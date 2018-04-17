/***************************************************************************************************************************
Class:         DeviceChecklistContainerModel
----------------------------------------------------------------------------------------------------------------------------
Author:        Sreedhar karukonda
Created Date:  14/08/2014
Reason:        This domain class for Data model in DeviceChecklistHierarchyView components

Change Log:    Created     -     Sreedhar     -     14/08/2014
                Updated     -     Sreedhar   -     10/02/2014 - Removed TASKRAY Application Objects Dependency
***************************************************************************************************************************/

public without sharing class DeviceChecklistContainerModel {
    public DeviceChecklistContainerModel(Checklist_Container__c prj){
            this.Name = prj.Name;
            this.startDt = prj.Project_Start__c;
            this.endDt = prj.Project_End__c;
            this.level = Integer.valueOf(prj.Hierarchy_Level__c);
            this.pid = prj.Id;
        }
        public Id pid{get; set;}
        public Integer level{get; set;}
        public String Name{get; set;}
        public Date startDt{get; set;}
        public Date endDt{get; set;}
        public List<DeviceChecklistContainerModel> chldContainer{get; set;}
        public List<TaskWrapper> rows{get; set;}
        public void addTask(Checklist_Task__c task){
            if(rows == null) rows = new List<TaskWrapper>();
            rows.add(new TaskWrapper(task, false));
        }
        public DeviceChecklistContainerModel addChild(Checklist_Container__c prj){
            if(chldContainer == null) chldContainer = new List<DeviceChecklistContainerModel>();
            DeviceChecklistContainerModel mdl = new DeviceChecklistContainerModel(prj);
            chldContainer.add(mdl);
            return mdl;
        }

        public class TaskWrapper{
            public TaskWrapper(Checklist_Task__c task, boolean updated){
                this.task = task;
                this.updated = updated;
            }
            public boolean updated{get; set;}
            public Checklist_Task__c task{get; set;}
        }
 }