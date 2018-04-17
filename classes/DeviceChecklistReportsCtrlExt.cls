/*Author: Sreedhar Karukonda
    Description: This is a Controller Extension class for TaskRay Project object used in DeviceChecklistOpptyReportView Page.
    
    History:
    Created     -     05142014     - code creation.
    Updated     -     Sreedhar   -     10/02/2014
                [Reason]   Removed TASKRAY Application Objects Dependency   
*/

public without sharing class DeviceChecklistReportsCtrlExt {
    public boolean checklistReportView{
        get{if(checklistReportView == null) checklistReportView = true; return checklistReportView;}
        set;
    }

    /*
    * Switch to Opportunity Report View
    */
    public PageReference switchToReportToOpptyReport(){
        checklistReportView = false;
        return null;
    }

    /*
    * Switch Device Checlist Report
    */
    public PageReference switchToReportToChecklistReport(){
        checklistReportView = true;
        return null;
    }
    /*
    * Holds Current Device's Checklist Id
    */
    private final Checklist_Container__c checklist;

    public DeviceChecklistReportsCtrlExt(ApexPages.StandardController stdController) {
        this.checklist = (Checklist_Container__c)stdController.getRecord();
    }

    public DeviceChecklistReportsCtrlExt(Id checklistId, Id opptyId){
        checklist = new Checklist_Container__c(id=checklistId, Opportunity__c=opptyId);
    }

    /*
    * Holds all projects of the Device Checklist
    */
    public Checklist_Container__c programDetails {
        get{
            if(programDetails == null) {
                programDetails = [select id, Name, Archive_Project__c, Device__c, Opportunity_Program__c, Opportunity__c, Opportunity__r.Name, Account__c, OwnerId from  Checklist_Container__c where id=: checklist.Id];
            }
            return  programDetails;
        }
        set;
    }

    /*
    * Map between User Id and User Statistcis
    */ 
    public map<id, UserStats> userStatsMap{
        get{
            if(userStatsMap == null) userStatsMap = new Map<id, UserStats>();
            return userStatsMap;
        }
        set;
    }

    /*
    * Project Statics Model
    */
    public class ThisProjectStatus{
        public ThisProjectStatus(id pid){
            this.pid = pid;
        }
        public id pid{get; set;}
        public Integer total {get{ if(total == null) total = 0; return total;} set;}
        public Integer dueSoon{get{ if(dueSoon == null) dueSoon = 0; return dueSoon;} set;}
        public Integer overdue{get{ if(overdue == null) overdue = 0; return overdue;} set;}
        public Integer due{get{ if(due == null) due = 0; return due;} set;}
        public Integer flagged{get{ if(flagged == null) flagged = 0; return flagged;} set;}
        public Integer closed{get{ if(closed == null) closed = 0; return closed;} set;}
        public void addStatus(String status){
            if(status == 'Closed'){
                this.closed = this.closed + 1;
                this.total = this.total + 1;
            }else if(status == 'Open'){
                this.due = this.due + 1;
                this.total = this.total + 1;
            }else if(status == 'Over Due - Flagged'){
                this.overdue = this.overdue + 1;
                this.flagged = this.flagged + 1;
                this.total = this.total + 1;
            }else if(status == 'Over Due'){
                this.overdue = this.overdue + 1;
                this.total = this.total + 1;
            }else if(status == 'Due Soon - Flagged'){
                this.dueSoon = this.dueSoon + 1;
                this.flagged = this.flagged + 1;
                this.total = this.total + 1;
            }else if(status == 'Due Soon'){
                this.dueSoon = this.dueSoon + 1;
                this.total = this.total + 1;
            }else if(status == 'Flagged'){
                this.flagged = this.flagged + 1;
                this.due = this.due + 1;
                this.total = this.total + 1;
            }
        }

        public void addChild(ThisProjectStatus child){
            this.due = this.due + child.due;
            this.overdue = this.overdue + child.overdue;
            this.dueSoon = this.dueSoon + child.dueSoon;
            this.flagged = this.flagged + child.flagged;
            this.total = this.total + child.total;
            this.closed = this.closed + child.closed;
        }

        public Integer getProgress(){
            if(total != 0){
                return (this.closed * 100)/this.total;
            }else return 100;
        }
    }

    /*
    * Convert Task Status to User Statiscs Items
    */
    public void addUserStats(Checklist_Task__c task){
        if(userStatsMap.get(task.OwnerId) != null){
            userStatsMap.get(task.OwnerId).addTaskStats(task);
        }else{
            userStatsMap.put(task.OwnerId, new UserStats(task.Owner.Name));
            userStatsMap.get(task.OwnerId).addTaskStats(task);
        }
    }

    /*
    * Get Current Device's Checklist Statistics
    */
    public  Map<Id, ThisProjectStatus> getProjectsStatus(){
        return getProjectsStatus(checklist.Id);
    }

    /*
    * Calculates given projects statistics
    */
    public  Map<Id, ThisProjectStatus> getProjectsStatus(Id checklistId){
        userStatsMap = new Map<id, UserStats>();
        List<Checklist_Container__c> prjs = 
                [select id, OwnerId, Owner.Name, Parent__c, Parent__r.Parent__c, 
                Parent__r.Parent__r.Parent__c,
                Parent__r.Parent__r.Parent__r.Parent__c,
                Parent__r.Parent__r.Parent__r.Parent__r.Parent__c,
                (select id, Task_Status__c, OwnerId, Owner.Name, Deadline__c, Completed_Date__c  from Checklist_Tasks__r where Not_Applicable__c = false) from Checklist_Container__c 
                where (Program__c =:checklistId OR Id=:checklistId) and Not_Applicable__c = false order by Hierarchy_Level__c asc];
        Map<Id, ThisProjectStatus> mapstatus = new Map<Id, ThisProjectStatus>();
        for(Checklist_Container__c prj : prjs){
            ThisProjectStatus thisstatus = new ThisProjectStatus(prj.id);
            for(Checklist_Task__c task: prj.Checklist_Tasks__r){
                thisstatus.addStatus(task.Task_Status__c);
                this.addUserStats(task);
            }
            mapstatus.put(prj.id, thisstatus);

            if(prj.Parent__c != null){
                mapstatus.get(prj.Parent__c).addChild(thisstatus);
                if(prj.Parent__r.Parent__c != null){
                    mapstatus.get(prj.Parent__r.Parent__c).addChild(thisstatus);
                    if(prj.Parent__r.Parent__r.Parent__c != null){
                        mapstatus.get(prj.Parent__r.Parent__r.Parent__c).addChild(thisstatus);
                        if(prj.Parent__r.Parent__r.Parent__r.Parent__c != null){
                            mapstatus.get(prj.Parent__r.Parent__r.Parent__r.Parent__c).addChild(thisstatus);
                            if(prj.Parent__r.Parent__r.Parent__r.Parent__r.Parent__c != null){
                                mapstatus.get(prj.Parent__r.Parent__r.Parent__r.Parent__r.Parent__c).addChild(thisstatus);
                            }
                        }
                    }
                }
            }            
        }
        return mapstatus;
    }

    /*
    * Holds all Device Checklists related to Current Device's Opportunity
    */ 
    public Map<id, Checklist_Container__c> allOpportunityDeviceChecklists{
        get{
            if(allOpportunityDeviceChecklists == null) {
                //allOpportunityDeviceChecklists = new Map<id, Checklist_Container__c>();
                allOpportunityDeviceChecklists = new Map<id, Checklist_Container__c>([select id, Name, Device__r.Name from Checklist_Container__c where 
                        Opportunity__c =: programDetails.Opportunity__c and Hierarchy_Level__c = 0 and Device__c != null]);
            }
            return allOpportunityDeviceChecklists;
        }
        set;
    }

    /*
    * Calculates statistics of the current Device Checklist's opportunity
    */
    public List<ThisProjectStatus> getOpportunityChecklistsStatus(){
        if(programDetails.Opportunity__c != null){
            return getOpportunityChecklistsStatus(programDetails.Opportunity__c);
        }else{
            return null;
        }

        
    }

    /*
    * Calculats statistics of the given Opprotunity Device Checklists
    */
    public List<ThisProjectStatus> getOpportunityChecklistsStatus(id opptyId){
        List<Checklist_Task__c>  allOptyTasks = [select OwnerId, Task_Status__c, Container__r.Program__c from Checklist_Task__c
                                                                where Container__r.Program__r.Opportunity__c =: opptyId and 
                                                                Container__r.Program__r.Device__c != null and Not_Applicable__c = false];
        Map<Id, ThisProjectStatus> statusMap = new Map<Id, ThisProjectStatus>();
        for(Checklist_Task__c task : allOptyTasks){
            if(statusMap.get(task.Container__r.Program__c) != null){
                statusMap.get(task.Container__r.Program__c).addStatus(task.Task_Status__c);
            }else{
                statusMap.put(task.Container__r.Program__c, new ThisProjectStatus(task.Container__r.Program__c));
                statusMap.get(task.Container__r.Program__c).addStatus(task.Task_Status__c);
            }
        }
        return statusMap.values();
    }

    /*
    * Holds current project statics including Hierarchey 
    */
    public TreeeModel programTree{
        get{
            if(programTree == null){
                Map<Id, ThisProjectStatus> statusMap = getProjectsStatus();
                List<Checklist_Container__c> projectsInProgram = 
                    [Select Id, Name, Hierarchy_level__c, Parent__c, Archive_Project__c from Checklist_Container__c 
                            where (id=:checklist.Id or Program__c=:checklist.Id) and Not_Applicable__c = false  order by
                            Hierarchy_level__c, Name asc];
                Map<Id, TreeeModel> ptree = new Map<Id, TreeeModel>();
                for ( Checklist_Container__c project : projectsInProgram) {
                    if(project.Parent__c != null && ptree.get(project.Parent__c) != null){
                        TreeeModel cTree = ptree.get(project.Parent__c).addChild(project, statusMap.get(project.id));
                        ptree.put(project.id, cTree);
                    }else{
                        TreeeModel ptr = new TreeeModel(project, statusMap.get(project.id));
                        ptree.put(project.id, ptr);
                    }
                }
                programTree = ptree.get(checklist.Id);
            }
            
            return programTree;
        } 
        set;
    }

    /*
    * Project Hierarchey model holds all projects statistics
    */
    public class TreeeModel{
        public id pid{get; set;}
        public String name{get; set;}
        public List<TreeeModel> children{ get; set;}
        public ThisProjectStatus  status{ get; set;}
        public TreeeModel(Checklist_Container__c project, ThisProjectStatus sts){
            this.name = project.Name;
            this.pid= project.id;
            this.status = sts;
        } 

        public TreeeModel addChild(Checklist_Container__c project, ThisProjectStatus sts){
            if(children == null)  children = new List<TreeeModel>();
            TreeeModel model = new TreeeModel(project, sts);
            children.add(model);
            return model;
        }
    }
    /*
    * User Statistics Model
    */

    public class UserStats{
        public UserStats(String userName){
            this.userName = userName;
        }
        public String userName{get; set;}
        public Integer total{get{if(total == null) total =0; return total;} set;}
        public Integer noOfClosed{get{if(noOfClosed == null) noOfClosed =0; return noOfClosed;} set;}
        public Integer noOfDue{get{if(noOfDue == null) noOfDue =0; return noOfDue;} set;}
        public Integer noOfDueSoon{get{if(noOfDueSoon == null) noOfDueSoon =0; return noOfDueSoon;} set;}
        public Integer noOfOverdue{get{if(noOfOverdue == null) noOfOverdue =0; return noOfOverdue;} set;}
        public Integer noOfFlagedOpen{get{if(noOfFlagedOpen == null) noOfFlagedOpen =0; return noOfFlagedOpen;} set;}
        public Integer totalMissedDeadline{get{if(totalMissedDeadline == null) totalMissedDeadline =0; return totalMissedDeadline;} set;}
        public Long totalMissedDeadlineDays{get{if(totalMissedDeadlineDays == null) totalMissedDeadlineDays =0; return totalMissedDeadlineDays;} set;}
        public void addTaskStats(Checklist_Task__c task){
            if(task.Task_Status__c == 'Closed'){
                this.noOfClosed = this.noOfClosed + 1;
                this.total = this.total + 1;
                if(task.Completed_Date__c != null && task.Deadline__c != null){
                    // Calculate Deadline missed by Days
                    Long lateBy = task.Deadline__c.daysBetween(task.Completed_Date__c);
                    if(lateBy > 0){
                        totalMissedDeadlineDays = totalMissedDeadlineDays + lateBy;
                        this.totalMissedDeadline = this.totalMissedDeadline + 1;
                    }
                }
            }else if(task.Task_Status__c == 'Open'){
                this.noOfDue = this.noOfDue + 1;
                this.total = this.total + 1;
            }else if(task.Task_Status__c == 'Over Due - Flagged'){
                this.noOfOverdue = this.noOfOverdue + 1;
                this.noOfFlagedOpen = this.noOfFlagedOpen + 1;
                // Deadline Missed
                this.totalMissedDeadline = this.totalMissedDeadline + 1;
                // Calculate Deadline missed by Days
                Long lateBy = task.Deadline__c.daysBetween(Date.today());
                totalMissedDeadlineDays = totalMissedDeadlineDays + lateBy;

                this.total = this.total + 1;
            }else if(task.Task_Status__c == 'Over Due'){
                this.noOfOverdue = this.noOfOverdue + 1;
                // Deadline Missed
                this.totalMissedDeadline = this.totalMissedDeadline + 1;
                // Calculate Deadline missed by Days
                Long lateBy = task.Deadline__c.daysBetween(Date.today());
                totalMissedDeadlineDays = totalMissedDeadlineDays + lateBy;
                this.total = this.total + 1;
            }else if(task.Task_Status__c == 'Due Soon - Flagged'){
                this.noOfDueSoon = this.noOfDueSoon + 1;
                this.noOfFlagedOpen = this.noOfFlagedOpen + 1;
                this.total = this.total + 1;
            }else if(task.Task_Status__c == 'Due Soon'){
                this.noOfDueSoon = this.noOfDueSoon + 1;
                this.total = this.total + 1;
            }else if(task.Task_Status__c == 'Flagged'){
                this.noOfFlagedOpen = this.noOfFlagedOpen + 1;
                this.noOfDue = this.noOfDue + 1;
                this.total = this.total + 1;
            }
        }

        public Integer getAvgLate(){
            if(totalMissedDeadlineDays == 0) return 0;
            else return Integer.valueOf(this.totalMissedDeadlineDays/totalMissedDeadline);
        }
    }

}