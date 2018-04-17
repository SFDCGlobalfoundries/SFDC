/* 
    @Author :- SUHAS BARGI
    @Controller : DesignWaiverCollaboratorDetailsViewTest
*/

@isTest
private class DesignWaiverCollaboratorDetailsViewTest {  

 @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();   
    }

    static testMethod void drcDesignWaiverCollaboratorDetailsViewTest() { 
        DesignCollaboratorTestData.getGroupTestData('DFM_PI_YE_4_FAB1', 'DFM PI YE 4 FAB1');
        List<User> user = DesignCollaboratorTestData.getUserTestData();
        Account account = DesignCollaboratorTestData.getAccountTestData();
        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaborator(user[0].FederationIdentifier, user[1].FederationIdentifier, account.Id); 
        //DesignWaiverCollaboratorDetailsView.collaborator=waiverColl;
       // DesignWaiverCollaboratorDetailsView.currentId='14141414';
       
        ApexPages.StandardController stdController = new ApexPages.StandardController(waiverColl);
        DesignWaiverCollaboratorDetailsView drcWaiver = new DesignWaiverCollaboratorDetailsView(stdController);
        
         drcWaiver.currentId='14141414';
        drcWaiver.redirectTo();
       }
}