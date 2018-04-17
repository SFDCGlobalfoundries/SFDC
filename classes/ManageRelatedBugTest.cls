/*Author: Karthick D
* Description: Test Class for RelatedBugAssciation Trigger and
               ManageRelatedBug, ViewRelatedBug Controller.
* History: Created on : 05/04/2014
*/

@isTest(SeeAllData = false)
public class ManageRelatedBugTest {

    public static testMethod void RelatedBugTest() {
        Test.startTest();
        //Test Data Creation Starts
        Bug__c b = new Bug__c();
        b.bug_title__c = 'test';
        insert b;
        Bug__c b1 = new Bug__c();
        b1.bug_title__c = 'test';
        insert b1;
        // Test data creation ends
        ApexPages.StandardController controller = new ApexPages.StandardController(b);
        viewRelatedBugList viewRelatedBugListVar = new viewRelatedBugList(controller);
        viewRelatedBugListVar.getrelatedbuglist();
        viewRelatedBugListVar.Redirecttobug();

        ManageRelatedBug ManageRelatedBugVar = new ManageRelatedBug(controller);
        ManageRelatedBugVar.bugid = b.id;
        ManageRelatedBugVar.relatedbugvar.bugb__c = b1.id;

        ManageRelatedBugVar.AddRelatedBug();
        ManageRelatedBugVar.deleteRelatedBug();
        ManageRelatedBugVar.Redirecttobug();
        ManageRelatedBugVar.getRelatedbugs();
        ManageRelatedBugVar.relatedbugvar = new RelatedBugAssociation__c();

        RelatedBugAssociation__c relatedDupBug = new RelatedBugAssociation__c();
        ManageRelatedBugVar.bugid = b.id;
        ManageRelatedBugVar.relatedbugvar.bugb__c = b1.id;
        ManageRelatedBugVar.AddRelatedBug();
        Test.stopTest();
    }
}