/**
@Author < Varsha Tomar >
@name < DesignExecutionTriggerHelper >
@CreateDate < 11/21/2016 >
@Description < Helper class for DesignExecutionTrigger >
@Version <1.0>
*/
public class DesignExecutionTriggerHelper {
    
    // method invoked on after insert event
    // method to update option stage when Design Execution is created
    public void updateOptionStage() {
        // list of option ids related to CDS
        List<Id> optionIds = new List<Id>();
    
        for(Design_Execution__c tr :(List<Design_Execution__c>)Trigger.new) {
            optionIds.add(tr.Option__c);
        }
        
        BnP_OptionUtility ctrl = new BnP_OptionUtility();
        // call generic method to update option stage
        ctrl.updateOptionStages(optionIds, 'Design Execution');
    }
}