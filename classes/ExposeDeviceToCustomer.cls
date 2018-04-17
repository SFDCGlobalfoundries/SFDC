/*
    Author: Ariz Solito
    Description: Apex class called by DeviceTrigger to send email notifications to customer when a device is exposed to customer portal
    History: 
        Asolito     06172013    - Code creation.
        Asolito     09262013    - Added sharing rule for newly created portal users
        Asolito     10023013    - Added logic to only allow beta users to receive email
        ARoy        10302013    - Added the account population when an Export Control Form is created for a Device (Task - 463).
        Asolito     11132013    - Case 00002918: Removed is_portal_user_active__c and s_portal_user_created__c filter check on user when 
                                  creating sharing rule
        Asolito     11132013    - move hasExposedRun before inserting of IP dec and export control junction to fix duplicate issue
        ARoy        11192013    - Added the updation of the Device with Export Control Status.
        Asolito     11212013    - Fixed issue where exposed device emails are sent to non portal customer users     
        Nbustillos  12302013    - Updated logic for exposeCustomer() wherein query for contacts is coming from User 
                                  to avoid hitting the FOR LOOP Query limit when Account has a lot of contacts. 
        ZAmbat      03112014    - Updated logic as per CASE 7219.  Expose device to portal users according to Account Hierarchy.
        Tlai        09052014    - Updated logic as per case 00016668.         
        ZAmbat      07292014    - Modified validate() method to conform with new 'Expose Device to Customer' page/setup (CASE 31330). 
        Poulami     01162018    - Added code for Skywork Qorvo Template automation
*/
public class ExposeDeviceToCustomer {
     
    private static final string OPPTY_PROG_TM_ROLE_AM = '%' + EnvironmentVariable.get('OPPTY_PROG_TM_ROLE_AM');
    private static final string OPPTY_PROG_TM_ROLE_TS = '%' + EnvironmentVariable.get('OPPTY_PROG_TM_ROLE_TS');  
    private static final string OPPTY_PROG_TM_ROLE_FAE =  EnvironmentVariable.get('OPPTY_PROG_TM_ROLE_FAE');  
    private static final string CONTACT_ROLE_DEVICE_ADMIN = EnvironmentVariable.get('CONTACT_ROLE_DEVICE_ADMIN'); 
    private static final string FV_BETA_ACCOUNT_TOOGLE = EnvironmentVariable.get('FV_BETA_ACCOUNT_TOOGLE');
    private static final string EXPOSE_DEVICE_BCC_ID = EnvironmentVariable.get('EXPOSE_DEVICE_BCC_ID');
    
    public static Boolean hasExposeRun = false;        
    
    //Method will Device and Export control form to newly created portal users
    @future
    public static void createSharingRule(List<String> newUsers) {
        /*Map<String,List<String>> toShareUserIDs = new Map<String,List<String>>();
        List<String> accountIDs = new List<String>();
        
        for(User u: [SELECT id,contact.accountId 
                       FROM User
                       WHERE isPortalEnabled = true
                        
                       //Case 00002918 -commented out portal filter
                       /*
                       AND contact.is_portal_user_active__c = true
                       AND contact.is_portal_user_created__c = true
                       
                       AND isActive = true
                       AND id IN :newUsers]){
            if(toShareUserIDs.containsKey(u.contact.accountId)){                        
                toShareUserIDs.get(u.contact.accountId).add(u.id);
            } else {
                toShareUserIDs.put(u.contact.accountId,new List<String>{u.id});
            }                                                           
        }*/
        
        //create the sharing list               
        /*List<Device__Share> shareDevices = new List<Device__Share>(); 
        List<Export_Control_Form__Share> shareExps = new List<Export_Control_Form__Share>();
        
        for(Device__c d: [SELECT id,account__c,
                            (SELECT export_control_form__c 
                               FROM Device_Export_Control_Junctions__r) 
                            FROM Device__c
                            WHERE account__c IN :toShareUserIDs.keySet()]){
                                
            //loop thru the users for each account and add sharing rule to Device and Export Control
            if(toShareUserIDs.containsKey(d.account__c)){
                for(String u :toShareUserIDs.get(d.account__c)){
                    Device__Share rec = new Device__Share();
                    rec.AccessLevel = 'Edit';
                    rec.ParentId = d.id;
                    rec.RowCause = Schema.Device__Share.RowCause.FoundryView_User__c;
                    rec.UserOrGroupId = u;
                    shareDevices.add(rec);
                      
                    for(Device_Export_Control_Junction__c j: d.Device_Export_Control_Junctions__r){                 
                        Export_Control_Form__Share rec2 = new Export_Control_Form__Share();
                        rec2.AccessLevel = 'Edit';
                        rec2.ParentId = j.export_control_form__c;
                        rec2.RowCause = Schema.Export_Control_Form__Share.RowCause.FoundryView_User__c;
                        rec2.UserOrGroupId = u;
                        shareExps.add(rec2);
                    }
                }                                                                   
            }   
        }*/
        
        // ZAmbat 03112014
        // START
        // Create map of Devices per Account
        Map<id, Account> mapDevicesPerAccount = new Map<id, Account>([
            SELECT      Id
                        , (SELECT Id FROM Devices__r WHERE Expose_Device_to_Customer__c = true)
            FROM        Account
        ]);
        
        // Create map of Export Control Forms per Device
        Map<id, Device__c> mapExportControlFormPerDevice = new Map<id, Device__c>([
            SELECT      Id
                        , (SELECT Export_Control_Form__c FROM Device_Export_Control_Junctions__r)
            FROM        Device__c
            WHERE       Expose_Device_to_Customer__c = true
        ]);
        
        // Store Account Hierarchy in map
        Map<id, id> mapAccountsAboveHierarchy = new Map<id, id>();
        Map<id, id> mapAccountsBelowHierarchy = new Map<id, id>();
        for (Account a : [SELECT    Id
                                    , ParentId
                          FROM      Account
                          WHERE     ParentId != null]) {
            mapAccountsAboveHierarchy.put(a.Id, a.ParentId);
            mapAccountsBelowHierarchy.put(a.ParentId, a.Id);
        }
        
        // Loop thru the users for each account and add sharing rule to Device and Export Control
        List<Device__Share> shareDevices = new List<Device__Share>(); 
        List<Export_Control_Form__Share> shareExps = new List<Export_Control_Form__Share>();
        for (User u : [SELECT       Id
                                    , Contact.AccountId
                       FROM         User
                       WHERE        isPortalEnabled = true
                                    AND isActive = true
                                    AND Id IN :newUsers]) {
            // Give access to exposed Devices and Export Control Forms under the user's Account
            if (mapDevicesPerAccount.containsKey(u.Contact.AccountId)) {    
                if (mapDevicesPerAccount.get(u.Contact.AccountId).Devices__r.size() > 0) {
                    for (Device__c d : mapDevicesPerAccount.get(u.Contact.AccountId).Devices__r) {
                        // Add Device share
                        Device__Share rec = new Device__Share();
                        rec.AccessLevel = 'Edit';
                        rec.ParentId = d.Id;
                        rec.RowCause = Schema.Device__Share.RowCause.FoundryView_User__c;
                        rec.UserOrGroupId = u.Id;
                        shareDevices.add(rec);
                        
                        // Add Export Control share
                        if (mapExportControlFormPerDevice.containsKey(d.Id)) {
                            if (mapExportControlFormPerDevice.get(d.Id).Device_Export_Control_Junctions__r.size() > 0) {
                                for (Device_Export_Control_Junction__c j : mapExportControlFormPerDevice.get(d.Id).Device_Export_Control_Junctions__r) {
                                    Export_Control_Form__Share rec2 = new Export_Control_Form__Share();
                                    rec2.AccessLevel = 'Edit';
                                    rec2.ParentId = j.Export_Control_Form__c;
                                    rec2.RowCause = Schema.Export_Control_Form__Share.RowCause.FoundryView_User__c;
                                    rec2.UserOrGroupId = u.Id;
                                    shareExps.add(rec2);
                                }
                            }
                        }
                    }   
                }
            }
            
            // Give access to exposed Devices and Export Control Forms above the user's Account hierarchy
            string tempAccountId = u.Contact.AccountId;
            while(mapAccountsAboveHierarchy.containsKey(tempAccountId)) {
                tempAccountId = mapAccountsAboveHierarchy.get(tempAccountId);
                if (mapDevicesPerAccount.containsKey(tempAccountId)) {  
                    if (mapDevicesPerAccount.get(tempAccountId).Devices__r.size() > 0) {
                        for (Device__c d : mapDevicesPerAccount.get(tempAccountId).Devices__r) {
                            // Add Device share
                            Device__Share rec = new Device__Share();
                            rec.AccessLevel = 'Edit';
                            rec.ParentId = d.Id;
                            rec.RowCause = Schema.Device__Share.RowCause.FoundryView_User__c;
                            rec.UserOrGroupId = u.Id;
                            shareDevices.add(rec);
                            
                            // Add Export Control share
                            if (mapExportControlFormPerDevice.containsKey(d.Id)) {
                                if (mapExportControlFormPerDevice.get(d.Id).Device_Export_Control_Junctions__r.size() > 0) {
                                    for (Device_Export_Control_Junction__c j : mapExportControlFormPerDevice.get(d.Id).Device_Export_Control_Junctions__r) {
                                        Export_Control_Form__Share rec2 = new Export_Control_Form__Share();
                                        rec2.AccessLevel = 'Edit';
                                        rec2.ParentId = j.Export_Control_Form__c;
                                        rec2.RowCause = Schema.Export_Control_Form__Share.RowCause.FoundryView_User__c;
                                        rec2.UserOrGroupId = u.Id;
                                        shareExps.add(rec2);
                                    }
                                }
                            }
                        }   
                    }
                }
            }
            
            // Give access to exposed Devices and Export Control Forms below the user's Account hierarchy
            tempAccountId = u.Contact.AccountId;
            while(mapAccountsBelowHierarchy.containsKey(tempAccountId)) {
                tempAccountId = mapAccountsBelowHierarchy.get(tempAccountId);
                if (mapDevicesPerAccount.containsKey(tempAccountId)) {  
                    if (mapDevicesPerAccount.get(tempAccountId).Devices__r.size() > 0) {
                        for (Device__c d : mapDevicesPerAccount.get(tempAccountId).Devices__r) {
                            // Add Device share
                            Device__Share rec = new Device__Share();
                            rec.AccessLevel = 'Edit';
                            rec.ParentId = d.Id;
                            rec.RowCause = Schema.Device__Share.RowCause.FoundryView_User__c;
                            rec.UserOrGroupId = u.Id;
                            shareDevices.add(rec);
                            
                            // Add Export Control share
                            if (mapExportControlFormPerDevice.containsKey(d.Id)) {
                                if (mapExportControlFormPerDevice.get(d.Id).Device_Export_Control_Junctions__r.size() > 0) {
                                    for (Device_Export_Control_Junction__c j : mapExportControlFormPerDevice.get(d.Id).Device_Export_Control_Junctions__r) {
                                        Export_Control_Form__Share rec2 = new Export_Control_Form__Share();
                                        rec2.AccessLevel = 'Edit';
                                        rec2.ParentId = j.Export_Control_Form__c;
                                        rec2.RowCause = Schema.Export_Control_Form__Share.RowCause.FoundryView_User__c;
                                        rec2.UserOrGroupId = u.Id;
                                        shareExps.add(rec2);
                                    }
                                }
                            }
                        }   
                    }
                }
            }
        }
        // END
        
        try {
            system.debug('shareDevices.size() ============================> ' + shareDevices.size());
            if (shareDevices.size() > 0) { 
                insert shareDevices;  
            }
            
            system.debug('shareExps.size() ============================> ' + shareExps.size());
            if (shareExps.size() > 0) {
                insert shareExps;
            }   
        } catch(Exception e) {
            System.debug(e);
        }       
    }          
    
    //Method will validate devices to be exposed to customer portal 
    //Tlai 09052014 -- changed logic
    //public static void validate(List<Device__c> devices, set<id> accountIds){
    // ZAmbat 07292014
    public static ReturnMessage validate(List<Device__c> devices, set<id> accountIds) {
        /*
            Step #1: Get Master Account set and mappings between Device Account and Master Account
        */
        ReturnMessage rm = new ReturnMessage(); // ZAmbat 07292014
        map<id, id> mDevAcct2MasterAcct = new map<id, id>();// Dev Acct Id 2 Master Acct Id
        set<id> sMasterAcctId = new set<id>();
        for(Account_Hierarchy__c ah :[select Parent_Id__c, Master_Account_Id__c from Account_Hierarchy__c where Parent_Id__c != null and Parent_Id__c in :accountIds]){
           if(!mDevAcct2MasterAcct.containskey(ah.Parent_Id__c)){
                mDevAcct2MasterAcct.put(ah.Parent_Id__c, ah.Master_Account_Id__c);
           }
           if(!sMasterAcctId.contains(ah.Master_Account_Id__c)){
                sMasterAcctId.add(ah.Master_Account_Id__c);
           }
        
        }    
        system.debug('____MAPAccountValues___'+mDevAcct2MasterAcct);
        /*
            Step #2: Get mappings between master account and devices
        
        Map<String,Map<Id,Device__c>> mMasterAcct2Dev = new Map<String,Map<Id,Device__c>>();
        for(Device__c d: devices){          
            //get the exposed devices 
            Id masterAcctId =  mDevAcct2MasterAcct.get(d.account__c);
            if(masterAcctId != null){
                if(mMasterAcct2Dev.containsKey(masterAcctId)){
                    mMasterAcct2Dev.get(masterAcctId).put(d.id,d);
                } else {                
                    mMasterAcct2Dev.put(masterAcctId,new Map<Id,Device__c>{d.id=>d});
                }
            }                     
            
        }*/
        /*
            Step #3: Get account hierarchy with the same master account
        */
        map<id,list<string>> mChild2MasterAcct = new map<id, list<string>>(); // map from every child account to master account 
        if(sMasterAcctId.size() > 0){
            
            for(Account_Hierarchy__c ah :[select Parent_Id__c, Master_Account_Id__c,Parent_Account_Short_Name__c from Account_Hierarchy__c where Master_Account_Id__c != null and Master_Account_Id__c in :sMasterAcctId]){
                if(!mChild2MasterAcct.containsKey(ah.Parent_Id__c)){
                    mChild2MasterAcct.put(ah.Parent_Id__c, new list<String>{ah.Master_Account_Id__c, ah.Parent_Account_Short_Name__c});
                }
            }
        }
        system.debug('mChild2MasterAcct:' + mChild2MasterAcct);
        /*
            Step #4 Get validated contacts:
            in Access Setup, My Device is checked and either IP Declaration or Export Control is checked.
        */
        map<id, set<Contact>> mMasterAcct2Contact = new map<id, set<Contact>>();
        if(mChild2MasterAcct.size() > 0){
            for(Contact cont: [select id, accountId, email, 
                                    (select My_Devices__c, IP_Declaration__c, Export_Control__c from Access_Setup__r)
                                from contact 
                                where Is_Portal_User_Active__c = true and Is_Portal_User_Created__c = true and accountId in :mChild2MasterAcct.keyset()]){                             
                if(cont.Access_Setup__r.size() > 0){     
                    Portal_Tab_Access__c pta = cont.Access_Setup__r[0];
                    if(pta.My_Devices__c && (pta.IP_Declaration__c || pta.Export_Control__c))   {
                        String masterAcctId = mChild2MasterAcct.get(cont.accountId)[0];
                        if(masterAcctId != null){
                            if(mMasterAcct2Contact.containskey(masterAcctId)){
                                mMasterAcct2Contact.get(masterAcctId).add(new Contact(id=cont.id,Email= cont.email,accountId = cont.accountId));
                            } else{
                                mMasterAcct2Contact.put(masterAcctId, new set<Contact>{new Contact(id=cont.id,Email= cont.email,accountId = cont.accountId)});
                            }
                        }
                            
                    }    
                }                                                   
            }
        }
        
        /*
            Step #5 Get Validated Device to expose to customer
        */
        map<String,List<RecordDetail>> mAcct2RecDetail = new map<String,List<RecordDetail>>();
        system.debug('mMasterAcct2Contact:' + mMasterAcct2Contact);
        for(Device__c dev: devices){ 
            boolean isValidated2Expose = false;
            id masterAcctId  = mDevAcct2MasterAcct.get(dev.account__c);
            if(masterAcctId != null){
                set<Contact> sContId = mMasterAcct2Contact.get(masterAcctId);               
                if(sContId != null && sContId.size() > 0){   
                    isValidated2Expose = true;             
                }       
            }
            
            if(isValidated2Expose){
                string acctShortName = mChild2MasterAcct.get(dev.account__c)[1];
                RecordDetail rd = new RecordDetail(dev, acctShortName);// manufacture recordDetail
                rd.addContacts(new list<Contact>(mMasterAcct2Contact.get(masterAcctId)));
                if(mAcct2RecDetail.containskey(dev.account__c)){
                    mAcct2RecDetail.get(dev.account__c).add(rd);
                }else {
                    mAcct2RecDetail.put(dev.account__c,new list<RecordDetail>{rd} );
                }
                
            } else {
                //dev.expose_device_to_customer__c.addError(Error_Codes__c.getInstance('DEVICE_EXPOSED_NO_DEVICE_ADMIN').message__c);
                // ZAmbat 07292014
                rm.errorMessage = Error_Codes__c.getInstance('DEVICE_EXPOSED_NO_DEVICE_ADMIN').Message__c;
            }
        }
        
        /*
            Step #6 Expose Device to Customer
        */
        // ZAmbat 07292014
        /*if(mAcct2RecDetail.size() > 0 ){
            ExposeDeviceToCustomer.exposeCustomer(mAcct2RecDetail);
        }*/
        
        rm.recordsMap = mAcct2RecDetail;
        
        return rm;
    }

    //Method will send email to the customer and create sharing rules for contacts under the device's Account
    //Tlai 09052014
    public static void exposeCustomer(Map<String,List<RecordDetail>> records, boolean hasRecords){
        /*
        // ZAmbat 03112014
        // START
        // Store Account Hierarchy in map
        Map<id, id> mapAccountsAboveHierarchy = new Map<id, id>();
        Map<id, id> mapAccountsBelowHierarchy = new Map<id, id>();
        for (Account a : [SELECT    Id
                                    , ParentId
                          FROM      Account
                          WHERE     ParentId != null]) {
            mapAccountsAboveHierarchy.put(a.Id, a.ParentId);
            mapAccountsBelowHierarchy.put(a.ParentId, a.Id);
        }
        
        // Create Map of Portal Users per Account
        Map<id, List<Contact>> mapContactsPerAccount = new Map<id, List<Contact>>();
        for (User u : [SELECT       Id
                                    , ContactId
                                    , Contact.AccountId
                                    , Contact.Email
                                    , Contact.Role__c
                       FROM         User
                       WHERE        Contact.AccountId != null
                                    AND IsActive = true 
                       ORDER BY     Contact.AccountId DESC]) {
            
            Contact c = new Contact();
            c.Id = u.ContactId;
            c.Email = u.Contact.Email;
            c.Role__c = u.Contact.Role__c;
            
            if (mapContactsPerAccount.containsKey(u.Contact.AccountId)) {
                mapContactsPerAccount.get(u.Contact.AccountId).add(c);
            } else {
                mapContactsPerAccount.put(u.Contact.AccountId, new List<Contact>{c});
            }
        }
        // END*/
        /* tlai 09052014
        Map<String,List<RecordDetail>> records = new Map<String,List<RecordDetail>>();
        
        //Create the wrapper class for the device 
        for(Device__c d: [SELECT id,account__c,ownerId,opportunity_program__c,account__r.short_name__c
                            FROM Device__c
                            WHERE id IN :deviceIDs]){
            if(records.containsKey(d.account__c)){
                records.get(d.account__c).add(new RecordDetail(d));
            } else {                            
                records.put(d.account__c,new List<RecordDetail>{new RecordDetail(d)});
            }
        }
        */
        //Add the portal contacts related to the device
        /*for(Account a: [SELECT id,(SELECT email,role__c 
                                     FROM Contacts
                                     //Case 00002918 - commented out portal filter
                                     //WHERE is_portal_user_active__c = true
                                     //AND is_portal_user_created__c = true)
                          FROM Account
                          WHERE id IN :records.keySet()]){
            if(records.containsKey(a.id)){
                for(RecordDetail r: records.get(a.id)){
                    r.addContacts(a.contacts);
                }
            }                   
        }*/
        
        // Logic updated by Nbustilos 12302013.
        // START - Add the portal contacts related to the device.
        /*Map<Id,List<Contact>> mapAccountActivePortalUsers = new Map<Id,List<Contact>>(); 
        for(User u : [SELECT Id, ContactId, Contact.AccountId, Contact.Email, Contact.Role__c FROM User 
                            WHERE Contact.AccountId IN :records.keySet() 
                            AND IsActive = true order by Contact.AccountId DESC]){
            if(mapAccountActivePortalUsers.containsKey(u.Contact.AccountId)){
                List<Contact> lstAcctContacts = mapAccountActivePortalUsers.get(u.Contact.AccountId);
                lstAcctContacts.add(new Contact(Id=u.ContactId, Email=u.Contact.Email, Role__c=u.Contact.Role__c));
                mapAccountActivePortalUsers.put(u.Contact.AccountId,lstAcctContacts);
            }else{
                List<Contact> lstAcctContacts = new List<Contact>();
                lstAcctContacts.add(new Contact(Id=u.ContactId, Email=u.Contact.Email, Role__c=u.Contact.Role__c));
                mapAccountActivePortalUsers.put(u.Contact.AccountId,lstAcctContacts);
            }
        }
        for(Id acctId : mapAccountActivePortalUsers.keySet()){
            for(RecordDetail r : records.get(acctId)){
                r.addContacts(mapAccountActivePortalUsers.get(acctId));
            }
        }*/
        // END
        /*
        // ZAmbat 03112014
        // START
        // Assign Portal Users per Device
        for (string key : records.keySet()) {
            for (RecordDetail r: records.get(key)) {
                // Assign Portal Users
                List<Contact> listContacts = new List<Contact>();
                
                // Get Contacts for Device's Account
                if (mapContactsPerAccount.containsKey(r.device.Account__c)) {
                    listContacts.addAll(mapContactsPerAccount.get(r.device.Account__c));
                }
                
                // Get Contacts Above Device's Account Hierarchy
                string tempAccountId = r.device.Account__c;
                while(mapAccountsAboveHierarchy.containsKey(tempAccountId)) {
                    tempAccountId = mapAccountsAboveHierarchy.get(tempAccountId);
                    if (mapContactsPerAccount.containsKey(tempAccountId)) {
                        listContacts.addAll(mapContactsPerAccount.get(tempAccountId));
                    }
                }
                
                // Get Contacts Below Device's Account Hierarchy
                tempAccountId = r.device.Account__c;
                while(mapAccountsBelowHierarchy.containsKey(tempAccountId)) {
                    tempAccountId = mapAccountsBelowHierarchy.get(tempAccountId);
                    if (mapContactsPerAccount.containsKey(tempAccountId)) {
                        listContacts.addAll(mapContactsPerAccount.get(tempAccountId));
                    }
                }
                
                // Add contacts
                if (listContacts.size() > 0) {
                    // Remove possible duplicate values
                    Set<Contact> setContacts = new Set<Contact>();
                    setContacts.addAll(listContacts);
                    
                    listContacts = new List<Contact>();
                    listContacts.addAll(setContacts);
                    
                    r.addContacts(listContacts); // set contacts
                }
            }
        }
        // END*/
        
        //Add the team members related to the device
        for(Opportunity_Program__c o: [SELECT id,account__c,(SELECT id,user__c,user__r.email,team_role__c,
                                                                    user__r.profile.name 
                                                               FROM Opportunity_Program_Team_Members__r 
                                                               WHERE team_role__c = :OPPTY_PROG_TM_ROLE_FAE or team_role__c like : OPPTY_PROG_TM_ROLE_AM or team_role__c like : OPPTY_PROG_TM_ROLE_TS)
                                         FROM Opportunity_Program__c
                                         WHERE account__c IN :records.keySet() ]){
            if(records.containsKey(o.account__c)){
                for(RecordDetail r: records.get(o.account__c)){
                    if(r.device.opportunity_program__c == o.id){
                        r.addTeamMembers(o.opportunity_program_team_members__r); // set OpportunityProgram TeamMember
                    }
                }               
            }                                                                   
        }
        try {
            //set the flag to true before insertion of IP dec and export control junction to fix duplicate issue
            hasExposeRun = true;
            if (!hasRecords) {
                generateIPAndExportRec(records);
            }
            createSharingRule(records, hasRecords);                                                                                                         
            // ZAmbat 07292014
            //sendEmail(records);            
        } catch(Exception e){
            System.debug(e);
        }                                   
    }
    
    //Method will auto generate IP declaration form and export control form after device has been exposed
    private static void generateIPAndExportRec(Map<String,List<RecordDetail>> records){
        List<IP_Declaration_Form__c> IPDecs = new List<IP_Declaration_Form__c>();
        List<Export_Control_Form__c> exports = new List<Export_Control_Form__c>();
        List<psa_psc_eccn_default__c> eccnDefaultList = new List<psa_psc_eccn_default__c>();
        Boolean newRecInsert = false;
        RecordDetail recDet;
         
        for(String k: records.keySet()){
            for(RecordDetail r: records.get(k)){
                IP_Declaration_Form__c IP = new IP_Declaration_Form__c();
                IP.device__c = r.device.id;
                IP.status__c = 'Undeclared';
                IPDecs.add(IP);
                
                recDet = r;
            }   
        }
        List<Device_Export_Control_Junction__c> devExpJun = [select id, Export_Control_Form__c, Export_Control_Form__r.Status__c,Export_Control_Form__r.Product_Description__c,Export_Control_Form__r.Weapon_Product__c,Export_Control_Form__r.Military_App_Product__c,Export_Control_Form__r.ITAR_Product__c,Export_Control_Form__r.Encryption_Control_Product__c,Export_Control_Form__r.US_EAR_Product__c,Export_Control_Form__r.US_EAR_Product_Details__c,Export_Control_Form__r.Non_US_EAR_Product__c,Export_Control_Form__r.Non_US_EAR_Product_Details__c,Export_Control_Form__r.Other_Harmonized_System__c,Export_Control_Form__r.End_User_Customer_Name__c,Export_Control_Form__r.ECCN_Technology__c,Export_Control_Form__r.ECCN_Wafer__c,Export_Control_Form__r.account__c,Export_Control_Form__r.FAB__c, Device__c from Device_Export_Control_Junction__c where Device__c = :recDet.device.id];
        
        Export_Control_Form__c exp = new Export_Control_Form__c();
        
        if(!devExpJun.isEmpty() && devExpJun[0].Export_Control_Form__c != null){
            exp = [SELECT id, Product_Description__c, Weapon_Product__c, Military_App_Product__c, ITAR_Product__c, Encryption_Control_Product__c,  US_EAR_Product__c, US_EAR_Product_Details__c, Non_US_EAR_Product__c, Non_US_EAR_Product_Details__c, Other_Harmonized_System__c, End_User_Customer_Name__c, ECCN_Technology__c, ECCN_Wafer__c, status__c, account__c, Fab__c,Customer_Trade_Compliance_Contact_Person__c, Phone__c,Email_Address__c,OwnerId__c,Last_Assigned_Customer_User__c,Export_Control_Template__c,Harmonized_System__c from Export_Control_Form__c WHERE id =:devExpJun[0].Export_Control_Form__c];
            newRecInsert = false;
        }else if(devExpJun.isEmpty()){
             //exp = new Export_Control_Form__c();
             newRecInsert = true;
        }
        //exp.device__c = r.device.id;
        if(recDet.device.Export_Control_Template__c != null && recDet.device.Export_Control_Template__c != ''){
            List<EC_Template_for_Skyworks_Qorvo__c> skyquoECTemplateList = new List<EC_Template_for_Skyworks_Qorvo__c>();
            skyquoECTemplateList = [SELECT id, name,Q1__c,Q2__c,Q3__c,Q4__c,Q5__c,Q6__c,Q6_a__c,Q7__c,Q7_a__c,Q8__c,Q9__c,ECCN_Technology__c,ECCN_Wafer__c,Export_Control_Template__c from EC_Template_for_Skyworks_Qorvo__c WHERE Account__c = :recDet.device.account__c and Export_Control_Template__c = :recDet.device.Export_Control_Template__c and IsActive__c = 'Yes'];
            if(!skyquoECTemplateList.isEmpty()){
                    exp.Product_Description__c = skyquoECTemplateList[0].Q1__c;
                    exp.Weapon_Product__c = skyquoECTemplateList[0].Q2__c;
                    exp.Military_App_Product__c = skyquoECTemplateList[0].Q3__c;
                    exp.ITAR_Product__c = skyquoECTemplateList[0].Q4__c;
                    exp.Encryption_Control_Product__c = skyquoECTemplateList[0].Q5__c;
                    exp.US_EAR_Product__c = skyquoECTemplateList[0].Q6__c;
                    exp.US_EAR_Product_Details__c = skyquoECTemplateList[0].Q6_a__c;
                    exp.Non_US_EAR_Product__c = skyquoECTemplateList[0].Q7__c;
                    exp.Non_US_EAR_Product_Details__c = skyquoECTemplateList[0].Q7_a__c; 
                    //exp.Other_Harmonized_System__c = skyquoECTemplateList[0].Q8__c;
                    List<Export_Control_HS_Code__c> expConHSCodeList = [select ID, HS_Code__c, HS_Description__c from Export_Control_HS_Code__c WHERE HS_Code__c = :skyquoECTemplateList[0].Q8__c];
                    exp.Harmonized_System__c = expConHSCodeList[0].id;
                    exp.End_User_Customer_Name__c = skyquoECTemplateList[0].Q9__c;
                    exp.ECCN_Technology__c = skyquoECTemplateList[0].ECCN_Technology__c;
                    exp.ECCN_Wafer__c = skyquoECTemplateList[0].ECCN_Wafer__c;
                    //exp.status__c = 'Approved'; 
                    //exp.account__c = recDet.device.account__c;
                    //exp.FAB__c = recDet.device.fab__c;
                    //exp.D1_National_Access_is_Allowed__c = 'No';
                    exp.Customer_Trade_Compliance_Contact_Person__c = UserInfo.getLastName()+','+UserInfo.getFirstName();
                    User usr = [select phone, email from User where id = :UserInfo.getUserId()];
                    exp.Phone__c = usr.phone;
                    exp.Email_Address__c = usr.email;
                    exp.OwnerId__c = UserInfo.getUserId();
                    exp.Last_Assigned_Customer_User__c = UserInfo.getUserId();
                    exp.Export_Control_Template__c = recDet.device.Export_Control_Template__c;
                    
            }
        }

        exp.status__c = 'Undeclared';
        exp.account__c = recDet.device.account__c;
        exp.FAB__c = recDet.device.fab__c;   

        if(exp.ECCN_Technology__c != null && exp.ECCN_Technology__c != ''){
            eccnDefaultList = [SELECT name, D1_National_Access_Allowed__c, psa_eccn__c, psc_eccn__c, ECCN_Color__c from psa_psc_eccn_default__c where name = :exp.ECCN_Technology__c];
            if(!eccnDefaultList.isEmpty()){
                exp.D1_National_Access_is_Allowed__c = eccnDefaultList[0].D1_National_Access_Allowed__c;
                exp.ECCN_Color__c = eccnDefaultList[0].ECCN_Color__c;  
            }
        }
        exports.add(exp);            
        //store the export control for reference later when creating the junction object
        //r.exp = exp;
        recDet.exp = exp;
        if(newRecInsert){
            insert IPDecs ;
        }
        upsert exports Id;
        exports.clear();
        
        //generate the junction object
        List<Device_Export_Control_Junction__c> junctions = new List<Device_Export_Control_Junction__c>();
        List<Id> deviceIds = new List<Id>();
        List<Id> expIds = new List<Id>();
        for(String k: records.keySet()){
            for(RecordDetail r: records.get(k)){        
                Device_Export_Control_Junction__c j = new Device_Export_Control_Junction__c(
                    device__c = r.device.id,
                    export_control_form__c = r.exp.id
                );
                junctions.add(j);
                deviceIds.add(r.device.id);
                expIds.add(r.exp.id);
            }
        }   
        if(newRecInsert){
            insert junctions;
        }
        if(recDet.device.Export_Control_Template__c != null && recDet.device.Export_Control_Template__c != ''){
            exp.status__c = 'Approved';
            exports.add(exp);
            update exports;
        }
        
        //========Update the Device with Export Control Status====//
        if(recDet.device.Export_Control_Template__c == null || recDet.device.Export_Control_Template__c == ''){
            if(deviceIds.size()>0){
                List<Device__c> deviceList = [select Export_Control_Status__c from Device__c where id in :deviceIds];
                for(String k: records.keySet()){
                    for(RecordDetail r: records.get(k)){
                        for(Device__c dev1 : deviceList){
                            dev1.Export_Control_Status__c = r.exp.status__c;
                            dev1.Export_Control_Junction__c = '1';
                        }
                    }
                }
                if(deviceList!=null && deviceList.size()>0){
                    update deviceList;
                }
            }
        }
        //========================================================//
    }
        
    //Method will create sharing rule for contacts under the device
    private static void createSharingRule(Map<String,List<RecordDetail>> records, boolean hasRecords){                      
        //get the contact IDs
        List<String> contactIDs = new List<String>();
        for(String key: records.keyset()){
            for(RecordDetail r: records.get(key)){
                for(Contact c: r.contacts){
                    contactIDs.add(c.id);
                }
            }
        }
        
        //create contact=>user map
        Map<String,String> portalUserMap = new Map<String,String>();
        for(User u: [SELECT id,contactID 
                       FROM User 
                       WHERE contactID IN :contactIDs
                       AND isActive = true]){
            portalUserMap.put(u.contactID,u.id);
        }
        
        //create the sharing list               
        List<Device__Share> shareDevices = new List<Device__Share>(); 
        List<Export_Control_Form__Share> shareExps = new List<Export_Control_Form__Share>();
        for(String key: records.keyset()){
            for(RecordDetail r: records.get(key)){
                for(Contact c: r.contacts){                 
                    if(portalUserMap.containsKey(c.id)){
                        Device__Share rec = new Device__Share();
                        rec.AccessLevel = 'Edit';
                        rec.ParentId = r.device.id;
                        rec.RowCause = Schema.Device__Share.RowCause.FoundryView_User__c;
                        rec.UserOrGroupId = portalUserMap.get(c.id);
                        shareDevices.add(rec);
                        
                        if (!hasRecords) {
                            Export_Control_Form__Share rec2 = new Export_Control_Form__Share();
                            rec2.AccessLevel = 'Edit';
                            rec2.ParentId = r.exp.id;
                            rec2.RowCause = Schema.Device__Share.RowCause.FoundryView_User__c;
                            rec2.UserOrGroupId = portalUserMap.get(c.id);
                            shareExps.add(rec2);     
                        }                   
                    }
                }            
            }
        }
                        
        insert shareDevices;  
        if (shareExps.size() > 0) {
            insert shareExps;
        }  
    }        
    
    //Method will send email to customers, Account admin and FAE
    //private static void sendEmail(Map<String,List<RecordDetail>> records){
    // ZAmbat 07292014
    public static void sendEmail(Map<String,List<RecordDetail>> records, Set<Id> ecContactIds, Set<Id> ipContactIds) {
         System.debug(ecContactIds.size()+'________=Contacts==_____'+ecContactIds);
        //get the email templates
        EmailTemplate temp1 = [SELECT id from EmailTemplate where name = 'Device Expose device to customer VF'];//For IP declaration Form notification
        EmailTemplate temp2 = [SELECT id from EmailTemplate where name = 'Device Expose device to customer VF2'];//For Export Control notification
        
        list<String> bccRcptEmailAddrList = new list<String>();
        if(!String.isblank(EXPOSE_DEVICE_BCC_ID)){
            for(string emailAddr : EXPOSE_DEVICE_BCC_ID.split(';')){
                if(!String.isblank(emailAddr)){
                    bccRcptEmailAddrList.add(emailAddr);
                }
            }
        }
        
        //send the email notifications
        for(String key: records.keySet()){
            Integer recipientNum = 0;
            for(RecordDetail rec: records.get(key)){
                if((rec.isBetaUser && FV_BETA_ACCOUNT_TOOGLE == 'ON') || FV_BETA_ACCOUNT_TOOGLE == 'OFF' || Test.isRunningTest()){                
                    List<String> combineEmails = new List<String>();
                    set<string> ipdSet = new set<string>();
                    set<string> expcSet = new set<string>();
                    rec.getCustomerEmail(ipdSet, expcSet, ecContactIds, ipContactIds);
                    combineEmails.addAll(rec.getFAEEmail()); 
                    
                    if(combineEmails.size() > 25){
                    
                        List<String> tempCombineEmails = new List<String>();
                        
                        for(String tempEmail : combineEmails){
                            
                            if(tempCombineEmails.size() < 25){
                                
                                tempCombineEmails.add(tempEmail);
                            }
                            else if(bccRcptEmailAddrList.size() < 25){
                                
                                bccRcptEmailAddrList.add(tempEmail);
                            }
                        }
                        
                        combineEmails = tempCombineEmails;
                    }
                    
                    list<Messaging.SingleEmailMessage> msgList = new list<Messaging.SingleEmailMessage>();
                    
                    if(ipdSet.size() > 0){
                        
                        Integer counter = 0;
                        Set<String> tempIpdSet = new set<String>();
                        Messaging.SingleEmailMessage message1;
                        
                        for(String tempEmail : ipdSet){
                            
                            counter++;
                            tempIpdSet.add(tempEmail);
                            
                            if( Math.mod(counter, 100) == 0 ){
                                
                                message1 = EmailUtil.generateEmailTemplate(temp1.id,
                                                                            rec.device.id,
                                                                            null,
                                                                            new list<String>(tempIpdSet),
                                                                            combineEmails,
                                                                            new Map<String,String>());
                                message1.saveAsActivity = false;
                                
                                if(bccRcptEmailAddrList.size() > 0){
                                    message1.setBccAddresses(bccRcptEmailAddrList);
                                }
                                
                                msgList.add(message1);
                                
                                tempIpdSet = new set<String>();
                            }
                            else if(counter == ipdSet.size()){
                                
                                message1 = EmailUtil.generateEmailTemplate(temp1.id,
                                                                            rec.device.id,
                                                                            null,
                                                                            new list<String>(tempIpdSet),
                                                                            combineEmails,
                                                                            new Map<String,String>());
                                message1.saveAsActivity = false;
                                
                                if(bccRcptEmailAddrList.size() > 0){
                                    message1.setBccAddresses(bccRcptEmailAddrList);
                                }
                                
                                msgList.add(message1);
                            }
                        }
                        
                        recipientNum = recipientNum + ipdSet.size() + combineEmails.size() + bccRcptEmailAddrList.size();
                    }
                    system.debug(expcSet.size()+'____-EXP--____'+expcSet);
                    if(expcSet.size() > 0){  
                        
                        Integer counter = 0;
                        Set<String> tempExpcSet = new set<String>();
                        Messaging.SingleEmailMessage message2;
                        
                        for(String tempEmail : expcSet){
                            
                            counter++;
                            tempExpcSet.add(tempEmail);
                            
                            if( Math.mod(counter, 100) == 0 ){
                                
                                message2 = EmailUtil.generateEmailTemplate(temp2.id,
                                                                            rec.device.id,
                                                                            null,
                                                                            new list<String>(tempExpcSet),
                                                                            combineEmails,
                                                                            new Map<String,String>());                                                                                                           
                                message2.saveAsActivity = false;
                                if(bccRcptEmailAddrList.size() > 0){
                                    message2.setBccAddresses(bccRcptEmailAddrList);
                                }
                                
                                msgList.add(message2);
                                
                                tempExpcSet = new set<String>();
                            }
                            else if(counter == expcSet.size()){
                                
                                message2 = EmailUtil.generateEmailTemplate(temp2.id,
                                                                            rec.device.id,
                                                                            null,
                                                                            new list<String>(tempExpcSet),
                                                                            combineEmails,
                                                                            new Map<String,String>());                                                                                                           
                                message2.saveAsActivity = false;
                                if(bccRcptEmailAddrList.size() > 0){
                                    message2.setBccAddresses(bccRcptEmailAddrList);
                                }
                                
                                msgList.add(message2);
                            }
                        }
                        
                        recipientNum = recipientNum + expcSet.size() + combineEmails.size() + bccRcptEmailAddrList.size();
                    }
                                                                         
                    if(!Test.isRunningTest()){  
                        Messaging.reserveSingleEmailCapacity(recipientNum);    
                        system.debug(msgList);             
                        Messaging.sendEmail(msgList);
                    }
                }           
            }
        }   
    }   
    
    //Subclass to store device and contact details
    public class RecordDetail {
        public Device__c device;
        public String deviceID;
        public Export_Control_Form__c exp;
        public Boolean isBetaUser = false;
        public List<Opportunity_Program_Team_Member__c> teamMembers;
        private List<Contact> contacts;      
          
        
        //constructor
        public RecordDetail(Device__c d, String acctShortName){//Tlai 09052014 changed method signature
            this.contacts = new List<Contact>();
            this.teamMembers = new List<Opportunity_Program_Team_Member__c>();
            this.device = d;
            this.deviceID = d.id; 
            this.isBetaUser = isBetaUser(acctShortName); 
        } 

        //Method will check if the device's account is a beta user
        private Boolean isBetaUser(String accountShortName){
            FV_Beta_Account__c setting = FV_Beta_Account__c.getInstance(accountShortName);
            
            if(setting <> null){
                return true;
            }
            
            return false;
        }              
        
        //Method will add opportunity team members related to the device
        public void addTeamMembers(List<Opportunity_Program_Team_Member__c> teamMembers){
            this.teamMembers.addAll(teamMembers);
        }
        
        //Method will add contacts related to the device
        public void addContacts(List<Contact> contacts){
            this.contacts.addAll(contacts);
        }   
        
        //Method will get costumer record
        public Contact getCustomer(){
            for(Contact c: this.contacts){
                return c;
            }
            return null;
        }
        
        //Method will get the customer emails
        //public void getCustomerEmail(set<string> ipdSet, set<string> expcSet ){
        // ZAmbat 07292014
        public void getCustomerEmail(set<string> ipdSet, set<string> expcSet, Set<Id> ecContactIds, Set<Id> ipContactIds){
            System.debug(ecContactIds.size()+'____ENTER____'+ecContactIds);
            List<String> emails = new List<String>();
            List<String> contactIDs = new List<String>();
            
            for(contact cont: this.contacts){
                contactIDs.add(cont.id);
            }
            
            for(Contact cont: [select id, email, 
                                    (select My_Devices__c, IP_Declaration__c, Export_Control__c from Access_Setup__r)
                                from contact 
                                where Is_Portal_User_Active__c = true and Is_Portal_User_Created__c = true and (id in: contactIDs OR id in: ecContactIds) ]){
                 Portal_Tab_Access__c pta = cont.Access_Setup__r[0];
                 //if(pta.My_Devices__c && pta.IP_Declaration__c){
                 // ZAmbat 07292014
                 if(pta.My_Devices__c && pta.IP_Declaration__c && ipContactIds.contains(cont.Id)) {
                    ipdSet.add(cont.email);
                 }
                 //if (pta.My_Devices__c && pta.Export_Control__c){
                 // ZAmbat 07292014
                 if (pta.My_Devices__c && pta.Export_Control__c && ecContactIds.contains(cont.Id)) {
                 System.debug(cont.Id+'____ENTER-2____'+ecContactIds);
                    expcSet.add(cont.email);
                 }
            }
            System.debug(expcSet.size()+'____EXPORTDEVICE____'+expcSet);
             /*for(User u: [SELECT email,id,contactID 
                       FROM User 
                       WHERE contactID IN :contactIDs
                       AND isActive = true
                       AND isPortalEnabled = true]){
                       
                emails.add(u.email);
            }
            return emails;*/
        }              
        
        //Method will get the account admin emails
        public List<String> getAccountAdminEmail(){
            List<String> emails = new List<String>();
            for(Contact c: this.contacts){
                if(UtilsString.isNotBlank(c.role__c)){
                    if(c.role__c.contains (CONTACT_ROLE_DEVICE_ADMIN)){
                        emails.add(c.email);
                    }
                }
            }
            return emails;
        }   
        
        //Method will get the FE and Account Manager emails
        public List<String> getFAEEmail(){
            List<String> emails = new List<String>();
            for(Opportunity_Program_Team_Member__c t: this.teamMembers){
                //if(t.team_role__c.contains(OPPTY_PROG_TM_ROLE_AM) || t.team_role__c.contains(OPPTY_PROG_TM_ROLE_TS) || t.team_role__c == OPPTY_PROG_TM_ROLE_FAE){
                    emails.add(t.user__r.email);
                //}
            }
            return emails;
        }   
    }   
    
    // ZAmbat 07292014
    public class ReturnMessage {
        public string errorMessage {get;set;}
        public Map<String,List<RecordDetail>> recordsMap {get;set;}
        
        public ReturnMessage(){}
    }
}