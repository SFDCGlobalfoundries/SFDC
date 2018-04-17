/*
Type Name: clsPortalReportTest
Author: Cognizant
Created Date: 16-August-2013
Reason: This is the Test class for class clsPortalReports. 
Change History:
Author: 
Modified Date: 
Reason: 
……..
……..
*/
@isTest(SeeAllData=true)
public class clsPortalReportTest 
{
     static testMethod void testExtReports() {
     	
	     PageReference pageRef = Page.vfPortalReports;
	     Test.setCurrentPageReference(pageRef);
	     String reportname = 'Document downloads';
	     clsPortalReports clsPReports = new clsPortalReports();
	     clsPReports.getreportName();
	     clsPReports.setreportName(reportname);
	     String rtName = clsPReports.getreportName();
	     system.assertEquals(reportname,rtName);
	     clsPReports.onclickRadioButton();
	     //clsPReports.getReportLinkName();
	     clsPReports.getURL();
	     
    }
    
    static testMethod void testSFDCReports() {
     	
	     PageReference pageRef = Page.vfPortalReports;
	     Test.setCurrentPageReference(pageRef);
	     String reportname = 'Frequency of logins';
	     clsPortalReports clsPReports = new clsPortalReports();
	     clsPReports.getreportName();
	     clsPReports.setreportName(reportname);
	     String rtName = clsPReports.getreportName();
	     system.assertEquals(reportname,rtName);
	     clsPReports.onclickRadioButton();
	     //clsPReports.getReportLinkName();
	     clsPReports.getURL();
	     
    }

}