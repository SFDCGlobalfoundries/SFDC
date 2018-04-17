@isTest
private class ClsEditCPKReportTest{
    
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        
        List<Map<String,Object>> fieldValueMapList = new List<Map<String,Object>>();
        for(integer i=1;i<=2;i++){
            Map<String,Object> fieldValueMap = new Map<String,Object>();
            fieldValueMap.put('Name', 'MYTEST ACCOUNT'+i);            
            fieldValueMap.put('stage__c', 'Unqualified');        
            fieldValueMap.put('sub_type__c', 'Direct');
            fieldValueMap.put('site_department__c', 'test dept');          
            fieldValueMap.put('transaction_type__c', 'transactional');                          
            fieldValueMap.put('region__c', 'APJ');        
            fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
            fieldValueMap.put('Corporate_City__c', 'Test City');                
            fieldValueMap.put('Corporate_Country__c', 'Singapore');
            fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
            fieldValueMap.put('Bill_To_City__c', 'Test City');            
            fieldValueMap.put('Bill_To_Country__c', 'Singapore');        
            fieldValueMap.put('Fab_9_10__c','No');
            fieldValueMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER'));
                        
            fieldValueMapList.add(fieldValueMap);
        }
        AccountDataFactory.createAccounts(fieldValueMapList,2);
    }
    
    //following test methods for ClsEditCPKReport.cls
    
     //Test method for validiating CPK Report record
    static testMethod void testSaving1(){
        Environment_Variable__c env = QS_TestUtil.createENVariable('CPKReportCycleDay', '10');
        insert env;
        FAB__c fab = ClsNewCPKReportTest.createFab('FAB 6', true, true);
        insert fab;
        CPK_Report__c cpkReport = ClsNewCPKReportTest.createCPKReport('28LPS', '0.028UM', System.Today() + 5, fab.Id, 'Monthly',userInfo.getUserId(), null);
        cpkReport.Stage__c = 'Draft';
        insert cpkReport;
        system.assertEquals(cpkReport.Stage__c,'Draft');
        Apexpages.currentPage().getParameters().put('Id', cpkReport.Id);
        Apexpages.StandardController  stdCntrl = new ApexPages.StandardController(cpkReport);
        ClsEditCPKReport clsEditCPKReport = new ClsEditCPKReport(stdCntrl);
        clsEditCPKReport.cpkReport.Technology__c = null;
        Test.startTest();
        clsEditCPKReport.Saving();
        
        Test.stopTest();
    }
    
    
    //Test method for Positive test case 
    static testMethod void testSaving2(){
        
        Account acc = getAccount('MYTEST ACCOUNT1');

        Environment_Variable__c env = [select id,name,value__c from Environment_Variable__c where name='HCM Emp AccountId'];
        env.value__c=acc.Id;
        update env;
        Test.startTest();
        FAB__c fab = ClsNewCPKReportTest.createFab('FAB 6', true, true);
        insert fab;
        User userObj = ClsNewCPKReportTest.createUser();
        Fab_User__c fabUser = ClsNewCPKReportTest.createFabUser(fab.Id, true, userObj.Id);
        insert fabUser;
        CPK_Report__c cpkReport = ClsNewCPKReportTest.createCPKReport('28LPS', '0.028UM', System.Today() + 5, fab.Id, 'Monthly',userInfo.getUserId(), '10');
        cpkReport.Stage__c = 'Draft';
        insert cpkReport;
        system.assertEquals(cpkReport.Stage__c,'Draft');
        Apexpages.currentPage().getParameters().put('Id', cpkReport.Id);
        Apexpages.StandardController  stdCntrl = new ApexPages.StandardController(cpkReport);
        ClsEditCPKReport clsEditCPKReport = new ClsEditCPKReport(stdCntrl);
        
        clsEditCPKReport.Saving();
        Test.stopTest();
    }
    //Test method for Positive test case 
    static testMethod void testSaving3(){
        Account acc = getAccount('MYTEST ACCOUNT2');

        Environment_Variable__c env = [select id,name,value__c from Environment_Variable__c where name='HCM Emp AccountId'];
        env.value__c=acc.Id;
        update env;        
        Test.startTest();
        FAB__c fab = ClsNewCPKReportTest.createFab('FAB 6', true, true);
        insert fab;
        User userObj = ClsNewCPKReportTest.createUser();
        Fab_User__c fabUser = ClsNewCPKReportTest.createFabUser(fab.Id, true, userObj.Id);
        insert fabUser;
        CPK_Report__c cpkReport = ClsNewCPKReportTest.createCPKReport('28LPS', '0.028UM', System.Today() + 5, fab.Id, 'Monthly',userInfo.getUserId(), '10');
        cpkReport.Stage__c = 'Draft';
        insert cpkReport;
        system.assertEquals(cpkReport.Stage__c,'Draft');
       
        Apexpages.currentPage().getParameters().put('Id', cpkReport.Id);
        Apexpages.StandardController  stdCntrl = new ApexPages.StandardController(cpkReport);
        ClsEditCPKReport clsEditCPKReport = new ClsEditCPKReport(stdCntrl);
        
        clsEditCPKReport.Saving();
        Test.stopTest();
    }
    
    //Test method for sectionAccessToQA mehthod
    static testMethod void testSectionAccessToQA(){
        
        FAB__c fab = ClsNewCPKReportTest.createFab('FAB 6', true, true);
        insert fab;
        CPK_Report__c cpkReport = ClsNewCPKReportTest.createCPKReport('28LPS', '0.028UM', System.Today() + 5, fab.Id, 'Monthly',userInfo.getUserId(), '10');
        cpkReport.Stage__c = 'Approved';
        insert cpkReport;
        system.assertEquals(cpkReport.Stage__c,'Approved');
        cpkReport.QA_Approver__c=userInfo.getUserId();
        update cpkReport;
        Apexpages.currentPage().getParameters().put('Id', cpkReport.Id);
        Apexpages.StandardController  stdCntrl = new ApexPages.StandardController(cpkReport);
        ClsEditCPKReport clsEditCPKReport = new ClsEditCPKReport(stdCntrl);
        Test.startTest();
        clsEditCPKReport.sectionAccessToQA();
        Test.stopTest();
    }
    
    //Test method for CPK_Report__c OnAfterDelete mehthod
    static testMethod void testOnAfterDelete(){
        
        FAB__c fab = ClsNewCPKReportTest.createFab('FAB 6', true, true);
        insert fab;
        CPK_Report__c cpkReport = ClsNewCPKReportTest.createCPKReport('28LPS', '0.028UM', System.Today() + 5, fab.Id, 'Monthly',userInfo.getUserId(), '10');
        cpkReport.Stage__c = 'Draft';
        insert cpkReport;
        system.assertEquals(cpkReport.Stage__c,'Draft');
        Test.startTest();
            delete cpkReport;
        Test.stopTest();
    }
    
    //Test method for OnBeforerUpdate mehthod -- changing the Fab assigned
    static testMethod void testOnBeforerUpdate(){
        
        FAB__c fab = ClsNewCPKReportTest.createFab('FAB 6', true, true);
        insert fab;
        FAB__c fab2 = ClsNewCPKReportTest.createFab('FAB 2', true, true);
        insert fab2;
        CPK_Report__c cpkReport = ClsNewCPKReportTest.createCPKReport('28LPS', '0.028UM', System.Today() + 5, fab.Id, 'Monthly',userInfo.getUserId(), '10');
        cpkReport.Stage__c = 'Draft';
        insert cpkReport;
        system.assertEquals(cpkReport.Stage__c,'Draft');
        Test.startTest();
            cpkReport.Fabs__c = fab2.Id;
            QS_CPKReportTriggerHandler.isExecuted = false;
            update cpkReport;
        Test.stopTest();
    }
    
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
}