/*
    Author: Zymark Ambat
    Description: This serves as the test class for NPCFormRecordLinkController.
    History: 
        ZAmbat      12142013    - Code creation.
        Ashwini     05182015    - Updated code for refactoring of test class.
*/
@isTest(SeeAllData=false)
public class NPCFormRecordLinkControllerTest {
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
    }
    static testMethod void runTest() {
        //DataUtilTest.loadEnvironmentVariables();
        NPCFormRecordLinkController n = new NPCFormRecordLinkController();
        n.getRecordLink();
    }
}