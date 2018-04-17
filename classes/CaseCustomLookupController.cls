/*
Type Name: CaseCustomLookupController 
Author: Cognizant Case Management Team
Created Date: 26-Feb-2014
Reason: Custom Case Lookup functionality
Change History:
Author: 
Modified Date: 
Reason: 
*/
public class CaseCustomLookupController {

    private final Map < String, Schema.SObjectType > globalDescribe = Schema.getGlobalDescribe();
    public Boolean isErrorMessages {
        get;
        set;
    }
    public Case objCase {
        get;
        set;
    } // new case to create
    public List < Case > results {
        get;
        set;
    } // search results
    public String messages {
        get;
        set;
    } // search results

    public string searchString {
        get;
        set;
    } // search keyword
    public String searchItems = 'CaseNumber'; // selected Item
    public List < SelectOption > items {
        get;
        set;
    } // Radio button option
    public List < String > selectedFields {
        get;
        set;
    }
    
    /**
    Constructor of the Class
    @Constructor name: CaseCustomLookupController
    @parameter:   NA.
    @return :     NA.
    **/
    public CaseCustomLookupController() {
        objCase = new Case();
        // get the current search string
        searchString = System.currentPageReference().getParameters().get('lksrch');
        runSearch();
        selectedFields = new List < String > ();
        items = getItems();
        getSearchResultItems();
    }
    
    /**
    This method is used for populate FieldSetMember for Case object
    @method name: getSearchResultItems
    @parameter:   NA.
    @return :     NA.
    **/
    public void getSearchResultItems() {
    
        //List < String > lstFS = New List < String > ();
        Schema.DescribeSObjectResult res = globalDescribe.get('Case').getDescribe();
        List < Schema.FieldSetMember > fields = res.fieldSets.getMap().get('CaseLookupSearchResults').getFields();

        for (Schema.FieldSetMember fsm: fields) {            
            selectedFields.add(fsm.getFieldPath());
        }
    }
    
    /**
    This method is used for creating Radio button option for Case Search
    @method name: getItems
    @parameter:   NA.
    @return :     List < SelectOption >
    **/
    public List < SelectOption > getItems() {
        List < SelectOption > options = new List < SelectOption > ();
        options.add(new SelectOption('CaseNumber', 'Case Number')); // Don't remove this Case Number Field
       
        //List < String > lstFS = New List < String > ();
        Schema.DescribeSObjectResult res = globalDescribe.get('Case').getDescribe();
        List < Schema.FieldSetMember > fields = res.fieldSets.getMap().get('CaseLookupFilterFields').getFields();

        for (Schema.FieldSetMember fsm: fields) {
            options.add(new SelectOption(fsm.getFieldPath(), fsm.getLabel()));            
        }
        options.add(new SelectOption('AllFields', 'All Fields'));
        return options;
    }
    
    public String getSearchItems() {
        return searchItems;
    }
    public void setSearchItems(String searchItems) {
        this.searchItems = searchItems;
    }

    
    /**
    This method is used to performs the keyword search
    @method name: search
    @parameter:   NA.
    @return :     NA
    **/
    public PageReference search() {
        runSearch();
        return null;
    }
    
    /**
    This method is used to prepare the query and issue the search command
    @method name: runSearch
    @parameter:   NA.
    @return :     NA
    **/
    private void runSearch() {
        try {
            // prepare query string for complex serarches & prevent injections
            isErrorMessages = false;

            if (searchString != '' && searchString != null) {
                if (searchString.length() == 1) {
                    isErrorMessages = true;
                    results = New List < Case > ();
                } else {
                    messages = 'Sarch Results :';
                    results = performSearch(searchString.trim());//MM-:added trim() 
                }
            } else {
                messages = 'Recently Viewed :';
                results = performRecentlyViewed();
            }
        } catch (Exception e) { ApexPages.addMessages(e);}// Don't redirect if something goes wrong. May be a validation or trigger issue on save.  
    }

    /**
    This method is used to prepare the query based on the Recently Viewed Cases
    @method name: performRecentlyViewed
    @parameter:   NA.
    @return :     List of Cases
    **/
    private List < Case > performRecentlyViewed() {
        List < Case > lstCase = New List < Case > ();
        String query;
        query = createSOQLString('Case', 'CaseLookupSearchResults');
        //Modified by <Monalisa Mohapatra> Case #00052792 – Start
        query = query + ' WHERE LastViewedDate != NULL ORDER BY LastViewedDate DESC LIMIT 20'; //MM-Added16May16
        //query = query + ' AND LastViewedDate != NULL ORDER BY LastViewedDate DESC LIMIT 20'; //MM-:Commented to display all case records      
        //Modified by <Monalisa Mohapatra> Case #00052792 - End
        lstCase = database.query(query);
        return lstCase;
    }

    /**
    This method is used to run the search and return the records found
    @method name: performSearch
    @parameter:   NA.
    @return :     List of Cases
    **/
    private List < Case > performSearch(string searchString) {
        List < Case > lstCase = New List < Case > ();
        List < Case > lstCaseRet = New List < Case > ();
        String query;
        try {
            if (searchItems == 'AllFields') {
                String queryString = createSOSLString('Case', 'CaseLookupSearchResults');
                query = ' FIND\'*' + searchString + '*\' IN ALL FIELDS RETURNING ' + queryString + '';                
                List < List < SObject >> searchList = search.query(query);
                lstCase = ((List < Case > ) searchList[0]);
            } else {
                query = createSOQLString('Case', 'CaseLookupSearchResults');
                if (searchString != '' && searchString != null){
                    //Modified by <Monalisa Mohapatra> Case #00052792 – Start
                    query = query + ' WHERE ' + searchItems + ' LIKE \'%' + searchString + '%\'';//MM-:Added
                    //query = query + ' AND ' + searchItems + ' LIKE \'%' + searchString + '%\'';//MM-:Commented to display all case records 
                    //Modified by <Monalisa Mohapatra> Case #00052792 - End
                }
                    
                query = query + ' ORDER By LastModifiedDate DESC LIMIT 20';
                lstCase = database.query(query);
            }            
        } catch (Exception e) {ApexPages.addMessages(e);} // Don't redirect if something goes wrong. May be a validation or trigger issue on save.  
        
        return lstCase;
    }

    /**
    This method is used by the visualforce page to send the link to the right dom element
    @method name: getFormTag
    @parameter:   NA.
    @return :     string 
    **/
    public string getFormTag() {
        return System.currentPageReference().getParameters().get('frm');
    }

    /**
    This method is used by the visualforce page to send the link to the right dom element for the text box
    @method name: getTextBox
    @parameter:   NA.
    @return :     string 
    **/
    public string getTextBox() {
        return System.currentPageReference().getParameters().get('txt');
    }

    /**
    This method is used for creating SOSL String from Object & corresponding Field Set Name
    @method name: createSOSLString
    @parameter:   String object Name, String fieldSet Name
    @return :     String.
    **/
    public string createSOSLString(string sObjectName, string fieldSetName) {
        String query = sObjectName + '(Id, CaseNumber,Case_Record_Type_API__c ';

        Schema.DescribeSObjectResult res = globalDescribe.get(sObjectName).getDescribe();
        Map < String, Schema.FieldSet > fieldSetMap = res.fieldSets.getMap();
        Schema.FieldSet fs = fieldSetMap.get(fieldSetName);

        for (Schema.FieldSetMember fsm: fs.getFields()) {
            query = query + ',' + fsm.getFieldPath();
        }
        //Modified by <Monalisa Mohapatra> Case #00052792 – Start
        query = query + ' ORDER BY LastModifiedDate DESC LIMIT 20)';//MM-:Added to display all case records irrespective of record types
        //query = query + ' WHERE CustomerRecordType__c = true ORDER BY LastModifiedDate DESC LIMIT 20)';//MM-:Commented to display all case records irrespective of record types
        //Modified by <Monalisa Mohapatra> Case #00052792 - End
        return query;
    }
    
    /**
    This method is used for creating SOQL String from Object & corresponding Field Set Name
    @method name: createSOQLString
    @parameter:   String object Name, String fieldSet Name
    @return :     String.
    **/
    public string createSOQLString(string sObjectName, string fieldSetName) {
        String query = 'SELECT Id, CaseNumber,Case_Record_Type_API__c ';
        Schema.DescribeSObjectResult res = globalDescribe.get(sObjectName).getDescribe();
        Map < String, Schema.FieldSet > fieldSetMap = res.fieldSets.getMap();
        Schema.FieldSet fs = fieldSetMap.get(fieldSetName);

        for (Schema.FieldSetMember fsm: fs.getFields()) {
            query = query + ',' + fsm.getFieldPath();
        }
        //Modified by <Monalisa Mohapatra> Case #00052792 – Start
        query = query + ' from ' + sObjectName;//MM-:Added to display all case records irrespective of record types
        //query = query + ' from ' + sObjectName + ' WHERE CustomerRecordType__c = true ';//MM-:Commented to display all case records irrespective of record types
        //Modified by <Monalisa Mohapatra> Case #00052792 - End
        return query;
    }

}