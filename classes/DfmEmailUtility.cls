/*
* @ Author :- Navneet Rajput
* @ Date :- 23 oct 2015
* @ Description :- 
*/

public with sharing class DfmEmailUtility {

       private Messaging.SingleEmailMessage singleEmailMessage;
       private final List<String> toAddresses;
       private final List<String> ccAddresses;
       private final List<String> bccAddresses;
       
       private String subject = '';
       private String htmlBody = ''; 
       private Boolean useSignature = false;
       private List<Messaging.EmailFileAttachment> fileAttachments = null;

       private String senderDisplayName = UserInfo.getFirstName()+' '+UserInfo.getLastName();
       //get the current user in context
       User currentUser = [Select email from User where username = :UserInfo.getUserName() limit 1];        
       //replyTo defaults to current user's email 
       private String replyTo = currentUser.email;
       private String plainTextBody = '';
       
       public DfmEmailUtility(List<String> toAddresses, List<String> ccAddresses,List<String> bccAddresses) {
           this.toAddresses = toAddresses;
           this.ccAddresses = ccAddresses;
           this.bccAddresses = bccAddresses;
       }
       
       public DfmEmailUtility senderDisplayName(String val) {
           senderDisplayName = val;
           return this;
       }
       
       public DfmEmailUtility subject(String val) {
           subject = val;
           return this;
       }
       
       public DfmEmailUtility htmlBody(String val) {
           htmlBody = val;
           return this;
       }
       
       public DfmEmailUtility useSignature(Boolean bool) {
           useSignature = bool;
           return this;
       }
       
       public DfmEmailUtility replyTo(String val) {
           replyTo = val;
           return this;
       }
       
       public DfmEmailUtility plainTextBody(String val) {
           plainTextBody = val;
           return this;
       }
       
       public DfmEmailUtility fileAttachments(List<Messaging.Emailfileattachment> val) {
           fileAttachments = val;
           return this;
       }
     
       // Method allow to setup data at run time 	  
       private DfmEmailUtility setUp() {
           singleEmailMessage = new Messaging.SingleEmailMessage();
           singleEmailMessage.setToAddresses(this.toAddresses);
           singleEmailMessage.setCcAddresses(this.ccAddresses);
           singleEmailMessage.setBccAddresses(this.bccAddresses);
           //singleEmailMessage.setSenderDisplayName(this.senderDisplayName);
           singleEmailMessage.setSubject(this.subject);
           singleEmailMessage.setHtmlBody(this.htmlBody);
           singleEmailMessage.setUseSignature(this.useSignature);
           //singleEmailMessage.setReplyTo(this.replyTo);
           singleEmailMessage.setPlainTextBody(this.plainTextBody);
           singleEmailMessage.setFileAttachments(this.fileAttachments);
           
           List<OrgwideEmailAddress> ordDefaultAddress = [select id from orgwideEmailAddress where displayname ='Salesforce, Noreply']; 
           if (ordDefaultAddress<>NULL && !ordDefaultAddress.isEmpty()){
		   		singleEmailMessage.setOrgWideEmailAddressId(ordDefaultAddress[0].id);
           }

           return this;
       }
       
       //send the email message
       public void sendEmail() {
              try {
                  //call build first to create the email message object
                  setUp();
                  if(!Test.isRunningTest()){
                  Messaging.sendEmail(new Messaging.SingleEmailMessage[] { singleEmailMessage });
                  }       	
              } catch (Exception ex) {
                  throw new DfmEmailUtility.GenericException('Problem while sending email, Please contact system administrator.' +ex.getMessage());
                  
              }                
       }    
       
     class GenericException extends Exception {
     }
           
  }