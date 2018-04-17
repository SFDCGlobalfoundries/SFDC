/*
    Author: Ariz Solito
    Description: Apex test class for VCIDComponentConversion
    History: 
        Asolito     07/15/2013    - Code creation.
*/
@isTest(SeeAllData=false)
public with sharing class VCIDComponentConversion_Test {

 @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        // Example of how you can create an account with overwritten values
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        // Overwrite default values
        fieldValueMap.put('Name', 'TestAccount111');
        // Overwrite empty values
        fieldValueMap.put('Corporate_State__c', 'Test State');
        fieldValueMap.put('Corporate_Postal_Zip_Code__c', '700007');
        fieldValueMap.put('Copy_Address__c', true);
        fieldValueMap.put('Short_Name__c', 'TARegion1');          
        fieldValueMap.put('Account_Profile__c', 'Fabless - Emerging'); 
        fieldValueMap.put('Fab_9_10__c', 'No');                
        fieldValueMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER'));
        AccountDataFactory.createAccount(fieldValueMap);
    }
    static Device__c createDevice(Id accId, Id oppId, Id opProgId, Id prId){
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name','TESTDEVICE1313'); 
        fieldValueMap.put('Stage__c','Tapeout'); 
        fieldValueMap.put('Status__c','Active'); 
        fieldValueMap.put('Account__c',accId); 
        fieldValueMap.put('Opportunity2__c',oppId); 
        fieldValueMap.put('Opportunity_Program__c',opProgId); 
        fieldValueMap.put('Market_Segment__c','Automotive'); 
        fieldValueMap.put('Semiconductor_Device__c','Analog Regulator'); 
        fieldValueMap.put('End_Application__c','Body'); 
        fieldValueMap.put('Device_Sourcing__c','3rd Source'); 
        fieldValueMap.put('Tapeout_Type__c','Customer MPW'); 
        fieldValueMap.put('Siebel_Device_ID__c','0987654321'); 
        fieldValueMap.put('IP_Gap__c',false); 
        fieldValueMap.put('Actual_Tapeout_Date__c',date.newInstance(2013,5,20)); 
        fieldValueMap.put('Forecasted_Lot_Start_Date__c',date.newInstance(2013,5,20)); 
        fieldValueMap.put('Original_Forecasted_Tapeout_Date__c',date.newInstance(2013,5,20)); 
        fieldValueMap.put('Current_Forecast_Tapeout_Date__c',date.newInstance(2013,3,4)); 
        fieldValueMap.put('assigned_process_ID__c',prId);
        fieldValueMap.put('CRMDID__c','1234567890-TEST');
        return DeviceDataFactory.createDevice(fieldValueMap);
    }

    //test method for the class     
    static testMethod void testClass(){     
        
        Account acc = getAccount('TestAccount111');                                
        
        Process__c pr = new Process__c(
            name = '123457890',
            PID_number__c = '12345',
            process_technology__c = 'tech1'
        );
        insert pr;
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('AccountId',acc.Id);
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
         
        Opportunity opp = OpportunityDataFactory.createOpportunity(fieldValueMap);
        
        Opportunity_Program__c opProg = new Opportunity_Program__c(
            Name='Test OppProg',
            Account__c=acc.id,
            Opportunity__c=opp.id
        );
        insert opProg;
        Mask_Set_Title__c MSTId = DeviceUtilTest.createMaskSetTtitleObj('MSTTRT');
        string MSTAccId = DeviceUtilTest.createMSTAccount(acc.Id,MSTId.id);
        Test.startTest(); 
        createDevice(acc.Id, opp.Id, opProg.Id,pr.Id);
          
        
               
        
        Process_Technology__c pt = new Process_Technology__c(
            name = 'test PT',
            tech_geometry__c = '0.014UM',
            ip_geometry_technology__c = '0.014UM',
            PT_number__c = 'tech1'
        );                               
        insert pt;
         
        IP_OIC_Mapping__c OICMap = new IP_OIC_Mapping__c(
            name = 'test IP OIC',
            OIC_IP_component__c = 'OICIPComp1',         
            vcid_vendor__c = 'test vendor',
            program__c = '0.014UM',
            vcid_sub_component__c = 'subComp1',
            lookup_code__c = 'lookup1'
        ); 
        insert OICMap;
        Test.stopTest();
        
        //Fire the conversion process - SUCCESSFUL
        IP_VCID_Sub_Component__c subComp = new IP_VCID_Sub_Component__c(
            CRM_DID__c = '1234567890-TEST',
            processID__c = '123457890',
            vendor__c = 'test vendor',
            library__c = 'subComp1',
            technology__c = '0.014'
        ); 
        insert subComp;              
        
        //verify that a new VCID component has been created                 
        Datetime dt = dateTime.now().addSeconds(-1); 
        
        List<IP_VCID_Component__c> newRec = [SELECT id FROM IP_VCID_Component__c WHERE CRM_DID__c = '1234567890-TEST'];                 
        
        System.assert(true,newRec.size() == 1);                                                
    } 
    
    private static Account getAccount(string AccountName)
    {
        // Select columns you would like to use in your test class for the object. If only ID is used, just select ID
        Account acc = [SELECT Id FROM Account Where Name =: AccountName];
        
        return acc;
    }  
}