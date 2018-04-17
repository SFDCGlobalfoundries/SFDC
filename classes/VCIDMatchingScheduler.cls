/*
    Author: Ariz Solito
 	Description: Apex scheduler class for VCIDMatchingBatch 
    History: 
    Asolito      07/04/2013    - Apex coded created
 
To Run:    System.schedule('VCIDMatchingBatch', '0 0 2 * * ?', new  VCIDMatchingScheduler());
To Check Status: CronTrigger ct = [SELECT id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];           
*/
global class VCIDMatchingScheduler implements Schedulable {
    global void execute(SchedulableContext  sc) {
        VCIDMatchingBatch job = new VCIDMatchingBatch();
        Database.executebatch(job,10);
    }    
}