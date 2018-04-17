/*
Scheduler class for batch to send emails for Expiry of ITAR Certifications.
Author: Amit Kumar Ojha
Version: 1
*/
public class ITAR_Sch_Certified_Exp_PortalUsers_Batch implements Schedulable
{
           public void execute(SchedulableContext sc)
            {
                   Id batchJobId = Database.executeBatch(new ITAR_Certified_Expiry_PortalUsers_Batch(), 50);
            }
           
}