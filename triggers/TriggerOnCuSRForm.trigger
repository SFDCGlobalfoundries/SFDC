/*
Author: Shyam Ravindra Nair
Description: Trigger for CuSR Form.
History:
SNair     24112014     - code creation
SNair     30012015     - updated logic for sending emails to notification group
*/
trigger TriggerOnCuSRForm on CuSR_Form__c (after insert, after update, before update) {
    
    TriggerOnCuSRFormHandler handler  = new TriggerOnCuSRFormHandler();
    
    if (!IntegrationUserUtil.isSkipTrigger()) {
    	if(trigger.isAfter && trigger.isInsert){
	        handler.provideAccess(trigger.new);
	    }  
	    if(trigger.isAfter && trigger.isUpdate){
	    	for(CuSR_Form__c cusrRecord: trigger.new){
	    		if(cusrRecord.Status__c == 'New' || cusrRecord.Status__c == 'Implemented' || cusrRecord.Status__c == 'Rejected' ){
	    			handler.onBeforeUpdate(trigger.new);
	    		}
	    		/*if(cusrRecord.Status__c == 'Pending AM Review'){
	    			handler.afterPendingAMReview(trigger.new);
	    		}*/
	    	}
	    	handler.onAfterUpdate(trigger.new);
	        for(CuSR_Form__c oldCuSRForm: trigger.old){
	        	for(CuSR_Form__c newCuSRForm: trigger.new){
	        		if(oldCuSRForm.Status__c == 'Pending Stakeholder Review' && newCuSRForm.Status__c == 'Pending PM Review'){
	        			handler.sendEmailForPMApproval(trigger.new);
	        		}
	        		if((oldCuSRForm.Status__c == 'Pending Implementation' && newCuSRForm.Status__c == 'Implemented')||(oldCuSRForm.Status__c == 'Pending AM Review' && newCuSRForm.Status__c == 'Implemented')||(oldCuSRForm.Status__c == 'Pending PM Review' && newCuSRForm.Status__c == 'Implemented')){
	        			handler.notifyGroupAndCustomer(trigger.new);
	        		}
	        		if(newCuSRForm.Status__c == 'Implemented' && oldCuSRForm.Remark__c != newCuSRForm.Remark__c){
	                    handler.notifyInitiatorAndNotificationGroupOnUpdate(trigger.new);
	                }
                    if(oldCuSRForm.Fifth_Day_Reminder__c == false && newCuSRForm.Fifth_Day_Reminder__c && newCuSRForm.Ninth_Day_Reminder__c == false){
                        handler.sendFirstReminder(newCuSRForm.Id);
                    }
                    if(oldCuSRForm.Ninth_Day_Reminder__c == false && newCuSRForm.Ninth_Day_Reminder__c && newCuSRForm.Fifth_Day_Reminder__c){
                        handler.sendSecondReminder(newCuSRForm.Id);
                    }
	        	}
	        }
	    }
	    
	    if(trigger.isBefore && trigger.isUpdate){
	    	for(CuSR_Form__c oldCuSRForm: trigger.old){
	            for(CuSR_Form__c newCuSRForm: trigger.new){
	                if((oldCuSRForm.Status__c == 'Pending Implementation' || oldCuSRForm.Status__c == 'Pending PM Review' || oldCuSRForm.Status__c == 'Pending AM Review') && newCuSRForm.Status__c == 'Implemented'){
	                    newCuSRForm.Implemented_Date__c = date.today();
	                }
	            }
	        }
	        for(CuSR_Form__c newCuSRForm: trigger.new){
	        	if(newCuSRForm.Status__c == 'Implemented'){
	        		handler.checkFabAfterImplementation(trigger.old, trigger.new);
	        	}
	        }
	    }	
    }
    
}