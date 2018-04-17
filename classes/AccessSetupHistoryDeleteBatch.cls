global class AccessSetupHistoryDeleteBatch implements Database.Batchable<SObject>, Schedulable{
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        Integer months = Integer.valueOf(Access_Setup_History_InMonths__c.getInstance('MonthsLimit').Months__c) * -1;
        Datetime d = datetime.now().addMonths(months);    
        return database.getQueryLocator([Select Id,CreatedDate from AccessSetupHistoryTracking__c where CreatedDate >:d]);
    }
    
    global void execute(Database.BatchableContext info, List<SObject> scope){
        delete scope;
    } 
        
    global void finish(Database.BatchableContext BC){        
          
    }
    
    global void execute(SchedulableContext sc){
        
        AccessSetupHistoryDeleteBatch deleteBatch = new AccessSetupHistoryDeleteBatch();
        Database.executeBatch(deleteBatch,2000);
    } 
}