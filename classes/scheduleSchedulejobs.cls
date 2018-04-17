global class scheduleSchedulejobs implements schedulable{
    global void execute(SchedulableContext sc){
        Schedulejobs abc = new Schedulejobs();
        database.executebatch(abc);
        
    }
}