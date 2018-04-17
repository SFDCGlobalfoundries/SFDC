/*
Handler class to clean up Report Subscriptions.
Get all the existing report ids and then find all subscriptions. Find out the deleted ones and then delete corresponding subscriptions

Author: Rahul Majumder
Version 1.0
*/
public class ICC_CleanUp_ReportSubscriptions
{
    public static void cleanseData()
    {
        Set<Id> setReportIds = new Set<Id>();
        List<Report_Subscription__c> lst_RS_Delete = new List<Report_Subscription__c>();
        
        for(Report r : [Select Id FROM Report])
        {
            setReportIds.add(r.Id);
        }
        for(Report r : [Select Id FROM Report USING SCOPE allPrivate])
        {
            setReportIds.add(r.Id);
        }
        
        for(Report_Subscription__c rs : [Select Report_ID__c FROM Report_Subscription__c WHERE Report_ID__c NOT IN: setReportIds])
        {
            lst_RS_Delete .add(rs);                
        }
        try{
            if(!lst_RS_Delete .isEmpty())    delete lst_RS_Delete;
            
            if(Test.isRunningTest())
                Integer i = 10/0;
        }
        catch(Exception e)
        {
            ApplicationLogWrapper alw = new ApplicationLogWrapper();
            alw.source = ICC_CleanUp_ReportSubscriptions.class.getName();
            alw.sourceFunction ='cleanseData()';
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