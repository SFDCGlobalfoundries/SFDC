/*
Type Name: WorkRequestEmailHandler 
Author: Cognizant
Created Date: 04-07-2015
Reason: Reason: This is the controller class for all Email related activities.
Test Class: WorkRequestTriggerHandlerTest
Change History:
Author: 
Modified Date: 
……..
……..
--
*/

global class WorkRequestEmailHandler {
    
    //This method is used for validating Users Ids
    public static String validateTemplateId(String Idparam) {
        String id = String.escapeSingleQuotes(Idparam);
        if ((id.length() == 15 || id.length() == 18) && Pattern.matches('^[a-zA-Z0-9]*$', id) && ((id.startsWith('00X')))) {
            return id;
        }
        return null;
    }

    //Method to send Email Notification to CC List and Componet Team Members on status change
    @future
    public static void onStatusChangeEvent(Id wrId, string emailType) {
        try {
            string templateId;
            set < Id > userIds = new set < Id > ();
            WREmailTemplateId__c objTemplate = WREmailTemplateId__c.getValues(emailType);

            if (objTemplate != null && objTemplate.TemplateId__c != null) {
                templateId = validateTemplateId(objTemplate.TemplateId__c);
            }

            if (templateId != null) {
                userIds = getPDKRequestUserIdsAll(wrId);
                if (userIds != null && userIds.size() > 0) {
                    sendEmailMessage(wrId, templateId, userIds);
                }
            }
        } catch (Exception e) {CaseHandlerUtility.trackException('WorkRequestEmailHandler.onStatusChangeEvent', e.getLineNumber(), e.getTypeName(), e.getMessage());}
    }

    //Method to send Email Notification to CC List and Componet Team Members on stage change
    @future
    public static void onStageChangeEvent(Id wrId, string emailType) {
        try {
            string templateId;
            set < Id > userIds = new set < Id > ();
            WREmailTemplateId__c objTemplate = WREmailTemplateId__c.getValues(emailType);

            if (objTemplate != null && objTemplate.TemplateId__c != null) {
                templateId = validateTemplateId(objTemplate.TemplateId__c);
            }

            if (templateId != null) {
                userIds = getPDKRequestUserIdsLimited(wrId);
                if (userIds != null && userIds.size() > 0) {
                    sendEmailMessage(wrId, templateId, userIds);
                }
            }
        } catch (Exception e) {CaseHandlerUtility.trackException('WorkRequestEmailHandler.onStageChangeEvent', e.getLineNumber(), e.getTypeName(), e.getMessage());}
    }

    //Method to create Email message and send to CC List and Componet Team Members
    public static void sendEmailMessage(Id wrId, string templateId, set < Id > userIds) {
        List < Messaging.SingleEmailMessage > msgListToBeSend = new List < Messaging.SingleEmailMessage > ();
        Contact objContact = [select Id, Email from Contact where email <> null limit 1]; // Pick a dummy Contact   

        try {
            // Construct the list of emails we want to send
            List < Messaging.SingleEmailMessage > lstMsgs = new List < Messaging.SingleEmailMessage > ();
            Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
            msg.setUseSignature(false);
            msg.setBccSender(false);
            msg.setSaveAsActivity(false);
            msg.setTemplateId(templateId);
            msg.setWhatId(wrId);
            msg.setTargetObjectId(objContact.id);
            lstMsgs.add(msg);
            // Send the emails in a transaction, then roll it back
            Savepoint sp = Database.setSavepoint();
            Messaging.sendEmail(lstMsgs);
            Database.rollback(sp);
            // For each SingleEmailMessage that was just populated by the sendEmail() method, copy its
            // contents to a new SingleEmailMessage. Then send those new messages. 
            sendActualEmailMessage(lstMsgs[0].getSubject(), lstMsgs[0].getHTMLBody(), userIds);

        } catch (Exception e) {CaseHandlerUtility.trackException('WorkRequestEmailHandler.sendEmailMessage', e.getLineNumber(), e.getTypeName(), e.getMessage());}
    }
    //Method to get CC List and Componet Team Member User Ids
    public static set < Id > getPDKRequestUserIdsAll(Id wrId) {
        set < Id > userIds = new set < Id > ();
        try {

            List < CC_List__c > listCCList = [SELECT User__c FROM CC_List__c WHERE Bug_Work_Request__c = : wrId
                AND User__c <> null AND Email_Opt_Out__c = false LIMIT 100
            ];
            if (listCCList != null && listCCList.size() > 0) {
                for (CC_List__c objCC: listCCList) {
                    if (!userIds.contains(objCC.User__c))
                        userIds.add(objCC.User__c);
                }
            }
            List < Component_Team__c > listCTeam = [SELECT User__c FROM Component_Team__c WHERE Bug_Work_Request__c = : wrId
                AND User__c <> null AND Email_Opt_Out__c = false LIMIT 100
            ];
            if (listCTeam != null && listCTeam.size() > 0) {
                for (Component_Team__c objCT: listCTeam) {
                    if (!userIds.contains(objCT.User__c))
                        userIds.add(objCT.User__c);
                }
            }
        } catch (Exception e) {CaseHandlerUtility.trackException('WorkRequestEmailHandler.sendEmailMessage', e.getLineNumber(), e.getTypeName(), e.getMessage());}
        return userIds;
    }
    
    //Method to get CC List and Componet Team Member User Ids
    public static set < Id > getPDKRequestUserIdsLimited(Id wrId) {
        set < Id > userIds = new set < Id > ();
        try {

            List < CC_List__c > listCCList = [SELECT User__c FROM CC_List__c WHERE Bug_Work_Request__c = : wrId
                AND User__c <> null AND StatusOnly__c = false  AND Email_Opt_Out__c = false LIMIT 100
            ];
            if (listCCList != null && listCCList.size() > 0) {
                for (CC_List__c objCC: listCCList) {
                    if (!userIds.contains(objCC.User__c))
                        userIds.add(objCC.User__c);
                }
            }
            List < Component_Team__c > listCTeam = [SELECT User__c FROM Component_Team__c WHERE Bug_Work_Request__c = : wrId
                AND User__c <> null AND Email_Opt_Out__c = false LIMIT 100
            ];
            if (listCTeam != null && listCTeam.size() > 0) {
                for (Component_Team__c objCT: listCTeam) {
                    if (!userIds.contains(objCT.User__c))
                        userIds.add(objCT.User__c);
                }
            }
        } catch (Exception e) {CaseHandlerUtility.trackException('WorkRequestEmailHandler.sendEmailMessage', e.getLineNumber(), e.getTypeName(), e.getMessage());}
        return userIds;
    }

    //Method to send Email Notification to CC List and Component Team Members on PDK Component Creation
    public static void sendEmailNotificationforPDKComponent(Id wrId, Id pdkId, string emailType) {
            try {
                string templateId;
                set < Id > userIds = new set < Id > ();
                WREmailTemplateId__c objTemplate = WREmailTemplateId__c.getValues(emailType);

                if (objTemplate != null && objTemplate.TemplateId__c != null) {
                    templateId = validateTemplateId(objTemplate.TemplateId__c);
                }

                if (templateId != null) {
                    userIds = getPDKRequestUserIdsLimited(wrId);
                    if (userIds != null && userIds.size() > 0) {
                        sendPDKEmailMessage(wrId, pdkId, templateId, userIds);
                    }
                }
            } catch (Exception e) {CaseHandlerUtility.trackException('WorkRequestEmailHandler.sendEmailNotificationOnPDKCreation', e.getLineNumber(), e.getTypeName(), e.getMessage());}
    }
    //Method to create Email message and send to CC List and Component Team Members
    public static void sendPDKEmailMessage(Id wrId, Id PDKid, string templateId, set < Id > userIds) {
            List < Messaging.SingleEmailMessage > msgListToBeSend = new List < Messaging.SingleEmailMessage > ();
            Contact objContact = [select Id, Email from Contact where email <> null limit 1]; // Pick a dummy Contact   

            try {
                // Construct the list of emails we want to send
                List < Messaging.SingleEmailMessage > lstMsgs = new List < Messaging.SingleEmailMessage > ();
                Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
                msg.setUseSignature(false);
                msg.setBccSender(false);
                msg.setSaveAsActivity(false);
                msg.setTemplateId(templateId);
                msg.setWhatId(wrId);
                msg.setWhatId(PDKid);
                msg.setTargetObjectId(objContact.id);
                lstMsgs.add(msg);
                // Send the emails in a transaction, then roll it back
                Savepoint sp = Database.setSavepoint();
                Messaging.sendEmail(lstMsgs);
                Database.rollback(sp);
                // For each SingleEmailMessage that was just populated by the sendEmail() method, copy its
                // contents to a new SingleEmailMessage. Then send those new messages. 
                sendActualEmailMessage(lstMsgs[0].getSubject(), lstMsgs[0].getHTMLBody(), userIds);

            } catch (Exception e) {CaseHandlerUtility.trackException('WorkRequestEmailHandler.sendEmailMessage', e.getLineNumber(), e.getTypeName(), e.getMessage());}
        }

    //Method to create Email message and send to CC List and Component Team Members
    public static void sendActualEmailMessage(string subject, string htmlBody, set < Id > userIds) {
        try {
            final String orgWideEmail = System.Label.Bug_OrgWideEmailAddress;
            // Construct the list of emails we want to send
            List < Messaging.SingleEmailMessage > msgListToBeSend = new List < Messaging.SingleEmailMessage > ();
            List < Id > listUsers = new List < Id > ();
            listUsers.addAll(userIds);

            for (Id userId: listUsers) {
                Messaging.SingleEmailMessage emailToSend = new Messaging.SingleEmailMessage();
                emailToSend.setUseSignature(false);
                emailToSend.setBccSender(false);
                emailToSend.setSaveAsActivity(false);
                emailToSend.setTargetObjectId(userId);
                emailToSend.setSubject(subject);
                emailToSend.setHTMLBody(htmlBody);
                emailToSend.setOrgWideEmailAddressId(orgWideEmail);
                msgListToBeSend.add(emailToSend);
            }

            if (msgListToBeSend.size() > 0) {
                List < Messaging.SendEmailResult > results = Messaging.sendEmail(msgListToBeSend);
                if (!results.get(0).isSuccess()) {
                    System.StatusCode statusCode = results.get(0).getErrors()[0].getStatusCode();
                    String errorMessage = results.get(0).getErrors()[0].getMessage();
                }
            }
        } catch (Exception e) {CaseHandlerUtility.trackException('WorkRequestEmailHandler.sendActualEmailMessage', e.getLineNumber(), e.getTypeName(), e.getMessage());}
    }
}