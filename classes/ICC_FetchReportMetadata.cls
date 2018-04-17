/*
Handler class called from batch that will run every day and check if any standard report has been modified.
If yes, then it goes to all respective subscriptions and updates the soql.

Author: Rahul Majumder
Version: 1
*/

public class ICC_FetchReportMetadata
{
    public static String fetchLatestReportSOQL(String reportID)
    {
        String strSOQL_Validation = ICC_ReportSubscriptionUtility.validateReportSOQL(reportID);
        if(strSOQL_Validation.startsWith('Error'))
        {
            return strSOQL_Validation;
        }
        else 
        {
            return strSOQL_Validation.split('~')[0];
        }
                
        
    }
    
}