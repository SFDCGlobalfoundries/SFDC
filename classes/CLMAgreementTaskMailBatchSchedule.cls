//Scheduler Method to schedule the class
  Global class CLMAgreementTaskMailBatchSchedule implements Schedulable 
  {
  
      private Integer intervalMinutes;
      public String jobId;
      public DateTime now;
      public String cronString;
    public CLMAgreementTaskMailBatchSchedule (Integer intervalMinutes) 
    {
        this.intervalMinutes = intervalMinutes;
    }
    
  global void execute(SchedulableContext sc)
    {
    
            now  = DateTime.now();
            DateTime nextRunTime = now.addMinutes(intervalMinutes);
            cronString = '' + nextRunTime.second() + ' ' + nextRunTime.minute() + ' ' + 
            nextRunTime.hour() + ' ' + nextRunTime.day() + ' ' + 
            nextRunTime.month() + ' ? ' + nextRunTime.year(); 
            jobId= System.schedule(CLMAgreementTaskMailBatchSchedule.class.getName() + '-' + now.format(), cronString, new CLMAgreementTaskMailBatchSchedule (intervalMinutes));     
            
            Database.executeBatch(new CLMAgreementTaskNotificationBatch(),1);  //batch size is 1 for task trigger to handle batch operations on recurring tasks
    }
}