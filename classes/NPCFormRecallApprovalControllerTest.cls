/*
    Author: Anirban Roy
    Description: This is the test class for NPCFormRecallApprovalController class.
    History: 
        ARoy        02052014    - Code creation.
        Vijay       16012015    - Updated the Device Stage 'Solutioning' to 'Design In' as Device will be created in 
                                  'Design In' directly and added mandatory fields.
        DBiswal     04012015    - Updated code for refactoring of test class.
*/

@isTest(SeeAllData=false)
public class NPCFormRecallApprovalControllerTest {
    
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        
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
           
            fieldValueMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER'));
    
            fieldValueMapList.add(fieldValueMap);
        }
        AccountDataFactory.createAccounts(fieldValueMapList,2);
        String testAcctId = NPCFormRecallApprovalControllerTest.createAccount();
        String testOpptyId = NPCFormRecallApprovalControllerTest.createOpportunity(testAcctId);
        String testOpptyProgramId = NPCFormRecallApprovalControllerTest.createOpportunityProgram(testAcctId, testOpptyId);
        Mask_Set_Title__c MSTId = DeviceUtilTest.createMaskSetTtitleObj('TRS48');
        string MSTAccId = DeviceUtilTest.createMSTAccount(testAcctId,MSTId.id);
        Test.startTest();
        Device__c testDevice = NPCFormRecallApprovalControllerTest.createDevice(testAcctId, testOpptyProgramId);
        Test.stopTest();
        /*string acctId = DeviceUtilTest.createAccount();
        string opptyId = DeviceUtilTest.createOpp(acctId,'0.10UM');
        string opptyProgramId = DeviceUtilTest.createOppProg(acctId,opptyId);
        Device__c Device = DeviceUtilTest.createCMPWDevice(acctId,opptyProgramId);
        Insert Device;*/
    }
    
    // Get List of Users
    static List<User> getUserList(){
        Set<Id> profileIds = new Set<Id>();
        for (Profile p : [SELECT    Id
                          FROM      Profile
                          WHERE     Name LIKE 'GF%']) {
            profileIds.add(p.Id);               
        }
        
        List<User> listUser = [
            SELECT      Id
            FROM        User
            WHERE       IsActive = true
                        AND ProfileId IN :profileIds
                        AND Fab_Assigned__c INCLUDES ('FAB 7')
            ];
            
        return listUser;
    }    
    
    static Id createAccount() {
        // Create Account
         Account testAcct= getAccount('MYTEST ACCOUNT1');
        
        testAcct.Siebel_Account_ID__c = '123123123123';
        
        Update testAcct;
        
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
        fieldValueMap.put('Process_Geometry__c','0.055UM');  
        fieldValueMap.put('Process_Family__c','Generic / Nominal');        
        fieldValueMap.put('Siebel_Opportunity_ID__c','123123123123');
         
        Opportunity testOppty = OpportunityDataFactory.createOpportunity(fieldValueMap);
        
        testOppty.Siebel_Opportunity_ID__c = '123123123123';
        
        Update testOppty;
        
        return testOppty.Id;
    }
    
    static Id createOpportunityProgram(Id testAcctId, Id testOpptyId) {
        // Create Opportunity Program
        Opportunity_Program__c testOpptyProgram = new Opportunity_Program__c();
        testOpptyProgram.Name = 'Test Opportunity';
        testOpptyProgram.Account__c = testAcctId;
        testOpptyProgram.Opportunity__c = testOpptyId;
        
        Insert testOpptyProgram;
        
        return testOpptyProgram.Id;
    }    
    
    static Device__c createDevice(Id testAcctId, Id testOpptyProgramId) {
        // Create Device
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Account__c',testAcctId); 
        fieldValueMap.put('Name','TESTDEVICEZAIH12345688');
        fieldValueMap.put('Original_Forecasted_Tapeout_Date__c',System.today());
        fieldValueMap.put('Opportunity_Program__c',testOpptyProgramId);
        fieldValueMap.put('Fab__c','FAB 7');
        fieldValueMap.put('GSOP_Assignment_Tapeout_Plan__c','No');
        fieldValueMap.put('Market_Segment__c','Mobility');
        fieldValueMap.put('Semiconductor_Device__c','Analog Amplifier');
        fieldValueMap.put('End_Customer__c','Test Customer');
        fieldValueMap.put('Device_Sourcing__c','First Source');
        fieldValueMap.put('Stage__c','Design In');
        fieldValueMap.put('Status__c','Active');
        fieldValueMap.put('Siebel_Device_ID__c','1234567890');
        fieldValueMap.put('Tapeout_Type__c','Customer MPW');
        fieldValueMap.put('PLM_Device_ID__c','ANBQP60ACO8CH-U01');
        fieldValueMap.put('CRMDID__c','CDID0000001.00');
        fieldValueMap.put('Device_Type__c','Base');
        fieldValueMap.put('Confidence_Level_Tapeout__c','100');
        fieldValueMap.put('End_Application__c','Body');
        fieldValueMap.put('Device_Mask_Set_Title__c','TRS48');
        fieldValueMap.put('Enabled_via_previous_MPW_1__c',null);
        
        return DeviceDataFactory.createDevice(fieldValueMap);
    }    
    
    static New_Part_Creation_Form__c createNPCForm(Id accountId, Id deviceId) {
        New_Part_Creation_Form__c npc = new New_Part_Creation_Form__c();
        npc.Account__c = accountId;
        npc.BASE_Device__c = deviceId;
        npc.Originating_Device__c = deviceId;
        npc.New_Part_ID__c = 'NPCTEST1';
        npc.CRM_DID__c = 'CDID12345';
        
        insert npc;
        
        return npc;
    }    
    
    static Id createNPCMasks(Id npcId) {
        Mask__c m = new Mask__c();
        m.New_Part_Creation_Form__c = npcId;
        m.Layer__c = 'TestLayer';
        m.Modified_Mask__c = 'TestLayerMask';
        m.Original_Mask__c = 'TestLayerMask';
        
        insert m;
        
        return m.Id;
    }
    
    static void createOpportunityProgramTeamMembers(Id opportunityProgramId, Id userId) {

        Opportunity_Program_Team_Member__c opptm = new Opportunity_Program_Team_Member__c();
        opptm.Opportunity_Program__c = opportunityProgramId;
        opptm.User__c = userId;
        opptm.Opportunity_Program_Access__c = 'Read/Write';
        opptm.Device_Access__c = 'Read/Write';
        opptm.Team_Role__c = 'Customer Engineer';
        opptm.Core_Team_Member__c = false;     
        
        insert opptm;
    }
    
    static testMethod void testNPCRecall(){
        //DataUtilTest.loadEnvironmentVariables();
        List<User> usrList = NPCFormRecallApprovalControllerTest.getUserList();
        //String testAcctId = NPCFormRecallApprovalControllerTest.createAccount();
        test.startTest();
        //String testOpptyId = NPCFormRecallApprovalControllerTest.createOpportunity(testAcctId);
        //String testOpptyProgramId = NPCFormRecallApprovalControllerTest.createOpportunityProgram(testAcctId, testOpptyId);
        //System.debug('Total Number of SOQL Queries allowed in this apex code context1: ' +  Limits.getLimitQueries());
        
        //Device__c testDevice = NPCFormRecallApprovalControllerTest.createDevice(testAcctId, testOpptyProgramId);
        Account testAcctId = [Select Id from Account where name = 'MYTEST ACCOUNT1'];
        Opportunity_Program__c testOpptyProgramId = [Select Id from Opportunity_Program__c where name = 'Test Opportunity' limit 1];
        Device__c testDevice = [Select Id from Device__c where name = 'TESTDEVICEZAIH12345688'];
        
        System.debug('Total Number of SOQL Queries allowed in this apex code context2: ' +  Limits.getLimitQueries());
        New_Part_Creation_Form__c testNPC = NPCFormRecallApprovalControllerTest.createNPCForm(testAcctId.Id, testDevice.Id);
        NPCFormRecallApprovalControllerTest.createOpportunityProgramTeamMembers(testOpptyProgramId.Id,usrList[0].Id);
        
       System.debug('Total Number of SOQL Queries allowed in this apex code context3: ' +  Limits.getLimitQueries());
            PageReference pageRef = Page.NPCFormVF;
            Test.setCurrentPageReference(pageRef);
            ApexPages.currentPage().getParameters().put('id', testNPC.Id);
            ApexPages.currentPage().getParameters().put('share', '1');
            NPCFormApprovalProcessController n = new NPCFormApprovalProcessController();            
            
            n.submitNPCForm();
            System.debug('MuktapgRef1'+pageRef);
            ApexPages.StandardController controller = new ApexPages.StandardController(testNPC);
            NPCFormRecallApprovalController npcFormRecall = new NPCFormRecallApprovalController(controller);
            PageReference pgRef = npcFormRecall.recallApproval();
            System.debug('MuktapgRef'+pgRef);
            system.assert(pgRef!=null);
        System.debug('Total Number of SOQL Queries allowed in this apex code context4: ' +  Limits.getLimitQueries());    
        test.stopTest();
    }
    
   static testMethod void testNPCCancel(){
        //DataUtilTest.loadEnvironmentVariables();
        List<User> usrList = NPCFormRecallApprovalControllerTest.getUserList();
        //String testAcctId = NPCFormRecallApprovalControllerTest.createAccount();
        test.startTest();
        //String testOpptyId = NPCFormRecallApprovalControllerTest.createOpportunity(testAcctId);
        //String testOpptyProgramId = NPCFormRecallApprovalControllerTest.createOpportunityProgram(testAcctId, testOpptyId);
        
        //System.debug('2ndTotal Number of SOQL Queries allowed in this apex code context1: ' +  Limits.getLimitQueries());
        
        //Device__c testDevice = NPCFormRecallApprovalControllerTest.createDevice(testAcctId, testOpptyProgramId);
        Account testAcctId = [Select Id from Account where name = 'MYTEST ACCOUNT1'];
        Opportunity_Program__c testOpptyProgramId = [Select Id from Opportunity_Program__c where name = 'Test Opportunity' limit 1];
        
        Device__c testDevice = [Select Id from Device__c where name = 'TESTDEVICEZAIH12345688'];
       
       
        System.debug('2ndTotal Number of SOQL Queries allowed in this apex code context2: ' +  Limits.getLimitQueries());
        New_Part_Creation_Form__c testNPC = NPCFormRecallApprovalControllerTest.createNPCForm(testAcctId.Id, testDevice.id);
        NPCFormRecallApprovalControllerTest.createOpportunityProgramTeamMembers(testOpptyProgramId.Id,usrList[0].Id);
        
        
            PageReference pageRef = Page.NPCFormVF;
            Test.setCurrentPageReference(pageRef);
            ApexPages.currentPage().getParameters().put('id', testNPC.Id);
            NPCFormApprovalProcessController n = new NPCFormApprovalProcessController();            
            
            n.submitNPCForm();
            
            ApexPages.StandardController controller = new ApexPages.StandardController(testNPC);
            NPCFormRecallApprovalController npcFormRecall = new NPCFormRecallApprovalController(controller);
            PageReference pgRef = npcFormRecall.cancelNPC();
            System.debug('MuktapgRef2'+pgRef);
            system.assert(pgRef!=null);
        System.debug('2ndTotal Number of SOQL Queries allowed in this apex code context3: ' +  Limits.getLimitQueries());    
        test.stopTest();
    } 
    
    private static Account getAccount(string AccountName)
            {
                Account testAcct= [SELECT Id, Name FROM Account Where Name =: AccountName];
        
                return testAcct;
            }     
}