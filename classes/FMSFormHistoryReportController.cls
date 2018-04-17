/*
* @ Author :- Inshu Misra
* @ Company :- JKT
* @ Project :- FMS 2.0
* @ Description :- Controller for FMSFormHistoryReport and FMSHistoryCSVExport pages
* @ Date :- 12-July-2017
* @ Change History :-  
**/

public class FMSFormHistoryReportController {
    public String formObjId{get;set;}
    public String mainFormId{get;set;}
    Set<Id> tempSet = new Set<Id>();
    
    public List<Form_System_History__c> formHistoryList{
        get{
            return setCon.getRecords();
        }
        set;
    }
    public List<List<string>> listDetails{get; set;}
    public String queryString{get;set;}
    public Integer size{get;set;}
    public Integer noOfRecords{get; set;}
    public String SortDirection{
        get { 
            if (SortDirection == null) {
                SortDirection = 'desc'; 
            } 
            return SortDirection;  
        }
        set;
    }
    public String SortField {
        get { 
            if (SortField == null) {
                SortField = 'CreatedDate'; 
            } return SortField;  
        }
        set; 
    }
    public String SortFieldSave;
    public boolean setConFlag;
    public ApexPages.StandardSetController setCon {
        get{
            if(setCon == null || setConFlag){
                size = 20;       
                if(queryString.contains('ORDER BY')){
                    queryString = queryString.substringBefore('ORDER BY');
                }
                setConFlag= true;
                queryString += ' ORDER BY ' + String.escapeSingleQuotes(SortField) + ' ' + String.escapeSingleQuotes(SortDirection) ;
                setCon = new ApexPages.StandardSetController(Database.getQueryLocator(queryString));
                setCon.setPageSize(size);
                noOfRecords = setCon.getResultSize();
            }
            return setCon;
        }set;
    }
    public FMSFormHistoryReportController(ApexPages.StandardController controller){
        formObjId = ApexPages.currentPage().getParameters().get('id');
        mainFormId = ApexPages.currentPage().getParameters().get('mainFormId');
        SortFieldSave = SortField; 
        queryString = 'select Id, Field_Name__c, Old_Value__c,isProcessed__c,ExternalHistory_Key__c,  New_Value__c, createdby.Name, createddate from Form_System_History__c where Main_Form__c ';
        if(mainFormId != null && mainFormId != ''){
            Map<Id, Form_Management_System__c> spForm = new Map<Id, Form_Management_System__c>([select Id from Form_Management_System__c where Main_Form_Id__c =:mainFormId and Form_Type__c =: Label.Form_Type_SP]); 
            tempSet = spForm.keySet();
            queryString+='in:tempSet';
        }else{
            queryString+='=:formObjId';
        }
    }

    public Boolean hasNext {
        get {
            setConFlag= false;
            return setCon.getHasNext();
        }
        set;
    }
    public Boolean hasPrevious {
        get {
            setConFlag= false;
            return setCon.getHasPrevious();
        }
        set;
    }
  
    public Integer pageNumber {
        get {
            return setCon.getPageNumber();
        }
        set;
    }
  
    public void first() {
        setConFlag= false;
        setCon.first();
    }
  
    public void last() {
        setConFlag= false;
        setCon.last();
    }
  
    public void previous() {
        setConFlag= false;
        setCon.previous();
    }
  
    public void next() {
        setConFlag= false;
        setCon.next();
    }   

    public PageReference exportCsvFile() {
        listDetails = new List<List<string>>();
        createCsvFile();
        PageReference csvExpPage = Page.FMSHistoryCSVExport;
        return csvExpPage;
    }

    public void createCsvFile() {
        listDetails = new List<List<string>>();
        List<string> headers = new List<string>();
        List<String> fmsIdList = new List<String>();
        List<Form_System_History__c> formHistoryList = (List<Form_System_History__c>)Database.query(queryString);
        List<string> tempList = new List<string>();
        headers.add('Field Name, Old Value, New Value, Form System History: Created By, Form System History: Created Date\n');
        listDetails.add(headers); 
        if(formHistoryList != null && !formHistoryList.isEmpty()){
            for(Form_System_History__c history : formHistoryList){
                String detail = '';
                detail += history.Field_Name__c+', ';
                detail += ((history.Old_Value__c == null || history.Old_Value__c == '')?'':history.Old_Value__c)+', ';
                detail += ((history.New_Value__c == null || history.New_Value__c == '')?'':history.New_Value__c)+', ';
                detail += history.CreatedBy.Name+', ';
                detail += history.CreatedDate+',\n';
                if(tempList.size() < 1000){
                    tempList.add(detail);
                }else {
                    listDetails.add(tempList); 
                    tempList = new List<string>();
                }
            } 
        }
        if(tempList.size() > 0){
            listDetails.add(tempList);
        }
    }
    
    public void SortToggle() {
        SortDirection = SortDirection.equals('asc') ? 'desc NULLS LAST' : 'asc';
        if (SortFieldSave != SortField) {
            SortDirection = 'asc';
            SortFieldSave = SortField;
        }
        setConFlag= true;
    }
    public List<List<String>> getDetails(){
//      createCsvFile();
        return listDetails;
    }
    public PageReference backToFormPage(){
        PageReference back = ApexPages.currentPage();
        back.setRedirect(true);
        return back;
    }
}