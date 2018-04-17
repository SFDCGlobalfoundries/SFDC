/*
	@Author :- Suhas Bargi
*/
@isTest
private class DRCCustEMailNotifiyBatchSchedulerTest {
    
     @testSetup static void testdata() { 
        DataUtilTest.loadEnvironmentVariables();  
    }
    
        static testMethod void myAutoEmailBatchMethod() {
             List<Wavier_Collaborator__c> waiverList = new  List<Wavier_Collaborator__c>();
          Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaboratorDRCService();
                 
         waiverList.add(waiverColl);
            
          Wavier_Collaborator__c  waiverColl1 = DesignCollaboratorTestData.getWaiverCollaboratorDRCService();
                   
         waiverList.add(waiverColl1);
            
         Database.BatchableContext bc;
         DRCReleaseToCustEMailNotifiyBatch waiver = new DRCReleaseToCustEMailNotifiyBatch();
      Test.startTest();  
         waiver.execute(bc, waiverList);
        
      Test.stopTest();  
     }

    static testMethod void myAutoEmailSchMethod() {
        
        String sch = '0 0 09 * * ?';
        
        Test.startTest();
        
        DRCCustEMailNotifiyBatchScheduler m = new DRCCustEMailNotifiyBatchScheduler();
        String jobID = system.schedule('Email Job1', sch, m);
        
        Test.stopTest();      
    }
}