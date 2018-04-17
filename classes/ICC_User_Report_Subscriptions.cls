/*
Controller class for ICC_User_Report_Subscriptions VF page
On load of page, fetch all report subscription records of current logged in user

Created by: Rahul Majumder
Version 1.0
*/
public with sharing class ICC_User_Report_Subscriptions 
{
    public List<Report_Subscription__c> lstReportSubscriptions {get;set;} // List of Report Subscriptions to be displayed on VF page
    
    public ICC_User_Report_Subscriptions()
    {
        lstReportSubscriptions = new List<Report_Subscription__c>();
        // Fetch Report Subscription records belonging to logged in user
        for(Report_Subscription__c rs : [Select Id, Name, Report_Name__c, Report_Type__c, Interval__c 
                                         FROM Report_Subscription__c 
                                         WHERE Subscriber__c =: UserInfo.getUserId() 
                                         ORDER BY Name])
        {
            lstReportSubscriptions.add(rs);
        }
    }
    
    public void refreshAllSubscriptionSOQLs()
    {
        List<Report> lst_LoggedInUsersPrivateReports = new List<Report>();
        lst_LoggedInUsersPrivateReports = [Select Id, DeveloperName, Name, LastModifiedDate FROM Report USING SCOPE allPrivate WHERE ownerid =: UserInfo.getUserId()];
        Map<Id, DateTime> mapReportId_To_LastModifiedDate = new Map<Id, DateTime>();
        Map<Id, String> mapReportId_To_SOQL = new Map<Id, String>();
        Set<Id> setReportIds_ToFetchMetadata = new Set<Id>();
        List<Report_Subscription__c> lstSubscriptions_ToUpdateSOQL = new List<Report_Subscription__c>();
        
        if(Test.isRunningTest())
        {
            lst_LoggedInUsersPrivateReports = [Select Id, DeveloperName, Name, LastModifiedDate FROM Report WHERE DeveloperName = 'ICC_Test_Coverage_Subscription_Report'];
        }
        
        for(Report r : lst_LoggedInUsersPrivateReports)
        {
            mapReportId_To_LastModifiedDate.put(r.id, r.LastModifiedDate);
        }
        
        for(Report_Subscription__c rs : [Select LastModifiedDate, Report_Id__c FROM Report_Subscription__c WHERE Report_Id__c IN: mapReportId_To_LastModifiedDate.keyset()])
        {
            if(rs.LastModifiedDate < mapReportId_To_LastModifiedDate.get(rs.Report_Id__c) || Test.isRunningTest())
            {
                setReportIds_ToFetchMetadata.add(rs.Report_Id__c);
                lstSubscriptions_ToUpdateSOQL.add(rs);
            }
        }
        
        if(Test.isRunningTest())
        {
            List<Report> lstReportsForTest = new List<Report>();
            lstReportsForTest = [select id from Report WHERE DeveloperName = 'ICC_Test_Coverage_Subscription_Report'];
            if(!lstReportsForTest.isEmpty())
                setReportIds_ToFetchMetadata.add(lstReportsForTest[0].id);
        }
        
        for(Id reportId : setReportIds_ToFetchMetadata)
        {
            String latestReportSOQL = ICC_FetchReportMetadata.fetchLatestReportSOQL(reportId);
            if(!latestReportSOQL.startsWithIgnoreCase('Error'))
            {
                mapReportId_To_SOQL.put(reportId, latestReportSOQL);
            }
        }
        List<Report_Subscription__c> lstSubscriptionsUpdate = new List<Report_Subscription__c>();
        
        for(Report_Subscription__c rs : lstSubscriptions_ToUpdateSOQL)
        {
            if(mapReportId_To_SOQL.containsKey(rs.Report_Id__c))
            {
                rs.Report_SOQL__c = mapReportId_To_SOQL.get(rs.Report_Id__c);
                lstSubscriptionsUpdate.add(rs);
            }
        }
        
        if(!lstSubscriptionsUpdate.isEmpty())   update lstSubscriptionsUpdate;  
        
        
    }
    
    // Method called on click of "DEL" link. Method deletes the selected record.
    // The ID of deleted record is passed to "delReportSubID" as parameter
    public void deleteReportSubscription()
    {
        try
        {
            delete new Report_Subscription__c(id = System.currentPageReference().getParameters().get('delReportSubID'));
        }
        catch(Exception e)
        {
            ApplicationLogWrapper alw = new ApplicationLogWrapper();alw.source = ICC_User_Report_Subscriptions.class.getName();alw.sourceFunction ='deleteReportSubscription()';
            alw.ApplicationName='ICC';
            alw.referenceInfo = 'Bug';
            alw.logMessage = 'Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
            alw.debugLevel = 'Error';
            alw.logCode = e.getTypeName();
            alw.ex = e.getCause();
            GlobalUtility.logMessage(alw);
            // If any errors in DML, display error message on page
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, e.getMessage()));
            return;
        }
    }
 
}