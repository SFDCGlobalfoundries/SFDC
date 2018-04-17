/*
	@Author :- Abhita Bansal
 */
@isTest
private class WaiverCollaborator4CustomerClsTest {

    static testMethod void myUnitTest() {
       
       Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaborator0();
       
       WaiverCollaborator4CustomerCls designWaiver = new WaiverCollaborator4CustomerCls();
        
       Test.startTest();
        
       designWaiver.getWaiverList();
       boolean test1 = designWaiver.hasNext;
       boolean test2 = designWaiver.hasPrevious;
       Integer pageNo = designWaiver.pageNumber;
       designWaiver.first();
       designWaiver.last();
       designWaiver.previous();
       designWaiver.next();
       designWaiver.cancel();
       
       Test.stopTest();
        
    }
}