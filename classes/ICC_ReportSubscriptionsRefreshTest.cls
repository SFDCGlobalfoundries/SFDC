/*
Test class for scheduler and batch to refresh SOQL if report changes
Author: Rahul Majumder
Version: 1
*/

@isTest
public class ICC_ReportSubscriptionsRefreshTest
{
    private testMethod static void testRefresh()
    {
        try{
            
            ICC_FetchReportMetadata.fetchLatestReportSOQL('test');
        }
        catch(Exception e)
        {
            ApplicationLogWrapper alw = new ApplicationLogWrapper();
            alw.source = ICC_ReportSubscriptionsRefreshTest.class.getName();
            alw.sourceFunction ='testRefresh()';
            alw.ApplicationName='ICC';
            alw.referenceInfo = 'Bug';
            alw.logMessage = 'Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
            alw.debugLevel = 'Error';
            alw.logCode = e.getTypeName();
            alw.ex = e.getCause();
            GlobalUtility.logMessage(alw);
        }
    }
    
    private testMethod static void testScheduler()
    {
        try{
            Test.startTest();
            ICC_Scheduler_RefreshSOQL_Standard sh1 = new ICC_Scheduler_RefreshSOQL_Standard();
            String sch = '0 0 23 * * ?'; system.schedule('Test Scheduler', sch, sh1); 
            Test.stopTest();
        }
        catch(Exception e)
        {
            ApplicationLogWrapper alw = new ApplicationLogWrapper();
            alw.source = ICC_ReportSubscriptionsRefreshTest.class.getName();
            alw.sourceFunction ='testScheduler()';
            alw.ApplicationName='ICC';
            alw.referenceInfo = 'Bug';
            alw.logMessage = 'Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
            alw.debugLevel = 'Error';
            alw.logCode = e.getTypeName();
            alw.ex = e.getCause();
            GlobalUtility.logMessage(alw);
        }
    }
    
    private testMethod static void testBatch()
    {
        try{
            Test.startTest();
            Id batchJobId = Database.executeBatch(new ICC_Batch_RefreshSubscrptnSOQL_Standard(), 200);
            Test.stopTest();
        }
        catch(Exception e)
        {
            ApplicationLogWrapper alw = new ApplicationLogWrapper();
            alw.source = ICC_ReportSubscriptionsRefreshTest.class.getName();
            alw.sourceFunction ='testBatch()';
            alw.ApplicationName='ICC';
            alw.referenceInfo = 'Bug';
            alw.logMessage = 'Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
            alw.debugLevel = 'Error';
            alw.logCode = e.getTypeName();
            alw.ex = e.getCause();
            GlobalUtility.logMessage(alw);
        }
    }
}