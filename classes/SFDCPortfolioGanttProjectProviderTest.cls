/*
    Author: Art Contreras
    Description: Test class for SFDCProjectGanttProjectProvider
    Test cases: 
    1.
*/

@isTest
public class SFDCPortfolioGanttProjectProviderTest{

    //test #1.
    static testMethod void doTestReturnStageResult(){
        test.startTest(); //start new governor limit
        
        //initialize variables, populate data structures
        
        SFDC_Project__c newPro = new SFDC_Project__c(Name='red',Overall_Status__c='Red',Priority_Sequence__c=0);
        insert newPro;
        
        SFDC_Project_Stage__c newStage = new SFDC_Project_Stage__c(Name='Test Stage',Name__c='User Request',SFDC_Project__c = newPro.id);
        newStage.Start_Date__c = Date.newinstance(2013, 1,1);
        newStage.End_Date__c = Date.newinstance(2013, 1,30);
        insert newStage;
        
        SFDC_Project_Milestone__c milestone = new SFDC_Project_Milestone__c (Name='Test Milestone 1', Stage__c = newStage.id);       
        milestone.Start_Date__c = Date.newinstance(2013, 1,1);
        milestone.End_Date__c = Date.newinstance(2013, 1,10); 
        insert milestone;
        
        SFDC_Project_Milestone__c milestone2 = new SFDC_Project_Milestone__c (Name='Test Milestone 2', Stage__c = newStage.id);       
        milestone2.Start_Date__c = Date.newinstance(2013, 1,1);
        milestone2.End_Date__c = Date.newinstance(2013, 1,10); 
        milestone2.Chart_Color__c = 'Blue';
        insert milestone2;
        
        SFDC_Project_Milestone__c milestone3 = new SFDC_Project_Milestone__c (Name='Test Milestone 3', Stage__c = newStage.id);       
        milestone3.Start_Date__c = Date.newinstance(2013, 1,1);
        milestone3.End_Date__c = Date.newinstance(2013, 1,10); 
        milestone3.Chart_Color__c = 'Green';
        insert milestone3;
        
        SFDC_Project_Milestone__c milestone4 = new SFDC_Project_Milestone__c (Name='Test Milestone 4', Stage__c = newStage.id);       
        milestone4.Start_Date__c = Date.newinstance(2013, 1,1);
        milestone4.End_Date__c = Date.newinstance(2013, 1,10); 
        milestone4.Chart_Color__c = 'Orange';
        insert milestone4;
        
        
        SFDC_Project__c proj2 = new SFDC_Project__c(Name='green',Overall_Status__c='Red',Priority_Sequence__c=0);
        insert proj2;
        
        SFDC_Project_Stage__c stage2 = new SFDC_Project_Stage__c(Name='Test Stage',Name__c='Implementation',SFDC_Project__c = proj2.id);
        stage2.Start_Date__c = Date.newinstance(2013, 1,1);
        stage2.End_Date__c = Date.newinstance(2013, 1,30);
        insert stage2;
        
        SFDC_Project_Milestone__c milestone5 = new SFDC_Project_Milestone__c (Name='Test Milestone 5', Stage__c = stage2.id);       
        milestone5.Start_Date__c = Date.newinstance(2013, 1,1);
        milestone5.End_Date__c = Date.newinstance(2013, 1,10); 
        insert milestone5;
        
        
        SFDC_Project__c proj3 = new SFDC_Project__c(Name='green',Overall_Status__c='Red',Priority_Sequence__c=0);
        insert proj3;
        
        SFDC_Project_Stage__c stage3 = new SFDC_Project_Stage__c(Name='Test Stage',Name__c='Implementation',SFDC_Project__c = proj3.id);
        stage3.Start_Date__c = Date.newinstance(2013, 1,1);
        stage3.End_Date__c = Date.newinstance(2013, 1,30);
        insert stage3;
        
        SFDCPortfolioGanttProjectProvider p = new SFDCPortfolioGanttProjectProvider();
        p.getProjects();
        p.getProjects(newPro.Id);
        p.getProjects(proj2.Id);
        p.getProjects(proj3.Id);
          
        test.stopTest();
    }
    
    
}