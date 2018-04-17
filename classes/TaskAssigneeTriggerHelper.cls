/*************************************************************************************************************************************************************
@ Class:          TaskAssigneeTriggerHelper
@ Version:        1.0
@ Author:         Poulami Saha
@ Purpose:        Helper class which consist of logics used in Task Assignee Trigger.
--------------------------------------------------------------------------------------------------------------------------------------------------------------
@ Change history: 16.12.2016 / Poulami Saha / Created the class.
**************************************************************************************************************************************************************/
Public Class TaskAssigneeTriggerHelper{
    /**
    *  The Purpose of this method is to restrict user from adding duplicate assignee.
    *  @name <beforeInsertUpdMethod>
    *  @param <NA> 
    *  @return <Void>
    *  @throws exception-<exception description>
    */
    public void beforeInsertMethod() {
        List<id> taskRouteIdList = new List<id>();
        for(RFQ_Task_Assignee__c taskAssignee : (List<RFQ_Task_Assignee__c>)trigger.new){
            taskRouteIdList.add(taskAssignee.RFQ_Task_Routing__c);
        }
        List<RFQ_Task_Assignee__c > rtaList= [select id,User__c,Task_Assignee_Id__c, RFQ_Task_Routing__c from RFQ_Task_Assignee__c where RFQ_Task_Routing__c IN: taskRouteIdList ];
        system.debug('rtaList size:' +rtaList);
        for(RFQ_Task_Assignee__c taskAssignee : (List<RFQ_Task_Assignee__c>)trigger.new){
            if( rtaList.size()>0){
                for(RFQ_Task_Assignee__c taskAssigneeNew : rtaList){
                    if(taskAssignee.RFQ_Task_Routing__c == taskAssigneeNew.RFQ_Task_Routing__c && taskAssignee.id != taskAssigneeNew.id){
                        system.debug('Inside 1st if');
                        if(taskAssignee.Task_Assignee_Id__c == taskAssigneeNew.Task_Assignee_Id__c){
                            system.debug('Inside 2nd if');
                            taskAssignee.adderror('Duplicate users not allowed');
                        }
                    }
                }
            }
        }
        
    }
    
    /**
    *  The Purpose of this method is to restrict user updating route is related RFQ is Accepted.
    *  @name <beforeUpdateMethod>
    *  @param <NA> 
    *  @return <Void>
    *  @throws exception-<exception description>
    */
    public void beforeUpdateMethod() {
        List<id> taskRouteIdList = new List<id>();
        for(RFQ_Task_Assignee__c taskAssignee : (List<RFQ_Task_Assignee__c>)trigger.new){
            taskRouteIdList.add(taskAssignee.RFQ_Task_Routing__c);
            
        }
        List<RFQ_Task_Assignee__c > rtaList= [select id,User__c,Task_Assignee_Id__c,RFQ_Task_Routing__c from RFQ_Task_Assignee__c where RFQ_Task_Routing__c IN: taskRouteIdList ];
        for(RFQ_Task_Assignee__c taskAssignee : (List<RFQ_Task_Assignee__c>)trigger.new){
            if( rtaList.size()>0){
                for(RFQ_Task_Assignee__c taskAssigneeNew : rtaList){
                    if(taskAssignee.RFQ_Task_Routing__c == taskAssigneeNew.RFQ_Task_Routing__c && taskAssignee.id != taskAssigneeNew.id){
                        if(taskAssignee.Task_Assignee_Id__c == taskAssigneeNew.Task_Assignee_Id__c){
                            taskAssignee.adderror('Duplicate users not allowed');
                        }
                    }
                }
            }
        }
        
        Map<Id, RFQ_Task_Assignee__c> taskAssigneeMap = new Map<Id, RFQ_Task_Assignee__c>();
        taskAssigneeMap.putAll([SELECT id,RFQ_Task_Routing__c,RFQ_Task_Routing__r.Related_RFQ_Routing__r.RFQ__r.Quote_Status__c FROM RFQ_Task_Assignee__c WHERE Id IN: trigger.new]);
        for(RFQ_Task_Assignee__c taskAssignee : (List<RFQ_Task_Assignee__c>)trigger.new){
            if(taskAssigneeMap.get(taskAssignee.Id).RFQ_Task_Routing__c != null && taskAssigneeMap.get(taskAssignee.Id).RFQ_Task_Routing__r.Related_RFQ_Routing__r.RFQ__r.Quote_Status__c == 'Accept'){
                taskAssignee.addError('Record locked as related RFQ/RFI Quote Status is \'Accept\'.');            
            }
        }
    }
    
    /**
    *  The Purpose of this method is to restrict user updating route is related RFQ is Accepted.
    *  @name <afterInsertUpdateMethod>
    *  @param <NA> 
    *  @return <Void>
    *  @throws exception-<exception description>
    */
    public void afterInsertUpdateMethod() {
        List<id> taskRouteIdList = new List<id>();
        List<RFQ_Tasks_Routing__c> tskToUpdate = new List<RFQ_Tasks_Routing__c>();
        for(RFQ_Task_Assignee__c taskAssignee : (List<RFQ_Task_Assignee__c>)trigger.new){
            taskRouteIdList.add(taskAssignee.RFQ_Task_Routing__c);
            
        }
        List<RFQ_Task_Assignee__c > tskAssigneeList= [select id,User__c,Task_Assignee_Id__c,RFQ_Task_Routing__c, Task_Assignee__c from RFQ_Task_Assignee__c where id IN: trigger.new order by lastmodifieddate asc];
        List<RFQ_Tasks_Routing__c> tskList = [Select id, Name, Task_Assignee__c from RFQ_Tasks_Routing__c where id IN: taskRouteIdList and complete__c = false];
        
        for(RFQ_Tasks_Routing__c tsk : tskList){
            for(RFQ_Task_Assignee__c tskAssignee : tskAssigneeList){
                if(tsk.id == tskAssignee.RFQ_Task_Routing__c){
                    tsk.Task_Assignee__c = tskAssignee.Task_Assignee__c;
                    tskToUpdate.add(tsk);
                }
            }
        }
        if(!tskToUpdate.isEmpty()){
            try{
             update tskToUpdate;
            }catch(DmlException excp){
                for (Integer i = 0; i < excp.getNumDml(); i++) {
                    Trigger.new[0].addError(excp.getDmlMessage(i));
                    //Trigger.new[0].addError('Updating Calculate due date based on is impacting the dependent task');
                }
            }
        }
    }
}