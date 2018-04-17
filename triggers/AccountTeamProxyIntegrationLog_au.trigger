trigger AccountTeamProxyIntegrationLog_au  on Account_Team_Proxy__c (after update) {

    //*************
    //  This trigger operation will insert an Intgration log entry
    //   when the Opportunity is updated with a Siebel response status of "ERROR" or "SUCCESS"
    //   The integration log will track the integration updates from Siebel
    if (Trigger.IsUpdate && Trigger.isAfter && trigger.oldMap.size() == 1){
        for(Account_Team_Proxy__c actNew: trigger.new){
           if((Trigger.oldMap.get(actNew.Id).Siebel_Status__c !=  actNew.Siebel_Status__c)  && 
               (actNew.Siebel_Status__c == 'ERROR' || actNew.Siebel_Status__c == 'SUCCESS' ))
           {  
              IntegrationLog.addIntegrationLog('Account Team',
                  actNew.ID, 
                  actNew.Siebel_Sync_ID__c,
                  actNew.Siebel_Error_Message__c,
                  actNew.Siebel_Operation__c,
                  actNew.Siebel_Status__c,
                  actNew.Siebel_Sent_DateTime__c );   
           }
        }
    }
 }