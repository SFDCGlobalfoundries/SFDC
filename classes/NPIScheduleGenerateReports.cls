/**
* Author: Yathish NS 
* Project: NPI Report  
* Description: Scheduler class for NPIGenerateReports class
**/
global class NPIScheduleGenerateReports implements schedulable
{
    global void execute(SchedulableContext sc)
    {
        NPIGenerateReports adq = new NPIGenerateReports(); 
        database.executebatch(adq);
    }
}