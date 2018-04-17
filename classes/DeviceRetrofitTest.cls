/*
    Author: Ariz Solito
    Description: Apex test class for DeviceRetrofit
    History: 
    Asolito     09062013    - Apex coded created.
    Vijay       16012015    - Updated the Device Stage 'Solutioning' to 'Design In' as Device will be created in 
                                  'Design In' directly and added mandatory fields.
    Ashwini     05142015    - Updated code for refactoring of test class.
                               
*/
@isTest(SeeAllData=false)
public with sharing class DeviceRetrofitTest {
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        
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

        AccountDataFactory.createAccount(fieldValueMap);
    }
    static Device__c createDevice(id accId, id oppId, id oppProgId){
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name','TESTDEVICE1947');
        fieldValueMap.put('Stage__c','Design In');
        fieldValueMap.put('Status__c','Active');
        fieldValueMap.put('Account__c',accId);
        fieldValueMap.put('Opportunity2__c',oppId);
        fieldValueMap.put('Opportunity_Program__c',oppProgId);
        fieldValueMap.put('Market_Segment__c','Automotive');
        fieldValueMap.put('Semiconductor_Device__c','Analog Regulator');
        fieldValueMap.put('End_Application__c','Body');
        fieldValueMap.put('Device_Sourcing__c','3rd Source');
        fieldValueMap.put('Tapeout_Type__c','Customer MPW');
        fieldValueMap.put('Siebel_Device_ID__c','0987654321');
        fieldValueMap.put('IP_Gap__c',false);
        fieldValueMap.put('BX041_Status__c','Closed');
        fieldValueMap.put('Actual_Tapeout_Date__c',date.newInstance(2013,5,20));
        fieldValueMap.put('Original_Forecasted_Tapeout_Date__c',date.newInstance(2013,5,20));
        fieldValueMap.put('Current_Forecast_Tapeout_Date__c',date.newInstance(2013,3,4));
        fieldValueMap.put('Confidence_Level_Tapeout__c','100');
        fieldValueMap.put('Fab__c','Fab 3');
        return DeviceDataFactory.createDevice(fieldValueMap);
    }
    
    static testMethod void testClass(){
        //DataUtilTest.loadEnvironmentVariables(); 
        Account acc = getAccount('MYTEST ACCOUNT1');
        
        test.startTest();
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('AccountId',acc.Id);
        fieldValueMap.put('Name','Test Opportunity');  
        fieldValueMap.put('StageName','1. Discovery');
        fieldValueMap.put('CloseDate',date.newinstance(2012, 12, 21));  
        fieldValueMap.put('Target_Process_Node__c','14XM');
        fieldValueMap.put('Market_Segment__c','Automotive');  
        fieldValueMap.put('Process_Platform__c','GF Baseline');
        fieldValueMap.put('Fab_Split__c',100);          
        fieldValueMap.put('Process_Geometry__c','0.09UM');  
        fieldValueMap.put('Process_Family__c','Generic / Nominal');
        fieldValueMap.put('Opportunity_Sourcing_Type__c','First Source');          
         
        Opportunity opp = OpportunityDataFactory.createOpportunity(fieldValueMap);
        
        Opportunity_Program__c oppProg = new Opportunity_Program__c(Name='Test OppProg',Account__c=acc.id,Opportunity__c=opp.id);
        insert oppProg;
        Mask_Set_Title__c MSTId = DeviceUtilTest.createMaskSetTtitleObj('MSTTRT');
        string MSTAccId = DeviceUtilTest.createMSTAccount(acc.Id,MSTId.id);
        Device__c dev = createDevice(acc.id,opp.id,oppProg.id);
          
        
        /*Id MSTId = DeviceUtilTest.createMaskSetTtitle();
        string MSTAccId = DeviceUtilTest.createMSTAccount(acc.id,MSTId);   
        Id dev=DeviceUtilTest.createCustomerMPWDevice(acc.id,oppProg.id);*/
        IP_Declaration_Form__c ip = new IP_Declaration_Form__c(device__c = dev.id,status__c = 'Draft');
        
        insert ip;
        
        Export_Control_HS_Code__c hs = new Export_Control_HS_Code__c(hs_code__c='test');
        insert hs;
        
        Export_Control_Form__c ex = new Export_Control_Form__c(email_address__c = 'test@test.com',phone__c = '12345678798',
                                                               customer_trade_compliance_contact_person__c = 'test',product_description__c = 'test',
                                                               weapon_product__c = 'No',military_app_product__c = 'No',ITAR_product__c = 'No',
                                                               US_EAR_product__c = 'No',Non_US_EAR_product__c = 'No',harmonized_system__c = hs.id); 
        insert ex;        
        
        Device_Export_Control_Junction__c junction = new Device_Export_Control_Junction__c(device__c = dev.id,export_control_form__c = ex.id);
        insert junction;
                
        
        //Fire the clone IP and export control method
       /* Device__c dev2 = new Device__c(Name = 'TESTDEVICE1947',Stage__c = 'Design In',Status__c = 'Active',Account__c = acc.id,
                                      Opportunity2__c = opp.id,Opportunity_Program__c = oppProg.id,Market_Segment__c = 'Automotive',
                                      Semiconductor_Device__c = 'Analog Regulator',End_Application__c = 'Body', Device_Sourcing__c = '3rd Source',
                                      Tapeout_Type__c = 'Retrofit',Siebel_Device_ID__c = '0987654321',IP_Gap__c = false,BX041_Status__c = 'Closed',
                                      Actual_Tapeout_Date__c = date.newInstance(2013,5,20),Original_Forecasted_Tapeout_Date__c = date.newInstance(2013,5,20),
                                      Current_Forecast_Tapeout_Date__c = date.newInstance(2013,3,4),device_type__c = 'Retrofit',base_device__c = dev.id,
                                      ptrf_id__c = 'TESTPTRF123');
        dev2.Confidence_Level_Tapeout__c = '100';
        dev2.Fab__c = 'Fab 3';
                                      
        insert dev2;*/
       
        //Device__c dev2=deviceUtilTest.createRetrofitDevice1(acc, opp, oppProg, dev);
       
        //Device__c dev2=deviceUtilTest.createRetrofitDevice1(dev);
       
        test.stopTest();        
        
        /*List<Device_Export_Control_Junction__c> exs = [SELECT id from Device_Export_Control_Junction__c where device__c = :dev2.id];
        system.assertEquals(1,exs.size());
        
        List<IP_Declaration_Form__c> ips = [SELECT id from IP_Declaration_Form__c where device__c = :dev2.id];
        system.assertEquals(1,ips.size());*/
    }   
    
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }

}