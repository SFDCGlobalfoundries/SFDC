/**
*  Author: Sreedhar Karukonda
*  Description: DevicePEOLRequestDetailsTriggerHandlrTst  is Test case for DevicePEOLRequestDetailsTriggerHandler class.
* History:
*   Sreedhar Karukonda         15102015    - code creation.
**/

@isTest
private class DevicePEOLRequestDetailsTriggerHandlrTst {
    //Test data creation
    @testSetup
    private static void createTestDate(){
        DataUtilTest.loadEnvironmentVariables();
        User user1 = DevicePEOLTestsData.createUser('System Administrator', 'PCSR'); // PRIMARY CSR
        User user2 = DevicePEOLTestsData.createUser('System Administrator', 'BCSR'); // Backup CSR
        User user3 = DevicePEOLTestsData.createUser('System Administrator','AM');  // Account Manager
        Test.startTest();
        Account account1 = DevicePEOLTestsData.createAccount('account1','12345');
        ERP_Device__c device123456 = DevicePEOLTestsData.createERPDevice('123456', 'FAB 6;FAB 8');
        ERP_Device__c device123457 = DevicePEOLTestsData.createERPDevice('123457', 'FAB 7;FAB 8');

        List<Customer_Item__c> items = new  List<Customer_Item__c>{
                new Customer_Item__c(ERP_Device__c=device123456.Id, Customer__c= account1.Id),
                new Customer_Item__c(ERP_Device__c=device123457.Id, Customer__c= account1.Id)
            };
        insert items;

        DevicePEOLTestsData.createAccountTeam(account1, new LIST<String>{'Backup Customer Service Rep','Primary Customer Service Rep'}, new LIST<User>{user1, user2});
        Test.stopTest();
    }

    @isTest static void successTest() {
        Account account1 = [SELECT Id, Name, Account_Manager__c FROM Account where Short_Name__c = 'account1'];
        User accountManager = [SELECT Id, Name FROM User where firstName = 'AM'];
        User pcsr = [SELECT Id, Name FROM User where firstName = 'PCSR'];
        account1.Account_Manager__c = accountManager.id;
        update account1;

        List<ERP_Device__c> devices = [SELECT Id, Name, Geometry__c, ERP_Inventory_Id__c  FROM ERP_Device__c ORDER BY ERP_Inventory_Id__c asc ];
        System.assertEquals(2, devices.size(), 'There should be 2 Devies');
        Device_PEOL_Request__c peolRequest = new Device_PEOL_Request__c(Customer__c=account1.Id);
        insert peolRequest;
        
        List<Customer_Item__c> customerItems = [SELECT Id, Name FROM Customer_Item__c ORDER BY ERP_Device__r.ERP_Inventory_Id__c asc ];
        System.assertEquals(2, customerItems.size());
        List<Device_PEOL_Request_Detail__c> details = new List<Device_PEOL_Request_Detail__c>();
        details.add(new Device_PEOL_Request_Detail__c(ERP_Status_Message__c= 'Waiting for ERP Response', Device_PEOL_Request__c= peolRequest.Id, ERP_Device__c= devices[0].Id, Fab__c= 'FAB 6', Customer_Item__c = customerItems[0].Id, Last_Time_Ship_Date__c = DateTime.now(), Last_Time_Buy_Date__c = Datetime.now()));
        details.add(new Device_PEOL_Request_Detail__c(ERP_Status_Message__c= 'Waiting for ERP Response', Device_PEOL_Request__c= peolRequest.Id, ERP_Device__c= devices[0].Id, Fab__c= 'FAB 8', Customer_Item__c = customerItems[0].Id, Last_Time_Ship_Date__c = DateTime.now(), Last_Time_Buy_Date__c = Datetime.now()));
        details.add(new Device_PEOL_Request_Detail__c(ERP_Status_Message__c= 'Waiting for ERP Response', Device_PEOL_Request__c= peolRequest.Id, ERP_Device__c= devices[1].Id, Fab__c= 'FAB 8', Customer_Item__c = customerItems[1].Id, Last_Time_Ship_Date__c = DateTime.now(), Last_Time_Buy_Date__c = Datetime.now()));

        insert details;

        Test.startTest();
        peolRequest.Status__c = 'In-process';
        update peolRequest;

        for(Device_PEOL_Request_Detail__c detail : details){
            detail.ERP_Status_Message__c = 'SUCCESS';
        }
        update details;
        DevicePEOLUtility.fillCSR(peolRequest.Id);
        Device_PEOL_Request__c peolRequestQueried = [SELECT Id, Name, Status__c, Primary_CSR__c, Backup_CSR__c FROM Device_PEOL_Request__c WHERE Id =: peolRequest.Id ];
        System.assertEquals('Completed', peolRequestQueried.Status__c, 'Request should be in Review Status.');

        System.assertNotEquals(null, peolRequestQueried.Primary_CSR__c, 'There should be Primary CSR');
        System.assertNotEquals(null, peolRequestQueried.Backup_CSR__c, 'There should be Backup CSR');

    }
    
    @isTest static void failedTest() {
        Account account1 = [SELECT Id, Name, Account_Manager__c FROM Account where Short_Name__c = 'account1'];
        User accountManager = [SELECT Id, Name FROM User where firstName = 'AM'];
        User pcsr = [SELECT Id, Name FROM User where firstName = 'PCSR'];
        account1.Account_Manager__c = accountManager.id;
        update account1;

        List<ERP_Device__c> devices = [SELECT Id, Name, Geometry__c, ERP_Inventory_Id__c  FROM ERP_Device__c ORDER BY ERP_Inventory_Id__c asc ];
        System.assertEquals(2, devices.size(), 'There should be 2 Devies');
        
        List<Customer_Item__c> customerItems = [SELECT Id, Name FROM Customer_Item__c ORDER BY ERP_Device__r.ERP_Inventory_Id__c asc ];
        System.assertEquals(2, customerItems.size());
        
        Device_PEOL_Request__c peolRequest = new Device_PEOL_Request__c(Customer__c=account1.Id);
        insert peolRequest;
        List<Device_PEOL_Request_Detail__c> details = new List<Device_PEOL_Request_Detail__c>();
        details.add(new Device_PEOL_Request_Detail__c(ERP_Status_Message__c= 'Waiting for ERP Response', Device_PEOL_Request__c= peolRequest.Id, ERP_Device__c= devices[0].Id, Fab__c= 'FAB 6', Customer_Item__c = customerItems[0].Id, Last_Time_Ship_Date__c = DateTime.now(), Last_Time_Buy_Date__c = Datetime.now()));
        details.add(new Device_PEOL_Request_Detail__c(ERP_Status_Message__c= 'Waiting for ERP Response', Device_PEOL_Request__c= peolRequest.Id, ERP_Device__c= devices[0].Id, Fab__c= 'FAB 8', Customer_Item__c = customerItems[0].Id, Last_Time_Ship_Date__c = DateTime.now(), Last_Time_Buy_Date__c = Datetime.now()));
        details.add(new Device_PEOL_Request_Detail__c(ERP_Status_Message__c= 'Waiting for ERP Response', Device_PEOL_Request__c= peolRequest.Id, ERP_Device__c= devices[1].Id, Fab__c= 'FAB 8', Customer_Item__c = customerItems[1].Id, Last_Time_Ship_Date__c = DateTime.now(), Last_Time_Buy_Date__c = Datetime.now()));

        insert details;

        Test.startTest();
        peolRequest.Status__c = 'In-process';
        update peolRequest;
        
        for(Device_PEOL_Request_Detail__c detail : details){
            detail.ERP_Status_Message__c = 'ERROR';
        }
        update details;

        Device_PEOL_Request__c peolRequestQueried = [SELECT Id, Name, Status__c FROM Device_PEOL_Request__c WHERE Id =: peolRequest.Id ];
        System.assertEquals('Failed', peolRequestQueried.Status__c, 'Request should be in Review Status.');
    }

    @isTest static void validationFailureTest() {
        Account account1 = [SELECT Id, Name, Account_Manager__c FROM Account where Short_Name__c = 'account1'];
        User accountManager = [SELECT Id, Name FROM User where firstName = 'AM'];
        User pcsr = [SELECT Id, Name FROM User where firstName = 'PCSR'];
        account1.Account_Manager__c = accountManager.id;
        update account1;

        List<ERP_Device__c> devices = [SELECT Id, Name, Geometry__c, ERP_Inventory_Id__c  FROM ERP_Device__c ORDER BY ERP_Inventory_Id__c asc ];
        System.assertEquals(2, devices.size(), 'There should be 2 Devies');
        
        List<Customer_Item__c> customerItems = [SELECT Id, Name FROM Customer_Item__c ORDER BY ERP_Device__r.ERP_Inventory_Id__c asc ];
        System.assertEquals(2, customerItems.size());
        
        Test.startTest();
        Device_PEOL_Request__c peolRequest = new Device_PEOL_Request__c(Customer__c=account1.Id);
        insert peolRequest;
        List<Device_PEOL_Request_Detail__c> details = new List<Device_PEOL_Request_Detail__c>();
        details.add(new Device_PEOL_Request_Detail__c(ERP_Status_Message__c= 'Waiting for ERP Response', Device_PEOL_Request__c= peolRequest.Id, ERP_Device__c= devices[0].Id, Fab__c= 'FAB 6',  Customer_Item__c = customerItems[0].Id,  Last_Time_Ship_Date__c = DateTime.now() - 1, Last_Time_Buy_Date__c = Datetime.now()));
        details.add(new Device_PEOL_Request_Detail__c(ERP_Status_Message__c= 'Waiting for ERP Response', Device_PEOL_Request__c= peolRequest.Id, ERP_Device__c= devices[0].Id, Fab__c= 'FAB 8',  Customer_Item__c = customerItems[0].Id, Last_Time_Ship_Date__c = DateTime.now() - 40 , Last_Time_Buy_Date__c = Datetime.now() -41));
        details.add(new Device_PEOL_Request_Detail__c(ERP_Status_Message__c= 'Waiting for ERP Response', Device_PEOL_Request__c= peolRequest.Id, ERP_Device__c= devices[1].Id, Fab__c= 'FAB 8', Customer_Item__c = customerItems[1].Id,  Last_Time_Ship_Date__c = DateTime.now(), Last_Time_Buy_Date__c = Datetime.now()));
        try{
            insert details;
        }catch(Exception ex){
            System.assert(ex.getMessage().contains('Last Time Ship Date can not be greater than Last Time Buy Date'));
        }
    }
    
}