/**
* @ Author : Abhita Bansal
* @ Company : Globalfoundries
 */
@isTest(SeeAllData=true)
private class ProgressBarTest {
	
	/*@testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables(); 
    }
*/
    static testMethod void myProgressBarMethod() {
        
        //List<Progress_Bar__c> progBarDataList = DesignCollaboratorTestData.getProgressBarData();
        Wavier_Collaborator__c waiverCollaborator = DesignCollaboratorTestData.getWaiverCollaborator0();
        
        Test.startTest();
        
	        ProgressBar progBar = new ProgressBar();
	        
	        progBar.applicationName = 'DFM';
	        progBar.sObjectName = waiverCollaborator;
	        progBar.getImage();
        
        Test.stopTest();
    }
    
    static testMethod void myProgressBarMethod1() {
        
        User u = DesignCollaboratorTestData.createPortalUser();
       // List<Progress_Bar__c> progBarDataList = DesignCollaboratorTestData.getProgressBarData();
        Wavier_Collaborator__c waiverCollaborator = DesignCollaboratorTestData.getWaiverCollaborator0();
        
        Test.startTest();
        
        System.runAs(u) {
	        ProgressBar progBar = new ProgressBar();
	        
	        progBar.applicationName = 'DFM';
	        progBar.sObjectName = waiverCollaborator;
	        progBar.getImage();
        }
        
        Test.stopTest();
    }
    
    
     static testMethod void myProgressBarMethodDRC() {
        
         DesignCollaboratorTestData.getGroupTestData('DFM_PI_YE_4_FAB1', 'DFM PI YE 4 FAB1');
        List<User> user = DesignCollaboratorTestData.getUserTestData();
        Account account = DesignCollaboratorTestData.getAccountTestData();
       // List<Progress_Bar__c> progBarDataList = DesignCollaboratorTestData.getProgressBarData();
        Wavier_Collaborator__c waiverCollaborator = DesignCollaboratorTestData.getWaiverCollaborator4DRC(user[0].FederationIdentifier, user[1].FederationIdentifier, account.Id);
        
        Test.startTest();
        
	        ProgressBar progBar = new ProgressBar();
	        
	        progBar.applicationName = 'DRC';
	        progBar.sObjectName = waiverCollaborator;
	        progBar.getImage();
        
        Test.stopTest();
    }
    
		
    static testMethod void myProgressBarMethod12() {
        
        User u = DesignCollaboratorTestData.createPortalUser();
       // List<Progress_Bar__c> progBarDataList = DesignCollaboratorTestData.getProgressBarData();
        Wavier_Collaborator__c waiverCollaborator = DesignCollaboratorTestData.getWaiverCollaborator0();
        
        Test.startTest();
        
        System.runAs(u) {
	        ProgressBar progBar = new ProgressBar();
	        
	        progBar.applicationName = 'DRC';
	        progBar.sObjectName = waiverCollaborator;
	        progBar.getImage();
        }
        
        Test.stopTest();
    }
    
}