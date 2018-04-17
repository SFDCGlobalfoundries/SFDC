/*
Type Name: CaseEmailHandlerCls
Author: UCM Team
Created Date: 8/08/2016
Reason: Reason: This class is used for copying images and attachments out of customers reply emails to Cases
Test Class: 
Change History:
Author:
Modified Date: 
*/
global class CaseEmailHandlerCls implements Messaging.InboundEmailHandler {
    Case caseObj = null;
    CaseEmailInBoundHelper helper;
    public CaseEmailHandlerCls() {
        helper =  new CaseEmailInBoundHelper();
    }
    
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();        
        List<FeedItem> feedItemLst = new List<FeedItem> ();
        List<Attachment> attachments = new List<Attachment>();
        String emailSubject = email.subject;         
        Set<String> prefixes = new Set<String>{
           're:',
           'RE:',
           'Re:',
           'Re:'
        };
        String sub =email.Subject.substringBefore(':').trim()+':';                     
        String caseSubjectPattern = getCaseSubjectPattern(emailSubject);
        
        if(caseSubjectPattern != null) {
            // fetching appripriate Case record from Subject 
            List<Case> caseList = [Select Id,CaseNumber,Status from Case where CaseNumber=:caseSubjectPattern limit 1];
            if(caseList.size() > 0) {
                this.caseObj = caseList[0];
                //Case caseObj = caseList.get(0);
                String caseId = caseObj.Id;   
                CaseFeed feedObj = [SELECT Id, Type, ParentId, VISIBILITY FROM CaseFeed WHERE 
                                    parentid =:caseId  and (type ='TextPost' or type = 'ContentPost' or type = 'TrackedChange')  order by createdDate desc limit 1]; 
                                                
                FeedItem feeditemVar = new FeedItem();
                feeditemVar.parentid = caseId;                    
                feeditemVar.VISIBILITY = feedObj.VISIBILITY; 
                                                             
                  if(email.plainTextBody!=null) {                                                      
                        if(email.plainTextBody.length() >= 9000){                              
                               feeditemVar.Body = email.plainTextBody.substring(0, 9000);
                        }
                        else {
                               feeditemVar.Body = email.plainTextBody;
                        }
                        
                                           
                  }else if(email.HtmlBody!=null) {
                        if(email.HtmlBody.length()>=9000){
                                feeditemVar.Body  = email.HtmlBody.replaceAll('\\<.*?>','').substring(0, 9000);
                        }
                        else{
                               feeditemVar.Body = email.HtmlBody.replaceAll('\\<.*?>','');
                         }                    
                  }
                  
                feedItemLst.add(feeditemVar);
                // Process any text attachments, such as JS files, HTML files, etc.
                if(email.TextAttachments != null) {
                    for(Messaging.InboundEmail.TextAttachment attachment: email.TextAttachments) {
                        attachments.add(new Attachment(ParentId=caseId, Body=Blob.valueOf(attachment.body), Name=attachment.fileName,   ContentType=attachment.mimeTypeSubType));
                    }
                }

                // Process videos, images, etc.
                if(email.BinaryAttachments != null) {
                    for(Messaging.InboundEmail.BinaryAttachment attachment: email.BinaryAttachments) {
                        attachments.add(new Attachment(ParentId=caseId, Body=attachment.body, name=attachment.fileName, ContentType=attachment.mimeTypeSubType));
                    }
                }
            }

            helper.handleAttachments(caseObj, email);
            if(feedItemLst.size() > 0) {
                try{
                    if(prefixes.contains(sub)) {
                        insert feedItemLst;
                    }
                    if(Test.isRunningTest()) {
                        throw new applicationException('In Test Mode');
                    }    
                }catch(Exception e) {
                    System.debug('Error creating comment Record:' + e.getMessage());
                   
                    //Adding code for exception framework
                    ApplicationLogWrapper alw=new ApplicationLogWrapper();
                    alw.source =CaseEmailHandlerCls.class.getName();
                    alw.sourceFunction ='handleInboundEmail()';
                    alw.ApplicationName='Case Management';
                    alw.referenceId =caseObj.id;
                    alw.referenceInfo='Case';
                    alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                    alw.debugLevel ='Error';
                    alw.logCode =e.getTypeName();
                    alw.ex=e.getCause();
                    GlobalUtility.logMessage(alw);
                }    
            }            
        }    
        return result;
    }
    String getCaseSubjectPattern(String emailSubject){
        String patternString = '^\\D+(\\d+).*';
        Pattern thePattern = Pattern.compile(patternString);
        String caseSubjectPattern;
        Matcher matcher = thePattern.matcher(emailSubject);
        if (matcher.matches()) 
        caseSubjectPattern = matcher.group(1);

        return caseSubjectPattern;
    }
    
     
    public class applicationException extends Exception {}
}