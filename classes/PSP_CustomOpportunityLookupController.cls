public with sharing class PSP_CustomOpportunityLookupController {

    public Opportunity Opportunity {get;set;} // Opportunity instance
    public List<Opportunity> results{get;set;} // search results
    public string searchString{get;set;} // search keyword

    public PSP_CustomOpportunityLookupController() {
        Opportunity = new Opportunity();
        // get the current search string
        searchString = System.currentPageReference().getParameters().get('lksrch');
        runSearch();  
    }

    // performs the keyword search
    public PageReference search() {
        runSearch();
        return null;
    }

    // prepare the query and issue the search command
    private void runSearch() {
        // TODO prepare query string for complex searches & prevent injections
        results = performSearch(searchString);               
    } 

    // run the search and return the records found. 
    private List<Opportunity> performSearch(string searchString){
        String soql = 'select id,name,Market_Segment__c,Opportunity_Health__c,Process_Geometry__c,Process_Family__c from Opportunity';
        if(searchString != '' && searchString != null)
        soql = soql +  ' where name LIKE \'%' + searchString +'%\'';
        soql = soql + ' order by name limit 25';
        System.debug(soql);
        return database.query(soql);
    }

    // used by the visualforce page to send the link to the right dom element
    public string getFormTag() {
        system.debug('####Txt###'+System.currentPageReference().getParameters().get('frm'));
        return System.currentPageReference().getParameters().get('frm');
    }

    // used by the visualforce page to send the link to the right dom element for the text box
        public string getTextBox() {
        system.debug('####Txt###'+System.currentPageReference().getParameters().get('txt'));
        return System.currentPageReference().getParameters().get('txt');
    }
}