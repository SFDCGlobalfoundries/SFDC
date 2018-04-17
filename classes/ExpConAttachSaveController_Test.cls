/*
    Author: Anirban Roy
    Description: This is the test class for the ExpConAttachSaveController class. 
    History:
        ARoy        07022013    - code creation.
        ARoy        10162013    - modified code to remove SeeAllData=true.
        DBiswal     03302015    - Updated code for refactoring of test class.        
*/

@isTest(SeeAllData=false)
public class ExpConAttachSaveController_Test {
    
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        
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
    }
    
    //Creation of User
    static User createUser1(){
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
   /* static Device__c createDevice(Id accId, Id oppId, Id oppProgId){
        Device__c dev = new Device__c();
        dev.Name = 'TESTDEVICE1947';
        dev.Stage__c = 'Solutioning';
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
    
    // Upload of Attachment in Export Control Form
    static Attachment uploadAttachment(Id expConFormId, String quesStrWith, String attachDesc){
        Attachment attach = new Attachment();       
        attach.Name = quesStrWith+'Unit Test Attachment';
        Blob bodyBlob = Blob.valueOf('Unit Test Attachment Body');
        attach.body = bodyBlob;
        attach.ParentId = expConFormId;
        attach.Description = attachDesc;
        insert attach;        
        return attach;
    }
    
    // Upload of Attachment in Export Control Form
    static Attachment createAttachmentObj(String attachDesc){
        Attachment attach=new Attachment();     
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.Description = attachDesc;
        return attach;
    }
    
    // Test Method for new Attachment
    static testMethod void saveAttachTest(){
        
        // Data creation
        //DataUtilTest.loadEnvironmentVariables();
        User user = ExpConAttachSaveController_Test.createUser1();
        String acctId = getAccount('MYTEST ACCOUNT1').id;
        String oppId = ExpConAttachSaveController_Test.createOpp(acctId);
        String oppProgId = ExpConAttachSaveController_Test.createOppProg(acctId, oppId);
        Opportunity_Program_Team_Member__c oppProgTM = ExpConAttachSaveController_Test.createOppProgTmMem(oppProgId, user.Id);
        String MSTId = DeviceUtilTest.createMaskSetTtitle();
        
          Test.startTest();
        string MSTAccId = DeviceUtilTest.createMSTAccount(acctId,MSTId);  
        Device__c dev = DeviceUtilTest.createCustomerMPWDevice3(acctId,oppId,oppProgId);
        Export_Control_HS_Code__c expConHSCode = ExpConAttachSaveController_Test.createExportControlHSCode();
        Export_Control_Form__c expConForm = ExpConAttachSaveController_Test.createExportControlForm(expConHSCode.Id);
        Device_Export_Control_Junction__c junc = ExpConAttachSaveController_Test.createJunction(dev.id, expConForm.id);
        
      
        
        ApexPages.currentPage().getParameters().put('id',expConForm.Id);
        ExpConAttachSaveController exp = new ExpConAttachSaveController();
        PageReference pgref = exp.saveAttachments();
        //system.assert(pgref.getUrl().contains(expConForm.Id));
        
        pgref = exp.cancel();
        system.assert(pgref.getUrl().contains(expConForm.Id)); 
        
        Test.stopTest();
    }
    
    // Test Method for existing Attachment
    static testMethod void saveExstAttachTest(){
        
        // Data creation
        //DataUtilTest.loadEnvironmentVariables();
        User user = ExpConAttachSaveController_Test.createUser1();
        String acctId = getAccount('MYTEST ACCOUNT1').id;
        String oppId = ExpConAttachSaveController_Test.createOpp(acctId);
        String oppProgId = ExpConAttachSaveController_Test.createOppProg(acctId, oppId);
        Opportunity_Program_Team_Member__c oppProgTM = ExpConAttachSaveController_Test.createOppProgTmMem(oppProgId, user.Id);
        String MSTId = DeviceUtilTest.createMaskSetTtitle();
        
        Test.startTest();
        string MSTAccId = DeviceUtilTest.createMSTAccount(acctId,MSTId);  
        
        Device__c dev = DeviceUtilTest.createCustomerMPWDevice3(acctId,oppId,oppProgId);
        Export_Control_HS_Code__c expConHSCode = ExpConAttachSaveController_Test.createExportControlHSCode();
        Export_Control_Form__c expConForm = ExpConAttachSaveController_Test.createExportControlForm(expConHSCode.Id);
        Device_Export_Control_Junction__c junc = ExpConAttachSaveController_Test.createJunction(dev.id, expConForm.id);        
        String ques_4 = EnvironmentVariable.get('QUES_4_STARTSWITH');
        String ques_5 = EnvironmentVariable.get('QUES_5_STARTSWITH');
        String ques4desc = EnvironmentVariable.get('QUESTION_4_DESC');
        String ques5desc = EnvironmentVariable.get('QUESTION_5_DESC');
        
        
        
        
        ApexPages.currentPage().getParameters().put('id',expConForm.Id);
        
        Attachment attachment1 = ExpConAttachSaveController_Test.uploadAttachment(expConForm.Id, ques_4, ques4desc);
        Attachment attachment2 = ExpConAttachSaveController_Test.uploadAttachment(expConForm.Id, ques_5, ques5desc);
        
        ExpConAttachSaveController exp = new ExpConAttachSaveController();
        
        exp.attachment1 = ExpConAttachSaveController_Test.createAttachmentObj(ques4desc);
        exp.attachment2 = ExpConAttachSaveController_Test.createAttachmentObj(ques5desc);
        exp.attachOthers = ExpConAttachSaveController_Test.createAttachmentObj('Other');       
        
        PageReference pgref = exp.saveAttachments();
        //system.assert(pgref.getUrl().contains(expConForm.Id)); 
        
        Test.stopTest();
    }
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
}