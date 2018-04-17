@isTest
private class ClsUpdateCPKReportOnReportUploadTest{
    
    //DBiswal 02262015
    Public static List<Environment_Variable__c> envInsert(){
        List<Environment_Variable__c> envList = new List<Environment_Variable__c>();
        envList.add(QS_TestUtil.createENVariable('Quality Endpoint URl', 'Test Create Folder Service'));
        envList.add(QS_TestUtil.createENVariable('CPKReportCycleDay', '10'));
        insert envList;
        return envList;
    }
    
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
    
    //test method for UpdateReportDueDate (Report Cycle = Monthly)
    static testMethod void testUpdateReportDueDate1(){
        ClsUpdateCPKReportOnReportUploadTest.envInsert();
        FAB__c fab = ClsNewCPKReportTest.createFab('FAB 6', true, true);
        insert fab;
        CPK_Report__c cpkReport = ClsNewCPKReportTest.createCPKReport('28LPS', '0.028UM', System.Today() + 5, fab.Id, 'Monthly',userInfo.getUserId(), '10');
        cpkReport.Stage__c = 'Draft';
        cpkReport.OpenTextId__c = '111111';
        insert cpkReport;
        Monthly_CPK_Report__c monthlyCPKrecord = ClsNewCPKReportTest.createMonthlyCPKReport('TestReport','Draft',cpkReport.Id);
        monthlyCPKrecord.Report_Due_Date__c = cpkReport.Reminder__c;
        insert monthlyCPKrecord;
        Test.startTest();
        ClsUpdateCPKReportOnReportUpload.UpdateReportDueDate(cpkReport,monthlyCPKrecord);
        Test.stopTest();
    }
   
    //test method for UpdateReportDueDate (Report Cycle = Bi-Monthly)
    static testMethod void testUpdateReportDueDate2(){
        ClsUpdateCPKReportOnReportUploadTest.envInsert();
        FAB__c fab = ClsNewCPKReportTest.createFab('FAB 6', true, true);
        insert fab;
        CPK_Report__c cpkReport = ClsNewCPKReportTest.createCPKReport('28LPS', '0.028UM', System.Today() + 5, fab.Id, 'Bi-Monthly',userInfo.getUserId(), '10');
        cpkReport.Stage__c = 'Draft';
        cpkReport.OpenTextId__c = '111111';
        insert cpkReport;
        Monthly_CPK_Report__c monthlyCPKrecord = ClsNewCPKReportTest.createMonthlyCPKReport('TestReport','Draft',cpkReport.Id);
        monthlyCPKrecord.Report_Due_Date__c = cpkReport.Reminder__c;
        insert monthlyCPKrecord;
        Test.startTest();
        ClsUpdateCPKReportOnReportUpload.UpdateReportDueDate(cpkReport,monthlyCPKrecord);
        Test.stopTest();
    }
    
    //test method for UpdateReportDueDate (Report Cycle = Quarterly)
    static testMethod void testUpdateReportDueDate3(){
        ClsUpdateCPKReportOnReportUploadTest.envInsert();
        FAB__c fab = ClsNewCPKReportTest.createFab('FAB 6', true, true);
        insert fab;
        CPK_Report__c cpkReport = ClsNewCPKReportTest.createCPKReport('28LPS', '0.028UM', System.Today() + 5, fab.Id, 'Quarterly',userInfo.getUserId(), '10');
        cpkReport.Stage__c = 'Draft';
        cpkReport.OpenTextId__c = '111111';
        insert cpkReport;
        Monthly_CPK_Report__c monthlyCPKrecord = ClsNewCPKReportTest.createMonthlyCPKReport('TestReport','Draft',cpkReport.Id);
        monthlyCPKrecord.Report_Due_Date__c = cpkReport.Reminder__c;
        insert monthlyCPKrecord;
        Test.startTest();
        ClsUpdateCPKReportOnReportUpload.UpdateReportDueDate(cpkReport,monthlyCPKrecord);
        Test.stopTest();
    }
    
    //test method for UpdateReportDueDate (Report Cycle = Half yearly)
    static testMethod void testUpdateReportDueDate4(){
        ClsUpdateCPKReportOnReportUploadTest.envInsert();
        FAB__c fab = ClsNewCPKReportTest.createFab('FAB 6', true, true);
        insert fab;
        CPK_Report__c cpkReport = ClsNewCPKReportTest.createCPKReport('28LPS', '0.028UM', System.Today() + 5, fab.Id, 'Half yearly',userInfo.getUserId(), '10');
        cpkReport.Stage__c = 'Draft';
        cpkReport.OpenTextId__c = '111111';
        insert cpkReport;
        Monthly_CPK_Report__c monthlyCPKrecord = ClsNewCPKReportTest.createMonthlyCPKReport('TestReport','Draft',cpkReport.Id);
        monthlyCPKrecord.Report_Due_Date__c = cpkReport.Reminder__c;
        insert monthlyCPKrecord;
        Test.startTest();
        ClsUpdateCPKReportOnReportUpload.UpdateReportDueDate(cpkReport,monthlyCPKrecord);
        Test.stopTest();
    }
    
    //test method for updateCpkDateAfterReportApproval
    static testMethod void testUpdateCpkDateAfterReportApproval(){
        ClsUpdateCPKReportOnReportUploadTest.envInsert();
        FAB__c fab = ClsNewCPKReportTest.createFab('FAB 6', true, true);
        insert fab;
        CPK_Report__c cpkReport = ClsNewCPKReportTest.createCPKReport('28LPS', '0.028UM', System.Today() + 5, fab.Id, 'Half yearly',userInfo.getUserId(), '10');
        cpkReport.Stage__c = 'Draft';
        cpkReport.OpenTextId__c = '111111';
        insert cpkReport;
        Monthly_CPK_Report__c monthlyCPKrecord = ClsNewCPKReportTest.createMonthlyCPKReport('TestReport','Draft',cpkReport.Id);
        insert monthlyCPKrecord;
        Test.startTest();
        ClsUpdateCPKReportOnReportUpload.updateCpkDateAfterReportApproval(monthlyCPKrecord);
        Test.stopTest();
    }
    
    //test method for CreateDeleteObject
    static testMethod void testCreateDeleteObject(){
        FAB__c fab = ClsNewCPKReportTest.createFab('FAB 6', true, true);
        insert fab;
        CPK_Report__c cpkReport = ClsNewCPKReportTest.createCPKReport('28LPS', '0.028UM', System.Today() + 5, fab.Id, 'Half yearly',userInfo.getUserId(), '10');
        cpkReport.Stage__c = 'Draft';
        cpkReport.OpenTextId__c = '111111';
        insert cpkReport;
        Test.startTest();
        Map<String,String> CPKIDOpenTextIdMap = new Map<String,String>{cpkReport.Id =>'123456'}; 
        ClsUpdateCPKReportOnReportUpload.CreateDeleteObject(CPKIDOpenTextIdMap);
        Test.stopTest();
    }
    
    //test method for AfterTriggerInsert
    static testMethod void AfterTriggerInsert(){
        ClsUpdateCPKReportOnReportUploadTest.envInsert();
        FAB__c fab = ClsNewCPKReportTest.createFab('FAB 3', true, true);
        insert fab;
        CPK_Report__c cpkReport = ClsNewCPKReportTest.createCPKReport('28LPS', '0.028UM', System.Today() + 4, fab.Id, 'Monthly',userInfo.getUserId(), '10');
        cpkReport.Stage__c = 'Draft';
        cpkReport.OpenTextId__c = '111111';
        insert cpkReport;
        Monthly_CPK_Report__c monthlyCPKrecord = ClsNewCPKReportTest.createMonthlyCPKReport('TestReport1','Draft',cpkReport.Id);
        insert monthlyCPKrecord;
        Report_Upload__c reportupload = new Report_Upload__c();
        reportupload.File_Name__c = 'TestAttach';
        reportupload.Monthly_CPK_Report__c = monthlyCPKrecord.Id;
        insert reportupload;
        Test.startTest();
        List<Report_Upload__c> reportUploadedList = new List<Report_Upload__c>{reportupload}; 
        ClsUpdateCPKReportOnReportUpload.AfterTriggerInsert(reportUploadedList);
        Test.stopTest();
    }
    
    /*
    //test method for UpdateAccessList old
    static testMethod void testUpdateAccessListOld(){
        ClsNewCPKReportTest.setupData();
        FAB__c fab = ClsNewCPKReportTest.createFab('FAB 6', true, true);
        insert fab;
        CPK_Report__c cpkReport = ClsNewCPKReportTest.createCPKReport('28LPS', '0.028UM', System.Today() + 5, fab.Id, 'Monthly',userInfo.getUserId(), '10');
        cpkReport.Stage__c = 'Draft';
        insert cpkReport;
        CPK_Report_Access_List__c cpkReportAccessList = ClsNewCPKReportTest.createCPKReportAccessList(ClsNewCPKReportTest.account1.Id, cpkReport.Id);
        insert cpkReportAccessList;
        cpkReportAccessList = [Select Id, Account__c, FAB__c, CPK_Report__c From CPK_Report_Access_List__c where Id =: cpkReportAccessList.Id Limit 1];
        List<Id> userIdList = new List<Id>{UserInfo.getUserId(),UserInfo.getUserId(),UserInfo.getUserId(),UserInfo.getUserId(),UserInfo.getUserId()};
        Map<ID,List<ID>> accTeamProxyMap = new Map<ID,List<ID>>{ClsNewCPKReportTest.account1.Id => userIdList};
        Map<ID,String>  accTeamProxyFabMap = new Map<ID,String>{ClsNewCPKReportTest.account1.Id => 'FAB 6'};
        Test.startTest();
        ClsUpdateCPKReportOnReportUpload.UpdateAccessList(cpkReportAccessList, accTeamProxyMap, accTeamProxyFabMap);
        Test.stopTest();    
    }
    */
    
    //test method for UpdateAccessList
    static testMethod void testUpdateAccessList(){
       
        FAB__c fab = ClsNewCPKReportTest.createFab('FAB 6', true, true);
        insert fab;
        CPK_Report__c cpkReport = ClsNewCPKReportTest.createCPKReport('28LPS', '0.028UM', System.Today() + 5, fab.Id, 'Monthly',userInfo.getUserId(), '10');
        cpkReport.Stage__c = 'Draft';
        insert cpkReport;
        CPK_Report_Access_List__c cpkReportAccessList = ClsNewCPKReportTest.createCPKReportAccessList(getAccount('MYTEST ACCOUNT1').Id, cpkReport.Id);
        insert cpkReportAccessList;
        cpkReportAccessList = [Select Id, Account__c, FAB__c, CPK_Report__c From CPK_Report_Access_List__c where Id =: cpkReportAccessList.Id Limit 1];
        User testUser = new User(Id = UserInfo.getUserId(), Fab_Assigned__c = 'FAB 6');
        List<Account_Team_Proxy__c> lstATP = new List<Account_Team_Proxy__c>();
        Map<String, List<Account_Team_Proxy__c>> accountTeamProxyListMap = new Map<String, List<Account_Team_Proxy__c>>();
        Account_Team_Proxy__c atp = createAccountTeamProxy(cpkReportAccessList.Account__c,testUser.Id,'Customer Engineer');
        atp.User__r = testUser;
        lstAtp.add(atp);
        lstAtp.add(atp);
        lstAtp.add(atp);
        lstAtp.add(atp);
        lstAtp.add(atp);
        lstAtp.add(atp);
        accountTeamProxyListMap.put(cpkReportAccessList.Account__c,lstAtp);
        Test.startTest();
        ClsUpdateCPKReportOnReportUpload.UpdateAccessList(cpkReportAccessList, accountTeamProxyListMap );
        Test.stopTest();    
    }
    
    static Account_Team_Proxy__c createAccountTeamProxy(String AccountId,String UserId,string Role){
        Account_Team_Proxy__c atp = new Account_Team_Proxy__c(User__c = UserId,Sequence_No__c='1',
                                                              Account_Role_ID__c='test',Account__c=AccountId ,Account_Access__c='Read/Write',
                                                              Opportunity_Access__c='Read/Write',Team_Role__c=Role,
                                                              fab_assignment__c = 'FAB 6');
       
        
        return atp;
    }
    
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
}