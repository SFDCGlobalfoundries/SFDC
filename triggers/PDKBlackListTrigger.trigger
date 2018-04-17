/*
* @ Author :- Prajnith Karra
* @ Company :- GF
* @ Description :- Trigger
* @ Date :- 11/10/2014
* @ Change History :- 
* @ Created Date: 5/6/2017
**/
trigger PDKBlackListTrigger on PDK_Blacklist__c (Before insert,Before Update) {

      PDKBlackListTriggerHandler.onBeforeInsertUpdate(trigger.new);
    
}