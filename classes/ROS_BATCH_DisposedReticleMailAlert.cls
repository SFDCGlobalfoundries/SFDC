public class ROS_BATCH_DisposedReticleMailAlert implements Database.Batchable<sObject> {
    
    public Database.queryLocator start(Database.BatchableContext batchableContext) {
       return Database.getQueryLocator('SELECT parentId' +
                                          + ', userOrGroupId' +
                                          + ', Parent.Name ' + 
                                     + 'FROM Reticle__Share ' +
                                     + 'WHERE (Parent.Reticle_workflow_Status__c = \'Shipped Out\' ' + 
                                            + 'OR Parent.Reticle_workflow_Status__c = \'Closed\') ' +
                                        + 'AND Parent.isFinalNotified__c = false');
    }

    public void execute(Database.BatchableContext batchableContext, List<Reticle__Share> lReticleShare) {
        Set<Id> sUserId = new Set<Id>();
        String groupId;
        
        for (Reticle__Share eachReticleShare :lReticleShare) {
            sUserId.add(eachReticleShare.userOrGroupId);
        }
        SYSTEM.DEBUG('USER COUNT : ' + sUserId.size());
        
        List<Group> lGroup = [ SELECT Id 
                               FROM Group 
                               WHERE Type ='Queue' 
                                   AND Name='WWMS ROS Team' LIMIT 1 ];
                                   
        if (lGroup != null && !lGroup.isEmpty()) {
            groupId = lGroup.get(0).Id;
        }
        
        if (groupId != null && sUserId.contains(groupId)) {
            List<GroupMember> lGroupUser = [ SELECT Id
                                                  , GroupId
                                                  , UserOrGroupId 
                                             FROM GroupMember 
                                             WHERE GroupId = :groupId ];
                                             
            for(GroupMember gMember :lGroupUser) {
                sUserId.add(gMember.UserOrGroupId);
            }
            sUserId.remove(groupId);
        }

        EmailTemplate emailTemplate = [ SELECT Id 
                                        FROM EmailTemplate 
                                        WHERE DeveloperName = 'ROS_FINAL_NOTIFICATION' ];
        
        SYSTEM.DEBUG('USER COUNT AGAIN : ' + sUserId.size());
        for (Id eachUserId :sUserId) {
            ROS_Util.sendNotification(emailTemplate.Id, eachUserId);
        }
    }

    public void finish(Database.BatchableContext batchableContext) {
        
    }
}