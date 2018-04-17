/*
    Author: Zymark Ambat
    Description: This serves as the Test Class for POLeadTimeBatchUpdate.
    History: 
        ZAmbat      10032014    - Code creation.
*/

@isTest(SeeAllData=false)
public class POLeadTimeBatchUpdateTest {

    @testSetup static void testdata(){
        DataUtilTest.loadEnvironmentVariables();
 
         Map<String,Object> fieldValueMap = new Map<String,Object>();       
        fieldValueMap.put('Name', 'Test Account ZA1');
            
        fieldValueMap.put('stage__c', 'Unqualified');
        fieldValueMap.put('short_name__c', 'Test007');
        fieldValueMap.put('sub_type__c', 'Direct');
        fieldValueMap.put('site_department__c', 'IT');          
        fieldValueMap.put('transaction_type__c', 'Non-Transactional');
                
        fieldValueMap.put('Process_Tech_Interested__c', 'Mature (> 0.11um)');
        fieldValueMap.put('region__c', 'US');
        fieldValueMap.put('Sales_Territory__c', 'Greater China');
        fieldValueMap.put('financial_territory__c', 'Greater China');          
               
        fieldValueMap.put('Bill_To_Address_1__c', 'Test address1');
        fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');
        fieldValueMap.put('Bill_To_City__c', 'Test billtocity');
        fieldValueMap.put('Corporate_City__c', 'test corporate city');
        fieldValueMap.put('Bill_To_Country__c', 'India');
        fieldValueMap.put('Corporate_Country__c', 'India');
        fieldValueMap.put('Short_Name__c', 'hello');          
             
        fieldValueMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER'));       
        AccountDataFactory.createAccount(fieldValueMap);
        
         List<User> users = new List<User>();
         User u = new User(alias = 'ts3', email='testaccss3@test.com',
        emailencodingkey='UTF-8', lastname='TestLast3', firstname='TestFirst3', languagelocalekey='en_US',
        localesidkey='en_US', profileid = '00e90000001232a',
        timezonesidkey='America/Los_Angeles', username='testaccss24@test.com',communitynickname='tsss3',FederationIdentifier='Test4');
        
      
        users.add(u); 
        
        insert users;               
    } 

      
        
        
            
    static Id createAccount() {
        // Create Account
        Account testAcct = getAccount('Test Account ZA1'); 
        
        return testAcct.Id;
    }
    
    static Id createContact(Id testAcctId) {
        Contact c = new Contact();
        c.FirstName = 'FirstName';
        c.LastName = 'LastName';
        c.AccountId = testAcctId;
        c.Email = 'test@test.com';
        c.Department__c = 'TestDepartment';
        
        insert c;
        
        return c.Id;
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
        s.PF_Adder_day__c = '5';
        s.ML_Count_FEOL_BEOL__c = '10';
        
        insert s;
    }
    
    static testMethod void testPOLeadTimeBatchUpdate1() {
        string testAcctId = POLeadTimeBatchUpdateTest.createAccount();
        POLeadTimeBatchUpdateTest.createSCMCDB(testAcctId);
        test.startTest();
            string soql = 'SELECT Id, Name, Account__c, Account__r.Name, Base_Device__c, Bullet_DPML_12w_day_CurrQtr__c, Bullet_DPML_12w_day_CurrQtr_1__c, Bullet_DPML_12w_day_CurrQtr_2__c, Bullet_DPML_12w_day_CurrQtr_3__c, ' + 
                                     'PO_Raise_Date__c, Goods_Received_Date__c, Bullet_DPML_12w_day_CurrQtr1__c, Bullet_DPML_12w_day_CurrQtr_1_1__c, Bullet_DPML_12w_day_CurrQtr_2_1__c, Bullet_DPML_12w_day_CurrQtr_3_1__c, Device_Account_Short_Name__c, ' +
                                     'Fab__c, Geometry__c, Hot_DPML_12w_day_CurrQtr1__c, Total_Lead_Time__c, Hot_DPML_12w_day_CurrQtr__c, Hot_DPML_12w_day_CurrQtr_1__c, Hot_DPML_12w_day_CurrQtr_2__c, Hot_DPML_12w_day_CurrQtr_3__c, ' +
                                     'Hot_DPML_12w_day_CurrQtr_1_1__c, Hot_DPML_12w_day_CurrQtr_2_1__c, Hot_DPML_12w_day_CurrQtr_3_1__c, ML_Count_FEOL_BEOL__c, PF_Adder_day__c, PO_Lead_Time_day__c, Process_Flow_Pid_PT_Id__c, Device_Stage__c, ' +
                                     'Sort_Adder_day__c, Standard_DPML_day_CurrQtr__c, Standard_DPML_day_CurrQtr_1__c, Standard_DPML_day_CurrQtr_2__c, Standard_DPML_day_CurrQtr_3__c ' +
                          'FROM PO_Lead_Time__c LIMIT 1';
            database.executeBatch(new POLeadTimeBatchUpdate(date.today()
                                                            , null
                                                            , date.newInstance(date.today().year(), 10, 1)
                                                            , date.newInstance(date.today().year(), 10, 1).addMonths(3)
                                                            , date.newInstance(date.today().year(), 10, 1).addMonths(6)
                                                            , date.newInstance(date.today().year(), 10, 1).addMonths(9)
                                                            , soql
                                                            , 'Standard'
                                                            , new List<string>{'FAB2'}
                                                            , new List<string>()
                                                            , UserInfo.getUserId()));
        test.stopTest();
    }
    
    static testMethod void testPOLeadTimeBatchUpdate2() {
        string testAcctId = POLeadTimeBatchUpdateTest.createAccount();
        POLeadTimeBatchUpdateTest.createSCMCDB(testAcctId);
        test.startTest();
            string soql = 'SELECT Id, Name, Account__c, Account__r.Name, Base_Device__c, Bullet_DPML_12w_day_CurrQtr__c, Bullet_DPML_12w_day_CurrQtr_1__c, Bullet_DPML_12w_day_CurrQtr_2__c, Bullet_DPML_12w_day_CurrQtr_3__c, ' + 
                                     'PO_Raise_Date__c, Goods_Received_Date__c, Bullet_DPML_12w_day_CurrQtr1__c, Bullet_DPML_12w_day_CurrQtr_1_1__c, Bullet_DPML_12w_day_CurrQtr_2_1__c, Bullet_DPML_12w_day_CurrQtr_3_1__c, Device_Account_Short_Name__c, ' +
                                     'Fab__c, Geometry__c, Hot_DPML_12w_day_CurrQtr1__c, Total_Lead_Time__c, Hot_DPML_12w_day_CurrQtr__c, Hot_DPML_12w_day_CurrQtr_1__c, Hot_DPML_12w_day_CurrQtr_2__c, Hot_DPML_12w_day_CurrQtr_3__c, ' +
                                     'Hot_DPML_12w_day_CurrQtr_1_1__c, Hot_DPML_12w_day_CurrQtr_2_1__c, Hot_DPML_12w_day_CurrQtr_3_1__c, ML_Count_FEOL_BEOL__c, PF_Adder_day__c, PO_Lead_Time_day__c, Process_Flow_Pid_PT_Id__c, Device_Stage__c, ' +
                                     'Sort_Adder_day__c, Standard_DPML_day_CurrQtr__c, Standard_DPML_day_CurrQtr_1__c, Standard_DPML_day_CurrQtr_2__c, Standard_DPML_day_CurrQtr_3__c ' +
                          'FROM PO_Lead_Time__c LIMIT 1';
            database.executeBatch(new POLeadTimeBatchUpdate(date.today()
                                                            , null
                                                            , date.newInstance(date.today().year(), 10, 1)
                                                            , date.newInstance(date.today().year(), 10, 1).addMonths(3)
                                                            , date.newInstance(date.today().year(), 10, 1).addMonths(6)
                                                            , date.newInstance(date.today().year(), 10, 1).addMonths(9)
                                                            , soql
                                                            , 'BulletLE12'
                                                            , new List<string>{'FAB2'}
                                                            , new List<string>()
                                                            , UserInfo.getUserId()));
        test.stopTest();
    }
    
    static testMethod void testPOLeadTimeBatchUpdate3() {
        string testAcctId = POLeadTimeBatchUpdateTest.createAccount();
        POLeadTimeBatchUpdateTest.createSCMCDB(testAcctId);
        test.startTest();
            string soql = 'SELECT Id, Name, Account__c, Account__r.Name, Base_Device__c, Bullet_DPML_12w_day_CurrQtr__c, Bullet_DPML_12w_day_CurrQtr_1__c, Bullet_DPML_12w_day_CurrQtr_2__c, Bullet_DPML_12w_day_CurrQtr_3__c, ' + 
                                     'PO_Raise_Date__c, Goods_Received_Date__c, Bullet_DPML_12w_day_CurrQtr1__c, Bullet_DPML_12w_day_CurrQtr_1_1__c, Bullet_DPML_12w_day_CurrQtr_2_1__c, Bullet_DPML_12w_day_CurrQtr_3_1__c, Device_Account_Short_Name__c, ' +
                                     'Fab__c, Geometry__c, Hot_DPML_12w_day_CurrQtr1__c, Total_Lead_Time__c, Hot_DPML_12w_day_CurrQtr__c, Hot_DPML_12w_day_CurrQtr_1__c, Hot_DPML_12w_day_CurrQtr_2__c, Hot_DPML_12w_day_CurrQtr_3__c, ' +
                                     'Hot_DPML_12w_day_CurrQtr_1_1__c, Hot_DPML_12w_day_CurrQtr_2_1__c, Hot_DPML_12w_day_CurrQtr_3_1__c, ML_Count_FEOL_BEOL__c, PF_Adder_day__c, PO_Lead_Time_day__c, Process_Flow_Pid_PT_Id__c, Device_Stage__c, ' +
                                     'Sort_Adder_day__c, Standard_DPML_day_CurrQtr__c, Standard_DPML_day_CurrQtr_1__c, Standard_DPML_day_CurrQtr_2__c, Standard_DPML_day_CurrQtr_3__c ' +
                          'FROM PO_Lead_Time__c LIMIT 1';
            database.executeBatch(new POLeadTimeBatchUpdate(date.today()
                                                            , null
                                                            , date.newInstance(date.today().year(), 10, 1)
                                                            , date.newInstance(date.today().year(), 10, 1).addMonths(3)
                                                            , date.newInstance(date.today().year(), 10, 1).addMonths(6)
                                                            , date.newInstance(date.today().year(), 10, 1).addMonths(9)
                                                            , soql
                                                            , 'BulletG12'
                                                            , new List<string>{'FAB2'}
                                                            , new List<string>()
                                                            , UserInfo.getUserId()));
        test.stopTest();
    }
    
    static testMethod void testPOLeadTimeBatchUpdate4() {
        string testAcctId = POLeadTimeBatchUpdateTest.createAccount();
        POLeadTimeBatchUpdateTest.createSCMCDB(testAcctId);
        test.startTest();
            string soql = 'SELECT Id, Name, Account__c, Account__r.Name, Base_Device__c, Bullet_DPML_12w_day_CurrQtr__c, Bullet_DPML_12w_day_CurrQtr_1__c, Bullet_DPML_12w_day_CurrQtr_2__c, Bullet_DPML_12w_day_CurrQtr_3__c, ' + 
                                     'PO_Raise_Date__c, Goods_Received_Date__c, Bullet_DPML_12w_day_CurrQtr1__c, Bullet_DPML_12w_day_CurrQtr_1_1__c, Bullet_DPML_12w_day_CurrQtr_2_1__c, Bullet_DPML_12w_day_CurrQtr_3_1__c, Device_Account_Short_Name__c, ' +
                                     'Fab__c, Geometry__c, Hot_DPML_12w_day_CurrQtr1__c, Total_Lead_Time__c, Hot_DPML_12w_day_CurrQtr__c, Hot_DPML_12w_day_CurrQtr_1__c, Hot_DPML_12w_day_CurrQtr_2__c, Hot_DPML_12w_day_CurrQtr_3__c, ' +
                                     'Hot_DPML_12w_day_CurrQtr_1_1__c, Hot_DPML_12w_day_CurrQtr_2_1__c, Hot_DPML_12w_day_CurrQtr_3_1__c, ML_Count_FEOL_BEOL__c, PF_Adder_day__c, PO_Lead_Time_day__c, Process_Flow_Pid_PT_Id__c, Device_Stage__c, ' +
                                     'Sort_Adder_day__c, Standard_DPML_day_CurrQtr__c, Standard_DPML_day_CurrQtr_1__c, Standard_DPML_day_CurrQtr_2__c, Standard_DPML_day_CurrQtr_3__c ' +
                          'FROM PO_Lead_Time__c LIMIT 1';
            database.executeBatch(new POLeadTimeBatchUpdate(date.today()
                                                            , null
                                                            , date.newInstance(date.today().year(), 10, 1)
                                                            , date.newInstance(date.today().year(), 10, 1).addMonths(3)
                                                            , date.newInstance(date.today().year(), 10, 1).addMonths(6)
                                                            , date.newInstance(date.today().year(), 10, 1).addMonths(9)
                                                            , soql
                                                            , 'HotLE12'
                                                            , new List<string>{'FAB2'}
                                                            , new List<string>()
                                                            , UserInfo.getUserId()));
        test.stopTest();
    }
    
    static testMethod void testPOLeadTimeBatchUpdate5() {
        string testAcctId = POLeadTimeBatchUpdateTest.createAccount();
        POLeadTimeBatchUpdateTest.createSCMCDB(testAcctId);
        test.startTest();
            string soql = 'SELECT Id, Name, Account__c, Account__r.Name, Base_Device__c, Bullet_DPML_12w_day_CurrQtr__c, Bullet_DPML_12w_day_CurrQtr_1__c, Bullet_DPML_12w_day_CurrQtr_2__c, Bullet_DPML_12w_day_CurrQtr_3__c, ' + 
                                     'PO_Raise_Date__c, Goods_Received_Date__c, Bullet_DPML_12w_day_CurrQtr1__c, Bullet_DPML_12w_day_CurrQtr_1_1__c, Bullet_DPML_12w_day_CurrQtr_2_1__c, Bullet_DPML_12w_day_CurrQtr_3_1__c, Device_Account_Short_Name__c, ' +
                                     'Fab__c, Geometry__c, Hot_DPML_12w_day_CurrQtr1__c, Total_Lead_Time__c, Hot_DPML_12w_day_CurrQtr__c, Hot_DPML_12w_day_CurrQtr_1__c, Hot_DPML_12w_day_CurrQtr_2__c, Hot_DPML_12w_day_CurrQtr_3__c, ' +
                                     'Hot_DPML_12w_day_CurrQtr_1_1__c, Hot_DPML_12w_day_CurrQtr_2_1__c, Hot_DPML_12w_day_CurrQtr_3_1__c, ML_Count_FEOL_BEOL__c, PF_Adder_day__c, PO_Lead_Time_day__c, Process_Flow_Pid_PT_Id__c, Device_Stage__c, ' +
                                     'Sort_Adder_day__c, Standard_DPML_day_CurrQtr__c, Standard_DPML_day_CurrQtr_1__c, Standard_DPML_day_CurrQtr_2__c, Standard_DPML_day_CurrQtr_3__c ' +
                          'FROM PO_Lead_Time__c LIMIT 1';
            database.executeBatch(new POLeadTimeBatchUpdate(date.today()
                                                            , null
                                                            , date.newInstance(date.today().year(), 10, 1)
                                                            , date.newInstance(date.today().year(), 10, 1).addMonths(3)
                                                            , date.newInstance(date.today().year(), 10, 1).addMonths(6)
                                                            , date.newInstance(date.today().year(), 10, 1).addMonths(9)
                                                            , soql
                                                            , 'HotG12'
                                                            , new List<string>{'FAB2'}
                                                            , new List<string>()
                                                            , UserInfo.getUserId()));
        test.stopTest();
    }
    
    // 2nd quarter
    static testMethod void testPOLeadTimeBatchUpdate6() {
        string testAcctId = POLeadTimeBatchUpdateTest.createAccount();
        POLeadTimeBatchUpdateTest.createSCMCDB(testAcctId);
        test.startTest();
            string soql = 'SELECT Id, Name, Account__c, Account__r.Name, Base_Device__c, Bullet_DPML_12w_day_CurrQtr__c, Bullet_DPML_12w_day_CurrQtr_1__c, Bullet_DPML_12w_day_CurrQtr_2__c, Bullet_DPML_12w_day_CurrQtr_3__c, ' + 
                                     'PO_Raise_Date__c, Goods_Received_Date__c, Bullet_DPML_12w_day_CurrQtr1__c, Bullet_DPML_12w_day_CurrQtr_1_1__c, Bullet_DPML_12w_day_CurrQtr_2_1__c, Bullet_DPML_12w_day_CurrQtr_3_1__c, Device_Account_Short_Name__c, ' +
                                     'Fab__c, Geometry__c, Hot_DPML_12w_day_CurrQtr1__c, Total_Lead_Time__c, Hot_DPML_12w_day_CurrQtr__c, Hot_DPML_12w_day_CurrQtr_1__c, Hot_DPML_12w_day_CurrQtr_2__c, Hot_DPML_12w_day_CurrQtr_3__c, ' +
                                     'Hot_DPML_12w_day_CurrQtr_1_1__c, Hot_DPML_12w_day_CurrQtr_2_1__c, Hot_DPML_12w_day_CurrQtr_3_1__c, ML_Count_FEOL_BEOL__c, PF_Adder_day__c, PO_Lead_Time_day__c, Process_Flow_Pid_PT_Id__c, Device_Stage__c, ' +
                                     'Sort_Adder_day__c, Standard_DPML_day_CurrQtr__c, Standard_DPML_day_CurrQtr_1__c, Standard_DPML_day_CurrQtr_2__c, Standard_DPML_day_CurrQtr_3__c ' +
                          'FROM PO_Lead_Time__c LIMIT 1';
            database.executeBatch(new POLeadTimeBatchUpdate(date.newInstance(date.today().year(), 10, 15).addMonths(3)
                                                            , null
                                                            , date.newInstance(date.today().year(), 10, 1)
                                                            , date.newInstance(date.today().year(), 10, 1).addMonths(3)
                                                            , date.newInstance(date.today().year(), 10, 1).addMonths(6)
                                                            , date.newInstance(date.today().year(), 10, 1).addMonths(9)
                                                            , soql
                                                            , 'Standard'
                                                            , new List<string>{'FAB2'}
                                                            , new List<string>()
                                                            , UserInfo.getUserId()));
        test.stopTest();
    }
    
    static testMethod void testPOLeadTimeBatchUpdate7() {
        string testAcctId = POLeadTimeBatchUpdateTest.createAccount();
        POLeadTimeBatchUpdateTest.createSCMCDB(testAcctId);
        test.startTest();
            string soql = 'SELECT Id, Name, Account__c, Account__r.Name, Base_Device__c, Bullet_DPML_12w_day_CurrQtr__c, Bullet_DPML_12w_day_CurrQtr_1__c, Bullet_DPML_12w_day_CurrQtr_2__c, Bullet_DPML_12w_day_CurrQtr_3__c, ' + 
                                     'PO_Raise_Date__c, Goods_Received_Date__c, Bullet_DPML_12w_day_CurrQtr1__c, Bullet_DPML_12w_day_CurrQtr_1_1__c, Bullet_DPML_12w_day_CurrQtr_2_1__c, Bullet_DPML_12w_day_CurrQtr_3_1__c, Device_Account_Short_Name__c, ' +
                                     'Fab__c, Geometry__c, Hot_DPML_12w_day_CurrQtr1__c, Total_Lead_Time__c, Hot_DPML_12w_day_CurrQtr__c, Hot_DPML_12w_day_CurrQtr_1__c, Hot_DPML_12w_day_CurrQtr_2__c, Hot_DPML_12w_day_CurrQtr_3__c, ' +
                                     'Hot_DPML_12w_day_CurrQtr_1_1__c, Hot_DPML_12w_day_CurrQtr_2_1__c, Hot_DPML_12w_day_CurrQtr_3_1__c, ML_Count_FEOL_BEOL__c, PF_Adder_day__c, PO_Lead_Time_day__c, Process_Flow_Pid_PT_Id__c, Device_Stage__c, ' +
                                     'Sort_Adder_day__c, Standard_DPML_day_CurrQtr__c, Standard_DPML_day_CurrQtr_1__c, Standard_DPML_day_CurrQtr_2__c, Standard_DPML_day_CurrQtr_3__c ' +
                          'FROM PO_Lead_Time__c LIMIT 1';
            database.executeBatch(new POLeadTimeBatchUpdate(date.newInstance(date.today().year(), 10, 15).addMonths(3)
                                                            , null
                                                            , date.newInstance(date.today().year(), 10, 1)
                                                            , date.newInstance(date.today().year(), 10, 1).addMonths(3)
                                                            , date.newInstance(date.today().year(), 10, 1).addMonths(6)
                                                            , date.newInstance(date.today().year(), 10, 1).addMonths(9)
                                                            , soql
                                                            , 'BulletLE12'
                                                            , new List<string>{'FAB2'}
                                                            , new List<string>()
                                                            , UserInfo.getUserId()));
        test.stopTest();
    }
    
    static testMethod void testPOLeadTimeBatchUpdate8() {
        string testAcctId = POLeadTimeBatchUpdateTest.createAccount();
        POLeadTimeBatchUpdateTest.createSCMCDB(testAcctId);
        test.startTest();
            string soql = 'SELECT Id, Name, Account__c, Account__r.Name, Base_Device__c, Bullet_DPML_12w_day_CurrQtr__c, Bullet_DPML_12w_day_CurrQtr_1__c, Bullet_DPML_12w_day_CurrQtr_2__c, Bullet_DPML_12w_day_CurrQtr_3__c, ' + 
                                     'PO_Raise_Date__c, Goods_Received_Date__c, Bullet_DPML_12w_day_CurrQtr1__c, Bullet_DPML_12w_day_CurrQtr_1_1__c, Bullet_DPML_12w_day_CurrQtr_2_1__c, Bullet_DPML_12w_day_CurrQtr_3_1__c, Device_Account_Short_Name__c, ' +
                                     'Fab__c, Geometry__c, Hot_DPML_12w_day_CurrQtr1__c, Total_Lead_Time__c, Hot_DPML_12w_day_CurrQtr__c, Hot_DPML_12w_day_CurrQtr_1__c, Hot_DPML_12w_day_CurrQtr_2__c, Hot_DPML_12w_day_CurrQtr_3__c, ' +
                                     'Hot_DPML_12w_day_CurrQtr_1_1__c, Hot_DPML_12w_day_CurrQtr_2_1__c, Hot_DPML_12w_day_CurrQtr_3_1__c, ML_Count_FEOL_BEOL__c, PF_Adder_day__c, PO_Lead_Time_day__c, Process_Flow_Pid_PT_Id__c, Device_Stage__c, ' +
                                     'Sort_Adder_day__c, Standard_DPML_day_CurrQtr__c, Standard_DPML_day_CurrQtr_1__c, Standard_DPML_day_CurrQtr_2__c, Standard_DPML_day_CurrQtr_3__c ' +
                          'FROM PO_Lead_Time__c LIMIT 1';
            database.executeBatch(new POLeadTimeBatchUpdate(date.newInstance(date.today().year(), 10, 15).addMonths(3)
                                                            , null
                                                            , date.newInstance(date.today().year(), 10, 1)
                                                            , date.newInstance(date.today().year(), 10, 1).addMonths(3)
                                                            , date.newInstance(date.today().year(), 10, 1).addMonths(6)
                                                            , date.newInstance(date.today().year(), 10, 1).addMonths(9)
                                                            , soql
                                                            , 'BulletG12'
                                                            , new List<string>{'FAB2'}
                                                            , new List<string>()
                                                            , UserInfo.getUserId()));
        test.stopTest();
    }
    
    static testMethod void testPOLeadTimeBatchUpdate9() {
        string testAcctId = POLeadTimeBatchUpdateTest.createAccount();
        POLeadTimeBatchUpdateTest.createSCMCDB(testAcctId);
        test.startTest();
            string soql = 'SELECT Id, Name, Account__c, Account__r.Name, Base_Device__c, Bullet_DPML_12w_day_CurrQtr__c, Bullet_DPML_12w_day_CurrQtr_1__c, Bullet_DPML_12w_day_CurrQtr_2__c, Bullet_DPML_12w_day_CurrQtr_3__c, ' + 
                                     'PO_Raise_Date__c, Goods_Received_Date__c, Bullet_DPML_12w_day_CurrQtr1__c, Bullet_DPML_12w_day_CurrQtr_1_1__c, Bullet_DPML_12w_day_CurrQtr_2_1__c, Bullet_DPML_12w_day_CurrQtr_3_1__c, Device_Account_Short_Name__c, ' +
                                     'Fab__c, Geometry__c, Hot_DPML_12w_day_CurrQtr1__c, Total_Lead_Time__c, Hot_DPML_12w_day_CurrQtr__c, Hot_DPML_12w_day_CurrQtr_1__c, Hot_DPML_12w_day_CurrQtr_2__c, Hot_DPML_12w_day_CurrQtr_3__c, ' +
                                     'Hot_DPML_12w_day_CurrQtr_1_1__c, Hot_DPML_12w_day_CurrQtr_2_1__c, Hot_DPML_12w_day_CurrQtr_3_1__c, ML_Count_FEOL_BEOL__c, PF_Adder_day__c, PO_Lead_Time_day__c, Process_Flow_Pid_PT_Id__c, Device_Stage__c, ' +
                                     'Sort_Adder_day__c, Standard_DPML_day_CurrQtr__c, Standard_DPML_day_CurrQtr_1__c, Standard_DPML_day_CurrQtr_2__c, Standard_DPML_day_CurrQtr_3__c ' +
                          'FROM PO_Lead_Time__c LIMIT 1';
            database.executeBatch(new POLeadTimeBatchUpdate(date.newInstance(date.today().year(), 10, 15).addMonths(3)
                                                            , null
                                                            , date.newInstance(date.today().year(), 10, 1)
                                                            , date.newInstance(date.today().year(), 10, 1).addMonths(3)
                                                            , date.newInstance(date.today().year(), 10, 1).addMonths(6)
                                                            , date.newInstance(date.today().year(), 10, 1).addMonths(9)
                                                            , soql
                                                            , 'HotLE12'
                                                            , new List<string>{'FAB2'}
                                                            , new List<string>()
                                                            , UserInfo.getUserId()));
        test.stopTest();
    }
    
    static testMethod void testPOLeadTimeBatchUpdate10() {
        string testAcctId = POLeadTimeBatchUpdateTest.createAccount();
        POLeadTimeBatchUpdateTest.createSCMCDB(testAcctId);
        test.startTest();
            string soql = 'SELECT Id, Name, Account__c, Account__r.Name, Base_Device__c, Bullet_DPML_12w_day_CurrQtr__c, Bullet_DPML_12w_day_CurrQtr_1__c, Bullet_DPML_12w_day_CurrQtr_2__c, Bullet_DPML_12w_day_CurrQtr_3__c, ' + 
                                     'PO_Raise_Date__c, Goods_Received_Date__c, Bullet_DPML_12w_day_CurrQtr1__c, Bullet_DPML_12w_day_CurrQtr_1_1__c, Bullet_DPML_12w_day_CurrQtr_2_1__c, Bullet_DPML_12w_day_CurrQtr_3_1__c, Device_Account_Short_Name__c, ' +
                                     'Fab__c, Geometry__c, Hot_DPML_12w_day_CurrQtr1__c, Total_Lead_Time__c, Hot_DPML_12w_day_CurrQtr__c, Hot_DPML_12w_day_CurrQtr_1__c, Hot_DPML_12w_day_CurrQtr_2__c, Hot_DPML_12w_day_CurrQtr_3__c, ' +
                                     'Hot_DPML_12w_day_CurrQtr_1_1__c, Hot_DPML_12w_day_CurrQtr_2_1__c, Hot_DPML_12w_day_CurrQtr_3_1__c, ML_Count_FEOL_BEOL__c, PF_Adder_day__c, PO_Lead_Time_day__c, Process_Flow_Pid_PT_Id__c, Device_Stage__c, ' +
                                     'Sort_Adder_day__c, Standard_DPML_day_CurrQtr__c, Standard_DPML_day_CurrQtr_1__c, Standard_DPML_day_CurrQtr_2__c, Standard_DPML_day_CurrQtr_3__c ' +
                          'FROM PO_Lead_Time__c LIMIT 1';
            database.executeBatch(new POLeadTimeBatchUpdate(date.newInstance(date.today().year(), 10, 15).addMonths(3)
                                                            , null
                                                            , date.newInstance(date.today().year(), 10, 1)
                                                            , date.newInstance(date.today().year(), 10, 1).addMonths(3)
                                                            , date.newInstance(date.today().year(), 10, 1).addMonths(6)
                                                            , date.newInstance(date.today().year(), 10, 1).addMonths(9)
                                                            , soql
                                                            , 'HotG12'
                                                            , new List<string>{'FAB2'}
                                                            , new List<string>()
                                                            , UserInfo.getUserId()));
        test.stopTest();
    }
    
    //3rd quarter
    static testMethod void testPOLeadTimeBatchUpdate11() {
        string testAcctId = POLeadTimeBatchUpdateTest.createAccount();
        POLeadTimeBatchUpdateTest.createSCMCDB(testAcctId);
        test.startTest();
            string soql = 'SELECT Id, Name, Account__c, Account__r.Name, Base_Device__c, Bullet_DPML_12w_day_CurrQtr__c, Bullet_DPML_12w_day_CurrQtr_1__c, Bullet_DPML_12w_day_CurrQtr_2__c, Bullet_DPML_12w_day_CurrQtr_3__c, ' + 
                                     'PO_Raise_Date__c, Goods_Received_Date__c, Bullet_DPML_12w_day_CurrQtr1__c, Bullet_DPML_12w_day_CurrQtr_1_1__c, Bullet_DPML_12w_day_CurrQtr_2_1__c, Bullet_DPML_12w_day_CurrQtr_3_1__c, Device_Account_Short_Name__c, ' +
                                     'Fab__c, Geometry__c, Hot_DPML_12w_day_CurrQtr1__c, Total_Lead_Time__c, Hot_DPML_12w_day_CurrQtr__c, Hot_DPML_12w_day_CurrQtr_1__c, Hot_DPML_12w_day_CurrQtr_2__c, Hot_DPML_12w_day_CurrQtr_3__c, ' +
                                     'Hot_DPML_12w_day_CurrQtr_1_1__c, Hot_DPML_12w_day_CurrQtr_2_1__c, Hot_DPML_12w_day_CurrQtr_3_1__c, ML_Count_FEOL_BEOL__c, PF_Adder_day__c, PO_Lead_Time_day__c, Process_Flow_Pid_PT_Id__c, Device_Stage__c, ' +
                                     'Sort_Adder_day__c, Standard_DPML_day_CurrQtr__c, Standard_DPML_day_CurrQtr_1__c, Standard_DPML_day_CurrQtr_2__c, Standard_DPML_day_CurrQtr_3__c ' +
                          'FROM PO_Lead_Time__c LIMIT 1';
            database.executeBatch(new POLeadTimeBatchUpdate(date.newInstance(date.today().year(), 10, 15).addMonths(6)
                                                            , null
                                                            , date.newInstance(date.today().year(), 10, 1)
                                                            , date.newInstance(date.today().year(), 10, 1).addMonths(3)
                                                            , date.newInstance(date.today().year(), 10, 1).addMonths(6)
                                                            , date.newInstance(date.today().year(), 10, 1).addMonths(9)
                                                            , soql
                                                            , 'Standard'
                                                            , new List<string>{'FAB2'}
                                                            , new List<string>()
                                                            , UserInfo.getUserId()));
        test.stopTest();
    }
    
    static testMethod void testPOLeadTimeBatchUpdate12() {
        string testAcctId = POLeadTimeBatchUpdateTest.createAccount();
        POLeadTimeBatchUpdateTest.createSCMCDB(testAcctId);
        test.startTest();
            string soql = 'SELECT Id, Name, Account__c, Account__r.Name, Base_Device__c, Bullet_DPML_12w_day_CurrQtr__c, Bullet_DPML_12w_day_CurrQtr_1__c, Bullet_DPML_12w_day_CurrQtr_2__c, Bullet_DPML_12w_day_CurrQtr_3__c, ' + 
                                     'PO_Raise_Date__c, Goods_Received_Date__c, Bullet_DPML_12w_day_CurrQtr1__c, Bullet_DPML_12w_day_CurrQtr_1_1__c, Bullet_DPML_12w_day_CurrQtr_2_1__c, Bullet_DPML_12w_day_CurrQtr_3_1__c, Device_Account_Short_Name__c, ' +
                                     'Fab__c, Geometry__c, Hot_DPML_12w_day_CurrQtr1__c, Total_Lead_Time__c, Hot_DPML_12w_day_CurrQtr__c, Hot_DPML_12w_day_CurrQtr_1__c, Hot_DPML_12w_day_CurrQtr_2__c, Hot_DPML_12w_day_CurrQtr_3__c, ' +
                                     'Hot_DPML_12w_day_CurrQtr_1_1__c, Hot_DPML_12w_day_CurrQtr_2_1__c, Hot_DPML_12w_day_CurrQtr_3_1__c, ML_Count_FEOL_BEOL__c, PF_Adder_day__c, PO_Lead_Time_day__c, Process_Flow_Pid_PT_Id__c, Device_Stage__c, ' +
                                     'Sort_Adder_day__c, Standard_DPML_day_CurrQtr__c, Standard_DPML_day_CurrQtr_1__c, Standard_DPML_day_CurrQtr_2__c, Standard_DPML_day_CurrQtr_3__c ' +
                          'FROM PO_Lead_Time__c LIMIT 1';
            database.executeBatch(new POLeadTimeBatchUpdate(date.newInstance(date.today().year(), 10, 15).addMonths(6)
                                                            , null
                                                            , date.newInstance(date.today().year(), 10, 1)
                                                            , date.newInstance(date.today().year(), 10, 1).addMonths(3)
                                                            , date.newInstance(date.today().year(), 10, 1).addMonths(6)
                                                            , date.newInstance(date.today().year(), 10, 1).addMonths(9)
                                                            , soql
                                                            , 'BulletLE12'
                                                            , new List<string>{'FAB2'}
                                                            , new List<string>()
                                                            , UserInfo.getUserId()));
        test.stopTest();
    }
    
    static testMethod void testPOLeadTimeBatchUpdate13() {
        string testAcctId = POLeadTimeBatchUpdateTest.createAccount();
        POLeadTimeBatchUpdateTest.createSCMCDB(testAcctId);
        test.startTest();
            string soql = 'SELECT Id, Name, Account__c, Account__r.Name, Base_Device__c, Bullet_DPML_12w_day_CurrQtr__c, Bullet_DPML_12w_day_CurrQtr_1__c, Bullet_DPML_12w_day_CurrQtr_2__c, Bullet_DPML_12w_day_CurrQtr_3__c, ' + 
                                     'PO_Raise_Date__c, Goods_Received_Date__c, Bullet_DPML_12w_day_CurrQtr1__c, Bullet_DPML_12w_day_CurrQtr_1_1__c, Bullet_DPML_12w_day_CurrQtr_2_1__c, Bullet_DPML_12w_day_CurrQtr_3_1__c, Device_Account_Short_Name__c, ' +
                                     'Fab__c, Geometry__c, Hot_DPML_12w_day_CurrQtr1__c, Total_Lead_Time__c, Hot_DPML_12w_day_CurrQtr__c, Hot_DPML_12w_day_CurrQtr_1__c, Hot_DPML_12w_day_CurrQtr_2__c, Hot_DPML_12w_day_CurrQtr_3__c, ' +
                                     'Hot_DPML_12w_day_CurrQtr_1_1__c, Hot_DPML_12w_day_CurrQtr_2_1__c, Hot_DPML_12w_day_CurrQtr_3_1__c, ML_Count_FEOL_BEOL__c, PF_Adder_day__c, PO_Lead_Time_day__c, Process_Flow_Pid_PT_Id__c, Device_Stage__c, ' +
                                     'Sort_Adder_day__c, Standard_DPML_day_CurrQtr__c, Standard_DPML_day_CurrQtr_1__c, Standard_DPML_day_CurrQtr_2__c, Standard_DPML_day_CurrQtr_3__c ' +
                          'FROM PO_Lead_Time__c LIMIT 1';
            database.executeBatch(new POLeadTimeBatchUpdate(date.newInstance(date.today().year(), 10, 15).addMonths(6)
                                                            , null
                                                            , date.newInstance(date.today().year(), 10, 1)
                                                            , date.newInstance(date.today().year(), 10, 1).addMonths(3)
                                                            , date.newInstance(date.today().year(), 10, 1).addMonths(6)
                                                            , date.newInstance(date.today().year(), 10, 1).addMonths(9)
                                                            , soql
                                                            , 'BulletG12'
                                                            , new List<string>{'FAB2'}
                                                            , new List<string>()
                                                            , UserInfo.getUserId()));
        test.stopTest();
    }
    
    static testMethod void testPOLeadTimeBatchUpdate14() {
        string testAcctId = POLeadTimeBatchUpdateTest.createAccount();
        POLeadTimeBatchUpdateTest.createSCMCDB(testAcctId);
        test.startTest();
            string soql = 'SELECT Id, Name, Account__c, Account__r.Name, Base_Device__c, Bullet_DPML_12w_day_CurrQtr__c, Bullet_DPML_12w_day_CurrQtr_1__c, Bullet_DPML_12w_day_CurrQtr_2__c, Bullet_DPML_12w_day_CurrQtr_3__c, ' + 
                                     'PO_Raise_Date__c, Goods_Received_Date__c, Bullet_DPML_12w_day_CurrQtr1__c, Bullet_DPML_12w_day_CurrQtr_1_1__c, Bullet_DPML_12w_day_CurrQtr_2_1__c, Bullet_DPML_12w_day_CurrQtr_3_1__c, Device_Account_Short_Name__c, ' +
                                     'Fab__c, Geometry__c, Hot_DPML_12w_day_CurrQtr1__c, Total_Lead_Time__c, Hot_DPML_12w_day_CurrQtr__c, Hot_DPML_12w_day_CurrQtr_1__c, Hot_DPML_12w_day_CurrQtr_2__c, Hot_DPML_12w_day_CurrQtr_3__c, ' +
                                     'Hot_DPML_12w_day_CurrQtr_1_1__c, Hot_DPML_12w_day_CurrQtr_2_1__c, Hot_DPML_12w_day_CurrQtr_3_1__c, ML_Count_FEOL_BEOL__c, PF_Adder_day__c, PO_Lead_Time_day__c, Process_Flow_Pid_PT_Id__c, Device_Stage__c, ' +
                                     'Sort_Adder_day__c, Standard_DPML_day_CurrQtr__c, Standard_DPML_day_CurrQtr_1__c, Standard_DPML_day_CurrQtr_2__c, Standard_DPML_day_CurrQtr_3__c ' +
                          'FROM PO_Lead_Time__c LIMIT 1';
            database.executeBatch(new POLeadTimeBatchUpdate(date.newInstance(date.today().year(), 10, 15).addMonths(6)
                                                            , null
                                                            , date.newInstance(date.today().year(), 10, 1)
                                                            , date.newInstance(date.today().year(), 10, 1).addMonths(3)
                                                            , date.newInstance(date.today().year(), 10, 1).addMonths(6)
                                                            , date.newInstance(date.today().year(), 10, 1).addMonths(9)
                                                            , soql
                                                            , 'HotLE12'
                                                            , new List<string>{'FAB2'}
                                                            , new List<string>()
                                                            , UserInfo.getUserId()));
        test.stopTest();
    }
    
    static testMethod void testPOLeadTimeBatchUpdate15() {
        string testAcctId = POLeadTimeBatchUpdateTest.createAccount();
        POLeadTimeBatchUpdateTest.createSCMCDB(testAcctId);
        test.startTest();
            string soql = 'SELECT Id, Name, Account__c, Account__r.Name, Base_Device__c, Bullet_DPML_12w_day_CurrQtr__c, Bullet_DPML_12w_day_CurrQtr_1__c, Bullet_DPML_12w_day_CurrQtr_2__c, Bullet_DPML_12w_day_CurrQtr_3__c, ' + 
                                     'PO_Raise_Date__c, Goods_Received_Date__c, Bullet_DPML_12w_day_CurrQtr1__c, Bullet_DPML_12w_day_CurrQtr_1_1__c, Bullet_DPML_12w_day_CurrQtr_2_1__c, Bullet_DPML_12w_day_CurrQtr_3_1__c, Device_Account_Short_Name__c, ' +
                                     'Fab__c, Geometry__c, Hot_DPML_12w_day_CurrQtr1__c, Total_Lead_Time__c, Hot_DPML_12w_day_CurrQtr__c, Hot_DPML_12w_day_CurrQtr_1__c, Hot_DPML_12w_day_CurrQtr_2__c, Hot_DPML_12w_day_CurrQtr_3__c, ' +
                                     'Hot_DPML_12w_day_CurrQtr_1_1__c, Hot_DPML_12w_day_CurrQtr_2_1__c, Hot_DPML_12w_day_CurrQtr_3_1__c, ML_Count_FEOL_BEOL__c, PF_Adder_day__c, PO_Lead_Time_day__c, Process_Flow_Pid_PT_Id__c, Device_Stage__c, ' +
                                     'Sort_Adder_day__c, Standard_DPML_day_CurrQtr__c, Standard_DPML_day_CurrQtr_1__c, Standard_DPML_day_CurrQtr_2__c, Standard_DPML_day_CurrQtr_3__c ' +
                          'FROM PO_Lead_Time__c LIMIT 1';
            database.executeBatch(new POLeadTimeBatchUpdate(date.newInstance(date.today().year(), 10, 15).addMonths(6)
                                                            , null
                                                            , date.newInstance(date.today().year(), 10, 1)
                                                            , date.newInstance(date.today().year(), 10, 1).addMonths(3)
                                                            , date.newInstance(date.today().year(), 10, 1).addMonths(6)
                                                            , date.newInstance(date.today().year(), 10, 1).addMonths(9)
                                                            , soql
                                                            , 'HotG12'
                                                            , new List<string>{'FAB2'}
                                                            , new List<string>()
                                                            , UserInfo.getUserId()));
        test.stopTest();
    }
    
    // 4th quarter
    static testMethod void testPOLeadTimeBatchUpdate16() {
        string testAcctId = POLeadTimeBatchUpdateTest.createAccount();
        POLeadTimeBatchUpdateTest.createSCMCDB(testAcctId);
        test.startTest();
            string soql = 'SELECT Id, Name, Account__c, Account__r.Name, Base_Device__c, Bullet_DPML_12w_day_CurrQtr__c, Bullet_DPML_12w_day_CurrQtr_1__c, Bullet_DPML_12w_day_CurrQtr_2__c, Bullet_DPML_12w_day_CurrQtr_3__c, ' + 
                                     'PO_Raise_Date__c, Goods_Received_Date__c, Bullet_DPML_12w_day_CurrQtr1__c, Bullet_DPML_12w_day_CurrQtr_1_1__c, Bullet_DPML_12w_day_CurrQtr_2_1__c, Bullet_DPML_12w_day_CurrQtr_3_1__c, Device_Account_Short_Name__c, ' +
                                     'Fab__c, Geometry__c, Hot_DPML_12w_day_CurrQtr1__c, Total_Lead_Time__c, Hot_DPML_12w_day_CurrQtr__c, Hot_DPML_12w_day_CurrQtr_1__c, Hot_DPML_12w_day_CurrQtr_2__c, Hot_DPML_12w_day_CurrQtr_3__c, ' +
                                     'Hot_DPML_12w_day_CurrQtr_1_1__c, Hot_DPML_12w_day_CurrQtr_2_1__c, Hot_DPML_12w_day_CurrQtr_3_1__c, ML_Count_FEOL_BEOL__c, PF_Adder_day__c, PO_Lead_Time_day__c, Process_Flow_Pid_PT_Id__c, Device_Stage__c, ' +
                                     'Sort_Adder_day__c, Standard_DPML_day_CurrQtr__c, Standard_DPML_day_CurrQtr_1__c, Standard_DPML_day_CurrQtr_2__c, Standard_DPML_day_CurrQtr_3__c ' +
                          'FROM PO_Lead_Time__c LIMIT 1';
            database.executeBatch(new POLeadTimeBatchUpdate(date.newInstance(date.today().year(), 10, 15).addMonths(9)
                                                            , null
                                                            , date.newInstance(date.today().year(), 10, 1)
                                                            , date.newInstance(date.today().year(), 10, 1).addMonths(3)
                                                            , date.newInstance(date.today().year(), 10, 1).addMonths(6)
                                                            , date.newInstance(date.today().year(), 10, 1).addMonths(9)
                                                            , soql
                                                            , 'Standard'
                                                            , new List<string>{'FAB2'}
                                                            , new List<string>()
                                                            , UserInfo.getUserId()));
        test.stopTest();
    }
    
    static testMethod void testPOLeadTimeBatchUpdate17() {
        string testAcctId = POLeadTimeBatchUpdateTest.createAccount();
        POLeadTimeBatchUpdateTest.createSCMCDB(testAcctId);
        test.startTest();
            string soql = 'SELECT Id, Name, Account__c, Account__r.Name, Base_Device__c, Bullet_DPML_12w_day_CurrQtr__c, Bullet_DPML_12w_day_CurrQtr_1__c, Bullet_DPML_12w_day_CurrQtr_2__c, Bullet_DPML_12w_day_CurrQtr_3__c, ' + 
                                     'PO_Raise_Date__c, Goods_Received_Date__c, Bullet_DPML_12w_day_CurrQtr1__c, Bullet_DPML_12w_day_CurrQtr_1_1__c, Bullet_DPML_12w_day_CurrQtr_2_1__c, Bullet_DPML_12w_day_CurrQtr_3_1__c, Device_Account_Short_Name__c, ' +
                                     'Fab__c, Geometry__c, Hot_DPML_12w_day_CurrQtr1__c, Total_Lead_Time__c, Hot_DPML_12w_day_CurrQtr__c, Hot_DPML_12w_day_CurrQtr_1__c, Hot_DPML_12w_day_CurrQtr_2__c, Hot_DPML_12w_day_CurrQtr_3__c, ' +
                                     'Hot_DPML_12w_day_CurrQtr_1_1__c, Hot_DPML_12w_day_CurrQtr_2_1__c, Hot_DPML_12w_day_CurrQtr_3_1__c, ML_Count_FEOL_BEOL__c, PF_Adder_day__c, PO_Lead_Time_day__c, Process_Flow_Pid_PT_Id__c, Device_Stage__c, ' +
                                     'Sort_Adder_day__c, Standard_DPML_day_CurrQtr__c, Standard_DPML_day_CurrQtr_1__c, Standard_DPML_day_CurrQtr_2__c, Standard_DPML_day_CurrQtr_3__c ' +
                          'FROM PO_Lead_Time__c LIMIT 1';
            database.executeBatch(new POLeadTimeBatchUpdate(date.newInstance(date.today().year(), 10, 15).addMonths(9)
                                                            , null
                                                            , date.newInstance(date.today().year(), 10, 1)
                                                            , date.newInstance(date.today().year(), 10, 1).addMonths(3)
                                                            , date.newInstance(date.today().year(), 10, 1).addMonths(6)
                                                            , date.newInstance(date.today().year(), 10, 1).addMonths(9)
                                                            , soql
                                                            , 'BulletLE12'
                                                            , new List<string>{'FAB2'}
                                                            , new List<string>()
                                                            , UserInfo.getUserId()));
        test.stopTest();
    }
    
    static testMethod void testPOLeadTimeBatchUpdate18() {
        string testAcctId = POLeadTimeBatchUpdateTest.createAccount();
        POLeadTimeBatchUpdateTest.createSCMCDB(testAcctId);
        test.startTest();
            string soql = 'SELECT Id, Name, Account__c, Account__r.Name, Base_Device__c, Bullet_DPML_12w_day_CurrQtr__c, Bullet_DPML_12w_day_CurrQtr_1__c, Bullet_DPML_12w_day_CurrQtr_2__c, Bullet_DPML_12w_day_CurrQtr_3__c, ' + 
                                     'PO_Raise_Date__c, Goods_Received_Date__c, Bullet_DPML_12w_day_CurrQtr1__c, Bullet_DPML_12w_day_CurrQtr_1_1__c, Bullet_DPML_12w_day_CurrQtr_2_1__c, Bullet_DPML_12w_day_CurrQtr_3_1__c, Device_Account_Short_Name__c, ' +
                                     'Fab__c, Geometry__c, Hot_DPML_12w_day_CurrQtr1__c, Total_Lead_Time__c, Hot_DPML_12w_day_CurrQtr__c, Hot_DPML_12w_day_CurrQtr_1__c, Hot_DPML_12w_day_CurrQtr_2__c, Hot_DPML_12w_day_CurrQtr_3__c, ' +
                                     'Hot_DPML_12w_day_CurrQtr_1_1__c, Hot_DPML_12w_day_CurrQtr_2_1__c, Hot_DPML_12w_day_CurrQtr_3_1__c, ML_Count_FEOL_BEOL__c, PF_Adder_day__c, PO_Lead_Time_day__c, Process_Flow_Pid_PT_Id__c, Device_Stage__c, ' +
                                     'Sort_Adder_day__c, Standard_DPML_day_CurrQtr__c, Standard_DPML_day_CurrQtr_1__c, Standard_DPML_day_CurrQtr_2__c, Standard_DPML_day_CurrQtr_3__c ' +
                          'FROM PO_Lead_Time__c LIMIT 1';
            database.executeBatch(new POLeadTimeBatchUpdate(date.newInstance(date.today().year(), 10, 15).addMonths(9)
                                                            , null
                                                            , date.newInstance(date.today().year(), 10, 1)
                                                            , date.newInstance(date.today().year(), 10, 1).addMonths(3)
                                                            , date.newInstance(date.today().year(), 10, 1).addMonths(6)
                                                            , date.newInstance(date.today().year(), 10, 1).addMonths(9)
                                                            , soql
                                                            , 'BulletG12'
                                                            , new List<string>{'FAB2'}
                                                            , new List<string>()
                                                            , UserInfo.getUserId()));
        test.stopTest();
    }
    
    static testMethod void testPOLeadTimeBatchUpdate19() {
        string testAcctId = POLeadTimeBatchUpdateTest.createAccount();
        POLeadTimeBatchUpdateTest.createSCMCDB(testAcctId);
        test.startTest();
            string soql = 'SELECT Id, Name, Account__c, Account__r.Name, Base_Device__c, Bullet_DPML_12w_day_CurrQtr__c, Bullet_DPML_12w_day_CurrQtr_1__c, Bullet_DPML_12w_day_CurrQtr_2__c, Bullet_DPML_12w_day_CurrQtr_3__c, ' + 
                                     'PO_Raise_Date__c, Goods_Received_Date__c, Bullet_DPML_12w_day_CurrQtr1__c, Bullet_DPML_12w_day_CurrQtr_1_1__c, Bullet_DPML_12w_day_CurrQtr_2_1__c, Bullet_DPML_12w_day_CurrQtr_3_1__c, Device_Account_Short_Name__c, ' +
                                     'Fab__c, Geometry__c, Hot_DPML_12w_day_CurrQtr1__c, Total_Lead_Time__c, Hot_DPML_12w_day_CurrQtr__c, Hot_DPML_12w_day_CurrQtr_1__c, Hot_DPML_12w_day_CurrQtr_2__c, Hot_DPML_12w_day_CurrQtr_3__c, ' +
                                     'Hot_DPML_12w_day_CurrQtr_1_1__c, Hot_DPML_12w_day_CurrQtr_2_1__c, Hot_DPML_12w_day_CurrQtr_3_1__c, ML_Count_FEOL_BEOL__c, PF_Adder_day__c, PO_Lead_Time_day__c, Process_Flow_Pid_PT_Id__c, Device_Stage__c, ' +
                                     'Sort_Adder_day__c, Standard_DPML_day_CurrQtr__c, Standard_DPML_day_CurrQtr_1__c, Standard_DPML_day_CurrQtr_2__c, Standard_DPML_day_CurrQtr_3__c ' +
                          'FROM PO_Lead_Time__c LIMIT 1';
            database.executeBatch(new POLeadTimeBatchUpdate(date.newInstance(date.today().year(), 10, 15).addMonths(9)
                                                            , null
                                                            , date.newInstance(date.today().year(), 10, 1)
                                                            , date.newInstance(date.today().year(), 10, 1).addMonths(3)
                                                            , date.newInstance(date.today().year(), 10, 1).addMonths(6)
                                                            , date.newInstance(date.today().year(), 10, 1).addMonths(9)
                                                            , soql
                                                            , 'HotLE12'
                                                            , new List<string>{'FAB2'}
                                                            , new List<string>()
                                                            , UserInfo.getUserId()));
        test.stopTest();
    }
    
    static testMethod void testPOLeadTimeBatchUpdate20() {
        string testAcctId = POLeadTimeBatchUpdateTest.createAccount();
        POLeadTimeBatchUpdateTest.createSCMCDB(testAcctId);
        test.startTest();
            string soql = 'SELECT Id, Name, Account__c, Account__r.Name, Base_Device__c, Bullet_DPML_12w_day_CurrQtr__c, Bullet_DPML_12w_day_CurrQtr_1__c, Bullet_DPML_12w_day_CurrQtr_2__c, Bullet_DPML_12w_day_CurrQtr_3__c, ' + 
                                     'PO_Raise_Date__c, Goods_Received_Date__c, Bullet_DPML_12w_day_CurrQtr1__c, Bullet_DPML_12w_day_CurrQtr_1_1__c, Bullet_DPML_12w_day_CurrQtr_2_1__c, Bullet_DPML_12w_day_CurrQtr_3_1__c, Device_Account_Short_Name__c, ' +
                                     'Fab__c, Geometry__c, Hot_DPML_12w_day_CurrQtr1__c, Total_Lead_Time__c, Hot_DPML_12w_day_CurrQtr__c, Hot_DPML_12w_day_CurrQtr_1__c, Hot_DPML_12w_day_CurrQtr_2__c, Hot_DPML_12w_day_CurrQtr_3__c, ' +
                                     'Hot_DPML_12w_day_CurrQtr_1_1__c, Hot_DPML_12w_day_CurrQtr_2_1__c, Hot_DPML_12w_day_CurrQtr_3_1__c, ML_Count_FEOL_BEOL__c, PF_Adder_day__c, PO_Lead_Time_day__c, Process_Flow_Pid_PT_Id__c, Device_Stage__c, ' +
                                     'Sort_Adder_day__c, Standard_DPML_day_CurrQtr__c, Standard_DPML_day_CurrQtr_1__c, Standard_DPML_day_CurrQtr_2__c, Standard_DPML_day_CurrQtr_3__c ' +
                          'FROM PO_Lead_Time__c LIMIT 1';
            database.executeBatch(new POLeadTimeBatchUpdate(date.newInstance(date.today().year(), 10, 15).addMonths(9)
                                                            , null
                                                            , date.newInstance(date.today().year(), 10, 1)
                                                            , date.newInstance(date.today().year(), 10, 1).addMonths(3)
                                                            , date.newInstance(date.today().year(), 10, 1).addMonths(6)
                                                            , date.newInstance(date.today().year(), 10, 1).addMonths(9)
                                                            , soql
                                                            , 'HotG12'
                                                            , new List<string>{'FAB2'}
                                                            , new List<string>()
                                                            , UserInfo.getUserId()));
                                                            
        test.stopTest();
    }
    
      
    private static Account getAccount(string AccountName)
            {
                Account testAcct= [SELECT Id, Name FROM Account Where Name =: AccountName];
        
                return testAcct;
            }  
}