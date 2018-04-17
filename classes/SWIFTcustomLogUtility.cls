/*
Component Name: SWIFTcustomLogUtility
Author: Cognizant
Description: Utility Class to insert Custom Error Logs in system.
History:
created     10/6/2014     
*/
public class SWIFTcustomLogUtility{
public static void saveCustomLog (list<customLogClass> lstErrorLogs){
if(lstErrorLogs!=null && lstErrorLogs.size()>0){
list<SWIFT_Application_Log__c> logs = new list<SWIFT_Application_Log__c>();
for(customLogClass iLog :lstErrorLogs){
SWIFT_Application_Log__c tempLog = new SWIFT_Application_Log__c();
tempLog.Debug_Level__c = iLog.debugLevel;
tempLog.Apex_Component_Name__c = iLog.componentName;
tempLog.Apex_Component_Id__c = iLog.ComponentID;
tempLog.Error_Message__c = iLog.errorMessage;
tempLog.Stack_Trace__c = iLog.stackTrace;
tempLog.Message_ID__c = iLog.messageID;
tempLog.Method__c = iLog.method;
tempLog.Integration_Payload__c = iLog.integrationPayload;
logs.add(tempLog);
}
insert logs;
}

}
public class customLogClass{
public string debugLevel;
public string componentName;
public string ComponentID;
public string errorMessage;
public string stackTrace;
public string messageID;
public string method;
public string integrationPayload;
}
}