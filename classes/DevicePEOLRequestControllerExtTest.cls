/*
*  Author: Sreedhar Karukonda
*  Description: DevicePEOLRequestControllerExtTest  is Test case for DevicePEOLRequestControllerExtTest class.
* History:
*   Sreedhar Karukonda         15102015    - code creation.
*/

@isTest
private class DevicePEOLRequestControllerExtTest {
    
    @testSetup
    private static void createTestDate(){
        DataUtilTest.loadEnvironmentVariables();
        User user1 = DevicePEOLTestsData.createUser('System Administrator', 'PCSR'); // PRIMARY CSR
        User user2 = DevicePEOLTestsData.createUser('System Administrator', 'BCSR'); // Backup CSR
        User user3 = DevicePEOLTestsData.createUser('System Administrator','AM');  // Account Manager
        Account account1 = DevicePEOLTestsData.createAccount('account1',  '12345');
        ERP_Device__c device123456 = DevicePEOLTestsData.createERPDevice('123456', 'FAB 6;FAB 8');
        Customer_Item__c item = DevicePEOLTestsData.createCustomerItems('123456', new LIST<String>{'account1'})[0];
        DevicePEOLTestsData.createAccountTeam(account1, new LIST<String>{'Backup Customer Service Rep','Primary Customer Service Rep'}, new LIST<User>{user1, user2});
    }


    @isTest static void successfulEndToEnd() {
        Account account1 = [select Id, Name, Account_Manager__c from Account where Short_Name__c = 'account1'];
        User accountManager = [select Id, Name from User where firstName = 'AM'];
        account1.Account_Manager__c = accountManager.id;
        Test.startTest();
        update account1;
        PageReference pageRef = Page.DevicePEOLRequestPage;
        Test.setCurrentPage(pageRef);
        Device_PEOL_Request__c peolRequest = new Device_PEOL_Request__c();
        ApexPages.StandardController standardController = new ApexPages.StandardController(peolRequest);
        DevicePEOLRequestControllerExt controller = new DevicePEOLRequestControllerExt(standardController);
        peolRequest.Customer__c = account1.Id;
        controller.searchDevices();
        List<DevicePEOLRequestControllerExt.ErpDeviceWrapper> dispalyDevices = controller.displayDevices;
        System.assertEquals(2, dispalyDevices.size(), 'THere should be 2 Device displayed in Available Devices');

        System.assertEquals(false, controller.hasNext, 'There should not be next page');
        System.assertEquals(false, controller.hasPrevious, 'There should not be previous page');
        controller.addThisDeviceWithKey = dispalyDevices.get(0).referenceId;
        PageReference afterAdd = controller.addSelectedDeviceToPEOL();
        System.assertEquals(null, afterAdd, 'Add selected Device button should not navigate to someother page');
        System.assertEquals(null, controller.addThisDeviceWithKey, 'addThisDeviceWithKey should be rest to null');
        System.assertEquals(1, controller.addedDevices.size(), 'One Device should be added to the added device List');
        controller.addedDevices[0].Last_Time_Buy_Date__c = DateTime.now();
        controller.addedDevices[0].Last_Time_Ship_Date__c = DateTime.now();
        
        // Search for Device after adding a device
        controller.searchDevices();
        dispalyDevices = controller.displayDevices;
        System.assertEquals(1, dispalyDevices.size(), 'There should be 1 Device displayed in Available Devices, Other device is already added');

        // Search including fab
        peolRequest.Geometry__c = '0.028UM';
        peolRequest.Fab__c = dispalyDevices[0].fab;
        controller.searchDevices();
        dispalyDevices = controller.displayDevices;
        System.assertEquals(1, dispalyDevices.size(), 'There should be 1 Device displayed in Available Devices, Other device is already added');

        //Add second device
        controller.addThisDeviceWithKey = dispalyDevices[0].referenceId;
        controller.addSelectedDeviceToPEOL();
        System.assertEquals(2, controller.addedDevices.size(), '2nd Device is added, so it should be 2 devices');

        //Remove second device
        controller.removeThisDevice = dispalyDevices[0].referenceId;
        controller.removeDeviceFromAddredDevices();
        System.assertEquals(1, controller.addedDevices.size(), '2nd Device is removed, so it should be 1 devices');

        // Search does not match any device
        peolRequest.Fab__c = null;
        controller.deviceNameForSearch = 'SOME RANDOM NAME';
        controller.searchDevices();
        dispalyDevices = controller.displayDevices;
        System.assertEquals(0, dispalyDevices.size(), 'There should be 0 Device displayed in Available Devices.');
        
        // Save PEOL Request, this should save PEOL Request as well as PEOL Request Detail
        controller.savePEOLRequest();
        System.assertNotEquals(null, peolRequest.Id, 'PEOL REquest should be saved');
        Device_PEOL_Request__c peolRequestQueried = [SELECT Customer__c,ERP_Error_Device_Count__c,Fab__c, Name, Status__c, 
                                                    (select Id, Name from Device_PEOL_Request_Details__r) FROM Device_PEOL_Request__c 
                                                    where Id=:peolRequest.Id];
        System.assertEquals(1, peolRequestQueried.Device_PEOL_Request_Details__r.size(), 'There should be one Detail record');

        controller.getFirst();
        controller.getLast();
        controller.getPrevious();
        controller.getNext();

        Test.stopTest();
        
    }
    
}