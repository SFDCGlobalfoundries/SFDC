trigger OptionTrigger on Customer_Requirement__c (before insert, before update, after insert,after update) {
	new OptionTriggerHandler().run(); 
}