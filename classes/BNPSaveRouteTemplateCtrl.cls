/*
Type Name: BNPSaveRouteTemplateCtrl
Author: Poulami Saha
Project Name: DIW Step Down Track 2 (BnP) 
Created Date: 03/06/2017
Description: This class is call from 'Save as Template' button to create Route Template.
Test Class: BNPSaveRouteTemplateCtrlTest
Change History: 05/11/2017 - Added task assignee copy functionality to task assignee template
*/
Global class BNPSaveRouteTemplateCtrl{
    public static RFQ_Routing__c routeRec {get; set;}
     public static List<RFQ_Tasks_Routing__c> tasks {get; set;}

     /**
    *  The Purpose of this method is to clone RFQ.
    *  @name <BNPSaveRouteTemplate>
    *  @param <String> 
    *  @return <String>
    *  @throws exception-<GlobalUtility.logMessage was called to capture the exception>
    */
    WebService static String BNPSaveRouteTemplate(String routingId){
        string routingQuery = 'SELECT id, Name, Calculate_due_date_based_on__c, RFQ__c, RFQ__r.id, Route_Base_Purpose__c,Auto_Stop_on_Rejection__c,Description__c FROM RFQ_Routing__c';
        string taskQuery = 'SELECT id, Task_Name__c,Select_Task_Name__c, Action__c, Add_Offset_Days__c, Order__c, Predecessor_Task__c, Predecessor_Task__r.Order__c, Request_Catcher__c, Negotiation_Date1__c, Start_Date__c, Task_Due_Date_and_Time__c, Customer_response_date1__c, Task_Assignee__c FROM RFQ_Tasks_Routing__c';
        routeRec = (RFQ_Routing__c)Database.query(routingQuery + ' WHERE Id =: routingId limit 1');
        tasks=Database.query(taskQuery+' where Related_RFQ_Routing__c = :routingId Order By Order__c ASC');
        Map<Id, List<RFQ_Task_Assignee__c>> rfqTaskRoutIdTaskassigneeMap = new Map<Id, List<RFQ_Task_Assignee__c>>();
        List<Id> rfqTaskIdList = new List<Id>(); 
        
        Savepoint preSave = Database.setSavepoint(); //set savepoint so we can rollback the whole save if there are errors
        try{
            Route_Template__c routeTemplate = new Route_Template__c();
            routeTemplate.Route_Name__c = routeRec.Name;
            routeTemplate.Calculate_due_date_based_on__c = routeRec.Calculate_due_date_based_on__c;
            routeTemplate.Route_Base_Purpose__c = routeRec.Route_Base_Purpose__c;
            routeTemplate.Status__c = '';
            routeTemplate.Auto_Stop_on_Rejection__c = routeRec.Auto_Stop_on_Rejection__c;
            routeTemplate.Description__c = routeRec.Description__c;
            Database.SaveResult routeTempResult = Database.insert(routeTemplate, false);

            
            List<Task_Template__c> tskTemplateList = new List<Task_Template__c>();
            for(RFQ_Tasks_Routing__c taskRoute : tasks){
                rfqTaskIdList.add(taskRoute.id);
                Task_Template__c newtskTemplate = new Task_Template__c();
                newtskTemplate.Task_Routing__c = taskRoute.id;
                newtskTemplate.Task_Name__c = taskRoute.Task_Name__c;
                newtskTemplate.Task_Type__c = taskRoute.Select_Task_Name__c;
                newtskTemplate.Action_Type__c = taskRoute.Action__c;
                newtskTemplate.Duration__c = Integer.valueOf(taskRoute.Add_Offset_Days__c);
                newtskTemplate.Order__c = taskRoute.Order__c;
                newtskTemplate.Request_Catcher__c = taskRoute.Request_Catcher__c;
                if(taskRoute.Predecessor_Task__c != null){
                    newtskTemplate.Predecessor_Task_Order__c = taskRoute.Predecessor_Task__r.Order__c;
                }
                newtskTemplate.Route_Template__c = routeTemplate.id;
                if(taskRoute.Negotiation_Date1__c != null){
                    if(taskRoute.Start_Date__c != null){
                        newtskTemplate.Start_Date_Diff_Negotiation_Date__c = taskRoute.Start_Date__c.Date().daysBetween(taskRoute.Negotiation_Date1__c.Date());
                    }
                    if(taskRoute.Task_Due_Date_and_Time__c != null){
                        newtskTemplate.Due_Date_Diff_Negotiation_Date__c = taskRoute.Task_Due_Date_and_Time__c.Date().daysBetween(taskRoute.Negotiation_Date1__c.Date());
                    }
                }
                if(taskRoute.Customer_response_date1__c != null){
                    if(taskRoute.Start_Date__c != null){
                        newtskTemplate.Start_Date_Diff_Customer_Response_Date__c =  taskRoute.Start_Date__c.Date().daysBetween(taskRoute.Customer_response_date1__c.Date());
                    }
                    if(taskRoute.Task_Due_Date_and_Time__c != null){
                        newtskTemplate.Due_Date_Diff_Customer_Response_Date__c = taskRoute.Task_Due_Date_and_Time__c.Date().daysBetween(taskRoute.Customer_response_date1__c.Date());
                    }
                }
                newtskTemplate.Task_Assignee__c = taskRoute.Task_Assignee__c;
                tskTemplateList.add(newtskTemplate);
            }
            Database.SaveResult[] tskTempResult = Database.insert(tskTemplateList, false);
            /*****05/11/2017 - Added task assignee copy functionality to task assignee template Starts*****/
            for(RFQ_Tasks_Routing__c taskRoute : tasks){
                for(RFQ_Task_Assignee__c rfqTaskAssign : [Select Id, RFQ_Task_Routing__c, Notify__c, User__c, User__r.id, All_Task_Assignee_Id__c, Task_Assignee_Email__c, User_Type__c, Task_Assignee__c, Task_Assignee_Id__c from RFQ_Task_Assignee__c where RFQ_Task_Routing__c IN :rfqTaskIdList]){
                    if(taskRoute.id == rfqTaskAssign.RFQ_Task_Routing__c){
                        if(rfqTaskRoutIdTaskassigneeMap.containsKey(taskRoute.id)){
                            rfqTaskRoutIdTaskassigneeMap.get(taskRoute.id).add(rfqTaskAssign);
                        }else{
                                rfqTaskRoutIdTaskassigneeMap.put(taskRoute.id, new List <RFQ_Task_Assignee__c> {
                                                rfqTaskAssign
                                });
                        }
                    }
                }
            }
            
            List<Task_Assignee_Template__c> tskAssigneeTemplateList = new List<Task_Assignee_Template__c>();
            for(Task_Template__c tskTemp : tskTemplateList){
                List<RFQ_Task_Assignee__c> tskAssigneeList = rfqTaskRoutIdTaskassigneeMap.get(tskTemp.Task_Routing__c);
                if(tskAssigneeList != null){
                    for(RFQ_Task_Assignee__c taskAss : tskAssigneeList){
                        Task_Assignee_Template__c taskAssTemp = new Task_Assignee_Template__c();
                        taskAssTemp.Task_Template__c = tskTemp.id;
                        taskAssTemp.Assignee_Type__c = taskAss.User_Type__c;
                        taskAssTemp.Task_Assignee__c = taskAss.Task_Assignee__c;
                        taskAssTemp.Task_Assignee_Email__c = taskAss.Task_Assignee_Email__c;
                        taskAssTemp.Task_Assignee_Id__c = taskAss.Task_Assignee_Id__c;
                        taskAssTemp.All_Task_Assignee_Id__c = taskAss.All_Task_Assignee_Id__c;
                        taskAssTemp.Subscribe_Notification__c = taskAss.Notify__c;
                        tskAssigneeTemplateList.add(taskAssTemp);
                    }
                }
            }
            Database.SaveResult[] tskAssigneeTempResult = Database.insert(tskAssigneeTemplateList, false);
            /*****05/11/2017 - Added task assignee copy functionality to task assignee template Ends*****/
            return +routeTemplate.id+'?reqId='+routeRec.RFQ__r.id;
        }catch(Exception e){
            GlobalUtility.logMessage('Error','BNPSaveRouteTemplateCtrl','BNPSaveRouteTemplate','','Exception while creating route template',String.valueof(e.getMessage()),'','BnP',e,0);
            Database.rollback(preSave); //rollback any completed saves if the transaction has errors
            return e.getMessage();
        }
    }
}