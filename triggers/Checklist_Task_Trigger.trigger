trigger Checklist_Task_Trigger on Checklist_Task__c (before insert, before update, before delete, 
                                                     after insert, after update, after delete, 
                                                     after undelete) {
   if((Trigger.isInsert || Trigger.isUpdate || Trigger.isDelete) && Trigger.isAfter){
   }
   if(Trigger.isInsert && Trigger.isBefore){
        DeviceChecklistTaskRayTaskHelper.addDeadlineOnInsert(Trigger.new);
   }
   if(Trigger.isUpdate && Trigger.isBefore){
     DeviceChecklistTaskRayTaskHelper.updateTasks(Trigger.newMap, Trigger.oldMap);
     DeviceChecklistTaskRayTaskHelper.updateDeadlineOnTaskUpdate(Trigger.newMap, Trigger.oldMap);
   }

}