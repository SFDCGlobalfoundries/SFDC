@isTest(seeAllData = true)
public class ICC_Test_CleanUp_ReportSubscriptions
{
    private testMethod static void test()
    {
        try{
            Report_Subscription__c testRS = new Report_Subscription__c(Report_ID__c = 'xxxxxxxxx');
            insert testRS;
            ICC_CleanUp_ReportSubscriptions.cleanseData();
        }
        catch(Exception e)
        {
            ApplicationLogWrapper alw = new ApplicationLogWrapper();
            alw.source = ICC_Test_CleanUp_ReportSubscriptions.class.getName();
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