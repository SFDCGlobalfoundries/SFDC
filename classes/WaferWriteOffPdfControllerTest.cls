/*
    Author: Zymark Ambat
    Description: This Class serves as the test class for WaferWriteOffPdfController.
    History: 
        ZAmbat      03162015    - Code creation.
        NJain       04272015    - SeeAddData made False
*/

@isTest(SeeAllData=false)
private class WaferWriteOffPdfControllerTest {
    
    @testSetup static void testdata(){
        DataUtilTest.loadEnvironmentVariables();
        
         Map<String,Object> fieldValueMap = new Map<String,Object>();            
        fieldValueMap.put('Name', 'Test Account 009');            
        fieldValueMap.put('stage__c', 'Unqualified');
        fieldValueMap.put('short_name__c', 'Test007');
        fieldValueMap.put('sub_type__c', 'Direct');
        fieldValueMap.put('site_department__c', 'IT');          
        fieldValueMap.put('transaction_type__c', 'Non-Transactional');
        fieldValueMap.put('account_profile__c', 'Fabless - Emerging');            
        fieldValueMap.put('Process_Tech_Interested__c', 'Mature (> 0.11um)');
        fieldValueMap.put('region__c', 'US');
        fieldValueMap.put('Sales_Territory__c', 'Greater China');
        fieldValueMap.put('financial_territory__c', 'Greater China');          
        fieldValueMap.put('Copy_Address__c', true);
        fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');
        fieldValueMap.put('Corporate_Address_2__c', 'Test Address 2');
        fieldValueMap.put('Corporate_Address_3__c', 'Test Address 3');
        fieldValueMap.put('Corporate_Address_4__c', 'Test Address 4');            
        fieldValueMap.put('Corporate_Country__c', 'Test Country');
        fieldValueMap.put('Corporate_City__c', 'Test City');
        fieldValueMap.put('Corporate_State__c', 'Test State');
        fieldValueMap.put('Corporate_Postal_Zip_Code__c', '700007');
        fieldValueMap.put('Organization_Unit__c', 'GF Investment LLC OU');
        fieldValueMap.put('bill_to_location__c', 'test');
        fieldValueMap.put('total_employee__c', 7);          
        fieldValueMap.put('end_customer__c', 'people');
        fieldValueMap.put('Revenue_Potential__c', 'Low Potential');            
        fieldValueMap.put('Target_Account__c', 'Yes');
        fieldValueMap.put('Fab_9_10__c','No');
        fieldValueMap.put('Bill_To_Address_1__c','Test Address');
        fieldValueMap.put('Account_Profile__c','Fabless - Emerging');
        fieldValueMap.put('Bill_To_City__c','Test City');
        fieldValueMap.put('Bill_To_Country__c','India');
        AccountDataFactory.createAccount(fieldValueMap);
        
        string accountId = WaferWriteOffPdfControllerTest.createAccount();
        List<Manufacturing_Lot__c> listML = WaferWriteOffPdfControllerTest.createManufacturingLot(accountId);   
        Wafer_Write_Off__c wwo = WaferWriteOffPdfControllerTest.createWaferWriteOff(accountId);
        WaferWriteOffPdfControllerTest.createLots(listML, wwo);
    }
    
    static Id createAccount() {
         Account testAcct= getAccount('Test Account 009');        
        return testAcct.Id;
    }
    
    static List<Manufacturing_Lot__c> createManufacturingLot(Id accountId) {
        List<Manufacturing_Lot__c> listML = new List<Manufacturing_Lot__c>();
        for (integer i=1; i<=40; i++) {    
            Manufacturing_Lot__c m = new Manufacturing_Lot__c();
            m.Account_Name__c = accountId;
            m.Name = 'testManufacturingLotZ' + i;
            m.Lot_Type__c = 'PB';
            m.Lot_Start_Date__c = datetime.now();
            m.Last_Ship_Date__c = date.today().addDays(50);
            m.Active_Flag__c = true;
            m.Current_Lot_Die_Quantity__c = 10;
            m.Current_Wafer_Quantity_In_Lot__c = 10;
            m.Fab_Group__c = 'Fab 2';
            listML.add(m);
        }
        
        insert listML;
        
        return listML;
    }
    
    static Wafer_Write_Off__c createWaferWriteOff(string accountId) {
        Wafer_Write_Off__c w = new Wafer_Write_Off__c();
        w.Customer_Name__c = accountId;
        w.Fab__c = 'Fab 2';
        w.Reason__c = 'Others';
        w.Other_Reason__c = 'test';
        w.Total_Value__c = 100;
        w.Total_Provisioned__c = 50;
        w.Status__c = 'Draft';
        
        insert w;
        
        return w;
    }
    
    static void createLots(List<Manufacturing_Lot__c> listML, Wafer_Write_Off__c wwo) {
        List<WaferWriteOff_ManufacturingLot__c> listWWOML = new List<WaferWriteOff_ManufacturingLot__c>();
        for (Manufacturing_Lot__c m : listML) {
            WaferWriteOff_ManufacturingLot__c w = new WaferWriteOff_ManufacturingLot__c();
            w.Wafer_Write_Off__c = wwo.Id;
            w.Manufacturing_Lot__c = m.Id;
            w.Die_Qty__c = 10;
            w.Wafer_Qty__c = 10;
            w.Lot_Type__c = 'PB';
            w.Aged_Days__c = 10;
            
            listWWOML.add(w);
        }
        
        insert listWWOML;
    }
    
    static testMethod void testWaferWriteOffPdfController() {
        Wafer_Write_Off__c wwo = [select id from Wafer_Write_Off__c limit 1];
        List<Environment_Variable__c > lstEV = new List<Environment_Variable__c >();
        Environment_Variable__c env1 = new Environment_Variable__c(name='WWO_PROFILE_1',Value__c = 'GF Planning');
        Environment_Variable__c env2 = new Environment_Variable__c(name='WWO_PROFILE_2',Value__c = 'GF Finance');
        Environment_Variable__c env3 = new Environment_Variable__c(name='WWO_PROFILE_3',Value__c = 'System Administrator;GF System Admin;GF Planning (Standard)');
        Environment_Variable__c env4 = new Environment_Variable__c(name='WWO_RECORDS_PER_PAGE',Value__c = '10');
        lstEV.add(env1);
        lstEV.add(env2);
        lstEV.add(env3);
        lstEV.add(env4);
        insert lstEV;
        
        test.startTest();
            // Submit Wafer Write Off
            Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
            req1.setObjectId(wwo.Id);
            Approval.process(req1);
            
            test.setCurrentPageReference(new PageReference('Page.WaferWriteOffPdfVF'));
            System.currentPageReference().getParameters().put('id', wwo.Id);
            ApexPages.StandardController sc;
            WaferWriteOffPdfController w = new WaferWriteOffPdfController(sc);
        test.stopTest();
    }
    
     private static Account getAccount(string AccountName)
        {
        Account testAcct= [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return testAcct;
        }
}