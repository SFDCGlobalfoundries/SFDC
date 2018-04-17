/*
    Author: Anirban Roy
    Description: This is the trigger on Task object.  
    History:
        ARoy        05152014    - code creation.
*/

trigger TaskTrigger on Task (before update,after update) {
    
    // Variables for GMPL/BX009
    final string BX009_STATUS_BRB_REVIEW = EnvironmentVariable.get('BX009_STATUS_BRB_REVIEW');
    final string GMPL_BX009_OBJECT = EnvironmentVariable.get('GMPL_BX009_OBJECT');
    final string BX009_TASK_STATUS_COMPLETED = EnvironmentVariable.get('BX009_TASK_STATUS_COMPLETED');  
    
    // this block resets the process flag for the CLM batch to pick up the records and process them for sending emails
    
    if(trigger.isBefore && trigger.isUpdate)
        for(Task t: Trigger.new)
             if( t.isReminderSet!=Trigger.oldmap.get(t.id).isReminderSet ||             
                 t.ReminderDateTime != Trigger.oldmap.get(t.id).ReminderDateTime  || 
                 t.OwnerId != Trigger.oldmap.get(t.id).OwnerId ||
                 t.WhoId != Trigger.oldmap.get(t.id).WhoId ||
                 t.CLM_Email_Addresses__c !=Trigger.oldmap.get(t.id).CLM_Email_Addresses__c )
                 t.IsProcessedByCLMBatch__c=FALSE;
                                          
                 
                 
         
    
   
    
    if(trigger.isAfter && trigger.isUpdate){
        
        /* Get the Task for the WhatId as GMPL/BX009 where the Subject is 'BRB Review'
           and sent a email notification on 'Completion' of the task to the creator of 
           the task.
        */
        //****************************************************************************//
        Map<Id,Id> gmplAssigneeIdMap = new Map<Id,Id>();
        List<Id> tskIds = new List<Id>();
        
        for(Task tsk : trigger.new){
            tskIds.add(tsk.Id);
        }
        
        for(Task tsk : [select    id
                                  , WhatId
                                  , What.Type
                                  , Subject
                                  , Status
                                  , OwnerId
                        from      Task
                        where     id in :tskIds]){
            if(tsk.WhatId != null && tsk.What.Type == GMPL_BX009_OBJECT 
                && tsk.Subject == BX009_STATUS_BRB_REVIEW && tsk.Status != trigger.oldMap.get(tsk.Id).Status 
                && tsk.Status == BX009_TASK_STATUS_COMPLETED){
                gmplAssigneeIdMap.put(tsk.WhatId,tsk.OwnerId);
            }
        }
        
        if(!gmplAssigneeIdMap.isEmpty()){
            //Call the email sending method
            system.debug('gmplAssigneeIdMap ==> '+gmplAssigneeIdMap);
            GMPLBX009NotificationEmail.sendEmailOnTask(gmplAssigneeIdMap);
        }
        //****************************************************************************//
    }
}