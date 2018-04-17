/*
Scheduler to run everyday and check if any report is deleted. It will then delete the corresponding report subscriptions
AUTHOR: Rahul Majumder
Version 1.0
*/

global class ICC_Scheduler_CleanseReportSubscriptions implements Schedulable 
{
   global void execute(SchedulableContext sc) 
   {
      ICC_CleanUp_ReportSubscriptions.cleanseData();
   }
}