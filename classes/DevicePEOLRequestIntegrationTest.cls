/*
  Author: Ariz Solito
  Description: Test class for DevicePEOLRequestIntegration
  History:
    ASolito         07072015    - code creation.
*/
@isTest(SeeAllData=false)
public class DevicePEOLRequestIntegrationTest  {
  
    //Test data creation
    @testSetup
    private static void createTestDate(){
        DataUtilTest.loadEnvironmentVariables();
        User user1 = DevicePEOLTestsData.createUser('System Administrator', 'PCSR'); // PRIMARY CSR
        User user2 = DevicePEOLTestsData.createUser('System Administrator', 'BCSR'); // Backup CSR
        User user3 = DevicePEOLTestsData.createUser('System Administrator','AM');  // Account Manager
        Account account1 = DevicePEOLTestsData.createAccount('account1', '12345');
        ERP_Device__c device123456 = DevicePEOLTestsData.createERPDevice('123456', 'FAB 6;FAB 8');
        ERP_Device__c device123457 = DevicePEOLTestsData.createERPDevice('123457', 'FAB 7;FAB 8');

        List<Customer_Item__c> items = new  List<Customer_Item__c>{
                new Customer_Item__c(ERP_Device__c=device123456.Id, Customer__c= account1.Id),
                new Customer_Item__c(ERP_Device__c=device123457.Id, Customer__c= account1.Id)
            };
        insert items;

        DevicePEOLTestsData.createAccountTeam(account1, new LIST<String>{'Backup Customer Service Rep','Primary Customer Service Rep'}, new LIST<User>{user1, user2});

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
        details.add(new Device_PEOL_Request_Detail__c(Device_PEOL_Request__c= peolRequest.Id, ERP_Device__c= devices[0].Id, Fab__c= 'FAB 6',  Customer_Item__c = customerItems[0].Id, Last_Time_Ship_Date__c = DateTime.now(), Last_Time_Buy_Date__c = Datetime.now()));
        details.add(new Device_PEOL_Request_Detail__c(Device_PEOL_Request__c= peolRequest.Id, ERP_Device__c= devices[0].Id, Fab__c= 'FAB 8',  Customer_Item__c = customerItems[0].Id, Last_Time_Ship_Date__c = DateTime.now(), Last_Time_Buy_Date__c = Datetime.now()));
        details.add(new Device_PEOL_Request_Detail__c(Device_PEOL_Request__c= peolRequest.Id, ERP_Device__c= devices[1].Id, Fab__c= 'FAB 8',  Customer_Item__c = customerItems[1].Id, Last_Time_Ship_Date__c = DateTime.now(), Last_Time_Buy_Date__c = Datetime.now()));

        insert details;
    
    }

    @isTest static void createPEOLRequestSuccess() {
        
        List<Device_PEOL_Request__c> peolRequests = [select Id from Device_PEOL_Request__c limit 1];
        System.assertEquals(1, peolRequests.size());

        Test.startTest();
        //Test.setMock(WebServiceMock.class, new DevicePEOLRequestToAIAMockService());
        //success callout
        // Add mock service and Assert logic
        DevicePEOLRequestIntegration.doCallout(new List<String>{peolRequests[0].id});
        Test.stopTest();

    }

    @isTest static void errorPEOLReuest() {
        // To Force Error
        Test.startTest();
        Account account1 = [select Id, Customer_Number__c from Account where Short_Name__c = 'account1'];
        account1.Customer_Number__c = null;
        update account1;

        List<Device_PEOL_Request__c> peolRequests = [select Id from Device_PEOL_Request__c limit 1];
        System.assertEquals(1, peolRequests.size());
        
        //Test.setMock(WebServiceMock.class, new DevicePEOLRequestToAIAMockService(true, false));
        //Failed callout
        // Add mock service and Assert logic

        DevicePEOLRequestIntegration.doCallout(new List<String>{peolRequests[0].id});
        Test.stopTest();
    }

    @isTest static void testSendEmail(){
        DevicePEOLRequestIntegration.sendMail('JUST UNIT TESTING');
    }

}