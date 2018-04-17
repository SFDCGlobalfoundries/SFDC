/*
    Author: Abhita Bansal
    Description: This trigger is used to update the Email field "User Email" with formula field "Email Formula" on Record Creation

*/
trigger eWSRUpdateEmailFieldTrigger on eWSR_Notification_Group__c (after insert) {
    
     Set<Id> notGpIds = new Set<Id>();
     
     if(!IntegrationUserUtil.isSkipTrigger()){
     
     for (eWSR_Notification_Group__c notGp : Trigger.new) {                       
        notGpIds.add(notGp .Id);         
     }
    
    if(!notGpIds.isEmpty()){
       eWSRUpdateEmailFieldClass.updateField(notGpIds);
    }
    }
}