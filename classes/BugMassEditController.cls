/*
Type Name: BugMassEditController 
Author: UCM Cognizant
Reason: This class implements the functionality of Mass Updating Bug records.
Test Class: BugMassEditControllerTest
Change History:
Author: Shuchi against Case #00053999
Modified Date: 06132016
……..//
……..
--
*/
public class BugMassEditController {
    private String currentStep;
    private Integer numberofSelectedRecords{get;set;}
    private Map < String, Schema.SObjectField > fieldMap;
    private final PageReference fromPage;
    private transient ApexPages.Message currentMsg;
    private Schema.SObjectField field;
    private final List < Bug__c > objs;
    Transient private final List < Bug__c > isBugFalse {
        get;
        set;
    }
    
    public String res ;
    public String dmClassification ;
    public String resolutionDetl ;
    
    private List < SelectOption > picklistValues;
    public string stStatus {
        get;
        set;
    }
    public string dmTeamClassification {
        get;
        set;
    }
    public string stResolution {
        get;
        set;
    }
    public string resolutionDetails {
        get;
        set;
    }
    public list < SelectOption > statusList {
        get;
        set;
    }
    public list < SelectOption > dmTeamList {
        get;
        set;
    }
    Public Boolean isNotBug {
        get;
        set;
    }
    Public Map < Bug__c, string > bugVsErrorMap {
        get;
        set;
    }
    Public List < Bug__c > bugSuccessList {
        get;
        set;
    }
    Public Boolean hasUpdateError {
        get;
        set;
    }
    Public Boolean isSuccess {
        get;
        set;
    }
    Public Boolean isFailure {
        get;
        set;
    }
    Public string listid;
    Public String updateFileName {
        get;
        set;
    }
    Public set < string > bugId;
    
    Public set <string>selectedBugId;
    public string chatterComment {
        get;
        set;
    }

    public list<BugWrapper> bugwrapperlist{
        get;
        set;
    }
    public BugMassEditController(ApexPages.StandardSetController controller) {
        currentStep = '1';
        res = '';
        dmClassification = '';
        resolutionDetl = '';
        controller.setPageSize(200);
        fromPage = controller.cancel();
        listid = fromPage.getParameters().get('fcf');
        if (this.objs == null) {
            this.objs = controller.getSelected();
            isBugFalse = new List < Bug__c > ();
            bugId = new set < string > ();
            selectedBugId = new set < string > ();
            for (Bug__c bugRec: objs) {
                bugId.add(bugRec.id);
                if (bugRec.RecordTypeId != System.Label.CAD_Bug_Record_Type_Id && bugRec.RecordTypeId != System.Label.CDT_Bug_Record_Type_Id && bugRec.RecordTypeId != System.Label.PDK_Bug_Record_Type_Id && bugRec.RecordTypeId != System.Label.Legacy_Data_Record_Type_Id) {
                    isBugFalse.add(bugRec);
                    isNotBug = true;
                }
            }
        }
        if (getRecordSize() < 1) {
            String msg = 'No record was selected on the list view.  Please click Previous button and select records for mass update.';
            currentMsg = new ApexPages.Message(ApexPages.severity.ERROR, msg);
        } else if (!isBugFalse.isEmpty()) {
            String msg = '<b>Bug Mass Update is Applicable for Bug Record Only (CAD, CDT, PDK and Legacy Bug)</b>';
            currentMsg = new ApexPages.Message(ApexPages.severity.INFO, msg);
        } else {
            String msg = 'Number of records selected for update: ' + getRecordSize();
            currentMsg = new ApexPages.Message(ApexPages.severity.INFO, msg);
        }
        setPickListValues();
        ApexPages.addMessage(currentMsg);
        fetchListviewRecords();
    }
    public String getStep() {
        return currentStep;
    }
    
    public PageReference step1() {
        if (getRecordSize() < 1) return fromPage;
        currentStep = '1';
        return ApexPages.currentPage();
    }
    /*
    public PageReference step2() 
    {
        if (getRecordSize() < 1) return fromPage;
        currentStep = '2';
        return ApexPages.currentPage();
    }
    */
    public integer getRecordSize() {
        if (objs != null) {
            return objs.size();
        } else {
            return 0;
        }
    }
    public String fieldName {
        get;
        set {
            fieldName = value;
            field = fieldMap.get(value);
            fieldType = field.getDescribe().getType().name();
        }
    }
    public String fieldType {
        get;
        set;
    }
    public DescribeSObjectResult discoverSObjectType(SObject s) {
        Map < String, Schema.SObjectType > des = Schema.getGlobalDescribe();

        for (Schema.SObjectType o: des.values()) {
            if (s.getSObjectType() == o) {
                return o.getDescribe();
            }
        }
        return null;
    }
    public List < SelectOption > getFieldTypeOptions() {
        if (objs.size() < 1) return null;

        List < SelectOption > options = new List < SelectOption > ();
        Schema.DescribeSObjectResult sObj = discoverSObjectType(objs.get(0));

        fieldMap = sObj.fields.getMap();

        List < String > keys = sortByFieldLabel(fieldMap);

        for (String key: keys) {
            if (key == 'Status__c') {
                Schema.DescribeFieldResult d = fieldMap.get(key).getDescribe();

                if (d.isAccessible() && d.isUpdateable()) {
                    if (isSupportedFieldType(d)) {
                        String label = d.getLabel();
                        if (d.isCustom()) {
                            options.add(new SelectOption(key, label));

                        }
                    }
                }
            }
        }
        return options;
    }
    private List < String > sortByFieldLabel(Map < String, Schema.SObjectField > gd) {
        List < String > keys = new List < String > ();

        Map < String, List < String >> labelMap = new Map < String, List < String >> ();

        for (Schema.SObjectField s: gd.values()) {
            String label = s.getDescribe().getLabel();
            if (labelMap.get(label) == null) {
                labelMap.put(label, new List < String > ());
            }

            labelMap.get(label).add(s.getDescribe().getName());
        }

        List < String > labels = new List < String > (labelMap.keySet());
        labels.sort();

        for (String label: labels) {
            keys.addAll(labelMap.get(label));
        }

        return keys;
    }
    private boolean isSupportedFieldType(DescribeFieldResult d) {
        // always return true for now, but in future some fields might not be supported
        return true;
    }
    public PageReference step2() {
        selectedBugId.clear();
        if(!bugwrapperlist.isEmpty()){
            for(BugWrapper bugWrapperRecord:bugwrapperlist){
                if(bugWrapperRecord.selected == true){  
                    selectedBugId.add(bugWrapperRecord.bugObj.id);
                    }            
            }
            if(selectedBugId.size()>0){
                numberofSelectedRecords = selectedBugId.size();
                }   
            else{
                    Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'No record was selected.  Please select records for mass update.'));
                    return null;
                } 
        }  
        currentStep = '2';
        return ApexPages.currentPage();
    }

    public PageReference step3() {
        if (ststatus == '' || ststatus == null ) {
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Status Field cannot be Blank'));
            return null;
        }
        else if ((resolutionDetails == '') && (stStatus == 'Closed' || stStatus == 'Resolved' || stStatus == 'Verified')) {
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Resolution and Resolution Details fields are required when closing a bug.'));
            return null;
        }
        else {
            String msg = 'Please review your selections before confirm: <br></br>';
            
                msg = msg + '<br><b>Records Selected:</b>    ' + numberofSelectedRecords + '</br>';
                msg = msg + '<br><b>Field To Be Updated:</b> ' + 'Status';
                msg = msg + '<b>   New Value:</b>           ' + ststatus + '</br>';
                
                if(stResolution == null || stResolution == ''){
                        res = 'Resolution;';
                }
                else{
                        msg = msg + '<br><b>Field To Be Updated:</b> ' + 'Resolution';
                        msg = msg + '<b>   New Value:</b>           ' + stResolution + '</br>';
                        res = '';
                    }
                    
                 if(dmTeamClassification == null || dmTeamClassification == ''){
                        dmClassification = 'DmTeamClassification;';
                    }
                else{
                        msg = msg + '<br><b>Field To Be Updated:</b> ' + 'DM Team Classification';
                        msg = msg + '<b>   New Value:</b>           ' + dmTeamClassification + '</br>';
                        dmClassification = '';
                    }
                    
                if(resolutionDetails == null || resolutionDetails == ''){
                     resolutionDetl = 'ResolutionDetails';
                    }
                else {
                        msg = msg + '<br>Resolution Details New value <b>' + resolutionDetails + '</b> will be appended</br>';
                        resolutionDetl = '';
                    }
                
                if(resolutionDetl != '' || dmClassification !='' || res != ''){
                    msg = msg + '<br><b>Fields which are not part of current bulk update:</b> ' + res +'' + dmClassification + ''+ resolutionDetl+'</br>';
                    }
                    
            currentMsg = new ApexPages.Message(ApexPages.severity.INFO, msg);
            ApexPages.addMessage(currentMsg);
            currentStep = '3';
            return ApexPages.currentPage();
        }
    }

    public PageReference step4() 
    {
        hasUpdateError = false;
        bugSuccessList = new List < Bug__c > ();
        bugVsErrorMap = new map < Bug__c, string > ();
        List < Bug__c > bugList = new List < Bug__c > ();
        List < FeedItem > feedItemList = new List < FeedItem > ();

        Map < id, Bug__c > bugMapUpdate = new Map < id, Bug__c > ();
        set < string > setColName = new set < string > ();
        setColName.addAll(columnName);
        List < Bug__c > bugUpdateList = new List < Bug__c > ();
        if (!setColName.contains('Resolution_Details__c')) {
            setColName.add('Resolution_Details__c');
        }
        if (!setColName.contains('Component__c')) {
            setColName.add('Component__c');
        }
        string queryColumn = 'Name,';
        for (string eachCol: setColName) {
            queryColumn = queryColumn + eachCol + ',';
        }
        queryColumn = queryColumn.substring(0, queryColumn.length() - 1);
            
        string queryStringForBug = 'select ' + queryColumn + ' from Bug__c ' + ' where Id In : selectedBugId';
        
        bugUpdateList = Database.query(queryStringForBug);
        selectedBugId.clear();
        for (Bug__c bugRecord: bugUpdateList) {
            bugRecord.Status__c = stStatus;
            if(stResolution != null){
                bugRecord.Resolution__c = stResolution;
            }
            if (bugRecord.RecordTypeId == System.Label.PDK_Bug_Record_Type_Id) {
                if(dmTeamClassification != null ){                
                    bugRecord.DM_Team_Classification__c = dmTeamClassification;
                }
            }
            if(resolutionDetails != null ){
                if (bugRecord.Resolution_Details__c != null) {
                    string resolutionAppend = bugRecord.Resolution_Details__c + '<br></br>' + resolutionDetails;
                    bugRecord.Resolution_Details__c = resolutionAppend;
                } else {
                    bugRecord.Resolution_Details__c = resolutionDetails;
                }
            }
            bugList.add(bugRecord);
            bugMapUpdate.put(bugRecord.id, bugRecord);
        }
        String msg = '';
        String errorMsg = '';
        if (!bugList.isEmpty()) {
            Database.SaveResult[] srList = Database.update(bugList, false);
            // Iterate through each returned result
            for (Integer i = 0; i < srList.size(); i++) {
                if (srList.get(i).isSuccess()) {
                    msg = 'Updated all the Records';
                    srList.get(i).getId();
                    bugSuccessList.add(bugMapUpdate.get(srList.get(i).getId()));
                    //Chatter Comment
                    if (chatterComment != null && chatterComment.trim() != '') {
                        FeedItem feeditemVar = new FeedItem();
                        feeditemVar.parentid = srList.get(i).getId();
                        feeditemVar.Body = chatterComment;
                        feedItemList.add(feeditemVar);
                    }
                } else if (!srList.get(i).isSuccess()) {
                    // DML operation failed
                    Database.Error error = srList.get(i).getErrors().get(0);
                    String failedDML = error.getMessage();
                    bugList.get(i); //failed record from the list
                    errorMsg = 'Below records are not updated.Click on the Bug Number to see the bug details.';
                    bugVsErrorMap.put(bugMapUpdate.get(bugList.get(i).id), failedDML);
                }
            }

        }
        if (!feedItemList.isEmpty()) {
            insert feedItemList;
        }

        if (errorMsg != '') {
            currentMsg = new ApexPages.Message(ApexPages.severity.ERROR, errorMsg);
            hasUpdateError = true;
        } else {
            currentMsg = new ApexPages.Message(ApexPages.severity.Info, msg);
        }
        ApexPages.addMessage(currentMsg);
        currentStep = '4';
        return ApexPages.currentPage();
    }
    public void setPickListValues() {
        list < BugStatusResolutionMapping__c > bugStatusResList = BugStatusResolutionMapping__c.getall().values();
        statusList = new list < SelectOption > ();
        dmTeamList = new list < SelectOption > ();
        Schema.DescribeFieldResult fieldResult;
        List < Schema.PicklistEntry > schemaList;
        statusList.add(new SelectOption('', '--None--'));
        for (BugStatusResolutionMapping__c sr: bugStatusResList) {
            statusList.add(new SelectOption(sr.name, sr.name));
        }

        fieldResult = Bug__c.DM_Team_Classification__c.getDescribe();
        schemaList = fieldResult.getPicklistValues();
        dmTeamList.add(new SelectOption('', '--None--'));
        for (Schema.PicklistEntry f: schemaList) {
            dmTeamList.add(new SelectOption(f.getLabel(), f.getValue()));
        }

    }
    public List < SelectOption > getResolution() {
        Map < String, BugStatusResolutionMapping__c > bugStatusResList = BugStatusResolutionMapping__c.getall();
        List < SelectOption > options = new List < SelectOption > ();
        options.add(new SelectOption('', '--None--'));
        if (ststatus != '') {
            if (bugStatusResList.containsKey(ststatus)) {
                options.clear();
                string str = bugStatusResList.get(ststatus).Resolution__c;
                options.add(new SelectOption('', '--None--'));
                for (string st: str.split(',')) {
                    if (st != '') {
                        options.add(new SelectOption(st, st));
                    }

                }
            }
        }
        return options;
    }
    public PageReference ExportExcelErrorLog() {
        PageReference r;
        try {
            isSuccess = false;
            isFailure = true;
            updateFileName = 'Mass Update Error Log File';
            r = new PageReference('/apex/bugMassUpdate_Excel');
            r.setredirect(false);
            if(Test.isRunningTest()) {
                throw new applicationException('In Test Mode');
            }
        } catch (Exception e) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, e.getmessage()));
            //Adding code for exception framework
            ApplicationLogWrapper alw=new ApplicationLogWrapper();
            alw.source =BugMassEditController.class.getName();
            alw.sourceFunction ='ExportExcelErrorLog()';
            alw.ApplicationName='Case Management';
            List<String> bugidList=new List<String>();
            bugidList.addAll(bugid);
            alw.referenceId =String.join(bugidList,';');
            alw.referenceInfo='Bug';
            alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
            alw.debugLevel ='Error';
            alw.logCode =e.getTypeName();
            alw.ex=e.getCause();
            GlobalUtility.logMessage(alw);
        }
        return r;
    }
    public PageReference ExportExcelSuccessLog() {
        PageReference r;
        try {
            isFailure = false;
            isSuccess = true;
            updateFileName = 'Mass Update Success Log File';
            r = new PageReference('/apex/bugMassUpdate_Excel');
            r.setredirect(false);
            if(Test.isRunningTest()) {
                throw new applicationException('In Test Mode');
            }
        } catch (Exception e) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, e.getmessage()));
            //Adding code for exception framework
            ApplicationLogWrapper alw=new ApplicationLogWrapper();
            alw.source =BugMassEditController.class.getName();
            alw.sourceFunction ='ExportExcelSuccessLog()';
            alw.ApplicationName='Case Management';
            List<String> bugidList=new List<String>();
            bugidList.addAll(bugid);
            alw.referenceId =String.join(bugidList,';');
            alw.referenceInfo='Bug';
            alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
            alw.debugLevel ='Error';
            alw.logCode =e.getTypeName();
            alw.ex=e.getCause();
            GlobalUtility.logMessage(alw);
        }
        return r;
    }
    public List < String > columnName {
        get;
        set;
    }
    public Map < String, String > columnMap {
        get;
        set;
    }
    public List < Bug__c > listSobject {
        get;
        set;
    }
    public transient String ObjectName;
    public void fetchListviewRecords() {
        columnName = new List < String > ();
        columnMap = new Map < String, String > ();
        ObjectName = 'Bug__c';
        if (listid != null && this.ObjectName != null) {
            //Http callout 
            callHttpRequest();
        }
    }
    
    public void callHttpRequest() {
        try {
            List < StandardListViewExportAPI.Columns > parserCol;
            parserCol = new List < StandardListViewExportAPI.Columns > ();
            Map < String, Object > root;
            listSobject = new List < Bug__c > ();
            List < Bug__c > listSobjectTemp = new List < Bug__c > ();
            HttpResponse res;
            // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
            HttpRequest req = new HttpRequest();
            req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionID());
            req.setHeader('Content-Type', 'application/json');
            String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
            String endpointUrl = baseUrl;

            if (UserInfo.getUserType() != 'Standard') {
                endpointUrl += '/GlobalfoundryView';
            } else {
                if (baseUrl.containsIgnoreCase('GlobalfoundryView')) {
                    endpointUrl += '/GlobalfoundryView';
                }
            }

            endpointUrl += '/services/data/v32.0/sobjects/' + ObjectName + '/listviews/' + listid + '/describe';
            req.setEndpoint(endpointUrl);
            req.setMethod('GET');
            req.setTimeout(120000);

            Http h = new Http();

            // Invoke web service call        
            if (!Test.isRunningTest()) {
                res = h.send(req);
                root = (Map < String, Object > ) JSON.deserializeUntyped(res.getBody());

                JSONParser parser = JSON.createParser(res.getBody());
                //Parsing JSON string to get the column details
                while (parser.nextToken() != null) {
                    if (parser.getCurrentToken() == JSONToken.START_ARRAY) {
                        while (parser.nextToken() != null) {
                            if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                                StandardListViewExportAPI.Columns le = (StandardListViewExportAPI.Columns) parser.readValueAs(StandardListViewExportAPI.Columns.class);
                                parserCol.add(le);
                            }
                        }
                    }
                }
            } else {
                StandardListViewExportAPI.Columns le = new StandardListViewExportAPI.Columns();
                parserCol.add(le);
            }
            for (StandardListViewExportAPI.Columns lc: parserCol) {
                if (lc.hidden == false && lc.fieldNameOrPath != Null) {
                    if (lc.fieldNameOrPath != 'Name' && lc.fieldNameOrPath != 'Resolution_Details__c' && lc.fieldNameOrPath != 'Bug_Description__c') {
                        columnName.add(lc.fieldNameOrPath);
                        columnMap.put(lc.fieldNameOrPath, lc.label);
                    }
                }

            }
            string queryColumn = 'Name,';

            for (string eachCol: columnName) {
                queryColumn = queryColumn + eachCol + ',';
            }
            queryColumn = queryColumn.substring(0, queryColumn.length() - 1);
            string queryStringForBug = 'select ' + queryColumn + ' from Bug__c ' + ' where Id In : bugId';
            listSobject = Database.query(queryStringForBug);
            
            if(bugwrapperlist == null){
                bugwrapperlist = new list<BugWrapper>();
                for(Bug__c bu:listSobject){
                        bugwrapperlist.add(new BugWrapper(bu));
                }   
            }
            if(Test.isRunningTest()) {
                throw new applicationException('In Test Mode');
            }
        } 
        catch (Exception e){ 
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, e.getmessage()));
            //Adding code for exception framework
            ApplicationLogWrapper alw=new ApplicationLogWrapper();
            alw.source =BugMassEditController.class.getName();
            alw.sourceFunction ='callHttpRequest()';
            alw.ApplicationName='Case Management';
            List<String> bugidList=new List<String>();
            bugidList.addAll(bugid);
            alw.referenceId =String.join(bugidList,';');
            alw.referenceInfo='Bug';
            alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
            alw.debugLevel ='Error';
            alw.logCode =e.getTypeName();
            alw.ex=e.getCause();
            GlobalUtility.logMessage(alw);
        }
    }
    
    public class BugWrapper{          
        public Bug__c bugObj{get;set;}
        public Boolean selected {get; set;}
        public BugWrapper(Bug__c bugrecord){
          selected = true;
          bugObj = bugrecord;

        }
    }
    public class applicationException extends Exception {}
}