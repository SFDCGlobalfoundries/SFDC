/*
Author: Cognizant
Company: Cognizant
Description: Custom Log Purging Schedulable Class
History:
created     06/10/2014     
*/
global class SWIFTPurgeCustomLogScheduler implements Schedulable {

 global void execute(SchedulableContext ctx) {
 SWIFTPurgeCustomLogBatch batch = new SWIFTPurgeCustomLogBatch();
 Database.executeBatch( batch, 200 );
 }
}