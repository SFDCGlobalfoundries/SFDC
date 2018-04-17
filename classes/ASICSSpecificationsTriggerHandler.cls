/**
@Author < Meghna Ganguly >
@name < ASICSSpecificationsTriggerHandler>
@CreateDate < 01/05/2016 >
@Description < This Handler class is handling the after insert event of AsicsSpecificationsTrigger>
@Version <1.0>
*/
public class ASICSSpecificationsTriggerHandler extends TriggerHandler{
    public static ASICSSpecificationsTriggerHelper helper { get; set; }
   
   //constructor
    public ASICSSpecificationsTriggerHandler(){
        helper = new ASICSSpecificationsTriggerHelper();
    }
    
    //This method is calling the method which needs to be triggered in after insert event
    public override void afterInsert(){
        helper.insertasicSpecificationsShare();
    }
}