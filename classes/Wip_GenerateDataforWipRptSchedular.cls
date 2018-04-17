/*
This is used to schedule Wip_GenerateDataforWipRpt
batch on every Monday
Author: Ravikiran Nadella
Version 1.0
*/
global class Wip_GenerateDataforWipRptSchedular implements Schedulable {
   global void execute(SchedulableContext SC) {
      Wip_GenerateDataforWipRpt wip= new Wip_GenerateDataforWipRpt();
      database.executeBatch(wip,200);
   }
}