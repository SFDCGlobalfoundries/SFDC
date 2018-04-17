/*
Type Name: OpportunityScoreCardCalculator 
Author: Cognizant
Created Date: 30-May-2014
Reason: This is the trigger for Opportunity Weighted Score Calculation
Test Class: 
Change History:
Author: 
Modified Date: 
Reason: 
……..
……..
*/
trigger OpportunityScoreCardCalculator on Opportunity_ScoreCard__c (before insert , before update) {
if(Trigger.isBefore){
if (Trigger.isInsert || Trigger.isUpdate) {
            
            for (Opportunity_ScoreCard__c oppScore : trigger.new) {
               oppScore.Revised_Customer_Qual2__c = oppScore.Design_Win_Revenue_Weighted_Score__c
                                                    + oppScore.Margins_Weighted_Score__c
                                                    + oppScore.Funding_Resource_Weighted_Score__c
                                                    + oppScore.IP_Match_Weighted_Score__c
                                                    + oppScore.Pipeline_Cleaning_Value_Frnd_All_Score__c
                                                    + oppScore.Other_Business_Potential_Weighted_Score__c
                                                    + oppScore.Already_Engaged_with_SEC_Weighted_Score__c
                                                    + oppScore.Market_Leadership_Weighted_Score__c
                                                    + oppScore.Strategic_Existing_Cust_Weighted_Score__c
                                                    + oppScore.Decision_Timeframe_Weighted_Score__c;
              
            }
        }
    }
}