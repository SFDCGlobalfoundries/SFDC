/*
Batch that will run every day and check if any standard report has been modified.
If yes, then it goes to all respective subscriptions and updates the soql.

Author: Rahul Majumder
Version: 1
*/
global class ICC_Batch_RefreshSubscrptnSOQL_Standard implements database.batchable<Sobject>,  Database.AllowsCallouts 
{
    global database.QueryLocator start(Database.batchableContext BC)
    {
        Set<String> setFolderNames = new Set<String>();
        for(ICC_Standard_Report__c sr : ICC_Standard_Report__c.getall().values())
        {
            setFolderNames.add(sr.Name);
        }
        
        return database.getQueryLocator([Select Id, DeveloperName, Name, LastModifiedDate FROM Report WHERE DeveloperName IN: setFolderNames]);
    }
    
    global void execute (Database.BatchableContext BC, List<Report> Scope)
    {
        Map<Id, DateTime> mapReportId_To_LastModifiedDate = new Map<Id, DateTime>();
        Map<Id, String> mapReportId_To_SOQL = new Map<Id, String>();
        Set<Id> setReportIds_ToFetchMetadata = new Set<Id>();
        List<Report_Subscription__c> lstSubscriptions_ToUpdateSOQL = new List<Report_Subscription__c>();
        
        for(Report r : scope)
        {
            mapReportId_To_LastModifiedDate.put(r.id, r.LastModifiedDate);
        }
        
        for(Report_Subscription__c rs : [Select LastModifiedDate, Report_Id__c FROM Report_Subscription__c WHERE Report_Id__c IN: mapReportId_To_LastModifiedDate.keyset()])
        {
            if(rs.LastModifiedDate < mapReportId_To_LastModifiedDate.get(rs.Report_Id__c))
            {
                setReportIds_ToFetchMetadata.add(rs.Report_Id__c);
                lstSubscriptions_ToUpdateSOQL.add(rs);
            }
        }
        if(Test.isRunningTest())
        {
            List<ICC_Test_Report_Name__c> lstCS_Test = new List<ICC_Test_Report_Name__c>();
            lstCS_Test = [Select Name FROM ICC_Test_Report_Name__c LIMIT 1];
            String strTestReport = lstCS_Test.isEmpty() ? '' : lstCS_Test[0].Name;
            
            List<Report> lstReportsForTest = new List<Report>();
            lstReportsForTest = [select id from Report WHERE DeveloperName =:strTestReport];
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
    
    global void finish(Database.batchableContext BC)
    {
        // Do nothing
    }

}