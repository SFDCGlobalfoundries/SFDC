/*
    Author: Shyam Ravindra Nair
    Description: serves as test class for MPWReservationFormTriggerHandler class.
    History: 
        SNair      02092015    - Code creation.
*/
@isTest(SeeAllData=false)
public class MPWReservationFormTriggerHandlerTest {

    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
    }
    
    private static MPW_Geometry_Mapping__c utilDataGMMethod() {
        
        MPW_Geometry_Mapping__c mpwGeoMap = new MPW_Geometry_Mapping__c();
        mpwGeoMap.Name = '28nm';
        mpwGeoMap.Geometry_ID__c = '0.028UM';    
        mpwGeoMap.Active__c = true;
        mpwGeoMap.Use_Process_Type__c  = true;
        insert mpwGeoMap;
        
        return mpwGeoMap;
    }   
    
    private static Customer_Guideline_Factor__c utilDataCGFMethod() {
    
        Customer_Guideline_Factor__c customerGF = new Customer_Guideline_Factor__c();
        customerGF.Adder3__c = 0;
        customerGF.Expedite__c = 12000;
        customerGF.ExtraDice_B__c = 12000;
        customerGF.Option2__c = 0;
        customerGF.RecticalSpace_A1__c = 10000;
        customerGF.ReticleSpace_Min__c = 90800;
        customerGF.ShortLoop_Wafer__c = 1500;
        customerGF.Sub_Devices_Extraction__c = 109;
        customerGF.Tech_ID__c = '0.028UM';
        customerGF.TechNodes__c = '28nm';
        customerGF.Wafer_Form_Delivery__c = 12788;
        insert customerGF;
        
        return customerGF;
    } 

    private static Internal_Guideline_Factor__c utilDataIGFMethod() {
    
        Internal_Guideline_Factor__c internalGF = new Internal_Guideline_Factor__c();
        internalGF.DieToWaferConv__c = '16000';
        internalGF.Reticle__c = 12000;
        internalGF.Wafer__c= 12000;
        internalGF.TechID__c = '0.028UM';
        internalGF.Tech_Node__c = '28nm';
        insert internalGF;
        
        return internalGF;
    }   
    
    private static MPW_Train_Maintenance__c utilDataTMMethod() {
    
        MPW_Train_Maintenance__c mpwTrainMaintenance = new MPW_Train_Maintenance__c();
        mpwTrainMaintenance.Name = 'MPW0311';
        mpwTrainMaintenance.Geometry__c = '28nm';
        mpwTrainMaintenance.Publish__c = true;
        mpwTrainMaintenance.Active__c = true;
        mpwTrainMaintenance.Reservation_Close_Date__c = System.today()+10;
        mpwTrainMaintenance.Tapeout_Date_Other_Participant__c = System.today();
        mpwTrainMaintenance.Train_Type__c = 'GlobalShuttle';
        mpwTrainMaintenance.Geometry_ID__c = '0.028UM';
        mpwTrainMaintenance.Tapeout_Date_Customer__c = System.today();
        insert mpwTrainMaintenance;
        
        return mpwTrainMaintenance;
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
    
    private static Account utilDataAccMethod() {
        Account a= new Account();
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MYTEST ACCOUNT1');            
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
        a= AccountDataFactory.createAccount(fieldValueMap);
        return a;
    }  
    
    private static List<Account_Team_Proxy__c> utilDataAccPMethod(Account a) {
        
        List<Account_Team_Proxy__c> accountProxyList =  new List<Account_Team_Proxy__c>();
        
        List<User> userAppMatrix = [select Id from User where Profile.Name = 'GF PIYE Platform' and isActive = true limit 5];
        
        Account_Team_Proxy__c accProxy = new Account_Team_Proxy__c();
        accProxy.Account__c = a.Id;
        accProxy.Team_Role__c = 'Primary Account Manager';
        accProxy.User__c = userAppMatrix[0].Id;
        accProxy.Account_Access__c = 'Read/Write';
        insert accProxy;
        accountProxyList.add(accProxy);
        
        Account_Team_Proxy__c accProxy1 = new Account_Team_Proxy__c();
        accProxy1.Account__c = a.Id;
        accProxy1.Team_Role__c = 'Primary Customer Service Rep';
        accProxy1.User__c = userAppMatrix[1].Id;
        accProxy1.Account_Access__c = 'Read/Write';
        insert accProxy1;
        accountProxyList.add(accProxy1);
        
        Account_Team_Proxy__c accProxy2 = new Account_Team_Proxy__c();
        accProxy2.Account__c = a.Id;
        accProxy2.Team_Role__c = 'Field Application Engineer';
        accProxy2.User__c = userAppMatrix[2].Id;
        accProxy2.Account_Access__c = 'Read/Write';
        insert accProxy2;
        accountProxyList.add(accProxy2);
        
        Account_Team_Proxy__c accProxy3 = new Account_Team_Proxy__c();
        accProxy3.Account__c = a.Id;
        accProxy3.Team_Role__c = 'Customer Service Rep';
        accProxy3.User__c = userAppMatrix[3].Id;
        accProxy3.Account_Access__c = 'Read/Write';
        insert accProxy3;
        accountProxyList.add(accProxy3);
        
        Account_Team_Proxy__c accProxy4 = new Account_Team_Proxy__c();
        accProxy4.Account__c = a.Id;
        accProxy4.Team_Role__c = 'Customer Service Rep';
        accProxy4.User__c = userAppMatrix[4].Id;
        accProxy4.Account_Access__c = 'Read/Write';
        insert accProxy4;
        accountProxyList.add(accProxy4);
        
        return accountProxyList;
    }    
    
    public static testMethod void myReservationFormMethod(){
    
        MPW_Geometry_Mapping__c mpwGeoMap = utilDataGMMethod();
        Customer_Guideline_Factor__c customerGF = utilDataCGFMethod();
        Internal_Guideline_Factor__c internalGF = utilDataIGFMethod();
        MPW_Train_Maintenance__c mpwTrainMaintenance = utilDataTMMethod();
        
        MPW_Reservation__c mpwReservation1 = new MPW_Reservation__c();        
        mpwReservation1.MPW_Train_Name__c = mpwTrainMaintenance.Id;
        mpwReservation1.Name = '2015-03-05600';
        mpwReservation1.Form_Status__c = 'Pending Internal Budget Owner Approval';
        mpwReservation1.Category__c = 'Customer';
        mpwReservation1.Usage__c = 'Required';
        mpwReservation1.Prime_Die_Name__c = 'TestComapre1';
        insert mpwReservation1;
        
        MPW_Prime_Die__c mpwPrimeDie1 = utilDataPDMethod(mpwReservation1);
        
        Test.startTest();
            
            mpwReservation1.Form_Status__c = 'Accepted by MPW Tapeout';
            update mpwReservation1;
        
        Test.stopTest() ; 
    }
    
    public static testMethod void myReservationFormMethod1(){
    
        MPW_Geometry_Mapping__c mpwGeoMap = utilDataGMMethod();
        Customer_Guideline_Factor__c customerGF = utilDataCGFMethod();
        Internal_Guideline_Factor__c internalGF = utilDataIGFMethod();
        MPW_Train_Maintenance__c mpwTrainMaintenance = utilDataTMMethod();      
        
        MPW_Reservation__c mpwReservation1 = new MPW_Reservation__c();        
        mpwReservation1.MPW_Train_Name__c = mpwTrainMaintenance.Id;
        mpwReservation1.Name = '2015-03-05600';
        mpwReservation1.Form_Status__c = 'Accepted by MPW Tapeout';
        mpwReservation1.Category__c = 'Customer';
        mpwReservation1.Usage__c = 'Required';
        mpwReservation1.Prime_Die_Name__c = 'TestComapre1';
        insert mpwReservation1;
        
        MPW_Prime_Die__c mpwPrimeDie1 = utilDataPDMethod(mpwReservation1);
        
        Test.startTest();
            
            mpwReservation1.Form_Status__c = 'Void';
            update mpwReservation1;
        
        Test.stopTest() ; 
    }
    
    public static testMethod void myReservationFormMethod2(){
        
        List<User> userAppMatrix = [select Id,Email from User where Profile.Name = 'GF PIYE Platform' and isActive = true limit 5];
        
        MPW_Geometry_Mapping__c mpwGeoMap = utilDataGMMethod();
        Account a = utilDataAccMethod();    
        List<Account_Team_Proxy__c> accountProxyList = utilDataAccPMethod(a);
        MPW_Train_Maintenance__c mpwTrainMaintenance = utilDataTMMethod();      
        
        MPW_Reservation__c mpwReservation1 = new MPW_Reservation__c();            
        mpwReservation1.MPW_Train_Name__c = mpwTrainMaintenance.Id;
        mpwReservation1.Name = '2015-03-05600';
        mpwReservation1.Form_Status__c = 'Accepted by MPW Tapeout';
        mpwReservation1.Category__c = 'Customer';
        mpwReservation1.Usage__c = 'Required';
        mpwReservation1.Prime_Die_Name__c = 'TestComapre1';
        mpwReservation1.Customer_Company_Name__c = a.Id;
        mpwReservation1.AM_Name__c = userAppMatrix[1].Id;
        mpwReservation1.CSR_Name__c = userAppMatrix[2].Id;
        mpwReservation1.FE_Name__c = userAppMatrix[3].Id;
        mpwReservation1.SendQuotation_Close_CancellationReminder__c = false;
        mpwReservation1.SendPurchaseOrderReminder__c = false;
        mpwReservation1.SendSalesOrderNumberReminder__c = false;
        mpwReservation1.SendRevisionEmailCustomerReminder__c = false;
        mpwReservation1.SendRevisionEmailInternalReminder__c = false;
        insert mpwReservation1;       

    Test.startTest();
        MPW_Prime_Die__c mpwPrimeDie1 = utilDataPDMethod(mpwReservation1);
        
        
           System.debug('******Test Class****'+mpwReservation1.OwnerId);
           mpwReservation1.SendQuotation_Close_CancellationReminder__c = true;
           mpwReservation1.SendPurchaseOrderReminder__c = true;
           mpwReservation1.SendSalesOrderNumberReminder__c = true;
           update mpwReservation1;
        
        Test.stopTest() ; 
    }
    
    public static testMethod void myReservationFormMethod3(){
        
        List<User> userAppMatrix = [select Id,Email from User where Profile.Name = 'GF PIYE Platform' and isActive = true limit 5];
        
        MPW_Geometry_Mapping__c mpwGeoMap = utilDataGMMethod();
        Account a = utilDataAccMethod(); 
        Environment_Variable__c env = [select id,name,value__c from Environment_Variable__c where name='HCM Emp AccountId'];
        env.value__c=a.Id;
        update env;  
         
        List<Account_Team_Proxy__c> accountProxyList = utilDataAccPMethod(a);
        MPW_Train_Maintenance__c mpwTrainMaintenance = utilDataTMMethod();    
        
        HCM_Employee__c hcmEmp = new HCM_Employee__c();
        hcmEmp.First_Name__c = 'Test';
        hcmEmp.Last_Name__c = 'LastName';
        hcmEmp.Employee_ID__c = '1012012';
        hcmEmp.Login_ID__c = '1089';
        hcmEmp.Email_Address__c = 'test1@test.com';
        //insert hcmEmp;
        
        User u = new User();
        u.LastName = 'LastName';
        u.FirstName = 'Test';
        u.Alias = 'Test1';
        u.Email = 'test1@test.com';
        u.LanguageLocaleKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        u.LocaleSidKey = 'en_US';
        u.ProfileId = [Select Id,Name from Profile where Name = 'GF PIYE Platform'].Id;
        u.TimeZoneSidKey = 'America/Los_Angeles';
        u.UserName = 'test1@test.com.mpwdev';
        //u.FederationIdentifier = '1012012';     
        u.IsActive = true;
        u.CommunityNickname = 'Testtest123';
       // insert u;  
        
        System.runAs(userAppMatrix[0]) {
            MPW_Reservation__c mpwReservation1 = new MPW_Reservation__c();            
            mpwReservation1.MPW_Train_Name__c = mpwTrainMaintenance.Id;
            mpwReservation1.Name = '2015-03-05600';
            mpwReservation1.Form_Status__c = 'Accepted by MPW Tapeout';
            mpwReservation1.Category__c = 'FAB';
            mpwReservation1.Usage__c = 'Required';
            mpwReservation1.Prime_Die_Name__c = 'TestComapre1';
            mpwReservation1.AM_Name__c = userAppMatrix[1].Id;
            mpwReservation1.CSR_Name__c = userAppMatrix[2].Id;
            mpwReservation1.FE_Name__c = userAppMatrix[3].Id;
            mpwReservation1.SendRevisionEmailInternalReminder__c = false;
            Test.startTest();
            insert mpwReservation1;       
    
            MPW_Prime_Die__c mpwPrimeDie1 = utilDataPDMethod(mpwReservation1);
        
        
           //mpwReservation1.SendRevisionEmailCustomerReminder__c = true;
           mpwReservation1.SendRevisionEmailInternalReminder__c = true;
           update mpwReservation1;
        
        Test.stopTest() ; 
        }
    }
    
    public static testMethod void myReservationFormMethod4(){
        
        List<User> userAppMatrix = [select Id,Email from User where Profile.Name = 'GF PIYE Platform' and isActive = true limit 5];
        
        MPW_Geometry_Mapping__c mpwGeoMap = utilDataGMMethod();
        Account a = utilDataAccMethod();    
        Environment_Variable__c env = [select id,name,value__c from Environment_Variable__c where name='HCM Emp AccountId'];
        env.value__c=a.Id;
        update env;
        List<Account_Team_Proxy__c> accountProxyList = utilDataAccPMethod(a);
        MPW_Train_Maintenance__c mpwTrainMaintenance = utilDataTMMethod();    
        
        HCM_Employee__c hcmEmp = new HCM_Employee__c();
        hcmEmp.First_Name__c = 'Test';
        hcmEmp.Last_Name__c = 'LastName';
        hcmEmp.Employee_ID__c = '1012012';
        hcmEmp.Login_ID__c = '1089';
        hcmEmp.Email_Address__c = 'test1@test.com';
        //insert hcmEmp;
        
        User u = new User();
        u.LastName = 'LastName';
        u.FirstName = 'Test';
        u.Alias = 'Test1';
        u.Email = 'test1@test.com';
        u.LanguageLocaleKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        u.LocaleSidKey = 'en_US';
        u.ProfileId = [Select Id,Name from Profile where Name = 'GF PIYE Platform'].Id;
        u.TimeZoneSidKey = 'America/Los_Angeles';
        u.UserName = 'test1@test.com.mpwdev';
      //  u.FederationIdentifier = '1012012';     
        u.IsActive = true;
        u.CommunityNickname = 'Testtest123';
        //insert u;  
        
        System.runAs(userAppMatrix[0]) {
            MPW_Reservation__c mpwReservation1 = new MPW_Reservation__c();            
            mpwReservation1.MPW_Train_Name__c = mpwTrainMaintenance.Id;
            mpwReservation1.Name = '2015-03-05600';
            mpwReservation1.Form_Status__c = 'Accepted by MPW Tapeout';
            mpwReservation1.Category__c = 'Customer';
            mpwReservation1.Usage__c = 'Required';
            mpwReservation1.Prime_Die_Name__c = 'TestComapre1';
            mpwReservation1.AM_Name__c = userAppMatrix[1].Id;
            mpwReservation1.CSR_Name__c = userAppMatrix[2].Id;
            mpwReservation1.FE_Name__c = userAppMatrix[3].Id;
            mpwReservation1.SendRevisionEmailCustomerReminder__c = false;
            Test.startTest();
            insert mpwReservation1;       
    
            MPW_Prime_Die__c mpwPrimeDie1 = utilDataPDMethod(mpwReservation1);
        
        
           mpwReservation1.SendRevisionEmailCustomerReminder__c = true;
           update mpwReservation1;
        
        Test.stopTest() ; 
        }
    }
    
    public static testMethod void myReservationFormMethod5(){
    
        MPW_Geometry_Mapping__c mpwGeoMap = utilDataGMMethod();
        Customer_Guideline_Factor__c customerGF = utilDataCGFMethod();
        Internal_Guideline_Factor__c internalGF = utilDataIGFMethod();
        MPW_Train_Maintenance__c mpwTrainMaintenance = utilDataTMMethod();
        
        MPW_Reservation__c mpwReservation1 = new MPW_Reservation__c();        
        mpwReservation1.MPW_Train_Name__c = mpwTrainMaintenance.Id;
        mpwReservation1.Name = '2015-03-05600';
        mpwReservation1.Form_Status__c = 'Pending Internal Budget Owner Approval';
        mpwReservation1.Category__c = 'Customer';
        mpwReservation1.Usage__c = 'Required';
        mpwReservation1.Prime_Die_Name__c = 'TestComapre1';
        mpwReservation1.Sales_Order__c = 'Test';
        Test.startTest();
        insert mpwReservation1;
        
        MPW_Prime_Die__c mpwPrimeDie1 = utilDataPDMethod(mpwReservation1);
        
        
            
            mpwReservation1.Sales_Order__c = 'Test1';
            update mpwReservation1;
        
        Test.stopTest() ; 
    }
    
}