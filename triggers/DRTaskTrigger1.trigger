trigger DRTaskTrigger1 on DR_Task__c (after update) {
    list<Id> drApprovedIds = new list<Id>();
    list<Id> drDeployedIds = new list<Id>();
    list<Deployment_Request__c> tobeupdateddrs = new list<Deployment_Request__c>();
    for(DR_Task__c t: trigger.new){
        if(t.Status__c == 'Completed'){
            if(t.Subject__c == 'Post Deployment Review'){
                drDeployedIds.add(t.Deployment_Request__c);
            }
            
            if(t.Subject__c == 'Deployment Task'){
                drApprovedIds.add(t.Deployment_Request__c);
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