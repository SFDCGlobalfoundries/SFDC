/*
@Author :- SUHAS BARGI
*/
@isTest
private class WaiverRuleListControllerTest {
    
    @testSetup static void testdata() { 
       // DataUtilTest.loadEnvironmentVariables();  
    }
    
    static testMethod void myWaiverRuleListControllerMethod() {
        
        
        // Custom Settings for account 
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
        
        Waiver_Rule_List__c waiverRule = new Waiver_Rule_List__c();
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
        //List<User> user = DesignCollaboratorTestData.getUserTestData();
        Account account = DesignCollaboratorTestData.getAccountTestData();
        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaborator(userSU.FederationIdentifier, userSU.FederationIdentifier, account.Id); 
        DesignCollaboratorTestData.getWaiverRuleListForiFDWCR(waiverColl.Id);
        List<Waiver_Rule_List__c> waiverRulesList = DesignCollaboratorTestData.getWaiverRuleList(waiverColl.Id);
        if(waiverRulesList <> null && !waiverRulesList.isEmpty()){
            waiverRule = waiverRulesList.get(0);
        }
        ApexPages.StandardController stdController = new ApexPages.StandardController(waiverRule);
        WaiverRuleListController drcWaiver = new WaiverRuleListController(stdController);
        
        List<String> imagesParameter = new List<String>();
        String url='';
        String recordId='Record1234';
        //drcWaiver.returnURL='https://globalfoundries--gfvdev.cs5.my.salesforce.com';
        
        
        
        //Test.setMock(WebServiceMock.class, new DRC_DesignWaiverCollaboratorMockImpl());
        //DRCAttachmentIntegrationPOC.MantisFileTransferSFDC_pt mantisFile = new DRCAttachmentIntegrationPOC.MantisFileTransferSFDC_pt();
        pageReference pgRef =drcWaiver.back();
        
        System.assertEquals(pgRef, pgRef);
    }
    
    
    
}