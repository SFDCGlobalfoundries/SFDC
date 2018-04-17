/*
*@ Author		:- Navneet Rajput 
*@ Company		:- Cognizant technology
*@ Date			:- 26/06/2014
*@ Description	:- #CR27641 : Below batch will execute in every 1 hr of time interval and it will take all document provisioning records 
							  whith status Send For Approval and send they for approval to document provisioning owner and update isSendForApproval
							  Field to false (next time same record need to send for approval again)	
*@ History		:- 
*/

global class FV_DocumentProvisioningBatchCls implements Database.Batchable<sObject>{
	
	global Database.querylocator start(Database.BatchableContext BC){
		
            return Database.getQueryLocator([SELECT ID,
            										Status__c,
            										isSendForApproval__c
            								 FROM 	Document_Provisioning__c
            								 WHERE 	Status__c='Sent For Approval'
            								 AND 	isSendForApproval__c=true]);
    }

	// Execute document provisioning request
	global void execute(Database.BatchableContext BC, List<sObject> listOfDocuments){
		Set<Id> documentIdSet = new Set<Id>();
		List<Approval.ProcessSubmitRequest> requests = new List<Approval.ProcessSubmitRequest> ();
		Approval.ProcessResult[] processResults = null;
		Map<ID,ID> mapOfApprovalIds = new Map<ID,ID>();
		List<Document_Provisioning__c> listOfprovisionedDocuments = new List<Document_Provisioning__c>();
		system.debug('listOfDocuments>>>>>>>>>>>>>>>>>>>>>'+listOfDocuments); 
		
		Savepoint savePt = Database.setSavepoint();
		try {
			if(listOfDocuments<>Null && !listOfDocuments.isEmpty()){
			    for(Document_Provisioning__c pDocument : (List<Document_Provisioning__c>) listOfDocuments){
			   		// Approval process
		            Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
		            req.setComments('Submitted for approval. Please approve.');
		            req.setObjectId(pDocument.Id);
		            requests.add(req); 
		            // Update isApproval check
		            pDocument.isSendForApproval__c=false;
		            listOfprovisionedDocuments.add(pDocument);
			    }   
			}
            processResults = Approval.process(requests,false);
        	if(listOfprovisionedDocuments<>Null && !listOfprovisionedDocuments.isEmpty()){
        		update listOfprovisionedDocuments;
        	}
            
        } catch (System.DmlException e) {
            System.debug('Exception Is ' + e.getMessage());
            Database.rollback(savePt);
        } 
	}
	// Send email notification as well as track failures of document provisioning	
	global void finish(Database.BatchableContext BC){
		
	}
}