/*Author: Karthick D
* Description: This is controller class for ViewRelatedBugList page. 
               Displays the list of related bugs in the bug Detail page.
* History: Created on 04/10/2014
*/
public with sharing class ViewRelatedBugList {
    public string bugId;
    public ViewRelatedBugList(ApexPages.StandardController controller) {
            bugid = apexpages.currentpage().getparameters().get('id');
        }
        //Method returns list of related bugs.
    public list < RelatedBugAssociation__c > getRelatedBugList() {

        return [select id, buga__c, bugb__c, buga__r.id, bugb__r.id, buga__r.name, bugb__r.name, Relasionship__c,BugA_Title__c,BugB_Title__c from RelatedBugAssociation__c where buga__c = : bugid or bugb__c = : bugid];
    }
  
    //Method redirects to the Manage related Bug page
    public pageReference redirecttoBug() {
        PageReference newocp;
        try {
            string st = '/apex/managerelatedbug?id=' + bugid;
            newocp = new PageReference(st);
            newocp.setRedirect(false);

        } catch (exception e) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, e.getmessage()));
        }
        return newocp;
    }
}