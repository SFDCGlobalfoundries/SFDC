public class MPWWIPLotReportsubScriberScheduler  implements Schedulable {
      public void execute(SchedulableContext ctx) {  
		    MPWWIPLotReportsubScriberBatch obj= new MPWWIPLotReportsubScriberBatch();
		    integer batchSize = 1;
		    database.executebatch(obj, batchSize);
	  } // execute
}