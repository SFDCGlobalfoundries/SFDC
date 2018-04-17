/*
    Author:         Ankit Singhal
    Company:        Cognizant Technology Solution
    Description:        
    History:
    
    Ankit Singhal   26082013     Class Creation
    Sameer Matale   04032014     Sharing with FTA and FAS
    Vijay Mahajan   20052014     Now daily active reticle batch load will introduce some active reticles which are already present in Salesforce ROS system as 
                                 inactive reticles. 'New Inactive Days' field will be updated on inactive reticles and it will be processed
                                 under 'Pending for Verification' category by WWSM Team. 
    NJain           22-Sep-14    Populating Date_Inactive_to_Active_Insertion__c field when Active Reticle is loaded for the same Reticle which is 
                                 already Inactive in ROS System.
    Shuchi          16022015     added logic to update Customer name
*/

global class ROS_ReticleDatawareHouseBatchHelper {
    
    private static Map<String, List<Reticle_DataWareHouse__c>> mReticleConsolidated;
    private static Map<String, Account> mAccountId;
    private static Map<String, Set<String>> mFabReticle;
    private static Map<String, String> mReticleId;
    private static List<Reticle__c> lUpdateReticle;
    
    private static Set<String> sGfDevice;
    private static Set<String> sDupReticleDevice;
    private static Set<String> sDupReticleFab;
    private static Set<String> sContactId;
    private static Map<String, Reticle__c> existingReticleMap;
    /* Method to validate datawarehouse reticles to check following Validations:
        1. Customer Name/Customer Id is blank
        2. Reticle Name is blank
        3. Fab is Blank
        4. Device Id is Blank And then append appropriate message in the Invalid reason field */
    public static  void ValidateDatawareHouseReticles(List<Reticle_DataWareHouse__c> LRDataWarehouse,Id ReticleTypeId,String CycleId){
        //Prepare a map of DatawarehouseReticles with Unique Reticle Name to List of reticle records.
        Set<String> SUniqueCustomerDevices = new Set<String>();
        Map<String,List<Reticle_DataWareHouse__c>> MRetDWNametoRecordsList = new Map<String,List<Reticle_DataWareHouse__c>>();
        Set<String> SAccountNames = new Set<String>();
        Map<String,String> MRetDWHNameGFIdCRMId = new Map<String,String>();

        Set<String> SUniqueRTDWNames = new Set<String>();
          
        for(Reticle_DatawareHouse__c temp : LRDataWarehouse){
              SUniqueCustomerDevices.add(temp.GlobalFoundries_DeviceID__c);
              SUniqueRTDWNames.add(temp.name);
              if (temp.Customer_Id__c != null) {
                  SAccountNames.add(temp.Customer_Id__c.toLowercase());
              }
              MRetDWHNameGFIdCRMId.put(temp.GlobalFoundries_DeviceID__c,temp.CustomerDevice_ID__c);
        }
        
        //Retrieving already Existing reticles for current Reticle datawarehouse Batch            
        List<Reticle__c> lAlreadyExistingReticles=new List<Reticle__c>([Select Id,Name,Device_ID__c,Isactive__c,Reticle_Workflow_Status__c,ROS_Cycle__c from Reticle__c
                                                                                                       WHERE Name in :SUniqueRTDWNames
                                                                                                       AND Reticle_Workflow_Status__c != 'Closed']);
    
        Map<String,Reticle__c> mAlreadyExistingReticles=new Map<String,Reticle__c>();
        for(Reticle__c eachReticle : lAlreadyExistingReticles)
            mAlreadyExistingReticles.put(eachReticle.Name,eachReticle);

        for(String temp : SUniqueRTDWNames) {  
            List<Reticle_DataWareHouse__c> temp1 =  new List<Reticle_DataWareHouse__c>();
            
            for(Reticle_DataWareHouse__c obj : LRDataWarehouse){  
                if(obj.name==temp){
                    temp1.add(obj );
                }  
                MRetDWNametoRecordsList.put(temp,temp1);
            }
        }

        //Prepare a map to fetch device Id based on Device Name
        List<Device__c> LDevices=new List<Device__c>([Select Id,Name,Account__c,MES_Device_Id__c,PLM_Device_ID__c,CRMDID__c 
                                                      from Device__c 
                                                      where name in :(SUniqueCustomerDevices) 
                                                          or MES_Device_Id__c in :(SUniqueCustomerDevices) 
                                                          or PLM_Device_ID__c in :(SUniqueCustomerDevices) 
                                                          or CRMDID__c in :(SUniqueCustomerDevices)]);
        Map<String,Device__c> MDeviceNames = new Map<String,Device__c>();
        for(Device__c r:LDevices) {
            MDeviceNames.put(r.Name,r);
            MDeviceNames.put(r.MES_Device_Id__c,r);
            MDeviceNames.put(r.PLM_Device_ID__c,r);
            MDeviceNames.put(r.CRMDID__c,r);
        }

        //Fetch all Customer/Account Names in the system
        List<Account> LAccounts=new List<Account>([ Select Id
                                                         , Name,Short_Name__c 
                                                    from Account 
                                                    where Short_Name__c in :(SAccountNames)]);
        Map<String,Id> MAccountNames=new Map<String,Id> {};
        
        for(Account r:LAccounts){
            MAccountNames.put(r.Short_Name__c,r.id);
        }
        
        //Creating a Set containing all Account Names
        Set<String> SAllAccountNames=MAccountNames.keyset();
        
        //Create a list for insertion of new Reticles from Reticle Datawarehouse records
        List<Reticle__c> LNewInsertReticles=new List<Reticle__c>();
        List<Reticle__c> LNewUpdateReticles=new List<Reticle__c>();


        //Create a list for Updating already existing reticles in the system
        Map<Id,Set<String>> MInsertFabReticles=new Map<Id,Set<String>>();
        Map<Id,Set<String>> MInsertDeviceReticles=new Map<Id,Set<String>>();
        Map<String,Set<String>> MRetNametoRD=new Map<String,Set<String>>();
        Map<String,Set<String>> MRetNametoFAB=new Map<String,Set<String>>();
        
        //Retreive Queue Id for Assignment to WWSM Team Queue
        
        Group WWSMQueueId = [ select Id 
                              from Group 
                              where Name = 'WWMS ROS Team' 
                                  and Type = 'Queue' LIMIT 1];
        
        // Validate Each Reticle datawarehouse record before insertion into reticle Object
        /* ===================================================================================================
        Validation Starts
        =================================================================================================== */
        

        for(String tempRETDWName : MRetDWNametoRecordsList.keyset()) {
                
            Set<String> SnewFabs=new Set<String>();
            Set<String> SnewDevices=new Set<String>();
            
            if(!mAlreadyExistingReticles.keyset().contains(tempRETDWName)){ 
                Reticle__c r=new Reticle__c();
                
                for(Reticle_Datawarehouse__c TRetDW :MRetDWNametoRecordsList.get(tempRETDWName)) {
                    if(TRetDW.Customer_ID__c != null && SAllAccountNames.contains(TRetDW.Customer_ID__c.toLowercase())) {
                        r.Account__c=MAccountNames.get(TRetDW.Customer_ID__c.toLowercase());
                    } 
                
                    if(TRetDW.Fab__c!=null && TRetDW.Fab__c.length()>0)
                        SnewFabs.add(TRetDW.Fab__c);
                    
                    SnewDevices.add(TRetDW.GlobalFoundries_DeviceID__c+','+TRetDW.CustomerDevice_ID__c);    
                   
                    r.Name = TRetDW.Name;      
                    r.Reticle_workflow_Status__c = '';
                    r.ROS_Status__c = '';
                    r.Region__c = TRetDW.Region_Name__c;
                    r.Reticle_Type__c=TRetDW.Reticle_Type__c;
                    r.ROS_Cycle__c = CycleId;
                    r.Day_Inactive__c = TRetDW.InactiveDay__c;
                    r.OwnerId = WWSMQueueId.Id;
                    r.RecordTypeId = ReticleTypeId;
                    r.Device_Type__c=TRetDW.Device_Type__c;
                    r.Job_Id__c = TRetDW.Job_Id__c;
                    r.Solution_Team_Confirm__c = true;
                    r.Made_Valid_by_CSR_Team__c = true;
                }
    
                LNewInsertReticles.add(r);
                MRetNametoRD.put(r.name,SnewDevices);
                MRetNametoFAB.put(r.name,SNewFabs);
            }
            
            else if(mAlreadyExistingReticles.keyset().contains(tempRETDWName)){
                Reticle__c TempExistingReticle = mAlreadyExistingReticles.get(tempRETDWName);
            
                for(Reticle_Datawarehouse__c TRetDW:MRetDWNametoRecordsList.get(tempRETDWName)){
                    TempExistingReticle.ROS_Cycle__c = CycleId;
                    TempExistingReticle.Solution_Team_Confirm__c = true;
                    TempExistingReticle.Made_Valid_by_CSR_Team__c = true;
                    
                    if (TRetDW.InactiveDay__c != null) {
                        TempExistingReticle.Day_Inactive__c = TRetDW.InactiveDay__c;
                    }
                    if (TRetDW.Reticle_Type__c != null && TRetDW.Reticle_Type__c.length() > 0) {
                        TempExistingReticle.Reticle_Type__c = TRetDW.Reticle_Type__c;
                    }
                    if (TRetDW.Reticle_Status__c != null && TRetDW.Reticle_Status__c.length() > 0) {
                        TempExistingReticle.Reticle_Status__c = TRetDW.Reticle_Status__c;
                    }
                    if (TRetDW.Device_Type__c != null && TRetDW.Device_Type__c.length() > 0) {
                        TempExistingReticle.Device_Type__c = TRetDW.Device_Type__c;
                    }
                    if (TRetDW.Region_Name__c != null && TRetDW.Region_Name__c.length() > 0) {
                        TempExistingReticle.Region__c = TRetDW.Region_Name__c;
                    }
                    
                    if(TRetDW.Fab__c!=null && TRetDW.Fab__c.length()>0)
                        SnewFabs.add(TRetDW.Fab__c);
                    SnewDevices.add(TRetDW.GlobalFoundries_DeviceID__c+','+TRetDW.CustomerDevice_ID__c); 
                }
    
                LNewupdateReticles.add(TempExistingReticle);
                MRetNametoRD.put(TempExistingReticle.name,SnewDevices);
                MRetNametoFAB.put(TempExistingReticle.name,SNewFabs);
            }
    
        }   
        
        if (!(LNewInsertReticles.isempty())){
            System.debug('------>'+LNewInsertReticles.size());
            insert LNewInsertReticles;
            for(Reticle__c temp : LNewInsertReticles) {
                if(!MRetNametoFAB.get(temp.name).isEmpty())
                    MInsertFabReticles.put(temp.Id,MRetNametoFAB.get(temp.name));
                if(!MRetNametoRD.get(temp.name).isEmpty() )
                    MInsertDeviceReticles.put(temp.Id,MRetNametoRD.get(temp.name));
            }
              
            ROS_ReticleDatawarehousehelper.createfabreticles(MInsertFabReticles);
            ROS_ReticleDatawarehousehelper.createdevicereticles(MInsertDeviceReticles,MDeviceNames);
            
            //Sharing Inactive Reticle Records with Customer in case Customer wants to Dispose Reticles 
            Map<Id,Id> MValidRetAccounts= new Map<Id,Id>();
            List<Fab_Reticle__c> LFabreticles=new List<Fab_Reticle__c>([Select id,reticle__c from Fab_reticle__c where reticle__c in :(LNewInsertReticles)]);
            Map<Id,Id> MRetIdFR=new Map<Id,Id>();
            for(Fab_reticle__c eachFabret : LFabreticles)
                MRetIdFR.put(eachFabret.Reticle__c,eachFabret.Id);
            
            for(Reticle__c eachReticle : LNewInsertReticles){
                if(eachreticle.Account__c!=null && MRetIdFR.get(eachReticle.Id)!=null){
                    MValidRetAccounts.put(eachReticle.Id,eachReticle.Account__c);            
                } 
            }
              
            if(MValidRetAccounts!= null && MValidRetAccounts.size() > 0){
                Map<Id,Account> MIdAccount=new Map<Id,Account>([Select Id, Name,(SELECT Id, Team_Role__c, User__c 
                                                                                FROM Account_Team_Proxy__r 
                                                                                WHERE (   Team_Role__c = 'Primary Customer Service Rep'
                                                                                       OR Team_Role__c = 'Backup Customer Service Rep'
                                                                                       OR Team_Role__c = 'Customer Service Rep'
                                                                                       OR Team_Role__c = 'Primary Field Application Engineer'
                                                                                       OR Team_Role__c = 'Field Application Engineer'
                                                                                       OR (Team_Role__c = 'Account Manager' AND Is_FAE__c = TRUE)
                                                                                       OR (Team_Role__c = 'Primary Account Manager' AND Is_FAE__c = TRUE) )
                                                                                ), 
                                                                                (Select Id, name, AccountId 
                                                                                from Contacts ) 
                                                                  from Account 
                                                                  where Id in :MValidRetAccounts.values() ]);
                  
                //Map<Id,List<Contact>> MRetIdContacts=new Map<Id,List<Contact>>();
                List<Reticle__Share> lReticleShare = new List<Reticle__Share>();
                for(Id eachRetId : MValidRetAccounts.keyset()){
                    //MRetIdContacts.put(eachretId,MIdAccount.get(MValidRetAccounts.get(eachRetId)).Contacts);
                    lReticleShare.addAll(shareReticleAtp(eachRetId, MIdAccount.get(MValidRetAccounts.get(eachRetId)).Account_Team_Proxy__r));
                }
                
                //lReticleShare.addAll(ROS_ReticleDatawarehousehelper.SharingRecordswithContacts(ROS_ReticleDatawarehousehelper.createMapIdPortalUsers(MRetIdContacts)));
                Database.SaveResult[] lsr = Database.insert(lReticleShare, false);
            }
              
        }
        
        if(!(LNewUpdateReticles.isempty())){
            Database.SaveResult[] lsr = Database.update(LNewUpdateReticles, false);
            for(Reticle__c temp : LNewUpdateReticles) {
                if(!MRetNametoFAB.get(temp.name).isEmpty())
                    MInsertFabReticles.put(temp.Id,MRetNametoFAB.get(temp.name));
                if(!MRetNametoRD.get(temp.name).isEmpty() )
                    MInsertDeviceReticles.put(temp.Id,MRetNametoRD.get(temp.name));
            }
            
            ROS_ReticleDatawarehousehelper.createfabreticles(MInsertFabReticles);
            ROS_ReticleDatawarehousehelper.createdevicereticles(MInsertDeviceReticles,MDeviceNames);
        }
          
    }

    public static void createActiveReticles(List<Reticle_DataWareHouse__c> lReticleDwInputVal) {
        SYSTEM.DEBUG('ACTIVE RETICLE METHOD ENTRY');
        Set<String> sExistingReticle = new Set<String>();
        Set<String> sAccount = new Set<String>();
        sGfDevice = new Set<String>();
        sContactId = new Set<String>();
        
        List<Reticle__c> lReticle = new List<Reticle__c>();
        List<Reticle_DataWareHouse__c> lReticleDwFabReticle = new List<Reticle_DataWareHouse__c>();
        
        mAccountId = new Map<String, Account>();
        mReticleConsolidated = new Map<String, List<Reticle_DataWareHouse__c>>();
        mReticleId = new Map<String, String>();
        existingReticleMap = new Map<String, Reticle__c>();
        // GET QUEUE ID FOR THE WWSM QUEUE
        Group wWsmQueueId = [ SELECT Id 
                              FROM Group
                              WHERE DeveloperName = 'WWMS_ROS_Team' 
                                AND Type = 'Queue' LIMIT 1 ];

        if (!lReticleDwInputVal.isEmpty()) { 
            mReticleConsolidated = getConsolidatedReticleDw(lReticleDwInputVal, sAccount);
            SYSTEM.DEBUG('CONSOLIDATED RETICLES : ' + mReticleConsolidated.size());
            SYSTEM.DEBUG('CONSOLIDATED RETICLES : ' + mReticleConsolidated);
            System.debug('** ' + sAccount);
            mAccountId = getAccounts(sAccount);
            System.debug('** ' + sAccount);
            // GET EXISTING RETICLES
            sExistingReticle = getExistingReticle(mReticleConsolidated);
            // sReticleName.removeAll(sExistingReticle);

            SYSTEM.DEBUG('ACCOUNTS, EXISTING RETICLES, REMAINING RETICLES TO INSERT : ' 
                + mAccountId.size() + ', ' + sExistingReticle.size() + ', ');
            String recordTypeId = Schema.getGlobalDescribe().get('Reticle__c').getDescribe().getRecordTypeInfosByName().get('Default').getRecordTypeId();

            for (String eachReticle :mReticleConsolidated.keySet()) {
                if (!sExistingReticle.contains(eachReticle)) {
                    lReticle.add(createReticle(mReticleConsolidated.get(eachReticle), wWsmQueueId.Id, recordTypeId));
                }
                lReticleDwFabReticle.addAll(mReticleConsolidated.get(eachReticle));
            }
            SYSTEM.DEBUG('TOTAL RETICLES TO BE INSERTED : ' + lReticle.size());
            if (lReticle != null && !lReticle.isEmpty()) {
                insert lReticle;
                
                getNewlyInsertedReticleId(lReticle);
                shareActiveReticle(lReticle);
                createReticleFab(lReticle);
            }

            if (lReticleDwFabReticle != null && !lReticleDwFabReticle.isEmpty()) {
                SYSTEM.DEBUG('RETICLE DEVICE TO INSERT');
                createReticleDevice(lReticleDwFabReticle);
            }
            
            SYSTEM.DEBUG('UPDATE RETICLE : ' + lUpdateReticle.size());
            if (lUpdateReticle != null && !lUpdateReticle.isEmpty()) {
                update lUpdateReticle;
            }
        }
    }
    
    private static void getNewlyInsertedReticleId(List<Reticle__c> lReticle) {
        
        if (lReticle != null && !lReticle.isEmpty()) {
            for (Reticle__c eachReticle :lReticle) {
                mReticleId.put(eachReticle.Name, eachReticle.Id);
            }
        }
    }
    
    private static void createReticleDevice(List<Reticle_DataWareHouse__c> lReticleDw) {
        Set<String> sDuplicteDevice = new Set<String>();
        Map<String, String> mDeviceId = prepareDeviceData(sGfDevice);
        List<Reticle_Device__c> lReticleDevice = new List<Reticle_Device__c>();

        if (lReticleDw != null && !lReticleDw.isEmpty()) {
            for (Reticle_DatawareHouse__c eachReticleDw :lReticleDw) {
            
                if (!sDupReticleDevice.contains(eachReticleDw.GlobalFoundries_DeviceID__c 
                                            + eachReticleDw.CustomerDevice_ID__c 
                                            + eachReticleDw.Name)) {
                    Reticle_Device__c reticleDevice = new Reticle_Device__c();
                    reticleDevice.GF_Device_Id__c = eachReticleDw.GlobalFoundries_DeviceID__c;
                    reticleDevice.Global_foundries_device_Id__c = eachReticleDw.GlobalFoundries_DeviceID__c;
                    reticleDevice.CRM_Device_ID__c = eachReticleDw.CustomerDevice_ID__c;
                    
                    if (mDeviceId != null
                        && mDeviceId.size() > 0 
                        && mDeviceId.get(eachReticleDw.GlobalFoundries_DeviceID__c) != null) {
                        reticleDevice.Device__c = mDeviceId.get(eachReticleDw.GlobalFoundries_DeviceID__c);
                    }
                    
                    if (mReticleId != null && mReticleId.size() > 0 && mReticleId.get(eachReticleDw.Name) != null) {
                        reticleDevice.Reticle__c = mReticleId.get(eachReticleDw.Name);
                    }
                    if(existingReticleMap != null && existingReticleMap.containsKey(eachReticleDw.Name)){
                      System.debug('In createReticleDevice method in'+existingReticleMap.get(eachReticleDw.Name).IsActive__c );
                      if(!existingReticleMap.get(eachReticleDw.Name).IsActive__c && (eachReticleDw.InactiveDay__c != null && eachReticleDw.InactiveDay__c < 365)){
                        System.debug('In createReticleDevice method in'+eachReticleDw.InactiveDay__c);
                        reticleDevice.Is_Temporary__c = true;
                      }
                    }
                    lReticleDevice.add(reticleDevice);
                    sDupReticleDevice.add(
                        eachReticleDw.GlobalFoundries_DeviceID__c 
                      + eachReticleDw.CustomerDevice_ID__c 
                      + eachReticleDw.Name);
                }
            }
            SYSTEM.DEBUG('RETICLE DEVICE COUNT TO INSERT : ' + lReticleDevice.size());
            insert lReticleDevice;
        }
    }
    
    public static void shareActiveReticle(List<Reticle__c> lReticle) {
        List<Reticle__Share> lReticleShare = new List<Reticle__Share>();
        
        Map<String, String> mAccountSnId = new Map<String, String>();
        Map<String, String> mContactUser = getContactUser(sContactId);
        
        for (String accountId :mAccountId.keySet()) {
            mAccountSnId.put(mAccountId.get(accountId).Id, mAccountId.get(accountId).Short_Name__c);
        }

        for (Reticle__c eachReticle :lReticle) {
            if(eachReticle.Account__c != null && mAccountId != null && mAccountSnId != null
               && mAccountSnId.get(eachReticle.Account__c) != null
               && mAccountId.get(mAccountSnId.get(eachReticle.Account__c)) != null
               && mAccountId.get(mAccountSnId.get(eachReticle.Account__c)).Contacts != null){
                   List<Contact> lContact = mAccountId.get(mAccountSnId.get(eachReticle.Account__c)).Contacts;
            
            if (lContact != null && !lContact.isEmpty()) {
                for (Contact contact :lContact) {
                    if (mContactUser != null && mContactUser.size() >0 && mContactUser.get(contact.Id) != null) {
                        Reticle__share reticleShare = new Reticle__share();
                        reticleShare.parentId = eachReticle.Id;
                        reticleShare.UserOrGroupId = mContactUser.get(contact.Id);
                        reticleShare.AccessLevel = 'edit';
                        reticleShare.RowCause = Schema.Reticle__Share.RowCause.Sharing_Reticle_Contacts__c;
                        lReticleShare.add(reticleShare);
                    }
                }
            }
              List<Account_Team_Proxy__c> lAtp = mAccountId.get(mAccountSnId.get(eachReticle.Account__c)).Account_Team_Proxy__r;
            if (lAtp != null && !lAtp.isEmpty()) {
                lReticleShare.addAll(shareReticleAtp(eachReticle.Id, lAtp));
            }
            }
         
          
        }
        
        insert lReticleShare;
    }
    
    public static List<Reticle__Share> shareReticleAtp(String reticleId, List<Account_Team_Proxy__c> lAtp) {
        List<Reticle__Share> retVal = new List<Reticle__Share>();
        
        if (lAtp != null && !lAtp.isEmpty()) {
            for (Account_Team_Proxy__c eachAtp :lAtp) {
                Reticle__share reticleShare = new Reticle__share();
                reticleShare.parentId = reticleId;
                reticleShare.UserOrGroupId = eachAtp.User__c;
                reticleShare.AccessLevel = 'edit';
                reticleShare.RowCause = Schema.Reticle__Share.RowCause.Sharing_with_CSR__c;
                retVal.add(reticleShare);
            }
        }

        return retVal;
    }
    
    public static Map<String, String> prepareDeviceData(Set<String> sDeviceId) {
        Map<String, String> retVal = new Map<String, String>();
        
        List<Device__c> lDevice = [ SELECT Id
                                         , Name
                                         , Account__c
                                         , MES_Device_Id__c
                                         , PLM_Device_ID__c
                                         , CRMDID__c 
                                    FROM Device__c 
                                    WHERE Name IN :(sDeviceId)
                                        OR MES_Device_Id__c IN :(sDeviceId)
                                        OR PLM_Device_ID__c IN :(sDeviceId)
                                        OR CRMDID__c IN :(sDeviceId) ];

        if (lDevice != null && !lDevice.isEmpty()) {
            for (Device__c eachDevice :lDevice) {
                retVal.put(eachDevice.Name, eachDevice.Id);
                retVal.put(eachDevice.MES_Device_Id__c, eachDevice.Id);
                retVal.put(eachDevice.PLM_Device_ID__c, eachDevice.Id);
                retVal.put(eachDevice.CRMDID__c, eachDevice.Id);
            }
        }
        
        return retVal;
    }
    
    public static void createReticleFab(List<Reticle__c> lReticle) {
        Map<Id, Set<String>> mReticleFab = new Map<Id, Set<String>>();
    
        if (!lReticle.isEmpty()) {
            for (Reticle__c eachReticle :lReticle) {
                mReticleFab.put(eachReticle.Id, mFabReticle.get(eachReticle.Name));
            }
        }
        
        ROS_ReticleDatawarehousehelper.createfabreticles(mReticleFab);
    }
    
    // THIS METHOD RETRIVES EXISTING RETICLES IN SALESFORCE.
    public static Set<String> getExistingReticle(Map<String, List<Reticle_DataWareHouse__c>> mConRdw) {
        Set<String> retVal = new Set<String>();
        sDupReticleDevice = new Set<String>();
        sDupReticleFab = new Set<String>();
        SYSTEM.DEBUG('GET EXSTING METHOD ' + mConRdw.size());
        SYSTEM.DEBUG('GET CONSOL DW ' + mConRdw);
        //Shuchi -- 16022015
        Map<String, Id> AccountMap = new Map<String,Id>();         
        //Daily active reticle batch load will introduce some active reticles which are already present in Salesforce ROS system as inactive reticles
        //Now It will fetch both InActive and Active Reticles. So below Query filter criteria is updated( Removed the IsActive__c = true filter criteria)
        //Updated by Vijay <19-05-2014>
        Map<Id, Reticle__c> mExistingReticle = new Map<Id, Reticle__c>([ SELECT Id
                                                                              , Name
                                                                              , Job_Id__c
                                                                              , IsActive__c
                                                                              , (SELECT Reticle__r.Name
                                                                                      , Global_foundries_device_Id__c
                                                                                      , CRM_Device_ID__c
                                                                                 FROM Reticle_Device__r)
                                                                              , (SELECT Reticle__r.Name
                                                                                      , Fab__r.Name
                                                                                 FROM Fab_Reticle__r) 
                                                                          FROM Reticle__c 
                                                                          WHERE Name IN :mConRdw.keySet()]); 
                                                                              //AND ROS_Cycle__c = null
                                                                              //AND ROS_Status__c = null 
                                                                              //AND IsActive__c = true ]);
        SYSTEM.DEBUG('EXISTING RETICLES ' + mExistingReticle.size());
        lUpdateReticle = new List<Reticle__c>();
        //Shuchi
        set<String> AccName = new set<String>();
        for(Reticle_DataWareHouse__c retDataWareHouse: [select Customer_Name__c from Reticle_DataWareHouse__c where Name IN :mConRdw.keySet()]){
            AccName.add(retDataWareHouse.Customer_Name__c);
        }
        for (Account eachAcc: [select id,name from account where name IN: AccName]) {
            AccountMap.put(eachAcc.name,eachAcc.id);
        }         
        for (String eachReticle: mExistingReticle.keySet()) {
            retVal.add(mExistingReticle.get(eachReticle).Name);
            mReticleId.put(mExistingReticle.get(eachReticle).Name, mExistingReticle.get(eachReticle).Id);
            existingReticleMap.put(mExistingReticle.get(eachReticle).Name, mExistingReticle.get(eachReticle));
            
            for (Reticle_Device__c eachReticleDevice :mExistingReticle.get(eachReticle).Reticle_Device__r) {
                sDupReticleDevice.add(eachReticleDevice.Global_foundries_device_Id__c 
                                        + eachReticleDevice.CRM_Device_ID__c 
                                        + eachReticleDevice.Reticle__r.Name);
            }
            for (Fab_Reticle__c fabReticle :mExistingReticle.get(eachReticle).Fab_Reticle__r) {
                sDupReticleFab.add(fabReticle.Fab__r.Name + fabReticle.Reticle__r.Name);
            }
            
            // WORKING HERE
            SYSTEM.DEBUG(mExistingReticle.get(eachReticle));
            SYSTEM.DEBUG(mConRdw.get(eachReticle));
            SYSTEM.DEBUG('CON DW' + mConRdw);
            SYSTEM.DEBUG(eachReticle);
            Reticle__c reticle = mExistingReticle.get(eachReticle);
            if (mConRdw != null && mConRdw.get(mExistingReticle.get(eachReticle).Name) != null && !mConRdw.get(mExistingReticle.get(eachReticle).Name).isEmpty()) {
                SYSTEM.DEBUG('HERE WE GO : ');
                for(Reticle_Datawarehouse__c retDw :mConRdw.get(mExistingReticle.get(eachReticle).Name)) {
                    reticle.Job_Id__c = retDw.Job_Id__c;
                    
                  if(!reticle.IsActive__c && (retDw.InactiveDay__c != null && retDw.InactiveDay__c < 365)){
                    reticle.New_Inactive_Days__c = retDw.InactiveDay__c;
                    reticle.Date_Inactive_to_Active_Insertion__c= System.TODAY();
                  }else{
                      if (retDw.InactiveDay__c != null) {
                          SYSTEM.DEBUG('UPDATE INACTIVE DAYS : ' + retDw.InactiveDay__c);
                          reticle.Day_Inactive__c = retDw.InactiveDay__c;
                      }
                      if (retDw.Reticle_Type__c != null && retDw.Reticle_Type__c.length() > 0) {
                          reticle.Reticle_Type__c = retDw.Reticle_Type__c;
                      }
                      if (retDw.Reticle_Status__c != null && retDw.Reticle_Status__c.length() > 0) {
                          reticle.Reticle_Status__c = retDw.Reticle_Status__c;
                      }
                      if (retDw.Region_Name__c != null && retDw.Region_Name__c.length() > 0) {
                          reticle.Region__c = retDw.Region_Name__c;
                      }
                      //Shuchi -- 16022015
                      if(!AccountMap.isEmpty()){
                          if (retDw.Customer_Name__c != null && retDw.Customer_Name__c.length() > 0 ){
                          system.debug('AccountMap'+AccountMap);
                                reticle.Account__c = AccountMap.get(retDw.Customer_Name__c);                          
                          }
                     }                      
                   }
                }
                lUpdateReticle.add(reticle);
            }
        }
        return retVal;
    }
    
    public static Map<String, Account> getAccounts(Set<String> sAccountId) {
        Map<String, Account> retVal = new Map<String, Account>();
        
        List<Account> lAccount = [ SELECT Id, Short_Name__c ,
                                            (SELECT Id, Team_Role__c, User__c 
                                             FROM Account_Team_Proxy__r
                                             WHERE (Team_Role__c = 'Primary Customer Service Rep'
                                                    OR Team_Role__c = 'Backup Customer Service Rep'
                                                    OR Team_Role__c = 'Customer Service Rep'
                                                    OR Team_Role__c = 'Primary Field Application Engineer'
                                                    OR Team_Role__c = 'Field Application Engineer'
                                                    OR (Team_Role__c = 'Account Manager' AND Is_FAE__c = TRUE)
                                                    OR (Team_Role__c = 'Primary Account Manager' AND Is_FAE__c = TRUE))
                                                AND User__r.IsActive = true),
                                             (SELECT Id
                                              FROM Contacts 
                                              WHERE /*Is_Portal_User_Created__c = true 
                                                AND */Is_Portal_User_Active__c = true)
                                   FROM Account 
                                   WHERE Short_Name__c IN :sAccountId ];
        System.debug('** ' + lAccount);
        for (Account eachAccount :lAccount) {
            retVal.put(eachAccount.Short_Name__c.toLowerCase(), eachAccount);
            
            if (eachAccount.Contacts != null && !eachAccount.Contacts.isEmpty()) {
                for (Contact contact :eachAccount.Contacts) {
                    sContactId.add(contact.Id);
                }
            }
        }
        return retVal;
    }
    
    private static Map<String, String> getContactUser(Set<String> sContact) {
        Map<String, String> retVal = new Map<String, String>();
        
        List<User> lUser = [ SELECT Id
                                  , ContactId
                             FROM User 
                             WHERE ContactId IN : sContact
                                 AND IsActive = true ];
        
        for (User user :lUser) {
            retVal.put(user.ContactId, user.Id);
        }
        
        return retVal;
    }
    
    private static Reticle__c createReticle(List<Reticle_DataWareHouse__c> lReticleDw, String ownerId, String recordTypeId) {
        Reticle__c retVal = new Reticle__c();
        
        if (lReticleDw != null) {
            for (Reticle_DataWareHouse__c eachReticleDw :lReticleDw) {
                if (eachReticleDw != null) {
                    retVal.Job_Id__c = eachReticleDw.Job_Id__c;

                    if (retVal.Name == null && eachReticleDw.Name != null) {
                       retVal.Name = eachReticleDw.Name;
                    }
                    if (retVal.Reticle_Type__c == null && eachReticleDw.Reticle_Type__c != null) {
                        retVal.Reticle_Type__c = eachReticleDw.Reticle_Type__c;
                    }
                    if (retVal.Region__c == null && eachReticleDw.Region_Name__c != null) {
                        retVal.Region__c = eachReticleDw.Region_Name__c;
                    }
                    if (retVal.Day_Inactive__c == null && eachReticleDw.InactiveDay__c != null) {
                        retVal.Day_Inactive__c = eachReticleDw.InactiveDay__c;
                    }
                    System.debug('** ' + eachReticleDw.Customer_ID__c);
                    System.debug('** ' + mAccountId.get(eachReticleDw.Customer_ID__c));
                    if (retVal.Account__c == null && eachReticleDw.Customer_ID__c != null 
                        && mAccountId.get(eachReticleDw.Customer_ID__c.toLowerCase()) != null) {
                        retVal.Account__c = mAccountId.get(eachReticleDw.Customer_ID__c.toLowerCase()).Id;
                    }
                    if (retVal.OwnerId == null) {
                        retVal.OwnerId = ownerId;
                    }
                    if (recordTypeId != null) {
                        retVal.RecordTypeId = recordTypeId;
                    }
                    if (retVal.Reticle_Status__c == null && eachReticleDw.Reticle_Status__c != null) {
                        retVal.Reticle_Status__c = eachReticleDw.Reticle_Status__c;
                    }
                    if (retVal.Device_Type__c == null && eachReticleDw.Device_Type__c != null) {
                        retVal.Device_Type__c = eachReticleDw.Device_Type__c;
                    }

                    if (retVal.Name != null 
                        && retVal.Reticle_Type__c != null 
                        && retVal.Region__c != null 
                        && retVal.Day_Inactive__c != null
                        && retVal.Account__c != null
                        && retVal.OwnerId != null) {
                        break;
                    }
                }
            }
        }

        return retVal;
    }
    
    private static Map<String, List<Reticle_DataWareHouse__c>> getConsolidatedReticleDw(List<Reticle_DataWareHouse__c> lReticleDw, Set<String> sAccount) {
        Map<String, List<Reticle_DataWareHouse__c>> retVal = new Map<String, List<Reticle_DataWareHouse__c>>();
        mFabReticle = new Map<String, Set<String>>();

        if (!lReticleDw.isEmpty()) {
            for (Reticle_DataWareHouse__c eachRetDw :lReticleDw) {
                SYSTEM.DEBUG('CONSOLODATED DW SIZE : ' + lReticleDw.size());
                if (!retVal.containsKey(eachRetDw.Name)) {
                    retVal.put(eachRetDw.Name, new Reticle_DataWareHouse__c[]{eachRetDw});
                } else {
                    retVal.get(eachRetDw.Name).add(eachRetDw);
                }
                SYSTEM.DEBUG('CONSOLODATED RETVAL SIZE : ' + retVal.size());
                SYSTEM.DEBUG('CONSOLODATED RETVAL : ' + retVal);
                if (!mFabReticle.containsKey(eachRetDw.Name)) {
                    Set<String> sFab = new Set<String>();
                    sFab.add(eachRetDw.FAB__c);
                    mFabReticle.put(eachRetDw.Name, sFab);
                } else {
                    mFabReticle.get(eachRetDw.Name).add(eachRetDw.FAB__c);
                }
                if (eachRetDw.GlobalFoundries_DeviceID__c != null) {
                    sGfDevice.add(eachRetDw.GlobalFoundries_DeviceID__c);
                }
                sAccount.add(eachRetDw.Customer_ID__c.toLowerCase());
            }
        }
        
        return retVal;
    }
    
    public static void updateInvalidReason(List<Reticle__c> lReticle, List<Reticle_Datawarehouse__c> lReticleDw,String JobId) {
       
        Set<String> InValidRetNames=new Set<String>();
        Map<String,Reticle__c> MRetNameInvalidReason=new Map<String,Reticle__c>();
        
        for(Reticle__c ret: lReticle){
            InValidRetNames.add(ret.Name); 
            MRetNameInvalidReason.put(ret.Name,ret);
        }
          
        List<Reticle_Datawarehouse__c> LRDWH=new List<Reticle_Datawarehouse__c>([Select Id,Name,Invalid_Reason__c,Job_Id__c from Reticle_Datawarehouse__c where Name in :InValidRetNames and Job_Id__c=:JobId]);
        
        for(Reticle_Datawarehouse__c retdwh : LRDWH){        
            retDwH.Invalid_Reason__c=MRetNameInvalidReason.get(retdwh.Name).Invalid_Reason__c; 
        }
        update LRDWH;
       
       
    }
}