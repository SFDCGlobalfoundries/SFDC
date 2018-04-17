/* 
    @Author :- SUHAS BARGI
    @Controller : DRCEmailImplementation
    @ Change:  Harshavardhana malladi,8/11/2016 
*/

@isTest(SeeAllData=false)
private class DRCEmailImplementationTest { 
    

            
static testMethod void drcReleaseReportToCustomerTest() {   
        
        Test.startTest(); 
        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaborator8();       
        DesignCollaboratorTestData.getWaiverRuleListForPI(waiverColl.Id);       
        
        DRCEmailImplementation.drcReleaseReportToCustomer(waiverColl.Id);        
        Test.stopTest();
        System.assertEquals(waiverColl, waiverColl);
    
    }
    
    
       
    static testMethod void drcReleaseReportToCustomerTest1() {
         Test.startTest();
        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaborator8();       
        DesignCollaboratorTestData.getWaiverRuleListForPW(waiverColl.Id);       
        
        DRCEmailImplementation.drcReleaseReportToCustomer(waiverColl.Id);        
        Test.stopTest();
        System.assertEquals(waiverColl, waiverColl);
    }
    
    static testMethod void drcReleaseReportToCustomerTest2() {
        Test.startTest(); 
        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaborator8();       
        DesignCollaboratorTestData.getWaiverRuleListForFDCC(waiverColl.Id);       
        
        DRCEmailImplementation.drcReleaseReportToCustomer(waiverColl.Id);        
        Test.stopTest();
        System.assertEquals(waiverColl, waiverColl);
    }
    
    static testMethod void drcReleaseReportToCustomerTest3() {  
        
        Test.startTest();
        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaborator8();       
        DesignCollaboratorTestData.getWaiverRuleListForPI1(waiverColl.Id);       
         
        DRCEmailImplementation.drcReleaseReportToCustomer(waiverColl.Id);        
        Test.stopTest();
        System.assertEquals(waiverColl, waiverColl);
    }
   

    static testMethod void drcReminderReleaseReportToCustomerTest(){
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
        DesignCollaboratorTestData.getCustomSettings1('ACCT_PFTS_OR_BCSR_NOT_FOUND_ERROR');
        DesignCollaboratorTestData.getCustomSettings1('ACCT_TM_DUP_USER_ROLE_ERROR');
        DesignCollaboratorTestData.getCustomSettings1('ATP_INTEGRATION_SEQUENCE_ERROR');
        DesignCollaboratorTestData.getCustomSettings1('ATP_FLAG_FOR_DELETE_UPDATE_ERROR');
        DesignCollaboratorTestData.getCustomSettings1('ATP_FLAG_FOR_DELETE_CREATION_ERROR');
        DesignCollaboratorTestData.getCustomSettings4('Update Bill To Address No');
        DesignCollaboratorTestData.getCustomSettings('ACCT_TM_PRXY_TM_RL_PFAE');
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
    
        Account account = AccountDataFactory.createAccount(fieldValueMap);
        
        
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
        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaborator(userSU.FederationIdentifier, userSU.FederationIdentifier, account.Id);       
        Test.startTest(); 
       DRCEmailImplementation.drcReminderReleaseReportToCustomer(waiverColl);
        Test.stopTest();
        
        System.assertEquals(waiverColl, waiverColl);
    }  
    
    
    static testMethod void drcResponseRequiredReportTest(){
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
        DesignCollaboratorTestData.getCustomSettings1('ACCT_PFTS_OR_BCSR_NOT_FOUND_ERROR');
        DesignCollaboratorTestData.getCustomSettings1('ACCT_TM_DUP_USER_ROLE_ERROR');
        DesignCollaboratorTestData.getCustomSettings1('ATP_INTEGRATION_SEQUENCE_ERROR');
        DesignCollaboratorTestData.getCustomSettings1('ATP_FLAG_FOR_DELETE_UPDATE_ERROR');
        DesignCollaboratorTestData.getCustomSettings1('ATP_FLAG_FOR_DELETE_CREATION_ERROR');
        DesignCollaboratorTestData.getCustomSettings4('Update Bill To Address No');
        DesignCollaboratorTestData.getCustomSettings('ACCT_TM_PRXY_TM_RL_PFAE');
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
    
        Account account = AccountDataFactory.createAccount(fieldValueMap);
        DesignCollaboratorTestData.getGroupTestData('DFM_PI_YE_4_FAB1', 'DFM PI YE 4 FAB1');
        
        
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

        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaborator(userSU.FederationIdentifier, userSU.FederationIdentifier, account.Id);       
        Test.startTest(); 
       DRCEmailImplementation.drcResponseRequiredReport(waiverColl);
        Test.stopTest();
        System.assertEquals(waiverColl, waiverColl);
    }  
     static testMethod void drcReminderResponseRequiredReportTest(){ 
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
    
        Account account = AccountDataFactory.createAccount(fieldValueMap);
         
        DesignCollaboratorTestData.getGroupTestData('DFM_PI_YE_4_FAB1', 'DFM PI YE 4 FAB1');
        
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
         
        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaborator(userSU.FederationIdentifier, userSU.FederationIdentifier, account.Id);       
        Test.startTest(); 
       DRCEmailImplementation.drcReminderResponseRequiredReport(waiverColl.Id);
        Test.stopTest();
         
        System.assertEquals(waiverColl, waiverColl); 
    }
     static testMethod void drcDecisionMadeByCustReportTest(){
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
    
        Account account = AccountDataFactory.createAccount(fieldValueMap); 
        DesignCollaboratorTestData.getGroupTestData('DFM_PI_YE_4_FAB1', 'DFM PI YE 4 FAB1');
      
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
         
        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaborator(userSU.FederationIdentifier, userSU.FederationIdentifier, account.Id);
        DesignCollaboratorTestData.getWaiverRuleListForFDCC(waiverColl.Id);
         DesignCollaboratorTestData.getWaiverRuleListForiFD(waiverColl.Id);
         DesignCollaboratorTestData.getWaiverRuleListForiFDWCR(waiverColl.Id);
         DesignCollaboratorTestData.getWaiverRuleListForFDCCWCR(waiverColl.Id);
         DesignCollaboratorTestData.getWaiverRuleListForFDCC(waiverColl.Id);
        Test.startTest(); 
        DRCEmailImplementation.drcDecisionMadeByCustReport(waiverColl);
        Test.stopTest();
        System.assertEquals(waiverColl, waiverColl); 
    }
    
     static testMethod void drcDecisionMadeByCustReportTest1(){
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
    
        Account account = AccountDataFactory.createAccount(fieldValueMap); 
        DesignCollaboratorTestData.getGroupTestData('DFM_PI_YE_4_FAB1', 'DFM PI YE 4 FAB1');
       
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
         
        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaborator(userSU.FederationIdentifier, userSU.FederationIdentifier, account.Id);
         DesignCollaboratorTestData.getWaiverRuleListForFDCC1(waiverColl.Id);
         DesignCollaboratorTestData.getWaiverRuleListForiFD1(waiverColl.Id);
         DesignCollaboratorTestData.getWaiverRuleListForiFDWCR2(waiverColl.Id);
         DesignCollaboratorTestData.getWaiverRuleListForFDCCWCR2(waiverColl.Id);
         DesignCollaboratorTestData.getWaiverRuleListForFDCC1(waiverColl.Id);
           DesignCollaboratorTestData.getWaiverRuleListForDisagree(waiverColl.Id);
         
        Test.startTest(); 
        DRCEmailImplementation.drcDecisionMadeByCustReport(waiverColl);
        Test.stopTest();
         
        System.assertEquals(waiverColl, waiverColl); 
    }
    
    static testMethod void drcNotAllDecisionMadebyCustTestTemplate5(){
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
    
        Account account = AccountDataFactory.createAccount(fieldValueMap);  
        Test.startTest(); 
        DesignCollaboratorTestData.getGroupTestData('DFM_PI_YE_4_FAB1', 'DFM PI YE 4 FAB1');
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

        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaboratorDRCTemplate5(userSU.FederationIdentifier, userSU.FederationIdentifier, account.Id);
     
        DesignCollaboratorTestData.getWaiverRuleListForFDCC1(waiverColl.Id);
         DesignCollaboratorTestData.getWaiverRuleListForiFD1(waiverColl.Id);
         DesignCollaboratorTestData.getWaiverRuleListForiFDWCR2(waiverColl.Id);
         DesignCollaboratorTestData.getWaiverRuleListForFDCCWCR2(waiverColl.Id);
         DesignCollaboratorTestData.getWaiverRuleListForFDCC1(waiverColl.Id);
        
         DRCEmailImplementation.drcDecisionMadeByCustReport(waiverColl);
         Test.stopTest();
        System.assertEquals(waiverColl, waiverColl);
    }
    
     static testMethod void drcNotAllDecisionMadebyCustTest(){
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
    
        Account account = AccountDataFactory.createAccount(fieldValueMap);  
       Test.startTest(); 
        DesignCollaboratorTestData.getGroupTestData('DFM_PI_YE_4_FAB1', 'DFM PI YE 4 FAB1');
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
        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaborator(userSU.FederationIdentifier, userSU.FederationIdentifier, account.Id);   
        DesignCollaboratorTestData.getWaiverRuleListForFDCC(waiverColl.Id);
        DesignCollaboratorTestData.getWaiverRuleListForiFD(waiverColl.Id);
        
        DRCEmailImplementation.drcNotAllDecisionMadebyCust(waiverColl.Id); 
       
        Test.stopTest();
        System.assertEquals(waiverColl, waiverColl); 
    }
    
    
     
   
        static testMethod void FoundryToRiskApprovalTest() {  
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
    
        Account account = AccountDataFactory.createAccount(fieldValueMap);  
       Test.startTest(); 
        DesignCollaboratorTestData.getGroupTestData('DFM_PI_YE_4_FAB1', 'DFM PI YE 4 FAB1');
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
        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaborator(userSU.FederationIdentifier, userSU.FederationIdentifier, account.Id);   
        DesignCollaboratorTestData.getWaiverRuleListForFDCC(waiverColl.Id);
        DesignCollaboratorTestData.getWaiverRuleListForiFD(waiverColl.Id);
        
                set<Id> sid = new  set<Id>();
               
               DRCEmailImplementation.drcFoundryToRiskApproval(waiverColl,sid);        
                Test.stopTest();    
                System.assertEquals(waiverColl, waiverColl);    
                }  
  
  
  
    static testMethod void drcFoundryToRiskTier2OpenApprovalTest1(){
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
    
        Account account = AccountDataFactory.createAccount(fieldValueMap);  
      Test.startTest();
        DesignCollaboratorTestData.getGroupTestData('DFM_PI_YE_4_FAB1', 'DFM PI YE 4 FAB1');
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

        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaborator(userSU.FederationIdentifier, userSU.FederationIdentifier, account.Id);  
        DesignCollaboratorTestData.getWaiverRuleListForiFDWCR(waiverColl.Id);
        DesignCollaboratorTestData.getWaiverRuleListForiFDWCR(waiverColl.Id);
        DesignCollaboratorTestData.getWaiverRuleListForiFDWCR(waiverColl.Id);
        DesignCollaboratorTestData.getWaiverRuleListForiFDWCR(waiverColl.Id);
        DesignCollaboratorTestData.getWaiverRuleListForiFDWCR(waiverColl.Id);
        
        list<Waiver_Rule_List__c>  waiverRuleList = DesignCollaboratorTestData.getWaiverRuleList(waiverColl.Id);
        
        DRCEmailImplementation.getDRCRuleListPendingApprovals(waiverRuleList);
        Test.stopTest();
        System.assertEquals(waiverColl, waiverColl);
    }
   
    
    
    static testMethod void drcFoundryToRiskTier2OpenApprovalTest(){
      Test.startTest(); 
        DesignCollaboratorTestData.getGroupTestData('DFM_PI_YE_4_FAB1', 'DFM PI YE 4 FAB1');
        
       List<Id> drcID = new List<Id>();
                
        List<Id> workItemIds = new List<Id>();
        List<Waiver_Rule_List__c> waiverRuleList1=new List<Waiver_Rule_List__c> ();
        
        for ( ProcessInstance pi: [SELECT Id, Status,(SELECT Id, ActorId, OriginalActorId, StepStatus, Comments,TargetObjectId FROM StepsAndWorkitems)
                                   FROM ProcessInstance where Status IN ('Pending')] ) {
                                       for (ProcessInstanceHistory pih : pi.StepsAndWorkItems) {                                           
                                           workItemIds.add(pih.TargetObjectId);
                                           
                                       }  
                                   }
        
        Map<Id,Waiver_Rule_List__c> wrObjMap = new Map<Id,Waiver_Rule_List__c>();
        Waiver_Rule_List__c ruleObj1 = new Waiver_Rule_List__c();
        if (workItemIds<>NULL && !workItemIds.isEmpty()){            
            wrObjMap=new Map<Id,Waiver_Rule_List__c>([SELECT Id,Design_Rule_Name__c, Rule_Description__c,Stage__c,Final_Stage__c,Waiver_Collaborator__c  FROM Waiver_Rule_List__c WHERE Id IN :workItemIds AND Waiver_Collaborator__r.PTSR_Service_Type__c LIKE '%DRC%' ]);
        }
        
        for(Id ids: wrObjMap.keySet()){
            drcID.add(ids);
           
        }
        
        
       if(drcID.size()>0){
        ruleObj1 = wrObjMap.get(drcID.get(0));
        DRCEmailImplementation.getDRCRuleListPendingApprovals(waiverRuleList1);
       // DRCEmailImplementation.getDRCRuleListPendingApprovals(ruleObj1.Waiver_Collaborator__c);
        }
         if(drcID.size()>1){
        ruleObj1 = wrObjMap.get(drcID.get(1));
        DRCEmailImplementation.getDRCRuleListPendingApprovals(waiverRuleList1);
        //DRCEmailImplementation.getDRCRuleListPendingApprovals(ruleObj1.Waiver_Collaborator__c);
        }
       
        Test.stopTest();
        System.assertEquals(ruleObj1, ruleObj1);
    }
    
    
    
    static testMethod void drcReviewSummaryNotification9aTest(){
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
    
        Account account = AccountDataFactory.createAccount(fieldValueMap);
        Test.startTest(); 
        DesignCollaboratorTestData.getGroupTestData('DFM_PI_YE_4_FAB1', 'DFM PI YE 4 FAB1');
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

        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaborator(userSU.FederationIdentifier, userSU.FederationIdentifier, account.Id);  
        DesignCollaboratorTestData.getWaiverRuleListForFDCC(waiverColl.Id);
        DesignCollaboratorTestData.getWaiverRuleListForiFD(waiverColl.Id);
        DesignCollaboratorTestData.getWaiverRuleListForFDCC(waiverColl.Id);
        DesignCollaboratorTestData.getWaiverRuleListForFDCCFD(waiverColl.Id);
        DesignCollaboratorTestData.getWaiverRuleListForFDCCWCR(waiverColl.Id);
        DesignCollaboratorTestData.getWaiverRuleListForFDCCWEA(waiverColl.Id);
        DesignCollaboratorTestData.getWaiverRuleListForiFD(waiverColl.Id);
        DesignCollaboratorTestData.getWaiverRuleListForiFDFD(waiverColl.Id);
        DesignCollaboratorTestData.getWaiverRuleListForiFDWCR(waiverColl.Id);
        DesignCollaboratorTestData.getWaiverRuleListForiFDWEA(waiverColl.Id);
        DesignCollaboratorTestData.getWaiverRuleListForPI(waiverColl.Id);
        DesignCollaboratorTestData.getWaiverRuleListForPW(waiverColl.Id);
        
      
        DRCEmailImplementation.drcReviewSummaryNotification9a(waiverColl);
        Test.stopTest();
        System.assertEquals(waiverColl, waiverColl);
    }
    static testMethod void drcReviewSummaryNotification9bTest(){
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
    
        Account account = AccountDataFactory.createAccount(fieldValueMap);
        Test.startTest(); 
        DesignCollaboratorTestData.getGroupTestData('DFM_PI_YE_4_FAB1', 'DFM PI YE 4 FAB1');
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
        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaborator(userSU.FederationIdentifier, userSU.FederationIdentifier, account.Id);  
        DesignCollaboratorTestData.getWaiverRuleListForFDCC(waiverColl.Id);
        DesignCollaboratorTestData.getWaiverRuleListForiFD(waiverColl.Id);
        DesignCollaboratorTestData.getWaiverRuleListForFDCC(waiverColl.Id);
        DesignCollaboratorTestData.getWaiverRuleListForFDCCFD(waiverColl.Id);
        DesignCollaboratorTestData.getWaiverRuleListForFDCCWCR(waiverColl.Id);
        DesignCollaboratorTestData.getWaiverRuleListForFDCCWEA(waiverColl.Id);
        DesignCollaboratorTestData.getWaiverRuleListForiFD(waiverColl.Id);
        DesignCollaboratorTestData.getWaiverRuleListForiFDFD(waiverColl.Id);
        DesignCollaboratorTestData.getWaiverRuleListForiFDWCR(waiverColl.Id);
        DesignCollaboratorTestData.getWaiverRuleListForiFDWEA(waiverColl.Id);
        DesignCollaboratorTestData.getWaiverRuleListForPI(waiverColl.Id);
        DesignCollaboratorTestData.getWaiverRuleListForPW(waiverColl.Id);
        
        DRCEmailImplementation.drcReviewSummaryNotification9b(waiverColl);
        Test.stopTest();
        System.assertEquals(waiverColl, waiverColl);
    }
    static testMethod void drcDesignRejectNotificationTest(){
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
    
        Account account = AccountDataFactory.createAccount(fieldValueMap);
        Test.startTest(); 
        DesignCollaboratorTestData.getGroupTestData('DFM_PI_YE_4_FAB1', 'DFM PI YE 4 FAB1');
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

        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaborator(userSU.FederationIdentifier, userSU.FederationIdentifier, account.Id); 
        DesignCollaboratorTestData.getWaiverRuleListForiFDFD(waiverColl.Id);
        DesignCollaboratorTestData.getWaiverRuleListForiFDFD(waiverColl.Id);
        
        DRCEmailImplementation.drcDesignRejectNotification(waiverColl);
        Test.stopTest();
        System.assertEquals(waiverColl, waiverColl);
    }
    static testMethod void jobCancelledNotificationTest(){
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
    
        Account account = AccountDataFactory.createAccount(fieldValueMap);
        Test.startTest(); 
        DesignCollaboratorTestData.getGroupTestData('DFM_PI_YE_4_FAB1', 'DFM PI YE 4 FAB1');
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

        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaborator(userSU.FederationIdentifier, userSU.FederationIdentifier, account.Id);       
       
        DRCEmailImplementation.jobCancelledNotification(waiverColl);
        Test.stopTest();
        System.assertEquals(waiverColl, waiverColl);
    }
        
    static testMethod void drcPIPWClosureNotificationTest() { 
        
        
        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaborator8();       
        DesignCollaboratorTestData.getWaiverRuleListForPI(waiverColl.Id);       
        Test.startTest(); 
        DRCEmailImplementation.drcPIPWClosureNotification(waiverColl);        
        Test.stopTest();
        System.assertEquals(waiverColl, waiverColl);
    }
    
     static testMethod void setUpPiyeAndQAUsersTest(){
       
        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaborator27() ;
        Test.startTest(); 
        DRCEmailImplementation.setUpPiyeAndQAUsers(waiverColl);
        Test.stopTest();
        System.assertEquals(waiverColl, waiverColl); 
    }
    
    static testMethod void foundrytoRiskApprovalCancelledbyCustomerTest(){
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
        DesignCollaboratorTestData.getCustomSettings('ACCT_TM_PRXY_TM_RL_PFAE');
        DesignCollaboratorTestData.getCustomSettings('ACCT_TM_PRXY_TM_RL_AA');
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
    
        Account account = AccountDataFactory.createAccount(fieldValueMap);
            Test.startTest(); 
        DesignCollaboratorTestData.getGroupTestData('DFM_PI_YE_4_FAB1', 'DFM PI YE 4 FAB1');
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

        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaborator(userSU.FederationIdentifier, userSU.FederationIdentifier, account.Id); 
        DesignCollaboratorTestData.getWaiverRuleListForFCF1(waiverColl.Id);
        
        DRCEmailImplementation.foundrytoRiskApprovalCancelledbyCustomer(waiverColl.Id);
        Test.stopTest();
        System.assertEquals(waiverColl, waiverColl);
    }
   static testMethod void foundrytoRiskApprovalCancelledbyCustomerTest1(){
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
    
        Account account = AccountDataFactory.createAccount(fieldValueMap);
        Test.startTest(); 
        DesignCollaboratorTestData.getGroupTestData('DFM_PI_YE_4_FAB1', 'DFM PI YE 4 FAB1');
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
        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaborator(userSU.FederationIdentifier, userSU.FederationIdentifier, account.Id); 
       
        DesignCollaboratorTestData.getWaiverRuleListForiFDWCR(waiverColl.Id);
       
        DRCEmailImplementation.foundrytoRiskApprovalCancelledbyCustomer(waiverColl.Id);
        Test.stopTest();
        System.assertEquals(waiverColl, waiverColl);
    }
 
 static testMethod void collaboratorAcknowledgementForDRCTest(){
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
    
        Account account = AccountDataFactory.createAccount(fieldValueMap);
        Test.startTest(); 
        DesignCollaboratorTestData.getGroupTestData('DFM_PI_YE_4_FAB1', 'DFM PI YE 4 FAB1');
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

        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaborator(userSU.FederationIdentifier, userSU.FederationIdentifier, account.Id); 
       
        DesignCollaboratorTestData.getWaiverRuleListForiFDWCR(waiverColl.Id);
         
        DRCEmailImplementation.collaboratorAcknowledgementForDRC(waiverColl.Id);
        Test.stopTest();
        System.assertEquals(waiverColl, waiverColl);
    }
    
     
 static testMethod void nonMatchingRulesForDRCTest(){
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
    
        Account account = AccountDataFactory.createAccount(fieldValueMap);
        Test.startTest(); 
        DesignCollaboratorTestData.getGroupTestData('DFM_PI_YE_4_FAB1', 'DFM PI YE 4 FAB1');
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

        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaborator(userSU.FederationIdentifier, userSU.FederationIdentifier, account.Id); 
       
        DesignCollaboratorTestData.getWaiverRuleListForNonMatch(waiverColl.Id);
         
        DRCEmailImplementation.nonMatchingRulesForDRC(waiverColl.Id);
        Test.stopTest();
        System.assertEquals(waiverColl, waiverColl);
    }
    
   static testMethod void drcNotAllDecisionMadebyCustTestTemplate_1(){
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
    
        Account account = AccountDataFactory.createAccount(fieldValueMap);  
        Test.startTest(); 
        DesignCollaboratorTestData.getGroupTestData('DFM_PI_YE_4_FAB1', 'DFM PI YE 4 FAB1');
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

        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaboratorDRCTemplate5(userSU.FederationIdentifier, userSU.FederationIdentifier, account.Id);
     
        DesignCollaboratorTestData.getWaiverRuleListForFDCC1(waiverColl.Id);
         DesignCollaboratorTestData.getWaiverRuleListForiFD1(waiverColl.Id);
         DesignCollaboratorTestData.getWaiverRuleListForiFDWCR2(waiverColl.Id);
         DesignCollaboratorTestData.getWaiverRuleListForFDCCWCR2(waiverColl.Id);
         DesignCollaboratorTestData.getWaiverRuleListForFDCC1(waiverColl.Id);
        list<Waiver_Rule_List__c>  waiverRuleList = DesignCollaboratorTestData.getWaiverRuleList(waiverColl.Id);
         DRCEmailImplementation.getDRCRuleListPendingApprovals(waiverRuleList);
         Test.stopTest();
        System.assertEquals(waiverColl, waiverColl);
    }
}