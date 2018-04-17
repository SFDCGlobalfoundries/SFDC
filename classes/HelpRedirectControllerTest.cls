/*
Type Name: HelpRedirectController 
Author: Cognizant
Created Date: 09-Dec-2013
Reason: This is the Test class for class HelpRedirectController. 
Change History:
Author: 
Modified Date: 
Reason: 
……..
……..
 */
@isTest(SeeAllData=true)
private class HelpRedirectControllerTest{
	static testMethod void HelpRedirectControllerTest(){
		Test.startTest();

		insert new HelpGroups__c(Name = 'TestAccounts' , Groups__c ='0F9O00000000Cbv');

		PageReference pageRef1 = Page.helpredirect;
		Test.setCurrentPage(pageRef1);
		apexpages.currentpage().getparameters().put('id','TestAccounts');

		HelpRedirectController controller1 = new HelpRedirectController ();
		controller1.redirect();

		PageReference pageRef2 = Page.helpredirect;
		Test.setCurrentPage(pageRef2);      
		HelpRedirectController controller2 = new HelpRedirectController ();
		controller2.redirect();

		Test.stopTest();
	}
}