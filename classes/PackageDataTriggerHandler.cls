/**
@Author < Meghna Ganguly >
@name < PackageDataTriggerHandler>
@CreateDate < 12/15/2016 >
@Description < This Handler class is handling the after insert event of PackageShareTrigger>
@Version <1.0>
*/public class PackageDataTriggerHandler extends TriggerHandler{
    //public static PackageDataTriggerHelper helper { get; set; }
   
   //constructor
    public PackageDataTriggerHandler(){
        //helper = new PackageDataTriggerHelper();
    }
    
    //This method is calling the method which needs to be triggered in after insert event
    public override void afterInsert(){
        //helper.insertpackdataShare();
    }
}