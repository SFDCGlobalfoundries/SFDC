/*
Author: Shyam Ravindra Nair
Description: Trigger on Attachment for CuSR Form.
History:
SNair     28042015     - code creation
*/
trigger TriggerOnAttachmentForCuSR on Attachment (before delete) {

	List<CuSR_Implementation__c> cusrImpementationList = new List<CuSR_Implementation__c>();
	List<Id> parentIdList = new List<Id>();
	
	if (!IntegrationUserUtil.isSkipTrigger()){
		if(trigger.isBefore && trigger.isDelete){
			for(Attachment oldAttachment: trigger.old){
				parentIdList.add(oldAttachment.ParentId);
			}
			if(parentIdList.size() > 0){
				cusrImpementationList = [select Id, Status__c from CuSR_Implementation__c where Id IN: parentIdList];
				if(cusrImpementationList.size() > 0){
					for(CuSR_Implementation__c cusrImplementation: cusrImpementationList){
						if(cusrImplementation.Status__c == 'Completed' || cusrImplementation.Status__c == 'Cancelled'){
							for(Attachment oldAttachment: trigger.old){
								oldAttachment.addError('You cannot delete the attachment as the Implementation Task is Completed/Cancelled.');
							}
						}
					}
				}
			}
		}
	}
}