/*Author: Vijay Vemuru
    Description: Email Service for sending CVA Survey
    History:
    Created     -     Vijay Vemuru   -    03/3/2016      - code creation.
*/
global class VisitationEmailReceive implements Messaging.InboundEmailHandler {

 global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.Inboundenvelope envelope) {
  if (!string.isblank(email.subject)) {
   string subject = email.subject;
   Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
   if (subject.contains('Verify your Salesforce Organization-Wide Address')) {
    result.success = false;
    result.message = email.plainTextBody;
    exception e;
    throw e;
    return result;
   }
   boolean flag = false;

   if (Visitation_Setting__c.getInstance('SHOW CHATTER TAB') != null) {
    flag = Visitation_Setting__c.getInstance('SHOW CHATTER TAB').value_boolean__c;
   }
   string csNumber;
   if (subject.contains('#')) {
    csNumber = subject.substring(subject.indexOf('#') + 1, subject.indexOf(' - Please'));
   }

   Visitation_Record__c Visit = [SELECT Id, Customer_Status__c FROM Visitation_Record__c WHERE Name = : csNumber limit 1];
   List < FeedItem > feedItemList = New List < FeedItem > ();
   List < Attachment > attachList = New List < Attachment > ();
   for (Messaging.Inboundemail.BinaryAttachment bAttachment: email.binaryAttachments) {
    if (flag) {
     feedItemList.add(new FeedItem(ParentId = Visit.Id, Body = 'Attachment added', ContentData = bAttachment.body, ContentFileName = bAttachment.filename, Title = bAttachment.filename));
    } else {
     Attachment attachment = new Attachment();
     attachment.Body = bAttachment.body;
     attachment.Name = bAttachment.filename;
     attachment.ParentId = visit.id;
     attachList.add(attachment);
    }
   }
   if (flag) {
    Insert feedItemList;
   } else {
    Insert attachList;
   }
   Visit.Customer_Status__c = '5. Closed - Completed';
   update visit;
  }
  return null;
 }
}