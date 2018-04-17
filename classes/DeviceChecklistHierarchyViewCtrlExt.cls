/*Author: Sreedhar Karukonda
    Description: This is a Controller Extension class for TaskRay Project object. 
    History:
    04222014     - code creation.
    05142014     - Updated Code to test updated requiremtns.
    07162014     - isAdmin, sortOrder, newTask instance variable are added. 
                   isAdmin drives Admins columns display in DeviceChecklistHierarcheyView. 
                   sortOrder drives new tasks sequence number in tasks list.
                   "insertTask" method is added. This method is called from ActionFunction for VF page to insert a Task
    Change Log:    Updated     -     JOYDEV     -     30/07/2014
               Reason: (*) User should be able to initiate sync job for opened checklist and we need to capture user click 
                           sync start date time in Last Sync Date field of the checklist.
                       (*) Header should show which ever is latest either scheduled sync job start time OR user initiated sync.
                    Updated     -     Sreedhar   -     10/02/2014 - Removed TASKRAY Application Objects Dependency
*/  

public without sharing class DeviceChecklistHierarchyViewCtrlExt{

    /*
    * Current device checklist details
    */
    public  Checklist_Container__c checklist{get; set;}
    public Checklist_Task__c newTask{
        get{
            if(newTask == null) newTask = new Checklist_Task__c();
            return newTask;
        }
        set;
    }

    /*
    * Display "N/A" Column and "Add Task" Column to only Admins
    */
    public boolean isAdmin{
        get{
            return DeviceChecklistUtils.canEditTemplate;
        }
        set;
    }
    
    /*
    * Current device checklist Id
    */
    public String projectId{get; set;}
    
    /*
    * New Tasks Sequence Number.
    */
    public Decimal sortOrder{get; set;}

    public PageReference insertTask(){
        newTask.Container__c = this.projectId;
        newTask.Sequence__c = this.sortOrder;
        insert newTask;
        newTask = new Checklist_Task__c();
        projectId = null;
        sortOrder = null;
        containerTree = null;
        return null;
    }

    /*
    * This varable is used show the chatter feed.
    */
    public id showFeedForTask{ get; set;}

    /*
    * This varable is used show the chatter feed.
    */
    public Checklist_Task__c showFeedForTaskRecord{
        get{
            List<Checklist_Task__c> tasks = null;
            if(showFeedForTask == null){
               tasks = [select id, Name,Deadline__c, Red_Flag__c, Current_Status__c, Days_Due_Before_TO__c, Dependent_Object__c, Dependent_Field__c, Dependent_Field_Completed_Value__c,
                                                        Override_Tapeout_Date__c, Device_TO_Date__c, Container__c, Container__r.Device__c, Dependency_Tootip__c, Completed_Date__c from Checklist_Task__c 
                                                        where Container__r.Program__c =:checklist.id limit 1]; 
            }else{
                tasks = [select id, Name,Deadline__c, Red_Flag__c, Current_Status__c, Days_Due_Before_TO__c, Dependent_Object__c, Dependent_Field__c, Dependent_Field_Completed_Value__c,
                                                        Override_Tapeout_Date__c, Device_TO_Date__c, Container__c, Container__r.Device__c, Dependency_Tootip__c, Completed_Date__c from Checklist_Task__c 
                                                        where Container__r.Program__c =:checklist.id  and id=:showFeedForTask limit 1]; 
            }
            if(tasks.size() > 0){
                showFeedForTaskRecord =  tasks[0];
            }else{
                showFeedForTaskRecord = null;
            }
            return showFeedForTaskRecord;
        } 
        set;
    }

    /*
    * This variable holds Current Device Checklist Details
    */
    public Checklist_Container__c programDetails {
        get{
            if(programDetails == null) {
                programDetails = [select id, Name, Archive_Project__c, Device__c, Opportunity_Program__c, Opportunity__c, Account__c, OwnerId, 
                                    DeviceChecklistLastSyncDate__c, BX_041__c
                                    from  Checklist_Container__c where id=: checklist.Id];
            }
            return  programDetails;
        }
        set;
    }

    /*
    * Constructor for Controller Etension
    */
    public DeviceChecklistHierarchyViewCtrlExt(ApexPages.StandardController stdCtrl){
        checklist = (Checklist_Container__c) stdCtrl.getRecord();
        if(checklist.id == null){
            throw new DeviceCheckListException('Checklist Id required in the url. Please contact System support.');
        }
    }

    public Map<Id,String> taskOwners{
        get{
            if(taskOwners == null) taskOwners = new Map<Id,String>();
            return taskOwners;
        }
        set;
    }
    
    /*
    * This is private varaible to hold reference to Model of all projects of Checklist 
    */
    Map<Id, DeviceChecklistContainerModel> localMap = new Map<Id, DeviceChecklistContainerModel>();

    /*
    * This is  varaible to hold reference to Model of Device Checklist.
    */
    public DeviceChecklistContainerModel containerTree{
        get{
            if(containerTree == null){
                syncTasksForChecklist(checklist.id);
                List<Checklist_Container__c> prjts = [select Id, Name, Archive_Project__c, Hierarchy_Level__c, Project_Start__c, Parent__c, Project_End__c, 
                (select id, Name, Dependent_Object__c, Red_Flag__c, Deadline__c,  Completed_Date__c, Not_Applicable__c,
                        Owner.name, OwnerId, Container__c, Is_Completed__c,Days_Due_Before_TO__c, Mandatory__c,
                        Container__r.Name, Status__c,  Override_Tapeout_Date__c,  Sequence__c, Dependency_Tootip__c, Container__r.Archive_Project__c from Checklist_Tasks__r 
                        where Not_Applicable__c = false order by Sequence__c asc NULLS LAST, CreatedDate asc, Name asc)
                from Checklist_Container__c where (Program__c = :checklist.id or Id=:checklist.id) and Not_Applicable__c = false order by Hierarchy_Level__c, Display_Sequence__c, Name  asc];
    
                for(Checklist_Container__c prj: prjts){ 
                    DeviceChecklistContainerModel tempModel;
                    if(prj.Parent__c == null){
                        DeviceChecklistContainerModel mdl = new DeviceChecklistContainerModel(prj);
                        localMap.put(prj.id, mdl);
                        containerTree = mdl;
                        tempModel = mdl;
                    }else{
                         DeviceChecklistContainerModel mdl = localMap.get(prj.Parent__c).addChild(prj);
                         localMap.put(prj.id, mdl);
                         tempModel = mdl;
                    }
                    if(prj.Checklist_Tasks__r != null && prj.Checklist_Tasks__r.size() > 0){
                        for(Checklist_Task__c task: prj.Checklist_Tasks__r ){
                            tempModel.addTask(task);
                            taskOwners.put(task.OwnerId, task.Owner.Name);
                        }  
                    }
                }
            }
            return containerTree;
        }
        set;
    }

    /*
    * This action method Saves edited tasks on "Save Edits" button
    */
    public PageReference saveEdits(){
        try{
            List<Checklist_Task__c> updatedTasks = new List<Checklist_Task__c>();
            for(DeviceChecklistContainerModel model :localMap.values()){
                if(model.rows != null){
                    for(DeviceChecklistContainerModel.TaskWrapper taskWrapper :model.rows){
                        if(taskWrapper.updated){
                            updatedTasks.add(taskWrapper.task);
                            System.debug(taskWrapper.task);
                        }
                    }
                }
            }
            if(updatedTasks.size() > 0){
                update updatedTasks;
                containerTree = null;
            }
            }catch(Exception ex){
                System.debug(ex);
                ApexPages.addMessages(ex);
            }
        return null;
    }

    /*
    * Remove Project from Devie Checklist. Marks a project and it decendents as not applicable for the Checklist. Invoked on Admin user click on "Remove" button in UI.
    */
    public Id projectToBeRemoved{get; set;}
    public PageReference removeProjectFromChecklist(){
        List<Checklist_Container__c> projectsNeedToMarkAsNotApplicable = [select Id, Not_Applicable__c, (select Id, Not_Applicable__c from Checklist_Tasks__r) from Checklist_Container__c
            where Id=:projectToBeRemoved OR Parent__c=:projectToBeRemoved OR Parent__r.Parent__c =:projectToBeRemoved
            OR Parent__r.Parent__r.Parent__c =:projectToBeRemoved
            OR Parent__r.Parent__r.Parent__r.Parent__c =:projectToBeRemoved
            OR Parent__r.Parent__r.Parent__r.Parent__r.Parent__c =:projectToBeRemoved
        ];
        List<Checklist_Container__c> projectsToUpdate = new List<Checklist_Container__c>();
        List<Checklist_Task__c> tasksToUpdate = new List<Checklist_Task__c>();
        for(Checklist_Container__c project: projectsNeedToMarkAsNotApplicable){
            projectsToUpdate.add(new Checklist_Container__c(Id= project.Id, Not_Applicable__c = true));
            for(Checklist_Task__c task: project.Checklist_Tasks__r){
                tasksToUpdate.add(new Checklist_Task__c(Id= task.Id, Not_Applicable__c = true));
            }
        }
        update projectsToUpdate;
        update tasksToUpdate;
        projectToBeRemoved= null;
        containerTree =null;
        return null;
    }

    /*Change Log:    Updated     -     JOYDEV     -     30/07/2014    -    begin     */
    /*
    * This action method syncs tasks with opportunity/device - auto-completion
    */
    public PageReference SyncTasks(){
        try{
            DeviceChecklistSyncTaskBatchUtil DCUtil = new DeviceChecklistSyncTaskBatchUtil();
            DCUtil.ChecklistId = checklist.Id;
            DCUtil.ExecuteUtil(Database.query(DCUtil.SOQLUtil()));            
        } catch(Exception ex) {
            System.debug(ex);
            ApexPages.addMessages(ex);
        }
        programDetails = Null;
        containerTree = null;
        return null;
    }

    /*Change Log:    Updated     -     JOYDEV     -     30/07/2014    -    begin     */
    /*
    * This action method syncs tasks with opportunity/device - auto-completion
    */
    public void syncTasksForChecklist(Id checklistId){
        try{
            DeviceChecklistSyncTaskBatchUtil DCUtil = new DeviceChecklistSyncTaskBatchUtil();
            DCUtil.ChecklistId = checklistId;
            DCUtil.ExecuteUtil(Database.query(DCUtil.SOQLUtil()));            
        } catch(Exception ex) {
            System.debug(ex);
            ApexPages.addMessages(ex);
        }
        programDetails = null;
        containerTree = null;
    }

    /*Change Log:    Updated     -     Sreedhar     -     07 Oct 2014    -    begin     *
    *
    * Archive a checklist once Device is end of life 
    */
    public PageReference archiveChecklist(){
        Checklist_Container__c container = new Checklist_Container__c(Id= checklist.Id, Archive_Project__c = true);
        update container;
        programDetails = null;
        containerTree = null;
        return null;
    }

    /*
    * Archive a checklist once Device is end of life 
    */
    public PageReference unarchiveChecklist(){
        Checklist_Container__c container = new Checklist_Container__c(Id= checklist.Id, Archive_Project__c = false);
        update container;
        programDetails = null;
        containerTree = null;
        return null;
    }

    /*
    * Generic Exception Class for any error.
    */
    public class DeviceCheckListException extends Exception{}
}