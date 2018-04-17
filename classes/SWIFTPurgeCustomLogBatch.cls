/*
Type Name: SWIFTPurgeCustomLogBatch 
Author: Cognizant 
Created Date: 06-Oct-2014
Reason: This is a Batch Apex class to purge custom log records 
Change History:
*/
global class SWIFTPurgeCustomLogBatch implements Database.Batchable<sObject> {

 global String Query = 'SELECT Id FROM SWIFT_Application_Log__c WHERE LastModifieddate <Last_N_Days:30';
 global Database.QueryLocator start(Database.BatchableContext BC){
  Environment_Variable__c  cs =[select id,value__c from Environment_Variable__c where name ='Custom_Log_Age' limit 1]; 
  if(cs.value__c!=null){
      Query  = Query.substring(0,Query.length()-2)+cs.value__c;
      if(Test.isRunningTest()){
          Query = 'SELECT Id FROM SWIFT_Application_Log__c limit 1';
      }
  }       
      return Database.getQueryLocator(Query);
 }

 global void execute(Database.BatchableContext BC, List<sObject> scope){
   try{
       delete scope;
   }catch(exception e){}
 }
 
 global void finish(Database.BatchableContext BC){
 }
}