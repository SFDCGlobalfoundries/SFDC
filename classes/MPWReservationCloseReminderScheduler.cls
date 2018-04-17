global class MPWReservationCloseReminderScheduler implements Schedulable{
    public static String strCronExp = '0 00 00 * * ?';  //Every Day at 12 AM 
    
    global static String startSchedule(String strCronExpTemp) {
        if(strCronExpTemp != null && strCronExpTemp.trim() != '') {
            strCronExp = strCronExpTemp;
        }
        MPWReservationCloseReminderScheduler sc = new MPWReservationCloseReminderScheduler(); 
        if(!Test.isRunningTest()) {
            return System.schedule('MPW Reservation Close Reminder', strCronExp, sc);
        }
        else {
            return null;
        }
    }

    global void execute(SchedulableContext sc) {
        MPWReservationCloseReminderBatch b1 = new MPWReservationCloseReminderBatch();
        Id batchprocessid = Database.executeBatch(b1);           
    }
}