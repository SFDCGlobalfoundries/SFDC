/*
Author: Cognizant
Company: Cognizant
Description: Test Class for Custom Log Purging Batchable Class-SWIFTPurgeCustomLogBatch
History:
created     06/10/2014     
*/
@istest
private class SWIFTPurgeCustomLogBatchTest{
@istest (SeeAllData=false)
static void customLogBatchableTest() { 
Environment_variable__c ev = new environment_variable__c(Name='Custom_Log_Age', value__c='30');
insert ev;
SWIFT_Application_Log__c tempLog = new SWIFT_Application_Log__c();
tempLog.Debug_Level__c = 'ERROR';
tempLog.Apex_Component_Name__c = 'SWIFT Oracle DB Response Service';
tempLog.Apex_Component_Id__c = 'componenetID';
tempLog.Error_Message__c = 'DRT:test Error Message';
tempLog.Stack_Trace__c = 'SWIFt Oracle DB Respnse Service: Line no. 7';
insert tempLog;
test.StartTest();
SWIFTPurgeCustomLogBatch iBatch = new SWIFTPurgeCustomLogBatch();
database.executeBatch(iBatch);
Test.StopTest();
    
}
}