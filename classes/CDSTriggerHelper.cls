/**
@Author < Varsha Tomar >
@name < CDSTriggerHelper >
@CreateDate < 12/4/2016 >
@Description < Helper class for CDS trigger >
@Version <1.0>
*/
public class CDSTriggerHelper {
    
    // method invoked on after insert event
    // method to update option stage when CDS is created
    public void updateOptionStage() {
    if(!IntegrationUserUtil.isSkipTrigger()){
        // list of option ids related to CDS
        List<Id> optionIds = new List<Id>();
    
        for(Custom_Design__c tr :(List<Custom_Design__c>)Trigger.new) {
            optionIds.add(tr.DIW_Option_Control_Number__c);
        }
        
        // query options which are in 'Bid and Quote' stage
        Map<Id, Customer_Requirement__c> optionsMap = new Map<Id, Customer_Requirement__c>([select id from Customer_Requirement__c where 
                                                Option_Stage__c = 'Bid and Quote' and id IN:optionIds]);
        
        // clear option id list
        optionIds.clear();
        // add option ids whose stage is 'Bid and Quote'
        optionIds.addAll(optionsMap.keySet());
        
        BnP_OptionUtility ctrl = new BnP_OptionUtility();
        // call generic method to update option stage
        ctrl.updateOptionStages(optionIds, 'Reconciliation');
    }
    }
}