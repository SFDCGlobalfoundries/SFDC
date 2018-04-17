/*
    Author: Nino Bustillos
    Description: This webservice resets the quarterly ASP/Volume. 
                 Called from 'Reset Forecast' button.
    History: 
        Nbustillos  02142013    - Code creation.
        ARoy        03042013    - Code modification to incorporate the logic to reset all ASP/Volume values 
                                  to zero of Quarterly Revenue Object.
*/
global class QuarterlyRevenueService {
    webservice static String resetForecast(string opptyID) {
        try{
            String resetStatus = 'OK';
            List<Quarterly_Revenue_Object__c> qtrObjList = [select Id,ASP__c,Volume__c 
                                           from Quarterly_Revenue_Object__c where
                                               Opportunity__c = :opptyID];
                                
            List<Quarterly_Revenue_Object__c> qtrObjChgdList = new List<Quarterly_Revenue_Object__c>();
            for(Quarterly_Revenue_Object__c qtrRevObj : qtrObjList ){
                if(qtrRevObj.ASP__c!=0){
                    qtrRevObj.ASP__c = 0;
                }
                if(qtrRevObj.Volume__c!=0){
                    qtrRevObj.Volume__c = 0;
                }
                qtrObjChgdList.add(qtrRevObj);
            }           
            if(qtrObjChgdList.size()>0){
                update qtrObjChgdList;
            }
            return resetStatus;
        }catch(Exception ex){
            return ex.getMessage();
        }
    }
}