/*
* @ Author :- Navneet Rajput
* @ Company :- CTS
* @ Description :- Class help to provision PDK Bundle and specs
* @ Date :- 11/10/2014
* @ Change History :- 
* @ Modified Date: 5/26/2015
* @ Reason: Case 41455 - Check account sync before provisioning
* @ Author: Sunita
* @ Modified Date: 6/17/2015
* @ Reason: Case 42841 - sorting acc serach by shortname
* @ Author: Sunita
* @ Modified Date: 7/21/2015
* @ Reason: Case 38803 - account reprovisioning
* @ Author : Prajnith Karra
* @ Modified Date: 5/6/2017
* @ Reason: CHG0041538 PDK Blacklist validations
* @ line numbers modified - 300-304,319-324,

**/
public without sharing class FV_PDKProvisioningHandler {

    public Id objSubPDKId{get;set;}
    public Sub_PDK__c objSubPDK{get;set;}   
    //public List<AccountWapper> wrapSelectedAccounts {get; set;}
    public Boolean isValidProfile{get;set;}
     // Prajnith ASIC
    public Boolean ASICFlag{get;set;}
    public Boolean isValidReleaseStatusForProvisioning{get;set;}
    public boolean isNotObsoletePDK{get;set;}
    public Boolean showAddAccounts{get;set;}
    public Boolean isValidTechGeometry{get;set;}
    public Boolean renderSearchResults{get;set;}
    public List<AccountWapper> searchResult {get; set;}
    public string searchText{get;set;}
    public List<Account> lstOfSelectedAccounts;
    public Boolean isReadyForProvisioning{get;set;}
    public Map<String, Profiles_for_Provisioning__c> mapPFP = Profiles_for_Provisioning__c.getAll();
    public Map<String, Restricted_Tech_Geometry__c> mapRTG = Restricted_Tech_Geometry__c.getAll();
    
    
    public FV_PDKProvisioningHandler(ApexPages.StandardController controller){
        
        isValidProfile = false;
        isValidReleaseStatusForProvisioning= false;
        isNotObsoletePDK= false;
        showAddAccounts= false;
        isValidTechGeometry= false;
        renderSearchResults= false;
        lstOfSelectedAccounts = new List<Account>();
        objSubPDKId = controller.getId();
        list<AccountWapper> searchResultOld;
        searchResult= new list<AccountWapper>();
        isReadyForProvisioning = false;
        
        if(objSubPDKId!=null){
            objSubPDK = retrieveSubPDKInfo(objSubPDKId);
            pdkReadyForProvisioning();
            isValidProfileForProvisioning();
            if(objSubPDK<>Null){
                isValidTechGeometry = verifyValidTechGeometry(objSubPDK.Tech_Geometry__c);
                 /** Restrict from Provisioning Sub PDKs when PDK is Obsolete - Start **/
                isNotObsoletePDK = verifyNonObsoleteMasterPDK(objSubPDK.PDK__c);
                /** Restrict from Provisioning Sub PDKs when PDK is Obsolete - End **/
                showAddAccounts = showOrHideAddAccounts(objSubPDK.Release_Status__c);
                if (objSubPDK.Release_Status__c.toLowerCase().contains('white list')){
                    searchResultOld =new list<AccountWapper>();
                    list<White_List__c> wlList = new list<White_List__c>();
                    set<ID> accIds = new set<ID>();
                    map<ID,Account> accMap = new map<ID,Account>();    
                    wlList = [select account__c,account__r.Name,account__r.Site_Department__c,account__r.Stage__c,account__r.Parent_Account_Name__c,
                                                 account__r.Parent_Account_Short_Name__c,account__r.Short_Name__c,Sub_PDK__c,account__r.Account_Present_In_OT__c,account__r.ASIC_Business_Flag__c  
                                          from white_List__c 
                                          where Sub_PDK__c=:objSubPDKId];
                    for(White_List__c wl:wlList){
                        if(wl.account__c != null)
                            accIds.add(wl.account__c);
                    }
                     if(!accIds.isEmpty())
                    accMap = new map<ID,Account>([SELECT ASIC_Business_Flag__c,ID,Name,Site_Department__c,Stage__c,Short_Name__c,Parent_Account_Name__c ,Parent_Account_Short_Name__c,Account_Present_In_OT__c  FROM Account WHERE ID IN: accIds ]);
                                                                              
                    for(White_List__c wl:wlList){
                        if (wl<>Null && accMap != null && accMap.containsKey(wl.account__c)){
                           AccountWapper accWrapper = new AccountWapper();
                           accWrapper.acct = accMap.get(wl.account__c); 
                           /*accWrapper.acct = new Account(id=wl.account__c,name = wl.account__r.Name,
                                                         Site_Department__c = wl.account__r.Site_Department__c,
                                                         Stage__c = wl.account__r.Stage__c,
                                                         Short_Name__c = wl.account__r.Short_Name__c,Account_Present_In_OT__c=wl.account__r.Account_Present_In_OT__c); 
                            */                                                         
                           //accWrapper.selected = false;
                           //accWrapper.isAlreadyProvisioned=false;                              
                           searchResultOld.add(accWrapper);
                        }
                    }
                    
                    Map<Id,Id> acctMap = new Map<Id,Id>();
                    // ADDED to disabled checkbox
                    List<Document_Provisioning__c> listOfDpRecords = [SELECT Id,Name,AccountID__c,AccountID__r.Short_Name__c,sub_PDK__c,status__c,Sub_PDK__r.Time_Req_To_Create_Association_In_OT__c,Sub_PDK__r.Release_Status__c//changes
                                                                        FROM Document_Provisioning__c
                                                                        WHERE sub_PDK__c = : objSubPDKId
                                                                        AND status__c IN ('Provisioned','Provisioning In Progress','Sent For Approval','De-Provisioning In Progress')
                                                                     ];
                    
                    if(listOfDpRecords<>NULL && !listOfDpRecords.isEmpty()){                                                 
                        for(Document_Provisioning__c dp : listOfDpRecords){
                            if(!acctMap.containsKey(dp.AccountID__c)){
                                acctMap.put(dp.AccountID__c,dp.AccountID__c);
                            }
                        }
                    }
                    if(searchResultOld<>NULL && !searchResultOld.isEmpty()){
                        for(AccountWapper acc : searchResultOld){
                            if (acc<>Null){
                               AccountWapper w = new AccountWapper();
                               if(acctMap<>NULL && acctMap.containsKey(acc.acct.Id)){
                                    w.acct = acc.acct;
                                    w.selected = true;
                                    w.isAlreadyProvisioned=true;
                               } else {
                                    w.acct = acc.acct;   
                                    w.selected = false;
                                    w.isAlreadyProvisioned=false;
                               }
                               searchResult.add(w);
                            }
                        }
                    }    
                    system.debug('Search Result >>>>>>'+searchResult);
                    if(searchResult!=null && !searchResult.isEmpty()){
                        renderSearchResults = true; 
                    }
                }
            }
        } 
    }
    
    public pageReference pdkReadyForProvisioning(){
        if(objSubPDK.Time_Req_To_Create_Association_In_OT__c == null && objSubPDK.OpenText_Error_Message__c==null){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'PDK bundle creation is in progress. Please refer Time Req To Create Association In OT field.');
            ApexPages.addMessage(myMsg);
        }
        else if(objSubPDK.Time_Req_To_Create_Association_In_OT__c!=null && objSubPDK.Time_Req_To_Create_Association_In_OT__c!='0' && objSubPDK.OpenText_Error_Message__c == null){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'PDK bundle creation is in progress. Please try again after'+' '+objSubPDK.Time_Req_To_Create_Association_In_OT__c+'.');
            ApexPages.addMessage(myMsg);
        }
        else if(objSubPDK.OpenText_Error_Message__c!=null){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'PDK bundle creation is not done.'+' '+objSubPDK.OpenText_Error_Message__c);
            ApexPages.addMessage(myMsg);
        }
        else if(!objSubPDK.Ready_For_Provisioning__c && objSubPDK.PDK_Failure_Specs__c!=null){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'PDK Spec association error.'+' '+objSubPDK.PDK_Failure_Specs__c);
            ApexPages.addMessage(myMsg);
        }
        else if(objSubPDK.Ready_For_Provisioning__c && objSubPDK.PDK_Failure_Specs__c==null){
            isReadyForProvisioning = true;          
        }       
        return null;
    }
    // Page Action Method to verify valid profile for provisioning  
    public pageReference isValidProfileForProvisioning(){
        Set<Id> setProfileIds = new Set<Id>();
        setProfileIds.addAll(getValidProfiles());
        if(setProfileIds!=null && setProfileIds.contains(UserInfo.getProfileId())){
            isValidProfile = true;  
        }
        else{
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'You do not have proper permission for provisioning this sub pdk.');
            ApexPages.addMessage(myMsg);
        }
        return null;
    }
    
    // Check logged in user profile and check access to this perticular profile for provisioning
    public  Set<Id> getValidProfiles(){
        Set<Id> setProfileIds = new Set<Id>();
        if(mapPFP!=null && mapPFP.size()>0){
            for(Profile objProfile: [Select Id, Name from Profile where Name IN: mapPFP.KeySet()]){
                 setProfileIds.add(objProfile.Id);
             }
        }
        return setProfileIds;
    }

    // Method decide when to show/Hide Add Account button
    public  Boolean showOrHideAddAccounts(String releaseStatus){

        Boolean showAccounts;
        isValidReleaseStatusForProvisioning = false;    

        if(releaseStatus!=null){
            if(releaseStatus.contains('Specific Account Release')){ 
                showAccounts = true;    
            }
            else{
                showAccounts = false;
            }
            if(releaseStatus!='Internal Use Only' && releaseStatus!='General Release'){
                isValidReleaseStatusForProvisioning = true; 
            }
            else{
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'You cannot provision for Release Statuses of General Release or Internal Release');
                ApexPages.addMessage(myMsg);    
            }
        }
        else{
            showAccounts = false;   
        }
        return showAccounts;
    }
    
    
    // Retrive SubPDK Information for selected sub PDK
    public  Sub_PDK__c retrieveSubPDKInfo(Id subPDKId){
        
        Sub_PDK__c objSubPDK = new Sub_PDK__c();
        // Prajnith ASIC - added new custom field 
        objSubPDK = [Select Id, Name, Sub_PDK_Version__c, Sub_PDK_Location_Fab__c, Sub_PDK_Revision_Release_Date__c, Sub_PDK_Lifecycle_Phase__c, 
                            Sub_PDK_Sub_class__c, Technology__c,Tech_Geometry__c, Release_Status__c, PDK__c,Sync_With_OpenText__c,PDK_Bundle_ASIC__c,                             
                            OpenText_Error_Message__c,Ready_For_Provisioning__c,Time_Req_To_Create_Association_In_OT__c,PDK_Failure_Specs__c  
                     from   Sub_PDK__c
                     where  Id =: subPDKId];
        return objSubPDK;
            
    }
    
    /**
        This method decides whether the Tech Geometry of the Design Spec record is in Restricted Tech Geometries.

        @method name: verifyValidTechGeometry
        @parameter:   Tech Geometry of the corresponding Design Spec record.
        @return :     True or False depending on whether it's a valid Tech Geometry or not.
     **/
     
    public  Boolean verifyValidTechGeometry(String techGeometry){
        Boolean isValid;
        if(techGeometry!=null){
            if(mapRTG<>Null && mapRTG.keySet().contains(techGeometry)){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'You cannot provision for Restricted Tech Geometries');
                ApexPages.addMessage(myMsg);
                isValid=false;          
            }
            else{
                isValid=true;
            }
        }
        else{
            isValid=true;
        }
        return isValid;
    }
    
    /**
        This method decides whether the PDK is Obsolete or not and restricts Sub PDK Provisioning.

        @method name: verifyNonObsoleteMasterPDK
        @parameter:   Master PDK Id of Sub PDK Record.
        @return :     False or True depending on whether PDK is Obsolete or not.
     **/
     
    public  Boolean verifyNonObsoleteMasterPDK(Id pdkId){
        Boolean isValid;
        if(pdkId!=null){
            for(PDK__c obj:[Select Id, PDK_Lifecycle_Phase__c from PDK__c where Id=:pdkId]){
                if(obj.PDK_Lifecycle_Phase__c=='Obsolete'){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'You cannot provision for Obsolete Master PDKs');
                    ApexPages.addMessage(myMsg);
                    isValid = false;        
                }
                else{
                    isValid = true;
                }   
            }
        }
        return isValid;
    }
    
    // Account Search
    public pageReference searchAccount(){
        system.debug('Inside Search Account >>>>>>>>>>>>>>>');
        if(searchtext!=null && searchtext.length()>1){
            searchResult =new list<AccountWapper>();
            string searchstrng='%'+searchtext.toLowerCase()+'%';
            Map<Id,Id> acctMap = new Map<Id,Id>();
            // ADDED to disabled checkbox
            List<Document_Provisioning__c> listOfDpRecords = [SELECT Id,Name,AccountID__c,AccountID__r.Short_Name__c,sub_PDK__c,status__c,Sub_PDK__r.Release_Status__c
                                                                FROM Document_Provisioning__c
                                                                WHERE sub_PDK__c = : objSubPDKId
                                                                AND status__c IN ('Provisioned','Provisioning In Progress','Sent For Approval','De-Provisioning In Progress')
                                                             ];
            
            if(listOfDpRecords<>NULL && !listOfDpRecords.isEmpty()){                                                 
                for(Document_Provisioning__c dp : listOfDpRecords){
                    if(!acctMap.containsKey(dp.AccountID__c)){
                        acctMap.put(dp.AccountID__c,dp.AccountID__c);
                    }
                }
            }

             //Added by Prajnith - Blacklist
            map<ID,ID> accountIdsBlackList =new map<ID,ID>();                                 
            for(PDK_Blacklist__c oblack: [Select Account__c,Account_Short_Name__c,PDK__c from PDK_Blacklist__c where PDK__c =:objSubPDKId AND (Account__r.name like :searchstrng OR Account__r.Short_Name__c like :searchstrng) AND BlackList_Activated__c =: true ]){
                accountIdsBlackList.put(oblack.Account__c,oblack.ID); 
            }
                        
            for(Account acc : [select name,id,Site_Department__c,Stage__c,Parent_Account_Name__c,ASIC_Business_Flag__c ,Parent_Account_Short_Name__c,Short_Name__c,Account_Present_In_OT__c
                                from account where (name like :searchstrng OR Short_Name__c like :searchstrng) order by Short_Name__c]){ //added for Case 42841
                if (acc<>Null){
                   AccountWapper w = new AccountWapper();
                   if(acctMap<>NULL && acctMap.containsKey(acc.Id)){
                        w.acct = acc;
                        w.selected = true;
                        w.isAlreadyProvisioned=true;
                   } else {
                        w.acct = acc;   
                        w.selected = false;
                        w.isAlreadyProvisioned=false;
                   }
                   // Added by Prajnith
                   if(accountIdsBlackList.containsKey(acc.ID)){
                       w.selected = false;
                       w.isAccountBlacklisted = true;
                       w.BlackListID = accountIdsBlackList.get(acc.ID);
                   }
                   searchResult.add(w);                   
                }
            }
            system.debug('Search Result >>>>>>'+searchResult);
            if(searchResult!=null && !searchResult.isEmpty()){
                renderSearchResults = true;
                 
            } else{ 
                renderSearchResults = false;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Account not found for entered account name. Please try another accout name.'));
            }
            
        } else{
            renderSearchResults = false;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please provide atleast 2 characters to search Account for provisioning.'));
        }  
        return null;
    }
    
    // Methos Help to provision PDK and PDK specs for provisioning
    public pageReference doProvision(){
        system.debug('Inside doProvisioning Method >>>>>>>>>>');     
        String accAlreadyProNames = '';
        system.debug('accAlreadyProNames>>>>>>>>>>>'+accAlreadyProNames);
        SavePoint sp;
        try{
            sp = DataBase.setSavepoint();
            if (searchResult<>Null && !searchResult.isEmpty()){
                if (isAccSelected()){
                    string accnames='';               
                    boolean showerror=false;
                    datetime d= datetime.now(); 
                    system.debug('lstOfSelectedAccounts$$>>>>>krishanu>>>>>>'+lstOfSelectedAccounts);
                    for(Account accobj:lstOfSelectedAccounts)
                    {
                     system.debug('Account_Present_In_OT_>>>>>>>>>>>'+accobj.Account_Present_In_OT__c);
                        if(accobj.Account_Present_In_OT__c==false || accobj.Short_Name__c==null || accobj.Short_Name__c=='')
                        {
                            showerror=true;
                            break;
                        }
                        else
                        {
                           showerror=false;
                        }
                    }
                    
                    for(Account accobj:lstOfSelectedAccounts)
                    {
                    
                        if(accobj.Account_Present_In_OT__c==false || accobj.Short_Name__c==null || accobj.Short_Name__c=='')
                        {
                        system.debug('Account_Present_In_OT__c$$>>>>>>>>>>>'+accnames);
                            if(accnames=='')
                            {
                                accnames='"'+accobj.Name+'"';
                            }
                            else
                            {
                                accnames=accnames+','+'"'+accobj.Name+'"';  
                             
                            }
                       }
                    }
                    system.debug('accnamefinal>>>>>>'+accnames);
                    system.debug('showerror$$>>>>>>>>>>>'+showerror);
 /*----------------------------added for Case 41455 end----------------------------------------------------------*/                        
                    
                    if(showerror==false)//added for case 41455
                    {
                        List<Account> lstOfSelectedAcc = FV_PDKProvisioningHandler.updateDeProvisionedDp(lstOfSelectedAccounts,objSubPDK.Id);
                        //Added by Dinesh
                        system.debug('list of Selected Acc'+lstOfSelectedAcc);
                        set<String> accountshortnameset=new set<String>(); 
                        Map<String,String> blacklistmap=new Map<String,Id>();
                                            
                        List<PDK_Blacklist__c> blacklist=[Select Account__c,Account_Short_Name__c,PDK__c from PDK_Blacklist__c where Account__c IN:lstOfSelectedAcc AND PDK__c =:objSubPDKId AND BlackList_Activated__c =: true]; 
                        for(PDK_Blacklist__c black:blacklist){
                        accountshortnameset.add(black.Account_Short_Name__c);
                        blacklistmap.put(black.Account_Short_Name__c,black.Id);
                        }
                        
                        
                        integer blacklistcount=0;
                        String DynamicAccount='';
                        String DynamicRecordLink='';
                        system.debug('lstOfSelectedAccounts***'+lstOfSelectedAccounts);
                        for(Account accnt:lstOfSelectedAccounts){
                          if(accountshortnameset.contains(accnt.Short_Name__c)){
                           DynamicAccount=accnt.Short_Name__c;
                           DynamicRecordLink=blacklistmap.get(accnt.Short_Name__c);
                           
                           blacklistcount++;
                           }
                          
                        }

                        objSubPDK = retrieveSubPDKInfo(objSubPDKId);
                        String DynamicBundle=objSubPDK.Name;
                       
                        //Ended by Dinesh
                        
                        if(lstOfSelectedAcc<>NULL && !lstOfSelectedAcc.isEmpty()&& blacklistcount==0){
                            // Call PDK Provisioning Method
                                FV_DocumentProvisioningUtil.provisionNewPDK(objSubPDK, lstOfSelectedAcc);
                            }
                        //Added by Dinesh    
                        else if(blacklistcount>0)   {
                            String BlackListerrorMessage='This account'+' '+ '"'+ DynamicAccount +'"'+' is Blacklisted for '+'"'+ DynamicBundle +'"'  +' ';
                            BlackListerrorMessage+='<br/><br/><a target="_blank" href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+DynamicRecordLink+' " >Click here to see the details</a>';
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,BlackListerrorMessage));
                            return null;
                        }   
                        //Ended by Dinesh  
                    }
/*------------------------added for Case 41455 start----------------------------------------------------------------------*/
                    else
                    {
                    String errorMessage = 'Account'+' '+accnames+' '+'is/are not fully enabled yet.'+'<br/>'+
                                          'Please ensure the following conditions in Account are met before attempting to provision it again:'+
                                          '<ul><li>'+'Every Account must have a "Short Name."'+'</li>'+
                                          '<li>'+'Each Account must have at least one Contact that is an active portal user. (Note: This will enable "Account Present in OT" to be checked to allow account to be selected for provisioning.)'+'</li></ul>';
                                            
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,errorMessage));
                    return null;
                    
                    }
 /*----------------------added for Case 41455 end-------------------------------------------------------------------------------*/                   
                } else {
                    system.debug('Inside else select at least one Account ###########');
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please select at least 1 Account for PDK provisioning.'));
                    return null;
                }
            } else {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please search and add at least 1 Account for PDK provisioning.'));
                    return null;
            }
            
        } catch (Exception e){
            DataBase.rollback(sp);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
            //return null;
        }
        return new PageReference('/'+objSubPDKId);
    }
    // Method help to check if account is selected for provisioning or not
    public boolean isAccSelected(){
        
        Boolean isSelected = false;
        lstOfSelectedAccounts = new List<Account>();
        
        if(searchResult<>Null && !searchResult.isEmpty()){
            for (AccountWapper wrapper : searchResult){
                if (wrapper.selected && !wrapper.isAlreadyProvisioned){
                    lstOfSelectedAccounts.add(wrapper.acct);
                }
            }                   
        }
        system.debug('lstOfSelectedAccounts>>>>>>>>>>>>'+lstOfSelectedAccounts);
        if (lstOfSelectedAccounts<>Null && !lstOfSelectedAccounts.isEmpty()){
            isSelected = true;
        }
        return isSelected;
    }
    // Update already provisioned Document provisioning record
    public static List<Account> updateDeProvisionedDp(List<Account> lstOfSelectedAccounts,Id objSubPDKId){
        //Map holds white list specs (spec release status) records. 
        Map<Id,Sub_PDK_Spec__c> whiteListSpecs = new Map<Id,Sub_PDK_Spec__c>();
        // Map holds specs which doesnt have release status as white list
        Map<Id,Sub_PDK_Spec__c> nonWhiteListSpecs = new Map<Id,Sub_PDK_Spec__c>();
        // Below map will be hold id as spec and set of account ids which are related to that perticular spec
        Map<Id,Set<Id>> wlSpecAccMap = new Map<Id,Set<Id>>();
        system.debug('lstOfSelectedAccounts$$$'+lstOfSelectedAccounts);
        for(Sub_PDK_Spec__c  pdkSpec : [SELECT  id,name,Sub_PDK__c,Design_Spec__c,OTID__c,Design_Spec__r.Release_Status__c,
                                                    Design_Spec__r.OpenText_ID__c,Design_Spec__r.Specification_Type__c,Design_Spec__r.Document_Title__c
                                            FROM    Sub_PDK_Spec__c
                                            WHERE  ( Sub_PDK__c = : objSubPDKId )
                                            AND     Design_Spec__r.Release_Status__c!='General Release'
                                            AND     Design_Spec__r.Release_Status__c!='Internal Use Only'
                                            AND     Design_Spec__r.Specification_Type__c!='Stepper Tooling Forms'
                                            AND     Design_Spec__r.Specification_Type__c!='Reticle Grade Table']) {
            
            if(pdkSpec<>NULL){ 
             if (pdkSpec.Design_Spec__r.Release_Status__c!=null && pdkSpec.Design_Spec__c!=null)
              {  
                if (pdkSpec.Design_Spec__r.Release_Status__c.toLowerCase().contains('white list')){
                    if(pdkSpec.Design_Spec__r.OpenText_ID__c!=Null){
                        if(!whiteListSpecs.containsKey(pdkSpec.Design_Spec__c)){
                            // prepare whitelist spec map
                            whiteListSpecs.put(pdkSpec.Design_Spec__c,pdkSpec);
                        }
                    }
                  }          
                 
                else {
                            if(pdkSpec.Design_Spec__r.OpenText_ID__c!=Null){
                                if(!nonWhiteListSpecs.containsKey(pdkSpec.Design_Spec__c)){
                                    // prepare non white list map
                                    nonWhiteListSpecs.put(pdkSpec.Design_Spec__c,pdkSpec);
                                }
                            }
                        } 
                 }         
             }                                              
         } // END OF FOR LOOP
        
        system.debug('nonWhiteListSpecs in edit pdk$$'+nonWhiteListSpecs);
        //prepare Map of spec as key and list of white list accounts associated with that spec  
        if(whiteListSpecs<>NULL && !whiteListSpecs.isEmpty()){
            for(White_List__c wl : [Select Id,Design_Spec__c,Account__c 
                                    From White_List__c 
                                    where Design_Spec__c IN : whiteListSpecs.keySet()]){
                                                             
                if(wl<>Null){                       
                    if (!wlSpecAccMap.containsKey(wl.Design_Spec__c)){
                        wlSpecAccMap.put(wl.Design_Spec__c, new Set<Id>());
                    } //else {
                        // prepare map of design spec and list of account associated with that spec
                        // it will help to identify user while account level provisioning and if that selected account 
                        // is available in white list of this map then this spec will be send to OT for provisioning else it will not be send to OT for provisioning
                        wlSpecAccMap.get(wl.Design_Spec__c).add(wl.Account__c);
                    //}
                }
            } 
        }
        Map<Id,Account> mapOfAccount = new Map<Id,Account>();
        List<Document_Provisioning__c> listOfDpRecords = new List<Document_Provisioning__c>();
        List<Document_Provisioning__c> updatedDpRecords = new List<Document_Provisioning__c>();
        Set<Id> setOfAccIds = new Set<Id>();
        List<Account> lstOfAccsNotDepro = new List<Account>();// prepare list of account which are not deprovisioned and which are new for provisioning
        if (lstOfSelectedAccounts<>NULL && !lstOfSelectedAccounts.isEmpty()){
            for (Account acc : lstOfSelectedAccounts){
                if (!mapOfAccount.containsKey(acc.Id)){
                    mapOfAccount.put(acc.Id,acc);   
                }
            }
        }
        if(mapOfAccount<>NULL && !mapOfAccount.isEmpty()){
            listOfDpRecords = [SELECT Id,Name,AccountID__r.Short_Name__c,sub_PDK__c,status__c,is_De_Prov_From_UI__c,Sub_PDK__r.Release_Status__c
                               FROM Document_Provisioning__c
                               WHERE (Sub_PDK__c = : objSubPDKId)
                               AND AccountID__c IN : mapOfAccount.keySet()
                               AND status__c IN ('De-Provisioned','Rejected','Provisioning In Progress')];

        }
        if (listOfDpRecords<>NULL && !listOfDpRecords.isEmpty()){
            for (Document_Provisioning__c dp: listOfDpRecords){
                String specs = '';
                String subPdkSpecs = '';
                String pdkAssociations = '';
                String specName = '';
                setOfAccIds.add(dp.AccountID__c);
                if(whiteListSpecs<>Null && !whiteListSpecs.isEmpty()){
                    for (Id specId : whiteListSpecs.keySet()){
                        if(wlSpecAccMap<>Null && wlSpecAccMap.containskey(specId) && 
                            wlSpecAccMap.get(specId).contains(dp.AccountID__c)){
                                // Add spec id to dp design spec
                                //if(whiteListSpecs.containsKey(specId)){ 
                                if(specs==''){
                                    if(!String.isBlank(String.valueOf(whiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c))){
                                        //specs = String.valueOf(whiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c);
                                        if (whiteListSpecs.get(specId).OTID__c!=NULL)
                                            specs = String.valueOf(whiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c)+':'+whiteListSpecs.get(specId).OTID__c;    
                                        else 
                                            specs = String.valueOf(whiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c)+':'+'NONE';
                                    }
                                } else {
                                    if(!String.isBlank(String.valueOf(whiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c))){
                                        if (whiteListSpecs.get(specId).OTID__c!=NULL)
                                            specs = specs +';'+String.valueOf(whiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c)+':'+whiteListSpecs.get(specId).OTID__c; 
                                        else 
                                            specs = specs +';'+String.valueOf(whiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c)+':'+'NONE';
                                    }   
                                  }
                            }
                    } // End of whitelist for loop
                } 
                       
                    if(nonWhiteListSpecs<>Null && !nonWhiteListSpecs.isEmpty()){    
                        system.debug('Inside nonWhiteListSpecs>>>>>>>>');
                        for (Id specId : nonWhiteListSpecs.keySet()){
                            if (specs ==''){
                                if(!String.isBlank(String.valueOf(nonWhiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c))){
                                    system.debug('Specs before >>>>>>>>>>>'+nonWhiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c);
                                    if(nonWhiteListSpecs.get(specId).OTID__c<>NULL)
                                        specs = String.valueOf(nonWhiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c)+':'+nonWhiteListSpecs.get(specId).OTID__c;
                                    else 
                                        specs = String.valueOf(nonWhiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c)+':'+'NONE';
                                        system.debug('Specs After>>>>>>>>..'+specs);
                                }
                            } else {
                               system.debug('enter else22>>>>>>>>..');
                                if(!String.isBlank(String.valueOf(nonWhiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c))){
                                system.debug('Specs before else>>>>>>>>>>>'+nonWhiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c);
                                    if (nonWhiteListSpecs.get(specId).OTID__c<>NULL)
                                        specs = specs+';'+ String.valueOf(nonWhiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c)+':'+nonWhiteListSpecs.get(specId).OTID__c;
                                    else 
                                        specs = specs+';'+ String.valueOf(nonWhiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c)+':'+'NONE';  
                                    system.debug('Specs After else>>>>>>>>..'+specs);
                                
                                }
                            }
                        } // End of nonWhiteListSpec for loop
                    }
                    system.debug('specs>>>>>>>>>>'+specs);
 /*----------------------PDK Specs to send to OT will be NONE instead of empty---------------------------------------*/                    
                    if (String.isBlank(specs)){
                        DP.PdkSpecs__c = 'NONE'; 
                    }
                    system.debug('specs>>>>>>>>>>'+specs);
/*----------------------PDK Specs to send to OT will be NONE instead of empty---------------------------------------*/   
                    if (!String.isBlank(specs)){
                        DP.PdkSpecs__c = specs; 
                    }
                if (dp.status__c=='De-Provisioned' && dp.Sub_PDK__r.Release_Status__c!='Specific Account Release with Spec owner Approval' && dp.Sub_PDK__r.Release_Status__c!='Internal Use Only' ){
                    dp.status__c = 'Provisioning In Progress';  
                }
                if (dp.status__c=='Rejected' || (dp.status__c=='De-Provisioned' && dp.Sub_PDK__r.Release_Status__c=='Specific Account Release with Spec owner Approval')){
                    dp.status__c='Sent For Approval';
                }
                dp.isProvUpdate__c = false;
                dP.isDeProUpdate__c = false;
                if(!system.isFuture() && !system.isBatch() && dp.is_De_Prov_From_UI__c){
                   dp.is_De_Prov_From_UI__c=false;  
                }
                updatedDpRecords.add(dp);
            }
            try{
                if(updatedDpRecords<>NULL && !updatedDpRecords.isEmpty()){
                    update updatedDpRecords;
                }
            } catch (Exception e){
                system.debug('Exception Occureed in updateDeProvisionedDp Method :: '+e.getMessage());  
            }
            if (setOfAccIds<>NULL && !setOfAccIds.isEmpty()){
                for(Id accId : mapOfAccount.keySet()){
                    if (!setOfAccIds.contains(accId)){
                        lstOfAccsNotDepro.add(mapOfAccount.get(accId));
                    }
                }
            }
            
        } else {
            lstOfAccsNotDepro.addAll(lstOfSelectedAccounts);
        }
        system.debug('lstOfAccsNotDepro >>>>>>>>>>>'+lstOfAccsNotDepro);
        return lstOfAccsNotDepro;
    }
/*------------------------------------acc reprovisioning------------------------------------------------*/  

public static List<Account> updateDeProvisionedDpforNDAactivate(List<Account> acclist,Set<Id> setofPDKIds){
   system.debug('***im in updateDeProvisionedDpforNDAactivate***');
   List<Sub_PDK__c> lstofWLPdk=[Select Id,Release_Status__c 
                                       from Sub_PDK__c 
                                       where Release_Status__c ='Release to White list' and Id In:setofPDKIds];
   
        Map<Id,Sub_PDK_Spec__c> whiteListSpecs = new Map<Id,Sub_PDK_Spec__c>();
        Map<Id,Id> WhiteListSpecsandPDK = new Map<Id,Id>();
        Map<Id,Sub_PDK_Spec__c> whiteListdesignSpecs=new Map<Id,Sub_PDK_Spec__c>();
        // Map holds specs which doesnt have release status as white list
        Map<Id,Sub_PDK_Spec__c> nonWhiteListSpecs = new Map<Id,Sub_PDK_Spec__c>();
        Map<Id,Id> nonWhiteListSpecsandPDK = new Map<Id,Id>();
        // Below map will be hold id as spec and set of account ids which are related to that perticular spec
        Map<Id,Set<Id>> wlSpecAccMap = new Map<Id,Set<Id>>();
        Map<Id,Set<Id>> wlPdkAccMap=new Map<Id,Set<Id>>();
        
        for(Sub_PDK_Spec__c  pdkSpec : [SELECT  id,name,Sub_PDK__c,Design_Spec__c,OTID__c,Design_Spec__r.Release_Status__c,
                                                    Design_Spec__r.OpenText_ID__c,Design_Spec__r.Specification_Type__c,Design_Spec__r.Document_Title__c
                                            FROM    Sub_PDK_Spec__c
                                            WHERE   Sub_PDK__c IN : setofPDKIds
                                            AND     Design_Spec__r.Release_Status__c!='General Release'
                                            AND     Design_Spec__r.Release_Status__c!='Internal Use Only'
                                            AND     Design_Spec__r.Specification_Type__c!='Stepper Tooling Forms'
                                            AND     Design_Spec__r.Specification_Type__c!='Reticle Grade Table']) {
                                            
            system.debug('pdkSpec&&&&'+pdkSpec);                                
            
            if(pdkSpec<>NULL){
              if (pdkSpec.Design_Spec__r.Release_Status__c!=null && pdkSpec.Design_Spec__c!=null)
              {
                if (pdkSpec.Design_Spec__r.Release_Status__c.toLowerCase().contains('white list')){
                    if(pdkSpec.Design_Spec__r.OpenText_ID__c!=Null){
                        if(!whiteListSpecs.containsKey(pdkSpec.Design_Spec__c)){
                            // prepare whitelist spec map
                            whiteListSpecs.put(pdkSpec.Design_Spec__c,pdkSpec);
                            //whiteListdesignSpecs.put(pdkSpec.Design_Spec__c,pdkSpec);
                            WhiteListSpecsandPDK.put(pdkSpec.Design_Spec__c,pdkSpec.Sub_PDK__c);
                        }
                    }
                  }          
                 else {
                
                          system.debug('pdkSpec else&&&&'+pdkSpec); 
                            if(pdkSpec.Design_Spec__r.OpenText_ID__c!=Null){
                            system.debug('pdkSpec.Design_Spec__r.OpenText_ID__c!=Null'+pdkSpec.Design_Spec__r.OpenText_ID__c);
                                if(!nonWhiteListSpecs.containsKey(pdkSpec.Id)){
                                    // prepare non white list map
                                    system.debug('nonWhiteListSpecs11&&&&'+nonWhiteListSpecs);
                                    nonWhiteListSpecs.put(pdkSpec.Id,pdkSpec);
                                    nonWhiteListSpecsandPDK.put(pdkSpec.id,pdkSpec.Sub_PDK__c);
                                }
                            }
                        }
                    }       
             }                                              
         } // END OF FOR LOOP
        
        system.debug('WhiteListSpecs&&&&'+whiteListSpecs);
        system.debug('WhiteListSpecsandPDK&&&&'+WhiteListSpecsandPDK);
        
        system.debug('nonWhiteListSpecs&&&&'+nonWhiteListSpecs);
        system.debug('nonWhiteListSpecsandPDK&&&&'+nonWhiteListSpecsandPDK);
        
      //prepare Map of spec as key and list of white list accounts associated with that spec  
        if(whiteListSpecs<>NULL && !whiteListSpecs.isEmpty()){
            for(White_List__c wl : [Select Id,Design_Spec__c,Account__c 
                                    From White_List__c 
                                    where Design_Spec__c IN : whiteListSpecs.keySet()]){
                                                             
                if(wl<>Null){                       
                    if (!wlSpecAccMap.containsKey(wl.Design_Spec__c)){
                        wlSpecAccMap.put(wl.Design_Spec__c, new Set<Id>());
                    } //else {
                        // prepare map of design spec and list of account associated with that spec
                        // it will help to identify user while account level provisioning and if that selected account 
                        // is available in white list of this map then this spec will be send to OT for provisioning else it will not be send to OT for provisioning
                        wlSpecAccMap.get(wl.Design_Spec__c).add(wl.Account__c);
                    //}
                }
            } 
        } // END OF whiteListSpecs LOOP
        
        
        //prepare Map of pdk as key and list of white list accounts associated with that pdk
        List<White_List__c> lstwl=new List<White_List__c>();
            for(White_List__c wl : [Select Id,Sub_PDK__c,Account__c 
                                    From White_List__c 
                                    where Sub_PDK__c IN : setofPDKIds]){
                 lstwl.add(wl);                                            
                
                }
             
        
        system.debug('lstwl&&&&'+lstwl);  
      
        Map<Id,Account> mapOfAccount = new Map<Id,Account>();
        List<Document_Provisioning__c> listOfDpRecords = new List<Document_Provisioning__c>();
        List<Document_Provisioning__c> updatedDpRecords = new List<Document_Provisioning__c>();
        Set<Id> setOfAccIds = new Set<Id>();
        List<Account> lstOfAccsNotDepro = new List<Account>();// prepare list of account which are not deprovisioned and which are new for provisioning
        if (acclist<>NULL && !acclist.isEmpty()){
            for (Account acc : acclist){
                if (!mapOfAccount.containsKey(acc.Id)){
                    mapOfAccount.put(acc.Id,acc);   
                }
            }
        }
        if(mapOfAccount<>NULL && !mapOfAccount.isEmpty()){
            listOfDpRecords = [SELECT Id,Name,AccountID__r.Short_Name__c,sub_PDK__c,status__c,is_De_Prov_From_UI__c,Account__c,Sub_PDK__r.Release_Status__c,
                                DP_ASIC_Business__c,DP_Is_Parent_ASIC__c,Design_Spec__c
                               FROM Document_Provisioning__c
                               WHERE sub_PDK__c IN : setofPDKIds
                               AND AccountID__c IN : mapOfAccount.keySet()
                               AND status__c IN ('De-Provisioned','Rejected','Provisioning In Progress')
                               AND is_De_Prov_From_UI__c=false];

        }
/*--------------------added on 10th Jutly---------------------------------------------------------------*/

  map<id,set<id>> dpPdkAccMap=new map<id,set<id>>();
             for(White_List__c wl :lstwl)
             {
              for(Document_Provisioning__c dp: listOfDpRecords )
              {
               if(dp.sub_PDK__c==wl.sub_PDK__c)
               {
                  system.debug('!wlPdkAccMap.containsKey(wl.Sub_PDK__c )'+!wlPdkAccMap.containsKey(wl.Sub_PDK__c ));
                    if (!wlPdkAccMap.containsKey(wl.Sub_PDK__c )){
                            wlPdkAccMap.put(wl.Sub_PDK__c, new Set<Id>());
                            system.debug('entrif###'+wlPdkAccMap);
                     } 
                      
                      wlPdkAccMap.get(wl.Sub_PDK__c).add(wl.Account__c);
                      
                      
                }
                     
                    
               }
              
              }
              
              
              
         system.debug('wlPdkAccMap&&&&'+wlPdkAccMap);
/*----------------------------------------------------------------------------------------------------*/        
        
        
/*--------------------------added new ---------------------------------------------------------------------*/  
        Map<Id,Id> mapofDpPDKid=new Map<Id,Id>();
        if (listOfDpRecords<>NULL && !listOfDpRecords.isEmpty())
        {
            for (Document_Provisioning__c dp: listOfDpRecords)
            {
             mapofDpPDKid.put(dp.Id,dp.Sub_PDK__c);
            }
            
         }   
/*----------------------added new ---------------------------------------------------------------------*/   
/*-----------------------final code-------------------------------------------------------------------------*/
       if (listOfDpRecords<>NULL && !listOfDpRecords.isEmpty()){
            for (Document_Provisioning__c dp: listOfDpRecords){
                String specs = '';
                String subPdkSpecs = '';
                String pdkAssociations = '';
                String specName = '';
                setOfAccIds.add(dp.AccountID__c);
                system.debug('dp.Sub_PDK__c&&&&'+dp.Sub_PDK__c);
                system.debug('wlPdkAccMap.get(dp.Sub_PDK__c)&&&&'+wlPdkAccMap.get(dp.Sub_PDK__c));
                if(wlPdkAccMap<>Null && wlPdkAccMap.get(dp.Sub_PDK__c)<>NULL && wlPdkAccMap.get(dp.Sub_PDK__c).contains(dp.account__c))
                {
                
               
                if(whiteListSpecs<>Null && !whiteListSpecs.isEmpty()){
                    for (Id specId : whiteListSpecs.keySet()){
                     if(WhiteListSpecsandPDK<>Null && WhiteListSpecsandPDK.get(specId)==mapofDpPDKid.get(dp.id))
                     {
                        if(wlSpecAccMap<>Null && wlSpecAccMap.containskey(specId) && 
                            wlSpecAccMap.get(specId).contains(dp.AccountID__c)){
                                
                                if(specs==''){
                                    if(!String.isBlank(String.valueOf(whiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c))){
                                        //specs = String.valueOf(whiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c);
                                        if (whiteListSpecs.get(specId).OTID__c!=NULL)
                                            specs = String.valueOf(whiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c)+':'+whiteListSpecs.get(specId).OTID__c;    
                                        else 
                                            specs = String.valueOf(whiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c)+':'+'NONE';
                                    }
                                } else {
                                    if(!String.isBlank(String.valueOf(whiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c))){
                                        if (whiteListSpecs.get(specId).OTID__c!=NULL)
                                            specs = specs +';'+String.valueOf(whiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c)+':'+whiteListSpecs.get(specId).OTID__c; 
                                        else 
                                            specs = specs +';'+String.valueOf(whiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c)+':'+'NONE';
                                    }   
                                  }
                            }
                    } // End of whitelist for loop
                } 
                }
                }
                if(nonWhiteListSpecs<>Null && !nonWhiteListSpecs.isEmpty()){    
                        system.debug('Inside nonWhiteListSpecs>>>>>>>>');
                        for (Id specId : nonWhiteListSpecs.keySet())
                        {
                        system.debug('specId >>>>>>>>'+specId );
                        system.debug('DP>>>>>>>>'+dp );
                        system.debug('nonWhiteListSpecsandPDK.get(specId)if>>>>>>>>'+nonWhiteListSpecsandPDK.get(specId));
                        system.debug('mapofDpPDKid.get(dp.id)>>>>>>>>'+mapofDpPDKid.get(dp.id));
                            if(nonWhiteListSpecsandPDK.get(specId)==mapofDpPDKid.get(dp.id))
                            {
                             system.debug('Inside if>>>>>>>>');
                                if (specs ==''){
                                    if(!String.isBlank(String.valueOf(nonWhiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c))){
                                        system.debug('Specs before >>>>>>>>>>>'+nonWhiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c);
                                        if(nonWhiteListSpecs.get(specId).OTID__c<>NULL)
                                            specs = String.valueOf(nonWhiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c)+':'+nonWhiteListSpecs.get(specId).OTID__c;
                                        else 
                                            specs = String.valueOf(nonWhiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c)+':'+'NONE';
                                            system.debug('Specs After>>>>>>>>..'+specs);
                                    }
                                } else {
                                    if(!String.isBlank(String.valueOf(nonWhiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c))){
                                        if (nonWhiteListSpecs.get(specId).OTID__c<>NULL)
                                            specs = specs+';'+ String.valueOf(nonWhiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c)+':'+nonWhiteListSpecs.get(specId).OTID__c;
                                        else 
                                            specs = specs+';'+ String.valueOf(nonWhiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c)+':'+'NONE';  
                                    }
                                }
                            } // End of nonWhiteListSpec for loop 
                        }
                      }  
                      
                      
                      system.debug('specs>>>>>>>>>>'+specs);
 /*----------------------PDK Specs to send to OT will be NONE instead of empty---------------------------------------*/                    
                    if (String.isBlank(specs)){
                        DP.PdkSpecs__c = 'NONE'; 
                    }
                    system.debug('specs>>>>>>>>>>'+specs);
/*----------------------PDK Specs to send to OT will be NONE instead of empty---------------------------------------*/   
                    if (!String.isBlank(specs)){
                        DP.PdkSpecs__c = specs; 
                    }
               if (dp.status__c=='De-Provisioned' && dp.Sub_PDK__r.Release_Status__c=='Release to White list'){
               
                  if(wlPdkAccMap<>Null && wlPdkAccMap.get(dp.Sub_PDK__c)<>NULL && wlPdkAccMap.get(dp.Sub_PDK__c).contains(dp.account__c))
                  {
                    dp.status__c = 'Provisioning In Progress';
                  }  
                }     
                else if (dp.status__c=='De-Provisioned' && dp.Sub_PDK__r.Release_Status__c!='Internal Use Only'){
                    dp.status__c = 'Provisioning In Progress';  
                }
                if (dp.status__c=='Rejected'){
                    dp.status__c='Sent For Approval';
                }
                dp.isProvUpdate__c = false;
                dP.isDeProUpdate__c = false;
                
                /*
                //DP_ASIC_Business__c,DP_Licensing_Agreement__c,DP_Is_Parent_ASIC__c,Design_Spec__c
                if(dp.DP_ASIC_Business__c){ // when account is ASIC
                    if(dp.DP_Is_Parent_ASIC__c){
                                                
                    }
                }
                
                // if design spec
                        if(dp.Design_Spec__c != null){
                            
                        }
                        // if bundle
                        if(dp.Sub_PDK__c != null){
                            
                        }
                        */
                
                if(!system.isFuture() && !system.isBatch() && dp.is_De_Prov_From_UI__c){
                   dp.is_De_Prov_From_UI__c=false;  
                }
                updatedDpRecords.add(dp);
  
              }
              
              try{
                if(updatedDpRecords<>NULL && !updatedDpRecords.isEmpty()){
                    update updatedDpRecords;
                }
            } catch (Exception e){
                system.debug('Exception Occureed in updateDeProvisionedDp Method :: '+e.getMessage());  
            }
            
           if (setOfAccIds<>NULL && !setOfAccIds.isEmpty()){
                for(Id accId : mapOfAccount.keySet()){
                    if (!setOfAccIds.contains(accId)){
                        lstOfAccsNotDepro.add(mapOfAccount.get(accId));
                    }
                }
            }
            
        }
/*--------------------------------------------------------------------------------------------------------------*/
               
       /* if (listOfDpRecords<>NULL && !listOfDpRecords.isEmpty()){
            for (Document_Provisioning__c dp: listOfDpRecords){
                String specs = '';
                String subPdkSpecs = '';
                String pdkAssociations = '';
                String specName = '';
                setOfAccIds.add(dp.AccountID__c);
                if(whiteListSpecs<>Null && !whiteListSpecs.isEmpty()){
                    for (Id specId : whiteListSpecs.keySet()){
                        if(wlSpecAccMap<>Null && wlSpecAccMap.containskey(specId) && 
                            wlSpecAccMap.get(specId).contains(dp.AccountID__c)){
                                
                                if(specs==''){
                                    if(!String.isBlank(String.valueOf(whiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c))){
                                        //specs = String.valueOf(whiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c);
                                        if (whiteListSpecs.get(specId).OTID__c!=NULL)
                                            specs = String.valueOf(whiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c)+':'+whiteListSpecs.get(specId).OTID__c;    
                                        else 
                                            specs = String.valueOf(whiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c)+':'+'NONE';
                                    }
                                } else {
                                    if(!String.isBlank(String.valueOf(whiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c))){
                                        if (whiteListSpecs.get(specId).OTID__c!=NULL)
                                            specs = specs +';'+String.valueOf(whiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c)+':'+whiteListSpecs.get(specId).OTID__c; 
                                        else 
                                            specs = specs +';'+String.valueOf(whiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c)+':'+'NONE';
                                    }   
                                  }
                            }
                    } // End of whitelist for loop
                } 
                
                if(nonWhiteListSpecs<>Null && !nonWhiteListSpecs.isEmpty()){    
                        system.debug('Inside nonWhiteListSpecs>>>>>>>>');
                        for (Id specId : nonWhiteListSpecs.keySet())
                        {
                        system.debug('specId >>>>>>>>'+specId );
                        system.debug('DP>>>>>>>>'+dp );
                        system.debug('nonWhiteListSpecsandPDK.get(specId)if>>>>>>>>'+nonWhiteListSpecsandPDK.get(specId));
                        system.debug('mapofDpPDKid.get(dp.id)>>>>>>>>'+mapofDpPDKid.get(dp.id));
                            if(nonWhiteListSpecsandPDK.get(specId)==mapofDpPDKid.get(dp.id))
                            {
                             system.debug('Inside if>>>>>>>>');
                                if (specs ==''){
                                    if(!String.isBlank(String.valueOf(nonWhiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c))){
                                        system.debug('Specs before >>>>>>>>>>>'+nonWhiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c);
                                        if(nonWhiteListSpecs.get(specId).OTID__c<>NULL)
                                            specs = String.valueOf(nonWhiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c)+':'+nonWhiteListSpecs.get(specId).OTID__c;
                                        else 
                                            specs = String.valueOf(nonWhiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c)+':'+'NONE';
                                            system.debug('Specs After>>>>>>>>..'+specs);
                                    }
                                } else {
                                    if(!String.isBlank(String.valueOf(nonWhiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c))){
                                        if (nonWhiteListSpecs.get(specId).OTID__c<>NULL)
                                            specs = specs+';'+ String.valueOf(nonWhiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c)+':'+nonWhiteListSpecs.get(specId).OTID__c;
                                        else 
                                            specs = specs+';'+ String.valueOf(nonWhiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c)+':'+'NONE';  
                                    }
                                }
                            } // End of nonWhiteListSpec for loop 
                        }
                      }  
                      
                      
                      system.debug('specs>>>>>>>>>>'+specs);
                    if (!String.isBlank(specs)){
                        DP.PdkSpecs__c = specs; 
                    }
                if (dp.status__c=='De-Provisioned'){
                    dp.status__c = 'Provisioning In Progress';  
                }
                if (dp.status__c=='Rejected'){
                    dp.status__c='Sent For Approval';
                }
                dp.isProvUpdate__c = false;
                dP.isDeProUpdate__c = false;
                if(!system.isFuture() && !system.isBatch() && dp.is_De_Prov_From_UI__c){
                   dp.is_De_Prov_From_UI__c=false;  
                }
                updatedDpRecords.add(dp);
  
              }
              
              try{
                if(updatedDpRecords<>NULL && !updatedDpRecords.isEmpty()){
                    update updatedDpRecords;
                }
            } catch (Exception e){
                system.debug('Exception Occureed in updateDeProvisionedDp Method :: '+e.getMessage());  
            }
            
           if (setOfAccIds<>NULL && !setOfAccIds.isEmpty()){
                for(Id accId : mapOfAccount.keySet()){
                    if (!setOfAccIds.contains(accId)){
                        lstOfAccsNotDepro.add(mapOfAccount.get(accId));
                    }
                }
            }
            
        }*/
        
         else {
            lstOfAccsNotDepro.addAll(acclist);
        }
        system.debug('lstOfAccsNotDepro >>>>>>>>>>>'+lstOfAccsNotDepro);
        return lstOfAccsNotDepro;
  
  }//end of method

 /*----------------------------acc reprovisioning------------------------------------------------------------------------*/ 
    
    // Methods returns already provisioned account short names
    public string getAlreadyProvisionedAccounts(){
        String accShortNames = '';
        String alreadyProvisionedAccs = '';
        
        List<Document_Provisioning__c> listOfDpRecords = [SELECT Id,Name,AccountID__r.Short_Name__c,sub_PDK__c,status__c,Sub_PDK__r.Release_Status__c
                                                          FROM Document_Provisioning__c
                                                          WHERE sub_PDK__c = : objSubPDKId
                                                          AND status__c IN ('Provisioned','Provisioning In Progress','Sent For Approval','De-Provisioning In Progress')];
                                                            
                                                          
        for (Document_Provisioning__c dp : listOfDpRecords){
            if (accShortNames==''){
                accShortNames = dp.AccountID__r.Short_Name__c;
            } else {
                accShortNames = accShortNames +','+dp.AccountID__r.Short_Name__c;
            }
        }
        
        for (Account acc : lstOfSelectedAccounts){
            if (accShortNames.contains(acc.Short_Name__c)){
                if(alreadyProvisionedAccs==''){
                    alreadyProvisionedAccs = acc.Short_Name__c;
                } else {
                    alreadyProvisionedAccs = alreadyProvisionedAccs+';'+acc.Short_Name__c;
                }
            }
        }
        
        return alreadyProvisionedAccs;                                                
    }
    
    public PageReference back(){
        
        return new PageReference('/'+objSubPDKId);
    }
    
    public class AccountWapper{
         public Account acct {get; set;}
         public boolean selected {get;set;}
         public boolean isAccountBlacklisted{get;set;}                  
         public String BlackListID {get;set;}  
                  
         public boolean isAlreadyProvisioned {get;set;}
         public AccountWapper(){
             if(acct==null){acct = new Account();}
         }
    }
}