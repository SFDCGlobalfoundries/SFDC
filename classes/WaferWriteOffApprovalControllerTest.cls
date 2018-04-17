/*
    Author: Zymark Ambat
    Description: This Class serves as the test class for WaferWriteOffApprovalController.
    History: 
        ZAmbat      03162015    - Code creation.
*/

@isTest(SeeAllData=false)
private class WaferWriteOffApprovalControllerTest {
    
    @testSetup static void testdata(){
        DataUtilTest.loadEnvironmentVariables();
        
         Map<String,Object> fieldValueMap = new Map<String,Object>();            
        fieldValueMap.put('Name', 'Test Account 100');            
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
        
        string accountId = WaferWriteOffApprovalControllerTest.createAccount();
        List<Manufacturing_Lot__c> listML = WaferWriteOffApprovalControllerTest.createManufacturingLot(accountId);
        Wafer_Write_Off__c wwo = WaferWriteOffApprovalControllerTest.createWaferWriteOff(accountId);
        WaferWriteOffApprovalControllerTest.createLots(listML, wwo);
    }
    
    static Id createAccount(){
         Account testAcct= getAccount('Test Account 100');        
        return testAcct.Id;
        
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
    
    static testMethod void testWaferWriteOffApprovalController(){
        Wafer_Write_Off__c wwo =[select id from Wafer_Write_Off__c limit 1];
        test.startTest();
            // Submit Wafer Write Off
            Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
            req1.setObjectId(wwo.Id);
            Approval.process(req1);
            
            test.setCurrentPageReference(new PageReference('Page.WaferWriteOffApprovalVF'));
            System.currentPageReference().getParameters().put('id', wwo.Id);
            System.currentPageReference().getParameters().put('approvalAction', 'Approve');
            ApexPages.StandardController sc;
            WaferWriteOffApprovalController w = new WaferWriteOffApprovalController(sc);
            w.getShowApproveButton();
            w.approveReject();
            w.cancel();
        test.stopTest();
    }
    
     private static Account getAccount(string AccountName)
        {
        Account testAcct= [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return testAcct;
        }  
}