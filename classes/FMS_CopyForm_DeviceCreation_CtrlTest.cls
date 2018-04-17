@isTest
public class FMS_CopyForm_DeviceCreation_CtrlTest {
    
  @testSetup
  static void testDataSetup(){
      DataUtilTest.loadEnvironmentVariables();  
  }
    
    public static Device__c createDevice(Id accId, Id oppId, Id oppProgId, Id processId){
    
        Device__c dev = deviceutiltest.createDevicePM(accId,oppId,oppProgId);
        dev.Confidence_Level_Tapeout__c = '100';
        dev.Expose_Device_to_Customer__c = false ; 
        dev.Fab__c = 'Fab 3';
        dev.Assigned_Process_ID__c = processId;
        dev.Enabled_via_previous_MPW_1__c='No';
        dev.CRMDID__c = '123456';
        insert dev;
        return dev; 
    }
    
    @isTest
    static void testCopyForm_DeviceCreation_Ctrl(){

        PageReference pageRef = Page.FormManagementMainPage;            
        Test.setCurrentPage(pageRef);
        TriggerHandler.bypass('Account_TriggerHandler');

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
        Account acc= AccountDataFactory.createAccount(fieldValueAccMap);

        Contact con = new Contact(FirstName = 'First', LastName = 'Test Last', AccountId = acc.Id, Is_Portal_User_Active__c = true);
        con.Is_Portal_User_Created__c = true;
        insert con;

        String oppId = DeviceChecklistTestDataUtils.createOpp(acc.Id);
        String oppProgId = DeviceChecklistTestDataUtils.createOppProg(acc.Id, oppId);
        Test.startTest();
		TriggerHandler.bypass('FMSTriggerHandler');

        Process__c p = DeviceChecklistTestDataUtils.createProcess();

        Device__c dev = createDevice(acc.Id,oppId,oppProgId,p.Id);

        Form_Management_System__c formObj = new Form_Management_System__c(
        Device__c = dev.Id,
        Customer_Name__c = acc.Id,
        Name__c = 'Test Name',
        Form_Name__c = 'Test Main Form',                 
        Form_Description__c = 'Test Description', 
        Technology__c = 'CSOI 7RF', 
        TestServices__c = 'Yes', 
        Packaging_Services__c = 'No', 
        RecordTypeId = Schema.SObjectType.Form_Management_System__c.getRecordTypeInfosByName().get('Design Data Return (DDR)').getRecordTypeId(),
        Chip_Interconnect__c = 'Wirebond', 
        QuoteOnly__c = 'No',
        ServiceOptions__c = 'Dicing',
        AppName__c = 'Test 1'+','+'Test 2',
        AppEmail__c = 'test@gmail.com',
        DesignSubmission__c = 'Single Chip (one GDS)', 
        InputMethod__c ='Advanced Process: Inputs via XML file attachment.', 
        Phone__c = '9999999999',
        Email__c = 'test@gmail.com',
        FileAttachment__c = 'Test Attachment',
        AdvancedProcessFileAttachment__c = 'Test Attachment',
        StepPlanRotationActive__c = null,
        
        LastMetalUsed__c = 'AM (Analog Metal) (MT, FT, AM) (70P5485)');
        
        insert formObj ;

        FMS_CopyForm_DeviceCreation_Ctrl dcctr = new FMS_CopyForm_DeviceCreation_Ctrl();
        dcctr.formTypeVal = 'IMC';
        dcctr.parentFormId = formObj.id;
        dcctr.selectedDevice = dev.Name;
        dcctr.getAvailableDeviceList();
        dcctr.ContinueNext();
        dcctr.createDevice();
        dcctr.formTypeVal = 'Main';
        dcctr.createDevice();
        Test.stopTest();



    }
}