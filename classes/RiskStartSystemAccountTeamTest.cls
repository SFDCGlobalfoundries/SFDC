/*    
    Author: Bhupesh Mukhija 
    Description: This serves as the test class for Risk Start System Enhancement.
    History:
    BMukhija        04032013        -   Test Class Creation.
    Vixit Bhardwaj  15012014        -   New Process defined at Step 2 
    Nbustillos      02152014        -   Added @isTest attribute.
                                    -   Removed try-catch to non-negative test.
    DBiswal         04092015        -   Updated code for refactoring of test class.
*/
@isTest(SeeAllData=false)
private class RiskStartSystemAccountTeamTest {
    
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MYTEST ACCOUNT1');                   
        fieldValueMap.put('site_department__c', 'test dept');                                           
        fieldValueMap.put('region__c', 'EUR');        
        fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Corporate_City__c', 'Test City');                
        fieldValueMap.put('Corporate_Country__c', 'Singapore');
        fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Bill_To_City__c', 'Test City');            
        fieldValueMap.put('Bill_To_Country__c', 'Singapore');        
        fieldValueMap.put('Fab_9_10__c','No');

        AccountDataFactory.createAccount(fieldValueMap);
        Account account = getAccount('MYTEST ACCOUNT1');
        Environment_Variable__c env = [select id,name,value__c from Environment_Variable__c where name='HCM Emp AccountId'];
        env.value__c=account.Id;
        update env;
    }
    
    static List<Account_Team_Proxy__c> lAccountTeam {private get; private set;}
    static List<User> lUser {private get; private set;}
    static Account account {private get; private set;}
    
    static Account createAccount(String sampleData) {
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MYTEST ACCOUNT1');                   
        fieldValueMap.put('site_department__c', 'test dept');                                           
        fieldValueMap.put('region__c', 'EUR');        
        fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Corporate_City__c', 'Test City');                
        fieldValueMap.put('Corporate_Country__c', 'Singapore');
        fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Bill_To_City__c', 'Test City');            
        fieldValueMap.put('Bill_To_Country__c', 'Singapore');        
        fieldValueMap.put('Fab_9_10__c','No');

        return AccountDataFactory.createAccount(fieldValueMap);
        
        
    }
    
    static HCM_Employee__c createHCMEmployee(String dataChange, Boolean supervisor) {
        HCM_Employee__c testHCMEmployee = new HCM_Employee__c();
        
        testHCMEmployee.First_Name__c = dataChange + ' ' + 'Employee FN';
        testHCMEmployee.Last_Name__c = dataChange + ' ' + 'Employee LN';
        testHCMEmployee.Employee_ID__c = dataChange;
        testHCMEmployee.Login_ID__c = dataChange + 'test.hcmemployee@gf.com';
        testHCMEmployee.Email_Address__c = dataChange + 'test.hcmemployee@gf.com';
        testHCMEmployee.Status__c = 'Active';
        
        if (!supervisor) {
            testHCMEmployee.Supervisor_ID__c = '11984';
        }
        
        return testHCMEmployee;
    }
    
    static User createUser(String dataChange, Boolean manager, Boolean gfProfile, Boolean fId) {
        User testUser = new User();
        
        User dummyUser = [SELECT id
                            , TimeZoneSidKey
                            , LocaleSidKey
                            , EmailEncodingKey
                            , ProfileId
                            , LanguageLocaleKey 
                          FROM User LIMIT 1];

        testUser.FirstName = dataChange + ' ' + 'User FN';
        testUser.LastName = dataChange + ' ' + 'User LN';
        testUser.Username = dataChange + 'test.user@gf.com';
        testUser.email = dataChange + 'test.user@gf.com';
        testUser.Email = dataChange + 'test.user@gf.com';
        testUser.Alias = dataChange;
        testUser.CommunityNickname = dataChange + 'COMM';
        if (gfProfile) {
            testUser.ProfileId = [SELECT Id 
                                  FROM Profile 
                                  WHERE Name = 'GF App User Platform' LIMIT 1].get(0).id;
        } else {
            testUser.ProfileId = [SELECT Id 
                                  FROM Profile 
                                  WHERE Name = 'Standard User Platform' LIMIT 1].get(0).id;
        }
        if (fId) {
            testUser.FederationIdentifier = dataChange;
        } else {
            testUser.FederationIdentifier = null;
        }
        testUser.TimeZoneSidKey = dummyUser.TimeZoneSidKey;
        testUser.LocaleSidKey = DummyUser.LocaleSidKey;
        testUser.EmailEncodingKey = DummyUser.EmailEncodingKey;
        testUser.LanguageLocaleKey = DummyUser.LanguageLocaleKey;
        testUser.Fab_Assigned__c = 'Fab 1; Fab 6; Fab 3; Fab 8';
        
        return testUser;
    }
    
    static Account_Team_Proxy__c createAccountTeamProxy(User user, String teamRole) {
        Account_Team_Proxy__c accountTeamProxy = new Account_Team_Proxy__c();

        accountTeamProxy.Account__c = account.Id;
        
        accountTeamProxy.Account_Access__c = 'Read/Write';
        accountTeamProxy.Opportunity_Access__c = 'Read/Write';
        
        accountTeamProxy.Team_Role__c = teamRole;
        accountTeamProxy.User__c = user.Id;
        
        if(teamRole == 'Fab Planner' || teamRole == 'Customer Engineer'){
            accountTeamProxy.fab_assignment__c = 'FAB 1';
        }
        
        return accountTeamProxy;
    }
    
    static Risk_Start_System__c createRiskStartSystem(String fab) {
        Risk_Start_System__c riskStartSystem = new Risk_Start_System__c();

        riskStartSystem.Customer_Name__c = account.Id;
        riskStartSystem.Recommended_Device__c = 'TESTDEVICE';
        riskStartSystem.Recommended_Quantity__c = 100;
        riskStartSystem.Status__c = 'Pending Pricing Inputs';
        riskStartSystem.Fab__c = fab;
        riskStartSystem.PX_WIP_FG1__c = 1;
        
        return riskStartSystem;
    }
    
    static void createCustomSettings() {
        /*
        List<Environment_Variable__c> lEnvironmentVariable = new List<Environment_Variable__c>();
        
        lEnvironmentVariable.add(new Environment_Variable__c(Name='PLANNERS_FAB1', Value__c='Planners Fab1', SetupOwnerId = UserInfo.getOrganizationId()));
        lEnvironmentVariable.add(new Environment_Variable__c(Name='PLANNERS_FAB2', Value__c='Planners Fab2', SetupOwnerId = UserInfo.getOrganizationId()));
        lEnvironmentVariable.add(new Environment_Variable__c(Name='PLANNERS_FAB3', Value__c='Planners Fab3', SetupOwnerId = UserInfo.getOrganizationId()));
        lEnvironmentVariable.add(new Environment_Variable__c(Name='PLANNERS_FAB3E', Value__c='Planners Fab3E', SetupOwnerId = UserInfo.getOrganizationId()));
        lEnvironmentVariable.add(new Environment_Variable__c(Name='PLANNERS_FAB5', Value__c='Planners Fab5', SetupOwnerId = UserInfo.getOrganizationId()));
        lEnvironmentVariable.add(new Environment_Variable__c(Name='PLANNERS_FAB6', Value__c='Planners Fab6', SetupOwnerId = UserInfo.getOrganizationId()));
        lEnvironmentVariable.add(new Environment_Variable__c(Name='PLANNERS_FAB7', Value__c='Planners Fab7', SetupOwnerId = UserInfo.getOrganizationId()));
        lEnvironmentVariable.add(new Environment_Variable__c(Name='PLANNERS_FAB8', Value__c='Planners Fab8', SetupOwnerId = UserInfo.getOrganizationId()));
        
        insert lEnvironmentVariable;    
        
        
        List<CS_Risk_Start__c> lCustomSettingRSS = new List<CS_Risk_Start__c>();
        lCustomSettingRSS.add(new CS_Risk_Start__c(Name='STATUS_PENDING_CUSTOMER_PLANNING'
            , RS_Status_Error__c = 'Pending Customer Planning Inputs'
            , SetupOwnerId = UserInfo.getOrganizationId()));
        lCustomSettingRSS.add(new CS_Risk_Start__c(Name='STATUS_DRAFT'
            , RS_Status_Error__c = 'Draft'
            , SetupOwnerId = UserInfo.getOrganizationId()));
        lCustomSettingRSS.add(new CS_Risk_Start__c(Name='STATUS_REJECTED'
            , RS_Status_Error__c = 'Rejected'
            , SetupOwnerId = UserInfo.getOrganizationId()));
        lCustomSettingRSS.add(new CS_Risk_Start__c(Name='ERROR_NO_FAB_PLANNERS'
            , RS_Status_Error__c = 'No Fab Planner is available in the selected Customer Account Team. Please ask your admin to add the planner role in the account team.'
            , SetupOwnerId = UserInfo.getOrganizationId()));   
        lCustomSettingRSS.add(new CS_Risk_Start__c(Name='STATUS_Pending_Sales_Account_Inputs'
            , RS_Status_Error__c = 'Pending Sales Account Manager Inputs'
            , SetupOwnerId = UserInfo.getOrganizationId())); 
        lCustomSettingRSS.add(new CS_Risk_Start__c(Name='Expected_PO_Date'
            , RS_Status_Error__c = 'All fields in Sales Account Manager Section need to be filled'
            , SetupOwnerId = UserInfo.getOrganizationId()));                 


        insert lCustomSettingRSS;
        */
        List<Account_Team_Roles__c> lAccountTeamRoles = new List<Account_Team_Roles__c>();
        lAccountTeamRoles.add(new Account_Team_Roles__c(Name='ROLE_PRIMARY_ACCOUNT_MANAGER'
            , Role__c = 'Primary Account Manager'
            , SetupOwnerId = UserInfo.getOrganizationId()));
        lAccountTeamRoles.add(new Account_Team_Roles__c(Name='ROLE_ACCOUNT_MANAGER'
            , Role__c = 'Account Manager'
            , SetupOwnerId = UserInfo.getOrganizationId()));
        lAccountTeamRoles.add(new Account_Team_Roles__c(Name='ROLE_FAB_PLANNER'
            , Role__c = 'Fab Planner'
            , SetupOwnerId = UserInfo.getOrganizationId()));

        insert lAccountTeamRoles;
    }

    static void prepareRiskStartTestData1() {
    
        // Create Custom Settings.
        RiskStartSystemAccountTeamTest.createCustomSettings();
        
        // Create Dummy HCM User Data for Risk Start System Test
        List<HCM_Employee__c> lHCMEmployee = new List<HCM_Employee__c>();
        lHCMEmployee.add(RiskStartSystemAccountTeamTest.createHCMEmployee('User1', false));
        insert lHCMEmployee; 

        // Create Dummy User Data for Risk Start System Test
        lUser = new List<User>();

        lUser.add(RiskStartSystemAccountTeamTest.createUser('User1', false, true, true));
        insert lUser;

        System.debug('::::::::::::prepareRiskStartTestData1:::');
        
        // Create Dummy Account Team Data for Risk Start System Test
        lAccountTeam = new List<Account_Team_Proxy__c>();
        lAccountTeam.add(RiskStartSystemAccountTeamTest.createAccountTeamProxy(lUser.get(0), 'Fab Planner'));
        insert lAccountTeam;
        

    }
    
/*  
    static void prepareRiskStartTestData() {
        // Create Custom Settings.
        RiskStartSystemAccountTeamTest.createCustomSettings();
        
        // Create Dummy HCM User Data for Risk Start System Test
        List<HCM_Employee__c> lHCMEmployee = new List<HCM_Employee__c>();
        lHCMEmployee.add(RiskStartSystemAccountTeamTest.createHCMEmployee('User1', false));
        lHCMEmployee.add(RiskStartSystemAccountTeamTest.createHCMEmployee('User2', false));
        lHCMEmployee.add(RiskStartSystemAccountTeamTest.createHCMEmployee('User3', false));
        lHCMEmployee.add(RiskStartSystemAccountTeamTest.createHCMEmployee('User4', false));
        lHCMEmployee.add(RiskStartSystemAccountTeamTest.createHCMEmployee('User5', false));
        lHCMEmployee.add(RiskStartSystemAccountTeamTest.createHCMEmployee('User6', false));
        lHCMEmployee.add(RiskStartSystemAccountTeamTest.createHCMEmployee('User7', false));
        lHCMEmployee.add(RiskStartSystemAccountTeamTest.createHCMEmployee('User8', false));
        lHCMEmployee.add(RiskStartSystemAccountTeamTest.createHCMEmployee('User9', false));
        lHCMEmployee.add(RiskStartSystemAccountTeamTest.createHCMEmployee('User10', false));
        lHCMEmployee.add(RiskStartSystemAccountTeamTest.createHCMEmployee('User11', false));
        lHCMEmployee.add(RiskStartSystemAccountTeamTest.createHCMEmployee('User12', false));
        lHCMEmployee.add(RiskStartSystemAccountTeamTest.createHCMEmployee('User13', false));
        lHCMEmployee.add(RiskStartSystemAccountTeamTest.createHCMEmployee('User14', false));
        
        insert lHCMEmployee; 

        // Create Dummy User Data for Risk Start System Test
        lUser = new List<User>();

        lUser.add(RiskStartSystemAccountTeamTest.createUser('User1', false, true, true));

        lUser.add(RiskStartSystemAccountTeamTest.createUser('User2', false, true, true));
        lUser.add(RiskStartSystemAccountTeamTest.createUser('User3', false, true, true));
        lUser.add(RiskStartSystemAccountTeamTest.createUser('User4', false, true, true));
        lUser.add(RiskStartSystemAccountTeamTest.createUser('User5', false, true, true));
        lUser.add(RiskStartSystemAccountTeamTest.createUser('User6', false, true, true));
        lUser.add(RiskStartSystemAccountTeamTest.createUser('User7', false, true, true));
        lUser.add(RiskStartSystemAccountTeamTest.createUser('User8', false, true, true));
        lUser.add(RiskStartSystemAccountTeamTest.createUser('User9', false, true, true));
        lUser.add(RiskStartSystemAccountTeamTest.createUser('User10', false, true, true));
        lUser.add(RiskStartSystemAccountTeamTest.createUser('User11', false, true, true));
        lUser.add(RiskStartSystemAccountTeamTest.createUser('User12', false, true, true));
        lUser.add(RiskStartSystemAccountTeamTest.createUser('User13', false, true, true));

        lUser.add(RiskStartSystemAccountTeamTest.createUser('User14', false, true, true));
                                                                               
        insert lUser;

        // Create Dummy Account Team Data for Risk Start System Test
        lAccountTeam = new List<Account_Team_Proxy__c>();
        lAccountTeam.add(RiskStartSystemAccountTeamTest.createAccountTeamProxy(lUser.get(0), 'Fab Planner'));
        
        lAccountTeam.add(RiskStartSystemAccountTeamTest.createAccountTeamProxy(lUser.get(1), 'Fab Planner'));
        lAccountTeam.add(RiskStartSystemAccountTeamTest.createAccountTeamProxy(lUser.get(2), 'Fab Planner'));
        lAccountTeam.add(RiskStartSystemAccountTeamTest.createAccountTeamProxy(lUser.get(3), 'Fab Planner'));
        lAccountTeam.add(RiskStartSystemAccountTeamTest.createAccountTeamProxy(lUser.get(4), 'Fab Planner'));
        lAccountTeam.add(RiskStartSystemAccountTeamTest.createAccountTeamProxy(lUser.get(5), 'Fab Planner'));
        lAccountTeam.add(RiskStartSystemAccountTeamTest.createAccountTeamProxy(lUser.get(6), 'Fab Planner'));
        lAccountTeam.add(RiskStartSystemAccountTeamTest.createAccountTeamProxy(lUser.get(7), 'Fab Planner'));
        lAccountTeam.add(RiskStartSystemAccountTeamTest.createAccountTeamProxy(lUser.get(8), 'Fab Planner'));
        lAccountTeam.add(RiskStartSystemAccountTeamTest.createAccountTeamProxy(lUser.get(9), 'Fab Planner'));
        lAccountTeam.add(RiskStartSystemAccountTeamTest.createAccountTeamProxy(lUser.get(10), 'Fab Planner'));
        lAccountTeam.add(RiskStartSystemAccountTeamTest.createAccountTeamProxy(lUser.get(11), 'Account Manager'));
        lAccountTeam.add(RiskStartSystemAccountTeamTest.createAccountTeamProxy(lUser.get(12), 'Primary Account Manager'));
        lAccountTeam.add(RiskStartSystemAccountTeamTest.createAccountTeamProxy(lUser.get(13), 'Account Manager'));
      
        insert lAccountTeam;
    }
*/    

    static testmethod void testNoFabPlanners1() {
        
        // Load Environment Variables   
        //DataUtilTest.loadEnvironmentVariables();
        
        // Create Custom Settings.
        //try
        //{
            RiskStartSystemAccountTeamTest.createCustomSettings();      
            // Create Dummy Account Data for Risk Start System Test
            account = getAccount('MYTEST ACCOUNT1');
            
            
            // Create Dummy Risk Start System Data for Risk Start System Test
            Risk_Start_System__c riskStartSystem = RiskStartSystemAccountTeamTest.createRiskStartSystem('Fab 1');
            Test.startTest();
            insert riskStartSystem;
            Test.stopTest();
            String approvalProcess = RiskStartSystemHelper.processApprovalNew(riskStartSystem.Id);
            //System.assert(approvalProcess.equalsIgnoreCase('noFabPlanners'));
        //}
        //    catch (Exception ex) {
        //}
    }
    static testmethod void testNoFabPlanners2() {
        
        // Load Environment Variables   
        //DataUtilTest.loadEnvironmentVariables();
        
        // Create Custom Settings.
        //try
        //{
            RiskStartSystemAccountTeamTest.createCustomSettings();      
            // Create Dummy Account Data for Risk Start System Test
            account = getAccount('MYTEST ACCOUNT1');
            
            
            // Create Dummy Risk Start System Data for Risk Start System Test
            Risk_Start_System__c riskStartSystem = RiskStartSystemAccountTeamTest.createRiskStartSystem('Fab 2');
            Test.startTest();
            insert riskStartSystem;
            Test.stopTest();
            String approvalProcess = RiskStartSystemHelper.processApprovalNew(riskStartSystem.Id);
            //System.assert(approvalProcess.equalsIgnoreCase('noFabPlanners'));
        //}
        //    catch (Exception ex) {
        //}
    }
    static testmethod void testNoFabPlanners3() {
        
        // Load Environment Variables   
        //DataUtilTest.loadEnvironmentVariables();
        
        // Create Custom Settings.
        //try
        //{
            RiskStartSystemAccountTeamTest.createCustomSettings();      
            // Create Dummy Account Data for Risk Start System Test
            account = getAccount('MYTEST ACCOUNT1');
            
            
            // Create Dummy Risk Start System Data for Risk Start System Test
            Risk_Start_System__c riskStartSystem = RiskStartSystemAccountTeamTest.createRiskStartSystem('Fab 3');
            Test.startTest();
            insert riskStartSystem;
            Test.stopTest();
            String approvalProcess = RiskStartSystemHelper.processApprovalNew(riskStartSystem.Id);
            //System.assert(approvalProcess.equalsIgnoreCase('noFabPlanners'));
        //}
        //    catch (Exception ex) {
        //}
    }
    static testmethod void testNoFabPlanners3E() {
        
        // Load Environment Variables   
        //DataUtilTest.loadEnvironmentVariables();
        
        // Create Custom Settings.
        //try
        //{
            RiskStartSystemAccountTeamTest.createCustomSettings();      
            // Create Dummy Account Data for Risk Start System Test
            account = getAccount('MYTEST ACCOUNT1');
            
            
            // Create Dummy Risk Start System Data for Risk Start System Test
            Risk_Start_System__c riskStartSystem = RiskStartSystemAccountTeamTest.createRiskStartSystem('Fab 3E');
            Test.startTest();
            insert riskStartSystem;
            Test.stopTest();
            String approvalProcess = RiskStartSystemHelper.processApprovalNew(riskStartSystem.Id);
            //System.assert(approvalProcess.equalsIgnoreCase('noFabPlanners'));
        //}
        //    catch (Exception ex) {
        //}
    } 
    static testmethod void testNoFabPlanners5() {
        
        // Load Environment Variables   
        //DataUtilTest.loadEnvironmentVariables();
        
        // Create Custom Settings.
        //try
        //{
            RiskStartSystemAccountTeamTest.createCustomSettings();      
            // Create Dummy Account Data for Risk Start System Test
            account = getAccount('MYTEST ACCOUNT1');
            
            
            // Create Dummy Risk Start System Data for Risk Start System Test
            Risk_Start_System__c riskStartSystem = RiskStartSystemAccountTeamTest.createRiskStartSystem('Fab 5');
            Test.startTest();
            insert riskStartSystem;
            Test.stopTest();
            String approvalProcess = RiskStartSystemHelper.processApprovalNew(riskStartSystem.Id);
            //System.assert(approvalProcess.equalsIgnoreCase('noFabPlanners'));
        //}
        //    catch (Exception ex) {
        //}
    }
    static testmethod void testNoFabPlanners6() {
        
        // Load Environment Variables   
        //DataUtilTest.loadEnvironmentVariables();
        
        // Create Custom Settings.
        //try
        //{
            RiskStartSystemAccountTeamTest.createCustomSettings();      
            // Create Dummy Account Data for Risk Start System Test
            account = getAccount('MYTEST ACCOUNT1');
            
            
            // Create Dummy Risk Start System Data for Risk Start System Test
            Risk_Start_System__c riskStartSystem = RiskStartSystemAccountTeamTest.createRiskStartSystem('Fab 6');
            Test.startTest();
            insert riskStartSystem;
            Test.stopTest();
            String approvalProcess = RiskStartSystemHelper.processApprovalNew(riskStartSystem.Id);
            //System.assert(approvalProcess.equalsIgnoreCase('noFabPlanners'));
        //}
        //    catch (Exception ex) {
        //}
    }
    static testmethod void testNoFabPlanners7() {
        
        // Load Environment Variables   
        //DataUtilTest.loadEnvironmentVariables();
        
        // Create Custom Settings.
        //try
        //{
            RiskStartSystemAccountTeamTest.createCustomSettings();      
            // Create Dummy Account Data for Risk Start System Test
            account = getAccount('MYTEST ACCOUNT1');
            
            
            // Create Dummy Risk Start System Data for Risk Start System Test
            Risk_Start_System__c riskStartSystem = RiskStartSystemAccountTeamTest.createRiskStartSystem('Fab 7');
            Test.startTest();
            insert riskStartSystem;
            Test.stopTest();
            String approvalProcess = RiskStartSystemHelper.processApprovalNew(riskStartSystem.Id);
            //System.assert(approvalProcess.equalsIgnoreCase('noFabPlanners'));
        //}
        //    catch (Exception ex) {
        //}
    }
    static testmethod void testNoFabPlanners8() {
        
        // Load Environment Variables   
        //DataUtilTest.loadEnvironmentVariables();
        
        // Create Custom Settings.
        //try
        //{
            RiskStartSystemAccountTeamTest.createCustomSettings();      
            // Create Dummy Account Data for Risk Start System Test
            account = getAccount('MYTEST ACCOUNT1');
           
            // Create Dummy Risk Start System Data for Risk Start System Test
            Risk_Start_System__c riskStartSystem = RiskStartSystemAccountTeamTest.createRiskStartSystem('Fab 8');
            Test.startTest();
            insert riskStartSystem;
            Test.stopTest();
            String approvalProcess = RiskStartSystemHelper.processApprovalNew(riskStartSystem.Id);
            //System.assert(approvalProcess.equalsIgnoreCase('noFabPlanners'));
        //}
        //    catch (Exception ex) {
        //}
    }
    static testmethod void testApprovalProcessSubmitStatus() {

        // Load Environment Variables   
        //DataUtilTest.loadEnvironmentVariables();
        
        //try
        //{
            // Create Dummy Account Data for Risk Start System Test
            account = getAccount('MYTEST ACCOUNT1');     
            Test.startTest();
            
            
            RiskStartSystemAccountTeamTest.prepareRiskStartTestData1();
            
            // Create Dummy Risk Start System Data for Risk Start System Test
            Risk_Start_System__c riskStartSystem = RiskStartSystemAccountTeamTest.createRiskStartSystem('Fab 1');
            
            insert riskStartSystem;



//          RiskStartSystemHelper.updateFabPlanningUsers(riskStartSystem.Id, RiskStartSystemAccountTeamTest.getIuser());
            
            riskStartSystem.Status__c = 'None';
            //update riskStartSystem;
            
            String approvalProcess = riskStartSystemHelper.processApprovalNew(riskStartSystem.Id);
            //System.assert(approvalProcess.equalsIgnoreCase('failure'));
            
            riskStartSystem.Status__c = CS_Risk_Start__c.getInstance('STATUS_DRAFT').RS_Status_Error__c;
            //update riskStartSystem;
            
            
            approvalProcess = RiskStartSystemHelper.processApprovalNew(riskStartSystem.Id);
            Test.stopTest();
            //System.assert(approvalProcess.equalsIgnoreCase('success'));
    
            //approvalProcess = RiskStartSystemHelper.processApprovalNew(riskStartSystem.Name);
            //System.assert(approvalProcess.equalsIgnoreCase('noFabPlanners'));
        //}
        //catch (Exception ex) {
        //}
    }

    static testmethod void testFabPartition() {
        
        // Load Environment Variables   
        //DataUtilTest.loadEnvironmentVariables();
        
        // Create Dummy Account Data for Risk Start System Test
        //try
        //{
            account = getAccount('MYTEST ACCOUNT1');
            Test.startTest();
            
            
            RiskStartSystemAccountTeamTest.prepareRiskStartTestData1();
            // Create Dummy Risk Start System Data for Risk Start System Test
            Risk_Start_System__c riskStartSystem = RiskStartSystemAccountTeamTest.createRiskStartSystem('Fab 1');
            insert riskStartSystem;
            
            System.debug('::::::::::::testFabPartition:::');

         
            // All users are from Fab 1, Fab 3, Fab 8
            riskStartSystem.Status__c = CS_Risk_Start__c.getInstance('STATUS_PENDING_CUSTOMER_PLANNING').RS_Status_Error__c;
                    
            try {
            
            
               // update riskStartSystem;
              //  System.assert(false);
            } catch (Exception ex) {
                System.assert(ex instanceof System.DMLException);
                System.assert(ex.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
                System.Assert(ex.getMessage().contains(
                CS_Risk_Start__c.getInstance('ERROR_NO_FAB_PLANNERS').RS_Status_Error__c.replace('MERGE_FAB', riskStartSystem.Fab__c)));
            }
        //}
        //catch (Exception ex) {
        //}
    }
 
    static testMethod void testDateValidation() {
        
        Test.startTest();
        
        //DataUtilTest.loadEnvironmentVariables();
        
        CustomerNumber__c customerNumber = new CustomerNumber__c();
        customerNumber.Name = 'Update Customer No';
        customerNumber.Customer_No__c = 1200001;
        insert customerNumber;
        
        account = getAccount('MYTEST ACCOUNT1');
        
        Risk_Start_System__c riskStartSystem = RiskStartSystemAccountTeamTest.createRiskStartSystem('Fab 1');
        riskStartSystem.Expected_PO_Date__c = Date.today();
        riskStartSystem.PO_Arrival_Date__c = '23/04/2016;24/04/2016';
        riskStartSystem.Scrap_Date__c = '23/04/2016';
        riskStartSystem.Write_Off_Date__c = '23/04/2016';
        riskStartSystem.Void_Date__c = '23/04/2016';
        
        insert riskStartSystem;
        
        riskStartSystem.PO_Arrival_Date__c = '04/24;';
        riskStartSystem.Scrap_Date__c = '04/24/2016;';
        riskStartSystem.Write_Off_Date__c = 'dssdfsa;';
        riskStartSystem.Void_Date__c = '04/24/edfdcn;';
        update riskStartSystem;
        
        riskStartSystem.PO_Arrival_Date__c = null;
        riskStartSystem.Scrap_Date__c = '04/24/2016;';
        update riskStartSystem;

        riskStartSystem.Scrap_Date__c = null;
        riskStartSystem.Write_Off_Date__c = 'dssdfsa;';
        update riskStartSystem;

        riskStartSystem.Write_Off_Date__c = null;
        riskStartSystem.Void_Date__c = '04/24/edfdcn;';
        update riskStartSystem;
        
        Test.stopTest();
    }
    
    static testMethod void runTest1() {
    
        List<User> userList = [SELECT Id, Name FROM User];
        
        RiskStartSystemAccountTeamTest.createCustomSettings(); 

        // Create Dummy Account Data for Risk Start System Test
        account = getAccount('MYTEST ACCOUNT1');
        
        // Create Dummy Risk Start System Data for Risk Start System Test
        Risk_Start_System__c riskStartSystem = RiskStartSystemAccountTeamTest.createRiskStartSystem('Fab 1');
        
        Test.startTest();
        ///insert riskStartSystem;
        
        List<Risk_Start_System__c> rtsList = new List<Risk_Start_System__c>();
        rtsList.add(riskStartSystem);
        
        List<User> tempUserList = new List<User>();
        for(User userObj : userList){
            
            tempUserList.add(userObj);
            
            if(tempUserList.size() < 16){
                
                RiskStartSystemHelper.updateFabPlanningUsers(rtsList, tempUserList);
            }
            else{
                break;
            }
        }
        
        Test.stopTest();
    }
     
     private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }   
}