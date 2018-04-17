/*
    Author: Zymark Ambat
    Description: This is a batch class to send email reminders for Yield Feedback.
    History: 
        ZAmbat      1211204    - Code creation.
*/

global class YieldFeedbackRemindersBatch implements Database.Batchable<sObject> {
    global EmailTemplate template1 {get;set;}
    global EmailTemplate template2 {get;set;}
    global string soql {get;set;}
    
    global YieldFeedbackRemindersBatch() {
        this.template1 = [
            SELECT    Id
            FROM      EmailTemplate
            WHERE     DeveloperName = 'EPTS_Notification_VF_2'
        ];
        
        this.template2 = [
            SELECT    Id
            FROM      EmailTemplate
            WHERE     DeveloperName = 'EPTS_Notification_VF_3'
        ];
        
        this.soql = 'SELECT Id, Account__c, Device__r.Tapeout_Type__c, Device__r.Fab__c, Manufacturing_Lot__r.Account_Name__c, Manufacturing_Lot__r.Lot_Type__c, Send_QD_Reminder__c, Send_QF_Reminder__c ' +
                    'FROM Yield_Feedback__c ' + 
                    'WHERE Send_QD_Reminder__c = true OR Send_QF_Reminder__c = true';
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(this.soql);
    }
    
    global void execute(Database.BatchableContext ctx, List<Sobject> scope) {
        List<Yield_Feedback__c> listYieldFeedback = (List<Yield_Feedback__c>)scope; 
        
        // Get recipients map 
        Set<Id> accountIds = new Set<Id>();
        for (Yield_Feedback__c y : listYieldFeedback) {
            accountIds.add(y.Account__c);
        }

        // Create Map for Account - Account Team Proxy
        Map<Id, Account> mapATP = new Map<Id, Account>(); 
        mapATP = new Map<Id, Account>([SELECT    Id
                                                 , (SELECT   User__c 
                                                             , User__r.Email
                                                             , Fab_Assignment__c
                                                             , Team_Role__c
                                                    FROM     Account_Team_Proxy__r 
                                                    WHERE    User__r.IsActive = true
                                                             AND (Team_Role__c IN ('Customer Engineer'
                                                                                  , 'Field Application Engineer'
                                                                                  , 'Field Technical Support'
                                                                                  , 'Primary Field Technical Support'
                                                                                  , 'Primary Field Application Engineer')
                                                                  OR ( Team_Role__c = 'Account Manager' AND Is_FAE__c = TRUE)
                                                                  OR ( Team_Role__c = 'Primary Account Manager' AND Is_FAE__c = TRUE))
                                                  )
                                       FROM      Account
                                       WHERE     Id IN :accountIds]);
        
        User u = [
            SELECT    Id
                      , Email
            FROM      User
            WHERE     Name = :Environment_Variable__c.getInstance('EPTS_QF_CE_NAME').Value__c
        ];
        
        // Construct the email
        List<Messaging.SingleEmailMessage> listEmail = new List<Messaging.SingleEmailMessage>();
        for (Yield_Feedback__c y : listYieldFeedback) {    
            if (mapATP.get(y.Account__c).Account_Team_Proxy__r.size() > 0) {
                Map<Id, string> mapRecipients = new Map<Id, string>();
                if (y.Device__r.Tapeout_Type__c == 'GlobalShuttle MPW') {
                    mapRecipients.put(u.Id, u.Email);
                }
                
                for (Account_Team_Proxy__c a : mapATP.get(y.Account__c).Account_Team_Proxy__r) {
                    if (a.Team_Role__c == 'Customer Engineer') {
                        if (y.Device__r.Tapeout_Type__c != 'GlobalShuttle MPW') {
                            if (a.Fab_Assignment__c != null) {
                                List<string> listFab = a.Fab_Assignment__c.split(';');
                                Set<string> setFab = new Set<string>();
                                setFab.addAll(listFab);
                                if (setFab.contains(y.Device__r.Fab__c)) {
                                    mapRecipients.put(a.User__c, a.User__r.Email);
                                }
                            }
                        }
                    } else {
                        mapRecipients.put(a.User__c, a.User__r.Email);
                    }
                }
                
                string templateId;
                if (y.Send_QD_Reminder__c) {
                    templateId = this.template1.Id;     
                } else if (y.Send_QF_Reminder__c) {
                    templateId = this.template2.Id;
                }
               
                listEmail.add(createEmail(templateId, y.Id, mapRecipients));
            }

        }
        
        // Send email
        if (listEmail.size() > 0 && !test.isRunningTest()) {
            Messaging.sendEmail(listEmail);
        }
    }
    
    global void finish(Database.BatchableContext BC) {}
    
    global Messaging.SingleEmailMessage createEmail(Id templateId, Id recordId, Map<Id, string> mapRecipients) {       
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.templateId = templateId;
        
        List<Id> listUserId = new List<Id>();
        listUserId.addAll(mapRecipients.keySet());
        
        email.setTargetObjectId(listUserId[0]);
        mapRecipients.remove(listUserId[0]);
        if (mapRecipients.size() > 0) {
            email.setToAddresses(mapRecipients.values());                        
        }
        email.setCCAddresses(Environment_Variable__c.getInstance('EPTS_CC_ADDRESSES').Value__c.split(';'));
        email.setBCCAddresses(Environment_Variable__c.getInstance('EPTS_BCC_ADDRESSES').Value__c.split(';'));                        
        email.setWhatId(recordId);
        email.setSaveAsActivity(false);

        return email;
    }
}