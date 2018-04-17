global class scheduleFeedItemAuditclass implements schedulable{
    global void execute(SchedulableContext sc){
        FeedItemAuditClass abc = new FeedItemAuditClass();
        database.executebatch(abc,150);
        
    }
}