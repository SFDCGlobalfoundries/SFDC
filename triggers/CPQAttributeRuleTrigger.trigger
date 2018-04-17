trigger CPQAttributeRuleTrigger on Attribute_Rule__c (After Update, After Insert, before delete, Before Insert, Before Update) {
    List<Attribute_Rule__c> triggeredRec = new List<Attribute_Rule__c> ();
    CPQAttributeRuleTriggerHandler handler = new CPQAttributeRuleTriggerHandler();
    if(trigger.isAfter){
        if(trigger.isUpdate || trigger.isInsert){
            for(Attribute_Rule__c ARule : trigger.new){
                String AddError = ARule.Mask_Layers__c == null && ARule.HasChildRule__c == FALSE ? 'Mask Layers': ARule.Attribute_Field_Value__c == null && ARule.HasChildRule__c == FALSE ? 'Attribute Field Value': '';                 
                if(AddError != ''){
                    ARule.addError('Please enter '+AddError );
                }
                else{
                    triggeredRec.add(ARule);
                }
            }
            handler.upsertHandler(triggeredRec);
        }        
    }  
    if(trigger.isBefore){
        if(trigger.isInsert || trigger.isUpdate){
            for(Attribute_Rule__c ARule : trigger.new){
                ARule.Attribute_Unique_Identifier__c = ARule.CPQ_MLGPLUS__c + '_' + ARule.Attribute_Group_Name__c + '_' + ARule.Attribute_Field_API_Name__c + '_' + ARule.Attribute_Field_Value__c; // added to remove attribute rule duplicacy case#0049711
            }
        }
        else if(trigger.isDelete){
            for(Attribute_Rule__c ARule : trigger.old){
                triggeredRec.add(ARule);
                
            }
            handler.deleteHandler(triggeredRec);
        }
    } 
}