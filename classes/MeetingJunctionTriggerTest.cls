/*
    Author: Anirban Roy
    Description: This is the test class for the MeetingJunctionTrigger class.  
    History:
        ARoy        04092014    - code creation.
        Ashwini     05182015    - Updated code for making SeeAllData=false and refactoring of test class.
*/


@isTest(SeeAllData=false)
public class MeetingJunctionTriggerTest {   
     @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
    }
    // Creation of Meeting
    static Id createMeeting(){
        Meeting_ID__c mtg = new Meeting_ID__c();        
        insert mtg;
        return mtg.Id;
    }
    
    // Creation of Meeting Junction
    static Meeting_Junction__c createMeetingJunction(Id gmplId, Id mtgId){
        Meeting_Junction__c mtgJunc = new Meeting_Junction__c();
        mtgJunc.GMPL_BX009__c = gmplId;
        mtgJunc.Meeting_ID__c = mtgId;        
        insert mtgJunc;
        return mtgJunc;
    }
    
    
    // Creation of GMPL/BX009
    static GMPL_BX009__c createGMPL(){
        GMPL_BX009__c gmplBX009 = new GMPL_BX009__c();      
        gmplBX009.G0_Target_Date__c = System.today();
        gmplBX009.G1_Target_Date__c = System.today();
        gmplBX009.G3_Target_Date__c = System.today();
        gmplBX009.G6_Target_Date__c = System.today();
        //gmplBX009.PCR_Target_Date__c = System.today();
        gmplBX009.G0_Commit_Date__c = System.today();
        gmplBX009.G1_Commit_Date__c = System.today();
        gmplBX009.G3_Commit_Date__c = System.today();
        gmplBX009.G6_Commit_Date__c = System.today();
        //gmplBX009.PCR_Commit_Date__c = System.today();
        gmplBX009.G0_Actual_Date__c = System.today();
        gmplBX009.G1_Actual_Date__c = System.today();
        gmplBX009.G3_Actual_Date__c = System.today();
        gmplBX009.G6_Actual_Date__c = System.today();
        //gmplBX009.PCR_Actual_Date__c = System.today();
        gmplBX009.G0_Plan_Date__c = System.today();
        gmplBX009.G1_Plan_Date__c = System.today();
        gmplBX009.G3_Plan_Date__c = System.today();
        gmplBX009.G6_Plan_Date__c = System.today();
        //gmplBX009.PCR_Plan_Date__c = System.today();
        gmplBX009.G0_Trend_Date__c = System.today();
        gmplBX009.G1_Trend_Date__c = System.today();
        gmplBX009.G3_Trend_Date__c = System.today();
        gmplBX009.G6_Trend_Date__c = System.today();
        //gmplBX009.PCR_Trend_Date__c = System.today();
        insert gmplBX009;
        return gmplBX009;
    }
    
    static testMethod void meetingJunctionTest(){
        
        // Load Environment Variables   
        //DataUtilTest.loadEnvironmentVariables();
        
        GMPL_BX009__c gmplObj = MeetingJunctionTriggerTest.createGMPL();
        Id mtgId = MeetingJunctionTriggerTest.createMeeting();
        
        Test.startTest();
        
        Meeting_Junction__c mtgJunc = MeetingJunctionTriggerTest.createMeetingJunction(gmplObj.Id,mtgId);
        
        mtgJunc = [select   Id
                            , G0_Target_Date__c
                            , G1_Target_Date__c
                            , G3_Target_Date__c
                            , G6_Target_Date__c
                            //, PCR_Target_Date__c
                            , G0_Commit_Date__c
                            , G1_Commit_Date__c
                            , G3_Commit_Date__c
                            , G6_Commit_Date__c
                            //, PCR_Commit_Date__c
                            , G0_Actual_Date__c
                            , G1_Actual_Date__c
                            , G3_Actual_Date__c
                            , G6_Actual_Date__c
                            //, PCR_Actual_Date__c
                            , G0_Plan_Date__c
                            , G1_Plan_Date__c
                            , G3_Plan_Date__c
                            , G6_Plan_Date__c
                            //, PCR_Plan_Date__c
                            , G0_Trend_Date__c
                            , G1_Trend_Date__c
                            , G3_Trend_Date__c
                            , G6_Trend_Date__c
                            //, PCR_Trend_Date__c 
                   from     Meeting_Junction__c
                   where    Id = :mtgJunc.Id];
        
        system.assertEquals(gmplObj.G0_Target_Date__c,mtgJunc.G0_Target_Date__c);
        system.assertEquals(gmplObj.G1_Target_Date__c,mtgJunc.G1_Target_Date__c);
        system.assertEquals(gmplObj.G3_Target_Date__c,mtgJunc.G3_Target_Date__c);
        system.assertEquals(gmplObj.G6_Target_Date__c,mtgJunc.G6_Target_Date__c);
        //system.assertEquals(gmplObj.PCR_Target_Date__c,mtgJunc.PCR_Target_Date__c);
        system.assertEquals(gmplObj.G0_Commit_Date__c,mtgJunc.G0_Commit_Date__c);
        system.assertEquals(gmplObj.G1_Commit_Date__c,mtgJunc.G1_Commit_Date__c);
        system.assertEquals(gmplObj.G3_Commit_Date__c,mtgJunc.G3_Commit_Date__c);
        system.assertEquals(gmplObj.G6_Commit_Date__c,mtgJunc.G6_Commit_Date__c);
        //system.assertEquals(gmplObj.PCR_Commit_Date__c,mtgJunc.PCR_Commit_Date__c);
        system.assertEquals(gmplObj.G0_Actual_Date__c,mtgJunc.G0_Actual_Date__c);
        system.assertEquals(gmplObj.G1_Actual_Date__c,mtgJunc.G1_Actual_Date__c);
        system.assertEquals(gmplObj.G3_Actual_Date__c,mtgJunc.G3_Actual_Date__c);
        system.assertEquals(gmplObj.G6_Actual_Date__c,mtgJunc.G6_Actual_Date__c);
        //system.assertEquals(gmplObj.PCR_Actual_Date__c,mtgJunc.PCR_Actual_Date__c);
        system.assertEquals(gmplObj.G0_Plan_Date__c,mtgJunc.G0_Plan_Date__c);
        system.assertEquals(gmplObj.G1_Plan_Date__c,mtgJunc.G1_Plan_Date__c);
        system.assertEquals(gmplObj.G3_Plan_Date__c,mtgJunc.G3_Plan_Date__c);
        system.assertEquals(gmplObj.G6_Plan_Date__c,mtgJunc.G6_Plan_Date__c);
        //system.assertEquals(gmplObj.PCR_Plan_Date__c,mtgJunc.PCR_Plan_Date__c);
        system.assertEquals(gmplObj.G0_Trend_Date__c,mtgJunc.G0_Trend_Date__c);
        system.assertEquals(gmplObj.G1_Trend_Date__c,mtgJunc.G1_Trend_Date__c);
        system.assertEquals(gmplObj.G3_Trend_Date__c,mtgJunc.G3_Trend_Date__c);
        system.assertEquals(gmplObj.G6_Trend_Date__c,mtgJunc.G6_Trend_Date__c);
        //system.assertEquals(gmplObj.PCR_Trend_Date__c,mtgJunc.PCR_Trend_Date__c);
        
        Test.stopTest();
    }
}