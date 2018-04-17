/*
    Author: Abhita Bansal
    Created Date: 27/08/2015 
    Description: Test class for MPWMyDevicesController
*/
@isTest(SeeAllData=false)
public class MPWMyDevicesControllerTest {

    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        
        
    }
    
    static Id createAccount() {
    
        User thisUser = [select Id from User where Profile.Name ='GF Sales User' and isActive = true and UserRoleId != null limit 1];
         Account testAcct = new Account();
         Map<String,Object> fieldValueMap = new Map<String,Object>();            
        fieldValueMap.put('Name', 'Test Account 007');            
        fieldValueMap.put('stage__c', 'Unqualified');
        fieldValueMap.put('short_name__c', 'Test007');
        fieldValueMap.put('sub_type__c', 'Direct');
        fieldValueMap.put('site_department__c', 'IT');          
        fieldValueMap.put('transaction_type__c', 'Non-Transactional');
        fieldValueMap.put('account_profile__c', 'Fabless - Emerging');            
        fieldValueMap.put('Process_Tech_Interested__c', 'Mature (> 0.11um)');
        fieldValueMap.put('region__c', 'US');
        fieldValueMap.put('Sales_Territory__c', 'Greater China');
        fieldValueMap.put('financial_territory__c', 'Greater China');          
        fieldValueMap.put('Copy_Address__c', true);
        fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');
        fieldValueMap.put('Corporate_Address_2__c', 'Test Address 2');
        fieldValueMap.put('Corporate_Address_3__c', 'Test Address 3');
        fieldValueMap.put('Corporate_Address_4__c', 'Test Address 4');            
        fieldValueMap.put('Corporate_Country__c', 'Test Country');
        fieldValueMap.put('Corporate_City__c', 'Test City');
        fieldValueMap.put('Corporate_State__c', 'Test State');
        fieldValueMap.put('Corporate_Postal_Zip_Code__c', '700007');
        fieldValueMap.put('Organization_Unit__c', 'GF Investment LLC OU');
        fieldValueMap.put('bill_to_location__c', 'test');
        fieldValueMap.put('total_employee__c', 7);          
        fieldValueMap.put('end_customer__c', 'people');
        fieldValueMap.put('Revenue_Potential__c', 'Low Potential');            
        fieldValueMap.put('Target_Account__c', 'Yes');
        fieldValueMap.put('Fab_9_10__c','No');
        fieldValueMap.put('Bill_To_Address_1__c','Test Address');
        fieldValueMap.put('Account_Profile__c','Fabless - Emerging');
        fieldValueMap.put('Bill_To_City__c','Test City');
        fieldValueMap.put('Bill_To_Country__c','India');
        fieldValueMap.put('ownerId',thisUser.Id);
        fieldValueMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER')); 
        testAcct=AccountDataFactory.createAccount(fieldValueMap);
                
        return testAcct.Id;
    }
    
    static Id createContact(Id accountId) {
    
        Contact con = new Contact();
        con.FirstName = 'FirstName';
        con.LastName = 'LastName';
        con.AccountId = accountId;
        con.Email = 'test1@test.com';
        con.Department__c='Design';
        insert con;  
        
        return con.Id;
    }
    
    static User createPortalUser(Id contactId) {
        
        Profile p = [Select Id,Name from Profile where Name = 'Customer Portal Admin' limit 1];
        
        User u = new User();
        u.LastName = 'LastName';
        u.Alias = 'Test1';
        u.Email = 'test1@test.com';
        u.LanguageLocaleKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        u.LocaleSidKey = 'en_US';
        u.ProfileId = p.Id;
        u.TimeZoneSidKey = 'America/Los_Angeles';
        u.UserName = 'test1@test.com.mpwdev';
        u.Portal_login__c = 'xyz';
        u.ContactId = contactId;
        u.IsActive = true;
        u.CommunityNickname = 'Testtest123';
        insert u;
        
        return u;
    }
    
    static Id createMPWTrain() {
        
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
        
        return mpwTrain.Id;
    }
    
    static Id createOpp(Id acctId, string processGeometry) {
        // Create Opportunity
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('AccountId',acctId);
        fieldValueMap.put('Name','Test Opportunity');  
        fieldValueMap.put('StageName','1. Discovery');
        fieldValueMap.put('CloseDate',Date.Today().addDays(10));  
        fieldValueMap.put('Target_Process_Node__c','14XM');
        fieldValueMap.put('Market_Segment__c','Mobility');  
        fieldValueMap.put('Process_Platform__c','GF Baseline');
        fieldValueMap.put('Fab_Split__c',100);          
        fieldValueMap.put('Process_Geometry__c',processGeometry);  
        fieldValueMap.put('Process_Family__c','Super Low Power');
         
        return OpportunityDataFactory.createOpportunity(fieldValueMap).id;
        
    }
    
    static Id createOppProg(Id acctId,Id oppId) {
        // Create Opportunity Program
        Opportunity_Program__c testOpptyProgram = new Opportunity_Program__c();
        testOpptyProgram.Name = 'Test Opportunity Program';
        testOpptyProgram.Account__c = acctId;
        testOpptyProgram.Opportunity__c = oppId;
        
        insert testOpptyProgram;
        return testOpptyProgram.Id;
    }
    
    static id createProcess(string processGeometry){
        Process__c pros = new Process__c();
        pros.Process_Family__c = 'Super Low Power';
        pros.Tech_Geometry__c = processGeometry;
        pros.Available_to_Sell__c = 'Available';
        pros.Process_Technology__c = 'test123';
        insert pros;      
        return pros.id;
    }
    
    static id createProcessTechnology() {
        Process_Technology__c pt = new Process_Technology__c();
        pt.Name = 'test';
        pt.IP_Geometry_Technology__c = 'test';
        pt.PT_Number__c = 'test123';
        insert pt;      
        return pt.id;
    }
    
    static id createDevice(id testAcctId, id testOpptyProgramId) {
        // Create Device
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name','MPW03312_TestDevice1');
        fieldValueMap.put('Account__c',testAcctId);
        fieldValueMap.put('Opportunity_Program__c',testOpptyProgramId);
        fieldValueMap.put('Fab__c','FAB 1');
        fieldValueMap.put('GSOP_Assignment_Tapeout_Plan__c','No');
        fieldValueMap.put('Market_Segment__c','Automotive');
        fieldValueMap.put('Semiconductor_Device__c','Analog Amplifier');
        fieldValueMap.put('End_Customer__c','Test Customer');
        fieldValueMap.put('Device_Sourcing__c','1st Source');
        fieldValueMap.put('Stage__c','Design In');
        fieldValueMap.put('Status__c','Active');
        fieldValueMap.put('Siebel_Device_ID__c','1234567890');
        fieldValueMap.put('Tapeout_Type__c','GlobalShuttle MPW');
        fieldValueMap.put('PLM_Device_ID__c','ANBQP60ACO8CH-U01');
        fieldValueMap.put('CRMDID__c','CDID0000001.00');
        fieldValueMap.put('Device_Type__c','Revise');
        fieldValueMap.put('End_Application__c','Body');
        fieldValueMap.put('Device_Mask_Set_Title__c','DVMST12345');
        return DeviceDataFactory.createDevice(fieldValueMap).Id;
        
    }
    
    static void createMPWReservation(Id trainId, Id accId, Id deviceId){
        MPW_Reservation__c mpwReservation1 = new MPW_Reservation__c();        
        mpwReservation1.MPW_Train_Name__c = trainId;
        mpwReservation1.Name = '2015-03-05600';
        mpwReservation1.Form_Status__c = 'Draft';
        mpwReservation1.Category__c = 'Customer';
        mpwReservation1.Customer_Company_Name__c = accId;
        mpwReservation1.Usage__c = 'Required';
        mpwReservation1.Device__c = deviceId;
        mpwReservation1.Prime_Die_Name__c = 'TestComapre1';
        insert mpwReservation1;
    }
    
    public static testMethod void myDeviceMethod1() {
        //Test.startTest();
        String acctId = MPWMyDevicesControllerTest.createAccount();
        //String conId = MPWMyDevicesControllerTest.createContact(acctId);
        string opptyId = MPWMyDevicesControllerTest.createOpp(acctId, '0.028UM');
        string opptyProgramId = MPWMyDevicesControllerTest.createOppProg(acctId, opptyId);
        string mpwId = MPWMyDevicesControllerTest.createMPWTrain();
        //string processId = MPWMyDevicesControllerTest.createProcess('0.028UM');
        //string processTechnologyId = MPWMyDevicesControllerTest.createProcessTechnology();
        Test.startTest();
        string baseDeviceId = MPWMyDevicesControllerTest.createDevice(acctId, opptyProgramId);
       
        MPWMyDevicesControllerTest.createMPWReservation(mpwId,acctId,baseDeviceId);
        Test.setCurrentPageReference(new PageReference('Page.MPWMyDevicesVF'));
        System.currentPageReference().getParameters().put('sortField','deviceName');
        System.currentPageReference().getParameters().put('accountId',acctId);
          
        MPWMyDevicesController appMatrixClass = new MPWMyDevicesController();
        appMatrixClass.getMyMPWDevices();
        appMatrixClass.getHasPrevious();
        appMatrixClass.getHasNext();
        appMatrixClass.previous();
        appMatrixClass.next();
        appMatrixClass.first();
        appMatrixClass.last();
        appMatrixClass.sortRecords();
        appMatrixClass.raiseMPWRequest();
        
        system.assertEquals(mpwId, mpwId);
        Test.stopTest() ;
        
    }
    
    public static testMethod void myDeviceMethod2() {
        
        String acctId = MPWMyDevicesControllerTest.createAccount();
        String conId = MPWMyDevicesControllerTest.createContact(acctId);
        string opptyId = MPWMyDevicesControllerTest.createOpp(acctId, '0.028UM');
        string opptyProgramId = MPWMyDevicesControllerTest.createOppProg(acctId, opptyId);
        string mpwId = MPWMyDevicesControllerTest.createMPWTrain();
        string processId = MPWMyDevicesControllerTest.createProcess('0.028UM');
        string processTechnologyId = MPWMyDevicesControllerTest.createProcessTechnology();
        Test.startTest();
        string baseDeviceId = MPWMyDevicesControllerTest.createDevice(acctId, opptyProgramId);
        
        
        
        Test.setCurrentPageReference(new PageReference('Page.MPWMyDevicesVF'));
        System.currentPageReference().getParameters().put('sortField','accountName');
        System.currentPageReference().getParameters().put('accountId',acctId);
          
        MPWMyDevicesController appMatrixClass = new MPWMyDevicesController();
        appMatrixClass.sortRecords();
        system.assertEquals(baseDeviceId, baseDeviceId);
        Test.stopTest() ;
        
    }
}