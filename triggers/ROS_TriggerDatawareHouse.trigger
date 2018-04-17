trigger ROS_TriggerDatawareHouse on Reticle_Datawarehouse__c (before insert) {
 if((ROS_Triggers_Bypass__c.getInstance('ROS_TriggerDatawareHouse').Username__c==null)||(UserInfo.getUserName()!=ROS_Triggers_Bypass__c.getInstance('ROS_TriggerDatawareHouse').Username__c)){ 

    
    if (Trigger.isBefore && Trigger.isInsert) {
        ROS_TRIGGER_HELPER_ReticleDatawarehouse.beforeInsert(Trigger.new);
    }
  }
}