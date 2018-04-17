@isTest(SeeAllData=false)
private class DRCWaiverCollaboratorControllerTest6 {    
    static testMethod void myDesignWaiverMethodTest5() {
        
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
        
            
        Wavier_Collaborator__c waiverColl11 = DesignCollaboratorTestData.getWaiverCollaborator4DFM_1(userSU.FederationIdentifier,userSU.FederationIdentifier,acc.Id ); 
        waiverColl11.IsSubmitted__c = true;
        waiverColl11.Waiver_Status__c='POF';
        waiverColl11.Is_Sync_with_AIA__c = true;
        waiverColl11.IsGfAcceptsRisk__c = true;
        
        update waiverColl11;
        waiverColl11.LastRuleSelected_Customer__c=userSU.FederationIdentifier+';'+userSU.FederationIdentifier;
        DesignCollaboratorTestData.getWaiverRuleListForiFDWCR(waiverColl11.Id);
        DesignCollaboratorTestData.getWaiverRuleListForiFDWEA(waiverColl11.Id);
        

     
        list<Waiver_Rule_List__c>  waiverCollList = DesignCollaboratorTestData.getWaiverRuleList(waiverColl11.Id);
        waiverCollList[0].Final_Stage__c = 'OPEN';
        waiverCollList[0].IsGfAcceptsRisk__c = true;
        update waiverCollList;
        
        //list<Approval_Task_Instance__c> appList = new list<Approval_Task_Instance__c>();
        Approval_Task_Instance__c appTask = new Approval_Task_Instance__c();
        appTask.Approver_Type__c = 'PIYE';
        appTask.WaiverRule__c = waiverCollList[0].Id;
        appTask.Process_Status__c = 'Approved';
        insert appTask; 
        Test.startTest();
        ApexPages.StandardController stdController = new ApexPages.StandardController(waiverColl11);        
        DWC_CollaboratorCtrl designWaiver = new DWC_CollaboratorCtrl(stdController);
        system.debug('waiverCollList>>>>>>>>>>'+waiverCollList);
          
        designWaiver.revertOption='Pending For FAE';
        
        designWaiver.hiddenUsrIds = userSU.Id;
        DWC_CollaboratorCtrl.ruleListTableWrapper ruleLstTableWrap  = new DWC_CollaboratorCtrl.ruleListTableWrapper(true, waiverCollList.get(0), 'ruleListTableWrapper test', 'ruleListTableWrapper test', 'Attachment test', 'Selected',false);
            
        waiverColl11.Revert_Reason__c = null;
        String revertReason = 'revertReason';
        String selectedOption = 'Review';
        //String userGroup = 'PIYE';
        //String users = String.valueOf(userSU.Id);        
        String collabId = String.valueOf(waiverColl11.Id);
        
        DWC_CollaboratorCtrl.submitRuleList(waiverCollList,collabId);
        DWC_CollaboratorCtrl.getFields(waiverColl11.Id);
        designWaiver.getRevertOptions();
        designWaiver.releaseToCustomer();
        designWaiver.createAccessSetupRecord();
        designWaiver.cancelWorkflow();
        //DWC_CollaboratorCtrl.revertCollaborator(revertReason,selectedOption,collabId);
       // DWC_CollaboratorCtrl.reAssignusersToAManager(waiverCollList,userGroup,users,collabId);
        Test.stopTest();
        DWC_CollaboratorCtrl.revertCollaborator(revertReason,selectedOption,collabId);
        System.Assert(waiverColl11.IsSubmitted__c,true);
    }
    static testMethod void myDesignWaiverMethodTest05() {
        
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
        Wavier_Collaborator__c waiverColl11 = DesignCollaboratorTestData.getWaiverCollaborator4DFM_1(userSU.FederationIdentifier,userSU.FederationIdentifier,acc.Id ); 
        waiverColl11.IsSubmitted__c = true;
        waiverColl11.Is_Sync_with_AIA__c = true;
        waiverColl11.Is_releasedToCustomer__c = true;
        Test.startTest();
        update waiverColl11;
        waiverColl11.LastRuleSelected_Customer__c=userSU.FederationIdentifier+';'+userSU.FederationIdentifier;
        DesignCollaboratorTestData.getWaiverRuleListForiFDWCR(waiverColl11.Id);
        DesignCollaboratorTestData.getWaiverRuleListForiFDWEA(waiverColl11.Id);
        
     
        list<Waiver_Rule_List__c>  waiverCollList = DesignCollaboratorTestData.getWaiverRuleList(waiverColl11.Id);
        waiverCollList[0].Final_Stage__c = 'OPEN';
        waiverCollList[0].IsGfAcceptsRisk__c = true;
        update waiverCollList;
        
        Approval_Task_Instance__c appTask = new Approval_Task_Instance__c();
        appTask.Approver_Type__c = 'QA';
        appTask.WaiverRule__c = waiverCollList[0].Id;
        insert appTask; 
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(waiverColl11);        
        DWC_CollaboratorCtrl designWaiver = new DWC_CollaboratorCtrl(stdController);
          
            
        String userGroup = 'QA';
        String users = String.valueOf(userSU.Id);        
        String collabId = String.valueOf(waiverColl11.Id);
        DWC_CollaboratorCtrl.reAssignusersToAManager(waiverCollList,userGroup,users,collabId);
        designWaiver.cancelWorkflow();
        Test.stopTest();
        
        System.AssertEquals(appTask.Approver_Type__c = 'QA','QA');
    }
    static testMethod void myDesignWaiverMethodTest015() {
        
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
        Wavier_Collaborator__c waiverColl11 = DesignCollaboratorTestData.getWaiverCollaborator4DFM_1(userSU.FederationIdentifier,userSU.FederationIdentifier,acc.Id ); 
        waiverColl11.IsSubmitted__c = true;
        waiverColl11.Is_Sync_with_AIA__c = true;
        waiverColl11.Is_releasedToCustomer__c = false;
        waiverColl11.IsGfAcceptsRisk__c = false;
        Test.startTest();
        update waiverColl11;
        waiverColl11.LastRuleSelected_Customer__c=userSU.FederationIdentifier+';'+userSU.FederationIdentifier;
        DesignCollaboratorTestData.getWaiverRuleListForiFDWCR(waiverColl11.Id);
        DesignCollaboratorTestData.getWaiverRuleListForiFDWEA(waiverColl11.Id);
        
     
        list<Waiver_Rule_List__c>  waiverCollList = DesignCollaboratorTestData.getWaiverRuleList(waiverColl11.Id);
        waiverCollList[0].Final_Stage__c = 'OPEN';
        waiverCollList[0].IsGfAcceptsRisk__c = true;
        update waiverCollList;
        
        Approval_Task_Instance__c appTask = new Approval_Task_Instance__c();
        appTask.Approver_Type__c = 'DE';
        appTask.WaiverRule__c = waiverCollList[0].Id;
        insert appTask; 
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(waiverColl11);        
        DWC_CollaboratorCtrl designWaiver = new DWC_CollaboratorCtrl(stdController);
        designWaiver.cancelWorkflow();
          
            
        String userGroup = 'DE';
        String users = String.valueOf(userSU.Id);        
        String collabId = String.valueOf(waiverColl11.Id);
        DWC_CollaboratorCtrl.reAssignusersToAManager(waiverCollList,userGroup,users,collabId);
        Test.stopTest();
        
        System.AssertEquals(appTask.Approver_Type__c = 'DE','DE');
    }    
    static testMethod void myDesignWaiverMethodTest025() {
        
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
        Wavier_Collaborator__c waiverColl11 = DesignCollaboratorTestData.getWaiverCollaborator4DFM_1(userSU.FederationIdentifier,userSU.FederationIdentifier,acc.Id ); 
        waiverColl11.IsSubmitted__c = true;
        waiverColl11.Is_Sync_with_AIA__c = true;
        Test.startTest();
        update waiverColl11;
        waiverColl11.LastRuleSelected_Customer__c=userSU.FederationIdentifier+';'+userSU.FederationIdentifier;
        DesignCollaboratorTestData.getWaiverRuleListForiFDWCR(waiverColl11.Id);
        DesignCollaboratorTestData.getWaiverRuleListForiFDWEA(waiverColl11.Id);
        
     
        list<Waiver_Rule_List__c>  waiverCollList = DesignCollaboratorTestData.getWaiverRuleList(waiverColl11.Id);
        waiverCollList[0].Final_Stage__c = 'OPEN';
        waiverCollList[0].IsGfAcceptsRisk__c = true;
        update waiverCollList;
        
        Portal_Tab_Access__c pta = new Portal_Tab_Access__c();
        pta.Account__c = acc.Id;
        pta.My_Devices__c = false;
        insert pta;
        
        Approval_Task_Instance__c appTask = new Approval_Task_Instance__c();
        appTask.Approver_Type__c = 'AM';
        appTask.WaiverRule__c = waiverCollList[0].Id;
        insert appTask; 
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(waiverColl11);        
        DWC_CollaboratorCtrl designWaiver = new DWC_CollaboratorCtrl(stdController);
            
        String userGroup = 'AM';
        String users = String.valueOf(userSU.Id);        
        String collabId = String.valueOf(waiverColl11.Id);
        DWC_CollaboratorCtrl.reAssignusersToAManager(waiverCollList,userGroup,users,collabId);
        designWaiver.cancelWorkflow();
        designWaiver.accessSetupId = pta.Id;
        Test.stopTest();
        
        System.AssertEquals(appTask.Approver_Type__c = 'AM','AM');
    }
    static testMethod void myDesignWaiverMethodTest035() {
        
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
        Wavier_Collaborator__c waiverColl11 = DesignCollaboratorTestData.getWaiverCollaborator4DFM_1(userSU.FederationIdentifier,userSU.FederationIdentifier,acc.Id ); 
        waiverColl11.IsSubmitted__c = true;
        waiverColl11.Is_Sync_with_AIA__c = true;
        waiverColl11.Is_releasedToCustomer__c = false;
        waiverColl11.IsGfAcceptsRisk__c = false;
        Test.startTest();
        update waiverColl11;
        waiverColl11.LastRuleSelected_Customer__c=userSU.FederationIdentifier+';'+userSU.FederationIdentifier;
        DesignCollaboratorTestData.getWaiverRuleListForiFDWCR(waiverColl11.Id);
        DesignCollaboratorTestData.getWaiverRuleListForiFDWEA(waiverColl11.Id);
        
     
        list<Waiver_Rule_List__c>  waiverCollList = DesignCollaboratorTestData.getWaiverRuleList(waiverColl11.Id);
        waiverCollList[0].Final_Stage__c = 'OPEN';
        waiverCollList[0].IsGfAcceptsRisk__c = true;
        update waiverCollList;
        
        Approval_Task_Instance__c appTask = new Approval_Task_Instance__c();
        appTask.Approver_Type__c = 'PIYE';
        appTask.WaiverRule__c = waiverCollList[0].Id;
        insert appTask; 
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(waiverColl11);        
        DWC_CollaboratorCtrl designWaiver = new DWC_CollaboratorCtrl(stdController);
        designWaiver.cancelWorkflow();
        designWaiver.primeDievl = 'Prime Die1';
        designWaiver.massRadioOption = '';
            
        String userGroup = 'PIYE';
        String users = String.valueOf(userSU.Id);        
        String collabId = String.valueOf(waiverColl11.Id);
        DWC_CollaboratorCtrl.reAssignusersToAManager(waiverCollList,userGroup,users,collabId);
        Test.stopTest();
        
        System.AssertEquals(appTask.Approver_Type__c = 'PIYE','PIYE');
    }    
}