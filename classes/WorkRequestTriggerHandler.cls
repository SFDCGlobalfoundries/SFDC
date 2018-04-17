/*
Type Name: WorkRequestTriggerHandler
Author: Cognizant Case Mgmt Team
Created Date: 04-07-2015
Reason: Reason: This is the controller class for WorkRequestTrigger.
Test Class: WorkRequestTriggerHandlerTest
Change History:
Author: 
Modified Date: 
……..
……..
--
*/
public class WorkRequestTriggerHandler {

    public void onAfterInsertWorkRequest(Bug__c[] newWR) {
        onOwnershipChangeCCListMemberInsert(newWR);
    }

    public void onBeforeUpdateWorkRequest(Bug__c[] oldWR, Bug__c[] updatedWR, Map < ID, Bug__c > WROldMap) {
        //Solution section can be modified by only users of the Queue
            modifySolutionValidation(updatedWR, WROldMap);
        SetWorkRequestApprovalProcess(updatedWR, WROldMap);
        //Method sets the Project manager and owner for the WR based on geometry and target process node.
        SetOwnerProjectManagerAndQAforWR(updatedWR, WROldMap);
        DateTimeUpdateOnStatusChange(updatedWR, WROldMap);
        sendEmailNotificationOnFieldValueChange(updatedWR, WROldMap);
    }

    public void onAfterUpdateWorkRequest(Bug__c[] oldWR, Bug__c[] updatedWR, Map < ID, Bug__c > WROldMap) {
        onOwnershipChangeCCListMemberUpdate(updatedWR, WROldMap);
    }

    //This method is used for validating Users Ids
    public String validateUserId(String Idparam) {
        String id = String.escapeSingleQuotes(Idparam);
        if ((id.length() == 15 || id.length() == 18) && Pattern.matches('^[a-zA-Z0-9]*$', id) && ((id.startsWith('005')))) {
            return id;
        }
        return null;
    }
    //isNotBlank- check the string null or blank
    public static Boolean isNotBlank(String val){
        if(val <> null && val.trim() <> '' && val <> 'null'){
            return true;
        }
        return false;
    }
    //Method to create Approval Process object.
    private Approval.ProcessSubmitRequest approvalProcessSubmitRequest(Id submitter, Id approver, string comments, Id objectId) {
        // create the new approval request to submit
        Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
        req.setSubmitterId(submitter);
        req.setNextApproverIds(new List < Id > {
            approver
        });
        req.setComments(comments);
        req.setObjectId(objectId);
        return req;
    }

    //Method to calculate PLM based on Geometry and Target Process Node
    private string calculatePLM(string geometry, string node) {
        string ownerId;
        if (WRPLMRouting__c.getValues(geometry + node) != null) {
            ownerId = WRPLMRouting__c.getValues(geometry + node).PLM__c;
        } else if (WRPLMRouting__c.getValues(geometry) != null) {
            ownerId = WRPLMRouting__c.getValues(geometry).PLM__c;
        } else if (WRPLMRouting__c.getValues('Default') != null) {
            ownerId = WRPLMRouting__c.getValues('Default').PLM__c;
        } else {
            ownerId = UserInfo.getUserId();
        }
        return ownerId;
    }

    //Method to calculate Project Manager based on Geometry and Target Process Node
    private string calculateManager(string geometry, string node) {
        string projectManager;
        //Set WR Project manager based on  geometry and target process node
        if (WRPMRouting__c.getValues(geometry + node) != null) {
            projectManager = WRPMRouting__c.getValues(geometry + node).ProjectManager__c;
        } else if (WRPMRouting__c.getValues(geometry) != null) {
            projectManager = WRPMRouting__c.getValues(geometry).ProjectManager__c;
        } else if (WRPMRouting__c.getValues('Default') != null) {
            projectManager = WRPMRouting__c.getValues('Default').ProjectManager__c;
        } else {
            projectManager = UserInfo.getUserId();
        }
        return projectManager;
    }
    //Method to calculate QA based on Geometry and Target Process Node
    private string calculateQA(string geometry, string node) {
        string QATeam;
        //Set WR Project manager based on  geometry and target process node
        if (WRQARouting__c.getValues(geometry + node) != null) {
            QATeam = WRQARouting__c.getValues(geometry + node).QA__c;
        } else if (WRQARouting__c.getValues(geometry) != null) {
            QATeam = WRQARouting__c.getValues(geometry).QA__c;
        } else if (WRQARouting__c.getValues('Default') != null) {
            QATeam = WRQARouting__c.getValues('Default').QA__c;
        } else {
            QATeam = UserInfo.getUserId();
        }
        return QATeam;
    }

    //Method to calculate Executive Queue based on Geometry and Target Process Node
    private string calculateExecutiveQueue(string geometry, string node) {
        string ExeQueue;
        //Set WR Owner based on  geometry and target process node
        if (WRQueueRouting__c.getValues(geometry + node) != null) {
            ExeQueue = WRQueueRouting__c.getValues(geometry + node).Owner__c;
        } else if (WRQueueRouting__c.getValues(geometry) != null) {
            ExeQueue = WRQueueRouting__c.getValues(geometry).Owner__c;
        } else if (WRQueueRouting__c.getValues('Default') != null) {
            ExeQueue = WRQueueRouting__c.getValues('Default').Owner__c;
        } else {
            ExeQueue = UserInfo.getUserId();
        }
        return ExeQueue;
    }

    //Method sets the PLM based on goemetry and target process node. When Creator Submits work request.
    private void setWorkRequestApprovalProcess(Bug__c[] updatedWR, Map < ID, Bug__c > WRMap) {
        try {
            List < Approval.ProcessSubmitRequest > lstprocess = new List < Approval.ProcessSubmitRequest > ();
            List < Work_Request_Solution_History__c > listSolutionHist = new List < Work_Request_Solution_History__c > ();
            Set < Id > rejWRIds = new Set < Id > ();
            for (Bug__c objWR: updatedWR) {
                Bug__c oldObjWR = WRMap.get(objWR.Id);
                if (objWR.IsPLMSubmitted__c != oldObjWR.IsPLMSubmitted__c && objWR.IsPLMSubmitted__c) {
                    objWR.OwnerId = calculatePLM(objWR.Geometry__c, objWR.Target_Process_Node__c);
                    objWR.Stages__c = 'New Request-Submitted';
                    lstprocess.add(ApprovalProcessSubmitRequest(UserInfo.getUserId(), objWR.OwnerId, System.Label.WR_PLM_Approval_New_Request, objWR.Id));

                } else if (objWR.IsTransferToProjectManager__c != oldObjWR.IsTransferToProjectManager__c && objWR.IsTransferToProjectManager__c) {
                    objWR.OwnerId = calculateExecutiveQueue(objWR.Geometry__c, objWR.Target_Process_Node__c);
                    objWR.Stages__c = 'Executive Team-Submitted';
                    lstprocess.add(ApprovalProcessSubmitRequest(UserInfo.getUserId(), objWR.OwnerId, System.Label.WR_Executive_Team_Approval, objWR.Id));

                } else if (objWR.IsPLMSolutionSubmitted__c != oldObjWR.IsPLMSolutionSubmitted__c && objWR.IsPLMSolutionSubmitted__c) {
                    if (objWR.Approval_Deadline_Date__c == null) objWR.Approval_Deadline_Date__c = Date.Today().adddays(14);
                    objWR.Actual_Delivered_Date__c = objWR.Targetted_Delivery_Date__c;
                    objWR.Actual_Delivered_PDK_Version__c = objWR.Target_delivery_PDK_version__c;
                    objWR.OwnerId = calculatePLM(objWR.Geometry__c, objWR.Target_Process_Node__c);
                    objWR.Stages__c = 'Solution-Submitted';
                    objWR.Status__c = 'Pending Approval';
                    lstprocess.add(ApprovalProcessSubmitRequest(UserInfo.getUserId(), objWR.OwnerId, System.Label.WR_PLM_Approval_Solution, objWR.Id));
                    listSolutionHist.add(createSolutionHistoryObject(objWR));
                } else if (objWR.IsQASubmitted__c != oldObjWR.IsQASubmitted__c && objWR.IsQASubmitted__c) {
                    objWR.OwnerId = calculateQA(objWR.Geometry__c, objWR.Target_Process_Node__c);
                    objWR.Stages__c = 'QA-Submitted';
                    lstprocess.add(ApprovalProcessSubmitRequest(UserInfo.getUserId(), objWR.OwnerId, System.Label.WR_QA_Approval_Solution, objWR.Id));

                } else if (objWR.IsPLMSatisfied__c != oldObjWR.IsPLMSatisfied__c && objWR.IsPLMSatisfied__c) {
                    objWR.QA_Approved_By__c = UserInfo.getUserId();
                    objWR.OwnerId = calculatePLM(objWR.Geometry__c, objWR.Target_Process_Node__c);
                    objWR.Stages__c = 'Implementation-Completed';
                    lstprocess.add(ApprovalProcessSubmitRequest(UserInfo.getUserId(), objWR.OwnerId, System.Label.WR_PLM_Approval_Satisfaction, objWR.Id));

                } else if (objWR.IsReopenSubmitted__c != oldObjWR.IsReopenSubmitted__c && objWR.IsReopenSubmitted__c) {
                    objWR.Reopen_Requested_By__c = UserInfo.getUserId();
                    if (objWR.ProjectManagerQueueId__c == '' || objWR.ProjectManagerQueueId__c == null) {
                        objWR.OwnerId = objWR.Project_Manager__c;
                    } else {
                        objWR.OwnerId = objWR.ProjectManagerQueueId__c;
                    }
                    objWR.Stages__c = 'Reopen-Submitted';
                    lstprocess.add(ApprovalProcessSubmitRequest(UserInfo.getUserId(), objWR.OwnerId, System.Label.WR_PM_Approval_Reopen, objWR.Id));

                } else if (objWR.IsReopen__c != oldObjWR.IsReopen__c && objWR.IsReopen__c) {
                    // This will reset all boolean values
                    objWR.IsPLMSolutionSubmitted__c = false;
                    objWR.IsQASubmitted__c = false;
                    objWR.IsPLMSatisfied__c = false;
                    objWR.IsReopenSubmitted__c = false;
                    objWR.IsSolutionAutoRejected__c = false;
                    objWR.IsSoulutionApproval__c = false;                    
                    // This will reset all DateTime Fields
                    objWR.Date_Time_Assigned_Start__c = null;
                    objWR.Date_Time_Pending_Approval_Start__c = null;
                    objWR.Date_Time_Implementation_Start__c = null;
                    objWR.Date_Time_Completed_Start__c = null;
                    objWR.Date_Time_Assigned_End__c = null;
                    objWR.Date_Time_Pending_Approval_End__c = null;
                    objWR.Date_Time_Implementation_End__c = null;
                    objWR.Date_Time_Completed_End__c = null;
                    objWR.Actual_Delivered_Date__c = null;
                    objWR.Actual_Delivered_PDK_Version__c = null;
                    objWR.Approval_Deadline_Date__c = null;
                    objWR.Resolution_Details__c = null;
                    objWR.Resolution_File_URL__c = null;
                    objWR.Target_Delivery_PDK_version__c = null;
                    objWR.Targetted_Delivery_Date__c = null;
                    objWR.Total_LOE__c = null;
                    objWR.Work_Request_Re_open_Count__c = (objWR.Work_Request_Re_open_Count__c != null) ? (objWR.Work_Request_Re_open_Count__c + 1) : 1;
                    //PDK Management Approval Process
                    objWR.IsReopen__c = false;
                    objWR.OwnerId = calculateExecutiveQueue(objWR.Geometry__c, objWR.Target_Process_Node__c);
                    //Stage should be Reopen Approved
                    objWR.Stages__c = 'Reopen-Approved';
                    //objWR.Stages__c = 'Executive Team-Submitted';                 
                    lstprocess.add(ApprovalProcessSubmitRequest(UserInfo.getUserId(), objWR.OwnerId, System.Label.WR_Executive_Team_Approval, objWR.Id)); 
                } else if (objWR.IsSolutionAutoRejected__c != oldObjWR.IsSolutionAutoRejected__c && objWR.IsSolutionAutoRejected__c) {
                    if (!rejWRIds.Contains(objWR.Id)) rejWRIds.add(objWR.Id);
                }
            }

            if (rejWRIds != null && rejWRIds.size() > 0) {
                AutoRejectedApproveProcess(rejWRIds, 'Solution Auto Rejected');
            }

            // submit the approval request for processing
            //Approval.ProcessResult result = Approval.process(req);
            // display if the request was successful            
            if (lstprocess != null && lstprocess.size() > 0) {
                List < Approval.ProcessResult > resultlist = Approval.process(lstprocess);
            }
            if (listSolutionHist != null && listSolutionHist.size() > 0) {
                insert listSolutionHist;
            }
        } catch (Exception e) {
            CaseHandlerUtility.trackException('WorkRequestTriggerHandler.setWorkRequestApprovalProcess', e.getLineNumber(), e.getTypeName(), e.getMessage());
        }
    }
    //Method to validate Only owner queue members can modify the Solution section
    private void modifySolutionValidation(bug__c[] WRNew, Map < id, bug__c > WROldMap) {
        try {
            Set <Id> qMemberIds = new Set < Id > ();
            Map < Id, List < Id >> mapQueueMembers = new Map < Id, List < Id >> ();
            for (bug__c objWR: WRNew) {
                Bug__c oldObjWR = WROldMap.get(objWR.Id);
                
                if(((String) oldObjWR.OwnerId).substring(0, 3) == '00G' && (((String) oldObjWR.stages__c).contains('Assigned-Owner') || ((String) oldObjWR.stages__c).contains('Solution-Rejected') )&&  
                    (oldObjWR.Targetted_Delivery_Date__c != objWR.Targetted_Delivery_Date__c || oldObjWR.Target_delivery_PDK_version__c != objWR.Target_delivery_PDK_version__c || oldObjWR.Resolution_Details__c != objWR.Resolution_Details__c || oldObjWR.Total_LOE__c != objWR.Total_LOE__c)){
                    if (!qMemberIds.contains(ObjWR.OwnerId))                        
                        qMemberIds.add(ObjWR.OwnerId); 
                }
            }
            if (qMemberIds != null && qMemberIds.size() > 0) {                
                mapQueueMembers = CaseHandlerUtility.getGroupMembers(qMemberIds);               
                for (bug__c objWR: WRNew) {
                    Bug__c oldObjWR = WROldMap.get(objWR.Id);                   
                    Boolean isQueueMemberError = true;
                    List < Id > queueMembers = mapQueueMembers.get(oldObjWR.OwnerId);                   
                    if (queueMembers != null && queueMembers.size() > 0) {
                        for (Id memberId: queueMembers) {                           
                            if (UserInfo.getUserId() == memberId){                              
                                isQueueMemberError = false;     
                            }
                        }
                    }
                    if (isQueueMemberError)
                        objWR.addError(System.Label.WR_Solution_Modification_Error);
                }
            }
        } catch (Exception e) {CaseHandlerUtility.trackException('WorkRequestTriggerHandler.modifySolutionValidation', e.getLineNumber(), e.getTypeName(), e.getMessage());}
    }

    //Method to reject active approval process based on Approval Deadline Date
    @future
    public static void autoRejectedApproveProcess(Set < Id > wrIds, string comments) {
        try {
            List < Approval.ProcessWorkitemRequest > lstprocess = new List < Approval.ProcessWorkitemRequest > ();

            List < ProcessInstanceWorkitem > listApprovalReq = [SELECT Id, ProcessInstance.TargetObjectId
            FROM ProcessInstanceWorkitem
            WHERE ProcessInstance.TargetObjectId In: wrIds];
            if (listApprovalReq != null && listApprovalReq.size() > 0) {
                for (ProcessInstanceWorkitem approvalReqObj: listApprovalReq) {
                    Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
                    req.setComments(comments);
                    req.setAction('Reject');
                    req.setWorkitemId(approvalReqObj.Id);
                    lstprocess.add(req);
                }
                if (lstprocess != null && lstprocess.size() > 0) {
                    List < Approval.ProcessResult > resultlist = Approval.process(lstprocess);
                }
            }
        } catch (Exception e) {
            CaseHandlerUtility.trackException('WorkRequestTriggerHandler.AutoRejectApproveProcess', e.getLineNumber(), e.getTypeName(), e.getMessage());
        }
    }

    //Method sets the Project manager and owner for the WR based on goemetry and target process node.
    public void setOwnerProjectManagerAndQAforWR(bug__c[] bugNew, Map < id, bug__c > bugOldMap) {
        try {
            for (bug__c objWR: bugNew) {
                Bug__c oldObjWR = bugOldMap.get(objWR.Id);
                if (objWR.stages__c != oldObjWR.stages__c) {
                    if (objWR.stages__c == 'New Request-Rejected') {
                        objWR.OwnerId = objWR.CreatedById;
                    } else if (objWR.stages__c == 'Assigned-Queue' || objWR.stages__c == 'Executive Team-Submitted') {
                        //objWR.OwnerId = calculateExecutiveQueue(objWR.Geometry__c, objWR.Target_Process_Node__c);
                        objWR.Project_Manager__c = calculateManager(objWR.Geometry__c, objWR.Target_Process_Node__c);

                        if (WRPMRouting__c.getValues(objWR.Geometry__c + objWR.Target_Process_Node__c) != null) {
                            objWR.ProjectManagerQueueId__c = WRPMRouting__c.getValues(objWR.Geometry__c + objWR.Target_Process_Node__c).ProjectManagerQueue__c;
                            objWR.Project_Manager_Queue__c = WRPMRouting__c.getValues(objWR.Geometry__c + objWR.Target_Process_Node__c).ProjectManagerQueueName__c;
                        } else if (WRPMRouting__c.getValues(objWR.Geometry__c) != null) {
                            objWR.ProjectManagerQueueId__c = WRPMRouting__c.getValues(objWR.Geometry__c).ProjectManagerQueue__c;
                            objWR.Project_Manager_Queue__c = WRPMRouting__c.getValues(objWR.Geometry__c).ProjectManagerQueueName__c;
                        } else {
                            objWR.ProjectManagerQueueId__c = '';
                            objWR.Project_Manager_Queue__c = '';
                        }

                    } else if (objWR.stages__c == 'Executive Team-Rejected') {
                        objWR.OwnerId = objWR.CreatedById;
                        objWR.IsPLMSubmitted__c = false;
                    } else if (objWR.stages__c == 'Executive Team-Approved') {
                        if (isNotBlank(objWR.ProjectManagerQueueId__c)) {
                            objWR.OwnerId = objWR.ProjectManagerQueueId__c;
                        } else {
                            objWR.OwnerId = objWR.Project_Manager__c;
                        }
                        objWR.stages__c = 'Assigned-Owner';
                        objWR.status__c = 'Assigned';
                    } else if (objWR.stages__c == 'Solution-Rejected') {
                        objWR.Solution_Rejected_By__c = UserInfo.getUserId();
                        if (objWR.ProjectManagerQueueId__c == '' || objWR.ProjectManagerQueueId__c == null) {
                            objWR.OwnerId = objWR.Project_Manager__c;
                        } else {
                            objWR.OwnerId = objWR.ProjectManagerQueueId__c;
                        }
                    } else if (objWR.stages__c == 'QA-Rejected') {
                        if (objWR.ProjectManagerQueueId__c == '' || objWR.ProjectManagerQueueId__c == null) {
                            objWR.OwnerId = objWR.Project_Manager__c;
                        } else {
                            objWR.OwnerId = objWR.ProjectManagerQueueId__c;
                        }
                    } else if (objWR.stages__c == 'Implementation') {
                        objWR.Solution_Approved_By__c = UserInfo.getUserId();
                        if (objWR.ProjectManagerQueueId__c == '' || objWR.ProjectManagerQueueId__c == null) {
                            objWR.OwnerId = objWR.Project_Manager__c;
                        } else {
                            objWR.OwnerId = objWR.ProjectManagerQueueId__c;
                        }
                    } else if (objWR.stages__c == 'Reopen-Rejected') {
                        objWR.OwnerId = calculatePLM(objWR.Geometry__c, objWR.Target_Process_Node__c);
                    }
                }
            }
        } catch (Exception e) {
            CaseHandlerUtility.trackException('WorkRequestTriggerHandler.SetOwnerProjectManagerAndQAforWR', e.getLineNumber(), e.getTypeName(), e.getMessage());
        }
    }

    //Method to send Email Notification to CC List and Component Team Members.
    public void sendEmailNotificationOnFieldValueChange(bug__c[] WRNew, Map < id, bug__c > WROldMap) {
        try {
            Integer i = 0;
            for (bug__c wrObj: WRNew) {
                if (i <= 10) { //to avoid future call and SOQL limit
                    Bug__c oldObjWR = WROldMap.get(wrObj.Id);
                    if (wrObj.status__c != oldObjWR.status__c) {
                        wrObj.Status_Old__c = oldObjWR.status__c;
                        //Status is Changed (Status New and Old values)
                        WorkRequestEmailHandler.onStatusChangeEvent(wrObj.Id, 'StatusChangedNotification');
                    }
                    if (wrObj.stages__c != oldObjWR.stages__c) {
                        WorkRequestEmailHandler.onStageChangeEvent(wrObj.Id, wrObj.stages__c);
                    }
                    i++;
                }
            }
        } catch (Exception e) {
            CaseHandlerUtility.trackException('WorkRequestTriggerHandler.sendEmailNotificationOnFieldValueChange', e.getLineNumber(), e.getTypeName(), e.getMessage());
        }
    }

    //Method to Date Time on Status change.
    public void dateTimeUpdateOnStatusChange(bug__c[] WRNew, Map < id, bug__c > WROldMap) {
        try {
            for (bug__c wrObj: WRNew) {
                Bug__c oldObjWR = WROldMap.get(wrObj.Id);
                if (wrObj.status__c != oldObjWR.status__c) {
                    // Start Dates
                    if (wrObj.status__c == 'Assigned') {
                        wrObj.Date_Time_Assigned_Start__c = DateTime.Now();
                    } else if (wrObj.status__c == 'Pending Approval') {
                        wrObj.Date_Time_Pending_Approval_Start__c = DateTime.Now();
                    } else if (wrObj.status__c == 'Implementation') {
                        wrObj.Date_Time_Implementation_Start__c = DateTime.Now();
                    } else if (wrObj.status__c == 'Completed') {
                        wrObj.Date_Time_Completed_Start__c = DateTime.Now();
                    } else if (wrObj.status__c == 'Reopen') {
                        wrObj.Date_Time_Reopened_Start__c = DateTime.Now();
                    } else if (wrObj.status__c == 'Closed') {
                        wrObj.Date_Time_Closed__c = DateTime.Now();
                    }
                    // End Dates
                    if (oldObjWR.status__c == 'New Request') {
                        wrObj.Date_Time_New_Request_End__c = DateTime.Now();
                    } else if (oldObjWR.status__c == 'Assigned') {
                        wrObj.Date_Time_Assigned_End__c = DateTime.Now();
                    } else if (oldObjWR.status__c == 'Pending Approval') {
                        wrObj.Date_Time_Pending_Approval_End__c = DateTime.Now();
                    } else if (oldObjWR.status__c == 'Implementation') {
                        wrObj.Date_Time_Implementation_End__c = DateTime.Now();
                    } else if (oldObjWR.status__c == 'Completed') {
                        wrObj.Date_Time_Completed_End__c = DateTime.Now();
                    } else if (oldObjWR.status__c == 'Reopen') {
                        wrObj.Date_Time_Reopened_End__c = DateTime.Now();
                    }
                }
            }
        } catch (Exception e) {
            CaseHandlerUtility.trackException('WorkRequestTriggerHandler.DateTimeUpdateOnStatusChange', e.getLineNumber(), e.getTypeName(), e.getMessage());
        }
    }

    //Method to insert PDK request Creator into CC Lists.
    public void onOwnershipChangeCCListMemberInsert(bug__c[] WRNew) {
        try {
            List < CC_List__c > lstCCList = New List < CC_List__c > ();
            for (bug__c wrObj: WRNew) {
                lstCCList.add(createCCLIstObject(wrObj.Id, wrObj.CreatedById, 'PDK Request Creator', false));
            }
            if (lstCCList != null && lstCCList.size() > 0) insert lstCCList;
        } catch (Exception e) {
            CaseHandlerUtility.trackException('WorkRequestTriggerHandler.onOwnershipChangeCCListMemberInsert', e.getLineNumber(), e.getTypeName(), e.getMessage());
        }
    }

    //Method creates Work_Request_Solution_History__c  object
    private Work_Request_Solution_History__c createSolutionHistoryObject(bug__c objWR) {
        Work_Request_Solution_History__c objHist = new Work_Request_Solution_History__c();
        objHist.Work_Request__c = objWR.Id;
        objHist.Actual_Delivered_Date__c = objWR.Actual_Delivered_Date__c;
        objHist.Actual_Delivered_PDK_Version__c = objWR.Actual_Delivered_PDK_Version__c;
        objHist.Approval_Deadline_Date__c = objWR.Approval_Deadline_Date__c;
        objHist.Resolution_Details__c = objWR.Resolution_Details__c;
        objHist.Resolution_File_URL__c = objWR.Resolution_File_URL__c;
        objHist.Target_Delivery_PDK_version__c = objWR.Target_Delivery_PDK_version__c;
        objHist.Targetted_Delivery_Date__c = objWR.Targetted_Delivery_Date__c;
        return objHist;
    }
    //Method to insert PDK request Owner into CC Lists.
    public void onOwnershipChangeCCListMemberUpdate(bug__c[] WRNew, Map < id, bug__c > WROldMap) {
        try {
            Set < Id > queueIds = new Set < Id > ();
            Set < Id > wrIds = new Set < Id > ();
            Map < string, Id > mapCCList = new Map < string, Id > ();
            Map < string, string > mapCCListforRole = new Map < string, string > ();
            Map < string, CC_List__c > mapCCListId = new Map < string, CC_List__c > ();
            Map < Id, List < Id >> mapGroupMembers = new Map < Id, List < Id >> ();
            List < CC_List__c > lstCCList = New List < CC_List__c > ();
            List < CC_List__c > lstCCListPLMQAPDK = New List < CC_List__c > ();
            List < CC_List__c > CCListToUpdate = New List < CC_List__c > ();
            List < CC_List__c > CCListToDelete = New List < CC_List__c > ();

            set < string > allRoleSet = new set < string > ();
            List < string > allRoleList = new List < string > ();
            for (bug__c wrObj: WRNew) {
                Bug__c oldObjWR = WROldMap.get(wrObj.Id);

                if (wrObj.Project_Manager__c != oldObjWR.Project_Manager__c) {
                    if (!wrIds.Contains(wrObj.Id)) wrIds.add(wrObj.Id);
                }

                if (wrObj.OwnerId != oldObjWR.OwnerId) {
                    if (((string) wrObj.OwnerId).startsWith('00G')) {
                        queueIds.add(wrObj.OwnerId);
                    }
                    if (!wrIds.Contains(wrObj.Id)) wrIds.add(wrObj.Id);
                }
            }

            List < CC_List__c > lstCCListTemp = New List < CC_List__c > ();
            if (wrIds != null && wrIds.size() > 0) {
                lstCCListTemp = [SELECT Id, UniqueId__c, Bug_Work_Request__c, User__c, Roles_Responsibility__c FROM CC_List__c WHERE Bug_Work_Request__c In: wrIds And UniqueId__c <> null LIMIT 1000];
                for (CC_List__c cc: lstCCListTemp) {
                    mapCCList.Put((string) cc.Bug_Work_Request__c + (string) cc.User__c, cc.Id);
                    mapCCListforRole.Put((string) cc.Bug_Work_Request__c + (string) cc.User__c, cc.Roles_Responsibility__c);
                    mapCCListId.put((string) cc.Bug_Work_Request__c + (string) cc.User__c, cc);
                }
            }

            // return group members with group Id
            if (queueIds != null && queueIds.size() > 0) {
                mapGroupMembers = CaseHandlerUtility.getGroupMembers(queueIds);
            }

            for (bug__c wrObj: WRNew) {
                string creator = WRCustomText__c.getValues('Creator').Text__c;
                string subscriber = WRCustomText__c.getValues('SubscriptionOnly').Text__c;
                string releaseEngineer = WRCustomText__c.getValues('ReleaseEngineer').Text__c;
                string other = WRCustomText__c.getValues('Other').Text__c;
                string PLM = WRCustomText__c.getValues('PLM').Text__c;
                string PDKTeam = WRCustomText__c.getValues('PDKTeam').Text__c;
                string PDKMember = WRCustomText__c.getValues('PDKMember').Text__c;
                string ProjectManager = WRCustomText__c.getValues('ProjectManager').Text__c;
                string QATeam = WRCustomText__c.getValues('QATeam').Text__c;
                Map < Id, String > userAndRole = new Map < Id, String > ();
                Set < string > stagesPLM = new Set < String > {
                    'New Request-Submitted', 'New Request-Rejected', 'QA-Approved', 'Assigned-Owner', 'Solution-Submitted', 'Solution-Rejected', 'Implementation-Completed'
                };
                Set < string > stagesPDKTeam = new Set < String > {
                    'Assigned-Queue', 'Reopen-Approved'
                };
                Set < string > stagesQA = new Set < String > {
                    'QA-Submitted'
                };
                Bug__c oldObjWR = WROldMap.get(wrObj.Id);

                if (wrObj.Project_Manager__c != oldObjWR.Project_Manager__c) {
                    if (!mapCCList.containsKey((string) wrObj.Id + (string) wrObj.Project_Manager__c)) {
                        lstCCList.add(createCCLIstObject(wrObj.Id, wrObj.Project_Manager__c, ProjectManager, false));
                        mapCCList.put((string) wrObj.Id + (string) wrObj.Project_Manager__c, null);
                    } else {
                        if (mapCCListforRole.containsKey((string) wrObj.Id + (string) wrObj.Project_Manager__c)) {
                            string oldRole = mapCCListforRole.get((string) wrObj.Id + (string) wrObj.Project_Manager__c);
                            allRoleList = oldRole.split(';');
                            for (string roleList: allRoleList) {
                                allRoleSet.add(roleList);
                            }
                            CC_List__c ccListid = mapCCListId.get((string) wrObj.Id + (string) wrObj.Project_Manager__c);
                            if (!allRoleSet.contains(ProjectManager)) {
                                ccListid.Roles_Responsibility__c = oldRole + ';' + ProjectManager;
                                CCListToUpdate.add(ccListid);
                            }
                        }
                    }
                }
                if (wrObj.Project_Manager_Queue__c != oldObjWR.Project_Manager_Queue__c) {
                    if (wrObj.ProjectManagerQueueId__c != '') {
                        Id pmqId = wrObj.ProjectManagerQueueId__c;
                        Set < Id > pmqIds = new Set < Id > ();
                        Map < Id, List < Id >> mapPMQMembers = new Map < Id, List < Id >> ();
                        pmqIds.add(pmqId);
                        mapPMQMembers = CaseHandlerUtility.getGroupMembers(pmqIds);
                        List < Id > qMembers = mapPMQMembers.get(pmqId);
                        if (qMembers != null && qMembers.size() > 0) {
                            for (Id userId: qMembers) {
                                if (wrObj.Project_Manager__c != userId) {
                                    if (mapCCList.containsKey((string) wrObj.Id + (string) userId)) {
                                        if (mapCCListforRole.containsKey((string) wrObj.Id + (string) userId)) {
                                            string oldRole = mapCCListforRole.get((string) wrObj.Id + (string) userId);
                                            allRoleList = oldRole.split(';');
                                            for (string roleList: allRoleList) {
                                                allRoleSet.add(roleList);
                                            }
                                            CC_List__c ccListid = mapCCListId.get((string) wrObj.Id + (string) userId);
                                            if (!allRoleSet.contains(ProjectManager)) {
                                                ccListid.Roles_Responsibility__c = oldRole + ';' + ProjectManager;
                                                CCListToUpdate.add(ccListid);
                                            }
                                        }
                                    } else {
                                        lstCCList.add(createCCLIstObject(wrObj.Id, userId, ProjectManager, false));
                                        mapCCList.put((string) wrObj.Id + (string) userId, null);
                                    }
                                }
                            }
                        }
                    }
                }

                if (wrObj.Stages__c == 'New Request-Submitted') {
                    userAndRole = createCClistUsers(wrObj.Geometry__c, wrObj.Target_Process_Node__c, wrObj.CreatedById);
                    for (Id uId: userAndRole.keySet()) {
                        if (!mapCCList.containsKey((string) wrObj.Id + (string) uId)) {
                            lstCCList.add(createCCLIstObject(wrObj.Id, uId, userAndRole.get(uId), true));
                            mapCCList.put((string) wrObj.Id + (string) uId, null);
                        } else {
                            if (mapCCListforRole.containsKey((string) wrObj.Id + (string) uId)) {
                                string oldRole = mapCCListforRole.get((string) wrObj.Id + (string) uId);
                                allRoleList = oldRole.split(';');
                                for (string roleList: allRoleList) {
                                    allRoleSet.add(roleList);
                                }
                                CC_List__c ccListid = mapCCListId.get((string) wrObj.Id + (string) uId);
                                if (!oldRole.contains(userAndRole.get(uId))) {
                                    ccListid.Roles_Responsibility__c = oldRole + ';' + userAndRole.get(uId);
                                    CCListToUpdate.add(ccListid);
                                }
                            }
                        }
                    }
                }

                if ((wrObj.Geometry__c != oldObjWR.Geometry__c || wrObj.Target_Process_Node__c != oldObjWR.Target_Process_Node__c) && (wrObj.Stages__c == 'New Request-Rejected' || wrObj.Stages__c == 'Executive Team-Rejected') ){
                    for (CC_List__c cc: [SELECT Id, UniqueId__c, Bug_Work_Request__c, User__c, Roles_Responsibility__c FROM CC_List__c WHERE Bug_Work_Request__c = : wrObj.Id And UniqueId__c <> null LIMIT 1000]) {
                        //Creator, Subscription only, Release Engineer, Other Contributors role will be not deleted.
                        if (!cc.Roles_Responsibility__c.contains(creator) && !cc.Roles_Responsibility__c.contains(subscriber) && !cc.Roles_Responsibility__c.contains(releaseEngineer) && !cc.Roles_Responsibility__c.contains(other)) {
                            CCListToDelete.add(cc);
                        } else {
                            if (cc.Roles_Responsibility__c.contains(creator)) {
                                cc.Roles_Responsibility__c = creator;
                                CCListToUpdate.add(cc);
                            } else if (cc.Roles_Responsibility__c.contains(subscriber)) {
                                cc.Roles_Responsibility__c = subscriber;
                                CCListToUpdate.add(cc);
                            } else if (cc.Roles_Responsibility__c.contains(releaseEngineer)) {
                                cc.Roles_Responsibility__c = releaseEngineer;
                                CCListToUpdate.add(cc);
                            } else {
                                cc.Roles_Responsibility__c = other;
                                CCListToUpdate.add(cc);
                            }
                        }
                    }
                }
                if (wrObj.OwnerId != oldObjWR.OwnerId) {
                    if (!(((string) wrObj.OwnerId).startsWith('00G'))) {
                        if (wrObj.Owner_IsActive__c) {
                            if (wrObj.CreatedById != wrObj.OwnerId) {
                                if (!mapCCList.containsKey((string) wrObj.Id + (string) wrObj.OwnerId)) {
                                    if (stagesPLM.contains(wrObj.Stages__c)) {
                                        lstCCList.add(createCCLIstObject(wrObj.Id, wrObj.OwnerId, PLM, false));
                                    } else if (stagesPDKTeam.contains(wrObj.Stages__c)) {
                                        lstCCList.add(createCCLIstObject(wrObj.Id, wrObj.OwnerId, PDKTeam, false));
                                    } else if (stagesQA.contains(wrObj.Stages__c)) {
                                        lstCCList.add(createCCLIstObject(wrObj.Id, wrObj.OwnerId, QATeam, false));
                                    } else {
                                        lstCCList.add(createCCLIstObject(wrObj.Id, wrObj.OwnerId, PDKMember, false));
                                    }
                                }
                            }
                        }
                    } else {
                        if (mapGroupMembers != null && mapGroupMembers.size() > 0) {
                            List < Id > groupMembers = mapGroupMembers.get(wrObj.OwnerId);
                            if (groupMembers != null && groupMembers.size() > 0) {
                                for (Id userId: groupMembers) {
                                    if (wrObj.CreatedById != userId) {                  
                                        if (!mapCCList.containsKey((string) wrObj.Id + (string) userId)) {
                                            if (stagesPLM.contains(wrObj.Stages__c)) {
                                                lstCCList.add(createCCLIstObject(wrObj.Id, userId, PLM, true));
                                            } else if (stagesPDKTeam.contains(wrObj.Stages__c)) {
                                                lstCCList.add(createCCLIstObject(wrObj.Id, userId, PDKTeam, true));
                                            } else if (stagesQA.contains(wrObj.Stages__c)) {
                                                lstCCList.add(createCCLIstObject(wrObj.Id, userId, QATeam, true));
                                            } else {
                                                lstCCList.add(createCCLIstObject(wrObj.Id, userId, PDKMember, false));
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }            
            if (lstCCList != null && lstCCList.size() > 0) insert lstCCList;
            if (CCListToUpdate != null && CCListToUpdate.size() > 0) update CCListToUpdate;
            if (CCListToDelete.size() > 0) delete CCListToDelete;
        } catch (Exception e) {
            CaseHandlerUtility.trackException('WorkRequestTriggerHandler.onOwnershipChangeCCListMemberUpdate', e.getLineNumber(), e.getTypeName(), e.getMessage());
        }
    }
    //Retrieving PLM, QA and PDK Team member for Initial Submission.
    public Map < Id, String > createCClistUsers(String geometry, String node, Id createdBy) {
        Map < Id, String > userwithRole = new Map < Id, String > ();
        String role = '';
        List < Id > lstIDs = new List < Id > ();
        Set < Id > userIds = new Set < Id > ();
        Set < Id > userIds_PLM = new Set < Id > ();
        Set < Id > userIds_QA = new Set < Id > ();
        Set < Id > userIds_PDK = new Set < Id > ();
        Set < Id > queueIds_PLM = new Set < Id > ();
        Set < Id > queueIds_QA = new Set < Id > ();
        Set < Id > queueIds_PDKTeam = new Set < Id > ();
        Map < Id, List < Id >> mapGroupMembers_PLM = new Map < Id, List < Id >> ();
        Map < Id, List < Id >> mapGroupMembers_QA = new Map < Id, List < Id >> ();
        Map < Id, List < Id >> mapGroupMembers_PDKMgmtTeam = new Map < Id, List < Id >> ();
        Id PLMusers;
        Id PDKManagementUsers;
        Id QAUsers;
        PLMusers = Id.valueof(calculatePLM(geometry, node));
        QAUsers = Id.valueof(calculateQA(geometry, node));
        PDKManagementUsers = Id.valueof(calculateExecutiveQueue(geometry, node));
        if (((string) PLMusers).startsWith('00G')) {
            queueIds_PLM.add(PLMusers);
        } else userIds_PLM.add(PLMusers);
        if (((string) QAUsers).startsWith('00G')) {
            queueIds_QA.add(QAUsers);
        } else {
            userIds_QA.add(QAUsers);
        }
        if (((string) PDKManagementUsers).startsWith('00G')) {
            queueIds_PDKTeam.add(PDKManagementUsers);
        } else {
            userIds_PDK.add(PDKManagementUsers);
        }
        if (queueIds_PLM != null && queueIds_PLM.size() > 0) {
            mapGroupMembers_PLM = CaseHandlerUtility.getGroupMembers(queueIds_PLM);
            if (mapGroupMembers_PLM.get(PLMusers) != null && (mapGroupMembers_PLM.get(PLMusers)).size() > 0) userIds_PLM.addAll(mapGroupMembers_PLM.get(PLMusers));
        }
        if (queueIds_QA != null && queueIds_QA.size() > 0) {
            mapGroupMembers_QA = CaseHandlerUtility.getGroupMembers(queueIds_QA);
            if (mapGroupMembers_QA.get(QAUsers) != null && (mapGroupMembers_QA.get(QAUsers)).size() > 0) userIds_QA.addAll(mapGroupMembers_QA.get(QAUsers));
        }
        if (queueIds_PDKTeam != null && queueIds_PDKTeam.size() > 0) {
            mapGroupMembers_PDKMgmtTeam = CaseHandlerUtility.getGroupMembers(queueIds_PDKTeam);
            if (mapGroupMembers_PDKMgmtTeam.get(PDKManagementUsers) != null && (mapGroupMembers_PDKMgmtTeam.get(PDKManagementUsers)).size() > 0) userIds_PDK.addAll(mapGroupMembers_PDKMgmtTeam.get(PDKManagementUsers));
        }
        userIds.addAll(userIds_PLM);
        userIds.addAll(userIds_QA);
        userIds.addAll(userIds_PDK);
        userIds.add(createdBy);
        for (Id u: userIds) {
            if (userIds_PLM.contains(u) && userIds_QA.contains(u) && userIds_PDK.contains(u)) {
                role = WRCustomText__c.getValues('PLM').Text__c + ';' + WRCustomText__c.getValues('QATeam').Text__c + ';' + WRCustomText__c.getValues('PDKTeam').Text__c;
                userwithRole.put(u, role);
            } else if (userIds_PLM.contains(u) && userIds_QA.contains(u)) {
                role = WRCustomText__c.getValues('PLM').Text__c + ';' + WRCustomText__c.getValues('QATeam').Text__c;
                userwithRole.put(u, role);
            } else if (userIds_PLM.contains(u) && userIds_PDK.contains(u)) {
                role = WRCustomText__c.getValues('PLM').Text__c + ';' + WRCustomText__c.getValues('PDKTeam').Text__c;
                userwithRole.put(u, role);
            } else if (userIds_QA.contains(u) && userIds_PDK.contains(u)) {
                role = WRCustomText__c.getValues('QATeam').Text__c + ';' + WRCustomText__c.getValues('PDKTeam').Text__c;
                userwithRole.put(u, role);
            } else if (userIds_PLM.contains(u)) {
                role = WRCustomText__c.getValues('PLM').Text__c;
                userwithRole.put(u, role);
            } else if (userIds_QA.contains(u)) {
                role = WRCustomText__c.getValues('QATeam').Text__c;
                userwithRole.put(u, role);
            } else {
                role = WRCustomText__c.getValues('PDKTeam').Text__c;
                userwithRole.put(u, role);
            }
        }
        return userwithRole;
    }
    //Method creates CC_List__c  object
    private CC_List__c createCCLIstObject(Id parentId, Id userId, string role, Boolean statusOnly) {
        CC_List__c objCCList = new CC_List__c();
        objCCList.Bug_Work_Request__c = parentId;
        objCCList.User__c = userId;
        objCCList.Roles_Responsibility__c = role;
        objCCList.Access__c = 'Read/Write';
        objCCList.StatusOnly__c = statusOnly;
        return objCCList;
    }
    //Method creates component team for PDK component
    public void componentTeamforPDKComponent(PDK_Component__c[] pdkList) {
        try {
            list < Component_Team__c > compList = new list < Component_Team__c > ();
            list < WRComponentTeam__c > csList = WRComponentTeam__c.getall().values();
            Map < string, WRComponentTeam__c > mapforOwnerandTeam = new Map < string, WRComponentTeam__c > ();
            //validating whether the users added in WRComponentTeam__c are active and standard users
            Map<id, user> UserMap = new Map<id, user>();
            list < string > userIdsTemp = new list < string > ();
            for (WRComponentTeam__c wr: csList) {
                if(wr.User__c != null){
                    for (string st: wr.User__c.split(',')) {
                        userIdsTemp.add(st);
                    }
                }
            }            
            UserMap = new Map < id, user > ([select id, IsActive from user where id in : userIdsTemp and IsActive =: true and usertype =: 'Standard']);
            for (pdk_component__c c: pdkList) {
                if (c.Product_Technology__c != '' && c.Product_Technology__c != null) {
                    for (WRComponentTeam__c csTemp: csList) {
                        if (c.Component__c != '' && c.Component__c != null) {
                            if (c.Product_Technology__c == cstemp.Product_Technology__c && c.Component__c == cstemp.Component__c) mapforOwnerandTeam.put(c.id, cstemp);
                        } else {
                            if (c.Product_Technology__c == cstemp.Product_Technology__c) {
                                mapforOwnerandTeam.put(c.id, cstemp);
                            }
                        }
                    }
                }
            }

            for (pdk_component__c p: pdkList) {
                if (mapforOwnerandTeam.size() > 0) {
                    if (mapforOwnerandTeam.get(p.id).user__c != '' && mapforOwnerandTeam.get(p.id).user__c != null) {
                        string users = mapforOwnerandTeam.get(p.id).user__c;
                        for (string st: users.split(',')) {
                            if (validateUserId(st) != null && UserMap.containskey(st)) {
                                Component_Team__c c = new Component_Team__c();
                                c.PDK_Component__c = p.id;
                                c.user__c = st;
                                compList.add(c);
                            }
                        }
                    }
                }
            }
            if (compList != null && compList.size() > 0) insert compList;
        } catch (Exception e) {
            CaseHandlerUtility.trackException('WorkRequestTriggerHandler.ComponentTeamforPDKComponent', e.getLineNumber(), e.getTypeName(), e.getMessage());
        }
    }
    //Method Validates the PDK Component for duplicate
    public boolean validatePDKComponent(pdk_Component__c pdkcompoentVar) {
        if ([SELECT id
        FROM pdk_component__c
        WHERE Bug_Work_Request__c = : pdkcompoentVar.Bug_Work_Request__c
        AND Product_Technology__c = : pdkcompoentVar.Product_Technology__c
        AND component__c = : pdkcompoentVar.component__c].size() > 0) {
            return true;
        } else return false;
    }
    //Method sets the WR no for component team from PDK component record.
    public void setWRNoforComponentTeam(Component_Team__c[] componentList) {
        try {
            list < id > pdkId = new list < id > ();
            for (Component_Team__c c: componentList) {
                pdkId.add(c.pdk_component__c);
            }

            Map < id, pdk_component__c > pdkMap = new Map < id, pdk_component__c > ([select id, Bug_Work_Request__c from pdk_component__c where id in : pdkId]);

            for (Component_Team__c c: componentList) {
                if (c.Bug_Work_Request__c == null || c.Bug_Work_Request__c == '') c.Bug_Work_Request__c = pdkMap.get(c.pdk_component__c).Bug_Work_Request__c;
            }
        } catch (Exception e) {
            CaseHandlerUtility.trackException('WorkRequestTriggerHandler.SetWRNoforComponentTeam', e.getLineNumber(), e.getTypeName(), e.getMessage());
        }
    }

    //Method for sending email on creation of PDK component
    public void emailNotificationForPDKCreation(List < PDK_Component__c > pdkList) {
        try {
            for (PDK_Component__c pdk: pdkList) {
                WorkRequestEmailHandler.sendEmailNotificationforPDKComponent(pdk.WR_ID__c, pdk.ID, 'PDKComponentCreation');
            }
        } catch (Exception e) {
            CaseHandlerUtility.trackException('WorkRequestTriggerHandler.emailNotificationForPDKCreation', e.getLineNumber(), e.getTypeName(), e.getMessage());
        }
    }

    //Method for sending email on Deletion of PDK component
    public void emailNotificationForPDKDeletion(List < PDK_Component__c > PDKdeleted) {
        try {
            for (PDK_Component__c pdk: PDKdeleted) {
                WorkRequestEmailHandler.sendEmailNotificationforPDKComponent(pdk.WR_ID__c, pdk.ID, 'PDKComponentDeletion');
            }
        } catch (Exception e) {
            CaseHandlerUtility.trackException('WorkRequestTriggerHandler.emailNotificationForPDKDeletion', e.getLineNumber(), e.getTypeName(), e.getMessage());
        }
    }

    //Method for getting Old and New Values for PDK Components
    public string getOldNewValuePDKComponent(PDK_Component__c bOld, PDK_Component__c bNew) {
        Map < String, Schema.SObjectField > schemaFieldMap = Schema.SObjectType.PDK_Component__c.fields.getMap();
        string st;
        try {
            list < selectOption > options = new list < selectoption > ();

            for (String fieldName: schemaFieldMap.keySet()) {
                if (bOld.get(fieldname) != bnew.get(fieldname)) {
                    if (fieldname != 'lastmodifieddate' && fieldname != 'lastmodifiedbyid' && fieldname != 'systemmodstamp') {
                        if (st == null) st = '<tr><td>' + ' ' + schemaFieldMap.get(fieldName).getDescribe().getlabel() + ' updated from  <b>' + bold.get(fieldName) + '</b> to <b>' + bnew.get(fieldName) + '</b></br></td></tr>' + ' ';
                        else st += '<tr><td>' + ' ' + schemaFieldMap.get(fieldName).getDescribe().getlabel() + ' updated from  <b>' + bold.get(fieldName) + '</b> to <b>' + bnew.get(fieldName) + '</b></br></td></tr>' + ' ';
                    }
                }
            }
            if (st == null) st = 'No fields are updated';
        } catch (Exception e) {
            CaseHandlerUtility.trackException('WorkRequestTriggerHandler.getOldNewValuePDKComponent', e.getLineNumber(), e.getTypeName(), e.getMessage());
        }
        return st;
    }

    //Method for sending email Notification on modifying Components
    public void emailNotificationForPDKUpdate(List < PDK_Component__c > newpdkList, Map < Id, PDK_Component__c > oldPdkMap) {
        try {
            string htmlBody, subject, strDocUrl;
            string gfDocId = System.Label.GF_Logo_Document_Id; // GF Logo Id 
            set < Id > userIds = new set < Id > ();
            strDocUrl = URL.getSalesforceBaseUrl().toExternalForm() + '/servlet/servlet.ImageServer?id=' + gfDocId + '&oid=' + UserInfo.getOrganizationId();
            for (PDK_Component__c objPDK: newpdkList) {
                PDK_Component__c objOldPDK = oldPdkMap.get(objPDK.Id);
                htmlBody = '<table><tr><td>' +
                    '<img id=r1sp1 src=' + strDocUrl + '></img>' + '</td></tr>' +
                    '<tr><td>Dear User,  <br><br></td></tr>' +
                    '<tr><td> This is to notify that PDK Component associated with  ' + objPDK.WR_No__c + ' has been updated by ' + Userinfo.getName() + ' recently. Below listed the changes made: <br><br> </td><tr> ' +
                    '<tr><td> ' + getOldNewValuePDKComponent(objOldPDK, objPDK) + ' <br></td></tr>' +
                    '<tr><td> Clicking on the link below, to view the PDK Request details: </td></tr>' +
                    '<tr><td>' + URL.getSalesforceBaseUrl().toExternalForm() + '/' + objPDK.WR_ID__c + '</td></tr><br><br>' +
                    '<tr><td>Thank You <br>' +
                    '</td></tr></table>';

                subject = 'WR[' + objPDK.WR_No__c + '] - Component Modified - ' + objPDK.WR_Short_Title__c;
                userIds = WorkRequestEmailHandler.getPDKRequestUserIdsLimited(objPDK.WR_ID__c);
                if (userIds != null && userIds.size() > 0) {
                    WorkRequestEmailHandler.sendActualEmailMessage(subject, htmlBody, userIds);
                }
            }
        } catch (Exception e) {
            CaseHandlerUtility.trackException('WorkRequestTriggerHandler.emailNotificationForPDKUpdate', e.getLineNumber(), e.getTypeName(), e.getMessage());
        }
    }
}