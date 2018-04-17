/*
  Author: Anirban Roy
  Description: This is the test class for ExportControlWeeklyReminderBatch class.
  History:
    ARoy        10162013    - code creation.
    DBiswal     04162015    - Updated code for making SeeAllData=false and refactoring of test class.                 
*/

@isTest(seeAllData = false)
public class ExportControlWeeklyReminderBatchTest {
    
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
        
    // Creation of a Contact
    static Id createContact(Id acctId){
        Contact con = new Contact(
            firstName = 'Test',
            lastName = 'Contact',
            email = 'test@test.com',
            accountId = acctId,
            is_portal_user_active__c = true,
            is_portal_user_created__c = true,
            role__c = 'Customers My Device Admin',
            Department__c = 'Design'
        );
        insert con;
        return con.Id;
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
                                        Opportunity_Program__c=oppProgId,Team_Role__c='Primary Field Application Engineer',
                                        User__c=userId,Flag_for_Delete__c=false);
        insert oppProgTM;
        return oppProgTM;
    }
    
    static Device__c createDevice(Id accId, Id oppId, Id oppProgId, Id ptId){
        Device__c dev = new Device__c();
        dev.Name = 'TESTDEVICE11947';
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
        dev.Fab__c = 'FAB 2';
        dev.IP_Gap__c = false;
        dev.Process_Technology_2__c = ptId;
        dev.Siebel_Device_ID__c = '0987654321';
        dev.Actual_Tapeout_Date__c = date.newInstance(2013,5,20);
        dev.Current_Forecast_Tapeout_Date__c = date.today().addDays(-2);
        dev.Original_Forecasted_Tapeout_Date__c = date.newInstance(2013,5,20);
        dev.Reticle_Type__c= 'Single Layer Reticle (SLR)';
        //dev.Current_Forecast_Tapeout_Date__c = date.newInstance(2013,3,4);
        insert dev;
        return dev; 
    }
    
    static Device__c createDevice1(Id accId, Id oppId, Id oppProgId, Id ptId){
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name','TESTDEVICE12947'); 
        fieldValueMap.put('Stage__c','Solutioning');
        fieldValueMap.put('Status__c','Active');
        fieldValueMap.put('Account__c',accId);
        fieldValueMap.put('Opportunity2__c',oppId);
        fieldValueMap.put('Opportunity_Program__c',oppProgId);
        fieldValueMap.put('Market_Segment__c','Automotive');
        fieldValueMap.put('Semiconductor_Device__c','Analog Regulator');
        fieldValueMap.put('End_Application__c','Body');
        fieldValueMap.put('Device_Sourcing__c','3rd Source');
        fieldValueMap.put('Tapeout_Type__c','Customer MPW');
        fieldValueMap.put('Siebel_Device_ID__c','0987654321');
        fieldValueMap.put('Fab__c','FAB 2');
        fieldValueMap.put('IP_Gap__c',false);
        fieldValueMap.put('Process_Technology_2__c',ptId);
        fieldValueMap.put('Siebel_Device_ID__c','0987654321');
        fieldValueMap.put('Actual_Tapeout_Date__c',date.newInstance(2013,5,20));
        fieldValueMap.put('Current_Forecast_Tapeout_Date__c',date.today().addDays(2));
        fieldValueMap.put('Original_Forecasted_Tapeout_Date__c',date.newInstance(2013,5,20));
        fieldValueMap.put('Reticle_Type__c','Single Layer Reticle (SLR)');
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
    
    static Process_Technology__c createPT(){
        Process_Technology__c pt = new Process_Technology__c();
        pt.Name = 'TestPT';
        pt.IP_Geometry_Technology__c = '28G;28LPE'; 
        insert pt;
        return pt;   
    }
    
   /* static testMethod void expConWeeklyReminderBatchTest1() {
               
        User user = [Select id from user where profile.name = 'GF FAE/FTS' and isactive = true limit 1];
        User admin = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        
        String acctId = getAccount('MYTEST ACCOUNT1').id;
        String conId = ExportControlWeeklyReminderBatchTest.createContact(acctId);
        
        
        String oppId = ExportControlWeeklyReminderBatchTest.createOpp(acctId);
        String oppProgId = ExportControlWeeklyReminderBatchTest.createOppProg(acctId, oppId);
        Opportunity_Program_Team_Member__c oppProgTM = ExportControlWeeklyReminderBatchTest.createOppProgTmMem(oppProgId, user.Id); 
        
        System.debug('Total Number of SOQL Queries allowed in this apex code context2: ' +  Limits.getQueries());
        Process_Technology__c pt = ExportControlWeeklyReminderBatchTest.createPT(); 
Test.startTest();
        Device__c dev = ExportControlWeeklyReminderBatchTest.createDevice(acctId,oppId,oppProgId,pt.Id);
        
        System.debug('Total Number of SOQL Queries allowed in this apex code context3: ' +  Limits.getQueries());
        
       
        System.debug('Total Number of SOQL Queries allowed in this apex code context4: ' +  Limits.getQueries());
        
        Export_Control_HS_Code__c expConHSCode = ExportControlWeeklyReminderBatchTest.createExportControlHSCode();
        
        Export_Control_Form__c ecf = ExportControlWeeklyReminderBatchTest.createExportControlForm(expConHSCode.id);
        ExportControlWeeklyReminderBatchTest.createJunction(dev.id, ecf.id);
        
        dev.Stage__c = 'Design In';
        dev.Confidence_Level_Tapeout__c = '0';
        dev.Expose_Device_to_Customer__c = true;
        update dev;        
        
         
        System.debug('Total Number of SOQL Queries allowed in this apex code context5: ' +  Limits.getQueries());
        List<Device_Export_Control_Junction__c> junc = [select    export_control_form__c 
                                                  from      Device_Export_Control_Junction__c
                                                  where     device__c = :dev.Id]; 
                                                  
        Export_Control_Form__c expConForm = [select     Phone__c, 
                                                        Product_Description__c,
                                                        Weapon_Product__c,
                                                        Military_App_Product__c,
                                                        ITAR_Product__c,
                                                        US_EAR_Product__c,
                                                        Non_US_EAR_Product__c,
                                                        Harmonized_System__c,
                                                        Other_Harmonized_System__c,
                                                        Submitted_Date__c,
                                                        Status__c
                                             from       Export_Control_Form__c
                                             where      id = :junc[0].Export_Control_Form__c];
                                             
        expConForm.OwnerId__c = UserInfo.getUserId();
        expConForm.Phone__c = '3456321';
        expConForm.Product_Description__c = 'Test Description';
        expConForm.Weapon_Product__c = 'No';
        expConForm.Military_App_Product__c = 'No';
        expConForm.ITAR_Product__c = 'No';
        expConForm.US_EAR_Product__c = 'No';
        expConForm.Non_US_EAR_Product__c = 'No';
        expConForm.Harmonized_System__c = expConHSCode.Id;
        expConform.Status__c = 'Submitted';
        expConForm.Submitted_Date__c = date.today().addDays(-2);
        update expConform;                                                         
        Test.stopTest();
        database.executeBatch(new ExportControlWeeklyReminderBatch()); 
       
      
    }*/
    
    static testMethod void expConWeeklyReminderBatchTest2() {
        
        //DataUtilTest.loadEnvironmentVariables();
        
        // Data creation  
      
        test.startTest();
        String acctId = getAccount('MYTEST ACCOUNT1').id;
        String conId = ExportControlWeeklyReminderBatchTest.createContact(acctId);
        System.debug('2nd Total Number of SOQL Queries allowed in this apex code context1: ' +  Limits.getQueries());
              
        String oppId = ExportControlWeeklyReminderBatchTest.createOpp(acctId);
        String oppProgId = ExportControlWeeklyReminderBatchTest.createOppProg(acctId, oppId); 
            
        User user =  [Select id from user where profile.name = 'GF FAE/FTS' and isactive = true limit 1];     
        
        Opportunity_Program_Team_Member__c oppProgTM = ExportControlWeeklyReminderBatchTest.createOppProgTmMem(oppProgId, user.Id); 
       Mask_Set_Title__c MSTId = DeviceUtilTest.createMaskSetTtitleObj('MSTTRT');
        string MSTAccId = DeviceUtilTest.createMSTAccount(acctId,MSTId.id);
       
        System.debug('2nd Total Number of SOQL Queries allowed in this apex code context2: ' +  Limits.getQueries());
        /*Device__c dev = DeviceUtilTest.createDevice();
        dev.IP_Gap__c = false;
        dev.Siebel_Device_ID__c = '0987654321';
        dev.Actual_Tapeout_Date__c = date.newInstance(2013,5,20);
        dev.Current_Forecast_Tapeout_Date__c = date.today().addDays(-2);
        Insert dev;*/
         
        System.debug('2nd Total Number of SOQL Queries allowed in this apex code context3: ' +  Limits.getQueries());
        
        
        Process_Technology__c pt = ExportControlWeeklyReminderBatchTest.createPT(); 
         Test.stopTest();
    Device__c dev = ExportControlWeeklyReminderBatchTest.createDevice1(acctId,oppId,oppProgId,pt.Id);
        
        
        
        /*User portalUser = new User(
            contactId = conId,
            firstName = 'Test',
            lastName = 'Contact',
            email = 'test@test.com',
            emailencodingkey='UTF-8',           
            communityNickname = 'Contact_'+math.random(),
            languagelocalekey='en_US',
            localesidkey='en_US',
            alias = 'portUsrT',
            profileId = '00e90000001C376',
            timezonesidkey='America/Los_Angeles', 
            username='testing00@test.com',
            FederationIdentifier='Test2015'
                    
            
        );        

        insert portalUser; 
        
        Portal_Tab_Access__c pta =  new Portal_Tab_Access__c();
        pta.Account__c = acctid;
        pta.User__c = portalUser.id;
        pta.IP_Declaration__c = true;
        pta.Export_Control__c = true;
        pta.My_Devices__c = true;
        insert pta;*/
        
        
        
        Export_Control_HS_Code__c expConHSCode = ExportControlWeeklyReminderBatchTest.createExportControlHSCode();
        Export_Control_Form__c ecf = ExportControlWeeklyReminderBatchTest.createExportControlForm(expConHSCode.id);
        ExportControlWeeklyReminderBatchTest.createJunction(dev.id, ecf.id);
        
        dev.Export_Control_Waiver_Flag__c = 'No';        
        dev.EC_Daily_Reminder__c = true;
        dev.Stage__c = 'Design In';
        dev.Confidence_Level_Tapeout__c = '0';
        dev.Expose_Device_to_Customer__c = true;
        //dev.Export_Control_Status__c = 'Draft';
        update dev;       
       
        System.debug('2nd Total Number of SOQL Queries allowed in this apex code context4: ' +  Limits.getQueries());
        List<Device_Export_Control_Junction__c> junc = [select    export_control_form__c 
                                                  from      Device_Export_Control_Junction__c
                                                  where     device__c = :dev.Id]; 
                                                  
        Export_Control_Form__c expConForm = [select     Phone__c, 
                                                        Product_Description__c,
                                                        Weapon_Product__c,
                                                        Military_App_Product__c,
                                                        ITAR_Product__c,
                                                        US_EAR_Product__c,
                                                        Non_US_EAR_Product__c,
                                                        Harmonized_System__c,
                                                        Other_Harmonized_System__c,
                                                        Submitted_Date__c,
                                                        Status__c
                                             from       Export_Control_Form__c
                                             where      id = :junc[0].Export_Control_Form__c];
                                             
        expConForm.OwnerId__c = UserInfo.getUserId();
        expConForm.Phone__c = '3456321';
        expConForm.Product_Description__c = 'Test Description';
        expConForm.Weapon_Product__c = 'No';
        expConForm.Military_App_Product__c = 'No';
        expConForm.ITAR_Product__c = 'No';
        expConForm.US_EAR_Product__c = 'No';
        expConForm.Non_US_EAR_Product__c = 'No';
        expConForm.Harmonized_System__c = expConHSCode.Id;
        expConform.Status__c = 'Draft';
        expConForm.Submitted_Date__c = date.today().addDays(2);
        update expConform;                                                                
         
        System.debug('2nd Total Number of SOQL Queries allowed in this apex code context5: ' +  Limits.getQueries()); 
        database.executeBatch(new ExportControlWeeklyReminderBatch()); 
        

        
    } 
    
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }   
}