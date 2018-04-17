/*
 * Author: Amit Kumar Ojha
 * Company: JK Technosoft Ltd
 * Description: Apex Controller Class on Contact Object for notifying users on Documents getting Verified, Creating Case on ITAR Access Requested check for ITAR Apps Provision 
 * History:
 *   Amit Kumar Ojha	31072017	Initial Draft          
 *   Dinesh Suggala     12032018    added validation message on save
 */
public with sharing class InlineContactITARAppsExtCntr {
	//added an instance varaible for the standard controller
    private ApexPages.StandardController controller {get; set;}
    // the actual account
    public Contact con {get;set;}
    public Boolean isedit{get;set;}
    public String message {get;set;}
    public String disclaimer {get;set;}
    // Accessing Custom Settings Data
    Error_Codes__c portalUserErrorCode;
    Error_Codes__c documentsCertifiedErrorCode;
    Error_Codes__c retrictedUsers;
    Environment_Variable__c note;
    public String caseId {get; set;}
    public Case cs;
    
    public InlineContactITARAppsExtCntr(ApexPages.StandardController controller) {
        isedit = false;
        message = '';
        disclaimer = '';
        //disclaimer = 'Note : Only Account Managers, CSRs or FAEs have the access to view this section.';
        portalUserErrorCode = Error_Codes__c.getInstance('ITAR CERTIFIED IF PORTAL USER');
        documentsCertifiedErrorCode = Error_Codes__c.getInstance('ITAR CERTIFIED IF DOCUMENTS VERIFIED');
        retrictedUsers = Error_Codes__c.getInstance('ITAR APPS RESTRICTION');
        note = Environment_Variable__c.getInstance('ITAR Disclaimer');
        
        if(note.Value__c != null) {
        	disclaimer = note.Value__c;
        }
        //initialize the standard controller
        this.controller = controller;
        this.con = (Contact)controller.getRecord();
        List<Contact> contactList = [SELECT Id, AccountId, Is_Portal_User_Active__c, ITAR_Certified__c, ITAR_Access_Requested__c, ITAR_Case_Number__c, ITAR_Documents_Verified__c,
                                    ITAR_Enabled_Date__c FROM Contact WHERE Id =: con.Id];
        con =  contactList[0];  
        
        if(!Test.isRunningTest()) {
            if(con.ITAR_Case_Number__c != null) {
	        	cs = [SELECT Id FROM Case WHERE CaseNumber =: con.ITAR_Case_Number__c];
	        }
	        if(cs != null) {
	        	caseId = cs.Id;
	        }
        } else {
        	caseId = 'TEST';
        }
    }
    
    /*
     * @ Method Name : validateAuthorization
     * @ Parameters : None
     * @ Return Type : None
     * @ Description : This method has been passed as the "action" attribute in the page and is used to validate for any authorized Users accessing the ITAR Apps Section
     *
     */
    public void validateAuthorization() {
        String accountId;
        // Roles include Account Manager, Backup Customer Service Rep, Customer Service Rep, Primary Account Manager, FAE and Primary FAE
        List<ITAR_App_Provision_ATP_Roles__c>  customSetATPRoles = ITAR_App_Provision_ATP_Roles__c.getAll().values();
        Set<String> desiredTeamRoles = new Set<String>();
        
        if(!customSetATPRoles.isEmpty()) {
            for(ITAR_App_Provision_ATP_Roles__c eachCS : customSetATPRoles) {
                desiredTeamRoles.add(eachCs.Name);	    
            }
        }
        String conId = ApexPages.currentPage().getParameters().get('Id');
        
        if(conId != null && conId != '') {
        	accountId = con.AccountId;
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

        if(!desiredTeamRoles.isEmpty() && accountId != null) {	
        	accTeamMembers = [SELECT Id, Name, User__c, Account__c, Team_Role__c FROM Account_Team_Proxy__c WHERE Account__c =: accountId];
        }
		// Get the Logged in User	
        User u = [SELECT Id, Name FROM User WHERE Id =: Userinfo.getUserId() AND IsActive = true LIMIT 1];
        
        if(!accTeamMembers.isEmpty()) {
	        for (Account_Team_Proxy__c atp : accTeamMembers) {
	        	if(atp.Team_Role__c != null && atp.User__c != null && u != null && u.Id == atp.User__c) {
        			if(!desiredTeamRoles.contains(atp.Team_Role__c) && (!prmisonSetAssignSet.isEmpty() && !prmisonSetAssignSet.contains(u.Id))) {
        				if(retrictedUsers.Message__c != null) {
        					message = retrictedUsers.Message__c;
        				}
        			}	
	        	}	
	        }
        }
    }
    
    /*
     * @ Method Name : customValidations
     * @ Parameters : None
     * @ Return Type : Boolean
     * @ Description : This method contains all the required Custom Validations for the ITAR Apps Section.
     *
     */
    public Boolean customValidations() {
    	if(con != null && !con.Is_Portal_User_Active__c) {
    		if(con.ITAR_Certified__c) {
                con.ITAR_Certified__c = false;
                con.ITAR_Enabled_Date__c = null;
                
                if(portalUserErrorCode.Message__c != null) {
		            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, portalUserErrorCode.Message__c);
		            ApexPages.addMessage(myMsg);
                }
	            return false;
            }
            return false;
        }
        
        if(!con.ITAR_Documents_Verified__c) {
            if(con.ITAR_Certified__c) {
                con.ITAR_Certified__c = false;
                con.ITAR_Enabled_Date__c = null;

                if(documentsCertifiedErrorCode.Message__c != null) {
		            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, documentsCertifiedErrorCode.Message__c);
		            ApexPages.addMessage(myMsg);
                }
                return false;
            }    
            return false;
        }
        return true;
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
     * @ Method Name : Edit
     * @ Parameters : None
     * @ Return Type : pageReference as Null
     * @ Description : This method returns the User to the ITAR Apps Section with all Editable Fields and a "Save" and "Cancel" button to update and save the record.
     *
     */
    public pagereference edit(){
        isedit = true;
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
	 if(con.Is_Portal_User_Active__c==true){
        if(customValidations()) {
            if(con.ITAR_Certified__c) {
                con.ITAR_Enabled_Date__c = System.today();
            } else {
            	con.ITAR_Enabled_Date__c = null;
            }
            
        } 
        if(!con.ITAR_Access_Requested__c && con.ITAR_Case_Number__c != null) {
        	con.ITAR_Case_Number__c = null;
        }
        isedit = false;
        update con;
		}
        else{
          ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Portal User is not enabled');
          ApexPages.addMessage(myMsg);
        }
        return null;
    }
}