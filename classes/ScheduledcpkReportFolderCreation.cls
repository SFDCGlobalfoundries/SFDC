/*
    Author:      Deepti Narayan Biswal
    Description: This class serves as a scheduler class for creation of CPK Reports Folder by scheduling batchMonthlycpkReportCreation Class.

    History:
    DBiswal    02092015 - Class Creation.
*/
global class ScheduledcpkReportFolderCreation implements Schedulable{

    global void execute(SchedulableContext SC) {
        batchMonthlycpkReportCreation monthlycpkreport = new batchMonthlycpkReportCreation();
        if(!Test.isRunningTest()){ database.executebatch(monthlycpkreport , 1); } else{ database.executebatch(monthlycpkreport); }
    }

}