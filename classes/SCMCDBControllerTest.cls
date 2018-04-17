/*
    Author: Zymark Ambat
    Description: This serves as the Test Class for SCMCDBController.
    History: 
        ZAmbat      09122014    - Code creation.
*/

@isTest(SeeAllData=false)
public class SCMCDBControllerTest {

 @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        User thisUser = [select Id from User where Profile.Name ='GF Sales User' and isActive = true and UserRoleId != null limit 1];
         List<Map<String,Object>>  fieldValueMapList = new List<Map<String,Object>>();
        for(integer i=1;i<=3;i++){
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
            fieldValueMap.put('Fab_9_10__c','no');
            fieldValueMap.put('ownerId',thisUser.Id);
            fieldValueMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER'));
    
            fieldValueMapList.add(fieldValueMap);
        }
        AccountDataFactory.createAccounts(fieldValueMapList,3);
    }
    static Id createAccount1() {
        // Create Account
        Account testAcct= getAccount('MYTEST ACCOUNT1');
        return testAcct.Id;
    }
    
    static Id createAccount2(Id acctId) {
        // Create Account
        Account testAcct= getAccount('MYTEST ACCOUNT2');
        return testAcct.Id;
        
     }
    
    static void createAccount3(Id acctId) {
        // Create Account
        Account testAcct= getAccount('MYTEST ACCOUNT3');
      }
    
    static void createSCMCDB(Id acctId) {
        PO_Lead_Time__c s = new PO_Lead_Time__c();
        s.Account__c = acctId;
        s.Base_Device__c = 'test';
        s.Fab__c = 'FAB 2';
        s.Geometry__c = '0.010UM';
        s.Source_System__c = 'test';
        s.Technology__c = 'test';
        s.Standard_DPML_day_CurrQtr__c = '1';
        s.Standard_DPML_day_CurrQtr_1__c = '2';
        s.Standard_DPML_day_CurrQtr_2__c = '3';
        s.Standard_DPML_day_CurrQtr_3__c = '4';
        s.Hot_DPML_12w_day_CurrQtr__c = '1';
        s.Hot_DPML_12w_day_CurrQtr_1__c = '2';
        s.Hot_DPML_12w_day_CurrQtr_2__c = '3';
        s.Hot_DPML_12w_day_CurrQtr_3__c = '4';
        s.Hot_DPML_12w_day_CurrQtr1__c = '1';
        s.Hot_DPML_12w_day_CurrQtr_1_1__c = '1';
        s.Hot_DPML_12w_day_CurrQtr_2_1__c = '1';
        s.Hot_DPML_12w_day_CurrQtr_3_1__c = '1';
        s.Bullet_DPML_12w_day_CurrQtr__c = '1';
        s.Bullet_DPML_12w_day_CurrQtr_1__c = '1';
        s.Bullet_DPML_12w_day_CurrQtr_2__c = '1';
        s.Bullet_DPML_12w_day_CurrQtr_3__c = '1';
        s.Bullet_DPML_12w_day_CurrQtr_1__c = '1';
        s.Bullet_DPML_12w_day_CurrQtr_1_1__c = '1';
        s.Bullet_DPML_12w_day_CurrQtr_2_1__c = '1';
        s.Bullet_DPML_12w_day_CurrQtr_3_1__c = '1';
        s.PF_Adder_day__c = '5';
        s.ML_Count_FEOL_BEOL__c = '10';
        s.PO_Lead_Time_day__c = '1';
        
        insert s;
    }
    
    static testMethod void testSCMCDBController1() {
        string testAcctId = SCMCDBControllerTest.createAccount1();
        SCMCDBControllerTest.createSCMCDB(testAcctId);
        
        test.startTest();
            SCMCDBController s = new SCMCDBController();
            s.account = 'MYTEST ACCOUNT1';
            s.scmcdb.Base_Device__c = 'test';
            s.scmcdb.Fab__c = 'FAB 2';
            s.scmcdb.Geometry__c = '0.010UM';
            s.scmcdb.PO_Raise_Date__c = date.newInstance(date.today().year(), 01, 15);
            s.dpmlSelected = 'Standard';
            
            s.retrieveSCMCDB();
            List<SCMCDBController.PoLeadTimeWrapper> listSCMCDB = s.getPoLeadTimeRecords();
            s.exportCsvFile();
            s.retrieveAccountHierarchy(testAcctId);
        test.stopTest();
    }
    
    static testMethod void testSCMCDBController2() {
        string testAcctId1 = SCMCDBControllerTest.createAccount1();
        string testAcctId2 = SCMCDBControllerTest.createAccount2(testAcctId1);
        SCMCDBControllerTest.createAccount3(testAcctId2);
        SCMCDBControllerTest.createSCMCDB(testAcctId2);

        test.startTest();
            SCMCDBController s = new SCMCDBController();
            s.scmcdb.Base_Device__c = 'test';
            s.scmcdb.Fab__c = 'FAB 2';
            s.scmcdb.Geometry__c = '0.010UM';
            s.scmcdb.PO_Raise_Date__c = date.newInstance(date.today().year(), 01, 15);
            s.dpmlSelected = 'BulletLE12';
            
            s.retrieveSCMCDB();
            List<SCMCDBController.PoLeadTimeWrapper> listSCMCDB = s.getPoLeadTimeRecords();
            s.exportCsvFile();
            s.retrieveAccountHierarchy(testAcctId2);
        test.stopTest();
    }
    
    static testMethod void testSCMCDBController3() {
        string testAcctId = SCMCDBControllerTest.createAccount1();
        SCMCDBControllerTest.createSCMCDB(testAcctId);

        test.startTest();
            SCMCDBController s = new SCMCDBController();
            s.account = 'MYTEST ACCOUNT1';
            s.scmcdb.Base_Device__c = 'test';
            s.scmcdb.Fab__c = 'FAB 2';
            s.scmcdb.Geometry__c = '0.010UM';
            s.scmcdb.PO_Raise_Date__c = date.newInstance(date.today().year(), 01, 15);
            s.dpmlSelected = 'BulletG12';
            
            s.retrieveSCMCDB();
            List<SCMCDBController.PoLeadTimeWrapper> listSCMCDB = s.getPoLeadTimeRecords();
            s.exportCsvFile();
            s.clear();
        test.stopTest();
    }
    
    static testMethod void testSCMCDBController4() {
        string testAcctId = SCMCDBControllerTest.createAccount1();
        SCMCDBControllerTest.createSCMCDB(testAcctId);

        test.startTest();
            SCMCDBController s = new SCMCDBController();
            s.account = 'MYTEST ACCOUNT1';
            s.scmcdb.Base_Device__c = 'test';
            s.scmcdb.Fab__c = 'FAB 2';
            s.scmcdb.Geometry__c = '0.010UM';
            s.scmcdb.PO_Raise_Date__c = date.newInstance(date.today().year(), 01, 15);
            s.dpmlSelected = 'HotLE12';
            
            s.retrieveSCMCDB();
            List<SCMCDBController.PoLeadTimeWrapper> listSCMCDB = s.getPoLeadTimeRecords();
            s.exportCsvFile();
            s.clear();
        test.stopTest();
    }
    
    static testMethod void testSCMCDBController5() {
        string testAcctId = SCMCDBControllerTest.createAccount1();
        SCMCDBControllerTest.createSCMCDB(testAcctId);

        test.startTest();
            SCMCDBController s = new SCMCDBController();
            s.account = 'MYTEST ACCOUNT1';
            s.scmcdb.Base_Device__c = 'test';
            s.scmcdb.Fab__c = 'FAB 2';
            s.scmcdb.Geometry__c = '0.010UM';
            s.scmcdb.PO_Raise_Date__c = date.newInstance(date.today().year(), 01, 15);
            s.dpmlSelected = 'HotG12';
            
            s.retrieveSCMCDB();
            List<SCMCDBController.PoLeadTimeWrapper> listSCMCDB = s.getPoLeadTimeRecords();
            s.exportCsvFile();
            s.clear();
        test.stopTest();
    }
    
    // 2nd quarter
    static testMethod void testSCMCDBController6() {
        string testAcctId = SCMCDBControllerTest.createAccount1();
        SCMCDBControllerTest.createSCMCDB(testAcctId);

        test.startTest();
            SCMCDBController s = new SCMCDBController();
            s.account = 'MYTEST ACCOUNT1';
            s.scmcdb.Base_Device__c = 'test';
            s.scmcdb.Fab__c = 'FAB 2';
            s.scmcdb.Geometry__c = '0.010UM';
            s.scmcdb.PO_Raise_Date__c = date.newInstance(date.today().year(), 01, 15).addMonths(3);
            s.dpmlSelected = 'Standard';
            
            s.retrieveSCMCDB();
            List<SCMCDBController.PoLeadTimeWrapper> listSCMCDB = s.getPoLeadTimeRecords();
            s.processBatch();
            s.getDPMLOptions();
            s.getHasPrevious();
            s.getHasNext();
            s.previous();
            s.next();
            s.first();
            s.last();
            s.getPageNo();
            s.getTotalPages();
            s.getTotalRecords();
            s.exportCsvFile();
            s.clear();
        test.stopTest();
    }
    
    static testMethod void testSCMCDBController7() {
        string testAcctId = SCMCDBControllerTest.createAccount1();
        SCMCDBControllerTest.createSCMCDB(testAcctId);

        test.startTest();
            SCMCDBController s = new SCMCDBController();
            s.account = 'MYTEST ACCOUNT1';
            s.scmcdb.Base_Device__c = 'test';
            s.scmcdb.Fab__c = 'FAB 2';
            s.scmcdb.Geometry__c = '0.010UM';
            s.scmcdb.PO_Raise_Date__c = date.newInstance(date.today().year(), 01, 15).addMonths(3);
            s.dpmlSelected = 'BulletLE12';
            
            s.retrieveSCMCDB();
            List<SCMCDBController.PoLeadTimeWrapper> listSCMCDB = s.getPoLeadTimeRecords();
            s.exportCsvFile();
            s.clear();
        test.stopTest();
    }
    
    static testMethod void testSCMCDBController8() {
        string testAcctId = SCMCDBControllerTest.createAccount1();
        SCMCDBControllerTest.createSCMCDB(testAcctId);

        test.startTest();
            SCMCDBController s = new SCMCDBController();
            s.account = 'MYTEST ACCOUNT1';
            s.scmcdb.Base_Device__c = 'test';
            s.scmcdb.Fab__c = 'FAB 2';
            s.scmcdb.Geometry__c = '0.010UM';
            s.scmcdb.PO_Raise_Date__c = date.newInstance(date.today().year(), 01, 15).addMonths(3);
            s.dpmlSelected = 'BulletG12';
            
            s.retrieveSCMCDB();
            List<SCMCDBController.PoLeadTimeWrapper> listSCMCDB = s.getPoLeadTimeRecords();
            s.exportCsvFile();
            s.clear();
        test.stopTest();
    }
    
    static testMethod void testSCMCDBController9() {
        string testAcctId = SCMCDBControllerTest.createAccount1();
        SCMCDBControllerTest.createSCMCDB(testAcctId);

        test.startTest();
            SCMCDBController s = new SCMCDBController();
            s.account = 'MYTEST ACCOUNT1';
            s.scmcdb.Base_Device__c = 'test';
            s.scmcdb.Fab__c = 'FAB 2';
            s.scmcdb.Geometry__c = '0.010UM';
            s.scmcdb.PO_Raise_Date__c = date.newInstance(date.today().year(), 01, 15).addMonths(3);
            s.dpmlSelected = 'HotLE12';
            
            s.retrieveSCMCDB();
            List<SCMCDBController.PoLeadTimeWrapper> listSCMCDB = s.getPoLeadTimeRecords();
            s.exportCsvFile();
            s.clear();
        test.stopTest();
    }
    
    static testMethod void testSCMCDBController10() {
        string testAcctId = SCMCDBControllerTest.createAccount1();
        SCMCDBControllerTest.createSCMCDB(testAcctId);

        test.startTest();
            SCMCDBController s = new SCMCDBController();
            s.account = 'MYTEST ACCOUNT1';
            s.scmcdb.Base_Device__c = 'test';
            s.scmcdb.Fab__c = 'FAB 2';
            s.scmcdb.Geometry__c = '0.010UM';
            s.scmcdb.PO_Raise_Date__c = date.newInstance(date.today().year(), 01, 15).addMonths(3);
            s.dpmlSelected = 'HotG12';
            
            s.retrieveSCMCDB();
            List<SCMCDBController.PoLeadTimeWrapper> listSCMCDB = s.getPoLeadTimeRecords();
            s.exportCsvFile();
            s.clear();
        test.stopTest();
    }
    
    // 3rd quarter
    static testMethod void testSCMCDBController11() {
        string testAcctId = SCMCDBControllerTest.createAccount1();
        SCMCDBControllerTest.createSCMCDB(testAcctId);

        test.startTest();
            SCMCDBController s = new SCMCDBController();
            s.account = 'MYTEST ACCOUNT1';
            s.scmcdb.Base_Device__c = 'test';
            s.scmcdb.Fab__c = 'FAB 2';
            s.scmcdb.Geometry__c = '0.010UM';
            s.scmcdb.PO_Raise_Date__c = date.newInstance(date.today().year(), 01, 15).addMonths(6);
            s.dpmlSelected = 'Standard';
            
            s.retrieveSCMCDB();
            List<SCMCDBController.PoLeadTimeWrapper> listSCMCDB = s.getPoLeadTimeRecords();
            s.exportCsvFile();
            s.clear();
        test.stopTest();
    }
    
    static testMethod void testSCMCDBController12() {
        string testAcctId = SCMCDBControllerTest.createAccount1();
        SCMCDBControllerTest.createSCMCDB(testAcctId);

        test.startTest();
            SCMCDBController s = new SCMCDBController();
            s.account = 'MYTEST ACCOUNT1';
            s.scmcdb.Base_Device__c = 'test';
            s.scmcdb.Fab__c = 'FAB 2';
            s.scmcdb.Geometry__c = '0.010UM';
            s.scmcdb.PO_Raise_Date__c = date.newInstance(date.today().year(), 01, 15).addMonths(6);
            s.dpmlSelected = 'BulletLE12';
            
            s.retrieveSCMCDB();
            List<SCMCDBController.PoLeadTimeWrapper> listSCMCDB = s.getPoLeadTimeRecords();
            s.exportCsvFile();
            s.clear();
        test.stopTest();
    }
    
    static testMethod void testSCMCDBController13() {
        string testAcctId = SCMCDBControllerTest.createAccount1();
        SCMCDBControllerTest.createSCMCDB(testAcctId);

        test.startTest();
            SCMCDBController s = new SCMCDBController();
            s.account = 'MYTEST ACCOUNT1';
            s.scmcdb.Base_Device__c = 'test';
            s.scmcdb.Fab__c = 'FAB 2';
            s.scmcdb.Geometry__c = '0.010UM';
            s.scmcdb.PO_Raise_Date__c = date.newInstance(date.today().year(), 01, 15).addMonths(6);
            s.dpmlSelected = 'BulletG12';
            
            s.retrieveSCMCDB();
            List<SCMCDBController.PoLeadTimeWrapper> listSCMCDB = s.getPoLeadTimeRecords();
            s.exportCsvFile();
            s.clear();
        test.stopTest();
    }
    
    static testMethod void testSCMCDBController14() {
        string testAcctId = SCMCDBControllerTest.createAccount1();
        SCMCDBControllerTest.createSCMCDB(testAcctId);

        test.startTest();
            SCMCDBController s = new SCMCDBController();
            s.account = 'MYTEST ACCOUNT1';
            s.scmcdb.Base_Device__c = 'test';
            s.scmcdb.Fab__c = 'FAB 2';
            s.scmcdb.Geometry__c = '0.010UM';
            s.scmcdb.PO_Raise_Date__c = date.newInstance(date.today().year(), 01, 15).addMonths(6);
            s.dpmlSelected = 'HotLE12';
            
            s.retrieveSCMCDB();
            List<SCMCDBController.PoLeadTimeWrapper> listSCMCDB = s.getPoLeadTimeRecords();
            s.exportCsvFile();
            s.clear();
        test.stopTest();
    }
    
    static testMethod void testSCMCDBController15() {
        string testAcctId = SCMCDBControllerTest.createAccount1();
        SCMCDBControllerTest.createSCMCDB(testAcctId);

        test.startTest();
            SCMCDBController s = new SCMCDBController();
            s.account = 'MYTEST ACCOUNT1';
            s.scmcdb.Base_Device__c = 'test';
            s.scmcdb.Fab__c = 'FAB 2';
            s.scmcdb.Geometry__c = '0.010UM';
            s.scmcdb.PO_Raise_Date__c = date.newInstance(date.today().year(), 01, 15).addMonths(6);
            s.dpmlSelected = 'HotG12';
            
            s.retrieveSCMCDB();
            List<SCMCDBController.PoLeadTimeWrapper> listSCMCDB = s.getPoLeadTimeRecords();
            s.exportCsvFile();
            s.clear();
        test.stopTest();
    }
    
    // 4th quarter
    static testMethod void testSCMCDBController16() {
        string testAcctId = SCMCDBControllerTest.createAccount1();
        SCMCDBControllerTest.createSCMCDB(testAcctId);

        test.startTest();
            SCMCDBController s = new SCMCDBController();
            s.account = 'MYTEST ACCOUNT1';
            s.scmcdb.Base_Device__c = 'test';
            s.scmcdb.Fab__c = 'FAB 2';
            s.scmcdb.Geometry__c = '0.010UM';
            s.scmcdb.PO_Raise_Date__c = date.newInstance(date.today().year(), 01, 15).addMonths(9);
            s.dpmlSelected = 'Standard';
            
            s.retrieveSCMCDB();
            List<SCMCDBController.PoLeadTimeWrapper> listSCMCDB = s.getPoLeadTimeRecords();
            s.exportCsvFile();
            s.clear();
        test.stopTest();
    }
    
    static testMethod void testSCMCDBController17() {
        string testAcctId = SCMCDBControllerTest.createAccount1();
        SCMCDBControllerTest.createSCMCDB(testAcctId);

        test.startTest();
            SCMCDBController s = new SCMCDBController();
            s.account = 'Test Account ZA1';
            s.scmcdb.Base_Device__c = 'test';
            s.scmcdb.Fab__c = 'FAB 2';
            s.scmcdb.Geometry__c = '0.010UM';
            s.scmcdb.PO_Raise_Date__c = date.newInstance(date.today().year(), 01, 15).addMonths(9);
            s.dpmlSelected = 'BulletLE12';
            
            s.retrieveSCMCDB();
            List<SCMCDBController.PoLeadTimeWrapper> listSCMCDB = s.getPoLeadTimeRecords();
            s.exportCsvFile();
            s.clear();
        test.stopTest();
    }
    
    static testMethod void testSCMCDBController18() {
        string testAcctId = SCMCDBControllerTest.createAccount1();
        SCMCDBControllerTest.createSCMCDB(testAcctId);

        test.startTest();
            SCMCDBController s = new SCMCDBController();
            s.account = 'MYTEST ACCOUNT1';
            s.scmcdb.Base_Device__c = 'test';
            s.scmcdb.Fab__c = 'FAB 2';
            s.scmcdb.Geometry__c = '0.010UM';
            s.scmcdb.PO_Raise_Date__c = date.newInstance(date.today().year(), 01, 15).addMonths(9);
            s.dpmlSelected = 'BulletG12';
            
            s.retrieveSCMCDB();
            List<SCMCDBController.PoLeadTimeWrapper> listSCMCDB = s.getPoLeadTimeRecords();
            s.exportCsvFile();
            s.clear();
        test.stopTest();
    }
    
    static testMethod void testSCMCDBController19() {
        string testAcctId = SCMCDBControllerTest.createAccount1();
        SCMCDBControllerTest.createSCMCDB(testAcctId);

        test.startTest();
            SCMCDBController s = new SCMCDBController();
            s.account = 'MYTEST ACCOUNT1';
            s.scmcdb.Base_Device__c = 'test';
            s.scmcdb.Fab__c = 'FAB 2';
            s.scmcdb.Geometry__c = '0.010UM';
            s.scmcdb.PO_Raise_Date__c = date.newInstance(date.today().year(), 01, 15).addMonths(9);
            s.dpmlSelected = 'HotLE12';
            
            s.retrieveSCMCDB();
            List<SCMCDBController.PoLeadTimeWrapper> listSCMCDB = s.getPoLeadTimeRecords();
            s.exportCsvFile();
            s.clear();
        test.stopTest();
    }
    
    static testMethod void testSCMCDBController20() {
        string testAcctId = SCMCDBControllerTest.createAccount1();
        SCMCDBControllerTest.createSCMCDB(testAcctId);

        test.startTest();
            SCMCDBController s = new SCMCDBController();
            s.account = 'MYTEST ACCOUNT1';
            s.scmcdb.Base_Device__c = 'test';
            s.scmcdb.Fab__c = 'FAB 2';
            s.scmcdb.Geometry__c = '0.010UM';
            s.scmcdb.PO_Raise_Date__c = date.newInstance(date.today().year(), 01, 15).addMonths(9);
            s.dpmlSelected = 'HotG12';
            
            s.retrieveSCMCDB();
            List<SCMCDBController.PoLeadTimeWrapper> listSCMCDB = s.getPoLeadTimeRecords();
            s.exportCsvFile();
            s.clear();
        test.stopTest();
    }
    
    static testMethod void testSCMCDBController21() {
        string testAcctId = SCMCDBControllerTest.createAccount1();
        SCMCDBControllerTest.createSCMCDB(testAcctId);
        
        test.startTest();
            SCMCDBController s = new SCMCDBController();
            s.account = 'MYTEST ACCOUNT1';
            s.scmcdb.Geometry__c = '0.010UM';
            s.scmcdb.PO_Raise_Date__c = date.newInstance(date.today().year(), 01, 15);
            s.dpmlSelected = 'Standard';
            
            s.retrieveSCMCDB();
        test.stopTest();
    }
    
     static testMethod void testSCMCDBController22() {
        string testAcctId = SCMCDBControllerTest.createAccount1();
        SCMCDBControllerTest.createSCMCDB(testAcctId);

        test.startTest();
            SCMCDBController s = new SCMCDBController();
            s.account = 'MYTEST ACCOUNT1';
            s.scmcdb.Base_Device__c = 'test';
            s.scmcdb.Fab__c = 'FAB 2';
            s.scmcdb.Geometry__c = '0.010UM';
            s.scmcdb.Goods_Received_Date__c = date.newInstance(date.today().year(), 01, 15).addMonths(9);
            s.dpmlSelected = 'BulletG12';
            
            s.retrieveSCMCDB();
            List<SCMCDBController.PoLeadTimeWrapper> listSCMCDB = s.getPoLeadTimeRecords();
            s.exportCsvFile();
            s.clear();
        test.stopTest();
    }
    
    static testMethod void testSCMCDBController23() {
        string testAcctId = SCMCDBControllerTest.createAccount1();
        SCMCDBControllerTest.createSCMCDB(testAcctId);

        test.startTest();
            SCMCDBController s = new SCMCDBController();
            s.account = 'MYTEST ACCOUNT1';
            s.scmcdb.Base_Device__c = 'test';
            s.scmcdb.Fab__c = 'FAB 2';
            s.scmcdb.Geometry__c = '0.010UM';
            s.scmcdb.PO_Raise_Date__c = date.newInstance(date.today().year(), 01, 15).addMonths(12);
            s.dpmlSelected = 'BulletG12';
            
            s.retrieveSCMCDB();
            List<SCMCDBController.PoLeadTimeWrapper> listSCMCDB = s.getPoLeadTimeRecords();
            s.exportCsvFile();
            s.clear();
        test.stopTest();
    }
    
     static testMethod void testSCMCDBController24() {
        string testAcctId = SCMCDBControllerTest.createAccount1();
        SCMCDBControllerTest.createSCMCDB(testAcctId);

        test.startTest();
            SCMCDBController s = new SCMCDBController();
            s.account = 'MYTEST ACCOUNT1';
            s.scmcdb.Base_Device__c = 'test';
            s.scmcdb.Fab__c = 'FAB 2';
            s.scmcdb.Geometry__c = '0.010UM';
            s.scmcdb.PO_Raise_Date__c = date.newInstance(date.today().year(), 01, 15).addMonths(12);
            s.dpmlSelected = 'Standard';
            
            s.retrieveSCMCDB();
            List<SCMCDBController.PoLeadTimeWrapper> listSCMCDB = s.getPoLeadTimeRecords();
            s.exportCsvFile();
            s.clear();
        test.stopTest();
    }
     static testMethod void testSCMCDBController25() {
        string testAcctId = SCMCDBControllerTest.createAccount1();
        SCMCDBControllerTest.createSCMCDB(testAcctId);

        test.startTest();
            SCMCDBController s = new SCMCDBController();
            s.account = 'MYTEST ACCOUNT1';
            s.scmcdb.Base_Device__c = 'test';
            s.scmcdb.Fab__c = 'FAB 2';
            s.scmcdb.Geometry__c = '0.010UM';
            s.scmcdb.PO_Raise_Date__c = date.newInstance(date.today().year(), 01, 15).addMonths(12);
            s.dpmlSelected = 'HotLE12';
            
            s.retrieveSCMCDB();
            List<SCMCDBController.PoLeadTimeWrapper> listSCMCDB = s.getPoLeadTimeRecords();
            s.exportCsvFile();
            s.clear();
        test.stopTest();
    }
    
    private static Account getAccount(string AccountName)
            {
                Account testAcct= [SELECT Id, Name FROM Account Where Name =: AccountName];
        
                return testAcct;
            }  
}