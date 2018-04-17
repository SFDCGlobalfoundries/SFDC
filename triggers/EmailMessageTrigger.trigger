/*
Type Name: EmailMessageTrigger 
Author: UCM Team
Created Date: 10-Nov-2015
Reason: This is the generic trigger for EmailMessage object. 
Test Class: CaseTriggerHandlerTest
Change History:
Author: 
Modified Date: 
Reason: 
……..
……..
*/
trigger EmailMessageTrigger on EmailMessage (after insert) {
     if (!IntegrationUserUtil.isSkipTrigger()) {
        List<EmailMessage> newEmailMessage = new List<EmailMessage>();
        for (EmailMessage newEmail :Trigger.New)
        {
            if(newEmail.Incoming)
            {
                newEmailMessage.add(newEmail);
            }
        }
        if(!newEmailMessage.iSEmpty()){
            CaseTriggerHandler handler = new CaseTriggerHandler(Trigger.isExecuting, Trigger.size);
            handler.OnAfterInsertEmailMessage(newEmailMessage);
        }            
    }
}