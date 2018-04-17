/*
Type Name: CaseFileSearchController 
Author: Cognizant Case Management Team
Created Date: 16-Dec-2014
Reason: Reason: This is the controllar class for CaseFileSearch page.
Test Class: CaseVisualforceControllerTest
Change History:
Author: 
Modified Date: 
……..
……..
--
*/
public with sharing class CaseFileSearchController {
    // selection and filter 
    public list<String> AlphaList {get; set;}
    public String AlphaFilter {get; set;}
    public static String orderBy;
    
    public String SearchName {get; set;}
    public String caseNumber {get; set;}
    public String creator{get; set;}    
    public String createdDate {get; set;}
    
    public transient list < Attachment > listCaseAttachment {get; set;}
    public transient list < CaseFeed > listCaseChatterFiles {get; set;}
    
    public list<CaseSubClass> filesList {get; set;}
    public transient list<CaseSubClass> pageFileList{get; set;}
    
    public transient String QueryCaseAttachments; // Attachment SOQL
    public transient String QueryCaseChatterFiles; // CaseFeed SOQL
    
    public Integer totalRecords {get; set;}
    
    //Pagination variable 
    Public Boolean hasPrevious {get;set;}
    Public Boolean hasNext {get;set;}
    Public Integer pageno {get;set;}
    Public Integer lastPageno {get;set;}
    public String RecPerPage {get; set;}
    public list<SelectOption> RecPerPageOption {get; set;}
    Public Integer intRecPerPage{get;set;}
    
    /***
* SortField - return sort by field. Default to Name
***/
    public String SortField {
        get { if (SortField == null) {SortField = 'Name'; } return SortField;  }
        set; 
    } 
    
    /***
* fileTypes - return Type of Search. Default to BOTH
***/
    public String fileTypes{
        get { if (fileTypes == null) {fileTypes = 'BOTH'; } return fileTypes; }
        set; 
    }    
    //CaseFileSearchController- Constructor initialization
    public CaseFileSearchController() {
        filesList = new list < CaseSubClass > ();
        listCaseAttachment = new List < Attachment > ();
        listCaseChatterFiles = new List < CaseFeed > ();
        //records for page initialization
        RecPerPageOption = new list < SelectOption > ();
        RecPerPageOption.add(new SelectOption('10', '10'));
        RecPerPageOption.add(new SelectOption('25', '25'));
        RecPerPageOption.add(new SelectOption('50', '50'));
        RecPerPageOption.add(new SelectOption('100', '100'));
        RecPerPageOption.add(new SelectOption('200', '200'));
        RecPerPage = '10'; //default records per page
        totalRecords = 0;
        pageNo = 1;
        lastPageno = 1;
        // initialization alpha list
        AlphaList = new list < String > {
            'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'All'
                };
                    
                    // alpha filter, use page parameter or set default to all
                    if (apexpages.currentpage().getparameters().get('alpha') == null) {
                        AlphaFilter = 'All';
                    } else {
                        AlphaFilter = apexpages.currentpage().getparameters().get('alpha');
                    }
        
    }
    
    //SearchCase File - set search criteria fields and refresh table
    public PageReference SearchCaseAttachment() {
        getFileList();
        return null;
    }
    //get Current Files List - return Files list for the table 
    public void getFileList() {
        if (filesList != null)
            filesList.clear();
        
       if (isNotBlank(SearchName) || isNotBlank(creator) || isNotBlank(createdDate) || isNotBlank(caseNumber)) {
            
            transient List < Id > listRecordIds = new List < Id > ();
            transient Set < Id > setRecordIds = new Set < Id > ();
    
            transient List < UserRecordAccess > listUserRecordAccess = new List < UserRecordAccess > ();
            transient list < CaseSubClass > fileListTotal;
            orderBy = SortDirection;
            if (AlphaFilter == null || AlphaFilter.trim().length() == 0) {
                AlphaFilter = 'All';
            }
            if (fileListTotal == null)
                fileListTotal = new list < CaseSubClass > ();
            if (fileTypes != 'ATTACHMENT') {
                    chatterQuery();
                    System.debug('@@@Chatterfiles'+Database.query(QueryCaseChatterFiles));
                    for(List<Case> caseList : Database.query(QueryCaseChatterFiles)) {
                        for(Case c : caseList) {
                            if(c.AttachedContentDocuments.size() > 0){
                                for(AttachedContentDocument att:c.AttachedContentDocuments){
                                    if (fileListTotal.size() >= 5000){
                                     System.debug('files 5000');
                                     break;
                                    }
                                    if(c.id == att.LinkedEntityId){
                                        System.debug('case with attachment-->'+att.ContentDocumentid);
                                    }
                                    
                                    string fileName = (string) att.Title;
                                    if (fileName != null && fileName != '') {
                                        if (SearchName != null && SearchName != '') {
                                            if (AlphaFilter != 'All') {
                                                if (fileName.startsWithIgnoreCase(AlphaFilter)) {
                                                    if (fileName.toLowerCase().contains(SearchName.toLowerCase())) {
                                                        fileListTotal.add(new CaseSubClass('Chatter', c,att));
                                                    }
                                                }
                                            } else {
                                                if (fileName.toLowerCase().contains(SearchName.toLowerCase())) {
                                                    fileListTotal.add(new CaseSubClass('Chatter', c,att));
                                                }
                                            }
                                        } else {
                                            if (AlphaFilter != 'All') {
                                                if (fileName.startsWithIgnoreCase(AlphaFilter)) {
                                                    fileListTotal.add(new CaseSubClass('Chatter',c,att));
                                                }
                                            } else {
                                                fileListTotal.add(new CaseSubClass('Chatter',c,att));
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
            }
            if (filesList == null)
                filesList = new list < CaseSubClass > ();
    
            if (UserInfo.getUserType() != 'Standard') {
                for (CaseSubClass subClassObj: fileListTotal) {
                    //to avoid Number of records exceeds limit: 200 
                    if (listRecordIds.size() != 200) {
                        listRecordIds.add(subClassObj.RecordId);
                    } else if (listRecordIds.size() == 200) {
                        listUserRecordAccess.addall(getUserRecordAccessList(listRecordIds));
                        listRecordIds.clear();
                    }
                }
                if (listRecordIds.size() > 0) {
                    listUserRecordAccess.addall(getUserRecordAccessList(listRecordIds));
                    listRecordIds.clear();
                }
    
                for (UserRecordAccess ura: listUserRecordAccess) {
                    if (ura.HasReadAccess) {
                        setRecordIds.add(ura.RecordId);
                    }
                }
                for (CaseSubClass subClassObj: fileListTotal) {
                    if (setRecordIds.contains(subClassObj.RecordId) && filesList.size() < 5000) {
                        filesList.add(subClassObj);
                    }
                }
            } else {
                filesList.addall(fileListTotal);
            }
            filesList.sort();
        }
        resetPagination(); 
    }
    
    public void chatterQuery(){
        String q1; 
        String uploadedby;
        String filename;
        String uploadeddate;
        string caseno;
        filename='\'%' + String.escapeSingleQuotes(SearchName.trim()) + '%\'';
        uploadedby ='\'%' + String.escapeSingleQuotes(creator.trim()) + '%\'';      
        uploadeddate =String.escapeSingleQuotes(createdDate) ;
        caseno='\'%' + String.escapeSingleQuotes(CaseNumber.trim()) + '%\'';
        
        QueryCaseChatterFiles ='SELECT id,CaseNumber,(SELECT ContentDocumentid,Title,CreatedBy.Name,ContentSize,ContentUrl,CreatedDate,CreatedById,LinkedEntityId FROM AttachedContentDocuments';	
        
        if ((SearchName == null || SearchName =='') && (caseNumber != null && caseNumber != '') && (creator == null || creator == '')) {
            q1=' WHERE createdDate = '+uploadeddate+') FROM Case WHERE CaseNumber LIKE '+caseno;
            QueryCaseChatterFiles = QueryCaseChatterFiles+q1;
        
        }
        else if ((SearchName != null && SearchName !='') && (caseNumber != null && caseNumber != '') && (creator != null && creator != '')) {
            q1=' WHERE Title LIKE '+filename+'AND CreatedBy.Name LIKE '+uploadedby+'AND createdDate = '+uploadeddate+') FROM Case WHERE CaseNumber LIKE '+caseno;
            QueryCaseChatterFiles = QueryCaseChatterFiles+q1;
        
        }
        else if (SearchName != null && SearchName !='' && creator != null && creator != '' ) {
            q1=' WHERE Title LIKE '+filename+'AND CreatedBy.Name LIKE '+uploadedby+'AND createdDate = '+uploadeddate+') FROM Case';
            QueryCaseChatterFiles = QueryCaseChatterFiles+q1;
        }   
        else if (SearchName != null && SearchName !='' && caseNumber != null && caseNumber != '' ) {
            q1=' WHERE Title LIKE '+filename+'AND createdDate = '+uploadeddate+') FROM Case WHERE CaseNumber LIKE '+caseno;
            QueryCaseChatterFiles = QueryCaseChatterFiles+q1;
        } 
        else if (creator != null && creator !='' && caseNumber != null && caseNumber != '' ) {
            q1=' WHERE CreatedBy.Name LIKE '+uploadedby+' AND createdDate = '+uploadeddate+') FROM Case WHERE CaseNumber LIKE '+caseno;
            QueryCaseChatterFiles = QueryCaseChatterFiles+q1;
        } 
        else if (SearchName != null && SearchName !='') {
            q1=' WHERE Title LIKE '+filename+' AND createdDate = '+uploadeddate+') FROM Case';
            QueryCaseChatterFiles = QueryCaseChatterFiles+q1;
        } 
        else if (creator != null && creator !='') {
            q1=' WHERE CreatedBy.Name LIKE '+uploadedby+'AND createdDate = '+uploadeddate+') FROM Case';
            QueryCaseChatterFiles = QueryCaseChatterFiles+q1;
        } else {
            q1=' WHERE createdDate = '+uploadeddate+') FROM Case';
            QueryCaseChatterFiles = QueryCaseChatterFiles+q1;
        }  
    }
    
    
    //getUserRecordAccessList- return UserRecordAccess list for portal users  
    public list<UserRecordAccess> getUserRecordAccessList(List < Id > allRecordIds) {        
        List < UserRecordAccess > listUserRecordAccess = 
            [SELECT RecordId, HasEditAccess, HasReadAccess FROM UserRecordAccess 
             WHERE UserId = : UserInfo.getUserId() AND RecordId In: allRecordIds Limit 200];
        
        return listUserRecordAccess;
    }
    
    //isNotBlank- check the string null or blank
    public static Boolean isNotBlank(String val){
        if(val <> null && val <> '' && val <> 'null'){
            return true;
        }
        return false;
    }
    
    /***
* ClearCaseSelectedSet - remove all varaibles Cases and initialize counter
***/
    public PageReference ClearAll() {
        totalRecords = 0;
        SearchName = '';
        caseNumber = '';
        creator = '';
        createdDate = '';
        fileTypes = 'BOTH';
        AlphaFilter = 'All';
        RecPerPage = '10'; //default records per page
        getFileList();
        return null;
    }
    /*
    //BuildWhere - build soql string for where criteria 
    public String BuildWhere(String QW, String Cond) {
        if (QW == '') {
            return ' WHERE ' + Cond;
        } else {
            return QW + ' AND ' + Cond;
        }
    }
    */
    //Method will generate Attachment & Chatter picklist values
    public List < SelectOption > getattChatterValues() {
        transient List < SelectOption > options = new List < SelectOption > ();
        options.add(new SelectOption('BOTH', 'BOTH'));
        options.add(new SelectOption('ATTACHMENT', 'ATTACHMENT ONLY'));
        options.add(new SelectOption('CHATTER', 'CHATTER ONLY'));
        return options;
    }
    
    //Method will generate date filter
    public List < SelectOption > getdatesFilter() {
        transient List < SelectOption > options = new List < SelectOption > ();
        //options.add(new SelectOption('', '--None--'));
        options.add(new SelectOption('THIS_YEAR', 'THIS YEAR'));
        options.add(new SelectOption('LAST_YEAR', 'LAST YEAR'));
        options.add(new SelectOption('LAST_QUARTER', 'LAST QUARTER'));
        options.add(new SelectOption('THIS_QUARTER', 'THIS QUARTER'));
        options.add(new SelectOption('LAST_90_DAYS', 'LAST 90 DAYS'));
        options.add(new SelectOption('THIS_MONTH', 'THIS_MONTH'));
        options.add(new SelectOption('LAST_MONTH', 'LAST MONTH'));
        options.add(new SelectOption('THIS_WEEK', 'THIS WEEK'));
        options.add(new SelectOption('LAST_WEEK', 'LAST WEEK'));
        options.add(new SelectOption('TODAY', 'TODAY'));
        options.add(new SelectOption('YESTERDAY', 'YESTERDAY'));        
        return options;
    }
    /***
* SortToggle - toggles the sorting of query from asc<-->desc
***/
    public void SortToggle() {
        SortDirection = SortDirection.equals('asc') ? 'desc' : 'asc';
        // run the query again
        getFileList();
    }
    /***
* SortDirection - return sort direction. Default ascending(asc)
***/
    public String SortDirection {
        get {
            if (SortDirection == null) {
                SortDirection = 'asc';
            }
            return SortDirection;
        }
        set;
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
        totalRecords = filesList.size();
        intRecPerPage = Integer.valueOf(RecPerPage);
        lastPageno = filesList.size() / intRecPerPage; // Page size 10 rows
        if (lastPageno * intRecPerPage < filesList.size()) {
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
        if (pageFileList == null)
            pageFileList = new list < CaseSubClass > ();
        
        If(pageNo * intRecPerPage < filesList.size()) {
            for (Integer i = ((pageNo * intRecPerPage) - intRecPerPage); i < pageNo * intRecPerPage; i++) {
                pageFileList.add(filesList[i]);
            }
        } else If(pageNo * intRecPerPage >= filesList.size()) {
            for (Integer i = ((pageNo * intRecPerPage) - intRecPerPage); i < filesList.size(); i++) {
                pageFileList.add(filesList[i]);
            }
            
        }
    }
             
    //CaseSubClass - Sub-Class to hold Attachment & FeedItem object values
    public with sharing class CaseSubClass implements Comparable {
        
        public Boolean aCheckBox {get; set;}
        public Id Id {get; set;}
        public Id RecordId {get; set;}        
        public string Name {get; set;}
        public string Description {get; set;}
        public decimal Size {get; set;}
        public string Parent {get; set;}
        public Id ParentID {get; set;}
        public string CreatedBy {get; set;}
        public Id CreatedById {get; set;}
        public string OwnerName {get; set;}
        public Id OwnerId {get; set;}
        public Boolean isPublic {get; set;}
        public Datetime createdDate {get; set;}
        public string urlDownload{get; set;}
        
        public Integer compareTo(Object compareTo) {
            CaseSubClass objCls = (CaseSubClass) compareTo;
            if (CaseFileSearchController.orderBy == 'asc') {
                if (Name == objCls.Name) return 0;
                if (Name > objCls.Name) return 1;
            } else {
                if (Name == objCls.Name) return 1;
                if (Name > objCls.Name) return 0;
            }
            return -1;
        }
        
        public CaseSubClass(string type,Case c, AttachedContentDocument att) {
            isPublic = true;
            string url =  '';
            if(UserInfo.getUserType() != 'Standard') {
                url =  Label.Case_Globalfoundry_Link;
            }else{
                url =  Label.Case_Link_for_Internal_User;
            }
            
            if (type == 'Attachment') {
                Id = att.Id;
                RecordId = att.Id;
                Name = att.Title;
                Size = att.ContentSize;
                Parent = c.CaseNumber;
                ParentId = c.Id;
                CreatedBy = att.CreatedBy.Name;
                CreatedById = att.CreatedById;
                OwnerName = att.CreatedBy.Name;
                OwnerId = att.CreatedById;
                createdDate = att.CreatedDate;
                urlDownload = url + 'servlet/servlet.FileDownload?file='+att.Id;
                aCheckBox = false;
                isPublic = false;
            } else if (type == 'Chatter') {
                Id = att.ContentDocumentId;
                RecordId = att.Id;
                Name = att.Title;
                Size = att.ContentSize;
                Parent = c.CaseNumber;
                ParentId = c.Id;
                CreatedBy = att.CreatedBy.Name;
                CreatedById = att.CreatedById;
                OwnerName = att.CreatedBy.Name;
                OwnerId = att.CreatedById;
                createdDate = att.CreatedDate;
                //urlDownload = url + 'sfc/servlet.shepherd/version/download/'+att.ContentDocumentId;
                urlDownload = url + att.ContentDocumentId;
                isPublic = false;
                aCheckBox = true;
            }
        }
    }
}