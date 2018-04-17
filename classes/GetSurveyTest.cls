@isTest(SeeAllData=false)

private class GetSurveyTest
{
    // Survey is Required
    @isTest static void surveyRequired() {
        System.assertEquals(true,GetSurvey.getSurveyRequired()[0]);
    }
    
    // Survey is Not Required
    @isTest static void surveyNotRequired() {
        Salesforce_Survey__c survey = new Salesforce_Survey__c(Using_Risk_Start_System__c=true,Using_Wafer_Write_Off_System__c=true,Comments__c='Sample Feedback');
        insert survey;
        Test.startTest();
        System.assertEquals(false,GetSurvey.getSurveyRequired()[0]);
        Test.stopTest();
    }

}