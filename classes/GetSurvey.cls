global class GetSurvey {

@InvocableMethod

    public static List<Boolean> getSurveyRequired() {
    
        Set<String> validProfileNamesList = new Set<String>{'System Administrator', 'GF Integration', 'GF System Admin', 'GF Biz Ops Alliances',
        'GF Biz Ops Pricing','GF CSR Lite','GF CSR','GF FAE/FTS Lite','GF FAE/FTS','GF Global Admin','GF Planning (Standard)','GF Planning Lite',
        'GF Planning', 'GF Sales User Lite', 'GF Sales User', 'GF WWMS Executive'};
        
        List<Boolean> surveyResponse = new List<Boolean>();
        
        Profile ProfileName = [select Name from profile where id = :userinfo.getProfileId()];
        
        // Validate whether user has already done the survey
        List<Salesforce_Survey__c> surveyDoneList = [SELECT ID FROM Salesforce_Survey__c WHERE ownerID = :userinfo.getUserId()];
        
        if(validProfileNamesList.contains(ProfileName.Name) && (surveyDoneList.size() == 0)){
            surveyResponse.add(true);
        }
        else
        {
            surveyResponse.add(false);
        }
        
        return surveyResponse;
    }
}