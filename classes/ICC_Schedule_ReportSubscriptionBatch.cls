global class ICC_Schedule_ReportSubscriptionBatch implements Schedulable
{
           global void execute(SchedulableContext sc)
            {
                   Id batchJobId = Database.executeBatch(new ICC_Process_UserReportSubscription_Batch(), 1);
            }
           
}