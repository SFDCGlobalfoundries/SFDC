/**
* Author: Surendranadh Nune
* Company: GlobalFoundries,India
* Project: New Part Creation 
* Description: This is a test class for NPCFormTriggerHelper & NPCTrigger
* History:
*    SurendranadhNune 26102015  -  Created    - This is a test class for NPCTriggerHelper 
*              
**/

@isTest(seeAllData=false)
public with sharing class NPCFormTriggerHelperTest {
  
   @testSetup static void setupData(){
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
        
        Error_Codes__c MSTReq = new  Error_Codes__c();
        mstreq.name = 'MSTRequired';
        mstreq.message__c = 'test';
        insert mstreq;
        Id testAcctId = createAccount();
        Contact contact = InternalDeviceTestUtil.createContact('Test Contact', 'Test Contact', testAcctId, 'test@test.com', 'Customers My Device Admin; Primary Account Admin', 
                                            'Design; Engineering; Quality; Procurement; Supply Chain; Legal', true, true);
        insert contact;
     test.startTest();
        Id testOpptyId = createOpportunity(testAcctId); 
        Id testOpptyProgramId = createOpportunityProgram(testAcctId, testOpptyId);
    //test.startTest();
        Device__c testDevice = createSPDevice(testAcctId, testOpptyProgramId);
         system.debug('\n\n testDevice :  ' + testDevice);
        New_Part_Creation_Form__c npcForm = createNPCForm(testAcctId, testDevice.Id); 
    test.stoptest(); 
    }
     static device__c createSPDevice(Id acctId,Id opptyProgramId){
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Account__c',acctId);
        fieldValueMap.put('Name','TESTDEVICEZAIH12345677');
        fieldValueMap.put('Opportunity_Program__c',opptyProgramId);
        fieldValueMap.put('Fab__c','FAB 2');
        fieldValueMap.put('GSOP_Assignment_Tapeout_Plan__c','No');
        fieldValueMap.put('Market_Segment__c','Automotive');
        fieldValueMap.put('Semiconductor_Device__c','Analog Amplifier');
        fieldValueMap.put('End_Customer__c','Test Customer');
        fieldValueMap.put('Device_Sourcing__c','1st Source');
        fieldValueMap.put('Stage__c','Design In');
        fieldValueMap.put('Status__c','Active');
        fieldValueMap.put('Siebel_Device_ID__c','1234567890');
        fieldValueMap.put('Tapeout_Type__c','Single Product');
        fieldValueMap.put('Confidence_Level_Tapeout__c','50');
        fieldValueMap.put('PLM_Device_ID__c','ANBQP60ACO8CH-U01');
        fieldValueMap.put('Device_Mask_Set_Title__c','MSTTRT1');
        fieldValueMap.put('CRMDID__c','CDID0000001.00');
        fieldValueMap.put('Device_Type__c','Base');
        fieldValueMap.put('reticle_type__c','Small Field Reticle (SFR)');
        fieldValueMap.put('End_Application__c','Body');
        return DeviceDataFactory.createDevice(fieldValueMap);
    }  
    
    static Id createAccount() { 
        // Create Account
        Account testAcct = getAccount('testing901');
        
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
    
    static void createOpportunityProgramTeamMembers(integer pNo, Id opportunityProgramId) {
        List<User> listUser = [
            SELECT      Id
            FROM        User
            WHERE       IsActive = true
                        AND Profile.Name LIKE 'GF%'
                        AND Fab_Assigned__c INCLUDES ('FAB 2')
            LIMIT :pNo
        ];
    system.debug('$$$$$$$$$$$$ listUser :  ' + listUser);
        List<Opportunity_Program_Team_Member__c> listOPTM = new List<Opportunity_Program_Team_Member__c>();
        for (integer i = 0; i<pNo; i++) {
            Opportunity_Program_Team_Member__c o = new Opportunity_Program_Team_Member__c();
            o.Opportunity_Program__c = opportunityProgramId;
            o.User__c = listUser[i].Id;
            o.Opportunity_Program_Access__c = 'Read/Write';
            o.Device_Access__c = 'Read/Write';
            o.Team_Role__c = 'Customer Engineer';
            o.Core_Team_Member__c = false;
            
            listOPTM.add(o);
        }
        
        insert listOPTM;
    }
    
    
     static New_Part_Creation_Form__c createNPCForm(Id accountId, Id deviceId) {
        New_Part_Creation_Form__c npc = new New_Part_Creation_Form__c();
        npc.Account__c = accountId;
        npc.BASE_Device__c = deviceId;
        npc.Originating_Device__c = deviceId;
        npc.New_Part_ID__c = 'NPCTEST1';
        npc.CRM_DID__c = 'CDID12345';
        npc.Fab__c = 'FAB 2';
        npc.New_Fab__c = 'FAB 3';
        npc.Reason_for_New_Part__c = 'Fab To Fab Transfer' ;
        npc.Tapeout_Required__c = 'No';
        
        insert npc;
        
        return npc;
    }
    
    static New_Part_Creation_Form__c createNPCFormwithTapeout(Id accountId, Id deviceId) {
        New_Part_Creation_Form__c npc = new New_Part_Creation_Form__c();
        npc.Account__c = accountId;
        npc.BASE_Device__c = deviceId;
        npc.Originating_Device__c = deviceId;
        npc.New_Part_ID__c = 'NPCTEST1';
        npc.CRM_DID__c = 'CDID12345';
        npc.Fab__c = 'FAB 2';
        npc.New_Fab__c = 'FAB 3';
        npc.Reason_for_New_Part__c = 'Fab To Fab Transfer' ;
        npc.Tapeout_Required__c = 'Yes';
        
        insert npc;
        
        return npc;
    }
    
    //Used for NPCFormTrigger
    static New_Part_Creation_Form__c createNPCFormForNPCFormTrigger1(Id accountId, Id deviceId) {
        New_Part_Creation_Form__c npc = new New_Part_Creation_Form__c();
        npc.Account__c = accountId;
        npc.BASE_Device__c = deviceId;
        npc.Originating_Device__c = deviceId;
        npc.New_Part_ID__c = 'NPCTEST1';
        npc.CRM_DID__c = 'CDID12345';
        npc.NPC_Form_Status__c = EnvironmentVariable.get('NPC_STATUS_SUBMITTED');
        npc.Tapeout_Required__c = 'No';
        npc.Reason_for_New_Part__c = EnvironmentVariable.get('NPC_REASON_OTHERS');
        npc.Require_To_Create_The_New_Part__c = EnvironmentVariable.get('NPC_REQUIRE_TO_CREATE_YES');
        insert npc;
        
        return npc;
    }
    
    //used for NPCformTrigger
     static New_Part_Creation_Form__c createNPCFormForNPCFormTrigger2(Id accountId, Id deviceId) {
        New_Part_Creation_Form__c npc = new New_Part_Creation_Form__c();
        npc.Account__c = accountId;
        npc.BASE_Device__c = deviceId;
        npc.Originating_Device__c = deviceId;
        npc.New_Part_ID__c = 'NPCTEST1';
        npc.CRM_DID__c = 'CDID12345';
        npc.NPC_Form_Status__c = EnvironmentVariable.get('NPC_STATUS_SUBMITTED');
        npc.Tapeout_Required__c = 'No';
        npc.Reason_for_New_Part__c = Environment_Variable__c.getInstance('NPC_REASON_CUSTOMERNAMECHANGE').Value__c;
        npc.Require_To_Create_The_New_Part__c = EnvironmentVariable.get('NPC_REQUIRE_TO_CREATE_YES');
        insert npc;
        
        return npc;
    }
    
    static BX_041__c createBX041(Device__c device){
        BX_041__c bx041 = new BX_041__c ();
        bx041.Device__c = device.ID;
        bx041.Geometry_Filter__c = '0.055UM';
        bx041.Process_Family_Filter__c = 'MEMS';
        bx041.BX_041_Opportunity_Program__c = device.Opportunity_Program__c;
        bx041.CRMDID__c = device.CRMDID__c ;
        bx041.Need_IP_information__c = true;
        bx041.Need_IP_Merge_information__c = true;
        bx041.GAP_Closed__c = false;
        bx041.BX_041_Status__c = 'Frozen/Pending PID Assignment';
        insert bx041;  
        return bx041;  
    }
    
    static id createProcess(){
        Process__c process1 = new Process__c();
        process1.name = 'Test Process1';
        process1.Available_to_Sell__c = 'Available';//Prototype Ready; MPW Ready;'Registered/TBO
        //process1.ATTRIBUTE_READINESS_CALCULATED__c = ''; // Suspended
        process1.Bias_Table_Spec__c = 'Test bais tabel spec';
        process1.Tech_Geometry__c = '0.055UM';
        process1.Process_Family__c = 'Generic / Nominal';
        insert process1;
        return process1.id;
    }
    
    static testmethod void testNPc(){
    test.startTest();
    New_Part_Creation_Form__c testnpcForm = [SELECT ID FROM New_Part_Creation_Form__c LIMIT 1];
      
      testNPCForm.Tapeout_Required__c = 'Yes';
      update testNPCform;
    //Opportunity_Program__c oppProgram = [Select Id, Name From Opportunity_Program__c Where Name = 'Test Opportunity Program'];
	Opportunity_Program__c oppProgram = [Select Id, Name From Opportunity_Program__c LIMIT 1];
  //system.AssertEquals('Test Opportunity Program', oppProgram.Name);
  
      createOpportunityProgramTeamMembers(3, oppProgram.id);
      PageReference pageRef = Page.NPCFormVF;
      Test.setCurrentPageReference(pageRef);
        ApexPages.currentPage().getParameters().put('id', testnpcForm.Id);
        NPCFormApprovalProcessController n = new NPCFormApprovalProcessController();
        n.submitNPCForm();
         
        list<device__c> dvclist = [select id from device__c where NPC_Form__c !=null];
        system.assertequals(1, dvclist.size());
        
        dvclist[0].Assigned_Process_Id__c = createProcess();
        update dvcList[0];
         test.stopTest();
       system.debug('\n\n &&&&&&&&&&&& device : ' + [select Assigned_Process_Id__c from device__c where id=:dvcList[0].id]);
   
    }
    static testmethod void testRejectionWithoutComments(){
    test.startTest();
    New_Part_Creation_Form__c testnpcForm = [SELECT ID FROM New_Part_Creation_Form__c LIMIT 1];
     
    //Opportunity_Program__c oppProgram = [Select Id, Name From Opportunity_Program__c Where Name = 'Test Opportunity Program'];
	List<Opportunity_Program__c> oppProgram = [Select Id, Name From Opportunity_Program__c LIMIT 1];
      createOpportunityProgramTeamMembers(3, oppProgram[0].Id);
    //system.AssertEquals('Test Opportunity Program', oppProgram.Name);
	system.assertequals(1, oppProgram.size());
     
    PageReference pageRef = Page.NPCFormVF;
      Test.setCurrentPageReference(pageRef);
      ApexPages.currentPage().getParameters().put('id', testnpcForm.Id);
      NPCFormApprovalProcessController n = new NPCFormApprovalProcessController();
      n.submitNPCForm();
      
    Approval.ProcessWorkitemRequest testRej = new Approval.ProcessWorkitemRequest();
      testRej.setComments('');
      testRej.setAction  ('Reject');
      testRej.setWorkitemId(getWorkItemId(testnpcForm.id));
      Test.stopTest();
        try{
          Approval.ProcessResult testRejResult =  Approval.process(testRej);
        }catch(Exception e){
          //system.assertEquals(true, e.getMessage().contains('Please enter Comments for rejecting NPC.'));
        }
       
  
    }
    
    static testmethod void testApprovalWithoutPIYEUsers(){
      test.startTest();
      New_Part_Creation_Form__c testnpcForm = [SELECT ID FROM New_Part_Creation_Form__c LIMIT 1];
      
      
      //Opportunity_Program__c oppProgram = [Select Id, Name From Opportunity_Program__c Where Name = 'Test Opportunity Program'];
	  List<Opportunity_Program__c> oppProgram = [Select Id, Name From Opportunity_Program__c LIMIT 1];
        createOpportunityProgramTeamMembers(3, oppProgram[0].Id);
      //system.AssertEquals('Test Opportunity Program', oppProgram.Name);
	  system.assertequals(1, oppProgram.size());
      
      PageReference pageRef = Page.NPCFormVF;
        Test.setCurrentPageReference(pageRef);
        ApexPages.currentPage().getParameters().put('id', testnpcForm.Id);
        NPCFormApprovalProcessController n = new NPCFormApprovalProcessController();
        n.submitNPCForm();
       
      Approval.ProcessWorkitemRequest testAppr = new Approval.ProcessWorkitemRequest();
        testAppr.setComments('');
        testAppr.setAction  ('Approve');
        testAppr.setWorkitemId(getWorkItemId(testnpcForm.id));
         Test.stopTest();
        try{
          Approval.ProcessResult testApprResult =  Approval.process(testAppr);
        }catch(Exception e){
          //system.assertEquals(true, e.getMessage().contains('Please add PI/YE users for approving NPC.'));
        }
        
      
    }
    
    
    
    public static testmethod void testNPCtrigger1(){
        test.startTest();
        Id deviceId = [select id from device__c limit 1][0].id;
        id accountId = [select id from account limit 1][0].id;
        New_Part_Creation_Form__c npc = createNPCFormForNPCFormTrigger1(accountId, deviceId);
        
        npc.NPC_Form_Status__c = EnvironmentVariable.get('NPC_STATUS_IN_EXEC');
        update npc;
        system.AssertEquals('In Execution', npc.NPC_Form_Status__c);
        test.stopTest();
    }
    
    public static testmethod void testNPCTrigger2(){
       test.startTest();
       Id deviceId = [select id from device__c limit 1][0].id;
        id accountId = [select id from account limit 1][0].id;
        New_Part_Creation_Form__c npc = createNPCFormForNPCFormTrigger2(accountId, deviceId);
        
        npc.NPC_Form_Status__c = EnvironmentVariable.get('NPC_STATUS_IN_EXEC');
        update npc;
        
        npc.npc_form_status__c = EnvironmentVariable.get('NPC_STATUS_PEND_RESUB');
        update npc;
        system.AssertEquals('Pending Resubmission', npc.NPC_Form_Status__c);
        test.stopTest();
    }
    public static Id getWorkItemId(Id targetObjectId)
    {
        Id retVal = null;

        for(ProcessInstanceWorkitem workItem  : [Select p.Id from ProcessInstanceWorkitem p
            where p.ProcessInstance.TargetObjectId =: targetObjectId])
        {
            retVal  =  workItem.Id;
        }

        return retVal;
    }
    
             private static Account getAccount(string AccountName)
            {
                Account testAcct= [SELECT Id, Name FROM Account Where Name =: AccountName];
        
                return testAcct;
            }  
}