/*
    Author: Zymark Ambat
    Description: This serves as the test class for MESService class.
    History: 
        ZAmbat      10172013    - Code creation.
        ARoy        03012014    - Code modified to call process() method.
        Ashwini     05182015    - Updated code for refactoring of test class.
*/
@isTest(SeeAllData=false)
public class MESServiceTest {
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
    }
    static testMethod void runTest() {
        //DataUtilTest.loadEnvironmentVariables();
        MESService mes = new MESService();
        MESService.NPC_PART_MAST_TYPE_TOUT_element a = new MESService.NPC_PART_MAST_TYPE_TOUT_element();
        MESService.WEB_PART_PHOTO_STAGE_TYPE_TOUT_element b = new MESService.WEB_PART_PHOTO_STAGE_TYPE_TOUT_element();
        MESService.SFMESSyncService_pt c = new MESService.SFMESSyncService_pt();
        MESService.processResponse_element d = new MESService.processResponse_element();
        d = c.process(null,null,null,null,null);
        MESService.process_element e = new MESService.process_element(); 
    }
}