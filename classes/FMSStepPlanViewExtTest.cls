/*
 
 */
@isTest(SeeAllData = false)
public class FMSStepPlanViewExtTest {
    
    @future
    private static void setUpObject(){
        Group grp = new Group(Name = 'FMS Admin Group');
        insert grp;
        
        GroupMember grpMember = new GroupMember(GroupId = grp.Id, userOrGroupId= userInfo.getUserId());
        insert grpMember;
    }
      @testSetup
  static void testDataSetup(){
      DataUtilTest.loadEnvironmentVariables();  
  }
       @isTest
    static void testMethod1() {
        
        setUpObject();
        
        PageReference pref = Page.FMSStepPlanFormView;        
        Test.setCurrentPage(pref);
          User thisUser = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
            System.runAs(thisUser){
                IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
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
        Account account1 = AccountDataFactory.createAccount(fieldValueAccMap);  
        
        
        Map<String,Object> fieldValueAccMap2 = new Map<String,Object>();
        fieldValueAccMap2.put('Customer_Name__c', account1.id);
        fieldValueAccMap2.put('Form_Name__c', 'test');
        FMSDataFactory obk = new FMSDataFactory();
        Form_Management_System__c  fmsRec= FMSDataFactory.createFMSRecord(fieldValueAccMap2,FMSDataFactory.FormType.MAIN , true);
                
        Map<String,Object> fieldValueAccMap21 = new Map<String,Object>();
        fieldValueAccMap21.put('Customer_Name__c', account1.id);
        fieldValueAccMap21.put('Parent_Form_Id__c', fmsRec.id);
        fieldValueAccMap21.put('Main_Form_Id__c', fmsRec.id);
        
        fieldValueAccMap21.put('Form_Name__c', 'test');
        fieldValueAccMap21.put('PrelimOrFinal__c', 'Preliminary');
        Form_Management_System__c  fmsRec2= FMSDataFactory.createFMSRecord(fieldValueAccMap21,FMSDataFactory.FormType.SP, true);
        
        Attachment att1 = new Attachment(parentId = fmsRec.Id, Name = 'Test Attachment', body = Blob.valueOf('Test Body'));
        insert att1;
        
        Attachment att2 = new Attachment(parentId = fmsRec.Id, Name = 'Test Attachment', body = Blob.valueOf('Test Body'));
        insert att2;
        
        pref.getParameters().put('id',fmsRec2.id);
        
        ApexPages.StandardController con = new ApexPages.StandardController(fmsRec2);        

        FMSStepPlanViewExt fmsExt = new FMSStepPlanViewExt(con);
        Test.StartTest();
        fmsExt.webRDTSActive ='TRUE';
        fmsExt.webRDTSActive ='TRUE';
        fmsExt.getFormId();
        fmsExt.unlckStpPlan();
        fmsExt.requnlckStpPlan();
      
        fmsExt.spComplete();
        fmsExt.requnck = false ; 
        fmsExt.conUnlcPlan();
        fmsExt.stateChangeComments = 'test comment';
        fmsExt.conUnlcPlan();
       
        fmsExt.closePopup();
        fmsExt.editForm();
        
        fmsExt.viewPdf();

        fmsExt.updateFormDetails();
        fmsExt.Subscribe();
        fmsExt.UnSubscribe();
        fmsExt.SubscribeUser();
        fmsExt.chngHistory();
        fmsExt.deleteForm();
        
        System.assertEquals(fmsRec2.Main_Form_Id__c, fmsRec.id);
        Test.StopTest();
    }
    }
       @isTest
    static void testMethod2() {
        setUpObject();
        
        
        PageReference pref = Page.FMSStepPlanFormView;        
        Test.setCurrentPage(pref);
          User thisUser = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
            System.runAs(thisUser){
                IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
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
        Account account1 = AccountDataFactory.createAccount(fieldValueAccMap);  
        
        
        Map<String,Object> fieldValueAccMap2 = new Map<String,Object>();
        fieldValueAccMap2.put('Customer_Name__c', account1.id);
        fieldValueAccMap2.put('Form_Name__c', 'test');
        FMSDataFactory obk = new FMSDataFactory();
        Form_Management_System__c  fmsRec= FMSDataFactory.createFMSRecord(fieldValueAccMap2,FMSDataFactory.FormType.MAIN , true);
                
        
        Map<String,Object> fieldValueAccMap21 = new Map<String,Object>();
        fieldValueAccMap21.put('Customer_Name__c', account1.id);
        fieldValueAccMap21.put('Parent_Form_Id__c', fmsRec.id);
        fieldValueAccMap21.put('Main_Form_Id__c', fmsRec.id);
        
        fieldValueAccMap21.put('PrelimOrFinal__c', 'Preliminary');
        fieldValueAccMap21.put('Form_Name__c', 'test');
        fieldValueAccMap21.put('Selection__c', 'Approve Preliminary Step Plan');
        
         fieldValueAccMap21.put('UniqueWebRDTSId__c', '123'); 
        fieldValueAccMap21.put('RejectionReason__c', '');
        
        
        fieldValueAccMap21.put('Main_Form_Id__c', fmsRec.id);
        
        fieldValueAccMap21.put('Form_Name__c', 'test');
        
        
        Form_Management_System__c  fmsRec2= FMSDataFactory.createFMSRecord(fieldValueAccMap21,FMSDataFactory.FormType.SP, true);
        
        
        
        Attachment att1 = new Attachment(parentId = fmsRec2.Id, Name = 'Test Attachment', body = Blob.valueOf('Test Body'));
        insert att1;
        
        Attachment att2 = new Attachment(parentId = fmsRec2.Id, Name = 'Test Attachment', body = Blob.valueOf('Test Body'));
        insert att2;
        
        pref.getParameters().put('id',fmsRec2.id);
        
        ApexPages.StandardController con = new ApexPages.StandardController(fmsRec2);        

        FMSStepPlanViewExt fmsExt = new FMSStepPlanViewExt(con);
        Test.StartTest();
        fmsExt.webRDTSActive ='TRUE';
        fmsExt.getFormId();
           FMSDropServiceStepPlanDetails_API dropAPI = new FMSDropServiceStepPlanDetails_API();
            Test.setMock(HttpCalloutMock.class, new FMSMockHttpResponseGenerator());
            dropAPI.FMSStepPlaApproval_API(1111, '2222', '200', 'Test Approval');
            FMSDropServiceStepPlanDetails_API.GetTechnologyDefault('BiCMOS 5PAe (SiGe 5PAe)');
            FMSDropServiceStepPlanDetails_API.Dropbox dropbx = new FMSDropServiceStepPlanDetails_API.Dropbox();
            FMSDropServiceStepPlanDetails_API.Data dt = new FMSDropServiceStepPlanDetails_API.Data();
            FMSDropServiceStepPlanDetails_API.Packages_to_user pkgUsr = new FMSDropServiceStepPlanDetails_API.Packages_to_user();
            FMSDropServiceStepPlanDetails_API.Packages pkg = new FMSDropServiceStepPlanDetails_API.Packages();
            FMSDropServiceStepPlanDetails_API.File file = new FMSDropServiceStepPlanDetails_API.File();
        
        
        fmsExt.updateFormDetailApprove();
        fmsExt.updateFormDetailReject();

        fmsExt.viewPdf();
        
         System.assertEquals(fmsRec2.Selection__c, 'Approve Preliminary Step Plan');
         
        Test.StopTest();
    }
    }
    
         @isTest  
      static void testMethod3() {
        setUpObject();
             
        PageReference pref = Page.FMSStepPlanFormView;        
        Test.setCurrentPage(pref);
          User thisUser = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
            System.runAs(thisUser){
                IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
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
        Account account1 = AccountDataFactory.createAccount(fieldValueAccMap);  
        ApexPages.currentPage().getHeaders().put('Referer','GlobalfoundryView');
        
        Map<String,Object> fieldValueAccMap2 = new Map<String,Object>();
        fieldValueAccMap2.put('Customer_Name__c', account1.id);
        fieldValueAccMap2.put('Form_Name__c', 'test');
        FMSDataFactory obk = new FMSDataFactory();
        Form_Management_System__c  fmsRec= FMSDataFactory.createFMSRecord(fieldValueAccMap2,FMSDataFactory.FormType.MAIN , true);
        
        
        Map<String,Object> fieldValueAccMap21 = new Map<String,Object>();
        fieldValueAccMap21.put('Customer_Name__c', account1.id);
        fieldValueAccMap21.put('Parent_Form_Id__c', fmsRec.id);
        fieldValueAccMap21.put('Main_Form_Id__c', fmsRec.id);
        fieldValueAccMap21.put('Selection__c','Reject Preliminary Step Plan' ); 
        fieldValueAccMap21.put('RejectionReason__c','tst' );
       // fieldValueAccMap21.put('UniqueWebRDTSId__c', '123'); 
        fieldValueAccMap21.put('Form_Name__c', 'test');
        
        Form_Management_System__c  fmsRec2= FMSDataFactory.createFMSRecord(fieldValueAccMap21,FMSDataFactory.FormType.SP, true);
        
        
        Attachment att1 = new Attachment(parentId = fmsRec.Id, Name = 'Test Attachment', body = Blob.valueOf('Test Body'));
        insert att1;
        
        Attachment att2 = new Attachment(parentId = fmsRec.Id, Name = 'Test Attachment', body = Blob.valueOf('Test Body'));
        insert att2;
        
        pref.getParameters().put('id',fmsRec2.id);
        
        ApexPages.StandardController con = new ApexPages.StandardController(fmsRec2);        

        FMSStepPlanViewExt fmsExt = new FMSStepPlanViewExt(con);
        Test.StartTest();

        fmsExt.getFormId();
         FMSDropServiceStepPlanDetails_API dropAPI = new FMSDropServiceStepPlanDetails_API();
            Test.setMock(HttpCalloutMock.class, new FMSMockHttpResponseGenerator());
            dropAPI.FMSStepPlaApproval_API(1111, '2222', '200', 'Test Approval');
            FMSDropServiceStepPlanDetails_API.GetTechnologyDefault('BiCMOS 5PAe (SiGe 5PAe)');
            FMSDropServiceStepPlanDetails_API.Dropbox dropbx = new FMSDropServiceStepPlanDetails_API.Dropbox();
            FMSDropServiceStepPlanDetails_API.Data dt = new FMSDropServiceStepPlanDetails_API.Data();
            FMSDropServiceStepPlanDetails_API.Packages_to_user pkgUsr = new FMSDropServiceStepPlanDetails_API.Packages_to_user();
            FMSDropServiceStepPlanDetails_API.Packages pkg = new FMSDropServiceStepPlanDetails_API.Packages();
            FMSDropServiceStepPlanDetails_API.File file = new FMSDropServiceStepPlanDetails_API.File();
        
        fmsExt.updateFormDetailApprove(); 
        fmsExt.updateFormDetailReject();
        fmsExt.requnck = true;
       
        fmsExt.conUnlcPlan(); 
        fmsExt.formSelection(); //Parent_Form_Id__c not queried
        fmsExt.viewPdf();
        
        System.assertEquals(fmsRec2.Selection__c, 'Reject Preliminary Step Plan' );

        Test.StopTest();
    }
    }
    
    
     @isTest  
      static void testMethod4() {
        setUpObject();
             
        PageReference pref = Page.FMSStepPlanFormView;        
        Test.setCurrentPage(pref);
          User thisUser = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
            System.runAs(thisUser){
                IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
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
        Account account1 = AccountDataFactory.createAccount(fieldValueAccMap);  
        
        
        Map<String,Object> fieldValueAccMap2 = new Map<String,Object>();
        fieldValueAccMap2.put('Customer_Name__c', account1.id);
        fieldValueAccMap2.put('Form_Name__c', 'test');
        FMSDataFactory obk = new FMSDataFactory();
        Form_Management_System__c  fmsRec= FMSDataFactory.createFMSRecord(fieldValueAccMap2,FMSDataFactory.FormType.MAIN , true);
        
        
        Map<String,Object> fieldValueAccMap21 = new Map<String,Object>();
        fieldValueAccMap21.put('Customer_Name__c', account1.id);
        fieldValueAccMap21.put('Parent_Form_Id__c', fmsRec.id);
        fieldValueAccMap21.put('Main_Form_Id__c', fmsRec.id);
        fieldValueAccMap21.put('Selection__c','Reject Preliminary Step Plan' ); 
        fieldValueAccMap21.put('RejectionReason__c','tst' );
       // fieldValueAccMap21.put('UniqueWebRDTSId__c', '123'); 
        fieldValueAccMap21.put('Form_Name__c', 'test');
        
        Form_Management_System__c  fmsRec2= FMSDataFactory.createFMSRecord(fieldValueAccMap21,FMSDataFactory.FormType.SP, true);
        
        
       
        
        pref.getParameters().put('id',fmsRec2.id);
        
        ApexPages.StandardController con = new ApexPages.StandardController(fmsRec2);        

        FMSStepPlanViewExt fmsExt = new FMSStepPlanViewExt(con);
        Test.StartTest();
       boolean bool = fmsExt.hasChildren;
       String str = fmsExt.rvdbyName;
       fmsExt.SubscribeUser();
       
        System.assertEquals(fmsRec2.Customer_Name__c,account1.id); 
        
        Test.StopTest();
    }
    }
    
    }