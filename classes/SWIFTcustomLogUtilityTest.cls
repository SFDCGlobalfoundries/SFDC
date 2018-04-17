/*
Component Name: SWIFTcustomLogUtilityTest
Company: Cognizant
Description: Test Class for Custom Log Utility Class- SWIFTcustomLogUtility
History:
created     06/10/2014     
*/
@istest
private class SWIFTcustomLogUtilityTest{
@istest (SeeAllData=false)
static void testCustomLog() { 
    list<SWIFTcustomLogUtility.customLogClass> lstlog = new list<SWIFTcustomLogUtility.customLogClass>();
    SWIFTcustomLogUtility.customLogClass templog = new SWIFTcustomLogUtility.customLogClass();
    tempLog.debugLevel = 'ERROR';
    tempLog.componentName = 'SWIFT Oracle DB Response Service';
    tempLog.ComponentID = 'componenetID';
    tempLog.errorMessage = 'DRT:test Error Message';
    tempLog.stackTrace = 'SWIFt Oracle DB Respnse Service: Line no. 7';
    lstLog.add(templog);
    SWIFTcustomLogUtility.saveCustomLog(lstLog);
}
}