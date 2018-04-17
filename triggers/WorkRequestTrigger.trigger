trigger WorkRequestTrigger on Bug__c(after insert, before update, after update)
{    
    list<Bug__c> wrNewList = new list<Bug__c>();
    list<Bug__c> wrOldList = new list<Bug__c>();
    Map<id, Bug__c> wrOldMap  = new Map<id, Bug__c>();
    bug__c oldObj;
    list<Bug__c> srNewList = new list<Bug__c>();
    list<Bug__c> srOldList = new list<Bug__c>();
    Map<id, Bug__c> srOldMap  = new Map<id, Bug__c>();
       
    if (!IntegrationUserUtil.isSkipTrigger())
    {
        if (Trigger.isInsert){
           for(bug__c objbug : Trigger.new)
                {
                    if(objbug.IsPDKRequest__c )
                    {                       
                       wrNewList.add(objbug);
                    }else if(objbug.Record_Type_API__c =='Simulation_Request'){
                       srNewList.add(objbug);
                    }
                }        
            if(wrNewList.size() > 0)
            {    
                WorkRequestTriggerHandler handler = new WorkRequestTriggerHandler();
                if (Trigger.isInsert && Trigger.isAfter) {handler.OnAfterInsertWorkRequest(wrNewList);}          
            }else if(srNewList.size() > 0){
                SimulationRequestHandler handler = new SimulationRequestHandler();
                if (Trigger.isInsert && Trigger.isAfter) {handler.onAfterInsertSimulationRequest(srNewList);} 
            }
        }else if(Trigger.isUpdate){
            for(bug__c objbug : Trigger.new)
                {
                    if(objbug.IsPDKRequest__c )
                    {
                        oldObj = Trigger.oldMap.get(objbug.Id);
                        wrNewList.add(objbug);
                        wrOldList.add(oldObj);
                        wrOldMap .put(oldObj.Id, oldObj);
                    }else if(objbug.Record_Type_API__c =='Simulation_Request'){
                       srNewList.add(objbug);
                       oldObj = Trigger.oldMap.get(objbug.Id);
                       srOldList.add(oldObj);
                       srOldMap .put(oldObj.Id, oldObj);
                    }
                }        
            if(wrNewList.size() > 0)
            {    
                WorkRequestTriggerHandler handler = new WorkRequestTriggerHandler();
                if (Trigger.isUpdate && Trigger.isBefore) {handler.OnBeforeUpdateWorkRequest(wrOldList, wrNewList, wrOldMap );} 
                else if (Trigger.isUpdate && Trigger.isAfter) {handler.OnAfterUpdateWorkRequest(wrOldList, wrNewList, wrOldMap );}            
            }else if(srNewList.size() > 0){
                SimulationRequestHandler handler = new SimulationRequestHandler();
                if (Trigger.isUpdate && Trigger.isAfter) {handler.onAfterUpdateSimulationRequest(srOldList, srNewList, srOldMap );}  
            }
        }
    }    
}