/*
Type Name: PCNFeedTriggerHandler
Author: Dinesh
Created Date: 11/30/2016
Reason: Reason: This is the controller class for all feeditem entered with textpost .It will send an Email Alert to Originator of PCNEOL or Owner of the PCNEOL.

Change History:
Author: 
Modified Date: 
*/
public class PCNFeedTriggerHandler{

  public Static void emailNotificationforFeedComment(List<FeedItem> NewFeedList,List<String> parentlist){
  
     List<EmailTemplate> template = [SELECT Id,Name,DeveloperName,HtmlValue FROM EmailTemplate WHERE DeveloperName='PCN_Notify_Admin_with_Customer_Comment'];
        String htmlval = '' + template[0].HtmlValue + '';
        htmlval +='<br/>Hi Admin Team,<br/><br/>This is to notify you that Customer has given comments on Feed Section of  PCN End of Life.<br/><br/>';
        List <Messaging.SingleEmailMessage> emailslist= new List<Messaging.SingleEmailMessage> (); 
        List<PCN_EOL__c> pcn=[Select CreatedBy.Email,PCN_Numbers__c from PCN_EOL__C where Id=:parentlist]; 
        
        for (feedItem feed: NewFeedList) {
        if(feed.Type == 'TextPost'){
          htmlval += '<br/><br/><a href="'+System.Label.Salesforce_Internal_URL+'/'+feed.ParentId+'">Click here to view the Record</a>';
          htmlval+='<br/><br/>Thank You<br/>Salesforce<br/><br/>';
          Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
          mail.setSenderDisplayName('GF');
          mail.settoAddresses(new List<String>{pcn[0].CreatedBy.Email});
          mail.setSubject('New Comment has been added for PCN :'+pcn[0].PCN_Numbers__c);
          mail.setSaveAsActivity(false);
          mail.setHtmlBody(htmlval);
          emailslist.add(mail);
       system.debug('emailslist'+emailslist.size());
      
         }
       }
       if(emailslist.size()>0){
           system.debug('emailslist'+emailslist);
         try{
           Messaging.sendEmail(emailslist);
          }
          Catch(Exception e){
          //Adding code for exception framework              
          PCNEOL_EmaiHandler.ExceptionalHandlingMethod(PCNFeedTriggerHandler.class.getName(),'emailNotificationforFeedComment()',String.ValueOf(pcn[0].Id),'Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString(),e.getTypeName(),e.getCause());
          }
      } 

  }
   
  
}