/*
* @ Author :- Navneet rajput
* @ Description :- 
* @ Date :-
* @ Change History :-  
**/
public without sharing class DesignWaiverCollaboratorDetails {

	public Wavier_Collaborator__c collaborator {get;set;}
	public Id dfmId;
	public String custOption {get;set;}
	public List<Attachment> lstOfCustomerAttachments {get;set;}
	public boolean isStandardUser {get;set;}
	public boolean isPortalUser {get;set;}
	public boolean isDfmUser {get;set;}
	public boolean isDfmManager {get;set;}
	public boolean isFAE {get;set;}
	public set<Id> setOfFAEUsers;
	public List<Attachment> attachments {get;set;}
	public List<String> uRoles;
	// Added chip related info
	public List<Chip__c> lst_Chips {get;set;}
	
	Set<Id> custIds;// = DfmUtilityCls.getCustomers(dfmReport[0].Created_By_Shortname__c,dfmReport[0].Submitted_By_Shortname__c);
	Set<Id> dfmUserIds = DfmUtilityCls.getUsersFromPublicGroup('DFM_Users')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_Users').keySet():NULL;
	Set<Id> dfmManagerIds = DfmUtilityCls.getUsersFromPublicGroup('DFM_Waiver_Team')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_Waiver_Team').keySet():NULL;
	Set<Id> PIYE_Users;
    Set<Id> QA_Users;
    Set<Id> FabWaiverTeamUsers;
  
	List<String> toAddresses;
	List<String> ccAddresses;
	List<String> bccAddresses; 
	
	public DesignWaiverCollaboratorDetails(ApexPages.StandardController stdController){
		
		lstOfCustomerAttachments = new List<Attachment>();
		dfmId = stdController.getRecord().Id;
		collaborator = getWaiverCollaborator(dfmId);
		fetchAllRelatedUsers();
		fetchAllManagers();
		lst_Chips = getChipDetails(dfmId);
		system.debug('collaborator>>>>>>>>>>>>>>>>'+collaborator);
		attachments = DfmUtilityCls.getAttachments(dfmId); 
		uRoles = new List<String>{'Field Application Engineer','Primary Field Application Engineer'};
		
		custIds = DfmUtilityCls.getCustomers(collaborator.Created_By_Shortname__c,collaborator.Submitted_By_Shortname__c);
		
		map<id,GroupMember> mapOfDfmUsers = DfmUtilityCls.getUsersFromPublicGroup('DFM_Users');
		map<id,GroupMember> mapOfDfmManager = DfmUtilityCls.getUsersFromPublicGroup('DFM_Waiver_Team');	
		
		if (mapOfDfmUsers<>NULL && mapOfDfmUsers.containsKey(UserInfo.getUserId())){
			isDfmUser = true;
		} else {
			isDfmUser = false;
		}	
		
		if (mapOfDfmManager<>NULL && mapOfDfmManager.containsKey(UserInfo.getUserId())){
			isDfmManager = true;
		} else {
			isDfmManager = false;
		}	
		
		setOfFAEUsers = DfmUtilityCls.getATPUsersByRole(collaborator.Account_Short_Name__c,uRoles);
		Set<Id> setOfAMasFAE = DfmUtilityCls.getATPUsersByRoleFAEflag(collaborator.Account_Short_Name__c);
        if(setOfAMasFAE != NULL && !setOfAMasFAE.isEmpty()){
            setOfFAEUsers.addAll(setOfAMasFAE);
        }
		
		if (setOfFAEUsers <> NULL && setOfFAEUsers.contains(UserInfo.getUserId())){
			isFAE = true;
		} else {
			isFAE = false;
		}
		
		String message = '' + ApexPages.CurrentPage().GetParameters().Get('message');
        if(message != 'null')
        {
               ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Waiver collaborator report submitted for approval.')); 
        }
	}
	
	// get chip details related to waiver collaborator
	public List<Chip__c> getChipDetails(Id dfmId1){
		
		lst_Chips = [SELECT Id,Name,Chip_Name__c,Chip_Size_X__c,Chip_Size_Y__c,Wavier_Collaborator__c,
							Database_Name__c,Database_Size__c,Md5Sum__c,Source_PTSR_Number__c,Top_Cell_Name__c
					 FROM Chip__c
					 WHERE Wavier_Collaborator__c =:dfmId1];
					 
		return lst_Chips;			 
	}
	
	// get waiver collaborator field information from respective field sets
	public List<Schema.FieldSetMember> getFields() {
		
		if (UserInfo.getUserType()!='Standard'){
			isStandardUser = false;
			isPortalUser = true;
        	return SObjectType.Wavier_Collaborator__c.FieldSets.DFM_Custome_View.getFields();
        	
		} else {
			//system.debug('String.ValueOf(UserInfo.getUserId()) >>>>>>>>> '+String.ValueOf(UserInfo.getUserId()));
			system.debug('Condition satisfied Its portal User >>>>>>>>>>');
			isStandardUser = true;
			isPortalUser = false;
			
		}
		return SObjectType.Wavier_Collaborator__c.FieldSets.DFM_FAE_View.getFields();
    }
    
    // retrive customer specific waiver collaborator records
    private Wavier_Collaborator__c getWaiverCollaborator(Id dfmId){
    	String query = 'SELECT ';
        for(Schema.FieldSetMember f : this.getFields()) {
            query += f.getFieldPath() + ', ';
        }
        query += 'Is_Submit_4_DFM_Apprval__c,PTSR_Status__c,Selected_AM__c,'
                +'Selected_Customers__c,Id,Account_Name__c,Account_Short_Name__c,'
                +'Account_Manager_Approver1__c,Is_releasedToCustomer__c,IsCustomerAcceptsRisk__c,'
                +'IsCustomerAgreeToFix__c,IsGfAcceptsRisk__c,isAllPartyApproved__c,Workflow_Readiness__c, '
                +'Account_Manager__c, Product_Line_Management__c, QA_Engineer__c, '
                +'Process_ID__c, FAE_Acc_ID__c,Customer_Full_Name__c'  
                +' FROM Wavier_Collaborator__c WHERE Id =:dfmId LIMIT 1';
                
        return Database.query(query);
    }

    // Method allow to close PTSR, this will happened when DFM team members update waiver list and then close the design waiver report.
    public pageReference saveByDfm(){
    	
    	try {
    		
    		String closureType;
    		Database.SaveResult result;
    		
    		system.debug('Before collaborator.IsCustomerAgreeToFix__c >>>>>>>> '+collaborator.IsCustomerAgreeToFix__c);
    		system.debug('Before collaborator.IsCustomerAcceptsRisk__c >>>>>>>> '+collaborator.IsCustomerAcceptsRisk__c);
    		system.debug('collaborator.PTSR_Status__c >>>>>>>>>> '+collaborator.PTSR_Status__c);
    		
    		if (DfmUtilityCls.getAttachments(dfmId).isEmpty()){
    			
    			ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING,'Please attach waiver list before submitting for approval.'));
	        	return null;	
    		}
    		
    		collaborator = getWaiverCollaborator(dfmId);
    		
    		system.debug('After collaborator.IsCustomerAgreeToFix__c >>>>>>>> '+collaborator.IsCustomerAgreeToFix__c);
    		system.debug('After collaborator.IsCustomerAcceptsRisk__c >>>>>>>> '+collaborator.IsCustomerAcceptsRisk__c);
    		
    		if (collaborator.isAllPartyApproved__c && collaborator.PTSR_Status__c != 'Closed'){
    			collaborator.PTSR_Status__c = 'Closed';
	    		collaborator.Waiver_Status__c = 'Approved,Exceptional arrangement';
	    		closureType = 'ExceptionalArrangement';
	    		result = Database.update(collaborator,false);
	    		// Share with PIYE,QA,DE,AM
	    		//shareDFMWithExceptionalApprovers();
	    		
    		} else if (collaborator.IsCustomerAcceptsRisk__c && collaborator.PTSR_Status__c != 'Closed') {
    			system.debug('Inside second option >>>>>>>>>>');
	    		collaborator.PTSR_Status__c = 'Closed';
	    		collaborator.Waiver_Status__c = 'Approved,Customer agree to take risk';	
	    		closureType = 'CustomerAcceptRisk';
	    		
	    		result = Database.update(collaborator,false);
	    		
    		} else if (collaborator.IsCustomerAgreeToFix__c && collaborator.PTSR_Status__c != 'Closed'){
    			ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'DFM Waiver already closed.'));
    			return null;
    			
    		} else if (collaborator.Waiver_Status__c == 'Open' && collaborator.PTSR_Status__c != 'Closed'){
    			ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING,'This DFM Waiver will not be closed at this stage.'));
    			return null;
    			
    		} else if (collaborator.PTSR_Status__c == 'Closed'){
    			ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING,'This DFM Waiver is already closed.'));
    			return null;
    		}
	    	
	    	system.debug('Result after >>>>>>>>>>>>>>>> '+result);
	    	//update this.collaborator;
	    	if (result<>null && result.isSuccess()){
	    		
	    		if (closureType =='ExceptionalArrangement'){
	    			workflowClosureNotificationToAll();
	    			
	    		} else if (closureType =='CustomerAcceptRisk'){
	    		   workFlowClosureCustomerAgreeToTakeRiskNotification();
	    		}
	    		ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Waiver collaborator report updated successfully.'));
	    		
	    	} else {
	    		ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Unable to update waiver collaborator report, please contact SFDC admin.'));
	    	}
	    	
	    	if (UserInfo.getUserType()!='Standard'){
            	//return new PageReference('/apex/WaiverCollaborator4Customer');
            	return null;
            } else {
				PageReference p = DfmUtilityCls.returnToListView('Wavier_Collaborator__c');
            	return p;
            }
	    	//return new PageReference('/apex/WaiverCollaborator4Customer');
	    	//return null;
	    	
    	} catch (Exception e){
    		ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
    		return null;
    	}		
    }
    
    // Share DFM report with QA,DE,PIYE and AM when it required exceptional approval.
    public void shareDFMWithExceptionalApprovers(){
		 // This method use to set up pi/ye and QA users(as per fab)
		 SetupPiYeAndQAUsers();
    	
    	 boolean isSuccess =false;
    	 Set<Id> setOfAllApprovers = new Set<Id>();
    	 //Set<Id> PIYE_Users;
    	 //Set<Id> QA_Users;
    	 Set<Id> DE_Users = DfmUtilityCls.getUsersFromPublicGroup('DFM_4_DE')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_4_DE').keySet():NULL;
    	 //Set<Id> AM_Users = DfmUtilityCls.getUsersFromPublicGroup('DFM_AM')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_AM').keySet():NULL;
    	 List<String> atpManagers = new List<String>{'Primary Account Manager','Account Administrator','Account Manager'};  
		 Set<Id> AM_Users = DfmUtilityCls.getATPUsersByRole(collaborator.Account_Short_Name__c,atpManagers);
		 
		 if (PIYE_Users<>NULL && !PIYE_Users.isEmpty()){
		 	setOfAllApprovers.addAll(PIYE_Users);
		 }
		 if (QA_Users<>NULL && !QA_Users.isEmpty()){
		 	setOfAllApprovers.addAll(QA_Users);
		 }
		 if (DE_Users<>NULL && !DE_Users.isEmpty()){
		 	setOfAllApprovers.addAll(DE_Users);
		 }
		 if (AM_Users<>NULL && !AM_Users.isEmpty()){
		 	setOfAllApprovers.addAll(AM_Users);
		 }
		 if (FabWaiverTeamUsers<>NULL && !FabWaiverTeamUsers.isEmpty()){
		 	setOfAllApprovers.addAll(FabWaiverTeamUsers);
		 }
		 
		 system.debug('AM_Users ############### '+AM_Users);
		 system.debug('PIYE_Users ################## '+PIYE_Users);
		 system.debug('QA_Users ################## '+QA_Users);
		 system.debug('DE_Users ########### '+DE_Users);
		 system.debug('FabWaiverTeamUsers ########## '+FabWaiverTeamUsers);
		 
		 
		 if (setOfAllApprovers<>NULL && !setOfAllApprovers.isEmpty()){
			isSuccess = DfmUtilityCls.shareRecord(collaborator.Id,setOfAllApprovers,'Edit');		 	
		 }
		 system.debug('Is DFM shared with Exceptional approvers ?????? '+isSuccess);
    }
    
    // Method updates customer oprtion or FAE selected option. 
    public string customerOption{get;set;}
    
    public pageReference saveDRC(){
    	
    	try{
    		system.debug('customerOption @@@@@@@@@@ '+customerOption);
    		system.debug('collaborator @@@@@@@@@@@@@ '+collaborator);
	    	List<Messaging.SingleEmailMessage> lstOfEmails = new List<Messaging.SingleEmailMessage>();
	    	Database.SaveResult result;
	    	//String customerOption;
	    	//this.collaborator.customer_Options__c = custOption;
	    	if (customerOption == 'CustomerAcceptsRisk'){
	    		system.debug('Customer Accept Option 2 >>>>>>>>>>> ');
				// Update waiver collaborator
				//customerOption = 'CustomerAcceptsRisk';	
				collaborator.IsCustomerAcceptsRisk__c=true;    		
	    		result = Database.update(collaborator,false);
	    		
	    	} else if (customerOption == 'CustomerAgreeToFix'){
	    		// Option 1
	    		system.debug('Customer Agree Option 1 >>>>>>>>>>>>>> ');
	    		// Update workflow status to closed
	    		collaborator.IsCustomerAgreeToFix__c = true;
	    		collaborator.PTSR_Status__c = 'Closed';
	    		result = Database.update(collaborator,false);
	    		//customerOption = 'CustomerAgreeToFix';
					
	    	} else if (customerOption == 'GfAcceptsRisk'){
	    		collaborator.IsGfAcceptsRisk__c = true;
	    		collaborator.Selected_AM__c = hiddenUsrIds;
	    		collaborator.Account_Manager_Approver1__c = Id.valueOf(hiddenUsrIds);
	    		
	    		system.debug('Option 3 selected AMs ###### '+ hiddenUsrIds);
	    		//customerOption = 'GfAcceptsRisk';
	    		// Option 3
	    		//List<String> uRoles = new List<String>{'Primary Account Manager','Account Administrator','Account Manager'};
	    		system.debug('GF Agree to fix Option 3 >>>>>>>>');
	    		
	    		List<Account_Team_Proxy__c> listOfATP = [SELECT Id,Name,Account_Short_Name__c,Account__c,User__c,
																Team_Role__c,Account__r.Short_Name__c 
														 FROM Account_Team_Proxy__c 
														 WHERE Team_Role__c IN ('Primary Account Manager','Account Administrator','Account Manager') AND  User__r.IsActive = true
														 AND Account__r.Short_Name__c =: collaborator.Account_Short_Name__c];
	    		
	    		if (collaborator.Account_Manager_Approver1__c == NULL &&  listOfATP<>NULL && !listOfATP.isEmpty()){
		    		for (Account_Team_Proxy__c ATP : listOfATP){
		    			if (ATP.Team_Role__c =='Primary Account Manager'){
		    				//collaborator.Account_Manager_Approver1__c = ATP.User__c;
		    				collaborator.Account_Manager_Approver1__c = ATP.User__c;
		    				break;
		    			} else if (ATP.Team_Role__c =='Account Administrator'){
		    				//collaborator.Account_Manager_Approver2__c = ATP.User__c;
		    				collaborator.Account_Manager_Approver1__c = ATP.User__c;
		    				break;
		    			} else if (ATP.Team_Role__c =='Account Manager'){
		    				//collaborator.Account_Manager_Approver3__c = ATP.User__c;
		    				collaborator.Account_Manager_Approver1__c = ATP.User__c;
		    				break;
		    			}
		    		}
		    		// In case account team proxy doesnt have any account manager related role then assign to default user
		    		if (collaborator.Account_Manager_Approver1__c == NULL){
		    			collaborator.Account_Manager_Approver1__c = UserInfo.getUserId();
		    		}
	    		}
	    		
	    		if (collaborator.Account_Manager_Approver1__c<>NULL){
	    			result = Database.update(collaborator,false);
	    		}
	    		if (result.isSuccess()){
		    		// Create an approval request for design waiver collaborator
			        Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
			        req.setComments('Submitting request by FAEs ');
			        req.setObjectId(collaborator.Id);
			        // Submit the approval request for the Opportunity
			        Approval.ProcessResult approvalResult = Approval.process(req);
		        	// check approval process submission result
			        if (approvalResult.isSuccess()){
			        	// Share with PIYE,QA,DE,AM
		    			shareDFMWithExceptionalApprovers();
			        }
	    		}
	    	}
	    	//Database.SaveResult result = Database.update(collaborator,false);
	    	//update this.collaborator;
	    	system.debug('result ######## '+result);
	    	
	    	if (result<> NULL && result.isSuccess()){
	    		ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Waiver collaborator report updated successfully.'));
	    		if(customerOption == 'CustomerAcceptsRisk'){
	    			system.debug('customerOption >>>>>>>>>>>>>>>'+customerOption);
	    			eTemplate4CustomerAcceptRisk();
	    			
	    		} else if (customerOption == 'CustomerAgreeToFix'){
	    			system.debug('customerOption >>>>>>>>>>>>>>>'+customerOption);
	    			eTemplate4CustomerAgreeToFix();
	    			
	    		} else if (customerOption == 'GfAcceptsRisk'){
	    			system.debug('customerOption >>>>>>>>>>>>>>>'+customerOption);
	    			eTemplate4GfAgreeToRisk();
	    		}
	    		
	    	} else {
	    		ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Unable to update waiver collaborator report, please contact SFDC admin.'));
	        	//return null;
	    	}
	    	collaborator = getWaiverCollaborator(dfmId);
	    	//return null;
	    	//return new PageReference('/apex/WaiverCollaborator4Customer');
	    	if (UserInfo.getUserType()!='Standard'){
            	//return new PageReference('/apex/WaiverCollaborator4Customer');
            	return null;
            } else {
				PageReference p = DfmUtilityCls.returnToListView('Wavier_Collaborator__c');
            	return p;
            }
	    	
    	} catch (Exception e){
    		
    		ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
	        return null;
    	}
    }

	public string hiddenUsrIds {get;set;}
	// Release waiver list to customer to take further decision   
    public pageReference releaseToCustomer(){
    	// Get set of user ids by passing created and submited name
		//Set<Id> custIds = DfmUtilityCls.getCustomers(collaborator.Created_By_Shortname__c,collaborator.Submitted_By_Shortname__c);
		Set <Id> selectedcustomers = new Set<Id>();
		system.debug('hiddenUsrIds >>>>>>>>>> '+hiddenUsrIds);
		if (hiddenUsrIds<>NULL && !String.isEmpty(hiddenUsrIds)){
			for (String str : hiddenUsrIds.split(';')){
				selectedcustomers.add(Id.valueOf(str));
			}
			//selectedcustomers = new set<Id>(hiddenUsrIds.split(';'));
			//selectedcustomers.addAll(hiddenUsrIds.split(';'));
		}
		system.debug('selectedcustomers >>>>>>>>>> '+selectedcustomers);
								
		if (selectedcustomers<>NULL && !selectedcustomers.isEmpty()){
			boolean isSuccess = DfmUtilityCls.shareRecord(collaborator.Id,selectedcustomers,'Edit');
			if (isSuccess){
				collaborator.Selected_Customers__c = hiddenUsrIds;
				collaborator.Is_releasedToCustomer__c = true;
				update collaborator;
				ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Waiver report release successfully.'));
				// Send email notification to customer
				sendReminderEmailToCustomer(collaborator,selectedcustomers);
	        	//return null;
	        	//return new PageReference('/apex/WaiverCollaborator4Customer');
	        	if (UserInfo.getUserType()!='Standard'){
	            	//return new PageReference('/apex/WaiverCollaborator4Customer');
	            	return null;
	            } else {
					PageReference p = DfmUtilityCls.returnToListView('Wavier_Collaborator__c');
	            	return p;
	            }
	        	
			} else {
				ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Unexpected Error. Please contact your system admin.'));
	        	return null;
  			}
			
		} else {
			ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Customer details are missing.'));
	        return null;
		}
		//return null;		
    }
    
    public pageReference submitForApproval(){
    	try {
    		
    		String errorMessages = checkMandatoryFields();
            if (errorMessages != 'Success'){                
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING, errorMessages));
                return null;    
            }
    		
    		if (DfmUtilityCls.getAttachments(dfmId).isEmpty()){
    			
    			ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING,'Please attach waiver list before submitting for approval.'));
	        	return null;	
    		}
	    	// Create an approval request for design waiver collaborator
	        Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
	        req.setComments('Submitting request by DFM users');
	        req.setObjectId(dfmId);
	        // Submit the approval request for the Opportunity
	        Approval.ProcessResult result = Approval.process(req);
	        // check approval process submission result
	        if (result.isSuccess()){
	        	// update dfm apprval flag
                DesignWaiverCollaboratorDetails.updatePtsrStatus(collaborator.Id);
	        	// Share waiver report with DFM Approver group
	        	DfmUtilityCls.shareRecord(collaborator.Id,dfmManagerIds,'Edit');
	        	dfmApprovalToDfmApprovalTeam();
	        	pageReference pg = new pageReference('/apex/DesignWaiverCollaboratorPage?Id='+collaborator.Id);
                pg.getParameters().put('message', '1');
        	 	pg.setRedirect(true);       	 
                return pg;
	        	
	        } else {
	        	for(Database.Error err : result.getErrors()) {
				 	System.debug(err.getStatusCode() + ': ' + err.getMessage());
				 	ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,err.getStatusCode() + ': ' + err.getMessage()));
				 }
	        	 return null;
	        }
	   		 return null;
	        
    	} catch (exception e){
			
			ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error while submitting waiver report for approval. Please contact with SFDC admin.')); 
			return null;   		
    	}
    	
    }
    
     // update isSubmit4DFMApproval flag
     @future
    public static void updatePtsrStatus(Id dfmId){
        Wavier_Collaborator__c waiverObj = [Select Id,Is_Submit_4_DFM_Apprval__c,PTSR_Status__c FROM Wavier_Collaborator__c WHERE Id = : dfmId limit 1];
        waiverObj.Is_Submit_4_DFM_Apprval__c = true;
        update waiverObj;
    }
    
    //Check the Mandatory Fields of Waiver Collaborator Object, Otherwise will not allow to Submit For Approval
    public String checkMandatoryFields() {
    	
    	Map<String, String> dfmFields = new Map<String,String>{'CRM Device' => collaborator.CRM_Device__c, 
    															'PTSR Number' => collaborator.PTSR_Number__c, 
    															'PTSR Service Type' => collaborator.PTSR_Service_Type__c, 
    															'PTSR Status' => collaborator.PTSR_Status__c,
                                        						'FAB' => collaborator.FAB__c, 
                                        						'Customer Full Name' => collaborator.Account__c, 
                                        						'Account Short Name' => collaborator.Account_Short_Name__c,
                                        						'DFMServiceOption' => collaborator.DFMServiceOption__c};
                                        						
		String errorMessages = MandatoryFieldValidator.createDFM(dFMFields);
		
		return errorMessages;								
    }
    
     // Send reminder email notification to customer
    public void sendReminderEmailToCustomer(Wavier_Collaborator__c waiver,Set<Id> customers){
    	
    	String primeDieName = DfmUtilityCls.getPrimeDieName(waiver.Id);
		String subject='Your Response is required: '+waiver.Name+','+waiver.PTSR_Number__c+', '+primeDieName+' DFM Waiver Collaboration,'+waiver.Account_Name__c;
		List<String> toAddresses = DfmUtilityCls.getEmailIds(customers);
		List<String> atpManagers = new List<String>{'Primary Account Manager','Account Administrator','Account Manager'};  
		Set<Id> atpManagerUIds = DfmUtilityCls.getATPUsersByRole(collaborator.Account_Short_Name__c,atpManagers);
		Set<Id> setOfFAEs = DfmUtilityCls.getATPUsersByRole(collaborator.Account_Short_Name__c,uRoles);
		Set<Id> setOfAMasFAE = DfmUtilityCls.getATPUsersByRoleFAEflag(collaborator.Account_Short_Name__c);
        if(setOfAMasFAE != NULL && !setOfAMasFAE.isEmpty()){
            setOfFAEs.addAll(setOfAMasFAE);
        }
		
		if (atpManagerUIds<>NULL){
			atpManagerUIds.addAll(setOfFAEs);	
		}
		
		List<String> ccAddresses = DfmUtilityCls.getEmailIds(atpManagerUIds);
		List<String> bccAddresses =DfmUtilityCls.getEmailIds(dfmManagerIds);
		bccAddresses.add('Gfv.do.not.reply@globalfoundries.com');
		DfmEmailUtility emailUtil = new DfmEmailUtility(toAddresses,ccAddresses,bccAddresses);
		
		String body = '<html><body>'
						+'<h3>Title: Waiver Rejection Notification</h3><br>'
						+'Your request of DFM waiver for '+ primeDieName+' has been rejected.<br>'
						+'<p>Your prompt choice of action is required in the Design Waiver Collaborator:<p><br>'
						+URL.getSalesforceBaseUrl().toExternalForm() +'/' + waiver.Id+'<br>'
						+'<b>Issue Title:</b> DFM Waiver Collaboration File '+waiver.PTSR_Number__c+'<br>'
						+'<b>Aggregated Waiver Review Status:</b> '+waiver.Waiver_Status__c+'<br>'
						+'<b>Collaborator Workflow Status:</b> '+waiver.Workflow_Status__c+'<br>'
						+'<b>Access the following URL to see DFM Waiver File: </b>'
						+System.Label.DFM_Customer_URL+'/' + waiver.Id+'<br><br>'
						+'</html></body>';	 
		//send plain text body
		emailUtil.htmlBody(body)
			 	 .senderDisplayName(UserInfo.getFirstName()+' '+UserInfo.getLastName())
			 	 .subject(subject)
			 	 .sendEmail();
		
    } 
    
    // Send email notification when customer accept risk
    public void eTemplate4CustomerAcceptRisk(){
    	
    	String waiverCollaboratorURL = '';
    	collaborator = getWaiverCollaborator(dfmId);
    	Set<Id> custIds= new Set<Id>(); //= DfmUtilityCls.getCustomers(collaborator.Created_By_Shortname__c,collaborator.Submitted_By_Shortname__c);
    	List<String> atpManagers = new List<String>{'Primary Account Manager','Account Administrator','Account Manager'};  
		Set<Id> AM_Users = DfmUtilityCls.getATPUsersByRole(collaborator.Account_Short_Name__c,atpManagers);
		Set<Id> setOfFAEs = DfmUtilityCls.getATPUsersByRole(collaborator.Account_Short_Name__c,uRoles);
		Set<Id> setOfAMasFAE = DfmUtilityCls.getATPUsersByRoleFAEflag(collaborator.Account_Short_Name__c);
        if(setOfAMasFAE != NULL && !setOfAMasFAE.isEmpty()){
            setOfFAEs.addAll(setOfAMasFAE);
        }
		
		Set<Id> bccUserIds = new Set<Id>();
		Set<Id> ccUSerIds = new Set<Id>();
		/*
		if (collaborator.Selected_Customers__c<>NULL && !String.isEmpty(collaborator.Selected_Customers__c)){
			for (String str : collaborator.Selected_Customers__c.split(';')){
				custIds.add(Id.valueOf(str));
			}
		}*/
		
		if (UserInfo.getUserType()!='Standard'){
			waiverCollaboratorURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + 'GlobalfoundryView' + '/';
		} else {
			waiverCollaboratorURL = URL.getSalesforceBaseUrl().toExternalForm() + '/';
		}
		//setUpPiyeAndQAUsers();
    	toAddresses = DfmUtilityCls.getEmailIds(dfmUserIds);
		ccAddresses = DfmUtilityCls.getEmailIds(dfmManagerIds);
		//bccAddresses = DfmUtilityCls.getEmailIds(bccUserIds);
		//bccAddresses.add('Gfv.do.not.reply@globalfoundries.com');
		List<String> bccAddresses = new List<String>{'Gfv.do.not.reply@globalfoundries.com'};
		
		DfmEmailUtility emailUtil = new DfmEmailUtility(toAddresses,ccAddresses,bccAddresses);
		String primeDieName = DfmUtilityCls.getPrimeDieName(collaborator.Id);
		
		String subject=': Update is required: '+collaborator.Name+','+collaborator.PTSR_Number__c+','+primeDieName +' DFM Waiver Collaboration,'+collaborator.Account_Name__c;
		// Prepare email body
		String body = '<html>'
						+'<h3> <b>Title:</b> Notification of customer-accept-risk </h3></br>'
						+'<p> Update of DFM waiver for '+primeDieName +' is required. Customer accepts risk.</p><br>'
						+'<b>Issue Title:</b> DFM Waiver Collaboration File '+collaborator.PTSR_Number__c+'<br>'
						+'<b>Aggregated Waiver Review Status:</b> '+collaborator.Waiver_Status__c+'<br>'
						+'<b>Collaborator Workflow Status:</b> '+collaborator.Workflow_Status__c+'<br><br>'
						+'<b>Access the following URL to see DFM Waiver File: </b>'
						+waiverCollaboratorURL + collaborator.Id+'<br>'
						+'</html>';
		//send plain text body
		emailUtil.htmlBody(body)
			 	 .senderDisplayName(UserInfo.getFirstName()+' '+UserInfo.getLastName())
			 	 .subject(subject)
			 	 .sendEmail();	
    }
    
    //send email notification when customer agree to fix
    public void eTemplate4CustomerAgreeToFix(){
    	
    	String waiverCollaboratorURL = '';
    	system.debug('eTemplate4CustomerAgreeToFix ######### ');
    	system.debug('dfmManagerIds >>>>>>> '+dfmManagerIds);
    	system.debug('dfmUserIds >>>>>>> '+dfmUserIds);
    	collaborator = getWaiverCollaborator(dfmId);
    	setOfFAEUsers = DfmUtilityCls.getATPUsersByRole(collaborator.Account_Short_Name__c,uRoles);
    	Set<Id> setOfAMasFAE = DfmUtilityCls.getATPUsersByRoleFAEflag(collaborator.Account_Short_Name__c);
        if(setOfAMasFAE != NULL && !setOfAMasFAE.isEmpty()){
            setOfFAEUsers.addAll(setOfAMasFAE);
        }
		
    	if (UserInfo.getUserType()!='Standard'){
			waiverCollaboratorURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + 'GlobalfoundryView' + '/';
		} else {
			waiverCollaboratorURL = URL.getSalesforceBaseUrl().toExternalForm() + '/';
		}
    	
    	Set<Id> custIds= new Set<Id>();
    	if (collaborator.Selected_Customers__c<>NULL && !String.isEmpty(collaborator.Selected_Customers__c)){
			for (String str : collaborator.Selected_Customers__c.split(';')){
				custIds.add(Id.valueOf(str));
			}
		}
		
		if (custIds<>NULL && !custIds.isEmpty()){
			setOfFAEUsers.addAll(custIds);
		}
		
    	Set<Id> ccUserIds = new Set<Id>();
    	Set<Id> bccUIds = new Set<Id>();
		List<String> atpManagers = new List<String>{'Primary Account Manager','Account Administrator','Account Manager'};  
		Set<Id> atpManagerUIds = DfmUtilityCls.getATPUsersByRole(collaborator.Account_Short_Name__c,atpManagers);
			
		system.debug('atpManagerUIds >>>>>>> '+atpManagerUIds);
			
		if (dfmManagerIds<>NULL && !dfmManagerIds.isEmpty()){
			bccUIds.addAll(dfmManagerIds);
		}
		if (dfmUserIds<>NULL && !dfmUserIds.isEmpty()){
			bccUIds.addAll(dfmUserIds);
		}
		/*if (atpManagerUIds<>NULL && !atpManagerUIds.isEmpty()){
			ccUserIds.addAll(atpManagerUIds);
		}*/
		
    	toAddresses = DfmUtilityCls.getEmailIds(setOfFAEUsers);
		ccAddresses = DfmUtilityCls.getEmailIds(atpManagerUIds);
		bccAddresses = DfmUtilityCls.getEmailIds(bccUIds);
		//List<String> bccAddresses = new List<String>{'Gfv.do.not.reply@globalfoundries.com'};
		bccAddresses.add('Gfv.do.not.reply@globalfoundries.com');
		// Prepare email utility instance and set to,cc and bcc addresses
		DfmEmailUtility emailUtil = new DfmEmailUtility(toAddresses,ccAddresses,bccAddresses);
		String primeDieName = DfmUtilityCls.getPrimeDieName(collaborator.Id);
		
		String subject=': Notification of Customer Response: '+collaborator.Name+','+collaborator.PTSR_Number__c+','+primeDieName +' DFM Waiver Collaboration,'+collaborator.Account_Name__c;
		// Prepare email body
		String body = '<html>'
						+'<h3> <b>Title:</b> Notification of Customer-Agree-to-Fix </h3></br>'
						+'Customer agrees to fix the non-waived violations and resubmit for '+primeDieName +'.<br>'
						+'<b>Issue Title:</b> DFM Waiver Collaboration File '+collaborator.PTSR_Number__c+'<br>'
						+'<b>Aggregated Waiver Review Status:</b> '+collaborator.Waiver_Status__c+'<br>'
						+'<b>Collaborator Workflow Status:</b> '+collaborator.PTSR_Status__c+'<br><br>'
						+'<b>Access the following URL to see DFM Waiver File: </b>'
						+waiverCollaboratorURL + collaborator.Id+'<br>'
						+'</html>';
		//send plain text body
		emailUtil.htmlBody(body)
			 	 .senderDisplayName(UserInfo.getFirstName()+' '+UserInfo.getLastName())
			 	 .subject(subject)
			 	 .sendEmail();
    }
    
    // sned email notification when GF agree to risk
    public void eTemplate4GfAgreeToRisk(){
    	 
    	 Set<Id> ccUserIds = new Set<Id>();
    	 Set<Id> toUserIds = new Set<Id>();
    	 //Set<Id> PIYE_Users;
    	 //Set<Id> QA_Users;
    	 Set<Id> DE_Users = DfmUtilityCls.getUsersFromPublicGroup('DFM_4_DE')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_4_DE').keySet():NULL; 
    	 //Set<Id> AM_Users = DfmUtilityCls.getUsersFromPublicGroup('DFM_AM')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_AM').keySet():NULL;
    	 List<String> atpManagers = new List<String>{'Primary Account Manager','Account Administrator','Account Manager'};  
		 Set<Id> AM_Users = DfmUtilityCls.getATPUsersByRole(collaborator.Account_Short_Name__c,atpManagers);
    	 // Set up pi/ye and QA approvers as per waiver collaborator fabs
    	 SetupPiYeAndQAUsers();
		 
		 if (dfmManagerIds<>NULL && !dfmManagerIds.isEmpty()){
		 	ccUserIds.addAll(dfmManagerIds);
		 }
		 // Prepare cc addresses
		 if (setOfFAEUsers<>NULL && !setOfFAEUsers.isEmpty()){
		 	ccUserIds.addAll(setOfFAEUsers);
		 }
    	
    	 if (QA_Users<>NULL && !QA_Users.isEmpty()){
    	 	toUserIds.addAll(QA_Users);
    	 }
		 if (PIYE_Users <>NULL && !PIYE_Users.isEmpty()){
		 	toUserIds.addAll(PIYE_Users);
		 } 
		 if (DE_Users<>NULL && !DE_Users.isEmpty()){
		 	toUserIds.addAll(DE_Users);
		 }
		 if (AM_Users<>NULL && !AM_Users.isEmpty()){
		 	toUserIds.addAll(AM_Users);
		 }	     	
		 // Prepare cc addresses
		 if (setOfFAEUsers<>NULL && !setOfFAEUsers.isEmpty()){
		 	toUserIds.addAll(setOfFAEUsers);
		 }
		 if (dfmManagerIds<>NULL && !dfmManagerIds.isEmpty()){
		 	toUserIds.addAll(dfmManagerIds);
		 }
		 
    	toAddresses = DfmUtilityCls.getEmailIds(toUserIds);
		ccAddresses = DfmUtilityCls.getEmailIds(ccUserIds);
		List<String> bccAddresses = new List<String>{'Gfv.do.not.reply@globalfoundries.com'};
		// Prepare email utility instance and set to,cc and bcc addresses
		DfmEmailUtility emailUtil = new DfmEmailUtility(toAddresses,ccAddresses,bccAddresses);
		String primeDieName = DfmUtilityCls.getPrimeDieName(collaborator.Id);
		String approvalUrl = DfmUtilityCls.generateApprovalURL(collaborator.Id);
		String subject='Your Approval is required: '+collaborator.Name+','+collaborator.PTSR_Number__c+','+primeDieName +' DFM Waiver Collaboration,'+collaborator.Account_Name__c;
		// Prepare email body
		String body = '<html>'
						+'<h3> <b>Title:</b> Foundry-to-Risk Approval from PIYE, DE, QA, AM </h3></br>'
						+'<p>The DFM waiver for '+primeDieName +' has been rejected and customer has declined to design fixes or to accept risk.' 
						+'Your approval is required for foundry to accept risk (Will communicate as Exceptional Arrangement to the customer once a member from each of the approval groups approves)</p><br>'
						+'Click on below link to access the Approve/Reject link for approval. <br>'
						+URL.getSalesforceBaseUrl().toExternalForm() +'/' + collaborator.Id+'<br>'
						+'<b>Approve = </b>'+'Foundry to accept risk due to no customer action possible on mitigating DFM violations;<br>'
						+'<b>Reject = </b>'+'Foundry reject the device tapeout submission due to unacceptable tapeout requirement non-compliance;<br>'
						+'<b>Issue Title:</b> DFM Waiver Collaboration File '+collaborator.PTSR_Number__c+'<br>'
						+'<b>Aggregated Waiver Review Status:</b> '+collaborator.Waiver_Status__c+'<br>'
						+'<b>Collaborator Workflow Status:</b> '+collaborator.Workflow_Status__c+'<br><br>'
						+'<b>Access the following URL to see DFM Waiver File: </b>'
						+URL.getSalesforceBaseUrl().toExternalForm() +'/' + collaborator.Id+'<br>'
						+'</html>';
		//send plain text body
		emailUtil.htmlBody(body)
			 	 .senderDisplayName(UserInfo.getFirstName()+' '+UserInfo.getLastName())
			 	 .subject(subject)
			 	 .sendEmail();
    	
    }
    
    // send workflow closure notification to DE,QA,FAE,PIYE in case of exceptional arrangment
    public void workflowClosureNotificationToAll(){
		
		 Set<Id> ccUserIds = new Set<Id>();
    	 Set<Id> toUserIds = new Set<Id>();
    	 Set<Id> bccUserIds = new Set<Id>();
    	
    	 Set<Id> DE_Users = DfmUtilityCls.getUsersFromPublicGroup('DFM_4_DE')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_4_DE').keySet():NULL; 
    	// Set<Id> AM_Users = DfmUtilityCls.getUsersFromPublicGroup('DFM_AM')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_AM').keySet():NULL;
    	 Set<Id> custIds = new Set<Id>();//DfmUtilityCls.getCustomers(collaborator.Created_By_Shortname__c,collaborator.Submitted_By_Shortname__c);
    	 
    	 List<String> atpManagers = new List<String>{'Primary Account Manager','Account Administrator','Account Manager'};  
		 Set<Id> AM_Users = DfmUtilityCls.getATPUsersByRole(collaborator.Account_Short_Name__c,atpManagers);
		 
		 if (collaborator.Selected_Customers__c<>NULL && !String.isEmpty(collaborator.Selected_Customers__c)){
			for (String str : collaborator.Selected_Customers__c.split(';')){
				custIds.add(Id.valueOf(str));
			}
		 }
    	 //Set up pi/ye and QA approvers as per waiver collaborator fabs
    	 SetupPiYeAndQAUsers();
    	 // prepate bcc addresses
    	 if (QA_Users<>NULL && !QA_Users.isEmpty()){
    	 	bccUserIds.addAll(QA_Users);
    	 }
		 if (PIYE_Users <>NULL && !PIYE_Users.isEmpty()){
		 	bccUserIds.addAll(PIYE_Users);
		 } 
		 if (DE_Users<>NULL && !DE_Users.isEmpty()){
		 	bccUserIds.addAll(DE_Users);
		 }
		 if (dfmManagerIds<>NULL && !dfmManagerIds.isEmpty()){
		 	bccUserIds.addAll(dfmManagerIds);
		 }
		 if (FabWaiverTeamUsers<>NULL && !FabWaiverTeamUsers.isEmpty()){
		 	bccUserIds.addAll(FabWaiverTeamUsers);
		 }
		 // Prepare cc addresses
		 if (setOfFAEUsers<>NULL && !setOfFAEUsers.isEmpty()){
		 	ccUserIds.addAll(setOfFAEUsers);
		 }
		 if (AM_Users<>NULL && !AM_Users.isEmpty()){
		 	ccUserIds.addAll(AM_Users);
		 }
		 // prepate To addresses
		 
		 
    	 toAddresses = DfmUtilityCls.getEmailIds(custIds);
		 ccAddresses = DfmUtilityCls.getEmailIds(ccUserIds);
		 bccAddresses = DfmUtilityCls.getEmailIds(bccUserIds);
		 bccAddresses.add('Gfv.do.not.reply@globalfoundries.com');
		 //List<String> bccAddresses = new List<String>{'Gfv.do.not.reply@globalfoundries.com'};
		// Prepare email utility instance and set to,cc and bcc addresses
		DfmEmailUtility emailUtil = new DfmEmailUtility(toAddresses,ccAddresses,bccAddresses);
		String primeDieName = DfmUtilityCls.getPrimeDieName(collaborator.Id);
		
		String subject='Final Waiver Status Notification: '+collaborator.Name+','+collaborator.PTSR_Number__c+','+primeDieName +' DFM Waiver Collaboration,'+collaborator.Account_Name__c;
		// Prepare email body
		String body = '<html>'
						+'<h3> <b>Title:</b> Final Waiver Status Notification: Exceptional Arrangement</h3></br>'
						+'<p>Your request of DFM waiver for '+primeDieName +' has been granted with exceptional arrangement.<p><br>' 
						+'<b>Issue Title:</b> DFM Waiver Collaboration File '+collaborator.PTSR_Number__c+'<br>'
						+'<b>Aggregated Waiver Review Status:</b> '+collaborator.Waiver_Status__c+'<br>'
						+'<b>Collaborator Workflow Status:</b> '+collaborator.Workflow_Status__c+'<br><br>'
						+'<b>Access the following URL to see DFM Waiver File: </b>'
						//+URL.getSalesforceBaseUrl().toExternalForm() +'/' + collaborator.Id+'<br>'
						+System.Label.DFM_Customer_URL+'/' + collaborator.Id+'<br><br>'
						+'</html>';
		//send plain text body
		emailUtil.htmlBody(body)
			 	 .senderDisplayName(UserInfo.getFirstName()+' '+UserInfo.getLastName())
			 	 .subject(subject)
			 	 .sendEmail();
		    	
    }
    
    public void workFlowClosureCustomerAgreeToTakeRiskNotification(){
    	system.debug('Inside setUpPiyeAndQAUsers ########## ');
    	collaborator = getWaiverCollaborator(dfmId);
    	
    	Set<Id> ccUserIds = new Set<Id>();
    	Set<Id> bccUserIds = new Set<Id>();
    	
		List<String> atpManagers = new List<String>{'Primary Account Manager','Account Administrator','Account Manager'};  
		Set<Id> atpManagerUIds = DfmUtilityCls.getATPUsersByRole(collaborator.Account_Short_Name__c,atpManagers);
		Set<Id> setOfFAEs = DfmUtilityCls.getATPUsersByRole(collaborator.Account_Short_Name__c,uRoles);
		Set<Id> setOfAMasFAE = DfmUtilityCls.getATPUsersByRoleFAEflag(collaborator.Account_Short_Name__c);
        if(setOfAMasFAE != NULL && !setOfAMasFAE.isEmpty()){
            setOfFAEs.addAll(setOfAMasFAE);
        }
		
		Set<Id> custIds = new Set<Id>();//= DfmUtilityCls.getCustomers(collaborator.Created_By_Shortname__c,collaborator.Submitted_By_Shortname__c);
		
    	if (collaborator.Selected_Customers__c<>NULL && !String.isEmpty(collaborator.Selected_Customers__c)){
			for (String str : collaborator.Selected_Customers__c.split(';')){
				custIds.add(Id.valueOf(str));
			}
		} 
		setUpPiyeAndQAUsers();	
		system.debug('atpManagerUIds >>>>>>> '+atpManagerUIds);
		
		if (setOfFAEs<>NULL && !setOfFAEs.isEmpty()){
			ccUserIds.addAll(setOfFAEs);
		}
		if (atpManagerUIds<>NULL && !atpManagerUIds.isEmpty()){
			ccUserIds.addAll(atpManagerUIds);
		}
		if (FabWaiverTeamUsers<>NULL && !FabWaiverTeamUsers.isEmpty()){
			bccUserIds.addAll(FabWaiverTeamUsers);
		}
		if (dfmManagerIds<>NULL && !dfmManagerIds.isEmpty()){
			bccUserIds.addAll(dfmManagerIds);
		}
		
    	toAddresses = DfmUtilityCls.getEmailIds(custIds);
		ccAddresses = DfmUtilityCls.getEmailIds(ccUserIds);
		bccAddresses = DfmUtilityCls.getEmailIds(bccUserIds);
		bccAddresses.add('Gfv.do.not.reply@globalfoundries.com');
		 //List<String> bccAddresses = new List<String>{'Gfv.do.not.reply@globalfoundries.com'};
		// Prepare email utility instance and set to,cc and bcc addresses
		DfmEmailUtility emailUtil = new DfmEmailUtility(toAddresses,ccAddresses,bccAddresses);
		String primeDieName = DfmUtilityCls.getPrimeDieName(collaborator.Id);
		
		String subject=': Final Waiver Status Notification: '+collaborator.Name+','+collaborator.PTSR_Number__c+','+primeDieName +' DFM Waiver Collaboration,'+collaborator.Account_Name__c;
		// Prepare email body
		String body = '<html>'
						+'<h3> <b>Title:</b> Final Waiver Status Notification: Customer-accept-risk </h3></br>'
						+'<p>Your request of DFM waiver for '+primeDieName +' has been granted on the basis that you as a representative of '
						+collaborator.Account_Name__c+', have agreed the device,'+ primeDieName+'to proceed for manufacturing and have agreed to accept risk liability due to the unfixed violations.</p><br>'
						+'<b>Issue Title:</b> DFM Waiver Collaboration File '+collaborator.PTSR_Number__c+'<br>'
						+'<b>Aggregated Waiver Review Status:</b> '+collaborator.Waiver_Status__c+'<br>'
						+'<b>Collaborator Workflow Status:</b> '+collaborator.Workflow_Status__c+'<br><br>'
						+'<b>Access the following URL to see DFM Waiver File: </b>'
						//+URL.getSalesforceBaseUrl().toExternalForm() +'/' + collaborator.Id+'<br>'
						+System.Label.DFM_Customer_URL+'/' + collaborator.Id+'<br><br>'
						+'</html>';
		//send plain text body
		emailUtil.htmlBody(body)
			 	 .senderDisplayName(UserInfo.getFirstName()+' '+UserInfo.getLastName())
			 	 .subject(subject)
			 	 .sendEmail();	
    }
    
    public void setUpPiyeAndQAUsers(){
    	 system.debug('Inside setUpPiyeAndQAUsers ########## ');
    	 collaborator = getWaiverCollaborator(dfmId);
    	  // prepare To addresses	
		 if (collaborator.FAB__c.contains('1')){
		 	PIYE_Users = DfmUtilityCls.getUsersFromPublicGroup('DFM_PI_YE_4_FAB1')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_PI_YE_4_FAB1').keySet():NULL;
		 	QA_Users = DfmUtilityCls.getUsersFromPublicGroup('DFM_QA_4_FAB1')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_QA_4_FAB1').keySet():NULL;
		 	
		 	FabWaiverTeamUsers = DfmUtilityCls.getUsersFromPublicGroup('Fab1_Waiver_Team')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('Fab1_Waiver_Team').keySet():NULL;
		 		
		 } else if (collaborator.FAB__c.contains('7')){
		 	
		 	PIYE_Users = DfmUtilityCls.getUsersFromPublicGroup('DFM_PI_YE_4_FAB7')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_PI_YE_4_FAB7').keySet():NULL;
		 	QA_Users = DfmUtilityCls.getUsersFromPublicGroup('DFM_QA_4_FAB7')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_QA_4_FAB7').keySet():NULL;
		 	
		 	FabWaiverTeamUsers = DfmUtilityCls.getUsersFromPublicGroup('Fab7_Waiver_Team')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('Fab7_Waiver_Team').keySet():NULL;
		 	
		 } else if (collaborator.FAB__c.contains('8')){
		 	
		 	PIYE_Users = DfmUtilityCls.getUsersFromPublicGroup('DFM_PI_YE_4_FAB8')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_PI_YE_4_FAB8').keySet():NULL;
		 	QA_Users = DfmUtilityCls.getUsersFromPublicGroup('DFM_QA_4_FAB8')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_QA_4_FAB8').keySet():NULL;
		 	
		 	FabWaiverTeamUsers = DfmUtilityCls.getUsersFromPublicGroup('Fab8_Waiver_Team')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('Fab8_Waiver_Team').keySet():NULL;
		 	
		 } else if (collaborator.FAB__c.contains('9')){
		 	
		 	PIYE_Users = DfmUtilityCls.getUsersFromPublicGroup('DFM_PI_YE_4_FAB9')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_PI_YE_4_FAB9').keySet():NULL;
		 	QA_Users = DfmUtilityCls.getUsersFromPublicGroup('DFM_QA_4_FAB9')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_QA_4_FAB9').keySet():NULL;
		 	
		 	FabWaiverTeamUsers = DfmUtilityCls.getUsersFromPublicGroup('Fab9_Waiver_Team')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('Fab9_Waiver_Team').keySet():NULL;
		 	
		 }
		 
    }
    
     // send email to DFM approval team
    public void dfmApprovalToDfmApprovalTeam(){
    	
    	collaborator = getWaiverCollaborator(dfmId);
    	system.debug('dfmManagerIds >>>>>>>>> '+dfmManagerIds);
    	system.debug('dfmUserIds >>>>>>>>>>> '+dfmUserIds);
    	
    	toAddresses = DfmUtilityCls.getEmailIds(dfmManagerIds);
		ccAddresses = DfmUtilityCls.getEmailIds(dfmUserIds);
		 //bccAddresses.add('Gfv.do.not.reply@globalfoundries.com');
		 List<String> bccAddresses = new List<String>{'Gfv.do.not.reply@globalfoundries.com'};
		DfmEmailUtility emailUtil = new DfmEmailUtility(toAddresses,ccAddresses,bccAddresses);
		String primeDieName = DfmUtilityCls.getPrimeDieName(collaborator.Id);
		
		String subject='Notification : '+collaborator.Name+','+collaborator.PTSR_Number__c+','+primeDieName +' DFM Waiver Collaboration,'+collaborator.Account_Name__c;
		// Prepare email body
		String body = '<html>'
						+'<h3> <b>Title:</b> Waiver List Approval for Aggregated Status</h3></br>'
						+'Action Required: Review waiver list file and enter Aggregated Waiver Status in the Design Waiver Collaborator '
						+URL.getSalesforceBaseUrl().toExternalForm() +'/' + collaborator.Id+'<br>'
						+'<b>Approve = </b>All violations waived and approved;<br>'
						+'<b>Reject =</b> One or more violation cannot be waived<br>'
						+'<b>Issue Title:</b> DFM Waiver Collaboration File '+collaborator.PTSR_Number__c+'<br>'
						+'<b>Aggregated Waiver Review Status:</b> '+collaborator.Waiver_Status__c+'<br>'
						+'<b>Collaborator Workflow Status:</b> '+collaborator.Workflow_Status__c+'<br><br>'
						+'Access the following URL to see DFM Waiver File: '
						+URL.getSalesforceBaseUrl().toExternalForm() +'/' + collaborator.Id+'<br>'
						+'</html>';
		//send plain text body
		emailUtil.htmlBody(body)
			 	 .senderDisplayName(UserInfo.getFirstName()+' '+UserInfo.getLastName())
			 	 .subject(subject)
			 	 .sendEmail();	
			 	 
    }
    
    //public transient List<List<UserWrapperCls>> uWrapperLst {get;set;}
    public List<List<UserWrapperCls>> uWrapperLst {get;set;}
    public static List<AMwrapperCls> amWrapperLst {get;set;}
    // Allow FAE ro select customers from specific account
    //public static Integer cnt=0;
    public List<List<UserWrapperCls>> getCustomerDetails(){
    	hiddenUsrIds='';
    	return uWrapperLst;
    }
    
    public List<AMwrapperCls> getAMDetails(){
    	hiddenUsrIds='';
    	system.debug('amWrapperLst !!!!!!!! '+amWrapperLst);
    	return amWrapperLst;
    }
    
    public void fetchAllManagers(){
    	system.debug('collaborator.Account__c >>>>>>>>> '+collaborator.Account__c);
    	amWrapperLst = new List<AMwrapperCls>();
    	list<Account_Team_Proxy__c> lst_ATP;
    	
    	if(collaborator.Account__c<>NULL){
    		lst_ATP=[SELECT Account__r.Name,Team_Role__c,User__r.Name,User__c 
    				 FROM Account_Team_Proxy__c
    				 WHERE Team_Role__c IN ('Primary Account Manager','Account Administrator','Account Manager') AND  User__r.IsActive = true
    				 AND Account__c =: collaborator.Account__c];
    	}
    	system.debug('lst_ATP @@@@@@@ '+lst_ATP);
    	if (lst_ATP<>NULL && !lst_ATP.isEmpty()){
    		for (Account_Team_Proxy__c ATP : lst_ATP){
    			AMwrapperCls amWrapper = new AMwrapperCls(false,ATP);
    			amWrapperLst.add(amWrapper);
    		}
    	}
    	system.debug('amWrapperLst ######## '+amWrapperLst);
    }
    
    public void fetchAllRelatedUsers(){
    	
    	List<UserWrapperCls> uWrapper= new List<UserWrapperCls>();
    	List<User> lst_Users;
    	system.debug('collaborator.Account__c >>>>>>>>> '+collaborator.Account__c);
    	//system.debug('Contact.AccountId >>>>>>>>>>>>> '+Contact.AccountId);
    	uWrapperLst = new List<List<UserWrapperCls>>();
    	if(collaborator.Account__c<>NULL){
    		lst_Users = [SELECT Id,Email,Name,MobilePhone 
						FROM User 
						WHERE IsActive = True
						AND Contact.AccountId = :collaborator.Account__c 
						ORDER BY Name DESC limit 2000];
    	}						
    	//UserWrapperCls uWrapperObj;
    	
    	if (lst_Users<>NULL && !lst_Users.isEmpty()){
    		 for (User usr : lst_Users){
    			// Need to write code for get existing users and mark them as selected
    			UserWrapperCls uWrapperObj = new UserWrapperCls(false,usr);
    			uWrapper.add(uWrapperObj);
    			
    			if (uWrapper.size() < 999){
    				continue;
    			} else {
    				uWrapperLst.add(uWrapper);
    				//uWrapper.clear();
    				uWrapper = new List<UserWrapperCls>();
    			}
    		}
    		
    		if (uWrapper.size()>0){
    			uWrapperLst.add(uWrapper);
    		}
    	}
    	//system.debug('uWrapperLst>>>>>>>>>>>>>> '+uWrapperLst.size());
    	//system.debug('uWrapper >>>>>>>>>>> '+uWrapper.size());
    
    	
    }
    
    // Get Customer details from specific Account
    public class UserWrapperCls {
    	
    	public boolean isSelected {get;set;}
    	public User userRecord {get;set;}
    	
    	public UserWrapperCls(boolean selected,User usr){
    		isSelected = selected;
    		userRecord = usr;
    	}
    }
    
    // get account manager details from ATP
    public class AMwrapperCls {
    	
    	public boolean isSelected {get;set;}
    	public Account_Team_Proxy__c ATP {get;set;}
    	
    	public AMwrapperCls (boolean selected,Account_Team_Proxy__c atp1){
    		isSelected = selected;
    		ATP = atp1;
    	}
    }
}