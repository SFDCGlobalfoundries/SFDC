global class MPWLotAssignmentNotificationScheduler implements schedulable {
    public static String strCronExp = '0 00 01 * * ?';  //Every Day at 1 AM 

    global static String startSchedule(String strCronExpTemp) {
        if(strCronExpTemp != null && strCronExpTemp.trim() != '') {
            strCronExp = strCronExpTemp;
        }
        
        MPWLotAssignmentNotificationScheduler oClass = new MPWLotAssignmentNotificationScheduler(); 
        if(!Test.isRunningTest()) {
            return System.schedule('MPW Lot Assignment Notification', strCronExp, oClass);
        }
        else {
            return null;
        }
    }

    global void execute(SchedulableContext sc) {
        MPWLotAssignmentNotificationBatch b = new MPWLotAssignmentNotificationBatch(); 
        database.executebatch(b);
    }
}