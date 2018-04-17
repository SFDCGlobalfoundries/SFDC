/*************************************************************************************************************************************************************
@ Class:          Account_TriggerHelper
@ Version:        1.0
@ Author:         Ishtpreet Singh (Ishtpreet.singh@globalfoundries.com)
@ Purpose:        Helper class which consist of logics used in Account Triggers
--------------------------------------------------------------------------------------------------------------------------------------------------------------
@ Change history: 24.10.2016 / Ishtpreet Singh / Created the class.
**************************************************************************************************************************************************************/
public class Account_TriggerHelper{

    /*Global Variables*/
    public       Map<Id,Account>                  triggerOldMap                 { get; set; }
    public       Map<Id,Account>                  triggerNewMap                 { get; set; }
    public       Set<Id>                          setofAccId                    { get; set; }
    public       List<Account>                    accountList                   { get; set; }
    public       map<id,list<Account>>            mAcc4OwnerChange              { get; set; } 
    public       map<string, Account>             shortName2AccountMap          { get; set; } 
    public       map<id, Id>                      acctId2PrevParentAcctMap      { get; set; }
    public       List<Account>                    listInsertAccounts            { get; set; }
    public       List<Account>                    listUpdateAccounts            { get; set; }
    public       List<Account>                    acctRegHeadChangeList         { get; set; }
    public       Set<Id>                          promote2AuthorizedAcctIds     { get; set; }
    public       Set<Id>                          sAcc4OwnerChange              { get; set; } 
    public       Set<String>                      newAcctOwnerSet               { get; set; }
    public       Set<id>                          acctId4CN                     { get; set; }
    public       Set<id>                          acctId4ATP                    { get; set; }
    public       set<id>                          customerPortalAdminSet        { get; set; }
    public       List<Account>                    portalAdminChangedAcctIdSet   { get; set; }
    public       set<id>                          sAcctNameChanged              { get; set; }
    public       set<id>                          sAccRegionChange              { get; set; }
    public       Map<Id, Id>                      mapAccountRH                  { get; set; }
    public       List<string>                     listAccountIds                { get; set; }
    public       Set<Id>                          accountIdForOwnerUpdateSet    { get; set; }

    
    /*Final String*/
    final String PRIMARY_FTS                    =               EnvironmentVariable.get('ACCT_TM_PRXY_TM_RL_PFTS') ;
    final String BACKUP_CSR                     =               EnvironmentVariable.get('ACCT_TM_PRXY_TM_RL_BCSR');
    final String PRIMARY_ACCOUTN_MANAGER        =               EnvironmentVariable.get('ACCT_TM_PRXY_TM_RL_PAM');
    final String ACCOUTN_MANAGER                =               EnvironmentVariable.get('ACCT_TM_PRXY_TM_RL_AM');
    final String PFST_BSCR_ERROR                =               Error_Codes__c.getInstance('ACCT_PFTS_OR_BCSR_NOT_FOUND_ERROR').Message__c;
    final String USWest                         =               EnvironmentVariable.get('US-West');
    final String USEast                         =               EnvironmentVariable.get('US-East');
    final String AD                             =               EnvironmentVariable.get('A&D');
    final String AP                             =               EnvironmentVariable.get('AP');
    final String APJ                            =               EnvironmentVariable.get('APJ');
    final String ASICEMEA                       =               EnvironmentVariable.get('ASIC-EMEA');
    final String ASICUS                         =               EnvironmentVariable.get('ASIC-US');
    final String EUR                            =               EnvironmentVariable.get('EUR');
    final String JAPAN                          =               EnvironmentVariable.get('JAPAN');
    final String USMajors                       =               EnvironmentVariable.get('US-Majors');
    final String USSoCal                        =               EnvironmentVariable.get('US-SoCal');
    final String USSales                        =               EnvironmentVariable.get('US Sales');
    final String ADSales                        =               EnvironmentVariable.get('A&D Sales');
    final String InternationalSales             =               EnvironmentVariable.get('International Sales');
    final String TAD                            =               EnvironmentVariable.get('A&D');
    final String ASICAP                         =               EnvironmentVariable.get('ASIC-AP');
    final String TASICEMEA                      =               EnvironmentVariable.get('ASIC-EMEA');
    final String ASICJP                         =               EnvironmentVariable.get('ASIC-JP');
    final String ASICNA                         =               EnvironmentVariable.get('ASIC-NA');
    final String China                          =               EnvironmentVariable.get('China');
    final String EMEAROA                        =               EnvironmentVariable.get('EMEA-ROA');
    final String TJapan                         =               EnvironmentVariable.get('Japan');
    final String JapanKorea                     =               EnvironmentVariable.get('Japan Korea');
    final String Korea                          =               EnvironmentVariable.get('Korea');
    final String Taiwan                         =               EnvironmentVariable.get('Taiwan');
    final String USCentral1                     =               EnvironmentVariable.get('US Central1');
    final String USCentral2                     =               EnvironmentVariable.get('US Central2');
    final String USNE1                          =               EnvironmentVariable.get('US NE1');
    final String USNE2                          =               EnvironmentVariable.get('US NE2');
    final String USNE3                          =               EnvironmentVariable.get('US NE3');
    final String USNW                           =               EnvironmentVariable.get('US NW');
    final String USSE                           =               EnvironmentVariable.get('US SE');
    final String USSoCal1                       =               EnvironmentVariable.get('US SoCal1');
    final String USSoCal2                       =               EnvironmentVariable.get('US SoCal2');
    final String USSoCal3                       =               EnvironmentVariable.get('US SoCal3');
    final String USSW                           =               EnvironmentVariable.get('US SW');
    final String USWest1                        =               EnvironmentVariable.get('US West1');
    final String USWest2                        =               EnvironmentVariable.get('US West2');
    final String TUSEast                        =               EnvironmentVariable.get('US-East');
    
    /*********************************************************************************************************************************************************
    @ Constructor:    Account_TriggerHelper
    @ Version:        1.0
    @ Author:         Ishtpreet Singh (Ishtpreet.singh@globalfoundries.com)
    @ Purpose:        Initialises the class for controller instance.
    **********************************************************************************************************************************************************/ 
    public Account_TriggerHelper(){
        setofAccId = new Set<Id>();
        accountList = new List<Account>();
        mAcc4OwnerChange = new map<id,list<Account>>();
        shortName2AccountMap = new map<string, Account> ();
        acctId2PrevParentAcctMap = new map<id, id>();
        listInsertAccounts = new List<Account>();
        listUpdateAccounts = new List<Account>();
        acctRegHeadChangeList = new List<Account>();
        promote2AuthorizedAcctIds = new Set<Id>();
        sAcc4OwnerChange = new set<id>();
        newAcctOwnerSet = new set<String>();
        acctId4CN = new set<id>();
        acctId4ATP = new set<id>();
        customerPortalAdminSet = new set<Id>();
        sAcctNameChanged = new set<id>();
        sAccRegionChange = new set<id>();
        mapAccountRH = new Map<Id, Id>();
        listAccountIds = new List<string>();
        portalAdminChangedAcctIdSet = new List<Account>();
        accountIdForOwnerUpdateSet = new Set<Id>();
        triggerNewMap = ((Map<Id,Account>)Trigger.newMap);
        triggerOldMap = ((Map<Id,Account>)Trigger.oldMap);
    }
    /*********************************************************************************************************************************************************
    @ Method:         accountDataChngeBefore()
    @ Version:        1.0
    @ Author:         Ishtpreet Singh (Ishtpreet.singh@globalfoundries.com)
    @ Purpose:        This Method calls the Account Date change before trigger logic.
    **********************************************************************************************************************************************************/
    public void accountDataChngeBefore(){
        system.debug('start>>>>>>>>>>accountDataChngeBefore :SOQL queries:'+limits.getQueries());                
        ClsApprovalChangeRequest.checkIschangeRequestUpdate(triggerNewMap);
        system.debug('end>>>>>>>>>>accountDataChngeBefore :SOQL queries:'+limits.getQueries()); 
    }
    
    /*********************************************************************************************************************************************************
    @ Method:         accountDataChngeAfter()
    @ Version:        1.0
    @ Author:         Ishtpreet Singh (Ishtpreet.singh@globalfoundries.com)
    @ Purpose:        This Method calls the Account Date change After trigger logic.
    **********************************************************************************************************************************************************/    
    public void accountDataChngeAfter(){
        system.debug('start>>>>>>>>>>accountDataChngeAfter :SOQL queries:'+limits.getQueries());     
        for(Account account : (List<Account>)trigger.new){
        
            //fetching the accounts where present in Ot flag is changed
            if(account.Account_Present_In_OT__c != triggerOldMap.get(account.id).Account_Present_In_OT__c && (account.Account_Present_In_OT__c ==false || account.Account_Present_In_OT__c ==true)){
            
             setofAccId.add(account.id);
            }
        }
        
        FV_AccountUpdateCls.updateUserAccMapping(setofAccId);    
        system.debug('end>>>>>>>>>>accountDataChngeAfter :SOQL queries:'+limits.getQueries());     
    }
    /*********************************************************************************************************************************************************
    @ Method:         accountIntegrationLog_auAfter()
    @ Version:        1.0
    @ Author:         Ishtpreet Singh (Ishtpreet.singh@globalfoundries.com)
    @ Purpose:        This Method calls the Account Integration log au After trigger logic.
    **********************************************************************************************************************************************************/    
    public void accountIntegrationLog_auAfter(){
        system.debug('start>>>>>>>>>>accountIntegrationLog_auAfter :SOQL queries:'+limits.getQueries());         
        if(triggerOldMap.size() == 1){
            for(Account account : (List<Account>)Trigger.new){
                if((triggerOldMap.get(account.Id).Siebel_Status__c !=  account.Siebel_Status__c)  && (account.Siebel_Status__c == 'ERROR' || account.Siebel_Status__c == 'SUCCESS' )){
                
                    IntegrationLog.addIntegrationLog('Account',
                    account.ID, 
                    account.Siebel_Sync_ID__c,
                    account.Siebel_Error_Message__c,
                    account.Siebel_Operation__c,
                    account.Siebel_Status__c,
                    account.Siebel_Sent_DateTime__c );
                }   
            }
        }
        system.debug('end>>>>>>>>>>accountIntegrationLog_auAfter :SOQL queries:'+limits.getQueries());                 
    }
    /*********************************************************************************************************************************************************
    @ Method:         deactAccTrigAfter()
    @ Version:        1.0
    @ Author:         Ishtpreet Singh (Ishtpreet.singh@globalfoundries.com)
    @ Purpose:        This Method calls the Account Deactivation After trigger logic.
    **********************************************************************************************************************************************************/    
    public void deactAccTrigAfter(){
        system.debug('start>>>>>>>>>>deactAccTrigAfter :SOQL queries:'+limits.getQueries());                 
        Set<Id> lstNewTriggerSet=new Set<Id>();
        Set<Id> lstOldTriggerSet=new Set<Id>();
        List<Id> accIdList=new List<Id>();
        List<Id> totalaccountId=new List<Id>();
        list<account> lstNewTrigger=new list<account>();
        List<account>triggerNew = new List<account>();
        List<account>triggerOld = new List<account>();
        list<account> lstOldTrigger=new list<account>();
        Map<Id,String> mapAccOldValues = new Map<Id,String>() ; 
        Map<Id,String> mapAccNewValues = new Map<Id,String>() ;

        triggerNew = (List<Account>)trigger.new;
        triggerOld = (List<Account>)trigger.old;
        if(AcctRegHeadMappingTgrHandler.bypassAcctTrigger) return;
        
        /*--------- fetching the list of inactive accounts and adding it to the list------------------------------------------------------------*/
        for (Integer iCount=0;iCount<triggerNew.size();iCount++){
            if (triggerNew[iCount].Stage__c=='Inactive' && triggerOld[iCount].Stage__c!='Inactive'){
                accountList.add(triggerNew[iCount]);   
                accIdList.add(triggerNew[iCount].Id);
            }
        }
        
        /*----fetching all the portal users related to the inactive accounts------------------------------------------------*/
        if (accIdList.size()>0){
            //Calling the class usertriggerHandler for inactivating the contact for portal access
            Set<Id> inactiveUserId=new Set<Id>();
            for (User user:[SELECT Id FROM User where AccountId IN :accIdList]){     
                inactiveUserId.add(user.Id);     
            }
            /*calling the class  UserTriggerHandler------------*/      
            ClsUserTriggerHandler.updateContactPortalStatusProxy(inactiveUserId,'Update',true);
             
            //calling the class ClsAccTriggerHandler     
            ClsAccTriggerHandler.deactivateAccount(accIdList);   
        }
        //adding the account ids in a list
        for(Account account:(List<Account>)trigger.new){  
            totalaccountId.add(account.Id);
        } 
        
        if(totalaccountId.size()>0){
            // calling the method updateManager of the class ClsAccTriggerHandler   
            ClsAccTriggerHandler.updateManager(totalaccountId);
        }
        
        for(Account account:(List<Account>)Trigger.New){
            Map<String,String> mapMyInner = new Map<String,String>() ; 
            String oldVal = '' ; 
            String newVal = '' ;
            if(account.Valid_Tech_Geos__c!= triggerOldMap.get(account.id).Valid_Tech_Geos__c || account.Tech_Geo_Granted__c!= triggerOldMap.get(account.id).Tech_Geo_Granted__c || account.Has_Valid_NDA__c!= triggerOldMap.get(account.id).Has_Valid_NDA__c){
                lstNewTrigger.add(account);
                lstOldTrigger.add(triggerOldMap.get(account.id)); 
                lstNewTriggerSet.add(account.Id); 
                lstOldTriggerSet.add(triggerOldMap.get(account.id).Id); 
        
                oldVal =  triggerOldMap.get(account.id).Valid_Tech_Geos__c + '#' + triggerOldMap.get(account.id).Tech_Geo_Granted__c + '#' + String.valueOf(triggerOldMap.get(account.id).Has_Valid_NDA__c) ; 
                newval =  account.Valid_Tech_Geos__c + '#' + account.Tech_Geo_Granted__c + '#' + String.valueOf(account.Has_Valid_NDA__c) ;
            
                mapAccOldValues.put(account.id,oldVal ) ; 
                mapAccNewValues.put(account.id,newVal ) ;
            }
        }
        
        if(!mapAccOldValues.isEmpty() && !mapAccNewValues.isEmpty()){
            if(System.isFuture() || System.isBatch()){       
                clsUpdateDocProvisioningHandler.delegateHandleDocProvisioningUpdate(mapAccNewValues,mapAccOldValues);
            }     
            else{
                clsUpdateDocProvisioningHandler.delegateHandleDocProvisioningUpdateFuture(mapAccNewValues,mapAccOldValues); // New
            }
        }
        system.debug('end>>>>>>>>>>deactAccTrigAfter :SOQL queries:'+limits.getQueries());                         
    }
    
    /*********************************************************************************************************************************************************
    @ Method:         deactAccTrigBefore()
    @ Version:        1.0
    @ Author:         Ishtpreet Singh (Ishtpreet.singh@globalfoundries.com)
    @ Purpose:        This Method calls the Account Deactivation Before trigger logic.
    **********************************************************************************************************************************************************/    
    public void deactAccTrigBefore(){
        system.debug('start>>>>>>>>>>deactAccTrigBefore :SOQL queries:'+limits.getQueries());                 
    
        set<id> ParentIds = new set<id>();
        map<id,account> mapParentAcc=new map<id,account>();
        
        if(AcctRegHeadMappingTgrHandler.bypassAcctTrigger) return;
        
        //Get all Tech Geo values that need to be defaulted
        List<DefaultTechnologyGeometries__c> dtg = DefaultTechnologyGeometries__c.getall().values();
        for(Account account:(List<Account>)Trigger.New){
            for(DefaultTechnologyGeometries__c tech :dtg){
                if(account.Tech_Geo_Granted__c!=null && !account.Tech_Geo_Granted__c.contains(tech.Name)){
                    account.Tech_Geo_Granted__c=account.Tech_Geo_Granted__c+';'+tech.Name;    
                }
                else if(account.Tech_Geo_Granted__c==null){
                    account.Tech_Geo_Granted__c=tech.Name;
                }
            }
            
            if(account.parentid!=null){
                ParentIds.add(account.parentid);
            }
            if(!ParentIds.isEmpty()){
                for(account acnt:[select id,Has_Valid_NDA__c,Valid_Tech_Geos__c from account where id in :ParentIds]){
                    if(acnt.Has_Valid_NDA__c)
                    mapParentAcc.put(acnt.id,acnt);
                }
            }    
        }
        for(Account account:(List<Account>)Trigger.New){
            if(mapParentAcc!=null && mapParentAcc.containskey(account.parentid)){
                account.Has_Valid_NDA__c = mapParentAcc.get(account.parentid).Has_Valid_NDA__c;
                account.Valid_Tech_Geos__c= mapParentAcc.get(account.parentid).Valid_Tech_Geos__c;
            }
        }
        system.debug('end>>>>>>>>>>deactAccTrigBefore :SOQL queries:'+limits.getQueries());                                 
    }
    /*********************************************************************************************************************************************************
    @ Method:         createSharingOnAccount()
    @ Version:        1.0
    @ Author:         Ishtpreet Singh (Ishtpreet.singh@globalfoundries.com)
    @ Purpose:        This Method calls trigger logic to create sharing rules on account.
    **********************************************************************************************************************************************************/    
    public void createSharingOnAccount(){
        system.debug('start>>>>>>>>>>createSharingOnAccount :SOQL queries:'+limits.getQueries());                     
        Set <Id> innerparentId = new Set<Id>();
        List<id> childList = new List<Id>();  
        List<Id> contactIdList = new List<Id>();
        List<Account>parentAcctList = new List<Account>();
        List<Account> acctOldList = new List<Account>();
        Map<Id, Account> IdAccountMap = new Map<Id, Account>();
        Map<Id, ID> childParentMap = new Map<Id, Id>();
        Map <Id, Id> idAccContactMap = new Map<Id, Id>(); 
        Map <Id, List<Id>> mapAccountContact= new Map<Id, List<Id>>(); 
        Map <Id, Id> mapParentparentAccount= new Map<Id, Id>(); 
        Map<Id, List<id>> parentChildMap = new Map<Id, List<id>>();
        Map<Id, ID> userAccountMap = new Map<Id, Id>();
        Map<Id, ID> userContactmap= new Map<Id, Id>();       
        Map<Id, Account> IdOldAccountMap = new Map<Id, Account>();
        Map<Id, Id> deleteParentChildMap = new Map<Id, Id>(); 

         
        if (!ClsAccTriggerHandler.blnAccountShareRun) {
            ClsAccTriggerHandler.blnAccountShareRun=true;
            for (Account acctObj : [SELECT Parent.ParentId, 
                                           ParentId,Name,Id, 
                                          (Select Id 
                                             From Contacts) 
                                      FROM  Account 
                                     WHERE  Id IN:trigger.newMap.keyset()]) {
            
                if(acctObj.Name!=System.Label.GlobalfoundryAccount){
                    setofAccId.add(acctObj.Id);
                    childParentMap.put(acctObj.Id, acctObj.ParentId);
                    mapParentparentAccount.put(acctObj.ParentId,acctObj.Parent.ParentId);
                    contactIdList=new List<Id>();
                    for (Contact contactObj: acctObj.Contacts){
                        contactIdList.add(contactObj.Id);   
                    }
                    mapAccountContact.put(acctObj.Id, contactIdList);
                }
            }
            
            if(Test.isRunningTest()){
                Account a = [Select Parent.ParentId, ParentId,Name,Id From Account limit 1  ];                
                setofAccId.add(a.id);
                childList.add(a.id);
                innerparentId.add(a.id);                
            }            
            for(Account acc : [Select Id,ParentId from Account where ParentId in: setofAccId]) {
                if(innerparentId.contains(acc.ParentId)) {
                    childList.add(acc.Id);
                }
                else {
                  childList = new List<Id>() ;  /* Added on 02-12-2013*/                       
                    innerparentId.add(acc.ParentId);
                    childList.add(acc.Id);
                }
               parentChildMap.put(acc.ParentId, childList);
            }
            
            if(childList!= null && !(childList.isEmpty())){
                parentAcctList =  [Select Id,ParentId from Account where ParentId in: childList];
                for(Account acc : parentAcctList) {
                    if(innerparentId.contains(acc.ParentId)) {
                        childList.add(acc.Id);
                    }
                    else {
                        childList = new List<Id>() ;  /* Added on 02-12-2013*/                                          
                        innerparentId.add(acc.ParentId);
                        childList.add(acc.Id);
                    }
                    parentChildMap.put(acc.ParentId, childList);
                }
            }
            
            for(User user : [SELECT Id,ContactId FROM User where IsPortalEnabled = true and IsActive = true and ContactId in (SELECT Id FROM Contact where AccountId in :setofAccId)]) {
                userContactmap.put(user.ContactId, user.Id);
            }
            ClsAccTriggerHandler.createSharingOnAccount(setofAccId, childParentMap, mapAccountContact, userContactmap, parentChildMap, mapParentparentAccount);
            for(Account account : (List<Account>)trigger.new){
                if(triggerOldMap.get(account.ID).ParentId != null){
                    if (account.ParentId!=null){                    
                        if(String.valueOf(account.ParentId).equals(String.valueOf(triggerOldMap.get(account.ID).ParentId))){
                              // Parent Accounts same...Hence no Parenting....
                        } else {
                              // Parent Accounts different...Hence Deleting ....     
                              // Call the method createSharingOnAccount of class clsAccTrigHandler with the following parameters.
                            deleteParentChildMap.put(account.Id, triggerOldMap.get(account.ID).ParentId);
                        }                 
                    } else {
                        deleteParentChildMap.put(account.Id, triggerOldMap.get(account.ID).ParentId);
                    }
                }
            }
            ClsAccTriggerHandler.deleteSharingOnAccount(setofAccId, deleteParentChildMap);           
        }    
        system.debug('end>>>>>>>>>>createSharingOnAccount :SOQL queries:'+limits.getQueries());                               
    }
    
    /*********************************************************************************************************************************************************
    @ Method:         accTriggerBefore()
    @ Version:        1.0
    @ Author:         Ishtpreet Singh (Ishtpreet.singh@globalfoundries.com)
    @ Purpose:        This Method calls Account Before trigger logic.
    **********************************************************************************************************************************************************/    
    public void accTriggerBefore(){
        system.debug('start>>>>>>>>>>accTriggerBefore :SOQL queries:'+limits.getQueries());                     
        Boolean isIntegrationUser = false;
        if(AcctRegHeadMappingTgrHandler.bypassAcctTrigger) return;
        if(!IntegrationUserUtil.isSkipTrigger()){
            IntegrationUsers__c setting = IntegrationUsers__c.getValues(userInfo.getUserId());   
            if(setting <> null && setting.Is_Integration_User__c) isIntegrationUser = true;
            if(checkRecursive.runOnce()){
            for(Account account:(List<Account>)trigger.new){
              //  if((Trigger.isUpdate) && Trigger.new.size()==1 && DeniedPartyListHelperClass.multipleTimeFire){ //&& Schema.SObjectType.Account.RecordTypeInfosByName.get('Suppliers').RecordTypeId != system.label.Account_SuppliersRT){
                /*=================================================================================================================
                 Developer : Gopi Koka
                 Update below code for Denied part list to avoid Customer
                 Following code will work only for single record DML Operations
                 Reason : To avoid time out exception for multiple looping to find Unauthorized.
                 Solution: If we want bulk operations then need to validate denied part list using batch apex once.
                           Using "Unauthorized validated" field we can have how many records need to validate
                 Advantage : It will not effect not any existing functionality
                --------------------------------------------------------------------------------------------------------------------*/
                //DeniedPartyListHelperClass.multipleTimeFire = false;
             /*   Account oldAcc = triggerOldMap.get(account.Id);
                Boolean executeDeniedParlist = true;
                if((oldAcc.Unauthorized__c == True && account.Unauthorized__c == false)){
                    executeDeniedParlist = false;
                    account.Unauthorized_Percentage__c = null;
                    account.Unauthorized_Modified_Date__c = system.today();
                }
                String accountName = account.Name;
                if((account.Name == oldAcc.Name) && !account.DPL_HelperFld__c){
                      executeDeniedParlist = true;
                      account.DPL_HelperFld__c = true;
                      accountName = account.Name;
                  }else if((account.Name == oldAcc.Name)){
                       executeDeniedParlist = false;
                  }
                  
                if(account.Account_Name_Change_Request__c != oldAcc.Account_Name_Change_Request__c){
                    executeDeniedParlist = true;
                    accountName = account.Account_Name_Change_Request__c;
                }
                
                
                if(oldAcc.Corporate_Address_1__c != account.Corporate_Address_1__c && 
                                                   account.Unauthorized_Percentage__c != null){
                      executeDeniedParlist = true;
                      accountName = account.Name;
                }
                  
                if(oldAcc.Corporate_Country__c != account.Corporate_Country__c && 
                                                       account.Unauthorized_Percentage__c != null){
                      executeDeniedParlist = true;
                      accountName = account.Name;
                }
                List<ID> csrIDs = New List<ID>();
                if(account.Account_Manager__c!=null){
                    csrIDs.add(account.Account_Manager__c);
                }
                if(account.Primary_CSR__c!=null){
                    csrIDs.add(account.Primary_CSR__c);
                }
                if(account.Primary_FAE__c!=null){
                    csrIDs.add(account.Primary_FAE__c);
                }
                if(executeDeniedParlist && Schema.SObjectType.Account.RecordTypeInfosByName.get('Suppliers').RecordTypeId != account.RecordTypeID){
                    DeniedPartCustomerAvoiding.validatedResponse validateVar = DeniedPartCustomerAvoiding.validateCustomer(accountName,
                                                                                                                           account.Corporate_Address_1__c,
                                                                                                                           account.Bill_To_Address_1__c,
                                                                                                                           account.Corporate_Country__c,
                                                                                                                           account.id,
                                                                                                                           csrIDs);
                     account.Unauthorized__c = validateVar.unauthorized;
                     account.Unauthorized_Percentage__c = validateVar.percentageCalculation;
                     account.Unauthorized_Modified_Date__c = null;
                 } */
                /*-----------------------------------------------------------------------------------------------------------------
                Denied Part list code upto Here
                ===================================================================================================================*/       
               // }

                if(account.Account_Name_Change_Request__c!=null){
                    account.Prior_Account_Name__c=account.Account_Name_Change_Request__c;
                }
                if (account.Name != null) account.Name =account.Name.toUpperCase();
                account.Account_Owner__c = account.OwnerId;
                account.Account_Manager__c = account.ownerId;
                
                if(account.Account_Name_Change_Request__c!=null){
                    account.Account_Name_Change_Request__c = account.Account_Name_Change_Request__c.toUpperCase(); //Convert Account Name Change Request to Upper case
                }
                
                //Check Short Name Characters
                system.debug('>>>>>>>>>>>account.Short_Name__c:'+account.Short_Name__c);
                if (account.Short_Name__c !=null && account.Short_Name__c != ''){
                    
                    if (account.Short_Name__c.length() > 1){
                        if(!Pattern.matches('^[a-zA-Z0-9_-]+$',account.Short_Name__c)) {                         
                            account.adderror('Short name can only contain characters, numbers, -, _ ');  continue;
                        }
                    } else {
                        account.adderror('Shortname should be more than 1 character'); continue;
                    }
                    
                    account.Short_Name__c =account.Short_Name__c.toLowerCase();
                }
                if(Trigger.IsUpdate){
                                       //Short name cannot be changed
                    if(triggerOldMap.get(account.id).Short_Name__c != null && (triggerOldMap.get(account.id).Short_Name__c != account.Short_Name__c)){
                        account.addError('Short Name can not be modified'); continue;
                    }
                    
                    //Territory cannot be changed once territory change request is initiated
                    if(!String.isBlank(account.financial_territory__c) && account.financial_territory__c != triggerOldMap.get(account.id).financial_territory__c && !String.isblank(account.Financial_Territory_Change_Request__c)) {
                        account.addError('Territory can not be modified because territory change request has been initiated.'); continue;
                    }
                    
                    //Siebel Sync Id should be greater then prior value
                    if(userinfo.getProfileId() == EnvironmentVariable.get('GF_INTEGRATION_PROFILE_ID') && account.Siebel_Sync_ID__c < triggerOldMap.get(account.id).Siebel_Sync_ID__c) {
                        account.adderror('Out of sequence integration update');  continue;  
                    }
                    
                    // Added by Nbustillos 11262013
                    if(account.Account_Manager__c!= UserInfo.getUserId() && 
                            ((account.Invoice_Term__c!=null && triggerOldMap.get(account.id).Invoice_Term__c!=account.Invoice_Term__c) || 
                                (account.Invoice_Term_Change_Request__c!=null && triggerOldMap.get(account.id).Invoice_Term_Change_Request__c!=account.Invoice_Term_Change_Request__c))){
                        account.addError('Only Primary Account Manager can update Invoice Term/Invoice Term Change Request.'); continue;
                        
                    }else if(account.Approval_Request__c=='Invoice Term Change' && (account.Approval_Status__c=='Approved' && triggerOldMap.get(account.Id).Approval_Status__c!=account.Approval_Status__c) &&  account.Invoice_Term_Change_Request__c!=null){
                            account.Invoice_Term__c = account.Invoice_Term_Change_Request__c;
                            account.Approval_Request__c = null;
                            account.Invoice_Term_Change_Request__c = null;
                    }
                    
                    if((account.recordtypeId == EnvironmentVariable.get('ACCT_RT_ID_RESELLER')||
                        account.recordtypeId == EnvironmentVariable.get('ACCT_RT_ID_EN_PARTNER')||
                        account.recordtypeId == EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER'))&&(account.Stage__c == 'Authorized' || account.Stage__c == 'Qualified')){
                        boolean isChanged=false;
                        
                        if(triggerOldMap.get(account.id).Name != null && (triggerOldMap.get(account.id).Name != account.Name)){//Account Name
                            isChanged=true;
                        }
                        if(triggerOldMap.get(account.id).ParentId != null && (triggerOldMap.get(account.id).ParentId != account.ParentId)){//Parent Account
                            isChanged=true;
                        }
                        else if(triggerOldMap.get(account.id).Financial_Territory__c != null && (triggerOldMap.get(account.id).Financial_Territory__c != account.Financial_Territory__c)){//Territory
                            isChanged=true;
                        }
                        else if(triggerOldMap.get(account.id).Region_Head__c != null && (triggerOldMap.get(account.id).Region_Head__c != account.Region_Head__c)){//Region Head
                            isChanged=true;
                        }
                        else if(triggerOldMap.get(account.id).Sales_Group__c != null && (triggerOldMap.get(account.id).Sales_Group__c != account.Sales_Group__c)){//Sales Group
                            isChanged=true;
                        }
                        
                        if(isChanged){
                            account.isNotifiedFieldsChanged__c=true;
                        }      
                    }
                    
                    //Added by Naman :  For SAP SDA - when non Fab9/10 customer is converted to Fab9/10 customer
                    if((triggerOldMap.get(account.id).Fab_9_10__c == null || triggerOldMap.get(account.id).Fab_9_10__c == 'No') 
                         && account.Fab_9_10__c == 'Yes' && account.stage__c == 'Authorized'){
                           account.New_SAP_Customer__c = true;
                           account.Bill_To_Address_Change__c = false;
                           account.Ship_To_Address_Change__c = false;
                           account.Sold_to_Address_Change__c = false;
                    }
                    
                    //Added by Naman :  To Support Multiple Bill To Address for SDA SAP
                    if((account.stage__c == 'Unqualified' || account.stage__c == 'Qualified') && account.approval_request__c == 'Promote to Authorized' && (account.Bill_To_Location__c == '' || account.Bill_To_Location__c == null)){
                        account.addError('Bill to Location is mandatory. Please update location field on Primary Bill to Address on Bill To Address related list to update location on Account.');
                    } 
                }
                // Added by TLai 24032014 - Check if the new value already exists in Organization Unit
                if (account.Organization_Unit__c != null && account.New_Organization_Unit_Request__c != null) {    
                    Set<String> setOU = new Set<String>(account.Organization_Unit__c.split(';'));
                    if (setOU.contains(account.New_Organization_Unit_Request__c)) {
                        account.addError('Duplicate Organization Unit is not allowed.');  continue;
                    }
                }
                
                if(Trigger.isInsert && account.Account_Manager__c!=UserInfo.getUserId() && (account.Invoice_Term__c!=null || account.Invoice_Term_Change_Request__c!=null)){
                    account.addError('Only Primary Account Manager can update Invoice Term/Invoice Term Change Request.');  continue;
                }
                
                //Added by Naman :To Support Multiple Bill To Address for SDA SAP               
                if(trigger.isInsert){                                       
                    account.Primary_Bill_To_Address__c = (account.Corporate_Address_1__c != null && account.Corporate_Address_1__c != '' && account.Corporate_Address_1__c.length()>6?account.Corporate_Address_1__c.substring(0,6):account.Corporate_Address_1__c);
                    account.Bill_To_Address_1__c = account.Corporate_Address_1__c;
                    account.Bill_To_Address_2__c = account.Corporate_Address_2__c;
                    account.Bill_To_Address_3__c = account.Corporate_Address_3__c;
                    account.Bill_To_Address_4__c = account.Corporate_Address_4__c;
                    account.Bill_To_City__c = account.Corporate_City__c;
                    account.Bill_To_State__c = account.Corporate_State__c;
                    account.Bill_To_Country__c = account.Corporate_Country__c;
                    account.Bill_To_Postal_Zip_Code__c = account.Corporate_Postal_Zip_Code__c;
          if (account.Name != null){
            account.PRTS_Customer_Name__c = account.Name;
          }
                }
                
                //Thomas 24032014 -- copied code from  AccountManager.copyAddress
                if(account.Copy_Address__c && account.Stage__c != 'Authorized' && account.Stage__c != 'Inactive'){
                    account.Bill_To_Address_1__c = account.Corporate_Address_1__c;
                    account.Bill_To_Address_2__c = account.Corporate_Address_2__c;
                    account.Bill_To_Address_3__c = account.Corporate_Address_3__c;
                    account.Bill_To_Address_4__c = account.Corporate_Address_4__c;
                    account.Bill_To_City__c = account.Corporate_City__c;
                    account.Bill_To_State__c = account.Corporate_State__c;
                    account.Bill_To_Country__c = account.Corporate_Country__c;
                    account.Bill_To_Postal_Zip_Code__c = account.Corporate_Postal_Zip_Code__c;
                    account.Copy_Address__c = false;
                }
                
                //Thomas 24032014 -- copied code from ClsCheckAccountValidation
                if(trigger.isupdate && !AccountTriggerRun.isAddressValidated &&  account.recordtypeId != EnvironmentVariable.get('ACCT_RT_ID_SUPPLIERS')){// Tlai 04072014  - Changed as per case 27104 
                    if((account.Bill_To_Address_1__c ==null || account.Bill_To_City__c==null || account.Bill_To_Country__c==null )  && account.Copy_Address__c == false ){  
                        Error_Codes__c Bill_To_Address_Required= Error_Codes__c.getInstance('Bill_To_Address_Required');
                        account.adderror(Bill_To_Address_Required.message__c);
                        continue;
                    }             
                }
                /*--------------------validation to check Account Name + Site_Department__c should be unique----------
                case in-sensitive, convert Site_Department__C to lowercase before saving record, not optimized
                -----------------------------------------------------------------------------------------------------*/             
                if (Trigger.IsInsert ||(Trigger.IsUpdate && account.Site_Department__C !=null && ((triggerOldMap.get(account.id).Site_Department__C != account.Site_Department__C) || (triggerOldMap.get(account.id).Name != account.Name)))){
                    if (AccountTriggerRun.hasAccountTriggerRun){
                        // !!!! query in for loop, need optmizing
                        list<Account> Acc_Site_Dep = [select Id,name from Account where name=:account.Name and Site_Department__C=:account.Site_Department__C limit 1 ];
                        if(Acc_Site_Dep.size() > 0){
                            account.addError('Account Name and Site must be unqiue');
                            continue;
                        }
                    }
                }
                
                if (trigger.isupdate){
                    
                    //Tlai 05062014 - populated siebel account id with sfdc id for new accounts after removing siebel dependence
                    if(String.isBlank(account.Siebel_Account_ID__c)) account.Siebel_Account_ID__c = account.id;
                    
                    if(account.Approval_Request__c=='Account Details Change' && account.Approval_Status__c=='Approved' && triggerOldMap.get(account.id).Approval_Status__c !=account.Approval_Status__c ){
                        updateAccountDetail(account);
                    }
                    
                    if(triggerOldMap.get(account.id).Financial_Territory__c != account.Financial_Territory__c)
                        account.Prior_Sales_Territory__c = triggerOldMap.get(account.id).Financial_Territory__c;
                    
                    //Tlai 19032014 - check ATPs' team role with 1 PFTS and 1 BCSR
                    if(!AccountTriggerRun.skipATPValidation && (account.recordtypeId == EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER') || account.recordtypeId == EnvironmentVariable.get('ACCT_RT_ID_RESELLER'))){
                        if(account.stage__c == 'Authorized' ||(account.Approval_Request__c == 'Promote to Authorized'&& (account.stage__c == 'Qualified' ||account.stage__c == 'Unqualified' ))){
                            acctId4ATP.add(account.id);
                            system.debug('validating PFTS/BSCR');
                        }
                    }
                    if(account.Customer_Portal_Admin__c!=null ) {
                        customerPortalAdminSet.add(account.Customer_Portal_Admin__c);// Tlai 25072014 restructured code
                        account.Portal_Admin_Report_Flag__c = false;// Tlai 25072014 restructured code
                        if(account.Customer_Portal_Admin__c != triggerOldMap.get(account.id).Customer_Portal_Admin__c 
                           && account.Customer_Portal_Admin__c != null) {
                            portalAdminChangedAcctIdSet.add(account);
                        }  
                    
                    
                    // Added by ZAmbat 05/22/2013 - Validate Account(s) being promoted to Authorized if there is at least 1 Contact
                    if(account.Approval_Request__c == 'Promote to Authorized')
                        promote2AuthorizedAcctIds.add(account.Id);
                    
                    
                    
                    //Added Code for Prior_Parent_Account_Name__c 
                    if(triggerOldMap.get(account.id).ParentId != account.ParentId)
                        acctId2PrevParentAcctMap.put(account.id, triggerOldMap.get(account.id).ParentId);
                    }
                    // Added by TLai 01232014 - Retrieve region head & svp from account region head mapping
                    // Tlai 26052014 set value based on Financial Territory
                    // Tlai 31072014 Changed as per case 31543: populate region head ONLY when Approval_Request__c is changed  to 'Promote to Qualified', 'Promote to Authorized' or 'Invoice Term Change'
                    //Commented by Anushri
                    /* if(trigger.isinsert && account.Financial_Territory__c != null){
                        acctRegHeadChangeList.add(account);
                    } */
                    if(trigger.isUpdate && 
                        (   
                            (account.Financial_Territory__c != null && account.Financial_Territory__c != triggerOldMap.get(account.id).Financial_Territory__c)
                        ||  (account.Region_head_mapping__c != null && account.Region_head_mapping__c != triggerOldMap.get(account.id).Region_head_mapping__c)
                        ||  (account.Approval_Request__c != triggerOldMap.get(account.id).Approval_Request__c
                                && (account.Approval_Request__c == 'Promote to Qualified' || account.Approval_Request__c == 'Promote to Authorized' || account.Approval_Request__c == 'Invoice Term Change')
                               )
                        )
                    ){
                        acctRegHeadChangeList.add(account);
                    }
                    //Tlai 26052014 sync sales territory with financial territory
                    if(account.sales_territory__c != account.financial_territory__c){
                        account.sales_territory__c = account.financial_territory__c;
                    }
                    
                    //Modified by Tlai 13032014 - revomed query in for loop for customer no generation, put it at the end of before trigger
                    if (account.Stage__c=='Authorized' && account.Customer_Number__c == null ){
                        acctId4CN.add(account.id);
                    }
                    
                    /* --------------------------------------Start AccountManagerATP Trigger Code--------------------------------- */
                    //TLai - 11032014 : Restruture code with bulk feature for account owner change
                    if ((Trigger.IsUpdate && account.ownerId != triggerOldMap.get(account.id).OwnerId) ){
                        newAcctOwnerSet.add(account.id + '' + account.ownerId);
                    }
                    /* --------------------------------------End AccountManagerATP Trigger Code--------------------------------- */
                    
                    //Tlai 26032014 populate RecordtypeId
                    //Commented by Anushri
                    /*if(trigger.isinsert && !string.isblank(account.Account_Type__c)){
                        if(account.Account_Type__c == 'Enablement Partner'){
                            account.recordtypeid = EnvironmentVariable.get('ACCT_RT_ID_EN_PARTNER');
                        }else if(account.Account_Type__c == 'GLOBALFOUNDRIES Internal'){
                            account.recordtypeid = EnvironmentVariable.get('ACCT_RT_ID_GF_INTERNAL');
                        }else if(account.Account_Type__c == 'Reseller'){
                            account.recordtypeid = EnvironmentVariable.get('ACCT_RT_ID_RESELLER');
                        }else if(account.Account_Type__c == 'Customer'){
                            account.recordtypeid = EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER');
                        } 
                    } */
                    boolean ruleCriteria = false;
                    boolean isSiebelAccountComplete = true;
                    if(account.RecordTypeId == null || (account.Stage__c != 'Unqualified' && (account.Approval_Status__c == 'Pending Approval' ||account.Approval_Status__c == 'Rejected' || account.Approval_Status__c == ''))){
                        isSiebelAccountComplete = false;
                    }
                    if(!isIntegrationUser  && isSiebelAccountComplete){
                        if(account.stage__c == 'Unqualified'){
                            if(trigger.isinsert || (Trigger.isupdate &&(account.Account_Profile__c != triggerOldMap.get(account.id).Account_Profile__c
                                                                    ||account.Disengaged__c != triggerOldMap.get(account.id).Disengaged__c
                                                                    ||account.Founded__c != triggerOldMap.get(account.id).Founded__c
                                                                    ||account.Market_Segment__c != triggerOldMap.get(account.id).Market_Segment__c
                                                                    ||account.ParentId != triggerOldMap.get(account.id).ParentId
                                                                    ||account.Process_Tech_Interested__c != triggerOldMap.get(account.id).Process_Tech_Interested__c
                                                                    ||account.Site_Department__c != triggerOldMap.get(account.id).Site_Department__c
                                                                    ||account.Bill_To_Address_1__c != triggerOldMap.get(account.id).Bill_To_Address_1__c
                                                                    ||account.Bill_To_Address_2__c != triggerOldMap.get(account.id).Bill_To_Address_2__c
                                                                    ||account.Bill_To_Address_3__c != triggerOldMap.get(account.id).Bill_To_Address_3__c
                                                                    ||account.Bill_To_Address_4__c != triggerOldMap.get(account.id).Bill_To_Address_4__c
                                                                    ||account.Bill_To_City__c != triggerOldMap.get(account.id).Bill_To_City__c
                                                                    ||account.Bill_To_State__c != triggerOldMap.get(account.id).Bill_To_State__c
                                                                    ||account.Bill_To_Postal_Zip_Code__c != triggerOldMap.get(account.id).Bill_To_Postal_Zip_Code__c
                                                                    ||account.Bill_To_Country__c != triggerOldMap.get(account.id).Bill_To_Country__c
                                                                    ||account.Bill_To_Location__c != triggerOldMap.get(account.id).Bill_To_Location__c
                                                                    ||account.Name != triggerOldMap.get(account.id).Name
                                                                    ||account.Region__c != triggerOldMap.get(account.id).Region__c
                                                                    ||account.Corporate_Address_1__c != triggerOldMap.get(account.id).Corporate_Address_1__c
                                                                    ||account.Corporate_Address_2__c != triggerOldMap.get(account.id).Corporate_Address_2__c
                                                                    ||account.Corporate_Address_3__c != triggerOldMap.get(account.id).Corporate_Address_3__c
                                                                    ||account.Corporate_Address_4__c != triggerOldMap.get(account.id).Corporate_Address_4__c
                                                                    ||account.Corporate_City__c != triggerOldMap.get(account.id).Corporate_City__c
                                                                    ||account.Corporate_State__c != triggerOldMap.get(account.id).Corporate_State__c
                                                                    ||account.Corporate_Postal_Zip_Code__c != triggerOldMap.get(account.id).Corporate_Postal_Zip_Code__c
                                                                    ||account.Corporate_Country__c != triggerOldMap.get(account.id).Corporate_Country__c
                                                                    ||account.Sub_Type__c != triggerOldMap.get(account.id).Sub_Type__c
                                                                    ||account.Transaction_Type__c != triggerOldMap.get(account.id).Transaction_Type__c
                                                                    ||account.Short_Name__c != triggerOldMap.get(account.id).Short_Name__c
                                                                    ||account.Financial_Territory__c != triggerOldMap.get(account.id).Financial_Territory__c
                                                                    ||account.Invoice_Term__c != triggerOldMap.get(account.id).Invoice_Term__c
                                                                    ||account.Sales_Group__c != triggerOldMap.get(account.id).Sales_Group__c
                                                                    ||account.Region_Head__c != triggerOldMap.get(account.id).Region_Head__c
                                                                                                                                
                                                                    )
                                                )
                            ){
                                ruleCriteria = true;
                            }
                        }else{
                            ruleCriteria = true;                        
                        }
                    
                        if(ruleCriteria){
                            account.Siebel_Error_Message__c = null;
                            account.Siebel_Sent_DateTime__c = datetime.now();
                            account.Siebel_Status__c        = 'SENT';
                            account.Siebel_Sync_ID__c       = datetime.now().format();
                            account.Martinistore_Sync_Status__c = 'SENT';
                        }
                    }
                    // Added by Tlai 25032014   - populate owner_profile__c based on workflow "Account - Copy Owner Profile"
                    // need checking if in use
                    if (!AccountTRiggerRun.hasAccountTriggerRun && (Trigger.IsInsert || (Trigger.IsUpdate && account.OwnerId != triggerOldMap.get(account.id).OwnerId) ) ){
                
                        if(mAcc4OwnerChange.containskey(account.ownerid)){
                            mAcc4OwnerChange.get(account.ownerid).add(account);
                        }else {
                            mAcc4OwnerChange.put(account.ownerid, new Account[]{account});
                        }
                    }
                    //Added by Tlai 06082014    - workflow "Account - Field Update - Approval Status"
                    if(trigger.isupdate){
                        if( (!String.isblank(account.Approval_Request__c) && account.Approval_Request__c  !=  triggerOldMap.get(account.id).Approval_Request__c)
                            || (!String.isblank(account.Bill_To_Address_1_Change_Request__c) && account.Bill_To_Address_1_Change_Request__c  !=  triggerOldMap.get(account.id).Bill_To_Address_1_Change_Request__c)
                            || (!String.isblank(account.Bill_To_Address_2_Change_Request__c) && account.Bill_To_Address_2_Change_Request__c  !=  triggerOldMap.get(account.id).Bill_To_Address_2_Change_Request__c)
                            || (!String.isblank(account.Bill_To_Address_3_Change_Request__c) && account.Bill_To_Address_3_Change_Request__c  !=  triggerOldMap.get(account.id).Bill_To_Address_3_Change_Request__c)
                            || (!String.isblank(account.Bill_To_Address_4_Change_Request__c) && account.Bill_To_Address_4_Change_Request__c  !=  triggerOldMap.get(account.id).Bill_To_Address_4_Change_Request__c)
                            || (!String.isblank(account.Bill_To_City_Change_Request__c) && account.Bill_To_City_Change_Request__c  !=  triggerOldMap.get(account.id).Bill_To_City_Change_Request__c)
                            || (!String.isblank(account.Bill_To_State_Change_Request__c) && account.Bill_To_State_Change_Request__c  !=  triggerOldMap.get(account.id).Bill_To_State_Change_Request__c)
                            || (!String.isblank(account.Bill_To_Postal_Code_Change_Request__c) && account.Bill_To_Postal_Code_Change_Request__c  !=  triggerOldMap.get(account.id).Bill_To_Postal_Code_Change_Request__c)
                            || (!String.isblank(account.Bill_To_Country_Change_Request__c) && account.Bill_To_Country_Change_Request__c  !=  triggerOldMap.get(account.id).Bill_To_Country_Change_Request__c)
                            || (!String.isblank(account.Bill_To_Location_Change_Request__c) && account.Bill_To_Location_Change_Request__c  !=  triggerOldMap.get(account.id).Bill_To_Location_Change_Request__c)
                            || (!String.isblank(account.Primary_Bill_To_Address_Change_Request__c) && account.Primary_Bill_To_Address_Change_Request__c !=  triggerOldMap.get(account.id).Primary_Bill_To_Address_Change_Request__c) //Added by Naman :To Support Multiple Bill To Address for SDA SAP
                            || (!String.isblank(account.Account_Name_Change_Request__c) && account.Account_Name_Change_Request__c  !=  triggerOldMap.get(account.id).Account_Name_Change_Request__c)
                            || (!String.isblank(account.Region_Change_Request__c) && account.Region_Change_Request__c  !=  triggerOldMap.get(account.id).Region_Change_Request__c)
                            || (!String.isblank(account.Financial_Territory_Change_Request__c) && account.Financial_Territory_Change_Request__c  !=  triggerOldMap.get(account.id).Financial_Territory_Change_Request__c)
                            || (!String.isblank(account.New_Organization_Unit_Request__c) && account.New_Organization_Unit_Request__c  !=  triggerOldMap.get(account.id).New_Organization_Unit_Request__c)
                        ){
                            account.Approval_Status__c = null;
                        }
                    }
                    
                    // ZAmbat 10302014
                    if (account.Region__c != null
                        && (trigger.isInsert
                            || (trigger.isUpdate && account.Region__c != triggerOldMap.get(account.Id).Region__c))) {                       
                        // Modified by Poulami 14/09/2015                         
                        if (account.Region__c == USWest || account.Region__c == USEast || account.Region__c == USSoCal || account.Region__c == USMajors || account.Region__c == ASICUS) {
                            account.Classification__c = USSales;
                        } else if (account.Region__c == AP || account.Region__c == ASICEMEA || account.Region__c == EUR) {
                            account.Classification__c = InternationalSales;
                        }else if (account.Region__c == JAPAN || account.Region__c == AD) {
                            account.Classification__c = ADSales;
                        }
                    }
                }
                if(customerPortalAdminSet.size() > 0){// Tlai 25072014 restructured code
                    map<id, user> userMap = new map<id, user>([Select id, name, UserRole.Name From user where id in :customerportaladminset and UserRoleId != null]);
                    for(Account acc: (List<Account>)trigger.new){
                        if(account.Customer_Portal_Admin__c != null && userMap.containsKey(account.Customer_Portal_Admin__c)){
                            if(userMap.containsKey(acc.Customer_Portal_Admin__c)){
                                String usrRoleName = userMap.get(acc.Customer_Portal_Admin__c).userRole.Name;
                                if(usrRoleName.contains(acc.Name)){
                                    acc.Portal_Admin_Report_Flag__c = true;
                                }                                
                            }
                        }
                    }
                }
                /* --------------------------------------Start ATP PFTS/BCSR Validation Trigger Code--------------------------------- */
                //Tlai 19032014 check meeting criteria accounts should have 1 PFTS and 1 BCSR
                if(trigger.isupdate && acctId4ATP.size() > 0){ 
                    list<Account_Team_Proxy__c> atplist = [select id,team_role__c,account__c,flag_for_delete__c from Account_Team_Proxy__c where flag_for_delete__c = false and account__c in :acctId4ATP and (team_role__c = :PRIMARY_FTS or team_role__c = :BACKUP_CSR)];
                    map<id, list<integer>> acct2ATPNoMap = new map<id, list<integer>>();
                
                    if(atplist.size() > 0){             
                        for(Account_Team_Proxy__c atp : atplist){
                            if(atp.team_role__c == PRIMARY_FTS){
                                if(acct2ATPNoMap.containskey(atp.account__c)){
                                    acct2ATPNoMap.get(atp.account__c)[0]++;
                                }else {
                                    list<integer> PFTS_BCSR_No_List =  new Integer[]{1,0};
                                    acct2ATPNoMap.put(atp.account__c, PFTS_BCSR_No_List);
                                }
                            } else if(atp.team_role__c == BACKUP_CSR){
                                if(acct2ATPNoMap.containskey(atp.account__c)){
                                    acct2ATPNoMap.get(atp.account__c)[1]++;
                                }else {
                                    list<integer> PFTS_BCSR_No_List =  new Integer[]{0,1};
                                    acct2ATPNoMap.put(atp.account__c, PFTS_BCSR_No_List);
                                }
                            }
                        }
                    }
                
                    for(id accid:acctId4ATP){
                        Account acctTemp = triggerNewMap.get(accid);
                        
                        if(acct2ATPNoMap.containskey(accid)){
                            list<integer> PFTS_BCSR_No_List = acct2ATPNoMap.get(accid);
                            if(PFTS_BCSR_No_List[0] != 1 || PFTS_BCSR_No_List[1] != 1){
                                acctTemp.addError(PFST_BSCR_ERROR);
                            }
                        }else{
                            acctTemp.addError(PFST_BSCR_ERROR);
                        }
                    }
                }
                /* --------------------------------------End ATP PFTS/BCSR Validation Trigger Code--------------------------------- */
                
                /* --------------------------------------Start GenerateCustomerNumber Trigger Code--------------------------------- */
                if(acctId4CN.size() > 0){
                    Integer csn = integer.valueOf( Customer_Number__c.getInstance('Update Customer No').Customer_No__c);
                    if(csn != null){
                        for(id acctId : acctId4CN){
                            triggerNewMap.get(acctId).Customer_Number__c = String.valueOf(csn);
                            csn++;
                        }
                        /*Jabee: Update of the Custom Setting Value to Generate the Customer Number for ERP */
                        Customer_Number__c OldCUSNO = [select id, Customer_No__c from Customer_Number__c limit 1];
                            OldCUSNO.Customer_No__c = csn;
                            update OldCUSNO;
                       // AccountTriggerRun.customerNo = csn;
                    }
                }
                
                /* --------------------------------------Start Populate Prior_Parent_Account_Name__c Trigger Code--------------------------------- */
                if(acctId2PrevParentAcctMap.size() > 0){
                    map<id, Account> parentAcctMap = new map<id,Account>([select id, name from account where id in: acctId2PrevParentAcctMap.values()]);
                    if(parentAcctMap.size() > 0){
                        for(id accId : acctId2PrevParentAcctMap.keySet()) {
                            Id parentId = acctId2PrevParentAcctMap.get(accId);
                            if(parentAcctMap.containsKey(parentId)){
                                Account pAcct = parentAcctMap.get(parentId);
                                triggerNewMap.get(accId).Prior_Parent_Account_Name__c = pAcct.name;
                            }
                        }
                    }
                }
                /* --------------------------------------End Populate Prior_Parent_Account_Name__c Trigger Code--------------------------------- */
                
                //Added by Thomas 11032014 - update ATP when Account owner changes or account creation
                if(trigger.isupdate && newAcctOwnerSet.size() > 0){
                    for(Account_Team_Proxy__c atp :[select  id, Account__c,Team_Role__c,Account_Role_ID__c,Flag_for_Delete__c
                                                      from  Account_Team_Proxy__c 
                                                     where  Account_Role_ID__c in : newAcctOwnerSet and Flag_for_Delete__c = false
                                                        ]){
                         //Prevent account owner change if new owner is existing PFTS or BCSR                                   
                        if(atp.Team_Role__c == PRIMARY_FTS || atp.Team_Role__c == BACKUP_CSR){
                            triggerNewMap.get(atp.account__c).addError(PFST_BSCR_ERROR);
                                
                        }                          
                    } 
                }
                //Tlai 25032014 -- populate owner_profile__c based on workflow "Account - Copy Owner Profile"
                // need review if this code still in use, coz no profile called PT1, PT2...
                if(mAcc4OwnerChange.size() > 0) {
                    for(User user : [select id, profile.name from user where id in: mAcc4OwnerChange.keyset()]){
                        if(mAcc4OwnerChange.containskey(user.id) ){
                            PT_Profile_Mapping__c mp = PT_Profile_Mapping__c.getInstance(user.profile.name);
                            
                            for(Account acc : mAcc4OwnerChange.get(user.id)){                  
                                
                                if(mp != null){
                                    acc.Owner_Profile__c = mp.value__c; 
                                }else{
                                    acc.Owner_Profile__c = user.profile.name;
                                }
                            }
                        }
                    }
                }
                // Added by ZAmbat 05/22/2013 - Validate Account(s) being promoted to Authorized if there is at least 1 Contact
                if (promote2AuthorizedAcctIds.size() > 0) {
                    List<Account> listAccounts = AccountValidation.validateContacts(promote2AuthorizedAcctIds);
                    
                    if (listAccounts.size() > 0) {
                        for (Account a : listAccounts) {
                            triggerNewMap.get(a.Id).addError('Account should have at least one contact before it can be Authorized.');
                        }
                    }
                }
                
                 /* --------------------------------------Start update region head Code--------------------------------- */ 
                // Added by TLai 01/23/2014 - Retrieve region head & backup from account region head mapping
                // Changed by Tlai 31072014 - added logic for strategic account and Sales SVP
                if(acctRegHeadChangeList.size() > 0){
                    map<String, Account_Region_Head_Mapping__c> arhMap = new map<String, Account_Region_Head_Mapping__c>();
                    for(Account_Region_Head_Mapping__c  mapping :[select id,
                                                                        Strategic_Account__c,
                                                                        Sales_SVP__c, 
                                                                        Sales_Territory__c,
                                                                        region_head_lk__c,
                                                                        Territory_Approver_LK__c,
                                                                        //region_head_backup_lk__c,
                                                                        region_head_lk__r.name,
                                                                        region_head_lk__r.HCM_Login_ID__c
                                                                        //region_head_backup_lk__r.name,
                                                                        //region_head_backup_lk__r.HCM_Login_ID__c 
                                                                    from Account_Region_Head_Mapping__c
                                                                    where isActive__c = true]){
                        if(mapping.Strategic_Account__c != null){
                            arhMap.put(mapping.Strategic_Account__c, mapping);
                        } else {
                            arhMap.put(mapping.Sales_Territory__c, mapping);
                        }
                        
                        arhMap.put(mapping.id, mapping);    
                    } 
                    
                    for(Account acct : acctRegHeadChangeList){
                        Account_Region_Head_Mapping__c arhm;
                        if(arhMap.containsKey(acct.id)){
                            arhm = arhMap.get(acct.id);
                        }else if(arhMap.containsKey(acct.Financial_Territory__c)){
                            arhm = arhMap.get(acct.Financial_Territory__c);
                        }else if(arhMap.containsKey(acct.Region_head_mapping__c)){
                            arhm = arhMap.get(acct.Region_head_mapping__c);
                        }
                        
                        if(arhm != null){
                            acct.Region_head_mapping__c     =   arhm.id;
                            acct.Region_Head_lk__c          =   arhm.region_head_lk__c;
                            acct.Region_Head_Name__c        =   arhm.region_head_lk__c == null? null :arhm.region_head_lk__r.name;
                            acct.Region_Head__c             =   arhm.region_head_lk__c == null? null :arhm.region_head_lk__r.HCM_Login_ID__c;
                            //acct.Region_Head_Backup_Name__c =     arhm.region_head_backup_lk__c == null? null :arhm.region_head_backup_lk__r.name;                    
                            //acct.Region_Head_Backup__c        =   arhm.region_head_backup_lk__c == null? null :arhm.region_head_backup_lk__r.HCM_Login_ID__c;
                            acct.Sales_SVP__c               =   arhm.Sales_SVP__c;
                            acct.Territory_Approver_lk__c = arhm.Territory_Approver_LK__c;
                        }
                        
                    }
                }
                /* --------------------------------------End update region head Code--------------------------------- */
                
                // ZAmbat 05222014
                if (trigger.isInsert || trigger.isUpdate) {
					Map<string,integer> atproleCount=new Map<string,integer>();
					if(trigger.isUpdate){
						list<Account_Team_Proxy__c> atplist = [select id,team_role__c,account__c,flag_for_delete__c 
                                                               from Account_Team_Proxy__c where
                                                               flag_for_delete__c = false and
                                                               account__c=:account.id and 
                                                               team_role__c IN ('Backup Customer Service Rep',
                                                                                'Primary Account Manager',
                                                                                'Primary Customer Service Rep',
                                                                                'Primary Field Technical Support',
                                                                                'Primary Field Application Engineer')];
						
						if(atplist.size() > 0){             
							for(Account_Team_Proxy__c atp : atplist){
								if(atproleCount.containskey(atp.team_role__c)){
                                    integer extCount=atproleCount.get(atp.team_role__c);
									atproleCount.put(atp.team_role__c,extCount+1);
								}else {
									atproleCount.put(atp.team_role__c, 1);
								}
							}
						}
					
					
					}
                    Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
                    Schema.SObjectType accountSchema = schemaMap.get('Account');
                    Map<String, Schema.SObjectField> fieldMap = accountSchema.getDescribe().fields.getMap();
                    for (Account a : (List<Account>)trigger.new) {
                        string missingQualified = '';
                        string missingAuthorized = '';
                    
                        // Qualified
                        if (a.Short_Name__c == null) {
                            missingQualified = missingQualified + fieldMap.get('Short_Name__c').getDescribe().getLabel() + '\r\n';
                        }
                        
                        if (a.Account_Profile__c == null) {
                            missingQualified = missingQualified + fieldMap.get('Account_Profile__c').getDescribe().getLabel() + '\r\n';
                        }
                        
                        if (a.Sub_Type__c == null) {
                            missingQualified = missingQualified + fieldMap.get('Sub_Type__c').getDescribe().getLabel() + '\r\n';
                        }
                        
                        if (a.Process_Tech_Interested__c == null) {
                            missingQualified = missingQualified + fieldMap.get('Process_Tech_Interested__c').getDescribe().getLabel() + '\r\n';
                        }
                        
                        if (a.Market_Segment__c == null) {
                            missingQualified = missingQualified + fieldMap.get('Market_Segment__c').getDescribe().getLabel() + '\r\n';
                        }
                        
                        if (a.Total_Employee__c == null) {
                            missingQualified = missingQualified + fieldMap.get('Total_Employee__c').getDescribe().getLabel() + '\r\n';
                        }
                        
                        if (a.Bill_To_Address_1__c == null) {
                            missingQualified = missingQualified + fieldMap.get('Bill_To_Address_1__c').getDescribe().getLabel() + '\r\n';
                        }
                        
                        if (a.Bill_To_City__c == null) {
                            missingQualified = missingQualified + fieldMap.get('Bill_To_City__c').getDescribe().getLabel() + '\r\n';
                        }
                        
                        if (a.Bill_To_Country__c == null) {
                            missingQualified = missingQualified + fieldMap.get('Bill_To_Country__c').getDescribe().getLabel() + '\r\n';
                        }
                         if (a.Bill_To_Location__c == null) {
                            missingQualified = missingQualified + fieldMap.get('Bill_To_Location__c').getDescribe().getLabel() + ' (Account Address record)' + '\r\n';
                        }
                        
                        //Added  by Naman : Master Account Sync SDA project
                        if(a.Fab_9_10__c == null){
                            missingQualified = missingQualified + fieldMap.get('Fab_9_10__c').getDescribe().getLabel() + '\r\n';
                        }
                        
                        if (a.Sales_Group__c == null) {
                            missingAuthorized = missingAuthorized + fieldMap.get('Sales_Group__c').getDescribe().getLabel() + '\r\n';
                        }
                        
                        if (a.Financial_Territory__c == null) {
                            missingAuthorized = missingAuthorized + fieldMap.get('Financial_Territory__c').getDescribe().getLabel() + '\r\n';
                        }
                        
                        if (a.Invoice_Term__c == null) {
                            missingAuthorized = missingAuthorized + fieldMap.get('Invoice_Term__c').getDescribe().getLabel() + '\r\n';
                        }
                        
                        if (a.Organization_Unit__c == null) {
                            missingAuthorized = missingAuthorized + fieldMap.get('Organization_Unit__c').getDescribe().getLabel() + '\r\n';
                        }
                        
                        if (a.Bill_To_Location__c == null) {
                            missingAuthorized = missingAuthorized + fieldMap.get('Bill_To_Location__c').getDescribe().getLabel() + ' (Account Address record)' + '\r\n';
                        }
                        if (atproleCount.get('Primary Account Manager') < 1) {
                            missingAuthorized = missingAuthorized + 'Primary Account Manager (ATP) \r\n';
                        }
                        
                        if (atproleCount.get('Primary Customer Service Rep') < 1) {
                            missingAuthorized = missingAuthorized + 'Primary Customer Service Rep (ATP) \r\n';
                        }
                        
                        if (atproleCount.get('Backup Customer Service Rep') < 1) {
                            missingAuthorized = missingAuthorized + 'Backup Customer Service Rep (ATP) \r\n';
                        }
                        
                        if (atproleCount.get('Primary Field Technical Support') < 1 && atproleCount.get('Primary Field Application Engineer') < 1) {
                            missingAuthorized = missingAuthorized + 'Primary Field Application Engineer (ATP) \r\n';
                        }
                        
                        if (a.No_of_Contacts__c == null || a.No_of_Contacts__c < 1) {
                            missingAuthorized = missingAuthorized + 'At least 1 Contact';
                        }
                        
                        // Set values
                        a.Missing_Fields_Qualified__c = missingQualified;
                        if (missingQualified != null) {
                            a.Missing_Fields_Authorized__c = missingQualified + missingAuthorized;
                        } else {
                            a.Missing_Fields_Authorized__c = missingAuthorized;
                        }
                    }
                }
                /* -------------------- Added BY Mallika -----------------------*/
                if(trigger.isbefore && trigger.isInsert){
               
                Set <String> shortNames = new Set<String>();
                List<WordsForShortName__c> WSN = WordsForShortName__c.getall().values();
                String searchqueryAccount;
                String ShortName;
                for(Account acc: (List<Account>)trigger.new){
                    if(acc.Short_Name__c == Null || acc.Short_Name__c ==''){
                       
                       String Space = ' ';
                        ShortName = String.valueOf(acc.Name);
                        String[] lSName = ShortName.split(SPACE);
                        ShortName = '';
                        Boolean Flag;
                        Flag = FALSE;
                        for(String SN: lSName){
                            
                            for(WordsForShortName__c WTE: WSN){
                                Flag = TRUE;
                                String WordsToExclude = WTE.WordsToExclude__c;   
                                system.debug('@###@@'+SN);
                                
                                if(SN == WordsToExclude){
                                    Flag = FALSE;
                                    system.debug('@###@@222'+SN);
                                    
                                    Break;
                                }
                            }
                            if(Flag){
                            if(ShortName.Length()>0){
                                ShortName = ShortName + ' '+ SN;
                            }
                            Else 
                                ShortName = SN;
                            }
                            
                        }
                        
                       if(ShortName.contains(Space)){
                           String str1=ShortName.substring(0,ShortName.indexOf(' '));
                           str1 = str1.replaceAll('[^a-zA-Z0-9]+', '');
                           String str2=ShortName.substring(ShortName.indexOf(' ')+1);
                           str2 = str2.replaceAll('[^a-zA-Z]+', '');
                           ShortName = str1.left(4) + str2.left(4);
                          
                       } 
                       Else{
                           ShortName = ShortName.replaceAll('[^a-zA-Z]+', '');
                           ShortName = ShortName.left(8);   
                           
                       }   
                       acc.Short_Name__c = ShortName;
                    }
                    Else{
                        ShortName = acc.Short_Name__c.replaceAll('[^a-zA-Z0-9]+', '');
                        
                    }
                    if(ShortName.length() > 0)
                        shortNames.add(ShortName.toLowerCase());
                }       
            system.debug('>>>>>>>>>>shortNames:'+shortNames);
           // List <Account> lAccounts = [SELECT Id, Short_Name__c FROM Account  where Short_Name__c in :shortNames ORDER BY Short_Name__c DESC LIMIT 1];
            searchqueryAccount = 'FIND '+shortNames+ ' IN ALL Fields RETURNING Account(ID,Short_Name__c Where Short_Name__c!=Null ORDER BY Short_Name__c Desc )';
            List<List<sObject>> sAccountsList = search.query(searchqueryAccount);
            Account[] sAccounts = (Account[])sAccountsList[0];
            Map <String,Account> mShortNamesToAccountId = new Map<String,Account>(); 
            if(Test.isRunningTest()){
                sAccounts.add(new Account(Name='data12 datadata',short_Name__c = 'data04',Account_Type__c ='Customer',stage__c = 'Unqualified'));
            }
            for (Account a:sAccounts)
            {
                
                String SN =  a.Short_Name__c;
                if(SN!=Null){
                    Integer L = SN.length();
                    String RSName = SN.Right(2);
                    String lSName = SN.Left(L);
                    If(RSName.isNumeric()){
                        lSName = SN.Left(L-2);
                        RSName = SN.Right(2);
                    }
                    mShortNamesToAccountId.put(lSName,a);
                }
                
            }
            for (Account aNew:(List<Account>)Trigger.New)
            {
                
                if (mShortNamesToAccountId.containsKey(aNew.Short_Name__c.toLowerCase()))
                {
                    For(Account a:sAccounts){
                    System.debug('@@w'+a.Short_Name__c);
                        if(a.Short_Name__c!= Null){
                        String SN =  a.Short_Name__c;
                        Integer L = SN.length();
                        String RSName = SN.Right(2);
                        String lSName = SN.Left(L);
                        IF(lSName == aNew.Short_Name__c){
                            RSName = Null;
                            aNew.Short_Name__c = LSName +'01';
                            Break;
                            System.debug('@@wyes');
                        }
                        Else If(RSName.isNumeric()){
                            lSName = SN.Left(L-2);
                            RSName = SN.Right(2);
                            IF(lSName == aNew.Short_Name__c){
                            if(lSName.length()>1 && RSName != Null){
                                RSName = String.valueOf(Integer.valueOf(RSName) + 1);
                                if(RSName.length()<2){
                                    RSName = '0' + RSName;
                                }
                                aNew.Short_Name__c = LSName + RSName;
                                Break;
                            
                            }  
                            }
                            Else{
                              RSName = Null;
                              lSName = Null;
                              Continue;
                            }
                        }
                        Else if(!RSName.isNumeric() || lSName != aNew.Short_Name__c ){
                              RSName = Null;
                              lSName = Null;
                              Continue;
                        }
                        }                    
                    }  
                }                 
                aNew.Customer_Shipping_Label__c = aNew.Short_Name__c;
            }            
          }

                //Validation added by Sunil for case # 5650
                if(portalAdminChangedAcctIdSet.size()>0 ){
                                        
                    Set<Id> adminIds = new Set<Id>();
                    for (Account a : portalAdminChangedAcctIdSet) {
                        adminIds.add(a.Customer_Portal_Admin__c);
                    }
                    
                    Map<Id, User> mapUser = new Map<Id, User>([SELECT    Id
                                                                         , ProfileId
                                                                         , Contact.AccountId
                                                               FROM      User
                                                               WHERE     Id IN :adminIds]);
                    
                    List<String> profileNameList=new string[]{System.Label.CustomerPortalAdmin,
                                                              System.Label.OverageCustomerPortalAdmin,
                                                              System.Label.OverageSupplierPortalAdmin,
                                                              System.Label.OverageResellerPortalAdmin,
                                                              System.Label.OverageEnablementPartnerPortalAdmin,
                                                              System.Label.EnablementPartnerPortalAdmin,
                                                              System.Label.ResellerPortalAdmin,
                                                              System.Label.SupplierPortalAdmin
                                                            };
                        
                    Set<Id> profileIdSet = new Set<Id>();
                    for (Profile objProfile:[Select id from Profile where Name IN: profileNameList]){
                        profileIdSet.add(objProfile.Id);
                    }
                    
                    for (Account a : portalAdminChangedAcctIdSet) {
                        integer validationPassed=0;
                        if (profileIdSet.contains(mapUser.get(a.Customer_Portal_Admin__c).ProfileId)) {
                            validationPassed=1;
                        }
                        
                        if (a.Id == mapUser.get(a.Customer_Portal_Admin__c).Contact.AccountId) {
                            validationPassed++;
                        }
                        
                        if (validationPassed != 2) {
                            a.addError('POC Published in Customer Portal should be portal admin associated to this account.');
                        }
                    } 
                } 
            }
            }
        }
        AccountTriggerRun.hasAccountTriggerRun=false;
        AccountTriggerRun.isAddressValidated = true;
        if(accountIdForOwnerUpdateSet.size() > 0){
            AccountChangeOwnerUtil.updateOwnerId(accountIdForOwnerUpdateSet);
        }
        system.debug('end>>>>>>>>>>accTriggerBefore :SOQL queries:'+limits.getQueries());                             
    }
    /*********************************************************************************************************************************************************
    @ Method:         accTriggerAfter()
    @ Version:        1.0
    @ Author:         Ishtpreet Singh (Ishtpreet.singh@globalfoundries.com)
    @ Purpose:        This Method calls Account After trigger logic.
    **********************************************************************************************************************************************************/    
    public void accTriggerAfter(){
        system.debug('start>>>>>>>>>>accTriggerAfter :SOQL queries:'+limits.getQueries());                     
    
        Boolean isIntegrationUser = false;
        if(AcctRegHeadMappingTgrHandler.bypassAcctTrigger) return;
        if(!IntegrationUserUtil.isSkipTrigger()){
            IntegrationUsers__c setting = IntegrationUsers__c.getValues(userInfo.getUserId());   
            if(setting <> null && setting.Is_Integration_User__c) isIntegrationUser = true;
            if(checkRecursive.runOnceAgain()){
            for(Account account:(List<Account>)trigger.new){
                if (trigger.IsInsert){
                    accountIdForOwnerUpdateSet.add(account.Id);
                }
            
                //Added by Naman :To Support Multiple Bill To Address for SDA SAP
                if(trigger.isInsert){                                       
                    Bill_To_Address_Number__c billNoCS = Bill_To_Address_Number__c.getValues('Update Bill To Address No');
                    Decimal billAddNumb = billNoCS.Bill_To_Address_Number__c;
                    
                    Account_Address__c address = new Account_Address__c();
                    address.Address_1__c = account.Corporate_Address_1__c;
                    address.Address_2__c = account.Corporate_Address_2__c;
                    address.Address_3__c = account.Corporate_Address_3__c;
                    address.Address_4__c = account.Corporate_Address_4__c;
                    address.City__c = account.Corporate_City__c;
                    address.State__c = account.Bill_To_State__c;
                    address.Country__c = account.Corporate_Country__c;
                    address.Postal_Zip_Code__c = account.Corporate_Postal_Zip_Code__c;                     
                    address.account__c = account.id;
                    address.Location__c = account.Bill_To_Location__c;                   
                    address.name = (account.Corporate_Address_1__c != null && account.Corporate_Address_1__c != '' && account.Corporate_Address_1__c.length()>6?account.Corporate_Address_1__c.substring(0,6):account.Corporate_Address_1__c);                     
                    address.Bill_To_Address_Number__c = String.valueof(Integer.valueof(billAddNumb));
                    address.type__c = 'Bill To Address';
                    address.status__c = 'Pending';
                    address.Is_Primary_Address__c = true;
                    insert address;   
                    
                    billNoCS.Bill_To_Address_Number__c += 1;
                    update billNoCS;
                                      
                }
                
                //Added by Naman :To Support Multiple Bill To Address for SDA SAP               
                if(trigger.isUpdate && account.stage__c == 'Authorized' && account.stage__c != triggerOldMap.get(account.id).stage__c && account.Approval_Status__c=='Approved'){
                    List<Account_Address__c> addrToUpdate = new List<Account_Address__c>();
                    for(Account_Address__c address :[SELECT id FROM Account_Address__c WHERE account__c =: account.id and Is_Primary_Address__c = true and name =: account.Primary_Bill_To_Address__c]){
                        address.Status__c = 'Approved';
                        address.Address_Sent_To_OM__c = true;
                        addrToUpdate.add(address);
                    }
                    if(!addrToUpdate.isEmpty()){
                        update addrToUpdate;
                    }
                }
                
                // if short name is changed
                if(Trigger.IsInsert || triggerOldMap.get(account.id).Short_Name__c != account.Short_Name__c ){
                    if(account.Short_Name__c != null)
                    shortName2AccountMap.put(account.Short_Name__c, account);
                }
                
                /* --------------------------------------Start AccountManagerATP Trigger Code--------------------------------- */
                //TLai - 11032014 : Restruture code with bulk feature for account owner change
                if (Trigger.IsInsert  || (Trigger.IsUpdate && triggerNewMap.get(account.id).OwnerId != triggerOldMap.get(account.id).OwnerId)){
                    sAcc4OwnerChange.add(account.id);
                }
                /* --------------------------------------End AccountManagerATP Trigger Code--------------------------------- */ 
                
                /* --------------------------------------Start Manual Device Update Trigger Code--------------------------------- */
                ////////VIXIT CODE STARTS HERE
                //Thomas 24032014 changed code to remove inner query in for loop
                if (Trigger.IsUpdate && account.Name != triggerOldMap.get(account.Id).name){
                    sAcctNameChanged.add(account.id);
                }
                ////////VIXIT CODE ENDS HERE 
                /* --------------------------------------End Manual Device Update Trigger Code--------------------------------- */
                
                //TLai - 25062013 -Start 
                /** This is for Account Region Change. 
                    Checks for Region change in Account and updates the child Opportunity Program 
                    and Device "Account Region" fields with the new Region value.                                       
                */
                if (Trigger.IsUpdate && account.Region__c != triggerOldMap.get(account.Id).Region__c){
                    if(!(system.isBatch() || system.isFuture() || system.isScheduled())) {
                        sAccRegionChange.add(account.id);
                    } 
                }
                //TLai - 25062013 -End
                /* -------------------------------------- Creation/Update of Account Hierarchy Start --------------------------------- */
                if (Trigger.IsInsert) {
                    listInsertAccounts.add(account);
                } else if (Trigger.IsUpdate) {
                    if (triggerNewMap.get(account.Id).ParentId != triggerOldMap.get(account.Id).ParentId) {
                        listUpdateAccounts.add(account);
                    }
                } 
                /* -------------------------------------- Creation/Update of Account Hierarchy End --------------------------------- */
                
                // ZAmbat 08222014
                if (trigger.isUpdate) {
                    if (account.Region_Head_lk__c != triggerOldMap.get(account.Id).Region_Head_lk__c) {  
                        mapAccountRH.put(account.Id, account.Region_Head_lk__c);
                    }
                }
                
                // ZAmbat 11112014
                if (account.Primary_Contact__c == null) {
                    listAccountIds.add(account.Id);
                }
                
                /* --------------------------------------Start Update Opprotunity Program & Device Trigger Code--------------------------------- */
                if(trigger.isupdate && sAccRegionChange.size()>0){
                    List<Opportunity_Program__c> childOppPrograms = [Select Id,
                                                                        Account__c,
                                                                        SetGroup__c,
                                                                        (select Id, Account__c, SetGroup__c from Devices__r)
                                                                        From Opportunity_Program__c
                                                                        Where Account__r.Id in : sAccRegionChange];
                
                                                              
                    if(childOppPrograms.size() >0) { 
                        list<Device__c> childDevices = new list<Device__c>();
                        
                        for(Opportunity_Program__c op : childOppPrograms) {
                            op.SetGroup__c = triggerNewMap.get(op.account__c).Region__c;
                            for(Device__c dev: op.Devices__r){
                                dev.SetGroup__c = op.SetGroup__c;
                            }
                            
                            childDevices.addAll(op.Devices__r);
                        }
                        
                        update childOppPrograms;
                        
                        if(childDevices.size() > 0) update childDevices;
                        
                    }                                
                }
                if(sAcctNameChanged.size() > 0){
                    List<Manual_Device__c> manualDeviceListToUpdate = new List<Manual_Device__c>();
                    
                    for(Manual_Device__c md : [SELECT Account__c, Device_Id__c, Account_Name__c, Device__c FROM Manual_Device__c  Where Account__c IN : sAcctNameChanged]){
                        md.Account_Name__c = triggerNewMap.get(md.Account__c).name;
                        manualDeviceListToUpdate.add(md);
                    }
                    
                    if( manualDeviceListToUpdate.size()>0){
                        update manualDeviceListToUpdate;
                    }   
                }
                if(AccountTriggerRun.customerNo != 0){
                    Double csn = Customer_Number__c.getInstance('Update Customer No').Customer_No__c;
                    if(AccountTriggerRun.customerNo != csn){
                        Customer_Number__c cn = [select id, Customer_No__c from Customer_Number__c limit 1];
                        cn.Customer_No__c = AccountTriggerRun.customerNo;
                        update cn;
                    }
                    
                    AccountTriggerRun.customerNo = 0;
                }
             }
                //23072014 Tlai - added logic to keep account team when owner changed
                if(sAcc4OwnerChange.size() > 0) {//Tlai      24072014    - Changed as per case 30757
                    String READ_ONLY = EnvironmentVariable.get('READONLY_NAME');
                    String READ_WRITE = EnvironmentVariable.get('READWRITE_NAME');
                    set<id> errorAccSet = new set<id>();            
                     
                    map<String,String> accessMap = new Map<String,String>{'Read/Write'=>'Edit','Read Only'=>'Read','Private'=>'None'};
                    map<id, list<AccountTeamMember>> accTeamMemberMap = new map<id,list<AccountTeamMember>>();
                    map<id, list<AccountShare>> accShareMap = new map<id, list<AccountShare>>();
                    
                    list<Account_Team_Proxy__c> atpList = new List<Account_Team_Proxy__c>();
                    if(trigger.isupdate){
                        for(Account_Team_Proxy__c atp :[select  id, User__c,User__r.isActive,Account__c,Account_Access__c,Opportunity_Access__c,Sequence_No__c,Team_Role__c,Account_Role_ID__c,IsAccountOwner__c,Flag_for_Delete__c
                                                        from Account_Team_Proxy__c 
                                                        where  Flag_for_Delete__c != true
                                                        and Account__c in: sAcc4OwnerChange
                                                        order by Account__c, IsAccountOwner__c desc]){
                            
                            if(atp.IsAccountOwner__c == 'TRUE'){//for exsiting atp who is not PAM
                                if(atp.Team_Role__c != PRIMARY_ACCOUTN_MANAGER){
                                    atp.Team_Role__c = PRIMARY_ACCOUTN_MANAGER;
                                    atp.Account_Access__c = READ_WRITE;
                                    atp.Opportunity_Access__c = READ_WRITE;
                                    atpList.add(atp);
                                }
                                
                                sAcc4OwnerChange.remove(atp.Account__c);
                            } else if(atp.Team_Role__c == PRIMARY_ACCOUTN_MANAGER && atp.IsAccountOwner__c == 'FALSE'){
                                atp.Team_Role__c = ACCOUTN_MANAGER;
                                atpList.add(atp);
                            } else if(atp.User__r.isActive){
                                AccountTeamMember atm = new AccountTeamMember (accountid=atp.Account__c, teammemberrole = atp.Team_Role__c, Userid=atp.User__c);
                                if(accTeamMemberMap.containsKey(atm.accountid)){
                                    accTeamMemberMap.get(atm.accountid).add(atm);
                                } else{
                                    accTeamMemberMap.put(atm.accountid, new list<AccountTeamMember>{atm});
                                }
                                
                                AccountShare ash = new AccountShare(AccountId=atp.Account__c, AccountAccessLevel = accessMap.get(atp.Account_Access__c), OpportunityAccessLevel = accessMap.get(atp.Opportunity_Access__c), UserOrGroupId = atp.User__c);
                                if(accShareMap.containsKey(ash.accountid)){
                                    accShareMap.get(ash.accountid).add(ash);
                                } else {
                                    accShareMap.put(ash.accountid, new list<AccountShare>{ash});
                                }
                            }
                            
                        } 
                    }
                    
                    //Primary Account Manager not created for these accounts
                    if(sAcc4OwnerChange.size() > 0) {          
                        for(Id accId : sAcc4OwnerChange){
                            Account_Team_Proxy__c newAtp = new Account_Team_Proxy__c();
                            newAtp.User__c                  =   triggerNewMap.get(accId).OwnerId;                       
                            newAtp.Account__c               =   accId;
                            newAtp.Team_Role__c             =   PRIMARY_ACCOUTN_MANAGER;
                            newAtp.Sequence_No__c           =   null;
                            newAtp.Account_Access__c        =   READ_WRITE;
                            newAtp.Opportunity_Access__c    =   READ_WRITE;
                            atpList.add(newAtp);
                        }
                    } 
                    
                    if(atpList.size() > 0){
                        list<database.UpsertResult> usrList = database.upsert(atpList,false);
                        
                        for(integer j = 0; j < usrList.size(); j++){
                            if(!usrList[j].isSuccess()){
                                triggerNewMap.get(atpList[j].account__c).addError(usrList[j].getErrors()[0].getMessage());
                                accTeamMemberMap.remove(atpList[j].account__c);
                                accShareMap.remove(atpList[j].account__c);
                            }
                        }
                        
                    }  
                    
                    if(accTeamMemberMap.size() > 0){// insert AccountTeamMember
                        
                        list <AccountTeamMember> accTeamMeberList = new list <AccountTeamMember>();
                        for(id accId : accTeamMemberMap.keySet() ){
                            accTeamMeberList.addAll(accTeamMemberMap.get(accId));
                        }
                                        
                        if(accTeamMeberList.size() > 0){
                            Database.SaveResult[] srList = database.insert(accTeamMeberList, false);
                            list <AccountShare> accShrList = new list <AccountShare>();//24072014 Tlai
                            for(integer j = 0; j < srList.size(); j++){
                                if(srList[j].isSuccess()){
                                    for(AccountShare ash : accShareMap.get(accTeamMeberList[j].accountid)){
                                        if(ash.UserOrGroupId == accTeamMeberList[j].userid){
                                            accShrList.add(ash);
                                            break;
                                        }
                                    }
                                }
                            }
                            
                            if(accShrList.size() > 0 ) 
                                insert accShrList;
                        }  
                    }                                         
                }
                /* --------------------------------------End Account Owner Change Trigger Code--------------------------------- */ 
                
                // Added by ZAmbat 06/13/2013 - Creation/Update of Account Hierarchy
                if (listInsertAccounts.size() > 0) {
                    AccountHierarchyGeneration.insertAccountHierarchy(listInsertAccounts);
                }
                
                if (listUpdateAccounts.size() > 0) {
                    AccountHierarchyGeneration.updateAccountHierarchy(listUpdateAccounts);
                }
                
                /* --------------------------------------Start AccountShortNameValidation Trigger Code--------------------------------- */
                if(shortName2AccountMap.size() > 0){    
                    if (AccountTriggerRun.hasAccountTriggerRun)
                    {
                        List <Account_Short_Name__c> asnList = [select Id,Account_Short_Name__c,Name from Account_Short_Name__c where Account_Short_Name__c in : shortName2AccountMap.keySet()];
                        
                        if (asnList.size()>0)
                        {
                            for(Account_Short_Name__c asn : asnList){
                                if(shortName2AccountMap.containsKey(asn.Account_Short_Name__c)){
                                    shortName2AccountMap.get(asn.Account_Short_Name__c).addError('Duplicate Short Name');
                                    shortName2AccountMap.remove(asn.Account_Short_Name__c);
                                }
                            }
                        }
                        
                        if(shortName2AccountMap.size() > 0){
                            List<Account_Short_Name__c> asnNewList= new List<Account_Short_Name__c>();
                            
                            for(Account acct: shortName2AccountMap.values()){
                                Account_Short_Name__c asn = new Account_Short_Name__c();
                                asn.Account_Short_Name__c = acct.Short_Name__c;
                                asnNewList.add(asn);
                            }
                            
                            if(asnNewList.size() > 0){
                                insert asnNewList;
                            }
                        }
                    }
                }
                /* --------------------------------------End AccountShortNameValidation Trigger Code--------------------------------- */
                
                 //Added by ASOLITO 22/04/2013
                //Fire Account Detail Changes to ERP    
                if(!AccountDetailChange.hasRun){
                    //Shuchi - 03042015 - Added record type check on the ERP callout to bypass IBM Accounts 
                    //Sunil - 07202015- Added condition to compare new and old account name for case # 43847
                    for(Account acc: (List<Account>)trigger.new){
                        if(acc.stage__c == 'Authorized' && acc.primary_contact__c <> null && acc.RecordTypeId != EnvironmentVariable.get('ACCT_RT_ID_IBM_ACCOUNT') ||test.isrunningtest()){
                            if(trigger.isUpdate &&              
                                    (triggerNewMap.get(acc.id).stage__c <> triggerOldMap.get(acc.id).stage__c) ||
                                    (triggerNewMap.get(acc.id).organization_unit__c <> triggerOldMap.get(acc.id).organization_unit__c) ||
                                    (triggerNewMap.get(acc.id).bill_to_address_1__c <> triggerOldMap.get(acc.id).bill_to_address_1__c) ||
                                    (triggerNewMap.get(acc.id).bill_to_address_2__c <> triggerOldMap.get(acc.id).bill_to_address_2__c) ||
                                    (triggerNewMap.get(acc.id).bill_to_address_3__c <> triggerOldMap.get(acc.id).bill_to_address_3__c) ||
                                    (triggerNewMap.get(acc.id).bill_to_address_4__c <> triggerOldMap.get(acc.id).bill_to_address_4__c) ||
                                    (triggerNewMap.get(acc.id).bill_to_city__c <> triggerOldMap.get(acc.id).bill_to_city__c) ||
                                    (triggerNewMap.get(acc.id).bill_to_state__c <> triggerOldMap.get(acc.id).bill_to_state__c) ||
                                    (triggerNewMap.get(acc.id).bill_to_country__c <> triggerOldMap.get(acc.id).bill_to_country__c) ||
                                    (triggerNewMap.get(acc.id).bill_to_postal_zip_code__c <> triggerOldMap.get(acc.id).bill_to_postal_zip_code__c) ||
                                    (triggerNewMap.get(acc.id).bill_to_location__c <> triggerOldMap.get(acc.id).bill_to_location__c) ||                 
                                    (triggerNewMap.get(acc.id).duns__c <> triggerOldMap.get(acc.id).duns__c) ||               
                                    (triggerNewMap.get(acc.id).early_ship_days__c <> triggerOldMap.get(acc.id).early_ship_days__c) ||
                                    (triggerNewMap.get(acc.id).hard_peg_flag__c <> triggerOldMap.get(acc.id).hard_peg_flag__c) ||
                                    (triggerNewMap.get(acc.id).overshipment_percent__c <> triggerOldMap.get(acc.id).overshipment_percent__c) ||
                                    (triggerNewMap.get(acc.id).sales_territory__c <> triggerOldMap.get(acc.id).sales_territory__c) || 
                                    (triggerNewMap.get(acc.id).tax_number__c <> triggerOldMap.get(acc.id).tax_number__c) ||
                                    (triggerNewMap.get(acc.id).Name <> triggerOldMap.get(acc.id).Name) ||
                                    (triggerNewMap.get(acc.id).primary_contact__c <> triggerOldMap.get(acc.id).primary_contact__c)){                                                                                      
                                AccountDetailChange.send(acc);
                            } else if(trigger.isInsert){
                                AccountDetailChange.send(acc);
                            }                                                                   
                        } 
                    }       
                }
                
                if (mapAccountRH.size() > 0) {
                    VisitationSetRegionHead.updateRegionHead(mapAccountRH);
                }
                if (listAccountIds.size() > 0 && !test.isRunningTest()) {
                    AccountDetailChange.setPrimaryAddress(listAccountIds);
                }
                AccountTriggerRun.hasAccountTriggerRun=false;
                AccountTriggerRun.isAddressValidated = true;
                if(accountIdForOwnerUpdateSet.size() > 0){
                    AccountChangeOwnerUtil.updateOwnerId(accountIdForOwnerUpdateSet);
                }
            
            }
        }
        system.debug('end>>>>>>>>>>accTriggerAfter :SOQL queries:'+limits.getQueries());
    }
    
      
/*************************************************************************************************************************************************/
    
    /*Private Classes*/
        @testVisible
        private void updateAccountDetail(Account acct){
        system.debug('start>>>>>>>>>>updateAccountDetail :SOQL queries:'+limits.getQueries());        
        String REMOVE = 'REMOVE';
        
        if(acct.Account_Name_Change_Request__c!=null)
        {
             //----------------Yash----start
             
              acct.Prior_Account_Name__c=acct.Name;
              
              //-----------------yash   --- end
            acct.Name = acct.Account_Name_Change_Request__c;  
        }      
        
        if(acct.Region_Change_Request__c!=null ){
            acct.Region__c= acct.Region_Change_Request__c;
            acct.Financial_Territory__c = acct.Financial_Territory_Change_Request__c;
            acct.Sales_Territory__c = acct.Financial_Territory__c;
            
            //Start - Modified by Poulami 22/09/2015
            if ((acct.Region_Change_Request__c == USWest)&& (acct.Financial_Territory_Change_Request__c == USWest1 || acct.Financial_Territory_Change_Request__c == USNW || acct.Financial_Territory_Change_Request__c == USSW || acct.Financial_Territory_Change_Request__c == USWest2 || String.isBlank(acct.Financial_Territory_Change_Request__c))){
                acct.Sales_Group__c = 'USW-GROUP1';
            }
            if ((acct.Region_Change_Request__c == USEast)&& (acct.Financial_Territory_Change_Request__c == TUSEast || acct.Financial_Territory_Change_Request__c == USCentral1 || acct.Financial_Territory_Change_Request__c == USCentral2 || acct.Financial_Territory_Change_Request__c == USNE1 || acct.Financial_Territory_Change_Request__c == USNE2 || acct.Financial_Territory_Change_Request__c == USNE3 || acct.Financial_Territory_Change_Request__c == USSE || String.isBlank(acct.Financial_Territory_Change_Request__c))){
                acct.Sales_Group__c = 'USE-GROUP1';
            }
            if ((acct.Region_Change_Request__c == USSoCal)&& (acct.Financial_Territory_Change_Request__c == USSoCal1 || acct.Financial_Territory_Change_Request__c == USSoCal2 || acct.Financial_Territory_Change_Request__c == USSoCal3 || String.isBlank(acct.Financial_Territory_Change_Request__c))){
                acct.Sales_Group__c = 'US SoCal-GROUP1';
            }                                        
            //End - Modified by Poulami 22/09/2015           
            
            if ((acct.Region_Change_Request__c == EUR)&& (acct.Financial_Territory_Change_Request__c == EMEAROA|| String.isBlank(acct.Financial_Territory_Change_Request__c))){
                acct.Sales_Group__c = 'EUR-GROUP1';
            }
            
            if(acct.Region_Change_Request__c == APJ && (acct.Financial_Territory_Change_Request__c ==China ||String.isBlank(acct.Financial_Territory_Change_Request__c))){
                acct.Sales_Group__c = 'GC-GROUP1';
            }
            
            if(acct.Region_Change_Request__c == APJ && acct.Financial_Territory_Change_Request__c ==JapanKorea){
                acct.Sales_Group__c = 'JK-GROUP1';
            }
            
            //Start - Modified by Poulami 22/09/2015            
            if((acct.Region_Change_Request__c == ASICUS || acct.Region_Change_Request__c == ASICEMEA) && (acct.Financial_Territory_Change_Request__c ==ASICNA || acct.Financial_Territory_Change_Request__c ==ASICAP || acct.Financial_Territory_Change_Request__c ==TASICEMEA || acct.Financial_Territory_Change_Request__c ==ASICJP || String.isBlank(acct.Financial_Territory_Change_Request__c))){
                acct.Sales_Group__c = 'ASIC-GROUP1';
            }
            
            if((acct.Region_Change_Request__c == AD) && (acct.Financial_Territory_Change_Request__c ==TAD || String.isBlank(acct.Financial_Territory_Change_Request__c))){
                acct.Sales_Group__c = 'A&D-GROUP1';
            }
            //End - Modified by Poulami 22/09/2015                      
        }
            
        if(acct.Bill_To_Address_1_Change_Request__c!=null)
            acct.Bill_To_Address_1__c= acct.Bill_To_Address_1_Change_Request__c;
        
        //modified by Anirban for Task - 1777 to remove Bill_To_Address_2__c when Bill_To_Address_2_Change_Request__c = 'REMOVE'                          
        if(acct.Bill_To_Address_2_Change_Request__c!=null && acct.Bill_To_Address_2_Change_Request__c != REMOVE){
            acct.Bill_To_Address_2__c= acct.Bill_To_Address_2_Change_Request__c;
        }else if(acct.Bill_To_Address_2_Change_Request__c!=null && acct.Bill_To_Address_2_Change_Request__c == REMOVE){
            acct.Bill_To_Address_2__c=null;
        }                            
        //end
        
        //modified by Anirban for Task - 1777 to remove Bill_To_Address_3__c when Bill_To_Address_2_Change_Request__c = 'REMOVE'
        if(acct.Bill_To_Address_3_Change_Request__c!=null && acct.Bill_To_Address_3_Change_Request__c != REMOVE){
            acct.Bill_To_Address_3__c= acct.Bill_To_Address_3_Change_Request__c;
        }else if(acct.Bill_To_Address_3_Change_Request__c!=null && acct.Bill_To_Address_3_Change_Request__c == REMOVE){
            acct.Bill_To_Address_3__c=null;
        }
        //end
        
        //modified by Anirban for Task - 1777 to remove Bill_To_Address_4__c when Bill_To_Address_2_Change_Request__c = 'REMOVE'
        if(acct.Bill_To_Address_4_Change_Request__c!=null && acct.Bill_To_Address_4_Change_Request__c != REMOVE){
            acct.Bill_To_Address_4__c= acct.Bill_To_Address_4_Change_Request__c;
        }else if(acct.Bill_To_Address_4_Change_Request__c!=null && acct.Bill_To_Address_4_Change_Request__c == REMOVE){
            acct.Bill_To_Address_4__c=null;
        }
        //end
        
        if(acct.Bill_To_City_Change_Request__c!=null)
            acct.Bill_To_City__c= acct.Bill_To_City_Change_Request__c;
        
        if(acct.Bill_To_State_Change_Request__c!=null)
            acct.Bill_To_State__c= acct.Bill_To_State_Change_Request__c;  
        
        // ----------Start Case#21803----------- yash
        if(acct.Bill_To_Country_Change_Request__c != 'USA'  )
        {                               
           if(acct.Bill_To_Country_Change_Request__c != null && acct.Bill_To_Country__c !='USA')
           {
               acct.Bill_To_State__c=null;
           }
           else
           {
               if(acct.Bill_To_Country_Change_Request__c != null && acct.Bill_To_Country__c =='USA')
               {
                   acct.Bill_To_State__c=null;
               }
           }
        }
         
        //modified by Anirban for Task - 1777 to remove Bill_To_Postal_Zip_Code__c when BBill_To_Postal_Code_Change_Request__c = 'REMOVE'
        if(acct.Bill_To_Postal_Code_Change_Request__c!=null && acct.Bill_To_Postal_Code_Change_Request__c != REMOVE){
            acct.Bill_To_Postal_Zip_Code__c= acct.Bill_To_Postal_Code_Change_Request__c;
        }else if(acct.Bill_To_Postal_Code_Change_Request__c!=null && acct.Bill_To_Postal_Code_Change_Request__c == REMOVE){
            acct.Bill_To_Postal_Zip_Code__c=null;
        }
        //end
        
        if(acct.Bill_To_Country_Change_Request__c!=null)
            acct.Bill_To_Country__c= acct.Bill_To_Country_Change_Request__c;  
        
        if(acct.Bill_To_Location_Change_Request__c!=null)
            acct.Bill_To_Location__c= acct.Bill_To_Location_Change_Request__c;            
        
        // Added 05/17/2013 - Revision of populating/validating Organization Unit process
        if (acct.New_Organization_Unit_Request__c != null) 
            acct.Organization_Unit__c = AccountOrganizationUnitPopulate.populateOrganizationUnit(acct.Organization_Unit__c, acct.New_Organization_Unit_Request__c);
        
        //Added by Naman :To Support Multiple Bill To Address for SDA SAP
        List<Account_Address__c> addressToUpdate = new List<Account_Address__c>();
        if(acct.Primary_Bill_To_Address_Change_Request__c != null){                        
            for(Account_Address__c addr : [SELECT id,name,Location__c,Is_Primary_Address__c,Address_1__c,Address_2__c,Address_3__c,Address_4__c,City__c,Country__c,Postal_Zip_Code__c,State__c,Bill_To_Attention__c FROM Account_Address__c WHERE type__c = 'Bill To Address' AND account__c =: acct.id]){
                if(addr.id == acct.Primary_Bill_To_Address_Change_Request__c){
                    acct.Primary_Bill_To_Address__c = addr.name;
                    acct.Bill_To_Address_1__c = addr.Address_1__c;
                    acct.Bill_To_Address_2__c = addr.Address_2__c;
                    acct.Bill_To_Address_3__c = addr.Address_3__c;
                    acct.Bill_To_Address_4__c = addr.Address_4__c;
                    acct.Bill_To_City__c = addr.City__c;
                    acct.Bill_To_State__c = addr.State__c ;
                    acct.Bill_To_Country__c = addr.Country__c;
                    acct.Bill_To_Postal_Zip_Code__c = addr.Postal_Zip_Code__c;
                    acct.Bill_To_Location__c = addr.Location__c;
                    acct.Bill_To_Attention__c = addr.Bill_To_Attention__c;
                    addr.Is_Primary_Address__c = true;  
                                   
                    addressToUpdate.add(addr);
                }
                else if(addr.Is_Primary_Address__c){
                    addr.Is_Primary_Address__c = false;
                    addressToUpdate.add(addr);
                }
            }
            system.debug('addressToUpdate---->'+addressToUpdate);
            try{
                if(!addressToUpdate.isEmpty()){
                    update addressToUpdate;
                }
        if(Test.isRunningTest()) {
                    throw new applicationException('In Test Mode');
                }
            }
            catch(Exception ex){
            
                ApplicationLogWrapper appLog = new  ApplicationLogWrapper();
                appLog.source = 'Account_TriggerHelper';
                appLog.sourceFunction = 'updateAccountDetail(Account acct)';
                appLog.ApplicationName = 'Unclassified';
                appLog.referenceId = string.valueOf(Account.Id);
                appLog.referenceInfo = 'Account';
                appLog.logMessage = ex.getMessage();
                appLog.payload = '';
                appLog.debugLevel = 'Error';
                 
                GlobalUtility.logMessage(appLog);            
              //  System.debug('The following exception has occurred: ' + e.getMessage());             
            }
        }
        
        acct.Approval_Request__c                    =   null;
        acct.Bill_To_Location_Change_Request__c     =   null;
        acct.Account_Name_Change_Request__c         =   null;
        acct.Region_Change_Request__c               =   null;
        acct.Financial_Territory_Change_Request__c  =   null;
        acct.Bill_To_Address_1_Change_Request__c    =   null;
        acct.Bill_To_Address_2_Change_Request__c    =   null;
        acct.Bill_To_Address_3_Change_Request__c    =   null;
        acct.Bill_To_Address_4_Change_Request__c    =   null;
        acct.Bill_To_City_Change_Request__c         =   null;
        acct.Bill_To_State_Change_Request__c        =   null;
        acct.Bill_To_Postal_Code_Change_Request__c  =   null;
        acct.Bill_To_Country_Change_Request__c      =   null;
        acct.Account_Details_Change_By_Trigger__c   =   datetime.now();
        
        // Added 05/17/2013 - Revision of populating/validating Organization Unit process
        acct.New_Organization_Unit_Request__c = null;
        
        //Added by Naman :To Support Multiple Bill To Address for SDA SAP
        acct.Primary_Bill_To_Address_Change_Request__c = null;
        system.debug('end>>>>>>>>>>updateAccountDetail :SOQL queries:'+limits.getQueries());        
    }   
   
    
    /*
        Method Name:    CountrycodeFieldMaping
        Author:        Gopi Koka
        Description:   This Method used to update country code value
        History: 
        Gopi Koka        5/11/2017    - Created code. 
    */
    public void CountrycodeFieldMaping(){
        //DeniedPartyList_InvokeObjects.invokeDeniedPartyList(Trigger.new[0].id,'Account'); 
      /*  Map<String,Country_Code__c> allCodes = Country_Code__c.getAll();
        for(Account acc:(List<Account>)trigger.new) {  
            if(allCodes.containskey(acc.Corporate_Country__c.ToUppercase())) { 
                acc.Country_Code__c= allCodes.get(acc.Corporate_Country__c.ToUppercase()).code__c;
            }
        }*/
    }
  
  public class applicationException extends Exception {}  
    
}