/*
    Author: Ariz Solito
    Description: Apex test class for NPCGroupCtrl
    History: 
        Asolito     11132013    - Code creation.
        Sunil Arora 01092014    - Added Department__c='Design' into contact object.                       
*/
@istest(SeeAllData=false)
public with sharing class NPCGroupCtrlTest {

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
        //Test.startTest();      
        List<User> users = new List<User>();
        User u1 = new User(
            alias = 'ts', 
            email='testing@test.com',
            emailencodingkey='UTF-8', 
            lastname='TestLast', 
            firstname='TestFirst', 
            languagelocalekey='en_US',
            localesidkey='en_US', 
            profileid = '00e90000001232a',
            timezonesidkey='America/Los_Angeles', 
            username='testing112@test.com',
            phone='9999999991',
            communitynickname='ts',
            FederationIdentifier='Test2014'
        );
        
        User u2 = new User(
            alias = 'ts2', 
            email='testing2@test.com',
            emailencodingkey='UTF-8', 
            lastname='TestLast2', 
            firstname='TestFirst', 
            languagelocalekey='en_US',
            localesidkey='en_US', 
            profileid = '00e90000001232a',
            timezonesidkey='America/Los_Angeles', 
            username='testing223@test.com',
            communitynickname='ts2',
            phone='999999999',
            FederationIdentifier='Test2013'
        ); 
        
        users.add(u1);
        users.add(u2);  
            
        insert users; 
        //Test.stopTest();
    }   

    static testMethod void testClass(){
        
        // Load Environment Variables 
        test.startTest();  
        Account acc= getAccount('testing901'); 
        User u1 = [Select Id, name from User where username='testing112@test.com'];
        User u2 = [Select Id, name from User where username='testing223@test.com'];
        Contact con = new Contact(
            firstName = 'Test',
            lastName = 'Contact',
            email = 'test@test.com',
            accountId = acc.id,
            is_portal_user_active__c = true,
            is_portal_user_created__c = true,
            role__c = 'Customers My Device Admin',
            Department__c='Design'
        );
        insert con;
                                        
        
    Map<String,Object> fieldValueMapOpp = new Map<String,Object>();
        fieldValueMapOpp.put('AccountId',acc.Id);
        fieldValueMapOpp.put('Name','Test Opportunity');  
        fieldValueMapOpp.put('StageName','1. Discovery');
        fieldValueMapOpp.put('CloseDate',date.newinstance(2012, 12, 21));  
        fieldValueMapOpp.put('Target_Process_Node__c','14XM');
        fieldValueMapOpp.put('Market_Segment__c','Automotive');  
        fieldValueMapOpp.put('Process_Platform__c','GF Baseline');
        fieldValueMapOpp.put('Fab_Split__c',100);          
        fieldValueMapOpp.put('Process_Geometry__c','0.014UM');  
        fieldValueMapOpp.put('Process_Family__c','Super Low Power');
        fieldValueMapOpp.put('Opportunity_Sourcing_Type__c','First Source');
        fieldValueMapOpp.put('Fab_Assignment_1__c','FAB 1');
         
        Opportunity opp = OpportunityDataFactory.createOpportunity(fieldValueMapOpp);
        
        Opportunity_Program__c opProg = new Opportunity_Program__c(
            Name='Test OppProg',
            Account__c=acc.id,
            Opportunity__c=opp.id
        );
        insert opProg;
        //test.startTest();        
        List<Opportunity_Program_Team_Member__c> mems = new List<Opportunity_Program_Team_Member__c>();
        
        Opportunity_Program_Team_Member__c optm1 = new Opportunity_Program_Team_Member__c(
            user__c = u1.id,
            team_role__c= 'Field Application Engineer',
            device_access__c = 'Read/Write',
            core_team_member__c = true,
            opportunity_program_access__c = 'Read/Write',
            opportunity_program__c = opProg.id,
           Flag_for_Delete__c=false
            
        ); 
        
        
                   
        Opportunity_Program_Team_Member__c optm2 = new Opportunity_Program_Team_Member__c(
            user__c = u2.id,
            team_role__c= 'Field Engineer',
            device_access__c = 'Read/Write',
            core_team_member__c = false,
            opportunity_program_access__c = 'Read/Write',
            opportunity_program__c = opProg.id            
        ); 
        
        
        mems.add(optm1);
        mems.add(optm2);
        
        insert mems;
        
            
        //String testAcctId = DeviceUtilTest.createAccount();
        //String testOpptyId = DeviceUtilTest.createOpp(testAcctId,'0.10UM');
        //String testOpptyProgramId = DeviceUtilTest.createOppProg(testAcctId, testOpptyId);
        
        String MSTId = DeviceUtilTest.createMaskSetTtitle();
        string MSTAccId = DeviceUtilTest.createMSTAccount(acc.id,MSTId);
        test.stopTest();
        Id testDeviceId = DeviceUtilTest.createCustomerMPWDevice(acc.id, opProg.id);
        
             
        
        New_Part_Creation_Form__c npc = new New_Part_Creation_Form__c();
        /*npc.Account__c = acc.id;
        npc.BASE_Device__c = dev.id;*/
        npc.Account__c = acc.id;
        npc.BASE_Device__c = testDeviceId;
        npc.New_Part_ID__c = 'NPCTEST1';
        npc.NPC_Form_Status__c = 'Pending CE Approval';
        npc.NPC_Form_Submitted_Date__c = date.today().addDays(-5);
        npc.Reference_Id__c = 'ANBQP60ACO8CH-U01';        
        insert npc; 
                      
        NPCGroupCtrl ctrl = new NPCGroupCtrl();
        ctrl.setRecID(npc.id);
        ctrl.getRecID();
        
              
        ctrl.isHTML=false;
        ctrl.showCE=false;
        ctrl.showFE=false;
        ctrl.showCSR=false;
        String str= ctrl.newLine;
         
        
                
      
    }
     
       
    private static Account getAccount(string AccountName)
            {
                Account acc= [SELECT Id, Name FROM Account Where Name =: AccountName];
        
                return acc;
            }  
}