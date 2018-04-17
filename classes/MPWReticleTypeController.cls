/*
    Author:Venkat 
    Description: This serves as the controller for MPW Reticle Type 
    History: 
        
*/

public class MPWReticleTypeController{
    public string strTechID {get;set;}
    
    public List<MPWReticleType> listMPWConfigSettings {get;set;}
    
    public List<SelectOption> TechIDOptions {get;set;}
    public String sortType {get; set;}
    public String sortField {get; set;}
    public List<MPWReticleType> listMPW {get;set;}
    public integer currentPageNo {get;set;}
    public integer totalNoOfPages {get;set;}
    public integer rowsPerPage {get;set;}
    public integer totalNoOfRecords {get;set;}
    public integer fromNo {get;set;}
    public integer toNo {get;set;}
    public String currentURL {get;set;}
    private Map<Integer,List<MPWReticleType>> pages;
    private Integer listSize;
    
    public MPWReticleTypeController() {
    
        this.listMPW = new List<MPWReticleType>();
        this.pages = new Map<Integer,List<MPWReticleType>>();
        
        // Retrieve current URL
        currentURL = ApexPages.currentPage().getURL();
        
        initPagination();
        
        // Retrieve Tech Node Values
        getTechNodeValues();
        strTechID= 'All';
        
        // Retrieve Data
        optionRecords();
    }
    
    public PageReference addNew() {
    
        PageReference p = Page.MPWReticleTypeTranxVF;
        p.getParameters().put('tranx', 'Add');
        p.getParameters().put('returnURL', currentURL );
        p.setRedirect(true);
        return p;
    }
    
    public PageReference optionRecords() {
        List<MPWReticleType> listMPWConfigGeo = new List<MPWReticleType>();
        string soql = strTechID== 'All' ? 
                        'SELECT Id, Name, Reticle_Type__c,LastModifiedBy.Name, CreatedBy.Name ' + 
                        'FROM MPW_Reticle_Type__c' +' ORDER BY Name ASC' 
                       : 'SELECT Id, Name, Reticle_Type__c,LastModifiedBy.Name, CreatedBy.Name  ' + 
                         'FROM MPW_Reticle_Type__c' +
                         ' WHERE name= \'' + strTechID+ '\'' +
                         ' ORDER BY Name ASC';
        // System.debug('********FFFFF**********'+soql);                
       
        for(MPW_Reticle_Type__c obj:Database.query(soql)){
        	listMPWConfigGeo.add(new MPWReticleType(obj));
        }
        this.listMPW = listMPWConfigGeo;          
        this.paginate();
        this.currentPageNo = 1;       
        this.totalNoOfRecords = this.listMPW.size();
        this.listMPWConfigSettings = this.pages.get(1);
        
        return null;
    }
    
    public PageReference sort(){
      /*  Map<String,List<MPWReticleType>> sortMap = new Map<String,List<MPWReticleType>>();
        
        for(MPWReticleType mp :this.listMPW){
            String key;            
            key = String.valueOf(mp.get(this.sortField)); 
            if(sortMap.containsKey(key)){
                sortMap.get(key).add(mp);
            } else {
                sortMap.put(key, new List<MPW_Reticle_Type__c>{mp});
            }
        }
        
        List<String> sortKey = new List<String>();
        sortKey.addAll(sortMap.keyset());
        sortKey.sort();
        
        this.listMPW = new List<MPW_Reticle_Type__c>();
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
        */   
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
    
    private List<SelectOption> getTechNodeValues() {
        //strTechID = new MPW_Reticle_Type__c();
        TechIDOptions = new List<SelectOption>();
        
        TechIDOptions.add(new SelectOption('All','All'));
        for(MPW_Geometry_Mapping__c m: [select Id, Name, Sequence_No__c from MPW_Geometry_Mapping__c where Active__c = true and Use_Process_Type__c = true order by Sequence_No__c asc]){
            TechIDOptions.add(new SelectOption(m.Name,m.Name));
        } 
        return TechIDOptions;
    }
    
    private void paginate(){
        this.pages = new Map<Integer,List<MPWReticleType>>(); 
        Integer counter = 0;
        Integer pageKey = 1;
        
        for(MPWReticleType mp: this.listMPW){
            if(counter < this.rowsPerPage ){
                if(this.pages.containsKey(pageKey)){
                    this.pages.get(pageKey).add(mp);
                } else {
                    this.pages.put(pageKey, new List<MPWReticleType>{mp});
                }
                counter ++;
            } else {               
                counter = 1;
                pageKey++;
                this.pages.put(pageKey, new List<MPWReticleType>{mp});
            }
        } 
        if(this.pages.keyset().size() == 0){
            this.totalNoOfPages = 1;
        } else {
            this.totalNoOfPages = this.pages.keyset().size();  
        }   
    }
    
    public class MPWReticleType{
    	public string strId{get;set;}
    	public string strTechIDName{get;set;}
    	public string Reticle_Type{get;set;}
    	public string CreatedByName{get;set;}
    	public string LastmodifyByName{get;set;}
    	
    	public MPWReticleType(MPW_Reticle_Type__c obj){
    		strId=obj.Id;
    		strTechIDName=obj.Name;
    		Reticle_Type=obj.Reticle_Type__c;
    		CreatedByName=obj.CreatedBy.Name;
    		LastmodifyByName=obj.LastModifiedBy.Name;
    	}
    	
    }
}