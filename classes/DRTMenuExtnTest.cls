/*
    Author: Cognizant
    Description: Apex test class for DRTMenuExtn class
    History: 
    Cognizant      05/05/2014    - Apex code created
*/
@istest
public class DRTMenuExtnTest{
	
	/**
	This method initialize data using throughout this test class.
	The create data method are: 
	- SwiftDataUtilityTest.customSystemData();
	@author		SWIFT TEAM
	@since		7-April-2015
	*/
	@testSetup static void setup() {
		SwiftDataUtilityTest.customSystemData();
	}
	
	/*
   This test method tests the below functionality of the class DRTCreateExtn for PRIME DRT
  	constructor
  	redirect() 
  */	
    public static testMethod void redirectTest()
    {
    	// comment-out, refactor with testSetup method setup()
        // SwiftDataUtilityTest.customSystemData();
        DRTMenuExtn obj = new DRTMenuExtn();
        test.startTest();
        obj.Page = 'CreateDRT';
        obj.redirect();
        obj.Page = 'SearchDRT';
        obj.redirect();
        obj.Page = 'DetailDRT';
        obj.redirect();
        test.stopTest();
    }
}