/*
Author: Shyam Ravindra Nair
Description: Trigger for CuSR Form.
History:
SNair     24112014     - code creation
SNair     31122014     - updated logic for AM Approval
*/

trigger TriggerOnCuSRApprovalProcess on CuSR_Approval_Process__c (after update, after insert) {

    TriggerOnCuSRApprovalProcessHandler handler = new TriggerOnCuSRApprovalProcessHandler();
    
    if(!IntegrationUserUtil.isSkipTrigger()){
    	if(trigger.isUpdate && trigger.isAfter){
	        handler.updateStatusOfCuSRFormOnUpdate(trigger.new);
	        for(CuSR_Approval_Process__c newCuSRApproval: trigger.new){
	        	if(newCuSRApproval.Type_of_Approver__c == 'AM'){
	        		handler.sendEmailToAMForApproval(trigger.old, trigger.new);
	        	}
	        	if(newCuSRApproval.Status__c == 'Pending Approval' && (newCuSRApproval.Remind_On_3rd_Day__c || newCuSRApproval.Remind_On_7th_Day__c)){
	        		handler.sendReminder(trigger.new);
	        	}
	        }
	        for(CuSR_Approval_Process__c oldCuSRApproval: trigger.old){
	        	for(CuSR_Approval_Process__c newCuSRApproval: trigger.new){
	        		if(oldCuSRApproval.Status__c == 'Pending Approval' && newCuSRApproval.Status__c == 'Approved'){
	        			handler.setFabOnScopeFieldOnApproval(trigger.new);	        		}
	        	}
	        }
	    }	
    }
    
    
    //Added by Abhita
    if(trigger.isAfter && trigger.isInsert){
        handler.provideAccessApproval(trigger.new);
    }
}