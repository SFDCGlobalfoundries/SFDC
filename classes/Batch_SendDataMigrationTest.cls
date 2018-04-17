@isTest
private class Batch_SendDataMigrationTest {
    
    @testSetup 
    static void init() {
        SwiftDataUtilityTest.customSystemData();
        MRS_Layer_Association_SWIFT_AINS_Test.initialData();
        delete [select id from MRS_Layer_Syncing_Status__c];
        delete [select id from MRS_Layer_Chip_Syncing_Status__c];
    }

    static testMethod void myUnitTest() {
        Test.startTest();        
        Batch_SendDataMigration b = new Batch_SendDataMigration();
        Database.executeBatch(b, 10);
        Test.stopTest();
    }
}