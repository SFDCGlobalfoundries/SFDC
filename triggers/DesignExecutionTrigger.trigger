/**
@Author < Varsha Tomar >
@name < DesignExecutionTrigger >
@CreateDate < 11/21/2016 >
@Description < Trigger on Design Execution object >
@Version <1.0>
*/
trigger DesignExecutionTrigger on Design_Execution__c (after insert) {
   
   
     new DesignExecutionTriggerHandler().run();  
}