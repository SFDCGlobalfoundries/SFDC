/**
@Author < Meghna Ganguly >
@name < OptionTriggerHandler>
@CreateDate < 12/16/2016 >
@Description < This Handler class is handling the events of OptionTrigger>
@Version <1.0>
*/public class OptionTriggerHandler extends TriggerHandler{
    public static OptionTriggerHelper helper { get; set; }
   
   //constructor
    public OptionTriggerHandler(){
        helper = new OptionTriggerHelper();
    }
    
    //This method is calling the method which needs to be triggered in before insert event
    public override void beforeinsert(){
        system.debug('start>>>>>>>>>>Option Trigger BeforeInsert :SOQL queries:'+limits.getQueries());
        helper.setDeviceonInsert();
        helper.creatupdtOptBefore();
        system.debug('end>>>>>>>>>>Option Trigger BeforeInsert :SOQL queries:'+limits.getQueries());
    }
    
    //This method is calling the method which needs to be triggered in before update event
    public override void beforeupdate(){
        system.debug('start>>>>>>>>>>Option Trigger BeforeUpdate :SOQL queries:'+limits.getQueries());
        helper.setDeviceonUpdate();
        helper.creatupdtOptBefore(); 
        system.debug('end>>>>>>>>>>Option Trigger BeforeUpdate :SOQL queries:'+limits.getQueries());
    }
    
    //This method is calling the method which needs to be triggered in after insert event
    public override void afterinsert(){
        system.debug('start>>>>>>>>>>Option Trigger AfterInsert :SOQL queries:'+limits.getQueries());
         helper.createRFQ();
         helper.insertoptionShare();   
        system.debug('end>>>>>>>>>>Option Trigger AfterInsert :SOQL queries:'+limits.getQueries());
    }
    
    //This method is calling the method which needs to be triggered in after update event
    public override void afterupdate(){
        system.debug('start>>>>>>>>>>Option Trigger AfterUpdate :SOQL queries:'+limits.getQueries());
        if(checkRecursive.runOnce()){
            helper.createERP_DEVICE();
            helper.updateDevice();
            helper.updtChipOptionStageAfter();
        }  
        system.debug('end>>>>>>>>>>Option Trigger AfterUpdate :SOQL queries:'+limits.getQueries());
    }
    
}