@isTest(seeAllData = true)
public class ICC_Test_NewSubscription
{
    private static testmethod void test()
    {
        Report_Subscription__c testRS = new Report_Subscription__c(Report_Id__c = [select id from Report WHERE DeveloperName = 'ICC_Test_Coverage_Subscription_Report'].id, Interval__c = 'Daily');
        
        ApexPages.StandardController sc = new ApexPages.StandardController(testRS);
        ICC_NewSubscription testNewSub = new ICC_NewSubscription(sc);
    
        PageReference pageRefNew = Page.ICC_New_Subscription;
        //pageRef.getParameters().put('id', String.valueOf(testAccountPlanInsert.Id));
        Test.setCurrentPage(pageRefNew);
        
        testNewSub.rtSubr.Report_Type__c = 'Custom';
        testNewSub.getReports();
        testNewSub.rtSubr.Report_Type__c = 'Standard';
        testNewSub.getReports(); 
        ApexPages.currentPage().getParameters().put('retURL', '001');
        testNewSub.fetchReportsOfSeletedReportType();
        testNewSub.save();
        
        testNewSub.rtSubr.Interval__c = 'Daily';
        //testNewSub.fetchDataTypeOfFields('Account');
        
        testNewSub.rtSubr.Interval__c = null;
        testNewSub.rtSubr.Report_Id__c = null;
        testNewSub.save();
    }
}