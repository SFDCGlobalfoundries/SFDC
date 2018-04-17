/*
 * @ Author :- Anil Kumar Reddy L
 * @ Description :- contains the test logic for FMSSPFormViewExtension Class.
 * @ Date :- 04/10/2016
 * @ Change History :-  
 **/
@isTest(SeeAllData = false)
public class FMSChildCreationControllerTest {
    
    @testSetup
    static void testDataSetup(){
        DataUtilTest.loadEnvironmentVariables(); 
		List<SObject> lstFMSMapTab = Test.loadData(FMS_Mapping_Table__c.sObjectType,'TestFMSMappingTableData');
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
        fieldValueAccMap.put('SAP_Account_Number__c', ' 017924');
        fieldValueAccMap.put('Customer_Category__c', 'TFA');
        fieldValueAccMap.put('tech_geo_granted__c', '0.032UM;0.040UM;0.045UM;0.065UM;0.09UM;0.11UM;0.13UM;0.14UM;0.152UM;0.153UM;0.15UM;0.16UM;0.18UM;0.25UM;0.35UM;0.60UM;0.17UM');
        
        Account acc= AccountDataFactory.createAccount(fieldValueAccMap);

        Contact con = new Contact(Department__c = 'Design',FirstName = 'Mr', LastName = 'Test Last', AccountId = acc.Id, Is_Portal_User_Active__c = false, Is_Portal_User_Created__c = false);
        insert con; 
        
        List<FMSValidations__c> fmsValList = new List<FMSValidations__c>();
        
        FMSValidations__c fmsVal = new FMSValidations__c();
        fmsVal.Name = 'DataCheckingOptions__c';
        fmsVal.Type_of_Form__c = 'IMC';
        fmsVal.LabelValue__c = 'Error: Data Checking Options: is a Required field';
        fmsValList.add(fmsVal);
        
        FMSValidations__c fmsVal1 = new FMSValidations__c();
        fmsVal1.Name = 'ProductName__c';
        fmsVal1.Type_of_Form__c = 'IMC;RIT;DDR';
        fmsVal1.LabelValue__c = 'Error: Product Name: is a Required field';
        fmsValList.add(fmsVal1);
        
        FMSValidations__c fmsVal2 = new FMSValidations__c();
        fmsVal2.Name = 'Technology__c';
        fmsVal2.Type_of_Form__c = 'IMC;RIT';
        fmsVal2.LabelValue__c = 'Error: Technology__c: is a Required field';
        fmsValList.add(fmsVal2);

        FMSValidations__c fmsVal3 = new FMSValidations__c();
        fmsVal3.Name = 'ReleaseProcessFlow__c';
        fmsVal3.Type_of_Form__c = 'IMC;RIT';
        fmsVal3.LabelValue__c = 'Error: ReleaseProcessFlow__c: is a Required field';
        fmsValList.add(fmsVal3); 

        FMSValidations__c fmsVal4 = new FMSValidations__c();
        fmsVal4.Name = 'DesignSubmission__c';
        fmsVal4.Type_of_Form__c = 'IMC;RIT';
        fmsVal4.LabelValue__c = 'Error: DesignSubmission__c: is a Required field';
        fmsValList.add(fmsVal4);
        
        insert fmsValList;
    }

    static Account getAccount(String name){
        Account acc = [select id, Name from Account where name = :name];
        return acc;
    }

    static Contact getContact(Id accId){
        Contact con = [select id, Name, AccountId from contact where AccountId = :accId];
        return con;
    }
    
    static Id getContentVer() {
        
        ContentVersion content=new ContentVersion(); 
        content.Title='Header_Picture1'; 
        content.PathOnClient='/' + content.Title + '.jpg'; 
        Blob bodyBlob=Blob.valueOf('Unit Test ContentVersion Body'); 
        content.VersionData=bodyBlob; 
        content.origin = 'H';
        insert content;

        return content.Id;
    }
    
    public static Device__c createDevice(Id accId, Id oppId, Id oppProgId, Id processId){
        Device__c dev = deviceutiltest.createDevicePM(accId,oppId,oppProgId);
        dev.Confidence_Level_Tapeout__c = '100';
        dev.Expose_Device_to_Customer__c = false ; 
        dev.Fab__c = 'Fab 3';
        dev.Assigned_Process_ID__c = processId;
        dev.Enabled_via_previous_MPW_1__c='No';
        dev.Device_Type__c = 'Retrofit';
        dev.CRMDID__c = 'CID0001.00';
        insert dev;
        return dev; 
    }
    
    public static Device__c createDevicePart(Id accId, Id oppId, Id oppProgId, Id processId){
        Device__c dev = deviceutiltest.createDevicePM(accId,oppId,oppProgId);
        dev.Confidence_Level_Tapeout__c = '100';
        dev.Expose_Device_to_Customer__c = false ; 
        dev.Fab__c = 'Fab 3';
        dev.Assigned_Process_ID__c = processId;
        dev.Enabled_via_previous_MPW_1__c='No';
        dev.Design_Partner__c = accId;
        insert dev;
        return dev; 
    }

    static testMethod void testMethod1() {
        
        Account acc = getAccount('TEST rec');
        Contact con = getContact(acc.Id);

        PageReference pageRef = Page.FMSDeviceSelectionPage;            
        Test.setCurrentPage(pageRef);       
        
        User thisUser= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator'); 
        System.runAs(thisUser){
            Test.startTest();

            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;

            String oppId = DeviceChecklistTestDataUtils.createOpp(acc.Id);
            String oppProgId = DeviceChecklistTestDataUtils.createOppProg(acc.Id, oppId);
            Process__c p = DeviceChecklistTestDataUtils.createProcess();

            Device__c dev = createDevicePart(acc.Id,oppId,oppProgId,p.Id);   
            
            Form_Management_System__c formObj = new Form_Management_System__c(
                Customer_Name__c = acc.Id,
                Selected_Contact_Ids__c = con.Id+';'+con.Id,
                Name__c = 'Test Name',
                Form_Name__c = 'Test Main Form',                 
                Form_Description__c = 'Test Description', 
                RecordTypeId = Schema.SObjectType.Form_Management_System__c.getRecordTypeInfosByName().get('Main Product Definition Form').getRecordTypeId());            
            insert formObj ;        

            Test.stopTest();  

            ApexPages.currentPage().getParameters().put('id',formObj.Id);              
            ApexPages.currentPage().getParameters().put('ParentId', formObj.id);
            ApexPages.currentPage().getParameters().put('tranx', 'Create');
            ApexPages.currentPage().getParameters().put('Type', 'Main');
            ApexPages.currentPage().getParameters().put('AccountId', acc.Id);

            FMSChildCreationController IMCext = new FMSChildCreationController(new ApexPages.StandardController(formObj));
            IMCext.getDMEAAccountList();
            PageReference pr = IMCext.cancelRecord();

            System.assert(pr.getUrl().contains('/apex/FMSmainFormViewPage?id='+formObj.id));
        } 
    }

    static testMethod void testMethod2() {
        
        Account acc = getAccount('TEST rec');

        PageReference pageRef = Page.FMSDeviceSelectionPage;            
        Test.setCurrentPage(pageRef);       
        
        User thisUser= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator'); 
        System.runAs(thisUser){
            Test.startTest();

            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;   

            String oppId = DeviceChecklistTestDataUtils.createOpp(acc.Id);
            String oppProgId = DeviceChecklistTestDataUtils.createOppProg(acc.Id, oppId);
            Process__c p = DeviceChecklistTestDataUtils.createProcess();

            Map<String,Object> fieldValueMap1 = new Map<String,Object>();
            fieldValueMap1.put('Account__c', acc.id);
            fieldValueMap1.put('Device_Sourcing__c','Sole Source');
            fieldValueMap1.put('Opportunity_Program__c',Id.valueOf(oppProgId));
            fieldValueMap1.put('Device_Mask_Set_Title__c','MPW');  
            fieldValueMap1.put('Export_Control_Status__c','Approved');
            Device__c Dev = new Device__c ();
            Dev = DeviceDataFactory.createDevice(fieldValueMap1);
        
            Form_Management_System__c formObj = new Form_Management_System__c(
                Customer_Name__c = acc.Id,
                Name__c = 'Test Name',
                Form_Name__c = 'Test Main Form',                 
                Form_Description__c = 'Test Description', 
                RecordTypeId = Schema.SObjectType.Form_Management_System__c.getRecordTypeInfosByName().get('Main Product Definition Form').getRecordTypeId());            
            insert formObj ;        

            Test.stopTest();  

            ApexPages.currentPage().getParameters().put('id',formObj.Id); 
            ApexPages.currentPage().getParameters().put('ParentId', formObj.id);             
            ApexPages.currentPage().getParameters().put('Type', 'Other');
            ApexPages.currentPage().getParameters().put('DeviceId', Dev.Id);

            FMSChildCreationController IMCext = new FMSChildCreationController(new ApexPages.StandardController(formObj));
            IMCext.getaddendumList(); 

            System.assertEquals(formObj.Form_Name__c,'Test Main Form');                            
        } 
    }

    static testMethod void testMethod3() {
        
        Account acc = getAccount('TEST rec');

        PageReference pageRef = Page.FMSDeviceSelectionPage;            
        Test.setCurrentPage(pageRef);       
        
        User thisUser= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator'); 
        System.runAs(thisUser){
            Test.startTest();

            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;   
            
            String oppId = DeviceChecklistTestDataUtils.createOpp(acc.Id);
            String oppProgId = DeviceChecklistTestDataUtils.createOppProg(acc.Id, oppId);
            Process__c p = DeviceChecklistTestDataUtils.createProcess();

            Map<String,Object> fieldValueMap1 = new Map<String,Object>();
            fieldValueMap1.put('Account__c', acc.id);
            fieldValueMap1.put('Device_Sourcing__c','Sole Source');
            fieldValueMap1.put('Opportunity_Program__c',Id.valueOf(oppProgId));
            fieldValueMap1.put('Device_Mask_Set_Title__c','MPW');  
            fieldValueMap1.put('Export_Control_Status__c','Approved');
            Device__c Dev = new Device__c ();
            Dev = DeviceDataFactory.createDevice(fieldValueMap1);
        
            Form_Management_System__c formObj = new Form_Management_System__c(
                Customer_Name__c = acc.Id,
                Name__c = 'Test Name',
                Form_Name__c = 'Test Main Form',                 
                Form_Description__c = 'Test Description', 
                RecordTypeId = Schema.SObjectType.Form_Management_System__c.getRecordTypeInfosByName().get('Main Product Definition Form').getRecordTypeId());            
            insert formObj ;        

            Test.stopTest();  

            ApexPages.currentPage().getParameters().put('id',formObj.Id);
            ApexPages.currentPage().getParameters().put('ParentId', formObj.id);            
            ApexPages.currentPage().getParameters().put('Type', 'IMC');
            ApexPages.currentPage().getParameters().put('DeviceId', Dev.Id);

            FMSChildCreationController IMCext = new FMSChildCreationController(new ApexPages.StandardController(formObj));
            IMCext.getaddendumList(); 
            PageReference pr = IMCext.cancelRecord();

            System.assert(pr.getUrl().contains('/apex/FMSIMCFormViewPage?id='+formObj.id));                           
        } 
    }

    static testMethod void testMethod4() {
        
        Account acc = getAccount('TEST rec');

        PageReference pageRef = Page.FMSDeviceSelectionPage;            
        Test.setCurrentPage(pageRef);       
        
        User thisUser= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator'); 
        System.runAs(thisUser){
            Test.startTest();

            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;   
        
            Form_Management_System__c formObj = new Form_Management_System__c(
                Customer_Name__c = acc.Id,
                Name__c = 'Test Name',
                Form_Name__c = 'Test Main Form',                 
                Form_Description__c = 'Test Description', 
                RecordTypeId = Schema.SObjectType.Form_Management_System__c.getRecordTypeInfosByName().get('Main Product Definition Form').getRecordTypeId());            
            insert formObj ;        

            Test.stopTest();  

            ApexPages.currentPage().getParameters().put('id',formObj.Id);              
            ApexPages.currentPage().getParameters().put('Type', 'RIT');

            FMSChildCreationController IMCext = new FMSChildCreationController(new ApexPages.StandardController(formObj));
            IMCext.getaddendumList();
            PageReference pr = IMCext.cancelRecord();

            System.assert(pr.getUrl().contains('/apex/FMSRITFormViewPage?id='+formObj.id));                             
        } 
    }

    static testMethod void testMethod5() {
        
        Account acc = getAccount('TEST rec');

        PageReference pageRef = Page.FMSDeviceSelectionPage;            
        Test.setCurrentPage(pageRef);       
        
        User thisUser= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator'); 
        System.runAs(thisUser){
            Test.startTest();

            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;   
        
            Form_Management_System__c formObj = new Form_Management_System__c(
                Customer_Name__c = acc.Id,
                Name__c = 'Test Name',
                Form_Name__c = 'Test Main Form',                 
                Form_Description__c = 'Test Description', 
                RecordTypeId = Schema.SObjectType.Form_Management_System__c.getRecordTypeInfosByName().get('Main Product Definition Form').getRecordTypeId());            
            insert formObj ;        

            Test.stopTest();  

            ApexPages.currentPage().getParameters().put('id',formObj.Id);              
            ApexPages.currentPage().getParameters().put('Type', 'DDR');

            FMSChildCreationController IMCext = new FMSChildCreationController(new ApexPages.StandardController(formObj));
            PageReference pr = IMCext.cancelRecord();

            System.assert(pr.getUrl().contains('/apex/FMSDDRFormViewPage?id='+formObj.id));                           
        } 
    }

    static testMethod void testMethod6() {
        
        Account acc = getAccount('TEST rec');

        PageReference pageRef = Page.FMSDeviceSelectionPage;            
        Test.setCurrentPage(pageRef);       
        
        User thisUser= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator'); 
        System.runAs(thisUser){
            Test.startTest();

            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;   
        
            Form_Management_System__c formObj = new Form_Management_System__c(
                Customer_Name__c = acc.Id,
                Name__c = 'Test Name',
                Form_Name__c = 'Test Main Form',                 
                Form_Description__c = 'Test Description', 
                RecordTypeId = Schema.SObjectType.Form_Management_System__c.getRecordTypeInfosByName().get('Main Product Definition Form').getRecordTypeId());            
            insert formObj ;        

            Test.stopTest();  

            ApexPages.currentPage().getParameters().put('id',formObj.Id);              
            ApexPages.currentPage().getParameters().put('Type', 'SP');

            FMSChildCreationController IMCext = new FMSChildCreationController(new ApexPages.StandardController(formObj));
            PageReference pr = IMCext.cancelRecord();

            System.assert(pr.getUrl().contains('/apex/FMSStepPlanFormView?id='+formObj.id));                         
        } 
    }

    static testMethod void testMethod7() {
        
        Account acc = getAccount('TEST rec');
        Contact con = getContact(acc.Id);

        PageReference pageRef = Page.FMSDeviceSelectionPage;            
        Test.setCurrentPage(pageRef);       
        
        User thisUser= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator'); 
        System.runAs(thisUser){
            Test.startTest();

            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;   
            
            Form_Management_System__c formObj = new Form_Management_System__c(
                Customer_Name__c = acc.Id,
                Selected_Contact_Ids__c = con.Id+';'+con.Id,
                Name__c = 'Test Name',
                Form_Name__c = 'Test Main Form',                 
                Form_Description__c = 'Test Description', 
                RecordTypeId = Schema.SObjectType.Form_Management_System__c.getRecordTypeInfosByName().get('Main Product Definition Form').getRecordTypeId());            
            insert formObj ;        

            Test.stopTest();  

            ApexPages.currentPage().getParameters().put('id',formObj.Id);              
            ApexPages.currentPage().getParameters().put('ParentId', formObj.id);
            ApexPages.currentPage().getParameters().put('tranx', 'Edit');
            ApexPages.currentPage().getParameters().put('Type', 'Main');
            ApexPages.currentPage().getParameters().put('AccountId', acc.Id);

            FMSChildCreationController IMCext = new FMSChildCreationController(new ApexPages.StandardController(formObj));  
            System.assertEquals(formObj.Form_Name__c,'Test Main Form');                           
        } 
    }

    static testMethod void testMethod8() {
        
        Account acc = getAccount('TEST rec');
        Contact con = getContact(acc.Id);

        PageReference pageRef = Page.FMSDeviceSelectionPage;            
        Test.setCurrentPage(pageRef);       
        
        User thisUser= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator'); 
        System.runAs(thisUser){
            Test.startTest();

            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;   
            
            Id testContentInsert = getContentVer();
            
            Form_Management_System__c formObj = new Form_Management_System__c(
                Customer_Name__c = acc.Id,
                Selected_Contact_Ids__c = con.Id+';'+con.Id,
                Name__c = 'Test Name',
                Form_Name__c = 'Test Main Form',                 
                Form_Description__c = 'Test Description',
                FileAttachment__c = testContentInsert,
                RecordTypeId = Schema.SObjectType.Form_Management_System__c.getRecordTypeInfosByName().get('Main Product Definition Form').getRecordTypeId());            
            insert formObj ;    
            list<FMS_Mapping_table__c> lstFMSTab = [Select Id,Is_Inactive__c FROM FMS_Mapping_table__c];
			for(FMS_Mapping_table__c fmsT : lstFMSTab) {
			  fmsT.is_Inactive__c = true;
			  fmsT.FMS_Field_API__c = 'MetallizationOpts__c';
			  fmsT.Technology__c = formObj.Technology__c;
			}
			update lstFMSTab;    
            Test.stopTest();  

            ApexPages.currentPage().getParameters().put('id',formObj.Id);              
            ApexPages.currentPage().getParameters().put('ParentId', formObj.id);
            ApexPages.currentPage().getParameters().put('tranx', 'Copy');
            ApexPages.currentPage().getParameters().put('Type', 'Main');
            ApexPages.currentPage().getParameters().put('AccountId', acc.Id);

            FMSChildCreationController IMCext = new FMSChildCreationController(new ApexPages.StandardController(formObj));  
            IMCext.continueCheck();     
            
            pageRef = new pagereference('/GlobalfoundryView/apex/FMSDDRFormPage');            
            Test.setCurrentPage(pageRef);   
            ApexPages.currentPage().getParameters().put('id',formObj.Id);              
            ApexPages.currentPage().getParameters().put('ParentId', formObj.id);
            ApexPages.currentPage().getParameters().put('tranx', 'Copy');
            ApexPages.currentPage().getParameters().put('Type', 'Main');
            ApexPages.currentPage().getParameters().put('AccountId', acc.Id);

            IMCext = new FMSChildCreationController(new ApexPages.StandardController(formObj));      
            PageReference pr = IMCext.continueCheck();

            System.assert(pr.getUrl().contains('/apex/FMSmainFormCreationPg1?id='));                               
        } 
    }
    
    static testMethod void testMethod9() {
        
        Account acc = getAccount('TEST rec');
        Contact con = getContact(acc.Id);

        PageReference pageRef = Page.FMSDeviceSelectionPage;            
        Test.setCurrentPage(pageRef);       
        
        User thisUser= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator'); 
        System.runAs(thisUser){
            Test.startTest();

            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;   
            
            Form_Management_System__c pformObj = new Form_Management_System__c(
                Customer_Name__c = acc.Id,
                Selected_Contact_Ids__c = con.Id+';'+con.Id,
                Name__c = 'Test Name',
                Form_Name__c = 'Test Main Form',                 
                Form_Description__c = 'Test Description', 
                RecordTypeId = Schema.SObjectType.Form_Management_System__c.getRecordTypeInfosByName().get('Main Product Definition Form').getRecordTypeId());            
            insert pformObj ;

            Form_Management_System__c formObj = new Form_Management_System__c();
            formObj.Form_Name__c = 'Test';
            formObj.Customer_Name__c = acc.Id;

            Test.stopTest();  

            ApexPages.currentPage().getParameters().put('id',null);              
            ApexPages.currentPage().getParameters().put('ParentId', pformObj.id);
            ApexPages.currentPage().getParameters().put('Type', 'Main');
            ApexPages.currentPage().getParameters().put('AccountId', acc.Id);

            FMSChildCreationController IMCext = new FMSChildCreationController(new ApexPages.StandardController(formObj));
            //IMCext.continueCheck(); 
            IMCext.cancelRecord();   
            
            pageRef = new pagereference('/GlobalfoundryView/apex/FMSDDRFormPage');            
            Test.setCurrentPage(pageRef);   
            ApexPages.currentPage().getParameters().put('id',formObj.Id);              
            ApexPages.currentPage().getParameters().put('ParentId', pformObj.id);
            //ApexPages.currentPage().getParameters().put('tranx', 'Edit');
            ApexPages.currentPage().getParameters().put('Type', 'Main');
            ApexPages.currentPage().getParameters().put('AccountId', acc.Id);

            IMCext = new FMSChildCreationController(new ApexPages.StandardController(formObj));
            IMCext.formObj.Id = null;
            PageReference pr = IMCext.cancelRecord();

            System.assert(pr.getUrl().contains('/apex/FMSmainFormViewPage?id='+pformObj.id));                     
        } 
    }

    static testMethod void testMethod10() {
        
        Account acc = getAccount('TEST rec');
        Contact con = getContact(acc.Id);

        PageReference pageRef = Page.FMSDeviceSelectionPage;            
        Test.setCurrentPage(pageRef);       
        
        User thisUser= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator'); 
        System.runAs(thisUser){
            Test.startTest();

            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;   
            
            Form_Management_System__c pformObj = new Form_Management_System__c(
                Customer_Name__c = acc.Id,
                Selected_Contact_Ids__c = con.Id+';'+con.Id,
                Name__c = 'Test Name',
                Customer__c = 'TEST rec',
                Form_Name__c = 'Test Main Form',                 
                Form_Description__c = 'Test Description', 
                RecordTypeId = Schema.SObjectType.Form_Management_System__c.getRecordTypeInfosByName().get('Incremental Mask Change (IMC)').getRecordTypeId());            
            insert pformObj ;

            Form_Management_System__c formObj = new Form_Management_System__c();
            formObj.Form_Name__c = 'Test';
            formObj.Customer_Name__c = acc.Id;

            Test.stopTest();  

            ApexPages.currentPage().getParameters().put('id',null);              
            ApexPages.currentPage().getParameters().put('ParentId', pformObj.id);
            ApexPages.currentPage().getParameters().put('Type', 'IMC');
            ApexPages.currentPage().getParameters().put('AccountId', acc.Id);

            FMSChildCreationController IMCext = new FMSChildCreationController(new ApexPages.StandardController(formObj)); 
            IMCext.cancelRecord();  
            
            pageRef = new pagereference('/GlobalfoundryView/apex/FMSDDRFormPage');            
            Test.setCurrentPage(pageRef);   
            ApexPages.currentPage().getParameters().put('id',null);              
            ApexPages.currentPage().getParameters().put('ParentId', pformObj.id);
           // ApexPages.currentPage().getParameters().put('tranx', 'Edit');
            ApexPages.currentPage().getParameters().put('Type', 'IMC');
            ApexPages.currentPage().getParameters().put('AccountId', acc.Id);

            IMCext = new FMSChildCreationController(new ApexPages.StandardController(formObj));
            IMCext.formObj.Id = null;
            PageReference pr = IMCext.cancelRecord();

            System.assert(pr.getUrl().contains('/apex/FMSIMCFormViewPage?id='+pformObj.id));                       
        } 
    }

    static testMethod void testMethod11() {
        
        Account acc = getAccount('TEST rec');
        Contact con = getContact(acc.Id);

        PageReference pageRef = Page.FMSDeviceSelectionPage;            
        Test.setCurrentPage(pageRef);       
        
        User thisUser= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator'); 
        System.runAs(thisUser){
            Test.startTest();

            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;   
            
            Form_Management_System__c pformObj = new Form_Management_System__c(
                Customer_Name__c = acc.Id,
                Selected_Contact_Ids__c = con.Id+';'+con.Id,
                Name__c = 'Test Name',
                Customer__c = 'TEST rec',
                Form_Name__c = 'Test Main Form',                 
                Form_Description__c = 'Test Description', 
                RecordTypeId = Schema.SObjectType.Form_Management_System__c.getRecordTypeInfosByName().get('Design Data Submission (RIT)').getRecordTypeId());            
            insert pformObj ;

            Form_Management_System__c formObj = new Form_Management_System__c();
            formObj.Form_Name__c = 'Test';
            formObj.Customer_Name__c = acc.Id;

            Test.stopTest();  

            ApexPages.currentPage().getParameters().put('id',null);              
            ApexPages.currentPage().getParameters().put('ParentId', pformObj.id);
            ApexPages.currentPage().getParameters().put('Type', 'RIT');
            ApexPages.currentPage().getParameters().put('AccountId', acc.Id);

            FMSChildCreationController IMCext = new FMSChildCreationController(new ApexPages.StandardController(formObj)); 
            IMCext.cancelRecord();  
            //IMCext.continueCheck();  
            
            pageRef = new pagereference('/GlobalfoundryView/apex/FMSDDRFormPage');            
            Test.setCurrentPage(pageRef);   
            ApexPages.currentPage().getParameters().put('id',null);              
            ApexPages.currentPage().getParameters().put('ParentId', pformObj.id);
            //ApexPages.currentPage().getParameters().put('tranx', 'Edit');
            ApexPages.currentPage().getParameters().put('Type', 'RIT');
            ApexPages.currentPage().getParameters().put('AccountId', acc.Id);

            IMCext = new FMSChildCreationController(new ApexPages.StandardController(formObj));
            IMCext.formObj.Id = null;
            PageReference pr = IMCext.cancelRecord();

            System.assert(pr.getUrl().contains('/apex/FMSRITFormViewPage?id='+pformObj.id));                    
        } 
    }

    static testMethod void testMethod12() {
        
        Account acc = getAccount('TEST rec');
        Contact con = getContact(acc.Id);

        PageReference pageRef = Page.FMSDeviceSelectionPage;            
        Test.setCurrentPage(pageRef);       
        
        User thisUser= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator'); 
        System.runAs(thisUser){
            Test.startTest();

            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;   
            
            Form_Management_System__c pformObj = new Form_Management_System__c(
                Customer_Name__c = acc.Id,
                Selected_Contact_Ids__c = con.Id+';'+con.Id,
                Name__c = 'Test Name',
                Customer__c = 'TEST rec',
                Form_Name__c = 'Test Main Form',                 
                Form_Description__c = 'Test Description', 
                RecordTypeId = Schema.SObjectType.Form_Management_System__c.getRecordTypeInfosByName().get('Design Data Return (DDR)').getRecordTypeId());            
            insert pformObj ;

            Form_Management_System__c formObj = new Form_Management_System__c();
            formObj.Form_Name__c = 'Test';
            formObj.Customer_Name__c = acc.Id;

            Test.stopTest();  

            ApexPages.currentPage().getParameters().put('id',null);              
            ApexPages.currentPage().getParameters().put('ParentId', pformObj.id);
            ApexPages.currentPage().getParameters().put('Type', 'DDR');
            ApexPages.currentPage().getParameters().put('AccountId', acc.Id);

            FMSChildCreationController IMCext = new FMSChildCreationController(new ApexPages.StandardController(formObj)); 
            IMCext.cancelRecord();  
            
            pageRef = new pagereference('/GlobalfoundryView/apex/FMSDDRFormPage');            
            Test.setCurrentPage(pageRef);   
            ApexPages.currentPage().getParameters().put('id',null);              
            ApexPages.currentPage().getParameters().put('ParentId', pformObj.id);
           // ApexPages.currentPage().getParameters().put('tranx', 'Edit');
            ApexPages.currentPage().getParameters().put('Type', 'DDR');
            ApexPages.currentPage().getParameters().put('AccountId', acc.Id);

            IMCext = new FMSChildCreationController(new ApexPages.StandardController(formObj));
            IMCext.formObj.Id = null;
            PageReference pr = IMCext.cancelRecord();

            System.assert(pr.getUrl().contains('/apex/FMSDDRFormViewPage?id='+pformObj.id));  
        } 
    }

    static testMethod void testMethod13() {                     
        
        User thisUser= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator'); 
        System.runAs(thisUser){

            PageReference pageRef = Page.FMSDeviceSelectionPage;            
            Test.setCurrentPage(pageRef); 
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;

            Account acc = getAccount('TEST rec');
            Contact con = getContact(acc.Id);
            
            Test.startTest();
            String oppId = DeviceChecklistTestDataUtils.createOpp(acc.Id);            
            String oppProgId = DeviceChecklistTestDataUtils.createOppProg(acc.Id, oppId);
            Process__c p = DeviceChecklistTestDataUtils.createProcess();          
            
            Device__c dev = createDevice(acc.Id,oppId,oppProgId,p.Id);
            
            Id testContentInsert = getContentVer();
            
            Test.stopTest();
            
            Form_Management_System__c formObj = new Form_Management_System__c(
                Device__c = dev.Id,
                Customer_Name__c = acc.Id,
                Selected_Contact_Ids__c = con.Id+';'+con.Id,
                Name__c = 'Test Name',
                Form_Name__c = 'Test Main Form',                 
                Form_Description__c = 'Test Description', 
                FileAttachment__c = testContentInsert,
                RecordTypeId = Schema.SObjectType.Form_Management_System__c.getRecordTypeInfosByName().get('Main Product Definition Form').getRecordTypeId());            
            insert formObj ;        

            ApexPages.currentPage().getParameters().put('id',formObj.Id);              
            ApexPages.currentPage().getParameters().put('ParentId', formObj.id);
            ApexPages.currentPage().getParameters().put('tranx', 'Copy');
            ApexPages.currentPage().getParameters().put('Type', 'IMC');
            ApexPages.currentPage().getParameters().put('AccountId', acc.Id);

            FMSChildCreationController IMCext = new FMSChildCreationController(new ApexPages.StandardController(formObj));  
            PageReference pr = IMCext.continueCheck();

            System.assert(pr.getUrl().contains('/apex/FMSIMCFormPage?id='));                         
        } 
    }
    
    
    static testMethod void testMethod27() {
                               
        User thisUser= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator'); 
        System.runAs(thisUser){

            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;   
            
            Account acc = getAccount('TEST rec');
            Contact con = getContact(acc.Id);

            PageReference pageRef = Page.FMSDeviceSelectionPage;            
            Test.setCurrentPage(pageRef);
            Test.startTest();
            String oppId = DeviceChecklistTestDataUtils.createOpp(acc.Id);
            
            String oppProgId = DeviceChecklistTestDataUtils.createOppProg(acc.Id, oppId);
            Process__c p = DeviceChecklistTestDataUtils.createProcess();           
            Device__c dev = createDevice(acc.Id,oppId,oppProgId,p.Id);
            Id testContentInsert = getContentVer();
            Test.stopTest();
            Form_Management_System__c formObj = new Form_Management_System__c(
                Device__c = dev.Id,
                Customer_Name__c = acc.Id,
                Selected_Contact_Ids__c = con.Id+';'+con.Id,
                Name__c = 'Test Name',
                Form_Name__c = 'Test Main Form',                 
                Form_Description__c = 'Test Description', 
                FileAttachment__c = testContentInsert,
                RecordTypeId = Schema.SObjectType.Form_Management_System__c.getRecordTypeInfosByName().get('Main Product Definition Form').getRecordTypeId());            
            insert formObj ;        

            pageRef = new pagereference('/GlobalfoundryView/apex/FMSDDRFormPage');            
            Test.setCurrentPage(pageRef);   
            ApexPages.currentPage().getParameters().put('id',formObj.Id);              
            ApexPages.currentPage().getParameters().put('ParentId', formObj.id);
            ApexPages.currentPage().getParameters().put('tranx', 'Copy');
            ApexPages.currentPage().getParameters().put('Type', 'IMC');
            ApexPages.currentPage().getParameters().put('AccountId', acc.Id);

            FMSChildCreationController IMCext = new FMSChildCreationController(new ApexPages.StandardController(formObj));  
            PageReference pr = IMCext.continueCheck();

            System.assert(pr.getUrl().contains('/apex/FMSIMCFormPage?id='));            
        } 
    }

    static testMethod void testMethod14() {
        
        Account acc = getAccount('TEST rec');
        Contact con = getContact(acc.Id);

        PageReference pageRef = Page.FMSDeviceSelectionPage;            
        Test.setCurrentPage(pageRef);       
        
        User thisUser= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator'); 
        System.runAs(thisUser){
            Test.startTest();

            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;   
            Id testContentInsert = getContentVer();
            Form_Management_System__c formObj = new Form_Management_System__c(
                Customer_Name__c = acc.Id,
                Selected_Contact_Ids__c = con.Id+';'+con.Id,
                Name__c = 'Test Name',
                Form_Name__c = 'Test Main Form',                 
                Form_Description__c = 'Test Description', 
                FileAttachment__c = testContentInsert,
                RecordTypeId = Schema.SObjectType.Form_Management_System__c.getRecordTypeInfosByName().get('Main Product Definition Form').getRecordTypeId());            
            insert formObj ;        

            Test.stopTest();  

            ApexPages.currentPage().getParameters().put('id',formObj.Id);              
            ApexPages.currentPage().getParameters().put('ParentId', formObj.id);
            ApexPages.currentPage().getParameters().put('tranx', 'Copy');
            ApexPages.currentPage().getParameters().put('Type', 'DDR');
            ApexPages.currentPage().getParameters().put('AccountId', acc.Id);

            FMSChildCreationController IMCext = new FMSChildCreationController(new ApexPages.StandardController(formObj));  
            IMCext.continueCheck();   
            
             pageRef = new pagereference('/GlobalfoundryView/apex/FMSDDRFormPage');            
            Test.setCurrentPage(pageRef);   
            ApexPages.currentPage().getParameters().put('id',formObj.Id);              
            ApexPages.currentPage().getParameters().put('ParentId', formObj.id);
            ApexPages.currentPage().getParameters().put('tranx', 'Copy');
            ApexPages.currentPage().getParameters().put('Type', 'DDR');
            ApexPages.currentPage().getParameters().put('AccountId', acc.Id);

            IMCext = new FMSChildCreationController(new ApexPages.StandardController(formObj));  
            PageReference pr = IMCext.continueCheck();

            System.assert(pr.getUrl().contains('/apex/FMSDDRFormPage?id='));    

        } 
    }

    static testMethod void testMethod15() {
        
        Account acc = getAccount('TEST rec');
        Contact con = getContact(acc.Id);

        PageReference pageRef = Page.FMSDeviceSelectionPage;            
        Test.setCurrentPage(pageRef);       
        
        User thisUser= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator'); 
        System.runAs(thisUser){
            Test.startTest();

            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;   

            Form_Management_System__c formObj = new Form_Management_System__c(
                Customer_Name__c = acc.Id,
                Selected_Contact_Ids__c = con.Id+';'+con.Id,
                Name__c = 'Test Name',
                Form_Name__c = 'Test Main Form',                 
                Form_Description__c = 'Test Description', 
                RecordTypeId = Schema.SObjectType.Form_Management_System__c.getRecordTypeInfosByName().get('Main Product Definition Form').getRecordTypeId());            
            insert formObj ;        

            Test.stopTest();  

            ApexPages.currentPage().getParameters().put('id',formObj.Id);              
            ApexPages.currentPage().getParameters().put('ParentId', formObj.id);
            ApexPages.currentPage().getParameters().put('tranx', 'Copy');
            ApexPages.currentPage().getParameters().put('Type', 'RIT');
            ApexPages.currentPage().getParameters().put('AccountId', acc.Id);

            FMSChildCreationController IMCext = new FMSChildCreationController(new ApexPages.StandardController(formObj));  
            IMCext.continueCheck();  
            
             pageRef = new pagereference('/GlobalfoundryView/apex/FMSDDRFormPage');            
            Test.setCurrentPage(pageRef);   
            ApexPages.currentPage().getParameters().put('id',formObj.Id);              
            ApexPages.currentPage().getParameters().put('ParentId', formObj.id);
            ApexPages.currentPage().getParameters().put('tranx', 'Copy');
            ApexPages.currentPage().getParameters().put('Type', 'RIT');
            ApexPages.currentPage().getParameters().put('AccountId', acc.Id);

            IMCext = new FMSChildCreationController(new ApexPages.StandardController(formObj));  
            PageReference pr = IMCext.continueCheck();

            System.assert(pr.getUrl().contains('/apex/FMSRITFormNewEditPage1?id='));                          
        } 
    }

    static testMethod void testMethod16() {
        
        Account acc = getAccount('TEST rec');
        Contact con = getContact(acc.Id);

        PageReference pageRef = Page.FMSDeviceSelectionPage;            
        Test.setCurrentPage(pageRef);       
        
        User thisUser= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator'); 
        System.runAs(thisUser){
            Test.startTest();

            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;   
            
            Form_Management_System__c formObj = new Form_Management_System__c(
                Customer_Name__c = acc.Id,
                Selected_Contact_Ids__c = con.Id+';'+con.Id,
                Name__c = 'Test Name',
                Form_Name__c = 'Test Main Form',                 
                Form_Description__c = 'Test Description', 
                RecordTypeId = Schema.SObjectType.Form_Management_System__c.getRecordTypeInfosByName().get('Main Product Definition Form').getRecordTypeId());            
            insert formObj ;        

            Test.stopTest();  

            ApexPages.currentPage().getParameters().put('id',formObj.Id);              
            ApexPages.currentPage().getParameters().put('ParentId', formObj.id);
            ApexPages.currentPage().getParameters().put('tranx', 'Edit');
            ApexPages.currentPage().getParameters().put('Type', 'RIT');
            ApexPages.currentPage().getParameters().put('AccountId', acc.Id);

            FMSChildCreationController IMCext = new FMSChildCreationController(new ApexPages.StandardController(formObj));  
            IMCext.continueCheck();   
            
            pageRef = new pagereference('/GlobalfoundryView/apex/FMSDDRFormPage');            
            Test.setCurrentPage(pageRef);   
            ApexPages.currentPage().getParameters().put('id',formObj.Id);              
            ApexPages.currentPage().getParameters().put('ParentId', formObj.id);
            ApexPages.currentPage().getParameters().put('tranx', 'Edit');
            ApexPages.currentPage().getParameters().put('Type', 'RIT');
            ApexPages.currentPage().getParameters().put('AccountId', acc.Id);

            IMCext = new FMSChildCreationController(new ApexPages.StandardController(formObj));  
            PageReference pr = IMCext.continueCheck();

            System.assert(pr.getUrl().contains('/apex/FMSRITFormViewPage?id='+formObj.id));                      
        } 
    }

    static testMethod void testMethod17() {
        
        Account acc = getAccount('TEST rec');
        Contact con = getContact(acc.Id);

        PageReference pageRef = Page.FMSDeviceSelectionPage;            
        Test.setCurrentPage(pageRef);       
        
        User thisUser= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator'); 
        System.runAs(thisUser){
            Test.startTest();

            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;   
            
            Form_Management_System__c formObj = new Form_Management_System__c(
                Customer_Name__c = acc.Id,
                Selected_Contact_Ids__c = con.Id+';'+con.Id,
                Name__c = 'Test Name',
                Form_Name__c = 'Test Main Form',                 
                Form_Description__c = 'Test Description', 
                RecordTypeId = Schema.SObjectType.Form_Management_System__c.getRecordTypeInfosByName().get('Main Product Definition Form').getRecordTypeId());            
            insert formObj ;        

            Test.stopTest();  

            ApexPages.currentPage().getParameters().put('id',formObj.Id);              
            ApexPages.currentPage().getParameters().put('ParentId', formObj.id);
            ApexPages.currentPage().getParameters().put('tranx', 'Edit');
            ApexPages.currentPage().getParameters().put('Type', 'Main');
            ApexPages.currentPage().getParameters().put('AccountId', acc.Id);

            FMSChildCreationController IMCext = new FMSChildCreationController(new ApexPages.StandardController(formObj));  
            IMCext.continueCheck();  
            
            pageRef = new pagereference('/GlobalfoundryView/apex/FMSDDRFormPage');            
            Test.setCurrentPage(pageRef);   
            ApexPages.currentPage().getParameters().put('id',formObj.Id);              
            ApexPages.currentPage().getParameters().put('ParentId', formObj.id);
            ApexPages.currentPage().getParameters().put('tranx', 'Edit');
            ApexPages.currentPage().getParameters().put('Type', 'Main');
            ApexPages.currentPage().getParameters().put('AccountId', acc.Id);

            IMCext = new FMSChildCreationController(new ApexPages.StandardController(formObj));  
            PageReference pr = IMCext.continueCheck();

            System.assert(pr.getUrl().contains('/apex/FMSmainFormViewPage?id='+formObj.id));                        
        } 
    }

    static testMethod void testMethod18() {
        
        Account acc = getAccount('TEST rec');
        Contact con = getContact(acc.Id);

        PageReference pageRef = Page.FMSDeviceSelectionPage;            
        Test.setCurrentPage(pageRef);       
        
        User thisUser= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator'); 
        System.runAs(thisUser){
            Test.startTest();

            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;   
            
            Form_Management_System__c formObj = new Form_Management_System__c(
                Customer_Name__c = acc.Id,
                Selected_Contact_Ids__c = con.Id+';'+con.Id,
                Name__c = 'Test Name',
                Form_Name__c = 'Test Main Form',                 
                Form_Description__c = 'Test Description', 
                RecordTypeId = Schema.SObjectType.Form_Management_System__c.getRecordTypeInfosByName().get('Main Product Definition Form').getRecordTypeId());            
            insert formObj ;        

            Test.stopTest();  

            ApexPages.currentPage().getParameters().put('id',formObj.Id);              
            ApexPages.currentPage().getParameters().put('ParentId', formObj.id);
            ApexPages.currentPage().getParameters().put('tranx', 'Edit');
            ApexPages.currentPage().getParameters().put('Type', 'IMC');
            ApexPages.currentPage().getParameters().put('AccountId', acc.Id);

            FMSChildCreationController IMCext = new FMSChildCreationController(new ApexPages.StandardController(formObj));  
            IMCext.continueCheck();   
            
            pageRef = new pagereference('/GlobalfoundryView/apex/FMSDDRFormPage');            
            Test.setCurrentPage(pageRef);   
            ApexPages.currentPage().getParameters().put('id',formObj.Id);              
            ApexPages.currentPage().getParameters().put('ParentId', formObj.id);
            ApexPages.currentPage().getParameters().put('tranx', 'Edit');
            ApexPages.currentPage().getParameters().put('Type', 'IMC');
            ApexPages.currentPage().getParameters().put('AccountId', acc.Id);

            IMCext = new FMSChildCreationController(new ApexPages.StandardController(formObj));  
            PageReference pr = IMCext.continueCheck();

            System.assert(pr.getUrl().contains('/apex/FMSIMCFormViewPage?id='+formObj.id));                        
        } 
    }

    static testMethod void testMethod19() {
        
        Account acc = getAccount('TEST rec');
        Contact con = getContact(acc.Id);

        PageReference pageRef = Page.FMSDeviceSelectionPage;            
        Test.setCurrentPage(pageRef);       
        
        User thisUser= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator'); 
        System.runAs(thisUser){
            Test.startTest();

            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;   
            
            Form_Management_System__c formObj = new Form_Management_System__c(
                Customer_Name__c = acc.Id,
                Selected_Contact_Ids__c = con.Id+';'+con.Id,
                Name__c = 'Test Name',
                Form_Name__c = 'Test Main Form',                 
                Form_Description__c = 'Test Description', 
                RecordTypeId = Schema.SObjectType.Form_Management_System__c.getRecordTypeInfosByName().get('Main Product Definition Form').getRecordTypeId());            
            insert formObj ;        

            Test.stopTest();  

            ApexPages.currentPage().getParameters().put('id',formObj.Id);              
            ApexPages.currentPage().getParameters().put('ParentId', formObj.id);
            ApexPages.currentPage().getParameters().put('tranx', 'Edit');
            ApexPages.currentPage().getParameters().put('Type', 'DDR');
            ApexPages.currentPage().getParameters().put('AccountId', acc.Id);

            FMSChildCreationController IMCext = new FMSChildCreationController(new ApexPages.StandardController(formObj));  
            IMCext.continueCheck(); 
            
            pageRef = new pagereference('/GlobalfoundryView/apex/FMSDDRFormPage');            
            Test.setCurrentPage(pageRef);   
            ApexPages.currentPage().getParameters().put('id',formObj.Id);              
            ApexPages.currentPage().getParameters().put('ParentId', formObj.id);
            ApexPages.currentPage().getParameters().put('tranx', 'Edit');
            ApexPages.currentPage().getParameters().put('Type', 'DDR');
            ApexPages.currentPage().getParameters().put('AccountId', acc.Id);

            IMCext = new FMSChildCreationController(new ApexPages.StandardController(formObj));  
            PageReference pr = IMCext.continueCheck();

            System.assert(pr.getUrl().contains('/apex/FMSDDRFormViewPage?id='+formObj.id));                         
        } 
    }

    static testMethod void testMethod20() {
        
        Account acc = getAccount('TEST rec');
        Contact con = getContact(acc.Id);

        PageReference pageRef = Page.FMSDeviceSelectionPage;            
        Test.setCurrentPage(pageRef);       
        
        User thisUser= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator'); 
        System.runAs(thisUser){
            Test.startTest();

            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;   
            
            Form_Management_System__c formObj = new Form_Management_System__c(
                Customer_Name__c = acc.Id,
                Selected_Contact_Ids__c = con.Id+';'+con.Id,
                Name__c = 'Test Name',
                Form_Name__c = 'Test Main Form',                 
                Form_Description__c = 'Test Description', 
                RecordTypeId = Schema.SObjectType.Form_Management_System__c.getRecordTypeInfosByName().get('Main Product Definition Form').getRecordTypeId());            
            insert formObj ;        

            Test.stopTest();  

            ApexPages.currentPage().getParameters().put('id',formObj.Id);              
            ApexPages.currentPage().getParameters().put('ParentId', formObj.id);
            ApexPages.currentPage().getParameters().put('tranx', 'Edit');
            ApexPages.currentPage().getParameters().put('Type', 'SP');
            ApexPages.currentPage().getParameters().put('AccountId', acc.Id);

            FMSChildCreationController IMCext = new FMSChildCreationController(new ApexPages.StandardController(formObj));  
            IMCext.continueCheck(); 
            
            pageRef = new pagereference('/GlobalfoundryView/apex/FMSDDRFormPage');            
            Test.setCurrentPage(pageRef);   
            ApexPages.currentPage().getParameters().put('id',formObj.Id);              
            ApexPages.currentPage().getParameters().put('ParentId', formObj.id);
            ApexPages.currentPage().getParameters().put('tranx', 'Edit');
            ApexPages.currentPage().getParameters().put('Type', 'SP');
            ApexPages.currentPage().getParameters().put('AccountId', acc.Id);

            IMCext = new FMSChildCreationController(new ApexPages.StandardController(formObj));  
            IMCext.continueCheck();  
               
            IMCext.checkFormCompany('fms-gf-as-2sda-asda','fms-gf-as-2sda-asda');   
            IMCext.formObj.Form_Name__c = null;
            System.assertNOTEquals(formObj.Form_Name__c,'Test Name'); 
            try{
            IMCext.continueCheck();    
            }catch(Exception e) {}                
        } 
    }
    
     static testMethod void testMethod21() {
        
        Account acc = getAccount('TEST rec');
        Contact con = getContact(acc.Id);

        PageReference pageRef = Page.FMSDeviceSelectionPage;            
        Test.setCurrentPage(pageRef);       
        
        User thisUser= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator'); 
        System.runAs(thisUser){
            Test.startTest();

            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;   
            
            Form_Management_System__c formObj = new Form_Management_System__c(
                Customer_Name__c = acc.Id,
                Selected_Contact_Ids__c = con.Id+';'+con.Id,
                Name__c = 'Test Name',
                Form_Name__c = 'Test Main Form',                 
                Form_Description__c = 'Test Description', 
                RecordTypeId = Schema.SObjectType.Form_Management_System__c.getRecordTypeInfosByName().get('Main Product Definition Form').getRecordTypeId());            
            insert formObj ;        

            Test.stopTest();  

            ApexPages.currentPage().getParameters().put('id',formObj.Id);              
            ApexPages.currentPage().getParameters().put('ParentId', formObj.id);
            ApexPages.currentPage().getParameters().put('tranx', 'Create');
            ApexPages.currentPage().getParameters().put('Type', EnvironmentVariable.get('FMS_MAIN_FORM_SHRT'));
            ApexPages.currentPage().getParameters().put('AccountId', acc.Id);

            FMSChildCreationController IMCext;
            try {
            IMCext = new FMSChildCreationController(new ApexPages.StandardController(formObj));  
            }catch(exception e){}
            IMCext.formObj.Id = null;
            try{
            IMCext.continueCheck();    
            }catch(exception e){}
            IMCext.checkFormCompany('fms-gf-as-2sda-asda','fms-gf-as-2sda-asda');     
            
            
            pageRef = new pagereference('/GlobalfoundryView/apex/FMSDDRFormPage');            
            Test.setCurrentPage(pageRef);   
             ApexPages.currentPage().getParameters().put('id',formObj.Id);              
            ApexPages.currentPage().getParameters().put('ParentId', formObj.id);
            ApexPages.currentPage().getParameters().put('tranx', 'Create');
            ApexPages.currentPage().getParameters().put('Type', EnvironmentVariable.get('FMS_MAIN_FORM_SHRT'));
            ApexPages.currentPage().getParameters().put('AccountId', acc.Id);

            IMCext = new FMSChildCreationController(new ApexPages.StandardController(formObj));  
            try{
            IMCext.continueCheck();  
            }catch(exception e){}
            
            System.assertNotEquals(formObj.Id,null); 
            IMCext.contactInfo.add(con);
            IMCext.targCustomerPortUser = thisUser.id;
            IMCext.selDMEAAccount= acc.id;
            IMCext.isDMEA = true;
            IMCext.dmeaList.add(acc);            
            try {            
            IMCext.continueCheck ();  
            }catch(Exception e) {}
            
            IMCext.targCustomerPortUser = null;
            IMCext.isDMEA = false;
            IMCext.formObj.Customer_Name__c = null;
            try {            
            IMCext.continueCheck ();  
            }catch(Exception e) {}
            
            
            IMCext.selDMEAAccount= null;
            IMCext.isDMEA = true;
            //IMCext.formObj.Customer_Name__c = null;
            try {            
            IMCext.continueCheck ();  
            }catch(Exception e) {}
             String s2 = IMCext.custName;
    String s1 = IMCext.selAddendum;
    
    String s3 = IMCext.selDMEAAccountName;

    String s4 = IMCext.extUserAccountId;
        } 
    }
    
     static testMethod void testMethod23() {
        
        Account acc = getAccount('TEST rec');
        Contact con = getContact(acc.Id);

        PageReference pageRef = Page.FMSDeviceSelectionPage;            
        Test.setCurrentPage(pageRef);       
        
        User thisUser= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator'); 
        System.runAs(thisUser){
            Test.startTest();

            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;   
            
            Form_Management_System__c formObj = new Form_Management_System__c(
                Customer_Name__c = acc.Id,
                Selected_Contact_Ids__c = con.Id+';'+con.Id,
                Name__c = 'Test Name',
                Form_Name__c = 'Test Main Form',                 
                Form_Description__c = 'Test Description', 
                RecordTypeId = Schema.SObjectType.Form_Management_System__c.getRecordTypeInfosByName().get('Main Product Definition Form').getRecordTypeId());            
            insert formObj ;        

            Test.stopTest();  

            ApexPages.currentPage().getParameters().put('id',formObj.Id);              
            ApexPages.currentPage().getParameters().put('ParentId', formObj.id);
            ApexPages.currentPage().getParameters().put('tranx', 'Create');
            ApexPages.currentPage().getParameters().put('Type', 'Other');
            ApexPages.currentPage().getParameters().put('AccountId', acc.Id);

            FMSChildCreationController IMCext;
            try {
            IMCext = new FMSChildCreationController(new ApexPages.StandardController(formObj));
            IMCext.isRunTest = true;
            IMCext.formType = 'Other';
            IMCext.selAddendum = 'IMC';
            }catch(exception e){}
            IMCext.formObj.Id = null;
            System.assertEquals(formObj.Id,null); 
            try{
            IMCext.continueCheck();    
            }catch(exception e){}
            
            IMCext.selAddendum = 'RIT';
            try{
            IMCext.continueCheck();    
            }catch(exception e){}
            IMCext.validationCheckForAddendum(formObj.id);
            
            IMCext.selAddendum = 'DDR';
            try{
            IMCext.continueCheck();    
            }catch(exception e){}
            IMCext.validationCheckForAddendum(formObj.id);
            
            IMCext.formType = 'IMC';
            IMCext.selAddendum = 'IMC';
            IMCext.validationCheckForAddendum(formObj.id);
            
            IMCext.selAddendum = 'RIT';
            IMCext.validationCheckForAddendum(formObj.id);
        } 
    }
    
    static testMethod void testMethod22() {
        
        Account acc = getAccount('TEST rec');
        Contact con = getContact(acc.Id);

        PageReference pageRef = Page.FMSDeviceSelectionPage;            
        Test.setCurrentPage(pageRef);       
        
        User thisUser= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator'); 
        System.runAs(thisUser){
            Test.startTest();

            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;

            String oppId = DeviceChecklistTestDataUtils.createOpp(acc.Id);
            String oppProgId = DeviceChecklistTestDataUtils.createOppProg(acc.Id, oppId);
            Process__c p = DeviceChecklistTestDataUtils.createProcess();

            Device__c dev = createDevicePart(acc.Id,oppId,oppProgId,p.Id);   
            
            Form_Management_System__c formObj = new Form_Management_System__c(
                Customer_Name__c = acc.Id,
                Selected_Contact_Ids__c = con.Id+';'+con.Id,
                Name__c = 'Test Name',
                Form_Name__c = 'Test Main Form',                 
                Form_Description__c = 'Test Description', 
                RecordTypeId = Schema.SObjectType.Form_Management_System__c.getRecordTypeInfosByName().get('Main Product Definition Form').getRecordTypeId());            
            insert formObj ;        

            Test.stopTest();  

            ApexPages.currentPage().getParameters().put('id',formObj.Id);              
            ApexPages.currentPage().getParameters().put('ParentId', formObj.id);
            ApexPages.currentPage().getParameters().put('tranx', 'Create');
            ApexPages.currentPage().getParameters().put('Type', 'SP');
            ApexPages.currentPage().getParameters().put('AccountId', acc.Id);

            FMSChildCreationController IMCext = new FMSChildCreationController(new ApexPages.StandardController(formObj));
            IMCext.getDMEAAccountList();
            IMCext.cancelRecord();   
            
            pageRef = new pagereference('/GlobalfoundryView/apex/FMSDDRFormPage');            
            Test.setCurrentPage(pageRef);   
            ApexPages.currentPage().getParameters().put('id',formObj.Id);              
            ApexPages.currentPage().getParameters().put('ParentId', formObj.id);
            ApexPages.currentPage().getParameters().put('tranx', 'Edit');
            ApexPages.currentPage().getParameters().put('Type', 'Main');
            ApexPages.currentPage().getParameters().put('AccountId', acc.Id);

            IMCext = new FMSChildCreationController(new ApexPages.StandardController(formObj));            
            IMCext.cancelRecord(); 
            
            pageRef = new pagereference('/GlobalfoundryView/apex/FMSDDRFormPage');            
            Test.setCurrentPage(pageRef);   
            ApexPages.currentPage().getParameters().put('id',formObj.Id);              
            ApexPages.currentPage().getParameters().put('ParentId', formObj.id);
            ApexPages.currentPage().getParameters().put('tranx', 'Edit');
            ApexPages.currentPage().getParameters().put('Type', 'IMC');
            ApexPages.currentPage().getParameters().put('AccountId', acc.Id);

            IMCext = new FMSChildCreationController(new ApexPages.StandardController(formObj));
            PageReference pr = IMCext.cancelRecord();

            System.assert(pr.getUrl().contains('/apex/FMSIMCFormViewPage?id='));
                           
        } 
    }
    
    
    static testMethod void testMethod26() {
        
        Account acc = getAccount('TEST rec');
        Contact con = getContact(acc.Id);

        PageReference pageRef = Page.FMSDeviceSelectionPage;            
        Test.setCurrentPage(pageRef);       
        
        User thisUser= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator'); 
        System.runAs(thisUser){
            Test.startTest();

            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;

            String oppId = DeviceChecklistTestDataUtils.createOpp(acc.Id);
            String oppProgId = DeviceChecklistTestDataUtils.createOppProg(acc.Id, oppId);
            Process__c p = DeviceChecklistTestDataUtils.createProcess();

            Device__c dev = createDevicePart(acc.Id,oppId,oppProgId,p.Id);   
            
            Form_Management_System__c formObj = new Form_Management_System__c(
                Customer_Name__c = acc.Id,
                Selected_Contact_Ids__c = con.Id+';'+con.Id,
                Name__c = 'Test Name',
                Form_Name__c = 'Test Main Form',                 
                Form_Description__c = 'Test Description', 
                RecordTypeId = Schema.SObjectType.Form_Management_System__c.getRecordTypeInfosByName().get('Main Product Definition Form').getRecordTypeId());            
            insert formObj ;        

            Test.stopTest();  
            
            
            pageRef = new pagereference('/GlobalfoundryView/apex/FMSDDRFormPage');            
            Test.setCurrentPage(pageRef);   
            ApexPages.currentPage().getParameters().put('id',formObj.Id);              
            ApexPages.currentPage().getParameters().put('ParentId', formObj.id);
            ApexPages.currentPage().getParameters().put('tranx', 'Edit');
            ApexPages.currentPage().getParameters().put('Type', 'SP');
            ApexPages.currentPage().getParameters().put('AccountId', acc.Id);

            FMSChildCreationController IMCext = new FMSChildCreationController(new ApexPages.StandardController(formObj));
            IMCext.cancelRecord();
            
            pageRef = new pagereference('/GlobalfoundryView/apex/FMSDDRFormPage');            
            Test.setCurrentPage(pageRef);   
            ApexPages.currentPage().getParameters().put('id',formObj.Id);              
            ApexPages.currentPage().getParameters().put('ParentId', formObj.id);
            ApexPages.currentPage().getParameters().put('tranx', 'Edit');
            ApexPages.currentPage().getParameters().put('Type', 'DDR');
            ApexPages.currentPage().getParameters().put('AccountId', acc.Id);

            IMCext = new FMSChildCreationController(new ApexPages.StandardController(formObj));
            IMCext.cancelRecord();
            
            pageRef = new pagereference('/GlobalfoundryView/apex/FMSDDRFormPage');            
            Test.setCurrentPage(pageRef);   
            ApexPages.currentPage().getParameters().put('id',formObj.Id);              
            ApexPages.currentPage().getParameters().put('ParentId', formObj.id);
            ApexPages.currentPage().getParameters().put('tranx', 'Edit');
            ApexPages.currentPage().getParameters().put('Type', 'RIT');
            ApexPages.currentPage().getParameters().put('AccountId', acc.Id);

            IMCext = new FMSChildCreationController(new ApexPages.StandardController(formObj));
            PageReference pr = IMCext.cancelRecord();

            System.assert(pr.getUrl().contains('/apex/FMSRITFormViewPage?id='));                         
        } 
    }
    
    
    static testMethod void testMethod24() {
        
        Account acc = getAccount('TEST rec');
        Contact con = getContact(acc.Id);

        PageReference pageRef = Page.FMSDeviceSelectionPage;            
        Test.setCurrentPage(pageRef);       
        
        User thisUser= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator'); 
        System.runAs(thisUser){
            Test.startTest();

            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;

            String oppId = DeviceChecklistTestDataUtils.createOpp(acc.Id);
            String oppProgId = DeviceChecklistTestDataUtils.createOppProg(acc.Id, oppId);
            Process__c p = DeviceChecklistTestDataUtils.createProcess();

            Device__c dev = createDevicePart(acc.Id,oppId,oppProgId,p.Id);   
            
            Form_Management_System__c formObj = new Form_Management_System__c(
                Customer_Name__c = acc.Id,
                Selected_Contact_Ids__c = con.Id+';'+con.Id,
                Name__c = 'Test Name',
                Form_Name__c = 'Test Main Form',                 
                Form_Description__c = 'Test Description', 
                RecordTypeId = Schema.SObjectType.Form_Management_System__c.getRecordTypeInfosByName().get('Main Product Definition Form').getRecordTypeId());            
            insert formObj ;        

            Test.stopTest();  

            ApexPages.currentPage().getParameters().put('id',formObj.Id);              
            ApexPages.currentPage().getParameters().put('ParentId', formObj.id);
            ApexPages.currentPage().getParameters().put('tranx', 'Create');
            ApexPages.currentPage().getParameters().put('Type', 'SP');
            ApexPages.currentPage().getParameters().put('AccountId', acc.Id);

            FMSChildCreationController IMCext = new FMSChildCreationController(new ApexPages.StandardController(formObj));
            IMCext.getDMEAAccountList();
            IMCext.cancelRecord();   
            
           
            
            //--
            pageRef = new pagereference('/GlobalfoundryView/apex/FMSDDRFormPage');            
            Test.setCurrentPage(pageRef);   
            ApexPages.currentPage().getParameters().put('id',formObj.Id);              
            ApexPages.currentPage().getParameters().put('ParentId', formObj.id);
            ApexPages.currentPage().getParameters().put('tranx', 'Edit');
            ApexPages.currentPage().getParameters().put('Type', 'Main');
            ApexPages.currentPage().getParameters().put('AccountId', acc.Id);

            IMCext = new FMSChildCreationController(new ApexPages.StandardController(formObj));   
            IMCext.formObj.Id = null; 
            PageReference pr = IMCext.cancelRecord();

            System.assert(pr.getUrl().contains('/apex/FMSmainFormViewPage?id=')); 
            
                                                                 
        } 
    }
    
    static testMethod void testMethod28() {
        
        Account acc = getAccount('TEST rec');
        Contact con = getContact(acc.Id);

        PageReference pageRef = Page.FMSDeviceSelectionPage;            
        Test.setCurrentPage(pageRef);       
        
        User thisUser= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator'); 
        System.runAs(thisUser){
            Test.startTest();

            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;

            String oppId = DeviceChecklistTestDataUtils.createOpp(acc.Id);
            String oppProgId = DeviceChecklistTestDataUtils.createOppProg(acc.Id, oppId);
            Process__c p = DeviceChecklistTestDataUtils.createProcess();

            Device__c dev = createDevicePart(acc.Id,oppId,oppProgId,p.Id);   
            
            Form_Management_System__c formObj = new Form_Management_System__c(
                Customer_Name__c = acc.Id,
                Selected_Contact_Ids__c = con.Id+';'+con.Id,
                Name__c = 'Test Name',
                Form_Name__c = 'Test Main Form',                 
                Form_Description__c = 'Test Description', 
                RecordTypeId = Schema.SObjectType.Form_Management_System__c.getRecordTypeInfosByName().get('Main Product Definition Form').getRecordTypeId());            
            insert formObj ;        

            Test.stopTest();  

            ApexPages.currentPage().getParameters().put('id',formObj.Id);              
            ApexPages.currentPage().getParameters().put('ParentId', formObj.id);
            ApexPages.currentPage().getParameters().put('tranx', 'Create');
            ApexPages.currentPage().getParameters().put('Type', 'SP');
            ApexPages.currentPage().getParameters().put('AccountId', acc.Id);

            FMSChildCreationController IMCext = new FMSChildCreationController(new ApexPages.StandardController(formObj));
            IMCext.getDMEAAccountList();
            IMCext.cancelRecord();   
            
           
            
            //--
            
            
           
            
            pageRef = new pagereference('/GlobalfoundryView/apex/FMSDDRFormPage');            
            Test.setCurrentPage(pageRef);   
            ApexPages.currentPage().getParameters().put('id',null);              
            ApexPages.currentPage().getParameters().put('ParentId', null);
            //ApexPages.currentPage().getParameters().put('tranx', 'Edit');
            ApexPages.currentPage().getParameters().put('Type', 'RIT');
            ApexPages.currentPage().getParameters().put('AccountId', acc.Id);

            IMCext = new FMSChildCreationController(new ApexPages.StandardController(formObj));
            IMCext.formObj.Id = null;
            IMCext.cancelRecord();
            
            pageRef = new pagereference('/apex/FMSDDRFormPage');            
            Test.setCurrentPage(pageRef);   
            ApexPages.currentPage().getParameters().put('id',null);              
            ApexPages.currentPage().getParameters().put('ParentId', null);
            //ApexPages.currentPage().getParameters().put('tranx', 'Edit');
            ApexPages.currentPage().getParameters().put('Type', 'RIT');
            ApexPages.currentPage().getParameters().put('AccountId', acc.Id);

            IMCext = new FMSChildCreationController(new ApexPages.StandardController(formObj));
            IMCext.formObj.Id = null;
            System.assertEquals(formObj.Id,null);  
            IMCext.cancelRecord();
                                    
        } 
    }
    
    
     public testMethod static void FMS_PortalUser_TestMethod() {
        Account acc;
        Contact con;
        FMS_Search_Filter__c srchFilter;
        User admin = [select id from user where profile.name='System Administrator' AND USerroleId !=NULL AND isActive =true limit 1];//DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(admin){
        
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = admin.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
            AcctRegHeadMappingTgrHandler.bypassAcctTrigger = true;
            TriggerHandler.bypass('Account_TriggerHandler');
            TriggerHandler.bypass('Contact_TriggerHandler');

            acc = getAccount('TEST rec');
         con = getContact(acc.Id);
         //con.Department__c = 'Design';
         //update con;
            
        }
        
        Profile portalProfile = [SELECT Id, Name FROM Profile where Name = 'Customer Portal Profile'
        Limit 1];
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None'
        and Name like '%Customer%'
        Limit 1];
        User portalUser1 = new User(Username = 'portaluser1@testorg13.com', Alias = 'auser', Email = 'portaluser1@testorg.com', EmailEncodingKey = 'UTF-8', Firstname = 'Bruce3', Lastname = 'Wayne4', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', TimeZoneSidKey = 'America/Chicago', ContactId = con.Id, IsActive = true, ProfileId = portalProfile.Id);
        insert portalUser1;
        List<PermissionSet> PersmissionsTemp = [SELECT Id,
                                                       Name, 
                                                       Label, 
                                                       ProfileId, 
                                                       Profile.Name 
                                                  FROM PermissionSet
                                                 WHERE Name = 'FMS_External_Users_All_License'];
        
                PermissionSetAssignment psa = new PermissionSetAssignment(AssigneeId = portalUser1.id, PermissionSetId = PersmissionsTemp[0].Id);
                insert psa;                                         
        Test.startTest();

            system.runAs(portalUser1) {
                 
                Form_Management_System__c formObj = new Form_Management_System__c(
                Customer_Name__c = acc.Id,
                Selected_Contact_Ids__c = con.Id+';'+con.Id,
                Name__c = 'Test Name',
                Form_Name__c = 'Test Main Form',                 
                Form_Description__c = 'Test Description', 
                RecordTypeId = Schema.SObjectType.Form_Management_System__c.getRecordTypeInfosByName().get('Main Product Definition Form').getRecordTypeId());            
            insert formObj ;       
            
            
            ApexPages.currentPage().getParameters().put('id',formObj.Id);              
            ApexPages.currentPage().getParameters().put('ParentId', formObj.id);
            ApexPages.currentPage().getParameters().put('tranx', 'Create');
            ApexPages.currentPage().getParameters().put('Type', 'Main');
            ApexPages.currentPage().getParameters().put('AccountId', acc.Id);

            FMSChildCreationController IMCext = new FMSChildCreationController(new ApexPages.StandardController(formObj)); 
            System.assertNotEquals(formObj.Id,null);  
        Test.stopTest();
        }  
    }
}