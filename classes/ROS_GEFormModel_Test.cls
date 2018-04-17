/**
*    Company       :   Cognizant Technologies PTE Ltd.
*    Description   :   Test Class for ROS_GEFormModel
*    History       :   

        Initials        Date                Description
-----------------------------------------------------------------------------------------
        Nikhil Jain    04/25/2014           Test class created.       
**/

 
@isTest(SEEALLDATA = false)
private class ROS_GEFormModel_Test {
    
    static testMethod void method_getSetmethods(){
        
        Test.startTest();
            ROS_GEFormModel obj = new ROS_GEFormModel();
            obj.getOrgID();
            obj.setOrgID('1234567890');
            obj.getRequestNo();
            obj.setRequestNo('1234567890');
            obj.getRaiseDate();
            obj.setRaiseDate('9876543210');
            obj.getEmployeeID();
            obj.setEmployeeID('1234');
            obj.getFab();
            obj.setFab('FAB 1');
            obj.getShipToCompany();
            obj.setShipToCompany('company');
            obj.getGEStatus();
            obj.setGEStatus('test');
        Test.stopTest();
    }

}