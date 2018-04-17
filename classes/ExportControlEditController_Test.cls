/*
  Author: Anirban Roy
  Description: This is the test class for the ExportControlEditController class.
  History:
    ARoy        07252013    - code creation.   
    Nbustillos  10122013    - Added call to loadEnvironmentVariables() method.
                            - Updated annotation to SeeAllData=false
    ARoy        11112013    - Modified as per changes for Task - 463
    ARoy        11272013    - modified for change in verbiage for GTC and non-GTC users.  
    Vijay       16012015    - Updated the Device Stage 'Solutioning' to 'Design In' as Device will be created in 
                                  'Design In' directly and added mandatory fields.  
    DBiswal     03302015    - Updated code for refactoring of test class. 
    Devendra     08/Aug/2017    - Updated code for refactoring of test class.   
*/
@isTest(SeeAllData=false)
public class ExportControlEditController_Test {
    
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        
        List<Map<String,Object>> fieldValueMapList = new List<Map<String,Object>>();
        for(integer i=1;i<=2;i++){
            Map<String,Object> fieldValueMap = new Map<String,Object>();
            fieldValueMap.put('Name', 'MYTEST ACCOUNT'+i);            
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
            
            fieldValueMapList.add(fieldValueMap);
        }
        AccountDataFactory.createAccounts(fieldValueMapList,2);
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
    
    static Id createMaskSetTitle(){
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name','MSTTRT1');
        fieldValueMap.put('Reticle_Type__c','Multi Layer Reticle (MLR)');
        return MaskSetTitleDataFactory.createMaskSetTitle(fieldValueMap).Id;
     }
    public static Device__c createCMPWDevice(Id acctId,Id opptyProgramId) {
        String MSTId = CreateMaskSetTitle();
        string MSTAccId = DeviceUtilTest.createMSTAccount(acctId,MSTId);
        // Create Device
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Account__c',acctId);
        fieldValueMap.put('Name','TESTDEVICE1947');
        fieldValueMap.put('Opportunity_Program__c',opptyProgramId);
        fieldValueMap.put('Fab__c','FAB 3');
        fieldValueMap.put('GSOP_Assignment_Tapeout_Plan__c','No');
        fieldValueMap.put('Market_Segment__c','Automotive');
        fieldValueMap.put('Semiconductor_Device__c','Analog Amplifier');
        fieldValueMap.put('End_Customer__c','Test Customer');
        fieldValueMap.put('Device_Sourcing__c','3rd Source');
        fieldValueMap.put('Stage__c','Design In');
        fieldValueMap.put('Status__c','Active');
        fieldValueMap.put('Siebel_Device_ID__c','0987654321');
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
    static Export_Control_Form__c createExportControlForm1(Id expConHSCodeId){
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
        expConForm.Status__c = 'Undeclared';
        expConForm.D1_National_Access_is_Allowed__c = 'No';
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
    
    // Creation of Attachment object in Export Control Form
    static Attachment addAttachmentObj(Attachment att){
        Attachment attach=att;     
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.Description = 'Test Description';
        return attach;
    }        
    
    // Create new Export Control Form 
    static testMethod void createExportConFormTest(){
        
        // Load Environment Variables   
        //DataUtilTest.loadEnvironmentVariables();
        
        // Data creation
        User user = ExportControlEditController_Test.createUser1();
        String acctId = getAccount('MYTEST ACCOUNT2').id;
        String oppId = ExportControlEditController_Test.createOpp(acctId);
        String oppProgId = ExportControlEditController_Test.createOppProg(acctId, oppId);
        Opportunity_Program_Team_Member__c oppProgTM = ExportControlEditController_Test.createOppProgTmMem(oppProgId, user.Id);  
        
        
        Test.startTest();
        Device__c dev = createCMPWDevice(acctId, oppProgId);    
        Export_Control_HS_Code__c expConHSCode = ExportControlEditController_Test.createExportControlHSCode();
        Export_Control_Form__c expConForm = ExportControlEditController_Test.createExportControlForm1(expConHSCode.Id);
        Device_Export_Control_Junction__c junc = ExportControlEditController_Test.createJunction(dev.id, expConForm.id);
        
        
        PageReference VFPage = Page.ExportControlEdit;
        Test.setCurrentPageReference(VFPage);
        system.assertNotEquals(expConForm.Id,null);
        ApexPages.currentPage().getParameters().put('deviceid',dev.Id);
        ApexPages.StandardController controller = new ApexPages.StandardController(expConForm);
        ExportControlEditController expConEdit = new ExportControlEditController(controller);
        expConEdit.init(); 
        
        expConEdit.ExportControl.ITAR_Product__c = 'Yes';
        expConEdit.ExportControl.US_EAR_Product__c = 'Yes';        
        
        // Save the Export Control Form
        PageReference pgr = expConEdit.saveRecord();
        //system.assert(pgr.getUrl().contains(dev.Id));
        
        // Save the Export Control Form and Reassign
        pgr = expConEdit.saveWithReassign();
        //system.assert(pgr.getUrl().contains(dev.Id));                 
        
        Test.stopTest();
    }
    
    // Save Export Control Form 
    static testMethod void updateExportConFormTest(){
        
        // Load Environment Variables   
        //DataUtilTest.loadEnvironmentVariables();
        
        // Data creation
        User user = ExportControlEditController_Test.createUser1();
        String acctId = getAccount('MYTEST ACCOUNT2').id;
        String oppId = ExportControlEditController_Test.createOpp(acctId);
        String oppProgId = ExportControlEditController_Test.createOppProg(acctId, oppId);
        Opportunity_Program_Team_Member__c oppProgTM = ExportControlEditController_Test.createOppProgTmMem(oppProgId, user.Id);  
        
        Test.startTest();
        Device__c dev = createCMPWDevice(acctId, oppProgId);
            
        Export_Control_HS_Code__c expConHSCode = ExportControlEditController_Test.createExportControlHSCode();
        Export_Control_Form__c expConForm = ExportControlEditController_Test.createExportControlForm1(expConHSCode.Id);
        Device_Export_Control_Junction__c junc = ExportControlEditController_Test.createJunction(dev.id, expConForm.id);
        
        
        system.assertNotEquals(expConForm.Id,null);
        ApexPages.currentPage().getParameters().put('deviceid',dev.Id);
        ApexPages.currentPage().getParameters().put('type','list');
        ApexPages.currentPage().getParameters().put('str','ExportControlEditNEW');
        ApexPages.StandardController controller = new ApexPages.StandardController(expConForm);
        ExportControlEditController expConEdit = new ExportControlEditController(controller);
        //expConEdit.init();                 
        
        // Save the Export Control Form
        PageReference pgr = expConEdit.saveRecord();
        //system.assert(pgr!=null);
        
        //Cancel operation
        pgr = expConEdit.cancel();
        system.assert(pgr.getUrl().contains('MyDevices'));
        
        // Save the Export Control Form and Reassign
        pgr = expConEdit.saveWithReassign();
        //system.assert(pgr.getUrl().contains(dev.Id));                 
        
        Test.stopTest();
    }
    
    // Submit Approval Export Control Form 
    static testMethod void submitApprovalExportConFormTest(){
        
        // Load Environment Variables   
        //DataUtilTest.loadEnvironmentVariables();
        
        // Data creation
        User user = ExportControlEditController_Test.createUser1();
        String acctId = getAccount('MYTEST ACCOUNT1').id;
        String oppId = ExportControlEditController_Test.createOpp(acctId);
        String oppProgId = ExportControlEditController_Test.createOppProg(acctId, oppId);
        Opportunity_Program_Team_Member__c oppProgTM = ExportControlEditController_Test.createOppProgTmMem(oppProgId, user.Id);  
        
        Test.startTest();
        Device__c dev = createCMPWDevice(acctId, oppProgId);    
        Export_Control_HS_Code__c expConHSCode = ExportControlEditController_Test.createExportControlHSCode();
        Export_Control_Form__c expConForm = ExportControlEditController_Test.createExportControlForm(expConHSCode.Id);
        Device_Export_Control_Junction__c junc = ExportControlEditController_Test.createJunction(dev.id, expConForm.id);
        PageReference VFPage = Page.ExportControlEdit;
        Test.setCurrentPageReference(VFPage);
        
        ApexPages.currentPage().getParameters().put('deviceid',dev.Id);
        ApexPages.StandardController controller = new ApexPages.StandardController(expConForm);
        ExportControlEditController expConEdit = new ExportControlEditController(controller);
        expConEdit.init(); 
              
        expConEdit.ExportControl.ITAR_Product__c = 'No';
        expConEdit.ExportControl.US_EAR_Product__c = 'No';        
        
        // Submit For Approval 
        PageReference pgr = expConEdit.submitForApproval();
        //system.assert(pgr!=null);
        
        //Cancel operation
        pgr = expConEdit.cancel();
        system.assert(pgr.getUrl().contains(dev.Id));                         
        
        Test.stopTest();
    }
    
    // ReadOnly Export Control Form 
    static testMethod void exportConFormReadOnlyTest(){
        
        // Load Environment Variables   
        //DataUtilTest.loadEnvironmentVariables();
        
        // Data creation
        User user = ExportControlEditController_Test.createUser1();
        String acctId = getAccount('MYTEST ACCOUNT1').id;
        String oppId = ExportControlEditController_Test.createOpp(acctId);
        String oppProgId = ExportControlEditController_Test.createOppProg(acctId, oppId);
        Opportunity_Program_Team_Member__c oppProgTM = ExportControlEditController_Test.createOppProgTmMem(oppProgId, user.Id); 
        
        Test.startTest();
        Device__c dev = createCMPWDevice(acctId, oppProgId);        
        Export_Control_HS_Code__c expConHSCode = ExportControlEditController_Test.createExportControlHSCode();
        Export_Control_Form__c expConForm = ExportControlEditController_Test.createExportControlForm(expConHSCode.Id);
        Device_Export_Control_Junction__c junc = ExportControlEditController_Test.createJunction(dev.id, expConForm.id);
        PageReference VFPage = Page.ExportControlEdit;
        Test.setCurrentPageReference(VFPage);
        
        ApexPages.currentPage().getParameters().put('deviceid',dev.Id);

        ApexPages.StandardController controller = new ApexPages.StandardController(expConForm);
        ExportControlEditController expConEdit = new ExportControlEditController(controller);
        expConEdit.init(); 
        
        expConEdit.ExportControl.ITAR_Product__c = 'No';
        expConEdit.ExportControl.US_EAR_Product__c = 'No';        
        
        // Submit For Approval 
        PageReference pgr = expConEdit.submitForApproval();
        system.assert(pgr!=null);
        
        expConForm = [SELECT    Id,
                                Status__c,
                                EC_Status__c,
                                OwnerId__c,
                                Last_Assigned_Customer_User__c,
                                Customer_Trade_Compliance_Contact_Person__c,
                                Phone__c,
                                Email_Address__c,
                                Product_Description__c,
                                Weapon_Product__c,
                                Military_App_Product__c,
                                Military_App_Product_Details__c,
                                Submitted_Date__c,
                                ITAR_Product__c,
                                ITAR_Product_Details__c,
                                US_EAR_Product__c,
                                US_EAR_Product_Details__c,
                                Non_US_EAR_Product__c,
                                Non_US_EAR_Product_Details__c,
                                Harmonized_System__c,
                                Harmonized_System__r.Name,
                                Harmonized_System__r.HS_Code__c, 
                                Harmonized_System__r.HS_Description__c,
                                (select CreatedBy.FirstName, CreatedBy.LastName, CreatedBy.Alias, CreatedBy.UserRoleId from ProcessSteps where StepStatus = 'Started' order by CreatedDate desc limit 1),
                                Other_Harmonized_System__c 
                     FROM       Export_Control_Form__c 
                     WHERE      Id = :expConForm.Id limit 1];
        
        ApexPages.currentPage().getParameters().put('deviceid',dev.Id);
        controller = new ApexPages.StandardController(expConForm);       
        expConEdit = new ExportControlEditController(controller);             
        expConEdit.toggleOnhold();
        expConEdit.reOpenRec();
        expconedit.editRecord();
        expconedit.unlockRecord();
        Test.stopTest();
    }
    
    static testMethod void exportConFormReadOnlyTest1(){
        
        // Load Environment Variables   
        //DataUtilTest.loadEnvironmentVariables();
        
        // Data creation
        User user = ExportControlEditController_Test.createUser1();
        System.runAs(user)
        {
            String acctId = getAccount('MYTEST ACCOUNT1').id;
            String oppId = ExportControlEditController_Test.createOpp(acctId);
            String oppProgId = ExportControlEditController_Test.createOppProg(acctId, oppId);
            Opportunity_Program_Team_Member__c oppProgTM = ExportControlEditController_Test.createOppProgTmMem(oppProgId, user.Id); 
            
            Test.startTest();
            Environment_Variable__c envVar1 = new Environment_Variable__c(Name='EXP_CON_GTC_EMAILADDRESS', Value__c = 'poulami.saha@globalfoundries.com');
            insert envVar1;
            psa_psc_eccn_default__c psapsaDef = new psa_psc_eccn_default__c(Name='3E292',D1_National_Access_Allowed__c='No',psa_eccn__c='0',psc_eccn__c='A',ECCN_Color__c='GREEN');
            insert psapsaDef;
            Device__c dev = createCMPWDevice(acctId, oppProgId);        
            Export_Control_HS_Code__c expConHSCode = ExportControlEditController_Test.createExportControlHSCode();
            Export_Control_Form__c expConForm = ExportControlEditController_Test.createExportControlForm(expConHSCode.Id);
            Device_Export_Control_Junction__c junc = ExportControlEditController_Test.createJunction(dev.id, expConForm.id);
            expConForm.ECCN_Technology__c = '3E292'; 
            expConForm.ECCN_Wafer__c = '3E292';
            Update expConForm;
            PageReference VFPage = Page.ExportControlEdit;
            Test.setCurrentPageReference(VFPage);
            
            ApexPages.currentPage().getParameters().put('deviceid',dev.Id);

            ApexPages.StandardController controller = new ApexPages.StandardController(expConForm);
            ExportControlEditController expConEdit = new ExportControlEditController(controller);
            expConEdit.init(); 
            
            expConEdit.ExportControl.ITAR_Product__c = 'No';
            expConEdit.ExportControl.US_EAR_Product__c = 'No';        
            
            // Submit For Approval 
            PageReference pgr = expConEdit.submitForApproval();
            system.assert(pgr!=null);
            
            expConForm = [SELECT    Id,
                                    Status__c,
                                    EC_Status__c,
                                    OwnerId__c,
                                    Last_Assigned_Customer_User__c,
                                    Customer_Trade_Compliance_Contact_Person__c,
                                    Phone__c,
                                    Email_Address__c,
                                    Product_Description__c,
                                    Weapon_Product__c,
                                    Military_App_Product__c,
                                    Military_App_Product_Details__c,
                                    Submitted_Date__c,
                                    ITAR_Product__c,
                                    ITAR_Product_Details__c,
                                    US_EAR_Product__c,
                                    US_EAR_Product_Details__c,
                                    Non_US_EAR_Product__c,
                                    Non_US_EAR_Product_Details__c,
                                    Harmonized_System__c,
                                    Harmonized_System__r.Name,
                                    Harmonized_System__r.HS_Code__c, 
                                    Harmonized_System__r.HS_Description__c,
                                    (select CreatedBy.FirstName, CreatedBy.LastName, CreatedBy.Alias, CreatedBy.UserRoleId from ProcessSteps where StepStatus = 'Started' order by CreatedDate desc limit 1),
                                    Other_Harmonized_System__c 
                         FROM       Export_Control_Form__c 
                         WHERE      Id = :expConForm.Id limit 1];
            
            ApexPages.currentPage().getParameters().put('deviceid',dev.Id);
            controller = new ApexPages.StandardController(expConForm);       
            expConEdit = new ExportControlEditController(controller);     
            expConEdit.psaValue = '0';
            expConEdit.pscValue = 'P';
            expConEdit.saveValue();
            expConEdit.sendemailtoGTCmember();
            expConEdit.showPopup1();
            expConEdit.closePopup();
            Test.stopTest();
        }
    }
    
    static testMethod void exportConFormReadOnlyTest2(){
        
        // Load Environment Variables   
        //DataUtilTest.loadEnvironmentVariables();
        
        // Data creation
        User user = ExportControlEditController_Test.createUser1();
        System.runAs(user)
        {
            String acctId = getAccount('MYTEST ACCOUNT1').id;
            String oppId = ExportControlEditController_Test.createOpp(acctId);
            String oppProgId = ExportControlEditController_Test.createOppProg(acctId, oppId);
            Opportunity_Program_Team_Member__c oppProgTM = ExportControlEditController_Test.createOppProgTmMem(oppProgId, user.Id); 
            
            Test.startTest();
            psa_psc_eccn_default__c psapsaDef = new psa_psc_eccn_default__c(Name='3E292',D1_National_Access_Allowed__c='No',psa_eccn__c='0',psc_eccn__c='A',ECCN_Color__c='GREEN');
            insert psapsaDef;
			system.AssertEquals('3E292', psapsaDef.Name);
            Device__c dev = createCMPWDevice(acctId, oppProgId);        
            Export_Control_HS_Code__c expConHSCode = ExportControlEditController_Test.createExportControlHSCode();
            Export_Control_Form__c expConForm = ExportControlEditController_Test.createExportControlForm(expConHSCode.Id);
            Device_Export_Control_Junction__c junc = ExportControlEditController_Test.createJunction(dev.id, expConForm.id);

            PageReference VFPage = Page.ExportControlEdit;
            Test.setCurrentPageReference(VFPage);
            
            ApexPages.currentPage().getParameters().put('deviceid',dev.Id);

            ApexPages.StandardController controller = new ApexPages.StandardController(expConForm);
            ExportControlEditController expConEdit = new ExportControlEditController(controller);
            expConEdit.init(); 

			expConEdit.ExportControl.ECCN_Technology__c = 'xxxx';
			expConEdit.ExportControl.D1_National_Access_is_Allowed__c = 'Yes';
			expConEdit.psaValue = '0';
            expConEdit.pscValue = 'P';
			PageReference pgr = expConEdit.saveRecord();
			//system.assert(pgr!=null);
            expConEdit.showPopup1();
            expConEdit.saveValue();
            expConEdit.closePopup();

            Test.stopTest();
        }
    }
    
   
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
}