/*
SWGP-998
This class is used to trigger MRSBatchRetryMSIH batch job to run.
This class will be scheduled via apex scheduler (UI). 

Test class: MRSBatchRetryMSIHTest
*/
global class MRSBatchRetryMSIHSchedulable implements MRSMSIHScheduleDispatcher.IMRSMSIHScheduleDispatcher {
    
    global void execute(SchedulableContext ctx) {
        Integer jobs = [select count() from AsyncApexJob where jobType = 'BatchApex' and status in ('Queued','Processing','Preparing')];
        if(jobs > 4) {
            Datetime sysTime = System.now().addMinutes(10); // try again in 10 minutes
            String cronExpression = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
            MRSMSIHScheduleDispatcher scheduledBatch = new MRSMSIHScheduleDispatcher();
            System.schedule( 'MRSBatchRetryMSIHS-' + sysTime, cronExpression, scheduledBatch );      
        } else {
            Integer sizeIsMatter = Integer.valueOf(Environment_Variable__c.getInstance('SWIFT_MRS_ROLLUP_RETRIGGER_BATCH_SIZE').Value__c);
            MRSBatchRetryMSIH m = new MRSBatchRetryMSIH(); 
            Database.executeBatch(m, sizeIsMatter);
        }
    }
}