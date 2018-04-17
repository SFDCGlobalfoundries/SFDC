/*
  Author: Shivam Sharma
  Description: This is the test class for the class "ProposalSharing"
  History:
    SSharma        12-12-2016    - code creation.              
*/
@isTest(SeeAllData=false)
public class ProposalSharingTest{

    private static User u;
    private static Account acc;
    private static Device__c device;
    
    private static void initialize(){
        
        DataUtilTest.loadEnvironmentVariables();
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        u = new User(Alias = 'staCPQ', Email='standarduserCPQ@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingCPQ', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='standarduserCPQ@testorg.com', HCM_Login_Id__c = 'Test');
        insert u;
        
            acc = new Account(Name = 'Test Account');
            insert acc;
            System.assert(acc.id != null);
            Opportunity_Program__c op = new Opportunity_Program__c();
            insert op;
            System.assert(op.id != null);
            device = new Device__c(Name = 'Test_Device', Account__c = acc.Id, Tapeout_Type__c = 'Test', Device_Sourcing__c = 'Test', End_Application__c = 'Test', Market_Segment__c = 'Test', Opportunity_Program__c = op.id, Internal_Device_Geometry__c = 'Test', Internal_Device_Process_Family__c = 'Test');
            insert device;
            System.assert(device.id != null);
    }
    
    static testMethod void test_insertWithoutAccountnDevice(){
        initialize();
        Test.startTest();
                Apttus_Proposal__Proposal__c newProposal = new Apttus_Proposal__Proposal__c();
                insert newProposal;
                System.assert(newProposal.id != null);
        Test.stopTest();
    }        
    static testMethod void test_insertWithAccount(){
        initialize();
        Test.startTest();
                Apttus_Proposal__Proposal__c newProposal = new Apttus_Proposal__Proposal__c();
                newProposal.Apttus_Proposal__Account__c = acc.Id;
                insert newProposal;
            Test.stopTest();
    }
       
   static testMethod void test_insertWithDevice(){
        initialize();
        Test.startTest();
                Apttus_Proposal__Proposal__c newProposal = new Apttus_Proposal__Proposal__c();
                newProposal.Device__c = device.id;
                newProposal.Apttus_Proposal__Account__c = acc.Id;
                newProposal.Apttus_Proposal__Opportunity__c = createOpportunityNew(acc.Id);
                insert newProposal;
                NPCCopyConfigurationController.InsideNPCCopyConfig = true;
                update newProposal;
            Test.stopTest();
    }
    /*
            Test.startTest();
                newProposal.Device__c = null;
                update newProposal;
            Test.stopTest();
            
                newProposal.Apttus_Proposal__Account__c = null;
                update newProposal;
            */
    //}
    static ID createOpportunityNew(ID testAcctID) {
        // Create Opportunity
        Opportunity testOppty = new Opportunity(
            name = 'Test Opportunity',
            accountID = testAcctID,
            stageName = '1. Discovery',
            closeDate = Date.Today().addDays(10),
            target_process_node__c = '14XM',
            market_segment__c = 'Mobility',
            process_platform__c = 'GF Baseline',
            fab_split__c = 100,
            process_geometry__c = '0.055UM',
            process_family__c = 'Generic / Nominal'
        );
        
        Insert testOppty;        
        return testOppty.ID;
    }
    
}