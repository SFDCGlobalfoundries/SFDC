/*
  Author: Anirban Roy
  Description: This is the test class for the ExpConReassignOwnerController class.
  History:
    ARoy        07172013    - code creation.             
    Nbustillos  10122013    - Added call to loadEnvironmentVariables() method.
                            - Updated annotation to SeeAllData=false 
    Vijay       16012015    - Updated the Device Stage 'Solutioning' to 'Design In' as Device will be created in 
                                  'Design In' directly and added mandatory fields.    
    DBiswal     04152015    - Updated code for making SeeAllData=false and refactoring of test class.
    ARoy        08142017    - Modified for Export Control changes.      
*/

@isTest(SeeAllData=false)
public class ExpConReassignOwnerController_Test {
    
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        for(Environment_Variable__c e:[select id,Name from Environment_Variable__c ]){
            system.debug('---------'+e);
        }
        User user = ExpConReassignOwnerController_Test.createUser1();
        System.runAs(user)
        {
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

        AccountDataFactory.createAccount(fieldValueMap);
        
        Map<String,Object> fieldValueMap1 = new Map<String,Object>();
        fieldValueMap1.put('Name', 'MYTEST ACCOUNT2');            
        fieldValueMap1.put('stage__c', 'Unqualified');        
        fieldValueMap1.put('sub_type__c', 'Direct');
        fieldValueMap1.put('site_department__c', 'test dept');          
        fieldValueMap1.put('transaction_type__c', 'transactional');                          
        fieldValueMap1.put('region__c', 'APJ');        
        fieldValueMap1.put('Corporate_Address_1__c', 'Test Address 2');          
        fieldValueMap1.put('Corporate_City__c', 'Test City');                
        fieldValueMap1.put('Corporate_Country__c', 'Singapore');
        fieldValueMap1.put('Bill_To_Address_1__c', 'Test Address 2');          
        fieldValueMap1.put('Bill_To_City__c', 'Test City');            
        fieldValueMap1.put('Bill_To_Country__c', 'Singapore');        
        fieldValueMap1.put('Fab_9_10__c','No');

        AccountDataFactory.createAccount(fieldValueMap1);
        }
    }
       
    //Creation of User
    static User createUser1(){
        User usr1 = [select id,name,email from User where profileId in (select id from Profile where Name='System Administrator') and IsActive=true and UserRoleId in (select id from UserRole where Name='Global Admin') limit 1];
        return usr1;
    }
    
    //Creation of Another User
    static User createUser2(){
        User usr1 = [select id,name,email from User where profileId in (select id from Profile where Name='GF CE') and IsActive=true and UserRoleId in (select id from UserRole where Name='Global Admin') limit 1];
        return usr1;
    }
        
    // Creation of Contact 1
    static Id createContact1(Id accId){
        Contact con = new Contact(FirstName='TestFirst', LastName='TestLast', AccountId=accId, Email='testcon@gf.com', Department__c='Design');
        insert con;
        return con.Id;
    }
    
    //Creation of Portal User
    static User createportalUser1(Id conId){
    //static Id createportalUser1() {
        Profile profileObj = [Select Name,Id from Profile where Name = 'Customer Portal Admin'];
        //UserRole userRoleObj = [SELECT Id FROM UserRole WHERE DeveloperName = 'Customer User'];
        User usr1 = new User(Alias = 'Test', Email='Test@test.com', EmailEncodingKey='UTF-8', LastName='Test',
                            LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = profileObj.Id, TimeZoneSidKey='America/Los_Angeles',
                            UserName='Test1212112@test.com', Portal_Login__c = 'abc', contactId = conId, IsActive = true);
        insert usr1;
        return usr1;
        
        /* User usr1 = [
            SELECT      Id
            FROM        User
            WHERE       Contact.Id != null
                        AND IsActive = true
            LIMIT 1
        ];
        
        return usr1.Id; */
    }    
    
    // Creation of an opportunity
    static Id createOpp(Id acctId){
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('AccountId',acctId);
        fieldValueMap.put('Name','Test OpportunityZ1');  
        fieldValueMap.put('StageName','1. Discovery');
        fieldValueMap.put('CloseDate',date.newinstance(2012, 12, 21));  
        fieldValueMap.put('Target_Process_Node__c','14XM');
        fieldValueMap.put('Market_Segment__c','Automotive');  
        fieldValueMap.put('Process_Platform__c','GF Baseline');
        fieldValueMap.put('Fab_Split__c',100);          
        fieldValueMap.put('Process_Geometry__c','0.09UM');  
        fieldValueMap.put('Process_Family__c','Generic / Nominal');
        fieldValueMap.put('Opportunity_Sourcing_Type__c','First Source');  
         
        return OpportunityDataFactory.createOpportunity(fieldValueMap).id;
        
    }
    
    // Creation of an opportunity program
    static Id createOppProg(Id acctId,Id oppId){
        Opportunity_Program__c opProg = new Opportunity_Program__c(Name='Test OppProgZ1',Account__c=acctId,Opportunity__c=oppId);
        insert opProg;
        return opProg.Id;
    }
    
    // Creation of an opportunity program team member
    static Opportunity_Program_Team_Member__c createOppProgTmMem(Id oppProgId, Id userId){
        Opportunity_Program_Team_Member__c oppProgTM = new Opportunity_Program_Team_Member__c(Core_Team_Member__c=false,
                                        Device_Access__c='Read/Write',Opportunity_Program_Access__c='Read/Write',
                                        Opportunity_Program__c=oppProgId,Team_Role__c='Field Application Engineer',
                                        User__c=userId,Flag_for_Delete__c=false);
        insert oppProgTM;
        return oppProgTM;
    }
    
    // Creation of Device
    /*static Device__c createDevice(Id accId, Id oppId, Id oppProgId){
        Device__c dev = new Device__c();
        dev.Name = 'TESTDEVICE1947Z1';
        dev.Stage__c = 'Design In';
        dev.Status__c = 'Active';
        dev.Account__c = accId;
        dev.Opportunity2__c = oppId;
        dev.Opportunity_Program__c = oppProgId;
        dev.Market_Segment__c = 'Automotive';
        dev.Semiconductor_Device__c = 'Analog Regulator';
        dev.End_Application__c = 'Body';
        dev.Device_Sourcing__c = '3rd Source';
        dev.Tapeout_Type__c = 'Customer MPW';
        dev.Siebel_Device_ID__c = '0987654321';
        dev.IP_Gap__c = false;
        dev.Actual_Tapeout_Date__c = date.newInstance(2013,5,20);
        dev.Original_Forecasted_Tapeout_Date__c = date.newInstance(2013,5,20);
        dev.Current_Forecast_Tapeout_Date__c = date.newInstance(2013,3,4);
        dev.PLM_Device_ID__c = 'ANBQP60ACO8CH-U01';
        dev.Fab__c = 'Fab 3';
        dev.Confidence_Level_Tapeout__c = '100';
        
        insert dev;
        return dev; 
    }
    */
    
    static Id createMaskSetTitle(){
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name','MSTTRT1');
        fieldValueMap.put('Reticle_Type__c','Multi Layer Reticle (MLR)');
        return MaskSetTitleDataFactory.createMaskSetTitle(fieldValueMap).Id;
    }
    public static Device__c createCMPWDevice(Id acctId,Id opptyProgramId){
        String MSTId = CreateMaskSetTitle();
        string MSTAccId = DeviceUtilTest.createMSTAccount(acctId,MSTId);
        // Create Device
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Account__c',acctId);
        fieldValueMap.put('Design_Partner__c',acctId);
        fieldValueMap.put('Name','Win-TEST-DEVICE-1947');
        fieldValueMap.put('Opportunity_Program__c',opptyProgramId);
        fieldValueMap.put('Fab__c','FAB 2');
        fieldValueMap.put('GSOP_Assignment_Tapeout_Plan__c','No');
        fieldValueMap.put('Market_Segment__c','Automotive');
        fieldValueMap.put('Semiconductor_Device__c','Analog Amplifier');
        fieldValueMap.put('End_Customer__c','Test Customer');
        fieldValueMap.put('Device_Sourcing__c','3rd Source');
        fieldValueMap.put('Stage__c','Design In');
        fieldValueMap.put('Status__c','Active');
        fieldValueMap.put('Siebel_Device_ID__c','1234567890');
        fieldValueMap.put('Tapeout_Type__c','Customer MPW');
        fieldValueMap.put('PLM_Device_ID__c','ANBQP60ACO8CH-U01');
        fieldValueMap.put('Device_Mask_Set_Title__c','MSTTRT1');
        fieldValueMap.put('CRMDID__c','CDID0000001.00');
        fieldValueMap.put('Actual_Tapeout_Date__c',date.newInstance(2013,5,20));
        fieldValueMap.put('Original_Forecasted_Tapeout_Date__c',date.newInstance(2013,5,20));
        fieldValueMap.put('Current_Forecast_Tapeout_Date__c',date.newInstance(2013,3,4));
        fieldValueMap.put('Confidence_Level_Tapeout__c','100');
        fieldValueMap.put('Device_Type__c','Base');
        fieldValueMap.put('End_Application__c','Body');
        fieldValueMap.put('IP_Gap__c',false);
        return DeviceDataFactory.createDevice(fieldValueMap);
    }
    
    // Creation of Export Control HS Code
    static Export_Control_HS_Code__c createExportControlHSCode(){
        Export_Control_HS_Code__c expConHSCode = new Export_Control_HS_Code__c();
        expConHSCode.HS_Code__c = 'Test HS Code';
        expConHSCode.HS_Description__c = 'Test HS Description';
        insert expConHSCode;
        return expConHSCode; 
    }
    
    // Creation of Export Control Form
    static Export_Control_Form__c createExportControlForm(Id expConHSCodeId){
        Export_Control_Form__c expConForm = new Export_Control_Form__c();        
        expConForm.OwnerId__c = UserInfo.getUserId();
        expConForm.Product_Description__c = 'Test Description';
        expConForm.Phone__c = '3456321';
        expConForm.Weapon_Product__c = 'No';
        expConForm.Military_App_Product__c = 'No';
        expConForm.ITAR_Product__c = 'No';
        expConForm.US_EAR_Product__c = 'No';
        expConForm.Non_US_EAR_Product__c = 'No';
        expConForm.Harmonized_System__c = expConHSCodeId;
        expConForm.Other_Harmonized_System__c = 'Others';
        expConForm.US_EAR_Product_Details__c = 'test';
        insert expConForm;
        return expConForm;
    }
    
    static Device_Export_Control_Junction__c createJunction(Id devId, Id exConId){
        Device_Export_Control_Junction__c junc = new Device_Export_Control_Junction__c(
            device__c = devId,
            export_control_form__c = exConId
        );
        insert junc;
        return junc;
    }  
    
    // Test Method for Reassign Owner
    static testMethod void reAssignOwnerTestA(){
        
        // Load Environment Variables   
        //DataUtilTest.loadEnvironmentVariables();
        
        User admin = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(admin){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = admin.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
            List <Environment_Variable__c> envVarList = new List<Environment_Variable__c>();
            Environment_Variable__c envVar1 = new Environment_Variable__c(Name='EXP_CON_CUS_CON_PER_API_NAME', Value__c = 'Customer_Trade_Compliance_Contact_Person__c');
            envVarList.add(envVar1);
            Environment_Variable__c envVar2 = new Environment_Variable__c(Name='EXP_CON_PHONE_API_NAME', Value__c = 'Phone__c');
            envVarList.add(envVar2);
            Environment_Variable__c envVar3 = new Environment_Variable__c(Name='EXP_CON_LAST_ASS_USER_API_NAME', Value__c = 'Last_Assigned_Customer_User__c');
            envVarList.add(envVar3);
            Environment_Variable__c envVar4 = new Environment_Variable__c(Name='EXP_CON_EMAIL_ADD_API_NAME', Value__c = 'Email_Address__c');
            envVarList.add(envVar4);
            insert envVarList;
            AcctRegHeadMappingTgrHandler.bypassAcctTrigger = true;
            ClsAccTriggerHandler.blnAccountShareRun = true;
            // Data creation
            User user = ExpConReassignOwnerController_Test.createUser1();
            String acctId = getAccount('MYTEST ACCOUNT1').id;
            String contactId = ExpConReassignOwnerController_Test.createContact1(acctId);
            String portalUserId;
            //String portalUserId = ExpConReassignOwnerController_Test.createportalUser1(contactId);
            //String portalUserId = ExpConReassignOwnerController_Test.createportalUser1();
            String oppId = ExpConReassignOwnerController_Test.createOpp(acctId);
            String oppProgId = ExpConReassignOwnerController_Test.createOppProg(acctId, oppId);
            Opportunity_Program_Team_Member__c oppProgTM = ExpConReassignOwnerController_Test.createOppProgTmMem(oppProgId, user.Id); 
            Test.startTest();
            system.runas(user){
             portalUserId = ExpConReassignOwnerController_Test.createportalUser1(contactId).Id; 
            }
            String MSTId = DeviceUtilTest.createMaskSetTtitle();
            string MSTAccId = DeviceUtilTest.createMSTAccount(acctId,MSTId);
            Device__c dev = DeviceUtilTest.createCustomerMPWDevice3(acctId,oppId,oppProgId);
            Export_Control_HS_Code__c expConHSCode = ExpConReassignOwnerController_Test.createExportControlHSCode();
            Export_Control_Form__c expConForm = ExpConReassignOwnerController_Test.createExportControlForm(expConHSCode.Id);
            Device_Export_Control_Junction__c junc = ExpConReassignOwnerController_Test.createJunction(dev.id, expConForm.id);
    
            ApexPages.currentPage().getParameters().put('id',expConForm.Id);
            ExpConReassignOwnerController expConReassign = new ExpConReassignOwnerController();
            List<SelectOption> selOpt = expConReassign.getAllAccountContacts();
            expConReassign.ownerId = portalUserId;
            
            // Save operation
            PageReference pgr = expConReassign.save();
            //system.assert(pgr.getUrl().contains(expConForm.Id));
            
            // Cancel operation
            pgr = expConReassign.cancel();
            system.assert(pgr.getUrl().contains(expConForm.Id));
            
            // Cancel operation
            ApexPages.currentPage().getParameters().put('type','list');
            ApexPages.currentPage().getParameters().put('deviceid',dev.Id);
            pgr = expConReassign.cancel();
            system.assert(pgr!=null);
            
            Test.stopTest();
        }    
    }
    
    static testMethod void reAssignOwnerTestB(){
        
        // Load Environment Variables   
        //DataUtilTest.loadEnvironmentVariables();
        
        User admin = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(admin){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = admin.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
            List <Environment_Variable__c> envVarList = new List<Environment_Variable__c>();
            Environment_Variable__c envVar1 = new Environment_Variable__c(Name='EXP_CON_CUS_CON_PER_API_NAME', Value__c = 'Customer_Trade_Compliance_Contact_Person__c');
            envVarList.add(envVar1);
            Environment_Variable__c envVar2 = new Environment_Variable__c(Name='EXP_CON_PHONE_API_NAME', Value__c = 'Phone__c');
            envVarList.add(envVar2);
            Environment_Variable__c envVar3 = new Environment_Variable__c(Name='EXP_CON_LAST_ASS_USER_API_NAME', Value__c = 'Last_Assigned_Customer_User__c');
            envVarList.add(envVar3);
            Environment_Variable__c envVar4 = new Environment_Variable__c(Name='EXP_CON_EMAIL_ADD_API_NAME', Value__c = 'Email_Address__c');
            envVarList.add(envVar4);
            insert envVarList;
            AcctRegHeadMappingTgrHandler.bypassAcctTrigger = true;
            ClsAccTriggerHandler.blnAccountShareRun = true;
            // Data creation
            User user = ExpConReassignOwnerController_Test.createUser1();
            String acctId = getAccount('MYTEST ACCOUNT1').id;
            String contactId = ExpConReassignOwnerController_Test.createContact1(acctId);
            String portalUserId;
            
            //String portalUserId = ExpConReassignOwnerController_Test.createportalUser1();
            String oppId = ExpConReassignOwnerController_Test.createOpp(acctId);
            String oppProgId = ExpConReassignOwnerController_Test.createOppProg(acctId, oppId);
            Opportunity_Program_Team_Member__c oppProgTM = ExpConReassignOwnerController_Test.createOppProgTmMem(oppProgId, user.Id);
            Test.startTest();
            system.runas(user){
             portalUserId = ExpConReassignOwnerController_Test.createportalUser1(contactId).Id;
            }  
            String MSTId = DeviceUtilTest.createMaskSetTtitle();
            string MSTAccId = DeviceUtilTest.createMSTAccount(acctId,MSTId);
            Device__c dev = DeviceUtilTest.createCustomerMPWDevice3(acctId,oppId,oppProgId);
            Export_Control_HS_Code__c expConHSCode = ExpConReassignOwnerController_Test.createExportControlHSCode();
            Export_Control_Form__c expConForm = ExpConReassignOwnerController_Test.createExportControlForm(expConHSCode.Id);
            Device_Export_Control_Junction__c junc = ExpConReassignOwnerController_Test.createJunction(dev.id, expConForm.id);
    
            ApexPages.currentPage().getParameters().put('id',expConForm.Id);
            ExpConReassignOwnerController expConReassign = new ExpConReassignOwnerController();
            List<SelectOption> selOpt = expConReassign.getAllAccountContacts();
            expConReassign.ownerId = portalUserId;
            
            // Save operation
            PageReference pgr = expConReassign.save();
            
            // Validation errors
            expConForm.Status__c = 'On-hold';
            update expConForm;
            system.assert(pgr.getUrl().contains(expConForm.Id));
            //expConReassign = new ExpConReassignOwnerController();
            //pgr = expConReassign.save();
            //system.assertEquals(pgr,null);
            
            Test.stopTest();
        }    
    }
    
    static testMethod void reAssignOwnerTestC(){
        
        // Load Environment Variables   
        //DataUtilTest.loadEnvironmentVariables();
        
        User admin = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(admin){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = admin.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
            List <Environment_Variable__c> envVarList = new List<Environment_Variable__c>();
            Environment_Variable__c envVar1 = new Environment_Variable__c(Name='EXP_CON_CUS_CON_PER_API_NAME', Value__c = 'Customer_Trade_Compliance_Contact_Person__c');
            envVarList.add(envVar1);
            Environment_Variable__c envVar2 = new Environment_Variable__c(Name='EXP_CON_PHONE_API_NAME', Value__c = 'Phone__c');
            envVarList.add(envVar2);
            Environment_Variable__c envVar3 = new Environment_Variable__c(Name='EXP_CON_LAST_ASS_USER_API_NAME', Value__c = 'Last_Assigned_Customer_User__c');
            envVarList.add(envVar3);
            Environment_Variable__c envVar4 = new Environment_Variable__c(Name='EXP_CON_EMAIL_ADD_API_NAME', Value__c = 'Email_Address__c');
            envVarList.add(envVar4);
            insert envVarList;
            AcctRegHeadMappingTgrHandler.bypassAcctTrigger = true;
            ClsAccTriggerHandler.blnAccountShareRun = true;
            // Data creation
            User user = ExpConReassignOwnerController_Test.createUser1();
            String acctId = getAccount('MYTEST ACCOUNT1').id;
            String contactId = ExpConReassignOwnerController_Test.createContact1(acctId);
            String portalUserId;
            
            //String portalUserId = ExpConReassignOwnerController_Test.createportalUser1();
            String oppId = ExpConReassignOwnerController_Test.createOpp(acctId);
            String oppProgId = ExpConReassignOwnerController_Test.createOppProg(acctId, oppId);
            Opportunity_Program_Team_Member__c oppProgTM = ExpConReassignOwnerController_Test.createOppProgTmMem(oppProgId, user.Id);  
            
            Test.startTest();
            system.runas(user){
             portalUserId = ExpConReassignOwnerController_Test.createportalUser1(contactId).Id;
            }
            String MSTId = DeviceUtilTest.createMaskSetTtitle();
            string MSTAccId = DeviceUtilTest.createMSTAccount(acctId,MSTId);
            Device__c dev = DeviceUtilTest.createCustomerMPWDevice3(acctId,oppId,oppProgId);
            Export_Control_HS_Code__c expConHSCode = ExpConReassignOwnerController_Test.createExportControlHSCode();
            Export_Control_Form__c expConForm = ExpConReassignOwnerController_Test.createExportControlForm(expConHSCode.Id);
            Device_Export_Control_Junction__c junc = ExpConReassignOwnerController_Test.createJunction(dev.id, expConForm.id);
    
            ApexPages.currentPage().getParameters().put('id',expConForm.Id);
            ExpConReassignOwnerController expConReassign = new ExpConReassignOwnerController();
            List<SelectOption> selOpt = expConReassign.getAllAccountContacts();
            expConReassign.ownerId = portalUserId;
            
            // Save operation
            //PageReference pgr = expConReassign.save();
            
            // Validation errors
            expConForm.Status__c = 'On-hold';
            update expConForm;
            //expConReassign = new ExpConReassignOwnerController();
            //pgr = expConReassign.save();
            PageReference pgr = expConReassign.save();
            system.assert(pgr.getUrl().contains(expConForm.Id));
            
            Test.stopTest();
        }    
    }
    
    // Test Method for validation error for Reassign Owner
    static testMethod void reAssignOwnerIsValidTest(){
        
        // Load Environment Variables   
        //DataUtilTest.loadEnvironmentVariables();
        User admin = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(admin){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = admin.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
            List <Environment_Variable__c> envVarList = new List<Environment_Variable__c>();
            Environment_Variable__c envVar1 = new Environment_Variable__c(Name='EXP_CON_CUS_CON_PER_API_NAME', Value__c = 'Customer_Trade_Compliance_Contact_Person__c');
            envVarList.add(envVar1);
            Environment_Variable__c envVar2 = new Environment_Variable__c(Name='EXP_CON_PHONE_API_NAME', Value__c = 'Phone__c');
            envVarList.add(envVar2);
            Environment_Variable__c envVar3 = new Environment_Variable__c(Name='EXP_CON_LAST_ASS_USER_API_NAME', Value__c = 'Last_Assigned_Customer_User__c');
            envVarList.add(envVar3);
            Environment_Variable__c envVar4 = new Environment_Variable__c(Name='EXP_CON_EMAIL_ADD_API_NAME', Value__c = 'Email_Address__c');
            envVarList.add(envVar4);
            insert envVarList;
            AcctRegHeadMappingTgrHandler.bypassAcctTrigger = true;
            ClsAccTriggerHandler.blnAccountShareRun = true;
            // Data creation
            User user = ExpConReassignOwnerController_Test.createUser2();
            String acctId = getAccount('MYTEST ACCOUNT1').id;
            system.AssertEquals(acctId, getAccount('MYTEST ACCOUNT1').id);
            String acctId1 = getAccount('MYTEST ACCOUNT2').id;
            String contactId = ExpConReassignOwnerController_Test.createContact1(acctId);
            User portalUser;
            
            //String portalUserId = ExpConReassignOwnerController_Test.createportalUser1();
            String oppId = ExpConReassignOwnerController_Test.createOpp(acctId);
            String oppProgId = ExpConReassignOwnerController_Test.createOppProg(acctId, oppId);
            Opportunity_Program_Team_Member__c oppProgTM = ExpConReassignOwnerController_Test.createOppProgTmMem(oppProgId, user.Id);  
                    
            
            Test.startTest();
            system.runas(user){
             portalUser = ExpConReassignOwnerController_Test.createportalUser1(contactId);
            }
            //String MSTId = DeviceUtilTest.createMaskSetTtitle();
            //string MSTAccId = DeviceUtilTest.createMSTAccount(acctId,MSTId);
            //Device__c dev = DeviceUtilTest.createCustomerMPWDevice3(acctId,oppId,oppProgId);
            Device__c dev = ExpConReassignOwnerController_Test.createCMPWDevice(acctId,oppProgId);
            dev.Design_Partner__c = acctId1;
            update dev;
            Export_Control_HS_Code__c expConHSCode = ExpConReassignOwnerController_Test.createExportControlHSCode();
            Export_Control_Form__c expConForm = ExpConReassignOwnerController_Test.createExportControlForm(expConHSCode.Id);
            Device_Export_Control_Junction__c junc = ExpConReassignOwnerController_Test.createJunction(dev.id, expConForm.id);
                    
            
            //system.runAs(user){
                ApexPages.currentPage().getParameters().put('id',expConForm.Id);
                ExpConReassignOwnerController expConReassign = new ExpConReassignOwnerController();
                List<SelectOption> selOpt = expConReassign.getAllAccountContacts();
                system.runAs(portalUser){
                    selOpt = expConReassign.getAllAccountContacts();    
                }
                expConReassign.ownerId = portalUser.Id;
                
                // Save operation
                PageReference pgr = expConReassign.save();
                system.assert(pgr.getUrl().contains(expConForm.Id));
            //}        
            
            Test.stopTest();
        }    
    }
    
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
    
}