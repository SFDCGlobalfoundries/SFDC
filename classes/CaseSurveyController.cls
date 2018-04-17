/*
Type Name: CaseSurveyController 
Author: Cognizant
Created Date: 24th-Mar-2014
Reason: This class is used for Customer Case Survey & which will be access in Case site.com portal.
Test Class: CaseSurveyControllerTest
Change History:
Author: 
Modified Date: 
……..
……..
--
*/
public class CaseSurveyController {

    Public CustomerSurveySetting__c setting { get; set;}  
    public CustomerSurvey__c varSurvey { get; set;} 
    public Case varCase{ get; set;}   
    public List<CaseComment> comments = new List<CaseComment>(); 
   
    public List < String > fslistQuestion { get; set;} 
    public List < String > fslistComments { get; set;}
    public List < String > fslistPreview { get; set;} 
    public List < String > fslistInternal { get; set;} 
    public List < String > fslistCase { get; set;} 
     
    public String rate { get; set;}
    public String message{ get; set;}
    
    public Boolean isUpdated {get;set;}
    public Boolean isLoaded {get; set;}
    public Boolean isDup {get; set;}
    public Boolean isError {get; set;}
    public Boolean isInternal {get;set;}
    
    private final Map < String, Schema.SObjectType > globalDescribe = Schema.getGlobalDescribe(); 


    /**
    Constructor of the Class
    @Constructor name: CaseSurveyController
    @parameter:   NA.
    @return :     NA.
    **/
    public CaseSurveyController() {

        isDup = false;
        isLoaded = false;
        isInternal = false;
        isUpdated = false;
        isError = false;

        populateFieldSets();
        setting = CustomerSurveySetting__c.getInstance();

        if (varSurvey == null) {
            varSurvey = getParameters();
        }

        if (varSurvey != null){
            if (varCase != null){
                if(varCase.IsClosed){
                    string closeDate = string.valueOf(varCase.ClosedDate);
                    varSurvey.UniqueId__c = string.valueOf(varSurvey.Case__c) + string.valueOf(varSurvey.Record_Owner__c) + closeDate.trim();
                    DuplicateChecking();
                }else {
                    variableInitializationError(true);
                    message = system.Label.Customer_Case_Survey_Link_Not_Valid;
                }                
            } 
        }
    }

    /**
    This method is used for populate FieldSets
    @method name: populateFieldSets
    @parameter:   NA.
    @return :     NA.
    **/
    private void populateFieldSets() {

        try {
            fslistQuestion = getFieldSetItems('CustomerSurvey__c', 'CustomerSurveyFieldsQuestion');
            fslistComments = getFieldSetItems('CustomerSurvey__c', 'CustomerSurveyFields');
            fslistPreview = getFieldSetItems('CustomerSurvey__c', 'CustomerSurveyFieldsQuestionReadOnly');
            fslistInternal = getFieldSetItems('CustomerSurvey__c', 'CustomerSurveyFieldsQuestionInternal');
            fslistCase = getFieldSetItems('Case', 'CaseSurveyFields');
        }
        Catch(Exception e) {variableInitializationError(true);}
    }

    /**
    This method is used for converting field set values into List of fields.
    @method name: getFieldSetItems
    @parameter:   NA.
    @return :     List of String with field name.
    **/
    public List < String > getFieldSetItems(string sObjectName, String fieldset) {
        List < String > Listfields = new List < String > ();
        Schema.DescribeSObjectResult res = globalDescribe.get(sObjectName).getDescribe();
        List < Schema.FieldSetMember > fields = res.fieldSets.getMap().get(fieldset).getFields();
        for (Schema.FieldSetMember fsm: fields) {
            Listfields.add(fsm.getFieldPath());
        }
        return Listfields;
    }

    /**
    This method is used for checking Duplicate survey for per User\Case.
    @method name: DuplicateChecking
    @parameter:   NA.
    @return :     NA.
    **/
    private void DuplicateChecking(){

        try {
            Integer count = [SELECT count() FROM CustomerSurvey__c WHERE UniqueId__c = : varSurvey.UniqueId__c LIMIT 1];
            if (count > 0) {
                variableInitializationDuplicate(true);

                Map < String, Schema.SObjectField > fldObjMap = schema.SObjectType.CustomerSurvey__c.fields.getMap();
                List < Schema.SObjectField > fldObjMapValues = fldObjMap.values();

                string theQuery = createQueryStringField(fldObjMapValues, 'CustomerSurvey__c', varSurvey.UniqueId__c);
                CustomerSurvey__c[] ListSurvey = Database.query(theQuery);
                varSurvey = ListSurvey[0];
            }
        }
        Catch(Exception e) {variableInitializationError(true);}
    }


    /**
    This method is used for final submition of Case Survey.
    @method name: submitForm
    @parameter:   NA.
    @return :     NA.
    **/
    public PageReference submitForm() {
        if (varSurvey != null && isDup == false && isError == false) {
            varSurvey.Submitted__c = true;
            variableInitializationUpdate(SaveRecords(varSurvey));   
        }
        return null;
    }

    /**
    This method is used for getting population radio button option
    @method name: getItems
    @parameter:   NA.
    @return :     List of Select option
    **/
    public list < SelectOption > getItems() {
        list < SelectOption > options = new list < SelectOption > ();
        options.add(new SelectOption('1', 'Very Dissatisfied'));
        options.add(new SelectOption('2', 'Dissatisfied'));
        options.add(new SelectOption('3', 'Fair'));
        options.add(new SelectOption('4', 'Satisfied'));
        options.add(new SelectOption('5', 'Very Satisfied'));
        return options;
    }

    /**
    This method is used for getting values from Page URL.
    @method name: getParameters
    @parameter:   NA.
    @return :     CustomerSurvey__c object
    **/
    public CustomerSurvey__c getParameters() {
        CustomerSurvey__c survey = New CustomerSurvey__c();

        Map < String, String > strMap = ApexPages.currentPage().getParameters();
        try {
            if (strMap != null && strMap.Size() > 0) {

                if (strMap.get('Survey_Score__c') != null) {
                    survey.Survey_Score__c = decimal.valueOf(strMap.get('Survey_Score__c'));
                    rate = strMap.get('Survey_Score__c');
                } else {
                    isInternal = true;
                }

                if (strMap.get('Case__c') != null && validateId(strMap.get('Case__c')) != null) {
                    survey.Case__c = strMap.get('Case__c');
                } else {
                    isInternal = false;
                }

                if (strMap.get('Record_Owner__c') != null && validateId(strMap.get('Record_Owner__c')) != null) {
                    survey.Record_Owner__c = strMap.get('Record_Owner__c');
                } else {
                    isInternal = false;
                }
                
                if (strMap.get('Case_re_open__c') != null) {
                    if(strMap.get('Case_re_open__c')=='true')
                        survey.Case_re_open__c = true;
                }

                if (survey.Case__c != null && survey.Record_Owner__c != null) {
                    string theQuery = createQueryStringFieldSet('Case', 'CaseSurveyFields', survey.Case__c);
                    Case[] ListCase = Database.query(theQuery);
                    varCase = ListCase[0];
                }
            }
        }
        Catch(Exception e) {variableInitializationError(true);}

        return survey;

    }
    
    
    /**
    This method is used for Insert\Update Case survey records
    @method name: SaveRecords
    @parameter:   CustomerSurvey__c object.
    @return :     Boolean success
    **/
    private Boolean SaveRecords(CustomerSurvey__c survey) {
        Boolean isSuccess = false;
        try {
            if (survey != null && survey.Case__c != null && isDup == false && isError == false) {
                upsert survey;
                isSuccess = true;
            }
        }
        Catch(Exception e) {variableInitializationError(true);}

        return isSuccess;

    }

    /**
    This method is used for insert Case survey on Page Load.
    @method name: rateSurvey
    @parameter:   NA.
    @return :     NA.
    **/
    public PageReference rateSurvey() {
        try {

            if (!isInternal) {
                if (varSurvey != null && isDup == false && isError == false) {
                    isLoaded = SaveRecords(varSurvey);
                }
            }
        }
        Catch(Exception e) {variableInitializationError(true);}
        return null;
    }

    /**
    This method is used for.
    @method name: createQueryStringField
    @parameter:   SObjectField , String object Name, String fieldSet Name, Unique Id.
    @return :     string.
    **/
    public string createQueryStringField(List < Schema.SObjectField > fldObjMapValues, string sObjectName, string objId) {

        string theQuery = 'SELECT ';

        for (Schema.SObjectField s: fldObjMapValues) {
            String theLabel = s.getDescribe().getLabel(); // Perhaps store this in another map
            String theName = s.getDescribe().getName();

            // Continue building your dynamic query string
            theQuery += theName + ',';
        }

        // Trim last comma
        theQuery = theQuery.subString(0, theQuery.length() - 1);

        // Finalize query string
        theQuery = theQuery + ' from ' + sObjectName + ' WHERE UniqueId__c= ' + '\'' + objId + '\' LIMIT 1';

        return theQuery;
    }

    /**
    This method is used for creating SOQL from Object & corresponding Field Set Name
    @method name: createQueryStringFieldSet
    @parameter:   String object Name, String fieldSet Name, record Id
    @return :     String.
    **/
    public string createQueryStringFieldSet(string sObjectName, string fieldSetName, string objId) {
        String query = '';

        if (sObjectName == 'Case') {
            query = 'SELECT Id,ClosedDate,IsClosed  ';
        } else {
            query = 'SELECT Id  ';
        }

        Schema.DescribeSObjectResult res = globalDescribe.get(sObjectName).getDescribe();
        Map < String, Schema.FieldSet > fieldSetMap = res.fieldSets.getMap();
        Schema.FieldSet fs = fieldSetMap.get(fieldSetName);

        for (Schema.FieldSetMember fsm: fs.getFields()) {
            query = query + ',' + fsm.getFieldPath();
        }

        query = query + ' from ' + sObjectName + ' WHERE Id= ' + '\'' + objId + '\' LIMIT 1';

        return query;
    }

    /**
    This method is used for validating Case Ids & users Ids
    @method name: validateId
    @parameter:   String Case Id.
    @return :     String Case Id.
    **/
    static public String validateId(String Idparam) {
        String id = String.escapeSingleQuotes(Idparam);
        if ((id.length() == 15 || id.length() == 18) && Pattern.matches('^[a-zA-Z0-9]*$', id) && ((id.startsWith('005')) || (id.startsWith('500')))) {
            return id;
        }
        return null;
    }

    /**
    This method is used for variable Initialization if Error occured
    @method name: variableInitializationError
    @parameter:   NA.
    @return :     NA.
    **/
    public void variableInitializationError(Boolean isBoolean) {
        if (isBoolean) {
            isError = true;
            isDup = false;
            isLoaded = false;
            isUpdated = false;
            isInternal = false;
            message = system.Label.Customer_Case_Survey_Message5;
        }
    }
    
    /**
    This method is used for variable Initialization if record already exists
    @method name: variableInitializationDuplicate
    @parameter:   NA.
    @return :     NA.
    **/
    public void variableInitializationDuplicate(Boolean isBoolean) {
        if (isBoolean) {
            isDup = true;
            isError = false;
            isLoaded = false;
            isUpdated = false;
            isInternal = false;
            message = system.Label.Customer_Case_Survey_Message4;
        }
    }
    
    /**
    This method is used for variable Initialization after Update 
    @method name: variableInitializationUpdate
    @parameter:   NA.
    @return :     NA.
    **/
    public void variableInitializationUpdate(Boolean isBoolean) {
        if (isBoolean) {
            isUpdated = true;
            isError = false;
            isDup = false;
            isLoaded = false;
            isInternal = false;
        }
    }
}