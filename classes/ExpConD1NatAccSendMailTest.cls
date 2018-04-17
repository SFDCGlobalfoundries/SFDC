/*
    Author: Anirban Roy
    Description: This is the test class of ExpConD1NatAccSendMail class.
    History: 
        ARoy      10312013    - Code creation.
        Baijnath    16072014    - Removed Transaction Type
        Baijnath    16072014    - Added Recticle Type as this have madatory validation inroduced by Swift Gen+
        Vijay       16012015    - Updated the Device Stage 'Solutioning' to 'Design In' as Device will be created in 
                                  'Design In' directly and added mandatory fields.
        Ashwini     05152015    - Updated code for refactoring of test class.                          
*/

@isTest
public class ExpConD1NatAccSendMailTest {
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
        expConForm.Status__c = 'Draft';
        expConForm.D1_National_Access_is_Allowed__c = 'No';
        expConForm.ECCN_Technology__c = 'No';
        expConForm.ECCN_Wafer__c = 'No';
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
    static Attachment addAttachmentObj(Attachment att){
        Attachment attach=att;     
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.Description = 'Test Description';
        return attach;
    }
    
    // Creation of PTRF
    static Id createPTRF(Id deviceId) {
        PTRF__c p = new PTRF__c();
        p.Name = 'PTRF1';
        p.Device__c = deviceId;
        p.Device_Id__c = deviceId;
        //p.Transaction_Type__c = 'LIFECYCLE';
        p.Transaction_Date__c = date.today();
        p.Order_Type__c = 'TEST';
        p.Prime_Tapeout__c = true;
        p.Mask_Set_Title__c = 'TESTMPW';
        p.Recticle_Type__c = 'Single Layer Reticle (SLR)';
            
        insert p;
        
        return p.Id;
    }
    
    // Create new Export Control Form 
    static testMethod void d1NatAccessSendMailTest(){
        
        // Load Environment Variables   
       // DataUtilTest.loadEnvironmentVariables();
        
        // Data creation
        User user = ExpConD1NatAccSendMailTest.createUser();
        Account acct = getAccount('MYTEST ACCOUNT1');
        String acctId = acct.id;
        String oppId = ExpConD1NatAccSendMailTest.createOpp(acctId);
        String oppProgId = ExpConD1NatAccSendMailTest.createOppProg(acctId, oppId);
        Opportunity_Program_Team_Member__c oppProgTM = ExpConD1NatAccSendMailTest.createOppProgTmMem(oppProgId, user.Id);
        String MSTId = DeviceUtilTest.createMaskSetTtitle();
        string MSTAccId = DeviceUtilTest.createMSTAccount(acctId,MSTId);  
        Test.startTest();
        Device__c dev = DeviceUtilTest.createCustomerMPWDevice3(acctId,oppId,oppProgId);
        String ptrfId = ExpConD1NatAccSendMailTest.createPTRF(dev.Id);       
        Export_Control_HS_Code__c expConHSCode = ExpConD1NatAccSendMailTest.createExportControlHSCode();
        Export_Control_Form__c expConForm = ExpConD1NatAccSendMailTest.createExportControlForm(expConHSCode.Id);
        Device_Export_Control_Junction__c junc = ExpConD1NatAccSendMailTest.createJunction(dev.id, expConForm.id);
        
               
        DeviceITAR__c myCS1 = new DeviceITAR__c(Name='Yes',ITAR_Classification_Status__c='ITAR/RED Zone Confirmed by GTC');
        insert myCS1;        
        DeviceITAR__c myCS2 = new DeviceITAR__c(Name='No',ITAR_Classification_Status__c='NON-ITAR/NON-RED Zone Confirmed by GTC');
        insert myCS2;  
        
        expConForm.Status__c = 'Approved';
        update expConForm; 
        
        ExpConD1NatAccSendMail expConSendMail = new ExpConD1NatAccSendMail();
        expConSendMail.paramId = expConForm.Id;
        List<ExpConD1NatAccSendMail.DeviceWrapper> devList = expConSendMail.getListDevices();
        system.assert(devList.size()>0);    
        
        Test.stopTest();
    }
    
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
}