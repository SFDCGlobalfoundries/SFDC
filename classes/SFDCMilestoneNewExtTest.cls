/*
    Author: Win
    Created Date: Feb/25/2013 
    Description: Test class for SFDCMilestoneNewExt
    Test cases: 
    1. 
*/

@isTest
public class SFDCMilestoneNewExtTest{

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
        milestone.Implement_Name__c = 'test impl name';
        insert milestone;
        
        ApexPages.StandardController controller = new ApexPages.StandardController(milestone);
        
        SFDCMilestoneNewExt ext = new SFDCMilestoneNewExt(controller);
        ext.getImplementationStageName();
        ext.getMilestone();
        ext.getStage();
        
        ext.getStage().Name__c = SFDCConstants.IMPLEMENTATION_STAGE;
        ext.Save();
        
        SFDC_Project_Milestone__c milestone2 = new SFDC_Project_Milestone__c (Name='Test Milestone 2',Stage__c = newStage.id);
        milestone2.Implement_Name__c = 'test impl name 2';
        milestone2.Name__c = 'name 2';
        insert milestone2;
        
        ApexPages.StandardController controller2 = new ApexPages.StandardController(milestone2);
        SFDCMilestoneNewExt ext2 = new SFDCMilestoneNewExt(controller2);
        ext2.save();
        
        
        test.stopTest();

    }
    
   
}