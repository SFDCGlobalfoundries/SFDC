/*
    Author: Harsha Vardhan
    Company: Cognizant
    Project: DRC/DFM Application
    Description: This class is used as test class for BatchFabgroupShare and BatchFabgroupShareScheduler

    History: Harsha:05/01/17
**/ 
@isTest(SeeAllData=False)

private class BatchFabgroupShareTest {

  
  static testMethod void Waiverapprovelist_Test()
  {
        Test.startTest();
        
        Wavier_Collaborator__c waiverColl = new Wavier_Collaborator__c();
        waiverColl.Metal_Stacks__c = 'Test Metal Stack';
        waiverColl.FAB__c = 'FAB 7';
        waiverColl.Account_Short_Name__c = 'testacc';
        waiverColl.PTSR_Service_Type__c = 'DFM Service Request';
        waiverColl.isAllPartyApproved__c = false;
        waiverColl.Is_releasedToCustomer__c = true;
        waiverColl.Progressbar_staus__c='Pending for FAE';
        insert waiverColl;
    
     BatchFabgroupShare batchObj = new BatchFabgroupShare();
     ID batchprocessid = Database.executeBatch(batchObj);
     //System.abortJob(batchprocessid);
      Test.Stoptest();
  }
    static testMethod void myAutoSchMethod() {
        
        String sch = '0 0 09 * * ?';
        
        Test.startTest();
        
        BatchFabgroupShareScheduler m = new BatchFabgroupShareScheduler();
        String jobID = system.schedule('Email Job1', sch, m);
        
        Test.stopTest();      
    }
}