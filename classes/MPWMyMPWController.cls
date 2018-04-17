/*
    Author: Zymark Ambat
    Description: This serves as the Controller for MPWMyMPWVF.
    History: 
        ZAmbat      06022015    - Code creation.
*/

public class MPWMyMPWController {
    public integer totalNoOfPages {get;set;}
    public integer totalNoOfRecords {get;set;}
    public integer currentPageNo {get;set;}
    public string sortType {get; set;}
    public string sortField {get; set;}
    public string selectedRange {get;set;} 
    public boolean hasValidNDA {get;set;}
    public List<string> listTechGeoGranted {get;set;}
    public Map<integer, List<MPWWrapper>> mapMPW {get;set;}
    
    public MPWMyMPWController() {
        this.sortType = 'ASC';
        this.sortField = 'mpwTrainName';
        this.selectedRange = 'Default';
        this.currentPageNo = 1;
        this.listTechGeoGranted = retrieveTechGeoGranted(UserInfo.getUserId());
        this.mapMPW = new Map<integer, List<MPWWrapper>>();
        this.mapMPW = retrieveMPWs();
    }
    
    private Map<integer, List<MPWWrapper>> retrieveMPWs() {
        Map<integer, List<MPWWrapper>> tempMap = new Map<integer, List<MPWWrapper>>();
        List<MPWWrapper> tempList = new List<MPWWrapper>();
        Set<Id> mpwIds = new Set<Id>();
        for (MPW_Train_Maintenance__c m : [SELECT    Id
                                           FROM      MPW_Train_Maintenance__c
                                           WHERE     Train_Type__c = 'GlobalShuttle'
                                                     AND Active__c = true
                                                     AND Publish__c = true
                                                     AND Reservation_Open_Date__c <= :datetime.now()
                                                     AND Reservation_Close_Date__c >= :datetime.now()]) {
            mpwIds.add(m.Id);
        }
        
        Set<Id> accountIds = retrieveAccounts(UserInfo.getUserId());
        if (accountIds.size() > 0) {
            for (MPW_Train_Account__c m : [SELECT    MPW_Train__c
                                           FROM      MPW_Train_Account__c
                                           WHERE     Account__c IN :accountIds
                                                     AND MPW_Train__r.Active__c = true
                                                     AND MPW_Train__r.Publish__c = true
                                                     AND MPW_Train__r.Reservation_Open_Date__c <= :datetime.now()
                                                     AND MPW_Train__r.Reservation_Close_Date__c >= :datetime.now()]) {
                mpwIds.add(m.MPW_Train__c);
            }
        }
        datetime tempDT = datetime.now();
        List<string> tempGeometryList = this.listTechGeoGranted;
        string soql = 'SELECT Id, Name, Geometry__c, Fab__c, Reservation_Open_Date__c, Reservation_Close_Date__c, ' +
                             'Cancellation_Deadline__c, Tapeout_Date_Other_Participant__c, Tapeout_Date_Customer__c, ' +
                             'Projected_1st_Batch_Bare_Die_Ship_Start__c, Projected_1st_Batch_Bare_Die_Ship_End__c, ' +
                             'Projected_2nd_Batch_Bare_Die_Ship_Start__c, Projected_2nd_Batch_Bare_Die_Ship_End__c, ' +
                             '(SELECT Device__c, No_of_Prime_Dies__c FROM MPW_Reservations__r WHERE Device__r.Tapeout_Type__c = \'GlobalShuttle MPW\') ' +
                      'FROM MPW_Train_Maintenance__c ' +
                      'WHERE Id IN :mpwIds ' +
                             'AND Geometry__c IN :listTechGeoGranted ' +
                             (this.selectedRange == 'Default' ? 'AND Tapeout_Date_Customer__c > :tempDT ' : '') +
                      'ORDER BY Name ASC';
                             
        for (MPW_Train_Maintenance__c m : database.query(soql)) {
            MPWWrapper mw = new MPWWrapper();
            mw.mpwTrainId = m.Id;
            mw.mpwTrainName = m.Name;
            
            integer noPrimeDies = 0;
            integer noDevices = 0;
            if (m.MPW_Reservations__r.size() > 0) {
                for (MPW_Reservation__c r : m.MPW_Reservations__r) {
                    if (r.No_of_Prime_Dies__c != null) {
                        noPrimeDies += integer.valueOf(r.No_of_Prime_Dies__c);
                    }
                    
                    if (r.Device__c != null) {
                        noDevices++;
                    }
                } 
            }
            
            mw.noOfPrimeDies = noPrimeDies;
            mw.noOfDevices = noDevices;
            mw.geometry = m.Geometry__c;
            mw.fab = m.Fab__c;
            
            if (m.Reservation_Open_Date__c != null) {
                mw.reservationOpenDate = m.Reservation_Open_Date__c;
            }
            
            if (m.Reservation_Close_Date__c != null) {
                mw.reservationCloseDate = m.Reservation_Close_Date__c;
            }
            
            if (m.Cancellation_Deadline__c != null) {
                mw.cancellationDate = m.Cancellation_Deadline__c;
            }
            
            if (m.Tapeout_Date_Other_Participant__c != null) {
                mw.othersPartTapeoutDate = m.Tapeout_Date_Other_Participant__c;
            }
            
            if (m.Tapeout_Date_Customer__c != null) {
                mw.customerTapeoutDate = m.Tapeout_Date_Customer__c;
            }
            
            if (m.Projected_1st_Batch_Bare_Die_Ship_Start__c != null) {
                mw.firstBatchShipDateStart = m.Projected_1st_Batch_Bare_Die_Ship_Start__c;
            }
            
            if (m.Projected_1st_Batch_Bare_Die_Ship_End__c != null) {
                mw.firstBatchShipDateEnd = m.Projected_1st_Batch_Bare_Die_Ship_End__c;
            }
            
            if (m.Projected_2nd_Batch_Bare_Die_Ship_Start__c != null) {
                mw.secondBatchShipDateStart = m.Projected_2nd_Batch_Bare_Die_Ship_Start__c;
            }
            
            if (m.Projected_2nd_Batch_Bare_Die_Ship_End__c != null) {
                mw.secondBatchShipDateEnd = m.Projected_2nd_Batch_Bare_Die_Ship_End__c;
            }
            
            tempList.add(mw);
        }
       
        // Paginate
        if (tempList.size() > 0) {
            tempMap = paginateRecords(tempList);
        }
        
        return tempMap;
    }
    
    private Map<integer, List<MPWWrapper>> paginateRecords(List<MPWWrapper> tempList) {
        Map<integer, List<MPWWrapper>> tempMap = new Map<integer, List<MPWWrapper>>();
        integer recordsPerPage = 10;
        integer pageNo = 1;
        List<MPWWrapper> temp = new List<MPWWrapper>();
        for (MPWWrapper m : tempList) {
            if (temp.size() < recordsPerPage) {
                temp.add(m);
            } else {
                tempMap.put(pageNo, temp);
                pageNo++;
                temp = new List<MPWWrapper>();
                temp.add(m);
            }
        }
        
        if (temp.size() > 0) {
            tempMap.put(pageNo, temp);
        }
        
        // Set values
        this.totalNoOfPages = pageNo;
        this.totalNoOfRecords  = tempList.size();
        
        return tempMap;
    }
    
    public List<MPWWrapper> getMyMPWRecords() {
        return (this.mapMPW.size() > 0 ? this.mapMPW.get(this.currentPageNo) : new List<MPWWrapper>());
    }
    
    public void sortRecords() {
        string tempSortField = ApexPages.currentPage().getParameters().get('sortField');
        if (this.sortField == tempSortField) {
            if (this.sortType == 'ASC') {
                this.sortType = 'DESC';
            } else {
                this.sortType = 'ASC';
            }
        } else {
            this.sortField = tempSortField;
            this.sortType = 'ASC';
        }
        
        // Sort Records
        List<MPWWrapper> tempList = new List<MPWWrapper>();
        for (integer key : this.mapMPW.keySet()) {
            tempList.addAll(this.mapMPW.get(key));
        }
        
        Map<string, List<MPWWrapper>> tempMap = new Map<string, List<MPWWrapper>>();
        for(MPWWrapper m : tempList){
            string sortKey = ''; 
            if (this.sortField == 'mpwTrainName') {
                sortKey = m.mpwTrainName;
            } else if (this.sortField == 'noOfDevices') {
                sortKey = string.valueOf(m.noOfDevices);
            } else if (this.sortField == 'noOfPrimeDies') {
                sortKey = string.valueOf(m.noOfPrimeDies);
            } else if (this.sortField == 'geometry') {
                sortKey = m.geometry;
            } else if (this.sortField == 'fab') {
                sortKey = m.fab;
            } else if (this.sortField == 'reservationOpenDate') {
                sortKey = string.valueOf(m.reservationOpenDate);
            } else if (this.sortField == 'reservationCloseDate') {
                sortKey = string.valueOf(m.reservationCloseDate);
            } else if (this.sortField == 'cancellationDate') {
                sortKey = string.valueOf(m.cancellationDate);
            } else if (this.sortField == 'othersPartTapeoutDate') {
                sortKey = string.valueOf(m.othersPartTapeoutDate);
            } else if (this.sortField == 'customerTapeoutDate') {
                sortKey = string.valueOf(m.customerTapeoutDate);
            } else if (this.sortField == 'firstBatchShipDateStart') {
                sortKey = string.valueOf(m.firstBatchShipDateStart);
            } else if (this.sortField == 'secondBatchShipDateStart') {
                sortKey = string.valueOf(m.secondBatchShipDateStart);
            } 

            if(tempMap.containsKey(sortKey)) {
                tempMap.get(sortKey).add(m);
            } else {
                tempMap.put(sortKey, new List<MPWWrapper>{m});
            }
        }
        
        List<string> sortList = new List<String>();
        sortList.addAll(tempMap.keySet());
        sortList.sort();
        
        tempList = new List<MPWWrapper>();
        if(this.sortType == 'ASC'){
            for(string s : sortList){
                tempList.addAll(tempMap.get(s));    
            }
        } else if(this.sortType == 'DESC'){
            for(integer ctr = (sortList.size()-1); ctr >= 0; ctr--){
                tempList.addAll(tempMap.get(sortList[ctr]));    
            }
        }
       
        this.mapMPW = paginateRecords(tempList);
    }
    
    // Pagination Controls
    public boolean getHasPrevious() {
        return (this.currentPageNo > 1 ? true : false);
    }
    
    public boolean getHasNext() {
        return (this.currentPageNo < this.totalNoOfPages ? true : false);
    }
    
    public void previous() {
        this.currentPageNo--;
    }
    
    public void next() {
        this.currentPageNo++;
    }
    
    public void first() {
        this.currentPageNo = 1; 
    }
    
    public void last() {
        this.currentPageNo = this.totalNoOfPages;  
    }
    
    private Set<Id> retrieveAccounts(string userId) {
        Set<Id> accountIds = new Set<Id>();
        
        // Get portal user's account
        User portalUser = [
            SELECT      Id
                        , AccountId
            FROM        User
            WHERE       Id = :userId
        ];
        
        // Get Account Id and ParentId
        Account a = [
            SELECT      Id
                        , ParentId
            FROM        Account
            WHERE       Id = :portalUser.AccountId
        ];
        
        // Get Accounts above
        if (a.ParentId != null) {
            for (Account_Hierarchy__c ah : [SELECT      Parent_Id__c
                                            FROM        Account_Hierarchy__c
                                            WHERE       Account_Id__c = :a.Id
                                                        AND Parent_Id__c != :a.Id]) { 
                accountIds.add(ah.Parent_Id__c);
            }
        }
        
        // Get Accounts below
        for (Account_Hierarchy__c ah : [SELECT      Account_Id__c
                                        FROM        Account_Hierarchy__c
                                        WHERE       Parent_Id__c = :a.Id
                                                    AND Account_Id__c != :a.Id]) { 
            accountIds.add(ah.Account_Id__c);
        }
        
        // Add User's Account Id
        accountIds.add(a.Id);
        
        return accountIds;
    }
    
    public List<string> retrieveTechGeoGranted(Id userId) {
        User u = [
            SELECT    AccountId
            FROM      User
            WHERE     Id = :userId
        ];
        
        Account a = [
            SELECT    Tech_Geo_Granted__c
                      , Has_Valid_NDA__c
            FROM      Account
            WHERE     Id = :u.AccountId
        ];
        
        List<string> tempList = new List<string>();
        if (a.Tech_Geo_Granted__c != null) {
            for (string s : a.Tech_Geo_Granted__c.split(';')) {
                tempList.add(s);
                string temp = string.valueOf(integer.valueOf(decimal.valueOf(s.replace('UM', '')) * 1000)) + 'nm';
                tempList.add(temp);
            }
        }
        
        return tempList;
    }
    
    public List<SelectOption> getRange() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Default', 'Default'));
        options.add(new SelectOption('All', 'All'));
        
        return options;
    }
    
    public void refreshRecords() {
       this.mapMPW = retrieveMPWs();
    }
    
    public class MPWWrapper {
        public string mpwTrainId {get;set;}
        public string mpwTrainName {get;set;}
        public integer noOfDevices {get;set;}
        public integer noOfPrimeDies {get;set;}
        public string geometry {get;set;}
        public string fab {get;set;}
        public datetime reservationOpenDate {get;set;}
        public datetime reservationCloseDate {get;set;}
        public datetime cancellationDate {get;set;}
        public datetime othersPartTapeoutDate {get;set;}
        public datetime customerTapeoutDate {get;set;}
        public datetime firstBatchShipDateStart {get;set;}
        public datetime firstBatchShipDateEnd {get;set;}
        public datetime secondBatchShipDateStart {get;set;}
        public datetime secondBatchShipDateEnd {get;set;}
        
        public MPWWrapper() {
            this.noOfDevices = 0;
            this.noOfPrimeDies = 0;
        }
    }
}