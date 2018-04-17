/*
    Author: Zymark Ambat
    Description: This Class is for Manufacturing Lot email notifications.
    History: 
        ZAmbat      12082014    - Code creation.
*/

public class ManufacturingLotSendNotifications {
    @future                
    public static void sendEmail(Set<Id> setMLIds) {
        List<Manufacturing_Lot__c> listML = [
            SELECT    Id
                      , Lot_Type__c
                      , Device_ID_MES__c
                      , QD_Email_Already_Sent__c
                      , QF_Email_Already_Sent__c
                      , Account_Name__c
                      , Account_Name__r.Name
                      , Fab_Group__c
            FROM      Manufacturing_Lot__c
            WHERE     Id IN :setMLIds
        ];
        
        Set<string> setQD = new Set<string>();
        Set<string> setQF = new Set<string>();
        for (Manufacturing_Lot__c m : [SELECT    Device_ID_MES__c
                                                 , QD_Email_Already_Sent__c
                                                 , QF_Email_Already_Sent__c
                                       FROM      Manufacturing_Lot__c
                                       WHERE     QD_Email_Already_Sent__c = true
                                                 OR QD_Email_Already_Sent__c = true]) {
            if (m.QD_Email_Already_Sent__c) {
                setQD.add(m.Device_ID_MES__c);
            }
            
            if (m.QF_Email_Already_Sent__c) {
                setQF.add(m.Device_ID_MES__c);
            }
        }
        
        List<Manufacturing_Lot__c> listUpdateML = new List<Manufacturing_Lot__c>();
        for (Manufacturing_Lot__c m : listML) {
            if (m.Lot_Type__c.startsWith('QD') && m.Device_ID_MES__c != null) {
                if (!setQD.contains(m.Device_ID_MES__c)) {
                    m.QD_Email_Already_Sent__c = true;
                    listUpdateML.add(m);
                }
            } else if (m.Lot_Type__c.startsWith('QF') && m.Device_ID_MES__c != null) {
                if (!setQF.contains(m.Device_ID_MES__c)) {
                    m.QF_Email_Already_Sent__c = true;
                    listUpdateML.add(m);
                }
            }
        }

        if (listUpdateML.size() > 0) {
            Set<Id> mlQDIds = new Set<Id>();
            Set<Id> mlQFIds = new Set<Id>();
            Set<Id> mlGShuttleIds = new Set<Id>();
            Map<Id, Manufacturing_Lot__c> mapML = new Map<Id, Manufacturing_Lot__c>();
            Set<Id> accountIds = new Set<Id>();
            for (Manufacturing_Lot__c m : listUpdateML) {
                if (m.Account_Name__r.Name == 'GLOBALSHUTTLE') {
                    mlGShuttleIds.add(m.Id);
                } else {
                    if (m.Lot_Type__c.startsWith('QD')) {
                        // Create Map for Manufacturing Lot - Account
                        mapML.put(m.Id, m);
                        accountIds.add(m.Account_Name__c);
                        mlQDIds.add(m.Id);
                    } else if (m.Lot_Type__c.startsWith('QF')) {
                        mlQFIds.add(m.Id);
                    }
                }
            }
            
            List<Messaging.SingleEmailMessage> listEmail = new List<Messaging.SingleEmailMessage>();
            
            // Get email template
            EmailTemplate et = [
                SELECT    Id
                FROM      EmailTemplate
                WHERE     DeveloperName = 'EPTS_Notification_VF_1'
            ];
    
            // QD
            if (mlQDIds.size() > 0) {
                // Create Map for Account - Account Team Proxy
                Map<Id, Account> mapATP = new Map<Id, Account>(); 
                mapATP = new Map<Id, Account>([SELECT Id
                                                   ,(SELECT User__c 
                                                          , User__r.Email
                                                          , Fab_Assignment__c
                                                          , Team_Role__c
                                                        FROM     Account_Team_Proxy__r 
                                                        WHERE    User__r.IsActive = true
                                                         AND (Team_Role__c IN ( 'Customer Engineer'
                                                                              , 'Field Application Engineer'
                                                                              , 'Field Technical Support'
                                                                              , 'Primary Field Technical Support'
                                                                              , 'Primary Field Application Engineer')
                                                            OR ( Team_Role__c = 'Account Manager' AND Is_FAE__c = TRUE)
                                                            OR ( Team_Role__c = 'Primary Account Manager' AND Is_FAE__c = TRUE) ))
                                                FROM  Account
                                                WHERE Id IN :accountIds]);
                
                // Contstruct the email
                for (Id i : mlQDIds) {
                    if (mapATP.get(mapML.get(i).Account_Name__c).Account_Team_Proxy__r.size() > 0) {
                        Map<Id, string> mapRecipients = new Map<Id, string>();
                        for (Account_Team_Proxy__c a : mapATP.get(mapML.get(i).Account_Name__c).Account_Team_Proxy__r) {
                            if (a.Team_Role__c == 'Customer Engineer') {
                                if (a.Fab_Assignment__c != null) {
                                    List<string> listFab = a.Fab_Assignment__c.split(';');
                                    Set<string> setFab = new Set<string>();
                                    setFab.addAll(listFab);
                                    if (setFab.contains(mapML.get(i).Fab_Group__c)) {
                                        mapRecipients.put(a.User__c, a.User__r.Email);
                                    }
                                }
                            } else {
                                mapRecipients.put(a.User__c, a.User__r.Email);
                            }
                        }
                        listEmail.add(ManufacturingLotSendNotifications.createEmail('QD', et.Id, i, mapRecipients));
                    }
                }
            }
            
            // QF
            if (mlQFIds.size() > 0) {
                for (Id i : mlQFIds) {
                    listEmail.add(ManufacturingLotSendNotifications.createEmail('QF', et.Id, i, null));
                }
            }
            
            // GlobalShuttle
            if (mlGShuttleIds.size() > 0) {
                for (Id i : mlGShuttleIds) {
                    listEmail.add(ManufacturingLotSendNotifications.createEmail('GS', et.Id, i, null));
                }
            }
            
            // Send Email
            if (listEmail.size() > 0 && !test.isRunningTest()) {
                Messaging.sendEmail(listEmail);
            }
            
            // Update
            ManufacturingLotTriggerStopper.hasExecuted = true;
            update listUpdateML;
        }
    }
    
    public static Messaging.SingleEmailMessage createEmail(string type, Id templateId, Id objectId, Map<Id, string> mapRecipients) {       
        // Send email to capture the template
        Messaging.reserveSingleEmailCapacity(type == 'QD' ? mapRecipients.size() : Environment_Variable__c.getInstance('EPTS_TO_ADDRESSES').Value__c.split(';').size());
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.templateId = templateId;
        
        List<Id> listUserId = new List<Id>();
        if (type == 'QD') {
            listUserId.addAll(mapRecipients.keySet());
        } else if (type == 'QF' || type == 'GS') {
            listUserId.add(Environment_Variable__c.getInstance('EPTS_TO_ADDRESSES').Value__c);
        }
        
        email.setTargetObjectId(listUserId[0]);
        if (type == 'QD') {
            mapRecipients.remove(listUserId[0]);
            if (mapRecipients.size() > 0) {
                email.setToAddresses(mapRecipients.values());                        
            }
        }
        email.setCCAddresses(Environment_Variable__c.getInstance('EPTS_CC_ADDRESSES').Value__c.split(';'));     
        email.setBCCAddresses(Environment_Variable__c.getInstance('EPTS_BCC_ADDRESSES').Value__c.split(';'));                       
        email.setWhatId(objectId);
        email.setSaveAsActivity(false);

        return email;
    }
}