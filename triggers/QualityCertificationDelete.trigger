/**
 * Author: 
 * Company: Cognizant Technology Solutions Asia Pacific Pte Ltd
 * Description: It is a QualityCertificationDelete trigger. It handles trigger events after delete and update.
 *            
 * History:
 * <Vijay>     11032014 - commented code from Line No.26 to Line No.42. The publishing documents business logic moved into QS_QualityCertificateTriggerHandler class
 */

trigger QualityCertificationDelete on Quality_Certificate__c (after delete,after update) {
    
    QS_QualityCertificateTriggerHandler qualityCertTriggerHandler = new QS_QualityCertificateTriggerHandler(Trigger.isExecuting, Trigger.size);
    if(Trigger.isDelete)
    {
        Map<String,String> mapId = new Map<String,String>();
        for(Quality_Certificate__c accList : Trigger.old)
        {
             String OtId=accList.OpenTextId__c+';'+accList.OpenTextIdPublish__c;
             mapId.put(accList.Id,OtId);
        //mapId.put(accList.Id,accList.OpenTextId__c);
        //mapId.put(accList.Id,accList.OpenTextIdPublish__c);
        }
        QCNewRecord.CreateDeleteObject(mapId);
    }
    if(Trigger.isUpdate){
        /*
        List<UploadQC__c> LUploadQC = new List<UploadQC__c>();
        Map<Id,Quality_Certificate__c> MQCs=new Map<Id,Quality_Certificate__c>([Select Id,Name,(Select Id,Name,Ready_to_Publish__c from UploadQC__r) from Quality_Certificate__c where id in :Trigger.newmap.keyset()]);
        for(Quality_Certificate__c accList : Trigger.new)
        { 
            if(acclist.Stage__c=='Approved'){
                for(UploadQC__c eachUploadQc : MQCs.get(acclist.Id).UploadQc__r){
                     eachUploadQc.Ready_To_Publish__c=true;  
                     LUploadQC.add(eachUploadQc);                
                }
            
            
            }
    
        }
        Database.update(LUploadQC);
        */
        qualityCertTriggerHandler.OnAfterUpdate(Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap);
    }
}