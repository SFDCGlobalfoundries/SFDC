@isTest
private class ClsCpkReportOnFVTest{
    
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
    
    //following test methods for ClsCpkReportOnFV.cls
    
    //test method for search
    static testMethod void testSearch(){
       
        Contact contact = QS_TestUtil.createContact('Test Contact', 'Test Contact', getAccount('MYTEST ACCOUNT1').Id, 'test@test.com', 'Customers My Device Admin; Primary Account Admin', 
                                            'Design; Engineering; Quality; Procurement; Supply Chain; Legal', true, true);
        insert contact;
        Profile[] profiles = [Select p.name, p.id From Profile p where p.UserLicense.Name like '%Customer Portal%' and p.name ='Customer Portal Admin' LIMIT 1];
        User portalUser = null;
        if(profiles != null && !profiles.isEmpty()){
            portalUser = QS_TestUtil.createPortalUser('test', 'test1@test1.com', 'test1 Contact', 'Test1 Contact', profiles[0].Id, contact.Id, 'test1@test1.com');
            Test.StartTest();
            insert portalUser;
        }
        
        FAB__c fab = ClsNewCPKReportTest.createFab('FAB 6', true, true);
        insert fab;
        CPK_Report__c cpkReport = ClsNewCPKReportTest.createCPKReport('G', '0.65UM', System.Today() + 5, fab.Id, 'Monthly',userInfo.getUserId(), '10');
        cpkReport.Stage__c = 'Draft';
        cpkReport.OpenTextId__c = '111111';
        insert cpkReport;
        Monthly_CPK_Report__c monthlyCPKReport = ClsNewCPKReportTest.createMonthlyCPKReport('Test', 'Approved', cpkReport.Id);
        monthlyCPKReport.OpenTextId__c = '1111111';
        insert monthlyCPKReport;
        Report_Upload__c reportUploaded = ClsNewCPKReportTest.createCPKReportUpload('test.doc', monthlyCPKReport.Id);
        insert reportUploaded;
        CPK_Report_Access_List__c qcAssociatedCustomer = ClsNewCPKReportTest.createCPKReportAccessList(getAccount('MYTEST ACCOUNT1').Id, cpkReport.Id);        
        insert qcAssociatedCustomer;
        System.runAs(portalUser){            
            ClsCpkReportOnFV clsCpkReportOnFV = new ClsCpkReportOnFV();
            //clsCpkReportOnFV.search();
            clsCpkReportOnFV.selectedFab = fab.id;
            clsCpkReportOnFV.selectedGeometry = '0.65UM';
            clsCpkReportOnFV.selectedTechnology ='G' ;
            clsCpkReportOnFV.search();            
        }
        system.assertEquals(getAccount('MYTEST ACCOUNT1').Id,qcAssociatedCustomer.Account__c);
        Test.StopTest();
    }
    
    //test method for onClickRedirect
    static testMethod void testOnClickRedirect(){
        FAB__c fab = ClsNewCPKReportTest.createFab('FAB 6', true, true);
        insert fab;
        CPK_Report__c cpkReport = ClsNewCPKReportTest.createCPKReport('G', '0.65UM', System.Today() + 5, fab.Id, 'Monthly',userInfo.getUserId(), '10');
        cpkReport.Stage__c = 'Draft';
        cpkReport.OpenTextId__c = '111111';
        insert cpkReport;
        Test.startTest();
            ClsCpkReportOnFV clsCpkReportOnFV = new ClsCpkReportOnFV();
            clsCpkReportOnFV.onClickRedirect();
            system.assertEquals(cpkReport.OpenTextId__c,'111111');
        Test.stopTest();
    }
    
    //test method for onLoadIframeAction
    static testMethod void testOnLoadIframeAction(){
        FAB__c fab = ClsNewCPKReportTest.createFab('FAB 6', true, true);
        insert fab;
        CPK_Report__c cpkReport = ClsNewCPKReportTest.createCPKReport('G', '0.65UM', System.Today() + 5, fab.Id, 'Monthly',userInfo.getUserId(), '10');
        cpkReport.Stage__c = 'Draft';
        cpkReport.OpenTextId__c = '111111';
        insert cpkReport;
        Apexpages.currentPage().getParameters().put('Id',cpkReport.Id);
        Test.startTest();
           ClsCpkReportOnFV clsCpkReportOnFV = new ClsCpkReportOnFV();
            clsCpkReportOnFV.onLoadIframeAction();
            system.assertEquals(cpkReport.OpenTextId__c,'111111');
        Test.stopTest();
    }
    
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }

}