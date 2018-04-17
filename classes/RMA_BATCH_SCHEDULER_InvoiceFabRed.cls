/*
    Company:        Cognizant Technology Solution
    Description:    Scheduler class for RMA_BATCH_InvoiceFabRed to insert/update the Invoice records for Fab 9/10.
    History:        21-Sep-16    Created the class    
*/

global class RMA_BATCH_SCHEDULER_InvoiceFabRed implements Schedulable{
    global void execute(SchedulableContext sc) {
        RMA_BATCH_InvoiceFabRed batchJob= new RMA_BATCH_InvoiceFabRed();
        Database.executebatch(batchJob, 100);
    }
}