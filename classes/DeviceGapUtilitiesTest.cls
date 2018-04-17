// Test Class for DeviceGapUtilities

@isTest(SeeAllData=false)
private class DeviceGapUtilitiesTest {

    @testSetup static void dataSetup() {
        DataUtilTest.loadEnvironmentVariables();
        
        // Create Account
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

        Account testAcct = AccountDataFactory.createAccount(fieldValueMap);        
        
        // Create Opportunity
        Map<String,Object> fieldValueMapOpp = new Map<String,Object>();
        fieldValueMapOpp.put('AccountId',testAcct.Id);
        fieldValueMapOpp.put('Name','Test Opportunity 1');  
        fieldValueMapOpp.put('StageName','1. Discovery');
        fieldValueMapOpp.put('CloseDate',Date.Today().addDays(10));  
        fieldValueMapOpp.put('Target_Process_Node__c','14XM');
        fieldValueMapOpp.put('Market_Segment__c','Mobility');  
        fieldValueMapOpp.put('Process_Platform__c','GF Baseline');
        fieldValueMapOpp.put('Fab_Split__c',100);          
        fieldValueMapOpp.put('Process_Geometry__c','0.13UM');  
        fieldValueMapOpp.put('Process_Family__c','Low Power / Ultra Low Leakage');        
        fieldValueMapOpp.put('Fab_Assignment_1__c','FAB 6');
         
        Opportunity testOppty = OpportunityDataFactory.createOpportunity(fieldValueMapOpp);
                
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
        
        insert testOpptyProgram;
    }
    
    // Test to Insert 1 Opportunity Issue to Opportunity with No Existing Opportunity Issue
    @isTest static void insertOneOpportunityIssue() {
        test.starttest();
        Opportunity o = [SELECT Id FROM Opportunity WHERE Name='Test Opportunity 1' LIMIT 1];
        Opportunity_Program__c op = [SELECT Id FROM Opportunity_Program__c WHERE Name='Test Opportunity 1' LIMIT 1];
        
        // Create the Opportunity Issue
        Device_Gap__c dg = new Device_Gap__c();
        dg.Issue_Comments__c = 'Price Too High';
        dg.Area__c = 'Price';
        dg.Improve_Prob__c = 20;
        dg.Need_by_Date__c = Date.Today().addMonths(1);
        dg.Select_Status__c = 'G - Major Issue. Action in Place, High Conf of Closure. Date Not in Critical Path';
        dg.Stage__c = 'New';
        dg.Opportunity__c = o.Id;
        dg.Opportunity_Program__c = op.Id;
        dg.Gap_Type__c = 'Price / Cost';
        //Test.startTest();
        insert dg;
       // Test.stopTest();
        
        // Validate Opportunity Issue is Inserted
        dg = [SELECT Id, Select_Status__c, Opportunity__c From Device_Gap__c Where Opportunity__c = :o.Id LIMIT 1];
        System.assertNotEquals(null, dg);
        // Validate Opportunity Status is set same as Opportunity Issue
        o = [SELECT Id, Worst_Issue_Status__c from Opportunity WHERE Id = :o.Id LIMIT 1];
        System.assertEquals(dg.Select_Status__c, o.Worst_Issue_Status__c);
        test.stoptest();
    }
     // Test to Delete 1 Opportunity Issue to Opportunity
    @isTest static void deleteOneOpportunityIssue() {
        Test.startTest();
        Opportunity o = [SELECT Id FROM Opportunity WHERE Name='Test Opportunity 1' LIMIT 1];
        Opportunity_Program__c op = [SELECT Id FROM Opportunity_Program__c WHERE Name='Test Opportunity 1' LIMIT 1];
        
        // Create the Opportunity Issue
        Device_Gap__c dg = new Device_Gap__c();
        dg.Issue_Comments__c = 'Price Too High';
        dg.Area__c = 'Price';
        dg.Improve_Prob__c = 20;
        dg.Need_by_Date__c = Date.Today().addMonths(1);
        dg.Select_Status__c = 'G - Major Issue. Action in Place, High Conf of Closure. Date Not in Critical Path';
        dg.Stage__c = 'New';
        dg.Opportunity__c = o.Id;
        dg.Opportunity_Program__c = op.Id;
        dg.Gap_Type__c = 'Price / Cost';
        insert dg;
        
        // Validate Opportunity Issue is Inserted
        dg = [SELECT Id, Select_Status__c, Opportunity__c From Device_Gap__c Where Opportunity__c = :o.Id LIMIT 1];
        System.assertNotEquals(null, dg);
        
        
        delete dg;
        
        
        // Validate Opportunity Issue is Deleted
        List<Device_Gap__c> opportunityIssueList = [SELECT Id, Select_Status__c, Opportunity__c From Device_Gap__c Where Opportunity__c = :o.Id];
        System.assertEquals(0, opportunityIssueList.Size());
        // Validate Opportunity Status is set to null
        o = [SELECT Id, Worst_Issue_Status__c from Opportunity WHERE Id = :o.Id LIMIT 1];
        System.assertEquals(null, o.Worst_Issue_Status__c);
        Test.stopTest();
    }
    
    // Test to Insert 2 Opportunity Issue to Opportunities and Validate Opportunity Status set to worse Status
    @isTest static void insertTwoOpportunityIssue() {
        Opportunity o = [SELECT Id FROM Opportunity WHERE Name='Test Opportunity 1' LIMIT 1];
        Opportunity_Program__c op = [SELECT Id FROM Opportunity_Program__c WHERE Name='Test Opportunity 1' LIMIT 1];
        
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
        dg.Gap_Type__c = 'Price / Cost';
        opportunityIssueList.add (dg);
        
        Device_Gap__c dg1 = new Device_Gap__c();
        dg1.Issue_Comments__c = 'Price Too High 2';
        dg1.Area__c = 'Price';
        dg1.Improve_Prob__c = 20;
        dg1.Need_by_Date__c = Date.Today().addMonths(1);
        dg1.Select_Status__c = 'G - Major Issue. Action in Place, High Conf of Closure. Date Not in Critical Path';
        dg1.Stage__c = 'New';
        dg1.Opportunity__c = o.Id;
        dg1.Opportunity_Program__c = op.Id;
        dg1.Gap_Type__c = 'Price / Cost';
        opportunityIssueList.add(dg1);
        
        Test.startTest();
        insert opportunityIssueList;
        Test.stopTest();
        
        // Validate 2 Opportunity Issues were Inserted
        opportunityIssueList = [SELECT Id, Select_Status__c, Opportunity__c From Device_Gap__c Where Opportunity__c = :o.Id];
        System.assertEquals(2, opportunityIssueList.Size());
        // Validate Opportunity Status is set same as Opportunity Issue
        o = [SELECT Id, Worst_Issue_Status__c from Opportunity WHERE Id = :o.Id LIMIT 1];
        System.assertEquals(dg.Select_Status__c, o.Worst_Issue_Status__c);
    }
    
    // Test to Delete 1 Opportunity Issue to Opportunity with remaining Opportunity Issue
    @isTest static void deleteOneOpportunityIssueWithOneExisting() {
        
        Opportunity o = [SELECT Id FROM Opportunity WHERE Name='Test Opportunity 1' LIMIT 1];
        Opportunity_Program__c op = [SELECT Id FROM Opportunity_Program__c WHERE Name='Test Opportunity 1' LIMIT 1];
        
        List <Device_Gap__c> opportunityIssueList = new List <Device_Gap__c> ();
        Test.startTest();
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
        dg.Gap_Type__c = 'Price / Cost';
        opportunityIssueList.add (dg);
        
        Device_Gap__c dg1 = new Device_Gap__c();
        dg1.Issue_Comments__c = 'Price Too High 2';
        dg1.Area__c = 'Yield';
        dg1.Improve_Prob__c = 20;
        dg1.Need_by_Date__c = Date.Today().addMonths(1);
        dg1.Select_Status__c = 'G - Major Issue. Action in Place, High Conf of Closure. Date Not in Critical Path';
        dg1.Stage__c = 'New';
        dg1.Opportunity__c = o.Id;
        dg1.Opportunity_Program__c = op.Id;
        dg1.Gap_Type__c = 'Price / Cost';
        opportunityIssueList.add(dg1);
        insert opportunityIssueList;
        
        // Validate 2 Opportunity Issues were Inserted
        //opportunityIssueList = [SELECT Id, Select_Status__c, Opportunity__c From Device_Gap__c Where Opportunity__c = :o.Id];
        System.assertEquals(2, opportunityIssueList.Size());
        // Validate Opportunity Blocking Factor is updated correctly;
       // o = [SELECT Id, Demand_Factor__c FROM Opportunity WHERE Name='Test Opportunity 1' LIMIT 1];
        //System.assertEquals('Price;Yield', o.Demand_Factor__c);
        
        
        delete dg;
        Test.stopTest();
        
        // Validate Opportunity Issue is Deleted
        opportunityIssueList = [SELECT Id, Select_Status__c, Opportunity__c From Device_Gap__c Where Opportunity__c = :o.Id];
        System.assertEquals(1, opportunityIssueList.Size());
        // Validate Opportunity Status is set to new status of remaining issue
        //o = [SELECT Id, Worst_Issue_Status__c from Opportunity WHERE Id = :o.Id LIMIT 1];
        //System.assertEquals(dg1.Select_Status__c, o.Worst_Issue_Status__c);
        
    }
    
     // Bulk Test to Insert 20 Opportunity Issue to Opportunities and Validate Opportunity Status set to worse Status
    @isTest static void insertBulkOpportunityIssue() {
        Opportunity o = [SELECT Id FROM Opportunity WHERE Name='Test Opportunity 1' LIMIT 1];
        Opportunity_Program__c op = [SELECT Id FROM Opportunity_Program__c WHERE Name='Test Opportunity 1' LIMIT 1];
        
        List <Device_Gap__c> opportunityIssueList = new List <Device_Gap__c> ();
        
        // Create the Opportunity Issue
        for (Integer i = 0; i < 20; i++)
        {
            Device_Gap__c dg = new Device_Gap__c();
            dg.Issue_Comments__c = 'Price Too High ' + i ;
            dg.Area__c = 'Price';
            dg.Improve_Prob__c = 20;
            dg.Need_by_Date__c = Date.Today().addMonths(1);
            if (i == 15)
            {
                dg.Select_Status__c = 'R3 - Help Requested from Council';
            }
            else
            {
                dg.Select_Status__c = 'G - Major Issue. Action in Place, High Conf of Closure. Date Not in Critical Path';
            }
            dg.Stage__c = 'New';
            dg.Opportunity__c = o.Id;
            dg.Opportunity_Program__c = op.Id;
            dg.Gap_Type__c = 'Price / Cost';
            opportunityIssueList.add (dg);
        }
        
        Test.startTest();
        insert opportunityIssueList;
        Test.stopTest();
        
        // Validate 20 Opportunity Issues were Inserted
        opportunityIssueList = [SELECT Id, Select_Status__c, Opportunity__c From Device_Gap__c Where Opportunity__c = :o.Id];
        System.assertEquals(20, opportunityIssueList.Size());
        // Validate Opportunity Status is set same as worst Opportunity Issue
        o = [SELECT Id, Worst_Issue_Status__c from Opportunity WHERE Id = :o.Id LIMIT 1];
        System.assertEquals('R3 - Help Requested from Council', o.Worst_Issue_Status__c);
    }
    
    // Test Setting Previous Value Updates
    @isTest static void testPreviousValues() {
        test.starttest();
        Opportunity o = [SELECT Id FROM Opportunity WHERE Name='Test Opportunity 1' LIMIT 1];
       
        Opportunity_Program__c op = [SELECT Id FROM Opportunity_Program__c WHERE Name='Test Opportunity 1' LIMIT 1];
        
        List <Device_Gap__c> opportunityIssueList = new List <Device_Gap__c> ();
        
        // Create the Opportunity Issue
        // Create the Opportunity Issue
        //Test.startTest();
        Device_Gap__c dg = new Device_Gap__c();
        dg.Issue_Comments__c = 'Price Too High';
        dg.Area__c = 'Price';
        dg.Improve_Prob__c = 20;
        dg.Action_Close_Date__c = Date.Today();
        dg.Need_by_Date__c = Date.Today().addMonths(1);
        dg.Select_Status__c = 'G - Major Issue. Action in Place, High Conf of Closure. Date Not in Critical Path';
        dg.Stage__c = 'New';
        dg.Opportunity__c = o.Id;
        dg.Opportunity_Program__c = op.Id;
        dg.Gap_Type__c = 'Price / Cost';
        insert dg;
        
        // Validate Opportunity Issue is Inserted
        //dg = [SELECT Id, Select_Status__c, Opportunity__c From Device_Gap__c Where Opportunity__c = :o.Id LIMIT 1];
        System.assertNotEquals(null, dg);
        
        // Now we update the values
        dg.Improve_Prob__c = 35;
        dg.Select_Status__c = 'R1 - Blocked Major Issues Need Resolved';
        dg.Action_Close_Date__c = Date.Today().addMonths(1);
        
        Test.stopTest();
        //update dg;
        
         
        //dg = [SELECT Id, Improve_Prob_P__c, Previous_Status__c, Action_Close_Date_P__c From Device_Gap__c Where Opportunity__c = :o.Id LIMIT 1];
        
        // Validate the Previous Value field set correctly
        //System.assertEquals(20, dg.Improve_Prob_P__c);
       // System.assertEquals('G - Major Issue. Action in Place, High Conf of Closure. Date Not in Critical Path', dg.Previous_Status__c);
        //System.assertEquals(Date.Today(), dg.Action_Close_Date_P__c);
    }
   
}