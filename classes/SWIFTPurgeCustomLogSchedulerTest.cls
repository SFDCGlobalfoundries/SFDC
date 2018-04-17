/*
Author: Cognizant
Company: Cognizant
Description: Test Class for Custom Log Purging Schedulable Class-SWIFTPurgeCustomLogScheduler
History:
created     06/10/2014     
*/
@isTest (SeeAllData=false)
 private class SWIFTPurgeCustomLogSchedulerTest
 {
 
 static testMethod void schedule_SWIFTPurgeCustomLogBatch(){
   Environment_variable__c ev = new environment_variable__c(Name='Custom_Log_Age', value__c='30');
   insert ev;
   Test.StartTest();
   string CORN_EXP = '0 0 0 1 4 ?';
   string jobid = system.schedule('Test Batch job', CORN_EXP, new SWIFTPurgeCustomLogScheduler() ); 
   Test.StopTest();
 }
 }