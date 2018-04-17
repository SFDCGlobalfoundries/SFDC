/*
    Author: Anirban Roy
    Description: This is the test class for the PPETeamTrigger class.  
    History:
        ARoy        04092014    - code creation.
        DBiswal     04152015    - Updated code for making SeeAllData=false and refactoring of test class.
*/

@isTest(SeeAllData=false)
public class PPETeamTriggerTest {
    
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
    }
    
    // Creation of GMPL/BX009
    static GMPL_BX009__c createGMPL(){
        GMPL_BX009__c gmplBX009 = new GMPL_BX009__c();               
        insert gmplBX009;
        return gmplBX009;
    }
    
    
    // Creation of PPE Team
    static PPE_Team__c createPPETeam(Id gmplId){
        PPE_Team__c pT = new PPE_Team__c(GMPL_BX009__c = gmplId, 
                                    PPE_Role__c = 'Team Member', User__c = UserInfo.getUserId(), Access_Level__c = 'Read/Write');       
        
        insert pT;
        return pT;
    }
    
    
    // Addition of PPE Team Member test
    static testMethod void ppETeamAddMemberTest(){
        
        // Load Environment Variables   
        //DataUtilTest.loadEnvironmentVariables();
        
        GMPL_BX009__c gmplObj = PPETeamTriggerTest.createGMPL();
        
        Test.startTest();
        
        PPE_Team__c pT1 = PPETeamTriggerTest.createPPETeam(gmplObj.Id);        
        
        try{
            PPE_Team__c pT2 = PPETeamTriggerTest.createPPETeam(gmplObj.Id);
        }catch(DMLException e){
            for(Integer i = 0; i < e.getNumDml(); i++){
                system.assert(e.getDmlMessage(i).contains('Duplicate Users cannot be inserted into PPE Team.'));
            }
        }
        
        Test.stopTest();               
        
    }
    
    // Removal of PPE Team Member test
    static testMethod void ppETeamRemoveMemberTest(){
        
        // Load Environment Variables   
        //DataUtilTest.loadEnvironmentVariables();
        
        GMPL_BX009__c gmplObj = PPETeamTriggerTest.createGMPL();
        PPE_Team__c pT1 = PPETeamTriggerTest.createPPETeam(gmplObj.Id);
        
        Test.startTest();
        
        delete pT1;               
        
        Test.stopTest();               
        
    }
    
}