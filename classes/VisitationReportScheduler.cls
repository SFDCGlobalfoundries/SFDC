/*Author: Vijay Vemuru
    Description: Scheduler for Sending Executives Reports for Customer Visitation
    
    History:
    Created     -     Vijay Vemuru-    03/31/2016      - code creation.
*/

global class VisitationReportScheduler implements Schedulable,Database.Batchable<sobject> {

   global void execute(SchedulableContext sc) {
       sendEmailTemplate();
   }
   
   global Database.QueryLocator start(Database.BatchableContext BC){
    string groupName = 'VisitationExecutivesReport' ;
    String query = 'SELECT id,userorgroupid FROm groupmember where group.developername=:groupName';
      return Database.getQueryLocator(query);
   }

   global void execute(Database.BatchableContext BC, List<sobject> groupMems){
     List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
     List<EmailTemplate> template  = [SELECT id FROM EmailTemplate where DeveloperName =:'AttendeeCustomReport'];
     Id templateId = template[0].id;
      
      for(groupmember grp : (list<groupmember>)groupMems) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
               mail.setTargetObjectId(grp.userorgroupid);
               if(!test.isRunningTest()) {
               		mail.setTemplateId(templateId);
               } else {
               		mail.setHtmlBody('<html><body></body></html>');
               }
               mail.setBccSender(false);
               mail.setUseSignature(false);
               mail.setSenderDisplayName('Global Foundries');
               mail.setSaveAsActivity(false); 
               mailList.add(mail);
      }
      
      if(mailList.size() > 0) {
        Messaging.sendEmail(mailList);
      }
    }

   global void finish(Database.BatchableContext BC){
   }
   
   global void sendEmailTemplate() {
       DataBase.executeBatch(new VisitationReportScheduler(),10); 
   
   }
   
   
}