public Without sharing class clsPortalReports
{
public Map<String,Portal_Report_Link__c> portalReportLink;
Public Portal_Report_Link__c portalReportDocumentDownloadValue;
Public Portal_Report_Link__c portalFrequencyLoginValue;
public String documentDownloadName{get;set;}
public String frequencyLoginName{get;set;}
Public Portal_Report_Link__c portalReportInactiveUsersValue;
Public Portal_Report_Link__c portalTopDownloadsValue;
public String InactiveUsersName{get;set;}
public String TopDownloadsName{get;set;}
Public Portal_Report_Link__c portalReportTypeDocumentSubscribedValue;
public String TypeDocumentSubscribedName{get;set;}
public clsPortalReports()
{
portalReportLink = Portal_Report_Link__c.getAll();
portalReportDocumentDownloadValue = portalReportLink.get('Document downloads');
portalFrequencyLoginValue = portalReportLink.get('Frequency of logins');
portalReportInactiveUsersValue = portalReportLink.get('Users Inactive since last 3 months');
portalTopDownloadsValue = portalReportLink.get('Top 20 downloads');
portalReportTypeDocumentSubscribedValue = portalReportLink.get('Docs and Reports Subscribed');
documentDownloadName = portalReportDocumentDownloadValue.Name;
frequencyLoginName = portalFrequencyLoginValue.Name;
InactiveUsersName = portalReportInactiveUsersValue.Name;
TopDownloadsName = portalTopDownloadsValue.Name;
TypeDocumentSubscribedName = portalReportTypeDocumentSubscribedValue.Name;
} 

    public PageReference onclickRadioButton() {
        return null;
    }
      String reportName= null;
   
    public String getreportName() {
        return reportName;
    }
   
             
    public void setreportName(String reportName) { this.reportName= reportName; }  
    public  String  getURL() {
    String retUrl ;
    if(reportName != null && reportName != '')
    {
       Portal_Report_Link__c insPortalReportLink = portalReportLink.get(reportName);
       if(insPortalReportLink  != null)
       {
       if(reportName.equals(insPortalReportLink.Link__c))
       {
           for(Report reportIns : [Select id from Report where Name =: insPortalReportLink.Link__c limit 1])
           {
            retUrl = '/'+reportIns.Id+'?isdtp=mn';
           }
       }
       else
        retUrl = insPortalReportLink.Link__c ;
       }
    }
    return retUrl ;
    }
}