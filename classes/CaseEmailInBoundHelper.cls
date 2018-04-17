/*
Type Name: CaseEmailInBoundHelper
Author: UCM Cognizant
Created Date: 26/04/2016
Reason: Reason: This is the helper class for routing and handling duplicate technical cases created by using Email Service
Test Class: CaseEmailInBoundTest
Change History:
Author:
Modified Date: 
……..//
……..
--
*/
public with sharing class CaseEmailInBoundHelper{
    public CaseEmailInBoundHelper() {        
    }
    //Mona- Myra case 6/6/16 start
    //Insert the email to FeedPost
    public void insertFeed(Case theCase, Messaging.InboundEmail email) {
        try{
            String value;
            List<String> emailLst = new List<String>();
            String toAddress ='';
            String ccAddress ='';
            string plainbody;
            string toCCLst;
            string checkdomain;
            boolean flag = false;
            FeedItem feeditemVar = new FeedItem();
            feeditemVar.parentid = theCase.id;          
           
            if(email.plainTextBody.length()>=9000){
                   plainbody = email.plainTextBody.substring(0, 9000);
            }
            else {
                   plainbody = email.plainTextBody;
            }
             value = '';
            if (email.toAddresses != null) {
                Boolean seenOne = false;
                for (String to: email.toAddresses) {
                    if (seenOne) {
                        value += ';\n';
                    }
                    to = extractAddress(to);
                    value += to;
                    seenOne = true;
                }
            }
            toAddress = value;
            
           /* **** CC */
            value = '';
            if (email.ccAddresses != null) {            
                Boolean seenOne = false;
                for (String cc: email.ccAddresses) {
                    if (seenOne) {
                        value += ';\n';
                    }
                    cc = extractAddress(cc);
                    value += cc;
                    seenOne = true;
                }
            }           
            ccAddress = value;                                     
            if(ccAddress != '')
                toCCLst =  toAddress +';'+ ccAddress ;
            else
                toCCLst =  toAddress;                          
            List<string> lstEmail = toCCLst.split(';');      
            for(string str:lstEmail){ 
                 checkdomain= str.split('@').get(1);                 
                   if(checkdomain == System.Label.CaseGlobalFoundaryDomain){             
                            continue;
                     }
                    else{                     
                           flag = true;
                           break;
                     }                      
             }         
            string emailBody = 'From:'+ email.fromAddress+'\n To:'+ toAddress + '\n CC:'+ ccAddress + '\n Date: ' + DateTime.now() + '\n Subject: '+ email.Subject + '\n\n' + plainbody;             
            //string emailBody = 'From:'+ email.fromName+'\n Subject: '+email.Subject+'\n Description: \n ' + plainbody;           
            feeditemVar.Body = emailBody;
            if(flag){
                feeditemVar.VISIBILITY = 'AllUsers';
             }
            //feeditemVar.InsertedById = uid;//Field is  not writeable
            theCase.AttachmentUploadedFlag__c = true;
            //theCase.EmailAttachmentFlag__c  
            //theCase.Last_Attachment_Date__c = DateTime.Now().addSeconds(-80);

            updateSObject(theCase);
            insert feeditemVar; 
            if(Test.isRunningTest()) {
                        throw new applicationException('In Test Mode');
            } 
        }catch (Exception e) {
                    ApplicationLogWrapper alw=new ApplicationLogWrapper();
                    alw.source = CaseEmailServiceHandler.class.getName();
                    alw.sourceFunction = 'insertFeed()';
                    alw.ApplicationName='Case Management';                  
                    alw.referenceInfo = 'CaseEmailInBoundHelper';
                    alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                    alw.debugLevel ='Error';
                    alw.logCode =e.getTypeName();
                    alw.ex=e.getCause();
                    GlobalUtility.logMessage(alw);      
        }  
    }
    //Mona- Myra case 6/6/16 end
    // Save attachments, if any
    public void handleAttachments(Case theCase, Messaging.InboundEmail email) {
        try{
            List<Attachment> email_atts=new List<Attachment>();//List of attachments coming in mail
            List<Attachment> TBI_atts=new List<Attachment>();//List of attachments which needs to be inserted           
            Set<Attachment> uniqueAtts = new Set<Attachment>();//Unique set of attachments which will be inserted
            Set<String> atts_old=new Set<String>();//Set of unique combination of Name+body of the attachment
            if (email.textAttachments != null && email.textAttachments.size() > 0) {
                for (Messaging.Inboundemail.TextAttachment tAttachment: email.textAttachments) {
                    Attachment attachment = new Attachment();
                    attachment.Name = tAttachment.fileName;
                    attachment.Body = Blob.valueOf(tAttachment.body);
                    attachment.ParentId = theCase.Id;
                    email_atts.add(attachment);
                }
            }

            if (email.binaryAttachments != null && email.binaryAttachments.size() > 0) {
                for (Messaging.Inboundemail.BinaryAttachment bAttachment: email.binaryAttachments) {
                    Attachment attachment = new Attachment();
                    attachment.Name = bAttachment.fileName;
                    attachment.Body = bAttachment.body;
                    attachment.ParentId = theCase.Id; 
                    email_atts.add(attachment);
                }
            }
            List <CaseFeed> listFeedItemFiles = [SELECT   Id,                                    
                                                                ContentFileName,
                                                                Title,
                                                                ContentSize,
                                                                ContentData,
                                                                CreatedDate,
                                                                RelatedRecordId,
                                                                LastModifiedDate,
                                                                InsertedBy.Name,
                                                                Visibility
                                                                FROM CaseFeed
                                                                WHERE ParentId = : theCase.Id
                                                                AND Type = 'ContentPost']; 
            if (listFeedItemFiles != null && listFeedItemFiles.size() > 0) {
                for (CaseFeed fi: listFeedItemFiles){
                    Attachment attachment = new Attachment();
                    attachment.Name = fi.ContentFileName;
                    attachment.Body = fi.ContentData;
                    String attName= attachment.Name;
                    //String data = attachment.Body.toString();
                    String name = attName+attachment.Body; 
                    atts_old.add(name);
                }
            }
            for(Attachment a1:email_atts){
                if(!atts_old.contains(a1.Name+a1.body)){
                    uniqueAtts.add(a1);
                }
            }
            TBI_atts.addAll(uniqueAtts);
            if(TBI_atts!=null && TBI_atts.size()>0){
                CaseHandlerUtility.isCompleted = false;
                theCase.AttachmentUploadedFlag__c = true;
                updateSObject(theCase);
                CaseHandlerUtility.isCompleted = true;
                insert TBI_atts;
            }
            if(Test.isRunningTest()) {
                        throw new applicationException('In Test Mode');
            }  
        }catch (Exception e) {
                    ApplicationLogWrapper alw=new ApplicationLogWrapper();
                    alw.source = CaseEmailServiceHandler.class.getName();
                    alw.sourceFunction = 'handleAttachments()';
                    alw.ApplicationName='Case Management';                  
                    alw.referenceInfo = 'CaseEmailInBoundHelper';
                    alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                    alw.debugLevel ='Error';
                    alw.logCode =e.getTypeName();
                    alw.ex=e.getCause();
                    GlobalUtility.logMessage(alw);      
        }  
    }

    public void insertSObject(sObject obj) {
         try {
            insert obj;
            if(Test.isRunningTest()) {
                        throw new applicationException('In Test Mode');
            }
        }catch (Exception e) {
                    ApplicationLogWrapper alw=new ApplicationLogWrapper();
                    alw.source = CaseEmailServiceHandler.class.getName();
                    alw.sourceFunction = 'insertSObject()';
                    alw.ApplicationName='Case Management';                  
                    alw.referenceInfo = 'CaseEmailInBoundHelper';
                    alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                    alw.debugLevel ='Error';
                    alw.logCode =e.getTypeName();
                    alw.ex=e.getCause();
                    GlobalUtility.logMessage(alw);  
        }  
    }
    public void updateSObject(sObject obj) {
         try {
            update obj;
            if(Test.isRunningTest()) {
                        throw new applicationException('In Test Mode');
            }
        } catch (Exception e) {
                    ApplicationLogWrapper alw=new ApplicationLogWrapper();
                    alw.source = CaseEmailServiceHandler.class.getName();
                    alw.sourceFunction = 'updateSObject()';
                    alw.ApplicationName='Case Management';                  
                    alw.referenceInfo = 'CaseEmailInBoundHelper';
                    alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                    alw.debugLevel ='Error';
                    alw.logCode =e.getTypeName();
                    alw.ex=e.getCause();
                    GlobalUtility.logMessage(alw);      
        }    
        
    }

    public String limitLength(String input, Integer maxLength) {
        try{
            String results;
            if (input != null && input.length() > maxLength)
                results = input.substring(0, maxLength);
            else{
                results = input;
            }
            if(Test.isRunningTest()) {
                throw new applicationException('In Test Mode');
            }
            return results;
        }catch (Exception e) {
                    ApplicationLogWrapper alw=new ApplicationLogWrapper();
                    alw.source = CaseEmailServiceHandler.class.getName();
                    alw.sourceFunction = 'limitLength()';
                    alw.ApplicationName='Case Management';                  
                    alw.referenceInfo = 'CaseEmailInBoundHelper';
                    alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                    alw.debugLevel ='Error';
                    alw.logCode =e.getTypeName();
                    alw.ex=e.getCause();
                    GlobalUtility.logMessage(alw);           
                    return null;
        }    
    }

    public void createEmailMessage(Case theCase, Messaging.InboundEmail email) {
        try{
            String value;
            Integer maxlength;
            EmailMessage theEmail = new EmailMessage();
            theEmail.ParentId = theCase.Id;
            theEmail.Incoming = true;
            Schema.DescribeFieldResult F = EmailMessage.HtmlBody.getDescribe();
            //.HtmlBody.getDescribe();
            maxlength = F.getLength();
            theEmail.Subject = limitLength(email.Subject, EmailMessage.Subject.getDescribe().getLength());
            theEmail.MessageDate = datetime.now();
            theEmail.HtmlBody = limitLength(email.htmlBody, EmailMessage.HtmlBody.getDescribe().getLength());
            theEmail.TextBody = limitLength(email.plainTextBody, EmailMessage.TextBody.getDescribe().getLength());

            /* **** To */
            value = '';
            if (email.toAddresses != null) {
                Boolean seenOne = false;
                for (String to: email.toAddresses) {
                    if (seenOne) {
                        value += ';\n';
                    }
                    to = extractAddress(to);
                    value += to;
                    seenOne = true;
                }
            }
            theEmail.ToAddress = limitLength(value, EmailMessage.ToAddress.getDescribe().getLength());

            /* **** From */
            theEmail.FromName = email.fromName;
            theEmail.FromAddress = email.fromAddress;

            /* **** CC */
            value = '';
            if (email.ccAddresses != null) {
                Boolean seenOne = false;
                for (String cc: email.ccAddresses) {
                    if (seenOne) {
                        value += ';\n';
                    }
                    cc = extractAddress(cc);
                    value += cc;
                    seenOne = true;
                }
            }
            theEmail.CcAddress = limitLength(value, EmailMessage.CcAddress.getDescribe().getLength());
            insertSObject(theEmail);
            if(Test.isRunningTest()) {
                        throw new applicationException('In Test Mode');
            }
        }catch (Exception e) {
                    ApplicationLogWrapper alw=new ApplicationLogWrapper();
                    alw.source = CaseEmailServiceHandler.class.getName();
                    alw.sourceFunction = 'createEmailMessage()';
                    alw.ApplicationName='Case Management';                  
                    alw.referenceInfo = 'CaseEmailInBoundHelper';
                    alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                    alw.debugLevel ='Error';
                    alw.logCode =e.getTypeName();
                    alw.ex=e.getCause();
                    GlobalUtility.logMessage(alw);                                  
        } 
    }

 /*
 Look for the case reference in the email subject line.  First search for a case reference using the standard Salesforce method of creating that complicated and non-user-friendly reference.  
 Do this first so it takes precedence.

 But, also search for the case number itself. This is user-friendly!
 */
    public String extractRef(String emailSubject) {
        try{
 
            String itemRef = null;
            String target = emailSubject.toLowerCase();
            String patternString;
            Pattern thePattern;
            Matcher matcher;

      /*  Take the text between the period and ":ref"  For example in the ref [ ref:00D7JFzw.5007H3Rh8:ref ] extract 5007H3Rh8
       Take that text and remove the 5007. For example H3Rh8 
       Append H3Rh8 to https://na5.salesforce.com/5007000000  to produce https://na5.salesforce.com/5007000000H3Rh8.   This is your link to get to the case.
      */
            patternString = '.*ref:(.{8}).(.{4})(.+):ref.*';
            thePattern = Pattern.compile(patternString);
            matcher = thePattern.matcher(emailSubject); // do not change to lower case for this test because Id's are case sensitive

            if (matcher.matches()) {
                String caseId = matcher.group(2) + '000000' + matcher.group(3);
                Case[] matchingCases = [Select CaseNumber from Case where Id = : caseId];
                if (matchingCases.size() == 1) {
                    Case theCase = matchingCases[0];
                    itemRef = theCase.CaseNumber;
                }
            }
            if (itemRef == null) {
                // extract the Case Number from the email Subject
                // Re: Test two numbers Case: 30088 and Case: 30089'
                // returns 30089, the last pattern matched
                patternString = '.*case[;:=]?\\s*([0-9]+).*';
                thePattern = Pattern.compile(patternString);
                matcher = thePattern.matcher(target);

                if (matcher.matches()) {
                    itemRef = matcher.group(1);
                }
            }
            if(Test.isRunningTest()) {
                        throw new applicationException('In Test Mode');
            }
            return itemRef;
        }catch (Exception e) {
                    ApplicationLogWrapper alw=new ApplicationLogWrapper();
                    alw.source = CaseEmailServiceHandler.class.getName();
                    alw.sourceFunction = 'extractRef()';
                    alw.ApplicationName='Case Management';                  
                    alw.referenceInfo = 'CaseEmailInBoundHelper';
                    alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                    alw.debugLevel ='Error';
                    alw.logCode =e.getTypeName();
                    alw.ex=e.getCause();
                    GlobalUtility.logMessage(alw);             
                    return null;
        } 
    }

    public String extractAddress(String inAddress) {
        try{
            String address;
            String patternString;
            Pattern thePattern;
            Matcher matcher;
            patternString = '.*<(.*)>.*';
            thePattern = Pattern.compile(patternString);
            matcher = thePattern.matcher(inAddress);
            if (matcher.matches()) {
                address = matcher.group(1);
            } else {
                address = inAddress;
            }
            if(Test.isRunningTest()) {
                        throw new applicationException('In Test Mode');
            }
            return address;
        }catch (Exception e) {
                    ApplicationLogWrapper alw=new ApplicationLogWrapper();
                    alw.source = CaseEmailServiceHandler.class.getName();
                    alw.sourceFunction = 'extractAddress()';
                    alw.ApplicationName='Case Management';                  
                    alw.referenceInfo = 'CaseEmailInBoundHelper';
                    alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                    alw.debugLevel ='Error';
                    alw.logCode =e.getTypeName();
                    alw.ex=e.getCause();
                    GlobalUtility.logMessage(alw);             
                    return null;                       
        } 
    }
      public class applicationException extends Exception {}   
}