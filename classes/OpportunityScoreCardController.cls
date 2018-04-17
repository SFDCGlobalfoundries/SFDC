/*……………………………………………………………………………..
Type Name: OpportunityScoreCardController 
Author: Cognizant
Created Date: 5/31/2014
Reason: This class is used for opportunity ScoreCard
Test Class: OpportunityScoreCardControllerTest
Change History:
Author: 
Modified Date: 
………………………………………………………………………………..*/
public class OpportunityScoreCardController {

    public final string oppId {
        get;
        set;
    }
    final Map < String, Schema.SObjectField > fldObjMap = schema.SObjectType.Opportunity_ScoreCard__c.fields.getMap();
    final List < Schema.SObjectField > fldObjMapValues = fldObjMap.values();
    public Opportunity_ScoreCard__c oppScoreCard {
        get;
        set;
    }
    private final Map < String, Schema.SObjectType > globalDescribe = Schema.getGlobalDescribe();
    public boolean isUpdate{get; set;}


    public OpportunityScoreCardController(ApexPages.StandardController controller) {
           
        isUpdate = false;
        
        if (ApexPages.currentPage().getParameters().get('oid') != null) {
            oppId = validateId(ApexPages.currentPage().getParameters().get('oid'));
        }
        if (oppId != null) {
                if (DuplicateChecking()){
                    oppScoreCard = createQueryString();
               
            } else {
                oppScoreCard = getParameters();
            }
        }
    }
    
    
     /**
    This method is used for getting values form Page .
    @method name: getParameters
    @parameter:   NA.
    @return :     Opportunity_ScoreCard__c object
    **/
    public Opportunity_ScoreCard__c getParameters() {
        Opportunity_ScoreCard__c objScore = New Opportunity_ScoreCard__c();
       
        try {
            if (oppId != null) {
                objScore.Opportunity__c = oppId;
                objScore.UniqueId__c = oppId;
                return objScore;
            } else { return null;}

        }
        Catch(Exception e) {return null;}
    }
    /**
    This method is used for the Duplicate Check of Opportunity Score Card .
    @method name: DuplicateChecking
    @parameter:   NA.
    @return :     NA.
    **/
    private boolean DuplicateChecking() {
        try {
            
            Integer count = [SELECT count() FROM Opportunity_ScoreCard__c WHERE Opportunity__c = : OppId LIMIT 1];
            if (count > 0) {
                isUpdate = true;
            }
        }
        Catch(Exception e) {isUpdate = false;}
        return isUpdate;
    }
    
    /**
    This method is used for the update of Opportunity Score Card .
    @method name: updateScoreCard
    @parameter:   NA.
    @return :     NA.
    **/
    public PageReference updateScoreCard() {
        PageReference pageRef;
        try {
            upsertScoreCard();            
            pageRef = new PageReference('/apex/OpportunityScoreCard?oid=' + oppId);
            pageRef.setRedirect(true);
        }
        Catch(Exception e) {}
        return pageRef;
    }
    
    
    /**
    This method is used for the insertion of Opportunity Score Card .
    @method name: insertScoreCard
    @parameter:   NA.
    @return :     NA.
    **/
    public PageReference insertScoreCard() {        
        try {
                upsertScoreCard();
                oppScoreCard = createQueryString();
                isUpdate = true;
        }
        Catch(Exception e) {}
        return null;
    }

    
    /**
    This method is used for the upsert of Opportunity Score Card .
    @method name: upsertScoreCard
    @parameter:   NA.
    @return :     NA.
    **/
    public void upsertScoreCard() {

        try {
            system.debug('############2oppScoreCard.UniqueId__c ' + oppScoreCard.UniqueId__c);
            if (oppScoreCard != null) {
                upsert oppScoreCard oppScoreCard.UniqueId__c;
            }

        }
        Catch(Exception e) {}
    }
    
    /**
    This method is used for  .
    @method name: createQueryString
    @parameter:   NA.
    @return :     Opportunity_ScoreCard__c Object.
    **/
    public Opportunity_ScoreCard__c createQueryString() {
        Opportunity_ScoreCard__c objScore = New Opportunity_ScoreCard__c();
        String theQuery = 'SELECT ';
        String oid = ApexPages.currentPage().getParameters().get('oid');
        for (Schema.SObjectField s: fldObjMapValues) {
            String theLabel = s.getDescribe().getLabel(); // Perhaps store this in another map
            String theName = s.getDescribe().getName();

            // Continue building your dynamic query string
            theQuery += theName + ',';
        }

        // Trim last comma
        theQuery = theQuery.subString(0, theQuery.length() - 1);

        // Finalize query string
        theQuery += ' FROM Opportunity_ScoreCard__c WHERE Opportunity__c = ' + '\'' + oid + '\' LIMIT 1';

        // Make your dynamic call
        Opportunity_ScoreCard__c[] ListScorecards = Database.query(theQuery);
        objScore = ListScorecards[0];
        return objScore;
    }

    static public String validateId(String Idparam) {
        String id = String.escapeSingleQuotes(Idparam);
        if ((id.length() == 15 || id.length() == 18) && Pattern.matches('^[a-zA-Z0-9]*$', id) || (id.startsWith('006'))) {
            return id;
        }
        return null;
    }

    //Exporting the records to Excel file
    public pageReference ExportToExcel() {
        PageReference pageRef = new PageReference('/apex/OpportunityScoreCardExport?oid=' + oppId);
        //pageRef.setRedirect(true);
        return pageRef;
    }

    //Exporting the records to Excel file
    public pageReference ScoreCardWrite() {
        PageReference pageRef = new PageReference('/apex/OpportunityScoreCardWrite?oid=' + oppId);
        pageRef.setRedirect(true);
        return pageRef;
    }

    //Return to the opportunity in Return
    public pageReference returnFunction() {
        PageReference pageRef;
        if (oppId != NULL && oppId != '') {
            pageRef = new PageReference('/' + oppId);
            pageRef.setRedirect(true);
        } else {
            pageRef = new PageReference('/home/home.jsp');
            pageRef.setRedirect(true);
        }
        return pageRef;
    }

}