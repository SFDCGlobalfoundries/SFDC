/**
@Author < Meghna Ganguly >
@name < CDSTriggerHandler>
@CreateDate < 12/12/2016 >
@Description < This Handler class is handling the after insert event of CDSTrigger>
@Version <1.0>
*/public class CDSTriggerHandler extends TriggerHandler{
    public static CDSTriggerHelper helper { get; set; }
   
   //constructor
    public CDSTriggerHandler(){
        helper = new CDSTriggerHelper();
    }
    
   //This method is calling the method which needs to be triggered in after insert event 
   public override void afterinsert(){
        helper.updateOptionStage();
        
    }
}