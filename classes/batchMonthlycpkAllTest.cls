/*
    Author:      Deepti Narayan Biswal
    Description: This class tests for batchMonthlycpkReportCreation,batchMonthlycpkReportFolderCallout,
                      ScheduledcpkReportFolderCreation and NoCPKReportforMonthController Classes.

    History:
    DBiswal    02242015 - Class Creation.
*/
@isTest
private class batchMonthlycpkAllTest{
    Public static String CRON_EXP = '0 0 0 15 3 ? 2022';
    //Test Method to test batchMonthlycpkReportCreation,batchMonthlycpkReportFolderCallout and ScheduledcpkReportFolderCreation Classes
    static testMethod void testbatch(){
        List<FAB__c> fablist = new List<FAB__c>();
        List<CPK_Report__c> cpkReportlist = new List<CPK_Report__c>(); 
        FAB__c fab1 = ClsNewCPKReportTest.createFab('FAB 2', true, true);
        fablist.add(fab1);
        FAB__c fab2 = ClsNewCPKReportTest.createFab('FAB 3', true, true);
        fablist.add(fab2);
        FAB__c fab3 = ClsNewCPKReportTest.createFab('FAB 5', true, true);
        fablist.add(fab3);
        FAB__c fab4 = ClsNewCPKReportTest.createFab('FAB 6', true, true);
        fablist.add(fab4);
       
        insert fablist;
        
        CPK_Report__c cpkReport1 = ClsNewCPKReportTest.createCPKReport('28LPS', '0.028UM', System.Today() + 1, fab1.Id, 'Monthly',userInfo.getUserId(), '10');
        cpkReport1.Stage__c = 'Approved';
        cpkReport1.OpenTextId__c = '111111';
        cpkReport1.Active__c = true;
        cpkReportlist.add(cpkReport1);
        CPK_Report__c cpkReport2 = ClsNewCPKReportTest.createCPKReport('BCDlite', '0.11UM', System.Today() - 1, fab2.Id, 'Bi-Monthly',userInfo.getUserId(), '7');
        cpkReport2.Stage__c = 'Approved';
        cpkReport2.OpenTextId__c = '222222';
        cpkReport2.Active__c = true;
        cpkReportlist.add(cpkReport2);
        CPK_Report__c cpkReport3 = ClsNewCPKReportTest.createCPKReport('GREEN', '0.25UM', System.Today() - 2, fab3.Id, 'Quarterly',userInfo.getUserId(), '8');
        cpkReport3.Stage__c = 'Approved';
        cpkReport3.OpenTextId__c = '333333';
        cpkReport3.Active__c = true;
        cpkReportlist.add(cpkReport3);
        CPK_Report__c cpkReport4 = ClsNewCPKReportTest.createCPKReport('LP', '0.032UM', System.Today() - 4, fab4.Id, 'Half yearly',userInfo.getUserId(), '9');
        cpkReport4.Stage__c = 'Approved';
        cpkReport4.OpenTextId__c = '444444';
        cpkReport4.Active__c = true;
        cpkReportlist.add(cpkReport4);
        
        insert cpkReportlist;
        
        List<Environment_Variable__c> envList = new List<Environment_Variable__c>();
        envList.add(QS_TestUtil.createENVariable('Quality Endpoint URl', 'Test Create Folder Service'));
        envList.add(QS_TestUtil.createENVariable('CPKReportCycleDay', '10'));
        insert envList;
        
        Test.startTest();
        System.schedule('ScheduleApexClassTest', CRON_EXP, new ScheduledcpkReportFolderCreation());
        Test.stopTest();        
    }
    
    //Test Method to test NoCPKReportforMonthController Class
    static testMethod void testNoCPKReportforMonthController(){
        FAB__c fab = ClsNewCPKReportTest.createFab('FAB 2', true, true);
        insert fab;
        CPK_Report__c cpkReport = ClsNewCPKReportTest.createCPKReport('28LPS', '0.028UM', System.Today() + 5, fab.Id, 'Monthly',userInfo.getUserId(), '10');
        cpkReport.Stage__c = 'Approved';
        cpkReport.OpenTextId__c = '111111';
        cpkReport.Active__c = true;
        insert cpkReport;
        
        Monthly_CPK_Report__c monthlycpkReport = ClsNewCPKReportTest.createMonthlyCPKReport('Test', 'Approved', cpkReport.Id);
        monthlycpkReport.OpenTextId__c = '1111111';
        monthlycpkReport.Reason_for_No_Reports__c ='No WIP';
        insert monthlycpkReport;
        
        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.standardController(monthlycpkReport);
        NoCPKReportforMonthController noReportforMonth = new NoCPKReportforMonthController(sc);
        noReportforMonth.saveReport();
        Test.stopTest();
    }
}