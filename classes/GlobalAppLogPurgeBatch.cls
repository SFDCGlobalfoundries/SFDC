/**
* Author: Devendra Babu Itraju
* Company: GF
* Project: Release Management Utilitity
* Description: 
*  
*  
* History:
*    <Devendra Babu Itraju> 2016-05-24 - Created
**/
global class GlobalAppLogPurgeBatch implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        decimal interval=System_Log_Setting__c.getInstance().Log_Purge_Days__c; //get the days from custom setting
        if(interval==null)interval=-60; // By default system will delete the records which are created before 60 days, so added hard limit to 60
        datetime diffDate=system.now().adddays(integer.valueof(interval)); // set the comparision date to 60 days before current date
        String soql = 'Select Id FROM Application_Log__c where createddate < :diffDate'; //query for old records which are created before 60 days
        return Database.getQueryLocator(soql);
    }
   
    global void execute(Database.BatchableContext bc, List<Application_Log__c > logList) {
       delete logList; //delte the records 
    }
   
    global void finish(Database.BatchableContext bc) {
        
    }
}