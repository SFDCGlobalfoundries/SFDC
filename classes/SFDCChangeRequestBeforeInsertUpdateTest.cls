/*
    Author: Art
     Created Date: Mar/28/2013 
    Description: Test class for SFDCChangeRequestBeforeInsertUpdate
    Test cases: 
    */

@isTest
public class SFDCChangeRequestBeforeInsertUpdateTest{

    static testMethod void doTestNullCloseDate(){
        test.startTest();
        SFDC_Project__c sfPro = new SFDC_Project__c(Name='red',Overall_Status__c='Red',Priority_Sequence__c=0);
        insert sfPro; 
        SFDC_Change_Request__c cr = new SFDC_Change_Request__c(Status__c = 'Closed-Accepted',Description__c = 'Null close date');
        try
        {
             insert cr;  
             System.assert(false,'insert should have failed'); 
         }catch(Exception expected)
          {
          
         }          
        test.stopTest();

    }
    
     static testMethod void doTestNullResumeDate(){
        test.startTest();
        SFDC_Project__c sfPro = new SFDC_Project__c(Name='red',Overall_Status__c='Red',Priority_Sequence__c=0);
        insert sfPro; 
        SFDC_Change_Request__c cr = new SFDC_Change_Request__c(Status__c = 'On Hold',Description__c = 'Null resume date');
        try
        {
             insert cr;  
             System.assert(false,'insert should have failed'); 
         }catch(Exception expected)
          {
          
         }          
        test.stopTest();

    }
    
    static testMethod void doTestNullStartDate(){
        test.startTest();
        SFDC_Project__c sfPro = new SFDC_Project__c(Name='red',Overall_Status__c='Red',Priority_Sequence__c=0);
        insert sfPro; 
        Date closeDate = Date.newinstance(2013, 12, 17);
        SFDC_Change_Request__c cr = new SFDC_Change_Request__c(Status__c = 'Open',Description__c = 'Null start date', Close_Date__c = closeDate);
        try
        {
             insert cr;  
             System.assert(false,'insert should have failed'); 
         }catch(Exception expected)
          {
          
         }          
        test.stopTest();

    }
    
    static testMethod void doTestCloseDateLessThanStartDate(){
        test.startTest();
        SFDC_Project__c sfPro = new SFDC_Project__c(Name='red',Overall_Status__c='Red',Priority_Sequence__c=0);
        insert sfPro; 
        Date closeDate = Date.newinstance(2013, 12, 17);
        Date startDate = Date.newinstance(2013, 12, 25);
        SFDC_Change_Request__c cr = new SFDC_Change_Request__c(Status__c = 'Open',
        Description__c = 'close date less than start date', 
        Close_Date__c = closeDate,
        Start_Date__c = startDate);
        try
        {
             insert cr;  
             System.assert(false,'insert should have failed'); 
         }catch(Exception expected)
          {
          
         }          
        test.stopTest();

    }
    
    static testMethod void doTestCloseDateLessThanResumeDate(){
        test.startTest();
        SFDC_Project__c sfPro = new SFDC_Project__c(Name='red',Overall_Status__c='Red',Priority_Sequence__c=0);
        insert sfPro; 
        Date startDate = Date.newinstance(2013, 12, 10);
        Date closeDate = Date.newinstance(2013, 12, 25);
        Date resumeDate = Date.newinstance(2013, 12, 27);
        SFDC_Change_Request__c cr = new SFDC_Change_Request__c(Status__c = 'Open',
        Description__c = 'close date less than resume date', 
        Close_Date__c = closeDate,
        Start_Date__c = startDate,
        Resume_Date__c = resumeDate);
        try
        {
             insert cr;  
             System.assert(false,'insert should have failed'); 
         }catch(Exception expected)
          {
          
         }          
        test.stopTest();

    }
    
    static testMethod void doTestResumeDateNullStartDate(){
        test.startTest();
        SFDC_Project__c sfPro = new SFDC_Project__c(Name='red',Overall_Status__c='Red',Priority_Sequence__c=0);
        insert sfPro; 
        
        Date resumeDate = Date.newinstance(2013, 12, 27);
        SFDC_Change_Request__c cr = new SFDC_Change_Request__c(Status__c = 'Open',
        Description__c = ' resume date with null start date', 
        Resume_Date__c = resumeDate);
        try
        {
             insert cr;  
             System.assert(false,'insert should have failed'); 
         }catch(Exception expected)
          {
          
         }          
        test.stopTest();

    }
    
    static testMethod void doTestResumeDateLessThanStartDate(){
        test.startTest();
        SFDC_Project__c sfPro = new SFDC_Project__c(Name='red',Overall_Status__c='Red',Priority_Sequence__c=0);
        insert sfPro; 
        
        Date resumeDate = Date.newinstance(2013, 12, 27);
        Date startDate = Date.newinstance(2013, 12, 28);
        SFDC_Change_Request__c cr = new SFDC_Change_Request__c(Status__c = 'Open',
        Description__c = ' resume date less than start date', 
        Start_Date__c = startDate,
        Resume_Date__c = resumeDate);
        try
        {
             insert cr;  
             System.assert(false,'insert should have failed'); 
         }catch(Exception expected)
          {
          
         }          
        test.stopTest();

    }
    
    
    

    
   }