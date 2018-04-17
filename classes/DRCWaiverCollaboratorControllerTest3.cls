@isTest(SeeAllData=false)
private class DRCWaiverCollaboratorControllerTest3 {    
    static testMethod void myDesignWaiverMethodTest3() {
        
        recordtype rt = [select id from recordtype where sobjecttype = 'Account'
                         and developername = 'GLOBALFOUNDRIES_Internal'
                        ];
        
        DesignCollaboratorTestData.getCustomSettings('DEVICE_STATUS_ACTIVE');
        DesignCollaboratorTestData.getCustomSettings('ACT_TM_PRXY_TM_RL_CE');
        DesignCollaboratorTestData.getCustomSettings('ACCT_TM_PRXY_TM_RL_FP');
        DesignCollaboratorTestData.getCustomSettings('ACCT_TM_PRXY_TM_RL_AM');
        DesignCollaboratorTestData.getCustomSettings('ACCT_TM_PRXY_TM_RL_TS');
        DesignCollaboratorTestData.getCustomSettings('ACCT_TM_PRXY_TM_RL_AE');
        DesignCollaboratorTestData.getCustomSettings('ACCT_TM_PRXY_TM_RL_CSR');
        DesignCollaboratorTestData.getCustomSettings('GF_INTEGRATION_PROFILE_ID');
        DesignCollaboratorTestData.getCustomSettings('ACCT_TM_PRXY_TM_RL_PCSR');
        DesignCollaboratorTestData.getCustomSettings('ACCT_TM_PRXY_TM_RL_PAM');
        DesignCollaboratorTestData.getCustomSettings('ACCT_TM_PRXY_TM_RL_AA');
        DesignCollaboratorTestData.getCustomSettings('ACCT_TM_PRXY_TM_RL_PFAE');
        DesignCollaboratorTestData.getCustomSettings1('ACCT_PFTS_OR_BCSR_NOT_FOUND_ERROR');
        DesignCollaboratorTestData.getCustomSettings1('ACCT_TM_DUP_USER_ROLE_ERROR');
        DesignCollaboratorTestData.getCustomSettings1('ATP_INTEGRATION_SEQUENCE_ERROR');
        DesignCollaboratorTestData.getCustomSettings1('ATP_FLAG_FOR_DELETE_UPDATE_ERROR');
        DesignCollaboratorTestData.getCustomSettings1('ATP_FLAG_FOR_DELETE_CREATION_ERROR');
        DesignCollaboratorTestData.getCustomSettings4('Update Bill To Address No');
        
		Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MYTEST ACCOUNT1');  
        fieldValueMap.put('Account_Type__c', 'Customer');                           
        fieldValueMap.put('sub_type__c', 'Indirect');        
        fieldValueMap.put('site_department__c', 'IT');  
        fieldValueMap.put('Account_Manager__c', userinfo.getuserid());        
        fieldValueMap.put('transaction_type__c', 'Non-Transactional');                          
        fieldValueMap.put('region__c', 'US');        
        fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Corporate_City__c', 'Test City');                
        fieldValueMap.put('Corporate_Country__c', 'Singapore');
        fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Bill_To_City__c', 'Test City');            
        fieldValueMap.put('Bill_To_Country__c', 'Singapore');        
        fieldValueMap.put('Fab_9_10__c','No');
              
		Account acc = AccountDataFactory.createAccount(fieldValueMap);
        Profile sysAdminProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User sysAdminUser = [SELECT Id, Name FROM User WHERE Profile.Name = 'System Administrator'
                             AND isActive = true
                            ].get(0);
        User userSU = new User();
        System.runAs(sysAdminUser) {
            Profile stdUserProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User'];
            UserRole usrRole = [SELECT Id FROM UserRole WHERE Name = 'GLOBALFOUNDRIES Corporate'];
            
            userSU = new User(alias = 'testMRS2', email = 'testMRS2@test.com',
                              emailencodingkey = 'UTF-8', lastname = 'testMRS2Last', firstname = 'testMRS2First', languagelocalekey = 'en_US',
                              localesidkey = 'en_US', profileid = stdUserProfile.Id, UserRoleId = usrRole.Id,
                              timezonesidkey = 'America/Los_Angeles', username = 'testMRS2@test.com', communitynickname = 'testMRS2');
            
            insert userSU;
            
            
        }
        
               
        Wavier_Collaborator__c waiverColl11 = DesignCollaboratorTestData.getWaiverCollaborator4DFM(userSU.FederationIdentifier,userSU.FederationIdentifier,acc.Id ); 
        waiverColl11.Revert_Collaborator__c = true;
        waiverColl11.Revert_Stage__c = 'Review';
        update waiverColl11;
        waiverColl11.IsSubmitted__c = true;
        waiverColl11.LastRuleSelected_Customer__c=userSU.FederationIdentifier+';'+userSU.FederationIdentifier;
        DesignCollaboratorTestData.getWaiverRuleListForiFDWCR(waiverColl11.Id);
        DesignCollaboratorTestData.getWaiverRuleListForiFDWEA(waiverColl11.Id);
        DesignCollaboratorTestData.getWaiverRuleListForFDCCWCR1(waiverColl11.Id); 
        DesignCollaboratorTestData.getWaiverRuleListForiFDWCR(waiverColl11.Id);
        DesignCollaboratorTestData.getWaiverRuleListForiFDWEA(waiverColl11.Id);
        DesignCollaboratorTestData.getWaiverRuleListForFDCCWCR1(waiverColl11.Id);
        list<Waiver_Rule_List__c>  waiverCollList = DesignCollaboratorTestData.getWaiverRuleList(waiverColl11.Id);
		waiverCollList[0].isIntermediateSave__c = true;
        waiverCollList[0].Prime_Die_Name__c = 'Prime Die1';
        waiverCollList[0].isFAESubmitted__c = false;
        waiverCollList[0].Final_Stage__c = 'Open';
        waiverCollList[0].IsGfAcceptsRisk__c = true;
        waiverCollList[0].Revert_Rule__c = true;
        update waiverCollList;
        
        list<Approval_Task_Instance__c> appList = new list<Approval_Task_Instance__c>();
        appList.add(DesignCollaboratorTestData.getApprovalTaskInstance(waiverCollList[0].Id));

        Chip__c chipObj = new Chip__c();
        chipObj.Chip_Name__c = 'DEVICEID1234';
        chipObj.Wavier_Collaborator__c = waiverColl11.Id;
        chipObj.MantisId1__c= '384868';
        chipObj.MantisId2__c= '384845';
        chipObj.Prime_Die_Name__c = waiverCollList[0].Prime_Die_Name__c;
        chipObj.PrimeDieComments1__c='PrimeDieComments 1';
        chipObj.PrimeDieComments2__c='PrimeDieComments 2';
        chipObj.Mantis_DRCPLUS__c= true;
        chipObj.Mantis_MAS__c = true;
        chipObj.Mantis_MCD__c = true;
        
        insert chipObj;	        
        
        Attachment   atc = DesignCollaboratorTestData.getAttachmentTestData(waiverCollList.get(1).Id) ;       
        ApexPages.StandardController stdController = new ApexPages.StandardController(waiverColl11);        
        DWC_CollaboratorCtrl designWaiver = new DWC_CollaboratorCtrl(stdController);
        system.debug('waiverCollList>>>>>>>>>>'+waiverCollList);
        

        designWaiver.hiddenUsrIds = userSU.Id;
        DWC_CollaboratorCtrl.ruleListTableWrapper ruleLstTableWrap  = new DWC_CollaboratorCtrl.ruleListTableWrapper(true, waiverCollList.get(0), 'ruleListTableWrapper test', 'ruleListTableWrapper test', 'Attachment test', 'Selected',false);
        Approval_Task_Instance__c appTask = new Approval_Task_Instance__c();    

        
        String userGroup = 'QA';
        String description = 'description';
        String decision = 'decision';
        String users = String.valueOf(userSU.Id);
        String collabId = String.valueOf(waiverColl11.Id);
        String finalstatus = 'All';
        String primediename = '';
        String ruleType = 'Mandatory';
        Integer pagenumber = 1;
        Integer pageSize = 10;
        String searchval = 'Test';
        Test.startTest();
        DWC_CollaboratorCtrl.approveRejectAllRules(userGroup,collabId,description,decision);
        DWC_CollaboratorCtrl.submitRuleList(waiverCollList,collabId);
        DWC_CollaboratorCtrl.getRuleStatusMapForReleaseToCustomer(collabId);
        DWC_CollaboratorCtrl.getRuleListForDataTable(collabId);
        DWC_CollaboratorCtrl.finalRevertSubmit(collabId);
        DWC_CollaboratorCtrl.submitFAERules(waiverCollList,collabId,users);
        DWC_CollaboratorCtrl.getCount(collabId,finalstatus,primediename,ruleType);
        DWC_CollaboratorCtrl.test(pagenumber,pageSize,collabId,finalstatus,primediename,searchval,ruleType);
        designWaiver.getAMDetails();

        
        Test.stopTest();
        
        System.Assert(waiverColl11.Revert_Collaborator__c,true);
    }
    
        static testMethod void myDesignWaiverMethodTest03() {
        
        recordtype rt = [select id from recordtype where sobjecttype = 'Account'
                         and developername = 'GLOBALFOUNDRIES_Internal'
                        ];
        
        DesignCollaboratorTestData.getCustomSettings('DEVICE_STATUS_ACTIVE');
        DesignCollaboratorTestData.getCustomSettings('ACT_TM_PRXY_TM_RL_CE');
        DesignCollaboratorTestData.getCustomSettings('ACCT_TM_PRXY_TM_RL_FP');
        DesignCollaboratorTestData.getCustomSettings('ACCT_TM_PRXY_TM_RL_AM');
        DesignCollaboratorTestData.getCustomSettings('ACCT_TM_PRXY_TM_RL_TS');
        DesignCollaboratorTestData.getCustomSettings('ACCT_TM_PRXY_TM_RL_AE');
        DesignCollaboratorTestData.getCustomSettings('ACCT_TM_PRXY_TM_RL_CSR');
        DesignCollaboratorTestData.getCustomSettings('GF_INTEGRATION_PROFILE_ID');
        DesignCollaboratorTestData.getCustomSettings('ACCT_TM_PRXY_TM_RL_PCSR');
        DesignCollaboratorTestData.getCustomSettings('ACCT_TM_PRXY_TM_RL_PAM');
        DesignCollaboratorTestData.getCustomSettings('ACCT_TM_PRXY_TM_RL_AA');
        DesignCollaboratorTestData.getCustomSettings('ACCT_TM_PRXY_TM_RL_PFAE');    
        DesignCollaboratorTestData.getCustomSettings1('ACCT_PFTS_OR_BCSR_NOT_FOUND_ERROR');
        DesignCollaboratorTestData.getCustomSettings1('ACCT_TM_DUP_USER_ROLE_ERROR');
        DesignCollaboratorTestData.getCustomSettings1('ATP_INTEGRATION_SEQUENCE_ERROR');
        DesignCollaboratorTestData.getCustomSettings1('ATP_FLAG_FOR_DELETE_UPDATE_ERROR');
        DesignCollaboratorTestData.getCustomSettings1('ATP_FLAG_FOR_DELETE_CREATION_ERROR');
        DesignCollaboratorTestData.getCustomSettings4('Update Bill To Address No');    
        
		Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MYTEST ACCOUNT1');  
        fieldValueMap.put('Account_Type__c', 'Customer');                           
        fieldValueMap.put('sub_type__c', 'Indirect');        
        fieldValueMap.put('site_department__c', 'IT');  
        fieldValueMap.put('Account_Manager__c', userinfo.getuserid());        
        fieldValueMap.put('transaction_type__c', 'Non-Transactional');                          
        fieldValueMap.put('region__c', 'US');        
        fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Corporate_City__c', 'Test City');                
        fieldValueMap.put('Corporate_Country__c', 'Singapore');
        fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Bill_To_City__c', 'Test City');            
        fieldValueMap.put('Bill_To_Country__c', 'Singapore');        
        fieldValueMap.put('Fab_9_10__c','No');
              
		Account acc = AccountDataFactory.createAccount(fieldValueMap);
        Profile sysAdminProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User sysAdminUser = [SELECT Id, Name FROM User WHERE Profile.Name = 'System Administrator'
                             AND isActive = true
                            ].get(0);
        User userSU = new User();
        System.runAs(sysAdminUser) {
            Profile stdUserProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User'];
            UserRole usrRole = [SELECT Id FROM UserRole WHERE Name = 'GLOBALFOUNDRIES Corporate'];
            
            userSU = new User(alias = 'testMRS2', email = 'testMRS2@test.com',
                              emailencodingkey = 'UTF-8', lastname = 'testMRS2Last', firstname = 'testMRS2First', languagelocalekey = 'en_US',
                              localesidkey = 'en_US', profileid = stdUserProfile.Id, UserRoleId = usrRole.Id,
                              timezonesidkey = 'America/Los_Angeles', username = 'testMRS2@test.com', communitynickname = 'testMRS2');
            
            insert userSU;
            
            
        }
        
               
        Wavier_Collaborator__c waiverColl11 = DesignCollaboratorTestData.getWaiverCollaborator4DFM(userSU.FederationIdentifier,userSU.FederationIdentifier,acc.Id ); 
        waiverColl11.IsSubmitted__c = true;
        waiverColl11.LastRuleSelected_Customer__c=userSU.FederationIdentifier+';'+userSU.FederationIdentifier;
        DesignCollaboratorTestData.getWaiverRuleListForiFDWCR(waiverColl11.Id);
        DesignCollaboratorTestData.getWaiverRuleListForiFDWEA(waiverColl11.Id);
        DesignCollaboratorTestData.getWaiverRuleListForFDCCWCR1(waiverColl11.Id); 
        DesignCollaboratorTestData.getWaiverRuleListForiFDWCR(waiverColl11.Id);
        DesignCollaboratorTestData.getWaiverRuleListForiFDWEA(waiverColl11.Id);
        DesignCollaboratorTestData.getWaiverRuleListForFDCCWCR1(waiverColl11.Id);
        list<Waiver_Rule_List__c>  waiverCollList = DesignCollaboratorTestData.getWaiverRuleList(waiverColl11.Id);
        waiverCollList[0].isIntermediateSave__c = true;
        waiverCollList[0].Prime_Die_Name__c = 'Prime Die1';
        waiverCollList[0].isFAESubmitted__c = false;    
        waiverCollList[0].Final_Stage__c = 'PI';
        waiverCollList[0].IsGfAcceptsRisk__c = true;
        update waiverCollList;
        
        list<Approval_Task_Instance__c> appList = new list<Approval_Task_Instance__c>();
        appList.add(DesignCollaboratorTestData.getApprovalTaskInstance(waiverCollList[0].Id));
    
        
        Test.startTest();
        Attachment   atc = DesignCollaboratorTestData.getAttachmentTestData(waiverCollList.get(1).Id) ;       
        ApexPages.StandardController stdController = new ApexPages.StandardController(waiverColl11);        
        DWC_CollaboratorCtrl designWaiver = new DWC_CollaboratorCtrl(stdController);
        system.debug('waiverCollList>>>>>>>>>>'+waiverCollList);
        
		waiverColl11.FAB__c = '8';
        update waiverColl11;    
        designWaiver.hiddenUsrIds = userSU.Id;
        //designWaiver.customerOptions = waiverCollList.get(0).Id+',GfAcceptsRisk;';
        DWC_CollaboratorCtrl.ruleListTableWrapper ruleLstTableWrap  = new DWC_CollaboratorCtrl.ruleListTableWrapper(true, waiverCollList.get(0), 'ruleListTableWrapper test', 'ruleListTableWrapper test', 'Attachment test', 'Selected',false);
        Approval_Task_Instance__c appTask = new Approval_Task_Instance__c();    
        //designWaiver.saveRules();
        String users = String.valueOf(userSU.Id);    
        String finalstatus = 'All';
        String primediename = 'Prime die1';
        String ruleType = 'Additional';
        Integer pagenumber = 1;
        Integer pageSize = 10;
        String searchval = 'Test';    
        String collabId = String.valueOf(waiverColl11.Id);
        DWC_CollaboratorCtrl.getRuleListForDataTable(collabId);
        DWC_CollaboratorCtrl.submitFAERules(waiverCollList,collabId,users);
        DWC_CollaboratorCtrl.getCount(collabId,finalstatus,primediename,ruleType);
		DWC_CollaboratorCtrl.test(pagenumber,pageSize,collabId,finalstatus,primediename,searchval,ruleType);    
    
        Test.stopTest();
        
        System.Assert(waiverCollList[0].isFAESubmitted__c,false);    
    }
    static testMethod void myDesignWaiverMethodTest013() {
        
        recordtype rt = [select id from recordtype where sobjecttype = 'Account'
                         and developername = 'GLOBALFOUNDRIES_Internal'
                        ];
        
        DesignCollaboratorTestData.getCustomSettings('DEVICE_STATUS_ACTIVE');
        DesignCollaboratorTestData.getCustomSettings('ACT_TM_PRXY_TM_RL_CE');
        DesignCollaboratorTestData.getCustomSettings('ACCT_TM_PRXY_TM_RL_FP');
        DesignCollaboratorTestData.getCustomSettings('ACCT_TM_PRXY_TM_RL_AM');
        DesignCollaboratorTestData.getCustomSettings('ACCT_TM_PRXY_TM_RL_TS');
        DesignCollaboratorTestData.getCustomSettings('ACCT_TM_PRXY_TM_RL_AE');
        DesignCollaboratorTestData.getCustomSettings('ACCT_TM_PRXY_TM_RL_CSR');
        DesignCollaboratorTestData.getCustomSettings('GF_INTEGRATION_PROFILE_ID');
        DesignCollaboratorTestData.getCustomSettings('ACCT_TM_PRXY_TM_RL_PCSR');
        DesignCollaboratorTestData.getCustomSettings('ACCT_TM_PRXY_TM_RL_PAM');
        DesignCollaboratorTestData.getCustomSettings('ACCT_TM_PRXY_TM_RL_AA');
        DesignCollaboratorTestData.getCustomSettings('ACCT_TM_PRXY_TM_RL_PFAE');
        DesignCollaboratorTestData.getCustomSettings1('ACCT_PFTS_OR_BCSR_NOT_FOUND_ERROR');
        DesignCollaboratorTestData.getCustomSettings1('ACCT_TM_DUP_USER_ROLE_ERROR');
        DesignCollaboratorTestData.getCustomSettings1('ATP_INTEGRATION_SEQUENCE_ERROR');
        DesignCollaboratorTestData.getCustomSettings1('ATP_FLAG_FOR_DELETE_UPDATE_ERROR');
        DesignCollaboratorTestData.getCustomSettings1('ATP_FLAG_FOR_DELETE_CREATION_ERROR');
        DesignCollaboratorTestData.getCustomSettings4('Update Bill To Address No');
        
		Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MYTEST ACCOUNT1');  
        fieldValueMap.put('Account_Type__c', 'Customer');                           
        fieldValueMap.put('sub_type__c', 'Indirect');        
        fieldValueMap.put('site_department__c', 'IT');  
        fieldValueMap.put('Account_Manager__c', userinfo.getuserid());        
        fieldValueMap.put('transaction_type__c', 'Non-Transactional');                          
        fieldValueMap.put('region__c', 'US');        
        fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Corporate_City__c', 'Test City');                
        fieldValueMap.put('Corporate_Country__c', 'Singapore');
        fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Bill_To_City__c', 'Test City');            
        fieldValueMap.put('Bill_To_Country__c', 'Singapore');        
        fieldValueMap.put('Fab_9_10__c','No');
              
		Account acc = AccountDataFactory.createAccount(fieldValueMap);
        Profile sysAdminProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User sysAdminUser = [SELECT Id, Name FROM User WHERE Profile.Name = 'System Administrator'
                             AND isActive = true
                            ].get(0);
        User userSU = new User();
        System.runAs(sysAdminUser) {
            Profile stdUserProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User'];
            UserRole usrRole = [SELECT Id FROM UserRole WHERE Name = 'GLOBALFOUNDRIES Corporate'];
            
            userSU = new User(alias = 'testMRS2', email = 'testMRS2@test.com',
                              emailencodingkey = 'UTF-8', lastname = 'testMRS2Last', firstname = 'testMRS2First', languagelocalekey = 'en_US',
                              localesidkey = 'en_US', profileid = stdUserProfile.Id, UserRoleId = usrRole.Id,
                              timezonesidkey = 'America/Los_Angeles', username = 'testMRS2@test.com', communitynickname = 'testMRS2');
            
            insert userSU;
            
            
        }
        
               
        Wavier_Collaborator__c waiverColl11 = DesignCollaboratorTestData.getWaiverCollaborator4DFM(userSU.FederationIdentifier,userSU.FederationIdentifier,acc.Id ); 
        waiverColl11.IsSubmitted__c = true;
        waiverColl11.LastRuleSelected_Customer__c=userSU.FederationIdentifier+';'+userSU.FederationIdentifier;
        DesignCollaboratorTestData.getWaiverRuleListForiFDWCR(waiverColl11.Id);
        DesignCollaboratorTestData.getWaiverRuleListForiFDWEA(waiverColl11.Id);
        DesignCollaboratorTestData.getWaiverRuleListForFDCCWCR1(waiverColl11.Id); 
        DesignCollaboratorTestData.getWaiverRuleListForiFDWCR(waiverColl11.Id);
        DesignCollaboratorTestData.getWaiverRuleListForiFDWEA(waiverColl11.Id);
        DesignCollaboratorTestData.getWaiverRuleListForFDCCWCR1(waiverColl11.Id);
        list<Waiver_Rule_List__c>  waiverCollList = DesignCollaboratorTestData.getWaiverRuleList(waiverColl11.Id);
        waiverCollList[0].isIntermediateSave__c = false;
        waiverCollList[0].Prime_Die_Name__c = 'Prime Die1';
        waiverCollList[0].isFAESubmitted__c = false;    
        waiverCollList[0].Final_Stage__c = 'Open';
        waiverCollList[0].IsGfAcceptsRisk__c = true;
        update waiverCollList;
        
        list<Approval_Task_Instance__c> appList = new list<Approval_Task_Instance__c>();
        appList.add(DesignCollaboratorTestData.getApprovalTaskInstance(waiverCollList[0].Id));
        
        Test.startTest();
        Attachment   atc = DesignCollaboratorTestData.getAttachmentTestData(waiverCollList.get(1).Id) ;       
        ApexPages.StandardController stdController = new ApexPages.StandardController(waiverColl11);        
        DWC_CollaboratorCtrl designWaiver = new DWC_CollaboratorCtrl(stdController);
        system.debug('waiverCollList>>>>>>>>>>'+waiverCollList);
        
		waiverColl11.FAB__c = '7';
        update waiverColl11;    
        designWaiver.hiddenUsrIds = userSU.Id;
        //designWaiver.customerOptions = waiverCollList.get(0).Id+',GfAcceptsRisk;';
        DWC_CollaboratorCtrl.ruleListTableWrapper ruleLstTableWrap  = new DWC_CollaboratorCtrl.ruleListTableWrapper(true, waiverCollList.get(0), 'ruleListTableWrapper test', 'ruleListTableWrapper test', 'Attachment test', 'Selected',false);
        Approval_Task_Instance__c appTask = new Approval_Task_Instance__c();    
        //designWaiver.saveRules();
        String users = String.valueOf(userSU.Id);
        String finalstatus = 'Open';
        String primediename = 'All';
        String ruleType = 'All';
        Integer pagenumber = 1;
        Integer pageSize = 10;
        Integer count = 10;
        Integer countStart = 9;
        String searchval = 'Test';
        String collabId = String.valueOf(waiverColl11.Id);
        DWC_CollaboratorCtrl.getRuleListForDataTable(collabId);
        DWC_CollaboratorCtrl.submitFAERules(waiverCollList,collabId,users);
        DWC_CollaboratorCtrl.getCount(collabId,finalstatus,primediename,ruleType);
		DWC_CollaboratorCtrl.test(pagenumber,pageSize,collabId,finalstatus,primediename,searchval,ruleType);
        Test.stopTest();
        
        System.Assert(waiverCollList[0].isFAESubmitted__c,false);
    }
    static testMethod void myDesignWaiverMethodTest023() {
        
        recordtype rt = [select id from recordtype where sobjecttype = 'Account'
                         and developername = 'GLOBALFOUNDRIES_Internal'
                        ];
        
        DesignCollaboratorTestData.getCustomSettings('DEVICE_STATUS_ACTIVE');
        DesignCollaboratorTestData.getCustomSettings('ACT_TM_PRXY_TM_RL_CE');
        DesignCollaboratorTestData.getCustomSettings('ACCT_TM_PRXY_TM_RL_FP');
        DesignCollaboratorTestData.getCustomSettings('ACCT_TM_PRXY_TM_RL_AM');
        DesignCollaboratorTestData.getCustomSettings('ACCT_TM_PRXY_TM_RL_TS');
        DesignCollaboratorTestData.getCustomSettings('ACCT_TM_PRXY_TM_RL_AE');
        DesignCollaboratorTestData.getCustomSettings('ACCT_TM_PRXY_TM_RL_CSR');
        DesignCollaboratorTestData.getCustomSettings('GF_INTEGRATION_PROFILE_ID');
        DesignCollaboratorTestData.getCustomSettings('ACCT_TM_PRXY_TM_RL_PCSR');
        DesignCollaboratorTestData.getCustomSettings('ACCT_TM_PRXY_TM_RL_PAM');
        DesignCollaboratorTestData.getCustomSettings('ACCT_TM_PRXY_TM_RL_AA');
        DesignCollaboratorTestData.getCustomSettings('ACCT_TM_PRXY_TM_RL_PFAE');
        DesignCollaboratorTestData.getCustomSettings1('ACCT_PFTS_OR_BCSR_NOT_FOUND_ERROR');
        DesignCollaboratorTestData.getCustomSettings1('ACCT_TM_DUP_USER_ROLE_ERROR');
        DesignCollaboratorTestData.getCustomSettings1('ATP_INTEGRATION_SEQUENCE_ERROR');
        DesignCollaboratorTestData.getCustomSettings1('ATP_FLAG_FOR_DELETE_UPDATE_ERROR');
        DesignCollaboratorTestData.getCustomSettings1('ATP_FLAG_FOR_DELETE_CREATION_ERROR');
        DesignCollaboratorTestData.getCustomSettings4('Update Bill To Address No');
        
		Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MYTEST ACCOUNT1');  
        fieldValueMap.put('Account_Type__c', 'Customer');                           
        fieldValueMap.put('sub_type__c', 'Indirect');        
        fieldValueMap.put('site_department__c', 'IT');  
        fieldValueMap.put('Account_Manager__c', userinfo.getuserid());        
        fieldValueMap.put('transaction_type__c', 'Non-Transactional');                          
        fieldValueMap.put('region__c', 'US');        
        fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Corporate_City__c', 'Test City');                
        fieldValueMap.put('Corporate_Country__c', 'Singapore');
        fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Bill_To_City__c', 'Test City');            
        fieldValueMap.put('Bill_To_Country__c', 'Singapore');        
        fieldValueMap.put('Fab_9_10__c','No');
              
		Account acc = AccountDataFactory.createAccount(fieldValueMap);
        Profile sysAdminProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User sysAdminUser = [SELECT Id, Name FROM User WHERE Profile.Name = 'System Administrator'
                             AND isActive = true
                            ].get(0);
        User userSU = new User();
        System.runAs(sysAdminUser) {
            Profile stdUserProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User'];
            UserRole usrRole = [SELECT Id FROM UserRole WHERE Name = 'GLOBALFOUNDRIES Corporate'];
            
            userSU = new User(alias = 'testMRS2', email = 'testMRS2@test.com',
                              emailencodingkey = 'UTF-8', lastname = 'testMRS2Last', firstname = 'testMRS2First', languagelocalekey = 'en_US',
                              localesidkey = 'en_US', profileid = stdUserProfile.Id, UserRoleId = usrRole.Id,
                              timezonesidkey = 'America/Los_Angeles', username = 'testMRS2@test.com', communitynickname = 'testMRS2');
            
            insert userSU;
            
            
        }
        
               
        Wavier_Collaborator__c waiverColl11 = DesignCollaboratorTestData.getWaiverCollaborator4DFM(userSU.FederationIdentifier,userSU.FederationIdentifier,acc.Id ); 
        waiverColl11.IsSubmitted__c = true;
        waiverColl11.LastRuleSelected_Customer__c=userSU.FederationIdentifier+';'+userSU.FederationIdentifier;
        DesignCollaboratorTestData.getWaiverRuleListForiFDWCR(waiverColl11.Id);
        DesignCollaboratorTestData.getWaiverRuleListForiFDWEA(waiverColl11.Id);
        DesignCollaboratorTestData.getWaiverRuleListForFDCCWCR1(waiverColl11.Id); 
        DesignCollaboratorTestData.getWaiverRuleListForiFDWCR(waiverColl11.Id);
        DesignCollaboratorTestData.getWaiverRuleListForiFDWEA(waiverColl11.Id);
        DesignCollaboratorTestData.getWaiverRuleListForFDCCWCR1(waiverColl11.Id);
        list<Waiver_Rule_List__c>  waiverCollList = DesignCollaboratorTestData.getWaiverRuleList(waiverColl11.Id);
                
        Test.startTest();
        Attachment   atc = DesignCollaboratorTestData.getAttachmentTestData(waiverCollList.get(1).Id) ;       
        ApexPages.StandardController stdController = new ApexPages.StandardController(waiverColl11);        
        DWC_CollaboratorCtrl designWaiver = new DWC_CollaboratorCtrl(stdController);
        
		waiverColl11.FAB__c = '9';
        update waiverColl11;    
        designWaiver.hiddenUsrIds = userSU.Id;
        //designWaiver.customerOptions = waiverCollList.get(0).Id+',GfAcceptsRisk;';
        DWC_CollaboratorCtrl.ruleListTableWrapper ruleLstTableWrap  = new DWC_CollaboratorCtrl.ruleListTableWrapper(true, waiverCollList.get(0), 'ruleListTableWrapper test', 'ruleListTableWrapper test', 'Attachment test', 'Selected',false);
        Approval_Task_Instance__c appTask = new Approval_Task_Instance__c();    
        //designWaiver.saveRules();
        String users = String.valueOf(userSU.Id);
        String finalstatus = 'PI';
        String primediename = 'All';
        String ruleType = 'Mandatory';
        Integer pagenumber = 1;
        Integer pageSize = 10;
        String searchval = 'Test';
        String collabId = String.valueOf(waiverColl11.Id);
        DWC_CollaboratorCtrl.submitFAERules(waiverCollList,collabId,users);
        DWC_CollaboratorCtrl.getCount(collabId,finalstatus,primediename,ruleType);
		DWC_CollaboratorCtrl.test(pagenumber,pageSize,collabId,finalstatus,primediename,searchval,ruleType);
        Test.stopTest();
        
        System.Assert(waiverColl11.IsSubmitted__c ,true);
    }    
    
    
    
}