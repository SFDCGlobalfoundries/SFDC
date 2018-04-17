/*
* @ Author :- Abhita Bansal
* @ Company :- Globalfoundries
* @ Description :- Test Class of MandatoryFieldValidator Class.
**/
@isTest
private class MandatoryFieldValidatorTest {
	
	@testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
    }
	
    static testMethod void myUnitTest() {
		
		Map<String, String> dfmFields = new Map<String, String>();		
    	
    	DesignCollaboratorTestData.getGroupTestData('DFM_PI_YE_4_FAB7', 'DFM PI YE 4 FAB7');
    	List<User> user = DesignCollaboratorTestData.getUserTestData();
    	Account account = DesignCollaboratorTestData.getAccountTestData();
    	Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaborator(user[0].FederationIdentifier, user[1].FederationIdentifier, account.Id);    	
    	
    	dFMFields.put('PTSR Number', waiverColl.PTSR_Number__c);
        dFMFields.put('PTSR Service Type', waiverColl.PTSR_Service_Type__c);
        dFMFields.put('PTSR Status', waiverColl.PTSR_Status__c);
        dFMFields.put('FAB', waiverColl.FAB__c);
        dFMFields.put('Account', waiverColl.Account__c);
        dFMFields.put('Account Short Name', waiverColl.Account_Short_Name__c);
        dFMFields.put('Submitted By Shortname', waiverColl.Submitted_By_Shortname__c);
    	
    	Test.startTest(); 
    		MandatoryFieldValidator.createDFM(dFMFields);
    		
    	Test.stopTest();
    }
}