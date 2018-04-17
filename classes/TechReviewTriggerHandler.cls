/**
@Author < Meghna Ganguly >
@name < TechReviewTriggerHandler>
@CreateDate < 12/12/2016 >
@Description < This Handler class is handling the after insert event of TechReviewTrigger>
@Version <1.0>
*/public class TechReviewTriggerHandler extends TriggerHandler{
    public static TechReviewTriggerHelper helper { get; set; }
   
   //constructor
    public TechReviewTriggerHandler(){
        helper = new TechReviewTriggerHelper();
    }
    
    //This method is calling the method which needs to be triggered in after insert event
    public override void afterinsert(){
        helper.updateOptionStageOnInsert();
        helper.updateRTMReadyDateOnOption();
    }
    
    //This method is calling the method which needs to be triggered in after insert event
    public override void afterupdate(){
        helper.updateOptionStageOnUpdate();
        helper.updateRTMReadyDateOnOption();
    }
}