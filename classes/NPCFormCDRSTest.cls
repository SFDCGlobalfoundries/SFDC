/*
    Author: Zymark Ambat
    Description: This serves as the test class for NPCFormCDRS.
    History: 
        ZAmbat      02112015    - Code creation.
*/

@isTest(SeeAllData=false)
public class NPCFormCDRSTest {

@testSetup static void testdata() {
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
        Account testAcct = getAccount('testing901'); 
        
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
        fieldValueMap.put('Market_Segment__c','Mobility');  
        fieldValueMap.put('Process_Platform__c','GF Baseline');
        fieldValueMap.put('Fab_Split__c',100);          
        fieldValueMap.put('Process_Geometry__c','0.055UM');  
        fieldValueMap.put('Process_Family__c','Generic / Nominal');
        
        return OpportunityDataFactory.createOpportunity(fieldValueMap).id;
        
    }
    
    static Id createOpportunityProgram(Id testAcctId, Id testOpptyId) {
        // Create Opportunity Program
        Opportunity_Program__c testOpptyProgram = new Opportunity_Program__c();
        testOpptyProgram.Name = 'Test Opportunity Program';
        testOpptyProgram.Account__c = testAcctId;
        testOpptyProgram.Opportunity__c = testOpptyId;
        
        insert testOpptyProgram;
        
        return testOpptyProgram.Id;
    }
    
    static Id createNPCForm(Id accountId, Id deviceId) {
        New_Part_Creation_Form__c npc = new New_Part_Creation_Form__c();
        npc.Account__c = accountId;
        npc.Originating_Device__c = deviceId;
        npc.BASE_Device__c = deviceId;
        npc.New_Part_ID__c = 'TESTDEVICEZAIH123456999';
        npc.NPC_Form_Status__c = 'Pending CE Approval';
        npc.NPC_Form_Submitted_Date__c = date.today().addDays(-5);
        npc.Reference_Id__c = 'ANBQP60ACO8CH-U01';
        npc.Current_Forecast_Tapeout_Date__c = date.today();
        npc.Mask_Set_Title__c = 'test';
        
        insert npc;
        
        return npc.Id;
    }
    
    static Device__c createDevice(Id testAcctId, Id testOpptyProgramId) {
        // Create Device
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name','TESTDEVICEZAIH12345677'); 
        fieldValueMap.put('Stage__c','Design In');
        fieldValueMap.put('Status__c','Active');
        fieldValueMap.put('Account__c',testAcctId);
        fieldValueMap.put('Opportunity_Program__c',testOpptyProgramId);
        fieldValueMap.put('Market_Segment__c','Mobility');
        fieldValueMap.put('Semiconductor_Device__c','Analog Regulator');
        fieldValueMap.put('End_Application__c','Body');
        fieldValueMap.put('Device_Sourcing__c','1st Source');
        fieldValueMap.put('Tapeout_Type__c','Single Product');
        fieldValueMap.put('Fab__c','FAB 2');
        fieldValueMap.put('Siebel_Device_ID__c','1234567890');
        fieldValueMap.put('Original_Forecasted_Tapeout_Date__c',System.today());
        fieldValueMap.put('GSOP_Assignment_Tapeout_Plan__c','No');
        fieldValueMap.put('End_Customer__c','Test Customer');
        fieldValueMap.put('PLM_Device_ID__c','ANBQP60ACO8CH-U01');
        fieldValueMap.put('Device_Mask_Set_Title__c','DVMST12345');
        fieldValueMap.put('CRMDID__c','CDID0000001.00');
        fieldValueMap.put('Device_Type__c','Base');
        fieldValueMap.put('Confidence_Level_Tapeout__c','100');
        fieldValueMap.put('Enabled_via_previous_MPW_1__c','No');
        return DeviceDataFactory.createDevice(fieldValueMap);
        
    }
    
    static Device__c createNPCDevice(Id testAcctId, Id testOpptyProgramId, Id npcFormId) {
        // Create Device
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name','TESTDEVICEZAIH123456908');
        fieldValueMap.put('Opportunity_Program__c',testOpptyProgramId);
        fieldValueMap.put('Fab__c','FAB 2');
        fieldValueMap.put('GSOP_Assignment_Tapeout_Plan__c','Yes');
        fieldValueMap.put('Market_Segment__c','Consumer');
        fieldValueMap.put('Semiconductor_Device__c','Display Driver');
        fieldValueMap.put('End_Customer__c','Test Customer2');  
        fieldValueMap.put('Device_Sourcing__c','Second Source');
        fieldValueMap.put('Stage__c','Design In');
        fieldValueMap.put('Status__c','Active');
        fieldValueMap.put('Siebel_Device_ID__c','12345678751');
        fieldValueMap.put('Tapeout_Type__c','Customer MPW');
        fieldValueMap.put('PLM_Device_ID__c','ANBQP60ACO8CH-U23');
        fieldValueMap.put('CRMDID__c','CDID0000001.05');
        fieldValueMap.put('Device_Type__c','Base');
        fieldValueMap.put('End_Application__c','Desktop PC');
        fieldValueMap.put('Confidence_Level_Tapeout__c','90');
        fieldValueMap.put('Original_Forecasted_Tapeout_Date__c',System.today());
        fieldValueMap.put('NPC_Form__c',npcFormId);
        return DeviceDataFactory.createDevice(fieldValueMap);
    }
    
    static BX_041__c createBX041(Device__c device){
        BX_041__c bx041 = new BX_041__c();
        bx041.Device__c = device.ID;
        bx041.Geometry_Filter__c = '0.055UM';
        bx041.Process_Family_Filter__c = 'MEMS';
        bx041.BX_041_Opportunity_Program__c = device.Opportunity_Program__c;
        bx041.CRMDID__c = device.CRMDID__c ;
        bx041.Need_IP_information__c = true;
        bx041.Need_IP_Merge_information__c = true;
        bx041.GAP_Closed__c = false;
        
        insert bx041;  
        
        return bx041;  
    }
    
    static testMethod void testNPCFormCDRS() {
        string acctId = NPCFormCDRSTest.createAccount();
        string opptyId = NPCFormCDRSTest.createOpportunity(acctId);
        string opptyProgramId = NPCFormCDRSTest.createOpportunityProgram(acctId, opptyId);
        Device__c device = NPCFormCDRSTest.createDevice(acctId, opptyProgramId);
        string npcFormId = NPCFormCDRSTest.createNPCForm(acctId, device.Id);
        test.startTest();
        Device__c ncpDevice = NPCFormCDRSTest.createNPCDevice(acctId, opptyProgramId, npcFormId);
        
        BX_041__c cdrs = NPCFormCDRSTest.createBX041(ncpDevice);
        
        
            Set<Id> npcIds = new Set<Id>{npcFormId};
            NPCFormCDRS.clearAssignedPID(npcIds);
        test.stopTest();
    }
    
    private static Account getAccount(string AccountName)
            {
                Account testAcct= [SELECT Id, Name FROM Account Where Name =: AccountName];
        
                return testAcct;
            }  
}