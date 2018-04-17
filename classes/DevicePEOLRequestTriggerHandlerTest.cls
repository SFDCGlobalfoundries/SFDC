/**
*  Author: Sreedhar Karukonda
*  Description: DevicePEOLRequestTriggerHandlerTest  is Test case for DevicePEOLRequestTriggerHandler class.
* History:
*   Sreedhar Karukonda         15102015    - code creation.
**/

@isTest
private class DevicePEOLRequestTriggerHandlerTest {
    //Test data creation
    @testSetup
    private static void createTestDate(){
        DataUtilTest.loadEnvironmentVariables();
        User user1 = DevicePEOLTestsData.createUser('System Administrator', 'PCSR'); // PRIMARY CSR
        User user2 = DevicePEOLTestsData.createUser('System Administrator', 'BCSR'); // Backup CSR
        User user3 = DevicePEOLTestsData.createUser('System Administrator','AM');  // Account Manager
        Test.startTest();
        Account account1 = DevicePEOLTestsData.createAccount('account1', '12345');
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

    @isTest static void createPEOLReuest() {
        Account account1 = [SELECT Id, Name, Account_Manager__c FROM Account where Short_Name__c = 'account1'];
        User accountManager = [SELECT Id, Name FROM User where firstName = 'AM'];
        User pcsr = [SELECT Id, Name FROM User where firstName = 'PCSR'];
        account1.Account_Manager__c = accountManager.id;
        Test.startTest();
        update account1;

        List<ERP_Device__c> devices = [SELECT Id, Name, Geometry__c, ERP_Inventory_Id__c  FROM ERP_Device__c ORDER BY ERP_Inventory_Id__c asc ];
        System.assertEquals(2, devices.size(), 'There should be 2 Devies');
        
        List<Customer_Item__c> customerItems = [SELECT Id, Name FROM Customer_Item__c ORDER BY ERP_Device__r.ERP_Inventory_Id__c asc ];
        System.assertEquals(2, customerItems.size());
        
        
        Device_PEOL_Request__c peolRequest = new Device_PEOL_Request__c(Customer__c=account1.Id);
        insert peolRequest;
        List<Device_PEOL_Request_Detail__c> details = new List<Device_PEOL_Request_Detail__c>();
        details.add(new Device_PEOL_Request_Detail__c(Device_PEOL_Request__c= peolRequest.Id, ERP_Device__c= devices[0].Id, Fab__c= 'FAB 6', Customer_Item__c = customerItems[0].Id, Last_Time_Ship_Date__c = DateTime.now(), Last_Time_Buy_Date__c = Datetime.now()));
        details.add(new Device_PEOL_Request_Detail__c(Device_PEOL_Request__c= peolRequest.Id, ERP_Device__c= devices[0].Id, Fab__c= 'FAB 8', Customer_Item__c = customerItems[0].Id, Last_Time_Ship_Date__c = DateTime.now(), Last_Time_Buy_Date__c = Datetime.now()));
        details.add(new Device_PEOL_Request_Detail__c(Device_PEOL_Request__c= peolRequest.Id, ERP_Device__c= devices[1].Id, Fab__c= 'FAB 8', Customer_Item__c = customerItems[1].Id, Last_Time_Ship_Date__c = DateTime.now(), Last_Time_Buy_Date__c = Datetime.now()));

        insert details;

       Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();     
       req1.setComments('Submitting record for approval.');
       req1.setObjectId(peolRequest.id);
       approval.ProcessResult result = Approval.process(req1);
       //Verify approval process successfully completed
       System.assert(result.isSuccess());

       Device_PEOL_Request__c peolRequestQueried = [SELECT Id, Name, Status__c FROM Device_PEOL_Request__c WHERE Id =: peolRequest.Id ];
       System.assertEquals('Review', peolRequestQueried.Status__c, 'Request should be in Review Status.');

      System.assertEquals(
            'Pending', result.getInstanceStatus(), 
            'Instance Status'+result.getInstanceStatus());
        
        // Approve the submitted request
        // First, get the ID of the newly created item
        List<Id> newWorkItemIds = result.getNewWorkitemIds();
        
        // Instantiate the new ProcessWorkitemRequest object and populate it
        Approval.ProcessWorkitemRequest req2 = 
            new Approval.ProcessWorkitemRequest();
        req2.setComments('Approving request.');
        req2.setAction('Approve');
        req2.setNextApproverIds(new Id[] {UserInfo.getUserId()});
        
        // Use the ID from the newly created item to specify the item to be worked
        req2.setWorkitemId(newWorkItemIds.get(0));
        
        // Submit the request for approval
        Approval.ProcessResult result2 =  Approval.process(req2);
        
        // Verify the results
        System.assert(result2.isSuccess(), 'Result Status:'+result2.isSuccess());
        
        System.assertEquals(
            'Approved', result2.getInstanceStatus(), 
            'Instance Status'+result2.getInstanceStatus());

        peolRequestQueried = [SELECT Id, Name, Status__c FROM Device_PEOL_Request__c WHERE Id =: peolRequest.Id ];
        System.assertEquals('In-process', peolRequestQueried.Status__c, 'Request should be in Review Status.');

    }

    @isTest static void declinePEOLReuest() {
        Account account1 = [SELECT Id, Name, Account_Manager__c FROM Account where Short_Name__c = 'account1'];
        User accountManager = [SELECT Id, Name FROM User where firstName = 'AM'];
        User pcsr = [SELECT Id, Name FROM User where firstName = 'PCSR'];
        account1.Account_Manager__c = accountManager.id;
        Test.startTest();
        update account1;

        List<ERP_Device__c> devices = [SELECT Id, Name, Geometry__c, ERP_Inventory_Id__c  FROM ERP_Device__c ORDER BY ERP_Inventory_Id__c asc ];
        System.assertEquals(2, devices.size(), 'There should be 2 Devies');
        
        List<Customer_Item__c> customerItems = [SELECT Id, Name FROM Customer_Item__c ORDER BY ERP_Device__r.ERP_Inventory_Id__c asc ];
        System.assertEquals(2, customerItems.size());
        
        
        Device_PEOL_Request__c peolRequest = new Device_PEOL_Request__c(Customer__c=account1.Id);
        insert peolRequest;
        List<Device_PEOL_Request_Detail__c> details = new List<Device_PEOL_Request_Detail__c>();
        details.add(new Device_PEOL_Request_Detail__c(Device_PEOL_Request__c= peolRequest.Id, ERP_Device__c= devices[0].Id, Fab__c= 'FAB 6', Customer_Item__c = customerItems[0].Id, Last_Time_Ship_Date__c = DateTime.now(), Last_Time_Buy_Date__c = Datetime.now()));
        details.add(new Device_PEOL_Request_Detail__c(Device_PEOL_Request__c= peolRequest.Id, ERP_Device__c= devices[0].Id, Fab__c= 'FAB 8', Customer_Item__c = customerItems[0].Id, Last_Time_Ship_Date__c = DateTime.now(), Last_Time_Buy_Date__c = Datetime.now()));
        details.add(new Device_PEOL_Request_Detail__c(Device_PEOL_Request__c= peolRequest.Id, ERP_Device__c= devices[1].Id, Fab__c= 'FAB 8', Customer_Item__c = customerItems[1].Id, Last_Time_Ship_Date__c = DateTime.now(), Last_Time_Buy_Date__c = Datetime.now()));

        insert details;

       Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();     
       req1.setComments('Submitting record for approval.');
       req1.setObjectId(peolRequest.id);
       approval.ProcessResult result = Approval.process(req1);
       //Verify approval process successfully completed
       System.assert(result.isSuccess());

       Device_PEOL_Request__c peolRequestQueried = [SELECT Id, Name, Status__c FROM Device_PEOL_Request__c WHERE Id =: peolRequest.Id ];
       System.assertEquals('Review', peolRequestQueried.Status__c, 'Request should be in Review Status.');

      System.assertEquals(
            'Pending', result.getInstanceStatus(), 
            'Instance Status'+result.getInstanceStatus());
        
        // Approve the submitted request
        // First, get the ID of the newly created item
        List<Id> newWorkItemIds = result.getNewWorkitemIds();
        
        // Instantiate the new ProcessWorkitemRequest object and populate it
        Approval.ProcessWorkitemRequest req2 = 
            new Approval.ProcessWorkitemRequest();
        req2.setComments('Approving request.');
        req2.setAction('Reject');
        req2.setNextApproverIds(new Id[] {UserInfo.getUserId()});
        
        // Use the ID from the newly created item to specify the item to be worked
        req2.setWorkitemId(newWorkItemIds.get(0));
        
        // Submit the request for approval
        Approval.ProcessResult result2 =  Approval.process(req2);
        
        // Verify the results
        System.assert(result2.isSuccess(), 'Result Status:'+result2.isSuccess());
        
        System.assertEquals(
            'Rejected', result2.getInstanceStatus(), 
            'Instance Status'+result2.getInstanceStatus());

        peolRequestQueried = [SELECT Id, Name, Status__c FROM Device_PEOL_Request__c WHERE Id =: peolRequest.Id ];
        System.assertEquals('Pending', peolRequestQueried.Status__c, 'Request should be in Review Status.');

    }
}