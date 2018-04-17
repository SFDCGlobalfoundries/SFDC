/*------------------------------------------------------------  
Author:        Sameera
Company:       CTS
Description:   A Schedule class to execute a batch to send emails
------------------------------------------------------------*/
global class FV_ScheduleASICNewsAlert implements Schedulable {
     global void execute(SchedulableContext sc) {
      FV_BatchASICNewsAlert batchable  = new FV_BatchASICNewsAlert ();
      database.executebatch(batchable,1);
    }
}

//For scheduling this class from 'Developer console - run the following code'
/* Id batchJobId1 = Database.executeBatch(new FV_BatchASICNewsAlert(), 1);
        FV_ScheduleASICNewsAlert sch = new  FV_ScheduleASICNewsAlert ();
    System.schedule('ASICNewsAlert Batch Schedule job hourly', '0 0 * * * ?', sch); */