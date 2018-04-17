/**
    Class Name:    BPMDeviceIntegrationTest
    Author:        Prosenjit Saha(PS)
    Description:   Test class for BPMDeviceIntegrationTest.
    Created Date: 
      PS           11192013    - Code creation.
      ZAmbat       04282014    - Updated code to SeeAllData=true as fix for SFDC test limitations.
      Tlai         19052014    - Refactored code
      Vijay        16012015    - Updated the Device Stage 'Solutioning' to 'Design In' as Device will be created in 
                                  'Design In' directly and added mandatory fields.

    Devendra  10142015      - Updated to fix device validation error
**/

@isTest(SeeAllData=false)
public class BPMDeviceIntegrationTest
{
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        
        List<BPM_Field_Mapping__c> bmcsList = new List<BPM_Field_Mapping__c>();
        BPM_Field_Mapping__c bmcs = new BPM_Field_Mapping__c();
        bmcs.Name = 'Approval_Step';
        bmcs.SFDC_Field_Value__c = 'Approval_Step__c';
        bmcsList.add(bmcs);
        
        BPM_Field_Mapping__c bmcs1 = new BPM_Field_Mapping__c();
        bmcs1.Name = 'Approver_1';
        bmcs1.SFDC_Field_Value__c = 'Approver_1__c';
        bmcsList.add(bmcs1);
        
        BPM_Field_Mapping__c bmcs2 = new BPM_Field_Mapping__c();
        bmcs2.Name = 'Approver_2';
        bmcs2.SFDC_Field_Value__c = 'Approver_2__c';
        bmcsList.add(bmcs2);
        
        BPM_Field_Mapping__c bmcs3 = new BPM_Field_Mapping__c();
        bmcs3.Name = 'Approver_3';
        bmcs3.SFDC_Field_Value__c = 'Approver_3__c';
        bmcsList.add(bmcs3);
        
        insert bmcsList;
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MYTEST ACCOUNT1');            
        fieldValueMap.put('stage__c', 'Unqualified');        
        fieldValueMap.put('sub_type__c', 'Direct');
        fieldValueMap.put('site_department__c', 'test dept');          
        fieldValueMap.put('transaction_type__c', 'transactional');                          
        fieldValueMap.put('region__c', 'APJ');        
        fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Corporate_City__c', 'Test City');                
        fieldValueMap.put('Corporate_Country__c', 'Singapore');
        fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Bill_To_City__c', 'Test City');            
        fieldValueMap.put('Bill_To_Country__c', 'Singapore');        
        fieldValueMap.put('Fab_9_10__c','No');
        fieldValueMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER'));

        AccountDataFactory.createAccount(fieldValueMap);
    }
    
    static Device__c createDevice( ) {
        // Create Device
        String AccId = getAccount('MYTEST ACCOUNT1').id;
        String OppId = DeviceUtilTest.createOpp(AccId,'055UM');
        String OppProgID = DeviceUtilTest.createOppProg(AccId,OppId);
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name','TESTDEVICEZAIH12345677.00');
        fieldValueMap.put('Geometry_Filter__c', '0.055UM');
        fieldValueMap.put('Process_Family_Filter__c', 'MEMS');
        fieldValueMap.put('Confidence_Level_Tapeout__c', '100');    
        fieldValueMap.put('Original_Forecasted_Tapeout_Date__c', System.today());   
        fieldValueMap.put('Account__c',AccId);
        fieldValueMap.put('Opportunity2__c',OppId);
        fieldValueMap.put('Fab__c','Fab 3');
        fieldValueMap.put('GSOP_Assignment_Tapeout_Plan__c','No');
        fieldValueMap.put('Market_Segment__c','Mobility');
        fieldValueMap.put('Semiconductor_Device__c','Analog Amplifier' );
        fieldValueMap.put('End_Customer__c','Test Customer');
        fieldValueMap.put('Device_Sourcing__c','1st Source');
        fieldValueMap.put('Stage__c','Design In');
        fieldValueMap.put('Status__c','Active');
        fieldValueMap.put('Reticle_Type__c','Multi Layer Reticle (MLR)');
        fieldValueMap.put('Tapeout_Type__c','Single Product');
        fieldValueMap.put('Forecasted_Lot_Start_Date__c',date.today());
        fieldValueMap.put('Device_Mask_Set_Title__c','test');
        fieldValueMap.put('Confidence_Level_Volume__c','100');
        fieldValueMap.put('Automotive_Device__c','Yes');
        fieldValueMap.put('Automotive_Grade__c','Grade 0');
        fieldValueMap.put('Special_Scribe_Width__c','test');
        fieldValueMap.put('End_Application__c','Body');
        fieldValueMap.put('Enabled_via_previous_MPW_1__c','No');
        fieldValueMap.put('Opportunity_Program__c',OppProgID);
        return DeviceDataFactory.createDevice(fieldValueMap);  
        
        //Insert device;
        
       // return device;
    }
    
    /*static Device__c createRetrofitDevice(){
        String AccId = DeviceUtilTest.createAccount();
        String OppId = DeviceUtilTest.createOpp(AccId,'055UM');
        String OppProgID = DeviceUtilTest.createOppProg(AccId,OppId);
        Device__c device= DeviceUtilTest.createCMPWDevice(AccId,OppProgID);   
        
        device.Name = 'TESTDEVICEZAIH12345677.01';
        device.Fab__c = 'Fab 3';
        device.GSOP_Assignment_Tapeout_Plan__c = 'No';
        device.Market_Segment__c = 'Mobility';
        device.Semiconductor_Device__c = 'Analog Amplifier';
        device.End_Customer__c = 'Test Customer';
        device.Device_Sourcing__c = '1st Source';
        device.Stage__c = 'Design In';
        device.Status__c = 'Active';
        //device.Siebel_Device_ID__c = '1234567890';
        device.Tapeout_Type__c = 'Single Product';
        device.Geometry_Filter__c = '0.055UM';
        device.Process_Family_Filter__c = 'MEMS';
        device.Forecasted_Lot_Start_Date__c = date.today();
        device.Device_Mask_Set_Title__c = 'MSTTRT1';
        device.Confidence_Level_Tapeout__c = '100';
        device.Confidence_Level_Volume__c = '100';
        device.Reticle_Type__c = 'Multi Layer Reticle (MLR)';
        device.Automotive_Device__c = 'Yes';
        device.Automotive_Grade__c = 'Grade 0';
        device.Device_Sourcing__c = 'First Source';
        device.Special_Scribe_Width__c = 'test';
        
        device.Device_Type__c = 'Retrofit';
        device.PTRF_ID__c = 'bypass';
        device.Enabled_via_previous_MPW_1__c = 'No';
        device.Original_Forecasted_Tapeout_Date__c = System.today();
        device.End_Application__c = 'Body';
        
        Insert device;
        
        return device;
        
        
    }*/
    
    static List<string> retrieveApprovers() {
        List<string> listApprovers = new List<string>();
        for (User u : [SELECT    Id
                       FROM      User
                       WHERE     IsActive = true
                                 AND HCM_Login_ID__c != null
                                 AND Profile.Name LIKE '%GF%'
                       LIMIT 3]) {
            listApprovers.add(u.Id);
        }
        
        return listApprovers;
    }
    
    static void createBX041(ID deviceID, List<string> listApprovers){
        BX_041__c bx041 = new BX_041__c ();
        bx041.Device__c = deviceID;
        bx041.Geometry_Filter__c = '0.055UM';
        bx041.Process_Family_Filter__c = 'MEMS';
        bx041.BX_041_Status__c = 'Pending Review';
        bx041.Approval_Step__c = 'Pending for PIYE';
        bx041.Approver_1__c = listApprovers[0];
        bx041.Approver_2__c = listApprovers[1];
        bx041.Approver_3__c = listApprovers[2];
        insert bx041;   
    }
    
    public static String BPMServiceMockResponse() {
        String response;
        response = 'SUCCESS';
        return response;
    }
   
    static testmethod void testBPMDeviceIntegration(){
        //Device__c retrofitDev = DeviceUtilTest.createCMPWDevice(acctId,OpptyPrgmId);
        String AccId = getAccount('MYTEST ACCOUNT1').id;
        String OppId = DeviceUtilTest.createOpp(AccId,'055UM');
        String OppProgID = DeviceUtilTest.createOppProg(AccId,OppId);
        Device__c retrofitDev = DeviceUtilTest.createCMPWDevice(AccId,OppProgID);    
        Test.startTest();
        Insert retrofitDev;
        BPMDeviceIntegration.deviceBPMSFDCIntegrationMethod(retrofitDev.id,false);
        Test.stopTest();
        
    }
    
    static testmethod void testBPMDeviceTrigger(){
        String AccId = getAccount('MYTEST ACCOUNT1').id;
        String OppId = DeviceUtilTest.createOpp(AccId,'055UM');
        String OppProgID = DeviceUtilTest.createOppProg(AccId,OppId);
        Device__c dev = DeviceUtilTest.createCMPWDevice(AccId,OppProgID);    
        Test.startTest();
        Insert dev;
        dev.Status__c = 'Inactive';
        update dev;
        Test.stopTest();
        
    }
    
    static testMethod void testBPMDeviceIntegration1() {
        String AccId = getAccount('MYTEST ACCOUNT1').id;
        String OppId = DeviceUtilTest.createOpp(AccId,'055UM');
        String OppProgID = DeviceUtilTest.createOppProg(AccId,OppId);
        Device__c dev = DeviceUtilTest.createCMPWDevice(AccId,OppProgID);         
        test.startTest();
        Insert dev;
        List<string> listApprovers = BPMDeviceIntegrationTest.retrieveApprovers();
        BPMDeviceIntegrationTest.createBX041(dev.Id, listApprovers);
        
            BPMService1.SFDC_Device bpm1 = BPMDeviceIntegration.mapDevice(dev.Id);
        test.stopTest();
    }
    
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
}