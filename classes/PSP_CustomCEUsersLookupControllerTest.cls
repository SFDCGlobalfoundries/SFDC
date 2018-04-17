/*
    Author: Deepti Narayan Biswal
    Description: Test class for PSP_CustomCEUsersLookupController
    History:
        DBiswal    05022016    Created.
        DBiswal    05072017    Edited for user lookup for ASIC changes.
*/
@isTest
private class PSP_CustomCEUsersLookupControllerTest{
    
    static Account testAcct1 = new Account();
    static String testOpptyId = '';
    static String testOpptyProgramId = '';
    static Device__c testDevice = new Device__c();
    Static User usr = new User();
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();        
    }
    
    static void createhcm(String accid){
        List<Environment_Variable__c> env = [SELECT Id,Value__c FROM Environment_Variable__c WHERE Name='HCM Emp AccountId'];
        env[0].Value__c = accid;
        try{
            update env;
            
            List<HCM_Employee__c> hcmEmployeeList = new List<HCM_Employee__c>();
            hcmEmployeeList.add(InternalDeviceTestUtil.createHCMEmployee('CEtest1', 'User1', 'CE1', 'IT', 'testCEUser@testFAEFTSUser.com',
                                'TestceTie', '99234129','CEtest1'));
            insert hcmEmployeeList;
        }catch(exception e){
            GlobalUtility.logMessage('Error', 'PSP_CustomCEUsersLookupControllerTest', 'createhcm','', 'Exception while inserting HCM Record', String.valueof(e.getMessage()),'','Device Management',e,0);
        }
    }
    
    static User createUser(){
        Profile p = [SELECT Id FROM Profile WHERE Name = 'GF CE'];
        String uEmail = 'standarduser1' + DateTime.now().getTime() + '@testorg1.com';
        User u = new User(Alias = 'standt', Email = uEmail,Fab_Assigned__c = 'FAB 1; FAB 2; FAB 3; FAB 3E; FAB 5; FAB 6; FAB 7; FAB 8',
            EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US', ProfileId = p.Id,FederationIdentifier = 'CEtest1',
            TimeZoneSidKey = 'America/Los_Angeles', Username = 'buguser1' + System.now().format('MMddyyyyHHmmss') + '@testorg.com');
        try{
            insert u;
        }catch(exception e){
            GlobalUtility.logMessage('Error', 'PSP_CustomCEUsersLookupControllerTest', 'createUser','', 'Exception while inserting User Record', String.valueof(e.getMessage()),'','Device Management',e,0);
        }
        System.assert(u.Id != null);
        return u;
    }
    
    static Account createAccount() {
        // Create Account
        RecordType rt = [
            SELECT      Id
            FROM        RecordType
            WHERE       SObjectType = 'Account'
                        AND Name = 'Customer'
        ];
        
        Account testAcct = new Account();
        testAcct.Name = 'Test Account1';
        testAcct.Stage__c = 'Unqualified';
        testAcct.Site_Department__c = 'Test Department';
        testAcct.Sub_Type__c = 'Direct';
        testAcct.Transaction_Type__c = 'Transactional';
        testAcct.Region__c = 'APJ';
        testAcct.Bill_To_Address_1__c = 'Test Address 1';
        testAcct.Corporate_Address_1__c = 'Corporate Address 1';
        testAcct.Bill_To_City__c = 'Test City';
        testAcct.Corporate_City__c = 'Test City';
        testAcct.Bill_To_Country__c = 'Singapore';
        testAcct.Corporate_Country__c = 'Singapore';
        testAcct.RecordTypeId = rt.Id;      
        testAcct.Short_Name__c = 'TestAcct1N';
        try{
            insert testAcct;
        }catch(exception e){
            GlobalUtility.logMessage('Error', 'PSP_CustomCEUsersLookupControllerTest', 'createAccount','', 'Exception while inserting Account Record', String.valueof(e.getMessage()),'','Device Management',e,0);
        }
        return testAcct;
    }
    
        
    static Id createOpportunity(Id testAcctId) {
        // Create Opportunity
        Opportunity testOppty = new Opportunity();
        testOppty.Name = 'Test Opportunity';
        testOppty.AccountId = testAcctId;
        testOppty.StageName = '1. Discovery';
        testOppty.CloseDate = Date.Today().addDays(10);
        testOppty.Target_Process_Node__c = '14XM';
        testOppty.Market_Segment__c = 'Mobility';
        testOppty.Process_Platform__c = 'GF Baseline';
        testOppty.Fab_Split__c = 100;
        testOppty.Process_Geometry__c = '0.055UM';
        testOppty.Process_Family__c = 'Generic / Nominal';        
        testOppty.X1st_Product_Production_Date__c = System.Today();
        testOppty.Years_of_Production__c = 3;
        testOppty.Siebel_Opportunity_ID__c = '123123123323';
        try{
            Insert testOppty;
        }catch(exception e){
            GlobalUtility.logMessage('Error', 'PSP_CustomCEUsersLookupControllerTest', 'createOpportunity','', 'Exception while inserting Opportunity Record', String.valueof(e.getMessage()),'','Device Management',e,0);
        }
                
        return testOppty.Id;
    }
    
    
    static testMethod void test_noPSPDates() {
        testAcct1 = PSP_CustomCEUsersLookupControllerTest.createAccount();
        testOpptyId = PSP_CustomCEUsersLookupControllerTest.createOpportunity(testAcct1.Id);
        createhcm(testAcct1.Id);
        
        test.startTest();
            try{
                usr = createUser();
                
                List<Account_Team_Proxy__c> teamProxyList = new List<Account_Team_Proxy__c>();
                teamProxyList.add(new Account_Team_Proxy__c(User__c = usr.Id, Account__c = testAcct1.Id, Fab_Assignment__c = 'FAB 1; FAB 2; FAB 3; FAB 3E; FAB 5; FAB 6; FAB 7; FAB 8', Account_Access__c = 'Read/Write', Opportunity_Access__c = 'Read/Write', Team_Role__c = 'Customer Engineer'));
                insert teamProxyList;
            
                PageReference pageRef = Page.PSP_CustomCEUsersLookup;
                pageRef.getParameters().put('accid',testAcct1.Id);
                Test.setCurrentPage(pageRef);
                PSP_CustomCEUsersLookupController pspce = new PSP_CustomCEUsersLookupController();
                pspce.userval = userInfo.getFirstName();
                pspce.searchUsers();
                System.AssertEquals(pspce.listceUsers != null, true);
            }catch(exception e){
                GlobalUtility.logMessage('Error', 'PSP_CustomCEUsersLookupControllerTest', 'test_noPSPDates','', 'Exception while executing test method', String.valueof(e.getMessage()),'','Device Management',e,0);
            }
        test.stoptest();                            
    }    
}