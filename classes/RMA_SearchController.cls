/**
* Company       :   Cognizant Technologies PTE Ltd.
* Description   :   This is the controller class for RMA_Search page.
* History       :   

        Initials        Date          Description
-----------------------------------------------------------------------------------------
        Nikhil Jain    16-Oct-15      Created the Class
**/

public without sharing class RMA_SearchController{

    // RMA and selection set/variables
    public List<RMASubClass> listCaseTotal{get; set;}
    public transient List <RMASubClass> listRMAPage{get; set;}
 
    // selection and filter 
    public list<String> AlphaList {get; set;}
    public String AlphaFilter {get; set;}
    public String CustomerName {get; set;}
    public String SearchRMANumber{get; set;}
    public String RMAcategory {get; set;}
    public String stage {get; set;}
    public String region{get; set;}
    public String fabName {get; set;}
    public String owner{get; set;}
    public String fileName{get; set;}
    public Integer totalRecords{get; set;}
    public String createdDate {get; set;}
    public String cdDateFromStr {get;set;}
    public String cdDateToStr {get;set;}
    private Date cdDateFrom {get;set;}
    private Date cdDateTo {get;set;}
    public String lmDateFromStr {get;set;}
    public String lmDateToStr {get;set;}
    private Date lmDateFrom {get;set;}
    private Date lmDateTo {get;set;}
    public String lastModifiedDate {get; set;}
    
    public transient String QueryRMA;
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
    public Boolean isAMDOnly{get; set;}
    public Boolean isLoad=false;    
    public Boolean isFoundryView {get;set;}
    public String exportUrl{get;set;}
    private List<String> rmaStageFilters;
    private boolean hasError;
      
    /***
    * RMASearchController - Constructor initialization
    ***/
    public RMA_SearchController(){
        isFoundryView = userinfo.getUserType() != 'Standard';
        hasError = false;
        expType = ApexPages.currentPage().getParameters().get('exptype');
        rmaStageFilters =  new String[]{};
        listCaseTotal = new list<RMASubClass>();
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
        
        String emailAddress = UserInfo.getUserEmail();
        if(emailAddress.contains('amd.com')){isAMDOnly = true;}        
        
        if(isFoundryView){
            rmaStageFilters = getFoundryViewStageFilters();
			
            //prevent from calling multiple times during export & communityview.
            if(String.isBlank(exptype)){
                User u = [select accountID from user where id=:userInfo.getUserid()];
                List<Account> accList = new List<Account>([select id, Short_Name__c from account where id = : u.accountId]);
                if(!accList.isempty()){
                    CustomerName= accList[0].Short_Name__c;
                    getRMAList();
                }
            }
        }
        if(isNotBlank(expType)){
            getParameters();  
            getRMAList();                     
        }
    }
     /***
    * This method is used for getting values from Page URL.
    ***/  
    public void getParameters() {

        Datetime myDT = Datetime.now();
        fileName = myDT.format('MM-dd-yyy h:mm a');
    
        this.CustomerName = isNotBlank(ApexPages.currentPage().getParameters().get('CustomerName')) ?
            ApexPages.currentPage().getParameters().get('CustomerName') : null;
        this.SearchRMANumber = isNotBlank(ApexPages.currentPage().getParameters().get('SearchRMANumber')) ?
            ApexPages.currentPage().getParameters().get('SearchRMANumber') : null;
        this.RMAcategory = isNotBlank(ApexPages.currentPage().getParameters().get('RMAcategory')) ?
            ApexPages.currentPage().getParameters().get('RMAcategory') : null;
        this.stage = isNotBlank(ApexPages.currentPage().getParameters().get('stage')) ?
            ApexPages.currentPage().getParameters().get('stage') : null;
        this.region = isNotBlank(ApexPages.currentPage().getParameters().get('region')) ?
            ApexPages.currentPage().getParameters().get('region') : null;
        this.fabName = isNotBlank(ApexPages.currentPage().getParameters().get('fabName')) ?
            ApexPages.currentPage().getParameters().get('fabName') : null;
        this.owner = isNotBlank(ApexPages.currentPage().getParameters().get('owner')) ?
            ApexPages.currentPage().getParameters().get('owner') : null;
        this.cdDateFrom = isNotBlank(ApexPages.currentPage().getParameters().get('cdDateFrom')) ?
            Date.valueOf(ApexPages.currentPage().getParameters().get('cdDateFrom')) : null;
        this.cdDateTo = isNotBlank(ApexPages.currentPage().getParameters().get('cdDateTo')) ?
            Date.valueOf(ApexPages.currentPage().getParameters().get('cdDateTo')) : null;            
        this.lastModifiedDate = isNotBlank(ApexPages.currentPage().getParameters().get('lastModifiedDate')) ?
            ApexPages.currentPage().getParameters().get('lastModifiedDate') : null;
        this.AlphaFilter = isNotBlank(ApexPages.currentPage().getParameters().get('AlphaFilter')) ?
            ApexPages.currentPage().getParameters().get('AlphaFilter') : null;
        this.SortField = isNotBlank(ApexPages.currentPage().getParameters().get('SortField')) ?
            ApexPages.currentPage().getParameters().get('SortField') : null;
    }
    
    public void getRMAList() {
        
        if (listCaseTotal != null)
            listCaseTotal.clear();
        if (isNotBlank(CustomerName) || isNotBlank(SearchRMANumber) || 
            isNotBlank(RMAcategory) || isNotBlank(stage) ||
            isNotBlank(region) || isNotBlank(fabName) || 
            isNotBlank(owner) || 
            cdDateFrom != null || cdDateTo !=null || lmDateFrom != null || lmDateTo != null
            ){
            
            transient List <RMA__c> listCase = new List<RMA__c>();        
            transient List <UserRecordAccess> listUserRecordAccess = new List <UserRecordAccess>();
            transient List <Id> setCaseIds = new List<Id>();
            transient Set  <Id> setRecordIds = new Set<Id>();
    
            BuildQuery();
            listCase = Database.Query(QueryRMA);
            if(listCase.size()>0){
                if (UserInfo.getUserType() == 'Standard') {
                    for (RMA__c c: listCase) {
                        //to avoid Number of records exceeds limit: 200
                        if (setCaseIds.size() != 200){
                            setCaseIds.add(c.Id);
                        }else if (setCaseIds.size() == 200) {
                            listUserRecordAccess.addall(getUserRecordAccessList(setCaseIds));
                            setCaseIds.clear();
                        }
                        //setCaseIds.add(c.Id);
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
                    for (RMA__c c: listCase) {
                        if (setRecordIds.contains(c.Id) && listCaseTotal.size() < 1000) {
                            listCaseTotal.add(new RMASubClass(c, isFoundryView));
                       }
                    }
                } else {
                    for (RMA__c c: listCase) {
                        listCaseTotal.add(new RMASubClass(c, isFoundryView));
                    }
                }
            }      
        }        
        if (exptype == 'excel') {
            if (listRMAPage == null){listRMAPage = new list <RMASubClass>();}
            listRMAPage.addall(listCaseTotal);
            totalRecords = listCaseTotal.size();
        }else{
            resetPagination();
        }        
    }
    
    /***
    * getUserRecordAccessList- return UserRecordAccess list for portal users
    ***/    
    public list<UserRecordAccess> getUserRecordAccessList(List <Id> setCaseIds) {        
        List <UserRecordAccess> listUserRecordAccess = 
                        [SELECT RecordId, HasEditAccess, HasReadAccess FROM UserRecordAccess 
                        WHERE UserId = : UserInfo.getUserId() AND RecordId In: setCaseIds Limit 200];
        
        return listUserRecordAccess;
    }
    
    /***
    * ClearCaseSelectedSet - remove selected Cases and initialize counter
    ***/
    public PageReference ClearAll(){
        CustomerName = isFoundryView ? customerName : '';
        exportUrl = '';
        SearchRMANumber = '';
        RMAcategory ='';
        stage ='';
        region ='';
        fabName ='';
        owner ='';
        createdDate ='';
        lastModifiedDate ='';
        AlphaFilter = 'All'; 
        totalRecords = 0;
        AlphaFilter = 'All';
        RecPerPage = '10'; //default records per page
        // list generation
        getRMAList();
        return null;
    }
 
    /***
    * SearchCase - set search criteria fields and refresh Case table
    ***/
    public PageReference SearchCase() { 
        exportUrl = '';
        if(validateDates()){
            getRMAList();
        }
        return null;
    }
    
     private boolean validateDates(){
        boolean isValid = true;
        try{
            cdDateFrom = String.isNotblank(cdDateFromStr) ? Date.parse(cdDateFromStr) : null;
            cdDateTo =  String.isNotblank(cdDateToStr) ? Date.parse(cdDateToStr) : null;
            if(!isFoundryView){
                lmDateFrom = String.isNotblank(lmDateFromStr) ? Date.parse(lmDateFromStr) : null;
                lmDateTo =  String.isNotblank(lmDateToStr) ? Date.parse(lmDateToStr) : null;
            }
        }catch(Exception e){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please enter valid date in dd/mm/yyyy.'));
            isValid = false;
        }
        return isValid;
    }
 
    /***
    * BuildQuery - build query command for list selection change
    ***/
    public void BuildQuery() {
        String QueryWhere = '';
 
        if (AlphaFilter == null || AlphaFilter.trim().length() == 0) {
            AlphaFilter = 'All';
        }
 
        QueryRMA = 'SELECT Id, Name, Region__c, RMA_Category__c ,Status__c,Workflow_Stage__c, Lot_Device_Risk_Production__c, CreatedBy.Id , ' + 
                    'Fab__c , CreatedDate, OwnerId, Owner.Name, CreatedById, CreatedBy.Name,LastModifiedDate,Return_Estimated_Date__c, ' +
                    'Customer__r.Name, Customer__r.Short_Name__c, Total_Wafers_Final__c, Grand_Total_Final__c, CN_DN_Number__c, Customer_Request_Date__c FROM RMA__c';
        
        if (AlphaFilter == 'Other') {
            QueryWhere = BuildWhere(QueryWhere, '(' + String.escapeSingleQuotes(SortField) + ' < \'A\' OR ' + 
                                    String.escapeSingleQuotes(SortField) + ' > \'Z\') AND (NOT ' + 
                                    String.escapeSingleQuotes(SortField) + ' LIKE \'Z%\') ');
        } else if (AlphaFilter != 'All') {
            QueryWhere = BuildWhere(QueryWhere, '(' + String.escapeSingleQuotes(SortField) + ' LIKE \'' + String.escapeSingleQuotes(AlphaFilter) + '%\')' );
        }
             
        if (CustomerName != null && CustomerName !='') {
            if(isFoundryView){
                QueryWhere = BuildWhere(QueryWhere, ' (Customer__r.Short_Name__c =\'' + String.escapeSingleQuotes(CustomerName) + '\')');
            }else{
                QueryWhere = BuildWhere(QueryWhere, ' (Customer__r.Name LIKE \'%' + String.escapeSingleQuotes(CustomerName) + '%\')');
            }
        }
        if (SearchRMANumber != null && SearchRMANumber !='') {
            QueryWhere = BuildWhere(QueryWhere, ' (Name LIKE \'%' + String.escapeSingleQuotes(SearchRMANumber) + '%\')');
        }
        if (stage != null && stage !='') {
            if(isFoundryView && stage == 'Pending for Approval'){
                for (Integer i = 0; i < rmaStageFilters.size(); i++) {
                    if (rmaStageFilters.get(i) == RMA_Constants.CLOSED_RMA){
                        rmaStageFilters.remove(i);
                        i--;
                    }
                }
                QueryWhere = BuildWhere(QueryWhere, ' (Workflow_Stage__c IN :rmaStageFilters' + ')');
            }else{
                QueryWhere = BuildWhere(QueryWhere, ' (Workflow_Stage__c LIKE \'%' + String.escapeSingleQuotes(stage) + '%\')');
            }
        }
        if (region != null && region !='') {
            QueryWhere = BuildWhere(QueryWhere, ' (Region__c LIKE \'%' + String.escapeSingleQuotes(region) + '%\')');
        }
        if (RMAcategory != null && RMAcategory !='') {
            QueryWhere = BuildWhere(QueryWhere, ' (RMA_Category__c LIKE \'%' + String.escapeSingleQuotes(RMAcategory) + '%\')');
        }
        if (fabName != null && fabName !='') {
            QueryWhere = BuildWhere(QueryWhere, ' (Fab__c LIKE \'%' + String.escapeSingleQuotes(fabName) + '%\')');
        }
        if (owner != null && owner !='') {
            QueryWhere = BuildWhere(QueryWhere, ' (Owner.Name LIKE \'%' + String.escapeSingleQuotes(owner) + '%\')');            
        }
        if(cdDateFrom != null){
            QueryWhere = BuildWhere(QueryWhere, ' (DAY_ONLY(convertTimezone(CreatedDate)) >= :cdDateFrom)');
        }
        if(cdDateTo != null){
            QueryWhere = BuildWhere(QueryWhere, ' (DAY_ONLY(convertTimezone(CreatedDate)) <= :cdDateTo)');
        }
        
        if(isFoundryView && String.isBlank(stage)){
            rmaStageFilters.add(RMA_Constants.CLOSED_RMA);
            QueryWhere = BuildWhere(QueryWhere, ' (Workflow_Stage__c IN :rmaStageFilters' + ')');     
        }
                
        QueryRMA += QueryWhere;
        QueryRMA += ' ORDER BY ' + String.escapeSingleQuotes(SortField) + ' ' + String.escapeSingleQuotes(SortDirection);   
        
        if(UserInfo.getUserType() == 'Standard'){
            QueryRMA += ' LIMIT 1000';
        }else{
            QueryRMA += ' LIMIT 3000';
        }        
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
       getRMAList();
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
        exportUrl = '';
        if(validateDates()){
            if (totalRecords != null && totalRecords > 0) {
                transient string url;
        
                if (UserInfo.getUserType() != 'Standard') {
                    url = '/GlobalfoundryView/apex/RMA_SearchExport';
                }
                else{
                    url = '/apex/RMA_SearchExport';
                }
        
                url += '?exptype=excel';
        
                if (CustomerName != null && CustomerName != '') {
                    url += '&CustomerName=' + CustomerName;
                }
                if (SearchRMANumber != null && SearchRMANumber != '') {
                    url += '&SearchRMANumber=' + SearchRMANumber;
                }
                if (stage != null && stage != '') {
                    url += '&stage=' + stage;
                }
                if (region != null && region != '') {
                    url += '&region=' + region;
                }
                if (RMAcategory != null && RMAcategory != '') {
                    url += '&RMAcategory=' + RMAcategory;
                }
                if (fabName != null && fabName != '') {
                    url += '&fabName=' + fabName;
                }
                if (owner != null && owner != '') {
                    url += '&owner=' + owner;
                }
                if (cdDateFrom != null) {
                    url += '&cdDateFrom=' + cdDateFrom;
                }
                if (cdDateTo != null) {
                    url += '&cdDateTo=' + cdDateTo;
                }
                if (lastModifiedDate != null && lastModifiedDate != '') {
                    url += '&lastModifiedDate=' + lastModifiedDate;
                }
                if (AlphaFilter != null && AlphaFilter != '') {
                    url += '&AlphaFilter=' + AlphaFilter;
                }
                if (SortField != null && SortField != '') {
                    url += '&SortField=' + SortField;
                }
                exportUrl = url;
                pageRef = new PageReference(url);
                pageRef.setRedirect(true);
            }
        }
        return null;
    }
    
    //Method will generate RMAcategory picklist
    public List < SelectOption > getRMAcategoryList() {
        transient List < SelectOption > options = new List <SelectOption> ();
        options.add(new SelectOption('', '--None--'));
    
        Schema.DescribeFieldResult fieldResult = RMA__c.RMA_Category__c.getDescribe();
        List <Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
    
        for (Schema.PicklistEntry f: ple) {
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }
        return options;
    }
    
    //Method will generate Fab picklist
    public List < SelectOption > getFabNameList() {
        transient List <SelectOption> options = new List <SelectOption>();
        options.add(new SelectOption('', '--None--'));
    
        Schema.DescribeFieldResult fieldResult = RMA__c.Fab__c.getDescribe();
        List < Schema.PicklistEntry > ple = fieldResult.getPicklistValues();
    
        for (Schema.PicklistEntry f: ple) {
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }
        return options;
    }
    
    //Method will generate Region picklist
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
    
    //Method will generate Region picklist
    public List<SelectOption> getRegionList(){
        transient List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','--None--'));
        Schema.DescribeFieldResult fieldResult = Account.Region__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
    
        for (Schema.PicklistEntry f: ple) {
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }
        return options;
    }
    
    //Method will generate Workflow Stage picklist
    public List<SelectOption> getStageList(){
        transient List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','--None--'));
        
        if(!isFoundryView){
            options.add(new SelectOption(RMA_Constants.RMA_RAISED,RMA_Constants.RMA_RAISED));
            options.add(new SelectOption(RMA_Constants.VOIDED_RMA,RMA_Constants.VOIDED_RMA));
            options.add(new SelectOption(RMA_Constants.REJECTED_RMA,RMA_Constants.REJECTED_RMA));
            options.add(new SelectOption(RMA_Constants.PEN_FAB_VAL,RMA_Constants.PEN_FAB_VAL));
            options.add(new SelectOption(RMA_Constants.PEN_TNK_VAL,RMA_Constants.PEN_TNK_VAL));
            options.add(new SelectOption(RMA_Constants.PEN_NONFAB_VAL,RMA_Constants.PEN_NONFAB_VAL));
            options.add(new SelectOption(RMA_Constants.PEN_REG_DIR,RMA_Constants.PEN_REG_DIR));
            options.add(new SelectOption(RMA_Constants.PEN_REG_VP,RMA_Constants.PEN_REG_VP));
            options.add(new SelectOption(RMA_Constants.PEN_REG_SVP,RMA_Constants.PEN_REG_SVP));
            options.add(new SelectOption(RMA_Constants.PEN_REC_WAF,RMA_Constants.PEN_REC_WAF));
            options.add(new SelectOption(RMA_Constants.PEN_SCR_CRT,RMA_Constants.PEN_SCR_CRT));
            options.add(new SelectOption(RMA_Constants.PEN_REC_SCR,RMA_Constants.PEN_REC_SCR));
            options.add(new SelectOption(RMA_Constants.DIS_NOT_DEF,RMA_Constants.DIS_NOT_DEF));
            options.add(new SelectOption(RMA_Constants.PEN_FIN_MGR,RMA_Constants.PEN_FIN_MGR));
            options.add(new SelectOption(RMA_Constants.PEN_FIN_CORP,RMA_Constants.PEN_FIN_CORP));
            options.add(new SelectOption(RMA_Constants.PEN_FIN_FABDIR,RMA_Constants.PEN_FIN_FABDIR));
            options.add(new SelectOption(RMA_Constants.PEN_FIN_PRC,RMA_Constants.PEN_FIN_PRC));
            options.add(new SelectOption(RMA_Constants.PEN_FIN_VPFIN,RMA_Constants.PEN_FIN_VPFIN));
        }
        
        options.add(new SelectOption('Pending for Approval', 'Pending for Approval'));
        options.add(new SelectOption(RMA_Constants.PEN_CN_ISS,RMA_Constants.PEN_CN_ISS));
        options.add(new SelectOption(RMA_Constants.PEN_SO_ISS,RMA_Constants.PEN_SO_ISS));
        options.add(new SelectOption(RMA_Constants.CLOSED_RMA,RMA_Constants.CLOSED_RMA));
        
        if(!isFoundryView){
            options.add(new SelectOption(RMA_Constants.PEN_PRD_ENG,RMA_Constants.PEN_PRD_ENG));
            options.add(new SelectOption(RMA_Constants.PEN_PRD_MGR,RMA_Constants.PEN_PRD_MGR));
            options.add(new SelectOption(RMA_Constants.PEN_PRD_DIR,RMA_Constants.PEN_PRD_DIR));
        }
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
        if (listRMAPage == null)
               listRMAPage = new list <RMASubClass> ();

        If(pageNo * intRecPerPage < listCaseTotal.size()) {
            for (Integer i = ((pageNo * intRecPerPage) - intRecPerPage); i < pageNo * intRecPerPage; i++) {
                listRMAPage.add(listCaseTotal[i]);
            }
        } else If(pageNo * intRecPerPage >= listCaseTotal.size()) {
            for (Integer i = ((pageNo * intRecPerPage) - intRecPerPage); i < listCaseTotal.size(); i++) {
                listRMAPage.add(listCaseTotal[i]);
            }

        }
    }
    
    private List<String> getFoundryViewStageFilters(){
        String[] filters = new String[]{};
        for(String picklistVal : Rma_utility.getPickListValues('RMA__c', 'Stage__c')){
            if(picklistVal.startsWith('Pending')){
                filters.add(picklistVal);
            }
        }
        filters.add(RMA_Constants.CLOSED_RMA);
        return filters;
    }
    
    /***
    * RMASubClass - Sub-Class to hold Case and checkbox for the table
    ***/
    public with sharing class RMASubClass{
        public Id Id{get;set;}
        public string SearchRMANumber{get;set;}
        public string RMAcategory {get;set;}
        public string Region{get;set;}
        public string stage {get;set;}
        public string Status{get;set;}
        public string OwnerName {get;set;}
        public string Product{get;set;}
        public string CreatedByName {get;set;}
        public Datetime CreatedDate {get;set;}
        public Datetime LastModifiedDate {get;set;}
        public String FabName{get;set;}
        public String CustomerName{get;set;}
        public Integer Total_Wafers_Final{get;set;}
        public Decimal Grand_Total_Final{get;set;}
        public Datetime Customer_Request_Date{get;set;}
        public String CN_DN_Number{get;set;}
        private boolean isFoundryView {get;set;}
        // sub-class initialization
        public RMASubClass(RMA__c c, Boolean isFoundryView){
            this.isFoundryView = isFoundryView;
            Id  = c.Id ;
            SearchRMANumber = c.Name;
            CustomerName = c.Customer__r.Name;
            RMAcategory = c.RMA_Category__c;
            Region = c.Region__c;
            if(isFoundryView){
                Stage = (c.Workflow_Stage__c == RMA_Constants.CLOSED_RMA || 
                         c.Workflow_Stage__c == RMA_Constants.PEN_SO_ISS || 
                         c.Workflow_Stage__c == RMA_Constants.PEN_CN_ISS) ? c.Workflow_Stage__c : 'Pending for Approval';
            }else{
                Stage = c.Workflow_Stage__c;    
            }
           
            OwnerName = c.Owner.Name;
            Product = c.Lot_Device_Risk_Production__c;
            CreatedByName = c.CreatedBy.Name;
            CreatedDate = c.CreatedDate;
            LastModifiedDate = c.LastModifiedDate;
            FabName = c.Fab__c;
            Status = c.Status__c;
            Total_Wafers_Final = (Integer)c.Total_Wafers_Final__c;
            Grand_Total_Final = c.Grand_Total_Final__c;
            CN_DN_Number = c.CN_DN_Number__c;
            Customer_Request_Date = c.Customer_Request_Date__c;
        }
    }
}