/*
    @Author :- Suhas Bargi
*/
@isTest
private class DRCReminderResponseRequiredSchedulerTest {
    
     
     @testSetup static void testdata() { 
       // DataUtilTest.loadEnvironmentVariables();  
    }
    
    
        static testMethod void myAutoEmailBatchMethod() {
             List<Waiver_Rule_List__c> waiverList = new  List<Waiver_Rule_List__c>();
          Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaboratorDRCService();
            DesignCollaboratorTestData.getWaiverRuleListForFDCCWCR(waiverColl.Id);
            
         waiverList=DesignCollaboratorTestData.getWaiverRuleList(waiverColl.Id);
          //created a new method   getWaiverRuleList1
          
            
         Database.BatchableContext bc;
         DRCReminderResponseRequiredBatch waiver = new DRCReminderResponseRequiredBatch('waiverList','Waiver_Rule_List__c');
      Test.startTest();  
         waiver.execute(bc,waiverList);
        
      Test.stopTest();  
     }
     static testMethod void myAutoEmailBatchMethod1() {
             List<Waiver_Rule_List__c> waiverList = new  List<Waiver_Rule_List__c>();
          Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaboratorDRCService();
            DesignCollaboratorTestData.getWaiverRuleListForFDCCWCR(waiverColl.Id);
          list<Wavier_Collaborator__c> waiverCollList=[Select id,Name,Account_Name__c,Progressbar_staus__c,Account_Short_Name__c,PTSR_Service_Type__c,isReleaseToCust4MultiDie__c,Mask_Set_Title__c,DRCServiceoption__c,CollaboratorClosedMail__c,MantisIds__c,PTSR_Number__c,PTSR_Status__c,Cancellation_Reason__c,DFM_Transaction_Id__c  from Wavier_Collaborator__c];                   
          waiverCollList.get(0).CollaboratorClosedMail__c=false;
          waiverCollList.get(0).isReleaseToCust4MultiDie__c= true;
         update waiverCollList;
         waiverList=DesignCollaboratorTestData.getWaiverRuleList(waiverColl.Id);
          //created a new method   getWaiverRuleList1
          
            
         Database.BatchableContext bc;
         DRCReminderResponseRequiredBatch waiver = new DRCReminderResponseRequiredBatch('waiverCollList','Wavier_Collaborator__c');
      Test.startTest();  
         waiver.execute(bc,waiverCollList);
        
      Test.stopTest();  
     }

    static testMethod void myAutoEmailSchMethod() {
        
        String sch = '0 0 09 * * ?';
        
        Test.startTest();
        
        DRCReminderResponseRequiredScheduler m = new DRCReminderResponseRequiredScheduler();
        String jobID = system.schedule('Email Job1', sch, m);
        
        Test.stopTest();      
    }
}