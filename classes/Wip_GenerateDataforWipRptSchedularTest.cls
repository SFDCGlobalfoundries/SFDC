@isTest
public class Wip_GenerateDataforWipRptSchedularTest {
    
    @testSetup static void testdata() {
     //   DataUtilTest.loadEnvironmentVariables();
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
        Bill_To_Address_Number__c bl = new Bill_To_Address_Number__c();

               
    }
    
    static testMethod void tMethod1() {
    DataUtilTest.loadEnvironmentVariables();
        String AccId = DeviceUtilTest.createAccount();
        String OppId = DeviceUtilTest.createOpp(AccId,'055UM');
        String OppProgID = DeviceUtilTest.createOppProg(AccId,OppId); 
        
        Mask_Set_Title__c mst = new Mask_Set_Title__c();
        mst.Name = 'MSTTRT';
        mst.Reticle_Type__c = 'Multi Layer Reticle (MLR)';
        insert mst;
        Device__c device= DeviceUtilTest.createCMPWDevice(AccId,OppProgID); 
        device.Name = 'TESTDEVICEZAIH12345677.00';
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
        device.Device_Mask_Set_Title__c = 'MSTTRT';
        device.Mask_Set_Title_Lookup__c=mst.id;
        device.Confidence_Level_Tapeout__c = '100';
        device.Confidence_Level_Volume__c = '100';
        device.Reticle_Type__c = 'Multi Layer Reticle (MLR)';
        device.Automotive_Device__c = 'Yes';
        device.Automotive_Grade__c = 'Grade 0';
        device.Device_Sourcing__c = 'First Source';
        device.Special_Scribe_Width__c = 'test';
        device.End_Application__c = 'Body';
        device.Enabled_via_previous_MPW_1__c = 'No';
        device.Original_Forecasted_Tapeout_Date__c = System.today();
        test.startTest();
        try{
        Insert device;
        
        
        WIP__c wp1 = new WIP__c();
        wp1.Mask_Set__c='MSTTRT';
        wp1.External_Id__c ='MSTTRT';
         
        insert wp1;
        
        Wip_GenerateDataforWipRptSch wp = new Wip_GenerateDataforWipRptSch();
        String sch = '0 0 23 * * ?';
        system.schedule('Test Schedular Check', sch, wp ); 
        }catch (exception e){
            
        }
        test.stopTest();
    }
    private static Account getAccount(string AccountName){
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        return acct;
    }
}