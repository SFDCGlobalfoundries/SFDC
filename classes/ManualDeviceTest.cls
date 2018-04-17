/*    
    Author: Bhupesh Mukhija 
    Description: This serves as the test class for CE Weekly Report for Manual Device and Device Objects.
    History:
        BMukhija    30052013    -  Class Creation.
        Nbustillos  10122013    - Added call to loadEnvironmentVariables() method.
*/

@isTest(SeeAllData = false)
public class ManualDeviceTest {

    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        
        List<Map<String,Object>> fieldValueMapList = new List<Map<String,Object>>();
        for(integer i=1;i<=3;i++){
            Map<String,Object> fieldValueMap = new Map<String,Object>();
            fieldValueMap.put('Name', 'MYTEST ACCOUNT'+i);                   
            fieldValueMap.put('sub_type__c', 'Direct');
            fieldValueMap.put('site_department__c', 'test dept');          
            fieldValueMap.put('transaction_type__c', 'transactional');                          
            fieldValueMap.put('region__c', 'APJ');        
            fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
            fieldValueMap.put('Corporate_City__c', 'Test City');                
            fieldValueMap.put('Corporate_Country__c', 'India');
            fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
            fieldValueMap.put('Bill_To_City__c', 'Test City');            
            fieldValueMap.put('Bill_To_Country__c', 'India');        
            fieldValueMap.put('Fab_9_10__c','No');            
            fieldValueMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER'));
            
            fieldValueMapList.add(fieldValueMap);
        }
        AccountDataFactory.createAccounts(fieldValueMapList,3);
    }
    
    static Id createMaskSetTitle(){
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name','MSTTRT1');
        fieldValueMap.put('Reticle_Type__c','Multi Layer Reticle (MLR)');
        return MaskSetTitleDataFactory.createMaskSetTitle(fieldValueMap).Id;
    }
    
    public static Device__c createCMPWDevice(Id acctId,Id opptyProgramId) {
        String MSTId = CreateMaskSetTitle();
        string MSTAccId = DeviceUtilTest.createMSTAccount(acctId,MSTId);
        // Create Device
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Account__c',acctId);
        fieldValueMap.put('Name','TESTDEVICEZAIH12345677');
        fieldValueMap.put('Opportunity_Program__c',opptyProgramId);
        fieldValueMap.put('Fab__c','FAB 2');
        fieldValueMap.put('GSOP_Assignment_Tapeout_Plan__c','No');
        fieldValueMap.put('Market_Segment__c','Automotive');
        fieldValueMap.put('Semiconductor_Device__c','Analog Amplifier');
        fieldValueMap.put('End_Customer__c','Test Customer');
        fieldValueMap.put('Device_Sourcing__c','1st Source');
        fieldValueMap.put('Stage__c','Design In');
        fieldValueMap.put('Status__c','Active');
        fieldValueMap.put('Siebel_Device_ID__c','1234567890');
        fieldValueMap.put('Tapeout_Type__c','Customer MPW');
        fieldValueMap.put('PLM_Device_ID__c','ANBQP60ACO8CH-U01');
        fieldValueMap.put('Device_Mask_Set_Title__c','MSTTRT1');
        fieldValueMap.put('CRMDID__c','CDID0000001.00');
        fieldValueMap.put('Actual_Tapeout_Date__c',date.newInstance(2013,5,20));
        fieldValueMap.put('Original_Forecasted_Tapeout_Date__c',date.newInstance(2013,5,20));
        fieldValueMap.put('Current_Forecast_Tapeout_Date__c',date.newInstance(2013,3,4));
        fieldValueMap.put('Confidence_Level_Tapeout__c','100');
        fieldValueMap.put('Device_Type__c','Base');
        fieldValueMap.put('End_Application__c','Body');
        return DeviceDataFactory.createDevice(fieldValueMap);
    }
     
    
    public static void setUpCustomSetting() {
        List<CS_Device_Stage__c> lcsDeviceStage = new List<CS_Device_Stage__c>();
        lcsDeviceStage.add(new CS_Device_Stage__c(Name='DEVICE_STAGE_DESIGN_IN'
            , Value__c = 'Design In'
            , SetupOwnerId = UserInfo.getOrganizationId()));
        lcsDeviceStage.add(new CS_Device_Stage__c(Name='DEVICE_STAGE_EOL'
            , Value__c = 'EOL'
            , SetupOwnerId = UserInfo.getOrganizationId()));
        lcsDeviceStage.add(new CS_Device_Stage__c(Name='DEVICE_STAGE_PRODUCTION'
            , Value__c = 'Production'
            , SetupOwnerId = UserInfo.getOrganizationId()));
        lcsDeviceStage.add(new CS_Device_Stage__c(Name='DEVICE_STAGE_PROTOTYPE'
            , Value__c = 'Prototype'
            , SetupOwnerId = UserInfo.getOrganizationId()));
        lcsDeviceStage.add(new CS_Device_Stage__c(Name='DEVICE_STAGE_RTR'
            , Value__c = 'RTR'
            , SetupOwnerId = UserInfo.getOrganizationId()));            
        lcsDeviceStage.add(new CS_Device_Stage__c(Name='DEVICE_STAGE_SOLUTIONING'
            , Value__c = 'Solutioning'
            , SetupOwnerId = UserInfo.getOrganizationId()));            
        lcsDeviceStage.add(new CS_Device_Stage__c(Name='DEVICE_STAGE_TAPEOUT'
            , Value__c = 'Tapeout'
            , SetupOwnerId = UserInfo.getOrganizationId()));            
                        

        insert lcsDeviceStage;

        List<CS_Manual_Device__c> lcsManualDevice = new List<CS_Manual_Device__c>();
        lcsManualDevice.add(new CS_Manual_Device__c(Name='MANUAL_DEVICE_PRODUCTION'
            , Value__c = 'Production'
            , SetupOwnerId = UserInfo.getOrganizationId()));
        lcsManualDevice.add(new CS_Manual_Device__c(Name='MANUAL_DEVICE_PROTO_RISK_PROD'
            , Value__c = 'Proto_Risk Production'
            , SetupOwnerId = UserInfo.getOrganizationId()));
        lcsManualDevice.add(new CS_Manual_Device__c(Name='MANUAL_DEVICE_PV_ACTIVE'
            , Value__c = 'Active'
            , SetupOwnerId = UserInfo.getOrganizationId()));
        lcsManualDevice.add(new CS_Manual_Device__c(Name='MANUAL_DEVICE_PV_INACTIVE'
            , Value__c = 'Inactive'
            , SetupOwnerId = UserInfo.getOrganizationId()));
        lcsManualDevice.add(new CS_Manual_Device__c(Name='MANUAL_DEVICE_PV_NO'
            , Value__c = 'No'
            , SetupOwnerId = UserInfo.getOrganizationId()));
        lcsManualDevice.add(new CS_Manual_Device__c(Name='MANUAL_DEVICE_PV_YES'
            , Value__c = 'Yes'
            , SetupOwnerId = UserInfo.getOrganizationId()));
        lcsManualDevice.add(new CS_Manual_Device__c(Name='MANUAL_DEVICE_TAPEOUT'
            , Value__c = 'Tapeout'
            , SetupOwnerId = UserInfo.getOrganizationId()));
        lcsManualDevice.add(new CS_Manual_Device__c(Name='MANUAL_DEVICE_RETROFIT'
            , Value__c = 'Retrofit'
            , SetupOwnerId = UserInfo.getOrganizationId()));
        lcsManualDevice.add(new CS_Manual_Device__c(Name='MANUAL_DEVICE_RETROFIT_ERROR'
            , Value__c = 'Publish Report cannot be "No" for 1. Device with Design In/Solutioning/Tapeout Status.AND 2. Device with Tapeout Type Retrofit.AND 3. Device with Confidence Level Tapeout >= 50.AND 4. Device with Forecast GDSII In Date is One year between Current Date'
            , SetupOwnerId = UserInfo.getOrganizationId()));
        lcsManualDevice.add(new CS_Manual_Device__c(Name='MANUAL_DEVICE_TEAM_ROOM_PUBLISH_ERROR'
            , Value__c = 'Meeting Minutes already Publishd for Current Week.'
            , SetupOwnerId = UserInfo.getOrganizationId()));
        lcsManualDevice.add(new CS_Manual_Device__c(Name='MANUAL_DEVICE_TEAM_ROOM_PUBLISH_INFO'
            , Value__c = 'Published to the Team Room.'
            , SetupOwnerId = UserInfo.getOrganizationId()));
        lcsManualDevice.add(new CS_Manual_Device__c(Name='MANUAL_DEVICE_DUPLICATE_DEVICE_ERROR'
            , Value__c = 'Device with Device Id already Exists.'
            , SetupOwnerId = UserInfo.getOrganizationId()));
        lcsManualDevice.add(new CS_Manual_Device__c(Name='MANUAL_DEVICE_ACCOUNT_ERROR'
            , Value__c = 'Please Enter a Valid Account.'
            , SetupOwnerId = UserInfo.getOrganizationId()));
        lcsManualDevice.add(new CS_Manual_Device__c(Name='MDEVICE_REPORT_FOLDER'
            , Value__c = 'CE_Weekly_Reports'
            , SetupOwnerId = UserInfo.getOrganizationId()));
        lcsManualDevice.add(new CS_Manual_Device__c(Name='MANUAL_DEVICE_OWNER_USER_FID'
            , Value__c = 'CRMBATCHUSR'
            , SetupOwnerId = UserInfo.getOrganizationId()));

        insert lcsManualDevice;
        
        List<CRMDID__c> lcsCRMDID = new List<CRMDID__c>();
        lcsCRMDID.add(new CRMDID__c(Name='CRMDID_No'
            , CRMDID_No__c = 15179
            , SetupOwnerId = UserInfo.getOrganizationId()));
            
        insert lcsCRMDID;
        
        /*Folder folder = new Folder();
        folder.DeveloperName = 'CE_Weekly_Reports';
        folder.AccessType = 'Public';
        folder.Name = 'CE Weekly Reports';
        
        insert folder;*/
    }        
    
     public static Account createAccount(String recChange) {
            Map<String,Object> fieldValueMap = new Map<String,Object>();
            fieldValueMap.put('Name', 'MYTEST ACCOUNT1');                   
            fieldValueMap.put('sub_type__c', 'Direct');
            fieldValueMap.put('site_department__c', 'test dept');          
            fieldValueMap.put('transaction_type__c', 'transactional');                          
            fieldValueMap.put('region__c', 'APJ');        
            fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
            fieldValueMap.put('Corporate_City__c', 'Test City');                
            fieldValueMap.put('Corporate_Country__c', 'India');
            fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
            fieldValueMap.put('Bill_To_City__c', 'Test City');            
            fieldValueMap.put('Bill_To_Country__c', 'India');        
            fieldValueMap.put('Fab_9_10__c','No');            
            fieldValueMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER'));
                               
            return AccountDataFactory.createAccount(fieldValueMap);
    }
    
    public static Opportunity createOpportunity(Id accountId, String recChange) {
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('AccountId',accountId);
        fieldValueMap.put('Name','Test '+recChange);  
        fieldValueMap.put('StageName','1. Discovery');
        fieldValueMap.put('CloseDate',date.newinstance(2012, 12, 21));  
        fieldValueMap.put('Target_Process_Node__c','14XM');
        fieldValueMap.put('Market_Segment__c','Automotive');  
        fieldValueMap.put('Process_Platform__c','GF Baseline');
        fieldValueMap.put('Fab_Split__c',100);          
        fieldValueMap.put('Process_Geometry__c','0.014UM');  
        fieldValueMap.put('Process_Family__c','Super Low Power');
        fieldValueMap.put('Opportunity_Sourcing_Type__c','First Source');  
        fieldValueMap.put('Fab_Assignment_1__c','FAB 1');
        fieldValueMap.put('FAE_CP2__c',true);
         
        return OpportunityDataFactory.createOpportunity(fieldValueMap);
        
    }
    
    public static Opportunity_Program__c createOpportunityProgram(Id accountId,Id opportunityId, String recChange){
        Opportunity_Program__c opportunityProgram = new Opportunity_Program__c
                                                                        ( Name ='Test ' + recChange
                                                                        , Account__c = accountId
                                                                        , Opportunity__c = opportunityId 
                                                                        , Technology__c = '20LPM');
                                                                        
        insert opportunityProgram;
        
        return opportunityProgram;
    }
    /*
    public static Device__c createDevice2(
        Id accountId, Id opportunityId, Id oppProgId, String recChange, String stage, String publishReport){
        Device__c device = new Device__c();
        
        device.Name = 'TESTDEVICE.' + recChange;
        device.Stage__c = stage;
        device.Status__c = 'Active';
        device.Project_Update__c = '<b>BOLD LETTERS</b>';
        device.Publish_Report__c = publishReport;
        device.Fab__c = 'FAB 7';
        
        device.Account__c = accountId;
        device.Opportunity2__c = opportunityId;
        device.Opportunity_Program__c = oppProgId;
        device.Confidence_Level_Tapeout__c = '75';
        
        device.Market_Segment__c = 'Automotive';
        device.Semiconductor_Device__c = 'Analog Regulator';
        device.End_Application__c = 'Body';
        device.Device_Sourcing__c = '3rd Source';
        device.Tapeout_Type__c = 'Customer MPW';
        device.Siebel_Device_ID__c = '0987654321';
        device.IP_Gap__c = false;
        device.Yield__c = 20;
        
        device.Actual_Tapeout_Date__c = date.newInstance(2013,6,20);
        device.Original_Forecasted_Tapeout_Date__c = date.newInstance(2013,6,20);        
        
        return device; 
    }
    */
    /*public static Device__c createDevice(
        Id accountId, Id opportunityId, Id oppProgId, String recChange, String stage, String publishReport){
        Device__c device = new Device__c();
        
        device.Name = 'TESTDEVICE.' + recChange;
        device.Stage__c = stage;
        device.Status__c = 'Active';
        device.Project_Update__c = '<b>BOLD LETTERS</b>';
        device.Publish_Report__c = publishReport;
        device.Fab__c = 'FAB 7';
        
        device.Account__c = accountId;
        device.Opportunity2__c = opportunityId;
        device.Opportunity_Program__c = oppProgId;
        device.Confidence_Level_Tapeout__c = '75';
        
        device.Market_Segment__c = 'Automotive';
        device.Semiconductor_Device__c = 'Analog Regulator';
        device.End_Application__c = 'Body';
        device.Device_Sourcing__c = '3rd Source';
        device.Tapeout_Type__c = 'Customer MPW';
        device.Siebel_Device_ID__c = '0987654321';
        device.IP_Gap__c = false;
        device.Yield__c = 20;
        
        device.Actual_Tapeout_Date__c = date.newInstance(2013,6,20);
        device.Original_Forecasted_Tapeout_Date__c = date.newInstance(2013,6,20);
        
        insert device;
        
        return device; 
    }*/

    public static Manual_Device__c createManualDeviceFrmDevice(Device__c device) {
        Manual_Device__c testManualDevice = new Manual_Device__c();

        testManualDevice.Account__c = device.Account__c;
        testManualDevice.Account_Name__c = [ SELECT Name FROM Account WHERE Id = :device.Account__c ].get(0).Name;
        testManualDevice.Device_Id__c = device.Name;
        testManualDevice.ET_Met_Target__c = device.ET_Met_Target__c;
        testManualDevice.Fab__c = device.Fab__c;
        testManualDevice.Geometry__c = device.Geometry__c;
        testManualDevice.Prime_Die__c = device.Prime_Die__c;
        testManualDevice.Process_Family__c = device.Process_Family__c;
        testManualDevice.Project_Update__c = device.Project_Update__c;
        testManualDevice.Proto_Functional_Status__c = device.Proto_Functional_Status__c;
        testManualDevice.Region__c = device.Account__r.Region__c;
        testManualDevice.Yield__c = device.Yield__c;
        testManualDevice.Technology__c = device.Opportunity_Program__r.Technology__c;
        testManualDevice.Device__c = device.Id;

        testManualDevice.IsActive__c = true;
        testManualDevice.Publish_Report__c = device.Publish_Report__c;
        
        testManualDevice.Forecast_GDSII_In__c = device.Current_Forecast_Tapeout_Date__c;
        testManualDevice.Forecast_1st_3_reticle_Lot_Start__c = device.Forecasted_Lot_Start_Date__c;        
        
        insert testManualDevice;
        
        return testManualDevice;
    }

    public static Manual_Device__c createManualDevice(String recChange, Account account) {
        Manual_Device__c manualDevice = new Manual_Device__c();

        manualDevice.Account__c = account.Id;
        manualDevice.Device_Id__c = 'DEVICEID.' + recChange;
        manualDevice.ET_Met_Target__c = 'Yes';
        manualDevice.Fab__c = 'FAB 10';
        manualDevice.Geometry__c = '0.010UM';
        manualDevice.Prime_Die__c = 'TEST PRIME DIE';
        manualDevice.Process_Family__c = 'Interposer';
        manualDevice.Project_Update__c = '<b>TEST</b>';
        manualDevice.Proto_Functional_Status__c = 'Pending Test';
        manualDevice.Region__c = 'EUR';
        manualDevice.Yield__c = 20;
        manualDevice.Technology__c = '32SOI';
        manualDevice.Export__c = true;
        manualDevice.Account_Name__c = [ SELECT Name FROM Account WHERE Id = :account.Id ].get(0).Name;

        manualDevice.IsActive__c = true;
        manualDevice.Publish_Report__c = 'Yes';
        
        manualDevice.Forecast_GDSII_In__c = date.newInstance(2013,3,4);
        manualDevice.Forecast_1st_3_reticle_Lot_Start__c = date.newInstance(2013,10,10);        
        
        insert manualDevice;
        
        return manualDevice;
    }

    public static List<Device__c> setUpDeviceData() {
        List<Device__c> retVal = new List<Device__c>();
        
        Account account1 = getAccount('MYTEST ACCOUNT1');
        Account account2 = getAccount('MYTEST ACCOUNT2');
        Account account3 = getAccount('MYTEST ACCOUNT3');
        
        Opportunity opportunity1 = ManualDeviceTest.createOpportunity(account1.Id, 'Opportunity 1');
        Opportunity opportunity2 = ManualDeviceTest.createOpportunity(account2.Id, 'Opportunity 2');
        Opportunity opportunity3 = ManualDeviceTest.createOpportunity(account3.Id, 'Opportunity 3');
        
        Opportunity_Program__c  oppProg1 = ManualDeviceTest.createOpportunityProgram(
            account1.Id, opportunity1.Id, 'Opp Prog 1');
            
        Opportunity_Program__c  oppProg2 = ManualDeviceTest.createOpportunityProgram(
            account1.Id, opportunity2.Id, 'Opp Prog 2');
            
        Opportunity_Program__c  oppProg3 = ManualDeviceTest.createOpportunityProgram(
            account1.Id, opportunity3.Id, 'Opp Prog 3');
            
        /*Opportunity_Program__c    oppProg4 = ManualDeviceTest.createOpportunityProgram(
            account1.Id, opportunity4.Id, 'Opp Prog 4');*/
        
        // Four set of devices for each account, opprotunity
        // Set 1
        Device__c device1 = createCMPWDevice(account1.Id,oppProg1.Id);
        //ManualDeviceTest.createDevice(
        //    account1.Id, opportunity1.Id, oppProg1.Id, 'Device.1', ManualDeviceConstants.DEVICE_STAGE_SOLUTIONING, ManualDeviceConstants.PV_YES);
        Test.starttest();
        Insert device1;
        retVal.add(device1);
                    
        Device__c device2 = createCMPWDevice(account1.Id,oppProg1.Id);
        //ManualDeviceTest.createDevice(
         //   account1.Id, opportunity1.Id, oppProg1.Id, 'Device.2', ManualDeviceConstants.DEVICE_STAGE_SOLUTIONING, ManualDeviceConstants.PV_YES);
        Insert device2;
        retVal.add(device2);
            
        Device__c device3 = createCMPWDevice(account1.Id,oppProg1.Id); 
        //ManualDeviceTest.createDevice(
         //   account1.Id, opportunity1.Id, oppProg1.Id, 'Device.3', ManualDeviceConstants.DEVICE_STAGE_SOLUTIONING, ManualDeviceConstants.PV_YES);
        Insert device3;
        retVal.add(device3);
            
        Device__c device4 = createCMPWDevice(account1.Id,oppProg1.Id);
        //ManualDeviceTest.createDevice(
         //   account1.Id, opportunity1.Id, oppProg1.Id, 'Device.4', ManualDeviceConstants.DEVICE_STAGE_SOLUTIONING, ManualDeviceConstants.PV_YES);
        Insert device4;
        retVal.add(device4);

        // Set 2
        Device__c device5 = createCMPWDevice(account1.Id,oppProg1.Id);
        //ManualDeviceTest.createDevice(
         //   account2.Id, opportunity2.Id, oppProg2.Id, 'Device.5', ManualDeviceConstants.DEVICE_STAGE_SOLUTIONING, ManualDeviceConstants.PV_YES);
        Insert device5;
        retVal.add(device5);
        
        Device__c device6 = createCMPWDevice(account1.Id,oppProg1.Id);
        //ManualDeviceTest.createDevice(
          //  account2.Id, opportunity2.Id, oppProg2.Id, 'Device.6', ManualDeviceConstants.DEVICE_STAGE_SOLUTIONING, ManualDeviceConstants.PV_YES);
        Insert device6;
        retVal.add(device6);
            
        Device__c device7 = createCMPWDevice(account1.Id,oppProg1.Id);
        //ManualDeviceTest.createDevice(
        //    account2.Id, opportunity2.Id, oppProg2.Id, 'Device.7', ManualDeviceConstants.DEVICE_STAGE_SOLUTIONING, ManualDeviceConstants.PV_NO);
        Insert device7;
        retVal.add(device7);
        
        Device__c device8 = createCMPWDevice(account1.Id,oppProg1.Id);
        //ManualDeviceTest.createDevice(
         //   account2.Id, opportunity2.Id, oppProg2.Id, 'Device.8', ManualDeviceConstants.DEVICE_STAGE_SOLUTIONING, ManualDeviceConstants.PV_NO);
        Insert device8;
        retVal.add(device8);
        
        return retVal;
    }

    public static List<Manual_Device__c> setUpManualDeviceData(Account account) {
        List<Manual_Device__c> retVal = new List<Manual_Device__c>();

        Integer iterator = 0; 
        for (;iterator < 5; iterator++) {
            retVal.add(ManualDeviceTest.createManualDevice(String.valueOf(iterator), account));
        }

        return retVal;
    }
    
    static Manual_Device__c createManualDeviceRetrofit(Account account, String publishReport) {
        Manual_Device__c manualDevice = new Manual_Device__c();
        
        manualDevice.Account__c = account.Id;
        manualDevice.Device_Id__c = 'DEVICEID.' + 'MD';
        manualDevice.ET_Met_Target__c = 'Yes';
        manualDevice.Fab__c = 'FAB 10';
        manualDevice.Geometry__c = '0.010UM';
        manualDevice.Prime_Die__c = 'TEST PRIME DIE';
        manualDevice.Process_Family__c = 'Interposer';
        manualDevice.Project_Update__c = '<b>TEST</b>';
        manualDevice.Proto_Functional_Status__c = 'Pending Test';
        manualDevice.Region__c = 'EUR';
        manualDevice.Yield__c = 20;
        manualDevice.Technology__c = '32SOI';
        manualDevice.Export__c = true;

        manualDevice.IsActive__c = true;
        manualDevice.Publish_Report__c = publishReport;
        manualDevice.Tapeout_Type__c = 'Retrofit';
        manualDevice.Confidence_Level_Tapeout__c = '75';
        manualDevice.Account_Name__c = [ SELECT Name FROM Account WHERE Id = :account.Id ].get(0).Name;
        
        manualDevice.Forecast_GDSII_In__c = date.newInstance(2013,7,7);
        manualDevice.Forecast_1st_3_reticle_Lot_Start__c = date.newInstance(2013,10,10);
        manualDevice.Status__c = ManualDeviceConstants.MDEVICE_TAPEOUT;
        
        insert manualDevice;
        
        return manualDevice;
    }

    static List<Manual_Device__c> setUpManualDeviceDataFromDevice(List<Device__c> lDevice) {
        List<Manual_Device__c> retVal = new List<Manual_Device__c>();

        retVal.add(ManualDeviceTest.createManualDeviceFrmDevice(lDevice.get(0)));
        retVal.add(ManualDeviceTest.createManualDeviceFrmDevice(lDevice.get(1)));
        retVal.add(ManualDeviceTest.createManualDeviceFrmDevice(lDevice.get(2)));
        retVal.add(ManualDeviceTest.createManualDeviceFrmDevice(lDevice.get(3)));
        retVal.add(ManualDeviceTest.createManualDeviceFrmDevice(lDevice.get(4)));
        retVal.add(ManualDeviceTest.createManualDeviceFrmDevice(lDevice.get(5)));
        retVal.add(ManualDeviceTest.createManualDeviceFrmDevice(lDevice.get(6)));
        retVal.add(ManualDeviceTest.createManualDeviceFrmDevice(lDevice.get(7)));
        
        return retVal;
    }

    static testmethod void testManualDeviceTriggerDeviceIdExists() {
        
        setUpCustomSetting();
        Test.startTest();
        Account account = getAccount('MYTEST ACCOUNT1');
        Opportunity opportunity = ManualDeviceTest.createOpportunity(account.Id, 'Opportunity1');
        Opportunity_Program__c opportunityProgram = ManualDeviceTest.createOpportunityProgram(account.Id, opportunity.Id,'OpportunityProg1');
        Device__c device = createCMPWDevice(account.Id,opportunityProgram.Id);
        //Insert Device;
        //ManualDeviceTest.createDevice(account.Id, opportunity.Id, opportunityProgram.Id, 'DEVICE.1', 'Solutioning', 'Yes');
        ManualDeviceHelper.flagHelper = false;
        
        // TEST IF DEVICE CREATED USING UI OR BULK LOAD AND DEVICE ALREADY EXISTS.
        try {
            Manual_Device__c mDevice = ManualDeviceTest.createManualDeviceFrmDevice(device);
            Test.stopTest();
        } catch (System.DmlException dmlException) {
            System.debug('EXCEPTION MESSAGE ' + dmlException.getMessage());
            System.debug('EXCEPTION TYPENAME ' + dmlException.getTypeName());
            
            System.assert(dmlException.getMessage().contains('Device with Device Id already Exists'));
        }

    }

    static testmethod void testManualDeviceTriggerManualDeviceIdExists() {
        
        setUpCustomSetting();
        Account account = getAccount('MYTEST ACCOUNT1');
        ManualDeviceHelper.flagHelper = false;
                
        Manual_Device__c mDevice = ManualDeviceTest.createManualDevice('MD', account);
        
        // TEST IF DEVICE CREATED USING UI OR BULK LOAD AND DEVICE ALREADY EXISTS.
        try {
            Test.startTest();
            Manual_Device__c mDeviceNew = ManualDeviceTest.createManualDevice('MD', account);
            Test.stopTest();
        } catch (System.DmlException dmlException) {
            System.debug('EXCEPTION MESSAGE ' + dmlException.getMessage());
            System.debug('EXCEPTION TYPENAME ' + dmlException.getTypeName());
            
            System.assert(dmlException.getMessage().contains('Device with Device Id already Exists'));
        }
    }
    
    static testmethod void testManualDeviceTriggerTapeoutRetrofitStatusNo() {
        
        setUpCustomSetting();
        Account account = getAccount('MYTEST ACCOUNT1');
        ManualDeviceHelper.flagHelper = false;
                
        try {
            Test.startTest();
            Manual_Device__c manualDevice = createManualDeviceRetrofit(account, ManualDeviceConstants.PV_NO);
            Test.stopTest();
        } catch (System.DmlException dmlException) {
            System.assert(dmlException.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
        }
    }

    static testmethod void testManualDeviceTriggerTapeoutRetrofitStatusYes() {
        
        setUpCustomSetting();
        Test.startTest();
        Account account = getAccount('MYTEST ACCOUNT2');
        ManualDeviceHelper.flagHelper = false;
        
        
        Manual_Device__c manualDevice = createManualDeviceRetrofit(account, ManualDeviceConstants.PV_YES);

        manualDevice = [ SELECT RecordTypeId FROM Manual_Device__c WHERE Id = :manualDevice.Id ];
        String recordTypeId = [ SELECT Id
                                FROM RecordType 
                                WHERE DeveloperName = 'Manual_Device_DI_Read_Only' LIMIT 1].get(0).Id;
        Test.stopTest();

        System.assert(manualDevice.RecordTypeId == recordTypeId);
    }

    static testmethod void testManualDeviceTriggerCEWeeklyReportInsert() {
        
        setUpCustomSetting();
        Account account = getAccount('MYTEST ACCOUNT2');
        ManualDeviceHelper.flagHelper = true;
        
        Test.startTest();
        Manual_Device__c manualDevice = createManualDeviceRetrofit(account, ManualDeviceConstants.PV_NO);

        manualDevice = [SELECT Id, Account_Name__c FROM Manual_Device__c WHERE Id = :manualDevice.Id];
        
        System.assert(manualDevice.Account_Name__c == account.Name);
        
        manualDevice.Publish_Report__c = ManualDeviceConstants.PV_YES;
        manualDevice.Status__c = ManualDeviceConstants.MDEVICE_PROTO_RISK_PROD;
        update manualDevice;
        
        manualDevice = [ SELECT RecordTypeId FROM Manual_Device__c WHERE Id = :manualDevice.Id ];
        String recordTypeId = [ SELECT Id
                                FROM RecordType 
                                WHERE DeveloperName = 'Manual_Device_DI_Read_Only' LIMIT 1].get(0).Id;

        System.assert(manualDevice.RecordTypeId == recordTypeId);
        
        manualDevice.Status__c = ManualDeviceConstants.MDEVICE_TAPEOUT;
        update manualDevice;
        Test.stopTest();
        
        manualDevice = [ SELECT RecordTypeId FROM Manual_Device__c WHERE Id = :manualDevice.Id ];
        recordTypeId = [ SELECT Id
                         FROM RecordType 
                         WHERE DeveloperName = 'Manual_Device_DI_Read_Only' LIMIT 1].get(0).Id;

        System.assert(manualDevice.RecordTypeId == recordTypeId);
    }
    
    static testmethod void testMdToDMapTest() {
        
        setUpCustomSetting();
        Account account = getAccount('MYTEST ACCOUNT1');
                
        List<Manual_Device__c> lManualDevice = ManualDeviceTest.setUpManualDeviceData(account);
        
        Test.startTest();
        List<Device__c> lDevice = ManualDeviceHelper.convertDeviceFrmManualDevice(lManualDevice);
        Test.stopTest();
        
        for (Device__c eachDevice :lDevice) {
            for (Manual_Device__c eachManualDevice :lManualDevice) {
                if (eachManualDevice.Device_Id__c == eachDevice.Name) {
                    System.assert(eachManualDevice.Project_Update__c == eachDevice.Project_Update__c);
                    System.assert(eachManualDevice.Publish_Report__c == eachDevice.Publish_Report__c);
                }
            }
        }
    }
   

  static testmethod void testmanualDeviceCheckedToExport() {
    
        setUpCustomSetting();
        Account account = getAccount('MYTEST ACCOUNT1');
        
        Test.startTest();
        List<Manual_Device__c> lManualDevice = ManualDeviceTest.setUpManualDeviceData(account);
        ManualDeviceHelper.manualDeviceCheckedToExport();
        Test.stopTest();
  }
  
  static testMethod void testSortAsc() {
    
        Test.startTest();
        Account account1 = getAccount('MYTEST ACCOUNT1');
        
        List<Account> accList = [select Name,AccountNumber from Account limit 10];

        ManualDeviceHelper.sortList(accList,'Name', 'ASC');
        String lastValue = accList.get(accList.size() - 1).Name;
        String currentValue = null;        
        
        for (Account acc : accList) {
            currentValue = acc.Name;
            //System.assertEquals(currentValue.compareTo(lastValue)>=0, false);
        }

        Test.stopTest();
    }
    
    static testMethod void testSortDsc() {
        
        Test.startTest();
        Account account1 = getAccount('MYTEST ACCOUNT1');

        List<Account> accList = [select Name, AccountNumber from Account limit 10];
        ManualDeviceHelper.sortList(accList,'Name', 'DESC');
        String lastValue = accList.get(accList.size() - 1).Name;
        String currentValue = null;        
        
        for (Account acc : accList) {
            currentValue = acc.Name;
            //System.assertEquals(currentValue.compareTo(lastValue)<=0, false);
        }

        Test.stopTest();
    }
    
    static testMethod void testCheckedExpNoRec() {
        
        setUpCustomSetting();
        List<Manual_Device__c> lMDevice = ManualDeviceHelper.manualDeviceCheckedToExport();
        
        System.assert(lMDevice == null, true);
    }

    static testMethod void testInvalidAccount() {
        
        Test.startTest();
        setUpCustomSetting();
        Account acc = getAccount('MYTEST ACCOUNT1');
        Manual_Device__c manualDevice = ManualDeviceTest.createManualDevice('MDevice', acc);
        
        manualDevice.Account_Name__c = 'ABCD';

        try {
            update manualDevice;
        } catch (Exception eException) {
            System.debug('EXCEPTION MESSAGE ' + eException.getMessage());
            System.debug('EXCEPTION TYPENAME ' + eException.getTypeName());
            
            System.assert(eException.getMessage().contains(
                'Please Enter a Valid Account'));
        }
        Test.stopTest();
    }
    
    static testMethod void testUpdateMDevice() {
        
        Test.startTest();
        setUpCustomSetting();
        Account acc = getAccount('MYTEST ACCOUNT1');
        Opportunity opp = ManualDeviceTest.createOpportunity(acc.Id, 'OPP');
        Opportunity_Program__c oppP = ManualDeviceTest.createOpportunityProgram(acc.Id, opp.Id, 'OPPPROG');
        Device__c device = createCMPWDevice(acc.Id,oppP.Id);
        //ManualDeviceTest.createDevice(acc.Id, opp.Id, oppP.Id, 'DEV1', 'Production', 'Yes');
        //Insert device;
        Manual_Device__c manualDevice = ManualDeviceTest.createManualDevice('DEV1', acc);
        manualDevice.Device__c = device.Id;
        
        update manualDevice;
        
        ManualDeviceHelper.flagMDevUpdate = false;
        ManualDeviceHelper.flagHelper = false;
        
        manualDevice.Project_Update__c = 'Project Update';
        update manualDevice;
        
        Test.stopTest();
    }
    
    static testmethod void testInactiveMD() {
        
        Test.startTest();
        setUpCustomSetting();
        Account acc = getAccount('MYTEST ACCOUNT1');
        Manual_Device__c manualDevice = ManualDeviceTest.createManualDevice('DEV1', acc);

        Opportunity opp = ManualDeviceTest.createOpportunity(acc.Id, 'OPP');
        Opportunity_Program__c oppP = ManualDeviceTest.createOpportunityProgram(acc.Id, opp.Id, 'OPPPROG');
        Device__c device = createCMPWDevice(acc.Id, oppP.Id);
        //ManualDeviceTest.createDevice(acc.Id, opp.Id, oppP.Id, 'DEV1', 'Production', 'Yes');
        //Insert Device;
        Test.stopTest(); 
    }

    static testMethod void documentTest() {
        
        folder f = new folder();
        f = [select id from folder where name=:'Salesforce Adoption Dashboards'];
        blob body = Blob.valueOf('TEST BLOB DATA');
        ManualDeviceHelper.createDocument(f.id, body);
    }
    
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
}