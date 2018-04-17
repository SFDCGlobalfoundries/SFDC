/*
    Author: Ariz Solito
    Description: Test class for PCMYields class
    History: 
        Asolito     09/19/2016    - Code creation.                                   
*/

@isTest
private class PCMYieldsTest{
    @testSetup
     static void testDataSetup(){
        DataUtilTest.loadEnvironmentVariables();        
     }
     
     static testMethod void testClass(){
         PCM_Yield__c y = new PCM_Yield__c(             
             catalog_id__c = 'c1',
             version__c = '1'
         );    
         insert y;
         
         test.startTest();        
         
         PCMYields ctrl = new PCMYields();
         
         ctrl.getCatalog();
         ctrl.getVersion();         
         ctrl.getCatalogid();
         ctrl.getVersions();
         ctrl.setCatalog('c1');
         ctrl.setCatalog('1');
         
         //call save method
         ctrl.save();
         
         test.stopTest();
         
     }
}