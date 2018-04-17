/*************************************************************************************************************************************************************
@ Class:          RoutingTriggerHelper
@ Version:        1.0
@ Author:         Poulami Saha
@ Purpose:        Helper class which consist of logics used in Request Information Trigger.
--------------------------------------------------------------------------------------------------------------------------------------------------------------
@ Change history: 16.12.2016 / Poulami Saha / Created the class.
**************************************************************************************************************************************************************/
Public Class RoutingTriggerHelper{
    public Map<Id,RFQ_Routing__c> triggerOldMap { get; set; }

    /*********************************************************************************************************************************************************
    @ Constructor:    RoutingTriggerHelper
    @ Version:        1.0
    @ Author:         Poulami Saha
    @ Purpose:        Initialises the class for controller instance.
    **********************************************************************************************************************************************************/     
    public RoutingTriggerHelper(){      
        triggerOldMap = ((Map<Id,RFQ_Routing__c>)Trigger.oldMap);
    }
    
    /**
    *  The Purpose of this method is to check 'Status' validation when set to 'Complete'. Set Task Status "Pause" if Route status is "Pause".  Set Task Status "In Progress" if Route status is "Restart".
    *  @name <beforeInsertUpdMethod>
    *  @param <NA> 
    *  @return <Void>
    *  @throws exception-<exception description>
    */
    public void beforeInsertUpdMethod() {
        List<RFQ_Tasks_Routing__c> taskUpDtLst=[select id,task_status__c, Related_RFQ_Routing__c from RFQ_Tasks_Routing__c where Related_RFQ_Routing__c in:trigger.new];
        List<RFQ_Tasks_Routing__c> rfqTaskToUpdateList = new List<RFQ_Tasks_Routing__c>();
        
        
        for(RFQ_Routing__c rfqRoute : (List<RFQ_Routing__c>)trigger.new){
            if(taskUpDtLst.size() > 0){
                    for(RFQ_Tasks_Routing__c task:taskUpDtLst){
                        if(task.Related_RFQ_Routing__c == rfqRoute.id){
                            if(rfqRoute.Status__c == 'Complete' && task.Task_Status__c != 'Complete'){
                                rfqRoute.addError('Status can be set to Complete once all task status is complete');
                            }else if(rfqRoute.Status__c =='Complete'){
                                if(Trigger.isInsert){
                                    rfqRoute.End_Date__c = System.now();
                                }
                                if(Trigger.isUpdate){
                                    RFQ_Routing__c oldRFPRout = triggerOldMap.get(rfqRoute.Id);
                                    if(oldRFPRout.Status__c <> rfqRoute.Status__c){
                                        rfqRoute.End_Date__c = System.now();
                                    }
                                }
                            }
                            if(Trigger.isInsert){
                                if(rfqRoute.Status__c =='Pause' && task.task_status__c == 'InProgress'){
                                    task.task_status__c = 'Pause';
                                    task.Pause_Reason__c = 'Route Pause';
                                    rfqTaskToUpdateList.add(task);
                                }else if(rfqRoute.Status__c =='Restart' && task.task_status__c == 'Pause'){
                                    System.debug('Inside Restart loop');
                                    task.task_status__c ='InProgress';
                                    rfqTaskToUpdateList.add(task);
                                }
                            }
                            if(Trigger.isUpdate){
                                RFQ_Routing__c oldRFPRout = triggerOldMap.get(rfqRoute.Id);
                                if(rfqRoute.Status__c =='Pause' && oldRFPRout.Status__c <> rfqRoute.Status__c && task.task_status__c == 'InProgress'){
                                    task.task_status__c = 'Pause';
                                    task.Pause_Reason__c = 'Route Pause';
                                    rfqTaskToUpdateList.add(task);
                                }else if(rfqRoute.Status__c =='Restart' && oldRFPRout.Status__c <> rfqRoute.Status__c && task.task_status__c == 'Pause'){
                                    System.debug('Inside Restart loop');
                                    task.task_status__c ='InProgress';
                                    rfqTaskToUpdateList.add(task);
                                }
                            }
                        }
                    }
            }else if(rfqRoute.Status__c == 'Complete'){
                rfqRoute.addError('Status can be set to Complete once all task status is complete');
            }
            
                if(Trigger.isInsert){
                    if(rfqRoute.Status__c =='Cancel'){
                        rfqRoute.End_Date__c = System.now();
                    }
                    if(rfqRoute.Status__c =='Pause'){
                        rfqRoute.Pause_Start_Date__c = System.now();
                        rfqRoute.Is_Paused__c = true;
                    }
                }
                if(Trigger.isUpdate){
                    RFQ_Routing__c oldRFPRout = triggerOldMap.get(rfqRoute.Id);
                    if(oldRFPRout.Status__c <> rfqRoute.Status__c && rfqRoute.Status__c =='Cancel'){
                        rfqRoute.End_Date__c = System.now();
                    }
                    if(oldRFPRout.Status__c <> rfqRoute.Status__c && rfqRoute.Status__c =='Pause'){
                        rfqRoute.Pause_Start_Date__c = System.now();
                        rfqRoute.Is_Paused__c = true;
                    }else if(oldRFPRout.Status__c <> rfqRoute.Status__c && oldRFPRout.Status__c =='Pause' && rfqRoute.Is_Paused__c == true){
                        rfqRoute.Is_Paused__c = false;
                    }
                }
            
        }

        if (!rfqTaskToUpdateList.isEmpty()){
            update rfqTaskToUpdateList;
        }
    }
    
    public void afterInsertUpdMethod() {
        boolean firequery = false;
        decimal totalRouteWithPause = 0;
        decimal totalRouteWithoutPause = 0;
        decimal totalTaskWithPause = 0;
        decimal totalTaskWithoutPause = 0;
        List<RFQ_Routing__c> routecompList = new List<RFQ_Routing__c>();
        List<Request_Information__c> rfqList = new List<Request_Information__c>();
        Map<id,decimal> rfqTotalRouteWithPauseMap = new Map<id,decimal>();
        Map<id,decimal> rfqTotalRouteWithoutPauseMap = new Map<id,decimal>();
        Map<id,decimal> rfqTotalTaskWithPauseMap = new Map<id,decimal>();
        Map<id,decimal> rfqTotalTaskWithoutPauseMap = new Map<id,decimal>();
        List<Request_Information__c> rfqToUpdList = new List<Request_Information__c>();
        List<Id> rfqNewList = new List<Id>();
        for(RFQ_Routing__c rfqRoute: (List<RFQ_Routing__c>)trigger.new){
            if(rfqRoute.Status__c == 'Cancel' || rfqRoute.Status__c == 'Complete'){
                firequery = true;
                rfqNewList.add(rfqRoute.RFQ__c);
            }
        }
        if(firequery){
            routecompList = [SELECT id, Route_Duration__c, Total_Route_Duration_without_Pause__c, Total_Close_Tasks_Duration_with_Pause__c, Total_Close_Tasks_Duration_without_Pause__c, RFQ__c from RFQ_Routing__c where RFQ__c IN: rfqNewList AND (Status__c = 'Cancel' OR Status__c = 'Complete')];  
            rfqList = [SELECT id, Total_Close_Route_Duration_without_Pause__c, Total_Close_Route_Duration_with_Pause__c, Total_Close_Task_Duration_with_Pause__c, Total_Close_Task_Duration_without_Pause__c from Request_Information__c where id IN: rfqNewList];
        }
        if(!routecompList.isEmpty()){
            for(RFQ_Routing__c rfqRoute: (List<RFQ_Routing__c>)trigger.new){
                totalRouteWithPause = 0;
                totalRouteWithoutPause = 0;
                totalTaskWithPause=0;
                totalTaskWithoutPause=0;
                for(RFQ_Routing__c routecomp : routecompList){
                    if(rfqRoute.RFQ__c == routecomp.RFQ__c){
                        system.debug('***********totalRouteWithPause  1***********' +totalRouteWithPause);
                        if(routecomp.Route_Duration__c != null){
                            totalRouteWithPause += routecomp.Route_Duration__c;
                        }
                        system.debug('***********totalRouteWithPause  2***********' +totalRouteWithPause);
                        system.debug('***********totalRouteWithoutPause  1***********' +totalRouteWithoutPause);
                        if(routecomp.Total_Route_Duration_without_Pause__c != null){
                            totalRouteWithoutPause += routecomp.Total_Route_Duration_without_Pause__c;
                        }
                        system.debug('***********totalRouteWithoutPause  2***********' +totalRouteWithoutPause);
                        if(routecomp.Total_Close_Tasks_Duration_with_Pause__c != null){
                            totalTaskWithPause += routecomp.Total_Close_Tasks_Duration_with_Pause__c;
                        }
                        if(routecomp.Total_Close_Tasks_Duration_without_Pause__c != null){
                            totalTaskWithoutPause += routecomp.Total_Close_Tasks_Duration_without_Pause__c;
                        }
                        
                        rfqTotalRouteWithPauseMap.put(routecomp.RFQ__c,totalRouteWithPause);
                        rfqTotalRouteWithoutPauseMap.put(routecomp.RFQ__c,totalRouteWithoutPause);
                        
                        rfqTotalTaskWithPauseMap.put(routecomp.RFQ__c,totalTaskWithPause);
                        rfqTotalTaskWithoutPauseMap.put(routecomp.RFQ__c,totalTaskWithoutPause);
                        
                    }
                }
            }
        }
        if(!rfqList.isEmpty()){
            for(Request_Information__c rfq : rfqList){
                system.debug('***********totalRouteWithPause  3***********' +rfqTotalRouteWithPauseMap.get(rfq.id));
                system.debug('***********totalRouteWithoutPause  3***********' +rfqTotalRouteWithoutPauseMap.get(rfq.id));
                rfq.Total_Close_Route_Duration_with_Pause__c = rfqTotalRouteWithPauseMap.get(rfq.id);
                rfq.Total_Close_Route_Duration_without_Pause__c = rfqTotalRouteWithoutPauseMap.get(rfq.id);
                
                rfq.Total_Close_Task_Duration_with_Pause__c = rfqTotalTaskWithPauseMap.get(rfq.id);
                rfq.Total_Close_Task_Duration_without_Pause__c = rfqTotalTaskWithoutPauseMap.get(rfq.id);
                rfqToUpdList.add(rfq);
            }

        }
        
        if(!rfqToUpdList.isEmpty()){
            //if(BNPStopRecurssion.runOnce())
            //{
                update rfqToUpdList;
            //}
        }
    }
    
    /**
    *  The Purpose of this method is to create route pause detail information if route status is set to pause.
    *  @name <afterInsertMethod>
    *  @param <NA> 
    *  @return <Void>
    *  @throws exception-<exception description>
    */
    public void afterInsertMethod() {
        List<Route_Pause_Details__c> routePauseDetList = new List<Route_Pause_Details__c>();
        for(RFQ_Routing__c rfqRoute : (List<RFQ_Routing__c>)trigger.new){
            if(rfqRoute.Status__c == 'Pause'){
                    Route_Pause_Details__c routePauseDet = new Route_Pause_Details__c();
                    routePauseDet.Pause_Start_Date__c = system.now();
                    routePauseDet.Pause_Reason__c = rfqRoute.Pause_Reason__c;
                    routePauseDet.Related_Route__c = rfqRoute.id;
                    routePauseDetList.add(routePauseDet);
                }
        }
        if(!routePauseDetList.isEmpty()){
            insert routePauseDetList;
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
        Map<Id, RFQ_Routing__c> rfqRouteMap = new Map<Id, RFQ_Routing__c>();
        rfqRouteMap.putAll([SELECT id,RFQ__c,CreatedDate,LastModifiedDate,RFQ__r.Quote_Status__c,Status__c FROM RFQ_Routing__c WHERE Id IN: trigger.new]);
        for(RFQ_Routing__c rfqRoute : (List<RFQ_Routing__c>)trigger.new){
            
            if(!BNPStopTrigger.bypassTriggerLogic){
                if((rfqRouteMap.get(rfqRoute.Id).LastModifiedDate.minute() - rfqRouteMap.get(rfqRoute.Id).CreatedDate.minute()) >= 0.1 && rfqRouteMap.get(rfqRoute.Id).RFQ__c != null && rfqRouteMap.get(rfqRoute.Id).RFQ__r.Quote_Status__c == 'Accept'){// && rfqRoute.Skip_Validation__c == false
                    rfqRoute.addError('Record locked as related RFQ/RFI Quote Status is \'Accept\'.');
                }
            }

            RFQ_Routing__c oldRFPRout = triggerOldMap.get(rfqRoute.Id);
            if(oldRFPRout.Status__c == 'Pause' && oldRFPRout.Status__c != rfqRoute.Status__c){
                rfqRoute.Pause_Reason__c = '';
            }
        }
    }
    
     /**
    *  The Purpose of this method is to Update 'Calculate due date based on' field.
    *  @name <afterUpdateMethod>
    *  @param <NA> 
    *  @return <Void>
    *  @throws exception-<exception description>
    */
    public void afterUpdateMethod(){
        map<id,list<RFQ_Tasks_Routing__c>> taskRouteMap = new map<id,list<RFQ_Tasks_Routing__c>>();
        List<RFQ_Tasks_Routing__c> tskRouteToUpdate = new List<RFQ_Tasks_Routing__c>();
        
        list<RFQ_Tasks_Routing__c> tskRouteList = [select Id, Related_RFQ_Routing__c,  Related_RFQ_Routing__r.Id, Related_RFQ_Routing__r.Calculate_due_date_based_on__c 
                                                    FROM RFQ_Tasks_Routing__c WHERE Related_RFQ_Routing__r.Id IN :Trigger.newMap.keySet() and Complete__c = false];
        for(RFQ_Tasks_Routing__c tskRoute : tskRouteList){
            System.debug('@TskRouting List ID: ' + tskRoute.Id);
            if(taskRouteMap.get(tskRoute.Related_RFQ_Routing__c)!=null){
                list<RFQ_Tasks_Routing__c> temp = taskRouteMap.get(tskRoute.Related_RFQ_Routing__c);
                temp.add(tskRoute);
                taskRouteMap.put(tskRoute.Related_RFQ_Routing__c,temp);
            }
            else{
                taskRouteMap.put(tskRoute.Related_RFQ_Routing__c,new list<RFQ_Tasks_Routing__c>{tskRoute});
            }
        }
        
        List<String> routeIdList = new List<String>();
        List<RFQ_Routing__c> routeList = new List<RFQ_Routing__c>();
        List<Route_Pause_Details__c> routePauseDetList = new List<Route_Pause_Details__c>();
        for(RFQ_Routing__c rfqRoute : (List<RFQ_Routing__c>)trigger.new){
            if(rfqRoute.Calculate_due_date_based_on__c != triggerOldMap.get(rfqRoute.id).Calculate_due_date_based_on__c){
                list<RFQ_Tasks_Routing__c> tskRoutinglist = taskRouteMap.get(rfqRoute.id);
                if(tskRoutinglist != null && tskRoutinglist.size() > 0){
                    for(RFQ_Tasks_Routing__c tskRoute : tskRoutinglist){ 
                            tskRoute.Calculate_due_date_based_on__c = rfqRoute.Calculate_due_date_based_on__c;
                            tskRoute.Skip_Validation__c = true;
                            tskRouteToUpdate.add(tskRoute);
                    }
                }
            }
            
            RFQ_Routing__c oldRFPRout = triggerOldMap.get(rfqRoute.Id);
            if(oldRFPRout.Status__c == 'Pause' && oldRFPRout.Status__c != rfqRoute.Status__c){
                //rfqRoute.Pause_Reason__c = '';
                routeIdList.add(rfqRoute.id);
                routeList.add(rfqRoute);
            }else if(rfqRoute.Status__c == 'Pause' && oldRFPRout.Status__c != rfqRoute.Status__c){
                Route_Pause_Details__c routePauseDet = new Route_Pause_Details__c();
                routePauseDet.Pause_Start_Date__c = system.now();
                routePauseDet.Pause_Reason__c = rfqRoute.Pause_Reason__c;
                routePauseDet.Related_Route__c = rfqRoute.id;
                routePauseDetList.add(routePauseDet);
            }
        }
        
        if(!routePauseDetList.isEmpty()){
            insert routePauseDetList;
        }
        
        List<Route_Pause_Details__c> routeDetList;
        List<Route_Pause_Details__c> routeDetListToUpd = new List<Route_Pause_Details__c>();
        if(!routeIdList.isEmpty()){
            routeDetList = [SELECT id, Name, Pause_Start_Date__c, Pause_End_Date__c, Related_Route__c from Route_Pause_Details__c WHERE Related_Route__c IN :routeIdList ORDER BY CreatedDate desc];
        }
        
        if(!routeList.isEmpty()){
            for(RFQ_Routing__c route: routeList){
                if(routeDetList != null){
                    for(Route_Pause_Details__c routeDet : routeDetList){
                        if(routeDet.Related_Route__c == route.id){
                            routeDet.Pause_End_Date__c = System.now();
                            routeDetListToUpd.add(routeDet);
                            break;
                        }
                    }
                }
            }
        }
 
        if(!routeDetListToUpd.isEmpty()){
            update routeDetListToUpd;
        }
        
        if(!tskRouteToUpdate.isEmpty()){
            try{
             update tskRouteToUpdate;
            }catch(DmlException excp){
                for (Integer i = 0; i < excp.getNumDml(); i++) {
                    Trigger.new[0].addError(excp.getDmlMessage(i));
                    //Trigger.new[0].addError('Updating "Calculate due date based on" is impacting the dependent task.');
                }
            }
        }
    }
}