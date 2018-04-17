/*
Type Name: CVASurveyController 
Author: Vijay Vemuru
Created Date: 13th-Mar-2016
Reason: This class is used for CVA Survey.
Test Class: CVASurveyControllerTest
Change History:
Author: 
Modified Date: 
*/
public class CVASurveyController {

    Public CustomerSurveySetting__c setting { get; set;}  
    public CVA_Survey__c varSurvey { get; set;} 
    public Visitation_record__c varCase{ get; set;}   
   
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
    @Constructor name: CVASurveyController
    @parameter:   NA.
    @return :     NA.
    **/
    public CVASurveyController() {

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
                if(varCase.End_Date__c !=null){
                    string closeDate = string.valueOf(varCase.End_Date__c);
                    varSurvey.UniqueId__c = string.valueOf(varSurvey.CVA__c) + string.valueOf(varSurvey.Record_Owner__c) + closeDate.trim();
                    DuplicateChecking();
                }else {
                    variableInitializationError(true);
                    message = system.Label.Customer_CVA_Survey_Link_Not_Valid;
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
            fslistQuestion = getFieldSetItems('CVA_Survey__c', 'CVASurveyFieldsQuestion');
            fslistComments = getFieldSetItems('CVA_Survey__c', 'CVASurveyFieldsComments');
            fslistPreview = getFieldSetItems('CVA_Survey__c', 'CVASurveyFieldsQuestionReadOnly');
            fslistInternal = getFieldSetItems('CVA_Survey__c', 'CVASurveyFieldsQuestionInternal');
            fslistCase = getFieldSetItems('Visitation_record__c', 'CVASurveyFields');
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
    This method is used for checking Duplicate survey for per User\CVA.
    @method name: DuplicateChecking
    @parameter:   NA.
    @return :     NA.
    **/
    private void DuplicateChecking(){

        try {
            Integer count = [SELECT count() FROM CVA_Survey__c WHERE UniqueId__c = : varSurvey.UniqueId__c LIMIT 1];
            if (count > 0) {
                variableInitializationDuplicate(true);

                Map < String, Schema.SObjectField > fldObjMap = schema.SObjectType.CVA_Survey__c.fields.getMap();
                List < Schema.SObjectField > fldObjMapValues = fldObjMap.values();

                string theQuery = createQueryStringField(fldObjMapValues, 'CVA_Survey__c', varSurvey.UniqueId__c);
                CVA_Survey__c[] ListSurvey = Database.query(theQuery);
                varSurvey = ListSurvey[0];
            }
        }
        Catch(Exception e) {variableInitializationError(true);}
    }

    /**
    This method is used for final submition of CVA Survey.
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
    public CVA_Survey__c getParameters() {
        CVA_Survey__c survey = New CVA_Survey__c();
        //survey.name= varCase.name;

        Map < String, String > strMap = ApexPages.currentPage().getParameters();
        try {
            if (strMap != null && strMap.Size() > 0) {

                if (strMap.get('Survey_Score__c') != null) {
                    survey.Survey_Score__c = decimal.valueOf(strMap.get('Survey_Score__c'));
                    rate = strMap.get('Survey_Score__c');
                } else {
                    isInternal = true;
                }

                if (strMap.get('CVA') != null && validateId(strMap.get('CVA')) != null) {
                    survey.CVA__c = strMap.get('CVA');
                } else {
                    isInternal = false;
                }
                if (strMap.get('Record_Owner__c') != null && validateId(strMap.get('Record_Owner__c')) != null) {
                    survey.Record_Owner__c = strMap.get('Record_Owner__c');
                } else {
                    isInternal = false;
                }
     
                if (survey.CVA__c != null && survey.Record_Owner__c != null) {
                    string theQuery = createQueryStringFieldSet('Visitation_record__c', 'CVASurveyFields', survey.CVA__c);
                    Visitation_record__c[] ListCase = Database.query(theQuery);
                    varCase = ListCase[0];
                    survey.name = varcase.name;
                }
            }
        }
        Catch(Exception e) {variableInitializationError(true);}

        return survey;
    }
    
    
    /**
    This method is used for Insert\Update CVA survey records
    @method name: SaveRecords
    @parameter:   CVA_Survey__c object.
    @return :     Boolean success
    **/
    private Boolean SaveRecords(CVA_Survey__c survey) {
        Boolean isSuccess = false;
        try {
            if (survey != null && survey.CVA__c != null && isDup == false && isError == false) {
                if(varCase.Customer_Status__c != '5. Closed - Completed' ) {
                    varCase.Customer_Status__c = '5. Closed - Completed';
                    update varCase;
                }
                upsert survey;
                isSuccess = true;
            }
        }
        Catch(Exception e) {System.Debug('********'+e.getmessage());
        variableInitializationError(true);}

        return isSuccess;

    }

    /**
    This method is used for insert CVA survey on Page Load.
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

        if (sObjectName == 'Visitation_record__c') {
            query = 'SELECT Id,End_Date__c,Customer_Status__c   ';
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
    @parameter:   String CVA Id.
    @return :     String CVA Id.
    **/
    static public String validateId(String Idparam) {
        String id = String.escapeSingleQuotes(Idparam);
        if ((id.length() == 15 || id.length() == 18) && Pattern.matches('^[a-zA-Z0-9]*$', id) && ((id.startsWith('a2K')) || (id.startsWith('005')))) {
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
            message = system.Label.Customer_CVA_Survey_Message5;
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
            message = system.Label.Customer_CVA_Survey_Message4;
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