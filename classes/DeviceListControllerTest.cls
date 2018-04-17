/*
    Author: Zymark Ambat
    Description: This serves as the test class for DeviceListController.
    History: 
        ZAmbat      10172013    - Code creation.
        ARoy        11132013    - Modified for pagination.
        Asolito     02202014    - Added sorting tests
        Ashwini     05142015    - Updated code for making SeeAllData=false and refactoring of test class.
        Devendra  10142015      - Updated to fix device validation error
*/
@isTest(SeeAllData=false)   
private class DeviceListControllerTest {
    @testsetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        device__c d=DeviceUtilTest.createDevice();
        d.Expose_Device_to_Customer__c=true;
        test.startTest();
        insert d;
        try{
        DeviceListController.DeviceListWrapper dlw=new DeviceListController.DeviceListWrapper(d);
        }catch(Exception e){}
        test.stopTest();
    }
    
    static testMethod void runTest() {
        
        test.startTest();
            PageReference pageRef = Page.DeviceList;
            Test.setCurrentPageReference(pageRef);
            ApexPages.currentPage().getParameters().put('name', 'test');
            DeviceListController dlc = new DeviceListController();            
            pageRef = dlc.Next();
            system.assert(pageRef==null);
            pageRef = dlc.Previous();
            system.assert(pageRef==null);
            pageRef = dlc.Beginning();
            system.assert(pageRef==null);
            pageRef = dlc.End();
            system.assert(pageRef==null);
            boolean prevChk = dlc.getDisablePrevious();
            boolean nextChk = dlc.getDisableNext();
            Integer pgNo = dlc.getPageNumber();
            Integer totalPg = dlc.getTotalPages(); 
            
            //sorting
            dlc.sortCol = 'name';
            dlc.sortType = 'asc';        
            dlc.sort();
        test.stopTest();
    }
}