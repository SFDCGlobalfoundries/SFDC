/*
  Author: Ariz Solito
  Description: Test class for controller class TrainingCommunityLandingCntrlr
  History:
    ASolito         03032015    - code creation.
*/
@isTest(SeeAllData=true)
public class TrainingCommunityLandingCntrlrTest  {

    static testMethod void testClass(){
        PageReference pageRef = Page.TrainingCommunityLanding;
        Test.setCurrentPageReference(pageRef);
        
        TrainingCommunityLandingCntrlr ctrl = new TrainingCommunityLandingCntrlr();
        
        //call the instance methods        
        ctrl.redirectToInternalView();                                        
    }    
}