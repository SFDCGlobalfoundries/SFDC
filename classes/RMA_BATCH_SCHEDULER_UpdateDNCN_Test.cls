@isTest
global class RMA_BATCH_SCHEDULER_UpdateDNCN_Test
{
    public static testmethod void ScheduleTest()
    {
      for(CronTrigger Ct: [SELECT Id, CronJobDetail.Id, CronJobDetail.Name, CronJobDetail.JobType
							FROM CronTrigger where CronJobDetail.Name like '%RMA_BATCH_SCHEDULER_UpdateDNCN%' and State<>'COMPLETE' and NextFireTime<>NULL]) 
    try{
        System.AbortJob(ct.Id);    
       }catch(Exception e){} 
        
        test.StartTest();
        RMA_BATCH_SCHEDULER_UpdateDNCN obj=new RMA_BATCH_SCHEDULER_UpdateDNCN();
        obj.execute(NULL);
        test.StopTest();
        Integer n=[SELECT count()FROM AsyncApexJob where ApexClassID in (select id from ApexClass where Name='RMA_BATCH_UpdateDNCN') and Status='Completed'];
        System.assertEquals(1,n);
      }  
      
  }