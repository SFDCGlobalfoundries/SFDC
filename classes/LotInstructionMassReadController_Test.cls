/*
    Author: 
    Description: 
    History:
        Yashkumar  17012014  - Added call to loadEnvironmentVariables() method.
        ravikiran  13092015  - Added Active check to the Manufacturing lot 
*/
@isTest
private class LotInstructionMassReadController_Test{
    
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MYTEST ACCOUNT1');                     
        fieldValueMap.put('sub_type__c', 'Direct');
        fieldValueMap.put('site_department__c', 'test dept');          
        fieldValueMap.put('transaction_type__c', 'transactional');                          
        fieldValueMap.put('region__c', 'APJ');        
        fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Corporate_City__c', 'Test City');                
        fieldValueMap.put('Corporate_Country__c', 'India');
        fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Bill_To_City__c', 'Test City');            
        fieldValueMap.put('Bill_To_Country__c', 'India');        
        fieldValueMap.put('Fab_9_10__c','No');

        AccountDataFactory.createAccount(fieldValueMap);
    }
    
    static testMethod void test_getSelectedSorted() {
       
        Test.startTest();   
            
            Account acc = getAccount('MYTEST ACCOUNT1');
            
            Lot_Request_Price_Table__c lotReqPriceTable = new Lot_Request_Price_Table__c();
            lotReqPriceTable.Fab__c = 'FAB 2';
            lotReqPriceTable.Geometry__c = '0.010UM';
            insert lotReqPriceTable;
            
            Fab_Cycle_Time_Table__c fabCycTimeTable = new Fab_Cycle_Time_Table__c();
            fabCycTimeTable.Fab__c = 'FAB 2';
            fabCycTimeTable.Geometry__c = '0.010UM';
            insert fabCycTimeTable;
            
            Lot_Request__c lotReq = new Lot_Request__c();
            lotReq.Lot_Request_Type__c = 'Expedite';
            lotReq.Fab__c = 'FAB 2';
            lotReq.Date_Customer_Submitted_Request__c = System.today();
            lotReq.Account__c = acc.id;
            //lotReq.Customer_Requested_New_Fabout_Date_CSR__c = System.Today() + 7;
            lotReq.New_Customer_Requested_Date_CRD_CSR__c =  System.Today() + 7;
            lotReq.Does_Customer_Accept_Standard_Pricing__c = 'Yes';
            lotReq.Lot_Request_Price_Table__c  = lotReqPriceTable.id;
            lotReq.Sales_Order_for_the_Lot__c = '123456';
            insert lotReq;
            
            Manufacturing_Lot__c mfgLot = new Manufacturing_Lot__c();
            mfgLot.name = 'Test Mfg Lot';
            mfgLot.Fab_Group__c = 'FAB 2';
            mfgLot.Geometry__c = '0.010UM';
            mfgLot.Actual_Fab_Out_Date__c = System.Today() + 3;
            mfgLot.Active_Flag__c = true;//added by ravi 
            insert mfgLot;
            
            Lot_Instruction__c  lotInstrn = new Lot_Instruction__c();
            lotInstrn.Lot_Request__c = lotReq.id;
            lotInstrn.Manufacturing_Lot__c = mfgLot.id;
            lotInstrn.New_CSD_P__c = System.Today() +4;
            insert lotInstrn;
            
            Test.setCurrentPageReference(page.LotInstructionMassRead);
            ApexPages.currentPage().getParameters().put('id',lotReq.id);
            
            Lot_Instruction__c lotIns = new Lot_Instruction__c();
            List<Lot_Instruction__c> lstLotInstr = new List<Lot_Instruction__c>();
            lstLotInstr.add(lotInstrn);
            
            
            ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(lstLotInstr);
            ssc.setSelected(new Lot_Instruction__c[]{lotInstrn});
            LotInstructionMassReadController lotObj = new LotInstructionMassReadController(ssc);
            
            
            ssc.setSelected(new Lot_Instruction__c[]{lotIns});
            LotInstructionMassReadController lotObj2 = new LotInstructionMassReadController(ssc);
            //lotObj.getSelectedSorted();                                    
    } 
    
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
}