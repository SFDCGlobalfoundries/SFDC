/*
    Author: Win
    Created Date: Feb/25/2013 
    Description: Test class for SFDCMilestoneEditExt
    Test cases: 
    1. 
*/

@isTest
public class SFDCMilestoneEditExtTest{

    static testMethod void doTest1(){
        test.startTest();
        //initialize variables, populate data structures
        
        SFDC_Project__c newPro = new SFDC_Project__c(Name='red',Overall_Status__c='Red',Priority_Sequence__c=0);
        insert newPro;
        
        SFDC_Project_Stage__c newStage = new SFDC_Project_Stage__c(Name='Test Stage',Name__c='User Request');
        insert newStage;
        
        newStage.SFDC_Project__c = newPro.id;
        update newStage;
        
        SFDC_Project_Milestone__c milestone = new SFDC_Project_Milestone__c (Name='Test Milestone', Stage__c = newStage.id);
        insert milestone;
        
        ApexPages.StandardController controller = new ApexPages.StandardController(milestone);
        
        SFDCMilestoneEditExt ext = new SFDCMilestoneEditExt(controller);
        
        ext.getImplementationStageName();
        ext.getMilestone();
        ext.getStage();
        ext.Save();
        
        ext.getStage().Name__c = SFDCConstants.IMPLEMENTATION_STAGE;
        ext.Save();
        
        test.stopTest();

    }
}