/*
Scheduler class to refresh SOQLs of all subscriptions subscribed to standard reports.
Author: Rahul Majumder
Version 1.0
*/
global class ICC_Scheduler_RefreshSOQL_Standard implements schedulable
{
    global void execute(SchedulableContext sc)
    {
        ICC_Batch_RefreshSubscrptnSOQL_Standard b = new ICC_Batch_RefreshSubscrptnSOQL_Standard(); 
        database.executebatch(b, 25);
    }
}