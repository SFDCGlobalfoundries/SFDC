/*
Batch Class to clean all existing AccountShare, OpportunityShare and CaseShare records of Cutomer Portal users
Author: Rahul Majumder
Version: 1
*/
global class ICC_Batch_CleanUpAccountShare implements database.batchable<Sobject> 
{
    // Start method: Fetch the AccountShare records
    global database.QueryLocator start(Database.batchableContext BC)
    {
        if(!Test.isRunningTest())
        {
            return database.getQueryLocator([Select id, UserOrGroupId, AccountId
                                         FROM AccountShare 
                                         WHERE RowCause = 'Manual' AND 
                                         UserOrGroup.Profile.Name LIKE '%Customer Portal%']); 
        }
        else
        {
            return database.getQueryLocator([Select id, UserOrGroupId, AccountId
                                         FROM AccountShare ]); 
        }
        
    }
    
    // Execute method: 
    global void execute (Database.BatchableContext BC, List<AccountShare> scope)
    {
        ICC_CleanUpAccountShare.cleanData(scope);
    }
    
    global void finish(Database.batchableContext BC)
    {
        // Do nothing
    }

}