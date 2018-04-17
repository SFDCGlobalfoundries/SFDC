/*Author: Karthick D
 * Description: This class is controller class for ManageRelatedBug page
 * History: Created on 03/31/2014
 */
public with sharing class ManageRelatedBug {

    public RelatedBugAssociation__c relatedBugVar {get;set;}
    public bug__c bugVar {get;set;}
    public string bugId {get;set;}
    public list <RelatedBugAssociation__c> relatedBugList = new list <RelatedBugAssociation__c>();

    public ManageRelatedBug(ApexPages.StandardController controller) {
        relatedBugVar = new RelatedBugAssociation__c();
        bugId = apexpages.currentpage().getparameters().get('id');
        if ([select id, name from bug__c where id = : bugid].size() > 0) bugVar = [select id, name from bug__c where id = : bugid][0];
    }

    public list < RelatedBugAssociation__c > getRelatedBugs() {
        return [select id, buga__c, bugb__c, Relasionship__c,BugA_Title__c ,BugB_Title__c  from RelatedBugAssociation__c where BugA__c = : bugid or bugb__c = : bugid];
    }

    public PageReference addRelatedBug() {
        try {
            relatedBugVar.BugA__c = bugid;
            insert relatedBugVar;
            relatedBugVar = new RelatedBugAssociation__c();
        } catch (System.DmlException e) {
            if (!e.getDmlMessage(0).contains('already')) ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, e.getDmlMessage(0)));
        }
        return null;
    }

    public pageReference redirecttoBug() {
        bug__c bugtempVar = [select id from bug__c where id = : bugid];
        Pagereference pgBug = new ApexPages.StandardController(bugtempVar).view();
        pgBug.setRedirect(true);
        return pgBug;
    }

    public PageReference deleteRelatedBug() {
        delete[select id from RelatedBugAssociation__c where id = : relatedbugvar.id];
        relatedBugVar = new RelatedBugAssociation__c();
        return null;
    }
}