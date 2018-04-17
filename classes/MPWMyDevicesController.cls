/*
    Author: Zymark Ambat
    Description: This serves as the Controller for MPWMyDevicesVF.
    History: 
        ZAmbat      06022015    - Code creation.
        SNair       06262015    - updated.
*/

public class MPWMyDevicesController {
    public integer totalNoOfPages {get;set;}
    public integer totalNoOfRecords {get;set;}
    public integer currentPageNo {get;set;}
    public string sortType {get; set;}
    public string sortField {get; set;}
    public Map<integer, List<MPWDevices>> mapMPWDevices {get;set;}
    public String returnURL{get;set;}
    public String accountId{get;set;}
    
    public MPWMyDevicesController() {
    	this.accountId = ApexPages.currentPage().getParameters().get('accountId');
        this.sortType = 'ASC';
        this.sortField = 'deviceName';
        this.currentPageNo = 1;
        this.mapMPWDevices = new Map<integer, List<MPWDevices>>();
        this.mapMPWDevices = retrieveMPWDevices();
        this.returnURL = ApexPages.currentPage().getURL();
    }
    
    private Map<integer, List<MPWDevices>> retrieveMPWDevices() {
        Map<integer, List<MPWDevices>> tempMap = new Map<integer, List<MPWDevices>>();
        List<MPWDevices> tempList = new List<MPWDevices>();
        //List<Id> listAccountIds = retrieveAccounts(UserInfo.getUserId());
        List<Id> listAccountIds = retrieveAccounts(this.accountId);
        if (listAccountIds.size() > 0) {
        	List<Device__c> deviceList = new List<Device__c>();
        	deviceList = [SELECT    Id, Name, Account__r.Name, Current_Forecast_Tapeout_Date__c, Geometry__c, Process_Family__c, Status__c, Stage__c, Fab__c, (SELECT Id, Name, MPW_Train_Name__c, MPW_Train_Name__r.Name FROM MPW_Reservations__r), Pre_PTRF_Validation_Status__c, Actual_Tapeout_Date_GMT__c, Device_Mask_Set_Title__c, CreatedDate FROM Device__c WHERE Account__c IN :listAccountIds AND Tapeout_Type__c = 'GlobalShuttle MPW' ORDER BY  Name ASC];
    		//for(Device__c d : [SELECT    Id, Name, Account__r.Name, Current_Forecast_Tapeout_Date__c, Geometry__c, Process_Family__c, Status__c, Stage__c, Fab__c, (SELECT Id, Name, MPW_Train_Name__c, MPW_Train_Name__r.Name FROM MPW_Reservations__r), Pre_PTRF_Validation_Status__c, Actual_Tapeout_Date_GMT__c, Device_Mask_Set_Title__c, CreatedDate FROM Device__c WHERE Account__c IN :listAccountIds AND Tapeout_Type__c = 'GlobalShuttle MPW' ORDER BY  Name ASC]) {
    		if(!deviceList.isEmpty()){
    			for(Device__c d: deviceList){
                if (d.MPW_Reservations__r.size() > 0) {
                    for (MPW_Reservation__c mr : d.MPW_Reservations__r) {
                        MPWDevices m = new MPWDevices();
                        m.deviceId = d.Id;
                        m.deviceName = d.Name;
                        m.accountName = d.Account__r.Name;
                        m.tapeoutDate = d.Current_Forecast_Tapeout_Date__c;
                        m.geometry = d.Geometry__c;
                        m.processFamily = d.Process_Family__c;
                        m.status = d.Status__c;
                        m.stage = d.Stage__c;
                        m.fab = d.Fab__c;
                        m.mpwTrainId = mr.MPW_Train_Name__c;
                        m.mpwTrainName = mr.MPW_Train_Name__r.Name;
                        m.mpwReservationFormId = mr.Id;
                        m.mpwReservationFormName = mr.Name;
                        m.tapeoutReadiness = d.Pre_PTRF_Validation_Status__c;
                        m.actualTapeoutDate = d.Actual_Tapeout_Date_GMT__c;
                        m.maskSetTitle = d.Device_Mask_Set_Title__c;
                        m.createdDate = Date.newInstance(d.CreatedDate.year(), d.CreatedDate.month(), d.CreatedDate.day());
                        
                        tempList.add(m);
                    }
                } else {
                    MPWDevices m = new MPWDevices();
                    m.deviceId = d.Id;
                    m.deviceName = d.Name;
                    m.accountName = d.Account__r.Name;
                    m.tapeoutDate = d.Current_Forecast_Tapeout_Date__c;
                    m.geometry = d.Geometry__c;
                    m.processFamily = d.Process_Family__c;
                    m.status = d.Status__c;
                    m.stage = d.Stage__c;
                    m.fab = d.Fab__c;
                    m.tapeoutReadiness = d.Pre_PTRF_Validation_Status__c;
                    m.actualTapeoutDate = d.Actual_Tapeout_Date_GMT__c;
                    m.maskSetTitle = d.Device_Mask_Set_Title__c;
                    m.createdDate = Date.newInstance(d.CreatedDate.year(), d.CreatedDate.month(), d.CreatedDate.day());
                    
                    tempList.add(m);
                }
            }
    		}
        
            // Paginate
            if (tempList.size() > 0) {
                tempMap = paginateRecords(tempList);
            }
        }
        
        return tempMap;
    }
    
    private Map<integer, List<MPWDevices>> paginateRecords(List<MPWDevices> tempList) {
        Map<integer, List<MPWDevices>> tempMap = new Map<integer, List<MPWDevices>>();
        integer recordsPerPage = 10;
        integer pageNo = 1;
        List<MPWDevices> temp = new List<MPWDevices>();
        for (MPWDevices m : tempList) {
            if (temp.size() < recordsPerPage) {
                temp.add(m);
            } else {
                tempMap.put(pageNo, temp);
                pageNo++;
                temp = new List<MPWDevices>();
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
    
    /*private List<Id> retrieveAccounts(string userId) {
        List<Id> listAccountIds = new List<Id>();
        Set<Id> accountIds = new Set<Id>();
        
        // Get portal user's account
        User portalUser = [SELECT Id, Contact.AccountId FROM User WHERE Id = :userId];
        
        List<Account> accList = [select Id, ParentId from Account where Id =: portalUser.Contact.AccountId];
        System.debug(accList);
        if(!accList.isEmpty()){
            Set<Id> accIdList = new Set<Id>();
            for(Account a: accList){
                accIdList.add(a.Id);
                accountIds.add(a.Id);
            }
            
            if(!accIdList.isEmpty()){
                for (Account_Hierarchy__c ah : [SELECT Parent_Id__c FROM Account_Hierarchy__c WHERE Account_Id__c IN : accIdList AND Parent_Id__c NOT IN :accIdList]) { 
                    accountIds.add(ah.Parent_Id__c);
                }
                
                for (Account_Hierarchy__c ah : [SELECT Account_Id__c FROM Account_Hierarchy__c WHERE Parent_Id__c IN : accIdList AND Account_Id__c NOT IN :accIdList]) { 
                    accountIds.add(ah.Account_Id__c);
                }
            }
            
            listAccountIds.addAll(accountIds);
        }
        
        return listAccountIds;
    }*/
    
    private List<Id> retrieveAccounts(string accountId) {
        List<Id> listAccountIds = new List<Id>();
        Set<Id> accountIds = new Set<Id>();
        
        // Get portal user's account
        //User portalUser = [SELECT Id, Contact.AccountId FROM User WHERE Id = :userId];
        
        List<Account> accList = [select Id, ParentId from Account where Id =: accountId];
        System.debug(accList);
        if(!accList.isEmpty()){
            Set<Id> accIdList = new Set<Id>();
            for(Account a: accList){
                accIdList.add(a.Id);
                accountIds.add(a.Id);
            }
            
            if(!accIdList.isEmpty()){
                for (Account_Hierarchy__c ah : [SELECT Parent_Id__c FROM Account_Hierarchy__c WHERE Account_Id__c IN : accIdList AND Parent_Id__c NOT IN :accIdList]) { 
                    accountIds.add(ah.Parent_Id__c);
                }
                
                for (Account_Hierarchy__c ah : [SELECT Account_Id__c FROM Account_Hierarchy__c WHERE Parent_Id__c IN : accIdList AND Account_Id__c NOT IN :accIdList]) { 
                    accountIds.add(ah.Account_Id__c);
                }
            }
            
            listAccountIds.addAll(accountIds);
        }
        
        return listAccountIds;
    }
    
    public List<MPWDevices> getMyMPWDevices() {
        return (this.mapMPWDevices.size() > 0 ? this.mapMPWDevices.get(this.currentPageNo) : new List<MPWDevices>());
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
        List<MPWDevices> tempList = new List<MPWDevices>();
        for (integer key : this.mapMPWDevices.keySet()) {
            tempList.addAll(this.mapMPWDevices.get(key));
        }
        
        Map<string, List<MPWDevices>> tempMap = new Map<string, List<MPWDevices>>();
        for(MPWDevices m : tempList){
            string sortKey = ''; 
            if (this.sortField == 'deviceName') {
                sortKey = m.deviceName;
            } else if (this.sortField == 'accountName') {
                sortKey = m.accountName;
            } else if (this.sortField == 'tapeoutDate') {
                sortKey = string.valueOf(m.tapeoutDate);
            } else if (this.sortField == 'geometry') {
                sortKey = m.geometry;
            } else if (this.sortField == 'processFamily') {
                sortKey = m.processFamily;
            } else if (this.sortField == 'status') {
                sortKey = m.status;
            } else if (this.sortField == 'stage') {
                sortKey = m.stage;
            } else if (this.sortField == 'fab') {
                sortKey = m.fab;
            } else if (this.sortField == 'mpwTrainName') {
                sortKey = m.mpwTrainName;
            } else if (this.sortField == 'mpwReservationFormName') {
                sortKey = m.mpwReservationFormName;
            } else if (this.sortField == 'tapeoutReadiness') {
                sortKey = m.tapeoutReadiness;
            } else if (this.sortField == 'actualTapeoutDate') {
                sortKey = string.valueOf(m.actualTapeoutDate);
            } else if (this.sortField == 'maskSetTitle') {
                sortKey = m.maskSetTitle;
            } else if (this.sortField == 'createdDate') {
                sortKey = string.valueOf(m.createdDate);
            }

            if(tempMap.containsKey(sortKey)) {
                tempMap.get(sortKey).add(m);
            } else {
                tempMap.put(sortKey, new List<MPWDevices>{m});
            }
        }
        
        List<string> sortList = new List<String>();
        sortList.addAll(tempMap.keySet());
        sortList.sort();
        
        tempList = new List<MPWDevices>();
        if(this.sortType == 'ASC'){
            for(string s : sortList){
                tempList.addAll(tempMap.get(s));    
            }
        } else if(this.sortType == 'DESC'){
            for(integer ctr = (sortList.size()-1); ctr >= 0; ctr--){
                tempList.addAll(tempMap.get(sortList[ctr]));    
            }
        }
       
        this.mapMPWDevices = paginateRecords(tempList);
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
    
    public pageReference raiseMPWRequest(){
        pageReference pgRef = new pageReference('/apex/MPWGeometrySelectionForReservationFormVF');
        pgRef.getParameters().put('retURL',this.returnURL);
        pgRef.setRedirect(true);
        return pgRef;
    }
    
    public class MPWDevices {
        public string deviceId {get;set;}
        public string deviceName {get;set;}
        public string accountName {get;set;}
        public date tapeoutDate {get;set;}
        public string geometry {get;set;}
        public string processFamily {get;set;}
        public string status {get;set;}
        public string stage {get;set;}
        public string fab {get;set;}
        public string mpwTrainId {get;set;}
        public string mpwTrainName {get;set;}
        public string mpwReservationFormId {get;set;}
        public string mpwReservationFormName {get;set;}
        public string tapeoutReadiness {get;set;}
        public date actualTapeoutDate {get;set;}
        public string maskSetTitle {get;set;}
        public date createdDate {get;set;}
        
        public MPWDevices() {}
    }
}