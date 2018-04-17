/*
Test class for ICC_CleanUp_ReportSubscriptions class that cleans all subscriptions 
if any report gets deleted

Author: Rahul Majumder
*/
@isTest(seeAllData = true)
public class ICC_CleanUp_ReportSubscriptionsTest
{
    private testMethod static void testCleanUp()
    {
        try{
            Report_Subscription__c testRS = new Report_Subscription__c(Report_ID__c = 'xxxxxxxxx');
            insert testRS;
            ICC_CleanUp_ReportSubscriptions.cleanseData();
        }
        catch(Exception e)
        {
            ApplicationLogWrapper alw = new ApplicationLogWrapper();
            alw.source = ICC_CleanUp_ReportSubscriptionsTest.class.getName();
            alw.sourceFunction ='test()';
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