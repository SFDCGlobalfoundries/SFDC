/*
    @Author :-  Abhita Bansal
    @DATE   :-  11/27/2015
    @Deatils:-  Test class for DfmUtilityCls
    @History:-  Mohan 01/11/2017 
 */
@isTest(seeAllData=false)
private class DfmUtilityClsTest {
    
    
    static testMethod void myDFMUtilityClsMethod() {
        
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
        
        List<String> uRoles = new List<String>{'Field Application Engineer','Primary Field Application Engineer'};
        Set<Id> userIds = new Set<Id>();
        AcctRegHeadMappingTgrHandler.bypassAcctTrigger=true;
        Account account = DesignCollaboratorTestData.getAccountTestData();
        Profile sysAdminProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User sysAdminUser = [SELECT Id, Name FROM User WHERE Profile.Name = 'System Administrator'
            AND isActive = true
        ].get(0);
        System.runAs(sysAdminUser) {
            Profile stdUserProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User'];
            UserRole usrRole = [SELECT Id FROM UserRole WHERE Name = 'GLOBALFOUNDRIES Corporate'];

            User userSU = new User(alias = 'testMRS2', email = 'testMRS2@test.com',
                emailencodingkey = 'UTF-8', lastname = 'testMRS2Last', firstname = 'testMRS2First', languagelocalekey = 'en_US',
                localesidkey = 'en_US', profileid = stdUserProfile.Id, UserRoleId = usrRole.Id,
                timezonesidkey = 'America/Los_Angeles', username = 'testMRS2@test.com', communitynickname = 'testMRS2');

            insert userSU;
            
             User userSU1 = new User(alias = 'testMSS1', email = 'testMRS21@test.com',
                emailencodingkey = 'UTF-8', lastname = 'testMRS21Last', firstname = 'testMRS21First', languagelocalekey = 'en_US',
                localesidkey = 'en_US', profileid = stdUserProfile.Id, UserRoleId = usrRole.Id,
                timezonesidkey = 'America/Los_Angeles', username = 'testMRS21@test.com', communitynickname = 'testMRS21');

            insert userSU1;

        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaborator(userSU.FederationIdentifier, userSU1.FederationIdentifier, account.Id); 
        Attachment attach = DesignCollaboratorTestData.getAttachmentTestData(waiverColl.Id);
        Chip__c chip = DesignCollaboratorTestData.getChipTestData(waiverColl.Id);
        List<Id> iDsList = new List<Id>();
        iDsList.add(userSU.id);
        userIds.add(userSU.Id);
        
        Test.startTest();
        
        //DfmUtilityCls();
        DfmUtilityCls util = new DfmUtilityCls();
        DfmUtilityCls.getUsersFromPublicGroup('DFM PI YE 4 FAB7');
        DfmUtilityCls.getATPUsersByRole(account.Short_Name__c, uRoles);
        DfmUtilityCls.getATPUsersByRoleFAEflag(account.Short_Name__c);
        DfmUtilityCls.shareRecord(waiverColl.Id, userIds,'Edit');
        DfmUtilityCls.getCustomers(userSU.FederationIdentifier, userSU.FederationIdentifier);
        DfmUtilityCls.getEmailIds(userIds);
        DfmUtilityCls.generateApprovalURL(waiverColl.Id);
        DfmUtilityCls.getAttachments(waiverColl.Id);
        DfmUtilityCls.getPrimeDieName(waiverColl.Id);
        DfmUtilityCls.getFields();
        DfmUtilityCls.getGroupNamesForList(iDsList);
        
        List<Waiver_Rule_List__c> waiverRuleList= DfmUtilityCls.getWaiverRuleList(waiverColl.Id) ;
        System.assert(DfmUtilityCls.getAllFields('Wavier_Collaborator__c') != null);
        for(Waiver_Rule_List__c wcr: waiverRuleList){
            iDsList.add(wcr.Id);
        }
        DfmUtilityCls.getWaiverRuleRecordMap(iDsList);
        DfmUtilityCls.getUsersForDRBGp(waiverColl.DRB_Group_uIds__c);
        DfmUtilityCls.drbEmailIDs(waiverColl.DRB_Group_uIds__c);
        
        DfmUtilityCls.getClosingSectionList(waiverColl.Id);
        dfmUtilityCls.drbNames(userSU.id);
        dfmUtilityCls.getNotesForCollaborator(waiverColl.Id);
        dfmUtilityCls.getWaiverCollaborator(waiverColl.Id);
        Test.stopTest();
        System.assert(DfmUtilityCls.returnToListView('Wavier_Collaborator__c')!= null);    
    }
}
}