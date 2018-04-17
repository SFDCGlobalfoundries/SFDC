/**
    Author: Abhita Bansal
    Created Date: 24/08/2015 
    Description: Test class for MPWSeachReservationFormController
    History
    Abansal     24/08/2015      Code Created
    SNair       18/10/2015      Modified logic
 */
@isTest(SeeAllData=false)
private class MPWSeachReservationControllerTest {

    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        User thisUser = [select Id from User where Profile.Name ='GF Sales User' and isActive = true and UserRoleId != null limit 1];
         List<Map<String,Object>>  fieldValueMapList = new List<Map<String,Object>>();
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
            fieldValueMap.put('Fab_9_10__c','no');
            fieldValueMap.put('ownerId',thisUser.Id);
            fieldValueMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER'));
    
            fieldValueMapList.add(fieldValueMap);
        }
        Test.startTest();
        AccountDataFactory.createAccounts(fieldValueMapList,2);
        Test.stopTest();
    }
    
    private static Account utilDataAccMethod() {
    
        Account account = getAccount('MYTEST ACCOUNT1');
        return account;
        
        
    }
    
    private static Account utilDataAccMethod1(Account account) {
    
       Account account1 = getAccount('MYTEST ACCOUNT2');
                       
        return account1;
    }
    
    private static Account_Hierarchy__c utilDataAccHMethod(Account account , Account account1) {
        
        Account_Hierarchy__c mpwAccountH = new Account_Hierarchy__c();
        mpwAccountH.Account_Id__c = account1.Id;
        mpwAccountH.Parent_Id__c = account.Id;
        insert mpwAccountH;
        
        return mpwAccountH;
    }
    
    private static Contact utilDataConMethod(Account account) {
    
        Contact con = new Contact();
        con.FirstName = 'FirstName';
        con.LastName = 'LastName';
        con.AccountId = account.Id;
        con.Email = 'test1@test.com';
        con.Department__c='Design';
        insert con;  
        
        return con;
    }
    
    private static User utilDataUserMethod(Contact con) {
        
        User u = new User();
        u.LastName = 'LastName';
        u.Alias = 'Test1';
        u.Email = 'test1@test.com';
        u.LanguageLocaleKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        u.LocaleSidKey = 'en_US';
        u.ProfileId = [Select Id,Name from Profile where Name = 'Customer Portal Admin'].Id;
        u.TimeZoneSidKey = 'America/Los_Angeles';
        u.UserName = 'test1@test.com.mpwdev';
        u.Portal_login__c = 'xyz';
        u.ContactId = con.Id;
        u.IsActive = true;
        u.CommunityNickname = 'Testtest123';
        Profile pp = [Select Id from Profile where Name='System Administrator']; 
        User ur = [Select Id, Name,IsActive from User where IsActive=true AND userRoleId != null and ContactId = null and ProfileID=:pp.Id Limit 1];
        system.runas(ur){
            insert u;
        }
        
        return u;
    }
    
    private static List<Account_Team_Proxy__c> utilDataAPMethod(Account account) {
        
        List<User> userAppMatrix = [select Id from User where Profile.Name = 'GF PIYE Platform' and isActive = true limit 3];
        
        List<Account_Team_Proxy__c> accProxyList =  new List<Account_Team_Proxy__c>();
        
        Account_Team_Proxy__c accProxy = new Account_Team_Proxy__c();
        accProxy.Account__c = account.Id;
        accProxy.Team_Role__c = 'Primary Account Manager';
        accProxy.User__c = userAppMatrix[0].Id;
        accProxy.Account_Access__c = 'Read/Write';
        accProxyList.add(accProxy);
        
        Account_Team_Proxy__c accProxy1 = new Account_Team_Proxy__c();
        accProxy1.Account__c = account.Id;
        accProxy1.Team_Role__c = 'Primary Customer Service Rep';
        accProxy1.User__c = userAppMatrix[1].Id;
        accProxy1.Account_Access__c = 'Read/Write';
        accProxyList.add(accProxy1);
        
        Account_Team_Proxy__c accProxy2 = new Account_Team_Proxy__c();
        accProxy2.Account__c = account.Id;
        accProxy2.Team_Role__c = 'Field Application Engineer';
        accProxy2.User__c = userAppMatrix[2].Id;
        accProxy2.Account_Access__c = 'Read/Write';
        accProxyList.add(accProxy2);
        
        if(!accProxyList.isEmpty()){
            insert accProxyList;
        }       
        
        return accProxyList;
    }
    
    private static MPW_Config_Settings__c utilDataCSMethod() {
        
        MPW_Config_Settings__c mpwConfig = new MPW_Config_Settings__c();
        mpwConfig.Active__c = true;
        mpwConfig.Geometry__c = '28nm';
        mpwConfig.Name = '28nmLP';
        insert mpwConfig;
        
        return mpwConfig;
    }
    
    private static MPW_Tech_Module__c utilDataTeMMethod() {
        
        MPW_Tech_Module__c mpwTechModule = new MPW_Tech_Module__c();
        mpwTechModule.Active__c = true;
        mpwTechModule.Answers__c = 'Yes;No';
        mpwTechModule.Geometry__c = '28nm';
        mpwTechModule.Module_Description__c = 'N3';
        mpwTechModule.Module_Name__c = 'Triple well';
        mpwTechModule.Question__c = 'Do you need Triple well?:';
        insert mpwTechModule;
        
        return mpwTechModule;
    }
    
    private static MPW_Train_Maintenance__c utilDataTMMethod() {
        
        MPW_Train_Maintenance__c mpwTrain = new MPW_Train_Maintenance__c();
        mpwTrain.Active__c = true;
        mpwTrain.Publish__c = true;
        mpwTrain.Train_Type__c = 'GlobalShuttle';
        mpwTrain.Geometry__c = '28nm';
        mpwTrain.Train_Number__c = 'MPW03312';
        mpwTrain.Reservation_Close_Date__c = System.today();
        mpwTrain.Projected_1st_Batch_Bare_Die_Ship_Start__c = System.today()+10;
        mpwTrain.Projected_1st_Batch_Bare_Die_Ship_End__c = System.today()+10;
        mpwTrain.Lot_Start_Date__c = System.today() +10;
        mpwTrain.Tapeout_Date_Customer__c = System.today() + 6;
        mpwTrain.Fab__c = 'Fab1';
        mpwTrain.Status__c = '28LPSe, 28LPS, 28LPS-RF';
        insert mpwTrain;
        
        return mpwTrain;
    }
    
    private static MPW_Train_Maintenance_Details__c utilDataTMDMethod(MPW_Tech_Module__c mpwTechModule, MPW_Train_Maintenance__c mpwTrain, MPW_Config_Settings__c mpwConfig) {
        
        MPW_Train_Maintenance_Details__c mpwTrainDetails = new MPW_Train_Maintenance_Details__c();
        mpwTrainDetails.Answers__c = 'Yes;No';
        mpwTrainDetails.MPW_Tech_Module__c = mpwTechModule.Id;
        mpwTrainDetails.MPW_Train_Maintenance__c = mpwTrain.Id;
        mpwTrainDetails.Process_Type__c = mpwConfig.Id;
        insert mpwTrainDetails;
        
        return mpwTrainDetails;
    }
    
    private static MPW_Prime_Die__c utilDataPDMethod(MPW_Reservation__c mpwReservation1) {
        
        MPW_Prime_Die__c mpwPrimeDie1 = new MPW_Prime_Die__c();
        mpwPrimeDie1.Prime_Die_Name__c = 'TestComapre1';
        mpwPrimeDie1.MPW_Form__c = mpwReservation1.Id;
        mpwPrimeDie1.Drawn_Die_Size_X_um__c = '1234';
        mpwPrimeDie1.Drawn_Die_Size_Y_um__c = '2344';
        mpwPrimeDie1.Device_Type__c = 'Product';
        mpwPrimeDie1.Delivery_Qty_Die_Form__c = '100';
        mpwPrimeDie1.Delivery_Qty_Wafer_Form__c = '2';
        mpwPrimeDie1.Drawn_Orientation_Restricted_Structures__c= 'Test';
        mpwPrimeDie1.Metal_Stack__c = 'Test';
        mpwPrimeDie1.Corner_Split__c = 'No';
        mpwPrimeDie1.FF__c = '0';
        mpwPrimeDie1.FS__c = '0';
        mpwPrimeDie1.POR__c = '0';
        mpwPrimeDie1.SF__c = '0';
        mpwPrimeDie1.SS__c = '0';
        mpwPrimeDie1.GMPL_Purpose__c = 'Test';
        mpwPrimeDie1.ShortLoop_Wafer__c = '4';
        mpwPrimeDie1.Backgrind__c = '10';
        mpwPrimeDie1.Expedite_In_DIE_Form__c = '100';
        mpwPrimeDie1.Expedite_In_WAFER_Form__c = '5';
        mpwPrimeDie1.Turnkey_Service__c = 'No';
        insert mpwPrimeDie1;
        
        return mpwPrimeDie1;
    }
    
    public static testMethod void mySearchReservationMethod1() {
        
        MPW_Config_Settings__c mpwConfig = utilDataCSMethod();      
        MPW_Tech_Module__c mpwTechModule = utilDataTeMMethod();
        MPW_Train_Maintenance__c mpwTrain = utilDataTMMethod();
        MPW_Train_Maintenance_Details__c mpwTrainDetails = utilDataTMDMethod(mpwTechModule, mpwTrain, mpwConfig);
        
        MPW_Reservation__c mpwReservation1 = new MPW_Reservation__c();        
        mpwReservation1.MPW_Train_Name__c = mpwTrain.Id;
        mpwReservation1.Name = '2015-03-05600';
        mpwReservation1.Form_Status__c = 'Draft';
        mpwReservation1.Category__c = 'FAB';
        mpwReservation1.Usage__c = 'Required';
        mpwReservation1.Prime_Die_Name__c = 'TestComapre1';
        mpwReservation1.Process_Type__c = mpwConfig.Id;
        insert mpwReservation1;
        
        MPW_Prime_Die__c mpwPrimeDie1 = utilDataPDMethod(mpwReservation1);
        
        Test.startTest();            
        
        Test.setCurrentPageReference(new PageReference('Page.MPWSearchReservationFormVF'));
        MPWSeachReservationFormController controller = new MPWSeachReservationFormController(new ApexPages.Standardcontroller(new MPW_Reservation__c()));
        controller.exportCsvFile();
        
        Test.stopTest();   
    }
    
    public static testMethod void mySearchReservationMethod2() {
    
        List<User> userAppMatrix = [select Id from User where Profile.Name = 'GF PIYE Platform' and isActive = true limit 13];
        //Test.startTest(); 
        Account account = utilDataAccMethod();
        Account account1 = utilDataAccMethod1(account);
        Account_Hierarchy__c mpwAccountH = utilDataAccHMethod(account, account1);
        Contact con = utilDataConMethod(account);
        User u = utilDataUserMethod(con);
        List<Account_Team_Proxy__c> accProxyList = utilDataAPMethod(account); 
        MPW_Config_Settings__c mpwConfig = utilDataCSMethod();      
        MPW_Tech_Module__c mpwTechModule = utilDataTeMMethod();
        MPW_Train_Maintenance__c mpwTrain = utilDataTMMethod();
        MPW_Train_Maintenance_Details__c mpwTrainDetails = utilDataTMDMethod(mpwTechModule, mpwTrain, mpwConfig);                  
        
        Test.startTest(); 
       
            MPW_Reservation__c mpwReservation1 = new MPW_Reservation__c();        
            mpwReservation1.MPW_Train_Name__c = mpwTrain.Id;
            mpwReservation1.Name = '2015-03-05600';
            mpwReservation1.Form_Status__c = 'Accepted by MPW Tapeout';
            mpwReservation1.Category__c = 'Customer';
            mpwReservation1.Customer_Company_Name__c = account.Id;
            mpwReservation1.FE_Name__c = userAppMatrix[0].Id;
            mpwReservation1.CSR_Name__c = userAppMatrix[1].Id;
            mpwReservation1.AM_Name__c = userAppMatrix[2].Id;
            mpwReservation1.Step_1_Approver_1__c = userAppMatrix[3].Id;
            mpwReservation1.Step_1_Approver_2__c = userAppMatrix[4].Id;
            mpwReservation1.Step_1_Approver_3__c = userAppMatrix[5].Id;
            mpwReservation1.Step_1_Approver_4__c = userAppMatrix[6].Id;
            mpwReservation1.Step_1_Approver_5__c = userAppMatrix[7].Id;
            mpwReservation1.Step_1_Approver_6__c = userAppMatrix[8].Id;
            mpwReservation1.Step_1_Approver_7__c = userAppMatrix[9].Id;
            mpwReservation1.Step_1_Approver_8__c = userAppMatrix[10].Id;
            mpwReservation1.Step_1_Approver_9__c = userAppMatrix[11].Id;
            mpwReservation1.Step_1_Approver_10__c = userAppMatrix[12].Id;
            mpwReservation1.Usage__c = 'Required';
            mpwReservation1.Prime_Die_Name__c = 'TestComapre1';
            insert mpwReservation1;
        //Test.startTest(); 
            system.runAs(u){
                Test.setCurrentPageReference(new PageReference('Page.MPWSearchReservationFormVF'));
                MPWSeachReservationFormController controller = new MPWSeachReservationFormController(new ApexPages.Standardcontroller(new MPW_Reservation__c()));
                controller.mpwResf.Name = '2015-03-05600';
                controller.geometrySelectedValue = '28nm';
                controller.getGeometryValues();
                controller.geometrySelected();
                controller.getProcessValues();
                controller.searchMethod();
                controller.exportCsvFile();
                System.currentPageReference().getParameters().put('sortField', 'Geometry__c');
                controller.sortRecords();
            }
           
            Test.stopTest();   
    }
    
    public static testMethod void mySearchReservationMethod3() {
    
        List<User> userAppMatrix = [select Id from User where Profile.Name = 'GF PIYE Platform' and isActive = true limit 3];
       // Test.startTest();
        Account account = utilDataAccMethod();
        Account account1 = utilDataAccMethod1(account);
        Account_Hierarchy__c mpwAccountH = utilDataAccHMethod(account, account1);
        Contact con = utilDataConMethod(account);
        User u = utilDataUserMethod(con);
        List<Account_Team_Proxy__c> accProxyList = utilDataAPMethod(account); 
        MPW_Config_Settings__c mpwConfig = utilDataCSMethod();      
        MPW_Tech_Module__c mpwTechModule = utilDataTeMMethod();
        MPW_Train_Maintenance__c mpwTrain = utilDataTMMethod();
        MPW_Train_Maintenance_Details__c mpwTrainDetails = utilDataTMDMethod(mpwTechModule, mpwTrain, mpwConfig);                  
        
        Test.startTest();
        
        List<MPW_Reservation__c> lstReservation = new List<MPW_Reservation__c>();
        MPW_Reservation__c mpwReservation1 = new MPW_Reservation__c();        
        mpwReservation1.MPW_Train_Name__c = mpwTrain.Id;
        mpwReservation1.Name = '2015-03-05600';
        mpwReservation1.Form_Status__c = 'Pending FAE Review';
        mpwReservation1.Category__c = 'Customer';
        mpwReservation1.Customer_Company_Name__c = account.Id;
        mpwReservation1.Usage__c = 'Required';
        mpwReservation1.Prime_Die_Name__c = 'TestComapre1';
        lstReservation.add(mpwReservation1);
        
        MPW_Reservation__c mpwReservation2 = new MPW_Reservation__c();        
        mpwReservation2.MPW_Train_Name__c = mpwTrain.Id;
        mpwReservation2.Name = '2015-03-05601';
        mpwReservation2.Form_Status__c = 'Pending FAE Review';
        mpwReservation2.Category__c = 'Customer';
        mpwReservation2.Customer_Company_Name__c = account.Id;
        mpwReservation2.Usage__c = 'Required';
        mpwReservation2.Prime_Die_Name__c = 'TestComapre1';
        lstReservation.add(mpwReservation2);
        
        MPW_Reservation__c mpwReservation3 = new MPW_Reservation__c();        
        mpwReservation3.MPW_Train_Name__c = mpwTrain.Id;
        mpwReservation3.Name = '2015-03-05602';
        mpwReservation3.Form_Status__c = 'Pending FAE Review';
        mpwReservation3.Category__c = 'Customer';
        mpwReservation3.Customer_Company_Name__c = account.Id;
        mpwReservation3.Usage__c = 'Required';
        mpwReservation3.Prime_Die_Name__c = 'TestComapre1';
        lstReservation.add(mpwReservation3);
        
        insert lstReservation;
        
        //Test.startTest();
        Test.setCurrentPageReference(new PageReference('Page.MPWSearchReservationFormVF'));
        
            MPWSeachReservationFormController controller = new MPWSeachReservationFormController(new ApexPages.Standardcontroller(new MPW_Reservation__c()));
            controller.mpwResf.Name = '2015-03-05600';
            controller.mpwResf.Form_Status__c = 'Draft';
            controller.geometrySelectedValue  = '28nm';
            controller.mpwResf.Process_Type__c = mpwConfig.Id;
            controller.mpwName = 'MPW03312';
            controller.feName = Userinfo.getUserId();
            controller.custCompanyName = 'Test';
            controller.csrName = Userinfo.getUserId();
            controller.ownerName = Userinfo.getUserId();
            controller.selectedVal= '1';
            controller.searchMethod();
            controller.getNext();
            controller.getPrevious();
            controller.getFirst();
            controller.getLast();
            
        Test.stopTest();   
    }
    
     private static Account getAccount(string AccountName)
            {
                Account testAcct= [SELECT Id, Name FROM Account Where Name =: AccountName];
        
                return testAcct;
            }  
}