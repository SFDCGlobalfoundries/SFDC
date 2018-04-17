/*
    Author: Art
    Created Date: Mar/28/2013 
    Description: Test class for SFDCProjectMilestoneAfterDelete
    Test cases: 
    1. 
*/

@isTest
public class SFDCProjectMilestoneAfterDeleteTest{

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
        
        SFDC_Task__c task = new SFDC_Task__c(Milestone__c = milestone.Id, Task_Name__c = 'Test');
        insert task;
        
        
        
        delete milestone;
        test.stopTest();

    }
    
   
}