@istest
public class OPP_GenerateDemandGenCtrlTest {
    @testSetup static void dataSetup() {
        DataUtilTest.loadEnvironmentVariables();
        TriggerHandler.bypass('User_TriggerHandler');
        TriggerHandler.bypass('Opportunity_TriggerHandler');
        TriggerHandler.bypass('Account_TriggerHandler');
        // Create Account
        Account testAcct = new Account();
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
        testAcct = AccountDataFactory.createAccount(fieldValueMap);
    
        // Create Opportunity
        Opportunity testOppty = new Opportunity();
        testOppty.Name = 'Test Opportunity 1';
        testOppty.AccountId = testAcct.Id;
        testOppty.Worst_Issue_Status__c = 'G - Major Issue. Action in Place, High Conf of Closure. Date Not in Critical Path';
        testOppty.Worst_Issue_Status_P__c = 'G - Major Issue. Action in Place, High Conf of Closure. Date Not in Critical Path';
        testOppty.StageName = '1. Discovery';
        testOppty.CloseDate = Date.Today().addDays(10);
        testOppty.Target_Process_Node__c = '14XM';
        testOppty.Market_Segment__c = 'Mobility';
        testOppty.Process_Platform__c = 'GF Baseline';
        testOppty.Fab_Split__c = 100;
        testOppty.Fab_Assignment_1__c = 'FAB 6';
        testOppty.Process_Geometry__c='0.13UM';
        testOppty.Process_Family__c='Low Power / Ultra Low Leakage';
        testOppty.AM_CP1__c = true;
        testOppty.FAE_CP1__c = true;
        testOppty.AM_CP2__c = true;
        testOppty.FAE_CP2__c = true;
        testOppty.PLM_CP2__c = true;
        testOppty.MarketSegment_CP2__c = true;
        insert testOppty;
        testOppty.StageName = '2. Assessment';
        update testOppty;
        // Create Opportunity Program
        Opportunity_Program__c testOpptyProgram = new Opportunity_Program__c();
        testOpptyProgram.Name = 'Test Opportunity 1';
        testOpptyProgram.Account__c = testAcct.Id;
        testOpptyProgram.Opportunity__c = testOppty.Id;
        Test.startTest();
        insert testOpptyProgram;
        
        Opportunity o = [SELECT Id FROM Opportunity WHERE Name='Test Opportunity 1' LIMIT 1];
        Opportunity_Program__c op = [SELECT Id FROM Opportunity_Program__c WHERE Name='Test Opportunity 1' LIMIT 1];
        
        // Create Opportunity Issues
        List <Device_Gap__c> opportunityIssueList = new List <Device_Gap__c> ();
        
        // Create the Opportunity Issue
        Device_Gap__c dg = new Device_Gap__c();
        dg.Issue_Comments__c = 'Price Too High';
        dg.Area__c = 'Price';
        dg.Improve_Prob__c = 20;
        dg.Need_by_Date__c = Date.Today().addMonths(1);
        dg.Select_Status__c = 'R3 - Help Requested from Council';
        dg.Previous_Status__c = 'G - Major Issue. Action in Place, High Conf of Closure. Date Not in Critical Path';
        dg.Stage__c = 'New';
        dg.Opportunity__c = o.Id;
        dg.Opportunity_Program__c = op.Id;
        dg.Select_Status__c = 'G - Major Issue. Action in Place, High Conf of Closure. Date Not in Critical Path';
        opportunityIssueList.add (dg);
        
        Device_Gap__c dg1 = new Device_Gap__c();
        dg1.Issue_Comments__c = 'Price Too High 2';
        dg1.Area__c = 'Price';
        dg1.Select_Status__c = 'Y - Major Issue, Action in Place, Med Conf of Closure. Date in Critical Path';
        dg.Previous_Status__c = 'Y - Major Issue, Action in Place, Med Conf of Closure. Date in Critical Path';
        dg1.Improve_Prob__c = 20;
        dg1.Need_by_Date__c = Date.Today().addMonths(1);
        dg1.Stage__c = 'New';
        dg1.Opportunity__c = o.Id;
        dg1.Opportunity_Program__c = op.Id;
        
        Device_Gap__c dg2 = new Device_Gap__c();
        dg2.Issue_Comments__c = 'Price Too High 2';
        dg2.Area__c = 'Price';
        dg2.Select_Status__c = 'R1 - Blocked Major Issues Need Resolved';
        dg.Previous_Status__c = 'R1 - Blocked Major Issues Need Resolved';
        dg2.Improve_Prob__c = 20;
        dg2.Need_by_Date__c = Date.Today().addMonths(1);
        dg2.Stage__c = 'New';
        dg2.Opportunity__c = o.Id;
        dg2.Opportunity_Program__c = op.Id;
        opportunityIssueList.add(dg2);
        
        Device_Gap__c dg3 = new Device_Gap__c();
        dg3.Issue_Comments__c = 'Price Too High 2';
        dg3.Area__c = 'Price';
        dg3.Select_Status__c = 'B - Major Issue Closed';
        dg3.Select_Status__c = 'R2 - Major Issue, Action in Critical Path to Revenue with Low/Med Prob';
        dg3.Improve_Prob__c = 20;
        dg3.Need_by_Date__c = Date.Today().addMonths(1);
        dg3.Stage__c = 'New';
        dg3.Opportunity__c = o.Id;
        dg3.Opportunity_Program__c = op.Id;
        opportunityIssueList.add(dg3);
        
        insert opportunityIssueList;
        Test.stopTest();
    }
    static testMethod void testOpportunityDemandGen() {
        Opportunity o = [SELECT Id, Name FROM Opportunity WHERE Name='Test Opportunity 1' LIMIT 1];
        PageReference pageRef = Page.OPP_GenerateDemandGen;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('idList',o.id);
        OPP_GenerateDemandGenCtrl obj=new OPP_GenerateDemandGenCtrl();        
    } 
    static testMethod void testOpportunityDemandGen3() {
        Opportunity o = [SELECT Id, Name FROM Opportunity WHERE Name='Test Opportunity 1' LIMIT 1];
        o.Worst_Issue_Status__c = 'Y - Major Issue, Action in Place, Med Conf of Closure. Date in Critical Path';
        o.Worst_Issue_Status_P__c = 'Y - Major Issue, Action in Place, Med Conf of Closure. Date in Critical Path';
        update o;
        PageReference pageRef = Page.OPP_GenerateDemandGen;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('idList',o.id);
        OPP_GenerateDemandGenCtrl obj=new OPP_GenerateDemandGenCtrl();        
    } 

    static testMethod void testOpportunityDemandGen1() {
        Opportunity o = [SELECT Id, Name FROM Opportunity WHERE Name='Test Opportunity 1' LIMIT 1];
        o.Worst_Issue_Status__c = 'R1 - Blocked Major Issues Need Resolved';
        o.Worst_Issue_Status_P__c = 'R1 - Blocked Major Issues Need Resolved';
        update o;
        PageReference pageRef = Page.OPP_GenerateDemandGen;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('idList',o.id);
        OPP_GenerateDemandGenCtrl obj=new OPP_GenerateDemandGenCtrl();        
    } 
    static testMethod void testOpportunityDemandGen4() {
        Opportunity o = [SELECT Id, Name FROM Opportunity WHERE Name='Test Opportunity 1' LIMIT 1];
        o.Worst_Issue_Status__c = 'R2 - Major Issue, Action in Critical Path to Revenue with Low/Med Prob';
        o.Worst_Issue_Status_P__c = 'R2 - Major Issue, Action in Critical Path to Revenue with Low/Med Prob';
        update o;
        PageReference pageRef = Page.OPP_GenerateDemandGen;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('idList',o.id);
        OPP_GenerateDemandGenCtrl obj=new OPP_GenerateDemandGenCtrl();        
    } 
    static testMethod void testOpportunityDemandGen5() {
        Opportunity o = [SELECT Id, Name FROM Opportunity WHERE Name='Test Opportunity 1' LIMIT 1];
        o.Worst_Issue_Status__c = 'R3 - Help Requested from Council';
        o.Worst_Issue_Status_P__c = 'R3 - Help Requested from Council';
        update o;
        PageReference pageRef = Page.OPP_GenerateDemandGen;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('idList',o.id);
        OPP_GenerateDemandGenCtrl obj=new OPP_GenerateDemandGenCtrl();        
    } 
    static testMethod void testOpportunityDemandGen2() {
        Opportunity o = [SELECT Id, Name FROM Opportunity WHERE Name='Test Opportunity 1' LIMIT 1];
        o.Worst_Issue_Status__c = 'B - Major Issue Closed';
        o.Worst_Issue_Status_P__c = 'B - Major Issue Closed';
        update o;
        PageReference pageRef = Page.OPP_GenerateDemandGen;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('idList',o.id);
        OPP_GenerateDemandGenCtrl obj=new OPP_GenerateDemandGenCtrl();        
    } 
}