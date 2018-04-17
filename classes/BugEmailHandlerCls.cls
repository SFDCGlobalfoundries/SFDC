/*
Type Name: BugEmailHandlerCls
Author: UCM Team
Created Date: 10/08/2016
Reason: Reason: This class is used for adding emails description to feed item in Bug object.
Test Class: 
Change History:
Author:
Modified Date: 
*/
global class BugEmailHandlerCls implements Messaging.InboundEmailHandler {

    Bug__c bugObj = null;      
    public BugEmailHandlerCls () {  
    }
    
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) 
    {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        String bugSubjectPattern  = 'B-';
        List<Attachment> attachments = new List<Attachment>();
        String emailSubject = email.subject;    
        bugSubjectPattern = bugSubjectPattern + getBugSubjectPattern(emailSubject);                
        if(bugSubjectPattern != null) {
            // fetching appropriate Bug record from Subject                    
            List<Bug__c> bugList = [Select Id,Name from Bug__c where Name=:bugSubjectPattern limit 1];
            iF(bugList.size() > 0){
                this.bugObj = bugList[0];
                String bugId = bugObj.Id;                             
                insertFeed(bugObj, email); 
                handleAttachments(bugObj, email);               
            }
        }    
        return result;
    }
    String getBugSubjectPattern(String emailSubject){
        String patternString = '^\\D+(\\d+).*';
        Pattern thePattern = Pattern.compile(patternString);
        String bugSubjectPattern;
        Matcher matcher = thePattern.matcher(emailSubject);
        if (matcher.matches()) 
        bugSubjectPattern = matcher.group(1);

        return bugSubjectPattern;
    }
    public void insertFeed(Bug__C bugObj, Messaging.InboundEmail email) {
        try{
            Set<String> prefixes = new Set<String>{
                   're:',
                   'RE:',
                   'Re:',
                   'Re:'
            };
            
            String sub =email.Subject.substringBefore(':').trim()+':';
            
            FeedItem feeditemVar = new FeedItem();
            feeditemVar.parentid = bugObj.id;
            string emailBody = 'From:'+ email.fromName+'\n Subject: '+ email.Subject +'\n Description: \n ' + email.plainTextBody;           
            feeditemVar.Body = emailBody; 
            if(prefixes.contains(sub)) {
                        insert feeditemVar; 
                    }                                       
            if(Test.isRunningTest()) {
                        throw new applicationException('In Test Mode');
                    }
            
        }catch (Exception e) {
                    
                    //Adding code for exception framework
                    ApplicationLogWrapper alw=new ApplicationLogWrapper();
                    alw.source = BugEmailHandlerCls.class.getName();
                    alw.sourceFunction ='handleInboundEmail()';
                    alw.ApplicationName='Bug';
                    alw.referenceId = bugObj.id;
                    alw.referenceInfo = 'Bug';
                    alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                    alw.debugLevel ='Error';
                    alw.logCode =e.getTypeName();
                    alw.ex=e.getCause();
                    GlobalUtility.logMessage(alw);
        }  
    }
public class applicationException extends Exception {}

 public void handleAttachments(Bug__C theBug, Messaging.InboundEmail email) {
        try{
            List<Attachment> email_atts=new List<Attachment>();//List of attachments coming in mail
            List<Attachment> TBI_atts=new List<Attachment>();//List of attachments which needs to be inserted           
            Set<Attachment> uniqueAtts = new Set<Attachment>();//Unique set of attachments which will be inserted
            Set<String> atts_old=new Set<String>();//Set of unique combination of Name+body of the attachment
                       
            if (email.textAttachments != null && email.textAttachments.size() > 0) 
            {
                for (Messaging.Inboundemail.TextAttachment tAttachment: email.textAttachments) {
                    Attachment attachment = new Attachment();
                    attachment.Name = tAttachment.fileName;
                    attachment.Body = Blob.valueOf(tAttachment.body);
                    attachment.ParentId = theBug.Id;
                    attachment.ContentType = tAttachment.mimeTypeSubType;
                    email_atts.add(attachment);
                }
            }            
            if (email.binaryAttachments != null && email.binaryAttachments.size() > 0) {
                for (Messaging.Inboundemail.BinaryAttachment bAttachment: email.binaryAttachments) {
                    Attachment attachment = new Attachment();
                    attachment.Name = bAttachment.fileName;
                    attachment.Body = bAttachment.body;
                    attachment.ParentId = theBug.Id; 
                    attachment.ContentType = bAttachment.mimeTypeSubType;
                    email_atts.add(attachment);
                }
            }
            List < Attachment> listFeedItemFiles = [SELECT  Id,Name,Body                                   
                                                                FROM Attachment 
                                                                WHERE ParentId  = : theBug.Id
                                                                ]; 
            if (listFeedItemFiles != null && listFeedItemFiles.size() > 0) {
                for (Attachment fi: listFeedItemFiles){
                    Attachment attachment = new Attachment();
                    attachment.Name = fi.Name ;
                    attachment.Body = fi.Body ;
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
                insert TBI_atts;
            } 
            if(Test.isRunningTest()) {
                        throw new applicationException('In Test Mode');
            }           
        }catch (Exception e) {
                    ApplicationLogWrapper alw=new ApplicationLogWrapper();
                    alw.source = BugEmailHandlerCls.class.getName();
                    alw.sourceFunction = 'handleAttachments()';
                    alw.ApplicationName='Bug';
                    alw.referenceId = bugObj.id;
                    alw.referenceInfo = 'Bug';
                    alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                    alw.debugLevel ='Error';
                    alw.logCode =e.getTypeName();
                    alw.ex=e.getCause();
                    GlobalUtility.logMessage(alw);
        //CaseHandlerUtility.trackException('BugEmailHandlerCls.handleAttachments',e.getLineNumber(),e.getTypeName(),e.getMessage());
        }  
    }
}