/*
    Author: Zymark Ambat
    Description: This serves as the Tab Navigation Controller for MPW Process and MPW Process DM.
    History: 
        ZAmbat      05062015    - Code creation.
*/

public class MPWConfigSettingsTabController {
    public string selectedTab {get;set;}
    public List<MPW_Config_Settings__c> listMPWConfigSettings {get;set;}
    public MPW_Config_Settings__c geometry{get;set;}
    public List<SelectOption> geometryOptions {get;set;}
    public String sortType {get; set;}
    public String sortField {get; set;}
    public List<MPW_Config_Settings__c> listMPW {get;set;}
    public integer currentPageNo {get;set;}
    public integer totalNoOfPages {get;set;}
    public integer rowsPerPage {get;set;}
    public integer totalNoOfRecords {get;set;}
    public integer fromNo {get;set;}
    public integer toNo {get;set;}
    public String currentURL {get;set;}
    private Map<Integer,List<MPW_Config_Settings__c>> pages;
    private Integer listSize;
    
    public MPWConfigSettingsTabController() {
    
        this.listMPW = new List<MPW_Config_Settings__c>();
        this.pages = new Map<Integer,List<MPW_Config_Settings__c>>();
        
        // Retrieve current URL
        currentURL = ApexPages.currentPage().getURL();
        
        initPagination();

        // Check if the selected tab is MPW Process or MPW Process DM
        if(ApexPages.currentPage().getParameters().get('sfdc.tabName') == null){
            this.selectedTab = 'MPWProcess';
        }
        else{
            this.selectedTab = retrieveSelectedTabName(ApexPages.currentPage().getParameters().get('sfdc.tabName'));
        }
        // Retrieve Geometry Values
        getGeometryValues();
        geometry.Geometry__c = 'All Active';
        
        // Retrieve Data
        optionRecords();
    }
    
    public PageReference addNew() {
        PageReference p = Page.MPWConfigSettingsTranxVF;
        p.getParameters().put('tranx', 'Add');
        p.getParameters().put('from', this.selectedTab);
        p.getParameters().put('returnURL', currentURL );
        p.setRedirect(true);
        
        return p;
    }
    
    public PageReference viewRecord() {
        PageReference p = Page.MPWConfigSettingsTranxVF;
        p.getParameters().put('returnURL', currentURL );
        p.getParameters().put('id', ApexPages.currentPage().getParameters().get('id'));
        p.getParameters().put('from', this.selectedTab);
        p.setRedirect(true);
        
        return p;
    }
    
    public PageReference optionRecords() {
        List<MPW_Config_Settings__c> listMPWConfigGeo = new List<MPW_Config_Settings__c>();
        string soql = 'SELECT Id, Name, Geometry__c, Active__c ' + 
                       (this.selectedTab == 'MPWProcessDM' ? ', Rule__c ' : '') +
                      'FROM MPW_Config_Settings__c ' +
                      'WHERE ' +
                       (this.selectedTab == 'MPWProcessDM' ? 'RecordType.DeveloperName = \'Process_DM\' ' : 'RecordType.DeveloperName = \'Process\'') +
                       (this.selectedTab == 'MPWProcessDM' ? 'AND Rule__c != null ' : '') +
                       (geometry.Geometry__c == 'All Active' ? 'AND Active__c = true ' : (geometry.Geometry__c == 'All Inactive' ? 'AND Active__c = false ' : 'AND Geometry__c = \'' + geometry.Geometry__c + '\' AND Active__c = true ')) +
                      'ORDER BY Name ASC' ;
            
        listMPWConfigGeo = Database.query(soql);   
        this.listMPW = listMPWConfigGeo;          
        this.paginate();
        this.currentPageNo = 1;       
        this.totalNoOfRecords = this.listMPW.size();
        this.listMPWConfigSettings = this.pages.get(1);
        
        return null;
    }
    
    public PageReference sort(){
        Map<String,List<MPW_Config_Settings__c>> sortMap = new Map<String,List<MPW_Config_Settings__c>>();
        
        for(MPW_Config_Settings__c mp :this.listMPW){
            String key;            
            key = String.valueOf(mp.get(this.sortField)); 
            if(sortMap.containsKey(key)){
                sortMap.get(key).add(mp);
            } else {
                sortMap.put(key, new List<MPW_Config_Settings__c>{mp});
            }
        }
        
        List<String> sortKey = new List<String>();
        sortKey.addAll(sortMap.keyset());
        sortKey.sort();
        
        this.listMPW = new List<MPW_Config_Settings__c>();
        if(this.sortType == 'asc'){
            for(String s: sortKey){
                this.listMPW.addAll(sortMap.get(s));    
            }
        } else if(this.sortType == 'desc'){
            for(Integer counter = (sortKey.size()-1); counter >= 0; counter--){
                this.listMPW.addAll(sortMap.get(sortKey[counter]));    
            }
        }
       
        this.paginate();
        this.currentPageNo = 1;
        this.listMPWConfigSettings = this.pages.get(1);
        
        return null;        
    }
    
    private void initPagination() {
        this.rowsPerPage = 10; 
        this.fromNo = 1;
        this.toNo = this.rowsPerPage;   
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
        this.listMPWConfigSettings = this.pages.get(this.currentPageNo);
    }
    
    public void next() {
        this.currentPageNo++;    
        this.fromNo = this.fromNo + this.rowsPerPage;
        if ((this.toNo + this.rowsPerPage) <= this.totalNoOfRecords) {
           this.toNo = this.toNo + this.rowsPerPage;
        } else {
           this.toNo = this.totalNoOfRecords;
        }   
        this.listMPWConfigSettings = this.pages.get(this.currentPageNo);
    }
    
    public void first() {
        this.currentPageNo = 1; 
        this.fromNo = 1;
        this.toNo = this.rowsPerPage;    
        this.listMPWConfigSettings = this.pages.get(1);
    }
    
    public void last() {
        this.currentPageNo = this.totalNoOfPages; 
        this.fromNo = (this.rowsPerPage*(this.totalNoOfPages-1))+1;
        this.toNo = this.totalNoOfRecords; 
        this.listMPWConfigSettings = this.pages.get(this.currentPageNo);
    }
    
    private string retrieveSelectedTabName(string tabId) {
        string tabName;
        for (Schema.DescribeTabSetResult dtsr : Schema.describeTabs()) {
            if (dtsr.isSelected()) {
                for (Schema.DescribeTabResult dtr : dtsr.tabs) {
                    if (dtr.url.contains(tabId)) {
                        tabName = dtr.label;
                        break;
                    }
                }
                break;
            }
        }
        
        return tabName.replace(' ', '');
    }
    
    private List<SelectOption> getGeometryValues() {
        geometry = new MPW_Config_Settings__c();
        geometryOptions = new List<SelectOption>();
        
        Schema.DescribeFieldResult geometryResult = MPW_Config_Settings__c.Geometry__c.getDescribe();
        List<Schema.PicklistEntry> picklistValue = geometryResult.getPicklistValues();
        
        geometryOptions.add(new SelectOption('All Active','All Active'));
        geometryOptions.add(new SelectOption('All Inactive','All Inactive'));
        for( Schema.PicklistEntry f : picklistValue )
        {              
              geometryOptions.add(new SelectOption(f.getLabel(), f.getValue()));
        }       
        return geometryOptions;
    }
    
    private void paginate(){
        this.pages = new Map<Integer,List<MPW_Config_Settings__c>>(); 
        Integer counter = 0;
        Integer pageKey = 1;
        
        for(MPW_Config_Settings__c mp: this.listMPW){
            if(counter < this.rowsPerPage ){
                if(this.pages.containsKey(pageKey)){
                    this.pages.get(pageKey).add(mp);
                } else {
                    this.pages.put(pageKey, new List<MPW_Config_Settings__c>{mp});
                }
                counter ++;
            } else {               
                counter = 1;
                pageKey++;
                this.pages.put(pageKey, new List<MPW_Config_Settings__c>{mp});
            }
        } 
        if(this.pages.keyset().size() == 0){
            this.totalNoOfPages = 1;
        } else {
            this.totalNoOfPages = this.pages.keyset().size();  
        }   
    }
}