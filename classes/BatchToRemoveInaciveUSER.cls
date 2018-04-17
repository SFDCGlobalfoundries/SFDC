/*
BatchToRemoveInaciveUSER job = new BatchToRemoveInaciveUSER();
        Database.executebatch(job,10);
*/
global class BatchToRemoveInaciveUSER implements  Database.Batchable<sObject>
{
   Map<id,Account_Team_Proxy__c> UserATPMap = new Map<id,Account_Team_Proxy__c>();
   
   static final string ACCT_TM_PRXY_TM_RL_BCSR= EnvironmentVariable.get('ACCT_TM_PRXY_TM_RL_BCSR');
   static final string ACCT_TM_PRXY_TM_RL_PCSR= EnvironmentVariable.get('ACCT_TM_PRXY_TM_RL_PCSR');
   static final string ACCT_TM_PRXY_TM_RL_PFTS= EnvironmentVariable.get('ACCT_TM_PRXY_TM_RL_PFTS');
   static final string ACCT_TM_PRXY_TM_RL_PAM = EnvironmentVariable.get('ACCT_TM_PRXY_TM_RL_PAM');
   
   global final String query = 'select id,user__r.name,Account__r.name,user__r.isactive,Flag_for_Delete__c from Account_Team_Proxy__c where user__r.isactive=false'+
                                 +' and Team_Role__c not in (\''+ BatchToRemoveInaciveUSER.ACCT_TM_PRXY_TM_RL_BCSR + '\',\''
                                        + BatchToRemoveInaciveUSER.ACCT_TM_PRXY_TM_RL_PCSR + '\',\''
                                        + BatchToRemoveInaciveUSER.ACCT_TM_PRXY_TM_RL_PFTS + '\',\''
                                        + BatchToRemoveInaciveUSER.ACCT_TM_PRXY_TM_RL_PAM +
                                        '\')' ;
   
   
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
         return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List<Account_Team_Proxy__c> scope)
    {
        try
        {
            List<Account_Team_Proxy__c> atpList =new List<Account_Team_Proxy__c>();
            
            for(Account_Team_Proxy__c AT : scope)
            {
                
                    
                    AT.Flag_for_Delete__c = true;
                    atpList.add(AT);
               
            }
            
           Database.SaveResult[] srList = Database.update(atpList, false);

            // Iterate through each returned result
            for (Database.SaveResult sr : srList) {
                if (!sr.isSuccess()) {
                    // Operation failed, so get all errors                
                    for(Database.Error err : sr.getErrors()) {
                        System.debug('The following error has occurred.');                    
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('ATP that affected this error: ' + err.getFields());
                    }
                }
            }
        }
        catch(Exception e)
        {
            System.debug('%%%%%%%%%%%%%%%%%:  '+e.getMessage());
        } 
    }
    global void finish(Database.BatchableContext BC)
    {
        
    } 
}