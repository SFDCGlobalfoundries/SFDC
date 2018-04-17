/*
  Author: Anirban Roy
  Description: This is the test class for the ExpCntrlFormTrigger trigger.
  History:
    ARoy        07252013    - code creation.
    ARoy        10162013    - modified code to remove SeeAllData=true.
    ARoy        12092013    - modified code for IPDeclaration comments been mandatory on rejection.  
    Vijay       16012015    - Updated the Device Stage 'Solutioning' to 'Design In' as Device will be created in 
                                  'Design In' directly and added mandatory fields.
    DBiswal     03302015    - Updated code for refactoring of test class.                     
*/

@isTest(SeeAllData=false)
public class ExpCntrlFormTrigger_Test {
    
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
    /*
    // Creation of Device
    static Device__c createDevice(Id accId, Id oppId, Id oppProgId){
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
        dev.Confidence_Level_Tapeout__c = '100';
        dev.Enabled_via_previous_MPW_1__c = 'No';
        dev.Fab__c = 'Fab 3';
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
        expConForm.Phone__c = '3456321';
        expConForm.Product_Description__c = 'Test Description';
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
    
    // Creation of Attachment object in Export Control Form
    static Attachment createAttachmentObj(String name,String expId){
        Attachment attach=new Attachment();     
        attach.Name=name;
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.Description = 'Test Description';
        attach.ParentId = expId;
        insert attach;
        return attach;
    }
    
    
    // Create new Export Control Form to test trigger validation
    static testMethod void createExportConFormValidTest(){
        // Data creation
        //DataUtilTest.loadEnvironmentVariables();
        User user = ExpCntrlFormTrigger_Test.createUser1();
        String acctId = getAccount('MYTEST ACCOUNT1').id;
        String oppId = ExpCntrlFormTrigger_Test.createOpp(acctId);
        String oppProgId = ExpCntrlFormTrigger_Test.createOppProg(acctId, oppId);
        Opportunity_Program_Team_Member__c oppProgTM = ExpCntrlFormTrigger_Test.createOppProgTmMem(oppProgId, user.Id);  
        String MSTId = DeviceUtilTest.createMaskSetTtitle();
        string MSTAccId = DeviceUtilTest.createMSTAccount(acctId,MSTId);
        
         Test.startTest();
        Device__c dev = DeviceUtilTest.createCustomerMPWDevice3(acctId,oppId,oppProgId);
        Export_Control_HS_Code__c expConHSCode = ExpCntrlFormTrigger_Test.createExportControlHSCode();
        
       
               
        Export_Control_Form__c expConForm = new Export_Control_Form__c();
        expConForm.Phone__c = '3456321';
        expConForm.Product_Description__c = 'Test Description';
        expConForm.Weapon_Product__c = 'No';
        expConForm.Military_App_Product__c = 'No';
        expConForm.ITAR_Product__c = 'Yes';
        expConForm.US_EAR_Product__c = 'Yes';
        expConForm.Non_US_EAR_Product__c = 'No';
        expConForm.Harmonized_System__c = expConHSCode.Id;
        expConForm.Other_Harmonized_System__c = 'Others';
        expConForm.Status__c = 'On-hold';
        
        insert expConForm;
        
        expConForm.status__c = 'Approved';
        
        try{
            update expConForm;
        }catch(DmlException e){
            system.assertEquals(StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION,e.getDmlType(0));
        }
                       
        
        Test.stopTest();
    }
    
    // Trigger validation error while updation of Export Control Form
    static testMethod void createExportConFormValid1Test(){
        // Data creation
        //DataUtilTest.loadEnvironmentVariables();
        User user = ExpCntrlFormTrigger_Test.createUser1();
        String acctId = getAccount('MYTEST ACCOUNT1').id;
        String oppId = ExpCntrlFormTrigger_Test.createOpp(acctId);
        String oppProgId = ExpCntrlFormTrigger_Test.createOppProg(acctId, oppId);
        Opportunity_Program_Team_Member__c oppProgTM = ExpCntrlFormTrigger_Test.createOppProgTmMem(oppProgId, user.Id);
        String MSTId = DeviceUtilTest.createMaskSetTtitle();
        string MSTAccId = DeviceUtilTest.createMSTAccount(acctId,MSTId);  
         Test.startTest();
        Device__c dev = DeviceUtilTest.createCustomerMPWDevice3(acctId,oppId,oppProgId);
        Export_Control_HS_Code__c expConHSCode = ExpCntrlFormTrigger_Test.createExportControlHSCode();
        Export_Control_Form__c expConForm = ExpCntrlFormTrigger_Test.createExportControlForm(expConHSCode.Id);        
        Device_Export_Control_Junction__c junc = ExpCntrlFormTrigger_Test.createJunction(dev.id, expConForm.id);                
        
       
        
        expConForm.Status__c = 'Approved';
        
        try{
            update expConForm;
        }catch(DmlException e){
            system.assertEquals(StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION,e.getDmlType(0));
        }              
        
        Test.stopTest();
    }
    
       // Trigger validation error while updation of Export Control Form
    static testMethod void createExportConFormValid1Test12(){
        // Data creation
        //DataUtilTest.loadEnvironmentVariables();
        User user = ExpCntrlFormTrigger_Test.createUser1();
        String acctId = getAccount('MYTEST ACCOUNT1').id;
        String oppId = ExpCntrlFormTrigger_Test.createOpp(acctId);
        String oppProgId = ExpCntrlFormTrigger_Test.createOppProg(acctId, oppId);
        Opportunity_Program_Team_Member__c oppProgTM = ExpCntrlFormTrigger_Test.createOppProgTmMem(oppProgId, user.Id);
        String MSTId = DeviceUtilTest.createMaskSetTtitle();
        string MSTAccId = DeviceUtilTest.createMSTAccount(acctId,MSTId);  
         Test.startTest();
        Device__c dev = DeviceUtilTest.createCustomerMPWDevice3(acctId,oppId,oppProgId);
        Export_Control_HS_Code__c expConHSCode = ExpCntrlFormTrigger_Test.createExportControlHSCode();
        Export_Control_Form__c expConForm = ExpCntrlFormTrigger_Test.createExportControlForm(expConHSCode.Id);        
        Device_Export_Control_Junction__c junc = ExpCntrlFormTrigger_Test.createJunction(dev.id, expConForm.id);                
        
       
        
        expConForm.Status__c = 'Approved';
        expConForm.D1_National_Access_is_Allowed__c = 'Yes';  
        
        try{
            update expConForm;
        }catch(DmlException e){
            system.assertEquals(StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION,e.getDmlType(0));
        }              
        
        Test.stopTest();
    }
    
         // Trigger validation error while updation of Export Control Form
    static testMethod void createExportConFormValid1Test22(){
        // Data creation
        //DataUtilTest.loadEnvironmentVariables();
        User user = ExpCntrlFormTrigger_Test.createUser1();
        String acctId = getAccount('MYTEST ACCOUNT1').id;
        String oppId = ExpCntrlFormTrigger_Test.createOpp(acctId);
        String oppProgId = ExpCntrlFormTrigger_Test.createOppProg(acctId, oppId);
        Opportunity_Program_Team_Member__c oppProgTM = ExpCntrlFormTrigger_Test.createOppProgTmMem(oppProgId, user.Id);
        String MSTId = DeviceUtilTest.createMaskSetTtitle();
        string MSTAccId = DeviceUtilTest.createMSTAccount(acctId,MSTId);  
         Test.startTest();
        Device__c dev = DeviceUtilTest.createCustomerMPWDevice3(acctId,oppId,oppProgId);
        Export_Control_HS_Code__c expConHSCode = ExpCntrlFormTrigger_Test.createExportControlHSCode();
        Export_Control_Form__c expConForm = ExpCntrlFormTrigger_Test.createExportControlForm(expConHSCode.Id);        
        Device_Export_Control_Junction__c junc = ExpCntrlFormTrigger_Test.createJunction(dev.id, expConForm.id);                
        
       
        
        expConForm.Status__c = 'Approved';
        expConForm.D1_National_Access_is_Allowed__c = 'Yes';  
        expConForm.ECCN_Technology__c= 'Yes';  
        
        try{
            update expConForm;
        }catch(DmlException e){
            system.assertEquals(StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION,e.getDmlType(0));
        }              
        
        Test.stopTest();
    }
    
    
    static testMethod void updateDevFrmECFormTest(){
        // Data creation
        //DataUtilTest.loadEnvironmentVariables();
        User user = ExpCntrlFormTrigger_Test.createUser1();
        String acctId = getAccount('MYTEST ACCOUNT1').id;
        String oppId = ExpCntrlFormTrigger_Test.createOpp(acctId);
        String oppProgId = ExpCntrlFormTrigger_Test.createOppProg(acctId, oppId);
        Opportunity_Program_Team_Member__c oppProgTM = ExpCntrlFormTrigger_Test.createOppProgTmMem(oppProgId, user.Id);  
        String MSTId = DeviceUtilTest.createMaskSetTtitle();
        string MSTAccId = DeviceUtilTest.createMSTAccount(acctId,MSTId);
        Test.startTest();
        Device__c dev = DeviceUtilTest.createCustomerMPWDevice3(acctId,oppId,oppProgId);
        Export_Control_HS_Code__c expConHSCode = ExpCntrlFormTrigger_Test.createExportControlHSCode();
        Export_Control_Form__c expConForm = ExpCntrlFormTrigger_Test.createExportControlForm(expConHSCode.Id);        
        Device_Export_Control_Junction__c junc = ExpCntrlFormTrigger_Test.createJunction(dev.id, expConForm.id);                
        
        
        
        expConForm.Status__c = 'Draft';
        expConForm.Submitted_Date__c = Date.today()+1;
        expConForm.D1_National_Access_is_Allowed__c = 'Yes';       
        update expConForm;
        
        expConForm.D1_National_Access_is_Allowed__c = 'No';
        update expConForm;
		system.assertEquals('No',expConForm.D1_National_Access_is_Allowed__c);
        
        Test.stopTest();
    }
    
    static testMethod void commentsMandatoryOnRejectionTest(){
        // Data creation
        //DataUtilTest.loadEnvironmentVariables();
        User user = ExpCntrlFormTrigger_Test.createUser1();
        String acctId = getAccount('MYTEST ACCOUNT1').id;
        String oppId = ExpCntrlFormTrigger_Test.createOpp(acctId);
        String oppProgId = ExpCntrlFormTrigger_Test.createOppProg(acctId, oppId);
        Opportunity_Program_Team_Member__c oppProgTM = ExpCntrlFormTrigger_Test.createOppProgTmMem(oppProgId, user.Id);  
        String MSTId = DeviceUtilTest.createMaskSetTtitle();
        string MSTAccId = DeviceUtilTest.createMSTAccount(acctId,MSTId);
        Test.startTest();
        Device__c dev = DeviceUtilTest.createCustomerMPWDevice3(acctId,oppId,oppProgId);
        Export_Control_HS_Code__c expConHSCode = ExpCntrlFormTrigger_Test.createExportControlHSCode();
        Export_Control_Form__c expConForm = ExpCntrlFormTrigger_Test.createExportControlForm(expConHSCode.Id);        
        Device_Export_Control_Junction__c junc = ExpCntrlFormTrigger_Test.createJunction(dev.id, expConForm.id);                
        
        
        
        // Create an approval request for the account
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setObjectId(expConForm.id);
        
        // Submit the approval request for the account
        Approval.ProcessResult result = Approval.process(req1);
        
        // Verify the result
        System.assert(result.isSuccess());   
        
        List<Id> newWorkItemIds = result.getNewWorkitemIds();     
        
        // Instantiate the new ProcessWorkitemRequest object and populate it
        Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();
        req2.setAction('Reject');
        
        // Use the ID from the newly created item to specify the item to be worked
        req2.setWorkitemId(newWorkItemIds.get(0));
        
        // Submit the request for approval
        try{
            Approval.ProcessResult result2 =  Approval.process(req2);
        }catch(DmlException e){
            system.assertEquals(StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION,e.getDmlType(0));
        }
       
        Test.stopTest();
    }
    
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
}