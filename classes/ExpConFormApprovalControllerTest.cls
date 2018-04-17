/*
    Author: Anirban Roy
    Description: This is the test class of ExpConFormApprovalController class.
    History: 
        ARoy     10312013    - Code creation.
        Vijay    16012015    - Updated the Device Stage 'Solutioning' to 'Design In' as Device will be created in 
                                  'Design In' directly and added mandatory fields.
        DBiswal  04152015    - Updated code for making SeeAllData=false and refactoring of test class.
        NJain    05072015    - Refactoring test class with testSetup.
*/

@isTest(seealldata=false)
public class ExpConFormApprovalControllerTest {
    
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        // Data creation
        User user = ExpConFormApprovalControllerTest.createUser();
        
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

        String acctId = AccountDataFactory.createAccount(fieldValueMap).id;
        
        String oppId = ExpConFormApprovalControllerTest.createOpp(acctId);
        String oppProgId = ExpConFormApprovalControllerTest.createOppProg(acctId, oppId);
        Opportunity_Program_Team_Member__c oppProgTM = ExpConFormApprovalControllerTest.createOppProgTmMem(oppProgId, user.Id); 
        String MSTId = DeviceUtilTest.createMaskSetTtitle();
        string MSTAccId = DeviceUtilTest.createMSTAccount(acctId,MSTId); 
        Device__c dev = DeviceUtilTest.createCustomerMPWDevice3(acctId,oppId,oppProgId);
        
        Environment_Variable__c ev = Environment_Variable__c.getInstance('EXP_CNTRL_Q8_VALID_DATE');
        Environment_Variable__c ev1 = Environment_Variable__c.getInstance('QUES_5_NEW_STARTSWITH');
        ev.Value__c = '2014-04-04 00:00:00';
        update ev;
    }
    
    //Creation of User
    static User createUser(){
        User usr1 = [select id,name,email from User where profileId in (select id from Profile where Name='System Administrator') and IsActive=true limit 1];
        return usr1;
    }
       
    // Creation of an opportunity
    static Id createOpp(Id acctId){
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('AccountId',acctId);
        fieldValueMap.put('Name','Test Opportunity');  
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
        Opportunity_Program__c opProg = new Opportunity_Program__c(Name='Test OppProg',Account__c=acctId,Opportunity__c=oppId);
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
  /*  static Device__c createDevice(Id accId, Id oppId, Id oppProgId){
        Device__c dev = new Device__c();
        dev.Name = 'TESTDEVICE1947';
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
        dev.Fab__c = 'Fab 3';
        dev.Confidence_Level_Tapeout__c = '100';
        
        insert dev;
        return dev; 
    }
    */
    // Creation of Export Control HS Code
    static Export_Control_HS_Code__c createExportControlHSCode(){
        Export_Control_HS_Code__c expConHSCode = new Export_Control_HS_Code__c();
        expConHSCode.HS_Code__c = 'Test HS Code';
        expConHSCode.HS_Description__c = 'Test HS Description';
        insert expConHSCode;
        return expConHSCode; 
    }
    
    // Creation of Export Control HS Code
    static Export_Control_HS_Code__c createExportControlHSCode1(){
        Export_Control_HS_Code__c expConHSCode = new Export_Control_HS_Code__c();
        expConHSCode.HS_Code__c = 'Other2';
        expConHSCode.HS_Description__c = 'Other2';
        insert expConHSCode;
        return expConHSCode; 
    }
    
    // Creation of Export Control Form
    static Export_Control_Form__c createExportControlForm(Id expConHSCodeId){
        Export_Control_Form__c expConForm = new Export_Control_Form__c();       
        expConForm.Customer_Trade_Compliance_Contact_Person__c = 'Test123, Test123';
        expConForm.Email_Address__c = 'test@test.com';
        expConForm.OwnerId__c = UserInfo.getUserId();
        expConForm.Phone__c = '3456321';
        expConForm.Product_Description__c = 'Test Description';
        expConForm.Weapon_Product__c = 'No';
        expConForm.Military_App_Product__c = 'No';
        expConForm.ITAR_Product__c = 'No';
        expConForm.US_EAR_Product__c = 'No';
        expConForm.Non_US_EAR_Product__c = 'No';
        expConForm.Harmonized_System__c = expConHSCodeId;
        expConForm.Other_Harmonized_System__c = 'Others';
        expConForm.Status__c = 'Draft';
        expConForm.D1_National_Access_is_Allowed__c = 'No';
        expConForm.End_User_Customer_Name__c = 'Test Customer Name';
        expConForm.US_EAR_Product_Details__c = 'test';
        insert expConForm;
        return expConForm;
    }
    
    // Creation of Export Control Form
    static Export_Control_Form__c createExportControlForm1(){
        Export_Control_Form__c expConForm = new Export_Control_Form__c();
        expConForm.D1_National_Access_is_Allowed__c = 'No';   
        expConForm.US_EAR_Product_Details__c = 'test';     
        insert expConForm;
        return expConForm;
    }
    
    // Creation of Export Control Form
    static Export_Control_Form__c createExportControlForm2(Id expConHSCodeId){
        Export_Control_Form__c expConForm = new Export_Control_Form__c();       
        expConForm.Customer_Trade_Compliance_Contact_Person__c = 'Test123, Test123';
        expConForm.OwnerId__c = UserInfo.getUserId();
        expConForm.Phone__c = '3456321';
        expConForm.Product_Description__c = 'Test Description';
        expConForm.Weapon_Product__c = 'No';
        expConForm.Military_App_Product__c = 'Yes';
        expConForm.ITAR_Product__c = 'Yes';
        expConForm.US_EAR_Product__c = 'Yes';
        expConForm.Non_US_EAR_Product__c = 'Yes';
        expConForm.Harmonized_System__c = expConHSCodeId;
        expConForm.Status__c = 'Draft';
        expConForm.D1_National_Access_is_Allowed__c = 'No';
        expConForm.US_EAR_Product_Details__c = 'test';
        insert expConForm;
        return expConForm;
    }
    
    // Creation of Export Control Form
    static Export_Control_Form__c createExportControlForm3(Id expConHSCodeId){
        Export_Control_Form__c expConForm = new Export_Control_Form__c();       
        expConForm.Customer_Trade_Compliance_Contact_Person__c = 'Test123, Test123';
        expConForm.Email_Address__c = 'test@test.com';
        expConForm.OwnerId__c = UserInfo.getUserId();
        expConForm.Phone__c = '3456321';
        expConForm.Product_Description__c = 'Test Description';
        expConForm.Weapon_Product__c = 'No';
        expConForm.Military_App_Product__c = 'No';
        expConForm.ITAR_Product__c = 'No';
        expConForm.US_EAR_Product__c = 'No';
        expConForm.Non_US_EAR_Product__c = 'No';
        expConForm.Harmonized_System__c = expConHSCodeId;
        expConForm.Other_Harmonized_System__c = 'Others';
        expConForm.Status__c = 'Draft';
        expConForm.D1_National_Access_is_Allowed__c = 'No';
        expConForm.US_EAR_Product_Details__c = 'test';
        insert expConForm;
        return expConForm;
    }
    
    
    // Creation of Attachment object in Export Control Form
    static void addAttachments(Id expConFormId){
        List<Attachment> attList = new List<Attachment>();
        Attachment attach = new Attachment();     
        attach.Name='Q4_Test1';
        Blob bodyBlob1=Blob.valueOf('Unit Test1 Body');
        attach.body=bodyBlob1;
        attach.ParentId = expConFormId;
        attList.add(attach);
        
        Attachment attach1 = new Attachment();     
        attach1.Name='Q5_Test2';
        Blob bodyBlob2=Blob.valueOf('Unit Test2 Body');
        attach1.body=bodyBlob2;
        attach1.ParentId = expConFormId;
        attList.add(attach1);
        
        insert attList;      
    }
    
    static Device_Export_Control_Junction__c createJunction(Id devId, Id exConId){
        Device_Export_Control_Junction__c junc = new Device_Export_Control_Junction__c(
            device__c = devId,
            export_control_form__c = exConId
        );
        insert junc;
        return junc;
    }   
    
    static testMethod void submitForApprovalTest1(){
        Device__c dev = [select id from Device__c limit 1];
        Export_Control_HS_Code__c expConHSCode = ExpConFormApprovalControllerTest.createExportControlHSCode();
        Export_Control_Form__c expConForm = ExpConFormApprovalControllerTest.createExportControlForm(expConHSCode.Id);
        Device_Export_Control_Junction__c junc = ExpConFormApprovalControllerTest.createJunction(dev.id, expConForm.id);
        
        Test.startTest();
            //ExpConFormApprovalControllerTest.addAttachments(expConForm.Id);
            ApexPages.currentPage().getParameters().put('id',expConForm.Id);
            ExpConFormApprovalController ecfAppCon = new ExpConFormApprovalController();
            PageReference pgr = ecfAppCon.submitExpConForm();
            system.assert(pgr.getUrl().contains(expConForm.Id));
            
            pgr = ecfAppCon.cancel();
            system.assert(pgr.getUrl().contains(expConForm.Id));    
        Test.stopTest();
    }
    
    static testMethod void submitForApprovalTest2(){
        
        Device__c dev = [select id from Device__c limit 1];
        Export_Control_HS_Code__c expConHSCode = ExpConFormApprovalControllerTest.createExportControlHSCode();
        Export_Control_Form__c expConForm = ExpConFormApprovalControllerTest.createExportControlForm1();
        Device_Export_Control_Junction__c junc = ExpConFormApprovalControllerTest.createJunction(dev.id, expConForm.id);
                
        Test.startTest();        
            ApexPages.currentPage().getParameters().put('id',expConForm.Id);
            ExpConFormApprovalController ecfAppCon = new ExpConFormApprovalController();
            PageReference pgr = ecfAppCon.submitExpConForm();
            system.assertEquals(pgr,null);  
        Test.stopTest();
        
    }
    
    static testMethod void submitForApprovalTest3(){
        Device__c dev = [select id from Device__c limit 1];
        Export_Control_HS_Code__c expConHSCode = ExpConFormApprovalControllerTest.createExportControlHSCode1();
        Export_Control_Form__c expConForm = ExpConFormApprovalControllerTest.createExportControlForm2(expConHSCode.Id);
        Device_Export_Control_Junction__c junc = ExpConFormApprovalControllerTest.createJunction(dev.id, expConForm.id);
        
        Test.startTest();
            ApexPages.currentPage().getParameters().put('id',expConForm.Id);
            ExpConFormApprovalController ecfAppCon = new ExpConFormApprovalController();
            PageReference pgr = ecfAppCon.submitExpConForm();
            system.assertEquals(pgr,null);  
        Test.stopTest();
    }
    
}