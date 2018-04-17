/**
* Author: Sreedhar Karukonda 
* This is Controller for Agreement Sync Page. The Page will be opened as Popup when user clicks "Sync Agreement" button "Agreement (Apttus__APTS_Agreement__c)" details view
* Action "synchronizeWithAccounts" will sync the agreement with related Accounts (either directly or through signatories) and all account's Valid Tech Geos will be updated if there is not error.
* If there is any error, popup window wil show the error. The same error will be put in Sync Erro Message field.
*
* Timeline: 
*		Created Mar 5, 2015
* 
**/

/*
* This class is intentionally without sharing. 
* Reason is :  we are updating Account which is private. Even user does not have edit permissions on related account record, 
* he should be able to update Agrement and so does account
*/

public without sharing class AgreementSyncPageCtrl {

	private final Apttus__APTS_Agreement__c agreement;

    public AgreementSyncPageCtrl(ApexPages.StandardController stdController) {
        this.agreement = (Apttus__APTS_Agreement__c)stdController.getRecord();
    }

    public String syncMessage{
    	get{
    		if(syncMessage  == null) syncMessage = 'Sync is in progress...';
    		return syncMessage;
    	}
    	set;
    }
    public boolean showWaiting{
    	get{
    		if(showWaiting == null) showWaiting = true;
    		return showWaiting;
    	}
    	set;
    }

    public boolean syncFailed{
    	get{
    		if(syncFailed == null) syncFailed = false;
    		return syncFailed;
    	}
    	set;
    }

    public PageReference synchronizeWithAccounts(){
    	Map<Id, Apttus__APTS_Agreement__c> agreementMap = new Map<Id, Apttus__APTS_Agreement__c>([SELECT Id, Name, RecordTypeId, Apttus__Status_Category__c, Apttus__Status__c FROM Apttus__APTS_Agreement__c where Id =: this.agreement.Id]);
        //AgreementSyncHandler.handler.afterInsert(new Map<Id, );
       	AgreementSyncHandler.handler.onAfterInsert(agreementMap);
       	Map<Id, Apttus__APTS_Agreement__c> agreementMapAfterSync = new Map<Id, Apttus__APTS_Agreement__c>([SELECT Id, Name, RecordTypeId, Apttus__Status_Category__c, Apttus__Status__c, (SELECT Id, Name, Sync_Error_Message__c, Sync_Failed__c from Agreement_To_Account_Sync_Status__r) FROM Apttus__APTS_Agreement__c where Id =: this.agreement.Id]);
       
       	if(agreementMapAfterSync.get(this.agreement.Id) != null && agreementMapAfterSync.get(this.agreement.Id).Agreement_To_Account_Sync_Status__r != null && agreementMapAfterSync.get(this.agreement.Id).Agreement_To_Account_Sync_Status__r.size() > 0){
       		syncMessage = agreementMapAfterSync.get(this.agreement.Id).Agreement_To_Account_Sync_Status__r[0].Sync_Error_Message__c.replace('\n', '<br/>');
       		syncMessage +='<br/> Please close this window and refresh agreement details page' ;
       	  syncFailed = agreementMapAfterSync.get(this.agreement.Id).Agreement_To_Account_Sync_Status__r[0].Sync_Failed__c;
        }else{
       		syncMessage = 'This agreement is not eligible for Synchronization <br/>Please close this window';
       	}
       
       showWaiting = false;
       
       return null;
    }
}