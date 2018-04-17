public with sharing class PSP_CustomAccountLookupController {

    public Account account {get;set;} //account instance
    public List<Account> results{get;set;} // search results
    public string searchString{get;set;} // search keyword

    public PSP_CustomAccountLookupController() {
        account = new Account();
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
    private List<Account> performSearch(string searchString) {
        String soql = 'select id,name,Short_Name__c,Alias__c,Region__c,Sales_Territory__c from account';
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