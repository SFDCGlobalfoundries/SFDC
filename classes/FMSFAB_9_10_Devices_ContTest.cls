/*
* @ Author :- Ram Prakash Rai
* @ Description :- contains the test logic for FMSFAB_9_10_Devices_Cont Class.
* @ Date :- 06/08/2017
* @ Change History :-  
**/

@isTest
public class FMSFAB_9_10_Devices_ContTest {

    @testSetup
    static void testDataSetup(){

        DataUtilTest.loadEnvironmentVariables();  
    
    }
  
    static void DataCreation(){
                User admin = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(admin){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = admin.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser; 

            Id rt = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
            Map<String,Object> fieldValueAccMap = new Map<String,Object>();
            fieldValueAccMap.put('Name', 'TEST rec');            
            fieldValueAccMap.put('stage__c', 'Unqualified');        
            fieldValueAccMap.put('sub_type__c', 'Direct');
            fieldValueAccMap.put('site_department__c', 'test dept1');          
            fieldValueAccMap.put('transaction_type__c', 'transactional');                          
            fieldValueAccMap.put('region__c', 'APJ');        
            fieldValueAccMap.put('Corporate_Address_1__c', 'Test Address 1');          
            fieldValueAccMap.put('Corporate_City__c', 'Lee');                
            fieldValueAccMap.put('Corporate_Country__c', 'Japan');
            fieldValueAccMap.put('Bill_To_Address_1__c', 'Test Address 1');          
            fieldValueAccMap.put('Bill_To_City__c', 'Test City');            
            fieldValueAccMap.put('Bill_To_Country__c', 'Singapore');        
            fieldValueAccMap.put('recordtypeid', rt); 
            fieldValueAccMap.put('short_name__c', 'TESTrec');
            fieldValueAccMap.put('Customer_Number__c', '10101');
            fieldValueAccMap.put('account_profile__c', 'Fabless - Emerging');
            fieldValueAccMap.put('Process_Tech_Interested__c', 'Mature (> 0.11um)');
            fieldValueAccMap.put('Sales_Territory__c', 'Japan Korea');
            fieldValueAccMap.put('financial_territory__c', 'Japan Korea');
            fieldValueAccMap.put('Organization_Unit__c', 'GF Investment LLC OU');
            fieldValueAccMap.put('bill_to_location__c', 'YES');
            fieldValueAccMap.put('total_employee__c', 100);
            fieldValueAccMap.put('end_customer__c', 'people');
            fieldValueAccMap.put('Revenue_Potential__c', 'High Potential');
            fieldValueAccMap.put('Target_Account__c', 'Yes');
            fieldValueAccMap.put('Preferred_Invoice_Delivery_Option__c', 'Electronic');
            fieldValueAccMap.put('Fab_9_10__c', 'Yes'); 
            fieldValueAccMap.put('SAP_Account_Number__c', '006104');
            fieldValueAccMap.put('Customer_Category__c', 'TFA');
            fieldValueAccMap.put('tech_geo_granted__c', '0.032UM;0.040UM;0.045UM;0.065UM;0.09UM;0.11UM;0.13UM;0.14UM;0.152UM;0.153UM;0.15UM;0.16UM;0.18UM;0.25UM;0.35UM;0.60UM;0.17UM');
            Account acc;

        try{
            acc= AccountDataFactory.createAccount(fieldValueAccMap);
            }catch(Exception e){
            UtilityCls.saveExceptionLog(FMSDeviceSelectionTest.class.getName(), 'save()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
        }
        
        Map<String,Object> fieldValueOppMap = new Map<String,Object>();
        fieldValueOppMap.put('AccountId', acc.id);
        Opportunity opp1;
        
        try {
            opp1 = OpportunityDataFactory.createOpportunity(fieldValueOppMap);
        }catch(Exception e){
            UtilityCls.saveExceptionLog(FMSDeviceSelectionTest.class.getName(), 'save()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
        } 

        Map<String,Object> fieldValuepoppProgramMap1 = new Map<String,Object>();
        fieldValuepoppProgramMap1.put('Account__c',acc.id);
        fieldValuepoppProgramMap1.put('Opportunity__c',opp1.id);
        Opportunity_Program__c oppprogram = new Opportunity_Program__c();    

        try{
            oppprogram = OpportunityProgramDataFactory.createOpportunityProgram(fieldValuepoppProgramMap1);
        }catch(Exception e){
            UtilityCls.saveExceptionLog(FMSDeviceSelectionTest.class.getName(), 'save()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
        }

        Map<String,Object> fieldValueMap1 = new Map<String,Object>();
        fieldValueMap1.put('Account__c', acc.id);
        fieldValueMap1.put('Device_Sourcing__c','Sole Source');
        fieldValueMap1.put('Opportunity_Program__c',oppprogram.Id);
        fieldValueMap1.put('Device_Mask_Set_Title__c','MPW');

        Device__c Dev = new Device__c ();
        try{
            
            Dev = DeviceDataFactory.createDevice(fieldValueMap1);
            
        }catch(Exception e){
            UtilityCls.saveExceptionLog(FMSDeviceSelectionTest.class.getName(), 'save()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
        }    
    }
    
    }
    @isTest
    static void testFMSFAB_9_10_Devices_Cont(){
        Test.startTest();  
        DataCreation();
        Test.stopTest();
        PageReference pageRef = Page.FormManagementMainPage;            
        Test.setCurrentPage(pageRef);

        Account acc = [select id from Account where name =: 'TEST rec'];
        Device__c dev = [select id from device__c where Device_Sourcing__c=: 'Sole Source'];  
        

        Map<String,Object> fieldValueAccMap12 = new Map<String,Object>();
        fieldValueAccMap12.put('Customer_Name__c', acc.id);
        fieldValueAccMap12.put('Form_Name__c', 'test');
        
        Form_Management_System__c  fmsRec= FMSDataFactory.createFMSRecord(fieldValueAccMap12,FMSDataFactory.FormType.MAIN , true);   
        
        Map<String,Object> fieldValueAccMap2 = new Map<String,Object>();
        fieldValueAccMap2.put('Customer_Name__c', acc.id);
        fieldValueAccMap2.put('Form_Name__c', 'test');
        Form_Management_System__c  formObj  = FMSDataFactory.createFMSRecord(fieldValueAccMap2,FMSDataFactory.FormType.MAIN , true);    
        
        FMSFAB_9_10_Devices_Cont fdc = new FMSFAB_9_10_Devices_Cont();
        System.runAs(FMSDataFactory.testUser){
        fdc.formID = formObj.id;
        fdc.sortType = 'DESC';
        fdc.sortCol = 'mpw';
        fdc.sort();
        
        fdc.getDevicesList();
        PageReference pr = fdc.navigateFMSForm();
        system.assert(pr.getUrl().contains('/apex/FMSmainFormViewPage?id='));
         
        }

         
        
    }


    @isTest
    static void testFMSFAB_9_10_Devices_Cont2(){
    
    Test.startTest();
    DataCreation();
    Test.stopTest();
    PageReference pageRef = Page.FormManagementMainPage;            
    Test.setCurrentPage(pageRef);

        
        
        Account acc = [select id from Account where name =: 'TEST rec'];
        Device__c dev = [select id from device__c];  
        
        
        Map<String,Object> fieldValueAccMap12 = new Map<String,Object>();
        fieldValueAccMap12.put('Customer_Name__c', acc.id);
        fieldValueAccMap12.put('Form_Name__c', 'test');
        
        Form_Management_System__c  fmsRec= FMSDataFactory.createFMSRecord(fieldValueAccMap12,FMSDataFactory.FormType.MAIN , true);   
        
        Map<String,Object> fieldValueAccMap2 = new Map<String,Object>();
        fieldValueAccMap2.put('Customer_Name__c', acc.id);
        fieldValueAccMap2.put('Form_Name__c', 'test');
        fieldValueAccMap2.put('Parent_Form_Id__c', fmsRec.id);
        fieldValueAccMap2.put('Main_Form_Id__c', fmsRec.id);
        FMSDataFactory obk = new FMSDataFactory();
        Form_Management_System__c  formObj  = FMSDataFactory.createFMSRecord(fieldValueAccMap2,FMSDataFactory.FormType.DDR, true);
        
        
        
        FMSFAB_9_10_Devices_Cont fdc = new FMSFAB_9_10_Devices_Cont();
        System.runAs(FMSDataFactory.testUser){
        fdc.formID = formObj.id;
        fdc.sortType = 'DESC';
        fdc.sortCol = 'mpw';
        fdc.sort();
        
        fdc.getDevicesList();
        PageReference pr = fdc.navigateFMSForm();
        system.assert(pr.getUrl().contains('/apex/FMSDDRFormViewPage?id='));
        }
        
        
    }


    @isTest
        static void testFMSFAB_9_10_Devices_Contt(){
        
        Test.startTest();
        DataCreation();
        Test.stopTest();
        PageReference pageRef = Page.FormManagementMainPage;            
        Test.setCurrentPage(pageRef);
        
        Account acc = [select id from Account where name =: 'TEST rec'];
        Device__c dev = [select id from device__c where Device_Sourcing__c=: 'Sole Source'];  
       
        
        Map<String,Object> fieldValueAccMap12 = new Map<String,Object>();
        fieldValueAccMap12.put('Customer_Name__c', acc.id);
        fieldValueAccMap12.put('Form_Name__c', 'test');
        
        Form_Management_System__c fmsRec; 
        try { 
            fmsRec= FMSDataFactory.createFMSRecord(fieldValueAccMap12,FMSDataFactory.FormType.MAIN , true);   
        }catch(Exception e){
            UtilityCls.saveExceptionLog(FMSDeviceSelectionTest.class.getName(), 'save()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0); }
             
        Map<String,Object> fieldValueAccMap2 = new Map<String,Object>();
        fieldValueAccMap2.put('Customer_Name__c', acc.id);
        fieldValueAccMap2.put('Form_Name__c', 'test');
        fieldValueAccMap2.put('Main_Form_Id__c', fmsRec.id);
        FMSDataFactory obk = new FMSDataFactory();
        Form_Management_System__c formObj ;
        try { 
            formObj  = FMSDataFactory.createFMSRecord(fieldValueAccMap2,FMSDataFactory.FormType.SP, true);
        }catch(Exception e){
            UtilityCls.saveExceptionLog(FMSDeviceSelectionTest.class.getName(), 'save()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0); 
        }
             
        
        
        FMSFAB_9_10_Devices_Cont fdc = new FMSFAB_9_10_Devices_Cont();
         System.runAs(FMSDataFactory.testUser){
        fdc.formID = formObj.id;
        fdc.sortType = 'DESC';
        fdc.sortCol = 'mpw';
        fdc.sort();
        
        fdc.getDevicesList();
        PageReference pr = fdc.navigateFMSForm();
        system.assert(pr.getUrl().contains('/apex/FMSSPFormViewExtension?id=')); 
        }
        
    }
    
    @isTest
    static void testFMSFAB_9_10_Devices_Cont3(){
        
        Test.startTest();
        DataCreation();
        Test.stopTest();
        PageReference pageRef = Page.FormManagementMainPage;            
        Test.setCurrentPage(pageRef);
        
         Account acc = [select id from Account where name =: 'TEST rec'];
        Device__c dev = [select id,CRMDID__c,Reticle_Type__c,Current_Forecast_Tapeout_Date__c,Name,Customer_Tapeout_Date__c,
        Geometry__c,Process_Family__c,Status__c,Stage__c,Fab__c,MPW_Train_Number__c,Actual_Tapeout_Date_GMT__c,
        MPW_Train_Number__r.name,Pre_PTRF_Validation_Status__c,Device_Mask_Set_Title__c,CreatedDate,Design_Partner__r.name,
        ip_declaration_status__c,BX041_Status__c,Tapeout_Type__c,Opportunity2__c,Opportunity_Program__c,Opportunity2__r.Name,
        Opportunity_Program__r.Name,Account__r.name from device__c where Device_Sourcing__c=: 'Sole Source'];   
            
        
        Map<String,Object> fieldValueAccMap12 = new Map<String,Object>();
        fieldValueAccMap12.put('Customer_Name__c', acc.id);
        fieldValueAccMap12.put('Form_Name__c', 'test');
         Form_Management_System__c  fmsRec;
        
        try{
            fmsRec= FMSDataFactory.createFMSRecord(fieldValueAccMap12,FMSDataFactory.FormType.MAIN , true);
        }catch(Exception e){
             UtilityCls.saveExceptionLog(FMSDeviceSelectionTest.class.getName(), 'save()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0); }
             
        Map<String,Object> fieldValueAccMap2 = new Map<String,Object>();
        fieldValueAccMap2.put('Customer_Name__c', acc.id);
        fieldValueAccMap2.put('Form_Name__c', 'test');
        fieldValueAccMap2.put('Parent_Form_Id__c', fmsRec.id);
        fieldValueAccMap2.put('Main_Form_Id__c', fmsRec.id);
         Form_Management_System__c  formObj ;
        try{
            formObj  = FMSDataFactory.createFMSRecord(fieldValueAccMap2,FMSDataFactory.FormType.IMC, true);
         }catch(Exception e){
             UtilityCls.saveExceptionLog(FMSDeviceSelectionTest.class.getName(), 'save()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0); }
        
        
        FMSFAB_9_10_Devices_Cont fdc = new FMSFAB_9_10_Devices_Cont();
        FMSFAB_9_10_Devices_Cont.DeviceListWrapper fdd = new FMSFAB_9_10_Devices_Cont.DeviceListWrapper(dev);
        System.runAs(FMSDataFactory.testUser){
        fdc.formID = formObj.id;
        fdc.sortType = 'DESC';
        fdc.sortCol = 'mpw';
        fdc.sort();
        
        fdc.getDevicesList();
        PageReference pr = fdc.navigateFMSForm();
        system.assert(pr.getUrl().contains('/apex/FMSIMCFormViewPage?id=')); 
        }
        System.assertEquals(formObj.Form_Name__c ,'test');
        
    }
    
    
    
}