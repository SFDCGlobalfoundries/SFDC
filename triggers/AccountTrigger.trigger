/*
    Author: 
    Description: This is the trigger for Account object. 
    History:
        ARoy        04152013    - Addition of Copy Functionality of Corporate Address to Billing Address. 
        ASolito     04222013    - Fire Account Detail Changes to ERP.
        ZAmbat      05172013    - Revision of populating/validating Organization Unit process.
        ZAmbat      05222013    - Added validation for Accounts being submitted to Authorized.
        TLai        06252013    - Added code for account region change        
        ZAmbat      06132013    - Added code for creation/update of Account Hierarchy
        Yash        08022013    - Added Code for Prior_Parent_Account_Name__c
        ARoy        09062013    - Added for removal of the Bill To Address 2, Bill To Address 3, Bill To Address 4 and Bill To Postal/Zip Code
        Yash        10112013    - Added code for Prior Sales Territory
        Yash        10162013    - Added code for Sales Territory 
        Nbustillos  11262013    - Added logic to support Invoice Term approval process. 
                                - Added skip logic.
                                NOTE: Please note that this trigger is not yet optimized.
        TLai        23012014    - Added logic to get region head & backup head
        TLai        11032014    - Modified and restructured code for ATP update when Account owner changes or account creation with bulk feature
        TLai        19032014    - Added logic to validate having ATPs with 1 PFTS and 1 BCSR
        Sunil       24032014    - Added validation for Customer_Portal_Admin__c
        Tlai        25032014    - Added code to populate owner_profile__c based on workflow "Account - Copy Owner Profile"
        Tlai        26032014    - Added code to populate RecordtypeId
        TLai        27032014    - Moved workflow field update logic of "Account - Outbound Message - To AIA"
        Tlai        25042014    - Aligned Financial Territory with Sales Territory
        ZAmbat      05222014    - Updated code to populate missing fields.
        Tlai        26052014    - Update code to remove sales Territory.
        Tlai        05062014    - Populated siebel account id with sfdc id for new accounts after removing siebel dependence
        Tlai        11062014    - Added validation before authorized account is approved(request from Bhanu)
        Tlai        03072014    - changed criteria for account completion(request from Bhanu)
        Tlai        04072014    - Changed as per case 27104
        Tlai        24072014    - Changed as per case 30757
        Tlai        25072014    - Restructured code 
        Tlai        29072014    - Changed as per case 5279  
        Tlai        31072014    - Changed as per case 31543
        Tlai        06082014    - Moved workflow field update logic of "Account - Field Update - Approval Status"
        Tlai        07082014    - Removed logic for Region Head backup 
        ZAmbat      08222014    - Updated code as per CASE 31543.
        ZAmbat      10302014    - Updated code as per CASE 35698.
        ZAmbat      11112014    - Updated code to populate Primary Contact if it is blank.
        Prashant    04142014    - Updated code to convert "Account Name Change Request" to Uppercase.
        Shuchi      03042015    - Added record type check on the ERP callout to bypass IBM Accounts 
        Sunil - 07202015- Added condition to compare new and old account name for case # 43847
        Devendra    05082015    - Added [W-000164] ID0489 P1 : Provide Account Change notification to IT and Business users DSOP, Supply Chain, TM1, DW

        
*/
trigger AccountTrigger on Account (before insert, before update,after insert, after update) {
    
    //Tlai  31072014
    if(AcctRegHeadMappingTgrHandler.bypassAcctTrigger) return;
    
    if(!IntegrationUserUtil.isSkipTrigger()){
        
        Boolean isIntegrationUser = false;
        IntegrationUsers__c setting = IntegrationUsers__c.getValues(userInfo.getUserId());   
        if(setting <> null && setting.Is_Integration_User__c) isIntegrationUser = true;
        /* --------------------------------------Variables For AccountShortNameValidation Trigger--------------------------------- */
        map<string, Account> shortName2AccountMap = new map<string, Account> ();
        Set<Id> promote2AuthorizedAcctIds = new Set<Id>();
        /* --------------------------------------Variables For AccountShortNameValidation Trigger--------------------------------- */
        map<id,list<Account>>  mAcc4OwnerChange = new map<id,list<Account>>(); //Tlai 25032014 
        /* --------------------------------------Variables AccountManagerATP Trigger--------------------------------- */
        set<Id> sAcc4OwnerChange = new set<id>(); 
        Set<String> newAcctOwnerSet = new set<String>();
        /* --------------------------------------Variables AccountManagerATP Trigger--------------------------------- ***/
        /* --------------------------------------Variables For GenerateCustomerNumber Trigger--------------------------------- */
        set<id> acctId4CN = new set<id>();
        /* --------------------------------------Variables For GenerateCustomerNumber Trigger--------------------------------- */
        /* --------------------------------------Variables For Parent Account Change--------------------------------- */
        //set<string> atcRecords = new set<string>();
        map<id, Id> acctId2PrevParentAcctMap = new map<id, id>();
        /* --------------------------------------Variables For Parent Account Change--------------------------------- */
        
        /* -------------------------------------- Variables For Creation/Update of Account Hierarchy --------------------------------- */
        List<Account> listInsertAccounts = new List<Account>();
        List<Account> listUpdateAccounts = new List<Account>(); 
        /* -------------------------------------- Variables For Creation/Update of Account Hierarchy --------------------------------- */
        
        /* -------------------------------------- Variables For Account region head ------- --------------------------------- */
        List<Account> acctRegHeadChangeList = new List<Account>();
        /* -------------------------------------- Variables For Account region head ------- --------------------------------- */
        /* --------------------------------------Variables ATP PFTS/BCSR Validation Trigger Code--------------------------------- */
        set<id> acctId4ATP = new set<id>(); // Added by Tlai 19032014
        
        final String PRIMARY_FTS                    =               EnvironmentVariable.get('ACCT_TM_PRXY_TM_RL_PFTS') ;
        final String BACKUP_CSR                     =               EnvironmentVariable.get('ACCT_TM_PRXY_TM_RL_BCSR');
        final String PRIMARY_ACCOUTN_MANAGER        =               EnvironmentVariable.get('ACCT_TM_PRXY_TM_RL_PAM');
        final String ACCOUTN_MANAGER                =               EnvironmentVariable.get('ACCT_TM_PRXY_TM_RL_AM');
        final String PFST_BSCR_ERROR                =               Error_Codes__c.getInstance('ACCT_PFTS_OR_BCSR_NOT_FOUND_ERROR').Message__c;
        /* --------------------------------------Variables ATP PFTS/BCSR Validation Trigger Code--------------------------------- */
        /* --------------------------------------Variables Manual Device Update Trigger Code--------------------------------- */
        set<id> sAcctNameChanged = new set<id>();
        /* --------------------------------------Variables Manual Device Update Trigger Code--------------------------------- */
        set<id> sAccRegionChange = new set<id>();
        /* --------------------------------------Variables Portal user Validation Trigger Code--------------------------------- */
        //Set<Id> portalAdminChangedAcctIdSet=new Set<Id>();
        List<Account> portalAdminChangedAcctIdSet=new List<Account>();
        /* --------------------------------------Variables Portal user Validation Trigger Code--------------------------------- */
        set<id> customerPortalAdminSet = new set<id>(); // Tlai 25072014 restructured code
        Map<Id, Id> mapAccountRH = new Map<Id, Id>();
        List<string> listAccountIds = new List<string>();
        
        // Account Owner update start. : Pradosh - 30-3-2016
        Set<Id> accountIdForOwnerUpdateSet = new Set<Id>();
        for(Account accObj: trigger.new){
            if (trigger.isAfter && trigger.IsInsert){
                
                accountIdForOwnerUpdateSet.add(accObj.Id);
            }
           // if((Trigger.isbefore && Trigger.isUpdate) && Trigger.new.size()==1) {
                /*=================================================================================================================
                    Developer : Gopi Koka
                    Update below code for Denied part list to avoid Customer
                     Following code will work only for single record DML Operations
                     Reason : To avoid time out exception for multiple looping to find Unauthorized.
                     Solution: If we want bulk operations then need to validate denied part list using batch apex once.
                     //          Using "Unauthorized validated" field we can have how many records need to validate
                     Advantage : It will not effect not any existing functionality
                --------------------------------------------------------------------------------------------------------------------*/
                 /*   Account oldAcc = Trigger.oldMap.get(accObj.Id);
                    Boolean executeDeniedParlist = true;
                    if(oldAcc.Unauthorized__c == True && accObj.Unauthorized__c == false){
                        executeDeniedParlist = false;
                    }
                    if(executeDeniedParlist){
                        if(oldAcc.Name == accObj.name || oldAcc.Account_Name_Change_Request__c!=oldAcc.Account_Name_Change_Request__c){
                            String accountName = accObj.name;
                            if(oldAcc.Account_Name_Change_Request__c!=accObj.Account_Name_Change_Request__c){
                                accountName = accObj.Account_Name_Change_Request__c;
                            }
                            DeniedPartCustomerAvoiding.validatedResponse validateVar = DeniedPartCustomerAvoiding.validateCustomer(accountName,
                                                                                                                                   accObj.Corporate_Address_1__c,
                                                                                                                                   accObj.Bill_To_Address_1__c,
                                                                                                                                   accObj.Corporate_Country__c,
                                                                                                                                   accObj.id);
                             accObj.Unauthorized__c = validateVar.unauthorized;
                             accObj.Unauthorized_Percentage__c = validateVar.percentageCalculation;
                         }
                         
                     }*/
                /*-----------------------------------------------------------------------------------------------------------------
                    Denied Part list code upto Here
                ===================================================================================================================*/
           // }
           
        }

        if(accountIdForOwnerUpdateSet.size() > 0){

            AccountChangeOwnerUtil.updateOwnerId(accountIdForOwnerUpdateSet);
        }
        // Account Owner update end
        
        //Fetching new values of Account Record to be inserted/updated
        for(Account acc: trigger.new){
            if (trigger.isbefore){
            
                //----------------Yash----start
             
                  if(acc.Account_Name_Change_Request__c!=null)
                  {
                  //trigger.new[0].addError(acc.Account_Name_Change_Request__c + acc.name);
                  acc.Prior_Account_Name__c=acc.Account_Name_Change_Request__c;
                  
                  system.debug('@@@@@acc.Prior_Account_Name__c'+acc.Prior_Account_Name__c);
                  }
              
              //-----------------yash   --- end
               
                /* --------------------------------------Start Logic before Validation--------------------------------- */
                if (acc.Name != null) acc.Name =acc.Name.toUpperCase(); //Convert Account Name to Upper case
                
                acc.Account_Owner__c = acc.OwnerId;//populate Account_owner__c
                
                acc.Account_Manager__c = acc.ownerId; //Tlai 24072014
                // Prashant 04142014 Case No#00040562
                     if(acc.Account_Name_Change_Request__c!=null){
                      acc.Account_Name_Change_Request__c = acc.Account_Name_Change_Request__c.toUpperCase(); //Convert Account Name Change Request to Upper case
                      }
                     
                //Check Short Name Characters
                if (acc.Short_Name__c !=null){
                    
                    if (acc.Short_Name__c.length() > 1){
                        if(!Pattern.matches('^[a-zA-Z0-9_-]+$',acc.Short_Name__c)) {                         
                            acc.adderror('Short name can only contain characters, numbers, -, _ ');  continue;
                        }
                    } else {
                        acc.adderror('Shortname should be more than 1 character'); continue;
                    }
                    
                    acc.Short_Name__c =acc.Short_Name__c.toLowerCase();
                }                   
                /* --------------------------------------End Logic before Validation--------------------------------- */
                
                /* --------------------------------------Start Account info Validation--------------------------------- */
                if(Trigger.IsUpdate){
                    //Short name cannot be changed
                    if(Trigger.oldMap.get(acc.id).Short_Name__c != null && (Trigger.oldMap.get(acc.id).Short_Name__c != acc.Short_Name__c)){
                        acc.addError('Short Name can not be modified'); continue;
                    }
                    
                    //Territory cannot be changed once territory change request is initiated
                    if(!String.isBlank(acc.financial_territory__c) && acc.financial_territory__c != trigger.oldmap.get(acc.id).financial_territory__c && !String.isblank(acc.Financial_Territory_Change_Request__c)) {
                        acc.addError('Territory can not be modified because territory change request has been initiated.'); continue;
                    }
                    
                    //Siebel Sync Id should be greater then prior value
                    if(userinfo.getProfileId() == EnvironmentVariable.get('GF_INTEGRATION_PROFILE_ID') && acc.Siebel_Sync_ID__c < Trigger.oldMap.get(acc.id).Siebel_Sync_ID__c) {
                        acc.adderror('Out of sequence integration update');  continue;  
                    }
                    
                    // Added by Nbustillos 11262013
                    if(acc.Account_Manager__c!= UserInfo.getUserId() && 
                            ((acc.Invoice_Term__c!=null && Trigger.oldmap.get(acc.id).Invoice_Term__c!=acc.Invoice_Term__c) || 
                                (acc.Invoice_Term_Change_Request__c!=null && Trigger.oldmap.get(acc.id).Invoice_Term_Change_Request__c!=acc.Invoice_Term_Change_Request__c))){
                        acc.addError('Only Primary Account Manager can update Invoice Term/Invoice Term Change Request.'); continue;
                        
                    }else if(acc.Approval_Request__c=='Invoice Term Change' && (acc.Approval_Status__c=='Approved' && trigger.oldMap.get(acc.Id).Approval_Status__c!=acc.Approval_Status__c) &&  acc.Invoice_Term_Change_Request__c!=null){
                            acc.Invoice_Term__c = acc.Invoice_Term_Change_Request__c;
                            acc.Approval_Request__c = null;
                            acc.Invoice_Term_Change_Request__c = null;
                    }
                    
                    //Added by Tlai 11062014    - check Target Account and Revenue Potential (MKTG) not empty before qualified account is approved
             /*       if(acc.Approval_Request__c == 'Promote to Authorized' && acc.Approval_Status__c=='Approved' && trigger.oldMap.get(acc.Id).Approval_Status__c!=acc.Approval_Status__c){
                        if(acc.Revenue_Potential__c == null && acc.Target_Account__c == null){
                            acc.addError('Target Account and Revenue Potential (MKTG) are required before Authorized account is approved.'); continue;
                        }
                    } */
                    
                    
                    //Added by Devendra 05082015 p-[W-000164] ID0489 P1 : Provide Account Change notification to IT and Business users DSOP, Supply Chain, TM1, DW
                    //Case Number : 00043203
                    if((acc.recordtypeId == EnvironmentVariable.get('ACCT_RT_ID_RESELLER')||
                            acc.recordtypeId == EnvironmentVariable.get('ACCT_RT_ID_EN_PARTNER')||
                            acc.recordtypeId == EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER'))&&(acc.Stage__c == 'Authorized' || acc.Stage__c == 'Qualified')){
                        boolean isChanged=false;
                        if(Trigger.oldMap.get(acc.id).Name != null && (Trigger.oldMap.get(acc.id).Name != acc.Name)){//Account Name
                            isChanged=true;
                        }
                        if(Trigger.oldMap.get(acc.id).ParentId != null && (Trigger.oldMap.get(acc.id).ParentId != acc.ParentId)){//Parent Account
                            isChanged=true;
                        }
                        else if(Trigger.oldMap.get(acc.id).Financial_Territory__c != null && (Trigger.oldMap.get(acc.id).Financial_Territory__c != acc.Financial_Territory__c)){//Territory
                            isChanged=true;
                        }
                        else if(Trigger.oldMap.get(acc.id).Region_Head__c != null && (Trigger.oldMap.get(acc.id).Region_Head__c != acc.Region_Head__c)){//Region Head
                            isChanged=true;
                        }
                        else if(Trigger.oldMap.get(acc.id).Sales_Group__c != null && (Trigger.oldMap.get(acc.id).Sales_Group__c != acc.Sales_Group__c)){//Sales Group
                            isChanged=true;
                        }
                        
                        if(isChanged){
                            acc.isNotifiedFieldsChanged__c=true;
                        }
                        
                    }
                    
                }
                
                // Added by TLai 24032014 - Check if the new value already exists in Organization Unit
                if (acc.Organization_Unit__c != null && acc.New_Organization_Unit_Request__c != null) {
                    
                    Set<String> setOU = new Set<String>(acc.Organization_Unit__c.split(';'));
                    
                    if (setOU.contains(acc.New_Organization_Unit_Request__c)) {
                        acc.addError('Duplicate Organization Unit is not allowed.');  continue;
                    }
                }
                    
                if(Trigger.isInsert && acc.Account_Manager__c!=UserInfo.getUserId() && (acc.Invoice_Term__c!=null || acc.Invoice_Term_Change_Request__c!=null)){
                    acc.addError('Only Primary Account Manager can update Invoice Term/Invoice Term Change Request.');  continue;
                }
                
                //Thomas 24032014 -- copied code from  AccountManager.copyAddress
                if(acc.Copy_Address__c && acc.Stage__c != 'Authorized' && acc.Stage__c != 'Inactive'){
                    acc.Bill_To_Address_1__c = acc.Corporate_Address_1__c;
                    acc.Bill_To_Address_2__c = acc.Corporate_Address_2__c;
                    acc.Bill_To_Address_3__c = acc.Corporate_Address_3__c;
                    acc.Bill_To_Address_4__c = acc.Corporate_Address_4__c;
                    acc.Bill_To_City__c = acc.Corporate_City__c;
                    acc.Bill_To_State__c = acc.Corporate_State__c;
                    acc.Bill_To_Country__c = acc.Corporate_Country__c;
                    acc.Bill_To_Postal_Zip_Code__c = acc.Corporate_Postal_Zip_Code__c;
                    acc.Copy_Address__c = false;
                }
                
                //Thomas 24032014 -- copied code from ClsCheckAccountValidation
                if(trigger.isupdate && !AccountTriggerRun.isAddressValidated &&  acc.recordtypeId != EnvironmentVariable.get('ACCT_RT_ID_SUPPLIERS')){// Tlai 04072014  - Changed as per case 27104
                   
                    if((acc.Bill_To_Address_1__c ==null || acc.Bill_To_City__c==null || acc.Bill_To_Country__c==null )  && acc.Copy_Address__c == false ){
                    
                        Error_Codes__c Bill_To_Address_Required= Error_Codes__c.getInstance('Bill_To_Address_Required');
                        acc.adderror(Bill_To_Address_Required.message__c);
                        continue;
                    }
                    
                }
                
                /*--------------------validation to check Account Name + Site_Department__c should be unique----------
                case in-sensitive, convert Site_Department__C to lowercase before saving record, not optimized
                -----------------------------------------------------------------------------------------------------*/             
                if (Trigger.IsInsert ||(Trigger.IsUpdate && acc.Site_Department__C !=null && ((Trigger.oldMap.get(acc.id).Site_Department__C != acc.Site_Department__C) || (Trigger.oldMap.get(acc.id).Name != acc.Name))))
                {
                    if (AccountTriggerRun.hasAccountTriggerRun){
                        // !!!! query in for loop, need optmizing
                        list<Account> Acc_Site_Dep = [select Id,name from Account where name=:acc.Name and Site_Department__C=:acc.Site_Department__C limit 1 ];
                        if(Acc_Site_Dep.size() > 0){
                            acc.addError('Account Name and Site must be unqiue');
                            continue;
                        }
                    }
                }
                
                /*----------- END Account info Validation ---------------------------------------------------------------*/
                
                if (trigger.isupdate){
                     
                    //Tlai 05062014 - populated siebel account id with sfdc id for new accounts after removing siebel dependence
                    if(String.isBlank(acc.Siebel_Account_ID__c))  acc.Siebel_Account_ID__c = acc.id;
                    
                    if(acc.Approval_Request__c=='Account Details Change' && acc.Approval_Status__c=='Approved' && Trigger.oldMap.get(acc.id).Approval_Status__c !=acc.Approval_Status__c ){
                        updateAccountDetail(acc);
                    }
                    
                    if(Trigger.oldMap.get(acc.id).Financial_Territory__c != acc.Financial_Territory__c)
                        acc.Prior_Sales_Territory__c    =   Trigger.oldMap.get(acc.id).Financial_Territory__c;
                    
                    //Tlai 19032014 - check ATPs' team role with 1 PFTS and 1 BCSR
                    if(!AccountTriggerRun.skipATPValidation && (acc.recordtypeId == EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER') || acc.recordtypeId == EnvironmentVariable.get('ACCT_RT_ID_RESELLER'))){
                        if(acc.stage__c == 'Authorized' ||(acc.Approval_Request__c == 'Promote to Authorized'&& (acc.stage__c == 'Qualified' ||acc.stage__c == 'Unqualified' ))){
                            acctId4ATP.add(acc.id);
                            system.debug('validating PFTS/BSCR');
                        }
                    }
                    
                    // 24/03/2014 Validation added by Sunil for case # 5650
                    if(acc.Customer_Portal_Admin__c!=null ) {
                        customerPortalAdminSet.add(acc.Customer_Portal_Admin__c);// Tlai 25072014 restructured code
                        acc.Portal_Admin_Report_Flag__c = false;// Tlai 25072014 restructured code
                        //if(acc.Customer_Portal_Admin__c!=trigger.oldmap.get(acc.id).Customer_Portal_Admin__c){
                            //portalAdminChangedAcctIdSet.add(acc.Id); 
                        if(acc.Customer_Portal_Admin__c != trigger.oldmap.get(acc.id).Customer_Portal_Admin__c 
                           && acc.Customer_Portal_Admin__c != null) {
                            portalAdminChangedAcctIdSet.add(acc);
                        }
                        
                    }
                    
                    // Added by ZAmbat 05/22/2013 - Validate Account(s) being promoted to Authorized if there is at least 1 Contact
                    if(acc.Approval_Request__c == 'Promote to Authorized')
                        promote2AuthorizedAcctIds.add(acc.Id);
                    
                    
                    
                    //Added Code for Prior_Parent_Account_Name__c 
                    if(Trigger.oldMap.get(acc.id).ParentId != acc.ParentId)
                        acctId2PrevParentAcctMap.put(acc.id, Trigger.oldMap.get(acc.id).ParentId);
                }
                
                // Added by TLai 01232014 - Retrieve region head & svp from account region head mapping
                // Tlai 26052014 set value based on Financial Territory
                // Tlai 31072014 Changed as per case 31543: populate region head ONLY when Approval_Request__c is changed  to 'Promote to Qualified', 'Promote to Authorized' or 'Invoice Term Change'
                if(trigger.isinsert && acc.Financial_Territory__c != null){
                    acctRegHeadChangeList.add(acc);
                }
                
                if(trigger.isUpdate && 
                                (   
                                    (acc.Financial_Territory__c != null && acc.Financial_Territory__c != trigger.oldMap.get(acc.id).Financial_Territory__c)
                                ||  (acc.Region_head_mapping__c != null && acc.Region_head_mapping__c != trigger.oldMap.get(acc.id).Region_head_mapping__c)
                                ||  (acc.Approval_Request__c != trigger.oldMap.get(acc.id).Approval_Request__c
                                        && (acc.Approval_Request__c == 'Promote to Qualified' || acc.Approval_Request__c == 'Promote to Authorized' || acc.Approval_Request__c == 'Invoice Term Change')
                                       )
                                )
                ){
                    acctRegHeadChangeList.add(acc);
                }
                
                //Tlai 26052014 sync sales territory with financial territory
                if(acc.sales_territory__c != acc.financial_territory__c){
                    acc.sales_territory__c = acc.financial_territory__c;
                }
                
                //Modified by Tlai 13032014 - revomed query in for loop for customer no generation, put it at the end of before trigger
                if (acc.Stage__c=='Authorized' && acc.Customer_Number__c == null )
                {
                    acctId4CN.add(acc.id);
                }
                
                /* --------------------------------------Start AccountManagerATP Trigger Code--------------------------------- */
                //TLai - 11032014 : Restruture code with bulk feature for account owner change
                if ((Trigger.IsUpdate && acc.ownerId != Trigger.oldMap.get(acc.id).OwnerId) )
                {
                    newAcctOwnerSet.add(acc.id + '' + acc.ownerId);
                }
                /* --------------------------------------End AccountManagerATP Trigger Code--------------------------------- */ 
                
                
                //Tlai 26032014 populate RecordtypeId
                if(trigger.isinsert && !string.isblank(acc.Account_Type__c)){
                
                    if(acc.Account_Type__c == 'Enablement Partner'){
                        acc.recordtypeid = EnvironmentVariable.get('ACCT_RT_ID_EN_PARTNER');
                    }else if(acc.Account_Type__c == 'GLOBALFOUNDRIES Internal'){
                        acc.recordtypeid = EnvironmentVariable.get('ACCT_RT_ID_GF_INTERNAL');
                    }else if(acc.Account_Type__c == 'Reseller'){
                        acc.recordtypeid = EnvironmentVariable.get('ACCT_RT_ID_RESELLER');
                    }else if(acc.Account_Type__c == 'Customer'){
                        acc.recordtypeid = EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER');
                    } 
                }
                
                // TLai 27032014 populate integration fields based on the workflow condition: "Account - Outbound Message - To AIA" 
                boolean ruleCriteria = false;
                boolean isSiebelAccountComplete = true;
                //03072014 TLai Remove criteria for account completion
                if(//String.isEmpty(acc.Corporate_Address_1__c)
                    //||String.isEmpty(acc.Corporate_City__c)
                    //||String.isEmpty(acc.Corporate_Country__c)
                    //||String.isEmpty(acc.Name)
                    //||String.isEmpty(acc.Region__c)
                    acc.RecordTypeId == null //Record_Type_Name__c is formula $RecordType.Name
                    //||String.isEmpty(acc.Site_Department__c)
                    //||String.isEmpty(acc.Stage__c)
                    //||String.isEmpty(acc.Sub_Type__c)
                    //||String.isEmpty(acc.Transaction_Type__c)
                    ||(acc.Stage__c != 'Unqualified' && (acc.Approval_Status__c == 'Pending Approval' ||acc.Approval_Status__c == 'Rejected' || acc.Approval_Status__c == ''))
                    ){
                        isSiebelAccountComplete = false;
                }
                if(!isIntegrationUser  && isSiebelAccountComplete){
                    if(acc.stage__c == 'Unqualified'){
                        if(trigger.isinsert || (Trigger.isupdate &&(acc.Account_Profile__c != trigger.oldmap.get(acc.id).Account_Profile__c
                                                                ||acc.Disengaged__c != trigger.oldmap.get(acc.id).Disengaged__c
                                                                ||acc.Founded__c != trigger.oldmap.get(acc.id).Founded__c
                                                                ||acc.Market_Segment__c != trigger.oldmap.get(acc.id).Market_Segment__c
                                                                ||acc.ParentId != trigger.oldmap.get(acc.id).ParentId
                                                                ||acc.Process_Tech_Interested__c != trigger.oldmap.get(acc.id).Process_Tech_Interested__c
                                                                ||acc.Site_Department__c != trigger.oldmap.get(acc.id).Site_Department__c
                                                                ||acc.Bill_To_Address_1__c != trigger.oldmap.get(acc.id).Bill_To_Address_1__c
                                                                ||acc.Bill_To_Address_2__c != trigger.oldmap.get(acc.id).Bill_To_Address_2__c
                                                                ||acc.Bill_To_Address_3__c != trigger.oldmap.get(acc.id).Bill_To_Address_3__c
                                                                ||acc.Bill_To_Address_4__c != trigger.oldmap.get(acc.id).Bill_To_Address_4__c
                                                                ||acc.Bill_To_City__c != trigger.oldmap.get(acc.id).Bill_To_City__c
                                                                ||acc.Bill_To_State__c != trigger.oldmap.get(acc.id).Bill_To_State__c
                                                                ||acc.Bill_To_Postal_Zip_Code__c != trigger.oldmap.get(acc.id).Bill_To_Postal_Zip_Code__c
                                                                ||acc.Bill_To_Country__c != trigger.oldmap.get(acc.id).Bill_To_Country__c
                                                                ||acc.Bill_To_Location__c != trigger.oldmap.get(acc.id).Bill_To_Location__c
                                                                ||acc.Name != trigger.oldmap.get(acc.id).Name
                                                                ||acc.Region__c != trigger.oldmap.get(acc.id).Region__c
                                                                ||acc.Corporate_Address_1__c != trigger.oldmap.get(acc.id).Corporate_Address_1__c
                                                                ||acc.Corporate_Address_2__c != trigger.oldmap.get(acc.id).Corporate_Address_2__c
                                                                ||acc.Corporate_Address_3__c != trigger.oldmap.get(acc.id).Corporate_Address_3__c
                                                                ||acc.Corporate_Address_4__c != trigger.oldmap.get(acc.id).Corporate_Address_4__c
                                                                ||acc.Corporate_City__c != trigger.oldmap.get(acc.id).Corporate_City__c
                                                                ||acc.Corporate_State__c != trigger.oldmap.get(acc.id).Corporate_State__c
                                                                ||acc.Corporate_Postal_Zip_Code__c != trigger.oldmap.get(acc.id).Corporate_Postal_Zip_Code__c
                                                                ||acc.Corporate_Country__c != trigger.oldmap.get(acc.id).Corporate_Country__c
                                                                ||acc.Sub_Type__c != trigger.oldmap.get(acc.id).Sub_Type__c
                                                                ||acc.Transaction_Type__c != trigger.oldmap.get(acc.id).Transaction_Type__c
                                                                ||acc.Short_Name__c != trigger.oldmap.get(acc.id).Short_Name__c
                                                                ||acc.Financial_Territory__c != trigger.oldmap.get(acc.id).Financial_Territory__c
                                                                ||acc.Invoice_Term__c != trigger.oldmap.get(acc.id).Invoice_Term__c
                                                                ||acc.Sales_Group__c != trigger.oldmap.get(acc.id).Sales_Group__c
                                                                ||acc.Region_Head__c != trigger.oldmap.get(acc.id).Region_Head__c
                                                                //||acc.Region_Head_Backup__c != trigger.oldmap.get(acc.id).Region_Head_Backup__c    Tlai Backup is replcaed by delegate on Region Head                                                            
                                                                )
                                            )
                        ){
                            ruleCriteria = true;
                        }
                    }else{
                        ruleCriteria = true;                        
                    }
                    
                    if(ruleCriteria){
                        acc.Siebel_Error_Message__c = null;
                        acc.Siebel_Sent_DateTime__c = datetime.now();
                        acc.Siebel_Status__c        = 'SENT';
                        acc.Siebel_Sync_ID__c       = datetime.now().format();
                        acc.Martinistore_Sync_Status__c = 'SENT';
                    }
                }
                
                // Added by Tlai 25032014   - populate owner_profile__c based on workflow "Account - Copy Owner Profile"
                // need checking if in use
                if (!AccountTRiggerRun.hasAccountTriggerRun && (Trigger.IsInsert || (Trigger.IsUpdate && acc.OwnerId != Trigger.oldMap.get(acc.id).OwnerId) ) ){
                
                    if(mAcc4OwnerChange.containskey(acc.ownerid)){
                        mAcc4OwnerChange.get(acc.ownerid).add(acc);
                    }else {
                        mAcc4OwnerChange.put(acc.ownerid, new Account[]{acc});
                    }
                }
                
                //Added by Tlai 06082014    - workflow "Account - Field Update - Approval Status"
                if(trigger.isupdate){
                    if( (!String.isblank(acc.Approval_Request__c) && acc.Approval_Request__c  !=  trigger.oldmap.get(acc.id).Approval_Request__c)
                        || (!String.isblank(acc.Bill_To_Address_1_Change_Request__c) && acc.Bill_To_Address_1_Change_Request__c  !=  trigger.oldmap.get(acc.id).Bill_To_Address_1_Change_Request__c)
                        || (!String.isblank(acc.Bill_To_Address_2_Change_Request__c) && acc.Bill_To_Address_2_Change_Request__c  !=  trigger.oldmap.get(acc.id).Bill_To_Address_2_Change_Request__c)
                        || (!String.isblank(acc.Bill_To_Address_3_Change_Request__c) && acc.Bill_To_Address_3_Change_Request__c  !=  trigger.oldmap.get(acc.id).Bill_To_Address_3_Change_Request__c)
                        || (!String.isblank(acc.Bill_To_Address_4_Change_Request__c) && acc.Bill_To_Address_4_Change_Request__c  !=  trigger.oldmap.get(acc.id).Bill_To_Address_4_Change_Request__c)
                        || (!String.isblank(acc.Bill_To_City_Change_Request__c) && acc.Bill_To_City_Change_Request__c  !=  trigger.oldmap.get(acc.id).Bill_To_City_Change_Request__c)
                        || (!String.isblank(acc.Bill_To_State_Change_Request__c) && acc.Bill_To_State_Change_Request__c  !=  trigger.oldmap.get(acc.id).Bill_To_State_Change_Request__c)
                        || (!String.isblank(acc.Bill_To_Postal_Code_Change_Request__c) && acc.Bill_To_Postal_Code_Change_Request__c  !=  trigger.oldmap.get(acc.id).Bill_To_Postal_Code_Change_Request__c)
                        || (!String.isblank(acc.Bill_To_Country_Change_Request__c) && acc.Bill_To_Country_Change_Request__c  !=  trigger.oldmap.get(acc.id).Bill_To_Country_Change_Request__c)
                        || (!String.isblank(acc.Bill_To_Location_Change_Request__c) && acc.Bill_To_Location_Change_Request__c  !=  trigger.oldmap.get(acc.id).Bill_To_Location_Change_Request__c)
                        || (!String.isblank(acc.Account_Name_Change_Request__c) && acc.Account_Name_Change_Request__c  !=  trigger.oldmap.get(acc.id).Account_Name_Change_Request__c)
                        || (!String.isblank(acc.Region_Change_Request__c) && acc.Region_Change_Request__c  !=  trigger.oldmap.get(acc.id).Region_Change_Request__c)
                        || (!String.isblank(acc.Financial_Territory_Change_Request__c) && acc.Financial_Territory_Change_Request__c  !=  trigger.oldmap.get(acc.id).Financial_Territory_Change_Request__c)
                        || (!String.isblank(acc.New_Organization_Unit_Request__c) && acc.New_Organization_Unit_Request__c  !=  trigger.oldmap.get(acc.id).New_Organization_Unit_Request__c)
                    ){
                        acc.Approval_Status__c = null;
                    }
                }
                
                // ZAmbat 10302014
                if (acc.Region__c != null
                    && (trigger.isInsert
                        || (trigger.isUpdate && acc.Region__c != trigger.oldMap.get(acc.Id).Region__c))) {
                    // Modified by Bhanu 31/10/2014                         
                    /*if (acc.Region__c == 'GC' || acc.Region__c == 'JK' ||acc.Region__c == 'US' || acc.Region__c == 'EUR') {
                        acc.Classification__c = 'GLOBAL SALES';
                    } else if (acc.Region__c == 'US-Majors') {
                        acc.Classification__c = 'MAJORS';
                    }*/
                    
                    // Modified by Poulami 14/09/2015                         
                    if (acc.Region__c == 'US-West' || acc.Region__c == 'US-East' || acc.Region__c == 'US-SoCal' || acc.Region__c == 'US-Majors') {
                        acc.Classification__c = 'US Foundry Sales';
                    } else if (acc.Region__c == 'GC' || acc.Region__c == 'JK' || acc.Region__c == 'EUR') {
                        acc.Classification__c = 'International Foundry Sales';
                    }else if (acc.Region__c == 'ASIC' || acc.Region__c == 'A&D') {
                        acc.Classification__c = 'ASIC and A&D';
                    }
                }
            }//end trigger.isbefore
            
            
            if(trigger.isafter) {
                
                // if short name is changed
                if(Trigger.IsInsert || Trigger.oldMap.get(acc.id).Short_Name__c != acc.Short_Name__c )
                {
                    if(acc.Short_Name__c != null)
                    shortName2AccountMap.put(acc.Short_Name__c, acc);
                }
                
                /* --------------------------------------Start AccountManagerATP Trigger Code--------------------------------- */
                //TLai - 11032014 : Restruture code with bulk feature for account owner change
                if (Trigger.IsInsert 
                    || (Trigger.IsUpdate && Trigger.newMap.get(acc.id).OwnerId != Trigger.oldMap.get(acc.id).OwnerId) )
                {
                    sAcc4OwnerChange.add(acc.id);
                    system.debug('Account Owner changed...');
                }
                /* --------------------------------------End AccountManagerATP Trigger Code--------------------------------- */  
                
                /* --------------------------------------Start Manual Device Update Trigger Code--------------------------------- */
                ////////VIXIT CODE STARTS HERE
                //Thomas 24032014 changed code to remove inner query in for loop
                if (Trigger.IsUpdate && acc.Name != trigger.oldmap.get(acc.Id).name){
                    sAcctNameChanged.add(acc.id);
                }
                ////////VIXIT CODE ENDS HERE 
                /* --------------------------------------End Manual Device Update Trigger Code--------------------------------- */
                
                /* Tlai 24032014 Commented and move to before trigger               
                //-------------------yash
                if ((Trigger.IsUpdate || Trigger.IsInsert) && (ClsCheckAccountValidation.Flag==false))
                {
                    ClsCheckAccountValidation.checkUpdateAccountValidation(trigger.newmap, Trigger.IsInsert,Trigger.IsUpdate);
                    ClsCheckAccountValidation.Flag=true;
                }
                //---------------
                */
                
                //TLai - 25062013 -Start 
                /** This is for Account Region Change. 
                    Checks for Region change in Account and updates the child Opportunity Program 
                    and Device "Account Region" fields with the new Region value.                                       
                */
                if (Trigger.IsUpdate && acc.Region__c != trigger.oldMap.get(acc.Id).Region__c)
                {
                    /*
                    Asynchronous method call to update the Account Region fields of the child
                    Opportunity Program and Device records only when the context is not in batch nor future nor schedule method.
                    */
                    if(!(system.isBatch() || system.isFuture() || system.isScheduled())) {
                        sAccRegionChange.add(acc.id);
                        //AccountChangeRegionUtil.regionChangeAction(acc.Id);
                    }
                }//TLai - 25062013 -End 
                
                
                /* -------------------------------------- Creation/Update of Account Hierarchy Start --------------------------------- */
                if (Trigger.IsInsert) {
                    listInsertAccounts.add(acc);
                } else if (Trigger.IsUpdate) {
                    if (trigger.newMap.get(acc.Id).ParentId != trigger.oldMap.get(acc.Id).ParentId) {
                        listUpdateAccounts.add(acc);
                    }
                }
                
                /* -------------------------------------- Creation/Update of Account Hierarchy End --------------------------------- */
                
                // ZAmbat 08222014
                if (trigger.isUpdate) {
                  if (acc.Region_Head_lk__c != trigger.oldMap.get(acc.Id).Region_Head_lk__c) {  
                    mapAccountRH.put(acc.Id, acc.Region_Head_lk__c);
                  }
                }
                
                // ZAmbat 11112014
                if (acc.Primary_Contact__c == null) {
                    listAccountIds.add(acc.Id);
                }
            }//end trigger.isafter
            
        }//end for loop
        
        /* ============================================================================================================================
                                                                Logic after for loop
        ===============================================================================================================================  */
        if(trigger.isbefore && customerPortalAdminSet.size() > 0){// Tlai 25072014 restructured code
            map<id, user> userMap = new map<id, user>([Select id, name, UserRole.Name From user where id in :customerportaladminset and UserRoleId != null]);
            for(Account acc: trigger.new){
                if(acc.Customer_Portal_Admin__c != null && userMap.containsKey(acc.Customer_Portal_Admin__c)){
                    String usrRoleName = userMap.get(acc.Customer_Portal_Admin__c).userRole.Name;
                    if(usrRoleName.contains(acc.Name)){
                        acc.Portal_Admin_Report_Flag__c = true;
                    }
                }
            }
        }
        
         /* --------------------------------------Start ATP PFTS/BCSR Validation Trigger Code--------------------------------- */
        //Tlai 19032014 check meeting criteria accounts should have 1 PFTS and 1 BCSR
        if(trigger.isbefore && trigger.isupdate && acctId4ATP.size() > 0){
            
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
                Account acctTemp = trigger.newmap.get(accid);
                
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
          if(trigger.isbefore && acctId4CN.size() > 0){
            Integer csn = integer.valueOf( Customer_Number__c.getInstance('Update Customer No').Customer_No__c);
            if(csn != null){
                for(id acctId : acctId4CN){
                    trigger.newmap.get(acctId).Customer_Number__c = String.valueOf(csn);
                    csn++;
                }
                /*Jabee: Update of the Custom Setting Value to Generate the Customer Number for ERP */
                  Customer_Number__c OldCUSNO = [select id, Customer_No__c from Customer_Number__c limit 1];
                OldCUSNO.Customer_No__c = csn;
                update OldCUSNO;
                //AccountTriggerRun.customerNo = csn;//Commented by Jabee on 21-Jun
            }
        } //commented by sunita
 /*----------------------------code added by sunita start---------------------------------*/       
       /* if(trigger.isbefore && trigger.isInsert && !test.isrunningtest()){
            Integer myVal = integer.valueOf( CustomerNumber__c.getInstance('Update Customer No').Customer_No__c);
                    
            if(myVal != null){
                for(Account acc: trigger.new){
                   if(acc.recordtypeid == EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER') || acc.recordtypeid == EnvironmentVariable.get('ACCT_RT_ID_EN_PARTNER') ||acc.recordtypeid == EnvironmentVariable.get('ACCT_RT_ID_RESELLER'))
                     {
                             acc.Short_Name__c='a'+myVal ;
                            // acc.Customer_Number__c = String.valueOf(myVal);
                             myVal++;
                     }
                    else if(acc.recordtypeid == EnvironmentVariable.get('ACCT_RT_ID_GF_INTERNAL'))
                    { 
                            acc.Short_Name__c='g'+myVal ;
                            //acc.Customer_Number__c = String.valueOf(myVal);
                            myVal++;
                    }
                
                AccountTriggerRun.customerNo = myVal;
            }
          }
        }*/
        
        /* --------------------------------------Start Populate Prior_Parent_Account_Name__c Trigger Code--------------------------------- */
        if(trigger.isBefore && acctId2PrevParentAcctMap.size() > 0){
            map<id, Account> parentAcctMap = new map<id,Account>([select id, name from account where id in: acctId2PrevParentAcctMap.values()]);
            if(parentAcctMap.size() > 0){
                for(id accId : acctId2PrevParentAcctMap.keySet()) {
                    Id parentId = acctId2PrevParentAcctMap.get(accId);
                    if(parentAcctMap.containsKey(parentId)){
                        Account pAcct = parentAcctMap.get(parentId);
                        trigger.newMap.get(accId).Prior_Parent_Account_Name__c = pAcct.name;
                    }
                }
            }
        }
        /* --------------------------------------End Populate Prior_Parent_Account_Name__c Trigger Code--------------------------------- */
        
        
         /* --------------------------------------Start Account Owner Change Trigger Code--------------------------------- */
        //Added by Thomas 11032014 - update ATP when Account owner changes or account creation
        if(trigger.isbefore && trigger.isupdate && newAcctOwnerSet.size() > 0){
             for(Account_Team_Proxy__c atp :[select  id, Account__c,Team_Role__c,Account_Role_ID__c,Flag_for_Delete__c
                                                from Account_Team_Proxy__c 
                                                where   Account_Role_ID__c in : newAcctOwnerSet and Flag_for_Delete__c = false
                                                ]){
                 //Prevent account owner change if new owner is existing PFTS or BCSR                                   
                 if(atp.Team_Role__c == PRIMARY_FTS || atp.Team_Role__c == BACKUP_CSR){
                        trigger.newMap.get(atp.account__c).addError(PFST_BSCR_ERROR);
                        
                 }                          
            }
            
        }
        
        //Tlai 25032014 -- populate owner_profile__c based on workflow "Account - Copy Owner Profile"
        // need review if this code still in use, coz no profile called PT1, PT2...
        if(trigger.isbefore && mAcc4OwnerChange.size() > 0) {
            for(user u : [select id, profile.name from user where id in: mAcc4OwnerChange.keyset()]){
                if(mAcc4OwnerChange.containskey(u.id) ){
                    PT_Profile_Mapping__c mp = PT_Profile_Mapping__c.getInstance(u.profile.name);
                    
                    for(Account acc : mAcc4OwnerChange.get(u.id)){                  
                        
                        if(mp != null){
                            acc.Owner_Profile__c = mp.value__c; 
                        }else{
                            acc.Owner_Profile__c = u.profile.name;
                        }
                    }
                }
            }
        }
        
        // Added by ZAmbat 05/22/2013 - Validate Account(s) being promoted to Authorized if there is at least 1 Contact
        if (Trigger.isBefore && promote2AuthorizedAcctIds.size() > 0) {
            List<Account> listAccounts = AccountValidation.validateContacts(promote2AuthorizedAcctIds);
            
            if (listAccounts.size() > 0) {
                //Error_Codes__c ec = Error_Codes__c.getInstance('ACCOUNT_DOES_NOT_HAVE_CONTACT'); ---> Other Test Classes should have "SeeAllData=true" attribute in order for this to work
                for (Account a : listAccounts) {
                    //Trigger.newMap.get(a.Id).addError(ec.Message__c);
                    Trigger.newMap.get(a.Id).addError('Account should have at least one contact before it can be Authorized.');
                }
            }
        }
        
        /* --------------------------------------Start update region head Code--------------------------------- */ 
        // Added by TLai 01/23/2014 - Retrieve region head & backup from account region head mapping
        // Changed by Tlai 31072014 - added logic for strategic account and Sales SVP
        if(trigger.isBefore && acctRegHeadChangeList.size() > 0){
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
        if (trigger.isBefore && (trigger.isInsert || trigger.isUpdate)) {
            Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
            Schema.SObjectType accountSchema = schemaMap.get('Account');
            Map<String, Schema.SObjectField> fieldMap = accountSchema.getDescribe().fields.getMap();
            for (Account a : trigger.new) {
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
                
                // Authorized
             /*   if (a.Target_Account__c == null) {
                    missingAuthorized = missingAuthorized + fieldMap.get('Target_Account__c').getDescribe().getLabel() + '\r\n';
                }
                
                if (a.Revenue_Potential__c == null) {
                    missingAuthorized = missingAuthorized + fieldMap.get('Revenue_Potential__c').getDescribe().getLabel() + '\r\n';
                } */
                
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
                    missingAuthorized = missingAuthorized + fieldMap.get('Bill_To_Location__c').getDescribe().getLabel() + '\r\n';
                }
                
                if (a.Customer_Shipping_Label__c == null) {
                    missingAuthorized = missingAuthorized + fieldMap.get('Customer_Shipping_Label__c').getDescribe().getLabel() + '\r\n';
                }
                
                if (a.Primary_Account_Manager__c < 1) {
                    missingAuthorized = missingAuthorized + 'Primary Account Manager (ATP) \r\n';
                }
                
                if (a.Primary_Customer_Service_Rep__c < 1) {
                    missingAuthorized = missingAuthorized + 'Primary Customer Service Rep (ATP) \r\n';
                }
                
                if (a.Backup_Customer_Service_Rep__c < 1) {
                    missingAuthorized = missingAuthorized + 'Backup Customer Service Rep (ATP) \r\n';
                }
                
                if (a.Primary_Field_Engineer__c < 1) {
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
        /* ========================================= before trigger process End ============================================== */
        //Validation added by Sunil for case # 5650
        if(trigger.isBefore && portalAdminChangedAcctIdSet.size()>0 ){
                                
            //Account[] actLst=[Select Id,Customer_Portal_Admin__c,Customer_Portal_Admin__r.ContactId, Customer_Portal_Admin__r.ProfileId, (Select Id, AccountId,Is_Portal_User_Created__c,Is_Portal_User_Active__c  From Contacts where Is_Portal_User_Active__c= true and Is_Portal_User_Created__c = true) From Account where Id IN:portalAdminChangedAcctIdSet];
            Set<Id> adminIds = new Set<Id>();
            for (Account a : portalAdminChangedAcctIdSet) {
                adminIds.add(a.Customer_Portal_Admin__c);
            }
            
            Map<Id, User> mapUser = new Map<Id, User>([SELECT    Id
                                                                 , ProfileId
                                                                 , Contact.AccountId
                                                       FROM      User
                                                       WHERE     Id IN :adminIds]);
            
            //if(actLst.size()>0){
                //Retrieves the profile id for all portal admin
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
                
                /*Integer validationPassed;
                Boolean throwError;
                Set<Id> actforErrorSet=new Set<Id>();
                for (Integer r=0;r<actLst.size();r++){
                    validationPassed=0;
                    if (profileIdSet.contains(actLst[r].Customer_Portal_Admin__r.ProfileId)){
                        validationPassed=1;
                    }
                    
                    if(actLst[r].Contacts.size()>0){
                        for(Integer j=0;j<actLst[r].Contacts.size();j++){
                            if(actLst[r].Customer_Portal_Admin__r.ContactId==actLst[r].Contacts[j].Id){
                                validationPassed=validationPassed+1;
                            }
                        }
                    }
                    //If value has not passed both the validations
                    if(validationPassed!=2){
                        actforErrorSet.add(actLst[r].Id);
                    }
                }
                
                for (Id accId : portalAdminChangedAcctIdSet){
                    if(actforErrorSet.contains(accid)){
                        trigger.newmap.get(accId).addError('POC Published in Customer Portal should be portal admin associated to this account.');
                    }
                }*/
                
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
            //}
            
        }//Sunil Code ends here for Case # 5650
        
        //update opportunity program and device
        /* --------------------------------------Start Update Opprotunity Program & Device Trigger Code--------------------------------- */
        if(trigger.isafter && trigger.isupdate && sAccRegionChange.size()>0){
            List<Opportunity_Program__c> childOppPrograms = [Select Id,
                                                                Account__c,
                                                                SetGroup__c,
                                                                (select Id, Account__c, SetGroup__c from Devices__r)
                                                                From Opportunity_Program__c
                                                                Where Account__r.Id in : sAccRegionChange];
        
                                                      
            if(childOppPrograms.size() >0) { 
                list<Device__c> childDevices = new list<Device__c>();
                
                for(Opportunity_Program__c op : childOppPrograms) {
                    op.SetGroup__c = trigger.newMap.get(op.account__c).Region__c;
                    for(Device__c dev: op.Devices__r){
                        dev.SetGroup__c = op.SetGroup__c;
                    }
                    
                    childDevices.addAll(op.Devices__r);
                }
                
                update childOppPrograms;
                
                if(childDevices.size() > 0) update childDevices;
                
            }
                                         
        }
        /* --------------------------------------End Update Opprotunity Program & Device Trigger Code--------------------------------- */
        
        /* --------------------------------------Start Update Manual Device Trigger Code--------------------------------- */
        if(trigger.isafter && sAcctNameChanged.size() > 0){
            List<Manual_Device__c> manualDeviceListToUpdate = new List<Manual_Device__c>();
            
            for(Manual_Device__c md : [SELECT Account__c, Device_Id__c, Account_Name__c, Device__c FROM Manual_Device__c  Where Account__c IN : sAcctNameChanged]){
                md.Account_Name__c = trigger.newmap.get(md.Account__c).name;
                manualDeviceListToUpdate.add(md);
            }
            
            if( manualDeviceListToUpdate.size()>0){
                update manualDeviceListToUpdate;
            }   
        
        }
        /* --------------------------------------End Update Manual Device Trigger Code--------------------------------- */
        
       
        
     /*    if(trigger.isAfter && AccountTriggerRun.customerNo != 0){
            Double csn = CustomerNumber__c.getInstance('Update Customer No').Customer_No__c;
            if(AccountTriggerRun.customerNo != csn){
                CustomerNumber__c cn = [select id, Customer_No__c from CustomerNumber__c limit 1];
                cn.Customer_No__c = AccountTriggerRun.customerNo;
                update cn;
            }
            
            AccountTriggerRun.customerNo = 0;
        }*/
 /*----------------------commented by sunita end--------------------------------------------------*/  
  /*----------------------added by sunita start--------------------------------------------------*/          
         if(trigger.isAfter && AccountTriggerRun.customerNo != 0  && !test.isrunningtest()){
         
                   
            Double Myval= CustomerNumber__c.getInstance('Update Customer No').Customer_No__c;
            if(AccountTriggerRun.customerNo != Myval){
                CustomerNumber__c cn = [select id, Customer_No__c from CustomerNumber__c limit 1];
                cn.Customer_No__c = AccountTriggerRun.customerNo;
                update cn;
            }
            
            AccountTriggerRun.customerNo = 0;
        }
        /* --------------------------------------End GenerateCustomerNumber Trigger Code--------------------------------- */
        
        
        //23072014 Tlai - added logic to keep account team when owner changed
        if(trigger.isAfter && sAcc4OwnerChange.size() > 0) {//Tlai      24072014    - Changed as per case 30757
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
                                                where  Flag_for_Delete__c != true// (IsAccountOwner__c = 'TRUE' or Team_Role__c = :PRIMARY_ACCOUTN_MANAGER)
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
                        //atp.Account_Access__c = READ_ONLY;
                        //atp.Opportunity_Access__c = READ_ONLY;
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
            system.debug('>>>>>>>>>>sAcc4OwnerChange:'+sAcc4OwnerChange);
            if(sAcc4OwnerChange.size() > 0) {
                for(id accId : sAcc4OwnerChange){
                    Account_Team_Proxy__c newAtp = new Account_Team_Proxy__c();
                    newAtp.User__c                  =   Trigger.newmap.get(accId).OwnerId;
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
                        trigger.newmap.get(atpList[j].account__c).addError(usrList[j].getErrors()[0].getMessage());
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
        if (Trigger.isAfter && listInsertAccounts.size() > 0) {
            AccountHierarchyGeneration.insertAccountHierarchy(listInsertAccounts);
        }
        
        if (Trigger.isAfter && listUpdateAccounts.size() > 0) {
            AccountHierarchyGeneration.updateAccountHierarchy(listUpdateAccounts);
        }
        
        /* --------------------------------------Start AccountShortNameValidation Trigger Code--------------------------------- */
        if(Trigger.isafter && shortName2AccountMap.size() > 0){    
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
          
         /* -------------------- Added BY Mallika -----------------------*/
              if(!Test.isRunningTest()){
              if(trigger.isbefore && trigger.isInsert){
               
                Set <String> shortNames = new Set<String>();
                List<WordsForShortName__c> WSN = WordsForShortName__c.getall().values();
                String searchqueryAccount;
                String ShortName;
                for(Account acc: trigger.new){
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
                    shortNames.add(ShortName.toLowerCase());
                }       

           // List <Account> lAccounts = [SELECT Id, Short_Name__c FROM Account  where Short_Name__c in :shortNames ORDER BY Short_Name__c DESC LIMIT 1];
            searchqueryAccount = 'FIND '+shortNames+ ' IN ALL Fields RETURNING Account(ID,Short_Name__c Where Short_Name__c!=Null ORDER BY Short_Name__c Desc )';
            List<List<sObject>> sAccountsList = search.query(searchqueryAccount);
            Account[] sAccounts = (Account[])sAccountsList[0];
            Map <String,Account> mShortNamesToAccountId = new Map<String,Account>(); 
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
            for (Account aNew:Trigger.New)
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
          }
        /* --------------------------------------End AccountShortNameValidation Trigger Code--------------------------------- */    
        
        //Added by ASOLITO 22/04/2013
        //Fire Account Detail Changes to ERP    
        if(Trigger.isAfter && !AccountDetailChange.hasRun){
            //Shuchi - 03042015 - Added record type check on the ERP callout to bypass IBM Accounts 
            //Sunil - 07202015- Added condition to compare new and old account name for case # 43847
            for(Account t: trigger.new){
                if(t.stage__c == 'Authorized' && t.primary_contact__c <> null && t.RecordTypeId != EnvironmentVariable.get('ACCT_RT_ID_IBM_ACCOUNT')){
                    if(trigger.isUpdate &&              
                            (Trigger.newMap.get(t.id).stage__c <> Trigger.oldMap.get(t.id).stage__c) ||
                            (Trigger.newMap.get(t.id).organization_unit__c <> Trigger.oldMap.get(t.id).organization_unit__c) ||
                            (Trigger.newMap.get(t.id).bill_to_address_1__c <> Trigger.oldMap.get(t.id).bill_to_address_1__c) ||
                            (Trigger.newMap.get(t.id).bill_to_address_2__c <> Trigger.oldMap.get(t.id).bill_to_address_2__c) ||
                            (Trigger.newMap.get(t.id).bill_to_address_3__c <> Trigger.oldMap.get(t.id).bill_to_address_3__c) ||
                            (Trigger.newMap.get(t.id).bill_to_address_4__c <> Trigger.oldMap.get(t.id).bill_to_address_4__c) ||
                            (Trigger.newMap.get(t.id).bill_to_city__c <> Trigger.oldMap.get(t.id).bill_to_city__c) ||
                            (Trigger.newMap.get(t.id).bill_to_state__c <> Trigger.oldMap.get(t.id).bill_to_state__c) ||
                            (Trigger.newMap.get(t.id).bill_to_country__c <> Trigger.oldMap.get(t.id).bill_to_country__c) ||
                            (Trigger.newMap.get(t.id).bill_to_postal_zip_code__c <> Trigger.oldMap.get(t.id).bill_to_postal_zip_code__c) ||
                            (Trigger.newMap.get(t.id).bill_to_location__c <> Trigger.oldMap.get(t.id).bill_to_location__c) ||                 
                            (Trigger.newMap.get(t.id).duns__c <> Trigger.oldMap.get(t.id).duns__c) ||               
                            (Trigger.newMap.get(t.id).early_ship_days__c <> Trigger.oldMap.get(t.id).early_ship_days__c) ||
                            (Trigger.newMap.get(t.id).hard_peg_flag__c <> Trigger.oldMap.get(t.id).hard_peg_flag__c) ||
                            (Trigger.newMap.get(t.id).overshipment_percent__c <> Trigger.oldMap.get(t.id).overshipment_percent__c) ||
                            (Trigger.newMap.get(t.id).sales_territory__c <> Trigger.oldMap.get(t.id).sales_territory__c) || 
                            (Trigger.newMap.get(t.id).tax_number__c <> Trigger.oldMap.get(t.id).tax_number__c) ||
                            (Trigger.newMap.get(t.id).Name <> Trigger.oldMap.get(t.id).Name) ||
                            (Trigger.newMap.get(t.id).primary_contact__c <> Trigger.oldMap.get(t.id).primary_contact__c)){                                                                                      
                        AccountDetailChange.send(t);
                    } else if(trigger.isInsert){
                        AccountDetailChange.send(t);
                    }                                                                   
                } /* Tlai 29072014 as per case 5279 else if(t.stage__c == 'Inactive'){
                    if(trigger.isUpdate){
                        if(Trigger.newMap.get(t.id).stage__c <> Trigger.oldMap.get(t.id).stage__c){
                            AccountDetailChange.send(t);
                        }    
                    }
                }*/
            }       
        }
        
        // ZAmbat 08222014
        if (mapAccountRH.size() > 0) {
          VisitationSetRegionHead.updateRegionHead(mapAccountRH);
        }
        
        // ZAmbat 11112014
        system.debug('listAccountIds ====================> ' + listAccountIds);
        if (listAccountIds.size() > 0 && !test.isRunningTest()) {
            AccountDetailChange.setPrimaryAddress(listAccountIds);
        }
        
        /* ========================================= after trigger process End ============================================== */
        
        AccountTriggerRun.hasAccountTriggerRun=false;
        AccountTriggerRun.isAddressValidated = true;
    }// end of trigger
    
    
    private void updateAccountDetail(Account acct){
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
            
            // Modified by Thomas Lai 15/01/2014/
            /*if ((acct.Region_Change_Request__c == 'US')&& (acct.Financial_Territory_Change_Request__c == 'US-West' || String.isBlank(acct.Financial_Territory_Change_Request__c))){
                acct.Sales_Group__c = 'USW-GROUP1';
            }
            
            if ((acct.Region_Change_Request__c == 'US')&& (acct.Financial_Territory_Change_Request__c == 'US-East')){
                acct.Sales_Group__c = 'USE-GROUP1';
            }
            
            if ((acct.Region_Change_Request__c == 'US')&& (acct.Financial_Territory_Change_Request__c == 'QUALCOMM')){
                acct.Sales_Group__c = 'QUALCOMM GROUP';
            }*/
            
            //Start - Modified by Poulami 22/09/2015
            if ((acct.Region_Change_Request__c == 'US-West')&& (acct.Financial_Territory_Change_Request__c == 'US West1' || acct.Financial_Territory_Change_Request__c == 'US NW' || acct.Financial_Territory_Change_Request__c == 'US SW' || acct.Financial_Territory_Change_Request__c == 'US West2' || String.isBlank(acct.Financial_Territory_Change_Request__c))){
                acct.Sales_Group__c = 'USW-GROUP1';
            }
            /*if ((acct.Region_Change_Request__c == 'US-West')&& (acct.Financial_Territory_Change_Request__c == 'US NW')){
                acct.Sales_Group__c = 'USNW-GROUP1';
            }
            if ((acct.Region_Change_Request__c == 'US-West')&& (acct.Financial_Territory_Change_Request__c == 'US SW')){
                acct.Sales_Group__c = 'USSW-GROUP1';
            }
            if ((acct.Region_Change_Request__c == 'US-West')&& (acct.Financial_Territory_Change_Request__c == 'US SEC')){
                acct.Sales_Group__c = 'USSEC-GROUP1';
            }*/
            if ((acct.Region_Change_Request__c == 'US-East')&& (acct.Financial_Territory_Change_Request__c == 'US-East' || acct.Financial_Territory_Change_Request__c == 'US Central1' || acct.Financial_Territory_Change_Request__c == 'US Central2' || acct.Financial_Territory_Change_Request__c == 'US NE1' || acct.Financial_Territory_Change_Request__c == 'US NE2' || acct.Financial_Territory_Change_Request__c == 'US NE3' || acct.Financial_Territory_Change_Request__c == 'US SE' || String.isBlank(acct.Financial_Territory_Change_Request__c))){
                acct.Sales_Group__c = 'USE-GROUP1';
            }
            /*if ((acct.Region_Change_Request__c == 'US-East')&& (acct.Financial_Territory_Change_Request__c == 'US Central1')){
                acct.Sales_Group__c = 'USC1-GROUP1';
            }
            if ((acct.Region_Change_Request__c == 'US-East')&& (acct.Financial_Territory_Change_Request__c == 'US Central2')){
                acct.Sales_Group__c = 'USC2-GROUP1';
            }
            if ((acct.Region_Change_Request__c == 'US-East')&& (acct.Financial_Territory_Change_Request__c == 'US NE1')){
                acct.Sales_Group__c = 'USNE1-GROUP1';
            }
            if ((acct.Region_Change_Request__c == 'US-East')&& (acct.Financial_Territory_Change_Request__c == 'US NE2')){
                acct.Sales_Group__c = 'USNE2-GROUP1';
            }
            if ((acct.Region_Change_Request__c == 'US-East')&& (acct.Financial_Territory_Change_Request__c == 'US SE')){
                acct.Sales_Group__c = 'USSE-GROUP1';
            }*/
            if ((acct.Region_Change_Request__c == 'US-SoCal')&& (acct.Financial_Territory_Change_Request__c == 'US SoCal1' || acct.Financial_Territory_Change_Request__c == 'US SoCal2' || acct.Financial_Territory_Change_Request__c == 'US SoCal3' || String.isBlank(acct.Financial_Territory_Change_Request__c))){
                acct.Sales_Group__c = 'US SoCal-GROUP1';
            }
            /*if ((acct.Region_Change_Request__c == 'US-SoCal')&& (acct.Financial_Territory_Change_Request__c == 'US-SoCal2')){
                acct.Sales_Group__c = 'USSoCal2-GROUP1';
            }
            if ((acct.Region_Change_Request__c == 'US-SoCal')&& (acct.Financial_Territory_Change_Request__c == 'US-SoCal3')){
                acct.Sales_Group__c = 'USSoCal3-GROUP1';
            }*/
            //End - Modified by Poulami 22/09/2015           
            
            if ((acct.Region_Change_Request__c == 'EUR')&& (acct.Financial_Territory_Change_Request__c == 'EMEA-ROA'|| String.isBlank(acct.Financial_Territory_Change_Request__c))){
                acct.Sales_Group__c = 'EUR-GROUP1';
            }
            
            if(acct.Region_Change_Request__c == 'APJ' && (acct.Financial_Territory_Change_Request__c =='Greater China' ||String.isBlank(acct.Financial_Territory_Change_Request__c))){
                acct.Sales_Group__c = 'GC-GROUP1';
            }
            
            if(acct.Region_Change_Request__c == 'APJ' && acct.Financial_Territory_Change_Request__c =='Japan Korea'){
                acct.Sales_Group__c = 'JK-GROUP1';
            }
            
            //Start - Modified by Poulami 22/09/2015            
            if((acct.Region_Change_Request__c == 'ASIC') && (acct.Financial_Territory_Change_Request__c =='NA-A' || acct.Financial_Territory_Change_Request__c =='AP-A' || acct.Financial_Territory_Change_Request__c =='EMEA-A' || acct.Financial_Territory_Change_Request__c =='JP-A' || String.isBlank(acct.Financial_Territory_Change_Request__c))){
                acct.Sales_Group__c = 'ASIC-GROUP1';
            }
            
            /*if(acct.Region_Change_Request__c == 'ASIC' && acct.Financial_Territory_Change_Request__c =='AP-A'){
                acct.Sales_Group__c = 'AP-GROUP1';
            }
            
            if(acct.Region_Change_Request__c == 'ASIC' && acct.Financial_Territory_Change_Request__c =='EMEA-A'){
                acct.Sales_Group__c = 'EMEA-GROUP1';
            }
            
            if(acct.Region_Change_Request__c == 'ASIC' && acct.Financial_Territory_Change_Request__c =='JP-A'){
                acct.Sales_Group__c = 'JP-GROUP1';
            }*/
            
            if((acct.Region_Change_Request__c == 'A&D') && (acct.Financial_Territory_Change_Request__c =='A&D' || String.isBlank(acct.Financial_Territory_Change_Request__c))){
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
        acct.Account_Alias_Change_Request__c        =   null;
        acct.Account_Details_Change_By_Trigger__c   =   datetime.now();
        
        // Added 05/17/2013 - Revision of populating/validating Organization Unit process
        acct.New_Organization_Unit_Request__c = null;
    }
}