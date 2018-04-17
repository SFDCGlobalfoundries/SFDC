/*
SWGP-998
This class is act as a dispatcher to schedule MRSBatchRetryMSIHSchedulable >> MRSBatchRetryMSIH.

This class will help to allow modification of MRSBatchRetryMSIH without the need of stopping 
running job as technically, this class is the one that get locked, not MRSBatchRetryMSIH.

Test class: MRSBatchRetryMSIHTest
*/
global class MRSMSIHScheduleDispatcher implements Schedulable {
    
    public interface IMRSMSIHScheduleDispatcher {
        void execute(SchedulableContext ctx);
    }
    
    global void execute(SchedulableContext ctx) {
        Type targetType = Type.forName('MRSBatchRetryMSIHSchedulable');
        if(targetType != null) {
            IMRSMSIHScheduleDispatcher obj = (IMRSMSIHScheduleDispatcher) targetType.newInstance();
            obj.execute(ctx);
        }
    }
}