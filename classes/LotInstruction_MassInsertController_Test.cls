/*
    Author: 
    Description: 
    History:
        Nbustillos  10122013    - Added call to loadEnvironmentVariables() method.
*/
@isTest
private class LotInstruction_MassInsertController_Test{
    
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MYTEST ACCOUNT1');                           
        fieldValueMap.put('sub_type__c', 'Direct');
        fieldValueMap.put('site_department__c', 'test dept');          
        fieldValueMap.put('transaction_type__c', 'transactional');                          
        fieldValueMap.put('region__c', 'US');        
        fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Corporate_City__c', 'Test City');                
        fieldValueMap.put('Corporate_Country__c', 'India');
        fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Bill_To_City__c', 'Test City');            
        fieldValueMap.put('Bill_To_Country__c', 'India');        
        fieldValueMap.put('Fab_9_10__c','No');

        AccountDataFactory.createAccount(fieldValueMap);
    }
    
    static testMethod void test_normalFlow() {        
        
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
            lotReq.New_Customer_Requested_Date_CRD_CSR__c = System.Today() + 7;
            lotReq.Does_Customer_Accept_Standard_Pricing__c = 'Yes';
            lotReq.Lot_Request_Price_Table__c  = lotReqPriceTable.id;
            lotReq.Sales_Order_for_the_Lot__c = '123456';
            insert lotReq;
            
            Process__c processRec = new Process__c();
            processRec.name = 'test Process';
            processRec.Tech_Type__c = 'CT';
            processRec.Tech_Geometry__c = '0.010UM';
            insert processRec;
            
            Manufacturing_Lot__c mfgLot = new Manufacturing_Lot__c();
            mfgLot.Purchase_Order_Number__c = 'testPO';
            
            mfgLot.name = 'Test Mfg Lot';
            mfgLot.Fab_Group__c = 'FAB 2';
            mfgLot.Active_Flag__c=true;
            mfgLot.Account_Name__c = acc.id;
            mfgLot.Process_Id__c = processRec.id;
            mfgLot.Geometry__c = '0.010UM';
            mfgLot.Actual_Fab_Out_Date__c = System.Today() + 3;
            insert mfgLot;
            
            Lot_Instruction__c  lotInstrn = new Lot_Instruction__c();
            lotInstrn.Lot_Request__c = lotReq.id;
            lotInstrn.Manufacturing_Lot__c = mfgLot.id;
            lotInstrn.New_CSD_P__c = System.Today() +4;
            lotInstrn.Account__c = acc.id;
            insert lotInstrn;
            
            
            Test.setCurrentPageReference(page.LotInstruction_MassCreation);
            ApexPages.currentPage().getParameters().put('id',lotReq.id);
            
            Lot_Instruction__c lotIns = new Lot_Instruction__c();
            List<Lot_Instruction__c> lstLotInstr = new List<Lot_Instruction__c>();
            lstLotInstr.add(lotInstrn);
            
            
            ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(lstLotInstr);
            ssc.setSelected(new Lot_Instruction__c[]{lotInstrn});
            LotInstruction_MassInsertController lotObj = new LotInstruction_MassInsertController(ssc);
            
            
            ssc.setSelected(new Lot_Instruction__c[]{lotIns});
            LotInstruction_MassInsertController lotObj2 = new LotInstruction_MassInsertController(ssc);
            
            lotObj.getItems();
            
            lotObj.textToSearch = 'testPO';
            lotObj.fieldToSearch = 'Purchase_Order_Number__c';
            lotObj.searchLots();
            
            for(LotInstruction_MassInsertController.MfgLotWrapper wrapperRec:lotObj.lstMfgLotWrapper){
                wrapperRec.radioButton = True;
            }
            lotObj.createRows();
            lotObj.save();
            
    }
    
    static testMethod void test_noMfgLotSelected() {
            
        
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
            lotReq.New_Customer_Requested_Date_CRD_CSR__c = System.Today() + 7;
            lotReq.Does_Customer_Accept_Standard_Pricing__c = 'Yes';
            lotReq.Lot_Request_Price_Table__c  = lotReqPriceTable.id;
            lotReq.Sales_Order_for_the_Lot__c = '123456';
            insert lotReq;
            
            Process__c processRec = new Process__c();
            processRec.name = 'test Process';
            processRec.Tech_Type__c = 'CT';
            processRec.Tech_Geometry__c = '0.010UM';
            insert processRec;
            
            Manufacturing_Lot__c mfgLot = new Manufacturing_Lot__c();
            mfgLot.Purchase_Order_Number__c = 'testPO';
            mfgLot.name = 'Test Mfg Lot';
            mfgLot.Fab_Group__c = 'FAB 2';
            mfgLot.Active_Flag__c=true;
            mfgLot.Account_Name__c = acc.id;
            mfgLot.Process_Id__c = processRec.id;
            mfgLot.Geometry__c = '0.010UM';
            mfgLot.Actual_Fab_Out_Date__c = System.Today() + 3;
            insert mfgLot;
            
            Lot_Instruction__c  lotInstrn = new Lot_Instruction__c();
            lotInstrn.Lot_Request__c = lotReq.id;
            lotInstrn.Manufacturing_Lot__c = mfgLot.id;
            lotInstrn.New_CSD_P__c = System.Today() +4;
            lotInstrn.Account__c = acc.id;
            insert lotInstrn;
            
            
            Test.setCurrentPageReference(page.LotInstruction_MassCreation);
            ApexPages.currentPage().getParameters().put('id',lotReq.id);
            
            Lot_Instruction__c lotIns = new Lot_Instruction__c();
            List<Lot_Instruction__c> lstLotInstr = new List<Lot_Instruction__c>();
            lstLotInstr.add(lotInstrn);
            
            
            ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(lstLotInstr);
            ssc.setSelected(new Lot_Instruction__c[]{lotInstrn});
            LotInstruction_MassInsertController lotObj = new LotInstruction_MassInsertController(ssc);
            
            
            ssc.setSelected(new Lot_Instruction__c[]{lotIns});
            LotInstruction_MassInsertController lotObj2 = new LotInstruction_MassInsertController(ssc);
            
            lotObj.getItems();
            
            lotObj.textToSearch = 'testPO';
            lotObj.fieldToSearch = 'Purchase_Order_Number__c';
            lotObj.searchLots();
            
            for(LotInstruction_MassInsertController.MfgLotWrapper wrapperRec:lotObj.lstMfgLotWrapper){
                wrapperRec.radioButton = True;
            }
            lotObj.createRows();
            
    }
    
    static testMethod void test_noMatchingMfgLot() {
        
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
            lotReq.New_Customer_Requested_Date_CRD_CSR__c = System.Today() + 7;
            lotReq.Does_Customer_Accept_Standard_Pricing__c = 'Yes';
            lotReq.Lot_Request_Price_Table__c  = lotReqPriceTable.id;
            lotReq.Sales_Order_for_the_Lot__c = '123456';
            insert lotReq;
            
            Process__c processRec = new Process__c();
            processRec.name = 'test Process';
            processRec.Tech_Type__c = 'CT';
            processRec.Tech_Geometry__c = '0.010UM';
            insert processRec;
            
            Manufacturing_Lot__c mfgLot = new Manufacturing_Lot__c();
            mfgLot.Purchase_Order_Number__c = 'testPO';
            mfgLot.Active_Flag__c=true;
            mfgLot.name = 'Test Mfg Lot';
            mfgLot.Fab_Group__c = 'FAB 2';
            mfgLot.Account_Name__c = acc.id;
            mfgLot.Process_Id__c = processRec.id;
            mfgLot.Geometry__c = '0.010UM';
            mfgLot.Actual_Fab_Out_Date__c = System.Today() + 3;
            insert mfgLot;
            
            Lot_Instruction__c  lotInstrn = new Lot_Instruction__c();
            lotInstrn.Lot_Request__c = lotReq.id;
            lotInstrn.Manufacturing_Lot__c = mfgLot.id;
            lotInstrn.New_CSD_P__c = System.Today() +4;
            lotInstrn.Account__c = acc.id;
            insert lotInstrn;
            
            
            Test.setCurrentPageReference(page.LotInstruction_MassCreation);
            ApexPages.currentPage().getParameters().put('id',lotReq.id);
            
            Lot_Instruction__c lotIns = new Lot_Instruction__c();
            List<Lot_Instruction__c> lstLotInstr = new List<Lot_Instruction__c>();
            lstLotInstr.add(lotInstrn);
            
            ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(lstLotInstr);
            ssc.setSelected(new Lot_Instruction__c[]{lotInstrn});
            LotInstruction_MassInsertController lotObj = new LotInstruction_MassInsertController(ssc);
                        
            ssc.setSelected(new Lot_Instruction__c[]{lotIns});
            LotInstruction_MassInsertController lotObj2 = new LotInstruction_MassInsertController(ssc);
            
            lotObj.getItems();
            
            lotObj.textToSearch = 'testPO';
            lotObj.fieldToSearch = 'Purchase_Order_Number__c';
            lotObj.searchLots();
    }
    
    static testMethod void test_noSearchText() {
         
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
            lotReq.New_Customer_Requested_Date_CRD_CSR__c = System.Today() + 7;
            lotReq.Does_Customer_Accept_Standard_Pricing__c = 'Yes';
            lotReq.Lot_Request_Price_Table__c  = lotReqPriceTable.id;
            lotReq.Sales_Order_for_the_Lot__c = '123456';
            insert lotReq;
            
            Process__c processRec = new Process__c();
            processRec.name = 'test Process';
            processRec.Tech_Type__c = 'CT';
            processRec.Tech_Geometry__c = '0.010UM';
            insert processRec;
            
            Manufacturing_Lot__c mfgLot = new Manufacturing_Lot__c();
            mfgLot.Purchase_Order_Number__c = 'testPO';
            mfgLot.name = 'Test Mfg Lot';
            mfgLot.Active_Flag__c=true;
            mfgLot.Fab_Group__c = 'FAB 2'; 
            mfgLot.Account_Name__c = acc.id;
            mfgLot.Process_Id__c = processRec.id;
            mfgLot.Geometry__c = '0.010UM';
            mfgLot.Actual_Fab_Out_Date__c = System.Today() + 3;
            insert mfgLot;
            
            Lot_Instruction__c  lotInstrn = new Lot_Instruction__c();
            lotInstrn.Lot_Request__c = lotReq.id;
            lotInstrn.Manufacturing_Lot__c = mfgLot.id;
            lotInstrn.New_CSD_P__c = System.Today() +4;
            lotInstrn.Account__c = acc.id;
            insert lotInstrn;
                        
            Test.setCurrentPageReference(page.LotInstruction_MassCreation);
            ApexPages.currentPage().getParameters().put('id',lotReq.id);
            
            Lot_Instruction__c lotIns = new Lot_Instruction__c();
            List<Lot_Instruction__c> lstLotInstr = new List<Lot_Instruction__c>();
            lstLotInstr.add(lotInstrn);
            
            
            ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(lstLotInstr);
            ssc.setSelected(new Lot_Instruction__c[]{lotInstrn});
            LotInstruction_MassInsertController lotObj = new LotInstruction_MassInsertController(ssc);
                        
            ssc.setSelected(new Lot_Instruction__c[]{lotIns});
            LotInstruction_MassInsertController lotObj2 = new LotInstruction_MassInsertController(ssc);
            
            lotObj.getItems();
            
            lotObj.textToSearch = '';
            lotObj.fieldToSearch = 'Purchase_Order_Number__c';
            lotObj.searchLots();

        }
        
    static testMethod void test_AddNewRow() {
       
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
            lotReq.New_Customer_Requested_Date_CRD_CSR__c = System.Today() + 7;
            lotReq.Does_Customer_Accept_Standard_Pricing__c = 'Yes';
            lotReq.Lot_Request_Price_Table__c  = lotReqPriceTable.id;
            lotReq.Sales_Order_for_the_Lot__c = '123456';
            insert lotReq;
            
            Process__c processRec = new Process__c();
            processRec.name = 'test Process';
            processRec.Tech_Type__c = 'CT';
            processRec.Tech_Geometry__c = '0.010UM';
            insert processRec;
            
            Manufacturing_Lot__c mfgLot = new Manufacturing_Lot__c();
            mfgLot.Purchase_Order_Number__c = 'testPO';
            mfgLot.name = 'Test Mfg Lot';
            mfgLot.Fab_Group__c = 'FAB 2'; 
            mfgLot.Active_Flag__c=true;
            mfgLot.Account_Name__c = acc.id;
            mfgLot.Process_Id__c = processRec.id;
            mfgLot.Geometry__c = '0.010UM';
            mfgLot.Actual_Fab_Out_Date__c = System.Today() + 3;
            insert mfgLot;
            
            Lot_Instruction__c  lotInstrn = new Lot_Instruction__c();
            lotInstrn.Lot_Request__c = lotReq.id;
            lotInstrn.Manufacturing_Lot__c = mfgLot.id;
            lotInstrn.New_CSD_P__c = System.Today() +4;
            lotInstrn.Account__c = acc.id;
            insert lotInstrn;
            
            
            Test.setCurrentPageReference(page.LotInstruction_MassCreation);
            ApexPages.currentPage().getParameters().put('id',lotReq.id);
            
            Lot_Instruction__c lotIns = new Lot_Instruction__c();
            List<Lot_Instruction__c> lstLotInstr = new List<Lot_Instruction__c>();
            lstLotInstr.add(lotInstrn);
            
            
            ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(lstLotInstr);
            ssc.setSelected(new Lot_Instruction__c[]{lotInstrn});
            LotInstruction_MassInsertController lotObj = new LotInstruction_MassInsertController(ssc);
                        
            ssc.setSelected(new Lot_Instruction__c[]{lotIns});
            LotInstruction_MassInsertController lotObj2 = new LotInstruction_MassInsertController(ssc);
            lotObj.addNewRow();
            
    }
    
    static testMethod void test_paginationMethods() {
     
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
            lotReq.New_Customer_Requested_Date_CRD_CSR__c = System.Today() + 7;
            lotReq.Does_Customer_Accept_Standard_Pricing__c = 'Yes';
            lotReq.Lot_Request_Price_Table__c  = lotReqPriceTable.id;
            lotReq.Sales_Order_for_the_Lot__c = '123456';
            insert lotReq;
            
            Process__c processRec = new Process__c();
            processRec.name = 'test Process';
            processRec.Tech_Type__c = 'CT';
            processRec.Tech_Geometry__c = '0.010UM';
            insert processRec;
            
            List<Manufacturing_Lot__c> lstMfgLots = new List<Manufacturing_Lot__c>();
            for(integer i =0 ;i<25;i++){
                Manufacturing_Lot__c mfgLot = new Manufacturing_Lot__c();
                mfgLot.Purchase_Order_Number__c = 'testPO'+i;
                mfgLot.name = 'Test Mfg Lot';
                mfgLot.Fab_Group__c = 'FAB 2'; 
                mfgLot.Account_Name__c = acc.id;
                mfgLot.Active_Flag__c=true;
                mfgLot.Process_Id__c = processRec.id;
                mfgLot.Geometry__c = '0.010UM';
                mfgLot.Actual_Fab_Out_Date__c = System.Today() + 3;
                lstMfgLots.add(mfgLot);
            }
            insert lstMfgLots;
            
            Lot_Instruction__c  lotInstrn = new Lot_Instruction__c();
            lotInstrn.Lot_Request__c = lotReq.id;
            lotInstrn.Manufacturing_Lot__c = lstMfgLots[0].id;
            lotInstrn.New_CSD_P__c = System.Today() +4;
            lotInstrn.Account__c = acc.id;
            insert lotInstrn;
            
            Test.setCurrentPageReference(page.LotInstruction_MassCreation);
            ApexPages.currentPage().getParameters().put('id',lotReq.id);
            
            Lot_Instruction__c lotIns = new Lot_Instruction__c();
            List<Lot_Instruction__c> lstLotInstr = new List<Lot_Instruction__c>();
            lstLotInstr.add(lotInstrn);
            
            
            ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(lstLotInstr);
            ssc.setSelected(new Lot_Instruction__c[]{lotInstrn});
            LotInstruction_MassInsertController lotObj = new LotInstruction_MassInsertController(ssc);
            
            lotObj.textToSearch = 'testPO';
            lotObj.fieldToSearch = 'Purchase_Order_Number__c';
            lotObj.searchLots();
            
            for(LotInstruction_MassInsertController.MfgLotWrapper wrapperRec:lotObj.lstMfgLotWrapper){
                wrapperRec.radioButton = True;
            }
            lotObj.createRows();
            lotObj.getTotalPages();
            lotObj.getPageNumber();
            lotObj.getTotal_size();
            
            
            lotObj.Beginning();
            lotObj.Previous();
            lotObj.Next();
            lotObj.End();
            
            lotObj.getDisableNext();
            lotObj.getDisablePrevious();
    }
    
    static testMethod void test_removeRow() {
    
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
            lotReq.New_Customer_Requested_Date_CRD_CSR__c = System.Today() + 7;
            lotReq.Does_Customer_Accept_Standard_Pricing__c = 'Yes';
            lotReq.Lot_Request_Price_Table__c  = lotReqPriceTable.id;
            lotReq.Sales_Order_for_the_Lot__c = '123456';
            insert lotReq;
            
            Process__c processRec = new Process__c();
            processRec.name = 'test Process';
            processRec.Tech_Type__c = 'CT';
            processRec.Tech_Geometry__c = '0.010UM';
            insert processRec;
            
            Manufacturing_Lot__c mfgLot = new Manufacturing_Lot__c();
            mfgLot.Purchase_Order_Number__c = 'testPO';
            mfgLot.name = 'Test Mfg Lot';
            mfgLot.Fab_Group__c = 'FAB 2';
            mfgLot.Active_Flag__c=true;
            mfgLot.Account_Name__c = acc.id;
            mfgLot.Process_Id__c = processRec.id;
            mfgLot.Geometry__c = '0.010UM';
            mfgLot.Actual_Fab_Out_Date__c = System.Today() + 3;
            insert mfgLot;
            
            Manufacturing_Lot__c mfgLot2 = new Manufacturing_Lot__c();
            mfgLot2.Purchase_Order_Number__c = 'testPO2';
            mfgLot2.name = 'Test Mfg Lot2';
            mfgLot2.Fab_Group__c = 'FAB 2';
            mfgLot2.Active_Flag__c = true;
            mfgLot2.Account_Name__c = acc.id;
            mfgLot2.Process_Id__c = processRec.id;
            mfgLot2.Geometry__c = '0.010UM';
            mfgLot2.Actual_Fab_Out_Date__c = System.Today() + 3;
            insert mfgLot2;
            
            Lot_Instruction__c  lotInstrn = new Lot_Instruction__c();
            lotInstrn.Lot_Request__c = lotReq.id;
            lotInstrn.Manufacturing_Lot__c = mfgLot.id;
            lotInstrn.New_CSD_P__c = System.Today() +4;
            lotInstrn.Account__c = acc.id;
            insert lotInstrn;
            
            Lot_Instruction__c  lotInstrn2 = new Lot_Instruction__c();
            lotInstrn2.Lot_Request__c = lotReq.id;
            lotInstrn2.Manufacturing_Lot__c = mfgLot2.id;
            lotInstrn2.New_CSD_P__c = System.Today() +4;
            lotInstrn2.Account__c = acc.id;
            insert lotInstrn2;
            
            Test.setCurrentPageReference(page.LotInstruction_MassCreation);
            ApexPages.currentPage().getParameters().put('id',lotReq.id);
            
            Lot_Instruction__c lotIns = new Lot_Instruction__c();
            List<Lot_Instruction__c> lstLotInstr = new List<Lot_Instruction__c>();
            lstLotInstr.add(lotInstrn);
            
            
            ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(lstLotInstr);
            ssc.setSelected(new Lot_Instruction__c[]{lotInstrn});
            LotInstruction_MassInsertController lotObj = new LotInstruction_MassInsertController(ssc);
            
            lotObj.textToSearch = 'testPO';
            lotObj.fieldToSearch = 'Purchase_Order_Number__c';
            lotObj.searchLots();
            
            for(LotInstruction_MassInsertController.MfgLotWrapper wrapperRec:lotObj.lstMfgLotWrapper){
                wrapperRec.radioButton = True;
            }
            lotObj.createRows();
            lotObj.numberOfRowToRemove = 0;
    }
    
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
}