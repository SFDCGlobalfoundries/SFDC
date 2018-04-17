@isTest
global class BatchSchedulerToRemoveInaciveUSERTest
{
    public static testmethod void testingmethod()
    {
    
       
        for(CronTrigger Ct: [SELECT Id, CronJobDetail.Id, CronJobDetail.Name, CronJobDetail.JobType
FROM CronTrigger where CronJobDetail.Name like '%BatchSchedulerToRemoveInaciveUSER%' and State<>'COMPLETE' and NextFireTime<>NULL]) 
try{
System.AbortJob(ct.Id);    
}catch(Exception e){} 
        
        test.StartTest();
        BatchSchedulerToRemoveInaciveUSER obj=new BatchSchedulerToRemoveInaciveUSER(24*60);// after 24 hours
        obj.execute(NULL);
        
        
         // Get the information from the CronTrigger API object
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered,NextFireTime FROM CronTrigger WHERE id = :obj.jobId];
        DateTime nextRunTime = obj.now.addMinutes(24*60);
        String cronString = '' + nextRunTime.second() + ' ' + nextRunTime.minute() + ' ' +nextRunTime.hour() + ' ' + nextRunTime.day() + ' ' + 
            nextRunTime.month() + ' ? ' + nextRunTime.year(); 
            
        // Verify the cron expressions are the same  
        System.assertEquals(obj.cronString ,cronString);
         
        // Verify the job has not run
        System.assertEquals(0, ct.TimesTriggered);
        
       // Verify the next time the job will run
       
        
       System.assertEquals(nextRunTime.second(),ct.NextFireTime.second());
       System.assertEquals(nextRunTime.minute(),ct.NextFireTime.minute());
       System.assertEquals(nextRunTime.hour(),ct.NextFireTime.hour());
       System.assertEquals(nextRunTime.day(),ct.NextFireTime.day());
       System.assertEquals(nextRunTime.month(),ct.NextFireTime.month());
       System.assertEquals(nextRunTime.year(),ct.NextFireTime.year());
        
        
        
        //Abort the job so that after test stops the system does not encounter AsyncException
        System.abortJob(obj.JobId);
        
       
        
        test.StopTest();
        
        
        
        
    }
}