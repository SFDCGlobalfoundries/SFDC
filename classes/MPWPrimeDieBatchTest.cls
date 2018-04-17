/**
* Author: Anil Kumar
* Company: JK Technosoft
* Project: MPW
* Description: Test Class for MPWPrimeDieBatch
* History:
*    Anil Kumar 10/02/2017 - Created
**/
@isTest
private class MPWPrimeDieBatchTest {
    @testSetup static void setupData(){
        DataUtilTest.loadEnvironmentVariables();
    }
    
    private static Account createAccount(){
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MYTEST ACCOUNT1');  
        fieldValueMap.put('Account_Type__c', 'Customer');                           
        fieldValueMap.put('sub_type__c', 'Indirect');        
        fieldValueMap.put('site_department__c', 'IT');  
        fieldValueMap.put('Account_Manager__c', userinfo.getuserid());        
        fieldValueMap.put('transaction_type__c', 'Non-Transactional');                          
        fieldValueMap.put('region__c', 'US');        
        fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Corporate_City__c', 'Test City');                
        fieldValueMap.put('Corporate_Country__c', 'Singapore');
        fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Bill_To_City__c', 'Test City');            
        fieldValueMap.put('Bill_To_Country__c', 'Singapore');        
        fieldValueMap.put('Fab_9_10__c','No');
        
        return AccountDataFactory.createAccount(fieldValueMap);
    }
    
    private static MPW_Train_Maintenance__c createTrainMaintenance() {
        MPW_Train_Maintenance__c mpwTrainMaintenance = new MPW_Train_Maintenance__c();
        mpwTrainMaintenance.Name = 'MPW0311';
        mpwTrainMaintenance.Geometry__c = '28nm';
        mpwTrainMaintenance.Publish__c = true;
        mpwTrainMaintenance.Active__c = true;
        mpwTrainMaintenance.Reservation_Close_Date__c = System.today()+10;
        mpwTrainMaintenance.Train_Type__c = 'GlobalShuttle';
        mpwTrainMaintenance.Geometry_ID__c = '0.028UM';
        mpwTrainMaintenance.Tapeout_Date_Customer__c = System.today();
        insert mpwTrainMaintenance;
        
        return mpwTrainMaintenance;
    }
    
    private static MPW_Reservation__c createReservation(MPW_Train_Maintenance__c mpwTrain, Id accId) {
        MPW_Reservation__c mpwReservation = new MPW_Reservation__c();        
        mpwReservation.MPW_Train_Name__c = mpwTrain.Id;
        mpwReservation.Name = '2015-03-05600';
        mpwReservation.Form_Status__c = 'Accepted By GlobalShuttle';
        mpwReservation.Category__c = 'FAB';
        mpwReservation.Usage__c = 'Required';
        mpwReservation.Prime_Die_Name__c = 'TestPD001';
        mpwReservation.Customer_Company_Name__c = accId;
        insert mpwReservation;
        
        return mpwReservation;
    }
    
    private static MPW_Prime_Die__c createPrimeDie(MPW_Reservation__c mpwReservation) {
        MPW_Prime_Die__c mpwPrimeDie1 = new MPW_Prime_Die__c();
        mpwPrimeDie1.Prime_Die_Name__c = 'TestPD001';
        mpwPrimeDie1.MPW_Form__c = mpwReservation.Id;
        mpwPrimeDie1.Drawn_Die_Size_X_um__c = '1234';
        mpwPrimeDie1.Drawn_Die_Size_Y_um__c = '2344';
        mpwPrimeDie1.Device_Type__c = 'Product';
        mpwPrimeDie1.Delivery_Qty_Die_Form__c = '100';
        mpwPrimeDie1.Delivery_Qty_Wafer_Form__c = '2';
        mpwPrimeDie1.Drawn_Orientation_Restricted_Structures__c= 'Test';
        mpwPrimeDie1.Metal_Stack__c = 'Test';
        mpwPrimeDie1.Corner_Split__c = 'No';
        mpwPrimeDie1.FF__c = '0';
        mpwPrimeDie1.FS__c = '0';
        mpwPrimeDie1.POR__c = '0';
        mpwPrimeDie1.SF__c = '0';
        mpwPrimeDie1.SS__c = '0';
        mpwPrimeDie1.Extra_Die_Qty__c = 1;
        mpwPrimeDie1.Extra_Wafer_Qty__c = 2;
        mpwPrimeDie1.GMPL_Purpose__c = 'Test';
        mpwPrimeDie1.ShortLoop_Wafer__c = '4';
        mpwPrimeDie1.Backgrind__c = '10';
        mpwPrimeDie1.Expedite_In_DIE_Form__c = '100';
        mpwPrimeDie1.Expedite_In_WAFER_Form__c = '5';
        mpwPrimeDie1.Turnkey_Service__c = 'No';
        mpwPrimeDie1.Extra_Die_Qty_Cumulative__c = 0;
        insert mpwPrimeDie1;
        
        return mpwPrimeDie1;
    }
    
    private static Opportunity createOpportunity(Id acctId){
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'Test Opportunity');  
        fieldValueMap.put('AccountId', acctId);                           
        fieldValueMap.put('StageName', '1. Discovery');        
        fieldValueMap.put('Market_Segment__c', 'Automotive');  
        fieldValueMap.put('Target_Process_Node__c', '14XM');        
        fieldValueMap.put('Process_Platform__c', 'GF Baseline');   
        fieldValueMap.put('Opportunity_Sourcing_Type__c', 'First Source');   
        fieldValueMap.put('Process_Geometry__c', '0.09UM');   
        fieldValueMap.put('Process_Family__c', 'Generic / Nominal');   
        fieldValueMap.put('Fab_Split__c', 100);   
        fieldValueMap.put('CloseDate', date.newinstance(2012, 12, 21));   
        
        return OpportunityDataFactory.createOpportunity(fieldValueMap);
    }
    
    private static Opportunity_Program__c createOpportunityProgram(Id acctId, Id oppId){
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'Test OppProg');  
        fieldValueMap.put('Account__c', acctId);                           
        fieldValueMap.put('Opportunity__c', oppId);        
        
        return OpportunityProgramDataFactory.createOpportunityProgram(fieldValueMap);
    }
    
    private static Process__c createProcess(){
        Process__c p = new Process__c();
        p.Name = 'TestProcess';
        p.Available_to_Sell__c = 'Available';
        insert p;
        
        return p;  
    }
    
    private static Device__c createDevice1(Id accId, Id oppId, Id oppProgId, Id processId){
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MPW0311');  
        fieldValueMap.put('Stage__c', 'Design In');                           
        fieldValueMap.put('Status__c', 'Active');        
        fieldValueMap.put('Account__c', accId);  
        fieldValueMap.put('Opportunity2__c', oppId);        
        fieldValueMap.put('Opportunity_Program__c', oppProgId);  
        fieldValueMap.put('Device_Mask_Set_Title__c', 'MPW0311');       
        fieldValueMap.put('Market_Segment__c', 'Automotive');        
        fieldValueMap.put('Semiconductor_Device__c', 'Analog Regulator');          
        fieldValueMap.put('End_Application__c', 'Body');                
        fieldValueMap.put('Device_Sourcing__c', '3rd Source');
        fieldValueMap.put('Tapeout_Type__c', 'Customer MPW');          
        fieldValueMap.put('Siebel_Device_ID__c', '0987654321');            
        fieldValueMap.put('IP_Gap__c', false);        
        fieldValueMap.put('Assigned_Process_ID__c',processId);
        fieldValueMap.put('BX041_Status__c', 'Closed');          
        fieldValueMap.put('Actual_Tapeout_Date__c', date.newInstance(2013,5,20));            
        fieldValueMap.put('Original_Forecasted_Tapeout_Date__c', date.newInstance(2013,5,20));        
        fieldValueMap.put('Current_Forecast_Tapeout_Date__c',date.newInstance(2013,3,4));
        
        return DeviceDataFactory.createDevice(fieldValueMap);
    }
    
    private static Device__c createDevice2(Id accId, Id oppId, Id oppProgId, Id processId){
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MPW0311_TestPD001');  
        fieldValueMap.put('Stage__c', 'Design In');                           
        fieldValueMap.put('Status__c', 'Active');        
        fieldValueMap.put('Account__c', accId);  
        fieldValueMap.put('Opportunity2__c', oppId);        
        fieldValueMap.put('Opportunity_Program__c', oppProgId);    
        fieldValueMap.put('Device_Mask_Set_Title__c', 'MPW0311');       
        fieldValueMap.put('Market_Segment__c', 'Automotive');        
        fieldValueMap.put('Semiconductor_Device__c', 'Analog Regulator');          
        fieldValueMap.put('End_Application__c', 'Body');                
        fieldValueMap.put('Device_Sourcing__c', '3rd Source');
        fieldValueMap.put('Tapeout_Type__c', 'Customer MPW');          
        fieldValueMap.put('Siebel_Device_ID__c', '0987654321');            
        fieldValueMap.put('IP_Gap__c', false);        
        fieldValueMap.put('Assigned_Process_ID__c',processId);
        fieldValueMap.put('BX041_Status__c', 'Closed');          
        fieldValueMap.put('Actual_Tapeout_Date__c', date.newInstance(2013,5,20));            
        fieldValueMap.put('Original_Forecasted_Tapeout_Date__c', date.newInstance(2013,5,20));        
        fieldValueMap.put('Current_Forecast_Tapeout_Date__c',date.newInstance(2013,3,4));
        
        return DeviceDataFactory.createDevice(fieldValueMap);
    }
    
    private static Mask_Set_Title__c createMaskSetTitle(){
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MPW0311');  
        fieldValueMap.put('Is_Available_For_Use__c', true);                           
        fieldValueMap.put('Status__c', 'Active');              
        
        return MaskSetTitleDataFactory.createMaskSetTitle(fieldValueMap);
    }
    
    private static MSTAccount__c createMSTAccount(Id accId, Id mstId){
        MSTAccount__c oMSTAccount = new MSTAccount__c();
        oMSTAccount.Account__c = accId;
        oMSTAccount.Mask_Set_Title__c = mstId;
        insert oMSTAccount;
        
        return oMSTAccount;
    }
    
    private static PTRF__c createPTRF(Id mstId, Id deviceId, Id accId){
       PTRF__c oPTRF = new PTRF__c();
       oPTRF.Status__c = 'Perform Tapeout Options';
       oPTRF.MaskSetTitle__c = mstId;
       oPTRF.Device_Id__c = 'Device1234';
       oPTRF.Transaction_Date__c = System.today();
       oPTRF.Process_ID__c = '';
       oPTRF.Prime_Tapeout__c = true;
       oPTRF.Prime_Status__c = '';
       oPTRF.Prime_DRT__c = '';
       oPTRF.Order_Type__c = 'Retrofit';
       oPTRF.Frame_Status__c = '';
       oPTRF.Frame_Mockup__c = false;
       oPTRF.Frame_GDSOUT_Review__c = false;
       oPTRF.Frame_DRT__c = '';
       oPTRF.Frame_Tapeout__c = false;
       oPTRF.DRC_Only__c = false;
       oPTRF.Prime_GDSOUT_Review__c = false;
       oPTRF.Device__c = deviceId;
       oPTRF.Recticle_Type__c = 'Single Layer Reticle (SLR)';
       oPTRF.DRC_DRW_Status__c = 'Completed';
       oPTRF.Customer__c = accId;
       insert oPTRF;
                                    
       return oPTRF;
    }
    
    private static Wavier_Collaborator__c createWavierCollaborator(Id deviceId, Id accId){
        Wavier_Collaborator__c waiverColl = new Wavier_Collaborator__c();
        waiverColl.FAB__c = '1';
        waiverColl.Metal_Stacks__c = 'Test Metal Stack';
        waiverColl.PTSR_Status__c = 'Approved';
        waiverColl.PTSR_Service_Type__c = 'DRC Service Request'; 
        waiverColl.Waiver_Status__c = 'Open';
        waiverColl.DFM_Design_Type__c = 'chip';
        waiverColl.DFMServiceOption__c = 'Waiver Request';
        waiverColl.Mask_Set_Title__c = 'MPW0311';
        waiverColl.CRM_Device__c = deviceId;
        waiverColl.Submitted_Date__c = System.today();
        waiverColl.Account__c = accId;
        insert waiverColl;
                                    
        return waiverColl;
    }
    
    static testMethod void MPWPrimeDieBatchTest1() {       
        Account acc = createAccount();
        MPW_Train_Maintenance__c mpwTrainMaintenance = createTrainMaintenance();
        MPW_Reservation__c mpwReservation = createReservation(mpwTrainMaintenance, acc.Id);
        MPW_Prime_Die__c mpwPrimeDie = createPrimeDie(mpwReservation);
        Opportunity opp = createOpportunity(acc.Id);
        Opportunity_Program__c oppProg = createOpportunityProgram(acc.Id, opp.Id);
        Process__c p = createProcess();
        Mask_Set_Title__c mst = createMaskSetTitle();
        MSTAccount__c mstAccount = createMSTAccount(acc.Id, mst.Id);
        
        Test.startTest();
        
        Device__c device = createDevice1(acc.Id, opp.Id, oppProg.Id, p.Id);
        PTRF__c ptrf = createPTRF(mst.Id, device.Id, acc.Id);
        
        Chip_Detail__c oCD = new Chip_Detail__c();
        oCD.Name = 'TestPD001';
        oCD.PTRF__c = ptrf.Id;
        insert oCD;
        
        //Test.startTest();
        
        MPWPrimeDieBatch b = new MPWPrimeDieBatch(null);
        Database.executeBatch(b, 1);
        
        Test.stopTest();
    }
    
    static testMethod void MPWPrimeDieBatchTest2() {       
        Account acc = createAccount();
        MPW_Train_Maintenance__c mpwTrainMaintenance = createTrainMaintenance();
        MPW_Reservation__c mpwReservation = createReservation(mpwTrainMaintenance, acc.Id);
        MPW_Prime_Die__c mpwPrimeDie = createPrimeDie(mpwReservation);
        Opportunity opp = createOpportunity(acc.Id);
        Opportunity_Program__c oppProg = createOpportunityProgram(acc.Id, opp.Id);
        Process__c p = createProcess();
        Mask_Set_Title__c mst = createMaskSetTitle();
        MSTAccount__c mstAccount = createMSTAccount(acc.Id, mst.Id);
        
        Test.startTest();
        
        Device__c device = createDevice2(acc.Id, opp.Id, oppProg.Id, p.Id);
        Wavier_Collaborator__c wc = createWavierCollaborator(device.Id, acc.Id);
        
        //Test.startTest();
        
        MPWPrimeDieBatch b = new MPWPrimeDieBatch(null);
        Database.executeBatch(b, 1);
        
        Test.stopTest();
    }
}