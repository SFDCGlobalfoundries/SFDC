public class RFQIPR_TriggerHandler extends TriggerHandler {
    public static RFQIPR_TriggerHelper helper{get;set;}
   
   //constructor
    public RFQIPR_TriggerHandler(){
        helper = new RFQIPR_TriggerHelper();
   }
    
    //This method is calling the method which needs to be triggered in after insert event
    public override void afterinsert(){
        helper.upsertAcceptedIPR();
        
    }
     public override void afterupdate(){
        helper.upsertAcceptedIPR();
        
    }
     public override void afterdelete(){
        helper.updateAcceptedIPR();
        
    }
   
}