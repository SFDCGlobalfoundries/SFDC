/**************************************************************************************************************************
Class:         DeviceChecklistAdminConsoleController
---------------------------------------------------------------------------------------------------------------------------
Author:        Joydev Mondol (Cognizant - 153480)
Created Date:  08/05/2014
Reason:        Controller class that provides logic and communication between the Visualforce page: 
               "DeviceChecklistAdminConsole" and the records of standard salesforce setup objects: 
               "Custom Setting" and "Permission Set"

Change Log:    Created     -     JOYDEV     -     08/05/2014   
Change Log:    Updated     -     JOYDEV     -     25/05/2014                
               [Reason] Need to block external users being displayed in the search user dropdown.             
**************************************************************************************************************************/

public with sharing class DeviceChecklistAdminConsoleController {

    /*master list of wrapper class DeviceChecklistUser to display user assignments*/
    public Map<Id, DeviceChecklistUser> DeviceChecklistUsers { get; set; }
    
    /*target user to act upon: target user to: (1)assign, (2)change admin and (3)remove assignment*/
    public String TargetUser { get; set; }
    
    /*permission set fetched with API name passed in url parameter: 'set'*/
    public PermissionSet Permission {get; set;}
    
    /*optional filter condition for autocomplete component*/
    public String OpFilter { get; set; }
    
    /** 
    *  Constructor:    DeviceChecklistAdminConsoleController
    *  args:           none
    *  purpose:        this constructor does the following: 
    *                      (1) fetches the permission set with API name passed on in url parameter (?set=)
    *                      (2) fetches the permission set assignments for the permission set in url parameter 
    *                      (3) constucts the optional filter fot the autocomlete component
    *                      (4) fetches the CustomSettings (GF TaskRay Project NPI Editors) for all the assigned 
    *                          users of the permission set in url parameter
    *                      (5) populates the master table
    *                      (6) re-renders the AJAX region in the page to refresh the table 
    **/
    public DeviceChecklistAdminConsoleController() {
        DeviceChecklistUsers = new Map<Id, DeviceChecklistUser>();
        
        String PerSetAPIName = ApexPages.currentPage().getParameters().get('Set');
        
        List<PermissionSet> PersmissionsTemp = [SELECT Id,
                                                       Name, 
                                                       Label, 
                                                       ProfileId, 
                                                       Profile.Name 
                                                  FROM PermissionSet
                                                 WHERE Name = :PerSetAPIName];
        
        if(PersmissionsTemp != Null && PersmissionsTemp.size() > 0) {    
            Permission = PersmissionsTemp[0];
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 
                                 'No Permission set of name \"' + PerSetAPIName.replace('_', ' ') + '\" exists!'));
            return;
        }  
        
        Map<Id, PermissionSetAssignment> PermissionSetAssignments = 
                new Map<Id, PermissionSetAssignment>([SELECT Id,
                                                             AssigneeId,
                                                             Assignee.Name,
                                                             PermissionSetId
                                                        FROM PermissionSetAssignment
                                                       WHERE PermissionSetId = :Permission.Id /*AND
                                                             Assignee.IsActive = TRUE AND
                                                             Assignee.Profile.UserType = 'Standard'*/]);   
        
        List<Id> PermissionSetAssignmentAssigneeIds = new List<Id>();
        
        for(PermissionSetAssignment perAsgn : PermissionSetAssignments.values()) {
            PermissionSetAssignmentAssigneeIds.add(perAsgn.AssigneeId);
        }
        
        /*block external users*/
        OpFilter = Label.DeviceChecklist_User_Access_Filter;
        
        Map<Id, GF_TaskRay_Project_NPI_Editors__c> CustomSettings = 
            new Map<Id, GF_TaskRay_Project_NPI_Editors__c>([SELECT Id,
                                                                   SetupOwnerId,
                                                                   NPI_Project_Template_Editable__c
                                                              FROM GF_TaskRay_Project_NPI_Editors__c
                                                             WHERE SetupOwnerId IN :PermissionSetAssignmentAssigneeIds]);        
        
        for(PermissionSetAssignment perSetAsgn : PermissionSetAssignments.values()) {
            GF_TaskRay_Project_NPI_Editors__c npiEditor = 
                new GF_TaskRay_Project_NPI_Editors__c(SetupOwnerId = perSetAsgn.AssigneeId);
            
            for(GF_TaskRay_Project_NPI_Editors__c npiEdit : CustomSettings.values())  {
                if(npiEdit.SetupOwnerId == perSetAsgn.AssigneeId) {
                    npiEditor = npiEdit;
                    break;
                }
            }
            
            DeviceChecklistUsers.put(perSetAsgn.AssigneeId, new DeviceChecklistUser(perSetAsgn, npiEditor));
        }
    }
    
    /** 
    *  method:         AddUser
    *  args:           none
    *  return type:    PageReference 
    *  purpose:        this method assigns a new user searched in the search component: 
    *                      (1) inserts a new PermissionSetAssignment record
    *                      (2) searhes for existing custom setting (GF TaskRay Project NPI Editors) for the new user if any
    *                      (3) creates and new custom setting (GF TaskRay Project NPI Editors) record if does 
    *                          not exist for the new user
    *                      (4) adds an entry to the master list 'DeviceChecklistUsers'
    *                      (5) re-renders the AJAX region in the page to refresh the table
    *                      (6) catches exceptions and shows error messages in the message component of the page 
    **/
    public PageReference AddUser() {
        try {
            /*look for existing PermissionSetAssignment for the user selected in the search component 
              (stored in 'TargetUser')*/
            PermissionSetAssignment newAssignment ;
            List<PermissionSetAssignment> newAssignments = [SELECT Id,
                                                                    AssigneeId,
                                                                    Assignee.Name,
                                                                    PermissionSetId
                                                               FROM PermissionSetAssignment
                                                              WHERE AssigneeId =: TargetUser AND
                                                                    PermissionSetId =: Permission.Id];
            
            if(newAssignments == null || newAssignments.size() == 0) {
                newAssignment = new PermissionSetAssignment(AssigneeId = TargetUser, PermissionSetId = Permission.Id);
                insert newAssignment;
                
                newAssignment =  [SELECT Id,
                                         AssigneeId,
                                         Assignee.Name,
                                         PermissionSetId
                                    FROM PermissionSetAssignment
                                   WHERE Id = :newAssignment.Id];
                                       
                GF_TaskRay_Project_NPI_Editors__c custSet;
                List<GF_TaskRay_Project_NPI_Editors__c> custSets = [SELECT Id,
                                                                           SetupOwnerId,
                                                                           NPI_Project_Template_Editable__c
                                                                      FROM GF_TaskRay_Project_NPI_Editors__c
                                                                     WHERE SetupOwnerId =: TargetUser];
                if(custSets == Null || custSets.size() == 0){
                    custSet = new GF_TaskRay_Project_NPI_Editors__c(SetupOwnerId = TargetUser);
                } else {
                    custSet = custSets[0];
                }
                
                DeviceChecklistUsers.put(newAssignment.AssigneeId, new DeviceChecklistUser(newAssignment, custSet));
            } else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 
                                                           DeviceChecklistUsers.get(TargetUser).PerSetAsgn.Assignee.Name 
                                                           + ' is already assigned.'));
            }
        } catch (Exception e) /*handle common exceptions*/ {
            if(e.getTypeName() == 'System.StringException') {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 
                                     'Please select or enter a valid user.'));
            }
        } 
        
        TargetUser = '';
        return null;
    }
    
    /** 
    *  method:         RemoveUser
    *  args:           none
    *  return type:    PageReference 
    *  purpose:        this method removes user assignments from the permission set 'Permission' when user clicks 
                       the 'Remove' link in the 'Action' column: 
    *                      (1) removes the entry from the master table
    *                      (2) deletes the PermissionSetAssignment record for the selected row
    *                      (3) catches exceptions and shows error messages in the message component of the page
    *                      (4) re-renders the AJAX region in the page to refresh the table
    **/
    public PageReference RemoveUser() {
        try {
            delete DeviceChecklistUsers.remove(ApexPages.currentPage().getParameters().get('TargetUser')).PerSetAsgn;
        } catch (Exception e) /*handle common exceptions*/ {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, e.getMessage()));
        }
        
        TargetUser = '';
        return null;
    }
    
    /** 
    *  method:         ChangeAdmin
    *  args:           none
    *  return type:    PageReference 
    *  purpose:        this method toggles the admin access for users in the master table when user clicks the 
    *                  checkbox in the 'Admin' column:
    *                      (1) toggles the field 'NPI_Project_Template_Editable__c' of the custom setting for 
    *                          the user selected
    *                      (2) upserts the custom setting (GF TaskRay Project NPI Editors)
    *                      (3) catches exceptions and shows error messages in the message component of the page
    *                      (4) re-renders the AJAX region in the page to refresh the table
    **/
    public PageReference ChangeAdmin() {
        try {
            /*upsert the custom setting (GF TaskRay Project NPI Editors) with updated field
              'NPI_Project_Template_Editable__c'*/
            upsert DeviceChecklistUsers.get(ApexPages.currentPage().getParameters().get('TargetUser')).NPIEditor;
        } catch (Exception e) /*handle common exceptions*/ {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, e.getMessage()));
        }
        
        TargetUser = '';
        return null;
    }
    
    /** 
    *   Wrapper Class (Inner) for Device Checklist Users that holds infromation from both 
    *   Persmission Set and Custom Setting Objects
    **/
    public class DeviceChecklistUser {
        public String UserId { get; set; }
        
        public PermissionSetAssignment PerSetAsgn { get; set; }
        
        public GF_TaskRay_Project_NPI_Editors__c NPIEditor { get; set; }
        
        /** 
        *  constructor:    DeviceChecklistUser
        *  args:           UserId
        *  purpose:        (1) initiates UserId with the value passed in 'UserId' argument
        **/
        public DeviceChecklistUser(Id UserId) {
            this.UserId = UserId;
        }
        
        /** 
        *  constructor:    DeviceChecklistUser
        *  args:           PerSetAsgn
        *  purpose:        (1) initiates PerSetAsgn with the value passed in 'PerSetAsgn' argument
        *                  (2) initiates UserId with the assingee id value passed in 'PerSetAsgn' argument
        **/
        public DeviceChecklistUser(PermissionSetAssignment PerSetAsgn) {
            this.UserId = PerSetAsgn.AssigneeId;
            this.PerSetAsgn = PerSetAsgn;
        }
        
        /** 
        *  constructor:    DeviceChecklistUser
        *  args:           NPIEditor
        *  purpose:        (1) initiates NPIEditor with the value passed in 'NPIEditor' argument
        *                  (2) initiates UserId with the setup owner id value passed in 'NPIEditor' argument
        **/
        public DeviceChecklistUser(GF_TaskRay_Project_NPI_Editors__c NPIEditor) {
            this.UserId = NPIEditor.SetupOwnerId;
            this.NPIEditor = NPIEditor;
        }
        
        /** 
        *  constructor:    DeviceChecklistUser
        *  args:           PerSetAsgn, NPIEditor
        *  purpose:        (1) initiates PerSetAsgn with the value passed in 'PerSetAsgn' argument
        *                  (2) initiates NPIEditor with the value passed in 'NPIEditor' argument
        *                  (3) initiates UserId with the assignee id value passed in 'PerSetAsgn' argument
        **/
        public DeviceChecklistUser(PermissionSetAssignment PerSetAsgn, GF_TaskRay_Project_NPI_Editors__c NPIEditor) {
            this.UserId = PerSetAsgn.AssigneeId;
            this.PerSetAsgn = PerSetAsgn;
            this.NPIEditor = NPIEditor;
        }
    }
}