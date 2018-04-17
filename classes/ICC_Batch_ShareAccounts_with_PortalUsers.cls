global class ICC_Batch_ShareAccounts_with_PortalUsers implements database.batchable<Sobject> 
{
    // Start method: Fetch the Customer Portal user records
    global database.QueryLocator start(Database.batchableContext BC)
    {
        string QueryQ='Select Id, Contact.AccountId FROM User WHERE Profile.Name LIKE  \'%Customer Portal%\'';
        if(Test.isRunningTest()){
            QueryQ+='Limit 1';
        }
        return database.getQueryLocator(QueryQ); 
    }
    
    // Execute method: 
    global void execute (Database.BatchableContext BC, List<User> scope)
    {
        ICC_CleanUpAccountShare.ShareAccounts(scope);
    }
    
    global void finish(Database.batchableContext BC)
    {
        // Do nothing
    }

}