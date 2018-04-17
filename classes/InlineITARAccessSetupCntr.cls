/*
 * Author: Amit Kumar Ojha
 * Company: JK Technosoft Ltd
 * Description: Apex Controller Class on Portal Tab Access Object for notifying users on ITAR Apps Provision 
 * History:
 *   Amit Kumar Ojha	25072017	Initial Draft          
 *
 */
public with sharing class InlineITARAccessSetupCntr {
	//added an instance varaible for the standard controller
    private ApexPages.StandardController controller {get; set;}
    // the actual account
    public Portal_Tab_Access__c portalCon {get;set;}
    public Boolean isedit{get;set;}
    public string message {get;set;}
    public string disclaimer {get;set;}
    public Boolean disableEdit {get;set;}
    public String enableEditMessage {get; set;}
    // Accessing Custom Settings 
    Environment_Variable__c note;
    Environment_Variable__c restrictEdit;
            
    public InlineITARAccessSetupCntr(ApexPages.StandardController controller) {
        isedit = false;
        disableEdit = false;
        message = '';
        enableEditMessage = '';
        disclaimer = '';
        note = Environment_Variable__c.getInstance('ITAR Disclaimer');
        restrictEdit = Environment_Variable__c.getInstance('ITAR EDIT ACCESS SET UP');
        
        if(note.Value__c != null) {
        	disclaimer = note.Value__c;
        }
        //initialize the standard controller
        this.controller = controller;
        this.portalCon = (Portal_Tab_Access__c)controller.getRecord();
        List<Portal_Tab_Access__c> portalConList = [SELECT Id, Contact__c,Account__c, DropBox_ITAR__c, DropBox_non_ITAR__c	, TeamRoom_ITAR__c, Remote_Mask_Viewer_ITAR__c,
                                    Remote_Mask_Viewer_non_ITAR__c FROM Portal_Tab_Access__c WHERE Id =: portalCon.Id];
        portalCon =  portalConList[0];
    }
    
    /*
     * @ Method Name : validateAuthorization
     * @ Parameters : None
     * @ Return Type : None
     * @ Description : This method has been passed as the "action" attribute in the page and is used to validate for any authorized Users accessing the ITAR Apps Section
     *
     */
    public void validateAuthorization() {
        disableEdit = false;
        Contact c;
        Account acc = new Account();
        List<Portal_Tab_Access__c> portalContactList = new List<Portal_Tab_Access__c>();
        // Roles include Account Manager, Backup Customer Service Rep, Customer Service Rep, Primary Account Manager, FAE and Primary FAE
        List<ITAR_App_Provision_ATP_Roles__c>  customSetATPRoles = ITAR_App_Provision_ATP_Roles__c.getAll().values();
        Set<String> desiredTeamRoles = new Set<String>();
        
        if(!customSetATPRoles.isEmpty()) {
            for(ITAR_App_Provision_ATP_Roles__c eachCS : customSetATPRoles) {
                desiredTeamRoles.add(eachCs.Name);	    
            }
        }
        String portalConId = ApexPages.currentPage().getParameters().get('Id');
        
        if(portalConId != null)
        	portalContactList = [SELECT Id, Contact__c FROM Portal_Tab_Access__c WHERE Id =: portalCon.Id];
        String portalContactId;
        
        if(!portalContactList.isEmpty() && portalContactList[0].Contact__c != null)
        	portalContactId =  portalContactList[0].Contact__c; 
        
        if(portalContactId != null && portalContactId != '') {
        	c = [SELECT Id, ITAR_Certified__c FROM Contact WHERE Id =: portalContactId];
        	acc = getParentAccount(portalContactId);
        }
        
        
        if(!c.ITAR_Certified__c) {
        	disableEdit = true;
        	if(restrictEdit.Value__c != null) {
	        	enableEditMessage = restrictEdit.Value__c;
	        }
        } 
        Set<id> prmisonSetAssignSet = new Set<id>();
        
        List<PermissionSetAssignment> prmisonSetAssign = [SELECT AssigneeId,PermissionSetId FROM PermissionSetAssignment where PermissionSet.name = 'Restricted_International_Regulations'];
        if(!prmisonSetAssign.isEmpty()) {
	        for(PermissionSetAssignment psAP : prmisonSetAssign ){
	            if(psAP.AssigneeId != null) {
	            	prmisonSetAssignSet.add(psAP.AssigneeId);
	            }
	        }
    	}
        //Get all the Team Members with their Roles associated to the Account "acc"
        List<Account_Team_Proxy__c> accTeamMembers = new List<Account_Team_Proxy__c>();
        if(!desiredTeamRoles.isEmpty() && acc.Id != null) {
        	accTeamMembers = [SELECT Id, Name, Account__c,User__c, Team_Role__c FROM Account_Team_Proxy__c WHERE Account__c =: acc.Id];
        }
        
        User u = [SELECT Id, Name FROM User WHERE Id =: Userinfo.getUserId() AND isActive = true LIMIT 1];
        
        if(!accTeamMembers.isEmpty()) {
	        for (Account_Team_Proxy__c atp : accTeamMembers) {
	        	if(atp.Team_Role__c != null && atp.User__c != null && u != null && u.Id == atp.User__c) {
        			if(!desiredTeamRoles.contains(atp.Team_Role__c) && (!prmisonSetAssignSet.isEmpty() && !prmisonSetAssignSet.contains(u.Id))) {
        				message = 'You are not authorized to use/view this Section.';	
        			}	
	        	}	
	        }
        }
        
    }
    
    /*
     * @ Method Name : getParentAccount
     * @ Parameters : String
     * @ Return Type : Account
     * @ Description : This method returns the Account depending on the Contact Id being passed as a Parameter
     *
     */
    public Account getParentAccount(String contactId) {
        String accountId;
        Account a = new Account();
        List<Contact> conList = new List<Contact>();
        
        conList = [SELECT Id,AccountId From Contact WHERE Id =: contactId];
        
        if(!conList.isEmpty()) {
            for(Contact con : conList) {
                if(con.AccountId != null) {
                    accountId = con.AccountId;
                }
            }
        }
        if(accountId != null) {
        	a = [SELECT Id, Name FROM Account WHERE Id =: accountId];
        }    
        return a;
    }
    
    /*
     * @ Method Name : Edit
     * @ Parameters : None
     * @ Return Type : pageReference as Null
     * @ Description : This method returns the User to the ITAR Apps Section with all Editable Fields and a "Save" and "Cancel" button to update and save the record.
     *
     */
    public pagereference edit(){
        isedit = true;
        disableEdit = false;
        return null;
    }
    
    /*
     * @ Method Name : Cancel
     * @ Parameters : None
     * @ Return Type : pageReference as Null
     * @ Description : This method returns the User to the ITAR Apps Section with all Non-Editable Fields and an "Edit" to it.
     *
     */
    public pagereference cancel() {
    	isedit = false;
        return null;
    }
    
    /*
     * @ Method Name : save
     * @ Parameters : None
     * @ Return Type : pageReference as Null
     * @ Description : This method has the Save Functionality implemented for the ITAR Apps Section.
     *
     */
    public pageReference save() {
        disableEdit = false;
        update portalCon;
        isedit = false;
        return null;
    }   
}