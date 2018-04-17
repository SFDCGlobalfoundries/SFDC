/*
    Author: Thomas Lai
    Description: This serves as the test class for the OpportunityTrigger Trigger.
    History: 
        Tlai         09082014    - Code creation.
        Vijay Vemuru 08122016    - Added Clip Level Implementation for Deal Grading.
        Pradosh Samal 04052017   - Case-00067002. Added test method (testUpdateLastEditorOfIPDF()) for Opportunity_TriggerHelper.updateLastEditorOfIPDF().

*/
@isTest(SeeAllData=false)
public class OpportunityTriggerTest {


    @testSetup static void testdata(){
        DataUtilTest.loadEnvironmentVariables();
 
         Map<String,Object> fieldValueMap = new Map<String,Object>();       
        fieldValueMap.put('Name', 'testing501');
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
    static Account createAccount1() {
        // Create Account
        Account testAcct = getAccount('testing501'); 
        return testAcct;
       
    }
 
    static list<Account> createAccountList() {
        // Create Account
        List<Map<String,Object>> fieldValueMapsList = new List<Map<String,Object>>();
        for (integer z=1; z<=3; z++) {
            Map<String,Object> fieldValueMap = new Map<String,Object>();                    
            fieldValueMap.put('short_name__c', 'ZAIHTESTACCT'+z);
            fieldValueMap.put('Name', 'TESTACCTZAIH12345'+z);
            fieldValueMap.put('sub_type__c', 'Direct');
            fieldValueMap.put('site_department__c', 'Test Department');          
            fieldValueMap.put('transaction_type__c', 'transactional');
            fieldValueMap.put('account_profile__c', 'Fabless - Emerging');            
            fieldValueMap.put('Process_Tech_Interested__c', 'Mature (> 0.11um)');
            fieldValueMap.put('region__c', 'APJ');
            fieldValueMap.put('Sales_Territory__c', 'Japan Korea');
            fieldValueMap.put('financial_territory__c', 'Japan Korea');          
            fieldValueMap.put('Copy_Address__c', true);
            fieldValueMap.put('Corporate_Address_1__c', 'Lee');            
            fieldValueMap.put('Corporate_Country__c', 'Japan');
            fieldValueMap.put('Organization_Unit__c', 'GF Investment LLC OU');
            fieldValueMap.put('bill_to_location__c', 'YES');
            fieldValueMap.put('total_employee__c', 100);          
            fieldValueMap.put('end_customer__c', 'people');
            fieldValueMap.put('Revenue_Potential__c', 'High Potential');            
            fieldValueMap.put('Target_Account__c', 'Yes');
            fieldValueMap.put('Fab_9_10__c','No');
            fieldValueMapsList.add(fieldValueMap);
        }
            
        List<Account> accList=AccountDataFactory.createAccounts(fieldValueMapsList,3);
        return accList;
        
     //   return acctList;
    }
    
    static Account_Team_Proxy__c createAccountTeamProxy(Id testAcctId) {        
        // Create Account Team Proxy        
        Account_Team_Proxy__c atp1 = new Account_Team_Proxy__c();       
        atp1.Account__c = testAcctId ;      
        User thisUser= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');      
        atp1.User__c = thisUser.Id ;        
        atp1.Team_Role__c = 'Account Manager';      
        atp1.Account_Access__c = 'Read/Write';      
        atp1.Opportunity_Access__c = 'Read/Write';      
                    
        insert atp1;        
                
        return atp1;        
    }
    
    static Opportunity createOpportunity1(Id testAcctId) {
        // Create Opportunity
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('AccountId',testAcctId);
        fieldValueMap.put('Name','Test Opportunity 1');  
        fieldValueMap.put('StageName','1. Discovery');
        fieldValueMap.put('CloseDate',Date.Today().addDays(10));  
        fieldValueMap.put('Target_Process_Node__c','14XM');
        fieldValueMap.put('Market_Segment__c','Automotive');  
        fieldValueMap.put('Process_Platform__c','GF Baseline');
        fieldValueMap.put('Fab_Split__c',100);          
        fieldValueMap.put('Process_Geometry__c','0.028UM');  
        fieldValueMap.put('Process_Family__c','Super Low Power');
        fieldValueMap.put('Opportunity_Sourcing_Type__c','First Source');  
        fieldValueMap.put('Fab_Assignment_1__c','FAB 3');
         
        return OpportunityDataFactory.createOpportunity(fieldValueMap);
        
    }   
    
    static Opportunity_Program__c createOpportunityProgram(Id testAcctId, Id testOpptyId) {
        // Create Opportunity Program
        Opportunity_Program__c testOpptyProgram = new Opportunity_Program__c();
        testOpptyProgram.Name = 'Test Opportunity 1';
        testOpptyProgram.Account__c = testAcctId;
        testOpptyProgram.Opportunity__c = testOpptyId;
        
        Insert testOpptyProgram;
        
        return testOpptyProgram;
    }
    
    static Device__c createDevice(Id testOpptyProgramId) {
        // Create Device
        Device__c device = new Device__c();
        device.Name = 'TESTDEVICEZAIH1234677';
        device.Opportunity_Program__c = testOpptyProgramId;
        device.Fab__c = 'Fab 3';
        device.GSOP_Assignment_Tapeout_Plan__c = 'No';
        device.Market_Segment__c = 'Mobility';
        device.Semiconductor_Device__c = 'Analog Amplifier';
        device.End_Customer__c = 'Test Customer';
        device.Device_Sourcing__c = '1st Source';
        device.Stage__c = 'Solutioning';
        device.Status__c = 'Active';
        device.Tapeout_Type__c = 'Customer MPW';
        device.End_Application__c = 'Cell Handset'; //added by abhishek
        device.Confidence_Level_Tapeout__c ='10'; //added by abhishek
        
        Insert device;
        
        return device;
    }
    
    static id createOpptyProgGap(Id testOpptyProgramId){
        Device_Gap__c gap = new Device_Gap__c(Opportunity_Program__c = testOpptyProgramId);
        insert gap;
        return gap.id;
    }
    
    static id createEDAReq(Id testOpptyProgramId){
        EDA_Requirement__c eda = new EDA_Requirement__c(Opportunity_Program__c = testOpptyProgramId);
        insert eda;
        return eda.id;
    }
    
    static void createQuarterlyRevenue(id opptyId){
        Quarterly_Revenue_Object__c qro= new Quarterly_Revenue_Object__c(Opportunity__c= opptyId,Date__c=System.today(),ASP__c=5,Volume__c=5, count__c = true);        
        insert qro;
    }
    
    static testMethod void testOpptyVoidStage() {
        
        //Account acct = getAccount('testing501');
        User u = [
            SELECT    Id
            FROM      User
            WHERE     HCM_Login_ID__c = 'E1006044'
        ];
        Test.startTest(); 
        Account acct =OpportunityTriggerTest.createAccount1();      
                
        Account_Team_Proxy__c atp = OpportunityTriggerTest.createAccountTeamProxy(acct.id);     
                
        Opportunity oppty = OpportunityTriggerTest.createOpportunity1(acct.id);     
        system.AssertEquals('First Source', oppty.Opportunity_Sourcing_Type__c);
                
        Opportunity_Program__c opptyPgm =  createOpportunityProgram(acct.id, oppty.id);     
                
        createQuarterlyRevenue(oppty.id);
        //Device__c dev = createDevice(opptyPgm.id);
       
        
        
        System.runAs(u) {
            oppty.Design_Win_Review_Status__c = 'Won';
            oppty.Date_Design_Win_Approved__c = system.today();
            oppty.DW_Quarter_Awarded__c = '2013-Q1';
            Oppty.Awarded_Amount__c = 100000;
            oppty.X1st_Product_Production_Date__c = date.today().addDays(5);
            oppty.Reset_High_End_Vol_to_Percentage__c = 10;
            oppty.Reset_Low_End_Vol_to_Percentage__c = 5;    
            oppty.Years_of_Production__c = 5;
            update oppty;
        }
       
       test.stoptest();
        
    }

    static testMethod void testOpptyApttus() {
        
        //Account acct = getAccount('testing501');
        User u = [
            SELECT    Id
            FROM      User
            WHERE     HCM_Login_ID__c = 'E1006044'
        ];
        Test.startTest(); 
        Account acct =OpportunityTriggerTest.createAccount1(); 
        Opportunity oppty = OpportunityTriggerTest.createOpportunity1(acct.id);   
        system.AssertEquals('First Source', oppty.Opportunity_Sourcing_Type__c);
        Opportunity_Program__c opptyPgm =  createOpportunityProgram(acct.id, oppty.id);        
        Device__c dev = createDevice(opptyPgm.id);
        
        RecordType recType = [Select Id
                                From RecordType 
                               Where Name='Draft' And
                                     SobjectType = 'Apttus_Proposal__Proposal__c'];        
            
        //Product2 processTech = createProduct('Test Process Technology', 'PROCESSTECH0001', null, 'PROCESSTECHCOM0003'); 
        
        Product2 processTech = new Product2(Name = 'Test Process Technology',
                                     Family = 'PROCESSTECHCOM0003',
                                     ProductCode = 'PROCESSTECH0001',
                                     Product_External_ID__c = 'PROCESSTECH0001'+ Math.Random(),
                                     BEOL__c = 'AA BB CC',
                                     FEOL__c = 'DD EE FF',
                                     APTPS_Core_Voltage__c = '1.50',
                                     APTPS_IO_Voltage__c = '1.50',
                                     Geometry__c = '0.028nm',
                                     Mask_Sets__c = null,
                                     IsActive = True);
        
        insert processTech;       
        //Process__c pid1 = createProcess('Test PID 1', 'BB,CC,DD,EE', 'TESTP1ID000001', processTech.PT_Number__c);
        Process__c pid1 = new Process__c(Name = 'Test PID 1',
                                            Mask_Layers__c = 'BB,CC,DD,EE',
                                            PID_Number__c = 'TESTP1ID000001',
                                            Process_Technology__c = processTech.PT_Number__c);
        insert pid1;
        
        //Create a proposal from Device
        Apttus_Proposal__Proposal__c proposal = 
                    new Apttus_Proposal__Proposal__c(Apttus_Proposal__Description__c = 'Test Proposal Description ...',
                                                     Device__c = dev.Id,                                                     
                                                     Apttus_Proposal__Opportunity__c = oppty.Id,
                                                     Apttus_Proposal__Account__c = acct.Id,                                                   
                                                     sram__c = 'Yes',
                                                     sram_gate_orientation__c = 'Horizontal',
                                                     aclv_gate_orientation__c = 'Horizontal',
                                                     gate_orientation_PFET__c = 'Horizontal',
                                                     ptrf_rotation__c = '90',
                                                     Devices__c='Test<:>Test3',
                                                     APTPS_Primary__c=true,
                                                     Purpose_of_the_Configuration__c='Final',                                                     
                                                     Apttus_Proposal__Approval_Stage__c='Process Flow Accepted',
                                                     process_technology__c = 'PT1002562',
                                                     Assigned_Process_ID__c = pid1.Id,
                                                     approval_check__c = false);
        insert proposal;
        
        OpportunityProcess__c oppprces =new OpportunityProcess__c();
          
        oppprces.Geometry__c ='0.028UM';
                oppprces.Process_Family__c ='Super Low Power';
                oppprces.FAB__c ='FAB 1';
                oppprces.Process_ID__c='434-343-34';                
        insert oppprces;        
        RecursionPrevent.run = true;
        update oppty;
        test.stoptest();
        
    }    
    
    static testMethod void testOpportunity1() {
        test.startTest();
        Account acct =OpportunityTriggerTest.createAccount1();
        Account_Team_Proxy__c atp = OpportunityTriggerTest.createAccountTeamProxy(acct.id);
        Opportunity oppty = OpportunityTriggerTest.createOpportunity1(acct.id);
        system.AssertEquals('First Source', oppty.Opportunity_Sourcing_Type__c);
        oppty.X1st_Product_Production_Date__c = date.today().addDays(5);
        Account ac = new Account();
        ac.name = 'test101';
        ac.Stage__c = 'Unqualified';
        ac.Account_Type__c = 'Customer';
        ac.Corporate_Address_1__c = 'test';
        ac.Copy_Address__c=true;
        ac.Corporate_City__c='sg';
        ac.Corporate_Country__c='sg';
        ac.Financial_Territory__c='Greater China';
        ac.Region__c='APJ';
        insert ac;  
        oppty.AccountId = ac.Id; 
        try{     
        update oppty;
        }catch(Exception expc){}
        test.stopTest();
    }
    
    static testMethod void testOpportunity2() {
        test.startTest();
        ConstantOpportunityValueStoreList__c cs = new ConstantOpportunityValueStoreList__c();
        cs.name = 'MEMS';
        cs.value__c = 'MEMS';
        insert cs;
        Account acct =OpportunityTriggerTest.createAccount1();
        Account_Team_Proxy__c atp = OpportunityTriggerTest.createAccountTeamProxy(acct.id);
        Opportunity oppty = OpportunityTriggerTest.createOpportunity1(acct.id);
        system.AssertEquals('First Source', oppty.Opportunity_Sourcing_Type__c);
        oppty.Design_Win_Review_Status__c = 'Submitted for Review';
        oppty.Target_Process_Node__c = 'MEMS';
        oppty.X1st_Product_Production_Date__c = date.today().addDays(5);
        createQuarterlyRevenue(oppty.id);        
        update oppty;
        test.stopTest();
    }
    
    static testMethod void testOpportunity3() {
        test.startTest();
        ConstantOpportunityValueStoreList__c cs = new ConstantOpportunityValueStoreList__c();
        cs.name = '0.11G';
        cs.value__c = '0.11G';
        insert cs;
        Account acct =OpportunityTriggerTest.createAccount1();
        Account_Team_Proxy__c atp = OpportunityTriggerTest.createAccountTeamProxy(acct.id);
        Opportunity oppty = OpportunityTriggerTest.createOpportunity1(acct.id);
        system.AssertEquals('First Source', oppty.Opportunity_Sourcing_Type__c);
        oppty.Design_Win_Review_Status__c = 'Submitted for Review';
        oppty.Target_Process_Node__c = '0.11G';
        update oppty;
        test.stopTest();
    }
    
    static testMethod void testOpportunity4() {
        test.startTest();
        ConstantOpportunityValueStoreList__c cs = new ConstantOpportunityValueStoreList__c();
        cs.name = '10LPP';
        cs.value__c = '10LPP';
        insert cs;
        Account acct =OpportunityTriggerTest.createAccount1();
        Account_Team_Proxy__c atp = OpportunityTriggerTest.createAccountTeamProxy(acct.id);
        Opportunity oppty = OpportunityTriggerTest.createOpportunity1(acct.id);
        system.AssertEquals('First Source', oppty.Opportunity_Sourcing_Type__c);
        oppty.Design_Win_Review_Status__c = 'Submitted for Review';
        oppty.Target_Process_Node__c = '10LPP';
        update oppty;
        test.stopTest();
    }
    
    static testMethod void testOpportunity5() {
        test.startTest();
        ConstantOpportunityValueStoreList__c cs = new ConstantOpportunityValueStoreList__c();
        cs.name = '20LPM';
        cs.value__c = '20LPM';
        insert cs;
        Account acct =OpportunityTriggerTest.createAccount1();
        Account_Team_Proxy__c atp = OpportunityTriggerTest.createAccountTeamProxy(acct.id);
        Opportunity oppty = OpportunityTriggerTest.createOpportunity1(acct.id);
        system.AssertEquals('First Source', oppty.Opportunity_Sourcing_Type__c);
        oppty.Design_Win_Review_Status__c = 'Submitted for Review';
        oppty.Target_Process_Node__c = '20LPM';
        update oppty;
        test.stopTest();
    }
    
    static testMethod void testOpportunity6() {
        test.startTest();
        ConstantOpportunityValueStoreList__c cs = new ConstantOpportunityValueStoreList__c();
        cs.name = '28FDSOI';
        cs.value__c = '28FDSOI';
        insert cs;
        Account acct =OpportunityTriggerTest.createAccount1();
        Account_Team_Proxy__c atp = OpportunityTriggerTest.createAccountTeamProxy(acct.id);
        Opportunity oppty = OpportunityTriggerTest.createOpportunity1(acct.id);
        system.AssertEquals('First Source', oppty.Opportunity_Sourcing_Type__c);
        oppty.Design_Win_Review_Status__c = 'Submitted for Review';
        oppty.Target_Process_Node__c = '28FDSOI';
        update oppty;
        test.stopTest();
    }
    
    static testMethod void testOpportunity7() {
        test.startTest();
        ConstantOpportunityValueStoreList__c cs = new ConstantOpportunityValueStoreList__c();
        cs.name = '40BCDlite';
        cs.value__c = '40BCDlite';
        insert cs;
        Account acct =OpportunityTriggerTest.createAccount1();
        Account_Team_Proxy__c atp = OpportunityTriggerTest.createAccountTeamProxy(acct.id);
        Opportunity oppty = OpportunityTriggerTest.createOpportunity1(acct.id);
        system.AssertEquals('First Source', oppty.Opportunity_Sourcing_Type__c);
        oppty.Design_Win_Review_Status__c = 'Submitted for Review';
        oppty.Target_Process_Node__c = '40BCDlite';
        update oppty;
        test.stopTest();
    }
    
    static testMethod void testOpportunity8() {
        test.startTest();
        ConstantOpportunityValueStoreList__c cs = new ConstantOpportunityValueStoreList__c();
        cs.name = '55LPE';
        cs.value__c = '55LPE';
        insert cs;
        Account acct =OpportunityTriggerTest.createAccount1();
        Account_Team_Proxy__c atp = OpportunityTriggerTest.createAccountTeamProxy(acct.id);
        Opportunity oppty = OpportunityTriggerTest.createOpportunity1(acct.id);
        system.AssertEquals('First Source', oppty.Opportunity_Sourcing_Type__c);
        Opportunity_Program__c opptyPgm =  createOpportunityProgram(acct.id, oppty.id);
        opptyPgm.Is_Private_Copy__c = true;
        update opptypgm;
        
        oppty.Design_Win_Review_Status__c = 'Submitted for Review';
        oppty.Target_Process_Node__c = '55LPE';
        oppty.IsPrivate = true;
        update oppty;
        
        Opportunity_TriggerHelper helper = new Opportunity_TriggerHelper();        
        helper.updateDevices(new set<id>{oppty.Id});
        //helper.validateAccountChange(new set<id>{oppty.Id});
        //helper.updateOpptyRelatedRecords(new set<id>{oppty.Id});
        test.stopTest();
    }
    
    static testMethod void testOpportunity9() {
        test.startTest();
        /*List<Opportunity_Control_Point_Approvals__c> ocp = new List<Opportunity_Control_Point_Approvals__c>();
        for(integer i=0; i<3; i++){
            Opportunity_Control_Point_Approvals__c oc = new Opportunity_Control_Point_Approvals__c(Name='TestAccount' + i, Market_Segment__c= 'Consumer',PLM__c='Mainstream');
            ocp.add(oc);
        }
        insert ocp; */
        Account acct =OpportunityTriggerTest.createAccount1();
        
        Opportunity opp = new Opportunity(); 
        opp.Name = 'Test Opportunity';                        
        opp.StageName = '4. Decision';
        opp.CloseDate = Date.Today().addDays(10);
        opp.Target_Process_Node__c = '28HPP';
        //opp.Market_Segment__c = 'Mobility';
        opp.Process_Platform__c = 'GF Baseline';
        opp.Fab_Split__c = 100;
        opp.Process_Geometry__c = '0.032UM';
        opp.Process_Family__c = 'Generic / Nominal';
        opp.Opportunity_Sourcing_Type__c = 'Second Source';
        opp.Fab_Assignment_1__c = 'FAB 3';
        opp.Product_Line__c = 'ASIC';
        insert opp;
        system.AssertEquals('Second Source', opp.Opportunity_Sourcing_Type__c);
        
        Opportunity opty = [Select id , Market_Segment__c from opportunity where id=:opp.id];
        opty.Market_Segment__c='Consumer';
        Update opty;
        test.stopTest();
    }
    
    // Clip Level Implementation for Deal Grading
    static testmethod void beforeUpdateTest(){
        Account acct =OpportunityTriggerTest.createAccount1();
         Clip_Level_Exemption__c testcl=new Clip_Level_Exemption__c();
            testcl.Name='Rule101';
            testcl.Target_Process_Node__c='65CMOS';
            testcl.Brand__c='ASIC';
            testcl.LTR_Min__c = -0.10;
            testcl.Type_of_Exception__c='Clip level'; 
            testcl.Active__c=true;
            testcl.Account__c = acct.id;
        insert testcl;
        
        Clip_Level_Exemption__c testcl1=new Clip_Level_Exemption__c();
            testcl1.Name                    =   'Rule102';
            testcl1.LTR_Min__c              =   -0.25;
            testcl1.Type_of_Exception__c    =   'Client Exemption';
            testcl1.Active__c               =   true;
            testcl1.Account__c = acct.id;
        insert testcl1;
        
        Opportunity oppty = OpportunityTriggerTest.createOpportunity1(acct.id);
        system.AssertEquals('First Source', oppty.Opportunity_Sourcing_Type__c);
        
    }
    
    
    private static Account getAccount(string AccountName)
            {
                Account testAcct= [SELECT Id, Name FROM Account Where Name =: AccountName];
        
                return testAcct;
            }
            
    static testMethod void Myunittest1() {
        
        Account ac = new Account();
        ac.name = 'test101';
        ac.Stage__c = 'Unqualified';
        ac.Account_Type__c = 'Customer';
        ac.Corporate_Address_1__c = 'test';
        ac.Copy_Address__c=true;
        ac.Corporate_City__c='sg';
        ac.Corporate_Country__c='sg';
        ac.Financial_Territory__c='Greater China';
        ac.Region__c='APJ';
        insert ac;
        
         //getAccount('testing501');
        Test.startTest();
        
        Account acct =OpportunityTriggerTest.createAccount1(); 
        Opportunity oppty = OpportunityTriggerTest.createOpportunity1(acct.id);
        system.AssertEquals('First Source', oppty.Opportunity_Sourcing_Type__c);
        
        Opportunity_Program__c opptyPgm =  createOpportunityProgram(acct.id, oppty.id);
        //opptyPgm.Is_Private_Copy__c = true;
        //update opptypgm;
        
        Device__c dev = createDevice(opptyPgm.id);
       
       
       
            //oppty.Design_Win_Review_Status__c = 'Won';
            //oppty.accountid = ac.id;
            oppty.Create_Program__c=true;
            oppty.X1st_Product_Production_Date__c = date.newInstance(2025,12,25);
            oppty.Years_of_Production__c = 1;
            RecursionPrevent.run = true;
            checkRecursive.run = true;
            update oppty;
       
       Test.stoptest();
        
    }
    
    /*static testMethod void Myunittest2() {
        Test.startTest();
		 Account acct =OpportunityTriggerTest.createAccount1();
        Environment_Variable__c ec = [Select id,name, value__c from Environment_Variable__c where name='OPPTY_STAGE_VOID' ];//new Environment_Variable__c();
        //ec.Name = 'OPPTY_STAGE_VOID';
        ec.Value__c = '10. Void';
        update ec;
        
         
        Opportunity oppty = OpportunityTriggerTest.createOpportunity1(acct.id);
        system.AssertEquals('First Source', oppty.Opportunity_Sourcing_Type__c);
        
        Opportunity_Program__c opptyPgm =  createOpportunityProgram(acct.id, oppty.id);
        Device__c dev = createDevice(opptyPgm.id);
        dev.Status__c = 'Void';
        update dev;
        oppty.AM_CP3__c=true;
        oppty.FAE_CP3__c=true;
        oppty.PLM_CP3__c=true;
        oppty.MarketSegment_CP3__c=true;
        oppty.stagename = '10. Void';   
        
            //oppty.Design_Win_Review_Status__c = 'Won';            
            
          update oppty;
       
       Test.stoptest();
        
    }*/
    
    static testMethod void Myunittest3() {
        
        User u = [
            SELECT    Id
            FROM      User
            WHERE     HCM_Login_ID__c = 'E1006044'
        ];
        Test.startTest();
        Environment_Variable__c ec = [Select id,name, value__c from Environment_Variable__c where name='OPPTY_STAGE_VOID' ];//new Environment_Variable__c();
        //ec.Name = 'OPPTY_STAGE_VOID';
        ec.Value__c = '10. Void';
        update ec;
        
        Account acct =OpportunityTriggerTest.createAccount1(); 
        Opportunity oppty = OpportunityTriggerTest.createOpportunity1(acct.id);
        system.AssertEquals('First Source', oppty.Opportunity_Sourcing_Type__c);
        //createQuarterlyRevenue(oppty.Id);
       System.runAs(u) {
            oppty.Design_Win_Review_Status__c = 'Won';
            //oppty.stagename = '10. Void';
            oppty.Design_Win_Review_Status__c = 'Won';
            oppty.Date_Design_Win_Approved__c = date.newInstance(2025,12,24);
            oppty.Stategic_Marketing_Approval_Date__c = Date.today();
            
            //oppty.Design_Win_Review_Status__c
            oppty.DW_Quarter_Awarded__c = '2015-Q4';
            oppty.Awarded_Amount__c = 200;
            RecursionPrevent.run = true;
            checkRecursive.run = true;
            update oppty;
       }
       Test.stoptest();
        
    }
    
    static testMethod void Myunittest4() {  
        RecordType recType = [select id from RecordType where Name='Customer' and SobjectType='Account' limit 1];
        Account acc = new Account(Name='Test Account',RecordTypeId=recType.id,Site_Department__c='IT',Sub_Type__c='Indirect',
                                Transaction_Type__c='Non-Transactional',Region__c='US',Bill_To_Address_1__c='Test Address',
                                Bill_To_City__c='Test City',Bill_To_Country__c='India',Corporate_Address_1__c='Test Address',
                                Corporate_City__c='Test City',Corporate_Country__c='India', Account_Manager__c = userinfo.getuserid());
        
        insert acc;
           
        Opportunity opp = new Opportunity(Name='Test Opportunity',AccountId=acc.Id,StageName='1. Discovery',Market_Segment__c='Automotive',
                                        Target_Process_Node__c='14XM',Process_Platform__c='GF Baseline',Opportunity_Sourcing_Type__c='First Source',
                                        Fab_Split__c=100,CloseDate = date.newinstance(2012, 12, 21),Process_Geometry__c='0.014UM',
                                        Fab_Assignment_1__c = 'FAB 1',
                                        Process_Family__c = 'Super Low Power');
        
        insert opp;
        system.AssertEquals('First Source', opp.Opportunity_Sourcing_Type__c);
        
        Opportunity_Program__c opProg = new Opportunity_Program__c(Name='Test OppProg',Account__c=acc.Id,Opportunity__c=opp.Id);
        insert opProg;
               
        test.startTest();
        String stageTapeout = 'Tapeout';
        //Updating device stage with Tapeout
        Device__c dev = new Device__c();
        dev.Name = 'TESTDEVICE1313';
        dev.Stage__c = 'Design In';
        dev.Status__c = 'Active';
        dev.Account__c = acc.Id;
        dev.Opportunity2__c = opp.Id;
        dev.Opportunity_Program__c = opProg.Id;
        dev.Market_Segment__c = 'Automotive';
        dev.Semiconductor_Device__c = 'Analog Regulator';
        dev.End_Application__c = 'Body';
        dev.Device_Sourcing__c = '3rd Source';
        dev.Tapeout_Type__c = 'Customer MPW';
        dev.Siebel_Device_ID__c = '0987654321';
        dev.IP_Gap__c = false;
        dev.Actual_Tapeout_Date__c = date.newInstance(2013,5,20);
        dev.Forecasted_Lot_Start_Date__c = date.newInstance(2013,5,20);
        dev.Original_Forecasted_Tapeout_Date__c = date.newInstance(2013,3,4);
        dev.Current_Forecast_Tapeout_Date__c = date.newInstance(2013,3,4);
        dev.Fab__c = 'FAB 2';
        dev.Confidence_Level_Tapeout__c = '100';         
        insert dev;
        Opportunity_TriggerHelper helper = new Opportunity_TriggerHelper();
        try{
            helper.validateAccountChange(new set<Id>{opp.Id});
            helper.updateOpptyRelatedRecords(new set<Id>{opp.id});
            helper.updateOpptyRelatedRecordsToReadOnly(new set<Id>{opp.id});
        }catch(Exception ex){}
        Test.stopTest();
    }
    
    
    static testMethod void Myunittest5() {
        Test.startTest();  
        RecordType recType = [select id from RecordType where Name='Customer' and SobjectType='Account' limit 1];
        Account acc = new Account(Name='Test Account',RecordTypeId=recType.id,Site_Department__c='IT',Sub_Type__c='Indirect',
                                Transaction_Type__c='Non-Transactional',Region__c='US',Bill_To_Address_1__c='Test Address',
                                Bill_To_City__c='Test City',Bill_To_Country__c='India',Corporate_Address_1__c='Test Address',
                                Corporate_City__c='Test City',Corporate_Country__c='India', Account_Manager__c = userinfo.getuserid());
        
        insert acc;
           
        Opportunity opp = new Opportunity(Name='Test Opportunity',AccountId=acc.Id,StageName='1. Discovery',Market_Segment__c='Automotive',
                                        Target_Process_Node__c='14XM',Process_Platform__c='GF Baseline',Opportunity_Sourcing_Type__c='First Source',
                                        Fab_Split__c=100,CloseDate = date.newinstance(2012, 12, 21),Process_Geometry__c='0.014UM',
                                        Fab_Assignment_1__c = 'FAB 1',
                                        Process_Family__c = 'Super Low Power');
        
        insert opp;   
        system.AssertEquals('First Source', opp.Opportunity_Sourcing_Type__c);
        
        system.debug('>>>>>>>>>>>>>>RecursionPrevent.runOnce():'+RecursionPrevent.runOnce());
        RecursionPrevent.run = true;
        checkRecursive.run = true;
        update opp;
        system.debug('>>>>>>>>>>>>>>RecursionPrevent.runOnce():'+RecursionPrevent.runOnce());
        Test.stopTest();    
     }     
    
     static testMethod void testUpdateLastEditorOfIPDF() {
        Test.startTest();
        
        Account acct = OpportunityTriggerTest.createAccount1();
        Opportunity oppty = OpportunityTriggerTest.createOpportunity1(acct.id);
        system.AssertEquals('First Source', oppty.Opportunity_Sourcing_Type__c);
        
        oppty.Include_PreDiscovery_in_Demand_Forecast__c = TRUE;        
        update oppty;
        
        Test.stopTest();
    }     

    static testMethod void testOpptyVoidStageNew() {
        
        //Account acct = getAccount('testing501');
        User u = [
            SELECT    Id
            FROM      User
            WHERE     HCM_Login_ID__c = 'E1006044'
        ];
        Test.startTest(); 
        Account acct =OpportunityTriggerTest.createAccount1();      
                
        Account_Team_Proxy__c atp = OpportunityTriggerTest.createAccountTeamProxy(acct.id);     
                
        Opportunity oppty = OpportunityTriggerTest.createOpportunity1(acct.id);     
        system.AssertEquals('First Source', oppty.Opportunity_Sourcing_Type__c);
        
        Informal_Quote__c infQuote = new Informal_Quote__c(Product_Category__c = 'Wafer', Budgetary_Quote_Status__c = 'Approved', Account__c = oppty.AccountId, Opportunity__c = oppty.id);
        insert infQuote;
        
        infQuote.Budgetary_Quote_Status__c =  'Approved';
        update infQuote;
 
        Opportunity_Program__c opptyPgm =  createOpportunityProgram(acct.id, oppty.id);     
                
        createQuarterlyRevenue(oppty.id);
        //Device__c dev = createDevice(opptyPgm.id);
        
        oppty.Informal_Quote__c = infQuote.id;        
        update oppty;
       
       test.stoptest();
        
    }
    
    static testMethod void testOpptyVoidStageNew1() {
        
        //Account acct = getAccount('testing501');
        User thisUser= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        Test.startTest(); 
        Account acct =OpportunityTriggerTest.createAccount1();      
                
        Account_Team_Proxy__c atp = OpportunityTriggerTest.createAccountTeamProxy(acct.id);  

        Opportunity_Control_Point_Approvals__c oppContrlapp = new Opportunity_Control_Point_Approvals__c(Name = 'Testapp', Market_Segment__c = 'Automotive', PLM__c = 'ASIC', User__c = thisUser.id);
        insert oppContrlapp;        
        Opportunity oppty = OpportunityTriggerTest.createOpportunity1(acct.id);     
        system.AssertEquals('First Source', oppty.Opportunity_Sourcing_Type__c);
 
        Opportunity_Program__c opptyPgm =  createOpportunityProgram(acct.id, oppty.id);     
                
        oppty.Market_Segment__c = 'Automotive';  
        oppty.product_line__c = 'ASIC';
        update oppty;
       
       test.stoptest();
        
    }
}