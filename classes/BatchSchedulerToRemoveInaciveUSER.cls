//Scheduler Method to schedule the class
  Global class BatchSchedulerToRemoveInaciveUSER implements Schedulable 
  {
  
      private Integer intervalMinutes;
      public String jobId;
      public DateTime now;
      public String cronString;
    public BatchSchedulerToRemoveInaciveUSER (Integer intervalMinutes) 
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
            jobId= System.schedule(BatchSchedulerToRemoveInaciveUSER.class.getName() + '-' + now.format(), cronString, new BatchSchedulerToRemoveInaciveUSER(intervalMinutes));     
            
            Database.executeBatch(new BatchToRemoveInaciveUSER(),100);
    }
}