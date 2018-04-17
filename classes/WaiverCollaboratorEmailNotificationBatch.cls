/*
* @ Author :- Navneet rajput
* @ Description :- 
* @ Date :-
* @ Change History :-  
**/
global class WaiverCollaboratorEmailNotificationBatch implements Database.Batchable<sObject> {

    global Database.QueryLocator start(Database.BatchableContext BC){ 
    	
    	Date previousDate = date.Today().addDays(-2);
    	
         return Database.getQueryLocator([SELECT Id,Name,IsCustomerAcceptsRisk__c,Workflow_Status__c,Account_Short_Name__c,Account_Name__c,
         										Created_By_Shortname__c,Submitted_By_Shortname__c,Selected_AM__c,Selected_Customers__c,
         										IsCustomerAgreeToFix__c,IsGfAcceptsRisk__c,Is_releasedToCustomer__c,PTSR_Number__c,Waiver_Status__c
        								  FROM 	Wavier_Collaborator__c
        								  WHERE LastModifiedDate <= : previousDate
        								  AND IsCustomerAcceptsRisk__c=false
        								  AND IsCustomerAgreeToFix__c=false
        								  AND IsGfAcceptsRisk__c=false
        								  AND Waiver_Status__c='Rejected'
        								  AND PTSR_Status__c!='Closed'
        								]);
       
    }
    
    global void execute(Database.BatchableContext BC, List<Wavier_Collaborator__c> waiverList){
   		system.debug('Inside execute >>>>>>>>>> '+waiverList);     
        //Map<String,Set<Id>> mapOfCustNameUserIds = new Map<String,Set<Id>>();
        Map<Id,Set<Id>> mapOfFAEs = new Map<Id,Set<Id>>();
        Map<Id,Wavier_Collaborator__c> mapOfWaiverReport = new Map<Id,Wavier_Collaborator__c>();
        Map<Id,Set<Id>> mapOfPortalUsers = new Map<Id,Set<Id>>();
        List<Messaging.SingleEmailMessage> lstOfEmails = new List<Messaging.SingleEmailMessage>(); 
        List<String> uRoles = new List<String>{'Field Application Engineer','Primary Field Application Engineer'};
        List<String> atpManagers = new List<String>{'Primary Account Manager','Account Administrator','Account Manager'};  
		//Set<Id> AM_Users = DfmUtilityCls.getATPUsersByRole(collaborator.Account_Short_Name__c,atpManagers);
        
        if (waiverList<>NULL && !waiverList.isEmpty()){
            
            for (Wavier_Collaborator__c waiver : waiverList){
                
                mapOfWaiverReport.put(waiver.Id,waiver);
                Set<Id> setOfFAEs = DfmUtilityCls.getATPUsersByRole(waiver.Account_Short_Name__c,uRoles);
				Set<Id> setOfAMasFAE = DfmUtilityCls.getATPUsersByRoleFAEflag(waiver.Account_Short_Name__c);
                if(setOfAMasFAE != NULL && !setOfAMasFAE.isEmpty()){
                    setOfFAEs.addAll(setOfAMasFAE);
                }
				
                Set<Id> setOfPortalUsers = new Set<Id>(); //= DfmUtilityCls.getCustomers(waiver.Created_By_Shortname__c,waiver.Submitted_By_Shortname__c);
                Set<Id> setOfAM = DfmUtilityCls.getATPUsersByRole(waiver.Account_Short_Name__c,atpManagers);
                
                if (waiver.Selected_Customers__c<>NULL && !String.isEmpty(waiver.Selected_Customers__c)){
					for (String str : waiver.Selected_Customers__c.split(';')){
						setOfPortalUsers.add(Id.valueOf(str));
					}
				}  
                if (waiver.Is_releasedToCustomer__c == false){
                	sendEmailReminderToFAE4releaseToCustomer(waiver,setOfFAEs);
                }
                if (waiver.Is_releasedToCustomer__c == true){
                	sendReminderEmailToCustomer(waiver,setOfPortalUsers);
                	sendReminderEmailToFAE(waiver,setOfFAEs,setOfAM);
                }
            }
  
        }
       
    }
    
    // Send reminder email notification to customer
    private void sendReminderEmailToCustomer(Wavier_Collaborator__c waiver,Set<Id> customers){
    	
    	String primeDieName = DfmUtilityCls.getPrimeDieName(waiver.Id);
		String subject='Reminder: Your Response is required: '+waiver.Name+','+waiver.PTSR_Number__c+', '+primeDieName+' DFM Waiver Collaboration,'+waiver.Account_Name__c;
		List<String> toAddresses = DfmUtilityCls.getEmailIds(customers);
		List<String> ccAddresses = null;
		List<String> bccAddresses = new List<String>{'Gfv.do.not.reply@globalfoundries.com'};
		DfmEmailUtility emailUtil = new DfmEmailUtility(toAddresses,ccAddresses,bccAddresses);
		
		String body = '<html><body>'
						+'<h3>Title: Reminder for Your Response to Waiver Rejection Notification</h3><br>'
						+'Your request of DFM waiver for '+ primeDieName+' has been rejected.<br>'
						+'<p>Your prompt choice of action is required in the Design Waiver Collaborator:<p><br>'
						+System.Label.DFM_Customer_URL+'/' + waiver.Id+'<br>'
						+'<b>Issue Title:</b> DFM Waiver Collaboration File> '+waiver.PTSR_Number__c+'<br>'
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
    // Take appropriate action of DFM reminder email to FAE
    private void sendReminderEmailToFAE(Wavier_Collaborator__c waiver,set<Id> FAEs,set<Id> AM){
    	
    	String primeDieName = DfmUtilityCls.getPrimeDieName(waiver.Id);
		String subject='Reminder: Your action is required:'+waiver.Name+','+waiver.PTSR_Number__c+', '+primeDieName+' DFM Waiver Collaboration,'+waiver.Account_Name__c;
		List<String> toAddresses = DfmUtilityCls.getEmailIds(FAEs);
		List<String> ccAddresses = DfmUtilityCls.getEmailIds(AM);
		List<String> bccAddresses = new List<String>{'Gfv.do.not.reply@globalfoundries.com'};
		DfmEmailUtility emailUtil = new DfmEmailUtility(toAddresses,ccAddresses,bccAddresses);
		
		String body = '<html><body>'
						+'<h3>Title: FAE Action Notification for Customer Response</h3><br>'
						+'<p>The DFM waiver for '+ primeDieName+' has been rejected and customer has not been responding to agree to design fixes or accepting risk.' 
						+'Please proceed to discuss with AM and the customer. If no positive response, you may trigger for foundry-to-risk approval in the Design Waiver Design Waiver Collaborator<br>'
						+ URL.getSalesforceBaseUrl().toExternalForm() +'/' + waiver.Id+'</p>'
						+'<b>Issue Title:</b> DFM Waiver Collaboration File '+waiver.PTSR_Number__c+'<br>'
						+'<b>Aggregated Waiver Review Status:</b> '+waiver.Waiver_Status__c+'<br>'
						+'<b>Collaborator Workflow Status:</b>'+waiver.Workflow_Status__c+'<br>'
						+'<b>Access the following URL to see DFM Waiver File: </b>'
						+URL.getSalesforceBaseUrl().toExternalForm() +'/' + waiver.Id+'<br><br>'
						+'</html></body>';	 
		//send plain text body
		emailUtil.htmlBody(body)
			 	 .senderDisplayName(UserInfo.getFirstName()+' '+UserInfo.getLastName())
			 	 .subject(subject)
			 	 .sendEmail();
    	
    }
    // release waiver report to customer reminder email
    private void sendEmailReminderToFAE4releaseToCustomer(Wavier_Collaborator__c waiver,set<Id> FAEs){
		
			String primeDieName = DfmUtilityCls.getPrimeDieName(waiver.Id);
			String subject='Reminder: Your Approval is required: '+waiver.Name+','+waiver.PTSR_Number__c+', '+primeDieName+' DFM Waiver Collaboration,'+waiver.Account_Name__c;
			List<String> toAddresses = DfmUtilityCls.getEmailIds(FAEs);
			List<String> ccAddresses = null;
			List<String> bccAddresses = new List<String>{'Gfv.do.not.reply@globalfoundries.com'};
			DfmEmailUtility emailUtil = new DfmEmailUtility(toAddresses,ccAddresses,bccAddresses);
			
			String body = '<html><body>'
							+'<h3>Title: Reminder for Approval for Waiver Rejection Notification to Customer</h3><br>'
							+'The DFM waiver for '+ primeDieName+' has been rejected by '+UserInfo.getFirstName()+' '+UserInfo.getLastName()+'<br>'
							+'<p> Action Required: Waiver report is pending your review and approval to release to customer for design fixes / accepting risk in the Design Waiver Collaborator:<p><br>'
							+URL.getSalesforceBaseUrl().toExternalForm() +'/' + waiver.Id+'<br>'
							+'<font color="red">Proceed to release </font> = Trigger Collaborator to release the waiver rejection report and email notify the customer <br>'
							+'<b>Issue Title:</b> DFM Waiver Collaboration File '+waiver.PTSR_Number__c+'<br>'
							+'<b>Aggregated Waiver Review Status:</b> '+waiver.Waiver_Status__c+'<br>'
							+'<b>Collaborator Workflow Status:</b> '+waiver.Workflow_Status__c+'<br>'
							+'<b>Access the following URL to see DFM Waiver File: </b>'
							+URL.getSalesforceBaseUrl().toExternalForm() +'/' + waiver.Id+'<br><br>'
						+'</html></body>';	 
			//send plain text body
			emailUtil.htmlBody(body)
				 	 .senderDisplayName(UserInfo.getFirstName()+' '+UserInfo.getLastName())
				 	 .subject(subject)
				 	 .sendEmail();    
				 	 	
    }
    
    global void finish(Database.BatchableContext BC){
        
    }
}