trigger CPKDelete on CPK_Report__c (before insert, after insert, before update, after update, after delete) {
	
	QS_CPKReportTriggerHandler cpkReportTriggerHandler = new QS_CPKReportTriggerHandler(Trigger.isExecuting, Trigger.size);
    /* if(Trigger.isDelete)
    {
    Map<String,String> mapId = new Map<String,String>();
    for(CPK_Report__c cpkreport : Trigger.old)
    {
     String OtId=cpkreport.OpenTextId__c+';'+cpkreport.OpenTextIdPublish__c;
     mapId.put(cpkreport.Id,OtId);
    //mapId.put(accList.Id,accList.OpenTextId__c);
    //mapId.put(accList.Id,accList.OpenTextIdPublish__c);
    }
    ClsUpdateCPKReportOnReportUpload.CreateDeleteObject(mapId);
    }*/
    
    if(Trigger.isBefore){
    	
    	if(Trigger.isInsert){
    		cpkReportTriggerHandler.OnBeforeInsert(Trigger.New);
    	}
    	
    	if(Trigger.isUpdate){
			cpkReportTriggerHandler.OnBeforerUpdate(Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap);    		
    	}
    }else{
    	
    	if(Trigger.isInsert){
			cpkReportTriggerHandler.OnAfterInsert(Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap);
    	}
    	if(Trigger.isUpdate){
    		cpkReportTriggerHandler.OnAfterUpdate(Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap);
    	}
    	if(Trigger.isDelete){
    		cpkReportTriggerHandler.OnAfterDelete(Trigger.old);
    	}
    }
}