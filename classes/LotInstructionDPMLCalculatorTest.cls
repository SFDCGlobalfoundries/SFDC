/*
    Author: Zymark Ambat
    Description: This Class serves as the test class for LotInstructionDPMLCalculatorController.
    History: 
        ZAmbat      11042014    - Code creation.
*/

@isTest(SeeAllData=false)
public class LotInstructionDPMLCalculatorTest {

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
        fieldValueMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER'));
        
        AccountDataFactory.createAccount(fieldValueMap);
    }    
    
    static Id createLotServiceRequest(Id acctId) {
        Lot_Request__c l = new Lot_Request__c();
        l.Account__c = acctId;
        l.Lot_Request_Type__c = 'Standard Expedite';
        l.Sales_Order_for_the_Lot__c = 'test';
        l.Fab__c = 'FAB 2';
        l.Date_Customer_Submitted_Request__c = date.TODAY();
        //l.Customer_Requested_Lot_Quantity__c = 1;
        l.Does_Customer_Accept_Standard_Pricing__c = 'Yes';
        l.New_Customer_Requested_Date_CRD_CSR__c = date.today();
        
        insert l;
        
        return l.Id;
    }
    
    static Id createManufacturingLot(Id accountId) {
        Manufacturing_Lot__c m = new Manufacturing_Lot__c();
        m.Account_Name__c = accountId;
        m.Name = 'testML';
        m.Lot_Type__c = 'QD1';
        m.Fab_Group__c = 'FAB 2';
        m.Lot_Start_Date__c = datetime.now();
        m.Device_ID_MES__c = 'testDeviceId';
        m.Device_ID_R12__c = 'testDeviceId';
        m.Active_Flag__c = true;
        m.Current_Scheduled_Date_CSD__c = System.TODAY()+5;
        
        insert m;        
        return m.Id;
    }
    
    static Id createLotInstruction(Id lotServiceRequestId, Id manufacturingLotId, Id accountId) {
        Lot_Instruction__c l = new Lot_Instruction__c();
        l.Lot_Request__c = lotServiceRequestId;
        l.Manufacturing_Lot__c = manufacturingLotId;
        l.Lead_Time_Adder_Days__c = 1;
        l.Remaining_Mask_Count_at_New_CRD_Submiss__c = 10;
        l.New_CRD_Submitted_Date__c = date.today();
        l.Submitted_Customer_Request_Date_CRD__c = date.today().addDays(-10);
        l.Account__c = accountId;
        insert l;
        
        l.Remaining_Mask_Count_at_New_CRD_Submiss__c = 10;
        update l;
        
        return l.Id;
    }
    
    static testMethod void testLotInstructionDPMLCalculatorController1() {
        string accountId = getAccount('MYTEST ACCOUNT1').id;
        string manufacturingLotId = LotInstructionDPMLCalculatorTest.createManufacturingLot(accountId);
        string lotServiceRequestId = LotInstructionDPMLCalculatorTest.createLotServiceRequest(accountId);
        string lotInstructionId = LotInstructionDPMLCalculatorTest.createLotInstruction(lotServiceRequestId, manufacturingLotId,accountId);
        test.startTest();
            ApexPages.currentPage().getParameters().put('id', lotInstructionId);
            LotInstructionDPMLCalculatorController l = new LotInstructionDPMLCalculatorController();
            l.calculateDPML();
            l.calculateShipDate();
            l.clear();
        test.stopTest();
    }
    
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }

}