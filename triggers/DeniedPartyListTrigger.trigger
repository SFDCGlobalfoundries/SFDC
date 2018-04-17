/*
Type Name: DeniedPartyListTrigger
Author: JK Technosoft
Created Date: 12-08-2016
Reason: DeniedPartyListTrigger used to excute logic to find unauthorized records 
……..
……..
*/
trigger DeniedPartyListTrigger on Denied_Party_List__c (After insert,After Update) {
    if((trigger.isInsert || Trigger.isUpdate) && (!IntegrationUserUtil.isSkipTrigger())){
        if(trigger.isInsert){
             DeniedPartyListHelperClass.DeniedPartyList(Trigger.New);
        }
        
        if(trigger.isUpdate){
            if(trigger.new != trigger.old){
                DeniedPartyListHelperClass.DeniedPartyList(Trigger.New);
            }
        } 
    }
}