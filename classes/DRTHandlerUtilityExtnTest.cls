/**
 * Created Date: 24-Oct-2016
 * By: Swift TEAM
 *
 */
@isTest
private class DRTHandlerUtilityExtnTest {
    
    @testSetup
    static void setupTestData() {
        initialData();
    }

    static testMethod void test_getLayerUniqueIdentifier() {
        DRT__c objDRTDetail = [select id,Tech_Geo__c,Mask_Set_Title__c from drt__c limit 1];
        DRTHandlerUtilityExtn.getLayerUniqueIdentifier(objDRTDetail, 'LV', 'AZ', '123');
    }
    
    public static void initialData() {
        Mask_Set_Title__c mst = SwiftDataUtilityTest.createMST( 'ZIN789');
        insert mst;
        
        DRT__c drt1 = new DRT__c( Name='testFrame', Synced_with_Oracle_DB__c=false, DRT_Package_Sync__c=false, Status__c='Active', Mask_Set_Title__c = mst.Id, Tech_Geo__c = '0.028UM' );          
        insert drt1;
    }
}