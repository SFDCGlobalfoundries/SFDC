/*
  Author: Anirban Roy
  Description: This is the batch apex class for deletion of 30 days old data of CPQ MLG Error Log records.
  History:
    ARoy        05252015    - code creation.             
*/

global class DeleteCPQMLGErrorLog implements Database.Batchable<sObject>{
    global final String query =  Test.isRunningTest()?'select id from CPQ_MLG_Error_Log__c':'select id from CPQ_MLG_Error_Log__c where createdDate != LAST_N_DAYS:30 ';
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC,List<CPQ_MLG_Error_Log__c> scope){
        delete scope;
    }

    global void finish(Database.BatchableContext BC){}
}