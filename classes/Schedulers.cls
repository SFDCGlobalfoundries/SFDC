global class Schedulers implements Schedulable{
    global void execute(SchedulableContext SC) {
       SchedullersController con = new SchedullersController(sc.getTriggerId());
     }
 }