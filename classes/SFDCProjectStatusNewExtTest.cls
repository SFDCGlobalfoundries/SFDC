/*
    Author: Win
    Created Date: Feb/25/2013 
    Description: Test class for SFDCProjectStatusNewExt
    Test cases: 
    1. 
*/

@isTest
public class SFDCProjectStatusNewExtTest{

    static testMethod void doTest1(){
        test.startTest();
       SFDC_Project__c newPro = new SFDC_Project__c(Name='red',Overall_Status__c='Red',Priority_Sequence__c=0);
        insert newPro;
        
        SFDC_Project_Status__c newProStatus = new SFDC_Project_Status__c();
        newProStatus.Project__c = newPro.id;
        
        ApexPages.StandardController controller = new ApexPages.StandardController(newProStatus);
        
        SFDCProjectStatusNewExt ext = new SFDCProjectStatusNewExt(controller);
        
        test.stopTest();

    }
}