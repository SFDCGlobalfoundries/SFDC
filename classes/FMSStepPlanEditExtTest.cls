/*
 
 */
@isTest(SeeAllData = false)
public class FMSStepPlanEditExtTest {
    
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
    
    static testMethod void testMethod1() {
        setUpObject();
        
        PageReference pref = Page.FMSStepPlanEditForm;        
        Test.setCurrentPage(pref);
        
        Form_Management_System__c fmsRec = new Form_Management_System__c();
        fmsRec.Selection__c = 'Reject Preliminary Step Plan';
        fmsRec.RejectionReason__c = 'Other';
        fmsRec.Form_Name__c = 'testForm';
        fmsRec.RecordTypeId = Schema.SObjectType.Form_Management_System__c.getRecordTypeInfosByName().get('Main Product Definition Form').getRecordTypeId();
        fmsRec.UniqueWebRDTSId__c = 'temp';
        insert fmsRec;
        
        Form_Management_System__c fmsRec2 = new Form_Management_System__c();
        fmsRec2.Selection__c = 'Reject Preliminary Step Plan';
        fmsRec2.RejectionReason__c = '';
        fmsRec2.Form_Name__c = 'testForm';
        fmsRec2.Main_Form_Id__c = fmsRec.id;
        fmsRec2.RecordTypeId = Schema.SObjectType.Form_Management_System__c.getRecordTypeInfosByName().get('Step Plan Approval (SP)').getRecordTypeId();
        fmsRec2.UniqueWebRDTSId__c = 'temp';
        insert fmsRec2;
        
        Attachment att1 = new Attachment(parentId = fmsRec.Id, Name = 'Test Attachment', body = Blob.valueOf('Test Body'));
        insert att1;
        
        Attachment att2 = new Attachment(parentId = fmsRec.Id, Name = 'Test Attachment', body = Blob.valueOf('Test Body'));
        insert att2;
        
        pref.getParameters().put('id',fmsRec2.id);
        
        ApexPages.StandardController con = new ApexPages.StandardController(fmsRec);        

        FMSStepPlanEditExt fmsExt = new FMSStepPlanEditExt(con);
        Test.StartTest();
        
        fmsExt.getFormId();        
        fmsExt.Selectionval = 'Reject Preliminary Step Plan';
        fmsExt.displResnBox();        
        fmsExt.Selectionval = 'Approve Preliminary Step Plan';
        fmsExt.displResnBox();        
        fmsExt.save();        
        fmsExt.validateSave();
        fmsExt.cancel();
        
        Test.StopTest();
    }
    
    static testMethod void testMethod2() {
        setUpObject();
        
        PageReference pref = Page.FMSStepPlanEditForm;        
        Test.setCurrentPage(pref);
        
        Form_Management_System__c fmsRec = new Form_Management_System__c();
        fmsRec.Selection__c = 'Reject Preliminary Step Plan';
        fmsRec.RejectionReason__c = 'Other';
        fmsRec.Form_Name__c = 'testForm';
       
       fmsRec.RecordTypeId = Schema.SObjectType.Form_Management_System__c.getRecordTypeInfosByName().get('Main Product Definition Form').getRecordTypeId();
        fmsRec.UniqueWebRDTSId__c = 'temp';
        insert fmsRec;
        
        Form_Management_System__c fmsRec2 = new Form_Management_System__c();
        fmsRec2.Selection__c = 'Reject Preliminary Step Plan';
        fmsRec2.RejectionReason__c = '';
        fmsRec2.Form_Name__c = 'testForm';
        fmsRec2.Main_Form_Id__c = fmsRec.id;
     
        fmsRec2.RecordTypeId = Schema.SObjectType.Form_Management_System__c.getRecordTypeInfosByName().get('Step Plan Approval (SP)').getRecordTypeId();
        fmsRec2.UniqueWebRDTSId__c = 'temp';
        insert fmsRec2;
        
        Attachment att1 = new Attachment(parentId = fmsRec2.Id, Name = 'Test Attachment', body = Blob.valueOf('Test Body'));
        insert att1;
        
        Attachment att2 = new Attachment(parentId = fmsRec2.Id, Name = 'Test Attachment', body = Blob.valueOf('Test Body'));
        insert att2;
        
        pref.getParameters().put('id',fmsRec2.id);
        
        ApexPages.StandardController con = new ApexPages.StandardController(fmsRec);        

        FMSStepPlanEditExt fmsExt = new FMSStepPlanEditExt(con);
        
        Test.StartTest(); 
               
        fmsExt.save(); 
        fmsExt.Selectionval  = '=== Select a Value ===';     
        fmsExt.saveandExit();        
        
        Test.StopTest();
        
    }
    
        static testMethod void testMethod3() {
        setUpObject();
        
        PageReference pref = Page.FMSStepPlanEditForm;        
        Test.setCurrentPage(pref);
        
        Form_Management_System__c fmsRec = new Form_Management_System__c();
        fmsRec.Selection__c = 'Reject Preliminary Step Plan';
        fmsRec.RejectionReason__c = 'Other';
        fmsRec.Form_Name__c = 'testForm';
       
       fmsRec.RecordTypeId = Schema.SObjectType.Form_Management_System__c.getRecordTypeInfosByName().get('Main Product Definition Form').getRecordTypeId();
        fmsRec.UniqueWebRDTSId__c = 'temp';
        insert fmsRec;
        
        Form_Management_System__c fmsRec2 = new Form_Management_System__c();
        fmsRec2.Selection__c = 'Reject Preliminary Step Plan';
        fmsRec2.RejectionReason__c = 'tst';
        fmsRec2.Form_Name__c = 'testForm';
        fmsRec2.Main_Form_Id__c = fmsRec.id;
     
        fmsRec2.RecordTypeId = Schema.SObjectType.Form_Management_System__c.getRecordTypeInfosByName().get('Step Plan Approval (SP)').getRecordTypeId();
        fmsRec2.UniqueWebRDTSId__c = 'temp';
        insert fmsRec2;
        
        Attachment att1 = new Attachment(parentId = fmsRec2.Id, Name = 'Test Attachment', body = Blob.valueOf('Test Body'));
        insert att1;
        
        Attachment att2 = new Attachment(parentId = fmsRec2.Id, Name = 'Test Attachment', body = Blob.valueOf('Test Body'));
        insert att2;
        
        pref.getParameters().put('id',fmsRec2.id);
        
        ApexPages.StandardController con = new ApexPages.StandardController(fmsRec);        

        FMSStepPlanEditExt fmsExt = new FMSStepPlanEditExt(con);
        
        Test.StartTest(); 
               
        fmsExt.save(); 
        fmsExt.Selectionval  = '=== Select a Value ===';     
        fmsExt.saveandExit();        
        
        Test.StopTest();
        
    }
    
     static testMethod void testMethod4() {
        setUpObject();
        
        PageReference pref = Page.FMSStepPlanEditForm;        
        Test.setCurrentPage(pref);
        
        Form_Management_System__c fmsRec = new Form_Management_System__c();
        fmsRec.Selection__c = 'Reject Preliminary Step Plan';
        fmsRec.RejectionReason__c = 'Other';
        fmsRec.Form_Name__c = 'testForm';
       
       fmsRec.RecordTypeId = Schema.SObjectType.Form_Management_System__c.getRecordTypeInfosByName().get('Main Product Definition Form').getRecordTypeId();
        fmsRec.UniqueWebRDTSId__c = 'temp';
        insert fmsRec;
        
        Form_Management_System__c fmsRec2 = new Form_Management_System__c();
        fmsRec2.Selection__c = 'Reject Preliminary Step Plan';
        fmsRec2.RejectionReason__c = 'tst';
        fmsRec2.Form_Name__c = 'testForm';
        fmsRec2.Main_Form_Id__c = fmsRec.id;
     
        fmsRec2.RecordTypeId = Schema.SObjectType.Form_Management_System__c.getRecordTypeInfosByName().get('Step Plan Approval (SP)').getRecordTypeId();
        fmsRec2.UniqueWebRDTSId__c = 'temp';
        insert fmsRec2;
        
      
        
        pref.getParameters().put('id',fmsRec2.id);
        
        ApexPages.StandardController con = new ApexPages.StandardController(fmsRec);        

        FMSStepPlanEditExt fmsExt = new FMSStepPlanEditExt(con);
        
        Test.StartTest(); 
        boolean b1 = fmsExt.hasChildren;
        boolean b2 = fmsExt.popupVal;
        string com = fmsExt.stateChangeComments;
        fmsExt.escape = true;       
        fmsExt.save(); 
             
        
        Test.StopTest();
        
    }
    
}