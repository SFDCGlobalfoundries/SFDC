/*
Author: Shyam Ravindra Nair
Description: Handler for TriggerOnContentDocumentForCuSRForm Trigger.
History:
SNair     30042015     - code creation
*/
public class TriggerOnContentDoForCuSRFormHandler {
    
    public void onBeforeDelete(String contentDocumentTitle, List<ContentDocument> oldContentDocumentList){
        List<CuSR_Form__c> cusrFormList = new List<CuSR_Form__c>();
        String title = contentDocumentTitle;
        title = title.length() >= 13 ? title.subString(0,13) : title;
        system.debug('Title is '+title);
        String query = 'select Id, Status__c from CuSR_Form__c where Name LIKE \'%'+title+'%\'';
        cusrFormList = database.query(query);
        if(cusrFormList != null && cusrFormList.size() > 0){
            for(CuSR_Form__c cusrForm: cusrFormList){
                if(cusrForm.Status__c != 'New' && cusrForm.Status__c != 'Rejected'){
                    for(ContentDocument oldContentDocument: oldContentDocumentList){
                        oldContentDocument.addError('You cannot delete the document as the Status of the CuSR Form is not New or Rejected.');
                    }
                }
            }
        }
        
    }
    
    public void deleteRMAAttachments(Set<Id> oldContentDocumentIds){
    	delete [SELECT ID FROM RMA_ATTACHMENT__C WHERE ATTACHMENT__C IN :oldContentDocumentIds];
    }

}