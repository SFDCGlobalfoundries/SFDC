/*
*    Author: Sreedhar Karukonda
*    Description:  This class iis used to test CustomerItemsTriggerHandler
*    History: 
*    skarukon      09/22/2015    - Apex code created    
*/
@isTest
private class CustomerItemsTriggerHandlerTest {
    
        //Test data creation
    @testSetup
    private static void createTestDate(){
        DataUtilTest.loadEnvironmentVariables();
        Account account1 = DevicePEOLTestsData.createAccount('account1', '12345');
        ERP_Device__c device123456 = DevicePEOLTestsData.createERPDevice('123456', 'FAB 6;FAB 8');
    }

    @isTest static void createPEOLReuest() {
        Customer_Item__c item = DevicePEOLTestsData.createCustomerItems('123456', new LIST<String>{'account1'})[0];
        Customer_Item__c queriedItem = [select Id, Name, Customer__c, ERP_Device__c from Customer_Item__c where id=: item.Id];
        System.assertNotEquals(null, queriedItem.Customer__c);
        System.assertNotEquals(null, queriedItem.ERP_Device__c);
    }
    
    
    
    @isTest static void createCustomerItemWithError() {
         ERP_Device__c device = new ERP_Device__c(
            name = 'd1',
            fab__c = 'FAB 6;FAB 8',
            geometry__c = '0.028UM',
            Part_Number__c = '1'        
        );
        insert device;
        ERP_Device_Required_Fields__c reqField = new ERP_Device_Required_Fields__c(Name='Customer__c', Message__c='Part Number (MATERIAL) is Required.', SObject__c='Customer_Item__c');
        insert reqField;
        Customer_Item__c item = new Customer_Item__c(MD_Part_Number__c='1', Sold_To__c='123132323', Sales_Org__c='123456');
        insert item;
        
        
        Customer_Item__c queriedItem = [select Id, Name, Integrity_Error_Flag__c, Integrity_Error__c from Customer_Item__c where id=: item.Id];
        System.assertEquals(true, queriedItem.Integrity_Error_Flag__c);
        System.assertNotEquals(null, queriedItem.Integrity_Error__c);
    }
    
}