/*
Type Name: Agreement Trigger 
Author: Cognizant NDA Team 
Created Date: 05-June-2013
Reason: This is the generic framwork trigger for Apttus Agreement object 
Test Class: AgreementToSignatoryTriggerTest
Change History: 
Author: 
Modified Date: 
Reason: 
……..
……..
*/

trigger AgreementToSignatoryTrigger on Apttus__APTS_Agreement__c (after insert, after update,before insert,before update) 
{
  AgreementTriggerHandler Agmnthandler = new AgreementTriggerHandler (Trigger.isExecuting, Trigger.size);
    if(AgreementTriggerHandler.executeOnce()){ 
    if((Trigger.isUpdate ||Trigger.isInsert) && Trigger.isBefore){
    Agmnthandler.OnBeforeInsertOrUpdateAgreement(Trigger.new);} 
    else if(Trigger.isAfter && Trigger.isInsert){
    Agmnthandler.OnAfterInsertAgreement(Trigger.new);} 
    else if(Trigger.isAfter && Trigger.isUpdate ){
    Agmnthandler.OnAfterUpdateAgreement(Trigger.new, Trigger.oldMap);}
    } 
 }