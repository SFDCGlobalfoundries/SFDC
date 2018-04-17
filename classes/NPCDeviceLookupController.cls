/*
    Author: Zymark Ambat
    Description: This serves as the Controller for NPCDeviceLookupVF.
    History: 
        ZAmbat      11142013    - Code creation.
        ZAmbat      11222013    - Updated code to retrieve Devices under Account Hierarchy.
        Nbustillos	01032014	- Updated logic to retrieve Accoun via Id instead of name.
        						- change variable name from accountName to accountId.
        ZAmbat		04032014	- Updated code as per CASE 7400.
*/

public class NPCDeviceLookupController {
    public List<Device__c> listDevices {get;set;}
    public Set<Id> accountIds {get;set;}
    public string accountId {get;set;}
    public string searchKey {get;set;}
    public integer rowsPerPage {get;set;}
    public integer fromNo {get;set;}
    public integer toNo {get;set;}
    public integer offsetValue {get;set;}
    public integer currentPageNo {get;set;}
    public integer totalNoOfPages {get;set;}
    public integer totalNoOfRecords {get;set;}
    
    public NPCDeviceLookupController() {
        this.accountId = system.currentPageReference().getParameters().get('acct');
        this.searchKey = system.currentPageReference().getParameters().get('lksrch');
        if (this.searchKey != null && this.searchKey.trim() != '') {
        	if (this.searchKey == 'Click lookup icon...') {
        		this.searchKey = '';
        	}
        }
        
        // Retrieve Accounts
        retrieveAccounts();
        
        // Init Pagination
        initPagination();
        
        // Search Devices
        searchDevices();
    }
    
    public void retrieveAccounts() {
    	// Get Account Id
        Account a = [
            SELECT      Id
                        , ParentId
            FROM        Account
            //WHERE       Name = :this.accountName
            WHERE Id = :this.accountId
        ];
        
        // Get Accounts in the Account Hierarchy
        this.accountIds = new Set<Id>();
        if (a.ParentId != null) {
            for (Account_Hierarchy__c ah : [SELECT      Parent_Id__c
                                            FROM        Account_Hierarchy__c
                                            WHERE       Account_Id__c = :a.Id
                                                        AND Parent_Id__c != :a.Id]) { 
                this.accountIds.add(ah.Parent_Id__c);
            }
        } 
           
        // Check for Devices below the Account Hierarchy
        for (Account_Hierarchy__c ah : [SELECT      Account_Id__c
                                        FROM        Account_Hierarchy__c
                                        WHERE       Parent_Id__c = :a.Id
                                                    AND Account_Id__c != :a.Id]) { 
            this.accountIds.add(ah.Account_Id__c);
        }
        
        // Add User's Account Id
        this.accountIds.add(a.Id);
    }
    
    public void searchDevices() {
    	// Init Pagination
        initPagination();
        
        // Retrieve Devices
        retrieveDevices();
        
        // Set value
        if (this.listDevices.size() == this.rowsPerPage) {
        	this.toNo = this.rowsPerPage;
        } else {
        	this.toNo = this.listDevices.size();
        }
    }
    
    public void retrieveDevices() {
        // Init
        this.listDevices = new List<Device__c>();

        string sKey = '';
        if (this.searchKey == null || this.searchKey.trim() == '') {
            sKey = '%';
        } else {
            sKey = '%' + this.searchKey.replace('*', '%') + '%';
        }
        
        this.listDevices = [
            SELECT      Id
                        , Name
                        , CRMDID__c
            FROM        Device__c
            WHERE       Name LIKE :sKey
                        AND Account__c IN :this.accountIds
                        //AND Device_Type__c = 'Base'
            ORDER BY    Name ASC
            LIMIT       :rowsPerPage
            OFFSET 		:offsetValue
        ];
        
        // Get Total number of records
        List<Device__c> tempList = [
        	SELECT      Id
                        , Name
                        , CRMDID__c
            FROM        Device__c
            WHERE       Name LIKE :sKey
                        AND Account__c IN :this.accountIds
                        AND Device_Type__c = 'Base'
        ];
        
        this.totalNoOfRecords = tempList.size();
        integer ans = this.totalNoOfRecords / this.rowsPerPage;
        integer rem = math.mod(this.totalNoOfRecords, this.rowsPerPage);
        if (rem > 0) {
        	this.totalNoOfPages = ans + 1;
        } else {
        	this.totalNoOfPages = ans;
        }
    }
    
    public void initPagination() {
    	this.rowsPerPage = integer.valueOf(Environment_Variable__c.getInstance('RECORDS_PER_PAGE_NPCLIST').Value__c);
        this.fromNo = 1;
        this.toNo = this.rowsPerPage;
        this.offsetValue = 0;
        this.currentPageNo = 1;
        this.totalNoOfPages = 1;
        this.totalNoOfRecords = 0;
    }
    
    public boolean getHasPrevious() {
    	return (this.currentPageNo > 1 ? true : false);
    }
    
    public boolean getHasNext() {
    	return (this.currentPageNo < this.totalNoOfPages ? true : false);
    }
	
	public void previous() {
    	this.currentPageNo--;
    	this.fromNo = this.fromNo - this.rowsPerPage;
        this.toNo = (this.fromNo + this.rowsPerPage) - 1;
        this.offsetValue = this.offsetValue - this.rowsPerPage;
        
        // Refresh values
        retrieveDevices();
    }
    
    public void next() {
    	this.currentPageNo++;
    	this.fromNo = this.fromNo + this.rowsPerPage;
       	
       	if ((this.toNo + this.rowsPerPage) <= this.totalNoOfRecords) {
       		this.toNo = this.toNo + this.rowsPerPage;
       	} else {
       		this.toNo = this.totalNoOfRecords;
       	}
       	
        this.offsetValue = this.offsetValue + this.rowsPerPage;
        
        // Refresh values
        retrieveDevices();
    }
    
    public string getFormTag() {
        return System.currentPageReference().getParameters().get('frm');
    }
    
    public string getTextBox() {
        return System.currentPageReference().getParameters().get('txt');
    }
}