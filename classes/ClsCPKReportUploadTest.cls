@isTest
private class ClsCPKReportUploadTest{
    
    //following test methods for ClsCPKReportUpload.cls
    
    //test method for doSave method
    static testMethod void testDoSave(){
        FAB__c fab = ClsNewCPKReportTest.createFab('FAB 6', true, true);
        insert fab;
        CPK_Report__c cpkReport = ClsNewCPKReportTest.createCPKReport('28LPS', '0.028UM', System.Today() + 5, fab.Id, 'Half yearly',userInfo.getUserId(), '10');
        cpkReport.Stage__c = 'Draft';
        cpkReport.OpenTextId__c = '111111';
        insert cpkReport;
        Monthly_CPK_Report__c monthlyCPKReport = ClsNewCPKReportTest.createMonthlyCPKReport('Test', 'Approved', cpkReport.Id);
        monthlyCPKReport.OpenTextId__c = '1111111';
        insert monthlyCPKReport;
        Report_Upload__c reportUploaded = ClsNewCPKReportTest.createCPKReportUpload('test.doc', monthlyCPKReport.Id);
        Apexpages.StandardController stdController = new Apexpages.StandardController(reportUploaded);
        ClsCPKReportUpload clsCPKReportUpload = new ClsCPKReportUpload(stdController);
        Test.startTest();
        clsCPKReportUpload.doSave();
        Test.stopTest();
    }
    
    //test method for doCancel method
    static testMethod void testDoCancel(){
        FAB__c fab = ClsNewCPKReportTest.createFab('FAB 6', true, true);
        insert fab;
        CPK_Report__c cpkReport = ClsNewCPKReportTest.createCPKReport('28LPS', '0.028UM', System.Today() + 5, fab.Id, 'Half yearly',userInfo.getUserId(), '10');
        cpkReport.Stage__c = 'Draft';
        cpkReport.OpenTextId__c = '111111';
        insert cpkReport;
        Monthly_CPK_Report__c monthlyCPKReport = ClsNewCPKReportTest.createMonthlyCPKReport('Test', 'Approved', cpkReport.Id);
        monthlyCPKReport.OpenTextId__c = '1111111';
        insert monthlyCPKReport;
        Report_Upload__c reportUploaded = ClsNewCPKReportTest.createCPKReportUpload('test.doc', monthlyCPKReport.Id);
        Apexpages.StandardController stdController = new Apexpages.StandardController(reportUploaded);
        ClsCPKReportUpload clsCPKReportUpload = new ClsCPKReportUpload(stdController);
        Test.startTest();
        clsCPKReportUpload.doCancel();
        Test.stopTest();
    }
}