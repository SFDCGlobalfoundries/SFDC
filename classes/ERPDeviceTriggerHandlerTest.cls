@isTest
private class ERPDeviceTriggerHandlerTest {
    //Test data creation
    @testSetup
    private static void createTestDate(){
        DataUtilTest.loadEnvironmentVariables();
        
        Account account1 = DevicePEOLTestsData.createAccount('account1', '12345');
        Process__c process = DevicePEOLTestsData.createProcess('TESTPROCESS');
         Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'standt', Email='standarduser_gfdskjahd@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standarduser_gfdskjahd@testorg.com');

        insert u;
        System.runAs(u){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = u.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
            Device__c device = DevicePEOLTestsData.createDevice(account1.Id, process.Id, 'TESTCRMDID');
        }
        
        
    }

    
     
      static Device__c createDevice(Id accId,  Id processId, String crmdid){
        Id optyId = DevicePEOLTestsData.createOpp(accId);
        Id optyProgramId = DevicePEOLTestsData.createOppProg(accId, optyId);
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name','TESTDEVICE1947');
        fieldValueMap.put('Fab__c','Fab 3');
        fieldValueMap.put('Stage__c','Design In');
        fieldValueMap.put('Status__c','Active');
        fieldValueMap.put('Account__c',accId);
        fieldValueMap.put('Opportunity2__c',optyId);
        fieldValueMap.put('Opportunity_Program__c',optyProgramId);
        fieldValueMap.put('Market_Segment__c','Automotive');
        fieldValueMap.put('Semiconductor_Device__c','Analog Regulator');
        fieldValueMap.put('End_Application__c','Body');
        fieldValueMap.put('Device_Sourcing__c','3rd Source');
        fieldValueMap.put('Confidence_Level_Tapeout__c','100');
        fieldValueMap.put('Siebel_Device_ID__c','0987654321');
        fieldValueMap.put('Tapeout_Type__c','Customer MPW');
        fieldValueMap.put('IP_Gap__c',false);
        fieldValueMap.put('Assigned_Process_ID__c',processId);
        fieldValueMap.put('CRMDID__c',crmdid);
        fieldValueMap.put('BX041_Status__c','Closed');
        fieldValueMap.put('Actual_Tapeout_Date__c',date.newInstance(2013,5,20));
        fieldValueMap.put('Original_Forecasted_Tapeout_Date__c',date.newInstance(2013,5,20));
        fieldValueMap.put('Current_Forecast_Tapeout_Date__c',date.newInstance(2013,3,4));
        return DeviceDataFactory.createDevice(fieldValueMap);
     }

	 public static ERP_Device__c getERPDeviceData(String psa, String psc) {     
        ERP_Device__c erpDevice = new ERP_Device__c();
        erpDevice.PSANew__c =psa;
        erpDevice.PSCNew__c=psc;
        erpDevice.Part_Number__c='0000000L4004';
        erpDevice.ITARNew__c ='No';
        insert erpDevice;
        return erpDevice;
    }  
      // Creation of an opportunity program for Test
      public static Id createOppProg(Id acctId, Id oppId){
          Opportunity_Program__c opProg = new Opportunity_Program__c(Name='Test OppProg',Account__c=acctId,Opportunity__c=oppId);
          insert opProg;
          return opProg.Id;
      }
  
    @isTest static void erpDeviceWithProcessAndDevice() {
        test.startTest();
        ERP_Device__c device123456 = DevicePEOLTestsData.createERPDevice('123456', 'FAB 6;FAB 8', 'TESTCRMDID', 'TESTPROCESS');
        ERP_Device__c queriesDevice = [select Id, Name, Process_Id__c, Device__c from ERP_Device__c where Id=: device123456.Id];
        System.assertNotEquals(null, queriesDevice.Device__c, 'There should be a device assosiated with ERP Device');
        System.assertNotEquals(null, queriesDevice.Process_Id__c, 'There should be a process assosiated with ERP Device');
        Test.stopTest();
    }
    
    @isTest static void redDeviceWithoutError() {
        ERP_Device_Required_Fields__c reqField = new ERP_Device_Required_Fields__c(Name='Fab__c', Message__c='Fab (MFG_LOCATION) is required.', SObject__c='ERP_Device__c');
        insert reqField;
        test.startTest();
        ERP_Device__c device = DevicePEOLTestsData.createERPDevice('123456', 'FAB 6;FAB 8', 'TESTCRMDID', 'TESTPROCESS');
        device.Part_Number__c = '1';
        update device;
        ERP_Device__c queriesDevice = [select Id, Name, Integrity_Error_Flag__c, Integrity_Error__c from ERP_Device__c where Id=: device.Id];
        System.assertEquals(false, queriesDevice.Integrity_Error_Flag__c, 'Flag should not be set.');
        System.assertEquals(null, queriesDevice.Integrity_Error__c, 'There should not be a error message');
        Test.stopTest();
    }
    
    @isTest static void redDeviceWithError() {
        ERP_Device_Required_Fields__c reqField = new ERP_Device_Required_Fields__c(Name='Chips_per_Wafer__c', Message__c='Chips per Wafer (CPW) is required.', SObject__c='ERP_Device__c');
        insert reqField;
        test.startTest();
        
         ERP_Device__c device = new ERP_Device__c(
            name = 'd1',
            fab__c = 'FAB 6;FAB 8',
            geometry__c = '0.028UM',
            Part_Number__c = '1'        
        );
        insert device;
        
        
        ERP_Device__c queriesDevice = [select Id, Name, Integrity_Error_Flag__c, Integrity_Error__c from ERP_Device__c where Id=: device.Id];
        System.assertEquals(true, queriesDevice.Integrity_Error_Flag__c, 'Flag should be set.');
        System.assertNotEquals(null, queriesDevice.Integrity_Error__c, 'There should be a error message');
        Test.stopTest();
    }
    @isTest static void updateJunctionListTest() {
        test.startTest();
        ERP_Device__c erpDevice = getERPDeviceData('AAAAAZZ','0000025');
        erpDevice.PSANew__c ='AAAAAZY';
        Device__c device = [select Id from Device__c where name = 'TESTDEVICE1947'];
        erpDevice.Device__c = device.Id;
        update erpDevice;
        Test.stopTest();
    }
}