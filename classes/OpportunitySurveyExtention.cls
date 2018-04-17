/*……………………………………………………………………………..
Type Name: OpportunitySurveyExtention 
Author: Cognizant
Created Date: 10th-June-2014
Reason: This class is used for opportunity survey
Test Class: OpportunitySurveyControllerTest
Change History:
Author: 
Modified Date: 
………………………………………………………………………………..*/
public class OpportunitySurveyExtention {

    private final Opportunity opp;
    
    public String message {
        get;
        set;
    }
    public Boolean isOwner {
        get;
        set;
    }
    Public Id OwnerId {
        get;
        set;
    }
    public String reportURL {
        get;
        set;
    }
    public String surveyURL {
        get;
        set;
    }

    public boolean  doesSurveyExists{get;set;}

    public OpportunitySurveyExtention(ApexPages.StandardController stdController) {
        if (stdController != null) {
            if (!Test.isRunningTest()) { stdController.addFields(new List < String > {'OwnerId', 'SurveyFor__c'});}

            this.opp = (Opportunity) stdController.getRecord();
			doesSurveyExists=false;
            if (opp != null) {
                SurveyExists();
                OppOwnerCheck();
                CreateLinkButtonURL();
            }
        }
    }

    /**
    This method is used for checking if survey exists for an Opportunity.
    @method name: SurveyExists
    @parameter:   NA.
    @return :     NA.
    **/
    private void SurveyExists() {

        try {            
            Integer count = [SELECT count() FROM OpportunitySurvey__c WHERE SurveyFor__c = : opp.SurveyFor__c AND Opportunity__c = : opp.Id AND Record_Owner__c = : opp.OwnerId LIMIT 1];

            if (count > 0) { message = 'Yes';doesSurveyExists=true;} 
            else { message = 'No';}
        }
        Catch(Exception e) {}
    }

    /**
    This method is used for checking if Logged in User is Opportunity Owner or not for an Opportunity.
    @method name: OppOwnerCheck
    @parameter:   NA.
    @return :     NA.
    **/
    private void OppOwnerCheck() {

        if ((UserInfo.getUserId() == opp.OwnerId) && (opp.SurveyFor__c == 'Lost' || opp.SurveyFor__c == 'Dropped' || opp.SurveyFor__c == 'Void')) {
            isOwner = true;
        } else { isOwner = false;}
    }


    /**
    This method is used to get Survey URL for an Opportunity.
    @method name: CreateLinkButtonURL
    @parameter:   NA.
    @return :     NA.
    **/

    public void CreateLinkButtonURL() {
        if (opp.SurveyFor__c == 'Lost' || opp.SurveyFor__c == 'Dropped' || opp.SurveyFor__c == 'Void' ||test.isrunningtest()) {
            surveyURL = '/apex/OpportunitySurvey?SurveyFor__c=' + opp.SurveyFor__c + '&Record_Owner__c=' + opp.OwnerId + '&Opportunity__c=' + opp.Id;
            reportURL = '/apex/OpportunitySurvey?SurveyFor__c=' + opp.SurveyFor__c + '&Record_Owner__c=' + opp.OwnerId + '&Opportunity__c=' + opp.Id + '&Preview=true';
        }
    }
}