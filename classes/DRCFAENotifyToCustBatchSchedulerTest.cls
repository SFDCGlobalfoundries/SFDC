/*
	@Author :- Suhas Bargi
*/
@isTest
private class DRCFAENotifyToCustBatchSchedulerTest {
    
    @testSetup static void testdata() { 
        DataUtilTest.loadEnvironmentVariables(); 
    }
    
     static testMethod void myAutoEmailBatchMethod() {
          Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaboratorDFMService();
         List<Waiver_Rule_List__c> waiverRuleList = DesignCollaboratorTestData.getWaiverRuleList1(waiverColl.Id);
         Database.BatchableContext bc;
         DRCFAENotifyToCustDiscussionBatch waiver = new DRCFAENotifyToCustDiscussionBatch();
     	 Test.startTest();         
         waiver.execute(bc, waiverRuleList); 
      Test.stopTest();  
     }
	static testMethod void myAutoEmailBatchMethod1() {
          Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaboratorDRCService();
         List<Waiver_Rule_List__c> waiverRuleList = DesignCollaboratorTestData.getWaiverRuleList1(waiverColl.Id);
         Database.BatchableContext bc;
         DRCFAENotifyToCustDiscussionBatch waiver = new DRCFAENotifyToCustDiscussionBatch();
     	 Test.startTest();         
         waiver.execute(bc, waiverRuleList); 
      Test.stopTest();  
     }
    static testMethod void myAutoEmailSchMethod() {  
        
        String sch = '0 0 09 * * ?';
         
        Test.startTest();
        
        DRCFAENotifyToCustBatchScheduler m = new DRCFAENotifyToCustBatchScheduler();
        String jobID = system.schedule('Email Job2', sch, m);
        
        Test.stopTest();      
    }
    
    
}