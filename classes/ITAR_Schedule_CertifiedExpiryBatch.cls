/*
Scheduler class for batch to send emails for Expiry of ITAR Certifications.
Author: Amit Kumar Ojha
Version: 1
*/
public class ITAR_Schedule_CertifiedExpiryBatch implements Schedulable
{
           public void execute(SchedulableContext sc)
            {
                   Id batchJobId = Database.executeBatch(new ITAR_Certified_Expiry_Batch(), 50);
            }
           
}