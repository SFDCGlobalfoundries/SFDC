/*
    Author: Zymark Ambat
    Description: This Class serves as the controller for the DevicePreviousEnablingDevicesVF.
    History: 
        ZAmbat      11122013    - Code creation.
*/

public class DevicePreviousEnablingDevicesController {
    public Device__c device {get;set;}
    public List<Device__c> listDevices {get;set;}
    public List<Device__c> listTotalDevices {get;set;}
    public string deviceId {get;set;}
    public string selectedMPW {get;set;}
    public string searchKey {get;set;}
    public integer rowsPerPage {get;set;}
    public integer fromNo {get;set;}
    public integer toNo {get;set;}
    public integer offsetValue {get;set;}
    public integer currentPageNo {get;set;}
    public integer totalNoOfPages {get;set;}
    public integer totalNoOfRecords {get;set;}
    
    public DevicePreviousEnablingDevicesController() {
        // Init
        this.listDevices = new List<Device__c>();
        this.listTotalDevices = new List<Device__c>();
        
        // Get Device details
        this.deviceId = ApexPages.currentPage().getParameters().get('deviceId');
        if (this.deviceId != null && this.deviceId.trim() != '') {
            initPagination();
            retrieveDeviceInfo();
            retrieveDevices();
            
            // Set value
            if (this.listDevices.size() == this.rowsPerPage) {
	        	this.toNo = this.rowsPerPage;
	        } else {
	        	this.toNo = this.listDevices.size();
	        }
        }
    }
    
    public void initPagination() {
    	this.rowsPerPage = integer.valueOf(Environment_Variable__c.getInstance('RECORDS_PER_PAGE').Value__c);
        this.fromNo = 1;
        this.toNo = this.rowsPerPage;
        this.offsetValue = 0;
        this.currentPageNo = 1;
        this.totalNoOfPages = 1;
        this.totalNoOfRecords = 0;
    }
    
    public void retrieveDeviceInfo() {
        // Get Device Info
        this.device = [
            SELECT      Id
                        , Account__c
                        , Previous_Enabling_Devices_MPW__c
            FROM        Device__c
            WHERE       Id = :this.deviceId
        ];
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
        // Get Devices under the same Account
        this.listDevices = [
            SELECT      Id
                        , Name
                        , CRMDID__c
                        , Geometry__c
                        , MPW_Train_Number__c
                        , MPW_Train_Number__r.Name
                        , Process_Family__c
            FROM        Device__c
            WHERE       Id != :this.device.Id
                        AND Account__c = :this.device.Account__c
                        AND Tapeout_Type__c = :Environment_Variable__c.getInstance('DEVICE_TAPEOUT_TYPE_GLOBALSHUTTLE_MPW').Value__c
                        AND MPW_Train_Number__c != NULL
                        AND Name LIKE :((this.searchKey != null && this.searchKey.trim() != '') ? this.searchKey.replace('*', '%').toUpperCase() : '%')
            ORDER BY    MPW_Train_Number__r.Name
                        , CRMDID__c NULLS LAST
            LIMIT       :rowsPerPage
            OFFSET 		:offsetValue
        ];
        
        // Get Total number of Devices under the same Account
        this.listTotalDevices = [
        	SELECT      Id
        	FROM        Device__c
            WHERE       Id != :this.device.Id
                        AND Account__c = :this.device.Account__c
                        AND Tapeout_Type__c = :Environment_Variable__c.getInstance('DEVICE_TAPEOUT_TYPE_GLOBALSHUTTLE_MPW').Value__c
                        AND MPW_Train_Number__c != NULL
                        AND Name LIKE :((this.searchKey != null && this.searchKey.trim() != '') ? this.searchKey.replace('*', '%').toUpperCase() : '%')
        ];
        
        // Set value    
        this.totalNoOfRecords = this.listTotalDevices.size();
           
        integer ans = this.listTotalDevices.size() / this.rowsPerPage;
        integer rem = math.mod(this.listTotalDevices.size(), this.rowsPerPage);
        if (rem > 0) {
        	this.totalNoOfPages = ans + 1;
        } else {
        	this.totalNoOfPages = ans;
        }
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
       	
       	if ((this.toNo + this.rowsPerPage) <= this.listTotalDevices.size()) {
       		this.toNo = this.toNo + this.rowsPerPage;
       	} else {
       		this.toNo = this.listTotalDevices.size();
       	}
       	
        this.offsetValue = this.offsetValue + this.rowsPerPage;
        
        // Refresh values
        retrieveDevices();
    }
    
    public PageReference save() {
        PageReference pageRef;
        
        try {
            this.device.Previous_Enabling_Devices_MPW__c = this.selectedMPW;
            update this.device;
            
            pageRef = new PageReference('/' + this.device.Id);
            pageRef.setRedirect(true);
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, e.getMessage()));
        }
        
        return pageRef;
    }
}