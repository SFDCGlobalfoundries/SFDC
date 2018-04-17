/*……………………………………………………………………………..
Type Name: OpportunitySurveyController 
Author: Cognizant
Created Date: 27th-Apr-2014
Reason: This class is used for opportunity survey
Test Class: OpportunitySurveyControllerTest
Change History:
Author: 
Modified Date: 
………………………………………………………………………………..*/

public with sharing class OpportunitySurveyController{

    String Preview;
    public string reasonForLostDropped;
    public string inadequateLabel{get;set;}
    public string ScheduletoolateLabel{get;set;}     
    Public CustomerSurveySetting__c setting {
        get;
        set;
    }    
    
    public OpportunitySurvey__c varSurvey {
        get;
        set;
    }
    
    public List < String > fslistOpp { get; set;}     
    
    public String message {
        get;
        set;
    }

    public Boolean isMessage {
        get;
        set;
    }
    
    
    public Boolean isPreview {
        get;
        set;
    }
    
    public string statusMessage {
        get;
        set;
    }
    public Boolean isNotValid;

    public Map < String, String > mapStage;
    
    final Map < String, Schema.SObjectType > globalDescribe = Schema.getGlobalDescribe(); 
    
    final Map < String, Schema.SObjectField > fldObjMap = schema.SObjectType.OpportunitySurvey__c.fields.getMap();
    final List < Schema.SObjectField > fldObjMapValues = fldObjMap.values();

    public OpportunitySurveyController() {

        isMessage = false;
        isPreview = false;
        statusMessage = '';
        createStageMapping();
        setting = CustomerSurveySetting__c.getInstance();
        varSurvey = getParameters();

        if (ApexPages.currentPage().getParameters().get('Preview') != null) {
            Preview = ApexPages.currentPage().getParameters().get('Preview');
        }
        if (ApexPages.currentPage().getParameters().get('RFLD') != null) {
            reasonForLostDropped = ApexPages.currentPage().getParameters().get('RFLD');
        }
        
        if (varSurvey != null && isNotValid == false) {
                if(Preview =='true'){
                    varSurvey = createQueryString();
                    isPreview = true;                    
                    statusMessage = System.Label.OpportunitySurvey_Message4;
                }else{
                    isPreview = false;
                    if (DuplicateChecking()){                
                        varSurvey = createQueryString();
                    }
                }
            } else {
                isMessage = true;
                message = System.Label.OpportunitySurvey_ErrorMessage;
            }
         inadequateLabel =  OpportunitySurveyFormLabel__c.getInstance('InadequateTech').Value__c;   
         ScheduletoolateLabel = OpportunitySurveyFormLabel__c.getInstance('Scheduletoolate').Value__c; 
         System.debug(')))))))))))))'+ScheduletoolateLabel);
    }

    /**
    This method is used for creating mapping between Opportunity stages & Survey for.
    @method name: createStageMapping
    @parameter:   NA.
    @return :     NA.
    **/
    private void createStageMapping() {
        mapStage = new Map < String, String > ();
        
        //mapStage.put('Revenue', 'Won');
        //mapStage.put('Won', 'Won');
        mapStage.put('Lost', 'Lost');
        mapStage.put('Dropped', 'Dropped');
        mapStage.put('Void', 'Void');        
    }   
    
    /**
    This method is used for checking Duplicate survey for per User\Opportunity.
    @method name: DuplicateChecking
    @parameter:   NA.
    @return :     NA.
    **/
    private boolean DuplicateChecking() {
        Boolean isDuplicate = false; 
        try {
            Integer count = [SELECT count() FROM OpportunitySurvey__c WHERE SurveyFor__c = : varSurvey.SurveyFor__c AND Opportunity__c = : varSurvey.Opportunity__c AND Record_Owner__c = : varSurvey.Record_Owner__c LIMIT 1];
            if (count > 0) {
                isDuplicate = true;
            }
        }
        Catch(Exception e) { isDuplicate = false; }
        return isDuplicate;
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
    This method is used for getting values for URL.
    @method name: getParameters
    @parameter:   NA.
    @return :     OpportunitySurvey__c object
    **/
    public OpportunitySurvey__c getParameters() {
        OpportunitySurvey__c survey;
        isNotValid = true;
        Map < String, String > strMap = ApexPages.currentPage().getParameters();
        try {
            if (strMap != null && strMap.Size() > 0) 
            {
                survey = New OpportunitySurvey__c();
                
                if (strMap.get('Opportunity__c') != null && validateId(strMap.get('Opportunity__c')) != null) {
                    survey.Opportunity__c = strMap.get('Opportunity__c');
                    isNotValid = false;
                }

                if (strMap.get('Record_Owner__c') != null && validateId(strMap.get('Record_Owner__c')) != null) {
                    survey.Record_Owner__c = strMap.get('Record_Owner__c');
                    isNotValid = false;
                }
                if (strMap.get('SurveyFor__c') != null && strMap.get('SurveyFor__c') != '') {
                    survey.SurveyFor__c = mapStage.get(strMap.get('SurveyFor__c'));
                    isNotValid = false;
                }
                if (survey.Opportunity__c != null && survey.Record_Owner__c != null && strMap.get('SurveyFor__c') != null) {
                    survey.UniqueId__c = mapStage.get(strMap.get('SurveyFor__c')) + string.valueOf(survey.Opportunity__c) + string.valueOf(survey.Record_Owner__c);
                    isNotValid = false;
                }
            } 

        }
        Catch(Exception e) { isMessage = true; }
        return survey;
    }


    /**
    This method is used for final submition of Opportunity Survey.
    @method name: submitForm
    @parameter:   NA.
    @return :     NA.
    **/
    public PageReference submitForm() {

        if (varSurvey != null) {
            varSurvey.isSubmitted__c = True;
            isMessage = SaveRecords(varSurvey);
        }
        if (isMessage) {
            message = System.Label.OpportunitySurvey_Message2;
            varSurvey = createQueryString();
        }
        return null;
    }

    /**
    This method is used for Insert\Update opportunity survey records
    @method name: SaveRecords
    @parameter:   OpportunitySurvey__c object.
    @return :     Boolean success
    **/
    private Boolean SaveRecords(OpportunitySurvey__c survey) {
        try {
            if (survey != null && survey.Opportunity__c != null && survey.Record_Owner__c != null && survey.SurveyFor__c != null) {
                upsert survey UniqueId__c;
                opportunity opp = new opportunity (id=survey.Opportunity__c,IsFeedbackDone__c =true );
                if(reasonForLostDropped !=null){
                    opp.Reason_for_Loss_Dropped__c = reasonForLostDropped;
                }
                if (survey.SurveyFor__c.equalsignorecase('Lost')){
                    opp.stagename = '8. Lost';
                }else if(survey.SurveyFor__c.equalsignorecase('Dropped')){
                    opp.stagename = '9. Dropped';
                }else if(survey.SurveyFor__c.equalsignorecase('Void')){
                    opp.stagename = '10. Void';
                }
				TriggerHandler.bypass('Account_TriggerHandler');
                update opp;
                isPreview = true;
                statusMessage = System.Label.OpportunitySurvey_ThankMessage;                
                return true;
            } else {
                isMessage = true;
                message = System.Label.OpportunitySurvey_ErrorMessage;
                return false;
            }

        }
        Catch(Exception e) {
            isMessage = true;
            message = System.Label.OpportunitySurvey_ErrorMessage;
            Apexpages.addMessages(e);
            return false;
        }
    }
    
    /**
    This method is used for creating list items
    @method name: getItems
    @parameter:  NA
    @return :    list of option items.
    **/
    public list < SelectOption > getItems() {
        list < SelectOption > options = new list < SelectOption > ();
        options.add(new SelectOption('0', '0'));
        options.add(new SelectOption('1', '1'));
        options.add(new SelectOption('2', '2'));
        options.add(new SelectOption('3', '3'));
        options.add(new SelectOption('4', '4'));
        return options;
    }
    
    
    /**
    This method is used for  .
    @method name: createQueryString
    @parameter:   NA.
    @return :     OpportunitySurvey__c Object.
    **/
    public OpportunitySurvey__c createQueryString() {
        OpportunitySurvey__c objSurvey = New OpportunitySurvey__c();
        String theQuery = 'SELECT ';
                
        for (Schema.SObjectField s: fldObjMapValues) {
             String theLabel = s.getDescribe().getLabel(); // Perhaps store this in another map
             String theName = s.getDescribe().getName();

            // Continue building your dynamic query string
            theQuery += theName + ',';
        }

        // Trim last comma
        theQuery = theQuery.subString(0, theQuery.length() - 1);

        // Finalize query string
        theQuery += ' FROM OpportunitySurvey__c WHERE Opportunity__c = ' + '\'' + varSurvey.Opportunity__c + '\' AND Record_Owner__c = ' + '\'' + varSurvey.Record_Owner__c + '\' AND SurveyFor__c = ' + '\'' + varSurvey.SurveyFor__c + '\'LIMIT 1';

        // Make your dynamic call
        OpportunitySurvey__c[] ListSurvey = Database.query(theQuery);
        objSurvey = ListSurvey[0];
        fslistOpp = getFieldSetItems('OpportunitySurvey__c','OpportunityUpdatedDetails');
        return objSurvey;
    }


    /**
    This method is used for validating opportunity Ids & users Ids
    @method name: validateId
    @parameter:   String Opportunity Id, user Id.
    @return :     String Opportunity Id, user Id.
    **/
    static public String validateId(String Idparam) {
        String id = String.escapeSingleQuotes(Idparam);
        if ((id.length() == 15 || id.length() == 18) && Pattern.matches('^[a-zA-Z0-9]*$', id) || ((id.startsWith('006')) || (id.startsWith('500')))) {
            return id;
        }
        return null;
    }
}