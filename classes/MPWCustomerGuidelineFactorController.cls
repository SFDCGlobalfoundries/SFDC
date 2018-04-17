/*
    Author: 
    Description: This serves as the controller for Internal Guideline Factor
    History: 
        07062015    - Code creation.
*/

public class MPWCustomerGuidelineFactorController {
    public Customer_Guideline_Factor__c TechNodes {get;set;}
    
    public List<Customer_Guideline_Factor__c> listMPWConfigSettings {get;set;}
    
    public List<SelectOption> TechIDOptions {get;set;}
    public String sortType {get; set;}
    public String sortField {get; set;}
    public List<Customer_Guideline_Factor__c> listMPW {get;set;}
    public integer currentPageNo {get;set;}
    public integer totalNoOfPages {get;set;}
    public integer rowsPerPage {get;set;}
    public integer totalNoOfRecords {get;set;}
    public integer fromNo {get;set;}
    public integer toNo {get;set;}
    public String currentURL {get;set;}
    private Map<Integer,List<Customer_Guideline_Factor__c>> pages;
    private Integer listSize;
    
    public MPWCustomerGuidelineFactorController() {
    
        this.listMPW = new List<Customer_Guideline_Factor__c>();
        this.pages = new Map<Integer,List<Customer_Guideline_Factor__c>>();
        
        // Retrieve current URL
        currentURL = ApexPages.currentPage().getURL();
        
        initPagination();
        
        // Retrieve Tech ID Values
        getTechIDValues();
        TechNodes.TechNodes__c = 'All';
        
        // Retrieve Data
        optionRecords();
    }
    
    public PageReference addNew() {
        
        PageReference p = Page.MPWCustomerGuidelineFactTranxVF;
        p.getParameters().put('tranx', 'Add');
        p.getParameters().put('returnURL', currentURL );
        p.setRedirect(true);
        return p;
    }
    
    public PageReference viewRecord() {
        PageReference p = Page.MPWCustomerGuidelineFactTranxVF;
        p.getParameters().put('returnURL', currentURL );
        p.getParameters().put('id', ApexPages.currentPage().getParameters().get('id'));
        p.setRedirect(true);
        
        return p;
    }
    
    public PageReference optionRecords() {
        List<Customer_Guideline_Factor__c> listMPWConfigGeo = new List<Customer_Guideline_Factor__c>();
        string soql = TechNodes.TechNodes__c == 'All' ? 
                        'SELECT Id, Name, TechNodes__c,Adder3__c,Expedite__c, ExtraDice_B__c, Option2__c, RecticalSpace_A1__c, ReticleSpace_Min__c, ShortLoop_Wafer__c, Sub_Devices_Extraction__c, Wafer_Form_Delivery__c   ' + 
                        'FROM Customer_Guideline_Factor__c ' +'ORDER BY Name ASC' 
                       : 'SELECT Id, Name, TechNodes__c ,Adder3__c,Expedite__c, ExtraDice_B__c, Option2__c, RecticalSpace_A1__c, ReticleSpace_Min__c, ShortLoop_Wafer__c, Sub_Devices_Extraction__c, Wafer_Form_Delivery__c ' + 
                         'FROM Customer_Guideline_Factor__c ' +
                         ' WHERE TechNodes__c = \'' + TechNodes.TechNodes__c + '\'' +
                         ' ORDER BY Name ASC';
        listMPWConfigGeo = Database.query(soql);   
        this.listMPW = listMPWConfigGeo;          
        this.paginate();
        this.currentPageNo = 1;       
        this.totalNoOfRecords = this.listMPW.size();
        this.listMPWConfigSettings = this.pages.get(1);
        
        return null;
    }
    
    public PageReference sort(){
        Map<String,List<Customer_Guideline_Factor__c >> sortMap = new Map<String,List<Customer_Guideline_Factor__c >>();
        
        for(Customer_Guideline_Factor__c   mp :this.listMPW){
            String key;            
            key = String.valueOf(mp.get(this.sortField)); 
            if(sortMap.containsKey(key)){
                sortMap.get(key).add(mp);
            } else {
                sortMap.put(key, new List<Customer_Guideline_Factor__c >{mp});
            }
        }
        
        List<String> sortKey = new List<String>();
        sortKey.addAll(sortMap.keyset());
        sortKey.sort();
        
        this.listMPW = new List<Customer_Guideline_Factor__c >();
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
    
    private List<SelectOption> getTechIDValues() {
        TechNodes = new Customer_Guideline_Factor__c ();
        TechIDOptions = new List<SelectOption>();
        
        TechIDOptions.add(new SelectOption('All','All'));
        for(MPW_Geometry_Mapping__c m: [select Id, Name, Sequence_No__c from MPW_Geometry_Mapping__c where Active__c = true and Use_Process_Type__c = true order by Sequence_No__c asc]){
            TechIDOptions.add(new SelectOption(m.Name,m.Name));
        }   
        return TechIDOptions;
    }
    
    private void paginate(){
        this.pages = new Map<Integer,List<Customer_Guideline_Factor__c >>(); 
        Integer counter = 0;
        Integer pageKey = 1;
        
        for(Customer_Guideline_Factor__c  mp: this.listMPW){
            if(counter < this.rowsPerPage ){
                if(this.pages.containsKey(pageKey)){
                    this.pages.get(pageKey).add(mp);
                } else {
                    this.pages.put(pageKey, new List<Customer_Guideline_Factor__c >{mp});
                }
                counter ++;
            } else {               
                counter = 1;
                pageKey++;
                this.pages.put(pageKey, new List<Customer_Guideline_Factor__c >{mp});
            }
        } 
        if(this.pages.keyset().size() == 0){
            this.totalNoOfPages = 1;
        } else {
            this.totalNoOfPages = this.pages.keyset().size();  
        }   
    }
}