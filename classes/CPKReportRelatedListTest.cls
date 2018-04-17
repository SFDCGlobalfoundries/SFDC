@isTest
private class CPKReportRelatedListTest{
    
    //DBiswal 02262015
    Public static List<Environment_Variable__c> envInsert(){
        List<Environment_Variable__c> envList = new List<Environment_Variable__c>();
        envList.add(QS_TestUtil.createENVariable('Quality Endpoint URl', 'Test Create Folder Service'));
        envList.add(QS_TestUtil.createENVariable('CPKReportCycleDay', '10'));
        insert envList;
        return envList;
    }
    //following test methods for CPKReportRelatedList.cls
    
    //test method for DateCalculation (Report Cylce equals Monthly)
    static testMethod void testDateCalculation1(){
        FAB__c fab = ClsNewCPKReportTest.createFab('FAB 6', true, true);
        insert fab;
        CPK_Report__c cpkReport = ClsNewCPKReportTest.createCPKReport('28LPS', '0.028UM', System.Today() + 5, fab.Id, 'Monthly',userInfo.getUserId(), '10');
        cpkReport.Stage__c = 'Draft';
        cpkReport.OpenTextId__c = '111111';
        insert cpkReport;
        Apexpages.currentPage().getParameters().put('Id', cpkReport.Id);
        Apexpages.StandardController stdController = new Apexpages.StandardController(cpkReport);
        CPKReportRelatedList cpkReportRelatedList = new CPKReportRelatedList(stdController);
        Test.startTest();
        cpkReportRelatedList.getRenderNewButton();
        cpkReportRelatedList.cpkReportins.Reminder__c = System.today();
        cpkReportRelatedList.getRenderNewButton();
        Test.stopTest();
    }
    
    //test method for DateCalculation (Report Cylce equals Bi-Monthly)
    static testMethod void testDateCalculation2(){
        FAB__c fab = ClsNewCPKReportTest.createFab('FAB 6', true, true);
        insert fab;
        CPK_Report__c cpkReport = ClsNewCPKReportTest.createCPKReport('28LPS', '0.028UM', System.Today() + 5, fab.Id, 'Bi-Monthly',userInfo.getUserId(), '10');
        cpkReport.Stage__c = 'Draft';
        insert cpkReport;
        Apexpages.currentPage().getParameters().put('Id', cpkReport.Id);
        Apexpages.StandardController stdController = new Apexpages.StandardController(cpkReport);
        CPKReportRelatedList cpkReportRelatedList = new CPKReportRelatedList(stdController);
        Test.startTest();
        cpkReportRelatedList.DateCalculation();
        cpkReportRelatedList.cpkReportins.Reminder__c = System.today();
        cpkReportRelatedList.DateCalculation();
        Test.stopTest();
    }
    
    //test method for DateCalculation (Report Cylce equals Quarterly)
    static testMethod void testDateCalculation3(){
        FAB__c fab = ClsNewCPKReportTest.createFab('FAB 6', true, true);
        insert fab;
        CPK_Report__c cpkReport = ClsNewCPKReportTest.createCPKReport('28LPS', '0.028UM', System.Today() + 5, fab.Id, 'Quarterly',userInfo.getUserId(), '10');
        cpkReport.Stage__c = 'Draft';
        insert cpkReport;
        Apexpages.currentPage().getParameters().put('Id', cpkReport.Id);
        Apexpages.StandardController stdController = new Apexpages.StandardController(cpkReport);
        CPKReportRelatedList cpkReportRelatedList = new CPKReportRelatedList(stdController);
        Test.startTest();
        cpkReportRelatedList.DateCalculation();
        cpkReportRelatedList.cpkReportins.Reminder__c = System.today();
        cpkReportRelatedList.DateCalculation();
        Test.stopTest();
    }
    
    //test method for DateCalculation (Report Cylce equals Half yearly)
    static testMethod void testDateCalculation4(){
        FAB__c fab = ClsNewCPKReportTest.createFab('FAB 6', true, true);
        insert fab;
        CPK_Report__c cpkReport = ClsNewCPKReportTest.createCPKReport('28LPS', '0.028UM', System.Today() + 5, fab.Id, 'Half yearly',userInfo.getUserId(), '10');
        cpkReport.Stage__c = 'Draft';
        insert cpkReport;
        Apexpages.currentPage().getParameters().put('Id', cpkReport.Id);
        Apexpages.StandardController stdController = new Apexpages.StandardController(cpkReport);
        CPKReportRelatedList cpkReportRelatedList = new CPKReportRelatedList(stdController);
        Test.startTest();
        cpkReportRelatedList.DateCalculation();
        cpkReportRelatedList.cpkReportins.Reminder__c = System.today();
        cpkReportRelatedList.DateCalculation();
        Test.stopTest();
    }
    
    
    //test method for getRenderTable
    static testMethod void testGetRenderTable1(){
        FAB__c fab = ClsNewCPKReportTest.createFab('FAB 6', true, true);
        insert fab;
        CPK_Report__c cpkReport = ClsNewCPKReportTest.createCPKReport('28LPS', '0.028UM', System.Today() + 5, fab.Id, 'Half yearly',userInfo.getUserId(), '10');
        cpkReport.Stage__c = 'Draft';
        insert cpkReport;
        Apexpages.currentPage().getParameters().put('Id', cpkReport.Id);
        Apexpages.StandardController stdController = new Apexpages.StandardController(cpkReport);
        CPKReportRelatedList cpkReportRelatedList = new CPKReportRelatedList(stdController);
        Test.startTest();
        cpkReportRelatedList.getRenderTable();
        Test.stopTest();
    }
    
    //test method for getRenderTable
    static testMethod void testGetRenderTable2(){
        CPKReportRelatedListTest.envInsert();
        FAB__c fab = ClsNewCPKReportTest.createFab('FAB 6', true, true);
        insert fab;
        CPK_Report__c cpkReport = ClsNewCPKReportTest.createCPKReport('28LPS', '0.028UM', System.Today() + 5, fab.Id, 'Half yearly',userInfo.getUserId(), '10');
        cpkReport.Stage__c = 'Draft';
        insert cpkReport;
        Monthly_CPK_Report__c monthlyCPKReport = ClsNewCPKReportTest.createMonthlyCPKReport('Test', 'Approved', cpkReport.Id);
        insert monthlyCPKReport;
        Apexpages.currentPage().getParameters().put('Id', cpkReport.Id);
        Apexpages.StandardController stdController = new Apexpages.StandardController(cpkReport);
        CPKReportRelatedList cpkReportRelatedList = new CPKReportRelatedList(stdController);
        Test.startTest();
        cpkReportRelatedList.getRenderTable();
        Test.stopTest();
    }
    
    //test method for NewReport method
    static testMethod void testNewReport(){
        CPKReportRelatedListTest.envInsert();
        FAB__c fab = ClsNewCPKReportTest.createFab('FAB 6', true, true);
        insert fab;
        CPK_Report__c cpkReport = ClsNewCPKReportTest.createCPKReport('28LPS', '0.028UM', System.Today() + 5, fab.Id, 'Half yearly',userInfo.getUserId(), '10');
        cpkReport.Stage__c = 'Draft';
        insert cpkReport;
        Apexpages.currentPage().getParameters().put('Id', cpkReport.Id);
        Apexpages.StandardController stdController = new Apexpages.StandardController(cpkReport);
        CPKReportRelatedList cpkReportRelatedList = new CPKReportRelatedList(stdController);
        CPKReportRelatedList.recordName = 'M';
        CPKReportRelatedList.noreptm = true;
        Test.startTest();
        CPKReportRelatedList.NewReport();
        Test.stopTest();
    }
    
    //test method for createFolder 
    static testMethod void testCreateFolder(){
        /*List<Environment_Variable__c> envList = new List<Environment_Variable__c>();
        envList.add(QS_TestUtil.createENVariable('Quality Endpoint URl', 'Test Create Folder Service'));
        envList.add(QS_TestUtil.createENVariable('CPKReportCycleDay', '10'));
        insert envList;*/
        CPKReportRelatedListTest.envInsert();
        FAB__c fab = ClsNewCPKReportTest.createFab('FAB 6', true, true);
        insert fab;
        CPK_Report__c cpkReport = ClsNewCPKReportTest.createCPKReport('28LPS', '0.028UM', System.Today() + 5, fab.Id, 'Half yearly',userInfo.getUserId(), '10');
        cpkReport.Stage__c = 'Draft';
        cpkReport.OpenTextId__c = '111111';
        insert cpkReport;
        Monthly_CPK_Report__c monthlyCPKReport = ClsNewCPKReportTest.createMonthlyCPKReport('Test', 'Approved', cpkReport.Id);
        insert monthlyCPKReport;
        Apexpages.currentPage().getParameters().put('Id', cpkReport.Id);
        Apexpages.StandardController stdController = new Apexpages.StandardController(cpkReport);
        //CPKReportRelatedList cpkReportRelatedList = new CPKReportRelatedList(stdController);
        //cpkReportRelatedList.SubfolderId = monthlyCPKReport.Id;
        Test.startTest();
        CPKReportRelatedList.Createfolder(monthlyCPKReport.Id);
        Test.stopTest();
    }
    
    //test method for deleteRecord
    static testMethod void testDeleteRecord(){
        FAB__c fab = ClsNewCPKReportTest.createFab('FAB 6', true, true);
        insert fab;
        CPK_Report__c cpkReport = ClsNewCPKReportTest.createCPKReport('28LPS', '0.028UM', System.Today() + 5, fab.Id, 'Half yearly',userInfo.getUserId(), '10');
        cpkReport.Stage__c = 'Draft';
        cpkReport.OpenTextId__c = '111111';
        insert cpkReport;
        Monthly_CPK_Report__c monthlyCPKReport = ClsNewCPKReportTest.createMonthlyCPKReport('Test', 'Approved', cpkReport.Id);
        monthlyCPKReport.OpenTextId__c = '1111111';
        insert monthlyCPKReport;
        Apexpages.currentPage().getParameters().put('Id', cpkReport.Id);
        Apexpages.StandardController stdController = new Apexpages.StandardController(cpkReport);
        CPKReportRelatedList cpkReportRelatedList = new CPKReportRelatedList(stdController);
        Test.startTest();
        cpkReportRelatedList.deleteRecord();
        Test.stopTest();
    }
    
    //testMethod for empty method
    static testMethod void testEmpty(){
        FAB__c fab = ClsNewCPKReportTest.createFab('FAB 6', true, true);
        insert fab;
        CPK_Report__c cpkReport = ClsNewCPKReportTest.createCPKReport('28LPS', '0.028UM', System.Today() + 5, fab.Id, 'Half yearly',userInfo.getUserId(), '10');
        cpkReport.Stage__c = 'Draft';
        cpkReport.OpenTextId__c = '111111';
        insert cpkReport;
        Apexpages.currentPage().getParameters().put('Id', cpkReport.Id);
        Apexpages.StandardController stdController = new Apexpages.StandardController(cpkReport);
        CPKReportRelatedList cpkReportRelatedList = new CPKReportRelatedList(stdController);
        Test.startTest();
        cpkReportRelatedList.empty();
        Test.stopTest();
    }
    
 }