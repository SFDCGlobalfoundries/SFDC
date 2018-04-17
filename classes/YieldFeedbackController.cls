/*
    Author: Zymark Ambat
    Description: This Class serves as the controller for the YieldFeedbackVF.
    History: 
        ZAmbat      11122014    - Code creation.
        # Code updated by Sunil Arora for case # 41436 so that Global Shuttle MPW device can also search by device account ids
*/
 
public class YieldFeedbackController {
    public string tabSelectedInfo {get;set;}
    public string searchKey {get;set;}
    public integer currentPageNoSR {get;set;}
    public integer totalNoOfPagesSR {get;set;}
    public integer totalNoOfRecordsSR {get;set;}
    public integer currentPageNoAR {get;set;}
    public integer totalNoOfPagesAR {get;set;}
    public integer totalNoOfRecordsAR {get;set;}
    public Account account {get;set;}
    public Device__c device {get;set;}
    public boolean fromAccount {get;set;}
    public boolean fromDevice {get;set;}
    public boolean showSearchSection {get;set;}
    public boolean enableLotPurpose {get;set;}
    public boolean showFunctional {get;set;}
    public boolean showSortYield {get;set;}
    public boolean showFirstTimeNotRight {get;set;}
    public boolean showDueDate {get;set;}
    public boolean showCheckbox {get;set;}
    public boolean enableField {get;set;}
    public boolean hideTabPanel {get;set;}
    public Yield_Feedback__c yieldFeedback {get;set;}
    public Set<Id> selectedLotIds {get;set;}
    public List<LotWrapper> listLotWrappers {get;set;}
    public Map<integer, List<LotWrapper>> selectedYFRecords {get;set;}
    public Map<integer, List<LotWrapper>> availableYFRecords {get;set;}
    
    public YieldFeedbackController() {
        // init
        this.fromAccount = false;
        this.fromDevice = false;
        this.yieldFeedback = new Yield_Feedback__c();
        this.account = new Account();
        this.device = new Device__c();
        this.tabSelectedInfo = 'existingDevice';
        this.currentPageNoSR = 1;
        this.currentPageNoAR = 1;
        this.selectedYFRecords = new Map<integer, List<LotWrapper>>();
        this.totalNoOfPagesSR = 0;
        this.totalNoOfRecordsSR = 0;
        this.availableYFRecords = new Map<integer, List<LotWrapper>>();
        this.totalNoOfPagesAR = 0;
        this.totalNoOfRecordsAR = 0;
        
        if (ApexPages.currentPage().getParameters().get('accountId') != null) {
            this.account = retrieveAccountDetails(ApexPages.currentPage().getParameters().get('accountId'));
            this.fromAccount = true;
            this.yieldFeedback.Account__c = this.account.Id;
        } else if (ApexPages.currentPage().getParameters().get('deviceId') != null) {
            this.device = retrieveDeviceDetails(ApexPages.currentPage().getParameters().get('deviceId'));
            this.account = retrieveAccountDetails(this.device.Account__c);
            this.yieldFeedback.Account__c = this.account.Id;
            this.fromDevice = true;
        }
        
        // init records map and check user's profile
        retrieveSelectedLots();
        checkUserProfile();
    }
    
    public Account retrieveAccountDetails(string accountId) {
        return [
            SELECT  Id
                    , Name
                    , ParentId
            FROM    Account
            WHERE   Id = :accountId
        ];
    }
    
    public Device__c retrieveDeviceDetails(string deviceId) {
        return [
            SELECT  Id
                    , Name
                    , Account__c
                    , Tapeout_Type__c
                    , Fab__c
            FROM    Device__c
            WHERE   Id = :deviceId
        ];
    }
    
    public Set<Id> getAccountIdsByHierarchy() {
        // Get Accounts in the Account Hierarchy
        Set<Id> accountIds = new Set<Id>();  
        if (this.account.ParentId != null) {
            for (Account_Hierarchy__c ah : [SELECT      Parent_Id__c
                                                        , Parent_Id__r.Name
                                                        , Parent_Account_Short_Name__c
                                            FROM        Account_Hierarchy__c
                                            WHERE       Account_Id__c = :this.account.Id
                                                        AND Parent_Id__c != :this.account.Id]) { 
                accountIds.add(ah.Parent_Id__c);
            }
        } 
           
        // Check for Devices below the Account Hierarchy
        for (Account_Hierarchy__c ah : [SELECT      Account_Id__c
                                                    , Account_Id__r.Name
                                                    , Account_Short_Name__c
                                        FROM        Account_Hierarchy__c
                                        WHERE       Parent_Id__c = :this.account.Id
                                                    AND Account_Id__c != :this.account.Id]) { 
            accountIds.add(ah.Account_Id__c);
        }
        
        // Add User's Account Id
        accountIds.add(this.account.Id);
        
        return accountIds;
    }
    
    public List<Yield_Feedback__c> retrieveExistingRecords() {
        string query = 'SELECT Id, Manufacturing_Lot__c, Manufacturing_Lot__r.Name, Lot_Purpose__c, Is_Auto_Tagged__c, ' +
                              'Manufacturing_Lot__r.Lot_Start_Date__c, Manufacturing_Lot__r.Last_Ship_Date__c, Comments__c, ' +
                              'Functional__c, Sort_Yield__c, First_Time_Not_Right__c, Yield_Feedback_Due_Date_Modified__c, ' +
                              'Manual_Device__c, Tapeout_Type__c, Device__c, Device__r.Name, Fab__c, Yield_Feedback_Due_Date__c ' +
                        'FROM  Yield_Feedback__c ' ;
        if (this.fromAccount) {
            query = query + 'WHERE Account__c = \'' + this.account.Id + '\' ';
        } else if (this.fromDevice) {
            query = query + 'WHERE Device__c = \'' + this.device.Id + '\' ';
        }
        
        query = query + 'ORDER BY Manufacturing_Lot__r.Name ASC';
        
        return Database.query(query);
    }
    
    public Map<integer, List<LotWrapper>> paginateRecords(List<LotWrapper> tempList) {
        integer pageKey = 1;
        Map<integer, List<LotWrapper>> tempMap = new Map<integer, List<LotWrapper>>();
        for (LotWrapper l : tempList) {
            if (tempMap.containsKey(pageKey)) {
                if (tempMap.get(pageKey).size() < integer.valueOf(Environment_Variable__c.getInstance('EPTS_RECORDS_PER_PAGE').Value__c)) {
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
    
    public void retrieveSelectedLots() {
        this.selectedYFRecords = new Map<integer, List<LotWrapper>>();
        this.totalNoOfPagesSR = 0;
        this.totalNoOfRecordsSR = 0;
        
        // Retrieve selected records
        List<LotWrapper> tempListSR = new List<LotWrapper>();
        this.selectedLotIds = new Set<Id>();
        for (Yield_Feedback__c y : retrieveExistingRecords()) {
            LotWrapper l = new LotWrapper();
            l.lotId = y.Manufacturing_Lot__c;
            l.lotName = y.Manufacturing_Lot__r.Name;
            l.lotStartDate = date.valueOf(y.Manufacturing_Lot__r.Lot_Start_Date__c);
            l.lotShipDate = y.Manufacturing_Lot__r.Last_Ship_Date__c;
            
            if (y.Yield_Feedback_Due_Date_Modified__c == null) {
                y.Yield_Feedback_Due_Date_Modified__c = y.Yield_Feedback_Due_Date__c;
            }
            
            l.yieldFeedback = y;
            l.isSelected = true;
            
            if (this.fromAccount) {
                if (y.Device__c != null) {
                    l.deviceId = y.Device__c;
                    l.deviceName = y.Device__r.Name;
                } else if (y.Manual_Device__c != null) {
                    l.deviceName = y.Manual_Device__c;
                }
            }
            
            tempListSR.add(l);
            this.selectedLotIds.add(y.Manufacturing_Lot__c);
        }
        
        // Paginate selected records
        if (tempListSR.size() > 0) {
            this.selectedYFRecords = paginateRecords(tempListSR);
            this.totalNoOfRecordsSR = tempListSR.size();
            this.totalNoOfPagesSR = this.selectedYFRecords.keySet().size();
        }
    }
    
    public void searchLots() {
        this.availableYFRecords = new Map<integer, List<LotWrapper>>();
        this.totalNoOfPagesAR = 0;
        this.totalNoOfRecordsAR = 0;
        if (this.searchKey != null && this.searchKey.trim() != '') {
            if (this.searchKey.replace('*', '').replace('%', '').length() >= 2) {
                // Retrieve available lots
                Set<Id> accountIds = new Set<Id>();
                string query = 'SELECT Id, Name, Lot_Start_Date__c, Last_Ship_Date__c ' +
                               'FROM  Manufacturing_Lot__c ';
                               
                if (this.fromDevice) {
                    if (this.device.Tapeout_Type__c == 'GlobalShuttle MPW') {
                        accountIds = getAccountIdsByHierarchy();
                        query = query + 'WHERE (Account_Name__r.Name = \'GLOBALSHUTTLE\'  or Account_Name__c IN :accountIds) ';//Line updated by Sunil for case # 41436
                    } else {
                        accountIds = getAccountIdsByHierarchy();
                        query = query + 'WHERE Account_Name__c IN :accountIds ';
                    }
                    
                    if (this.device.Fab__c == 'FAB 1' || this.device.Fab__c == 'FAB 8') {
                        query = query + 'AND Fab_Group__c IN (\'FAB 1\', \'FAB 8\') ';
                    } else {
                        query = query + 'AND Fab_Group__c NOT IN (\'FAB 1\', \'FAB 8\') ';
                    }
                } else {
                    accountIds = getAccountIdsByHierarchy();
                    query = query + 'WHERE Account_Name__c IN :accountIds ';
                }

                query = query + 'AND Id NOT IN :selectedLotIds ' + 
                                'AND Name LIKE \'%' + this.searchKey.replace('*', '') + '%\' ' +
                                //'AND Last_Ship_Date__c != null ' +
                                //'AND Active_Flag__c = true ' +
                               'ORDER BY Name ASC LIMIT 100';
                
                List<LotWrapper> tempListAR = new List<LotWrapper>();
                System.debug('##query##'+query);
                for (Manufacturing_Lot__c m : Database.query(query)) {
                    LotWrapper l = new LotWrapper();
                    l.lotId = m.Id;
                    l.lotName = m.Name;
                    l.lotStartDate = date.valueOf(m.Lot_Start_Date__c);
                    l.lotShipDate = m.Last_Ship_Date__c;
                    l.yieldFeedback = new Yield_Feedback__c(Manufacturing_Lot__c = m.Id, Lot_Purpose__c = 'Proto Lot');
                    tempListAR.add(l);
                }
                
                // Paginate available records
                if (tempListAR.size() > 0) {
                    this.availableYFRecords = paginateRecords(tempListAR);
                    this.totalNoOfRecordsAR = tempListAR.size();
                    this.totalNoOfPagesAR = this.availableYFRecords.keySet().size();
                }
            } else {
                // Error message
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Error_Codes__c.getInstance('EPTS_ERROR_MSG_SEARCH_KEY').Message__c));
            }
        } else {
            // Error message
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Error_Codes__c.getInstance('EPTS_ERROR_MSG_SEARCH_KEY').Message__c));
        }
    }
    
    public List<LotWrapper> getSelectedLots() {
        List<LotWrapper> tempList = new List<LotWrapper>();
        if (this.selectedYFRecords.containsKey(this.currentPageNoSR)) {
            tempList = this.selectedYFRecords.get(this.currentPageNoSR);
        }   
        return tempList;
    }
    
    public List<LotWrapper> getAvailableLots() {
        List<LotWrapper> tempList = new List<LotWrapper>();
        if (this.availableYFRecords.containsKey(this.currentPageNoAR)) {
            tempList = this.availableYFRecords.get(this.currentPageNoAR);
        }
        
        return tempList;
    }
    
    public List<Yield_Feedback__c> filterSelectedRecords(Map<integer, List<LotWrapper>> tempMap) {
        List<Yield_Feedback__c> tempList = new List<Yield_Feedback__c>(); 
        for (integer key : tempMap.keySet()) {
            for (LotWrapper l : tempMap.get(key)) {
                if (l.isSelected) {
                    Yield_Feedback__c y = new Yield_Feedback__c();
                    y.Account__c = this.account.Id;
                    y.Is_Auto_Tagged__c = l.yieldFeedback.Is_Auto_Tagged__c;
                    y.Auto_Tag_Note__c = null;
                    y.Manufacturing_Lot__c = l.yieldFeedback.Manufacturing_Lot__c;
                    y.Lot_Purpose__c = l.yieldFeedback.Lot_Purpose__c;
                    y.Comments__c = l.yieldFeedback.Comments__c;
                    if (this.fromAccount) {
                        if (l.deviceName != null) {
                            if (l.deviceId != null) {
                                y.Device__c = l.yieldFeedback.Device__c;
                            } else {
                                y.Manual_Device__c = l.yieldFeedback.Manual_Device__c;
                                y.Tapeout_Type__c = l.yieldFeedback.Tapeout_Type__c;
                            }
                        } else {
                            if (this.tabSelectedInfo == 'existingDevice') {
                                y.Device__c = this.yieldFeedback.Device__c;
                                y.Manual_Device__c = null;
                                y.Tapeout_Type__c = null;
                                this.yieldFeedback.Manual_Device__c = null;
                                this.yieldFeedback.Tapeout_Type__c = null;
                            } else if (this.tabSelectedInfo == 'manualDevice') {
                                y.Manual_Device__c = this.yieldFeedback.Manual_Device__c;
                                y.Tapeout_Type__c = this.yieldFeedback.Tapeout_Type__c;
                                y.Device__c = null;
                                this.yieldFeedback.Device__c = null;
                            }
                        }
                    } else if (this.fromDevice) {
                        y.Device__c = this.device.Id;
                    }
                    y.First_Time_Not_Right__c = l.yieldFeedback.First_Time_Not_Right__c;
                    y.Functional__c = l.yieldFeedback.Functional__c;
                    y.Lot_Purpose__c = l.yieldFeedback.Lot_Purpose__c;
                    y.Sort_Yield__c = l.yieldFeedback.Sort_Yield__c;
                    if (l.yieldFeedback.Yield_Feedback_Due_Date__c == l.yieldFeedback.Yield_Feedback_Due_Date_Modified__c) {
                        y.Yield_Feedback_Due_Date_Modified__c = null;
                    } else {
                        y.Yield_Feedback_Due_Date_Modified__c = l.yieldFeedback.Yield_Feedback_Due_Date_Modified__c;
                    }
                    tempList.add(y);
                }
            }
        }
        
        return tempList;
    }
    
    public boolean validateForm() {
        boolean isValid = true;
        if (this.fromAccount
            && (this.tabSelectedInfo == 'existingDevice' && this.yieldFeedback.Device__c == null) 
                || (this.tabSelectedInfo == 'manualDevice' && (this.yieldFeedback.Manual_Device__c == null || this.yieldFeedback.Tapeout_Type__c == null))) {
            
            for (integer key : this.availableYFRecords.keySet()) {
                for (LotWrapper l : this.availableYFRecords.get(key)) {
                    if (l.isSelected) {
                        isValid = false;
                        break;
                    }
                }
            }
            
            if (!isValid) {
                if (this.tabSelectedInfo == 'existingDevice' && this.yieldFeedback.Device__c == null) {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Error_Codes__c.getInstance('EPTS_ERROR_MSG_SELECT_DEVICE').Message__c));
                } else if (this.tabSelectedInfo == 'manualDevice' && this.yieldFeedback.Manual_Device__c == null) { 
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Error_Codes__c.getInstance('EPTS_ERROR_MSG_ADD_DEVICE').Message__c));
                } else if (this.tabSelectedInfo == 'manualDevice' && this.yieldFeedback.Tapeout_Type__c == null) {  
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Error_Codes__c.getInstance('EPTS_ERROR_MSG_SELECT_TAPEOUT_TYPE').Message__c));
                } else if (this.tabSelectedInfo == 'manualDevice' && this.yieldFeedback.Fab__c == null) {   
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Error_Codes__c.getInstance('EPTS_ERROR_MSG_SELECT_FAB').Message__c));
                }
            }
        }
        
        return isValid;
    }
    
    public void save() {
        if (validateForm()) {
            try {
                // Delete existing records
                List<Yield_Feedback__c> tempList = retrieveExistingRecords();
                if (tempList.size() > 0) {
                    delete tempList;
                }
                
                // Insert selected records
                List<Yield_Feedback__c> listYieldFeedbacks = new List<Yield_Feedback__c>();
                
                // Check Selected Records Map
                List<Yield_Feedback__c> tempListSR = filterSelectedRecords(this.selectedYFRecords);
                if (tempListSR.size() > 0) {
                    listYieldFeedbacks.addAll(tempListSR);
                }
                
                // Check Available Records Map
                List<Yield_Feedback__c> tempListAR = filterSelectedRecords(this.availableYFRecords);
                if (tempListAR.size() > 0) {
                    listYieldFeedbacks.addAll(tempListAR);
                }
        
                if (listYieldFeedbacks.size() > 0) {
                    insert listYieldFeedbacks;
                }
                
                // Refresh Maps
                this.currentPageNoSR = 1;
                this.currentPageNoAR = 1;
                this.availableYFRecords = new Map<integer, List<LotWrapper>>();
                this.totalNoOfPagesAR = 0;
                this.totalNoOfRecordsAR = 0;
                this.searchKey = '';
                retrieveSelectedLots();
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.CONFIRM, 'Changes were saved successfully.'));
            } catch (Exception e) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Error: ' + e.getMessage()));
            }
        }
    }
    
    public PageReference backToPage() {
        PageReference pageRef;
        if (this.fromAccount) {
            pageRef = new PageReference('/' + this.account.Id);
        } else if (this.fromDevice) {
            pageRef = new PageReference('/' + this.device.Id);
        }
        pageRef.setRedirect(true);
           
        return pageRef;
    }
    
    public void checkUserProfile() {
        Profile p = [
            SELECT      Name
            FROM        Profile
            WHERE       Id = :UserInfo.getProfileId()
        ];
        
        List<Account_Team_Proxy__c> listAtp = [
            SELECT      Team_Role__c
            FROM        Account_Team_Proxy__c
            WHERE       Account__c = :this.account.Id
                        AND User__c = :UserInfo.getUserId()
        ];
        
        string profileName = p.Name;
        string atpRoleName = '';
        if (listAtp.size() > 0) {
            atpRoleName = listAtp[0].Team_Role__c;
        }
        
        List<string> listProfiles1 = Environment_Variable__c.getInstance('EPTS_PROFILES_1').Value__c.split(';');
        List<string> listProfiles2 = Environment_Variable__c.getInstance('EPTS_PROFILES_2').Value__c.split(';');
        List<string> listAtpRoles1 = Environment_Variable__c.getInstance('EPTS_ATP_ROLES_1').Value__c.split(';');
        List<string> listAtpRoles2 = Environment_Variable__c.getInstance('EPTS_ATP_ROLES_2').Value__c.split(';');
        
        Set<string> setProfiles1 = new Set<string>();
        setProfiles1.addAll(listProfiles1);
        Set<string> setProfiles2 = new Set<string>();
        setProfiles2.addAll(listProfiles2);
        Set<string> setAtpRoles1 = new Set<string>();
        setProfiles1.addAll(listAtpRoles1);
        Set<string> setAtpRoles2 = new Set<string>();
        setProfiles2.addAll(listAtpRoles2);
        
        if (setProfiles1.contains(profileName) || setAtpRoles1.contains(atpRoleName)) {
            this.hideTabPanel = false;
            this.showSearchSection = true;
            this.showCheckbox = true;
            this.enableLotPurpose = true;
            this.showFunctional = false;
            this.showSortYield = false;
            this.showFirstTimeNotRight = false;
            this.showDueDate = false;
        } else if (setProfiles2.contains(profileName) || setAtpRoles2.contains(atpRoleName)) {
            this.hideTabPanel = true;
            this.showSearchSection = false;
            this.showCheckbox = false;
            this.enableLotPurpose = false;
            this.showFunctional = true;
            this.showSortYield = true;
            this.showFirstTimeNotRight = true;
            this.showDueDate = true;
        } else {
            this.hideTabPanel = false;
            this.showSearchSection = true;
            this.showCheckbox = true;
            this.enableLotPurpose = true;
            this.showFunctional = true;
            this.showSortYield = true;
            this.showFirstTimeNotRight = true;
            this.showDueDate = true;
        }
    }
    
    // Selected Records
    public boolean getHasPreviousSR() {
        return (this.currentPageNoSR > 1 ? true : false);
    }
    
    public boolean getHasNextSR() {
        return (this.currentPageNoSR < this.totalNoOfPagesSR ? true : false);
    }
    
    public void previousSR() {
        this.currentPageNoSR--;
    }
    
    public void nextSR() {
        this.currentPageNoSR++;
    }
    
    public void firstSR() {
        this.currentPageNoSR = 1; 
    }
    
    public void lastSR() {
        this.currentPageNoSR = this.totalNoOfPagesSR;  
    }
    
    // Available Records
    public boolean getHasPreviousAR() {
        return (this.currentPageNoAR > 1 ? true : false);
    }
    
    public boolean getHasNextAR() {
        return (this.currentPageNoAR < this.totalNoOfPagesAR ? true : false);
    }
    
    public void previousAR() {
        this.currentPageNoAR--;
    }
    
    public void nextAR() {
        this.currentPageNoAR++;
    }
    
    public void firstAR() {
        this.currentPageNoAR = 1; 
    }
    
    public void lastAR() {
        this.currentPageNoAR = this.totalNoOfPagesAR;  
    }
    
    public class LotWrapper {
        public boolean isSelected {get;set;}
        public string lotName {get;set;}
        public string lotId {get;set;}
        public string deviceId {get;set;}
        public string deviceName {get;set;}
        public date lotStartDate {get;set;}
        public date lotShipDate {get;set;}
        public Yield_Feedback__c yieldFeedback {get;set;}
        
        public LotWrapper() {
            this.isSelected = false;
        }
    }
}