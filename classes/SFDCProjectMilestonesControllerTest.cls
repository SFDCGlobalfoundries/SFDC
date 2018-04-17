/*
    Author: Win
    Created Date: Feb/25/2013 
    Description: Test class for SFDCProjectMilestonesController
    Test cases: 
    1. 
*/

@isTest
public class SFDCProjectMilestonesControllerTest{

    static testMethod void doTest1(){
        test.startTest();
        SFDC_Project__c newPro = new SFDC_Project__c(Name='red',Overall_Status__c='Red',Priority_Sequence__c=0);
        insert newPro;
        ApexPages.StandardController con = new ApexPages.StandardController(newPro);
        
        SFDCProjectMilestonesController controller = new SFDCProjectMilestonesController(con);
        controller.getMilestones();
        test.stopTest();

    }
}