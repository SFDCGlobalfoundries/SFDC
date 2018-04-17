/*
    Author: Pradosh Samal
    Description: This Test class is for the PNP_ReleaseControllerTest class.
    History: 
        Psamal      08082017    - Apex coded created
*/

@isTest(SeeAllData=false)
private class PNP_ReleaseControllerTest{
    
    private static testMethod void testRun1(){
        Test.startTest();
        
        Environment_Variable__c ev = new Environment_Variable__c(Name = 'PNP_RELEASE_PAGE_SIZE', Value__c = '10');
        insert ev;
        
        PNP_ReleaseController controller = new PNP_ReleaseController();
        
        controller.totalSize = 50;
        
        controller.beginning();
        controller.next();
        System.assert(controller.counter == 10);
        controller.previous();
        System.assert(controller.counter == 0);
        controller.end();
        controller.getDisablePrevious();
        controller.getDisableNext();
        controller.getPageNumber();
        controller.getTotalPages();
        
        Test.stopTest();
    }
}