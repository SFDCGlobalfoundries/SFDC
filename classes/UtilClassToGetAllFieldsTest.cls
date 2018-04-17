/*
Author: Shyam Ravindra Nair
Description: Test class to calculate code coverage for UtilClassToGetAllFields class.
History:
SNair     10012015     - code creation
SNair     28042015     - modified
*/
@isTest(SeeAllData=false)
public class UtilClassToGetAllFieldsTest {
	
	public static testMethod void myTestMethod(){
		User testUser = [select Id from User where Profile.Name  = 'System Administrator' and isActive = true limit 1];
		
		system.runAs(testUser){
			test.startTest();
			UtilClassToGetAllFields controller = new UtilClassToGetAllFields();
			controller.getAllFields('CuSR_Form__c');
			test.stopTest();
		}
	}	
	
}