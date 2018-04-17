/*
    Author: Nino Bustillos
    Description: Associate Active_Users_for_Analytics__c record to 
                 Login_count_last_7_days_for_analytics__c based on weekending.
    History:
        Nbustillos    01212013    - code creation.
*/
global class ActiveUserAssociationToLoginCount implements Schedulable{
    
    global void execute(SchedulableContext ctx){
        List<Active_Users_for_Analytics__c> ActiveUserRecord = [select Id, Week_Ending__c from Active_Users_for_Analytics__c order by createddate desc limit 1];
        
         
        if(ActiveUserRecord.size()>0){
            // retrieve login count records based on week ending. 
            // we are expecting only 1 record created every week from analytic snapshot.
            List<Login_count_last_7_days_for_analytics__c> LoginCountRec = [select id, week_ending__c, Active_User_Records__c
                                                                      from Login_count_last_7_days_for_analytics__c 
                                                                      where week_ending__c = :ActiveUserRecord.get(0).Week_Ending__c 
                                                                      order by createddate desc limit 1];
            if(LoginCountRec.size()>0){
                if(LoginCountRec.get(0).Active_User_Records__c==null){
                    LoginCountRec.get(0).Active_User_Records__c = ActiveUserRecord.get(0).Id;
                    update LoginCountRec;
                }
            }
        }
        
    }  
}