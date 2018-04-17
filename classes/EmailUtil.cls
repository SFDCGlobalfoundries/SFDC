/*
    Author: Win Hwang
    Description: This utilities provides method to send Email. both custom body and email template.
    History: 
        Win      07172013    - Code creation.
*/
public class EmailUtil {    
    //return SF link like: https://cs5.salesforce.com
    //optional param stringAppendToDomain - example: /apex/IpDeclarationEdit?id=a3HO00000008TN7MAM
    //will return FQDM 'https://cs5.salesforce.com/apex/IpDeclarationEdit?id=a3HO00000008TN7MAM'
    public static String getSFLink(String stringAppendToDomain){
        return System.URL.getSalesforceBaseUrl().toExternalForm() + stringAppendToDomain;
    }
    
    /*public static String sendEmail(String emailTemplateName, Id targetObjectId, Id whatId, String[] ccAddresses){
        try{
            // get the email template
            EmailTemplate emailTemp = [SELECT id from EmailTemplate where name = :emailTemplateName];
            
            // sending the mail
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();         
            mail.setTargetObjectId(targetObjectId);
            mail.setTemplateId(emailTemp.id);
            mail.setWhatId(whatId);
            mail.saveAsActivity = false;
            mail.setCcAddresses(ccAddresses);
            
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }catch (Exception e) {
            return e.getMessage();
            //e.printStackTrace();
        }
        return null; 
    }*/
    
    public static Messaging.SingleEmailMessage generateEmailTemplate(String emailId, 
                                                                     String targetObjectId, 
                                                                     String subject,
                                                                     List<String> toAddresses, 
                                                                     List<String> ccAddresses,                                                                         
                                                                     Map<String,String> mergeFields){
        
        try { 
            //get recipient size
            Integer recipientSize = 0;
            if(toAddresses <> null){
                recipientSize += toAddresses.size();
            }
            
            if(ccAddresses <> null){
                recipientSize += ccAddresses.size();
            }
            Messaging.reserveSingleEmailCapacity(Integer.valueOf(recipientSize));
            
            Messaging.SingleEmailMessage blankTemplate = new Messaging.SingleEmailMessage();
            
            System.debug('Send email limit passed');
            //Create a dummy email template with the merge fields populated fro)m the target object ID
            Contact c = [SELECT id,email FROM Contact WHERE email <> null LIMIT 1];
            
            List<Messaging.SingleEmailMessage> lstMsgs = new List<Messaging.SingleEmailMessage>();
            Messaging.SingleEmailMessage tempMsg = new Messaging.SingleEmailMessage();       
            tempMsg.templateId = emailId;
            tempMsg.setTargetObjectId(c.id);
            tempMsg.setWhatId(targetObjectId);
            tempMsg.setSaveAsActivity(false);
            tempMsg.setToAddresses(new List<String>{'blank@blank.com'});            
            String currSubject = tempMsg.subject; 
            lstMsgs.add(tempMsg);
    
            //Rollback to get the email template data
            Savepoint sp = Database.setSavepoint();      
            Messaging.sendEmail(lstMsgs);        
            Database.rollback(sp);
            
            //replace the merge fields
            //and set the to and cc addresses
            
            for(Messaging.SingleEmailMessage l :lstMsgs){
                                      
                String htmlBody = l.htmlBody;
                String textBody = l.plainTextBody;  
                
                if(mergeFields <> null){                                              
                    for(String k :mergeFields.keySet()){                
                        htmlBody = (htmlBody.replace(k,mergeFields.get(k)));                                
                        textBody = (textBody.replace(k,mergeFields.get(k)));
                    }
                }           
                blankTemplate.setHtmlBody(htmlBody);
                blankTemplate.setPlainTextBody(textBody);
                blankTemplate.setToAddresses(toAddresses);
                
                if(ccAddresses <> null && ccAddresses.size() > 0){
                    blankTemplate.setCCAddresses(ccAddresses);
                } 
                            
                if(subject <> null){
                    blankTemplate.setSubject(subject);
                } else {
                    blankTemplate.setSubject(l.subject);
                }
                system.debug('toAddresses===>'+toAddresses);
                system.debug('ccAddresses===>'+ccAddresses);
            }                
            return blankTemplate;
            
        } catch(Exception e){
            System.debug('Sending Email error :'+e);            
        }        
        return null;
    }
    
    public static List<Messaging.SingleEmailMessage> generateEmailTemplate(String emailId, String targetObjectId, List<String> toAddresses, List<String> ccAddresses){
        try { 
            //get recipient size
            Integer recipientSize = 0;
            if(toAddresses <> null){
                recipientSize += toAddresses.size();
            }
            
            if(ccAddresses <> null){
                recipientSize += ccAddresses.size();
            }
            
            Messaging.reserveSingleEmailCapacity(Integer.valueOf(recipientSize));
            
            //Create a dummy email template with the merge fields populated from the IP Declaration
            Contact c = [SELECT id,email FROM Contact WHERE email <> null LIMIT 1];
            
            List<Messaging.SingleEmailMessage> lstMsgs = new List<Messaging.SingleEmailMessage>();
            Messaging.SingleEmailMessage tempMsg = new Messaging.SingleEmailMessage();
            tempMsg.templateId = emailId;
            tempMsg.setTargetObjectId(c.id);
            tempMsg.setWhatId(targetObjectId);
            tempMsg.setSaveAsActivity(false);
            tempMsg.setToAddresses(toAddresses);        
            
            if(ccAddresses <> null){
                tempMsg.setCCAddresses(ccAddresses);
            }
            lstMsgs.add(tempMsg);
            
            //Rollback to get the email template data
            Savepoint sp = Database.setSavepoint();
            Messaging.sendEmail(lstMsgs);
            Database.rollback(sp);
            
            return lstMsgs;
        } catch(Exception e){
            System.debug('Sending Email error :'+e);            
        }        
        return null;          
    }
    
    public static String sendEmail(String subject, String textBody, String htmlBody, String[] toAddresses, String[] ccAddresses, String replyTo, String senderDisplayName){
        try{
            // First, reserve email capacity for the current Apex transaction to ensure
            // that we won't exceed our daily email limits when sending email after
            // the current transaction is committed.
            
            Integer recipientSize = 0;
            if(toAddresses <> null){
                recipientSize += toAddresses.size();
            }
            
            if(ccAddresses <> null){
                recipientSize += ccAddresses.size();
            }
            
            Messaging.reserveSingleEmailCapacity(recipientSize);
            
            // Processes and actions involved in the Apex transaction occur next,// which conclude with sending a single email.// Now create a new single email message object// that will send out a single email to the addresses in the To, CC & BCC list.
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            
            // Assign the addresses for the To and CC lists to the mail object.
            mail.setToAddresses(toAddresses);
            mail.setCcAddresses(ccAddresses);
            
            // Specify the address used when the recipients reply to the email. 
            mail.setReplyTo(replyTo);
            
            // Specify the name used as the display name.
            mail.setSenderDisplayName(senderDisplayName);
            
            // Specify the subject line for your email address.
            mail.setSubject(subject);
            
            // Set to True if you want to BCC yourself on the email.
            mail.setBccSender(false);
            
            // Optionally append the salesforce.com email signature to the email.// The email address of the user executing the Apex Code will be used.
            mail.setUseSignature(false);
            
            // Specify the text content of the email.
            if(textBody!=null && textBody!=''){
                mail.setPlainTextBody(textBody);
            }
            if(htmlBody!=null && htmlBody!=''){
                mail.setHtmlBody(htmlBody);
            }
            
            // Send the email you have created.
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }catch (Exception e) {
            return e.getMessage();
            //e.printStackTrace();
        }
        return null;    
    }      
}