/*
    Author: Tanuka Sengupta
    Description: This is the test class for AccountChangeRegionUtil class.   
    History:
        TSeng       06042013    - code creation.
        TLai        26062013    - code modification for testing DeviveTrigger
        Nbustillos  11022013    - updated code logic to load environment variables
       Brathour Test1   11022015    - updated code logic to load environment variables
    Devendra  10142015      - Updated to fix device validation error
*/
@isTest(SeeAllData=false)
private class AccountChangeRegionUtilTest {
    
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        // Example of how you can create an account with overwritten values
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        // Overwrite default values
        fieldValueMap.put('Name', 'TestAccountRegion1');
        // Overwrite empty values
        fieldValueMap.put('Corporate_State__c', 'Test State');
        fieldValueMap.put('Corporate_Postal_Zip_Code__c', '700007');
        fieldValueMap.put('Copy_Address__c', true);
        fieldValueMap.put('Short_Name__c', 'TARegion1');          
        fieldValueMap.put('Account_Profile__c', 'Fabless - Emerging'); 
        fieldValueMap.put('Fab_9_10__c', 'No');                
        
        AccountDataFactory.createAccount(fieldValueMap);
    }
    
    static Id CreateMaskSetTitle(){
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name','MSTTRT1');
        fieldValueMap.put('Reticle_Type__c','Multi Layer Reticle (MLR)');
        return MaskSetTitleDataFactory.createMaskSetTitle(fieldValueMap).Id;
    }
    
    public static Device__c createSingleProductDevice(Id acctId, Id opptyId, Id opptyProgramId) {
       
        string mpwId = DeviceUtilTest.createMPWTrainMnt();
        string processId = DeviceUtilTest.createProcess('0.10UM');
        string processTechnologyId = DeviceUtilTest.createProcessTechnology();
        String MSTId = CreateMaskSetTitle();
        string MSTAccId = DeviceUtilTest.createMSTAccount(acctId,MSTId);
       // string baseDeviceId = DeviceUtilTest.createCustomerMPWDevice(acctId,opptyProgramId);
        
            // Create Device
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Account__c',acctId);
        fieldValueMap.put('Name','TESTDEVICESP');
        fieldValueMap.put('Opportunity_Program__c',opptyProgramId);
        fieldValueMap.put('Market_Segment__c','Automotive');
        fieldValueMap.put('Fab__c','FAB 2');
        fieldValueMap.put('GSOP_Assignment_Tapeout_Plan__c','No');
        fieldValueMap.put('Semiconductor_Device__c','Analog Amplifier');
        fieldValueMap.put('Device_Sourcing__c','1st Source');
        fieldValueMap.put('Stage__c','Design In');
        fieldValueMap.put('Status__c','Active');
        fieldValueMap.put('Tapeout_Type__c','Single Product');
        fieldValueMap.put('Device_Mask_Set_Title__c','MSTSP01');
        fieldValueMap.put('End_Application__c','Body');
        fieldValueMap.put('Opportunity2__c',opptyId);
        fieldValueMap.put('Actual_Tapeout_Date__c',datetime.now());
        fieldValueMap.put('Original_Forecasted_Tapeout_Date__c',date.today());
        fieldValueMap.put('Confidence_Level_Tapeout__c','100');
        fieldValueMap.put('End_Customer__c','Test Customer');
        fieldValueMap.put('PLM_Device_ID__c','ANBQP60ACO8CH-U01');
        fieldValueMap.put('Previous_Enabling_Devices_MPW__c',mpwId);
        fieldValueMap.put('Process_Family_Filter__c','Super Low Power');
        fieldValueMap.put('Assigned_Process_ID__c',processId);
        fieldValueMap.put('reticle_type__c','Small Field Reticle (SFR)');
        fieldValueMap.put('Geometry_Filter__c','0.10UM');
        fieldValueMap.put('PTRF_ID__c','test');
        fieldValueMap.put('Process_Technology_2__c',processTechnologyId);
            return DeviceDataFactory.createDevice(fieldValueMap);
    }
    
    static testMethod void testRegionChangeAction() {
        
        Account acc = getAccount('TestAccountRegion1');
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('AccountId',acc.Id);
        fieldValueMap.put('Name','Test Opportunity');  
        fieldValueMap.put('StageName','4. Decision');
        fieldValueMap.put('CloseDate',Date.Today().addDays(10));  
        fieldValueMap.put('Target_Process_Node__c','28HPP');
        fieldValueMap.put('Market_Segment__c','Mobility');  
        fieldValueMap.put('Process_Platform__c','GF Baseline');
        fieldValueMap.put('Fab_Split__c',100);          
        fieldValueMap.put('Process_Geometry__c','0.10UM');  
        fieldValueMap.put('Process_Family__c','Generic / Nominal');
        fieldValueMap.put('Opportunity_Sourcing_Type__c','Second Source');  
        fieldValueMap.put('Fab_Assignment_1__c','FAB 3');
        fieldValueMap.put('FAE_CP2__c',True);
        fieldValueMap.put('FAE_CP3__c',True); 
        Opportunity testOppty = OpportunityDataFactory.createOpportunity(fieldValueMap);
                      
        Opportunity_Program__c oppProg = new Opportunity_Program__c(
                        Name = 'TestOppProg',
                        Opportunity__c = testOppty.Id,
                        Account__c = acc.Id
                        );     
                        
        Insert oppProg;                    
        
        /*Device__c dev = new Device__c(
                        Device_ID__c = '123',
                        Stage__c = 'Solutioning',
                        Status__c = 'Active',
                        Market_Segment__c = 'Automotive',
                        Opportunity_Program__c = oppProg.Id,
                        End_Application__c = 'Body',
                        Device_Sourcing__c = 'Second Source',
                        Tapeout_Type__c = 'Single Product'
                        );
        Insert dev;*/
        test.starttest();
        Device__c device=createSingleProductDevice(acc.Id,testOppty.Id,oppProg.Id);
        
        test.stoptest();
        acc.Region__c = 'EUR';
        update acc;
        
        
        AccountChangeRegionUtil.RegionChangeAction(acc.Id);
        
        
        //Opportunity_Program__c oppRegion = [select SetGroup__c from Opportunity_Program__c where Account__c =:acc.Id];
        //system.assertEquals('EUR',oppRegion.SetGroup__c  );
        
        //Device__c devRegion = [select SetGroup__c from Device__c where Account__c =:acc.Id];
        //system.assertEquals('EUR',devRegion.SetGroup__c  );
        
         
    }
    
    private static Account getAccount(string AccountName)
    {
        // Select columns you would like to use in your test class for the object. If only ID is used, just select ID
        Account acct = [SELECT Id FROM Account Where Name =: AccountName];
        
        return acct;
    }
    
}