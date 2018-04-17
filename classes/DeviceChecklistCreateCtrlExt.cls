/*Author: Sreedhar
    Description: This is a Controller Extension for Device used in DeviceChecklistCreateView.
    DeviceChecklistCreateView is used to select a template and Clone the template and assign it to the Device.
    DeviceChecklistCreateView is invoked from Button on Device Details page.
    History:
    03192014     - code creation.
    05142014     - Updated Code to test updated requiremtns.
    Updated     -     Sreedhar   -     10/02/2014 - Removed TASKRAY Application Objects Dependency
*/

public without sharing class DeviceChecklistCreateCtrlExt {
    public  Device__c devc {get; set;}
    public DeviceChecklistCreateCtrlExt(ApexPages.StandardController stdController){
        this.devc = (Device__c)stdController.getRecord();
        this.devc = [select id, Opportunity_Program__c, Opportunity__c, Account__c, Checklist__c,
                                Current_Forecast_Tapeout_Date__c, (select Id from BX_041__r) 
                                from Device__c where id=:devc.id];
    }

    /*
    * Message to show on the screen if non adimn try to create Checklist for a device
    */
    public boolean showMessage{
        get{
            return DeviceChecklistUtils.canEditTemplate;
        }
        set;
    }


    /*
    * This variable holds Current Device's Checklist ID.
    */
    public Id checklistId{get; set;}

    /*
    * This variable holds reference to Utility Object for Reports. Generated report is diplayed in Device Details page.
    */
    public DeviceChecklistReportsCtrlExt reportUtil {
        get{
            if(reportUtil == null) reportUtil = new DeviceChecklistReportsCtrlExt(devc.Checklist__c, null);
            return reportUtil;
        }
        set;
    }

    /*
    * This variable holds Selected TaskRay Project(Template) ID
    */
    public String selectedTemplateId{ get;  set; }

    public Map<Id, Checklist_Container__c> availableTemplates{
        get{
            if(availableTemplates == null){
                availableTemplates = new Map<id,Checklist_Container__c>([select id, type__c, subtype__c, name, OwnerId, Description__c  from Checklist_Container__c 
                                                    where Hierarchy_level__c = 0 and Type__c ='NPI Checklist' 
                                                          and Subtype__c='Checklist Template']);
            }
            return availableTemplates;
        }
        set;
    }

    /*
    * This variable holds Name for new Checklist.
    */
    public string newChecklistName{get; set;}

    /*
    * This variable holds Start Date for new Checklist.
    */
    public Date newChecklistStartDate{get; set;}

    /*
    * This variable holds End Date for new Checklist.
    */
    public Date newChecklistEndDate{get; set;}

    /*
    * Clone the selected Device Checklist Template and assign it to current Device
    */
    public pageReference cloneTemplateChecklist(){
        /*Map<String, String> cloneInfo = new Map<String, string>();
        DeviceChecklistUtils.deviceTapeoutDatePropagation = true;
        cloneInfo.put('projectId', selectedTemplateId);
        cloneInfo.put('newProjectName', newChecklistName);
        cloneInfo.put('cloneChildrenProjects', 'true');
        Id newProjectId = TaskRay.trController.cloneProjectReturnId_v2(cloneInfo);*/

        Map<String, String> checklistFieldsData = new Map<String, String>();

        checklistFieldsData.put('Device__c', devc.id);
        checklistFieldsData.put('Account__c', devc.Account__c);
        checklistFieldsData.put('Opportunity_Program__c', devc.Opportunity_Program__c);
        checklistFieldsData.put('Opportunity__c', devc.Opportunity__c);
        checklistFieldsData.put('Type__c', 'NPI Checklist');
        checklistFieldsData.put('SubType__c', 'Checklist');
        
        if(devc.BX_041__r != null && devc.BX_041__r.size() == 1){
            checklistFieldsData.put('BX_041__c', devc.BX_041__r[0].Id);
        }
        DeviceChecklistUtils.checklistCloningInProgress = true;
        Id newProjectId = DeviceChecklistCloneAPI.cloneHierarchey(selectedTemplateId,  newChecklistName, checklistFieldsData);
        DeviceChecklistUtils.checklistCloningInProgress = false;

        Device__c updateDeviceChecklist = new Device__c(id=devc.id, Checklist__c = newProjectId );
        update updateDeviceChecklist;
        updateOwnerAndDeadline(newProjectId, devc.Current_Forecast_Tapeout_Date__c);
        updateOwnersOfDeviceChecklist(newProjectId);
         DeviceChecklistSyncTaskBatchUtil DCUtil = new DeviceChecklistSyncTaskBatchUtil();
         DCUtil.ChecklistId = newProjectId;
         DCUtil.ExecuteUtil(Database.query(DCUtil.SOQLUtil())); 
         
        return new PageReference('/apex/DeviceChecklistHierarchyView?id='+newProjectId);
    }
    
    /*
    * This action function used save form data and submit it to server on "Select" Button Click.
    */
    public pageReference selectTemplate(){
        return null;
    }

    /*
    * This action function is invoked on Cancel button click.
    */
    public pageReference cancel(){
        selectedTemplateId = null;
        return null;
    }

    /*
    * User who can create checklist from template
    */

    public List<String> getUserWhoCanCreateChecklist(){
        PermissionSet Permission= null;
        List<PermissionSet> PersmissionsTemp = [SELECT Id,
                                                       Name, 
                                                       Label, 
                                                       ProfileId, 
                                                       Profile.Name 
                                                  FROM PermissionSet
                                                 WHERE Name = 'DeviceChecklist_Access'];
        
        if(PersmissionsTemp != Null && PersmissionsTemp.size() > 0) {    
            Permission = PersmissionsTemp[0];
        } else {
            /*show error message in the page if no permission exists of name passed in url parameter (?set=)*/
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 
                                 'No Permission set of name DeviceChecklist_Access exists!'));
            return null;
        }  
        
        /*fetch all permission set assignments related to 'Permission' fetched above*/               
        Map<Id, PermissionSetAssignment> PermissionSetAssignments = 
                new Map<Id, PermissionSetAssignment>([SELECT Id,
                                                             AssigneeId,
                                                             Assignee.Name,
                                                             PermissionSetId
                                                        FROM PermissionSetAssignment
                                                       WHERE PermissionSetId = :Permission.Id AND
                                                             Assignee.IsActive = TRUE]);   
        
        /*temporary list of assignee ids in 'PermissionSetAssignments' fetched above*/
        List<Id> PermissionSetAssignmentAssigneeIds = new List<Id>();
        
        /*populate assignee ids in 'PermissionSetAssignments' from 'PermissionSetAssignments' fetched above*/
        for(PermissionSetAssignment perAsgn : PermissionSetAssignments.values()) {
            PermissionSetAssignmentAssigneeIds.add(perAsgn.AssigneeId);
        }

        Map<Id, GF_TaskRay_Project_NPI_Editors__c> npiEditorsMap = new Map<Id, GF_TaskRay_Project_NPI_Editors__c>([SELECT Id,
                                                                       SetupOwnerId, SetupOwner.Name,
                                                                       NPI_Project_Template_Editable__c
                                                                  FROM GF_TaskRay_Project_NPI_Editors__c
                                                                 WHERE SetupOwnerId IN :PermissionSetAssignmentAssigneeIds and 
                                                                 NPI_Project_Template_Editable__c = true]);  
        List<String> editorsList = new List<String>();
        for(GF_TaskRay_Project_NPI_Editors__c npiEditorSetting: npiEditorsMap.values()){
            editorsList.add(npiEditorSetting.SetupOwner.Name);
        }
        return editorsList;
    }

    /*
    * Update Task Owner to current user and Update Day to TO
    */

    public void updateOwnerAndDeadline(Id dcid, Date DeviceCurrentForecastedDate){
        List<Checklist_Task__c> newDCTasks = [select Id, OwnerId, Days_Due_Before_TO__c from Checklist_Task__c where Container__r.Program__c =: dcid];
        for(Checklist_Task__c task: newDCTasks){
            task.ownerId = UserInfo.getUserId();
            if(DeviceCurrentForecastedDate != null){
                task.Deadline__c = DeviceCurrentForecastedDate - Integer.valueOf(task.Days_Due_Before_TO__c);
            } 
        }
        update newDCTasks;
    }

    /*
    *   Update Project Owners created user
    */

    public void updateOwnersOfDeviceChecklist(Id dcid){
        List<Checklist_Container__c> newDCprojects = [select Id, OwnerId from Checklist_Container__c where Program__c =: dcid];
        for(Checklist_Container__c project: newDCprojects){
            project.ownerId = UserInfo.getUserId();
        }
        update newDCprojects;
    }
}