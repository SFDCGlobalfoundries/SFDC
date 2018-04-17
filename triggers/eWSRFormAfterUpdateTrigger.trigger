/*
    Author : Abhita Bansal
    Description : This trigger is used to send the Emails to Notification Group on Final Approval and Update the Remaining Quantity on update of Form
    Code Creation: 21/11/2014
*/
trigger eWSRFormAfterUpdateTrigger on eWSR_Form__c(after update) {
	
	String fab7RecTypeId;
	List<RecordType> eWSRFormRecordTypeList = [select Id, DeveloperName from RecordType where SobjectType = 'eWSR_Form__c'];
	for(RecordType eWSRFormRecordType: eWSRFormRecordTypeList){
		if(eWSRFormRecordType.DeveloperName == eWSRConstantsVariablesClass.FAB7RECTYPEDEVNAME){
			fab7RecTypeId = eWSRFormRecordType.Id;
		}
	}
  
     List<eWSR_Form__c> formEmailList = new List<eWSR_Form__c>();
     List<eWSR_Form__c> formRemList = new List<eWSR_Form__c>();
     List<eWSR_Form__c> formAfterSubmissionList = new List<eWSR_Form__c>();
     List<eWSR_Form__c> statusList = new List<eWSR_Form__c>();
     
     if(!IntegrationUserUtil.isSkipTrigger()){
     
	     for(eWSR_Form__c forms : trigger.new){
	         if(forms.Status__c != trigger.oldMap.get(forms.Id).Status__c && forms.Status__c == eWSRConstantsVariablesClass.STATUSAPPROVED){
	             formEmailList.add(forms);
	         }    
	         if(forms.UpdateRemQuanOnApproval__c || (forms.UpdateRemQuanOnRejection__c && trigger.oldMap.get(forms.Id).Status__c != forms.Status__c) || forms.Status__c == eWSRConstantsVariablesClass.STATUSAPPROVED){
	             formRemList.add(forms);
	         }
	         
	         
	     }
	     for(eWSR_Form__c oldForm: trigger.old){
	     	for(eWSR_Form__c newForm: trigger.new){
	     		if((newForm.RecordTypeId != fab7RecTypeId && oldForm.Status__c == eWSRConstantsVariablesClass.STATUSPENDINGWITHSUPERVISOR) || (newForm.RecordTypeId == fab7RecTypeId && oldForm.Status__c == eWSRConstantsVariablesClass.STATUSPENDINGWITHPROGMANAGER)){
	     			if(newForm.Status__c == eWSRConstantsVariablesClass.STATUSNEW || newForm.Status__c == eWSRConstantsVariablesClass.STATUSREJECTED){
	     				formAfterSubmissionList.add(newForm);
	     			}
	     		}
	     	}
	     }
	     
	     if(!formEmailList.isEmpty()){
	         eWSRSendEmailtoNotiGroupClass.sendEmail(formEmailList);
	     }
	     
	     if(!formRemList.isEmpty()){
	         eWSRUpdateRemQuanClass.updateRemQuan(formRemList);
	         //eWSRUpdateFormAfterSubmissionClass.updateFormSubmission(formRemList);
	     }
	     if(!formAfterSubmissionList.isEmpty()){
	     	eWSRUpdateRemQuanClass.updateRemQuanAfterSubmission(formAfterSubmissionList); 
	     }
	     
     }
}