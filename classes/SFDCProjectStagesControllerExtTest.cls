/*
    Author: Win
    Created Date: Feb/25/2013 
    Description: Test class for SFDCProjectStagesControllerExt
    Test cases: 
    1. 
*/

@isTest
public class SFDCProjectStagesControllerExtTest{

    static testMethod void doTest1(){
        test.startTest();
        //initialize variables, populate data structures
        
        SFDC_Project__c newPro = new SFDC_Project__c(Name='red',Overall_Status__c='Red',Priority_Sequence__c=0);
        insert newPro;
        
        ApexPages.StandardController controller = new ApexPages.StandardController(newPro);
        
        SFDCProjectStagesControllerExt ext = new SFDCProjectStagesControllerExt(controller);
        ext.getProject();
        ext.getStages();
        
        test.stopTest();

    }
}