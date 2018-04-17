/**
@Author < Meghna Ganguly >
@name < DesignExecutionTriggerHandler>
@CreateDate < 12/12/2016 >
@Description < This Handler class is handling the after insert event of DesignExecutionTrigger>
@Version <1.0>
*/public class DesignExecutionTriggerHandler extends TriggerHandler{
    public static DesignExecutionTriggerHelper helper { get; set; }
   
   //constructor
    public DesignExecutionTriggerHandler(){
        helper = new DesignExecutionTriggerHelper();
    }
    
   //This method is calling the method which needs to be triggered in after insert event
    public override void afterinsert(){
        helper.updateOptionStage();
        
    }
}