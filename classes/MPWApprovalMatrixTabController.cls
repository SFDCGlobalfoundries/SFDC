/*
    Author: Abhita Bansal
    Description: This serves as the Tab Navigation Controller for MPW Approval Matrix.
    History: 
        ABansal     05232015    - Code creation.
        Poulami     04072016    - Added new field PA Code (MPW-PP87).
*/

public class MPWApprovalMatrixTabController {
    
    public Map<integer, List<MPW_Approval_Matrix__c>> mapMPWApprovalMatrix{get;set;}
    public List<MPW_Approval_Matrix__c> listMPWApprovalMatrix {get;set;}
    public integer totalNoOfPages {get;set;}
    public integer totalNoOfRecords {get;set;}
    public integer currentPageNo {get;set;}
    public String sortType {get; set;}
    public String sortField {get; set;}
    public String currentURL {get;set;}
    
    
    public MPWApprovalMatrixTabController () {
        this.listMPWApprovalMatrix = new List<MPW_Approval_Matrix__c>();
        
        // Retrieve current URL
        currentURL = ApexPages.currentPage().getURL();
        
        this.totalNoOfPages = 0;
        this.totalNoOfRecords = 0;
        this.currentPageNo = 1;
        this.sortField = 'Name';
        this.sortType = 'ASC';
        
        // Retrieve Data
        optionRecords();        
    }
    
    public PageReference addNew() {
        PageReference p = Page.MPWApprovalMatrixTranxVF;
        p.getParameters().put('tranx', 'Add');
        p.getParameters().put('returnURL', currentURL );
        p.setRedirect(true);
        
        return p;
    }
    
    public void optionRecords() {
    
        this.mapMPWApprovalMatrix = new Map<integer, List<MPW_Approval_Matrix__c>>();
        //04072016 - Modified by Poulami Starts.
        string soql = 'SELECT Id, Category__c, Step_1_Approver_1__c, Step_1_Approver_2__c, Geometry__c, Sub_Category__c, Fab__c, Step_1_Approver_3__c, PA_Code__c ' + 
                      'FROM MPW_Approval_Matrix__c ' +
                      'ORDER BY Name ASC' ;
        //04072016 - Modified by Poulami Ends.
        System.debug('=======Soql===='+soql);          
        List<MPW_Approval_Matrix__c> tempList = new List<MPW_Approval_Matrix__c>();
        tempList = database.query(soql);         
        listMPWApprovalMatrix = tempList; 
        
        if (tempList.size() > 0) {           
            this.mapMPWApprovalMatrix = paginateRecords(tempList);
        } 
    }
    
    private Map<integer, List<MPW_Approval_Matrix__c>> paginateRecords(List<MPW_Approval_Matrix__c> tempList) {
        Map<integer, List<MPW_Approval_Matrix__c>> tempMap = new Map<integer, List<MPW_Approval_Matrix__c>>();
        integer recordsPerPage = 10; //Integer.valueOf(selectedVal);
        integer pageNo = 1;
        List<MPW_Approval_Matrix__c> temp = new List<MPW_Approval_Matrix__c>();
        for (MPW_Approval_Matrix__c mam : tempList) {
            if (temp.size() < recordsPerPage) {
                temp.add(mam);
            } else {
                tempMap.put(pageNo, temp);
                pageNo++;
                temp = new List<MPW_Approval_Matrix__c>();
                temp.add(mam);
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
    
    public List<MPW_Approval_Matrix__c> getMPWApprovalMatrixRecords() {
        return (this.mapMPWApprovalMatrix.size() > 0 ? this.mapMPWApprovalMatrix.get(this.currentPageNo) : new List<MPW_Approval_Matrix__c>());
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
        Map<string, List<MPW_Approval_Matrix__c>> tempMap = new Map<string, List<MPW_Approval_Matrix__c>>();
        for(MPW_Approval_Matrix__c g : this.listMPWApprovalMatrix){
            string key = string.valueOf(g.get(this.sortField)); 
            if(tempMap.containsKey(key)){
                tempMap.get(key).add(g);
            } else {
                tempMap.put(key, new List<MPW_Approval_Matrix__c>{g});
            }
        }
        
        List<string> sortList = new List<String>();
        sortList.addAll(tempMap.keySet());
        sortList.sort();
        
        this.listMPWApprovalMatrix = new List<MPW_Approval_Matrix__c>();
        if(this.sortType == 'ASC'){
            for(string s : sortList){
                this.listMPWApprovalMatrix.addAll(tempMap.get(s));    
            }
        } else if(this.sortType == 'DESC'){
            for(integer ctr = (sortList.size()-1); ctr >= 0; ctr--){
                this.listMPWApprovalMatrix.addAll(tempMap.get(sortList[ctr]));    
            }
        }
        
        if (this.listMPWApprovalMatrix.size() > 0) {
            this.mapMPWApprovalMatrix = paginateRecords(listMPWApprovalMatrix);
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