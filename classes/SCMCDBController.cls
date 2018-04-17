/*
    Author: Zymark Ambat
    Description: This Class serves as the controller for the SCMCDBVF.
    History: 
        ZAmbat      09102013    - Code creation.
        DBiswal     11272014    - Added more fields to display for customer users.        
        DBiswal     01122015    - Added more Filter.
        DBiswal     01192015    - Added code to search within Account Hierarchy for Portal Users.                
*/

public class SCMCDBController {
    public string account {get;set;}
    public string soqlQuery {get;set;}
    public string soqlFilters {get;set;}
    public string dpmlSelected {get;set;}
    public string reportURL {get;set;}
    public string sortType {get; set;}
    public string sortField {get; set;}
    public integer pageNumber {get;set;}
    public date qtr1Start {get;set;}
    public date qtr2Start {get;set;}
    public date qtr3Start {get;set;}
    public date qtr4Start {get;set;}
    public date poRaiseDate {get;set;}
    public date goodsReceivedDate {get;set;}
    public boolean showResults {get;set;}
    public boolean isPortalUser {get;set;}
    public boolean isExportBatch {get;set;}
    public boolean hasClickedExportBatch {get;set;}
    public PO_Lead_Time__c scmcdb {get;set;}
    public Set<Id> accountIds {get;set;}
    public List<List<string>> listDetails {get;set;}
    public List<PO_Lead_Time__c> currPage {get;set;}
    private integer listSize;
    public List<string> fabValues {get;set;}
    public List<string> geometryValues {get;set;}
    public List<PoLeadTimeWrapper> listPoLeadTime {get;set;}
    public Map<string, string> mapAccountShortName {get;set;} 
    public List<SelectOption> accountOptions {get;set;}
    public ApexPages.StandardSetController stdSetController {get;set;}
    public string defaccount {get;set;}
    
    public SCMCDBController() {
        // Init
        this.account = '';
        this.soqlQuery = '';
        this.soqlFilters = '';  
        this.scmcdb = new PO_Lead_Time__c();
        this.showResults = false;
        this.isExportBatch = false;
        this.hasClickedExportBatch = false;
        this.accountIds = new Set<Id>();
        this.listDetails = new List<List<string>>();
        this.dpmlSelected = 'Standard';
        this.fabValues = new List<string>();
        this.geometryValues = new List<string>();
        this.mapAccountShortName = new Map<string, string>(); 
        this.accountOptions = new List<SelectOption>();
        this.sortField = 'Base_Device__c';
        this.sortType = 'ASC';
        this.pageNumber = 1;
        this.defaccount = '';        
        
        // Check if User is Portal User
        checkUser();
        
        // Get Quarters
        computeQuarterRanges();
    }
    
    public void retrieveSCMCDB() {
        // Refresh
        this.soqlQuery = '';
        this.soqlFilters = '';
        
        // Validation
        if (this.scmcdb.Fab__c != null || this.scmcdb.Base_Device__c != null || this.isPortalUser) {
            // Create the SOQL Query
            this.soqlQuery = 'SELECT Id, Name, Account__c, Account__r.Name, Base_Device__c, Bullet_DPML_12w_day_CurrQtr__c, Bullet_DPML_12w_day_CurrQtr_1__c, Bullet_DPML_12w_day_CurrQtr_2__c, Bullet_DPML_12w_day_CurrQtr_3__c, ' + 
                                     'PO_Raise_Date__c, Goods_Received_Date__c, Bullet_DPML_12w_day_CurrQtr1__c, Bullet_DPML_12w_day_CurrQtr_1_1__c, Bullet_DPML_12w_day_CurrQtr_2_1__c, Bullet_DPML_12w_day_CurrQtr_3_1__c, Device_Account_Short_Name__c, ' +
                                     'Fab__c, Geometry__c, Hot_DPML_12w_day_CurrQtr1__c, Total_Lead_Time__c, Hot_DPML_12w_day_CurrQtr__c, Hot_DPML_12w_day_CurrQtr_1__c, Hot_DPML_12w_day_CurrQtr_2__c, Hot_DPML_12w_day_CurrQtr_3__c, ' +
                                     'Hot_DPML_12w_day_CurrQtr_1_1__c, Hot_DPML_12w_day_CurrQtr_2_1__c, Hot_DPML_12w_day_CurrQtr_3_1__c, ML_Count_FEOL_BEOL__c, PF_Adder_day__c, PO_Lead_Time_day__c, Process_Flow_Pid_PT_Id__c, Device_Stage__c, ' +
                                     'Sort_Adder_day__c, Standard_DPML_day_CurrQtr__c, Standard_DPML_day_CurrQtr_1__c, Standard_DPML_day_CurrQtr_2__c, Standard_DPML_day_CurrQtr_3__c ' +
                             'FROM PO_Lead_Time__c';
            
            if (this.isPortalUser) {
                //DBiswal 01192015
                this.soqlFilters = 'Account__c IN :accountIds';
            } else {
                if (this.account != null && this.account.trim() != '') {
                    this.soqlFilters = 'Account__r.Name LIKE \'%' + this.account + '%\'';
                }   
            }
            
            if (this.scmcdb.Base_Device__c != null && this.scmcdb.Base_Device__c.trim() != '') {
                if (this.soqlFilters != null && this.soqlFilters.trim() != '') {
                    this.soqlFilters = this.soqlFilters + ' AND ';  
                }
               //Dbiswal 01122015    
               //this.soqlFilters = 'Base_Device__c LIKE \'%' + this.scmcdb.Base_Device__c + '%\'';
               this.soqlFilters = this.soqlFilters + 'Base_Device__c LIKE \'%' + this.scmcdb.Base_Device__c + '%\'';                
            }
            
            if (this.scmcdb.Fab__c != null) {
                if (this.soqlFilters != null && this.soqlFilters.trim() != '') {
                    this.soqlFilters = this.soqlFilters + ' AND ';  
                }
                this.fabValues = this.scmcdb.Fab__c.split(';');
                this.soqlFilters = this.soqlFilters + 'Fab__c IN :fabValues';
            }
            
            if (this.scmcdb.Geometry__c != null) {
                if (this.soqlFilters != null && this.soqlFilters.trim() != '') {
                    this.soqlFilters = this.soqlFilters + ' AND ';  
                }
                this.geometryValues = this.scmcdb.Geometry__c.split(';');
                this.soqlFilters = this.soqlFilters + 'Geometry__c IN :geometryValues';
            }
            
            if (this.soqlFilters != null && this.soqlFilters.trim() != '') {
                this.soqlQuery = this.soqlQuery + ' WHERE ' + this.soqlFilters + ' AND Device_Stage__c NOT IN (\'EOL\',\'Inactive\') ORDER BY ' + (this.sortField == 'Base_Device__c' ? 'Base_Device__c ' + this.sortType : this.sortField + ' ' + this.sortType + ', Base_Device__c ASC');
            }
            
            // Get Records
            this.stdSetController = new ApexPages.StandardSetController(Database.getQueryLocator(this.soqlQuery + ' LIMIT 10000'));
            this.stdSetController.setPageSize(50);
            this.stdSetController.setPageNumber(this.pageNumber);
            if (this.stdSetController.getResultSize() < 10000) {
                this.isExportBatch = false;
            } else {
                this.isExportBatch = true;
            }
            this.hasClickedExportBatch = false;
            
            // Show Results
            this.showResults = true;
        } else {
            // Show error message
            this.showResults = false;
            this.listPoLeadTime = new List<PoLeadTimeWrapper>();
            this.listDetails = new List<List<string>>();
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please fill up Device or Fab.'));
        }
    }
    
    public List<PoLeadTimeWrapper> getPoLeadTimeRecords() {              
        // Validation
        date tempDate;
        if (this.scmcdb.PO_Raise_Date__c != null && this.scmcdb.Goods_Received_Date__c == null) {              
            tempDate = this.scmcdb.PO_Raise_Date__c;
        } else if (this.scmcdb.PO_Raise_Date__c == null && this.scmcdb.Goods_Received_Date__c != null) {            
            tempDate = this.scmcdb.Goods_Received_Date__c;
        } else {
            tempDate = date.today();
        }
        
        this.listPoLeadTime = new List<PoLeadTimeWrapper>(); 
        if (this.soqlQuery != null && tempDate >= this.qtr1Start && tempDate <= this.qtr4Start.addMonths(3).addDays(-1)) { 
            for (PO_Lead_Time__c s : (List<PO_Lead_Time__c>)this.stdSetController.getRecords()) {
                PoLeadTimeWrapper p = new PoLeadTimeWrapper();
                p.account = s.Account__r.Name;
                p.accountShortName = s.Device_Account_Short_Name__c;
                p.geometry = s.Geometry__c;
                p.device = s.Base_Device__c;
                p.fab = s.Fab__c;
                p.pfAdder = s.PF_Adder_day__c;
                p.mlCount = s.ML_Count_FEOL_BEOL__c;
                p.poLeadTime = s.PO_Lead_Time_day__c;
                p.processId = s.Process_Flow_Pid_PT_Id__c;
                //11272014 DBiswal - Defining new fields 
                p.standardCurrQtr = s.Standard_DPML_day_CurrQtr__c;
                p.standardCurrQtr1 = s.Standard_DPML_day_CurrQtr_1__c;
                p.standardCurrQtr2 = s.Standard_DPML_day_CurrQtr_2__c;
                p.standardCurrQtr3 = s.Standard_DPML_day_CurrQtr_3__c;
                p.bulletLE12CurrQtr = s.Bullet_DPML_12w_day_CurrQtr__c;
                p.bulletLE12CurrQtr1 = s.Bullet_DPML_12w_day_CurrQtr_1__c;
                p.bulletLE12CurrQtr2 = s.Bullet_DPML_12w_day_CurrQtr_2__c;
                p.bulletLE12CurrQtr3 = s.Bullet_DPML_12w_day_CurrQtr_3__c;
                p.bulletG12CurrQtr = s.Bullet_DPML_12w_day_CurrQtr1__c;
                p.bulletG12CurrQtr1 = s.Bullet_DPML_12w_day_CurrQtr_1_1__c;
                p.bulletG12CurrQtr2 = s.Bullet_DPML_12w_day_CurrQtr_2_1__c;
                p.bulletG12CurrQtr3 = s.Bullet_DPML_12w_day_CurrQtr_3_1__c;
                p.hotLE12CurrQtr = s.Hot_DPML_12w_day_CurrQtr__c;
                p.hotLE12CurrQtr1 = s.Hot_DPML_12w_day_CurrQtr_1__c;
                p.hotLE12CurrQtr2 = s.Hot_DPML_12w_day_CurrQtr_2__c;
                p.hotLE12CurrQtr3 = s.Hot_DPML_12w_day_CurrQtr_3__c;
                p.hotG12CurrQtr = s.Hot_DPML_12w_day_CurrQtr1__c;
                p.hotG12CurrQtr1 = s.Hot_DPML_12w_day_CurrQtr_1_1__c;
                p.hotG12CurrQtr2 = s.Hot_DPML_12w_day_CurrQtr_2_1__c;
                p.hotG12CurrQtr3 = s.Hot_DPML_12w_day_CurrQtr_3_1__c;                
                
                // Total Lead Time
                decimal dpml = 0;
                if (tempDate >= this.qtr1Start && tempDate <= this.qtr2Start.addDays(-1)) {
                    if (this.dpmlSelected == 'Standard') {
                        if (s.Standard_DPML_day_CurrQtr__c != null && s.Standard_DPML_day_CurrQtr__c.trim() != '') {
                            dpml = decimal.valueOf(s.Standard_DPML_day_CurrQtr__c);
                        } 
                    } else if (this.dpmlSelected == 'BulletLE12') {
                        if (s.Bullet_DPML_12w_day_CurrQtr1__c != null && s.Bullet_DPML_12w_day_CurrQtr1__c.trim() != '') {
                            dpml = decimal.valueOf(s.Bullet_DPML_12w_day_CurrQtr__c);
                        }
                    } else if (this.dpmlSelected == 'BulletG12') {
                        if (s.Bullet_DPML_12w_day_CurrQtr1__c != null && s.Bullet_DPML_12w_day_CurrQtr1__c.trim() != '') {
                            dpml = decimal.valueOf(s.Bullet_DPML_12w_day_CurrQtr1__c);
                        }
                    } else if (this.dpmlSelected == 'HotLE12') {
                        if (s.Hot_DPML_12w_day_CurrQtr1__c != null && s.Hot_DPML_12w_day_CurrQtr1__c.trim() != '') {
                            dpml = decimal.valueOf(s.Hot_DPML_12w_day_CurrQtr__c);
                        }
                    } else if (this.dpmlSelected == 'HotG12') {
                        if (s.Hot_DPML_12w_day_CurrQtr1__c != null && s.Hot_DPML_12w_day_CurrQtr1__c.trim() != '') {
                            dpml = decimal.valueOf(s.Hot_DPML_12w_day_CurrQtr1__c);
                        }
                    }
                } else if (tempDate >= this.qtr2Start && tempDate <= this.qtr3Start.addDays(-1)) {
                    if (this.dpmlSelected == 'Standard') {
                        if (s.Standard_DPML_day_CurrQtr_1__c != null && s.Standard_DPML_day_CurrQtr_1__c.trim() != '') {
                            dpml = decimal.valueOf(s.Standard_DPML_day_CurrQtr_1__c);
                        } 
                    } else if (this.dpmlSelected == 'BulletLE12') {
                        if (s.Bullet_DPML_12w_day_CurrQtr_1_1__c != null && s.Bullet_DPML_12w_day_CurrQtr_1_1__c.trim() != '') {
                            dpml = decimal.valueOf(s.Bullet_DPML_12w_day_CurrQtr_1__c);
                        }
                    } else if (this.dpmlSelected == 'BulletG12') {
                        if (s.Bullet_DPML_12w_day_CurrQtr_1_1__c != null && s.Bullet_DPML_12w_day_CurrQtr_1_1__c.trim() != '') {
                            dpml = decimal.valueOf(s.Bullet_DPML_12w_day_CurrQtr_1_1__c);
                        }
                    } else if (this.dpmlSelected == 'HotLE12') {
                        if (s.Hot_DPML_12w_day_CurrQtr_1_1__c != null && s.Hot_DPML_12w_day_CurrQtr_1_1__c.trim() != '') {
                            dpml = decimal.valueOf(s.Hot_DPML_12w_day_CurrQtr_1__c);
                        }
                    } else if (this.dpmlSelected == 'HotG12') {
                        if (s.Hot_DPML_12w_day_CurrQtr_1_1__c != null && s.Hot_DPML_12w_day_CurrQtr_1_1__c.trim() != '') {
                            dpml = decimal.valueOf(s.Hot_DPML_12w_day_CurrQtr_1_1__c);
                        }
                    }
                } else if (tempDate >= this.qtr3Start && tempDate <= this.qtr4Start.addDays(-1)) {
                    if (this.dpmlSelected == 'Standard') {
                        if (s.Standard_DPML_day_CurrQtr_2__c != null && s.Standard_DPML_day_CurrQtr_2__c.trim() != '') {
                            dpml = decimal.valueOf(s.Standard_DPML_day_CurrQtr_2__c);
                        } 
                    } else if (this.dpmlSelected == 'BulletLE12') {
                        if (s.Bullet_DPML_12w_day_CurrQtr_2_1__c != null && s.Bullet_DPML_12w_day_CurrQtr_2_1__c.trim() != '') {
                            dpml = decimal.valueOf(s.Bullet_DPML_12w_day_CurrQtr_2__c);
                        }
                    } else if (this.dpmlSelected == 'BulletG12') {
                        if (s.Bullet_DPML_12w_day_CurrQtr_2_1__c != null && s.Bullet_DPML_12w_day_CurrQtr_2_1__c.trim() != '') {
                            dpml = decimal.valueOf(s.Bullet_DPML_12w_day_CurrQtr_2_1__c);
                        }
                    } else if (this.dpmlSelected == 'HotLE12') {
                        if (s.Hot_DPML_12w_day_CurrQtr_2_1__c != null && s.Hot_DPML_12w_day_CurrQtr_2_1__c.trim() != '') {
                            dpml = decimal.valueOf(s.Hot_DPML_12w_day_CurrQtr_2__c);
                        }
                    } else if (this.dpmlSelected == 'HotG12') {
                        if (s.Hot_DPML_12w_day_CurrQtr_2_1__c != null && s.Hot_DPML_12w_day_CurrQtr_2_1__c.trim() != '') {
                            dpml = decimal.valueOf(s.Hot_DPML_12w_day_CurrQtr_2_1__c);
                        }
                    }
                } else if (tempDate >= this.qtr4Start && tempDate <= this.qtr4Start.addMonths(3).addDays(-1)) {
                    if (this.dpmlSelected == 'Standard') {
                        if (s.Standard_DPML_day_CurrQtr_3__c != null && s.Standard_DPML_day_CurrQtr_3__c.trim() != '') {
                            dpml = decimal.valueOf(s.Standard_DPML_day_CurrQtr_3__c);
                        }
                    } else if (this.dpmlSelected == 'BulletLE12') {
                        if (s.Bullet_DPML_12w_day_CurrQtr_3_1__c != null && s.Bullet_DPML_12w_day_CurrQtr_3_1__c.trim() != '') {
                            dpml = decimal.valueOf(s.Bullet_DPML_12w_day_CurrQtr_3__c);
                        }
                    } else if (this.dpmlSelected == 'BulletG12') {
                        if (s.Bullet_DPML_12w_day_CurrQtr_3_1__c != null && s.Bullet_DPML_12w_day_CurrQtr_3_1__c.trim() != '') {
                            dpml = decimal.valueOf(s.Bullet_DPML_12w_day_CurrQtr_3_1__c);
                        }
                    } else if (this.dpmlSelected == 'HotLE12') {
                        if (s.Hot_DPML_12w_day_CurrQtr_3_1__c != null && s.Hot_DPML_12w_day_CurrQtr_3_1__c.trim() != '') {
                            dpml = decimal.valueOf(s.Hot_DPML_12w_day_CurrQtr_3__c);
                        }
                    } else if (this.dpmlSelected == 'HotG12') {
                        if (s.Hot_DPML_12w_day_CurrQtr_3_1__c != null && s.Hot_DPML_12w_day_CurrQtr_3_1__c.trim() != '') {
                            dpml = decimal.valueOf(s.Hot_DPML_12w_day_CurrQtr_3_1__c);
                        }
                    }
                }
                
                integer noOfMaskLayers = 0;
                if (s.ML_Count_FEOL_BEOL__c != null && s.ML_Count_FEOL_BEOL__c.trim() != '') {
                    noOfMaskLayers = integer.valueOf(s.ML_Count_FEOL_BEOL__c);
                }
                /** Case#00053847 ---Jabee---**/
                //integer pfAdder = 0;
                decimal pfAdder = 0;
                if (s.PF_Adder_day__c != null && s.PF_Adder_day__c.trim() != '') {
                    pfAdder = decimal.valueOf(s.PF_Adder_day__c);
                }
                /**--END--Case#00053847-**/
                integer fabQueueTime = 0;
                if (s.PO_Lead_Time_day__c != null && s.PO_Lead_Time_day__c.trim() != '') {
                    fabQueueTime = integer.valueOf(s.PO_Lead_Time_day__c);
                }
                
                // Put values in list
                p.dpml = string.valueOf(dpml);
                p.totalLeadTime = (fabQueueTime + pfAdder + (dpml * noOfMaskLayers)).round(System.RoundingMode.UP);
                if (this.scmcdb.PO_Raise_Date__c != null && this.scmcdb.Goods_Received_Date__c == null) {
                    p.poRaiseDate = this.scmcdb.PO_Raise_Date__c;
                    p.goodsReceivedDate = this.scmcdb.PO_Raise_Date__c.addDays(integer.valueOf(p.totalLeadTime));
                } else if (this.scmcdb.PO_Raise_Date__c == null && this.scmcdb.Goods_Received_Date__c != null) {
                    p.poRaiseDate = this.scmcdb.Goods_Received_Date__c.addDays(integer.valueOf(p.totalLeadTime) * -1);
                    p.goodsReceivedDate = this.scmcdb.Goods_Received_Date__c;
                } else {
                    p.poRaiseDate = date.today();
                    p.goodsReceivedDate = date.today().addDays(integer.valueOf(p.totalLeadTime));
                }
                
                this.listPoLeadTime.add(p);
            }
        }
        
        return this.listPoLeadTime;
    }
    
    public PageReference processBatch() {
        // Check if user has an existing set of records in the table
        List<PO_Lead_Time_Report__c> listPoLeadTimeReport = [
            SELECT      Id
            FROM        PO_Lead_Time_Report__c
            WHERE       User_Id__c = :UserInfo.getUserId()
                        AND DPML_Selected__c = :this.dpmlSelected
                        //AND PO_Raise_Date__c = :this.poRaiseDate
                        LIMIT 1
        ];
        
        date prDate;
        date grDate;
        if (this.scmcdb.PO_Raise_Date__c != null && this.scmcdb.Goods_Received_Date__c == null) {
            prDate = this.scmcdb.PO_Raise_Date__c;
        } else if (this.scmcdb.PO_Raise_Date__c == null && this.scmcdb.Goods_Received_Date__c != null) {
            grDate = this.scmcdb.Goods_Received_Date__c;
        } else {
            prDate = date.today();
        }
        
        if (listPoLeadTimeReport.size() > 0) {
            // Delete records
            database.executeBatch(new POLeadTimeBatchDelete(prDate, grDate, this.qtr1Start, this.qtr2Start, this.qtr3Start, this.qtr4Start, this.soqlQuery, this.dpmlSelected, this.fabValues, this.geometryValues, UserInfo.getUserId(), true)); 
        } else {
            // Retrieve records
            database.executeBatch(new POLeadTimeBatchUpdate(prDate, grDate, this.qtr1Start, this.qtr2Start, this.qtr3Start, this.qtr4Start, this.soqlQuery, this.dpmlSelected, this.fabValues, this.geometryValues, UserInfo.getUserId()));
        }
        
        this.isExportBatch = false;
        this.hasClickedExportBatch = true;
        
        return null;
    }
    
    public PageReference exportCsvFile() {
        // Refresh
        this.listDetails = new List<List<string>>();
        createCsvFile();
        
        return new PageReference('/apex/SCMCDBExportVF');
    }
    
    public void createCsvFile() {
        date prDate;
        date grDate;
        if (this.scmcdb.PO_Raise_Date__c != null && this.scmcdb.Goods_Received_Date__c == null) {
            prDate = this.scmcdb.PO_Raise_Date__c;
        } else if (this.scmcdb.PO_Raise_Date__c == null && this.scmcdb.Goods_Received_Date__c != null) {
            grDate = this.scmcdb.Goods_Received_Date__c;
        } else {
            prDate = date.today();
        }
        
        // Create Headers
        List<string> headers = new List<string>();
        if(!this.isPortalUser){
            headers.add('Account,Short Name,Device,Device Stage,Fab,Process Id,Geometry,DPML,ML Count,Fab Queue Time,PF Adder,Total Lead Time,PO Raise Date,Wafer Ship Date\n');
        } else {
            headers.add('Account,Short Name,Device,Device Stage,Fab,Process Id,Geometry,Standard DPML CurrQtr,Standard DPML CurrQtr+1,Standard DPML CurrQtr+2,Standard DPML CurrQtr+3,Bullet DPML (<=12w) CurrQtr,Bullet DPML (<=12w) CurrQtr+1,Bullet DPML (<=12w) CurrQtr+2,Bullet DPML (<=12w) CurrQtr+3,Bullet DPML (>12w) CurrQtr,Bullet DPML (>12w) CurrQtr+1,Bullet DPML (>12w) CurrQtr+2,Bullet DPML (>12w) CurrQtr+3,Hot DPML (<=12w) CurrQtr,Hot DPML (<=12w) CurrQtr+1,Hot DPML (<=12w) CurrQtr+2,Hot DPML (<=12w) CurrQtr+3,Hot DPML (>12w) CurrQtr,Hot DPML (>12w) CurrQtr+1,Hot DPML (>12w) CurrQtr+2,Hot DPML (>12w) CurrQtr+3\n');
        }
        this.listDetails.add(headers);
        
        List<string> tempList = new List<string>(); 
        for (PO_Lead_Time__c s : Database.query(this.soqlQuery)) {
            date tempDate;
            if (this.scmcdb.PO_Raise_Date__c != null && this.scmcdb.Goods_Received_Date__c == null) {              
                tempDate = this.scmcdb.PO_Raise_Date__c;
            } else if (this.scmcdb.PO_Raise_Date__c == null && this.scmcdb.Goods_Received_Date__c != null) {            
                tempDate = this.scmcdb.Goods_Received_Date__c;
            } else {
                tempDate = date.today();
            }
            
            // Total Lead Time
            decimal dpml = 0;
            if (tempDate >= this.qtr1Start && tempDate <= this.qtr2Start.addDays(-1)) {
                if (this.dpmlSelected == 'Standard') {
                    if (s.Standard_DPML_day_CurrQtr__c != null && s.Standard_DPML_day_CurrQtr__c.trim() != '') {
                        dpml = decimal.valueOf(s.Standard_DPML_day_CurrQtr__c);
                    } 
                } else if (this.dpmlSelected == 'BulletLE12') {
                    if (s.Bullet_DPML_12w_day_CurrQtr1__c != null && s.Bullet_DPML_12w_day_CurrQtr1__c.trim() != '') {
                        dpml = decimal.valueOf(s.Bullet_DPML_12w_day_CurrQtr__c);
                    }
                } else if (this.dpmlSelected == 'BulletG12') {
                    if (s.Bullet_DPML_12w_day_CurrQtr1__c != null && s.Bullet_DPML_12w_day_CurrQtr1__c.trim() != '') {
                        dpml = decimal.valueOf(s.Bullet_DPML_12w_day_CurrQtr1__c);
                    }
                } else if (this.dpmlSelected == 'HotLE12') {
                    if (s.Hot_DPML_12w_day_CurrQtr1__c != null && s.Hot_DPML_12w_day_CurrQtr1__c.trim() != '') {
                        dpml = decimal.valueOf(s.Hot_DPML_12w_day_CurrQtr__c);
                    }
                } else if (this.dpmlSelected == 'HotG12') {
                    if (s.Hot_DPML_12w_day_CurrQtr1__c != null && s.Hot_DPML_12w_day_CurrQtr1__c.trim() != '') {
                        dpml = decimal.valueOf(s.Hot_DPML_12w_day_CurrQtr1__c);
                    }
                }
            } else if (tempDate >= this.qtr2Start && tempDate <= this.qtr3Start.addDays(-1)) {
                if (this.dpmlSelected == 'Standard') {
                    if (s.Standard_DPML_day_CurrQtr_1__c != null && s.Standard_DPML_day_CurrQtr_1__c.trim() != '') {
                        dpml = decimal.valueOf(s.Standard_DPML_day_CurrQtr_1__c);
                    } 
                } else if (this.dpmlSelected == 'BulletLE12') {
                    if (s.Bullet_DPML_12w_day_CurrQtr_1_1__c != null && s.Bullet_DPML_12w_day_CurrQtr_1_1__c.trim() != '') {
                        dpml = decimal.valueOf(s.Bullet_DPML_12w_day_CurrQtr_1__c);
                    }
                } else if (this.dpmlSelected == 'BulletG12') {
                    if (s.Bullet_DPML_12w_day_CurrQtr_1_1__c != null && s.Bullet_DPML_12w_day_CurrQtr_1_1__c.trim() != '') {
                        dpml = decimal.valueOf(s.Bullet_DPML_12w_day_CurrQtr_1_1__c);
                    }
                } else if (this.dpmlSelected == 'HotLE12') {
                    if (s.Hot_DPML_12w_day_CurrQtr_1_1__c != null && s.Hot_DPML_12w_day_CurrQtr_1_1__c.trim() != '') {
                        dpml = decimal.valueOf(s.Hot_DPML_12w_day_CurrQtr_1__c);
                    }
                } else if (this.dpmlSelected == 'HotG12') {
                    if (s.Hot_DPML_12w_day_CurrQtr_1_1__c != null && s.Hot_DPML_12w_day_CurrQtr_1_1__c.trim() != '') {
                        dpml = decimal.valueOf(s.Hot_DPML_12w_day_CurrQtr_1_1__c);
                    }
                }
            } else if (tempDate >= this.qtr3Start && tempDate <= this.qtr4Start.addDays(-1)) {
                if (this.dpmlSelected == 'Standard') {
                    if (s.Standard_DPML_day_CurrQtr_2__c != null && s.Standard_DPML_day_CurrQtr_2__c.trim() != '') {
                        dpml = decimal.valueOf(s.Standard_DPML_day_CurrQtr_2__c);
                    } 
                } else if (this.dpmlSelected == 'BulletLE12') {
                    if (s.Bullet_DPML_12w_day_CurrQtr_2_1__c != null && s.Bullet_DPML_12w_day_CurrQtr_2_1__c.trim() != '') {
                        dpml = decimal.valueOf(s.Bullet_DPML_12w_day_CurrQtr_2__c);
                    }
                } else if (this.dpmlSelected == 'BulletG12') {
                    if (s.Bullet_DPML_12w_day_CurrQtr_2_1__c != null && s.Bullet_DPML_12w_day_CurrQtr_2_1__c.trim() != '') {
                        dpml = decimal.valueOf(s.Bullet_DPML_12w_day_CurrQtr_2_1__c);
                    }
                } else if (this.dpmlSelected == 'HotLE12') {
                    if (s.Hot_DPML_12w_day_CurrQtr_2_1__c != null && s.Hot_DPML_12w_day_CurrQtr_2_1__c.trim() != '') {
                        dpml = decimal.valueOf(s.Hot_DPML_12w_day_CurrQtr_2__c);
                    }
                } else if (this.dpmlSelected == 'HotG12') {
                    if (s.Hot_DPML_12w_day_CurrQtr_2_1__c != null && s.Hot_DPML_12w_day_CurrQtr_2_1__c.trim() != '') {
                        dpml = decimal.valueOf(s.Hot_DPML_12w_day_CurrQtr_2_1__c);
                    }
                }
            } else if (tempDate >= this.qtr4Start && tempDate <= this.qtr4Start.addMonths(3).addDays(-1)) {
                if (this.dpmlSelected == 'Standard') {
                    if (s.Standard_DPML_day_CurrQtr_3__c != null && s.Standard_DPML_day_CurrQtr_3__c.trim() != '') {
                        dpml = decimal.valueOf(s.Standard_DPML_day_CurrQtr_3__c);
                    }
                } else if (this.dpmlSelected == 'BulletLE12') {
                    if (s.Bullet_DPML_12w_day_CurrQtr_3_1__c != null && s.Bullet_DPML_12w_day_CurrQtr_3_1__c.trim() != '') {
                        dpml = decimal.valueOf(s.Bullet_DPML_12w_day_CurrQtr_3__c);
                    }
                } else if (this.dpmlSelected == 'BulletG12') {
                    if (s.Bullet_DPML_12w_day_CurrQtr_3_1__c != null && s.Bullet_DPML_12w_day_CurrQtr_3_1__c.trim() != '') {
                        dpml = decimal.valueOf(s.Bullet_DPML_12w_day_CurrQtr_3_1__c);
                    }
                } else if (this.dpmlSelected == 'HotLE12') {
                    if (s.Hot_DPML_12w_day_CurrQtr_3_1__c != null && s.Hot_DPML_12w_day_CurrQtr_3_1__c.trim() != '') {
                        dpml = decimal.valueOf(s.Hot_DPML_12w_day_CurrQtr_3__c);
                    }
                } else if (this.dpmlSelected == 'HotG12') {
                    if (s.Hot_DPML_12w_day_CurrQtr_3_1__c != null && s.Hot_DPML_12w_day_CurrQtr_3_1__c.trim() != '') {
                        dpml = decimal.valueOf(s.Hot_DPML_12w_day_CurrQtr_3_1__c);
                    }
                }
            }
                
            integer noOfMaskLayers = 0;
            if (s.ML_Count_FEOL_BEOL__c != null && s.ML_Count_FEOL_BEOL__c.trim() != '') {
                noOfMaskLayers = integer.valueOf(s.ML_Count_FEOL_BEOL__c);
            }
              /** Case#00057902-----Jabee---**/           
            decimal pfAdder = 0;
            if (s.PF_Adder_day__c != null && s.PF_Adder_day__c.trim() != '') {
                pfAdder = decimal.valueOf(s.PF_Adder_day__c);
            }
             /**--END--Case#00057902-**/
            integer fabQueueTime = 0;
            if (s.PO_Lead_Time_day__c != null && s.PO_Lead_Time_day__c.trim() != '') {
                fabQueueTime = integer.valueOf(s.PO_Lead_Time_day__c);
            }
            
            // Add to list
            s.Total_Lead_Time__c = (fabQueueTime + pfAdder + (dpml * noOfMaskLayers)).round(System.RoundingMode.UP);
            if (this.scmcdb.PO_Raise_Date__c != null && this.scmcdb.Goods_Received_Date__c == null) {
                s.PO_Raise_Date__c = this.scmcdb.PO_Raise_Date__c;
                s.Goods_Received_Date__c = this.scmcdb.PO_Raise_Date__c.addDays(integer.valueOf(s.Total_Lead_Time__c));
            } else if (this.scmcdb.PO_Raise_Date__c == null && this.scmcdb.Goods_Received_Date__c != null) {
                s.PO_Raise_Date__c = this.scmcdb.Goods_Received_Date__c.addDays(integer.valueOf(s.Total_Lead_Time__c) * -1);
                s.Goods_Received_Date__c = this.scmcdb.Goods_Received_Date__c;
            } else {
                s.PO_Raise_Date__c = date.today();
                s.Goods_Received_Date__c = date.today().addDays(integer.valueOf(s.Total_Lead_Time__c));
            }
            
            //DBiswal 11272014 - Added Details for extra columns
            string detail = '';
            if(!this.isPortalUser){
                detail = (s.Account__r.Name != null ? s.Account__r.Name.replace(',', '') : '') + ',' + (s.Device_Account_Short_Name__c != null ? s.Device_Account_Short_Name__c : '') + ',' + s.Base_Device__c + ',' + s.Device_Stage__c + ',' + s.Fab__c + ',' + s.Process_Flow_Pid_PT_Id__c + ',' + (s.Geometry__c != null ? s.Geometry__c : '') + ',' + string.valueOf(dpml) + ',' + (s.ML_Count_FEOL_BEOL__c != null ? s.ML_Count_FEOL_BEOL__c : '') + ',' + (s.PO_Lead_Time_day__c != null ? s.PO_Lead_Time_day__c : '') + ',' + (s.PF_Adder_day__c != null ? s.PF_Adder_day__c : '') + ',' + s.Total_Lead_Time__c + ',' + s.PO_Raise_Date__c.format() + ',' + s.Goods_Received_Date__c.format() + '\n';
            }else{                
                detail = (s.Account__r.Name != null ? s.Account__r.Name.replace(',', '') : '') + ',' + (s.Device_Account_Short_Name__c != null ? s.Device_Account_Short_Name__c : '') + ',' + s.Base_Device__c + ',' + s.Device_Stage__c + ',' + s.Fab__c + ',' + s.Process_Flow_Pid_PT_Id__c + ',' + (s.Geometry__c != null ? s.Geometry__c : '') + ',' + (s.Standard_DPML_day_CurrQtr__c != null ? s.Standard_DPML_day_CurrQtr__c : '') + ',' + (s.Standard_DPML_day_CurrQtr_1__c != null ? s.Standard_DPML_day_CurrQtr_1__c : '') + ',' + (s.Standard_DPML_day_CurrQtr_2__c != null ? s.Standard_DPML_day_CurrQtr_2__c : '') + ',' + (s.Standard_DPML_day_CurrQtr_3__c != null ? s.Standard_DPML_day_CurrQtr_3__c : '') + ',' + (s.Bullet_DPML_12w_day_CurrQtr__c != null ? s.Bullet_DPML_12w_day_CurrQtr__c : '') + ',' + (s.Bullet_DPML_12w_day_CurrQtr_1__c != null ? s.Bullet_DPML_12w_day_CurrQtr_1__c : '') + ',' + (s.Bullet_DPML_12w_day_CurrQtr_2__c != null ? s.Bullet_DPML_12w_day_CurrQtr_2__c : '') + ',' + (s.Bullet_DPML_12w_day_CurrQtr_3__c != null ? s.Bullet_DPML_12w_day_CurrQtr_3__c : '') + ',' + (s.Bullet_DPML_12w_day_CurrQtr1__c != null ? s.Bullet_DPML_12w_day_CurrQtr1__c : '') + ',' + (s.Bullet_DPML_12w_day_CurrQtr_1_1__c != null ? s.Bullet_DPML_12w_day_CurrQtr_1_1__c : '') + ',' + (s.Bullet_DPML_12w_day_CurrQtr_2_1__c != null ? s.Bullet_DPML_12w_day_CurrQtr_2_1__c : '') + ',' + (s.Bullet_DPML_12w_day_CurrQtr_3_1__c != null ? s.Bullet_DPML_12w_day_CurrQtr_3_1__c : '') + ',' + (s.Hot_DPML_12w_day_CurrQtr__c != null ? s.Hot_DPML_12w_day_CurrQtr__c : '') + ',' + (s.Hot_DPML_12w_day_CurrQtr_1__c != null ? s.Hot_DPML_12w_day_CurrQtr_1__c : '') + ',' + (s.Hot_DPML_12w_day_CurrQtr_2__c != null ? s.Hot_DPML_12w_day_CurrQtr_2__c : '') + ',' + (s.Hot_DPML_12w_day_CurrQtr_3__c != null ? s.Hot_DPML_12w_day_CurrQtr_3__c : '') + ',' + (s.Hot_DPML_12w_day_CurrQtr1__c != null ? s.Hot_DPML_12w_day_CurrQtr1__c : '') + ',' + (s.Hot_DPML_12w_day_CurrQtr_1_1__c != null ? s.Hot_DPML_12w_day_CurrQtr_1_1__c : '') + ',' + (s.Hot_DPML_12w_day_CurrQtr_2_1__c != null ? s.Hot_DPML_12w_day_CurrQtr_2_1__c : '') + ',' + (s.Hot_DPML_12w_day_CurrQtr_3_1__c != null ? s.Hot_DPML_12w_day_CurrQtr_3_1__c : '') + '\n';
            }
            
            
            if (tempList.size() < 1000) {
                tempList.add(detail);
            } else {
                this.listDetails.add(tempList); 
                tempList = new List<string>();
            }
        }
        
        if (tempList.size() > 0) {
            this.listDetails.add(tempList);
        }
    }
    
   //DBiswal 01132015 to clear the field values
   public void clear() {
        if(!this.isPortalUser){
            this.account = '';
        }else{
            this.account = this.defaccount;
        }
        this.scmcdb = new PO_Lead_Time__c();
        this.showResults = false;
        this.listDetails = new List<List<string>>();
        this.listPoLeadTime = new List<PoLeadTimeWrapper>();
        this.dpmlSelected = 'Standard';
    }
    
    public List<SelectOption> getDPMLOptions() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Standard', 'Standard'));
        options.add(new SelectOption('BulletLE12', 'Bullet (<=12w)'));
        options.add(new SelectOption('BulletG12', 'Bullet (>12w)'));
        options.add(new SelectOption('HotLE12', 'Hot (<=12w)'));
        options.add(new SelectOption('HotG12', 'Hot (>12w)'));
        
        return options;
    }
    
    public void computeQuarterRanges() {
        // Get current quarter
        if (date.today().month() >= 1 && date.today().month() <= 3) {
            this.qtr1Start = date.newInstance(date.today().year(), 1, 1);
        } else if (date.today().month() >= 4 && date.today().month() <= 6) {
            this.qtr1Start = date.newInstance(date.today().year(), 4, 1);
        } else if (date.today().month() >= 7 && date.today().month() <= 9) {
            this.qtr1Start = date.newInstance(date.today().year(), 7, 1);
        } else if (date.today().month() >= 10 && date.today().month() <= 12) {
            this.qtr1Start = date.newInstance(date.today().year(), 10, 1);
        }
        
        // Get other quarters
        this.qtr2Start = this.qtr1Start.addMonths(3);
        this.qtr3Start = this.qtr2Start.addMonths(3);
        this.qtr4Start = this.qtr3Start.addMonths(3);
    }
    
    public void checkUser() {
        User u = [
            SELECT      Id
                        , AccountId
            FROM        User
            WHERE       Id = :UserInfo.getUserId()
        ];
        
        if (u.AccountId != null) {
            this.isPortalUser = true;
            retrieveAccountHierarchy(u.AccountId);
        } else {
            this.isPortalUser = false;
        }
    }
    
    public void retrieveAccountHierarchy(Id accountId) {
        // Get Account Id
        Account a = [
            SELECT      Id
                        , ParentId
                        , Name
                        , Short_Name__c
            FROM        Account
            WHERE Id = :accountId
        ];
        
        // Get Accounts in the Account Hierarchy
        List<string> listAccount = new List<string>();  
        //this.accountIds = new Set<Id>();
        if (a.ParentId != null) {
            for (Account_Hierarchy__c ah : [SELECT      Parent_Id__c
                                                        , Parent_Id__r.Name
                                                        , Parent_Account_Short_Name__c
                                            FROM        Account_Hierarchy__c
                                            WHERE       Account_Id__c = :a.Id
                                                        AND Parent_Id__c != :a.Id]) { 
                this.accountIds.add(ah.Parent_Id__c);
                this.mapAccountShortName.put(ah.Parent_Id__r.Name, (ah.Parent_Account_Short_Name__c != null ? ah.Parent_Account_Short_Name__c : ''));
                listAccount.add(ah.Parent_Id__r.Name);
            }
        } 
           
        // Check for Devices below the Account Hierarchy
        for (Account_Hierarchy__c ah : [SELECT      Account_Id__c
                                                    , Account_Id__r.Name
                                                    , Account_Short_Name__c
                                        FROM        Account_Hierarchy__c
                                        WHERE       Parent_Id__c = :a.Id
                                                    AND Account_Id__c != :a.Id]) { 
            this.accountIds.add(ah.Account_Id__c);
            this.mapAccountShortName.put(ah.Account_Id__r.Name, (ah.Account_Short_Name__c != null ? ah.Account_Short_Name__c : ''));
            listAccount.add(ah.Account_Id__r.Name);
        }
        
        // Add User's Account Id
        this.accountIds.add(a.Id);
        this.mapAccountShortName.put(a.Name, (a.Short_Name__c != null ? a.Short_Name__c : ''));
        listAccount.add(a.Name);
        // Sort
        listAccount.sort();
        for (string s : listAccount) {
            this.accountOptions.add(new SelectOption(s, s));
        }
        
        // Set default value
        this.account = a.Name;
        this.defaccount = a.Name;        
    }
       
    public boolean getHasPrevious() {        
        return this.stdSetController.getHasPrevious();
    }
    
    public boolean getHasNext() {
        return this.stdSetController.getHasNext();
    }
    
    public void previous() {
        this.pageNumber--;
        this.stdSetController.previous();
    }
    
    public void next() {
        this.pageNumber++;
        this.stdSetController.next();
    }
    
    public void first() {
        this.pageNumber = 1;
        this.stdSetController.first();
    }
    
    public void last() {
        this.pageNumber = getTotalPages();
        this.stdSetController.last();
    }
    
    public integer getPageNo() {
        return this.stdSetController.getPageNumber();
    }
    
    public integer getTotalPages() {
        return (integer) Math.ceil(Double.valueOf(this.stdSetController.getResultSize()) / this.stdSetController.getPageSize());
    }
    
    public string getTotalRecords() {
        List<String> args = new String[]{'0', 'number', '###,###,##0'};
        return string.format(this.stdSetController.getResultSize().format(), args);
    }
    
    public class PoLeadTimeWrapper {
        public string account {get;set;}
        public string accountShortName {get;set;}
        public string device {get;set;}
        public string geometry {get;set;}
        public string fab {get;set;}
        public string poLeadTime {get;set;}
        public string pfAdder {get;set;}
        public string mlCount {get;set;}
        public string dpml {get;set;}
        public decimal totalLeadTime {get;set;}
        public date poRaiseDate {get;set;}
        public string processId {get;set;}
        public date goodsReceivedDate {get;set;}
        //11272014 DBiswal - Added variables of new fields
        public string standardCurrQtr {get;set;}
        public string standardCurrQtr1 {get;set;}
        public string standardCurrQtr2 {get;set;}
        public string standardCurrQtr3 {get;set;}
        public string bulletLE12CurrQtr {get;set;}
        public string bulletLE12CurrQtr1 {get;set;}
        public string bulletLE12CurrQtr2 {get;set;}
        public string bulletLE12CurrQtr3 {get;set;}
        public string bulletG12CurrQtr {get;set;}
        public string bulletG12CurrQtr1 {get;set;}
        public string bulletG12CurrQtr2 {get;set;}
        public string bulletG12CurrQtr3 {get;set;}
        public string hotLE12CurrQtr {get;set;}
        public string hotLE12CurrQtr1 {get;set;}
        public string hotLE12CurrQtr2 {get;set;}
        public string hotLE12CurrQtr3 {get;set;}
        public string hotG12CurrQtr {get;set;}
        public string hotG12CurrQtr1 {get;set;}
        public string hotG12CurrQtr2 {get;set;}
        public string hotG12CurrQtr3 {get;set;}  
        public PoLeadTimeWrapper(){}
    }
}