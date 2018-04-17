@isTest
public class RetryMRSDRTBatchableTest2 {

    @istest(SeeAllData = false)
    static void RetyFabDistriSyncOracleBatchableEmailUnitTest() {
        RetryMRSDRTBatchableTest.CreateRetryMRSDRT();
        
        RetyFabDistriSyncOracleBatchable reassign = new RetyFabDistriSyncOracleBatchable();
        reassign.Query = 'SELECT Id, Name FROM Fab_Distribution_Table__c WHERE Synced_with_Oracle_DB__c = false AND LastModifieddate > Today';
        reassign.Field = 'Trigger_Oracle_DB_Sync_Manual__c';
        reassign.Value = false;
        
        Test.StartTest();
        ID batchprocessid = Database.executeBatch(reassign);
        Test.StopTest();
    }
    
    @istest(SeeAllData = false)
    static void RetryDRTpackageSyncOracleBatchableEmailUnitTest() {
        RetryMRSDRTBatchableTest.CreateRetryMRSDRT();
        
        RetryDRTpackageSyncOracleBatchable reassign = new RetryDRTpackageSyncOracleBatchable();
        reassign.Query = 'SELECT Id, Name FROM DRT__c WHERE DRT_Package_Sync__c=TRUE and Synced_with_Oracle_DB__c = false AND LastModifiedDate > TODAY';
        reassign.Field = 'Trigger_Oracle_DB_FullPackageSync_Manual__c';
        reassign.Value = false;
        Test.StartTest();
        ID batchprocessid = Database.executeBatch(reassign);
        Test.StopTest();
    }
    
    @istest(SeeAllData = false)
    static void testDRTEmailNotification() {
        DRTSyncEmailNotification drt = new DRTSyncEmailNotification();
        drt.mthdDummy();
    }
    
    @istest(SeeAllData = false)
    static void testMRSEmailNotification() {
        MRSSyncEmailNotification mrs = new MRSSyncEmailNotification();
        mrs.mthdDummy();
    }
}