/*
Type Name: BNPCreateRouteFromTemplateCtrl
Author: Poulami Saha
Project Name: DIW Step Down Track 2 (BnP) 
Created Date: 03/06/2017
Description: This class is call from 'Create Route' button to create Route from Template.
Test Class: BNPCreateRouteFromTemplateCtrlTest
Change History: 05/11/2017 - Added task assignee copy functionality
*/
Global class BNPCreateRouteFromTemplateCtrl{
    public static Request_Information__c reqInfoRec {get; set;}
    public static Route_Template__c routeTemplateRec {get; set;}
    public static List<Task_Template__c> taskTemplateRec {get; set;}

     /**
    *  The Purpose of this method is to clone RFQ.
    *  @name <BNPCreateRouteFromTemplate>
    *  @param <String> 
    *  @return <String>
    *  @throws exception-<GlobalUtility.logMessage was called to capture the exception>
    */
    //@future
    WebService static String BNPCreateRouteFromTemplate(String routeTemplateId, String reqId){
    //WebService static Void BNPCreateRouteFromTemplate(String routeTemplateId, String reqId){
        //string reqInfoId = ApexPages.currentPage().getParameters().get('reqId');
        string reqInfoQuery = 'SELECT id, Name, Negotiation_Date__c, Date_customer_wants_response__c FROM Request_Information__c';
        string routeTemplateQuery = 'SELECT id, Name, Route_Name__c, Calculate_due_date_based_on__c, Route_Base_Purpose__c, Status__c, Description__c, Auto_Stop_on_Rejection__c FROM Route_Template__c';
        string taskTemplateQuery = 'SELECT id, Action_Type__c, Duration__c, Order__c, Request_Catcher__c, Predecessor_Task_Order__c, Route_Template__c, Start_Date_Diff_Customer_Response_Date__c, Start_Date_Diff_Negotiation_Date__c, Due_Date_Diff_Customer_Response_Date__c, Due_Date_Diff_Negotiation_Date__c, Task_Assignee__c, Task_Name__c, Task_Type__c FROM Task_Template__c';
        reqInfoRec = (Request_Information__c)Database.query(reqInfoQuery + ' WHERE Id =: reqId limit 1');
        routeTemplateRec = (Route_Template__c)Database.query(routeTemplateQuery + ' WHERE Id =: routeTemplateId limit 1');
        taskTemplateRec=Database.query(taskTemplateQuery+' where Route_Template__c = :routeTemplateId Order By Order__c ASC');
        Map<Id, List<Task_Assignee_Template__c>> rfqTaskTempIdTaskassigneeMap = new Map<Id, List<Task_Assignee_Template__c>>();
        List<Id> rfqTaskTempIdList = new List<Id>();
        
        
        Savepoint preSave = Database.setSavepoint(); //set savepoint so we can rollback the whole save if there are errors
        try{ 
            RFQ_Routing__c route = new RFQ_Routing__c();
            route.Calculate_due_date_based_on__c = routeTemplateRec.Calculate_due_date_based_on__c;
            route.Route_Base_Purpose__c = routeTemplateRec.Route_Base_Purpose__c;
            route.Name = routeTemplateRec.Route_Name__c;
            route.Status__c = routeTemplateRec.Status__c;
            route.RFQ__c = reqId;
            route.Auto_Stop_on_Rejection__c = routeTemplateRec.Auto_Stop_on_Rejection__c;
            route.Description__c = routeTemplateRec.Description__c;
            Database.SaveResult routeResult = Database.insert(route, false);
            
            /*****05/11/2017 - Added task assignee copy functionality Starts*****/           
            for(Task_Template__c taskTemp : taskTemplateRec){
                rfqTaskTempIdList.add(taskTemp.id);
            }
            /*****05/11/2017 - Added task assignee copy functionality Ends*****/        
            
            for(Task_Template__c taskTemp : taskTemplateRec){
                RFQ_Tasks_Routing__c taskRoute = new RFQ_Tasks_Routing__c();
                taskRoute.Related_RFQ_Routing__c = route.id;
                taskRoute.Select_Task_Name__c = taskTemp.Task_Name__c;
                taskRoute.Task_Name__c = taskTemp.Task_Type__c;
                taskRoute.Action__c = taskTemp.Action_Type__c;
                taskRoute.Add_Offset_Days__c = String.valueof(taskTemp.Duration__c);
                if(routeTemplateRec.Calculate_due_date_based_on__c == 'Negotiation date'){
                    if(reqInfoRec.Negotiation_Date__c != null){
                        if(taskTemp.Start_Date_Diff_Negotiation_Date__c != null && taskTemp.Start_Date_Diff_Negotiation_Date__c != 0){
                            Integer startDateDiffNego = integer.ValueOf(taskTemp.Start_Date_Diff_Negotiation_Date__c);
                            taskRoute.Start_Date__c = reqInfoRec.Negotiation_Date__c.date().addDays(-startDateDiffNego);
                        }
                        if(taskTemp.Due_Date_Diff_Negotiation_Date__c != null && taskTemp.Due_Date_Diff_Negotiation_Date__c != 0){
                            Integer dueDateDiffNego = integer.ValueOf(taskTemp.Due_Date_Diff_Negotiation_Date__c);
                            taskRoute.Task_Due_Date_and_Time__c = reqInfoRec.Negotiation_Date__c.date().addDays(-dueDateDiffNego);
                        }
                    }
                }
                if(routeTemplateRec.Calculate_due_date_based_on__c == 'Customer response date'){
                    if(reqInfoRec.Date_customer_wants_response__c != null){
                        if(taskTemp.Start_Date_Diff_Customer_Response_Date__c != null && taskTemp.Start_Date_Diff_Customer_Response_Date__c != 0){
                            Integer startDateDiffCus = integer.ValueOf(taskTemp.Start_Date_Diff_Customer_Response_Date__c);
                            taskRoute.Start_Date__c = reqInfoRec.Date_customer_wants_response__c.date().addDays(-startDateDiffCus);
                        }
                        if(taskTemp.Due_Date_Diff_Customer_Response_Date__c != null && taskTemp.Due_Date_Diff_Customer_Response_Date__c != 0){
                            Integer dueDateDiffCus = integer.ValueOf(taskTemp.Due_Date_Diff_Customer_Response_Date__c);
                            taskRoute.Task_Due_Date_and_Time__c = reqInfoRec.Date_customer_wants_response__c.date().addDays(-dueDateDiffCus);
                        }
                    }
                }
                if(taskTemp.Predecessor_Task_Order__c != null && taskTemp.Predecessor_Task_Order__c != 0){
                    RFQ_Tasks_Routing__c taskRoutePrecd = [SELECT id, Order__c from RFQ_Tasks_Routing__c where Order__c =: taskTemp.Predecessor_Task_Order__c and Related_RFQ_Routing__c =: route.id limit 1];
                    taskRoute.Predecessor_Task__c = taskRoutePrecd.id;
                }
                taskRoute.Order__c = taskTemp.Order__c;
                taskRoute.Task_Assignee__c = taskTemp.Task_Assignee__c;
                taskRoute.Request_Catcher__c = taskTemp.Request_Catcher__c;
                BNPStopTrigger.bypassTriggerLogic = true;
                Database.SaveResult taskRouteResult = Database.insert(taskRoute, false);
                
                /*****05/11/2017 - Added task assignee copy functionality Starts*****/
                for(Task_Assignee_Template__c rfqTaskAssignTemp : [Select Id,All_Task_Assignee_Id__c,Assignee_Type__c,Task_Assignee__c,Task_Assignee_Email__c,Task_Assignee_Id__c,Task_Template__c, Subscribe_Notification__c  from Task_Assignee_Template__c where Task_Template__c IN :rfqTaskTempIdList]){
                    if(taskTemp.id == rfqTaskAssignTemp.Task_Template__c){
                        if(rfqTaskTempIdTaskassigneeMap.containsKey(taskRoute.id)){
                            rfqTaskTempIdTaskassigneeMap.get(taskRoute.id).add(rfqTaskAssignTemp);
                        }else{
                                rfqTaskTempIdTaskassigneeMap.put(taskRoute.id, new List <Task_Assignee_Template__c> {
                                                rfqTaskAssignTemp
                                });
                        }
                    }
                }
                /*****05/11/2017 - Added task assignee copy functionality Ends*****/
            }
            
            /*****05/11/2017 - Added task assignee copy functionality Starts*****/
            List<RFQ_Task_Assignee__c> tskAssigneeList = new List<RFQ_Task_Assignee__c>();
            for(RFQ_Tasks_Routing__c tskRoute : [Select id from RFQ_Tasks_Routing__c where Related_RFQ_Routing__c = :route.id]){
                List<Task_Assignee_Template__c> tskAssigneeTempList = rfqTaskTempIdTaskassigneeMap.get(tskRoute.id);
                if(tskAssigneeTempList != null){
                    for(Task_Assignee_Template__c taskAssTemp : tskAssigneeTempList){
                        RFQ_Task_Assignee__c tskAss = new RFQ_Task_Assignee__c();
                        tskAss.User_Type__c = taskAssTemp.Assignee_Type__c;
                        tskAss.All_Task_Assignee_Id__c = taskAssTemp.All_Task_Assignee_Id__c;
                        tskAss.Task_Assignee__c = taskAssTemp.Task_Assignee__c;
                        tskAss.Task_Assignee_Email__c = taskAssTemp.Task_Assignee_Email__c;
                        tskAss.Task_Assignee_Id__c = taskAssTemp.Task_Assignee_Id__c;
                        tskAss.Notify__c = taskAssTemp.Subscribe_Notification__c;
                        tskAss.RFQ_Task_Routing__c = tskRoute.id;
                        tskAssigneeList.add(tskAss);
                        
                    }
                }
            }
            BNPStopTrigger.bypassTriggerLogic = true;
            Database.SaveResult[] tskAssigneeResult = Database.insert(tskAssigneeList, false);
            /*****05/11/2017 - Added task assignee copy functionality Ends*****/
            return +route.id;
        }catch(Exception e){
            GlobalUtility.logMessage('Error','BNPCreateRouteFromTemplateCtrl','BNPCreateRouteFromTemplate','','Exception while creating route from template',String.valueof(e.getMessage()),'','BnP',e,0);
            Database.rollback(preSave); //rollback any completed saves if the transaction has errors
            return e.getMessage();
        }
    }
}