trigger Checklist_Container_Trigger on Checklist_Container__c ( before insert, before update, before delete, 
                                                               after insert, after update, after delete, 
                                                               after undelete) {
    if(Trigger.isUpdate && Trigger.isAfter  && !DeviceChecklistUtils.checklistCloningInProgress){
       DeviceChecklistTaskRayProjectHelper.afterUpdate(trigger.oldMap, trigger.newMap);
    }
    if(Trigger.isDelete && Trigger.isBefore){
        DeviceChecklistTaskRayProjectHelper.beforeDelete(Trigger.oldMap);
    }
    if(Trigger.isInsert && Trigger.isAfter && !DeviceChecklistUtils.checklistCloningInProgress){
        DeviceChecklistTaskRayProjectHelper.afterInsert(Trigger.newMap);
    }
}