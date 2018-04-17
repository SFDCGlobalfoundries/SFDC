/**
 * Author: 
 * Company: Cognizant Technology Solutions Asia Pacific Pte Ltd
 * Description: It is a deletePWCAPublication trigger. It handles trigger events after delete and update.
 *            
 * History:
 * <Vijay>     04032014 - commented code from Line No.26 to Line No.42. The publishing documents business logic moved into QS_PWCAPublicationTriggerHandler class
 */

trigger deletePWCAPublication on PWCA_publication__c (after delete,after update) {
QS_PWCAPublicationTriggerHandler pwcaPublicationTriggerHandler = new QS_PWCAPublicationTriggerHandler(Trigger.isExecuting, Trigger.size);
if(Trigger.isDelete)
    {
    Map<String,String> mapId = new Map<String,String>();
    for(PWCA_publication__c accList : Trigger.old)
    {
    String OtId=accList.OpenTextId__c+';'+accList.OpenTextIdPublish__c;
    mapId.put(accList.Id,OtId);
    //mapId.put(accList.Id,accList.OpenTextId__c);
    //mapId.put(accList.Id,accList.OpenTextIdPublish__c);
    }
    PWCAReportUploadFile.CreateDeleteObject(mapId);
    
    }
    if(Trigger.isUpdate){
        /*
        Set<Id> SPWCAs=new Set<Id>();
        for(PWCA_publication__c accList : Trigger.new){
            SPWCAs.add(accList.Id);    
        }
        Map<Id,PWCA_publication__c> MPWCAs=new Map<Id,PWCA_publication__c>([Select Id,Name ,(Select Id,Name,ready_to_Publish__c from PWCA_Attachments__r) from PWCA_publication__c where id in :(SPWCAs)]);
        List<PWCA_Attachments__c> LPWCAAttachments = new List<PWCA_Attachments__c>();
        for(PWCA_publication__c eachPWCApublication : Trigger.new){
            if(eachPWCApublication.Ready_to_Publish__c==true){    
                    for(PWCA_Attachments__c eachPWCAAttachment : MPWCAs.get(eachPWCApublication.Id).PWCA_Attachments__r){
                        eachPWCAAttachment.Ready_to_Publish__c=true;
                        LPWCAAttachments.add(eachPWCAAttachment);        
                    } 
                }    
        }
        database.update(LPWCAAttachments,false);
        */
        pwcaPublicationTriggerHandler.OnAfterUpdate(Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap);

    }
}