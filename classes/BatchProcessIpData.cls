global class BatchProcessIpData implements Database.Batchable<SObject>{
    set<string> PT;
    global BatchProcessIpData(set<string> PTno){
        PT = PTno;
    }
    global database.querylocator start(Database.BatchableContext bc){
        return Database.getQueryLocator([SELECT name 
                              FROM     Process_Technology__c 
                              WHERE    name IN: PT]);
    }
 
    global void execute(Database.BatchableContext BC,List<Process_Technology__c> scope){
        system.debug('scope'+scope);
        for(Process_Technology__c eachPT: scope){
            string eachPT1 = eachPT.name;
            CPQIPDataUpdateReportController CPQIPDataUpdatecls = new CPQIPDataUpdateReportController ();
            CPQIPDataUpdatecls.updateIPData(eachPT1);
        }
    }
 
    global void finish(Database.BatchableContext bc){
        Messaging.MassEmailMessage mail = new Messaging.MassEmailMessage();
        Group grp = [select Id,Name, DeveloperName from Group where Name = 'ProcessIpData Admin' and Type = 'Queue'];
        List<Id> userList =new List<Id>();
        String userType = Schema.SObjectType.User.getKeyPrefix();
        String groupType = Schema.SObjectType.Group.getKeyPrefix();
        for (GroupMember m : [Select Id, UserOrGroupId From GroupMember Where GroupId = :grp.id]){
            if (((String)m.UserOrGroupId).startsWith(userType)){
                userList.add(m.UserOrGroupId);
            }
            /*else if (((String)m.UserOrGroupId).startsWith(groupType)){
                userList.addAll(GetUSerIdsFromGroup(m.UserOrGroupId));
            }*/
        }
        system.debug('grp'+grp);
        system.debug('userList'+userList);
        Id templateId = [select id, name from EmailTemplate where developername = : 'ProcessIpData'].id;
        system.debug('templateId'+templateId );
        mail.setTargetObjectIds(userList);
        mail.setTemplateID(templateId);
        mail.saveAsActivity = false;
        Messaging.sendEmail(new Messaging.MassEmailMessage[] {mail});   
    }
}