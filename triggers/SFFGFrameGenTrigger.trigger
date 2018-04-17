/**
* Author: Devendra Babu Itraju
* Company: GF
* Project: Standard Foundry Frame Generation 
* Description: 
*  
*  
* History:
*    <Devendra Babu Itraju> 2016-03-10 - Created
	 <Devendra Babu Itraju> 10-Aug-2017 - Updated for sending error email notification
**/
trigger SFFGFrameGenTrigger on SFFG_Standard_Foundry_Frame__c (before update,after update) {
    
    set<id> isChangedSet=new set<id>();
    
    set<id> isFrameCreatedSet=new set<id>();
    
    if(trigger.isbefore){
        for(SFFG_Standard_Foundry_Frame__c f:trigger.new){
            if(f.isChanged__c && !trigger.oldMap.get(f.id).isChanged__c && trigger.oldMap.get(f.id).SWIFT_PTRF_ID__c!=null){
                f.isChanged__c=false;isChangedSet.add(f.id);
            }
        }
        
        if(!isChangedSet.isempty()){SFFGFrameGenTriggerHandlerCtrl.sendNotification(isChangedSet,false);
        }
    }
    
    if(trigger.isafter){
        for(SFFG_Standard_Foundry_Frame__c f:trigger.new){
            if(f.SWIFT_PTRF_ID__c!=null && (trigger.oldMap.get(f.id).SWIFT_PTRF_ID__c==null))isFrameCreatedSet.add(f.id);
            if(f.SWIFT_Status__c=='Error')SFFGTriggerPTRFCtrl.sendErrorEmail(f,f.SWIFT_Response__c);
        }
        
        if(!isFrameCreatedSet.isempty()){
            SFFGFrameGenTriggerHandlerCtrl.sendNotification(isFrameCreatedSet,true);
        }
    }
    
    
    
    
}