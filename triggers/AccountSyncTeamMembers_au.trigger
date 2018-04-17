trigger AccountSyncTeamMembers_au on Account (after update) {


    //*************
    //  This trigger operation check if the Siebel account ID has been updated
    //    If it has then we will need to update all the Account team proxy members
    //    This is needed becuase the team members must be sent to Siebel only after
    //    the account has been synchronmized with Siebel
    if (Trigger.IsUpdate && Trigger.isAfter){
    
       List<ID> lAcctIds = new List<ID> ();
       for(Account actNew: trigger.new){
           if((Trigger.oldMap.get(actNew.Id).Siebel_Account_ID__c == null)  && 
               (actNew.Siebel_Account_ID__c != null))
           {  
              lAcctIds.add(actNew.Id);
           }
      }
      
      if (lAcctIds.size() > 0) {
        List<Account_Team_Proxy__c > lAcctProxy= [select id, Account__c 
            FROM Account_Team_Proxy__c WHERE Account__c in :lAcctIds ];
    
        Database.SaveResult[] lsr = Database.update(lAcctProxy, false);
       
        // Check if DB operation failed
        for(Database.SaveResult sr:lsr){
           System.debug(sr);
           if(sr.isSuccess()){
              System.debug('Acct Team Member ' + sr.getID() + ' has been updated for sync to Siebel' );
           } else {
               //TBD: report error on user update records
           }
        } 
     }
   }
}