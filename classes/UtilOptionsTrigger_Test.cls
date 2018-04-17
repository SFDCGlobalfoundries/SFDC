/**
@Author <JK Technosoft>
@name <UtilOptionsTrigger_Test>
@CreateDate <06/06/2017>
@Description <Apex Test Class For UtilOptionsTrigger>
@Version <>
1.0 Created by GOPI KOKA
@reference <>
*/
@isTest
public class UtilOptionsTrigger_Test {
    @TestSetup static void testdata(){
        DataUtilTest.loadEnvironmentVariables();
        Map<String,Object> fieldValueAccMap = new Map<String,Object>();
        Account account1 = AccountDataFactory.createAccount(fieldValueAccMap);
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('AccountId',account1.id);
        fieldValueMap.put('Name','Test Opp'+system.now());  
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
        Opportunity opp1 = OpportunityDataFactory.createOpportunity(fieldValueMap);
        
        Map<String,Object> fieldValuepoppProgramMap1 = new Map<String,Object>();
        fieldValuepoppProgramMap1.put('Account__c',account1.id);
        fieldValuepoppProgramMap1.put('Opportunity__c',opp1.id);
        Opportunity_Program__c oppprogram = new Opportunity_Program__c();    
        oppprogram = OpportunityProgramDataFactory.createOpportunityProgram(fieldValuepoppProgramMap1);
                
        Device__c Dev1 = new Device__c(Name = 'TESTDEVICEZAIH12345677',
                                       Fab__c = 'FAB 2',
                                       GSOP_Assignment_Tapeout_Plan__c = 'No',
                                       Market_Segment__c = 'Automotive',
                                       Semiconductor_Device__c = 'Analog Amplifier',
                                       End_Customer__c = 'Test Customer',
                                       Stage__c = 'Design In',
                                       Status__c = 'Active',
                                       Siebel_Device_ID__c = '1234567890',
                                       Tapeout_Type__c = 'Customer MPW',
                                       PLM_Device_ID__c = 'ANBQP60ACO8CH-U01',
                                       Confidence_Level_Tapeout__c = '100',
                                       Original_Forecasted_Tapeout_Date__c = date.today().addDays(7),
                                       CRMDID__c = 'CDID0000001.00',
                                       No_of_Mask_Layers__c = 1,
                                       Device_Type__c = 'Base',
                                       reticle_type__c = 'Small Field Reticle (SFR)',
                                       End_Application__c = 'Body',
                                       Device_Sourcing__c = 'Sole Source',
                                       Opportunity_Program__c = oppprogram.Id,
                                       Internal_Device_Geometry__c='0.10UM',
                                       Internal_Device_Process_Family__c='Generic / Nominal',
                                       ITAR_Flag__c = 'TBD'                                   
                                      );       
        insert Dev1;
        
    }
    Static TestMethod void UtilOptionsTrigger() {
        Test.StartTest();
        Device__c dev1 = [SELECT Id FROM Device__c LIMIT 1];
        Opportunity opp1 = [SELECT Id,Net_Parts_Per_Wafer__c,Target_Process_Node__c FROM Opportunity LIMIT 1];
        
        ERP_Device__c erp2 = new ERP_Device__c();
        erp2.Name ='Test234056';
        erp2.Part_Number__c = 'dpn009';        
        insert erp2;                 
        
        Customer_Requirement__c cr = new Customer_Requirement__c();
        cr.Fab__c ='FAB 1';
        cr.Node__c = '0.11UM';
        cr.Technology__c = '7LP';
        cr.Deliverable_Type__c = 'Chip';
        cr.Option_Stage__c = 'Reconciliation';
        cr.Deliverable_Part_Number_DPN__c = 'dpn009';
        cr.isTCA__c = 'Yes';
        cr.Manufacturing_Deliverables__c = 'Wafer Test;test;';
        cr.Device__c = dev1.Id;
        cr.Opportunity__c = opp1.Id;
        cr.Product_Type__c = 'ASIC';
        cr.Wafer_FAB_sourcing_location_wafer_size__c = 'B323 (EFK) (300mm)';
        insert cr;                
        
        Design__c des = new Design__c();
        des.Image_Size_X_mm__c = '10';
        des.Image_Size_Y_mm__c = '10';
        des.Image_Cell_Capacty_kCells__c = 'test';
        des.Total_Levels_of_Metal__c = '1';
        des.Last_Metal_Indicator__c = 'AM';
        des.Levels_of_Metal_Used_For_Wiring__c = '1';
        des.Package_style__c = 'CBGA';
        des.Customer_Requirement__c = cr.id;
        insert des;
        
        Wafer_Data__c waf = new Wafer_Data__c();
        waf.Technical_Requirement__c = cr.id;
        waf.Active_side_interconnect_technology__c = 'C4 Bumped by Customer';
        insert waf;
        
        Module_Data__c mod = new Module_Data__c();
        mod.Technical_Requirement__c = cr.id;
        insert mod;
        
        opp1.Net_Parts_Per_Wafer__c = 1;
        opp1.Target_Process_Node__c = '0.13EE';
        update opp1;
        
        des.Last_Metal_Indicator__c = 'IL';
        des.Package_style__c = 'Name';
        update des;
        
        mod.Module_test_type_platform__c = 'Roos';
        mod.Module_Burn_In__c = 'No';
        update mod;
        
        waf.Total_number_of_masks_required_to_build__c = '1';
        waf.Back_Side_Grind__c = 'No';
        waf.Active_side_interconnect_technology__c = 'C4';
        update waf;
        
        erp2.Product_Type__c = 'ASIC';
        erp2.Chips_per_Wafer__c = 100;
        erp2.Part_Reliability_Grade__c = 'test2';
        erp2.Deliverable_Type__c = 'SIGE9HP';
        erp2.Technology__c = 'new tech';
        erp2.Subbrand__c = 'test brand';
        erp2.MD_part_name__c = 'test part';
        erp2.Brand__c = 'test brand1';
        erp2.Test_wafer__c = 'Y';
        erp2.Module_Test_Flag__c = 'Y';
        erp2.Wafer_Diameter__c = 200;
        erp2.Business_Unit__c = 'RF';
        erp2.Product_Line__c = 'RF';
        erp2.Fab__c = 'Fab 9';
        erp2.End_Application__c = 'new test app';
        erp2.Mask_Layer_Count__c = '2';
        erp2.Chips_per_Wafer__c = 3;
        erp2.Target_Process_Node__c = 'test node';
        erp2.Last_Level_of_Metal__c = '3';
        erp2.Levels_Of_Metal__c = 4;
        erp2.Package_Type__c = 'new packg';
        erp2.Module_Tester_Type__c = 'test mod';
        erp2.Burn_In__c = 'N';
        erp2.Back_Side_Grind__c = 'N';
        erp2.Bonding_Type__c = 'test bond';
        erp2.Option__c = cr.id;
        erp2.option_ID__c = cr.name;
        update erp2;
        
        cr.Modules__c = mod.id;
        cr.Design__c = des.id;
        cr.Wafer_Data__c = waf.id;
        cr.Product_Type__c = 'CSSP';
        cr.Reliability_Grade__c = 'Grade 1 (Premium)';
        cr.Deliverable_Type__c = 'Service';
        cr.MD_part_name__c = 'test';
        cr.Brand_and_Sub_brand__c = 'SERVER - ASIC';        
        cr.Manufacturing_Deliverables__c = 'Wafer Test;Module Test';         
        cr.Wafer_FAB_sourcing_location_wafer_size__c =  'BTV (200mm)';
        update cr;
        
              
        UtilOptionsTrigger.syncERPDevice(cr.id);
        system.assertEquals(cr.Brand_and_Sub_brand__c,'SERVER - ASIC');
        Test.StopTest();
    }  
}