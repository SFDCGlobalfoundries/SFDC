trigger DRTaskTrigger on Task (after update) {
    list<Id> drApprovedIds = new list<Id>();
    list<Id> drDeployedIds = new list<Id>();
    list<Deployment_Request__c> tobeupdateddrs = new list<Deployment_Request__c>();
    for(Task t: trigger.new){
        if(t.Status == 'Completed'){
            if(t.Subject == 'Post Deployment Review'){
                drDeployedIds.add(t.WhatId);
            }
            
            if(t.Subject == 'Deployment Task'){
                drApprovedIds.add(t.WhatId);
            }
        }        
    }
    
    if(drApprovedIds.size() > 0){
        list<Deployment_Request__c> approvedDrs = [Select Id, Name, Stage_txt__c from Deployment_Request__c where Id IN :drApprovedIds];
        for(Deployment_Request__c dr :approvedDrs){
            dr.Stage_txt__c = 'Deployed';
            tobeupdateddrs.add(dr);
        }
    }
    
    if(drDeployedIds.size() > 0){
        list<Deployment_Request__c> deployedDrs = [Select Id, Name, Stage_txt__c from Deployment_Request__c where Id IN :drDeployedIds];
        for(Deployment_Request__c dr :deployedDrs){
            dr.Stage_txt__c = 'Closed';
            tobeupdateddrs.add(dr);
        }
    }
    
    upsert tobeupdateddrs;
}