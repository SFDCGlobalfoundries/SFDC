/*
Type Name: BNPStartRoutingTaskCtrl
Author: Poulami Saha
Project Name: DIW Step Down Track 2 (BnP) 
Created Date: 31/05/2016
Description: This class serves to send email notification to Task Assignees, Primay Request Catcher and Backup Request Catcher on clicking 'Start Routing' button on RFQ Routing detail page.
Test Class: 
Change History:
	Poulami Saha	16/06/2017		Added new merge fields in Email Notification Template
*/

Global class BNPStartRoutingTaskCtrl{
    public static List<RFQ_Tasks_Routing__c> routingTasks;
    public static List<RFQ_Tasks_Routing__c> tskToUpdQueueStartDateList;
    public static Boolean startRout;
    public static Boolean notifyAssignee;
    public static RFQ_Routing__c rfqRoute;
    //public static List<String> taskassigneeEmailListToNotify = new List<String>();
    WebService static String BNPStartRoutingTask(String rfqRouteId){
        rfqRoute = [SELECT id, Name, Status__c, RFQ__r.Primary_Request_Catcher__c, RFQ__r.Backup_Request_Catcher__c, RFQ__r.Device__c, RFQ__r.Device__r.Name, RFQ__r.Customer_Requirement__c, RFQ__r.Customer_Requirement__r.Name, RFQ__r.Account__c, RFQ__r.Account__r.Name, RFQ__r.Name, RFQ__r.Customer_Requirement__r.Option_Stage__c, RFQ__r.Customer_Requirement__r.Device_Product_Line__c, RFQ__r.Customer_Requirement__r.Node__c, RFQ__r.Customer_Requirement__r.Technology__c, RFQ__r.Customer_Requirement__r.Fab__c, RFQ__r.Opportunity__r.Business_Unit__c, RFQ__r.Opportunity__r.StageName, RFQ__r.Opportunity__r.Design_Win_Revenue__c, RFQ__r.Opportunity__r.CloseDate, RFQ__r.Opportunity__r.Probability, RFQ__r.Opportunity__r.Owner.Name, RFQ__r.Opportunity__r.Market_Segment__c, RFQ__r.Opportunity__r.Opportunity_Sourcing_Type__c, RFQ__r.Opportunity__r.Revenue_Region__c, RFQ__r.Opportunity__r.Revenue_Territory__c, RFQ__r.Opportunity__r.Siebel_Opportunity_ID__c, RFQ__r.Opportunity__r.Short_Name__c from RFQ_Routing__c WHERE id =: rfqRouteId];
        
        routingTasks=[select id,name,Task_Status__c,Negotiation_Date1__c,Customer_response_date1__c, Customer_response_date_new1__c,Negotiation_Date_New1__c,Start_date__c,End_Date_New__c,End_Date__c,Due_Date__c,complete__c, Status__c, Flag__c, order__c, sequence__c,Task_Due_Date_and_Time__c,Action__c,Task_Assignee__c from RFQ_Tasks_Routing__c where Related_RFQ_Routing__c =: rfqRouteId  and Predecessor_Task__c = null AND (Complete__c = false OR Task_Status__c <> 'Complete' OR Task_Status__c <> 'Cancel' OR Task_Status__c <> 'Auto Completed' OR Task_Status__c <> 'Auto Cancelled') order by order__c, createddate];
        
        system.debug('routingTasks List:' +routingTasks);
        system.debug('routingTasks List Size:' +routingTasks.size());
        
        //tskToUpdQueueStartDate = [SELECT id,name,Task_Status__c,Negotiation_Date1__c,Customer_response_date1__c, Customer_response_date_new1__c,Negotiation_Date_New1__c,Start_date__c,End_Date_New__c,End_Date__c,Due_Date__c,complete__c, Status__c, Flag__c, order__c, sequence__c,Task_Due_Date_and_Time__c,Action__c,Task_Assignee__c from RFQ_Tasks_Routing__c where Related_RFQ_Routing__c =: rfqRouteId and Predecessor_Task__c == null AND (Complete__c = false OR Task_Status__c <> 'Complete' OR Task_Status__c <> 'Cancel' OR Task_Status__c <> 'Auto Completed' OR Task_Status__c <> 'Auto Cancelled')];
        
        List<Id> taskRoutIdList = new List<Id>();
        for(RFQ_Tasks_Routing__c taskRout : routingTasks){
            taskRoutIdList.add(taskRout.id);
        }
        List<RFQ_Task_Assignee__c> rfqTaskAssigneeList = [Select id,name,RFQ_Task_Routing__c,Task_Assignee_Email__c,Task_Assignee__c,User__c,User__r.Email,Notify__c from RFQ_Task_Assignee__c where RFQ_Task_Routing__c IN: taskRoutIdList];
        system.debug('rfqTaskAssigneeList List:' +rfqTaskAssigneeList);
        system.debug('rfqTaskAssigneeList List Size:' +rfqTaskAssigneeList.size());
        Map<Id, List<String>> rfqTaskRoutIdTaskassigneeMap = new Map<Id, List<String>>();
        Map<Id, List<String>> rfqTaskRoutIdTaskassigneeNotifyMap = new Map<Id, List<String>>();
        List<String> assigneeEmailList = new List<String>();
        Map<Id, List<String>> rfqTaskRoutIdTaskassigneeNameMap = new Map<Id, List<String>>();
        
        
        for(RFQ_Tasks_Routing__c taskRout : routingTasks){
            for(RFQ_Task_Assignee__c rfqTaskAssign : rfqTaskAssigneeList){  
                List<String> usrEmailList = new List<String>();
                if(taskRout.id == rfqTaskAssign.RFQ_Task_Routing__c){
                    if(rfqTaskAssign.Task_Assignee_Email__c != null && rfqTaskAssign.Task_Assignee_Email__c != ''){
                        for( String usrEmail : rfqTaskAssign.Task_Assignee_Email__c.split(',')){
                            usrEmailList.add(usrEmail);
                        }
                    }
                
                    if(rfqTaskRoutIdTaskassigneeNameMap.containsKey(taskRout.id)){
                        rfqTaskRoutIdTaskassigneeNameMap.get(taskRout.id).add(rfqTaskAssign.Task_Assignee__c);
                    }else{
                        rfqTaskRoutIdTaskassigneeNameMap.put(taskRout.id, new List <String> {
                                            rfqTaskAssign.Task_Assignee__c
                            });
                    }
                
                    system.debug('Inside 2nd if');
                    for(String userEmail : usrEmailList){
                        if(rfqTaskRoutIdTaskassigneeMap.containsKey(taskRout.id)){
                            //rfqTaskRoutIdTaskassigneeMap.get(taskRout.id).add(rfqTaskAssign.User__r.Email);
                            
                            rfqTaskRoutIdTaskassigneeMap.get(taskRout.id).add(userEmail);
                            
                            //rfqTaskRoutIdTaskassigneeMap.get(taskRout.id).addAll(usrEmailList);
                        }else{
                            /*rfqTaskRoutIdTaskassigneeMap.put(taskRout.id, new List <String> {
                                            rfqTaskAssign.User__r.Email
                            });*/
                            
                            rfqTaskRoutIdTaskassigneeMap.put(taskRout.id, new List <String> {
                                            userEmail
                            });
                            
                            //rfqTaskRoutIdTaskassigneeMap.put(taskRout.id, usrEmailList);
                        }
                        if(rfqTaskAssign.Notify__c){
                            if(rfqTaskRoutIdTaskassigneeNotifyMap.containsKey(taskRout.id)){
                                //rfqTaskRoutIdTaskassigneeNotifyMap.get(taskRout.id).add(rfqTaskAssign.User__r.Email);
                                
                                rfqTaskRoutIdTaskassigneeNotifyMap.get(taskRout.id).add(userEmail);
                                
                                //rfqTaskRoutIdTaskassigneeNotifyMap.get(taskRout.id).addAll(usrEmailList);
                            }else{
                                /*rfqTaskRoutIdTaskassigneeNotifyMap.put(taskRout.id, new List <String> {
                                                rfqTaskAssign.User__r.Email
                                });*/
                                
                                rfqTaskRoutIdTaskassigneeNotifyMap.put(taskRout.id, new List <String> {
                                            userEmail
                                });
                                
                                //rfqTaskRoutIdTaskassigneeNotifyMap.put(taskRout.id, usrEmailList);
                            }
                        }
                    }
                }
            }
        }
        
        
        
        
        for(RFQ_Tasks_Routing__c taskRout : routingTasks){
            List<String> taskassigneeEmailList = rfqTaskRoutIdTaskassigneeMap.get(taskRout.id);
            /*if(taskRout.Start_date__c != null && taskRout.Task_Due_Date_and_Time__c != null && taskRout.order__c != null && taskRout.Action__c != '' && taskRout.Action__c != null && taskassigneeEmailList != null){*/
            if(taskRout.order__c != null && taskRout.Action__c != '' && taskRout.Action__c != null && taskassigneeEmailList != null){
                startRout = true;
            }else{
                system.debug('Inside 1st else');
                startRout = false;
                break;
            }
        }
        
        if(startRout == true){
            rfqRoute.Status__c = 'InProgress';
            update rfqRoute;
            
            tskToUpdQueueStartDateList = new List<RFQ_Tasks_Routing__c>();
            for(RFQ_Tasks_Routing__c taskRout : routingTasks){
                if(taskRout.Start_date__c == null){
                    taskRout.Start_date__c = System.now();
                    tskToUpdQueueStartDateList.add(taskRout);
                }
            }
            
            if(!tskToUpdQueueStartDateList.isEmpty()){
                update tskToUpdQueueStartDateList;
            }
            
            List<Messaging.SingleEmailMessage> newMails = new List<Messaging.SingleEmailMessage>();
            for(RFQ_Tasks_Routing__c taskRout : routingTasks){
                List<String> taskassigneeEmailListToNotify = new List<String>();
                Messaging.SingleEmailMessage singleMail = new Messaging.SingleEmailMessage();
                //List<String> taskassigneeEmailList = rfqTaskRoutIdTaskassigneeMap.get(taskRout.id);
                List<String> taskassigneeEmailList = rfqTaskRoutIdTaskassigneeNotifyMap.get(taskRout.id);
                List<String> taskassigneeNameList = rfqTaskRoutIdTaskassigneeNameMap.get(taskRout.id);
                if(taskassigneeEmailList != null){
                    //taskassigneeEmailListToNotify.addAll(rfqTaskRoutIdTaskassigneeNotifyMap.get(taskRout.id));
                    for(String taskAssEmail : taskassigneeEmailList){
                        taskassigneeEmailListToNotify.add(taskAssEmail);
                    }
                }
                if(rfqRoute.RFQ__r.Primary_Request_Catcher__c != null){
                    taskassigneeEmailListToNotify.add(rfqRoute.RFQ__r.Primary_Request_Catcher__c);
                }
                if(rfqRoute.RFQ__r.Backup_Request_Catcher__c != null){
                    taskassigneeEmailListToNotify.add(rfqRoute.RFQ__r.Backup_Request_Catcher__c);
                }
                if(taskassigneeEmailListToNotify != null && taskassigneeEmailListToNotify.size() > 0){
                    System.debug('User to notify:' +taskassigneeEmailListToNotify);
                    singleMail.setToAddresses(taskassigneeEmailListToNotify);
                    singleMail.setSubject('Task : ' +taskRout.Name+' is assigned to you');
                    String body = 'Device :' +rfqRoute.RFQ__r.Device__r.Name;
                    body+= '<br/>';
                    body+= 'Option :' +rfqRoute.RFQ__r.Customer_Requirement__r.Name;
                    body+= '<br/>';
                    body+= 'Account :' +rfqRoute.RFQ__r.Account__r.name;
                    body+= '<br/>';
                    body+= 'Request Information :' +rfqRoute.RFQ__r.Name;
                    body+= '<br/>';
                    body+= 'Task Name :' +taskRout.Name;
                    body+= '<br/>';
                    body+= 'Task Status :' +taskRout.Task_Status__c;
                    body+= '<br/>';
                    String negotiationDate = '';
                    if(taskRout.Negotiation_Date1__c != null){
                        Datetime negotiationDateTime = Datetime.newInstance(taskRout.Negotiation_Date1__c.year(), taskRout.Negotiation_Date1__c.month(), taskRout.Negotiation_Date1__c.day());
                        negotiationDate = negotiationDateTime.format('dd/MMM/yyyy');
                    }
                    body+= 'Negotiation Date :' +negotiationDate;
                    body+= '<br/>';
                    String cusResponseDate = '';
                    if(taskRout.Customer_response_date1__c != null){
                        Datetime cusResponseDateTime = Datetime.newInstance(taskRout.Customer_response_date1__c.year(), taskRout.Customer_response_date1__c.month(), taskRout.Customer_response_date1__c.day());
                        cusResponseDate = cusResponseDateTime.format('dd/MMM/yyyy');
                    }
                    body+= 'Customer response date :' +cusResponseDate;
                    body+= '<br/>';
                    String startDate = '';
                    if(taskRout.Start_date__c != null){
                        Datetime startDateTime = Datetime.newInstance(taskRout.Start_date__c.year(), taskRout.Start_date__c.month(), taskRout.Start_date__c.day());
                        startDate = startDateTime.format('dd/MMM/yyyy');
                    }
                    body+= 'Task Start Date :' +startDate;
                    body+= '<br/>';
                    String endDate = '';
                    //if(taskRout.End_Date_New__c != null){
                    if(taskRout.End_Date__c != null){
                        //Datetime endDateTime = Datetime.newInstance(taskRout.End_Date_New__c.year(), taskRout.End_Date_New__c.month(), taskRout.End_Date_New__c.day());
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
                    //body+= '<br/>';
                    //body+= 'Sequence :' +taskRout.sequence__c;
                    body+= '<br/>';
                    body+= 'Action :' +taskRout.Action__c;
                    body += '<br/>';
                    body+= 'Task Assignee :' +taskRout.Task_Assignee__c;
                    body+= '<br/>';
                    body+= 'Approve Status :' +taskRout.Status__c;
                    body+= '<br/>';
                    body+= 'Task Assignees :' +taskassigneeNameList;
                    body+= '<br/>';
                    body += '<br/>';
                    body+= 'Option>>Option Stage :' +rfqRoute.RFQ__r.Customer_Requirement__r.Option_Stage__c;
                    body+= '<br/>';
                    body+= 'Option>>Device Product Line :' +rfqRoute.RFQ__r.Customer_Requirement__r.Device_Product_Line__c;
                    body+= '<br/>';
                    body+= 'Option>>Node :' +rfqRoute.RFQ__r.Customer_Requirement__r.Node__c;
                    body+= '<br/>';
                    body+= 'Option>>Technology :' +rfqRoute.RFQ__r.Customer_Requirement__r.Technology__c;
                    body+= '<br/>';
                    body+= 'Option>>Fab :' +rfqRoute.RFQ__r.Customer_Requirement__r.Fab__c;
                    body+= '<br/>';
                    body+= '<br/>';
                    body+= 'Opportunity>>Business Unit :' +rfqRoute.RFQ__r.Opportunity__r.Business_Unit__c;
                    body+= '<br/>';
                    body+= 'Opportunity>>Stage :' +rfqRoute.RFQ__r.Opportunity__r.StageName;
                    body+= '<br/>';
                    body+= 'Opportunity>>Design Win Revenue :' +rfqRoute.RFQ__r.Opportunity__r.Design_Win_Revenue__c;
                    body+= '<br/>';
                    String closeDate = '';
                    if(rfqRoute.RFQ__r.Opportunity__r.CloseDate != null){
                        Datetime closeDateTime = Datetime.newInstance(rfqRoute.RFQ__r.Opportunity__r.CloseDate.year(), rfqRoute.RFQ__r.Opportunity__r.CloseDate.month(), rfqRoute.RFQ__r.Opportunity__r.CloseDate.day());
                        closeDate = closeDateTime.format('dd/MMM/yyyy');
                    }
                    body+= 'Opportunity>>Close Date :' +closeDate;
                    body+= '<br/>';
                    body+= 'Opportunity>>Probability :' +rfqRoute.RFQ__r.Opportunity__r.Probability;
                    body+= '<br/>';
                    body+= 'Opportunity>>Owner :' +rfqRoute.RFQ__r.Opportunity__r.Owner.Name;
                    body+= '<br/>';
                    body+= 'Opportunity>>Market Segment :' +rfqRoute.RFQ__r.Opportunity__r.Market_Segment__c;
                    body+= '<br/>';
                    body+= 'Opportunity>>Opportunity Sourcing Type :' +rfqRoute.RFQ__r.Opportunity__r.Opportunity_Sourcing_Type__c;
                    body+= '<br/>';
                    body+= 'Opportunity>>Revenue Region :' +rfqRoute.RFQ__r.Opportunity__r.Revenue_Region__c;
                    body+= '<br/>';
                    body+= 'Opportunity>>Revenue Territory :' +rfqRoute.RFQ__r.Opportunity__r.Revenue_Territory__c;
                    body+= '<br/>';
                    body+= 'Opportunity>>Account>>Short Name :' +rfqRoute.RFQ__r.Opportunity__r.Short_Name__c;
                    body+= '<br/>';
                    body+= 'Opportunity>>CRM Opportunity ID :' +rfqRoute.RFQ__r.Opportunity__r.Siebel_Opportunity_ID__c;
                    body+= '<br/>';
                    body+= '<br/>';
                    String hyperLink = URL.getSalesforceBaseUrl().toExternalForm()+'/'+taskRout.id;
                    body += '<a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+taskRout.id+'">'+hyperLink+'</a>';
                    singleMail.setHtmlBody(body);
                    newMails.add(singleMail);
                }
            }
            if(!newMails.isEmpty()){
                System.debug('Mail send to user:' +newMails);
                try{
                    Messaging.sendEmail(newMails);
                    return 'Notification sent to Task assignee and Request catcher.';
                }catch(Exception excp){
                    GlobalUtility.logMessage('Error','BNPStartRoutingTaskCtrl','BNPStartRoutingTask','','Exception while sending notification to Task Assignee and Request Catcher',String.valueof(excp.getMessage()),'','BnP',excp,0);
                    return 'Exception while sending notification to Task assignee and Request catcher.';
                }
            }else{
                System.debug('No user to notify:' +newMails);
                return 'There is no Task assignee or Request catcher to notify.';
            }
            
        }else{
            return 'Route will start only when all task must have order, task assignees and action.';
        }
    }
}