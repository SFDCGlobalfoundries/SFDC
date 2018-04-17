@isTest
private class AccessSetupHistorySchedulerTest {
    static testmethod void deleteAccessSetUpRecords() {
      Test.StartTest();
           AccessSetupHistoryTracking__c a = new AccessSetupHistoryTracking__c();
           a.apiName__c = 'test';
           a.name__c = 'test';
           a.OldValue__c = 'Old';
           a.NewValue__c = 'New';
       		insert a;
            Access_Setup_History_InMonths__c acc = new Access_Setup_History_InMonths__c();
            acc.Name = 'MonthsLimit';
            acc.Months__c = 12;
            insert acc;

     	AccessSetupHistoryDeleteBatch sh1 = new AccessSetupHistoryDeleteBatch();      
     	String sch = '0 0 * * * ?';
        system.schedule('Test1', sch, sh1);
        List<AccessSetupHistoryTracking__c> objectList = new List<AccessSetupHistoryTracking__c>(); 
        Test.stopTest();
   }
}