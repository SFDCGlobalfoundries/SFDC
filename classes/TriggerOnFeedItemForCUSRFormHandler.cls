/*
Author: Shyam Ravindra Nair
Description: Handler for TriggerOnFeedItemForCUSRForm trigger.
History:
SNair     23042015     - code creation
SNair     24042015     - modified
*/
public class TriggerOnFeedItemForCUSRFormHandler {
	public List<CuSR_Form__c> cusrFormList{get;set;}
	public List<Id> cusrFormIdList{get;set;}
	
	public void onBeforeDelete(List<FeedItem> oldFeedItemList){
		cusrFormList = new List<CuSR_Form__c>();
		cusrFormIdList = new List<Id>();
		for(FeedItem oldFeedItem: oldFeedItemList){
			if(oldFeedItem.Type == 'ContentPost'){
				cusrFormIdList.add(oldFeedItem.ParentId);
			}
		}
		if(cusrFormIdList.size() > 0){
			cusrFormList = [select Id, Status__c from CuSR_Form__c where Id IN: cusrFormIdList];
			if(cusrFormList.size() > 0){
				for(CuSR_Form__c cusrForm: cusrFormList){
					if(cusrForm.Status__c != 'New' && cusrForm.Status__c != 'Rejected'){
						oldFeedItemList[0].addError('You cannot delete the post as the Status of the CuSR Form is not New or Rejected.');
					}
				}
			}
		}
	}
	
	public void onBeforeInsert(List<FeedItem> newFeedItemList){
		cusrFormList = new List<CuSR_Form__c>();
		cusrFormIdList = new List<Id>();
		for(FeedItem newFeedItem: newFeedItemList){
			if(newFeedItem.Type == 'ContentPost'){
				cusrFormIdList.add(newFeedItem.ParentId);
			}
		}
		cusrFormList = [select Id, Name, Status__c from CuSR_Form__c where Id IN: cusrFormIdList];
		if(cusrFormList.size() > 0){
			for(CuSR_Form__c cusrForm: cusrFormList){
				for(FeedItem newFeedItem: newFeedItemList){
					String fileName = cusrForm.Name + '_' + newFeedItem.ContentFileName;
					newFeedItem.ContentFileName = fileName;
					String fileTitle = cusrForm.Name + '_' + newFeedItem.Title;
					newFeedItem.Title = fileTitle;
				}
			}
		}
	}
}