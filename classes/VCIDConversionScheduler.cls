/*
    Author: Ariz Solito
    Description: Apex scheduler class for VCIDConversionBatch 
     History: 
    Asolito      07/04/2013    - Apex coded created
 
To Run:    System.schedule('VCIDConversionBatch', '0 0 0 * * ?', new  VCIDConversionScheduler());
To Check Status: CronTrigger ct = [SELECT id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];           
*/
global class VCIDConversionScheduler implements Schedulable {
    global void execute(SchedulableContext  sc) {
        VCIDConversionBatch job = new VCIDConversionBatch();
        Database.executebatch(job);
    }    
}