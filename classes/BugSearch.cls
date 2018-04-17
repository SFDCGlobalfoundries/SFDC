/*Author: Karthick D
* Description: This class created to search bugs with advanced filter criteria.
* History: Created on 7/6/2014
           Modified on 08/21/2014 for code enhancement
           Modified on 10/20/2104 for adding new filters and export option.
           Modified by Shuchi for Case #00052659 
*/
public with sharing class BugSearch {

    private final Map < String, Schema.SObjectType > globalDescribe = Schema.getGlobalDescribe(); 
    public list<bug__c> bugList = new list<bug__c>();
    public list<bug__c> bugListExcel = new list<bug__c>();
    public string stQueryFilter;
    public list <string> stStatusFilter, stProductFilter, stComponentFilter, stPriorityFilter, stSeverityFilter, 
                        stBugClassFilter, stBugNoFilter, stVersionFilter, stBugzillaIdFilter,stSubstrateFilter,
                        stEncapsulationFilter,stInterconnectFilter,stPackageFilter,stSimulationTypeFilter,stDieSizeFilter,stProductSimulationFilter,stSimulationBugNoFilter,
                        stSimulationStatusFilter,stsimulationbugtitleFilter;
    
    public bug__c bug = new bug__c();
    public bug__c bug1 = new bug__c();
    public Bug_Team__c bgTeam = new Bug_Team__c ();
    
    public string stTempbugTitle;    
    public string stBugzillaId {get;set;}
    public string stStatus {get;set;}
    public string stProduct {get;set;}    
    public string stComponent {get;set;}  
    //public string stProduct1 {get;set;}    
    //public string stComponent1 {get;set;}  
    public string stPriority {get;set;}
    public string stSeverity {get;set;}
    public string stBugClass {get;set;}
    public string stBugNo {get;set;}
    public string stVersion {get;set;} 
    public string stSimulationBugNo {get;set;}
    public string stSimulationStatus {get;set;}
     
    public string stSubstrate {get;set;}
    public string stEncapsulation {get;set;}
    public string stInterconnect {get;set;}
    public string stPackage  {get;set;}
    public string stSimulationType {get;set;}
    public string stDieSize {get;set;}
    public string stProductSimulation {get;set;} 
     
    public string sortField {get;set;}
    public String previousSortField {get; set;}    
    public String sortOrder {get; set;}   
    public string sortFieldAdvSearch {get;set;}
    public String previousSortFieldAdvSearch {get; set;}
    public String sortOrderAdvSearch {get; set;}
    
    public boolean stFilter {get;set;}
    
    public boolean simulationFlag {get;set;}
    
    public String stOwner {get;set;}
    public String stCreatedBy {get;set;}
    public string stbugtitle {get;set;}
    public string stsimulationbugtitle {get;set;}
    public string checkUserSearchCon{get;set;}
    public string stRelatedDmmNumber {get;set;}
    public ApexPages.StandardSetController con {get;set;}
   // List for multi select   
   
    public list<SelectOption> statusList {get;set;}
    public list<SelectOption> priorityList {get;set;}
    public list<SelectOption> severitylist {get;set;}
    public list<SelectOption> productList {get;set;}
    public list<SelectOption> componentList {get;set;}
    public list<SelectOption> bugClassList {get;set;}
    public list<SelectOption> bugVerionList {get;set;}    
    public list<string> bugDmmNumberList {get;set;}
    
    public list<SelectOption> substrateList {get;set;}
    public list<SelectOption> encapsulationList {get;set;}
    public list<SelectOption> interconnectList {get;set;}
    public list<SelectOption> packageTypelist {get;set;}
    public list<SelectOption> simulationTypeList {get;set;}
    public list<SelectOption> dieSizeList {get;set;}
    public list<SelectOption> productSimulationList {get;set;}
    
    
    private integer counter=0;  //keeps track of the offset
    private integer list_Size=10; //sets the page size or number of rows
    public integer total_Size; //used to show user the total size of the list
    public integer total_Limit = 5000;
    
    private integer counterAdvSearch=0;  //keeps track of the offset
    private integer list_Size_AdvSearch=10; //sets the page size or number of rows
    public integer total_Size_AdvSearch; //used to show user the total size of the list
    
    //added for Advance Search
    public boolean isAdvSearch{get;set;}
    public string errorMsg = BugErrorMessages__c.getValues('AdvBugSearchError').Error_Message__c;
    public boolean checkFlag{get;set;}
    Transient public list<bug__c> bugListAdvSearch = new list<bug__c>();
    public list<bug__c> bugListExcelAdvSearch = new list<bug__c>();
    public string stQueryFilterAdvSearch{get;set;}  
    public set<string> bugId = new set<string>();
    public string textSearch {get;set;}
    public string searchstring{get;set;}
    

    public String createdBy{get; set;}
    public String createdByIds{get; set;}
    
    public String sCreatedBy{get; set;}
    public String sCreatedByIds{get; set;}
    
    public Boolean ClearFlagParent{get; set;}
    public List<UserWrap> listuserWrapper{get; set;}
    public List<UserWrap> listuserWrapperSelected{get; set;}
    public string userSearchString{get;set;}
    Public boolean displayResult{get;set;}
    Public boolean displayReadOnly{get;set;}
    public string searchUserString{get;set;}
    public string searchUserId{get;set;}
    public boolean clearFlag{get;set;}
    
    public string UserString{get;set;}
    public string UserId{get;set;}
    public boolean clearFlagCheck{get;set;}
    public string userIdsFromURL{get;set;}
    
    public Integer totalRecords{get; set;}
    //Pagination variable 
    Public Boolean hasPrevious {get;set;}
    Public Boolean hasNext {get;set;}
    Public Integer pageNo {get;set;}
    Public Integer lastPageno {get;set;}
    Public Integer intRecPerPage{get;set;}
    public String RecPerPage {get; set;}
    //Public Integer intRecPerPage{get;set;}
    public list <UserWrap> listUserPage {get; set;}
    public boolean searchflag{get;set;} 
    public List<string> useridString{get;set;}
    
    String simulationRecord = System.Label.BugSimulationRecordTypeName;
    
    public BugSearch(ApexPages.StandardController controller) {
        stbugtitle = ApexPages.currentPage().getParameters().get('userSearchFlag');
        if(stbugtitle == 'true'){
            clearFlag = true;
            listUserPage = new list < UserWrap > ();
            searchflag = false;
            RecPerPage = '10'; //default records per page
            totalRecords = 0;
            pageNo = 1;
            lastPageno = 1;
           listuserWrapper = new List<UserWrap>();
           listuserWrapperSelected = new List<UserWrap>();
           displayResult = false;
           displayReadOnly = false;
           userIdsFromURL = ApexPages.currentPage().getParameters().get('createdBy');
           if(userIdsFromURL != null){              
               List<User> userListReturned = new List<User>();
               List<String> userIdsList = new List<String>();
               userIdsList = userIdsFromURL.split(',');         
               userListReturned = [select id, Name,username,email from User where id IN : userIdsList];
            if(userListReturned.size() > 0){
                for(user us : userListReturned){
                    listuserWrapperSelected.add(new UserWrap(us,true));
                }
                displayResult = true;           
                if(searchflag == false){
                displayReadOnly = true; 
                }           
            }
            }        
        }
        checkUserSearchCon = ApexPages.currentPage().getParameters().get('bug_title');
        stBugNo = ApexPages.currentPage().getParameters().get('bug_number');
        stStatus = ApexPages.currentPage().getParameters().get('bug_status');
        stPriority = ApexPages.currentPage().getParameters().get('bug_priority');
        stSeverity = ApexPages.currentPage().getParameters().get('bug_severity');
        stBugClass = ApexPages.currentPage().getParameters().get('bug_classification');
        stProduct = ApexPages.currentPage().getParameters().get('product');        
        stComponent = ApexPages.currentPage().getParameters().get('component');    
        stVersion = ApexPages.currentPage().getParameters().get('version');
        stBugzillaId = ApexPages.currentPage().getParameters().get('bugzilla_id');
        bug.OwnerId = ApexPages.currentPage().getParameters().get('owner_id');
        bug.Related_DMM_Number__c = ApexPages.currentPage().getParameters().get('DMM_Number');
        bgTeam.user__c = ApexPages.currentPage().getParameters().get('created_by');
        bug.Status__c = stStatus;
        bugList = new list < bug__c > ();
        sortField = 'Name';
        sortOrder = 'desc';        
        sortFieldAdvSearch = 'Name';
        sortOrderAdvSearch = 'desc';       
        setPickListValues();
        bugListAdvSearch = new list < bug__c > ();
        checkFlag = false;
        simulationFlag  = false;
    }      

    public PageReference SearchUser() {
        clearFlag = false;
        searchUserString = '';
        searchUserId = ''; 
        listUserPage = new list < UserWrap > ();        
        listuserWrapper = new List<UserWrap>();
        displayResult = false;
        displayReadOnly = false;
        if(userSearchString == null || userSearchString.length() <= 1 || string.isBlank(userSearchString)){
           searchflag = false;
           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, errorMsg ));
        }
        else{
            searchflag = true;
            List<User> userListReturned = new List<User>();
            string searchString = '%' + userSearchString + '%';
            userListReturned = Database.Query('select id, Name,username,email from User where Name Like \'%' + String.escapeSingleQuotes(searchString) + '%\'');
            if(userListReturned.size() > 0){
                for(user us : userListReturned){
                    listuserWrapper.add(new UserWrap(us,false));
                }
                displayResult = true;
            }
           resetPagination();
        }
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
        totalRecords = listuserWrapper.size();
        intRecPerPage = Integer.valueOf(RecPerPage);
        lastPageno = listuserWrapper.size() / intRecPerPage; // Page size 10 rows
        if (lastPageno * intRecPerPage < listuserWrapper.size()) {
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
    Public PageReference PreviousUsers() {        
        pageno--;
        displayList();
        return null;
    }
    //action for next click
    Public PageReference NextUsers() {
        pageno++;
        displayList();
        return null;
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

        listUserPage = new list < UserWrap > ();

        If(pageNo * intRecPerPage < listuserWrapper.size()) {
            for (Integer i = ((pageNo * intRecPerPage) - intRecPerPage); i < pageNo * intRecPerPage; i++) {
                listUserPage.add(listuserWrapper[i]);
                }
            
        } else If(pageNo * intRecPerPage >= listuserWrapper.size()) {
            for (Integer i = ((pageNo * intRecPerPage) - intRecPerPage); i < listuserWrapper.size(); i++) {              
                listUserPage.add(listuserWrapper[i]);
            }

        }
    }
    public void SetValues(){
        if(clearFlagCheck == true){
            if(UserString != null){
            createdBy = UserString;
            createdByIds = UserId;     
            } 
            else{
            createdBy = '';
            createdByIds = '';             
            }  
        }
        else{
            if(createdBy != '' && createdBy != null){
                createdBy = createdBy+','+UserString;
                createdByIds = createdByIds +','+UserId;
            }
            else{
                createdBy = UserString;
                createdByIds = UserId;
            }
        }
    }
    public class UserWrap{
        public User eachUser {get;set;}
        public Boolean isSelected {get;set;}   

        public UserWrap(User userName,Boolean value) {
            eachUser = userName;
            isSelected = value;
        }
    }
    public PageReference addAllUsers() {
        if(searchUserString != ''){
            searchUserString = searchUserString + ',';
            searchUserId = searchUserId + ',';
        }
        if(!listUserPage.isEmpty()){
            for(UserWrap uw: listUserPage){
                if(uw.isSelected == true){
                    searchUserId = searchUserId + uw.eachUser.id + ',';    
                    searchUserString = searchUserString + uw.eachUser.Name + ',';
                }
            }
            if(searchUserId != ''){
                searchUserId = searchUserId.substring(0, searchUserId.length() - 1);
                searchUserString = searchUserString.substring(0, searchUserString.length() - 1);
            }
        }
        return null;
    }

      

    //returns the searched bugs
    public list < bug__c > getBugListvar() {
        try {
            bugList = new list < bug__c > (bugList );                       
            if (!stFilter)
            {                
                //bugList = database.query(stQueryFilter + ' and isbug__c = true' + ' order by  ' + sortField + ' ' + sortOrder + ' nulls last  limit :list_Size offset :counter  ');
                bugList = (List<bug__c>) con.getRecords();                
            }
            
        } catch (Exception e) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, e.getmessage()));
        }
        return bugList;
    }
    
    //Get handler class
    public list < bug__c > getBugListExcelVar() {
        return bugListExcel;
    }

    public bug__c getBugVar() {
        return bug;
    }
    
     public bug__c getSimulationBugVar() {
        return bug1;
    }

    public Bug_Team__c getBugTeamVar() {
        return bgTeam;
    }


    //methods builds the query string based on the filter criteria
    public pagereference buildQueryforFilters() {
        stCreatedby = bgTeam.user__c ;           
        counter = total_Size = 0;
        stFilter = false;
        if(!simulationFlag)
            stOwner = bug.OwnerId;
        else
            stOwner = bug1.OwnerId;
        stRelatedDmmNumber = bug.Related_DMM_Number__c;
        if (stBugTitle == null)
            stBugTitle = '';
        if (stsimulationbugtitle == null)
            stsimulationbugtitle = '';
        if (stBugNo == null)
            stBugNo = '';
        if (stSimulationBugNo == null)
            stSimulationBugNo = '';
        if (stStatus == null)
            stStatus = '';
        if (stSimulationStatus == null)
            stSimulationStatus = '';
        if (stPriority == null)
            stPriority = '';
        if (stSeverity == null)
            stSeverity = '';
        if (stBugClass == null)
            stBugClass = '';
        if (stProduct == null)
            stProduct = '';
        if (stComponent == null)
            stComponent = '';
        if (stVersion == null)
            stVersion = '';
        if (stBugzillaId == null)
            stBugzillaId = '';
        if (stBugClass == null)
            stBugClass = '';
        if (stOwner == null)
            stOwner = '';
        
        if (stSubstrate == null)
            stSubstrate  = '';      
        if (stEncapsulation == null)
            stEncapsulation  = '';  
        if (stInterconnect == null)
            stInterconnect  = '';   
        if (stPackage  == null)
            stPackage   = '';   
        if (stSimulationType == null)
            stSimulationType  = ''; 
        if (stDieSize == null)
            stDieSize  = '';                
        if (stProductSimulation == null)
            stProductSimulation = '';   
            
        if (stCreatedBy == null)
            stCreatedBy = '';
        if (createdByIds  == null)
            createdByIds  = '';
        if (stRelatedDmmNumber == null)
            stRelatedDmmNumber = '';

        stStatus = stStatus.replace('[', '').replace(']', '');
        stSimulationStatus = stSimulationStatus.replace('[', '').replace(']', '');
        stPriority = stPriority.replace('[', '').replace(']', '');
        stSeverity = stSeverity.replace('[', '').replace(']', '');
        stProduct = stProduct.replace('[', '').replace(']', '');         
        stComponent = stComponent.replace('[', '').replace(']', '');        
        stBugClass = stBugClass.replace('[', '').replace(']', '');
        stVersion = stVersion.replace('[', '').replace(']', '');
        
        stSubstrate = stSubstrate.replace('[', '').replace(']', '');
        stEncapsulation = stEncapsulation.replace('[', '').replace(']', '');
        stInterconnect = stInterconnect.replace('[', '').replace(']', '');
        stPackage = stPackage.replace('[', '').replace(']', '');
        stSimulationType = stSimulationType.replace('[', '').replace(']', '');
        stDieSize = stDieSize.replace('[', '').replace(']', '');
        stProductSimulation = stProductSimulation.replace('[', '').replace(']', '');
        
        stBugTitle = stBugTitle.replace('//', '////');
        stBugTitle = stBugTitle.replace('\\', '\\\\');
        stBugTitle = stBugTitle.trim();
        
        stsimulationbugtitle = stsimulationbugtitle.replace('//', '////');
        stsimulationbugtitle = stsimulationbugtitle.replace('\\', '\\\\');
        stsimulationbugtitle = stsimulationbugtitle.trim();
               
        if (stBugNo != '' || stStatus != '' || stPriority != '' ||
            stSeverity != '' || stBugClass != '' || stProduct != '' ||
            stComponent != '' || stVersion != '' || stBugzillaId != '' ||
            stOwner != '' || createdByIds != '' || stBugTitle != '' || stRelatedDmmNumber != '' ||
            stSubstrate != '' || stEncapsulation != '' || stInterconnect != '' || stPackage != '' ||
            stSimulationType != '' || stDieSize != '' || stProductSimulation != '' || stSimulationBugNo != '' || stSimulationStatus != '' || stsimulationbugtitle != '' || stCreatedBy != ''
        ) {
           if(!simulationFlag){           
                stQueryFilter = createQueryStringFieldSet('BugSearchFields');                           
            }
            else{
                stQueryFilter = createQueryStringFieldSet('BugSimulationFields');                     
            }
            stQueryFilter += ' where ';

            if (stStatus != '') {
                stStatusFilter = new list < string > ();
                stStatusFilter = stStatus.split(',');
                stStatusFilter = removespace(stStatusFilter);
                stQueryFilter = stQueryFilter + ' status__c in' + ':stStatusFilter';
            }
            if (stProduct != '') {
                stProductFilter = new list < string > ();
                stProductFilter = stProduct.split(',');                
                stProductFilter = removespace(stProductFilter);             
                if (stStatus != '')
                    stQueryFilter = stQueryFilter + ' and ' + ' Product_Technology__c in' + ':stProductFilter';
                else
                    stQueryFilter = stQueryFilter + ' Product_Technology__c in' + ':stProductFilter';
            }

            if (stComponent != '') {
                stComponentFilter = new list < string > ();
                stComponentFilter = stComponent.split(',');                 
                stComponentFilter = removespace(stComponentFilter);             
                if (stStatus != '' || stProduct != '')
                    stQueryFilter = stQueryFilter + ' and ' + ' Component__c in' + ':stComponentFilter';
                else

                    stQueryFilter = stQueryFilter + ' Component__c in' + ':stComponentFilter';
            }

            if (stPriority != '') {

                stPriorityFilter = new list < string > ();
                stPriorityFilter = stPriority.split(',');
                stPriorityFilter = removespace(stPriorityFilter);

                if (stStatus != '' || stProduct != '' || stComponent != '')
                    stQueryFilter = stQueryFilter + ' and ' + ' Priority__c in' + ':stPriorityFilter';
                else

                    stQueryFilter = stQueryFilter + ' Priority__c in' + ':stPriorityFilter';

            }

            if (stSeverity != '') {
                stSeverityFilter = new list < string > ();
                stSeverityFilter = stSeverity.split(',');
                stSeverityFilter = removespace(stSeverityFilter);

                if (stStatus != '' || stProduct != '' || stComponent != '' || stPriority != '')
                    stQueryFilter = stQueryFilter + ' and ' + ' Severity__c in' + ':stSeverityFilter';
                else

                    stQueryFilter = stQueryFilter + ' Severity__c in' + ':stSeverityFilter';
            }

            if (stBugClass != '') {
                stBugClassFilter = new list < string > ();
                stBugClassFilter = stBugClass.split(',');
                stBugClassFilter = removespace(stBugClassFilter);
                if (stStatus != '' || stProduct != '' || stComponent != '' ||
                    stPriority != '' || stSeverity != '')
                    stQueryFilter = stQueryFilter + ' and ' + ' Bug_Classification__c in' + ':stBugClassFilter';
                else

                    stQueryFilter = stQueryFilter + ' Bug_Classification__c in' + ':stBugClassFilter';
            }

            if (stBugNo != '') {
                stBugNoFilter = new list < string > ();
                stBugNoFilter = stBugNo.split(',');
                stBugNoFilter = removespace(stBugNoFilter);

                if (stStatus != '' || stProduct != '' || stComponent != '' ||
                    stPriority != '' || stSeverity != '' || stBugClass != '')
                    stQueryFilter = stQueryFilter + ' and ' + ' Name in' + ':stBugNoFilter';
                else

                    stQueryFilter = stQueryFilter + ' Name in' + ':stBugNoFilter';
            }

            if (stVersion != '') {
                stVersionFilter = new list < string > ();
                stVersionFilter = stVersion.split(',');
                stVersionFilter = removespace(stVersionFilter);
                if (stStatus != '' || stProduct != '' || stComponent != '' ||
                    stPriority != '' || stSeverity != '' || stBugClass != '' ||
                    stBugNo != '')
                    stQueryFilter = stQueryFilter + ' and ' + ' Version__c in' + ':stVersionFilter';
                else

                    stQueryFilter = stQueryFilter + ' Version__c in' + ':stVersionFilter';

            }

            if (stBugzillaId != '') {
                stBugzillaIdFilter = new list < string > ();
                stBugzillaIdFilter = stBugzillaId.split(',');
                stBugzillaIdFilter = removespace(stBugzillaIdFilter);
                if (stStatus != '' || stProduct != '' || stComponent != '' ||
                    stPriority != '' || stSeverity != '' || stBugClass != '' ||
                    stBugNo != '' || stVersion != '')
                    stQueryFilter = stQueryFilter + ' and ' + ' Bugzilla_ID__c in' + ':stBugzillaIdFilter';
                else

                    stQueryFilter = stQueryFilter + ' Bugzilla_ID__c in' + ':stBugzillaIdFilter';
            }

            if (stOwner != '') {
                //stOwner = removespace(stOwner );    
                if (stStatus != '' || stProduct != '' || stComponent != '' ||
                    stPriority != '' || stSeverity != '' || stBugClass != '' ||
                    stBugNo != '' || stVersion != '' || stBugzillaId != '')
                    stQueryFilter = stQueryFilter + ' and ' + ' OwnerId =' + ':stOwner ';
                else

                    stQueryFilter = stQueryFilter + ' OwnerId= ' + ':stOwner ';
            }

           
            useridString = new List<string>();
            if(createdByIds != ''){
                useridString = createdByIds.split(',');
                if (stStatus != '' || stProduct != '' || stComponent != '' ||
                    stPriority != '' || stSeverity != '' || stBugClass != '' ||
                    stBugNo != '' || stVersion != '' || stBugzillaId != '' || stOwner != ''){
                    stQueryFilter = stQueryFilter + ' and ' + ' CreatedById IN ' + ':useridString';                    
                }
                else

                    stQueryFilter = stQueryFilter + ' CreatedById IN ' + ':useridString';                
            }
            
            if (stBugTitle != '') {
                stTempbugTitle = '%' + stBugTitle + '%';

                stBugTitle = stBugTitle.toLowerCase();
                if (stStatus != '' || stProduct != '' || stComponent != '' ||
                    stPriority != '' || stSeverity != '' || stBugClass != '' ||
                    stBugNo != '' || stVersion != '' || stBugzillaId != '' ||
                    stOwner != '' || createdByIds != '')
                    stQueryFilter = stQueryFilter + ' and ' + ' Bug_Title__c like' + ':stTempbugTitle ';
                else
                    stQueryFilter = stQueryFilter + ' Bug_Title__c like ' + ':stTempbugTitle ';

            }
           
            if (stRelatedDmmNumber != '') {
                bugDmmNumberList = new list < string > ();
                bugDmmNumberList = stRelatedDmmNumber.split(',');
                bugDmmNumberList = removespace(bugDmmNumberList);
                if (stStatus != '' || stProduct != '' || stComponent != '' ||
                    stPriority != '' || stSeverity != '' || stBugClass != '' ||
                    stBugNo != '' || stVersion != '' || stBugzillaId != '' ||
                    stOwner != '' || createdByIds != '' || stBugTitle != '')
                    stQueryFilter = stQueryFilter + ' and ' + ' Related_DMM_Number__c in' + ':bugDmmNumberList';
                else

                    stQueryFilter = stQueryFilter + ' Related_DMM_Number__c in' + ':bugDmmNumberList';

            }
            
            
            
            
            if (stSubstrate  != '') {
                stSubstrateFilter = new list < string > ();
                stSubstrateFilter = stSubstrate.split(',');
                stSubstrateFilter = removespace(stSubstrateFilter);
                if (stStatus != '' || stProduct != '' || stComponent != '' ||
                    stPriority != '' || stSeverity != '' || stBugClass != '' ||
                    stBugNo != '' || stVersion != '' || stBugzillaId != '' ||
                    stOwner != '' || createdByIds != '' || stBugTitle != '' || stRelatedDmmNumber != '')
                    stQueryFilter = stQueryFilter + ' and ' + ' Substrate_Type__c in' + ':stSubstrateFilter';
                else

                    stQueryFilter = stQueryFilter + ' Substrate_Type__c in' + ':stSubstrateFilter';

            }
            
            if (stEncapsulation != '') {
                stEncapsulationFilter = new list < string > ();
                stEncapsulationFilter = stEncapsulation.split(',');
                stEncapsulationFilter = removespace(stEncapsulationFilter);
                if (stStatus != '' || stProduct != '' || stComponent != '' ||
                    stPriority != '' || stSeverity != '' || stBugClass != '' ||
                    stBugNo != '' || stVersion != '' || stBugzillaId != '' ||
                    stOwner != '' || createdByIds != '' || stBugTitle != '' || stRelatedDmmNumber != '' ||
                    stSubstrate  != '')
                    stQueryFilter = stQueryFilter + ' and ' + ' Encapsulation__c in' + ':stEncapsulationFilter';
                else

                    stQueryFilter = stQueryFilter + ' Encapsulation__c in' + ':stEncapsulationFilter';

            }
            if (stInterconnect != '') {
                stInterconnectFilter = new list < string > ();
                stInterconnectFilter = stInterconnect.split(',');
                stInterconnectFilter = removespace(stInterconnectFilter);
                if (stStatus != '' || stProduct != '' || stComponent != '' ||
                    stPriority != '' || stSeverity != '' || stBugClass != '' ||
                    stBugNo != '' || stVersion != '' || stBugzillaId != '' ||
                    stOwner != '' || createdByIds != '' || stBugTitle != '' || stRelatedDmmNumber != '' ||
                    stSubstrate  != '' || stEncapsulation != '')
                    stQueryFilter = stQueryFilter + ' and ' + ' Type_of_Interconnect__c in' + ':stInterconnectFilter';
                else

                    stQueryFilter = stQueryFilter + ' Type_of_Interconnect__c in' + ':stInterconnectFilter';

            }
            if (stPackage != '') {
                stPackageFilter = new list < string > ();
                stPackageFilter = stPackage.split(',');
                stPackageFilter = removespace(stPackageFilter);
                if (stStatus != '' || stProduct != '' || stComponent != '' ||
                    stPriority != '' || stSeverity != '' || stBugClass != '' ||
                    stBugNo != '' || stVersion != '' || stBugzillaId != '' ||
                    stOwner != '' || createdByIds != '' || stBugTitle != '' || stRelatedDmmNumber != '' ||
                    stSubstrate  != '' || stEncapsulation != '' || stInterconnect != '')
                    stQueryFilter = stQueryFilter + ' and ' + ' Package_Type__c in' + ':stPackageFilter';
                else

                    stQueryFilter = stQueryFilter + ' Package_Type__c in' + ':stPackageFilter';

            }
            
            if (stSimulationType != '') {
                stSimulationTypeFilter = new list < string > ();
                stSimulationTypeFilter = stSimulationType.split(',');
                stSimulationTypeFilter = removespace(stSimulationTypeFilter);
                if (stStatus != '' || stProduct != '' || stComponent != '' ||
                    stPriority != '' || stSeverity != '' || stBugClass != '' ||
                    stBugNo != '' || stVersion != '' || stBugzillaId != '' ||
                    stOwner != '' || createdByIds != '' || stBugTitle != '' || stRelatedDmmNumber != '' ||
                    stSubstrate  != '' || stEncapsulation != '' || stInterconnect != '' || stPackage != '')
                    stQueryFilter = stQueryFilter + ' and ' + ' Simulation_Type__c in' + ':stSimulationTypeFilter';
                else

                    stQueryFilter = stQueryFilter + ' Simulation_Type__c in' + ':stSimulationTypeFilter';

            }
            
            if (stDieSize != '') {
                stDieSizeFilter = new list < string > ();
                stDieSizeFilter = stDieSize.split(',');
                stDieSizeFilter = removespace(stDieSizeFilter);
                if (stStatus != '' || stProduct != '' || stComponent != '' ||
                    stPriority != '' || stSeverity != '' || stBugClass != '' ||
                    stBugNo != '' || stVersion != '' || stBugzillaId != '' ||
                    stOwner != '' || createdByIds != '' || stBugTitle != '' || stRelatedDmmNumber != '' ||
                    stSubstrate  != '' || stEncapsulation != '' || stInterconnect != '' || 
                    stPackage != '' || stSimulationType != '' )
                    stQueryFilter = stQueryFilter + ' and ' + ' Die_Size__c in' + ':stDieSizeFilter';
                else

                    stQueryFilter = stQueryFilter + ' Die_Size__c in' + ':stDieSizeFilter';

            }
            
             if (stProductSimulation != '') {
                stProductSimulationFilter = new list < string > ();
                stProductSimulationFilter = stProductSimulation.split(',');
                stProductSimulationFilter = removespace(stProductSimulationFilter);
                if (stStatus != '' || stProduct != '' || stComponent != '' ||
                    stPriority != '' || stSeverity != '' || stBugClass != '' ||
                    stBugNo != '' || stVersion != '' || stBugzillaId != '' ||
                    stOwner != '' || createdByIds != '' || stBugTitle != '' || stRelatedDmmNumber != '' ||
                    stSubstrate  != '' || stEncapsulation != '' || stInterconnect != '' || 
                    stPackage != '' || stSimulationType != '' || stDieSize != '')
                    
                    stQueryFilter = stQueryFilter + ' and ' + ' Product_Technology__c in' + ':stProductSimulationFilter';
                else

                    stQueryFilter = stQueryFilter + ' Product_Technology__c in' + ':stProductSimulationFilter';

            }
            
           if (stsimulationbugtitle != '') {
                stTempbugTitle = '%' + stsimulationbugtitle + '%';
                stsimulationbugtitle = stsimulationbugtitle .toLowerCase();
                
                if (stStatus != '' || stProduct != '' || stComponent != '' ||
                    stPriority != '' || stSeverity != '' || stBugClass != '' ||
                    stBugNo != '' || stVersion != '' || stBugzillaId != '' ||
                    stOwner != '' || createdByIds != '' || stBugTitle != '' || stRelatedDmmNumber != '' ||
                    stSubstrate  != '' || stEncapsulation != '' || stInterconnect != '' || 
                    stPackage != '' || stSimulationType != '' || stDieSize != '' || stProductSimulation != '')
                    
                    stQueryFilter = stQueryFilter + ' and ' + ' Bug_Title__c like' + ':stTempbugTitle ';
                else
                    stQueryFilter = stQueryFilter + ' Bug_Title__c like ' + ':stTempbugTitle ';

            }
           if (stSimulationStatus != '') {           
                stSimulationStatusFilter = new list < string > ();
                stSimulationStatusFilter = stSimulationStatus.split(',');
                stSimulationStatusFilter = removespace(stSimulationStatusFilter);
                if(stStatus != '' || stProduct != '' || stComponent != '' ||
                    stPriority != '' || stSeverity != '' || stBugClass != '' ||
                    stBugNo != '' || stVersion != '' || stBugzillaId != '' ||
                    stOwner != '' || createdByIds != '' || stBugTitle != '' || stRelatedDmmNumber != '' ||
                    stSubstrate  != '' || stEncapsulation != '' || stInterconnect != '' || 
                    stPackage != '' || stSimulationType != '' || stDieSize != '' || stProductSimulation != '' || stsimulationbugtitle != '')
                    
                    stQueryFilter = stQueryFilter + ' and ' + ' status__c in' + ':stSimulationStatusFilter ';
                else
                    stQueryFilter = stQueryFilter + ' status__c in' + ':stSimulationStatusFilter ';                
            }
        
           if (stSimulationBugNo != '') {
                stSimulationBugNoFilter = new list < string > ();
                stSimulationBugNoFilter = stSimulationBugNo.split(',');
                stSimulationBugNoFilter = removespace(stSimulationBugNoFilter);

                if (stStatus != '' || stProduct != '' || stComponent != '' ||
                    stPriority != '' || stSeverity != '' || stBugClass != '' ||
                    stBugNo != '' || stVersion != '' || stBugzillaId != '' ||
                    stOwner != '' || createdByIds != '' || stBugTitle != '' || stRelatedDmmNumber != '' ||
                    stSubstrate  != '' || stEncapsulation != '' || stInterconnect != '' || 
                    stPackage != '' || stSimulationType != '' || stDieSize != '' || stProductSimulation != '' || stsimulationbugtitle != '' || stSimulationStatus != '')                    
                        stQueryFilter = stQueryFilter + ' and ' + ' Name in' + ':stSimulationBugNoFilter ';
                else

                    stQueryFilter = stQueryFilter + ' Name in' + ':stSimulationBugNoFilter';
            } 
            
             if (stCreatedBy != '') {             
                //stOwner = removespace(stOwner );    
                if (stStatus != '' || stProduct != '' || stComponent != '' ||
                    stPriority != '' || stSeverity != '' || stBugClass != '' ||
                    stBugNo != '' || stVersion != '' || stBugzillaId != '' ||
                    stOwner != '' || createdByIds != '' || stBugTitle != '' || stRelatedDmmNumber != '' ||
                    stSubstrate  != '' || stEncapsulation != '' || stInterconnect != '' || 
                    stPackage != '' || stSimulationType != '' || stDieSize != '' || stProductSimulation != '' || stsimulationbugtitle != '' || stSimulationStatus != '' || stSimulationBugNo != '')
                    
                    stQueryFilter = stQueryFilter + ' and ' + ' CreatedById =' + ':stCreatedBy ';
                else

                    stQueryFilter = stQueryFilter + ' CreatedById = ' + ':stCreatedBy ';

            }
                        
        } else {
            stQueryFilter = null;
            stFilter = true;
        }

        if (!stFilter) {
            try {              
                if(!simulationFlag){                 
                    total_Size = (integer) database.Query('select count(id)total from bug__c where ' + stQueryFilter.split('where')[1] + ' and IsBug__c = true  ')[0].get('total');                                                          
                    if (total_size > total_Limit)
                        total_size = total_Limit;
                    if (total_Size == 1) 
                    {            
                        bugList = Database.query(stQueryFilter + ' and IsBug__c = true  ' + ' order by  ' + sortField + ' ' + sortOrder);
                        PageReference bugpage = new ApexPages.StandardController(bugList[0]).view();
                        
                        bugpage.setRedirect(true);
                        return bugpage;
                    } else
                    {                                           
                        con = new ApexPages.StandardSetController(Database.getQueryLocator(stQueryFilter + ' and IsBug__c = true  ' + ' order by  ' + sortField + ' ' + sortOrder +   ' nulls last ' + ' limit ' + total_Limit  ));
                        con.setPageSize(list_Size);

                    }                                         
                }
                else{                                                
                    total_Size = (integer) database.Query('select count(id)total from bug__c where ' + stQueryFilter.split('where')[1] + ' and    RecordType.Name = ' +  '\''+simulationRecord + '\'' )[0].get('total');
                    if (total_size > total_Limit)
                        total_size = total_Limit;
                    if (total_Size == 1) 
                    {            
                        bugList = Database.query(stQueryFilter + ' and  RecordType.Name = ' +  '\'' + simulationRecord + '\'' + ' order by  ' + sortField + ' ' + sortOrder);
                        PageReference bugpage = new ApexPages.StandardController(bugList[0]).view();
                        
                        bugpage.setRedirect(true);
                        return bugpage;
                    } else
                    {                                           
                        con = new ApexPages.StandardSetController(Database.getQueryLocator(stQueryFilter + ' and    RecordType.Name = ' +  '\''+simulationRecord + '\'' + ' order by  ' + sortField + ' ' + sortOrder +   ' nulls last ' + ' limit ' + total_Limit  ));
                        con.setPageSize(list_Size);

                    } 
                     
                                           
                }
            } catch (exception e) 
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, e.getmessage()));
            }
        }
      
         
        return null;
    }
    
    //Method removes unwanted spaces in the filtertext
    public list < string > removeSpace(list < string > stList) {
        list < string > stListtemp = new list < string > ();
        for (string st: stList) {
            stListtemp.add(st.trim());
        }
        return stListtemp;
    }

    //Pagination methods used in the grid
    public PageReference Beginning() { //user clicked beginning
        con.first();
        counter = 0;
         
        return null;
    }

    public PageReference Previous() { //user clicked previous button
        con.Previous();
        counter -= list_Size;
        return null;
    }

    public PageReference Next() { //user clicked next button
        con.Next();
        counter += list_Size;
        return null;
    }

    public PageReference End() { //user clicked end        
        con.last();
        counter = total_Size - math.mod(total_Size, list_Size);
        if (counter == total_Size)
            counter = counter - list_Size;
        return null;
    }

    public Boolean getDisablePrevious() {
        //this will disable the previous and beginning buttons
       
        if (counter > 0) return false;
        else return true;
    }

    public Boolean getDisableNext() { //this will disable the next and end buttons
        if (counter + list_Size < total_Size) return false;
        else return true;
    }

    public Integer gettotal_Size() {
        return total_Size;
    }

    public Integer getPageNumber() {
        return counter / list_Size + 1;
    }

    public Integer getTotalPages() {
        if (math.mod(total_Size, list_Size) > 0) {
            return total_Size / list_Size + 1;
        } else {
            return (total_Size / list_Size);
        }
    }

    public integer getTotalRows() {   
            return total_Size;
        }
        //End of Pagination method

    //Sorting methods in grid
    public void doSort() {
        sortOrder = 'asc';
        /*This checks to see if the same header was click two times in a row, if so40
        it switches the order.*/
        if (previousSortField == sortField) {
            sortOrder = 'desc';
            previousSortField = null;
        } else {
            previousSortField = sortField;
        }
        if(!simulationFlag){
            con = new ApexPages.StandardSetController(Database.getQueryLocator(stQueryFilter + ' and IsBug__c = true  ' + ' order by  ' + sortField + ' ' + sortOrder  +  ' nulls last ' + ' limit ' + total_Limit ));
            con.setPageSize(list_Size);
        }
        else{
            con = new ApexPages.StandardSetController(Database.getQueryLocator(stQueryFilter + ' and    RecordType.Name = ' +  '\''+simulationRecord + '\'' + ' order by  ' + sortField + ' ' + sortOrder +   ' nulls last ' + ' limit ' + total_Limit  ));
            con.setPageSize(list_Size);
        }
    }
    
    //Sorting for Advanced Search
    //Sorting methods in grid
    public void doSortAdv() {
        sortOrderAdvSearch = 'asc';
        if (previousSortFieldAdvSearch == sortFieldAdvSearch) {
            sortOrderAdvSearch = 'desc';
            previousSortFieldAdvSearch = null;
        } else {
            previousSortFieldAdvSearch = sortFieldAdvSearch;
        }
    }    

    //Method redirects to the bug detail page.
    public PageReference redirectBug(bug__c bgVar) {
        PageReference bugPage;
        try {
            bugListExcel = Database.query(stQueryFilter + ' order by  ' + sortField + ' ' + sortOrder);
            bugPage = new ApexPages.StandardController(bgVar).view();
            bugPage.setRedirect(true);

        } catch (exception e) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, e.getmessage()));
        }
        return bugPage;
    }

    //Builing piclist values for the custom picklist components
    public void setPickListValues() {

        statusList = new list < SelectOption >  ();
        priorityList = new list < SelectOption > ();
        severitylist = new list < SelectOption > ();
        productList = new list < SelectOption > ();
        componentList = new list < SelectOption > ();
        bugClassList = new list < SelectOption > ();
        bugVerionList = new list < SelectOption > ();

        substrateList = new list <SelectOption>  ();
        encapsulationList = new list <SelectOption>  ();
        interconnectList = new list <SelectOption>  ();
        simulationTypeList = new list <SelectOption>  ();
        dieSizeList = new list <SelectOption>  ();
        packageTypelist = new list <SelectOption>  ();
        productSimulationList = new list <SelectOption> ();
        
        Schema.DescribeFieldResult fieldResult;
        List < Schema.PicklistEntry > schemaList;
        List<String> statusStr = new List<String> { 'New', 'Assigned','Submitted','Fix In Progress',
                                                'Reopened','Resolved','Verified','Hold','Closed'};

        for (string str: statusStr) {
            statusList.add(new SelectOption(str, str));
        }
        
        fieldResult = Bug__c.priority__c.getDescribe();
        schemaList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry f: schemaList) {
            priorityList.add(new SelectOption(f.getLabel(), f.getValue()));
        }
        
        fieldResult = Bug__c.Product_Technology__c.getDescribe();
        schemaList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry f: schemaList) {
            productSimulationList.add(new SelectOption(f.getLabel(), f.getValue()));
        }
        

        fieldResult = Bug__c.severity__c.getDescribe();
        schemaList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry f: schemaList) {
            severitylist.add(new SelectOption(f.getLabel(), f.getValue()));
        }

        fieldResult = Bug__c.product_technology__c.getDescribe();
        schemaList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry f: schemaList) {
            productList.add(new SelectOption(f.getLabel(), f.getValue()));
        }

        fieldResult = Bug__c.component__c.getDescribe();
        schemaList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry f: schemaList) {
            componentList.add(new SelectOption(f.getLabel(), f.getValue()));
        }

        fieldResult = Bug__c.Bug_Classification__c.getDescribe();
        schemaList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry f: schemaList) {
            bugClassList.add(new SelectOption(f.getLabel(), f.getValue()));
        }

        fieldResult = Bug__c.Version__c.getDescribe();
        schemaList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry f: schemaList) {
            bugVerionList.add(new SelectOption(f.getLabel(), f.getValue()));
        }
        
        fieldResult = Bug__c.Substrate_Type__c.getDescribe();
        schemaList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry f: schemaList) {
            substrateList.add(new SelectOption(f.getLabel(), f.getValue()));
        }
        
        fieldResult = Bug__c.Encapsulation__c.getDescribe();
        schemaList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry f: schemaList) {
            encapsulationList.add(new SelectOption(f.getLabel(), f.getValue()));
        }
        
        fieldResult = Bug__c.Type_of_Interconnect__c.getDescribe();
        schemaList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry f: schemaList) {
            interconnectList.add(new SelectOption(f.getLabel(), f.getValue()));
        }
        
        fieldResult = Bug__c.Package_Type__c.getDescribe();
        schemaList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry f: schemaList) {
            packageTypelist.add(new SelectOption(f.getLabel(), f.getValue()));
        }
        
        fieldResult = Bug__c.Simulation_Type__c.getDescribe();
        schemaList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry f: schemaList) {
            simulationTypeList.add(new SelectOption(f.getLabel(), f.getValue()));
        }
        
        fieldResult = Bug__c.Die_Size__c.getDescribe();
        schemaList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry f: schemaList) {
            dieSizeList.add(new SelectOption(f.getLabel(), f.getValue()));
        }
    }

    public PageReference ExportExcel() {
        PageReference r;
        
        try {
        if(!simulationFlag){
        
                bugListExcel = Database.query(stQueryFilter + ' and IsBug__c = true  ' + ' order by  ' + sortField + ' ' + sortOrder + ' limit ' + total_Limit + '');                
                r = new PageReference('/apex/bugsearch_excel');
                r.setredirect(false);
          }
        else{
       
                bugListExcel = Database.query(stQueryFilter + ' and RecordType.Name = ' +  '\''+simulationRecord + '\'' + ' order by  ' + sortField + ' ' + sortOrder + ' limit ' + total_Limit + '');                
                r = new PageReference('/apex/bugsearch_excel');
                r.setredirect(false);        
          }
        } catch (Exception e) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, e.getmessage()));
        }
        return r;
    }
    public list < bug__c > getBugListvarAdvSearch() {
        try {
            bugListAdvSearch = new list < bug__c > ();
            if (stQueryFilterAdvSearch != null && stQueryFilterAdvSearch != '') {
                bugListAdvSearch = database.query(stQueryFilterAdvSearch + ' and IsPDKRequest__c = false ' + ' order by  ' + sortFieldAdvSearch + ' ' + sortOrderAdvSearch + ' nulls last  limit :list_Size_AdvSearch offset :counterAdvSearch ');
            }

        } catch (Exception e) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, e.getmessage()));
        }
        return bugListAdvSearch;
    }
    public list < bug__c > getBugListExcelVarAdvSearch() {
        return bugListExcelAdvSearch;
    }

    public PageReference advSearch() {
            checkFlag = false;
            isAdvSearch = true;
            bugId.clear();
            counterAdvSearch = total_Size_AdvSearch = 0;
            stOwner = bug.OwnerId;
            stCreatedby = bgTeam.user__c;
            stRelatedDmmNumber = bug.Related_DMM_Number__c;
            List < List < sObject >> lstListObj = new List < List < sObject >> ();
            String searchStr = '';
            Integer i;
            textSearch = textSearch.trim();
            string lengthChk = textSearch.replaceAll('[^a-zA-Z0-9]', '');
            lengthChk = lengthChk.trim();
            if (!String.isBlank(textSearch)) {
                if (lengthChk.length() <= 1) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, errorMsg));
                } else if (searchstring == 'all') {
                    textSearch = textSearch.replace('//', '////');
                    textSearch = textSearch.replace('\\', '\\\\');
                    textSearch = '"' + textSearch + '"';
                    String searchQuery = 'FIND \'' + textSearch + '\' IN ALL FIELDS RETURNING FeedItem(ParentId),Bug__c(Id)';
                    lstListObj = search.query(searchquery);
                    List < FeedItem > feedItemlist = lstListObj[0];
                    List < Bug__c > BugListTemp = lstListObj[1];
                    for (feeditem feed: feedItemlist) {
                        bugId.add(feed.ParentId);
                    }                                        
                    for (Bug__c bugTemp: BugListTemp) {
                        bugId.add(bugTemp.Id);
                    }
                    if (!bugId.isEmpty()) {
                        stQueryFilterAdvSearch = createQueryStringFieldSet('BugSearchFields');
                        stQueryFilterAdvSearch += ' where ' + ' id IN: bugId';

                    } else
                        checkFlag = true;
                } else if (searchstring == 'any') {
                    list < string > textSearchFilter = new list < string > ();
                    textSearchFilter = textSearch.split(' ');
                    textSearchFilter = removespace(textSearchFilter);
                    for (string str: textSearchFilter) {
                        searchStr += '\"' + str + '\"' + ' OR ';
                    }
                    searchStr = searchStr.substring(0, searchStr.length() - 4);
                    String searchQuery = 'FIND \'' + searchStr + '\' IN ALL FIELDS RETURNING FeedItem(ParentId),Bug__c(Id)';
                    lstListObj = search.query(searchquery);
                    List < FeedItem > feedItemlist = lstListObj[0];
                    List < Bug__c > BugListTemp = lstListObj[1];
                    for (feeditem feed: feedItemlist) {
                        bugId.add(feed.ParentId);
                    }
                    for (Bug__c bugTemp: BugListTemp) {
                        bugId.add(bugTemp.Id);
                    }
                    if (!bugId.isEmpty()) {
                        stQueryFilterAdvSearch = createQueryStringFieldSet('BugSearchFields');
                        stQueryFilterAdvSearch += ' where ' + ' id IN: bugId';

                    } else
                        checkFlag = true;
                }
            }

            if (stQueryFilterAdvSearch != null && stQueryFilterAdvSearch != '') {
                try {
                    bugListAdvSearch = Database.query(stQueryFilterAdvSearch + ' and IsPDKRequest__c = false'  + ' order by  ' + sortFieldAdvSearch + ' ' + sortOrderAdvSearch + ' limit 200');                    
                    bugListExcelAdvSearch = bugListAdvSearch;
                    total_Size_AdvSearch = bugListAdvSearch.size();
                    if(Test.isRunningTest()) {
                        throw new applicationException('In Test Mode');
                    } 
                } catch (exception e) {
                    ApplicationLogWrapper alw=new ApplicationLogWrapper();
                    alw.source = BugSearch.class.getName();
                    alw.sourceFunction ='advSearch()';
                    alw.ApplicationName='Case Management';                    
                    alw.referenceInfo = 'Bug';
                    alw.logMessage = 'Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                    alw.debugLevel = 'Error';
                    alw.logCode = e.getTypeName();
                    alw.ex = e.getCause();
                    GlobalUtility.logMessage(alw);
                    return null;
                }
            }
            if (bugListAdvSearch.size() == 1) {
                PageReference bugpageAdvSearch = new ApexPages.StandardController(bugListAdvSearch[0]).view();
                return bugpageAdvSearch.setRedirect(true);
            } else
                return null;
        }
    //Pagination methods used in the grid disablePrevious
    public PageReference BeginningAdvSearch() { //user clicked beginning
        counterAdvSearch = 0;
        return null;
    }
    public PageReference PreviousAdvSearch() { //user clicked previous button
        counterAdvSearch -= list_Size_AdvSearch;
        return null;
    }
    public PageReference NextAdvSearch() { //user clicked next button
        counterAdvSearch += list_Size_AdvSearch;
        return null;
    }
    public PageReference EndAdvSearch() { //user clicked end
        counterAdvSearch = total_Size_AdvSearch - math.mod(total_Size_AdvSearch, list_Size_AdvSearch);
        if (counterAdvSearch == total_Size_AdvSearch)
            counterAdvSearch = counterAdvSearch - list_Size_AdvSearch;
        return null;
    }
    public Boolean getDisablePreviousAdvSearch() {
        //this will disable the previous and beginning buttons
        if (counterAdvSearch > 0) return false;
        else return true;
    }

    public Boolean getDisableNextAdvSearch() { //this will disable the next and end buttons
        if (counterAdvSearch + list_Size_AdvSearch < total_Size_AdvSearch) return false;
        else return true;
    }

    public Integer gettotal_SizeAdvSearchAdvSearch() {
        return total_Size_AdvSearch;
    }
    public Integer getPageNumberAdvSearch() {

        return counterAdvSearch / list_Size_AdvSearch + 1;

    }

    public Integer getTotalPagesAdvSearch() {
        if (math.mod(total_Size_AdvSearch, list_Size_AdvSearch) > 0) {
            return total_Size_AdvSearch / list_Size_AdvSearch + 1;
        } else {
            return (total_Size_AdvSearch / list_Size_AdvSearch);
        }
    }

    public integer getTotalRowsAdvSearch() {

        return total_Size_AdvSearch;
    }
    public PageReference ExportExcelAdvSearch() {
        PageReference r = new PageReference('/apex/bugsearch_excel?param=adv');        
        r.setredirect(false);
        return r;
    }
    // This method is used for creating SOQL from Object & corresponding Field Set Name
    public string createQueryStringFieldSet(string fieldSetName) {
        String query = '';
        query = 'SELECT Id, Name  ';
        Schema.DescribeSObjectResult res = globalDescribe.get('Bug__c').getDescribe();
        Map < String, Schema.FieldSet > fieldSetMap = res.fieldSets.getMap();
        Schema.FieldSet fs = fieldSetMap.get(fieldSetName);
        for (Schema.FieldSetMember fsm: fs.getFields()) {
            query = query + ',' + fsm.getFieldPath();
        }
        query = query + ' from Bug__c';
        return query;
    }  
    public void clearAll(){
            stBugTitle = '';
            stBugNo = '';
            stStatus = '';
            stPriority = '';
            stSeverity = '';
            stBugClass = '';
            stProduct = '';
            stComponent = '';
            stVersion = '';
            stBugzillaId = '';
            stBugClass = '';
            stOwner = '';
            stSubstrate = '';
            stEncapsulation = '';
            stInterconnect = '';
            stPackage = '';
            stSimulationType = '';
            stDieSize ='';
            stProductSimulation  = '';
            stSimulationStatus = '';
            stsimulationbugtitle = '';
            stSimulationBugNo = '';
            stCreatedby  = '' ;
            bug = new Bug__c();
            bug1 = new Bug__c();
            bgTeam = new Bug_Team__c ();
            bugList = null;
            createdByIds  = '';
            createdBy = '';
            stRelatedDmmNumber = '';            
            buildQueryforFilters();
    } 
    
    public void resetTab(){
    
                    stBugTitle = '';
                    stBugNo = '';
                    stStatus = '';
                    stPriority = '';
                    stSeverity = '';
                    stBugClass = '';
                    stProduct = '';
                    stComponent = '';
                    stVersion = '';
                    stBugzillaId = '';
                    stBugClass = '';
                    stOwner = '';
                    stSubstrate = '';
                    stEncapsulation = '';
                    stInterconnect = '';
                    stPackage = '';
                    stSimulationType = '';
                    stDieSize ='';
                    stProductSimulation  = ''; 
                    stSimulationStatus = '';
                    stsimulationbugtitle = '';
                    stSimulationBugNo = '';
                    stCreatedby  = '';
                    bugList = null;
                    bug = new Bug__c();
                    bug1 = new Bug__c();
                    bgTeam = new Bug_Team__c ();
                    buildQueryforFilters();
    }
   
public class applicationException extends Exception {}     
}