/*
    Author: Zymark Ambat
    Description: This Class serves as the test class for WaferWriteOffController.
    History: 
        ZAmbat      03162015    - Code creation.
        NJain       04212015    - Added calls for History related methods.
        NJain       04272015    - SeeAddData made False
*/

@isTest(SeeAllData=false)
private class WaferWriteOffControllerTest {
    
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
    }
    
    static Id createAccount() {
        // Create Account
         Account testAcct= getAccount('Test Account 100');        
        return testAcct.Id;
    }
    
    static void createManufacturingLot(Id accountId) {
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
    }
    
    static testMethod void testWaferWriteOffController() {
        string accountId = WaferWriteOffControllerTest.createAccount();
        WaferWriteOffControllerTest.createManufacturingLot(accountId);
        /*
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
        */
        test.startTest();
            // New
            test.setCurrentPageReference(new PageReference('Page.WaferWriteOffVF'));
            ApexPages.StandardController sc;
            WaferWriteOffController w = new WaferWriteOffController(sc);
            w.waferWriteOff.Customer_Name__c = accountId;
            w.waferWriteOff.Fab__c = 'Fab 2';
            w.waferWriteOff.Reason__c = 'Others';
            w.goToLotSelectionPage();
            w.waferWriteOff.Other_Reason__c = 'test';
            w.goToLotSelectionPage();
            w.lotType = 'ALL';
            w.lotName = 'testManufacturingLotZ';
            w.searchLots();
            w.getAvailableLots();
            w.getHasPreviousAL();
            w.getHasNextAL();
            w.nextAL();
            w.previousAL();
            w.nextAL();
            w.firstAL();
            w.lastAL();
            w.getLotTypes();
            
            for (integer i : w.mapAvailableLots.keySet()) {
                for (WaferWriteOffController.LotWrapper lw : w.mapAvailableLots.get(i)) {
                    lw.isSelected = true;
                }
            }
            w.saveSelectedLots();
            w.getSelectedLots();
            w.getHasPreviousSL();
            w.getHasNextSL();
            w.nextSL();
            w.previousSL();
            w.nextSL();
            w.firstSL();
            w.lastSL();
            
            for (WaferWriteOffController.LotWrapper lw : w.mapSelectedLots.get(1)) {
                lw.isSelected = true;
            }
            w.removeSelectedLots();
            
            w.saveAndExit();
            w.getShowEditButton();
            w.getShowSaveButton();
            w.getShowSubmitButton();
            w.getShowCancelButton();
            w.getShowVoidButton();
            w.getShowCloneButton();
            w.getShowExportButton();
            w.getShowSearchLotsButton();
            w.getShowInputFields();
            w.getShowOtherFields();
            w.getShowReasonCommentFields();
            w.getShowUpdateLotStatus();
            w.getShowLockImage();
            
            // Edit
            test.setCurrentPageReference(new PageReference('Page.WaferWriteOffVF'));
            System.currentPageReference().getParameters().put('id', w.waferWriteOff.Id);
            System.currentPageReference().getParameters().put('edit', '1');
            System.currentPageReference().getParameters().put('pApprovalAction', 'Approve');
            w = new WaferWriteOffController(sc);
            w.waferWriteOff.Total_Value__c = 100;
            w.waferWriteOff.Total_Provisioned__c = 10;
            w.validateValues();
            w.save();
            w.cancel();
            
            // View
            test.setCurrentPageReference(new PageReference('Page.WaferWriteOffVF'));
            System.currentPageReference().getParameters().put('id', w.waferWriteOff.Id);
            w = new WaferWriteOffController(sc);
            w.cloneRecord();
            w.exportRecord();
            
            // Clone
            test.setCurrentPageReference(new PageReference('Page.WaferWriteOffVF'));
            System.currentPageReference().getParameters().put('clone', w.waferWriteOff.Id);
            w = new WaferWriteOffController(sc);                                              
            w.save();
            w.submitForApproval();
            w.waferWriteOff.Status__c = 'Approved and Pending Planning Update in MES';
            
            for (WaferWriteOffController.LotWrapper lw : w.mapSelectedLots.get(1)) {
                lw.isSelectedStatus = true;
            }
            w.wwomlStatusComments.Status__c = 'Not Executed';
            w.wwomlStatusComments.Comments__c = 'test';
            w.updateLotStatusAndComments();
            w.save();
            w.voidForm();
            w.checkUserProfile2();
            
            //History Records
            w.getQueryWWOML();
            w.getDisablePrevious();
            w.getDisableNext();
            w.Next();
            w.Previous();
            w.exportExcel();
            
        test.stopTest();
    }  
    
     private static Account getAccount(string AccountName)
    {
        Account testAcct= [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return testAcct;
    }  
}