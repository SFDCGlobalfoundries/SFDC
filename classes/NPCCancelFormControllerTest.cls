/*
    Author: Zymark Ambat
    Description: This Class serves as the controller for the NPCCancelFormController.
    History: 
        ZAmbat      11292013    - Code creation.
        Vijay       16012015    - Updated the Device Stage 'Solutioning' to 'Design In' as Device will be created in 
                                  'Design In' directly and added mandatory fields.
*/

@isTest(SeeAllData=false)
private class NPCCancelFormControllerTest {

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
        fieldValueMap.put('Account_Profile__c', 'Fabless - Emerging');
        fieldValueMap.put('Corporate_Postal_Zip_Code__c', '700007');
        fieldValueMap.put('Fab_9_10__c', 'No');
        fieldValueMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER'));       
        AccountDataFactory.createAccount(fieldValueMap);
    }   
    static Id createAccount() {
        // Create Account
        
            Account testAcct= getAccount('testing901'); 
            return testAcct.id;
            }
    
    static Id createContact(Id acctId) {
        Contact c = new Contact();
        c.FirstName = 'FirstName';
        c.LastName = 'LastName';
        c.AccountId = acctId;
        c.Email = 'test@test.com';
        c.Department__c = 'TestDepartment';
        
        insert c;
        
        return c.Id;
    }
    
    static Id createOpportunity(Id testAcctId) {
        // Create Opportunity
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('AccountId',testAcctId);
        fieldValueMap.put('Name','Test Opportunity');  
        fieldValueMap.put('StageName','1. Discovery');
        fieldValueMap.put('CloseDate',Date.Today().addDays(10));  
        fieldValueMap.put('Target_Process_Node__c','14XM');
        fieldValueMap.put('Market_Segment__c','Mobility');  
        fieldValueMap.put('Process_Platform__c','GF Baseline');
        fieldValueMap.put('Fab_Split__c',100);          
        fieldValueMap.put('Process_Geometry__c','0.055UM');  
        fieldValueMap.put('Process_Family__c','Generic / Nominal');
        
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
    
   
    static New_Part_Creation_Form__c createNPCForm(Id accountId, Id deviceId) {
        New_Part_Creation_Form__c npc = new New_Part_Creation_Form__c();
        npc.Account__c = accountId;
        npc.BASE_Device__c = deviceId;
        npc.New_Part_ID__c = 'NPCTEST1';
        npc.NPC_Form_Status__c = 'Pending Submission';
        npc.NPC_Form_Submitted_Date__c = date.today().addDays(-5);
        npc.Reference_Id__c = 'ANBQP60ACO8CH-U01';
        npc.Tapeout_Required__c = 'Yes';
        
        insert npc;
        
        return npc;
    }
    
    static testMethod void runTest() {
        
        String testAcctId = NPCCancelFormControllerTest.createAccount();
        String testOpptyId = NPCCancelFormControllerTest.createOpportunity(testAcctId);
        String testOpptyProgramId = NPCCancelFormControllerTest.createOpportunityProgram(testAcctId, testOpptyId);
        Device__c testDevice1 = DeviceUtilTest.createSPDevice(testAcctId,testOpptyProgramId  );
        test.startTest();
        testDevice1.Name = 'TESTDEVICEZAIH12345677';
        testDevice1.Fab__c = 'Fab 2';
        testDevice1.Account__c = testAcctId;
        testDevice1.Opportunity_Program__c = testOpptyProgramId;
        testDevice1.GSOP_Assignment_Tapeout_Plan__c = 'No';
        testDevice1.Market_Segment__c = 'Mobility';
        testDevice1.Semiconductor_Device__c = 'Analog Amplifier';
        testDevice1.End_Customer__c = 'Test Customer';
        testDevice1.Device_Sourcing__c = '1st Source';
        testDevice1.Stage__c = 'Design In';
        testDevice1.Status__c = 'Active';
        testDevice1.Siebel_Device_ID__c = '1234567890';
        testDevice1.PLM_Device_ID__c = 'ANBQP60ACO8CH-U01';
        testDevice1.CRMDID__c = 'CDID0000001.00';
        testDevice1.Device_Type__c = 'Base';
        testDevice1.End_Application__c = 'Body';
        testDevice1.Original_Forecasted_Tapeout_Date__c = System.today();
        testDevice1.Enabled_via_previous_MPW_1__c = 'No';
        Insert testDevice1;
        New_Part_Creation_Form__c testNPC = NPCCancelFormControllerTest.createNPCForm(testAcctId, testDevice1.Id);
        Device__c testDevice2 = DeviceUtilTest.createRetrofitDevice();
        testDevice2.Name = 'TESTDEVICEZAIH123456777';
        testDevice2.Fab__c = 'Fab 2';
        testDevice2.GSOP_Assignment_Tapeout_Plan__c = 'No';
        testDevice2.Market_Segment__c = 'Mobility';
        testDevice2.Semiconductor_Device__c = 'Analog Amplifier';
        testDevice2.End_Customer__c = 'Test Customer';
        testDevice2.Device_Sourcing__c = '1st Source';
        testDevice2.Stage__c = 'Design In';
        testDevice2.Status__c = 'Active';
        testDevice2.Siebel_Device_ID__c = '1234567890';
        testDevice2.Tapeout_Type__c = 'Retrofit';
        testDevice2.PLM_Device_ID__c = 'ANBQP60ACO8CH-U01';
        testDevice2.CRMDID__c = 'CDID0000002.00';
        testDevice2.Device_Type__c = 'Retrofit';
        testDevice2.NPC_Form__c = testNPC.Id;
        testDevice2.End_Application__c = 'Body';
        testDevice2.Original_Forecasted_Tapeout_Date__c = System.today();
        testDevice2.Enabled_via_previous_MPW_1__c = 'No';
        
         testNPC.Reason_for_New_Part__c =Environment_Variable__c.getInstance('NPC_REASON_RETROFIT').Value__c;
       
            PageReference pageRef = Page.NPCCancelFormVF;
            
            Test.setCurrentPageReference(pageRef);
            ApexPages.currentPage().getParameters().put('id', testNPC.Id);
            ApexPages.currentPage().getUrl();
            NPCCancelFormController n = new NPCCancelFormController();
            n.cancelNPC();
            n.cancel();
        test.stopTest();
    }
    
    private static Account getAccount(string AccountName)
            {
                Account testAcct= [SELECT Id, Name FROM Account Where Name =: AccountName];
        
                return testAcct;
            }  
}