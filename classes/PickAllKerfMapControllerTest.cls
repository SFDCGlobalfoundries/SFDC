/*
    Author: Pradosh Samal
    Description: This Test class is for the PickAllKerfMapController class.
    History: 
        Psamal      03312017    - Apex coded created
        Psamal      04132017    - Changes for Kerf map. Added testRun4().
        Psamal      05082017    - Changes for increasing code coverage
*/

@isTest(SeeAllData=false)
private class PickAllKerfMapControllerTest{
    
    @testSetup static void testData() {
        DataUtilTest.loadEnvironmentVariables();
    }
    
    private static testMethod void testRun1(){
        Test.startTest();

        PickAllKerfMapController controller = new PickAllKerfMapController();
        PageReference pageReference = controller.downloadPickAllMap();
        
        Test.stopTest();
    }
    
    private static testMethod void testRun2(){
        Test.startTest();

        PickAllKerfMapController controller = new PickAllKerfMapController();
        controller.pickAllPartNumber = 'test';
        controller.pickAllECNumber = 'test';
        PageReference pageReference = controller.downloadPickAllMap();
        
        Test.stopTest();
    }
    
    private static testMethod void testRun3(){
        Test.startTest();

        PickAllKerfMapController controller = new PickAllKerfMapController();
        controller.pickAllPartNumber = '00YY823';
        controller.pickAllECNumber = 'P07186';
        PageReference pageReference = controller.downloadPickAllMap();
        
        Test.stopTest();
    }
    
    private static testMethod void testRun4(){
        Test.startTest();

        PickAllKerfMapController controller = new PickAllKerfMapController();
        PageReference pageReference = controller.showKerfMap();
        
        controller.kerfMapPartNumber = '0000044D8071'; 
        controller.kerfMapECNumber = '10000H47375';  
        pageReference = controller.showKerfMap();
        
        KERF_Map__c kerfMapObj = new KERF_Map__c();
        kerfMapObj.Mask_Set_Id__c = '0000044D8071.10000H47375';
        kerfMapObj.External_Id__c = '0000044D8071.10000H473751454';
        kerfMapObj.Kerf_Die_X__c = 14;
        kerfMapObj.Kerf_Die_Y__c = 54;
        insert kerfMapObj;
        
        controller.kerfMapPartNumber = '0000044D8071'; 
        controller.kerfMapECNumber = '10000H47375';  
        pageReference = controller.showKerfMap();
        
        Test.stopTest();
    }
}