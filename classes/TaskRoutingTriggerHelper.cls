/*************************************************************************************************************************************************************
@ Class:          TaskRoutingTriggerHelper
@ Version:        1.0
@ Author:         Poulami Saha
@ Purpose:        Helper class which consist of logics used in Task Routing Trigger.
--------------------------------------------------------------------------------------------------------------------------------------------------------------
@ Change history: 16.12.2016 / Poulami Saha / Created the class.
**************************************************************************************************************************************************************/
Public Class TaskRoutingTriggerHelper{

    /*Global Variables*/
    Public List<Id> rfqTaskIdList { get; set; }
    Public List<Id> rfqRouteList { get; set; }
    Public List<Id> rfqRouteToEmailList { get; set; }
    Public List<Integer> rfqRouteTaskOrderList { get; set; }
    Public List<RFQ_Tasks_Routing__c> rfqRouteToEmailObjList { get; set; }
    Public Set<Id> rfqTaskParentIdSet { get; set; }
    Public Map<Id, Set<Id>> rfqTaskRoutIdTaskassigneeMap { get; set; }
    Public Map<Id, List<String>> rfqTaskRoutIdTaskassigneeEmailMap { get; set; }
    Public List<String> usrIdList { get; set; }
    Public List<String> usrEmailList { get; set; }
    public Map<Id,RFQ_Tasks_Routing__c> triggerOldMap { get; set; }
    
    /*********************************************************************************************************************************************************
    @ Constructor:    TaskRoutingTriggerHelper
    @ Version:        1.0
    @ Author:         Poulami saha
    @ Purpose:        Initialises the class for controller instance.
    **********************************************************************************************************************************************************/  
    Public TaskRoutingTriggerHelper(){
        rfqTaskIdList = new List<Id>();
        rfqRouteList = new List<Id>();
        rfqRouteToEmailList = new List<Id>();
        rfqRouteTaskOrderList = new List<Integer>();
        rfqRouteToEmailObjList = new List<RFQ_Tasks_Routing__c>();
        rfqTaskParentIdSet = new Set<Id>();
        rfqTaskRoutIdTaskassigneeMap = new Map<Id, Set<Id>>();
        rfqTaskRoutIdTaskassigneeEmailMap = new Map<Id, List<String>>();
        usrIdList = new List<String>();
        usrEmailList = new List<String>();
        triggerOldMap = ((Map<Id,RFQ_Tasks_Routing__c>)Trigger.oldMap);
        
        for(RFQ_Tasks_Routing__c rfpRout: (List<RFQ_Tasks_Routing__c>)trigger.new){
            rfqTaskIdList.add(rfpRout.id);
            rfqRouteList.add(rfpRout.Related_RFQ_Routing__c);
            //rfqTaskParentIdSet.add(rfpRout.Parent_task__c);
            rfqTaskParentIdSet.add(rfpRout.Predecessor_Task__c);
            if(rfpRout.complete__c == true){
                rfqRouteToEmailList.add(rfpRout.id);
                rfqRouteToEmailObjList.add(rfpRout);
                //Integer order = rfpRout.order_New__c + 1
                if(rfpRout.order_New__c <> 0 && rfpRout.order_New__c <> null){
                    rfqRouteTaskOrderList.add(Integer.Valueof(rfpRout.order_New__c)+1);
                }
                
            }
        }
        List<RFQ_Task_Assignee__c> rfqTaskassigneeList = [Select Id, RFQ_Task_Routing__c, User__c, User__r.id, All_Task_Assignee_Id__c, Task_Assignee_Email__c from RFQ_Task_Assignee__c where RFQ_Task_Routing__c IN :rfqTaskIdList];
        
    
        for(RFQ_Tasks_Routing__c taskRout:(List<RFQ_Tasks_Routing__c>)trigger.new){
            for(RFQ_Task_Assignee__c rfqTaskAssign : rfqTaskassigneeList){
                
                if(taskRout.id == rfqTaskAssign.RFQ_Task_Routing__c){
                    
                    if(rfqTaskAssign.All_Task_Assignee_Id__c != null && rfqTaskAssign.All_Task_Assignee_Id__c != ''){
                        for( String usrId : rfqTaskAssign.All_Task_Assignee_Id__c.split(',')){
                            usrIdList.add(usrId);
                        }
                    }
                                    
                    for(String userId : usrIdList){
                        if(rfqTaskRoutIdTaskassigneeMap.containsKey(taskRout.id)){
                            rfqTaskRoutIdTaskassigneeMap.get(taskRout.id).add(userId);
                        }else{
                                rfqTaskRoutIdTaskassigneeMap.put(taskRout.id, new Set <Id> {
                                                userId
                                });
                        }
                    }
                    
                    if(rfqTaskAssign.Task_Assignee_Email__c != null && rfqTaskAssign.Task_Assignee_Email__c != ''){
                        for( String usrEmail : rfqTaskAssign.Task_Assignee_Email__c.split(',')){
                            usrEmailList.add(usrEmail);
                        }
                        for(String userEmail : usrEmailList){
                            if(rfqTaskRoutIdTaskassigneeEmailMap.containsKey(taskRout.id)){
                                rfqTaskRoutIdTaskassigneeEmailMap.get(taskRout.id).add(userEmail);
                            }else{
                                    rfqTaskRoutIdTaskassigneeEmailMap.put(taskRout.id, new List <String> {
                                                    userEmail
                                    });
                            }
                        }
                    }
                }
            }
        }
    }
    
    public void beforeInsertUpdMethod() {
        for(RFQ_Tasks_Routing__c taskRout: (List<RFQ_Tasks_Routing__c>)trigger.new){
            if((taskRout.Task_Name__c == null || taskRout.Task_Name__c == '') && (taskRout.Select_Task_Name__c != null || taskRout.Select_Task_Name__c != '')){
                    taskRout.Task_Name__c = taskRout.Select_Task_Name__c;
            }
            if((taskRout.Task_Name__c == null || taskRout.Task_Name__c == '') && (taskRout.Select_Task_Name__c == null || taskRout.Select_Task_Name__c == '')){
                taskRout.addError('Please provide value either in "Task Name" or in "Task Type"');
            }
        }
        for(RFQ_Tasks_Routing__c rfpRout:  (List<RFQ_Tasks_Routing__c>)trigger.new){
            if(Trigger.isInsert){
                if(rfpRout.complete__c == true || rfpRout.Task_Status__c == 'Cancel'){
                    rfpRout.End_Date__c = System.now();
                    if(rfpRout.complete__c == true){
                        rfpRout.Task_Status__c = 'Complete';
                    }
                    if(rfpRout.Task_Status__c == 'Cancel'){
                        if(rfpRout.Actual_End_Date__c == null){
                            if(rfpRout.Adjusted_Start_Date__c == null && rfpRout.Start_Date__c == null){
                                rfpRout.Actual_End_Date__c = system.now();
                                rfpRout.Adjusted_Start_Date__c = system.now();
                                rfpRout.Start_Date__c = system.now();
                            }else if(rfpRout.Adjusted_Start_Date__c == null && rfpRout.Start_Date__c != null){
                                rfpRout.Actual_End_Date__c = system.now();
                                rfpRout.Adjusted_Start_Date__c = system.now();
                            }else if(rfpRout.Adjusted_Start_Date__c != null && rfpRout.Start_Date__c != null){
                                rfpRout.Actual_End_Date__c = system.now();
                            }else if(rfpRout.Adjusted_Start_Date__c != null && rfpRout.Start_Date__c == null){
                                rfpRout.Actual_End_Date__c = system.now();
                                rfpRout.Start_Date__c = system.now();
                            }
                        }
                    }
                }
                if(rfpRout.Task_Status__c =='Pause'){
                    rfpRout.Pause_Start_Date__c = System.now();
                    rfpRout.Is_Paused__c = true;
                }
            }
            if(Trigger.isUpdate){
                RFQ_Tasks_Routing__c oldRFPRout = triggerOldMap.get(rfpRout.Id);
                if(rfpRout.complete__c == true || rfpRout.Task_Status__c == 'Cancel'){
                    if((oldRFPRout.Task_Status__c <> rfpRout.Task_Status__c && rfpRout.Task_Status__c == 'Cancel') || (oldRFPRout.complete__c == false && rfpRout.complete__c == true)){
                        rfpRout.End_Date__c = System.now();
                        if(oldRFPRout.complete__c == false && rfpRout.complete__c == true){
                            rfpRout.Task_Status__c = 'Complete';
                        }
                        if(oldRFPRout.Task_Status__c <> rfpRout.Task_Status__c && rfpRout.Task_Status__c == 'Cancel'){
                            if(rfpRout.Actual_End_Date__c == null){
                                if(rfpRout.Adjusted_Start_Date__c == null && rfpRout.Start_Date__c == null){
                                    rfpRout.Actual_End_Date__c = system.now();
                                    rfpRout.Adjusted_Start_Date__c = system.now();
                                    rfpRout.Start_Date__c = system.now();
                                }else if(rfpRout.Adjusted_Start_Date__c == null && rfpRout.Start_Date__c != null){
                                    rfpRout.Actual_End_Date__c = system.now();
                                    rfpRout.Adjusted_Start_Date__c = system.now();
                                }else if(rfpRout.Adjusted_Start_Date__c != null && rfpRout.Start_Date__c != null){
                                    rfpRout.Actual_End_Date__c = system.now();
                                }else if(rfpRout.Adjusted_Start_Date__c != null && rfpRout.Start_Date__c == null){
                                    rfpRout.Actual_End_Date__c = system.now();
                                    rfpRout.Start_Date__c = system.now();
                                }
                            }
                        }
                    }
                }
                if(oldRFPRout.Task_Status__c <> rfpRout.Task_Status__c && rfpRout.Task_Status__c =='Pause'){
                    rfpRout.Pause_Start_Date__c = System.now();
                    rfpRout.Is_Paused__c = true;
                }else if(oldRFPRout.Task_Status__c <> rfpRout.Task_Status__c && oldRFPRout.Task_Status__c =='Pause' && rfpRout.Is_Paused__c == true){
                    rfpRout.skip_validation__c = true;
                    rfpRout.Is_Paused__c = false;
                }
            }
        }
    }
    
    public void beforeInsertMethod() {
        //***********************************
        Map<Id,RFQ_Tasks_Routing__c> rfqTaskParentIdMap = new Map<Id,RFQ_Tasks_Routing__c>();
        for(RFQ_Tasks_Routing__c rfqParentTask : [SELECT id,Name,Order__c,Sequence__c,Start_Date__c,End_Date_New__c,End_Date__c,Complete__c,CreatedDate,Related_RFQ_Routing__c,Task_Due_Date_and_Time__c, Actual_End_Date__c from RFQ_Tasks_Routing__c Where Id IN: rfqTaskParentIdSet]){
            for(RFQ_Tasks_Routing__c rfpTask : (List<RFQ_Tasks_Routing__c>)trigger.new){
                if(rfpTask.Predecessor_Task__c != null && rfpTask.Predecessor_Task__c == rfqParentTask.Id){
                    rfqTaskParentIdMap.put(rfpTask.Id,rfqParentTask);
                }
            }
        }
        for(RFQ_Tasks_Routing__c rfpRout: (List<RFQ_Tasks_Routing__c>)trigger.new){
            
            if(rfpRout.Predecessor_Task__c != null && rfqTaskParentIdMap.get(rfpRout.Id).Actual_End_Date__c != null){
                rfpRout.Start_Date__c = rfqTaskParentIdMap.get(rfpRout.Id).Actual_End_Date__c;
            }
            if(rfpRout.Start_Date__c != null && rfpRout.Add_Offset_Days__c != null && rfpRout.Add_Offset_Days__c != ''){
                Integer duration = integer.ValueOf(rfpRout.Add_Offset_Days__c);
                rfpRout.Task_Due_Date_and_Time__c = rfpRout.Start_Date__c.addDays(duration);
            }
        }
        //*************************************
    }
    
    public void beforeUpdateMethod() {
        Map<Id, RFQ_Tasks_Routing__c> rfqTaskRouteMap = new Map<Id, RFQ_Tasks_Routing__c>();
        rfqTaskRouteMap.putAll([SELECT id,Skip_Validation__c,CreatedDate,LastModifiedDate,Related_RFQ_Routing__c,Related_RFQ_Routing__r.RFQ__c,Related_RFQ_Routing__r.RFQ__r.Quote_Status__c FROM RFQ_Tasks_Routing__c WHERE Id IN: trigger.new]);
        
        List<Messaging.SingleEmailMessage> newMails = new List<Messaging.SingleEmailMessage>();
        
        for(RFQ_Tasks_Routing__c taskRout: (List<RFQ_Tasks_Routing__c>)trigger.new){
            if(taskRout.Delegated_To__c!=null && (taskRout.Delegated_To__c <> triggerOldMap.get(taskRout.Id).Delegated_To__c))taskRout.ownerid=taskRout.Delegated_To__c;
            else if(taskRout.Delegated_To__c==null && triggerOldMap.get(taskRout.Id).Delegated_To__c != null && taskRout.ownerid == triggerOldMap.get(taskRout.Id).Delegated_To__c)taskRout.ownerid=userinfo.getuserid();
            
            //PSaha 08262016
            RFQ_Tasks_Routing__c oldRFPRout = triggerOldMap.get(taskRout.Id);
            if(taskRout.Task_Due_Date_and_Time__c <> oldRFPRout.Task_Due_Date_and_Time__c){
                Messaging.SingleEmailMessage singleMail = new Messaging.SingleEmailMessage();
                List<String> taskassigneeEmailListToNotify = new List<String>();
                List<String> taskassigneeEmailList = rfqTaskRoutIdTaskassigneeEmailMap.get(taskRout.id);
                if(taskassigneeEmailList != null){
                    for(String taskAssEmail : taskassigneeEmailList){
                        taskassigneeEmailListToNotify.add(taskAssEmail);
                    }
                }
                if(taskassigneeEmailListToNotify != null && taskassigneeEmailListToNotify.size() > 0){
                    singleMail.setToAddresses(taskassigneeEmailListToNotify);
                    singleMail.setSubject('Due date for Task : ' +taskRout.Name+' is changed');
                    String body = 'Task Name :' +taskRout.Name;
                    body+= '<br/>';
                    String oldDueDate = '';
                    if(oldRFPRout.Task_Due_Date_and_Time__c != null){
                        Datetime oldDueDateTime = Datetime.newInstance(oldRFPRout.Task_Due_Date_and_Time__c.year(), oldRFPRout.Task_Due_Date_and_Time__c.month(), oldRFPRout.Task_Due_Date_and_Time__c.day());
                        oldDueDate = oldDueDateTime.format('dd/MMM/yyyy');
                    }
                    body+= 'Task Due Date and Time (Previous) :' +oldDueDate;
                    body+= '<br/>';
                    String dueDate = '';
                    if(taskRout.Task_Due_Date_and_Time__c != null){
                        Datetime dueDateTime = Datetime.newInstance(taskRout.Task_Due_Date_and_Time__c.year(), taskRout.Task_Due_Date_and_Time__c.month(), taskRout.Task_Due_Date_and_Time__c.day());
                        dueDate = dueDateTime.format('dd/MMM/yyyy');
                    }
                    body+= 'Task Due Date and Time :' +dueDate;
                    body += '<br/>';
                    body += '<br/>';
                    String hyperLink = URL.getSalesforceBaseUrl().toExternalForm()+'/'+taskRout.id;
                    body += '<a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+taskRout.id+'">'+hyperLink+'</a>';
                    singleMail.setHtmlBody(body);
                    newMails.add(singleMail);
                }
            }
            if(!BNPStopTrigger.bypassTriggerLogic){
                if((rfqTaskRouteMap.get(taskRout.Id).LastModifiedDate.minute() - rfqTaskRouteMap.get(taskRout.Id).CreatedDate.minute()) >= 0.1 && rfqTaskRouteMap.get(taskRout.Id).Related_RFQ_Routing__c != null && rfqTaskRouteMap.get(taskRout.Id).Related_RFQ_Routing__r.RFQ__r.Quote_Status__c == 'Accept'){// && taskRout.Skip_Validation__c == false
                    taskRout.addError('Record locked as related RFQ/RFI Quote Status is \'Accept\'.');            
                }
            }
            
            if(oldRFPRout.Task_Status__c == 'Pause' && oldRFPRout.Task_Status__c != taskRout.Task_Status__c){
                taskRout.Pause_Reason__c = '';
            }
        }
        if(!newMails.isEmpty()){
            Messaging.sendEmail(newMails);
        }
        
        //***********************************
        Map<Id,RFQ_Tasks_Routing__c> rfqTaskParentIdMap = new Map<Id,RFQ_Tasks_Routing__c>();
        for(RFQ_Tasks_Routing__c rfqParentTask : [SELECT id,Name,Order__c,Sequence__c,Start_Date__c,End_Date_New__c,End_Date__c,Complete__c,CreatedDate,Related_RFQ_Routing__c,Task_Due_Date_and_Time__c,Actual_End_Date__c from RFQ_Tasks_Routing__c Where Id IN: rfqTaskParentIdSet]){
            for(RFQ_Tasks_Routing__c rfpTask : (List<RFQ_Tasks_Routing__c>)trigger.new){
                if(rfpTask.Predecessor_Task__c != null && rfpTask.Predecessor_Task__c == rfqParentTask.Id){
                    rfqTaskParentIdMap.put(rfpTask.Id,rfqParentTask);
                }
            }
        }
        for(RFQ_Tasks_Routing__c rfpRout: (List<RFQ_Tasks_Routing__c>)trigger.new){
            RFQ_Tasks_Routing__c oldRFPRout = triggerOldMap.get(rfpRout.Id);
            
            if(rfpRout.Predecessor_Task__c != oldRFPRout.Predecessor_Task__c && rfpRout.Predecessor_Task__c != null){
                if(rfqTaskParentIdMap.get(rfpRout.Id).createddate > rfpRout.createddate){
                    rfpRout.addError('Created By Date of Predecessor Task can not be less than dependent task');
                }
            }
            
            if(rfpRout.Predecessor_Task__c != oldRFPRout.Predecessor_Task__c && rfpRout.Predecessor_Task__c != null){
                rfpRout.Start_Date__c = rfqTaskParentIdMap.get(rfpRout.Id).Actual_End_Date__c;
            }
            if(rfpRout.Start_Date__c != oldRFPRout.Start_Date__c || rfpRout.Add_Offset_Days__c != oldRFPRout.Add_Offset_Days__c){
                if(rfpRout.Start_Date__c != null && rfpRout.Add_Offset_Days__c != null && rfpRout.Add_Offset_Days__c != ''){
                    Integer duration = integer.ValueOf(rfpRout.Add_Offset_Days__c);
                    rfpRout.Task_Due_Date_and_Time__c = rfpRout.Start_Date__c.addDays(duration);
                }else{
                    rfpRout.Task_Due_Date_and_Time__c = null;
                }
            }
            
        }
        //*************************************
    }
    
    public void afterInsertUpdMethod() {
        boolean firequery = false;
        decimal totalTskWithPause = 0;
        decimal totalTskWithoutPause = 0;
        List<RFQ_Tasks_Routing__c> tskcompList = new List<RFQ_Tasks_Routing__c>();
        List<RFQ_Routing__c> routeList = new List<RFQ_Routing__c>();
        Map<id,decimal> routeTotalTskWithPauseMap = new Map<id,decimal>();
        Map<id,decimal> routeTotalTskWithoutPauseMap = new Map<id,decimal>();
        List<RFQ_Routing__c> routeToUpdList = new List<RFQ_Routing__c>();
        routeList = [SELECT id, First_Task_Created_Date_Time__c, Total_Close_Tasks_Duration_without_Pause__c, Total_Close_Tasks_Duration_with_Pause__c from RFQ_Routing__c where id IN: rfqRouteList];
        for(RFQ_Tasks_Routing__c rfqTask: (List<RFQ_Tasks_Routing__c>)trigger.new){
            if(rfqTask.Complete__c == true || rfqTask.Task_Status__c == 'Cancel' || rfqTask.Task_Status__c == 'Complete'){
                firequery = true;
            }
        }
        if(firequery){
            tskcompList = [SELECT id, Task_Duration__c, Total_Task_Duration_without_Pause__c, Related_RFQ_Routing__c from RFQ_Tasks_Routing__c where Related_RFQ_Routing__c IN: rfqRouteList AND (Complete__c = true OR Task_Status__c = 'Cancel' OR Task_Status__c = 'Complete')];  
            //routeList = [SELECT id, Total_Close_Tasks_Duration_without_Pause__c, Total_Close_Tasks_Duration_with_Pause__c from RFQ_Routing__c where id IN: rfqRouteList];
        }
        if(!tskcompList.isEmpty()){
            for(RFQ_Tasks_Routing__c rfqTask: (List<RFQ_Tasks_Routing__c>)trigger.new){
                totalTskWithPause = 0;
                totalTskWithoutPause = 0;
                for(RFQ_Tasks_Routing__c tskcomp : tskcompList){
                    if(rfqTask.Related_RFQ_Routing__c == tskcomp.Related_RFQ_Routing__c){
                        system.debug('***********totalTskWithPause  1***********' +totalTskWithPause);
                        if(tskcomp.Task_Duration__c != null){
                            totalTskWithPause += tskcomp.Task_Duration__c;
                        }
                        system.debug('***********totalTskWithPause  2***********' +totalTskWithPause);
                        system.debug('***********totalTskWithoutPause  1***********' +totalTskWithoutPause);
                        if(tskcomp.Total_Task_Duration_without_Pause__c != null){
                            totalTskWithoutPause += tskcomp.Total_Task_Duration_without_Pause__c;
                        }
                        system.debug('***********totalTskWithoutPause  2***********' +totalTskWithoutPause);
                        routeTotalTskWithPauseMap.put(tskcomp.Related_RFQ_Routing__c,totalTskWithPause);
                        routeTotalTskWithoutPauseMap.put(tskcomp.Related_RFQ_Routing__c,totalTskWithoutPause);
                    }
                }
            }
        }
        if(!routeList.isEmpty()){
            for(RFQ_Routing__c route : routeList){
                boolean rUpd = false;
                if(routeTotalTskWithPauseMap.get(route.id) != null){
                    system.debug('***********totalTskWithPause  3***********' +routeTotalTskWithPauseMap.get(route.id));
                    route.Total_Close_Tasks_Duration_with_Pause__c = routeTotalTskWithPauseMap.get(route.id);
                    rUpd = true;
                }
                if(routeTotalTskWithoutPauseMap.get(route.id) != null){
                    system.debug('***********totalTskWithoutPause  3***********' +routeTotalTskWithoutPauseMap.get(route.id));
                    route.Total_Close_Tasks_Duration_without_Pause__c = routeTotalTskWithoutPauseMap.get(route.id);
                    rUpd = true;
                }
                if(Trigger.isInsert){
                    for(RFQ_Tasks_Routing__c tskcomp : (List<RFQ_Tasks_Routing__c>)trigger.new){
                        if(route.id == tskcomp.Related_RFQ_Routing__c){
                            if(route.First_Task_Created_Date_Time__c == null){
                                route.First_Task_Created_Date_Time__c = System.now();
                                rUpd = true;
                            }
                        }
                    }
                }
                if(rUpd){
                    routeToUpdList.add(route);
                }
            }

        }
        
        if(!routeToUpdList.isEmpty()){
            //if(BNPStopRecurssion.runOnce())
            //{
                update routeToUpdList;
            //}
        }
    }
    
    public void afterInsertMethod() {
        List<RFQ_Tasks_Routing__c> rfpRoutPar = [SELECT id, Order__c, Task_Status__c, Pause_Reason__c, Request_Catcher__c, Related_RFQ_Routing__c,Complete__c,Related_RFQ_Routing__r.RFQ__c, Related_RFQ_Routing__r.RFQ__r.Primary_Request_Catcher__c, Related_RFQ_Routing__r.RFQ__r.Backup_Request_Catcher__c, Related_RFQ_Routing__r.OwnerId, Related_RFQ_Routing__r.CreatedById FROM RFQ_Tasks_Routing__c WHERE Id IN: trigger.new ORDER BY createddate asc];
        List<RFQ_Tasks_Routing__c> routeOldList = [SELECT id, Order__c, Related_RFQ_Routing__c from RFQ_Tasks_Routing__c where Related_RFQ_Routing__c IN: rfqRouteList ORDER BY Order__c desc];  
            List <RFQ_Tasks_Routing__c> rfqRouteToUpdateList = new List<RFQ_Tasks_Routing__c>();
            List <RFQ_Tasks_Routing__c> rfqRouteToUpdateList1 = new List<RFQ_Tasks_Routing__c>();
            List<Task_Pause_Details__c> tskPauseDetList = new List<Task_Pause_Details__c>();
            for(RFQ_Tasks_Routing__c rfpRout : rfpRoutPar){
                rfpRout.Request_Catcher__c = rfpRout.Related_RFQ_Routing__r.RFQ__r.Primary_Request_Catcher__c;
                rfpRout.Backup_Request_Catcher__c = rfpRout.Related_RFQ_Routing__r.RFQ__r.Backup_Request_Catcher__c;
                rfpRout.Route_Owner__c = rfpRout.Related_RFQ_Routing__r.OwnerId;
                rfpRout.Route_Creator__c = rfpRout.Related_RFQ_Routing__r.CreatedById;
                rfpRout.Skip_Validation__c = true;
                if(!routeOldList.isEmpty()){
                    for(RFQ_Tasks_Routing__c route : routeOldList){
                        if(route.Related_RFQ_Routing__c == rfpRout.Related_RFQ_Routing__c && route.id != rfpRout.id){
                            rfpRout.Order__c = routeOldList[0].Order__c + 1;
                            rfpRout.Skip_Validation__c = true;
                        }else if(route.id == rfpRout.id && routeOldList.size() == 1){
                            rfpRout.Order__c = 1;
                            rfpRout.Skip_Validation__c = true;
                        }
                    }
                    
                }
                rfqRouteToUpdateList.add(rfpRout);
                if(rfpRout.Task_Status__c == 'Pause'){
                    Task_Pause_Details__c tskPauseDet = new Task_Pause_Details__c();
                    tskPauseDet.Pause_Start_Date__c = system.now();
                    tskPauseDet.Pause_Reason__c = rfpRout.Pause_Reason__c;
                    tskPauseDet.Related_Task__c = rfpRout.id;
                    tskPauseDetList.add(tskPauseDet);
                }
            }
            if(!rfqRouteToUpdateList.isEmpty()){
                update rfqRouteToUpdateList;
            }
            //if(BNPStopRecurssion.runOnce())
            //{
                if(!tskPauseDetList.isEmpty()){
                    insert tskPauseDetList;
                }
            //}
    }
    
    public void afterUpdateMethod() {
        List<RFQ_Tasks_Routing__c> rfqTaskRouteToUpdateList = [Select Id, Name, Related_RFQ_Routing__c from RFQ_Tasks_Routing__c WHERE Related_RFQ_Routing__c IN :rfqRouteList and Complete__c = false];

            
        List<RFQ_Tasks_Routing__c> rfqTaskRouteAutoStopList = [Select Id, Name, Related_RFQ_Routing__c, Related_RFQ_Routing__r.Auto_Stop_on_Rejection__c from RFQ_Tasks_Routing__c WHERE Related_RFQ_Routing__c IN :rfqRouteList];
        Map<Id, List<RFQ_Tasks_Routing__c>> rfqTaskRouteIdTaskRouteMap = new Map<Id, List<RFQ_Tasks_Routing__c>>();
        List<RFQ_Tasks_Routing__c> rfqTaskToUpdate = new List<RFQ_Tasks_Routing__c>();
        Map<Id, String> rfqTaskRouteIdAutoStopMap = new Map<Id, String>();    
        
        for(RFQ_Tasks_Routing__c taskRout:  (List<RFQ_Tasks_Routing__c>)trigger.new){
            if(rfqTaskRouteToUpdateList.size() > 0){
                for(RFQ_Tasks_Routing__c taskRoutToUpdt: rfqTaskRouteToUpdateList){
                    if(taskRout.Related_RFQ_Routing__c == taskRoutToUpdt.Related_RFQ_Routing__c){
                        if(rfqTaskRouteIdTaskRouteMap.containsKey(taskRout.id)){
                            rfqTaskRouteIdTaskRouteMap.get(taskRout.id).add(taskRoutToUpdt);
                        }else{
                            rfqTaskRouteIdTaskRouteMap.put(taskRout.id, new List <RFQ_Tasks_Routing__c> {
                                            taskRoutToUpdt
                            });
                        }
                    }
                }
                for(RFQ_Tasks_Routing__c taskRoutAutoStop : rfqTaskRouteAutoStopList){
                    if(taskRout.id == taskRoutAutoStop.id){
                        rfqTaskRouteIdAutoStopMap.put(taskRout.id, taskRoutAutoStop.Related_RFQ_Routing__r.Auto_Stop_on_Rejection__c);
                    }
                }
            }
        }
        List<RFQ_Tasks_Routing__c> rfqTaskToUpdateSubList = new List<RFQ_Tasks_Routing__c>();
        
        List<String> tskRouteIdList = new List<String>();
        List<RFQ_Tasks_Routing__c> tskRouteList = new List<RFQ_Tasks_Routing__c>();
        List<Task_Pause_Details__c> tskPauseDetList = new List<Task_Pause_Details__c>();
        
        for(RFQ_Tasks_Routing__c rfpRout:  (List<RFQ_Tasks_Routing__c>)trigger.new){
            RFQ_Tasks_Routing__c oldRFPRout = triggerOldMap.get(rfpRout.Id);
            String rfqRoutAutoStop = rfqTaskRouteIdAutoStopMap.get(rfpRout.id);
                    
            if(oldRFPRout.Status__c != rfpRout.Status__c && rfpRout.Status__c == 'Reject' && rfqRoutAutoStop == 'Immediate'){
                if(rfqTaskRouteIdTaskRouteMap != null){
                    rfqTaskToUpdateSubList.addAll(rfqTaskRouteIdTaskRouteMap.get(rfpRout.id)) ;
                }
                if(rfqTaskToUpdateSubList.size() > 0){
                    for(RFQ_Tasks_Routing__c rfqTskToUpdate : rfqTaskToUpdateSubList){
                        rfqTskToUpdate.Complete__c = true;
                        rfqTskToUpdate.Skip_Validation__c = true;
                        //update rfqTskToUpdate;
                        rfqTaskToUpdate.add(rfqTskToUpdate);
                    }
                }
            }
            
            if(oldRFPRout.Task_Status__c == 'Pause' && oldRFPRout.Task_Status__c != rfpRout.Task_Status__c){
                tskRouteIdList.add(rfpRout.id);
                tskRouteList.add(rfpRout);
            }else if(rfpRout.Task_Status__c == 'Pause' && oldRFPRout.Task_Status__c != rfpRout.Task_Status__c){
                Task_Pause_Details__c tskPauseDet = new Task_Pause_Details__c();
                tskPauseDet.Pause_Start_Date__c = system.now();
                tskPauseDet.Pause_Reason__c = rfpRout.Pause_Reason__c;
                tskPauseDet.Related_Task__c = rfpRout.id;
                tskPauseDetList.add(tskPauseDet);
            }
        }
        if(!tskPauseDetList.isEmpty()){
            insert tskPauseDetList;
        }
        
        List<Task_Pause_Details__c> tskRouteDetList;
        List<Task_Pause_Details__c> tskRouteDetListToUpd = new List<Task_Pause_Details__c>();
        if(!tskRouteIdList.isEmpty()){
            tskRouteDetList = [SELECT id, Name, Pause_Start_Date__c, Pause_End_Date__c, Related_Task__c from Task_Pause_Details__c WHERE Related_Task__c IN :tskRouteIdList ORDER BY CreatedDate desc];
        }
        
        if(!tskRouteList.isEmpty()){
            for(RFQ_Tasks_Routing__c taskRout: tskRouteList){
                if(tskRouteDetList != null){
                    for(Task_Pause_Details__c tskRouteDet : tskRouteDetList){
                        if(tskRouteDet.Related_Task__c == taskRout.id){
                            tskRouteDet.Pause_End_Date__c = System.now();
                            tskRouteDetListToUpd.add(tskRouteDet);
                            break;
                        }
                    }
                }
            }
        }
 
        if(!tskRouteDetListToUpd.isEmpty()){
            update tskRouteDetListToUpd;
        }
        
        //*************************************
        
        List<RFQ_Tasks_Routing__c> rfqTaskToUpdateList = [Select Id, Name, Predecessor_Task__c, Start_Date__c, Add_Offset_Days__c, Task_Due_Date_and_Time__c, Negotiation_Date1__c, Complete__c, Calculate_due_date_based_on_new__c from RFQ_Tasks_Routing__c WHERE Predecessor_Task__c IN :trigger.new and Complete__c = false]; // and Complete__c = false
        List<RFQ_Tasks_Routing__c> rfqTaskToUpdate1 = new List<RFQ_Tasks_Routing__c>();
        for(RFQ_Tasks_Routing__c taskRout:  (List<RFQ_Tasks_Routing__c>)trigger.new){
            RFQ_Tasks_Routing__c oldRFPRout = triggerOldMap.get(taskRout.Id);
            if(!rfqTaskToUpdateList.isEmpty()){
                for(RFQ_Tasks_Routing__c taskRoutToUpdt: rfqTaskToUpdateList){
                    if(taskRout.id == taskRoutToUpdt.Predecessor_Task__c){
                        if(taskRout.Actual_End_Date__c != oldRFPRout.Actual_End_Date__c){
                            taskRoutToUpdt.Start_Date__c = taskRout.Actual_End_Date__c;
                            if(taskRoutToUpdt.Start_Date__c != null && taskRoutToUpdt.Add_Offset_Days__c != null && taskRoutToUpdt.Add_Offset_Days__c != ''){
                                Integer duration = integer.ValueOf(taskRoutToUpdt.Add_Offset_Days__c);
                                taskRoutToUpdt.Task_Due_Date_and_Time__c = taskRoutToUpdt.Start_Date__c.addDays(duration);
                            }else{
                                taskRoutToUpdt.Task_Due_Date_and_Time__c = null;
                            }
                            rfqTaskToUpdate.add(taskRoutToUpdt);
                        }
                    }
                }
                
            }
        }
       
        //*************************************
        
        
        //--------------------------------
        if(BNPStopRecurssion.runOnce())
        {
            Map<Id, List<String>> rfqTaskRoutIdTaskassigneeMap = new Map<Id, List<String>>();
            List<RFQ_Tasks_Routing__c> rfqTaskRouteToEmailList = new List<RFQ_Tasks_Routing__c>();
            List<RFQ_Tasks_Routing__c> rfqTaskRouteToEmailNewList = new List<RFQ_Tasks_Routing__c>();
            //Set<RFQ_Tasks_Routing__c> rfqTaskRouteToEmailUniqueList = new Set<RFQ_Tasks_Routing__c>();
            List<RFQ_Task_Assignee__c> rfqTaskAssigneeList = new List<RFQ_Task_Assignee__c>();
            system.debug('1st List :' +rfqRouteToEmailList.size());
            system.debug('rfqRouteToEmailList :' +rfqRouteToEmailList);
            
            system.debug('rfqRouteTaskOrderList :' +rfqRouteTaskOrderList);
            system.debug('Order List1 :' +rfqRouteTaskOrderList.size());
            
            if(!rfqRouteToEmailList.isEmpty()){
                rfqTaskRouteToEmailList = [Select Id, Name, Predecessor_Task__c, Predecessor_Task__r.Name, Start_Date__c, Add_Offset_Days__c, End_Date__c, Task_Due_Date_and_Time__c, order__c, Negotiation_Date1__c, Complete__c, Calculate_due_date_based_on_new__c, Action__c, Related_RFQ_Routing__c from RFQ_Tasks_Routing__c WHERE Related_RFQ_Routing__c IN :rfqRouteList AND (Predecessor_Task__c IN :rfqRouteToEmailList OR Order_New__c IN :rfqRouteTaskOrderList)];
                //rfqTaskRouteToEmailList = [Select Id, Name, Predecessor_Task__c, Predecessor_Task__r.Name, Start_Date__c, Add_Offset_Days__c, End_Date__c, Task_Due_Date_and_Time__c, order__c, Negotiation_Date1__c, Complete__c, Calculate_due_date_based_on_new__c, Action__c, Related_RFQ_Routing__c from RFQ_Tasks_Routing__c WHERE Related_RFQ_Routing__c IN :rfqRouteList AND Predecessor_Task__c IN :rfqRouteToEmailList];
                /*if(!rfqRouteTaskOrderList.isEmpty()){
                    rfqTaskRouteToEmailNewList = [Select Id, Name, Predecessor_Task__c, Predecessor_Task__r.Name, Start_Date__c, Add_Offset_Days__c, End_Date__c, Task_Due_Date_and_Time__c, order__c, Negotiation_Date1__c, Complete__c, Calculate_due_date_based_on_new__c, Action__c, Order_New__c, Related_RFQ_Routing__c from RFQ_Tasks_Routing__c WHERE Order_New__c IN :rfqRouteTaskOrderList and Related_RFQ_Routing__c IN :rfqRouteList];
                }*/
            }
            system.debug('rfqTaskRouteToEmailList List :' +rfqTaskRouteToEmailList);
            system.debug('2nd List :' +rfqTaskRouteToEmailList.size());
            
            //system.debug('rfqTaskRouteToEmailNewList List :' +rfqTaskRouteToEmailNewList);
            //system.debug('Order List2 :' +rfqTaskRouteToEmailNewList.size());
            
            Set<Id> rfqTskRouteToEmailList = new Set<Id>();
            if(!rfqTaskRouteToEmailList.isEmpty()){
                for(RFQ_Tasks_Routing__c rfqTaskRouteToEmail: rfqTaskRouteToEmailList){
                    rfqTskRouteToEmailList.add(rfqTaskRouteToEmail.id);
                    //rfqTaskRouteToEmailUniqueList.add(rfqTaskRouteToEmail);
                }
            }
            /*if(!rfqTaskRouteToEmailNewList.isEmpty()){
                for(RFQ_Tasks_Routing__c rfqTaskRouteToEmailNew: rfqTaskRouteToEmailNewList){
                    rfqTskRouteToEmailList.add(rfqTaskRouteToEmailNew.id);
                    rfqTaskRouteToEmailUniqueList.add(rfqTaskRouteToEmailNew);
                }
            }*/
            
            system.debug('3rd List :' +rfqTskRouteToEmailList);
            system.debug('3rd List :' +rfqTskRouteToEmailList.size());
            if(!rfqTskRouteToEmailList.isEmpty()){
                rfqTaskAssigneeList = [Select id,name,RFQ_Task_Routing__c,Task_Assignee_Email__c,User__c,User__r.Email,Notify__c from RFQ_Task_Assignee__c where RFQ_Task_Routing__c IN: rfqTskRouteToEmailList];
            }
            system.debug('4th List :' +rfqTaskAssigneeList.size());
            
            //system.debug('rfqTaskRouteToEmailUniqueList List :' +rfqTaskRouteToEmailUniqueList);
            //system.debug('rfqTaskRouteToEmailUniqueList List Size :' +rfqTaskRouteToEmailUniqueList.size());
            
            system.debug('rfqRouteToEmailObjList List Size :' +rfqRouteToEmailObjList.size());
            system.debug('rfqRouteToEmailObjList List :' +rfqRouteToEmailObjList);
            if(!rfqRouteToEmailObjList.isEmpty()){
                for(RFQ_Tasks_Routing__c taskRoutNew : rfqRouteToEmailObjList){
                    if(!rfqTaskRouteToEmailList.isEmpty()){
                        for(RFQ_Tasks_Routing__c taskRout : rfqTaskRouteToEmailList){
                            //if(taskRoutNew.id == taskRout.Predecessor_Task__c){
                            if(taskRoutNew.Related_RFQ_Routing__c == taskRout.Related_RFQ_Routing__c){
                                for(RFQ_Task_Assignee__c rfqTaskAssign : rfqTaskAssigneeList){  
                                    List<String> usrEmailList = new List<String>();
                                    if(taskRout.id == rfqTaskAssign.RFQ_Task_Routing__c){
                                        if(rfqTaskAssign.Task_Assignee_Email__c != null && rfqTaskAssign.Task_Assignee_Email__c != ''){
                                            for( String usrEmail : rfqTaskAssign.Task_Assignee_Email__c.split(',')){
                                                usrEmailList.add(usrEmail);
                                            }
                                        }
                                        system.debug('5th List :' +usrEmailList.size());
                                        for(String userEmail : usrEmailList){
                                            if(rfqTaskRoutIdTaskassigneeMap.containsKey(taskRout.id)){
                                                rfqTaskRoutIdTaskassigneeMap.get(taskRout.id).add(userEmail);
                                            }else{
                                                rfqTaskRoutIdTaskassigneeMap.put(taskRout.id, new List <String> {
                                                                userEmail
                                                });
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            system.debug('1st Map :' +rfqTaskRoutIdTaskassigneeMap);
            List<Messaging.SingleEmailMessage> newMails = new List<Messaging.SingleEmailMessage>();
            for(RFQ_Tasks_Routing__c taskRout : rfqTaskRouteToEmailList){
                List<String> taskassigneeEmailListToNotify = new List<String>();
                Messaging.SingleEmailMessage singleMail = new Messaging.SingleEmailMessage();
                List<String> taskassigneeEmailList = rfqTaskRoutIdTaskassigneeMap.get(taskRout.id);
                if(taskassigneeEmailList != null){
                    for(String taskAssEmail : taskassigneeEmailList){
                        taskassigneeEmailListToNotify.add(taskAssEmail);
                    }
                }
                if(taskassigneeEmailListToNotify != null && taskassigneeEmailListToNotify.size() > 0){
                    System.debug('User to notify:' +taskassigneeEmailListToNotify);
                    singleMail.setToAddresses(taskassigneeEmailListToNotify);
                    //singleMail.setSubject( +taskRout.Predecessor_Task__r.Name+' is completed you can start Task ' +taskRout.Name);
                    singleMail.setSubject( ' Dependent task or previous order task is completed you can start Task ' +taskRout.Name);
                    String body = 'Task Name :' +taskRout.Name;
                    body+= '<br/>';
                    String startDate = '';
                    if(taskRout.Start_date__c != null){
                        Datetime startDateTime = Datetime.newInstance(taskRout.Start_date__c.year(), taskRout.Start_date__c.month(), taskRout.Start_date__c.day());
                        startDate = startDateTime.format('dd/MMM/yyyy');
                    }
                    body+= 'Task Start Date :' +startDate;
                    body+= '<br/>';
                    String endDate = '';
                    if(taskRout.End_Date__c != null){
                        Datetime endDateTime = Datetime.newInstance(taskRout.End_Date__c.year(), taskRout.End_Date__c.month(), taskRout.End_Date__c.day());
                        endDate = endDateTime.format('dd/MMM/yyyy');
                    }
                    body+= 'Task End Date :' +endDate;
                    body+= '<br/>';
                    String dueDate = '';
                    if(taskRout.Task_Due_Date_and_Time__c != null){
                        Datetime dueDateTime = Datetime.newInstance(taskRout.Task_Due_Date_and_Time__c.year(), taskRout.Task_Due_Date_and_Time__c.month(), taskRout.Task_Due_Date_and_Time__c.day());
                        dueDate = dueDateTime.format('dd/MMM/yyyy');
                    }
                    body+= 'Task Due Date and Time :' +dueDate;
                    body+= '<br/>';
                    body+= 'Order :' +taskRout.order__c;
                    body+= '<br/>';
                    body+= 'Duration :' +taskRout.Add_Offset_Days__c;
                    body+= '<br/>';
                    body+= 'Action :' +taskRout.Action__c;
                    body += '<br/>';
                    body += '<br/>';
                    String hyperLink = URL.getSalesforceBaseUrl().toExternalForm()+'/'+taskRout.id;
                    body += '<a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+taskRout.id+'">'+hyperLink+'</a>';
                    singleMail.setHtmlBody(body);
                    newMails.add(singleMail);
                }
            }
            if(!newMails.isEmpty()){
                System.debug('Mail send to user:' +newMails);
                System.debug('Mail send to user List:' +newMails.size());
                try{
                    Messaging.sendEmail(newMails);
                }catch(Exception excp){
                    GlobalUtility.logMessage('Error','BNPStartRoutingTaskCtrl','BNPStartRoutingTask','','Exception while sending notification to Task Assignee and Request Catcher',String.valueof(excp.getMessage()),'','BnP',excp,0);
                }
            }
        }
        //---------------------------------

        if(rfqTaskToUpdate.size() > 0){
            try{
                update rfqTaskToUpdate;
            }catch(DmlException excp){
                for (Integer i = 0; i < excp.getNumDml(); i++) {
                    system.debug('Error Msg:' +excp.getDmlMessage(i));
                    Trigger.new[0].addError(excp.getDmlMessage(i));
                    //Trigger.new[0].addError('Updating "Start Date" or "Duration" is impacting dependent task Due Date. "Task Due Date and Time" cannot be greater than "Negotiation date" or "Customer Response Date".');
                }
            }
            
        }
    }
}