/*
Type Name: CVASurveyStarController
Author: Vijay Vemuru
Created Date: 14th-Mar-2016
Reason: 
Test Class: 
Change History:
Author: 
Modified Date: 
*/
public class CVASurveyStarController{
Public CustomerSurveySetting__c setting { get; set;} 
public String rate { get; set;}

public CVASurveyStarController() {            
        setting = CustomerSurveySetting__c.getInstance();  
    }
}