/*
    Author: Zymark Ambat
    Description: Batch class to send Email Reminders for Export Control Forms. 
    History:
        ZAmbat      07112013    - code creation.      
        Zambat      10162013    - Changed Field Enginner to Field Technical Support.  
*/

global class ExportControlWeeklyReminderBatch implements Database.Batchable<sObject> {

    global Database.QueryLocator start(Database.BatchableContext BC) {
        // Define scope
        // Retrieve Device records
        final string query = '  SELECT      Id '
                             + '            , Account__c '  
                             + '            , Opportunity_Program__c '
                             + '            , Export_Control_Status__c '
                             + '            , Current_Forecast_Tapeout_Date__c '
                             + 'FROM        Device__c '
                             + 'WHERE       Expose_Device_to_Customer__c = true '
                             + '            AND (((Export_Control_Waiver_Flag__c = \'No\' '
                             + '                  AND (Export_Control_Status__c = \'Draft\')) '
                             + '                  AND ((EC_Daily_Reminder__c = true AND Daily_Export_Control_Reminder_Email__c = \'TRUE\') '
                             + '                        OR (EC_Weekly_Reminder__c = true AND Weekly_Export_Control_Reminder_Email__c = \'TRUE\'))) '
                             + '                OR ( Export_Control_Status__c IN (\'Submitted\', \'On-hold\') '
                             + '                    AND Daily_Export_Control_Approval_Email__c = \'TRUE\'))';
        
        //final string query = 'SELECT Id, Account__c, Opportunity_Program__c, Export_Control_Status__c FROM Device__c WHERE Name = \'TESTDEVICEZAIH2GLOBALSHUTTLEMPW\'';                    
                             
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext ctx, List<Sobject> scope){
        List<Device__c> listDevice = (List<Device__c>)scope;
        system.debug('listDevice ==================> ' + listDevice); 
        // Retrieve Accounts and Oppotunity Programs
        Set<Id> accountIds = new Set<Id>();
        Set<Id> opptyProgramIds = new Set<Id>();
        for (Device__c d : listDevice) { 
            accountIds.add(d.Account__c);
            opptyProgramIds.add(d.Opportunity_Program__c);
        }
        
        // Retrieve Customer Device Admin Contacts
        Map<Id, List<Contact>> mapAdminContact = new Map<Id, List<Contact>>(); 
        for (Account a : [SELECT        Id
                                        , (SELECT       Id
                                                        , Email
                                           FROM         Contacts
                                           WHERE        Role__c includes ('Customers My Device Admin'))
                          FROM          Account
                          WHERE         Id IN :accountIds]) {
            if (a.Contacts.size() > 0) {
                mapAdminContact.put(a.Id, a.Contacts);
            }
        }
        
        // Retrieve Opportunity Program Team Members - Account Managers / Field Technical Supports
        Map<Id, List<Opportunity_Program_Team_Member__c>> mapAMFE = new Map<Id, List<Opportunity_Program_Team_Member__c>>();
        for (Opportunity_Program__c op : [SELECT        Id
                                                        , (SELECT       Id
                                                                        , User__c
                                                                        , User__r.Email
                                                           FROM         Opportunity_Program_Team_Members__r
                                                           WHERE        Team_Role__c IN (:Environment_Variable__c.getInstance('OPPTY_PROG_TM_ROLE_PAM').Value__c, :Environment_Variable__c.getInstance('OPPTY_PROG_TM_ROLE_AM').Value__c, :Environment_Variable__c.getInstance('OPPTY_PROG_TM_ROLE_PFTS').Value__c, :Environment_Variable__c.getInstance('OPPTY_PROG_TM_ROLE_FTS').Value__c))
                                          FROM          Opportunity_Program__c
                                          WHERE         Id IN :opptyProgramIds]) {
            if (op.Opportunity_Program_Team_Members__r.size() > 0) {
                mapAMFE.put(op.Id, op.Opportunity_Program_Team_Members__r);
            }
        } 
        
        // Retrieve email templates
        List<EmailTemplate> listEmailTemplate = [
            SELECT      Id
                        , Name
            FROM        EmailTemplate
            WHERE       Name IN ('Reminder for Export Control Form After Device expose')
        ];
                                              
        Map<String, Id> mapEmailTemplate = new Map<String, Id>(); 
        for (EmailTemplate et : listEmailTemplate) {
            mapEmailTemplate.put(et.Name, et.Id);
        }
        
        // Set up email
        List<Messaging.SingleEmailMessage> listEmail = new List<Messaging.SingleEmailMessage>(); 
        Integer totalRecipients = 0;
        for (Device__c d : listDevice) {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            
            OrgWideEmailAddress owea = [
                SELECT      Id
                FROM        OrgWideEmailAddress
                WHERE       DisplayName = 'Customer_support@globalfoundries.com'
            ];
            
            //mail.setOrgWideEmailAddressId(owea.Id);
            mail.setSenderDisplayName('GlobalFoundries');
            
            if (d.Export_Control_Status__c == 'Draft') {
                mail.setTemplateId(mapEmailTemplate.get('Reminder for Export Control Form After Device expose'));   
                mail.setWhatId(d.Id);
                
                string targetObjectId = '';
                List<String> listRecipients = new List<String>();
                if (mapAdminContact.containsKey(d.Account__c)) {
                    if (mapAdminContact.get(d.Account__c).size() > 0) { 
                        for (Contact c : mapAdminContact.get(d.Account__c)) {
                            if (targetObjectId == '') {
                                targetObjectId = c.Id;
                            } else {
                                listRecipients.add(c.Email);
                            }
                        }
                    }   
                }
                
                if (mapAMFE.containsKey(d.Opportunity_Program__c)) {
                    if (mapAMFE.get(d.Opportunity_Program__c).size() > 0) {
                        for (Opportunity_Program_Team_Member__c optm : mapAMFE.get(d.Opportunity_Program__c)) {
                            if (targetObjectId == '') {
                                targetObjectId = optm.Id;
                            } else {
                                listRecipients.add(optm.User__r.Email);
                            }
                        }
                    }
                }
                
                if (targetObjectId != '') {
                    mail.setTargetObjectId(targetObjectId);
                } else {
                    if (listRecipients.size() > 0) {
                        targetObjectId = listRecipients[0];
                        mail.setTargetObjectId(targetObjectId);
                    }
                }
                
                if (listRecipients.size() > 0) {
                    totalRecipients = listRecipients.size();
                    mail.setToAddresses(listRecipients);
                }
                
                if (targetObjectId != '') {
                    listEmail.add(mail);
                }
            } else {
                List<String> listRecipients = Environment_Variable__c.getInstance('GF_DISTRIBUTION_LIST').Value__c.split(',', (Environment_Variable__c.getInstance('GF_DISTRIBUTION_LIST').Value__c.countMatches(',') + 1));
                mail.setToAddresses(listRecipients);
                
                mail.setSubject('Export Control Form Approval');
                
                string emailBody = 'Dear Customer, <br/><br/>' +
                                   'The Export Control Questionnaire is not yet approved for the following device: <br/><br/>' +
                                   URL.getSalesforceBaseUrl().toExternalForm() + '/' + d.Id + '<br/><br/>' +
                                   'Please be reminded to review this form as soon as possible. <br/><br/>' +
                                   'Thank you. <br/><br/>' +
                                   d.Current_Forecast_Tapeout_Date__c;
                
                
                mail.setHtmlBody(emailBody);
                
                if (listRecipients.size() > 0) {
                    totalRecipients = listRecipients.size();
                    listEmail.add(mail);
                } 
            }
        }
        
        try{
            // Send email
            Messaging.reserveSingleEmailCapacity(totalRecipients);
            
            Messaging.sendEmail(listEmail);
        }catch(Exception e){
            system.debug('Exception==>'+e.getMessage());
        }
    }
    
    global void finish(Database.BatchableContext BC){}
    
}