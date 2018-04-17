/*
 Type Name: ClsDatePickerComponentControllerTest
 Author: Cognizant Technology Solutions
 Created Date: 16-August-2013
 Reason: This is the test class for 'ClsDatePickerComponentController' class.
 Change History:
 Author: 
 Modified Date: 
 Reason: 
 …….. 
 ……..
*/

@isTest
private class ClsDatePickerComponentControllerTest{

    static testMethod void ClsDatePickerComponentControllerTest() {
    
    Test.startTest();
    ClsDatePickerComponentController DatePickerComponentControllerobj= new ClsDatePickerComponentController();
    DatePickerComponentControllerobj.currentDate= '08/22/2050';

    Test.stopTest();       

    }
}