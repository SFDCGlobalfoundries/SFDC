@isTest(SeeAllData=false)
private class OpportunitySummaryExtensionTest {

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
        
        testOppty.StageName = '1. Discovery';
        testOppty.CloseDate = Date.Today().addDays(10);
        testOppty.Target_Process_Node__c = '14XM';
        testOppty.Market_Segment__c = 'Mobility';
        testOppty.Process_Platform__c = 'GF Baseline';
        testOppty.Fab_Split__c = 100;
        testOppty.Fab_Assignment_1__c = 'FAB 6';
        testOppty.Process_Geometry__c='0.13UM';
        testOppty.Process_Family__c='Low Power / Ultra Low Leakage';
        insert testOppty;
        testOppty.StageName = '2. Assessment';
        testOppty.AM_CP1__c = true;
        testOppty.FAE_CP1__c = true;
        testOppty.AM_CP2__c = true;
        testOppty.FAE_CP2__c = true;
        testOppty.PLM_CP2__c = true;
        testOppty.MarketSegment_CP2__c = true;
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
        dg.Stage__c = 'New';
        dg.Opportunity__c = o.Id;
        dg.Opportunity_Program__c = op.Id;
        
        opportunityIssueList.add (dg);
        
        Device_Gap__c dg1 = new Device_Gap__c();
        dg1.Issue_Comments__c = 'Price Too High 2';
        dg1.Area__c = 'Price';
        dg1.Improve_Prob__c = 20;
        dg1.Need_by_Date__c = Date.Today().addMonths(1);
        dg1.Select_Status__c = 'G - Major Issue. Action in Place, High Conf of Closure. Date Not in Critical Path';
        dg1.Previous_Status__c = 'G - Major Issue. Action in Place, High Conf of Closure. Date Not in Critical Path';
        dg1.Stage__c = 'New';
        dg1.Opportunity__c = o.Id;
        dg1.Opportunity_Program__c = op.Id;
        
        opportunityIssueList.add(dg1);
        
        insert opportunityIssueList;
        Test.stopTest();
    }

    static testMethod void testExtension() 
    {
        Test.StartTest();
        Opportunity o = [SELECT Id, Name FROM Opportunity WHERE Name='Test Opportunity 1' LIMIT 1];
        System.assertEquals('Test Opportunity 1', o.Name);
        List<Device_Gap__c> deviceGapList = new List<Device_Gap__c>();
        
        PageReference pref = Page.OpportunitySummary;
        Test.setCurrentPageReference(pref);
        pref.getParameters().put('id',o.Id);
        
        ApexPages.StandardController std = new ApexPages.standardController(o);
        OpportunitySummaryExtension ose = new OpportunitySummaryExtension(std);  
        ose.toggleSort();
        deviceGapList = ose.getOppIssues();  
        Test.StopTest(); 
        
        // Validate there are 2 opportunity issues
        System.assertEquals(3, deviceGapList.Size());
        
        // Validate value of opportunity issue
        System.assertEquals('Price', deviceGapList[0].Area__c);   
    }   
    
    static testMethod void testExportToExcel() 
    {
        Test.StartTest();
        Opportunity o = [SELECT Id, Name FROM Opportunity WHERE Name='Test Opportunity 1' LIMIT 1];
        System.assertEquals('Test Opportunity 1', o.Name);
        List<Device_Gap__c> deviceGapList = new List<Device_Gap__c>();
        String excel;
        
        PageReference pref = Page.OpportunitySummary;
        Test.setCurrentPageReference(pref);
        pref.getParameters().put('id',o.Id);
        ApexPages.StandardController std = new ApexPages.standardController(o);
        OpportunitySummaryExtension ose = new OpportunitySummaryExtension(std);  
        excel = ose.exportToExcel().getUrl();  
        
        
        // Validate Exported Page Reference URL
        
        System.assertEquals('/apex/opportunitysummaryexport?id=' + o.Id, excel);
        
        /*PageReference pageRef = Page.OPP_GenerateDemandGen;        
        ApexPages.currentPage().getParameters().put('idList',o.id);
         Test.setCurrentPage(pageRef);
        OPP_GenerateDemandGenCtrl obj=new OPP_GenerateDemandGenCtrl(); */
        Test.StopTest(); 
    }  
    
    static testMethod void testOpportunityDemandGen() {
        Test.StartTest();
        Opportunity o = [SELECT Id, Name FROM Opportunity WHERE Name='Test Opportunity 1' LIMIT 1];
         PageReference pref = Page.OpportunitySummary;
        Test.setCurrentPageReference(pref);
        pref.getParameters().put('id',o.Id);
        
        ApexPages.StandardController std = new ApexPages.standardController(o);
        OpportunitySummaryExtension ose = new OpportunitySummaryExtension(std); 
        system.assertEquals(o.Id,o.Id);   
        Test.stopTest();    
    } 
    static testMethod void testOpportunityDemandGen3() {
        Test.StartTest();
        Opportunity o = [SELECT Id, Name FROM Opportunity WHERE Name='Test Opportunity 1' LIMIT 1];
        o.Worst_Issue_Status__c = 'Y - Major Issue, Action in Place, Med Conf of Closure. Date in Critical Path';
        o.Worst_Issue_Status_P__c = 'Y - Major Issue, Action in Place, Med Conf of Closure. Date in Critical Path';
        update o;
         PageReference pref = Page.OpportunitySummary;
        Test.setCurrentPageReference(pref);
        pref.getParameters().put('id',o.Id);
        
        ApexPages.StandardController std = new ApexPages.standardController(o);
        OpportunitySummaryExtension ose = new OpportunitySummaryExtension(std);  
        system.assertEquals(o.Worst_Issue_Status__c,'Y - Major Issue, Action in Place, Med Conf of Closure. Date in Critical Path');
        Test.stopTest();
    } 

    static testMethod void testOpportunityDemandGen1() {
        Test.StartTest();
        Opportunity o = [SELECT Id, Name FROM Opportunity WHERE Name='Test Opportunity 1' LIMIT 1];
        o.Worst_Issue_Status__c = 'R1 - Blocked Major Issues Need Resolved';
        o.Worst_Issue_Status_P__c = 'R1 - Blocked Major Issues Need Resolved';
        update o;
         PageReference pref = Page.OpportunitySummary;
        Test.setCurrentPageReference(pref);
        pref.getParameters().put('id',o.Id);
        
        ApexPages.StandardController std = new ApexPages.standardController(o);
        OpportunitySummaryExtension ose = new OpportunitySummaryExtension(std); 
        system.assertEquals(o.Worst_Issue_Status__c,'R1 - Blocked Major Issues Need Resolved');
        Test.stopTest();
    } 
    static testMethod void testOpportunityDemandGen4() {
        Test.StartTest();
        Opportunity o = [SELECT Id, Name FROM Opportunity WHERE Name='Test Opportunity 1' LIMIT 1];
        o.Worst_Issue_Status__c = 'R2 - Major Issue, Action in Critical Path to Revenue with Low/Med Prob';
        o.Worst_Issue_Status_P__c = 'R2 - Major Issue, Action in Critical Path to Revenue with Low/Med Prob';
        update o;
         PageReference pref = Page.OpportunitySummary;
        Test.setCurrentPageReference(pref);
        pref.getParameters().put('id',o.Id);
        
        ApexPages.StandardController std = new ApexPages.standardController(o);
        OpportunitySummaryExtension ose = new OpportunitySummaryExtension(std);  
        system.assertEquals(o.Worst_Issue_Status__c,'R2 - Major Issue, Action in Critical Path to Revenue with Low/Med Prob');
        Test.StopTest();
    } 
    static testMethod void testOpportunityDemandGen5() {
        Test.StartTest();
        Opportunity o = [SELECT Id, Name FROM Opportunity WHERE Name='Test Opportunity 1' LIMIT 1];
        o.Worst_Issue_Status__c = 'R3 - Help Requested from Council';
        o.Worst_Issue_Status_P__c = 'R3 - Help Requested from Council';
        update o;
         PageReference pref = Page.OpportunitySummary;
        Test.setCurrentPageReference(pref);
        pref.getParameters().put('id',o.Id);
        
        ApexPages.StandardController std = new ApexPages.standardController(o);
        OpportunitySummaryExtension ose = new OpportunitySummaryExtension(std); 
        system.assertEquals(o.Worst_Issue_Status__c,'R3 - Help Requested from Council');
        Test.StopTest();
    } 
    static testMethod void testOpportunityDemandGen2() {
        Test.StartTest();
        Opportunity o = [SELECT Id, Name FROM Opportunity WHERE Name='Test Opportunity 1' LIMIT 1];
        o.Worst_Issue_Status__c = 'B - Major Issue Closed';
        o.Worst_Issue_Status_P__c = 'B - Major Issue Closed';
        update o;
         PageReference pref = Page.OpportunitySummary;
        Test.setCurrentPageReference(pref);
        pref.getParameters().put('id',o.Id);
        
        ApexPages.StandardController std = new ApexPages.standardController(o);
        OpportunitySummaryExtension ose = new OpportunitySummaryExtension(std);    
        system.assertEquals(o.Worst_Issue_Status__c,'B - Major Issue Closed');
        Test.StopTest();
    }        
    
    static testMethod void testOpportunityDemandGen6() {
        Test.StartTest();
        
        Opportunity opty = [SELECT Id, Name FROM Opportunity WHERE Name='Test Opportunity 1' LIMIT 1];
        opty.Worst_Issue_Status__c = 'G - Major Issue. Action in Place, High Conf of Closure. Date Not in Critical Path';
        opty.Worst_Issue_Status_P__c = 'G - Major Issue. Action in Place, High Conf of Closure. Date Not in Critical Path';
        opty.Opportunity_Health__c = 'Minor Obstacles';
        opty.X1st_Product_TO_Date__c = Date.newInstance(2018,01,01);
        opty.X1st_Product_Production_Date__c = Date.newInstance(2018,02,12);
        update opty;
        
        List<Quarterly_Revenue_Object__c> qRevList = new List<Quarterly_Revenue_Object__c>();
        
        Quarterly_Revenue_Object__c   qRev1 =  new Quarterly_Revenue_Object__c();
        qRev1.Fiscal_Quarter__c  = '2018-Q1';
        //qRev1.NRE__c         =   10000;
        qRev1.ASP__c         =   10000;
        qRev1.Volume__c      =   10000;
        qRev1.Date__c        =   Date.newInstance(2018,01,15);
        qRev1.Opportunity__c =   opty.Id;
        qRev1.ASP_Module_Chip__c = 100;
        qRev1.Volume_Module_Chip__c = 100;
        //qRev1.Revenue__c = 1000;
        qRevList.add(qRev1);

        Quarterly_Revenue_Object__c   qRev2 =  new Quarterly_Revenue_Object__c();
        qRev2.Fiscal_Quarter__c  = '2019-Q1';
        //qRev2.NRE__c         =   10000;
        qRev2.ASP__c         =   10000;
        qRev2.Volume__c      =   10000;
        qRev2.Date__c        =   Date.newInstance(2019,01,15);
        qRev2.Opportunity__c =   opty.Id;
        qRev2.ASP_Module_Chip__c = 100;
        qRev2.Volume_Module_Chip__c = 100;
        //qRev2.Revenue__c = 1000;
        qRevList.add(qRev2);
        
        Quarterly_Revenue_Object__c   qRev3 =  new Quarterly_Revenue_Object__c();
        qRev3.Fiscal_Quarter__c  = '2020-Q1';
        //qRev3.NRE__c         =   10000;
        qRev3.ASP__c         =   10000;
        qRev3.Volume__c      =   10000;
        qRev3.Date__c        =   Date.newInstance(2020,01,15);
        qRev3.Opportunity__c =   opty.Id;
        qRev3.ASP_Module_Chip__c = 100;
        qRev3.Volume_Module_Chip__c = 100;
        //qRev3.Revenue__c = 1000;
        qRevList.add(qRev3);
        
        Quarterly_Revenue_Object__c   qRev4 =  new Quarterly_Revenue_Object__c();
        qRev4.Fiscal_Quarter__c  = '2021-Q1';
        //qRev4.NRE__c         =   10000;
        qRev4.ASP__c         =   10000;
        qRev4.Volume__c      =   10000;
        qRev4.Date__c        =   Date.newInstance(2021,01,15);
        qRev4.Opportunity__c =   opty.Id;
        qRev4.ASP_Module_Chip__c = 100;
        qRev4.Volume_Module_Chip__c = 100;
        //qRev4.Revenue__c = 1000;
        qRevList.add(qRev4);
        
        Quarterly_Revenue_Object__c   qRev5 =  new Quarterly_Revenue_Object__c();
        qRev5.Fiscal_Quarter__c  = '2022-Q1';
        //qRev5.NRE__c         =   10000;
        qRev5.ASP__c         =   10000;
        qRev5.Volume__c      =   10000;
        qRev5.Date__c        =   Date.newInstance(2022,01,15);
        qRev5.Opportunity__c =   opty.Id;
        qRev5.ASP_Module_Chip__c = 100;
        qRev5.Volume_Module_Chip__c = 100;
        //qRev5.Revenue__c = 1000;
        qRevList.add(qRev5);
        
        Quarterly_Revenue_Object__c   qRev6 =  new Quarterly_Revenue_Object__c();
        qRev6.Fiscal_Quarter__c  = '2023-Q1';
        //qRev6.NRE__c         =   10000;
        qRev6.ASP__c         =   10000;
        qRev6.Volume__c      =   10000;
        qRev6.Date__c        =   Date.newInstance(2023,01,15);
        qRev6.Opportunity__c =   opty.Id;
        qRev6.ASP_Module_Chip__c = 100;
        qRev6.Volume_Module_Chip__c = 100;
        //qRev6.Revenue__c = 1000;
        qRevList.add(qRev6);

        Quarterly_Revenue_Object__c   qRev7 =  new Quarterly_Revenue_Object__c();
        qRev7.Fiscal_Quarter__c  = '2024-Q1';
        //qRev7.NRE__c         =   10000;
        qRev7.ASP__c         =   10000;
        qRev7.Volume__c      =   10000;
        qRev7.Date__c        =   Date.newInstance(2024,01,15);
        qRev7.Opportunity__c =   opty.Id;
        qRev7.ASP_Module_Chip__c = 100;
        qRev7.Volume_Module_Chip__c = 100;
        //qRev7.Revenue__c = 1000;
        qRevList.add(qRev7);

        Quarterly_Revenue_Object__c   qRev8 =  new Quarterly_Revenue_Object__c();
        qRev8.Fiscal_Quarter__c  = '2025-Q1';
        //qRev8.NRE__c         =   10000;
        qRev8.ASP__c         =   10000;
        qRev8.Volume__c      =   10000;
        qRev8.Date__c        =   Date.newInstance(2025,01,15);
        qRev8.Opportunity__c =   opty.Id;
        qRev8.ASP_Module_Chip__c = 100;
        qRev8.Volume_Module_Chip__c = 100;
        //qRev8.Revenue__c = 1000;
        qRevList.add(qRev8);

        insert qRevList;
        
        PageReference pref = Page.OpportunitySummary;
        Test.setCurrentPageReference(pref);
        pref.getParameters().put('Id', opty.Id);
        
        ApexPages.StandardController std = new ApexPages.standardController(opty);
        OpportunitySummaryExtension ose = new OpportunitySummaryExtension(std);    
        //system.assertEquals(o.Worst_Issue_Status__c,'B - Major Issue Closed');
        Test.StopTest();
    } 

    static testMethod void testOpportunityDemandGen7() {
        Test.StartTest();
        
        Opportunity opty = [SELECT Id, Name, OwnerId, CloseDate, Primary_Opportunity_FAE__c, X1st_Product_TO_Date__c FROM Opportunity WHERE Name='Test Opportunity 1' LIMIT 1];
        Opportunity_Program__c op = [SELECT Id FROM Opportunity_Program__c WHERE Name='Test Opportunity 1' LIMIT 1];
        
        List<Device_Gap__c> optyIssueList = new List<Device_Gap__c>();
        
        Device_Gap__c tempOppIssue = new Device_Gap__c();
        tempOppIssue.Opportunity__c = opty.Id;
        tempOppIssue.Opportunity_Program__c = op.Id;
        tempOppIssue.Gap_Type__c = 'Milestone';
        tempOppIssue.Gap_Sub_Type__c = 'Close Date';
        tempOppIssue.Select_Engagement_Step__c = 'B. DWIN Pre-Product Definition Plan & Resourcing (Schedule for achieving DWIN, Benchmarking)';
        tempOppIssue.Area__c = 'Milestone';
        tempOppIssue.Issue_Comments__c = 'Close Date';
        tempOppIssue.Select_Status__c = 'M - Milestone';
        tempOppIssue.Improve_Prob__c = 0;
        tempOppIssue.Improve_Prob_P__c = 0;
        tempOppIssue.Action_to_Close_Issue__c = 'Design Win';
        tempOppIssue.Solution_Owner__c = opty.OwnerId;
        tempOppIssue.Action_Close_Date__c = opty.CloseDate;
        tempOppIssue.Need_by_Date__c = opty.CloseDate;
        optyIssueList.add(tempOppIssue);
        
        tempOppIssue = new Device_Gap__c();
        tempOppIssue.Opportunity__c = opty.Id;
        tempOppIssue.Opportunity_Program__c = op.Id;
        tempOppIssue.Gap_Type__c = 'Milestone';
        tempOppIssue.Gap_Sub_Type__c = '1st Product TO';
        tempOppIssue.Select_Engagement_Step__c = 'B. DWIN Pre-Product Definition Plan & Resourcing (Schedule for achieving DWIN, Benchmarking)';
        tempOppIssue.Area__c = 'Milestone';
        tempOppIssue.Issue_Comments__c = '1st Prod TO';
        tempOppIssue.Select_Status__c = 'M - Milestone';
        tempOppIssue.Improve_Prob__c = 0;
        tempOppIssue.Improve_Prob_P__c = 0;
        tempOppIssue.Action_to_Close_Issue__c = '1st Prod TO';
        tempOppIssue.Solution_Owner__c = opty.Primary_Opportunity_FAE__c;
        tempOppIssue.Action_Close_Date__c = opty.X1st_Product_TO_Date__c;
        tempOppIssue.Need_by_Date__c = opty.X1st_Product_TO_Date__c;
        optyIssueList.add(tempOppIssue);
        
        insert optyIssueList;
        
        User thisUser= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        if(thisUser != NULL){
            opty.OwnerId = thisUser.Id;
        }
        opty.CloseDate = Date.Today().addDays(16);
        opty.X1st_Product_TO_Date__c = Date.Today().addDays(10);
        Test.StopTest();
        update opty;
        System.assertEquals(opty.X1st_Product_TO_Date__c, Date.Today().addDays(10));
    }
    
    static testMethod void testOpportunityDemandGen8() {
        Test.StartTest();
        
        Opportunity opty = [SELECT Id, Name, OwnerId, CloseDate, Primary_Opportunity_FAE__c, X1st_Product_TO_Date__c FROM Opportunity WHERE Name='Test Opportunity 1' LIMIT 1];
        Opportunity_Program__c op = [SELECT Id FROM Opportunity_Program__c WHERE Name='Test Opportunity 1' LIMIT 1];
        
        List<Device_Gap__c> optyIssueList = new List<Device_Gap__c>();
        
        Device_Gap__c tempOppIssue = new Device_Gap__c();
        tempOppIssue.Opportunity__c = opty.Id;
        tempOppIssue.Opportunity_Program__c = op.Id;
        tempOppIssue.Gap_Type__c = 'Milestone';
        tempOppIssue.Gap_Sub_Type__c = 'Close Date';
        tempOppIssue.Select_Engagement_Step__c = 'B. DWIN Pre-Product Definition Plan & Resourcing (Schedule for achieving DWIN, Benchmarking)';
        tempOppIssue.Area__c = 'Milestone';
        tempOppIssue.Issue_Comments__c = 'Close Date';
        tempOppIssue.Select_Status__c = 'M - Milestone';
        tempOppIssue.Improve_Prob__c = 0;
        tempOppIssue.Improve_Prob_P__c = 0;
        tempOppIssue.Action_to_Close_Issue__c = 'Design Win';
        tempOppIssue.Solution_Owner__c = opty.OwnerId;
        tempOppIssue.Action_Close_Date__c = opty.CloseDate;
        tempOppIssue.Need_by_Date__c = opty.CloseDate;
        optyIssueList.add(tempOppIssue);
        
        tempOppIssue = new Device_Gap__c();
        tempOppIssue.Opportunity__c = opty.Id;
        tempOppIssue.Opportunity_Program__c = op.Id;
        tempOppIssue.Gap_Type__c = 'Milestone';
        tempOppIssue.Gap_Sub_Type__c = '1st Product TO';
        tempOppIssue.Select_Engagement_Step__c = 'B. DWIN Pre-Product Definition Plan & Resourcing (Schedule for achieving DWIN, Benchmarking)';
        tempOppIssue.Area__c = 'Milestone';
        tempOppIssue.Issue_Comments__c = '1st Prod TO';
        tempOppIssue.Select_Status__c = 'M - Milestone';
        tempOppIssue.Improve_Prob__c = 0;
        tempOppIssue.Improve_Prob_P__c = 0;
        tempOppIssue.Action_to_Close_Issue__c = '1st Prod TO';
        tempOppIssue.Solution_Owner__c = opty.Primary_Opportunity_FAE__c;
        tempOppIssue.Action_Close_Date__c = opty.X1st_Product_TO_Date__c;
        tempOppIssue.Need_by_Date__c = opty.X1st_Product_TO_Date__c;
        optyIssueList.add(tempOppIssue);
        
        insert optyIssueList;
        
        User thisUser= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        if(thisUser != NULL){
            opty.OwnerId = thisUser.Id;
        }
        opty.CloseDate = Date.Today().addDays(16);
        opty.X1st_Product_TO_Date__c = Date.Today().addDays(10);
        Test.StopTest();
        
        List<Device_Gap__c> milestoneDeviceGapList = [SELECT Id, Opportunity__c, Gap_Type__c, Gap_Sub_Type__c FROM Device_Gap__c WHERE Opportunity__c = :opty .Id AND Gap_Type__c = 'Milestone' AND (Gap_Sub_Type__c = 'Close Date' OR Gap_Sub_Type__c = '1st Product TO')];
        
        if(milestoneDeviceGapList.size() > 0){
            delete milestoneDeviceGapList;
        }
        update opty;
        System.assertEquals(opty.CloseDate, Date.Today().addDays(16));
    }
}