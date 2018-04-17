/*
    Author: Zymark Ambat
    Description: This batch class is created for sending email reminders for Devices without PTRF Frame Tapeout.
    History: 
        ZAmbat      04082014    - Code creation.
        ZAmbat      05152014    - Added condition: Status = 'Active'.
        Gopi Koka   06042016    - Added condition: Stage  = 'Design In';
		Yash        03052017    - Added new condition for Fab FAB 9, FAB 10 line no 30
*/

global class DevicePTRFReminderBatch implements Database.Batchable<sObject> {
    string oneWeek = DateTime.newInstance(date.today().addDays(7).year(), date.today().addDays(7).month(), date.today().addDays(7).day()).format('yyyy-MM-dd'); 
    string twoWeeks = DateTime.newInstance(date.today().addDays(14).year(), date.today().addDays(14).month(), date.today().addDays(14).day()).format('yyyy-MM-dd');
    global final string query = 'SELECT     Id ' +
                                '           , Name ' +
                                '           , Geometry_NM__c ' +
                                '           , Opportunity_Program__c ' +
                                '           , Current_Forecast_Tapeout_Date__c ' + 
                                '           , Account__c ' +
                                '           , CRMDID__c ' +
                                '           , Tapeout_Type__c ' +
                                '           , Fab__c ' +
                                '           , Geometry__c ' +
                                '           , Device_Mask_Set_Title__c ' +
                                '           , (SELECT Id FROM PTRF__r WHERE Frame_Tapeout__c = true AND Status__c = \'Active\') ' +
                                'FROM       Device__c ' +
                                'WHERE      Tapeout_Type__c NOT IN (\'GlobalShuttle MPW\', \'Retrofit\') ' +
                                '           AND Stage__c IN (\'Design In\') ' + 
                                '           AND (Current_Forecast_Tapeout_Date__c = ' + oneWeek  + ' ' +
                                '                OR Current_Forecast_Tapeout_Date__c = ' + twoWeeks + ') ' + 
								'           AND Fab__c not IN ( \'FAB 9\',\'FAB 10\') ' +
                                '           AND Status__c = \'Active\'';

    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext ctx, List<Sobject> scope) {
        Set<Id> opptyProgramIds = new Set<Id>(); 
        Set<Id> deviceIds = new Set<Id>(); 
        List<Device__c> listDevice = new List<Device__c>(); 
        for (Device__c d : (List<Device__c>)scope) {
            deviceIds.add(d.Id);
            opptyProgramIds.add(d.Opportunity_Program__c);
            listDevice.add(d);
        }
        
        if (listDevice.size() > 0) {
            // Get Email template
            EmailTemplate et = [
                SELECT      Id
                FROM        EmailTemplate
                WHERE       Name = :Environment_Variable__c.getInstance('DEVICE_PTRF_MAIL_TEMPLATE').Value__c
                LIMIT 1
            ];
            
            // Create Map of FAE per Opportunity Program
            Map<Id, List<string>> mapFAE = new Map<Id, List<string>>();
            integer recipientSize = 0;
            for (Opportunity_Program_Team_Member__c optm : [SELECT      User_Email__c
                                                                        , Opportunity_Program__c
                                                            FROM        Opportunity_Program_Team_Member__c
                                                            WHERE       Opportunity_Program__c IN :opptyProgramIds
                                                                        AND (Team_Role__c IN ('Field Application Engineer',
                                                                                             'Primary Field Application Engineer', 
                                                                                             'Primary Field Technical Support', 
                                                                                             'Field Technical Support')
                                                                             OR ( Team_Role__c = 'Account Manager' AND Is_FAE__c = TRUE)
                                                                             OR ( Team_Role__c = 'Primary Account Manager' AND Is_FAE__c = TRUE) )
                                                                        AND User_Email__c != null
                                                                        AND User__r.IsActive = true]) { 
                List<string> tempList = new List<string>();
                if (mapFAE.containsKey(optm.Opportunity_Program__c)) {  
                    tempList = mapFAE.get(optm.Opportunity_Program__c);
                    tempList.add(optm.User_Email__c);
                    mapFAE.put(optm.Opportunity_Program__c, tempList);
                } else {
                    tempList.add(optm.User_Email__c);
                    mapFAE.put(optm.Opportunity_Program__c, tempList);
                }
                recipientSize++;
            }
            
            try {
                Messaging.reserveSingleEmailCapacity(recipientSize + listDevice.size());
                // Retrieve dummy recipient
                Contact c = [
                    SELECT      Id
                                , Email
                    FROM        Contact
                    WHERE       Email != null
                    LIMIT 1
                ];
                
                List<Messaging.SingleEmailMessage> listMail = new List<Messaging.SingleEmailMessage>();
                for (Device__c d : listDevice) {
                    // Create dummy email
                    List<Messaging.SingleEmailMessage> tempList = new List<Messaging.SingleEmailMessage>();
                    Messaging.SingleEmailMessage tempEmail = new Messaging.SingleEmailMessage();
                    tempEmail.TemplateId = et.Id;
                    tempEmail.setTargetObjectId(c.id);
                    tempEmail.setWhatId(d.Id);
                    tempEmail.setSaveAsActivity(false);
                    tempList.add(tempEmail);
                    
                    // Rollback to get the email template data
                    Savepoint sp = Database.setSavepoint();      
                    if (!test.isRunningTest()) {
                        Messaging.sendEmail(tempList);        
                    }
                    Database.rollback(sp);
                    
                    // Create the actual email
                    List<string> toAddresses = new List<string>();
                    integer geometryNM = integer.valueOf(d.Geometry_NM__c.replace('NM', ''));
                    if (mapFAE.containsKey(d.Opportunity_Program__c)
                        && (geometryNM >= 55
                            || (geometryNM >= 28 && geometryNM <= 40)
                            || (geometryNM >= 14 && geometryNM <= 20))) { 
                            toAddresses.addAll(mapFAE.get(d.Opportunity_Program__c));
                    }
                    
                    if (geometryNM >= 28 && geometryNM <= 40) {
                        toAddresses.addAll(Environment_Variable__c.getInstance('DEVICE_TDTI').Value__c.split(';'));
                        toAddresses.add(Environment_Variable__c.getInstance('DEVICE_TA').Value__c);
                    } else if (geometryNM >= 14 && geometryNM <= 20) {
                        toAddresses.addAll(Environment_Variable__c.getInstance('DEVICE_TDTI').Value__c.split(';'));
                    }
                    
                    if (toAddresses.size() > 0) {
                        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                        email.setSubject(tempList[0].Subject);
                        email.setHtmlBody(tempList[0].HtmlBody);
                        email.setPlainTextBody(tempList[0].PlainTextBody);
                        email.setToAddresses(toAddresses);
                        listMail.add(email);
                    }
                }
                
                if (listMail.size() > 0) {
                    if (!test.isRunningTest()) {
                        Messaging.sendEmail(listMail);
                    }   
                }
            } catch (Exception e) {
                system.debug('Error ==========================> ' + e.getMessage());
            }   
        }   
    }
    global void finish(Database.BatchableContext BC){}
}