/*
    Author: Zymark Ambat
    Description: This serves as the test class for the Utility Class.
    History: 
        ZAmbat      02272013    - Code creation.
    NJain    06082016  - Updated the test class for sorting PFAE methods in Utility class
*/
@isTest(SeeAllData=false)
public class Utility_Test {

  @testSetup static void testdata(){
        DataUtilTest.loadEnvironmentVariables();
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();       
        fieldValueMap.put('Name', 'testing901');
        fieldValueMap.put('Stage__c', 'Unqualified');
        fieldValueMap.put('Short_Name__c', 'test725');
        fieldValueMap.put('Site_Department__c', 'cts.com');
        fieldValueMap.put('Account_Type__c', 'Customer');
        fieldValueMap.put('Organization_Unit__c', 'sg;us');
        fieldValueMap.put('Copy_Address__c', true);
        fieldValueMap.put('Corporate_Address_1__c', 'test');
        fieldValueMap.put('Corporate_City__c', 'sg');
        fieldValueMap.put('Corporate_Country__c', 'sg');        
        fieldValueMap.put('Financial_Territory__c', 'Greater China');
        fieldValueMap.put('Region__c', 'APJ');
        fieldValueMap.put('Sub_Type__c', 'Direct');
        fieldValueMap.put('Transaction_Type__c', 'Transactional');
        fieldValueMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_RESELLER'));
        fieldValueMap.put('Account_Profile__c', 'Fabless - Emerging');
        fieldValueMap.put('Corporate_Postal_Zip_Code__c', '700007');
        fieldValueMap.put('Fab_9_10__c', 'No');
                
        AccountDataFactory.createAccount(fieldValueMap);
        }
    static Id createAccount() {
        // Create Account
    Account testAcct= getAccount('testing901');
        return testAcct.Id;
    }
    
    static Id createOpportunity(Id testAcctId) {
        // Create Opportunity
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('AccountId',testAcctId);
        fieldValueMap.put('Name','Test Opportunity');  
        fieldValueMap.put('StageName','1. Discovery');
        fieldValueMap.put('CloseDate',Date.Today().addDays(10));  
        fieldValueMap.put('Target_Process_Node__c','14XM');
        fieldValueMap.put('Market_Segment__c','Automotive');  
        fieldValueMap.put('Process_Platform__c','GF Baseline');
        fieldValueMap.put('Fab_Split__c',100);          
        fieldValueMap.put('Process_Geometry__c','0.014UM');  
        fieldValueMap.put('Process_Family__c','Super Low Power');
        fieldValueMap.put('Opportunity_Sourcing_Type__c','First Source');          
         
        Opportunity testOppty = OpportunityDataFactory.createOpportunity(fieldValueMap);
        
        testOppty.Siebel_Opportunity_ID__c = '123123123123';
        
        Update testOppty;
        
        return testOppty.Id;
    }   
    
    static Id createOpportunityProgram(Id testAcctId, Id testOpptyId) {
        // Create Opportunity Program
        Opportunity_Program__c testOpptyProgram = new Opportunity_Program__c();
        testOpptyProgram.Name = 'Test Opportunity Program';
        testOpptyProgram.Account__c = testAcctId;
        testOpptyProgram.Opportunity__c = testOpptyId;
        
        Insert testOpptyProgram;
        
        return testOpptyProgram.Id;
    }
    
    // Test for the generateNewCRMDID method
    static testMethod void testGenerateNewCRMDID() {
        test.startTest();
        String newCRMDID = Utility.generateNewCRMDID();
        test.stopTest();
    }
    
    // Test for the updateCRMDIDSequenceNo method
    static testMethod void testUpdateCRMDIDSequenceNo() {
        test.startTest();
        Utility.updateCRMDIDSequenceNo();
        test.stopTest();
    }
    
    // Test for the retrieveMapNewCRMDID method
    static testMethod void testRetrieveMapNewCRMDID() {
        // Create dummy records for testing
        String testAcctId = Utility_Test.createAccount();
        String testOpptyId = Utility_Test.createOpportunity(testAcctId);
        String testOpptyProgramId = Utility_Test.createOpportunityProgram(testAcctId, testOpptyId);
        
        List<Device__c> listDevices = new List<Device__c>();
        for (integer z=1; z<=10; z++) {
            // Create Device
            Device__c device = new Device__c();
            device.Name = 'TESTDEVICEZAIH' + String.valueOf(z);
            device.Account__c = testAcctId;
            device.Opportunity_Program__c = testOpptyProgramId;
            device.Fab__c = 'Fab 3';
            device.GSOP_Assignment_Tapeout_Plan__c = 'No';
            device.Market_Segment__c = 'Mobility';
            device.Semiconductor_Device__c = 'Analog Amplifier';
            device.End_Customer__c = 'Test Customer';
            device.Device_Sourcing__c = '1st Source';
            device.Stage__c = 'Solutioning';
            device.Status__c = 'Active';
            device.Name = 'TESTDEVICEZAIH' + String.valueOf(z);
            device.Device_ID__c = 'TESTDEVICEZAIH' + String.valueOf(z);
            
            listDevices.add(device);
        }
        
        // Set custom setting value
        CRMDID__c crmdid = CRMDID__c.getInstance('CRMDID_No');
        crmdid.CRMDID_No__c = 999;
        
        Update crmdid;
        
        Map<String, String> mapDevice = new Map<String, String>();
        for (Device__c d : listDevices) {
            mapDevice.put(d.Name, null);
        }
        
        test.startTest();
        mapDevice = Utility.retrieveMapNewCRMDID(mapDevice);
        crmdid = CRMDID__c.getInstance('CRMDID_No');
        System.assertEquals(1009, crmdid.CRMDID_No__c);
        test.stopTest();
    }
  private static Account getAccount(string AccountName)
        {
        Account testAcct= [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return testAcct;
        }
        
    static testMethod void testgetSortedFAE(){
        Profile[] profiles = [Select p.name, p.id From Profile p where p.UserLicense.Name = 'Salesforce' and p.name ='GF FAE/FTS' LIMIT 1];
        List<User> userList = [Select Id From User Where ProfileId = :profiles[0].Id AND IsActive=true Limit 2];
        
        if(userList.isEmpty()){
            DataUtilTest.LoadHCMEnvVariables(); 
            List<HCM_Employee__c> hcmEmployeeList = new List<HCM_Employee__c>();
            for(Integer i = 1; i<3; i++){
                hcmEmployeeList.add(InternalDeviceTestUtil.createHCMEmployee('FAEtest'+i, 'User'+i, 'FAEFTS'+i, 'IT', 'testFAEFTSUser'+i+'@testFAEFTSUser.com',
                                                                                        'TestTitle', '999999999','FAEtest'+i));
                userList.add(InternalDeviceTestUtil.createUser('FAEtest'+i, 'testFAEFTSUser'+i+'@testFAEFTSUser1.com', 'User1', 'FAEFTS'+i, profiles[0].Id, 
                                                            'testFAEFTSUser'+i+'@testFAEFTSUser.com', 'FAEtest'+i));
            }
        
            insert hcmEmployeeList;
            insert userList;
        }   
        
        List<Account_Team_Proxy__c> atpList = new List<Account_Team_Proxy__c>();
        createAccount();
        Account account =[SELECT Id FROM Account WHERE Name='testing901' LIMIT 1];
        
        for(User u:userList){
            atpList.add(new Account_Team_Proxy__c(User__c = u.id, Account__c=account.id, Account_Access__c='Read/Write',Team_Role__c='Primary Field Application Engineer',
                                                Sequence_No__c='1',  Account_Role_ID__c='test'));
        }
        Test.startTest();
            insert atpList;
            Utility.getSortedFAE(atpList);
        Test.stopTest();
    }
    
    static testMethod void testgetSortedOPTMforPFAE(){
        //Data preparation
        String userId1 = Utility_Test.createUser1();
        String userId2 = Utility_Test.createUser2();
        String acctId = Utility_Test.createAccount();
        String oppId = Utility_Test.createOpp(acctId);
        String oppProgId = Utility_Test.createOppProg(acctId, oppId);
        
        test.startTest();        
            //Create new oppty program team members
            Opportunity_Program_Team_Member__c oppProgTM = Utility_Test.createOppProgTmMem1(oppProgId, userId1);
            Opportunity_Program_Team_Member__c oppProgTM2 = Utility_Test.createOppProgTmMem2(oppProgId, userId2);
            
            List<Opportunity_Program_Team_Member__c> lstOPTM = new List<Opportunity_Program_Team_Member__c>();
            lstOPTM.add(oppProgTM);
            lstOPTM.add(oppProgTM2);
            Utility.getSortedOPTMforPFAE(lstOPTM);        
        test.stopTest();        
    }
    
    static Id createUser1(){
        User usr1 = [select id from User where profileId in (select id from Profile where Name='System Administrator') and IsActive=true limit 1];
        return usr1.Id;
    }
    
    static Id createUser2(){
        User usr2 = [select id from User where profileId in (select id from Profile where Name='GF System Admin') and IsActive=true limit 1];
        return usr2.Id;
    }
        
    static Id createOpp(Id acctId){
      Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('AccountId',acctId);
        fieldValueMap.put('Name','Test Opportunity');  
        fieldValueMap.put('StageName','1. Discovery');
        fieldValueMap.put('CloseDate',date.newinstance(2012, 12, 21));  
        fieldValueMap.put('Target_Process_Node__c','14XM');
        fieldValueMap.put('Market_Segment__c','Automotive');  
        fieldValueMap.put('Process_Platform__c','GF Baseline');
        fieldValueMap.put('Fab_Split__c',100);          
        fieldValueMap.put('Process_Geometry__c','0.014UM');  
        fieldValueMap.put('Process_Family__c','Generic / Nominal');
        fieldValueMap.put('Opportunity_Sourcing_Type__c','First Source');  
        fieldValueMap.put('Fab_Assignment_1__c','FAB 1');
         
        return OpportunityDataFactory.createOpportunity(fieldValueMap).id;
        
    }
    
    static Id createOppProg(Id acctId,Id oppId){
        Opportunity_Program__c opProg = new Opportunity_Program__c(Name='Test OppProg',Account__c=acctId,Opportunity__c=oppId);
        insert opProg;
        return opProg.Id;
    }
    
     static Opportunity_Program_Team_Member__c createOppProgTmMem1(Id oppProgId, Id userId){
        Opportunity_Program_Team_Member__c oppProgTM = new Opportunity_Program_Team_Member__c(Core_Team_Member__c=false,
                                        Device_Access__c='Read/Write',Opportunity_Program_Access__c='Read/Write',
                                        Opportunity_Program__c=oppProgId,Team_Role__c='Primary Account Manager',
                                        User__c=userId,Flag_for_Delete__c=false);
        insert oppProgTM;
        return oppProgTM;
    }
    
    static Opportunity_Program_Team_Member__c createOppProgTmMem2(Id oppProgId, Id userId){
        Opportunity_Program_Team_Member__c oppProgTM = new Opportunity_Program_Team_Member__c(Core_Team_Member__c=false,
                                        Device_Access__c='Read/Write',Opportunity_Program_Access__c='Read/Write',
                                        Opportunity_Program__c=oppProgId,Team_Role__c='Primary Field Application Engineer',
                                        User__c=userId,Flag_for_Delete__c=false);
        insert oppProgTM;
        return oppProgTM;
    }
}