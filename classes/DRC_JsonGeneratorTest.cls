/*
    @Author :- SUHAS BARGI
*/
@isTest(SeeAllData=false)
private class DRC_JsonGeneratorTest {  
	
	/*@testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables(); 
    }*/

static testMethod void myJsonGeneratorTestMethod() { 
    
     Test.startTest(); 
    Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaborator0();
    waiverColl.MantisId__c=545454;
    waiverColl.PTSR_Service_Type__c='DRC Request Type';
    waiverColl.PTSR_Number__c='PTSR1234';
    waiverColl.Waiver_Status__c='Pending';
    waiverColl.PTSR_Status__c='WCR';
    
    DRC_JsonGenerator jsonGen = new DRC_JsonGenerator();
    //jsonGen.objType='Wavier_Collaborator__c';
   
    DesignCollaboratorTestData.getWaiverRuleListForFDCCWCR(waiverColl.Id);
    List<Waiver_Rule_List__c> waiverRuleListForTest = new List<Waiver_Rule_List__c>();
    waiverRuleListForTest=DesignCollaboratorTestData.getWaiverRuleList(waiverColl.Id);
   
    DRC_JsonGenerator.getJsonRequest(waiverRuleListForTest, waiverColl);
    DRC_JsonGenerator.getJsonRequestForRevert(waiverRuleListForTest, waiverColl);
    Test.stopTest();
    

}
    
    
    
}