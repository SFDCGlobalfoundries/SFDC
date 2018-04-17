trigger MDD_partTrigger on Part__c (before insert,before update,after update) {
    MDD_partTriggerHelperCls obj = new MDD_partTriggerHelperCls();
    public User loginUser = [Select Id, ContactId from User where Id =: userInfo.getUserId()];
    public Boolean isInternalUser;
    if(loginUser.contactId != null)
        isInternalUser = true;
    if(isInternalUser != true){
        if(trigger.isInsert && trigger.isBefore){
            obj.getFolderLinks(Trigger.new);
        }
        if(trigger.isUpdate && trigger.isBefore){
            obj.removeShare(Trigger.oldMap,Trigger.newMap);
            obj.getFolderLinks(Trigger.new);
            obj.addShareForFamily(Trigger.new);
        }
        if(trigger.isUpdate && trigger.isAfter){
            //obj.removeShare(Trigger.new);
            //obj.addShareForFamily(Trigger.new);
        }
    }
}