/*********************************************************************************/
  // Purpose      : CaseAvailableRelatedBugsTest class is responsible for major responsibilities / business logic required in UCM Project
  // Date created : 17 March, 2017
  // Created by   : GlobalFoundries
  // Author       : Manikumar M 
  // Description  : This is the test class for CaseAvailableRelatedBugs class.  
  // Change History 
  //    1. [Modify By] [Modify Date] 
  //        [Reason] :
/*********************************************************************************/
@isTest(SeeAllData=false)
private class CaseAvailableRelatedBugsTest{
    private static testmethod void testCaseBugAssociations(){
        RecordType RecType1 = [Select Id From RecordType  Where SobjectType = 'Case' and RecordType.DeveloperName = 'External_System'];
        RecordType RecType2 = [Select Id From RecordType  Where SobjectType = 'Bug__c' and RecordType.DeveloperName = 'CAD_Bug'];
        
        Case objCase = new Case(RecordTypeId = RecType1.Id ,
                                Subject='Case - Something');        
        insert objCase;
     
        Bug__c objBug = new Bug__c (RecordTypeId = RecType2.Id,
                                Bug_Title__c='Bug - Something');
              
        insert objBug;
        
        Test.startTest();
        
        CaseBugAssociation__c objCaseBug1=new CaseBugAssociation__c(Case__c=objCase.Id,Bug__c=objBug.Id);
        PageReference pageRef = Page.CaseAvailableRelatedBugsVFP;
        Test.setCurrentPage(pageRef);
        CaseAvailableRelatedBugs controller = new CaseAvailableRelatedBugs ();
        CaseAvailableRelatedBugs.caseBugSubClass caseBugWrap = new CaseAvailableRelatedBugs.caseBugSubClass(objCaseBug1);
        controller.getCaseBugAss();
        controller.Isportal = false;
        controller.queryLimit = 10;
        pageRef = controller.next();
        system.assert(pageRef==null);
        pageRef = controller.previous();
        system.assert(pageRef==null);
        pageRef = controller.first();
        system.assert(pageRef==null);
        pageRef = controller.last();
        system.assert(pageRef==null);
        boolean prevChk = controller.getprev();
        boolean nextChk = controller.getnxt();
        controller.pageNavigation();
        controller.getRecordInfo();
        controller.changeLimit();
        controller.getItems();
        
        Test.stopTest();        
    }
}