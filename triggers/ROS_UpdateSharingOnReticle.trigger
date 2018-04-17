trigger ROS_UpdateSharingOnReticle on Reticle__c (after update,after insert,after delete,before update){
    
    Map<Id,Reticle__c> newMap = new Map<Id,Reticle__c>();
    Map<Id,Reticle__c> OldMap = new Map<Id,Reticle__c>();
    if((ROS_Triggers_Bypass__c.getInstance('ROS_UpdateSharingOnReticle').Username__c==null) || 
       (UserInfo.getUserName()!=ROS_Triggers_Bypass__c.getInstance('ROS_UpdateSharingOnReticle').Username__c)){ 

        List<AsyncApexJob> BatchJob = new List<AsyncApexJob>([ SELECT Id, Status, ApexClass.Name FROM AsyncApexJob 
                                                               WHERE (ApexClass.Name = 'ROS_BatchRTDW' OR ApexClass.Name = 'ROS_BATCH_ActiveReticleDailyLoad')
                                                                   AND Status =: 'Processing' LIMIT 1 ]);
        if(BatchJob.isEmpty()){
            
            if(Trigger.isBefore && Trigger.IsUpdate){
                ROS_ReticleTriggerHelper.ROSReticleBeforeUpdate(Trigger.New,Trigger.oldMap);
            }
            
            if(Trigger.isAfter && Trigger.IsUpdate){
                for(Reticle__c Res : Trigger.New){
                    if(Res.Reticle_Workflow_Status__c != Trigger.oldMap.get(Res.Id).Reticle_Workflow_Status__c){
                        newMap.put(Res.Id,Res);
                        OldMap.put(Res.Id,Trigger.oldMap.get(Res.Id));
                    }                                     
                }
                if(newMap.values().size() > 0){
                    ROS_ReticleTriggerHelper.ROSReticleafterUpdate(newMap,OldMap);
                }
                              
            }
            
            //DBiswal 06182015
            if(Trigger.isAfter){
                if(Trigger.isUpdate){
                    ROS_ReticleTriggerHelper.updatePIYESharingforFab(Trigger.newMap,Trigger.oldMap,'After Update');
                }
            }
        }
        if(Trigger.isAfter && Trigger.IsUpdate){
            List<Reticle__c> lstReticleToProcess = new List<Reticle__c>();
            for(Reticle__c eachReticle : Trigger.New){
                //Shuchi - For Granting Sharing Records on Account Change - 17/Feb/15
                if(eachReticle.Account__c != Trigger.oldMap.get(eachReticle.Id).Account__c ){                       
                   lstReticleToProcess.add(eachReticle);
                }
            } 
            //Shuchi - For Granting Sharing Records on Account Change - 17/Feb/15
            if(lstReticleToProcess != NULL && !lstReticleToProcess.isEmpty()){
                ROS_ReticleTriggerHelper.ROSReticleafterUpdateAccountSharing(lstReticleToProcess);
            }               
        }
        
    }

}