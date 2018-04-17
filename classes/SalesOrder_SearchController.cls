/*
 Type Name: SalesOrder_SearchController 
 Author: Cognizant Technology Solutions
 Created Date: 3-Nov-2016
 Reason: This class is used for searching sales order schedule records 
 Change History: 
 */


public with sharing class SalesOrder_SearchController {

    
    // RMA and selection set/variables
    public List<SalesOrderSubClass> listCaseTotal{get; set;}
    public transient List <SalesOrderSubClass> listSOPage{get; set;}
    
    
    
    private String exptype;
    public transient String QuerySO;
    
     //Pagination variable 
    Public Boolean hasPrevious {get;set;}
    Public Boolean hasNext {get;set;}
    Public Integer pageno {get;set;}
    Public Integer lastPageno {get;set;}
    Public Integer intRecPerPage{get;set;}
    // display sort and number
    public String RecPerPage {get; set;}
    public list<SelectOption> RecPerPageOption {get; set;}  
    public String SortFieldSave;
    public Boolean isAMDOnly{get; set;}
    public Boolean isLoad=false;    
    public Boolean isFoundryView {get;set;}
    public String exportUrl{get;set;}
    private List<String> rmaStageFilters;
    private boolean hasError;

    
    public String AlphaFilter { get; set; }

     public list<String> AlphaList {get; set;}

   
    public PageReference Previous() {
        return null;
    }
    Public PageReference Next() {
       
        return null;
    }
    
   
    
    public Integer totalRecords { get; set; }
    public String AccountName { get; set; }
  
    public String SalesOrderName { get; set; }

    public String Status { get; set; }
    
    public String PartNumber { get; set; }

    public String PONumber { get; set; }

    public PageReference ClearAll() {
    
        exportUrl = '';
        SalesOrderName= '';
        AccountName= '';
        PONumber= '';
        PartNumber = '';
        Status = '';
        AlphaFilter = 'All'; 
        totalRecords = 0;
        AlphaFilter = 'All';
        RecPerPage = '10'; //default records per page
        // list generation
        getSOList();
        return null;
        
    }
    
      /***
    * SortDirection - return sort direction. Default ascending(asc)
    ***/
    public String SortDirection {
        get { if (SortDirection == null) {  SortDirection = 'asc'; } return SortDirection;  }
        set;
    }
 
    /***
    * SortField - return sort by field. Default to Name
    ***/
    public String SortField {
        get { if (SortField == null) {SortField = 'Name'; } return SortField;  }
        set; 
    }
 
      /***
    * SortToggle - toggles the sorting of query from asc<-->desc
    ***/
    public void SortToggle() {
        SortDirection = SortDirection.equals('asc') ? 'desc NULLS LAST' : 'asc';
        // reset alpha filter and sort sequence when sorted field is changed
        if (SortFieldSave != SortField) {
            SortDirection = 'asc';
            AlphaFilter = 'All';
            SortFieldSave = SortField;
        }
        // run the query again
       getSOList();
    }
    
     /***
    * isNotBlank- check the string null or blank
    ***/
    public static Boolean isNotBlank(String val){
        if(val <> null && val <> '' && val <> 'null'){
            return true;
        }
        return false;
    }

   
        
    public PageReference Search() 
    {    
        exportUrl = '';
        getSOList();
        
    
        return null;
    }

    Public PageReference resetPagination() 
    {
        totalRecords = 0;
        pageNo = 1;
        lastPageno = 1;
        createPagination();
        return null;
    }
    
     public void createPagination() 
     {
        totalRecords = listCaseTotal.size();
        intRecPerPage = Integer.valueOf(RecPerPage);
        lastPageno = listCaseTotal.size() / intRecPerPage; // Page size 10 rows
        if (lastPageno * intRecPerPage < listCaseTotal.size()) {
            lastPageno++;
        }

        if (pageno < lastPageno) {
            hasNext = true;
        } else {
            hasNext = false;
        }

        if (pageno > 1) {
            hasPrevious = true;
        } else {
            hasPrevious = false;
        }

        displayList();
    }

    public void displayList() {
        intRecPerPage = Integer.valueOf(RecPerPage);
        if (pageno < lastPageno) {
            hasNext = true;
        } else {
            hasNext = false;
        }
        if (pageno > 1) {
            hasPrevious = true;
        } else {
            hasPrevious = false;
        }
        if (listSOPage == null)
               listSOPage = new list <SalesOrderSubClass> ();

        If(pageNo * intRecPerPage < listCaseTotal.size()) {
            for (Integer i = ((pageNo * intRecPerPage) - intRecPerPage); i < pageNo * intRecPerPage; i++) {
                listSOPage .add(listCaseTotal[i]);
            }
        } else If(pageNo * intRecPerPage >= listCaseTotal.size()) {
            for (Integer i = ((pageNo * intRecPerPage) - intRecPerPage); i < listCaseTotal.size(); i++) {
                listSOPage.add(listCaseTotal[i]);
            }

        }
    }
   
    public String getIsFoundryView() {
        return null;
    }
    
    public SalesOrder_SearchController()
    {
        hasError = false;
        expType = ApexPages.currentPage().getParameters().get('exptype');
        rmaStageFilters =  new String[]{};
        listCaseTotal = new list<SalesOrderSubClass>();
      //records for page initialization
        RecPerPageOption = new list<SelectOption>();
        RecPerPageOption.add(new SelectOption('10','10'));
        RecPerPageOption.add(new SelectOption('25','25'));
        RecPerPageOption.add(new SelectOption('50','50'));
        RecPerPageOption.add(new SelectOption('100','100'));
        RecPerPageOption.add(new SelectOption('200','200'));
        RecPerPage = '10'; //default records per page
        totalRecords = 0;
        pageNo = 1;
        lastPageno = 1;
        
        // initialization alpha list
        AlphaList = new list<String> {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'Other', 'All'};
            SortFieldSave = SortField;
        // alpha filter, use page parameter or set default to all
        if (apexpages.currentpage().getparameters().get('alpha') == null) { AlphaFilter = 'All';}
        else {AlphaFilter = apexpages.currentpage().getparameters().get('alpha');}  
        
         if(String.isBlank(exptype))
         {
               
          getSOList();
         }   
         
          if(isNotBlank(expType)){
            getParameters();  
            getSOList();                     
        }
    }
    
     public void getParameters()
      {
         this.SalesOrderName= isNotBlank(ApexPages.currentPage().getParameters().get('SalesOrderName')) ?
         ApexPages.currentPage().getParameters().get('SalesOrderName') : null;
         
         this.AccountName= isNotBlank(ApexPages.currentPage().getParameters().get('AccountName')) ?
         ApexPages.currentPage().getParameters().get('AccountName') : null;
         
         this.PONumber= isNotBlank(ApexPages.currentPage().getParameters().get('PONumber')) ?
         ApexPages.currentPage().getParameters().get('PONumber') : null;
         
         this.PartNumber= isNotBlank(ApexPages.currentPage().getParameters().get('PartNumber')) ?
         ApexPages.currentPage().getParameters().get('PartNumber') : null;
         
         this.Status = isNotBlank(ApexPages.currentPage().getParameters().get('Status')) ?
         ApexPages.currentPage().getParameters().get('Status') : null;
         
        
         
         this.AlphaFilter = isNotBlank(ApexPages.currentPage().getParameters().get('AlphaFilter')) ?
         ApexPages.currentPage().getParameters().get('AlphaFilter') : null;
         this.SortField = isNotBlank(ApexPages.currentPage().getParameters().get('SortField')) ?
         ApexPages.currentPage().getParameters().get('SortField') : null;
      }
      
      public void getSOList() 
      {
         if (listCaseTotal != null)
            listCaseTotal.clear();
            
         if (isNotBlank(SalesOrderName) || isNotBlank(AccountName) || 
            isNotBlank(PONumber) || isNotBlank(PartNumber) ||
            isNotBlank(Status)
            )
            {
              
            transient List <Sales_Order_Schedule__c> listCase = new List<Sales_Order_Schedule__c>();        
            
            transient List <Id> setCaseIds = new List<Id>();
            transient Set  <Id> setRecordIds = new Set<Id>();
            BuildQuery();
            listCase = Database.Query(QuerySO);
            
            system.debug('listCase ######'+listCase);
             if(listCase.size()>0)
             {
               for (Sales_Order_Schedule__c c: listCase) 
               {
                        listCaseTotal.add(new SalesOrderSubClass(c));
               }
             }
             system.debug('listCaseTotal######'+listCaseTotal);
            
            }
            
            if (exptype == 'excel') 
            {
            if (listSOPage == null){listSOPage = new list <SalesOrderSubClass>();}
            listSOPage.addall(listCaseTotal);
            totalRecords = listCaseTotal.size();
            }
            else{
            resetPagination();
            }     
      }
    
       /***
    * BuildQuery - build query command for list selection change
    ***/
    public void BuildQuery() {
        String QueryWhere = '';
 
        if (AlphaFilter == null || AlphaFilter.trim().length() == 0) {
            AlphaFilter = 'All';
        }
        
        QuerySO = 'SELECT Id,Sales_Order_Line__c,SalesOrder_Account__c,Sales_Order_Line__r.Account__r.Id,Name,Part__c,Purchase_order_number__c,Status__c FROM Sales_Order_Schedule__c';
        
        system.debug('QuerySO######'+QuerySO);
        
        if (AlphaFilter == 'Other') {
            QueryWhere = BuildWhere(QueryWhere, '(' + String.escapeSingleQuotes(SortField) + ' < \'A\' OR ' + 
                                    String.escapeSingleQuotes(SortField) + ' > \'Z\') AND (NOT ' + 
                                    String.escapeSingleQuotes(SortField) + ' LIKE \'Z%\') ');
        } 
        else if (AlphaFilter != 'All') {
            QueryWhere = BuildWhere(QueryWhere, '(' + String.escapeSingleQuotes(SortField) + ' LIKE \'' + String.escapeSingleQuotes(AlphaFilter) + '%\')' );
        }
        
        if (SalesOrderName!= null && SalesOrderName!='') {
            QueryWhere = BuildWhere(QueryWhere, ' (Name LIKE \'%' + String.escapeSingleQuotes(SalesOrderName) + '%\')');
        }
        if (AccountName!= null && AccountName!='') {
            QueryWhere = BuildWhere(QueryWhere, ' (SalesOrder_Account__c LIKE \'%' + String.escapeSingleQuotes(AccountName) + '%\')');
        }
        if (PONumber!= null && PONumber!='') {
            QueryWhere = BuildWhere(QueryWhere, ' (Purchase_order_number__c LIKE \'%' + String.escapeSingleQuotes(PONumber) + '%\')');
        }
        if (PartNumber!= null && PartNumber!='') {
            QueryWhere = BuildWhere(QueryWhere, ' (Part__c LIKE \'%' + String.escapeSingleQuotes(PartNumber) + '%\')');
        }
        if (Status!= null && Status!='') {
            QueryWhere = BuildWhere(QueryWhere, ' (Status__c LIKE \'%' + String.escapeSingleQuotes(Status) + '%\')');
        }
        
        QuerySO += QueryWhere;
        QuerySO += ' ORDER BY ' + String.escapeSingleQuotes(SortField) + ' ' + String.escapeSingleQuotes(SortDirection);   
        system.debug('QuerySO######@@@'+QuerySO);
    } 
    
    /***
    * BuildWhere - build soql string for where criteria 
    ***/
    public String BuildWhere(String QW, String Cond){
        if (QW == ''){
            return ' WHERE ' + Cond;
        } else {
            isLoad = true;
            return QW + ' AND ' + Cond;            
        }
        
        
    }    
 
    public with sharing class SalesOrderSubClass
    {
    
        public Id Id{get;set;}
        public string SalesOrderName{get;set;}
        public string AccountName {get;set;}
        public string PONumber{get;set;}
        public string PartNumber{get;set;}
        public string Status{get;set;}
        
        public SalesOrderSubClass(Sales_Order_Schedule__c so)
        {
         
            Id  = so.Id ;
            SalesOrderName = so.Name;
            AccountName = so.SalesOrder_Account__c;
            PONumber= so.Purchase_order_number__c;
            PartNumber= so.Part__c;
            Status= so.Status__c;
        
        }
        
    
    }
    
    

}