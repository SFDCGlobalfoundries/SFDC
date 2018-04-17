trigger PWCADeleteAttachment on PWCA_Attachments__c (after delete) {

 if(Trigger.isDelete)
    {
    Map<String,String> mapId = new Map<String,String>();
    for(PWCA_Attachments__c accList : Trigger.old)
    {
    mapId.put(accList.Id,accList.OpenTextId__c+';');
    }
    PWCAReportUploadFile.CreateDeleteObject(mapId);
    
    }
}