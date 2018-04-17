/*
Type Name: CaseSearchController
Author: Cognizant Case Management Team
Created Date: 20-Nov-2014
Reason: Reason: This is the controllar class for CaseSearch page.
Test Class: CaseVisualforceControllerTest
Change History:
Author: Monalisa Mohapatra.
Modified Date: 05-May-2015
Reason: Adding filter based on Account in advance case search page
……..
……..
--
*/

public with sharing class CaseSearchController{
    //Basic Search Variables
    // Case and selection set/variables
    public list<CaseSubClass> listCaseTotal {get; set;}
    public transient list < CaseSubClass> listCasePage {get; set;}
    // selection and filter 
    public list<String> AlphaList {get; set;}
    public String AlphaFilter {get; set;}
    public String SearchName {get; set;}
    public String SearchCaseNumber{get; set;}
    public String geometry {get; set;}
    public String category {get; set;}
    public String subcategory {get; set;}
    public String status {get; set;}
    public String priority {get; set;}
    public String classification {get; set;}
    public String projectName {get; set;}
    public String creator {get; set;}
    public String owner{get; set;}
    public String pdkName{get; set;}
    public String fileName{get; set;}
    public Integer totalRecords{get; set;}
    public String expectedCloseDate {get; set;}
    public String createdDate {get; set;}
    public String lastModifiedDate {get; set;}
    public String AccountName {get; set;}
    public Date ExpectedCloseDateStart{get; set;}
    public Date ExpectedCloseDateEnd{get; set;}
    public Date CreatedDateStart{get; set;}
    public Date CreatedDateEnd{get; set;}
    public Date ClosedDateEnd{get; set;}
    public Date ClosedDateStart{get; set;}
    public Date DateTimeVerifiedEnd{get; set;}
    public Date DateTimeVerifiedStart{get; set;}
         
    public transient String QueryCase;
    private String exptype;
    
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
    public Boolean isLoad=false;    

    //Advance Search variables
    public string errorMsg = BugErrorMessages__c.getValues('AdvBugSearchError').Error_Message__c;
    public list<String> AlphaListAdv {get; set;}
    public String AlphaFilterAdv {get; set;}
    public list<CaseSubClass> listCaseTotalAdv {get; set;}
    public transient list < CaseSubClass> listCasePageAdv {get; set;}
    public string searchstring{get;set;}
    public string textSearch {get;set;}
    //Pagination variable Adv search
    Public Boolean hasPreviousAdv {get;set;}
    Public Boolean hasNextAdv {get;set;}
    Public Integer pagenoAdv {get;set;}
    Public Integer lastPagenoAdv {get;set;}
    Public Integer intRecPerPageAdv{get;set;}
    public Integer totalRecordsAdv{get; set;}
    // display sort and number Adv search
    public String RecPerPageAdv {get; set;}
    public list<SelectOption> RecPerPageOptionAdv {get; set;}  
    public String SortFieldSaveAdv;
    public Boolean isLoadAdv=false;  
    public set<string> caseId = new set<string>();
    public string stQueryFilterAdvSearch{get;set;} 
    public boolean checkFlag{get;set;} 
    public transient String QueryCaseAdv;
    private String exptypeAdv;
     
    /***
    * CaseSearchController - Constructor initialization
    ***/
    public CaseSearchController(){
        listCaseTotal = new list<CaseSubClass>();
        listCaseTotalAdv = new list<CaseSubClass>();
        //records for page initialization        
        RecPerPageOption = getPageSelectOption();
        RecPerPageOptionAdv = getPageSelectOption();
               
        RecPerPage = '10'; //default records per page
        totalRecords = 0;
        pageNo = 1;
        lastPageno = 1;
        exptype = '';
        exptypeAdv = '';
        totalRecordsAdv = 0;
        pageNoAdv = 1;
        lastPagenoAdv = 1;
        // initialization alpha list
        AlphaList = getAlphaList();
            SortFieldSave = SortField;
        //// initialization alpha list for advance search
       AlphaListAdv = getAlphaList();
            SortFieldSaveAdv = SortFieldAdv;           
    }
    public list<String> getAlphaList() {
        list<String> alList = new list<String> {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'Other', 'All'};
        return alList;
    }
    
    public list<SelectOption> getPageSelectOption() {
        list<SelectOption> pageOption = new list<SelectOption>();
        pageOption.add(new SelectOption('10','10'));
        pageOption.add(new SelectOption('25','25'));
        pageOption.add(new SelectOption('50','50'));
        pageOption.add(new SelectOption('100','100'));
        pageOption.add(new SelectOption('200','200'));
        return pageOption;
    }
    public void getCaseList() {
        
        if (listCaseTotal != null)
            listCaseTotal.clear();
        if (isNotBlank(SearchName) || isNotBlank(SearchCaseNumber) || (geometry != '[]' && geometry != '') ||
            (category != '[]' && category != '') || (subcategory != '[]' && subcategory  != '') || (status != '[]' && status != '') ||
            (priority != '[]' && priority != '') || (classification != '[]' && classification != '') || isNotBlank(projectName) ||
            isNotBlank(creator) || isNotBlank(owner) || isNotBlank(pdkName) ||
            (ExpectedCloseDateStart != null && ExpectedCloseDateEnd != null) || (CreatedDateStart != null && CreatedDateEnd != null) || (ClosedDateStart != null && ClosedDateEnd != null)|| (DateTimeVerifiedStart != null && DateTimeVerifiedEnd != null) || isNotBlank(lastModifiedDate) ||
            isNotBlank(AccountName)) {
            transient list < Case > listCase = new list < Case > ();        
            transient List < UserRecordAccess > listUserRecordAccess = new List < UserRecordAccess > ();
            transient List < Id > setCaseIds = new List < Id > ();
            transient Set < Id > setRecordIds = new Set < Id > ();
            transient boolean noSort = false;
            transient boolean noSortExpectedDate = false;
            transient boolean noSortClosedDate = false;
            BuildQuery();
            if((SortField == 'CreatedDate') && AlphaFilter != 'All'){
                noSort = true;    
            }
            if((SortField == 'ClosedDate') && AlphaFilter != 'All'){
                noSortClosedDate = true;    
            }            
            if((SortField == 'Expected_Close_Date__c') && AlphaFilter != 'All'){
                noSortExpectedDate = true;    
            }            
            if(noSort == false && noSortExpectedDate == false && noSortClosedDate == false){
                listCase = Database.Query(QueryCase);
            }
            if(listCase.size()>0){
                if (UserInfo.getUserType() != 'Standard') {
                    for (Case c: listCase) {
                        //to avoid Number of records exceeds limit: 200 
                        if (setCaseIds.size() != 200) {
                            setCaseIds.add(c.Id);
                        } else if (setCaseIds.size() == 200) {
                            listUserRecordAccess.addall(getUserRecordAccessList(setCaseIds));
                            setCaseIds.clear();
                        }
                    }
                    if (setCaseIds.size() > 0) {
                        listUserRecordAccess.addall(getUserRecordAccessList(setCaseIds));
                        setCaseIds.clear();
                    }
        
                    for (UserRecordAccess ura: listUserRecordAccess) {
                        if (ura.HasReadAccess) {
                            setRecordIds.add(ura.RecordId);
                        }
                    }
                    for (Case c: listCase) {
                        if (setRecordIds.contains(c.Id) && listCaseTotal.size() < 500) {
                            listCaseTotal.add(new CaseSubClass(c,true,false));
                        }
                    }
                } else {
                    for (Case c: listCase) {
                        listCaseTotal.add(new CaseSubClass(c,true,false));
                    }
                }
            }      
        }        
        if (exptype == 'excel') {
            if (listCasePage == null){listCasePage = new list < CaseSubClass > ();}
            listCasePage.addall(listCaseTotal);
            totalRecords = listCaseTotal.size();
        }else{
            resetPagination();
        }        
    }
    
    /***
    * getUserRecordAccessList- return UserRecordAccess list for portal users
    ***/    
    public list<UserRecordAccess> getUserRecordAccessList(List < Id > setCaseIds) {        
        List < UserRecordAccess > listUserRecordAccess = 
                        [SELECT RecordId, HasEditAccess, HasReadAccess FROM UserRecordAccess 
                        WHERE UserId = : UserInfo.getUserId() AND RecordId In: setCaseIds Limit 200];
        
        return listUserRecordAccess;
    }

    /***
    * ClearCaseSelectedSet - remove selected Cases and initialize counter
    ***/
    public PageReference ClearAll(){
        SearchName = '';
        SearchCaseNumber = '';
        geometry ='[]';
        category ='[]';
        subcategory ='[]';
        status ='[]';
        priority ='[]';
        classification ='[]';
        projectName ='';
        creator ='';
        owner ='';
        pdkName ='';
        expectedCloseDate ='';
        createdDate ='';
        lastModifiedDate ='';
        AlphaFilter = 'All'; 
        totalRecords = 0;
        AlphaFilter = 'All';
        RecPerPage = '10'; //default records per page
        AccountName= '';
        ExpectedCloseDateStart = null;
        ExpectedCloseDateEnd = null;
        CreatedDateStart = null;
        CreatedDateEnd = null;
        ClosedDateEnd = null;
        ClosedDateStart = null;
        DateTimeVerifiedStart = null;
        DateTimeVerifiedEnd = null;
        // list generation
        getCaseList();
        return null;
    }

    /***
    * SearchCase - set search criteria fields and refresh Case table
    ***/
    public PageReference SearchCase() {
        if(CreatedDateStart > CreatedDateEnd){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.CreatedDate_To_and_From_Date_Validation);
            ApexPages.addMessage(myMsg); 
            return null;          
        }
        if(ExpectedCloseDateStart > ExpectedCloseDateEnd){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.Case_Expected_To_and_From_Date_Validation);
            ApexPages.addMessage(myMsg); 
            return null;      
        }
        if(ClosedDateStart > ClosedDateEnd){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.Case_Closed_To_and_From_Date_Validation);
            ApexPages.addMessage(myMsg); 
            return null;      
        }
        if(DateTimeVerifiedStart > DateTimeVerifiedEnd){     
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.Case_Date_Time_Verified_To_and_From_Date_Validation);
            ApexPages.addMessage(myMsg); 
            return null;      
        }         
        if((ExpectedCloseDateStart != null && ExpectedCloseDateEnd == null) || (ExpectedCloseDateStart == null && ExpectedCloseDateEnd != null)){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.Case_Expected_Close_Date_Validation);
            ApexPages.addMessage(myMsg);
            return null;             
        }        
        if((CreatedDateStart != null && CreatedDateEnd == null) || (CreatedDateStart == null && CreatedDateEnd != null)){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.Case_Created_Date_Validation);
            ApexPages.addMessage(myMsg);
           return null;             
        } 
        if((ClosedDateStart != null && ClosedDateEnd == null) || (ClosedDateStart == null && ClosedDateEnd != null)){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.Case_Closed_Date_Validation);
            ApexPages.addMessage(myMsg);
           return null;             
        }
        if((DateTimeVerifiedStart != null && DateTimeVerifiedEnd == null) || (DateTimeVerifiedStart == null &&  DateTimeVerifiedEnd != null)){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.Case_Date_Time_Verified_Validation);
            ApexPages.addMessage(myMsg);
           return null;             
        }                 
        getCaseList();
        return null;
    }

    /***
    * BuildQuery - build query command for list selection change
    ***/
    public void BuildQuery() {
        String QueryWhere = '';

        if (AlphaFilter == null || AlphaFilter.trim().length() == 0) {
            AlphaFilter = 'All';
        }        
        QueryCase = 'SELECT Id, CaseNumber, ContactId, Contact.Name, Description, Priority, Category__c , Status , Subject , PDK_Name__c, Geometry__c , Project__c, Project__r.Name, CreatedBy.Id , Account_Name__c, SubCategory__c ,' + 
                    'Classification__c , ClosedDate, CreatedDate, Case_Record_Type__c, OwnerId, Owner.Name, Origin,Age_of_Case__c, Contact_Name__c,' +  
                    'Need_by_Date__c, Expected_Close_Date__c, CreatedById, CreatedBy.Name,LastModifiedDate ' +
            ' FROM Case'; 
 
        if (AlphaFilter == 'Other') {
            QueryWhere = BuildWhere(QueryWhere, '(' + String.escapeSingleQuotes(SortField) + ' < \'A\' OR ' + 
                                    String.escapeSingleQuotes(SortField) + ' > \'Z\') AND (NOT ' + 
                                    String.escapeSingleQuotes(SortField) + ' LIKE \'Z%\') ');
        } else if (AlphaFilter != 'All') {
            QueryWhere = BuildWhere(QueryWhere, '(' + String.escapeSingleQuotes(SortField) + ' LIKE \'' + String.escapeSingleQuotes(AlphaFilter) + '%\')' );
        }
             
        if (SearchName != null && SearchName !='') {
            QueryWhere = BuildWhere(QueryWhere, ' (Subject LIKE \'%' + String.escapeSingleQuotes(SearchName) + '%\')');
        }
        if (SearchCaseNumber != null && SearchCaseNumber !='') {
            QueryWhere = BuildWhere(QueryWhere, ' (CaseNumber LIKE \'%' + String.escapeSingleQuotes(SearchCaseNumber) + '%\')');
        }
        if (status != null && status !='') {
            list < string > textSearchFilter = new list < string > ();
            String searchStr = ''; 
            textSearchFilter = status.split(',');
            textSearchFilter = removespace(textSearchFilter);
            for (string str: textSearchFilter) {
                if(str != '[]'){
                    searchStr += 'Status =' + '\'' + str + '\'' + ' OR ';
                }                
            }
            if(searchStr != ''){
                searchStr = searchStr.replace('[','');
                searchStr = searchStr.replace(']','');
                searchStr = searchStr.substring(0, searchStr.length() - 4);
            
                QueryWhere = BuildWhere(QueryWhere, '(' + searchStr+ ')');
            }
            //QueryWhere = BuildWhere(QueryWhere, ' (Status LIKE \'%' + String.escapeSingleQuotes(status) + '%\')');
        }
        if (priority != null && priority !='') {
            list < string > textSearchFilter = new list < string > ();
            String searchStr = ''; 
            textSearchFilter = Priority.split(',');
            textSearchFilter = removespace(textSearchFilter);
            for (string str: textSearchFilter) {
                if(str != '[]'){ 
                    searchStr += 'Priority =' + '\'' + str + '\'' + ' OR ';
                }                
            }
            if(searchStr != ''){
                searchStr = searchStr.replace('[','');
                searchStr = searchStr.replace(']','');
                searchStr = searchStr.substring(0, searchStr.length() - 4);
            
                QueryWhere = BuildWhere(QueryWhere, '(' + searchStr+ ')');
            }     
            //QueryWhere = BuildWhere(QueryWhere, ' (Priority LIKE \'%' + String.escapeSingleQuotes(priority) + '%\')');
        }
        if (category != null && category !='') {
           list < string > textSearchFilter = new list < string > ();
            String searchStr = ''; 
            textSearchFilter = category.split(',');
            textSearchFilter = removespace(textSearchFilter);
            for (string str: textSearchFilter) {
                if(str != '[]'){ 
                    searchStr += 'Category__c  =' + '\'' + str + '\'' + ' OR ';       
                }         
            }
            if(searchStr != ''){
                searchStr = searchStr.replace('[','');
                searchStr = searchStr.replace(']','');
                searchStr = searchStr.substring(0, searchStr.length() - 4);
            
                QueryWhere = BuildWhere(QueryWhere, '(' + searchStr+ ')');
            }       
            //QueryWhere = BuildWhere(QueryWhere, ' (Category__c LIKE \'%' + String.escapeSingleQuotes(category) + '%\')');
        }
        if (classification != null && classification !='') {
           list < string > textSearchFilter = new list < string > ();
            String searchStr = ''; 
            textSearchFilter = classification.split(',');
            textSearchFilter = removespace(textSearchFilter);
            for (string str: textSearchFilter) {
                if(str != '[]'){ 
                    searchStr += 'Classification__c  =' + '\'' + str + '\'' + ' OR ';   
                }            
            }
            if(searchStr != ''){
                searchStr = searchStr.replace('[','');
                searchStr = searchStr.replace(']','');
                searchStr = searchStr.substring(0, searchStr.length() - 4);
            
                QueryWhere = BuildWhere(QueryWhere, '(' + searchStr+ ')');
            }       
            //QueryWhere = BuildWhere(QueryWhere, ' (Classification__c LIKE \'%' + String.escapeSingleQuotes(classification) + '%\')');
        }
        if (geometry != null && geometry !='') {
           list < string > textSearchFilter = new list < string > ();
            String searchStr = ''; 
            textSearchFilter = geometry.split(',');
            textSearchFilter = removespace(textSearchFilter);
            for (string str: textSearchFilter) {
                if(str != '[]'){ 
                    searchStr += 'Geometry__c =' + '\'' + str + '\'' + ' OR ';           
                }     
            }
            if(searchStr != ''){
                searchStr = searchStr.replace('[','');
                searchStr = searchStr.replace(']','');
                searchStr = searchStr.substring(0, searchStr.length() - 4);
            
                QueryWhere = BuildWhere(QueryWhere, '(' + searchStr+ ')');
            }      
            //QueryWhere = BuildWhere(QueryWhere, ' (Geometry__c LIKE \'%' + String.escapeSingleQuotes(geometry) + '%\')');
        }
        if (subcategory != null && subcategory !='') {
            list < string > textSearchFilter = new list < string > ();
            String searchStr = ''; 
            textSearchFilter = subcategory.split(',');
            textSearchFilter = removespace(textSearchFilter);
            for (string str: textSearchFilter) {
                if(str != '[]'){ 
                    searchStr += 'SubCategory__c =' + '\'' + str + '\'' + ' OR ';   
                }             
            }
            if(searchStr != ''){
                searchStr = searchStr.replace('[','');
                searchStr = searchStr.replace(']','');
                searchStr = searchStr.substring(0, searchStr.length() - 4);
            
                QueryWhere = BuildWhere(QueryWhere, '(' + searchStr+ ')');
            }       
            //QueryWhere = BuildWhere(QueryWhere, ' (SubCategory__c LIKE \'%' + String.escapeSingleQuotes(subcategory) + '%\')');            
        }
        if (pdkName != null && pdkName !='') {
            QueryWhere = BuildWhere(QueryWhere, ' (PDK_Name__c LIKE \'%' + String.escapeSingleQuotes(pdkName) + '%\')');            
        }              
        if (projectName != null && projectName !='') {
            QueryWhere = BuildWhere(QueryWhere, ' (Project__r.Name LIKE \'%' + String.escapeSingleQuotes(projectName) + '%\')');            
        }        
        if (creator != null && creator !='') {
            QueryWhere = BuildWhere(QueryWhere, ' (CreatedBy.Name LIKE \'%' + String.escapeSingleQuotes(creator) + '%\')');            
        }        
        if (owner != null && owner !='') {
            QueryWhere = BuildWhere(QueryWhere, ' (Owner.Name LIKE \'%' + String.escapeSingleQuotes(owner) + '%\')');            
        }
        /*if (expectedCloseDate != null && expectedCloseDate !='') {
            QueryWhere = BuildWhere(QueryWhere, ' (Expected_Close_Date__c = ' + String.escapeSingleQuotes(expectedCloseDate) + ')');            
        }*/
        /*if (createdDate != null && createdDate !='') {
            QueryWhere = BuildWhere(QueryWhere, ' (CreatedDate = ' + String.escapeSingleQuotes(createdDate) + ')');            
        }*/
        if (CreatedDateStart != null && CreatedDateEnd != null ) {
            string createdStartDate =  string.valueof(CreatedDateStart.day());
            if( createdStartDate.length() == 1){
                createdStartDate = '0'+createdStartDate;
            }
            string createdStartMonth = string.valueof(CreatedDateStart.month());
            if( createdStartMonth.length() == 1){
                createdStartMonth = '0'+createdStartMonth ;
            }            
            string createdStartYear = string.valueof(CreatedDateStart.year());            
            string createdEndDate =  string.valueof(CreatedDateEnd.day());
            if( createdEndDate.length() == 1){
                createdEndDate = '0'+createdEndDate;
            }            
            string createdEndMonth = string.valueof(CreatedDateEnd.month());
            if( createdEndMonth.length() == 1){
                createdEndMonth = '0'+createdEndMonth;
            }            
            string createdEndYear = string.valueof(CreatedDateEnd.year());
            string createdStartDt = createdStartYear+'-'+createdStartMonth+'-'+createdStartDate+'T00:00:00.000+0000';
            string createdEndDt = createdEndYear+'-'+createdEndMonth+'-'+createdEndDate+'T23:59:59.000+0000';
            
            QueryWhere = BuildWhere(QueryWhere, ' (CreatedDate >= ' + String.escapeSingleQuotes(createdStartDt) + ')' + 'AND' + ' (CreatedDate <= ' + String.escapeSingleQuotes(createdEndDt) + ')');            
        }
        if (DateTimeVerifiedStart != null && DateTimeVerifiedEnd != null ) {
            string DateTimeVerifiedStartDate =  string.valueof(DateTimeVerifiedStart.day());
            if( DateTimeVerifiedStartDate.length() == 1){
                DateTimeVerifiedStartDate = '0'+DateTimeVerifiedStartDate;
            }
            string DateTimeVerifiedStartMonth = string.valueof(DateTimeVerifiedStart.month());
            if( DateTimeVerifiedStartMonth.length() == 1){
                DateTimeVerifiedStartMonth = '0'+DateTimeVerifiedStartMonth ;
            }            
            string DateTimeVerifiedStartYear = string.valueof(DateTimeVerifiedStart.year());            
            string DateTimeVerifiedEndDate =  string.valueof(DateTimeVerifiedEnd.day());
            if( DateTimeVerifiedEndDate.length() == 1){
                DateTimeVerifiedEndDate = '0'+DateTimeVerifiedEndDate;
            }            
            string DateTimeVerifiedEndMonth = string.valueof(DateTimeVerifiedEnd.month());
            if( DateTimeVerifiedEndMonth.length() == 1){
                DateTimeVerifiedEndMonth = '0'+DateTimeVerifiedEndMonth;
            }            
            string DateTimeEndYear = string.valueof(DateTimeVerifiedEnd.year());
            string DateTimeStartDt = DateTimeVerifiedStartYear+'-'+DateTimeVerifiedStartMonth+'-'+DateTimeVerifiedStartDate+'T00:00:00.000+0000';
            string DateTimeEndDt = DateTimeEndYear+'-'+DateTimeVerifiedEndMonth+'-'+DateTimeVerifiedEndDate+'T23:59:59.000+0000';
            
            QueryWhere = BuildWhere(QueryWhere, ' (Date_Time_Verified__c >= ' + String.escapeSingleQuotes(DateTimeStartDt) + ')' + 'AND' + ' (Date_Time_Verified__c <= ' + String.escapeSingleQuotes(DateTimeEndDt) + ')');            
        }
        if (ExpectedCloseDateStart != null && ExpectedCloseDateEnd != null ) {
            string ExpectedStartDate =  string.valueof(ExpectedCloseDateStart.day());
            if( ExpectedStartDate.length() == 1){
                ExpectedStartDate = '0'+ ExpectedStartDate ;
            }            
            string ExpectedStartMonth = string.valueof(ExpectedCloseDateStart.month());
            if( ExpectedStartMonth.length() == 1){
                ExpectedStartMonth = '0'+ ExpectedStartMonth ;
            }               
            string ExpectedStartYear = string.valueof(ExpectedCloseDateStart.year());
            string expectedEndDate =  string.valueof(ExpectedCloseDateEnd.day());
            if( expectedEndDate.length() == 1){
                expectedEndDate = '0'+ expectedEndDate ;
            }             
            string expectedEndMonth = string.valueof(ExpectedCloseDateEnd.month());
            if( expectedEndMonth.length() == 1){
                expectedEndMonth = '0'+ expectedEndMonth ;
            }            
            string expectedEndYear = string.valueof(ExpectedCloseDateEnd.year());
            string expectedStartDt = ExpectedStartYear+'-'+ExpectedStartMonth+'-'+ExpectedStartDate;
            string expectedEndDt = expectedEndYear+'-'+expectedEndMonth+'-'+expectedEndDate;
            QueryWhere = BuildWhere(QueryWhere, ' (Expected_Close_Date__c >= ' + String.escapeSingleQuotes(expectedStartDt) + ')' + 'AND' + ' (Expected_Close_Date__c <= ' + String.escapeSingleQuotes(expectedEndDt) + ')');                         
        } 
        if (ClosedDateStart != null && ClosedDateEnd != null ) {
            string ClosedDateStartDate =  string.valueof(ClosedDateStart.day());
            if( ClosedDateStartDate.length() == 1){
                ClosedDateStartDate = '0'+ ClosedDateStartDate ;
            }            
            string ClosedDateStartMonth = string.valueof(ClosedDateStart.month());
            if( ClosedDateStartMonth.length() == 1){
                ClosedDateStartMonth = '0'+ ClosedDateStartMonth ;
            }               
            string ClosedDateStartYear = string.valueof(ClosedDateStart.year());
            string ClosedDateEndDate =  string.valueof(ClosedDateEnd.day());
            if( ClosedDateEndDate.length() == 1){
                ClosedDateEndDate = '0'+ ClosedDateEndDate ;
            }             
            string ClosedDateEndMonth = string.valueof(ClosedDateEnd.month());
            if( ClosedDateEndMonth.length() == 1){
                ClosedDateEndMonth = '0'+ ClosedDateEndMonth ;
            }            
            string ClosedDateEndYear = string.valueof(ClosedDateEnd.year());
            string ClosedDateStartDt = ClosedDateStartYear+'-'+ClosedDateStartMonth+'-'+ClosedDateStartDate+'T00:00:00.000+0000';
            string ClosedDateEndDt = ClosedDateEndYear+'-'+ClosedDateEndMonth+'-'+ClosedDateEndDate+'T23:59:59.000+0000';
            QueryWhere = BuildWhere(QueryWhere, ' (ClosedDate >= ' + String.escapeSingleQuotes(ClosedDateStartDt) + ')' + 'AND' + ' (ClosedDate <= ' + String.escapeSingleQuotes(ClosedDateEndDt) + ')');                         
        }                  
        if (lastModifiedDate != null && lastModifiedDate !='') {
            QueryWhere = BuildWhere(QueryWhere, ' (LastModifiedDate = ' + String.escapeSingleQuotes(lastModifiedDate) + ')');            
        }
        if (AccountName != null && AccountName !='') {           
            QueryWhere = BuildWhere(QueryWhere, '(Account_Name__c LIKE \'%' + String.escapeSingleQuotes(AccountName) + '%\' or  Account_Short_Name__c = \'' + String.escapeSingleQuotes(AccountName) + '\' )'); 
        }
        if(UserInfo.getUserType() != 'Standard'){
            QueryWhere = BuildWhere(QueryWhere, ' (Internal_or_external__c = false)');
            QueryWhere = BuildWhere(QueryWhere, ' (Case_Record_Type_API__c  NOT IN (\'Internal_Case\'))');   
        }
        
        QueryCase += QueryWhere;        
        QueryCase += ' ORDER BY ' + String.escapeSingleQuotes(SortField) + ' ' + String.escapeSingleQuotes(SortDirection);
        if(UserInfo.getUserType() == 'Standard'){
            QueryCase += ' LIMIT 500';
        }else{
            QueryCase += ' LIMIT 2000';
        }    

    }

   /***
    * BuildWhere - build soql string for where criteria 
    ***/
    public String BuildWhere(String QW, String Cond) {
        if (QW == '') {
           //return ' WHERE (HasReadAccess = true) AND ' + Cond;
            return ' WHERE ' + Cond;
        } else {
            isLoad = true;
            return QW + ' AND ' + Cond;            
        }
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
        get { if (SortField == null) {SortField = 'Subject'; } return SortField;  }
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
       getCaseList();
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
    
    /***
    * ExporttoExcel - export Case result into excel
    ***/
    public pageReference ExporttoExcel() {
        PageReference pageRef;
        if (totalRecords != null && totalRecords > 0) {
            transient string url;
            url = '/apex/CaseSearchExcel';    
            url += '?exptype=excel';
            exptype = 'excel';
            getCaseList();
            pageRef = new PageReference(url);
            pageRef.setRedirect(false);
        }
        return pageRef;
    }
    
    //Method will generate geometry picklist
    public List < SelectOption > getGeometryList() {
        transient List < SelectOption > options = new List < SelectOption > ();
        options.add(new SelectOption('', '--None--'));
    
        Schema.DescribeFieldResult fieldResult = Case.Geometry__c.getDescribe();
        List < Schema.PicklistEntry > ple = fieldResult.getPicklistValues();
    
        for (Schema.PicklistEntry f: ple) {
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }
        return options;
    }
    
    //Method will generate Category picklist
    public List < SelectOption > getcategoryList() {
        transient List < SelectOption > options = new List < SelectOption > ();
        options.add(new SelectOption('', '--None--'));
    
        Schema.DescribeFieldResult fieldResult = Case.Category__c.getDescribe();
        List < Schema.PicklistEntry > ple = fieldResult.getPicklistValues();
    
        for (Schema.PicklistEntry f: ple) {
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }
        return options;
    }
    
    //Method will generate SubCategory picklist
   public List < SelectOption > getsubcategoryList() {
        transient List < SelectOption > options = new List < SelectOption > ();
        options.add(new SelectOption('', '--None--'));
    
        Schema.DescribeFieldResult fieldResult = Case.Subcategory__c.getDescribe();
        List < Schema.PicklistEntry > ple = fieldResult.getPicklistValues();
    
        for (Schema.PicklistEntry f: ple) {
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }
        return options;
    }
    
    //Method will generate Classification picklist
    public List < SelectOption > getclassificationList() {
        transient List < SelectOption > options = new List < SelectOption > ();
        options.add(new SelectOption('', '--None--'));
    
        Schema.DescribeFieldResult fieldResult = Case.Classification__c.getDescribe();
        List < Schema.PicklistEntry > ple = fieldResult.getPicklistValues();
    
        for (Schema.PicklistEntry f: ple) {
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }
        return options;
    }
    /*
    //Method will generate Priority picklist
    public List<SelectOption> getdatesFilter(){
        transient List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','--None--'));
      options.add(new SelectOption('YESTERDAY','YESTERDAY'));
        options.add(new SelectOption('TODAY','TODAY'));
        options.add(new SelectOption('LAST_WEEK','LAST WEEK'));   
        options.add(new SelectOption('THIS_WEEK','THIS WEEK'));
        options.add(new SelectOption('LAST_MONTH','LAST MONTH'));
        options.add(new SelectOption('THIS_MONTH','THIS_MONTH'));
        options.add(new SelectOption('LAST_90_DAYS','LAST 90 DAYS'));
        options.add(new SelectOption('THIS_QUARTER','THIS QUARTER'));
        options.add(new SelectOption('LAST_QUARTER','LAST QUARTER'));
        options.add(new SelectOption('THIS_YEAR','THIS YEAR'));
        options.add(new SelectOption('LAST_YEAR','LAST YEAR'));        
        return options;
    }
    */
    //Method will generate Priority picklist
    public List<SelectOption> getpriorityList(){
        transient List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','--None--'));
        options.add(new SelectOption('High','High'));
        options.add(new SelectOption('Medium','Medium'));
        options.add(new SelectOption('Low','Low'));        
        return options;
    }
    
    //Method will generate Status picklist
    public List<SelectOption> getstatusList(){
        transient List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','--None--'));
        options.add(new SelectOption('New','New'));
        options.add(new SelectOption('Acknowledged-In Queue','Acknowledged-In Queue'));
        options.add(new SelectOption('On Hold','On Hold'));
        options.add(new SelectOption('In Progress','In Progress'));
		options.add(new SelectOption('Awaiting customer response','Awaiting customer response'));
        options.add(new SelectOption('Closed - Resolved','Closed - Resolved'));
        options.add(new SelectOption('Closed - Duplicate','Closed - Duplicate'));
        options.add(new SelectOption('Closed - Added for Enhancements','Closed - Added for Enhancements'));
        options.add(new SelectOption('Closed - Bug Fixed','Closed - Bug Fixed'));
        options.add(new SelectOption('Closed - Information Provided','Closed - Information Provided'));
        options.add(new SelectOption('Closed - Request Fulfilled','Closed - Request Fulfilled'));
        options.add(new SelectOption('Closed - Workaround Provided','Closed - Workaround Provided'));
        options.add(new SelectOption('Closed - Verified','Closed - Verified'));
        options.add(new SelectOption('Reopen','Reopen'));
        return options;
    }
    
    //action for Previous click
    Public PageReference Previous() {
        pageno--;
        displayList();
        return null;
    }
    //action for next click
    Public PageReference Next() {
        pageno++;
        displayList();
        return null;
    }

    Public PageReference resetPagination() {
        totalRecords = 0;
        pageNo = 1;
        lastPageno = 1;
        createPagination();
        return null;
    }

    public void createPagination() {
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
        if (listCasePage == null)
               listCasePage = new list < CaseSubClass > ();

        If(pageNo * intRecPerPage < listCaseTotal.size()) {
            for (Integer i = ((pageNo * intRecPerPage) - intRecPerPage); i < pageNo * intRecPerPage; i++) {
                listCasePage.add(listCaseTotal[i]);
            }
        } else If(pageNo * intRecPerPage >= listCaseTotal.size()) {
            for (Integer i = ((pageNo * intRecPerPage) - intRecPerPage); i < listCaseTotal.size(); i++) {
                listCasePage.add(listCaseTotal[i]);
            }

        }
    }
      
    /***
    * CaseSubClass - Sub-Class to hold Case and checkbox for the table
    ***/
    public with sharing class CaseSubClass{
        public Boolean aCheckBox {get;set;}
        public Id Id {get;set;}
        public string CaseNumber {get;set;}
        public string Subject {get;set;}
        public string Account_Name {get;set;}        
        public string Category {get;set;}
        public string Subcategory {get;set;}
        public string Priority {get;set;}
        public string Status {get;set;}
        public string OwnerName {get;set;}
        public string Project {get;set;}
        public string Geometry  {get;set;}
        public string PDK_Name {get;set;}
        public string ContactName {get;set;}
        public string Case_Record_Type {get;set;}
        public Datetime Need_by_Date {get;set;}
        public string CreatedByName {get;set;}
        public Datetime CreatedDate {get;set;}
        public Datetime LastModifiedDate {get;set;}
        public Boolean chatterCheckBox {get;set;}
        public Date expectedCloseDate {get;set;}
        public Datetime closedDate{get;set;}
        // sub-class initialization
        public CaseSubClass(Case c, Boolean chk, Boolean chatterChk){
            aCheckBox = chk;
            chatterCheckBox = chatterChk;
            Id  = c.Id ;
            CaseNumber = c.CaseNumber;
            Subject = c.Subject;
            Account_Name = c.Account_Name__c;
            Category = c.Category__c;
            Subcategory = c.Subcategory__c;
            Priority = c.Priority;
            Status = c.Status;
            OwnerName = c.Owner.Name;
            Project = c.Project__r.Name;
            Geometry  = c.Geometry__c ;
            PDK_Name = c.PDK_Name__c;
            ContactName = c.Contact.Name;
            Case_Record_Type = c.Case_Record_Type__c;
            Need_by_Date = c.Need_by_Date__c;
           CreatedByName = c.CreatedBy.Name;
            CreatedDate = c.CreatedDate;
            LastModifiedDate = c.LastModifiedDate;
            expectedCloseDate = c.Expected_Close_Date__c;
            closedDate = c.closedDate;
        }
     }  
     
    //Method removes unwanted spaces in the filtertext
    public list < string > removeSpace(list < string > stList) {
        list < string > stListtemp = new list < string > ();
        for (string st: stList) {
            stListtemp.add(st.trim());
        }
        return stListtemp;
    } 
    public void createPaginationAdv() {
        totalRecordsAdv = listCaseTotalAdv.size();
        intRecPerPageAdv = Integer.valueOf(RecPerPageAdv);
        lastPagenoAdv = listCaseTotalAdv.size() / intRecPerPageAdv; // Page size 10 rows
        if (lastPagenoAdv * intRecPerPageAdv < listCaseTotalAdv.size()) {
            lastPagenoAdv++;
        }

        if (pagenoAdv < lastPagenoAdv) {
            hasNextAdv = true;
        } else {
            hasNextAdv = false;
        }

        if (pagenoAdv > 1) {
            hasPreviousAdv = true;
        } else {
            hasPreviousAdv = false;
        }

        displayListAdv();
    }
    public void displayListAdv() {
        intRecPerPageAdv = Integer.valueOf(RecPerPageAdv);
        if (pagenoAdv < lastPagenoAdv) {
            hasNextAdv = true;
        } else {
            hasNextAdv = false;
        }
        if (pagenoAdv > 1) {
            hasPreviousAdv = true;
        } else {
            hasPreviousAdv = false;
        }
        if (listCasePageAdv == null)
               listCasePageAdv = new list < CaseSubClass > ();

        If(pageNoAdv * intRecPerPageAdv < listCaseTotalAdv.size()) {
            for (Integer i = ((pageNoAdv * intRecPerPageAdv) - intRecPerPageAdv); i < pageNoAdv * intRecPerPageAdv; i++) {
                listCasePageAdv.add(listCaseTotalAdv[i]);
            }
        } else If(pageNoAdv * intRecPerPageAdv >= listCaseTotalAdv.size()) {
            for (Integer i = ((pageNoAdv * intRecPerPageAdv) - intRecPerPageAdv); i < listCaseTotalAdv.size(); i++) {
                listCasePageAdv.add(listCaseTotalAdv[i]);
            }

        }
    }
    public PageReference ClearAllAdv(){
        searchstring = '';
        textSearch = '';
        totalRecordsAdv = 0;
        AlphaFilterAdv = 'All';
        RecPerPageAdv = '10'; //default records per page
        getCaseListAdv();
        return null;
    }
    public void SortToggleAdv() {
        SortDirectionAdv = SortDirectionAdv.equals('asc') ? 'desc NULLS LAST' : 'asc';
        // reset alpha filter and sort sequence when sorted field is changed
        if (SortFieldSaveAdv != SortFieldAdv) {
            SortDirectionAdv = 'asc';
            AlphaFilterAdv = 'All';
            SortFieldSaveAdv = SortFieldAdv;
        }
        // run the query again
       getCaseListAdv();
    }
    Public PageReference PreviousAdv() {
        pagenoAdv--;
        displayListAdv();
        return null;
    }
    Public PageReference NextAdv() {
        pagenoAdv++;
        displayListAdv();
        return null;
    }
    Public PageReference resetPaginationAdv() {
        totalRecordsAdv = 0;
        pageNoAdv = 1;
        lastPagenoAdv = 1;
        createPaginationAdv();
        return null;
    }
    public String SortDirectionAdv {
        get { if (SortDirectionAdv == null) {  SortDirectionAdv = 'asc'; } return SortDirectionAdv;  }
        set;
    }
    public String SortFieldAdv {
        get { if (SortFieldAdv == null) {SortFieldAdv = 'Subject'; } return SortFieldAdv;  }
        set; 
    }
    public PageReference SearchCaseAdv() { 
        getCaseListAdv();
        return null;
    }
    public void getCaseListAdv() {
    caseId.clear();
    //checkFlag = false;
    textSearch = textSearch.trim();
    string lengthChk = textSearch.replaceAll('[^a-zA-Z0-9]', '');
    lengthChk = lengthChk.trim();    
    List < List < sObject >> lstListObj = new List < List < sObject >> ();
    Map <string,boolean> caseFromChatter = new Map <string,boolean>();
    String searchStr = '';        
        if (listCaseTotalAdv != null)
            listCaseTotalAdv.clear();
            if (!String.isBlank(textSearch)) {
                if (lengthChk.length() <= 1) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, errorMsg));
                }
                else if(searchstring == 'all') {
                        textSearch = textSearch.replace('//', '////');
                        textSearch = textSearch.replace('\\', '\\\\');
                        textSearch = '"' + textSearch + '"';
                        String searchQuery = 'FIND \'' + textSearch + '\' IN ALL FIELDS RETURNING FeedItem(ParentId),Case(Id)';
                        lstListObj = search.query(searchquery);
                        List < FeedItem > feedItemlist = lstListObj[0];
                        List < Case> caseListTemp = lstListObj[1];
                        for (Case caseTemp: caseListTemp) {
                            caseId.add(caseTemp.Id);
                        }
                        for (feeditem feed: feedItemlist) {
                            if(!caseId.contains(feed.ParentId)){
                                caseId.add(feed.ParentId);
                                caseFromChatter.put(feed.ParentId,true);
                            }
                        }          
               } 
               else if (searchstring == 'any') {
                        list < string > textSearchFilter = new list < string > ();
                        textSearchFilter = textSearch.split(' ');
                        textSearchFilter = removespace(textSearchFilter);
                        for (string str: textSearchFilter) {
                            searchStr += '\"' + str + '\"' + ' OR ';
                        }
                        searchStr = searchStr.substring(0, searchStr.length() - 4);
                        String searchQuery = 'FIND \'' + searchStr + '\' IN ALL FIELDS RETURNING FeedItem(ParentId),case(Id)';
                        lstListObj = search.query(searchquery);
                        List < FeedItem > feedItemlist = lstListObj[0];
                        List < case> caseListTemp = lstListObj[1];
                        for (case caseTemp: caseListTemp ) {
                            caseId.add(caseTemp.Id);
                        }
                        for (feeditem feed: feedItemlist) {
                            if(!caseId.contains(feed.ParentId)){
                                caseId.add(feed.ParentId);
                                caseFromChatter.put(feed.ParentId,true);
                            }
                        }                          
                }
                if (!caseId.isEmpty()) {
                    if (AlphaFilterAdv == null || AlphaFilterAdv.trim().length() == 0) {
                        AlphaFilterAdv = 'All';
                    }
                        QueryCaseAdv = 'SELECT Id, CaseNumber, ContactId, Contact.Name, Description, Priority, Category__c , Status , Subject , PDK_Name__c, Geometry__c , Project__c, Project__r.Name, CreatedBy.Id , Account_Name__c, SubCategory__c ,' + 
                                        'Classification__c , ClosedDate, CreatedDate, Case_Record_Type__c, OwnerId, Owner.Name, Origin,Age_of_Case__c, Contact_Name__c,' +  
                                        'Need_by_Date__c, Expected_Close_Date__c, CreatedById, CreatedBy.Name,LastModifiedDate ' +
                                        ' FROM Case'+' WHERE ' + ' id IN: caseId ';
                    if (AlphaFilterAdv == 'Other') {
                        QueryCaseAdv += 'AND ' +'(' + String.escapeSingleQuotes(SortFieldAdv) + ' < \'A\' OR ' + 
                                                  String.escapeSingleQuotes(SortFieldAdv) + ' > \'Z\') AND (NOT ' + 
                                                  String.escapeSingleQuotes(SortFieldAdv) + ' LIKE \'Z%\')';                                    
                    }
                    else if (AlphaFilterAdv != 'All') {
                        QueryCaseAdv += 'AND ' + '(' + String.escapeSingleQuotes(SortFieldAdv) + ' LIKE \'' + String.escapeSingleQuotes(AlphaFilterAdv) + '%\')' ;
                    }
                    if(UserInfo.getUserType() != 'Standard'){
                        QueryCaseAdv += ' AND '  + ' (Internal_or_external__c = false)'  + ' AND ' +' (Case_Record_Type_API__c  NOT IN (\'Internal_Case\'))';
                    }
                    QueryCaseAdv += ' ORDER BY ' + String.escapeSingleQuotes(SortFieldAdv) + ' ' + String.escapeSingleQuotes(SortDirectionAdv);
                    if(UserInfo.getUserType() == 'Standard'){
                        QueryCaseAdv += ' LIMIT 500';
                    }else{
                        QueryCaseAdv += ' LIMIT 2000';
                    }        
                    transient list < Case > listCase = new list < Case > ();        
                    transient List < UserRecordAccess > listUserRecordAccess = new List < UserRecordAccess > ();
                    transient List < Id > setCaseIds = new List < Id > ();
                    transient Set < Id > setRecordIds = new Set < Id > ();
                    transient boolean noSort = false;
                    transient boolean noSortClosedDate = false;
                    transient boolean noSortExpectedDate = false;
                    if(SortFieldAdv == 'CreatedDate' && AlphaFilterAdv != 'All'){
                        noSort = true;    
                    }
                    if(SortFieldAdv == 'ClosedDate' && AlphaFilterAdv != 'All'){
                        noSortClosedDate = true;    
                    }                    
                    if((SortFieldAdv == 'Expected_Close_Date__c') && AlphaFilterAdv != 'All'){
                        noSortExpectedDate = true;    
                    }                               
                if(noSort == false && noSortExpectedDate == false && noSortClosedDate == false){
                    listCase = Database.Query(QueryCaseAdv);
                }                    
                    if(QueryCaseAdv != null){
                        if(noSort == false && noSortExpectedDate == false && noSortClosedDate == false){
                        listCase = Database.Query(QueryCaseAdv);
                        }
                    }
                    if(listCase.size()>0){
                        if (UserInfo.getUserType() != 'Standard') {                
                            for (Case c: listCase) {
                                //to avoid Number of records exceeds limit: 200 
                                if (setCaseIds.size() != 200) {
                                    setCaseIds.add(c.Id);
                                } else if (setCaseIds.size() == 200) {
                                    listUserRecordAccess.addall(getUserRecordAccessList(setCaseIds));
                                    setCaseIds.clear();
                                }
                            }
                            if (setCaseIds.size() > 0) {
                                listUserRecordAccess.addall(getUserRecordAccessList(setCaseIds));
                                setCaseIds.clear();
                            }
                
                            for (UserRecordAccess ura: listUserRecordAccess) {
                                if (ura.HasReadAccess) {
                                    setRecordIds.add(ura.RecordId);
                                }
                            }
                            for (Case c: listCase) {
                                if (setRecordIds.contains(c.Id) && listCaseTotalAdv.size() < 500) {
                                    if(caseFromChatter.containsKey(c.Id)){
                                        listCaseTotalAdv.add(new CaseSubClass(c,true,true));
                                    }
                                    else{
                                        listCaseTotalAdv.add(new CaseSubClass(c,true,false));
                                    }
                                }
                            }
                        } else {
                            for (Case c: listCase) {
                                    if(caseFromChatter.containsKey(c.Id)){
                                        listCaseTotalAdv.add(new CaseSubClass(c,true,true));
                                    }
                                    else{
                                        listCaseTotalAdv.add(new CaseSubClass(c,true,false));
                                    }
                            }
                        }
                    }                                
        
                }
                                
        }       
        if (exptypeAdv == 'excel') {
            if (listCasePageAdv == null){listCasePageAdv = new list < CaseSubClass > ();}
            listCasePageAdv.addall(listCaseTotalAdv);
            totalRecordsAdv = listCaseTotalAdv.size();
        }else{
            resetPaginationadv();
        }        
    } 
    /***
    * ExporttoExcel - export Case result into excel
    ***/
    public pageReference ExporttoExcelAdv() {
        PageReference pageRef;
        if (totalRecordsAdv != null && totalRecordsAdv > 0) {
            transient string url;
            url = '/apex/CaseSearchExcel';
            url += '?exptypeAdv=excel'+'&param=adv';
            exptypeAdv = 'excel';
            getCaseListAdv();
            pageRef = new PageReference(url);
            pageRef.setRedirect(false);
        }
        return pageRef;
    }   
           
}