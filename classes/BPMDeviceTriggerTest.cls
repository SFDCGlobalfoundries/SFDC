/*
    Author: Anirban Roy
    Description: This is the test class for the DeviceUpdateTrigger.  
    History:
        Tlai    30052014    - code creation.
        */
@isTest(SeeAllData=false)
private class BPMDeviceTriggerTest {
    @testSetup
    static void testDataSetup(){
        DataUtilTest.loadEnvironmentVariables();
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();            
        fieldValueMap.put('Name', 'MYTEST ACCOUNT1');            
        fieldValueMap.put('stage__c', 'Unqualified');
        fieldValueMap.put('short_name__c', 'MyTestACC1');
        fieldValueMap.put('sub_type__c', 'Indirect');
        fieldValueMap.put('site_department__c', 'IT');          
        fieldValueMap.put('transaction_type__c', 'transactional');
        fieldValueMap.put('account_profile__c', 'Fabless - Emerging');            
        fieldValueMap.put('Process_Tech_Interested__c', 'Mature (> 0.11um)');
        fieldValueMap.put('region__c', 'US');
        fieldValueMap.put('Sales_Territory__c', 'US-East');
        fieldValueMap.put('FE_Territory__c', 'US-FE-East');
        fieldValueMap.put('financial_territory__c', 'US-East');          
        fieldValueMap.put('Copy_Address__c', true);
        fieldValueMap.put('Corporate_Address_1__c', '50 water st');  
        fieldValueMap.put('Corporate_Address_2__c', 'Suite B'); 
        fieldValueMap.put('Corporate_City__c', 'Fremont');  
        fieldValueMap.put('Corporate_State__c', 'CA');       
        fieldValueMap.put('Corporate_Country__c', 'USA');
        fieldValueMap.put('Bill_To_Address_1__c', '50 water st');  
        fieldValueMap.put('Bill_To_Address_2__c', 'Suite B'); 
        fieldValueMap.put('Bill_To_City__c', 'Fremont');  
        fieldValueMap.put('Bill_To_State__c', 'CA');       
        fieldValueMap.put('Bill_To_Country__c', 'USA');
        fieldValueMap.put('Organization_Unit__c', 'GF Investment');
        fieldValueMap.put('bill_to_location__c', 'YES');
        fieldValueMap.put('total_employee__c', 100);          
        fieldValueMap.put('end_customer__c', 'people');
        fieldValueMap.put('Revenue_Potential__c', 'High Potential');            
        fieldValueMap.put('Target_Account__c', 'Yes');
        fieldValueMap.put('Fab_9_10__c','No');  
        fieldValueMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER'));
        fieldValueMap.put('Account_Manager__c', userinfo.getuserid());
            
        AccountDataFactory.createAccount(fieldValueMap);
    } 
    
    private static Account getAccount(string AccountName)
    {
        // Select columns you would like to use in your test class for the object. If only ID is used, just select ID
        Account acct = [SELECT Id FROM Account Where Name =: AccountName];
        
        return acct;
    }
    
    static BX_041__c createBX041(ID deviceID, String status){
        BX_041__c bx041 = new BX_041__c ();
        bx041.Device__c = deviceID;
        bx041.Geometry_Filter__c = '0.055UM';
        bx041.Process_Family_Filter__c = 'MEMS';
        bx041.BX_041_Status__c = status;
        insert bx041;  
        return bx041;  
    }
    
    static Id createOpp(Id acctId){
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('AccountId',acctId);
        fieldValueMap.put('Name','Test Opportunity');  
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
         
        return OpportunityDataFactory.createOpportunity(fieldValueMap).id;
                
    }
    
    
    static Id createOppProg(Id acctId,Id oppId){
        Opportunity_Program__c opProg = new Opportunity_Program__c(Name='Test OppProg',Account__c=acctId,Opportunity__c=oppId);
        insert opProg;
        return opProg.Id;
    }
    
    static Device__c createDevice(Id accId, Id oppId, Id oppProgId){
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name','TESTDEVICE1313');
        fieldValueMap.put('Opportunity_Program__c', oppProgId);        
        fieldValueMap.put('Fab__c', 'Fab 1');
        fieldValueMap.put('Market_Segment__c', 'Automotive');                          
        fieldValueMap.put('Semiconductor_Device__c', 'Analog Amplifier');        
        fieldValueMap.put('Device_Sourcing__c', '3rd Source');                
        fieldValueMap.put('Stage__c', 'Design In');
        fieldValueMap.put('Status__c', 'Active');          
        fieldValueMap.put('Tapeout_Type__c', 'Customer MPW');            
        fieldValueMap.put('Confidence_Level_Tapeout__c','20');
        fieldValueMap.put('End_Application__c','Body');
        fieldValueMap.put('Original_Forecasted_Tapeout_Date__c',date.newInstance(2013,3,4));
        fieldValueMap.put('Account__c',accId);
        fieldValueMap.put('Opportunity2__c',oppId);
        fieldValueMap.put('Siebel_Device_ID__c','0987654321');
        fieldValueMap.put('IP_Gap__c',false);
        fieldValueMap.put('Actual_Tapeout_Date__c',date.newInstance(2013,5,20));
        fieldValueMap.put('Forecasted_Lot_Start_Date__c',date.newInstance(2013,5,20));
        fieldValueMap.put('Current_Forecast_Tapeout_Date__c',date.newInstance(2013,3,4));
        
        return DeviceDataFactory.createDevice(fieldValueMap);
    }
    
    
    
    static Device__c createDevice2(Id accId, Id oppId, Id oppProgId){
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name','TESTDEVICE008');
        fieldValueMap.put('Stage__c','Design In');
        fieldValueMap.put('Status__c','Active');
        fieldValueMap.put('Account__c',accId);
        fieldValueMap.put('Opportunity2__c',oppId);
        fieldValueMap.put('Opportunity_Program__c',oppProgId);
        fieldValueMap.put('Market_Segment__c','Automotive');
        fieldValueMap.put('Semiconductor_Device__c','Analog Regulator');
        fieldValueMap.put('End_Application__c','Body');
        fieldValueMap.put('Device_Sourcing__c','3rd Source');
        fieldValueMap.put('Siebel_Device_ID__c','0987654321');
        fieldValueMap.put('IP_Gap__c',false);
        fieldValueMap.put('Tapeout_Type__c','Customer MPW');
        fieldValueMap.put('BX041_Status__c','Pending Review');
        fieldValueMap.put('Original_Forecasted_Tapeout_Date__c',date.newInstance(2013,3,4));
        fieldValueMap.put('Current_Forecast_Tapeout_Date__c', date.newInstance(2013,3,4));
        fieldValueMap.put('Confidence_Level_Tapeout__c','100');
        fieldValueMap.put('Fab__c','FAB 1');
        fieldValueMap.put('reticle_type__c','Small Field Reticle (SFR)');
        
        return DeviceDataFactory.createDevice(fieldValueMap);
        
    }
    
    static Device__c createDeviceRet(Id accId, Id oppId, Id oppProgId){
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name','TESTDEVICE008');
        fieldValueMap.put('Stage__c','Design In');
        fieldValueMap.put('Status__c','Active');
        fieldValueMap.put('Account__c',accId);
        fieldValueMap.put('Opportunity2__c',oppId);
        fieldValueMap.put('Opportunity_Program__c',oppProgId);
        fieldValueMap.put('Market_Segment__c','Automotive');
        fieldValueMap.put('Semiconductor_Device__c','Analog Regulator');
        fieldValueMap.put('End_Application__c','Body');
        fieldValueMap.put('Device_Sourcing__c','3rd Source');
        fieldValueMap.put('Siebel_Device_ID__c','0987654321');
        fieldValueMap.put('IP_Gap__c',false);
        fieldValueMap.put('Tapeout_Type__c','Retrofit');
        fieldValueMap.put('Device_Type__c','Retrofit');
        fieldValueMap.put('PTRF_ID__c','Test');
        fieldValueMap.put('Original_Forecasted_Tapeout_Date__c',date.newInstance(2013,3,4));
        fieldValueMap.put('Current_Forecast_Tapeout_Date__c', date.newInstance(2013,3,4));
        fieldValueMap.put('Confidence_Level_Tapeout__c','100');
        fieldValueMap.put('reticle_type__c','Small Field Reticle (SFR)');
        
        return DeviceDataFactory.createDevice(fieldValueMap);
        
    }
   
    /****************************************** BPMDeviceTrigger Test: Start*******************************************
        Author: Prosenjit Saha
        Description: This is the test class for the BPMDeviceTrigger 
    *******************************************************************************************************************/
    static testMethod void BPMDeviceTriggerTest1() {
        // Load Environment Variables  
        //DataUtilTest.loadEnvironmentVariables();
    
        String acctId = getAccount('MYTEST ACCOUNT1').id;
        String oppId = BPMDeviceTriggerTest.createOpp(acctId);
        String oppProgId = BPMDeviceTriggerTest.createOppProg(acctId, oppId);
        Mask_Set_Title__c MSTId = DeviceUtilTest.createMaskSetTtitleObj('MSTTRT');
        string MSTAccId = DeviceUtilTest.createMSTAccount(acctId,MSTId.id);
        
        test.startTest();  
        Device__c dev1 = BPMDeviceTriggerTest.createDevice(acctId,oppId,oppProgId);
        BX_041__c bx1 = BPMDeviceTriggerTest.createBX041(dev1.id, 'Pending Submission');
        
              
        /*
            dev1.BX041_Status__c = 'Pending Review';
            update dev1;
            
            dev1.BX041_Status__c = 'Pending Acknowledgement';
            update dev1;
            
            dev1.BX041_Status__c = 'Closed';
            update dev1;
            
            dev1.Confidence_Level_Tapeout__c = '50';
            update dev1;
            system.debug('--------------------------------');
            dev1.Current_Forecast_Tapeout_Date__c = system.today();
            update dev1;*/
            
        test.stopTest();
    }
      
    static testMethod void BPMDeviceTriggerTest2() {
    
        String acctId = getAccount('MYTEST ACCOUNT1').id;
        String oppId = BPMDeviceTriggerTest.createOpp(acctId);
        String oppProgId = BPMDeviceTriggerTest.createOppProg(acctId, oppId);
        Mask_Set_Title__c MSTId = DeviceUtilTest.createMaskSetTtitleObj('MSTTRT');
        string MSTAccId = DeviceUtilTest.createMSTAccount(acctId,MSTId.id);
        test.startTest();        
        Device__c dev2 = BPMDeviceTriggerTest.createDeviceRet(acctId,oppId,oppProgId);
        test.stopTest();
    }
    
    static testMethod void BPMDeviceTriggerTest3() {
        String acctId = getAccount('MYTEST ACCOUNT1').id;
        String oppId = BPMDeviceTriggerTest.createOpp(acctId);
        String oppProgId = BPMDeviceTriggerTest.createOppProg(acctId, oppId);
        Mask_Set_Title__c MSTId = DeviceUtilTest.createMaskSetTtitleObj('MSTTRT');
        string MSTAccId = DeviceUtilTest.createMSTAccount(acctId,MSTId.id);
        test.startTest();       
        Device__c dev1 = BPMDeviceTriggerTest.createDevice(acctId,oppId,oppProgId);
        //BX_041__c bx1 = BPMDeviceTriggerTest.createBX041(dev1.id,'Pending Submission');
        
         
        
            dev1.Current_Forecast_Tapeout_Date__c = system.today().adddays(7);
            update dev1;
            
        test.stopTest();
    }
    static testMethod void BPMDeviceTriggerTest4() {
        String acctId = getAccount('MYTEST ACCOUNT1').id;
        String oppId = BPMDeviceTriggerTest.createOpp(acctId);
        String oppProgId = BPMDeviceTriggerTest.createOppProg(acctId, oppId);
        Mask_Set_Title__c MSTId = DeviceUtilTest.createMaskSetTtitleObj('MSTTRT');
        string MSTAccId = DeviceUtilTest.createMSTAccount(acctId,MSTId.id);
        test.startTest();        
        Device__c dev1 = BPMDeviceTriggerTest.createDevice(acctId,oppId,oppProgId);
        //BX_041__c bx1 = BPMDeviceTriggerTest.createBX041(dev1.id,'Pending Submission');
        
        
        
            dev1.Confidence_Level_Tapeout__c = '50';
            update dev1;
            
        test.stopTest();
    }
    static testMethod void BPMDeviceTriggerTest5() {
        String acctId = getAccount('MYTEST ACCOUNT1').id;
        String oppId = BPMDeviceTriggerTest.createOpp(acctId);
        String oppProgId = BPMDeviceTriggerTest.createOppProg(acctId, oppId);
        Mask_Set_Title__c MSTId = DeviceUtilTest.createMaskSetTtitleObj('MSTTRT');
        string MSTAccId = DeviceUtilTest.createMSTAccount(acctId,MSTId.id);
        test.startTest();   
        Device__c dev1 = BPMDeviceTriggerTest.createDevice(acctId,oppId,oppProgId);
        //BX_041__c bx1 = BPMDeviceTriggerTest.createBX041(dev1.id,'Pending Submission');
        
             
        
            dev1.stage__c = 'Design In';
            update dev1;
            
        test.stopTest();
    }
    
    static testMethod void BPMDeviceTriggerTest6() {
        String acctId = getAccount('MYTEST ACCOUNT1').id;
        String oppId = BPMDeviceTriggerTest.createOpp(acctId);
        String oppProgId = BPMDeviceTriggerTest.createOppProg(acctId, oppId);
        Mask_Set_Title__c MSTId = DeviceUtilTest.createMaskSetTtitleObj('MSTTRT');
        string MSTAccId = DeviceUtilTest.createMSTAccount(acctId,MSTId.id);
        test.startTest();       
        Device__c dev1 = BPMDeviceTriggerTest.createDevice(acctId,oppId,oppProgId);
        //BX_041__c bx1 = BPMDeviceTriggerTest.createBX041(dev1.id,'Pending Submission');
        
         
        
            dev1.status__c = 'Inactive';
            update dev1;
            
        test.stopTest();
    }
    
    static testMethod void BPMDeviceTriggerTest7() {
        String acctId = getAccount('MYTEST ACCOUNT1').id;
        String oppId = BPMDeviceTriggerTest.createOpp(acctId);
        String oppProgId = BPMDeviceTriggerTest.createOppProg(acctId, oppId);
        Mask_Set_Title__c MSTId = DeviceUtilTest.createMaskSetTtitleObj('MSTTRT');
        string MSTAccId = DeviceUtilTest.createMSTAccount(acctId,MSTId.id);
        test.startTest();   
        Device__c dev1 = BPMDeviceTriggerTest.createDevice2(acctId,oppId,oppProgId);
        BX_041__c bx1 = BPMDeviceTriggerTest.createBX041(dev1.id,'Pending Review');
        
             
        
            dev1.BX041_Status__c = 'Pending Acknowledgement';
            update dev1;
            
        test.stopTest();
    }
    
    static testMethod void BPMDeviceTriggerTest8() {
        String acctId = getAccount('MYTEST ACCOUNT1').id;
        String oppId = BPMDeviceTriggerTest.createOpp(acctId);
        String oppProgId = BPMDeviceTriggerTest.createOppProg(acctId, oppId);
        Mask_Set_Title__c MSTId = DeviceUtilTest.createMaskSetTtitleObj('MSTTRT');
        string MSTAccId = DeviceUtilTest.createMSTAccount(acctId,MSTId.id);
        test.startTest(); 
        Device__c dev1 = BPMDeviceTriggerTest.createDevice2(acctId,oppId,oppProgId);
        BX_041__c bx1 = BPMDeviceTriggerTest.createBX041(dev1.id,'Pending Review');
        
               
        
            dev1.BX041_Status__c = 'Closed';
            update dev1;
            
        test.stopTest();
    }
    
    static testMethod void BPMDeviceTriggerTest9() {
        String acctId = getAccount('MYTEST ACCOUNT1').id;
        String oppId = BPMDeviceTriggerTest.createOpp(acctId);
        String oppProgId = BPMDeviceTriggerTest.createOppProg(acctId, oppId);
        Mask_Set_Title__c MSTId = DeviceUtilTest.createMaskSetTtitleObj('MSTTRT');
        string MSTAccId = DeviceUtilTest.createMSTAccount(acctId,MSTId.id);
        test.startTest();   
        Device__c dev1 = BPMDeviceTriggerTest.createDevice2(acctId,oppId,oppProgId);
        BX_041__c bx1 = BPMDeviceTriggerTest.createBX041(dev1.id,'Pending Review');
        
             
        
            dev1.BX041_Status__c = 'Frozen/Pending PID Assignment';
            update dev1;
            
        test.stopTest();
    }     
}