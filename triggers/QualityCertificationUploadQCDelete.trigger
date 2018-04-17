trigger QualityCertificationUploadQCDelete on UploadQC__c (before delete,after delete,after insert,after update) {
    Set<Id> idSet = new Set<Id>();
    Map<Id,set<ID>> idMap = new Map<Id,set<Id>>();
    Map<Id,Id> MIdQCIds = new Map<Id,Id>();
    Map<Id,Quality_Certificate__c> MQualityCerts;
    Map<Id,Quality_Certificate__c> MdelQualityCerts;
    /*
    Id QCafterApprovalRTId;
    SObject obj;
    Schema.SObjectType targetType = Schema.getGlobalDescribe().get('Quality_Certificate__c');
    obj = targetType.newSObject();
    Schema.DescribeSObjectResult d = obj.getSObjectType().getDescribe(); 
    Map<String,Schema.RecordTypeInfo> rtMap = new Map<String,Schema.RecordTypeInfo>(d.getRecordTypeInfosByName());
    Schema.RecordTypeInfo rtInfo = rtMap.get('CertificationQualityafterUploadQcApproval');
    QCafterApprovalRTId=rtInfo.getRecordTypeId();
    
    */
    
    if(Trigger.IsUpdate || Trigger.IsInsert){
    for(UploadQC__c eachUploadQC : Trigger.new){
    MIdQCIds.put(eachUploadQC.Id,eachUploadQC.Quality_Certificate__c);    
    }

    MQualityCerts=new Map<Id,Quality_Certificate__c>([Select Id,Name,RecordTypeId from Quality_Certificate__c where Id in :MIdQCIds.values()]);
    }
    
    if(Trigger.isDelete && Trigger.isAfter)
    {
        Map<String,String> mapId = new Map<String,String>();
        for(UploadQC__c accList : Trigger.old)
        {
            mapId.put(accList.Id,accList.OpenTextId__c+';');
        }
        QCNewRecord.CreateDeleteObject(mapId);
    
    }  
    if(Trigger.isDelete && Trigger.isBefore)
    {
      Map<Id,Id> MUploadToQCIds=new Map<Id,Id>();
      for(UploadQC__c accList : Trigger.old){
          MUploadToQCIds.put(accList.Id,accList.Quality_Certificate__c);
      }  
      MdelQualityCerts=new Map<Id,Quality_Certificate__c>([Select Id,Stage__c from Quality_Certificate__c where id in :(MUploadToQCIds.values())]);
      
      for(UploadQC__c accList : Trigger.old){
      
          if(MdelQualityCerts.get(MUploadToQCIds.get(accList.Id)).Stage__c!='Draft' && MdelQualityCerts.get(MUploadToQCIds.get(accList.Id)).Stage__c!='Rejected'){
          
          accList.addError('Document cannot be deleted once the Quality Certificate is approved');
          
          }
      }
    
    
    
    
    }
   /* if(Trigger.isInsert)
        {
        for(UploadQC__c accList : Trigger.new)
        {
            idSet.add(accList.Approver_QC__c);
            idMap.put(accList.Quality_Certificate__c,idSet);
            //if(Trigger.newMap.get(accList.Id).Stage__c=='Approved'){            
            //    MQualityCerts.get(MIdQCIds.get(accList.Id)).RecordTypeId=QCafterApprovalRTId;            
            //}
            //update MQualityCerts.values();
        }
        QCNewRecord qcr = new QCNewRecord();
        qcr.shareToQAandPIDetail(idMap);
        }
        */
   /* if(Trigger.isUpdate && Trigger.IsAfter){
        System.debug('-----Inside Update Trigger');
        for(UploadQC__c qcList : Trigger.new)
        {
            if(Trigger.oldMap.get(qcList.Id).Approver_QC__c != Trigger.newMap.get(qcList.Id).Approver_QC__c)
            {
                idSet.add(qcList.Approver_QC__c);
                idMap.put(qcList.Quality_Certificate__c,idSet);
            }
           // if((Trigger.oldMap.get(qcList.Id)).Stage__c!='Approved' && Trigger.newMap.get(qcList.Id).Stage__c=='Approved'){            
           //    MQualityCerts.get(MIdQCIds.get(qcList.Id)).RecordTypeId=QCafterApprovalRTId;            
           //}
       }
       System.debug(';;;;;;;;'+MQualityCerts);
       //update MQualityCerts.values();
    QCNewRecord qcr = new QCNewRecord();
    qcr.shareToQAandPIDetail(idMap);
  }
  */
    
      
               
            
         
      
      
}