/*
Type Name: SurveyStarController
Author: Cognizant
Created Date: 24th-Apr-2014
Reason: 
Test Class: 
Change History:
Author: 
Modified Date: 
……..
……..
--
*/

public class SurveyStarController{
Public CustomerSurveySetting__c setting { get; set;} 
public String rate { get; set;}

public SurveyStarController() {            
        setting = CustomerSurveySetting__c.getInstance();  
    }
}