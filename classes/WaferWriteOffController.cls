/*
    Author: Zymark Ambat
    Description: This Class serves as the controller for the WaferWriteOffVF.
    History: 
        ZAmbat      01292015    - Code creation.
        NJain       04212015    - Added logic for displaying History records for WWOML records.
                                  Added a method ExportExcel for exporting WWOML records in Excel sheet.
*/

public class WaferWriteOffController{
    public string pageMode {get;set;}
    public string lotType {get;set;}
    public string mesDeviceId {get;set;}
    public string lotName {get;set;}
    public string createdDateTime {get;set;}
    public string lastModifiedDateTime {get;set;}
    public integer currentPageNoSL {get;set;}
    public integer totalNoOfPagesSL {get;set;}
    public integer totalNoOfRecordsSL {get;set;}
    public integer currentPageNoAL {get;set;}
    public integer totalNoOfPagesAL {get;set;}
    public integer totalNoOfRecordsAL {get;set;}
    public boolean isNew {get;set;}
    public boolean isEdit {get;set;}
    public boolean isClone {get;set;}
    public boolean showMainSection {get;set;}
    public boolean showLotSelectionSection {get;set;}
    public boolean editValue {get;set;}
    public boolean editStatus {get;set;}
    public Set<Id> selectedLotIds {get;set;}
    public Wafer_Write_Off__c waferWriteOff {get;set;}
    public WaferWriteOff_ManufacturingLot__c wwoMl {get;set;}
    public WaferWriteOff_ManufacturingLot__c wwomlStatusComments {get;set;}
    public Map<integer, List<LotWrapper>> mapSelectedLots {get;set;}
    public Map<integer, List<LotWrapper>> mapAvailableLots {get;set;} 
    
    public WaferWriteOffController(ApexPages.StandardController controller) {
        // init
        this.currentPageNoSL = 1;
        this.currentPageNoAL = 1;
        this.totalNoOfPagesSL = 0;
        this.totalNoOfPagesAL = 0;
        this.totalNoOfRecordsSL = 0;
        this.totalNoOfRecordsAL = 0;
        this.waferWriteOff = new Wafer_Write_Off__c();
        this.selectedLotIds = new Set<Id>();
        this.mapSelectedLots = new Map<integer, List<LotWrapper>>();
        this.mapAvailableLots = new Map<integer, List<LotWrapper>>();
        this.showMainSection = true;
        this.showLotSelectionSection = false;
        this.isEdit = false;
        this.isClone = false;
        this.editValue = false;
        this.editStatus = false;
        this.pageMode = 'detail';
        this.lotName = '';
        this.mesDeviceId = '';
        this.lotType = 'ALL';
        this.wwomlStatusComments = new WaferWriteOff_ManufacturingLot__c();

        if (ApexPages.currentPage().getParameters().get('id') != null) {
            this.isNew = false; 
            if (ApexPages.currentPage().getParameters().get('edit') != null) {
                this.isEdit = true;
                this.pageMode = 'edit';
            }
            
            this.waferWriteOff = retrieveWaferWriteOffDetails(ApexPages.currentPage().getParameters().get('id'));
            checkUserProfile1();    
            if (this.waferWriteOff.Status__c == 'Approved and Pending Planning') {
                checkUserProfile2();
            }
        } else {
            this.isNew = true;
            if (ApexPages.currentPage().getParameters().get('clone') != null) {
                this.isClone = true;
                Wafer_Write_Off__c tempWWO = retrieveWaferWriteOffDetails(ApexPages.currentPage().getParameters().get('clone'));
                this.waferWriteOff = tempWWO.clone(false, true);
                this.waferWriteOff.Date_Submitted_for_Approval__c = null;
                this.waferWriteOff.In_Approval_Process__c = false;
                this.waferWriteOff.Date_Submitted_for_Approval__c = null;
                this.waferWriteOff.Total_Value__c = null;
                this.waferWriteOff.Total_Provisioned__c = null;
            }
            this.waferWriteOff.Status__c = 'Draft';
        }
        CountTotalRecords = [SELECT COUNT() FROM WaferWriteOff_ManufacturingLot__history
                             WHERE Parent.Wafer_Write_Off__c = :ApexPages.currentPage().getParameters().get('id')
                                 AND Field in ('Status__c','Comments__c')];
                                 
    }
    
    public Wafer_Write_Off__c retrieveWaferWriteOffDetails(string wId) {
        Wafer_Write_Off__c w = [
            SELECT      Id
                        , Name
                        , Customer_Name__c
                        , Customer_Name__r.Short_Name__c
                        , Customer_Name__r.Region__c
                        , Fab__c
                        , Status__c
                        , CreatedById
                        , In_Approval_Process__c
                        , Total_Die_Qty__c
                        , Total_Wafer_Qty__c
                        , Date_Submitted_for_Approval__c
                        , No_of_Lots__c
                        , Reason__c
                        , Other_Reason__c
                        , Comments__c
                        , Total_Value__c
                        , Total_Provisioned__c
                        , Total_Impact_to_P_L__c
                        , OwnerId
                        , LastModifiedById
                        , App_and_Pend_Plan_Update_in_MES_DateTime__c
                        , CreatedDate
                        , LastModifiedDate
                        , Account_Region_Head__c
                        , Account_Sales_SVP__c
            FROM        Wafer_Write_Off__c
            WHERE       Id = :wId
        ];

        this.createdDateTime = w.CreatedDate.format();
        this.lastModifiedDateTime = w.LastModifiedDate.format();
        
        // Retrieve selected lots
        if (this.isEdit
            || (!this.isNew && !this.isEdit)
            || (this.isNew && this.isClone
                && (w.Status__c == 'Draft'
                    || w.Status__c == 'Rejected'
                    || w.Status__c == 'Closed'
                    || w.Status__c == 'Void'))) {
            retrieveSelectedLots(wId);
        }
        
        return w;
    }
    
    public Set<Id> getAccountIdsByHierarchy() {
        // Get Account info
        Account a = [
            SELECT  Id
                    , Name
                    , ParentId
            FROM    Account
            WHERE   Id = :this.waferWriteOff.Customer_Name__c
        ];
        
        // Get Accounts in the Account Hierarchy
        Set<Id> accountIds = new Set<Id>();  
        if (a.ParentId != null) {
            for (Account_Hierarchy__c ah : [SELECT      Parent_Id__c
                                                        , Parent_Id__r.Name
                                                        , Parent_Account_Short_Name__c
                                            FROM        Account_Hierarchy__c
                                            WHERE       Account_Id__c = :a.Id
                                                        AND Parent_Id__c != :a.Id]) { 
                accountIds.add(ah.Parent_Id__c);
            }
        } 
           
        // Check for Devices below the Account Hierarchy
        for (Account_Hierarchy__c ah : [SELECT      Account_Id__c
                                                    , Account_Id__r.Name
                                                    , Account_Short_Name__c
                                        FROM        Account_Hierarchy__c
                                        WHERE       Parent_Id__c = :a.Id
                                                    AND Account_Id__c != :a.Id]) { 
            accountIds.add(ah.Account_Id__c);
        }
        
        // Add User's Account Id
        accountIds.add(a.Id);
        
        return accountIds;
    }
    
    public void retrieveSelectedLots(string wId) {
        this.mapSelectedLots = new Map<integer, List<LotWrapper>>();
        this.totalNoOfPagesSL = 0;
        this.totalNoOfRecordsSL = 0;
        
        // Retrieve selected records
        this.selectedLotIds = new Set<Id>();
        List<LotWrapper> tempListSL = new List<LotWrapper>();
        List<WaferWriteOff_ManufacturingLot__c> listFilteredLots = new List<WaferWriteOff_ManufacturingLot__c>();
        List<WaferWriteOff_ManufacturingLot__c> tempList = [SELECT    Id
                                                                      , Manufacturing_Lot__c  
                                                                      , Manufacturing_Lot__r.Account_Name__c
                                                                      , Manufacturing_Lot__r.Active_Flag__c
                                                                      , Manufacturing_Lot__r.Account_Name__r.Name
                                                                      , Manufacturing_Lot__r.Device_ID_MES__c
                                                                      , Manufacturing_Lot__r.Name
                                                                      , Manufacturing_Lot__r.Lot_Type__c
                                                                      , Manufacturing_Lot__r.Current_Wafer_Quantity_In_Lot__c
                                                                      , Manufacturing_Lot__r.Current_Lot_Die_Quantity__c
                                                                      , Manufacturing_Lot__r.Stage_Id__c
                                                                      , Manufacturing_Lot__r.Lot_Start_Date__c
                                                                      , Reason__c
                                                                      , Status__c
                                                                      , Aged_Days__c
                                                                      , Die_Qty__c
                                                                      , Wafer_Qty__c
                                                                      , Write_Off_Qty__c 
                                                                      , Lot_Start_Date__c
                                                                      , Comments__c
                                                                      , Lot_type__c
                                                                      , Wafer_Write_Off_Status__c
                                                            FROM      WaferWriteOff_ManufacturingLot__c
                                                            WHERE     Wafer_Write_Off__c = :wId
                                                            ORDER BY  Manufacturing_Lot__r.Name ASC];
        if (this.isClone) {
            // Validate the lots
            listFilteredLots = filterClonedLots(tempList);
        } else {
            listFilteredLots = tempList;
        }
        
        for (WaferWriteOff_ManufacturingLot__c w : listFilteredLots) {                                        
            LotWrapper l = new LotWrapper();
            l.isSelected = false;
            l.lotName = w.Manufacturing_Lot__r.Name;
            l.accountName = w.Manufacturing_Lot__r.Account_Name__r.Name;
            l.deviceMES = w.Manufacturing_Lot__r.Device_ID_MES__c;
            l.lotType = w.Lot_Type__c;
            l.currentWaferQty = integer.valueOf(w.Wafer_Qty__c);
            l.currentDieQty = integer.valueOf(w.Die_Qty__c);
            
            l.storedWriteOffQty = Integer.valueOf(w.Write_Off_Qty__c);
            
            if(w.Die_Qty__c == null){
                l.currentWriteOffQty = Integer.valueOf(w.Wafer_Qty__c);
                l.enableWriteOffQtyEdit = false;
            }
            else if(w.Die_Qty__c == 0){
                l.currentWriteOffQty = Integer.valueOf(w.Wafer_Qty__c);
                l.enableWriteOffQtyEdit = false;
            }
            else{
                l.currentWriteOffQty = Integer.valueOf(w.Write_Off_Qty__c);
                l.enableWriteOffQtyEdit = true;
            }
            l.holdStage = w.Manufacturing_Lot__r.Stage_Id__c;
            l.lotStartDate = w.Lot_Start_Date__c;
            
            if (w.Aged_Days__c != null) {
                l.agedDays = integer.valueOf(w.Aged_Days__c);
            } else {
                l.agedDays = w.Lot_Start_Date__c.daysBetween(date.today());
            }
            
            if (this.isClone) {
                l.wwoml.Manufacturing_Lot__c = w.Manufacturing_Lot__c;
            } else {
                l.wwoml = w;
            }
                        
            tempListSL.add(l);
            this.selectedLotIds.add(w.Manufacturing_Lot__c);
        }
        
        // Paginate selected records
        if (tempListSL.size() > 0) {
            this.mapSelectedLots = paginateRecords(tempListSL);
            this.totalNoOfRecordsSL = tempListSL.size();
            this.totalNoOfPagesSL = this.mapSelectedLots.keySet().size();
        }
    }
    
    public List<WaferWriteOff_ManufacturingLot__c> filterClonedLots(List<WaferWriteOff_ManufacturingLot__c> tempList) {
        List<WaferWriteOff_ManufacturingLot__c> listValidLots = new List<WaferWriteOff_ManufacturingLot__c>();
        Set<Id> lotIds = new Set<Id>();
        Set<Id> invalidLotIds = new Set<Id>();
        for (WaferWriteOff_ManufacturingLot__c w : tempList) {
            lotIds.add(w.Manufacturing_Lot__c);            
        }
        
        if (lotIds.size() > 0) {
            Set<string> wwoLotTypes = new Set<string>{'PB', 'PP', 'PX', 'QX'};
            for (Manufacturing_Lot__c m : [SELECT    Id
                                                     , Name
                                                     , Active_Flag__c
                                                     , Lot_Type__c
                                                     , (SELECT     Id 
                                                        FROM       WaferWriteOff_ManufacturingLot__r 
                                                        WHERE      Wafer_Write_Off_Status__c NOT IN ('Draft', 'Rejected', 'Closed', 'Void') 
                                                                   OR (Wafer_Write_Off_Status__c = 'Closed' AND Status__c = 'Executed'))
                                           FROM      Manufacturing_Lot__c 
                                           WHERE     Id IN :lotIds]) {
                if (!m.Active_Flag__c || !wwoLotTypes.contains(m.Lot_Type__c) || m.WaferWriteOff_ManufacturingLot__r.size() > 0) {
                    invalidLotIds.add(m.Id);
                } 
            }
        }
        
        for (WaferWriteOff_ManufacturingLot__c w : tempList) {
            if (!invalidLotIds.contains(w.Manufacturing_Lot__c)) {
                w.Wafer_Qty__c = w.Manufacturing_Lot__r.Current_Wafer_Quantity_In_Lot__c;
                w.Die_Qty__c = w.Manufacturing_Lot__r.Current_Lot_Die_Quantity__c;
                listValidLots.add(w);
            }
        }
        
        return listValidLots;
    }
    
    public Map<integer, List<LotWrapper>> paginateRecords(List<LotWrapper> tempList) {
        integer pageKey = 1;
        Map<integer, List<LotWrapper>> tempMap = new Map<integer, List<LotWrapper>>();
        for (LotWrapper l : tempList) {
            if (tempMap.containsKey(pageKey)) {
                if (tempMap.get(pageKey).size() < integer.valueOf(Environment_Variable__c.getInstance('WWO_RECORDS_PER_PAGE').Value__c)) {
                    tempMap.get(pageKey).add(l);
                } else {
                    pageKey++;
                    tempMap.put(pageKey, new List<LotWrapper>{l});
                }
            } else {
                tempMap.put(pageKey, new List<LotWrapper>{l});
            }
        }
        
        return tempMap;
    }
    
    // Search for Manufacturing Lots
    public void searchLots() {
        this.mapAvailableLots = new Map<integer, List<LotWrapper>>();
        this.totalNoOfPagesAL = 0;
        this.totalNoOfRecordsAL = 0;
        this.currentPageNoAL = 1;
        if ((this.lotName != null && this.lotName.trim() != '') || (this.mesDeviceId != null && this.mesDeviceId.trim() != '')) {
            if (((this.lotName != null && this.lotName.trim() != '') && (this.lotName.replace('*', '').replace('%', '').length() >= 2))
                  || ((this.mesDeviceId != null && this.mesDeviceId.trim() != '') && (this.mesDeviceId.replace('*', '').replace('%', '').length() >= 2))) {
                
                // Retrieve available lots
                Set<Id> accountIds = new Set<Id>();
                string query = 'SELECT Id, Name, Lot_Start_Date__c, Last_Ship_Date__c, Device_ID_MES__c, Lot_Type__c, ' +
                                      'Current_Wafer_Quantity_In_Lot__c, Current_Lot_Die_Quantity__c, Stage_Id__c, Account_Name__r.Name, ' +
                                      '(SELECT Id FROM WaferWriteOff_ManufacturingLot__r WHERE Wafer_Write_Off_Status__c NOT IN (\'Draft\', \'Rejected\', \'Closed\', \'Void\') OR (Wafer_Write_Off_Status__c = \'Closed\' AND Status__c = \'Executed\'))' +
                               'FROM  Manufacturing_Lot__c ';
                               
                accountIds = getAccountIdsByHierarchy();
                query = query + 'WHERE Account_Name__c IN :accountIds ';

                query = query + 'AND Id NOT IN :selectedLotIds ';
                
                if ((this.lotName != null && this.lotName.trim() != '')) {
                    query = query + 'AND Name LIKE \'%' + this.lotName.replace('*', '') + '%\' ';
                }
                
                if ((this.mesDeviceId != null && this.mesDeviceId.trim() != '')) {
                    query = query + 'AND Device_ID_MES__c LIKE \'%' + this.mesDeviceId.replace('*', '') + '%\' ';
                }
                
                if (this.lotType == 'ALL') {
                    query = query + 'AND Lot_Type__c IN (\'PB\', \'PP\', \'PX\', \'QX\') ';
                } else {
                    query = query + 'AND Lot_Type__c = \'' + this.lotType + '\' ';
                }
                
                query = query + 'AND Fab_Group__c = \'' + this.waferWriteOff.Fab__c + '\' ' + 
                                'AND Active_Flag__c = true ' +
                                'ORDER BY Name ASC LIMIT 100';

                List<LotWrapper> tempListAL = new List<LotWrapper>();
                for (Manufacturing_Lot__c m : Database.query(query)) {
                    if (m.WaferWriteOff_ManufacturingLot__r.size() == 0) {
                        LotWrapper l = new LotWrapper();
                        l.lotName = m.Name;
                        l.accountName = m.Account_Name__r.Name;
                        l.deviceMES = m.Device_ID_MES__c;
                        l.lotType = m.Lot_Type__c;
                        l.currentWaferQty = integer.valueOf(m.Current_Wafer_Quantity_In_Lot__c);
                        l.currentDieQty = integer.valueOf(m.Current_Lot_Die_Quantity__c);
                        l.holdStage = m.Stage_Id__c;
                        l.lotStartDate = (m.Lot_Start_Date__c != null ? date.newinstance(m.Lot_Start_Date__c.year(), m.Lot_Start_Date__c.month(), m.Lot_Start_Date__c.day()) : null);
                        l.wwoml.Manufacturing_Lot__c = m.Id;
                        
                        //l.storedWriteOffQty = Integer.valueOf(m.Current_Write_Off_Qty__c);
                        l.storedWriteOffQty = 0;
            
                        if(m.Current_Lot_Die_Quantity__c == null){
                            l.currentWriteOffQty = Integer.valueOf(m.Current_Wafer_Quantity_In_Lot__c);
                            l.enableWriteOffQtyEdit = false;
                        }
                        else if(m.Current_Lot_Die_Quantity__c == 0){
                            l.currentWriteOffQty = Integer.valueOf(m.Current_Wafer_Quantity_In_Lot__c);
                            l.enableWriteOffQtyEdit = false;
                        }
                        else{
                            //l.currentWriteOffQty = 0;
                            l.enableWriteOffQtyEdit = true;
                        }
                        
                        tempListAL.add(l);
                    }
                }
                
                // Paginate available records
                if (tempListAL.size() > 0) {
                    this.mapAvailableLots = paginateRecords(tempListAL);
                    this.totalNoOfRecordsAL = tempListAL.size();
                    this.totalNoOfPagesAL = this.mapAvailableLots.keySet().size();
                }

                // Refresh Search Key value
                this.lotName = '';
                this.mesDeviceId = '';
                this.lotType = 'ALL';
            } else {
                // Error message
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Error_Codes__c.getInstance('EPTS_ERROR_MSG_SEARCH_KEY').Message__c));
            }
        } else {
            // Error message
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Error_Codes__c.getInstance('WWO_ERROR_MSG').Message__c));
        }
    }
    
    public List<LotWrapper> getSelectedLots() {
        List<LotWrapper> tempList = new List<LotWrapper>();
        if (this.mapSelectedLots.containsKey(this.currentPageNoSL)) {
            tempList = this.mapSelectedLots.get(this.currentPageNoSL);
        }   
        
        return tempList;
    }
    
    public List<LotWrapper> getAvailableLots() {
        List<LotWrapper> tempList = new List<LotWrapper>();
        if (this.mapAvailableLots.containsKey(this.currentPageNoAL)) {
            tempList = this.mapAvailableLots.get(this.currentPageNoAL);
        }
        
        return tempList;
    }
    
    public List<LotWrapper> filterSelectedRecords(Map<integer, List<LotWrapper>> tempMap) {
        List<LotWrapper> tempList = new List<LotWrapper>(); 
        for (integer key : tempMap.keySet()) {
            for (LotWrapper l : tempMap.get(key)) {
                if (l.isSelected) {
                    l.isSelected = false;
                    tempList.add(l);
                }
            }
        }
        
        return tempList;
    }
    
    public PageReference saveSelectedLots() {
        for (Integer key : this.mapAvailableLots.keySet()) {
            
            for (LotWrapper lwObj : this.mapAvailableLots.get(key)) {
                
                if(   lwObj.isSelected
                   && (lwObj.currentDieQty != null && lwObj.currentDieQty > 0)
                   && (lwObj.currentWriteOffQty < 1 || lwObj.currentWriteOffQty > 25) ){
                    
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Write_Off_Qty_Val_Error));
                    return null;
                }
            }
        }
        
        // Get all Selected Lots
        List<LotWrapper> tempList = new List<LotWrapper>();
        tempList.addAll(filterSelectedRecords(this.mapAvailableLots));
        for (integer key : this.mapSelectedLots.keySet()) {
            for (LotWrapper l : this.mapSelectedLots.get(key)) {
                tempList.add(l);
            }
        }

        // Refresh values
        this.mapAvailableLots = new Map<integer, List<LotWrapper>>();
        this.mapSelectedLots = new Map<integer, List<LotWrapper>>();
        this.selectedLotIds = new Set<Id>();
        List<string> tempListOrder = new List<string>();
        Map<string, LotWrapper> tempMap = new Map<string, LotWrapper>();
        for (LotWrapper l : tempList) {
            this.selectedLotIds.add(l.wwoml.Manufacturing_Lot__c);
            tempListOrder.add(l.lotName);
            tempMap.put(l.lotName, l);
        }
        
        // Sort
        tempListOrder.sort();
        tempList = new List<LotWrapper>();
        for (string key : tempListOrder) {
            tempList.add(tempMap.get(key));    
        }
        
        // Add values
        this.mapSelectedLots = paginateRecords(tempList);
        this.totalNoOfRecordsSL = tempList.size();
        this.totalNoOfPagesSL = this.mapSelectedLots.keySet().size(); 
        this.currentPageNoSL = 1;
        
        return null;
    }
    
    public void removeSelectedLots() {
        // Get all Unselected Lots
        List<LotWrapper> tempList = new List<LotWrapper>();
        for (integer key : this.mapSelectedLots.keySet()) {
            for (LotWrapper l : this.mapSelectedLots.get(key)) {
                if (!l.isSelected) {
                    tempList.add(l);
                }
            }
        }
        
        // Refresh values
        this.mapAvailableLots = new Map<integer, List<LotWrapper>>();
        this.mapSelectedLots = new Map<integer, List<LotWrapper>>();
        this.selectedLotIds = new Set<Id>();
        List<string> tempListOrder = new List<string>();
        Map<string, LotWrapper> tempMap = new Map<string, LotWrapper>();
        for (LotWrapper l : tempList) {
            this.selectedLotIds.add(l.wwoml.Manufacturing_Lot__c);
            tempListOrder.add(l.lotName);
            tempMap.put(l.lotName, l);
        }
        
        // Sort
        tempListOrder.sort();
        tempList = new List<LotWrapper>();
        for (string key : tempListOrder) {
            tempList.add(tempMap.get(key));    
        }
        
        // Add values
        this.mapSelectedLots = paginateRecords(tempList);
        this.totalNoOfRecordsSL = tempList.size();
        this.totalNoOfPagesSL = this.mapSelectedLots.keySet().size(); 
        this.currentPageNoSL = 1;   
    }
    
    public PageReference save(){
        PageReference pageRef;
        
        try {
            // Check Reason
            if (this.waferWriteOff.Reason__c != null) {
                List<string> tempReasonList = this.waferWriteOff.Reason__c.split(';');
                Set<string> tempReasonSet = new Set<string>();
                tempReasonSet.addAll(tempReasonList);
                if (tempReasonSet.contains('Others') && this.waferWriteOff.Other_Reason__c == null) {
                    // Error
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Other Reason: You must enter a value'));
                    return null;
                }
            }
                           
            if (this.waferWriteOff.Status__c == 'Approved and Pending Planning') {
                boolean closeRecord = true;
                for (integer key : this.mapSelectedLots.keySet()) {
                    for (LotWrapper l : this.mapSelectedLots.get(key)) {
                        if (l.wwoml.Status__c == null) {
                            closeRecord = false;
                        } else if (l.wwoml.Status__c == 'Not Executed' && l.wwoml.Comments__c == null) {
                            // Error
                            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please fill up Comments for Not Executed lots.'));
                            return null;
                        }
                    }
                }
                
                if (closeRecord) {
                    this.waferWriteOff.Status__c = 'Closed';
                    this.waferWriteOff.App_and_Pend_Plan_Update_in_MES_DateTime__c = datetime.now();
                }
            }
            
            // Check Reason field
            if (this.waferWriteOff.Reason__c != null) {
                List<string> tempReasonList = this.waferWriteOff.Reason__c.split(';');
                Set<string> tempReasonSet = new Set<string>();
                tempReasonSet.addAll(tempReasonList);
                if (!tempReasonSet.contains('Others')) {
                    this.waferWriteOff.Other_Reason__c = null;
                }
            } else {
                this.waferWriteOff.Other_Reason__c = null;
            }
            
            // Save Write Off record
            upsert this.waferWriteOff;
            
            List<WaferWriteOff_ManufacturingLot__c> lstToDelete = new List<WaferWriteOff_ManufacturingLot__c>();
            List<WaferWriteOff_ManufacturingLot__c> lstToUpdate = new List<WaferWriteOff_ManufacturingLot__c>();
                
            if (!this.isNew){
                List<WaferWriteOff_ManufacturingLot__c> tempList = [
                    SELECT    Id,Manufacturing_Lot__c,Wafer_Write_Off_Status__c 
                    FROM      WaferWriteOff_ManufacturingLot__c
                    WHERE     Wafer_Write_Off__c = :this.waferWriteOff.Id
                ];                
                for(WaferWriteOff_ManufacturingLot__c w: tempList){
                    if(w.Wafer_Write_Off_Status__c != 'Approved and Pending Planning' &&
                       w.Wafer_Write_Off_Status__c != 'Closed' ){
                        lstToDelete.add(w);
                    }else{
                        lstToUpdate.add(w);
                    }
                }
                // Delete existing Manufacturing Lot records
                if (lstToDelete.size() > 0){
                    delete lstToDelete;
                }
            }
            
            // Save Manufacturing Lot records
            List<WaferWriteOff_ManufacturingLot__c> tempList = new List<WaferWriteOff_ManufacturingLot__c>();
            List<WaferWriteOff_ManufacturingLot__c> tempListUpdate = new List<WaferWriteOff_ManufacturingLot__c>();
            
            for (integer key : this.mapSelectedLots.keySet()) {
                for (LotWrapper l : this.mapSelectedLots.get(key)) {
                    if(l.wwoml.Wafer_Write_Off_Status__c != 'Approved and Pending Planning' &&
                       l.wwoml.Wafer_Write_Off_Status__c != 'Closed' ){
                        WaferWriteOff_ManufacturingLot__c w = new WaferWriteOff_ManufacturingLot__c();
                        w.Wafer_Write_Off__c = this.waferWriteOff.Id;
                        w.Manufacturing_Lot__c = l.wwoml.Manufacturing_Lot__c;
                        w.Lot_Type__c = l.lotType;
                        w.Reason__c = l.wwoml.Reason__c;
                        w.Die_Qty__c = l.currentDieQty;
                        w.Wafer_Qty__c = l.currentWaferQty;
                        w.Write_Off_Qty__c = l.currentWriteOffQty;
                        w.Status__c = l.wwoml.Status__c;
                        w.Lot_Start_Date__c = l.lotStartDate;
                        w.Comments__c = l.wwoml.Comments__c;
                        
                        if (this.waferWriteOff.Status__c != 'Draft' && this.waferWriteOff.Status__c != 'Rejected') {
                            w.Aged_Days__c = l.agedDays;
                        }
                        tempList.add(w);
                    }else{
                        for(WaferWriteOff_ManufacturingLot__c wm: lstToUpdate){
                            if(wm.Manufacturing_Lot__c == l.wwoml.Manufacturing_Lot__c){
                                wm.Status__c = l.wwoml.Status__c;
                                wm.Comments__c = l.wwoml.Comments__c;
                                tempListUpdate.add(wm);
                                break;
                            }
                        }
                    }
                }
            }
            system.debug('####List to Update#####'+tempListUpdate);
            if (tempList.size() > 0) {
                insert tempList;
            } 
            if(!tempListUpdate.isEmpty()){
                update tempListUpdate;
            }
            // Go to view
            pageRef = new PageReference('/apex/WaferWriteOffVF?id=' + this.waferWriteOff.Id);
            pageRef.setRedirect(true);
        } catch (Exception e) {
            // Error
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Error: ' + e.getMessage()));
        }
        
        return pageRef;
    }
    
    public PageReference goToEditMode() {
        PageReference pageRef = new PageReference('/apex/WaferWriteOffVF?id=' + this.waferWriteOff.Id + '&edit=1');
        pageRef.setRedirect(true);
        
        return pageRef;
    }
    
    public PageReference validateValues() {
        PageReference pageRef;
        boolean isValid = true;
        string approvalAction = Apexpages.currentPage().getParameters().get('pApprovalAction');
        
        if (approvalAction == 'Approve') {
            if (this.waferWriteOff.Total_Provisioned__c == null || this.waferWriteOff.Total_Value__c == null) {
                isValid = false;
            }
        }

        if (isValid) {
            if (approvalAction == 'Approve') {
                pageRef = new PageReference('/apex/WaferWriteOffApprovalVF?id=' + this.waferWriteOff.Id + '&approve=1');  
            } else if (approvalAction == 'Reject') {
                pageRef = new PageReference('/apex/WaferWriteOffApprovalVF?id=' + this.waferWriteOff.Id);  
            }
            
            pageRef.setRedirect(true);
        } else {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please fill up Total Provisioned (US$) and Total Value (US$) before approving the Wafer Write Off.'));
        }
        
        return pageRef;
    }
    
    public PageReference saveAndExit() {
        // Save and go to view page
        PageReference pageRef;
        try {
            save();
            pageRef = new PageReference('/apex/WaferWriteOffVF?id=' + this.waferWriteOff.Id);  
            pageRef.setRedirect(true);
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Error: ' + e.getMessage()));
        } 
        
        return pageRef;
    }
    
    public void goToLotSelectionPage() {
        // Save the form
        try {
            if (this.isNew || this.isEdit) {
                // Check Reason
                if (this.waferWriteOff.Reason__c != null) {
                    List<string> tempReasonList = this.waferWriteOff.Reason__c.split(';');
                    Set<string> tempReasonSet = new Set<string>();
                    tempReasonSet.addAll(tempReasonList);
                    if (tempReasonSet.contains('Others') && this.waferWriteOff.Other_Reason__c == null) {
                        // Error
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Other Reason: You must enter a value'));
                        return;
                    }
                }
                
                // Check Reason field
                if (this.waferWriteOff.Reason__c != null) {
                    List<string> tempReasonList = this.waferWriteOff.Reason__c.split(';');
                    Set<string> tempReasonSet = new Set<string>();
                    tempReasonSet.addAll(tempReasonList);
                    if (!tempReasonSet.contains('Others')) {
                        this.waferWriteOff.Other_Reason__c = null;
                    }
                } else {
                    this.waferWriteOff.Other_Reason__c = null;
                }
                
                // Select Account Region Head
                if (this.waferWriteOff.Account_Region_Head__c == null || this.waferWriteOff.Account_Sales_SVP__c == null) {
                    Account a = [
                        SELECT    Id
                                  , Financial_Territory__c
                        FROM      Account
                        WHERE     Id = :this.waferWriteOff.Customer_Name__c
                    ];
                    
                    List<Account_Region_Head_Mapping__c> listARHM = [
                        SELECT    Region_Head_LK__c
                                  , Sales_SVP__c
                        FROM      Account_Region_Head_Mapping__c
                        WHERE     isActive__c = true
                                  AND Sales_Territory__c = :a.Financial_Territory__c
                        LIMIT 1
                    ];
                    
                    if (listARHM.size() > 0) {
                        this.waferWriteOff.Account_Region_Head__c = listARHM[0].Region_Head_LK__c;
                        this.waferWriteOff.Account_Sales_SVP__c = listARHM[0].Sales_SVP__c;
                    }
                }
                
                // Save Write Off record
                upsert this.waferWriteOff;
            }
            
            // Refresh
            this.currentPageNoSL = 1;
            this.currentPageNoAL = 1;
            
            goToEditMode();
            this.showMainSection = false;
            this.showLotSelectionSection = true;
        } catch (Exception e) {
            // Error
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Error: ' + e.getMessage()));
        }
    }
    
    public PageReference cancel() {
        PageReference pageRef;
        if (this.isEdit) {
            pageRef = new PageReference('/apex/WaferWriteOffVF?id=' + this.waferWriteOff.Id);    
        } else if (this.isNew) {
            if (this.isClone) {
                pageRef = new PageReference('/apex/WaferWriteOffVF?id=' + ApexPages.currentPage().getParameters().get('clone')); 
            } else {
                Schema.DescribeSobjectResult r = Wafer_Write_Off__c.sobjectType.getDescribe();
                pageRef = new PageReference('/' + r.getKeyPrefix());
            }
        }
        pageRef.setRedirect(true);
        
        return pageRef;
    }
    
    public PageReference voidForm() {
        PageReference pageRef;
        try {
            this.waferWriteOff.Status__c = 'Void';
            update this.waferWriteOff;
            
            pageRef = new PageReference('/apex/WaferWriteOffVF?id=' + this.waferWriteOff.Id); 
            pageRef.setRedirect(true);
        } catch (Exception e) {
            // Error
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Error: ' + e.getMessage()));
        }
        return pageRef;
    }
    
    public PageReference cloneRecord() {
        PageReference pageRef = new PageReference('/apex/WaferWriteOffVF?clone=' + this.waferWriteOff.Id); 
        pageRef.setRedirect(true);
        
        return pageRef;
    }
    
    public PageReference exportRecord() {
        PageReference pageRef = new PageReference('/apex/WaferWriteOffPdfVF?id=' + this.waferWriteOff.Id); 
        pageRef.setRedirect(true);
        
        return pageRef;
    }
    
    public PageReference exportExcel() {
        string waferWOId='';
        if(string.valueOf(this.waferWriteOff.Id).length()>15){
            waferWOId = String.valueOf(this.waferWriteOff.Id).substring(0,15);
        }
        PageReference pageRef = new PageReference('/' + System.Label.WaferWriteOff_ReportId + '?export=1&enc=UTF-8&xf=xls&pn0=eq&pv0=' + waferWOId ); 
        pageRef.setRedirect(false);
        return pageRef;
    }
    
    public PageReference submitForApproval() {
        PageReference pageRef;
        
        // Validate selected lots before submission
        Set<Id> lotIds = new Set<Id>();
        for (integer key : this.mapSelectedLots.keySet()) {
            for (LotWrapper l : this.mapSelectedLots.get(key)) {
                lotIds.add(l.wwoml.Manufacturing_Lot__c);            
            }
        }
        
        if (lotIds.size() > 0) {
            string invalidLots = '';
            for (Manufacturing_Lot__c m : [SELECT    Id
                                                     , Name
                                                     , (SELECT Id FROM WaferWriteOff_ManufacturingLot__r WHERE Wafer_Write_Off_Status__c NOT IN ('Draft', 'Rejected', 'Closed', 'Void') OR (Wafer_Write_Off_Status__c = 'Closed' AND Status__c = 'Executed'))
                                           FROM      Manufacturing_Lot__c 
                                           WHERE     Id IN :lotIds]) {
                if (m.WaferWriteOff_ManufacturingLot__r.size() > 0) {
                    invalidLots = invalidLots + '<br/>- ' + m.Name;
                } 
            }
            
            if (invalidLots != '') {
                string errorMsg = 'This Wafer Write Off form cannot be submitted for approval.  The following lots are either under approval for another Wafer Write Off form or already Executed: <br/>' + invalidLots;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, errorMsg));
                return null;
            }
        }
        
        try {
            // Update record
            this.waferWriteOff.Date_Submitted_for_Approval__c = date.today();
            update this.waferWriteOff;
            
            List<WaferWriteOff_ManufacturingLot__c> tempList = new List<WaferWriteOff_ManufacturingLot__c>();
            for (WaferWriteOff_ManufacturingLot__c w : [SELECT    Id
                                                                  , Aged_Days__c
                                                                  , Lot_Start_Date__c
                                                        FROM      WaferWriteOff_ManufacturingLot__c
                                                        WHERE     Wafer_Write_Off__c = :this.waferWriteOff.Id]) {
                w.Aged_Days__c = w.Lot_Start_Date__c.daysBetween(date.today());
                tempList.add(w);  
            }
            
            if (tempList.size() > 0) {
                update tempList;
            }
            
            // Submit form
            Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
            req1.setObjectId(this.waferWriteOff.Id);
            Approval.process(req1);
            
            // Go to view page
            pageRef = new PageReference('/apex/WaferWriteOffVF?id=' + this.waferWriteOff.Id);
            pageRef.setRedirect(true);
        } catch (Exception e) {
            // Error
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Error: ' + e.getMessage()));
        }
        
        return pageRef;
    }
    
    // Selected Records
    public boolean getHasPreviousSL() {
        return (this.currentPageNoSL > 1 ? true : false);
    }
    
    public boolean getHasNextSL() {
        return (this.currentPageNoSL < this.totalNoOfPagesSL ? true : false);
    }
    
    public void previousSL() {
        this.currentPageNoSL--;
    }
    
    public void nextSL() {
        this.currentPageNoSL++;
    }
    
    public void firstSL() {
        this.currentPageNoSL = 1; 
    }
    
    public void lastSL() {
        this.currentPageNoSL = this.totalNoOfPagesSL;  
    }
    
    // Available Records
    public boolean getHasPreviousAL() {
        return (this.currentPageNoAL > 1 ? true : false);
    }
    
    public boolean getHasNextAL() {
        return (this.currentPageNoAL < this.totalNoOfPagesAL ? true : false);
    }
    
    public void previousAL() {
        this.currentPageNoAL--;
    }
    
    public void nextAL() {
        this.currentPageNoAL++;
    }
    
    public void firstAL() {
        this.currentPageNoAL = 1; 
    }
    
    public void lastAL() {
        this.currentPageNoAL = this.totalNoOfPagesAL;  
    }
    
    public List<SelectOption> getLotTypes() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('ALL','ALL'));
        options.add(new SelectOption('PB','PB'));
        options.add(new SelectOption('PP','PP'));
        options.add(new SelectOption('PX','PX'));
        options.add(new SelectOption('QX','QX'));
        
        return options;
    }
    
    public void checkUserProfile1() {
        List<string> listProfile1 = Environment_Variable__c.getInstance('WWO_PROFILE_1').Value__c.split(';');
        Set<string> setProfile1 = new Set<string>();
        setProfile1.addAll(listProfile1);
        
        List<string> listProfile2 = Environment_Variable__c.getInstance('WWO_PROFILE_2').Value__c.split(';');
        Set<string> setProfile2 = new Set<string>();
        setProfile2.addAll(listProfile2);
        
        List<string> listProfile3 = Environment_Variable__c.getInstance('WWO_PROFILE_3').Value__c.split(';');
        Set<string> setProfile3 = new Set<string>();
        setProfile3.addAll(listProfile3);
        
        Profile p = [
            SELECT    Name
            FROM      Profile
            WHERE     Id = :UserInfo.getProfileId()
        ];
        
        if (setProfile1.contains(p.Name)) {
            this.editValue = false;
        } else if (setProfile2.contains(p.Name)) {
            this.editValue = true;
        } else if (setProfile3.contains(p.Name)) {
            this.editValue = true;
        } else {
            this.editValue = false;
        }
    }
    
    public void checkUserProfile2() {
        List<string> listProfile3 = Environment_Variable__c.getInstance('WWO_PROFILE_3').Value__c.split(';');
        Set<string> setProfile3 = new Set<string>();
        setProfile3.addAll(listProfile3);
        
        Profile p = [
            SELECT    Name
            FROM      Profile
            WHERE     Id = :UserInfo.getProfileId()
        ];
        
        if (setProfile3.contains(p.Name)) {
            this.editStatus = true;
        } else {
            string groupName;
            if (this.waferWriteOff.Fab__c == 'Fab 2') {
                groupName = 'Planners_Fab2';
            } else if (this.waferWriteOff.Fab__c == 'Fab 3') {
                groupName = 'Planners_Fab3';
            } else if (this.waferWriteOff.Fab__c == 'Fab 3E') {
                groupName = 'Planners_Fab3E';
            } else if (this.waferWriteOff.Fab__c == 'Fab 5') {
                groupName = 'Planners_Fab5';
            } else if (this.waferWriteOff.Fab__c == 'Fab 6') {
                groupName = 'Planners_Fab6';
            } else if (this.waferWriteOff.Fab__c == 'Fab 7') {
                groupName = 'Planners_Fab7';
            }

            for (GroupMember g : [SELECT    UserOrGroupId
                                  FROM      GroupMember
                                  WHERE     Group.DeveloperName = :groupName]) {
                if (g.UserOrGroupId == UserInfo.getProfileId()) {
                    this.editStatus = true;
                    break;
                }
            }
        }
    }
    
    public void updateLotStatusAndComments() {
        for (integer key : this.mapSelectedLots.keySet()) {
            for (LotWrapper l : this.mapSelectedLots.get(key)) {
                if (l.isSelectedStatus) {
                    l.wwoml.Status__c = this.wwomlStatusComments.Status__c;
                    l.wwoml.Comments__c = this.wwomlStatusComments.Comments__c;
                    l.isSelectedStatus = false;
                }
            }
        }
    }
    
    public boolean getShowEditButton() {
        boolean returnValue = false;
        if (!this.isNew 
            && !this.isEdit
            && (this.waferWriteOff.Status__c == 'Draft'
                || this.waferWriteOff.Status__c == 'Rejected'
                || (this.waferWriteOff.Status__c == 'Approved and Pending Planning'
                    && this.editStatus)
                || (this.waferWriteOff.Status__c == 'Pending Finance Update of Write Off Value'
                    && this.editValue))) {
            returnValue = true;
        } 
        
        return returnValue;
    }
    
    public boolean getShowSaveButton() {
        boolean returnValue = false;
        if (this.isNew || this.isEdit) {
            returnValue = true; 
        }
        
        return returnValue;
    }
    
    public boolean getShowSubmitButton() {
        boolean returnValue = false;
        if (!this.isNew 
            && !this.isEdit
            && ((this.waferWriteOff.Status__c == 'Draft' || this.waferWriteOff.Status__c == 'Rejected') 
                && this.waferWriteOff.No_of_Lots__c > 0)) {
            returnValue = true;
        }
        
        return returnValue;
    }
    
    public boolean getShowCancelButton() {
        boolean returnValue = false;
        if (this.isNew || this.isEdit) {
            returnValue = true; 
        }
        
        return returnValue;
    }
    
    public boolean getShowVoidButton() {
        boolean returnValue = false;
        if (!this.isNew 
            && !this.isEdit
            && (this.waferWriteOff.Status__c == 'Draft' 
                || this.waferWriteOff.Status__c == 'Rejected' )) {
            returnValue = true;
        }
        
        return returnValue;
    }
    
    public boolean getShowCloneButton() {
        boolean returnValue = false;
        if (!this.isNew && !this.isEdit) {
            returnValue = true;
        }
        
        return returnValue;
    }
    
    public boolean getShowExportButton() {
        boolean returnValue = false;
        if (!this.isNew 
            && !this.isEdit
            //&& this.waferWriteOff.Status__c == 'Closed'
            && WaferWriteOff_Export_Profile__c.getInstance(UserInfo.getProfileId()).Enable__c
            ){
            returnValue = true;
        }        
        return returnValue;
    }
    
    public boolean getShowSearchLotsButton() {
        boolean returnValue = false;
        if (this.isNew 
            || ((this.isEdit
                 || (!this.isNew && !this.isEdit))
                && (this.waferWriteOff.Status__c == 'Draft' 
                    || this.waferWriteOff.Status__c == 'Rejected'))) {    
            returnValue = true;   
        }
        
        return returnValue;
    }
    
    public boolean getShowInputFields() {
        boolean returnValue = false;
        if ((this.isNew && !this.isClone)
            || (this.isEdit
                && this.waferWriteOff.Status__c == 'Draft'
                && this.waferWriteOff.No_of_Lots__c == 0
                && this.waferWriteOff.Date_Submitted_for_Approval__c == null)
            || (this.isNew && this.isClone
                && this.mapSelectedLots.size() == 0)) {
            returnValue = true;
        }
        
        return returnValue;
    }
    
    public boolean getShowOtherFields() {
        boolean returnValue = false;
        if (this.isEdit 
            || (!this.isNew && !this.isEdit)) {
            returnValue = true; 
        }
        
        return returnValue;
    }
    
    public boolean getShowReasonCommentFields() {
        boolean returnValue = false;
        if (this.isNew
            || (this.isEdit
                && (this.waferWriteOff.Status__c == 'Draft'
                    || this.waferWriteOff.Status__c == 'Rejected'))) {
            returnValue = true;
        }
        
        return returnValue;
    }
    
    public boolean getShowUpdateLotStatus() {
        boolean returnValue = false;
        if (this.isEdit
            && this.waferWriteOff.Status__c == 'Approved and Pending Planning') {
            returnValue = true;
        }
        
        return returnValue;
    }
    
    public boolean getShowLockImage() {
        boolean returnValue = false;
        if (!this.isNew 
            && !this.isEdit
            && this.waferWriteOff.Status__c != 'Draft'
            && this.waferWriteOff.Status__c != 'Rejected') {
            returnValue = true;
        }
        
        return returnValue;
    }
    
    // Wrapper Class
    public class LotWrapper {
        public string lotName {get;set;}
        public string accountName {get;set;}
        public string deviceMES {get;set;}
        public string lotType {get;set;}
        public integer currentWaferQty {get;set;}
        public integer currentDieQty {get;set;}
        public Integer currentWriteOffQty {get;set;}
        public Integer storedWriteOffQty {get;set;}
        public Boolean enableWriteOffQtyEdit {get;set;}
        public integer agedDays {get;set;}
        public string holdStage {get;set;}
        public date lotStartDate {get;set;} 
        public boolean isSelected {get;set;}
        public boolean isSelectedStatus {get;set;}
        public WaferWriteOff_ManufacturingLot__c wwoml {get;set;}
        
        public LotWrapper() {
            this.isSelected = false;
            this.isSelectedStatus = false;
            this.wwoml = new WaferWriteOff_ManufacturingLot__c();
        }
    }
    
    //Querying History records for WWOML
    public Integer CountTotalRecords{get;set;}
    public String QueryString {get;set;}
    public Integer OffsetSize = 0;
    private Integer QueryLimit = 5;

    public Boolean getDisablePrevious(){
        if(OffsetSize>0){
            return false;
        }
        else return true;
    }

    public Boolean getDisableNext() {
        if (OffsetSize + QueryLimit < countTotalRecords){
            return false;
        }
        else return true;
    }

    public PageReference Next() {
        OffsetSize += QueryLimit;
        return null;
    }

    public PageReference Previous() {
        OffsetSize -= QueryLimit;
        return null;
    }
    
    public List<WaferWriteOff_ManufacturingLot__history> getQueryWWOML(){
        try{
            List<WaferWriteOff_ManufacturingLot__history> lstWWOML =  [SELECT CreatedDate, 
                                                                            CreatedBy.Name, 
                                                                            Field, 
                                                                            OldValue, 
                                                                            NewValue, 
                                                                            ParentId, 
                                                                            Parent.Manufacturing_Lot__c
                                                                        FROM WaferWriteOff_ManufacturingLot__history
                                                                        WHERE Parent.Wafer_Write_Off__c = :ApexPages.currentPage().getParameters().get('id')
                                                                            AND Field in ('Status__c','Comments__c')
                                                                        ORDER BY CreatedDate Desc
                                                                        LIMIT :QueryLimit OFFSET :OffsetSize];
            return lstWWOML;
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'There was some error, Please contact to System Administrator'));
        }
        return null;
    }
    
}