/*
    Author: Yash Kumar
    Description: Test class for GFCalendarComponentController
    History:
        YKUmar      02152013    - code creation.
        Nbustillos  10122013    - Added call to loadEnvironmentVariables() method.
        Ashwini     05152015    - Updated code for refactoring of test class.
 
*/

@isTest
public class GFCalendarComponentControllerTest{
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MYTEST ACCOUNT1');                           
        fieldValueMap.put('sub_type__c', 'Direct');
        fieldValueMap.put('site_department__c', 'test dept');          
        fieldValueMap.put('transaction_type__c', 'transactional');                          
        fieldValueMap.put('region__c', 'US');        
        fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Corporate_City__c', 'Test City');                
        fieldValueMap.put('Corporate_Country__c', 'India');
        fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Bill_To_City__c', 'Test City');            
        fieldValueMap.put('Bill_To_Country__c', 'India');        
        fieldValueMap.put('Fab_9_10__c','No');

        AccountDataFactory.createAccount(fieldValueMap);
    }
    static testMethod void doTestGFCalendarComponentController(){
        
        // Load Environment Variables   
        //DataUtilTest.loadEnvironmentVariables();
        
        test.startTest();
        GFCalendarComponentController ObjGFCalCompContr = new GFCalendarComponentController();
        ObjGFCalCompContr.providers = 'VisitationToGFCalActivityProvider,SFDCPortfolioGanttProjectProvider';
        ObjGFCalCompContr.getProviderActivityTypes();
        ObjGFCalCompContr.getProviders();
        ObjGFCalCompContr.getProviderActivities();
        ObjGFCalCompContr.getNumDaysInWeek();
        ObjGFCalCompContr.getNumWeeks();
        
        Account acct = getAccount('MYTEST ACCOUNT1');
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('AccountId',acct.Id);
        fieldValueMap.put('Name','Test Oppty');  
        fieldValueMap.put('StageName','1. Discovery');
        fieldValueMap.put('CloseDate',System.today().addYears(1));  
        fieldValueMap.put('Target_Process_Node__c','14XM');
        fieldValueMap.put('Market_Segment__c','Automotive');  
        fieldValueMap.put('Process_Platform__c','GF Baseline');
        fieldValueMap.put('Fab_Split__c',100);          
        fieldValueMap.put('Process_Geometry__c','0.014UM');  
        fieldValueMap.put('Process_Family__c','Super Low Power');
        fieldValueMap.put('Opportunity_Sourcing_Type__c','First Source');          
         
        Opportunity oppty = OpportunityDataFactory.createOpportunity(fieldValueMap);
        
         Task task0 = new Task(
          WhatID = oppty.Id,
          Priority = 'High', 
          ReminderDateTime = System.today().addYears(1), 
          Status = 'Not Started'
          );
         insert task0;
         
        task tesk1= new task();  
        tesk1=[select status,id from task where id=:task0.id];
        tesk1.Status='Open';
        update tesk1; 
        
        tesk1.Status='Closed';
        update tesk1; 
        
 
       
       ObjGFCalCompContr.objectId=oppty.id;
       ObjGFCalCompContr.typeName='Opportunity';
         
        ObjGFCalCompContr.getActivityHistories();
        ObjGFCalCompContr.getOpenActivities();
        test.stopTest();

    }
    
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
}