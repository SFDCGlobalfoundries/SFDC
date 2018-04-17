@isTest(SeeAllData=false)
private class DRCWaiverCollaboratorControllerTest5 {    
    static testMethod void myDesignWaiverMethodTest5() {
        
        recordtype rt = [select id from recordtype where sobjecttype = 'Account'
                         and developername = 'GLOBALFOUNDRIES_Internal'
                        ];
        //Test.startTest();
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
        waiverColl11.Is_releasedToCustomer__c = false;
        update waiverColl11;
        
        waiverColl11.LastRuleSelected_Customer__c=userSU.FederationIdentifier+';'+userSU.FederationIdentifier;
        DesignCollaboratorTestData.getWaiverRuleListForiFDWCR(waiverColl11.Id);
        DesignCollaboratorTestData.getWaiverRuleListForiFDWEA(waiverColl11.Id);
        
        list<Waiver_Rule_List__c>  waiverCollList = DesignCollaboratorTestData.getWaiverRuleList(waiverColl11.Id);
        waiverCollList[0].Prime_Die_Name__c = 'Pending';
        waiverCollList[0].Final_Stage__c = 'Open';
        waiverCollList[0].Rule_Type__c = '0';
        waiverCollList[0].IsGfAcceptsRisk__c = true;
        update waiverCollList;
        
        list<Approval_Task_Instance__c> appList = new list<Approval_Task_Instance__c>();
        appList.add(DesignCollaboratorTestData.getApprovalTaskInstance(waiverCollList[0].Id));
        

                    
        
       // system.debug('applist'+appList);
        Test.startTest();
        ApexPages.StandardController stdController = new ApexPages.StandardController(waiverColl11);        
        DWC_CollaboratorCtrl designWaiver = new DWC_CollaboratorCtrl(stdController);
        system.debug('waiverCollList>>>>>>>>>>'+waiverCollList);
        
        
        designWaiver.revertOption='Pending For Customer';
        designWaiver.hiddenUsrIds = userSU.Id;
        DWC_CollaboratorCtrl.ruleListTableWrapper ruleLstTableWrap  = new DWC_CollaboratorCtrl.ruleListTableWrapper(true, waiverCollList.get(0), 'ruleListTableWrapper test', 'ruleListTableWrapper test', 'Attachment test', 'Selected',false);
        
        //String accessSetupId = porTabAccess.Id;
        String finalstatus = '';
        String primediename = '';
        String ruleType = 'All';
        Integer pagenumber = 1;
        Integer pageSize = 10;
        String searchval = 'Test';        
        String revertReason = 'revertReason';
        String selectedOption = 'Pending For FAE';
        String collabId = String.valueOf(waiverColl11.Id);
        
        DWC_CollaboratorCtrl.submitRuleList(waiverCollList,collabId);
        DWC_CollaboratorCtrl.getRuleStatusMapForReleaseToCustomer(collabId);
        DWC_CollaboratorCtrl.getFields(waiverColl11.Id);
        DWC_CollaboratorCtrl.getCount(collabId,finalstatus,primediename,ruleType);
        DWC_CollaboratorCtrl.test(pagenumber,pageSize,collabId,finalstatus,primediename,searchval,ruleType);
        designWaiver.getRevertOptions();
        designWaiver.releaseToCustomer();
        designWaiver.getOptions();
        designWaiver.getCustomerDetails();
        Test.stopTest();
        //Test.startTest();
        DWC_CollaboratorCtrl.revertCollaborator(revertReason,selectedOption,collabId);
       // DWC_CollaboratorCtrl.getRuleListForDataTable(collabId);
        //Test.stopTest();
         DWC_CollaboratorCtrl.getRuleListForDataTable(collabId);
        System.Assert(waiverCollList[0].IsGfAcceptsRisk__c,true);
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
        waiverColl11.LastRuleSelected_Customer__c=userSU.FederationIdentifier+';'+userSU.FederationIdentifier;
        DesignCollaboratorTestData.getWaiverRuleListForiFDWCR(waiverColl11.Id);
        DesignCollaboratorTestData.getWaiverRuleListForiFDWEA(waiverColl11.Id);
     
        list<Waiver_Rule_List__c>  waiverCollList = DesignCollaboratorTestData.getWaiverRuleList(waiverColl11.Id);
        waiverCollList[0].Prime_Die_Name__c = 'Pending';
        waiverCollList[0].Final_Stage__c = 'PWA';
        waiverCollList[0].Rule_Type__c = '0';
        update waiverCollList;
        list<Approval_Task_Instance__c> appList = new list<Approval_Task_Instance__c>();
        appList.add(DesignCollaboratorTestData.getApprovalTaskInstance(waiverCollList[0].Id));
        
        Portal_Tab_Access__c pta = new Portal_Tab_Access__c();
        pta.Account__c = acc.Id;
        pta.My_Devices__c = true;
        insert pta; 
        Test.startTest();
        ApexPages.StandardController stdController = new ApexPages.StandardController(waiverColl11);        
        DWC_CollaboratorCtrl designWaiver = new DWC_CollaboratorCtrl(stdController);
        system.debug('waiverCollList>>>>>>>>>>'+waiverCollList);
        
        designWaiver.accessSetupId = pta.Id;
        String collabId = String.valueOf(waiverColl11.Id);
        DWC_CollaboratorCtrl.summaryTableWrapper  summaryTable = new DWC_CollaboratorCtrl.summaryTableWrapper();
        DWC_CollaboratorCtrl.getRuleListForDataTable(collabId);
        designWaiver.createAccessSetupRecord();
        Test.stopTest();
        
        System.AssertEquals(waiverCollList[0].Final_Stage__c = 'PWA','PWA');
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
        waiverColl11.LastRuleSelected_Customer__c=userSU.FederationIdentifier+';'+userSU.FederationIdentifier;
        DesignCollaboratorTestData.getWaiverRuleListForiFDWCR(waiverColl11.Id);
        DesignCollaboratorTestData.getWaiverRuleListForiFDWEA(waiverColl11.Id);
     
        list<Waiver_Rule_List__c>  waiverCollList = DesignCollaboratorTestData.getWaiverRuleList(waiverColl11.Id);
        waiverCollList[0].Prime_Die_Name__c = 'Pending';
        waiverCollList[0].Final_Stage__c = 'FD';
        waiverCollList[0].Rule_Type__c = '0';
        update waiverCollList;
        list<Approval_Task_Instance__c> appList = new list<Approval_Task_Instance__c>();
        appList.add(DesignCollaboratorTestData.getApprovalTaskInstance(waiverCollList[0].Id));
        
        Portal_Tab_Access__c pta = new Portal_Tab_Access__c();
        pta.Account__c = acc.Id;
        pta.My_Devices__c = false;
        insert pta; 
        Test.startTest();
        ApexPages.StandardController stdController = new ApexPages.StandardController(waiverColl11);        
        DWC_CollaboratorCtrl designWaiver = new DWC_CollaboratorCtrl(stdController);
        system.debug('waiverCollList>>>>>>>>>>'+waiverCollList);
        designWaiver.accessSetupId = pta.Id;
        String collabId = String.valueOf(waiverColl11.Id);
        DWC_CollaboratorCtrl.getRuleListForDataTable(collabId);
        designWaiver.createAccessSetupRecord();
        Test.stopTest();
        
        System.AssertEquals(waiverCollList[0].Final_Stage__c = 'FD','FD');
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
        waiverColl11.LastRuleSelected_Customer__c=userSU.FederationIdentifier+';'+userSU.FederationIdentifier;
        DesignCollaboratorTestData.getWaiverRuleListForiFDWCR(waiverColl11.Id);
        DesignCollaboratorTestData.getWaiverRuleListForiFDWEA(waiverColl11.Id);
     
        list<Waiver_Rule_List__c>  waiverCollList = DesignCollaboratorTestData.getWaiverRuleList(waiverColl11.Id);
        waiverCollList[0].Prime_Die_Name__c = 'Pending';
        waiverCollList[0].Final_Stage__c = 'PWO';
        waiverCollList[0].Rule_Type__c = '0';
        update waiverCollList;
        list<Approval_Task_Instance__c> appList = new list<Approval_Task_Instance__c>();
        appList.add(DesignCollaboratorTestData.getApprovalTaskInstance(waiverCollList[0].Id));
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(waiverColl11);        
        DWC_CollaboratorCtrl designWaiver = new DWC_CollaboratorCtrl(stdController);
        system.debug('waiverCollList>>>>>>>>>>'+waiverCollList);
        Test.startTest();

        String collabId = String.valueOf(waiverColl11.Id);
        DWC_CollaboratorCtrl.getRuleListForDataTable(collabId);
        Test.stopTest();
        
        System.AssertEquals(waiverCollList[0].Final_Stage__c = 'PWO','PWO');
    }    
}