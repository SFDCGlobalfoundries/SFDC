/*
    Author: Art
     Created Date: Mar/28/2013 
    Description: Test class for SFDCProjectIssueBInsertUpdate
    Test cases: 
    */

@isTest
public class SFDCProjectIssueBInsertUpdateTest{

    
    
    static testMethod void doTestOpenNullCloseDate(){
        test.startTest();
        SFDC_Project__c sfPro = new SFDC_Project__c(Name='red',Overall_Status__c='Red',Priority_Sequence__c=0);
        insert sfPro; 
    
        SFDC_Project_Issue__c issue = new SFDC_Project_Issue__c(Status__c = 'Open',
        Description__c = ' null close date' );
        try
        {
             insert issue;  
             System.assert(false,'insert should have failed'); 
         }catch(Exception expected)
          {
          
         }          
        test.stopTest();

    }
    
     static testMethod void doTestOnHoldNullResumeDate(){
        test.startTest();
        SFDC_Project__c sfPro = new SFDC_Project__c(Name='red',Overall_Status__c='Red',Priority_Sequence__c=0);
        insert sfPro; 
    
        SFDC_Project_Issue__c issue = new SFDC_Project_Issue__c(Status__c = 'On Hold',
        Description__c = ' null close date' );
        try
        {
             insert issue;  
             System.assert(false,'insert should have failed'); 
         }catch(Exception expected)
          {
          
         }          
        test.stopTest();

    }
    
     static testMethod void doTestClosedNullCloseDate(){
        test.startTest();
        SFDC_Project__c sfPro = new SFDC_Project__c(Name='red',Overall_Status__c='Red',Priority_Sequence__c=0);
        insert sfPro; 
    
        SFDC_Project_Issue__c issue = new SFDC_Project_Issue__c(Status__c = 'Closed',
        Description__c = ' null close date' );
        try
        {
             insert issue;  
             System.assert(false,'insert should have failed'); 
         }catch(Exception expected)
          {
          
         }          
        test.stopTest();

    }
    
    
    

    
   }