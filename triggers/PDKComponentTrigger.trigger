/*
Type Name: PDKComponentTrigger
Author: Cognizant Case Management Team
Created Date:  04/08/2015
Test Class: 
Change History:
Modified Date: 11thMay2015
Reason: Sending Email Notification on creation, updation and deletion of PDK Component
Modified By: Monalisa Mohapatra.
--- 
--
*/
trigger PDKComponentTrigger on PDK_Component__c(after insert, before insert, before delete, before update, after update) {
    WorkRequestTriggerHandler wr = new WorkRequestTriggerHandler();    
    //before isnsert method validates for unique record
    //after insert method creates component team for PDK component
    if (trigger.isinsert) {
        if (trigger.isbefore) {
            for (pdk_component__c p: trigger.new)
                if (new WorkRequestTriggerHandler().ValidatePDKComponent(p))
                    p.adderror(System.Label.WR_PDK_Component_Validation_Error);
        }
        if (trigger.isafter) {
            new WorkRequestTriggerHandler().ComponentTeamforPDKComponent(trigger.new);
            new WorkRequestTriggerHandler().emailNotificationForPDKCreation(trigger.new);
        }
    }else if (trigger.isUpdate) {
        if (trigger.isbefore) {
            for (pdk_component__c p: trigger.new)
                if(p.id!=trigger.oldMap.get(p.id).Id){
                    if (new WorkRequestTriggerHandler().ValidatePDKComponent(p)){
                        p.adderror(System.Label.WR_PDK_Component_Validation_Error);
                    }
                }
        }
        
        if (trigger.isafter) {
            new WorkRequestTriggerHandler().emailNotificationForPDKUpdate(trigger.new, trigger.oldMap);
        }
    }else if (trigger.isDelete) {
        new WorkRequestTriggerHandler().emailNotificationForPDKDeletion(trigger.old);
    }
}