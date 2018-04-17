/*
    Author: Abhita Bansal
    Description: This serves as the Tab Navigation Extension for MPW Process Group.
    History: 
        ABansal     06112015    - page creation.
*/

public class MPWProcessGroupTabController {

    public Map<integer, List<MPW_Process_Group__c>> mapMPWProcessGroup {get;set;}
    public List<MPW_Process_Group__c> listMPWProcessGroup {get;set;}
    public MPW_Process_Group__c geometry{get;set;}
    public List<SelectOption> geometryOptions {get;set;}
    public integer totalNoOfPages {get;set;}
    public integer totalNoOfRecords {get;set;}
    public integer currentPageNo {get;set;}
    public String sortType {get; set;}
    public String sortField {get; set;}
    public String currentURL {get;set;}
     
    public MPWProcessGroupTabController (ApexPages.StandardController sc) {
    
        this.listMPWProcessGroup = new List<MPW_Process_Group__c>();
        
        // Retrieve current URL
        currentURL = ApexPages.currentPage().getURL();
        
        // Retrieve Geometry Values
        getGeometryValues();
        geometry.Geometry__c = 'All Active';
        
        this.totalNoOfPages = 0;
        this.totalNoOfRecords = 0;
        this.currentPageNo = 1;
        this.sortField = 'Name';
        this.sortType = 'ASC';
        
        // Retrieve Data
        optionRecords();
    }
    
    public PageReference addNew() {
        PageReference p = Page.MPWProcessGroupTranxVF;
        p.getParameters().put('tranx', 'Add');
        p.getParameters().put('returnURL', currentURL );
        p.setRedirect(true);
        
        return p;
    }
    
    public PageReference viewRecord() {
        PageReference p = Page.MPWProcessGroupTranxVF;
        p.getParameters().put('returnURL', currentURL );
        p.getParameters().put('id', ApexPages.currentPage().getParameters().get('id'));
        p.setRedirect(true);
        
        return p;
    }
    
    private List<SelectOption> getGeometryValues() {
        geometry = new MPW_Process_Group__c();
        geometryOptions = new List<SelectOption>();
        
        geometryOptions.add(new SelectOption('All Active','All Active'));
        geometryOptions.add(new SelectOption('All Inactive','All Inactive'));
        //options.add(new SelectOption('None','Select Geometry'));
        for(MPW_Geometry_Mapping__c m: [select Id, Name, Sequence_No__c from MPW_Geometry_Mapping__c where Active__c = true and Use_Process_Type__c = true order by Sequence_No__c asc]){
            geometryOptions.add(new SelectOption(m.Name,m.Name));
        }
            
        return geometryOptions;
    }  
    
    public void optionRecords() {
    
        this.mapMPWProcessGroup = new Map<integer, List<MPW_Process_Group__c>>();
        
        string soql = 'SELECT Id, Name, Geometry__c, Process__c, Fab__c ' +
                      'FROM MPW_Process_Group__c ' +
                      'WHERE ' +
                      (geometry.Geometry__c == 'All Active' ? 'Active__c = true ' : (geometry.Geometry__c == 'All Inactive' ? 'AND Active__c = false ' : 'Geometry__c = \'' + geometry.Geometry__c + '\' AND Active__c = true ')) +
                      'ORDER BY Name ASC' ;
        List<MPW_Process_Group__c> tempList = new List<MPW_Process_Group__c>();
        tempList = database.query(soql);         
        listMPWProcessGroup = tempList; 
        
        if (tempList.size() > 0) {           
            this.mapMPWProcessGroup = paginateRecords(tempList);
        } 
    }
    
    private Map<integer, List<MPW_Process_Group__c>> paginateRecords(List<MPW_Process_Group__c> tempList) {
        Map<integer, List<MPW_Process_Group__c>> tempMap = new Map<integer, List<MPW_Process_Group__c>>();
        integer recordsPerPage = 10; //Integer.valueOf(selectedVal);
        integer pageNo = 1;
        List<MPW_Process_Group__c> temp = new List<MPW_Process_Group__c>();
        for (MPW_Process_Group__c mpg : tempList) {
            if (temp.size() < recordsPerPage) {
                temp.add(mpg);
            } else {
                tempMap.put(pageNo, temp);
                pageNo++;
                temp = new List<MPW_Process_Group__c>();
                temp.add(mpg);
            }
        }
        
        if (temp.size() > 0) {
            tempMap.put(pageNo, temp);
        }
        
        // Set values
        this.totalNoOfPages = pageNo;
        if(currentPageNo > 1){
           this.currentPageNo = 1;        
        }
        this.totalNoOfRecords  = tempList.size();
       
        return tempMap;
    }
    
    public List<MPW_Process_Group__c> getMPWProcessGroupRecords() {
        return (this.mapMPWProcessGroup.size() > 0 ? this.mapMPWProcessGroup.get(this.currentPageNo) : new List<MPW_Process_Group__c>());
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
        Map<string, List<MPW_Process_Group__c>> tempMap = new Map<string, List<MPW_Process_Group__c>>();
        for(MPW_Process_Group__c g : this.listMPWProcessGroup){
            string key = string.valueOf(g.get(this.sortField)); 
            if(tempMap.containsKey(key)){
                tempMap.get(key).add(g);
            } else {
                tempMap.put(key, new List<MPW_Process_Group__c>{g});
            }
        }
        
        List<string> sortList = new List<String>();
        sortList.addAll(tempMap.keySet());
        sortList.sort();
        
        this.listMPWProcessGroup = new List<MPW_Process_Group__c>();
        if(this.sortType == 'ASC'){
            for(string s : sortList){
                this.listMPWProcessGroup.addAll(tempMap.get(s));    
            }
        } else if(this.sortType == 'DESC'){
            for(integer ctr = (sortList.size()-1); ctr >= 0; ctr--){
                this.listMPWProcessGroup.addAll(tempMap.get(sortList[ctr]));    
            }
        }
        
        if (this.listMPWProcessGroup.size() > 0) {
            this.mapMPWProcessGroup = paginateRecords(listMPWProcessGroup);
        }
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
}