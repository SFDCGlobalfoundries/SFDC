/*
Type Name: ClsMailUtility 
Author: Cognizant
Created Date: 21-June-2013
Reason: This utility class is used for sending emails for various operations.
Change History:
Author: 
Modified Date: 
Reason: 
……..
……..
*/

public class ClsMailUtility {
    
    /**
        This method is used for sending emails for various operations.
        @method name: sendMail
        @parameter:   String, List, String, String, String, String.
        @return :     none.
    **/     
    
    public static void sendMail(String operation, List <String> emailids, String meetingtopic, String meetingDate, String meetingOccStartDateTime, String meetingOccEndDateTime, String subject,String teamRoomname,String teamRoomowner,String teamMeetingId,Datetime startdate,Datetime enddate,String agenda,String Status) {
        
        //List<User> lstUsers = [Select Id,UserType,FirstName, LastName, Email from User where Email IN:emailids]; 
        List<GF_Meeting_Invitee__c> meetingInvList = [SELECT User_Email_Address__c,Team_Room_Meeting__c,User__r.Name,User__r.Id,Community_User_URL__c FROM GF_Meeting_Invitee__c where Team_Room_Meeting__c=:teamMeetingId];    
        System.debug('@@meetingInvList'+meetingInvList);
        List<Messaging.SingleEmailMessage> lstEmailMsges = new List<Messaging.SingleEmailMessage>();
        
       for(GF_Meeting_Invitee__c objInvitee:meetingInvList)
             {
            Messaging.SingleEmailMessage mailHandler = new Messaging.SingleEmailMessage();
            //String fullName = objUser.FirstName+' '+objUser.LastName;
              
                if(operation.equalsIgnoreCase(System.Label.MeetingOccurrenceControllerCancel)){
                    mailHandler.setSubject('Meeting Cancellation to '+teamRoomname+' for '+meetingtopic);
                   
                     mailHandler.setHtmlBody('Dear '+objInvitee.User__r.Name+', <p> The meeting regarding '+meetingtopic+' on '+meetingDate+' GMT has been Cancelled.<p>'+objInvitee.Community_User_URL__c +teamMeetingId+' <p>If you have any questions, please contact '+teamRoomowner+'.<p>Thank you,<br>GLOBALFOUNDRYVIEW Admin.');
                    
                   } 
                else if(operation.equalsIgnoreCase(System.Label.MeetingOccurrenceControllerReschedule)){
                    mailHandler.setSubject(System.Label.MeetingOccuranceRescheduleEmailSubject);
                   
                    mailHandler.setHtmlBody('Dear '+objInvitee.User__r.Name+', <p> The Meeting Occurrence regarding '+meetingtopic+' on '+meetingDate+' GMT has been Rescheduled having Start Date/Time '+meetingOccStartDateTime+' GMT and End Date/Time '+meetingOccEndDateTime+' GMT. <p>If you have any questions, please contact your Customer Service Representative. <p>Thank you,<br>GLOBALFOUNDRYVIEW Administrator.');
                   
                } 
                else if(operation.equalsIgnoreCase(System.Label.TRMeetingCancelOperation)){
                     mailHandler.setSubject('Meeting recurrence cancellation to '+teamRoomname+' for '+meetingtopic);
                   
                     mailHandler.setHtmlBody('Dear '+objInvitee.User__r.Name+', <p> The Meeting regarding '+meetingtopic+' on '+meetingDate+' GMT has been cancelled along with all its meeting recurrences.<p>'+objInvitee.Community_User_URL__c +teamMeetingId+' <p>If you have any questions, please contact '+teamRoomowner+'.<p>Thank you,<br>GLOBALFOUNDRYVIEW Admin.');
                   
                }
                 else if(operation.equalsIgnoreCase(System.Label.MeetingOccurrenceControllerSendMeetingInvitee)) {
                 
                    mailHandler.setSubject('Meeting Invitation to '+teamRoomname+' for '+meetingtopic);
                  
                   mailHandler.setHtmlBody('Dear '+objInvitee.User__r.Name+', <p> You are invited to a meeting .The details are given below,<p>Start DateTime:'+startdate+' GMT <p>End DateTime:'+enddate+' GMT<p>Recurrence Status :'+Status+'<p>Agenda :'+agenda+'<p>'+objInvitee.Community_User_URL__c+teamMeetingId+'<p>If you have any questions, please contact '+teamRoomowner+'.<p>Thank you,<br>GLOBALFOUNDRYVIEW Admin.');
                   
                }
                 else if(operation.equalsIgnoreCase(System.Label.MeetingOccurrenceControllerSendMeetingNotes)) {
                    mailHandler.setSubject('Meeting Notes sent.');
                    mailHandler.setHtmlBody(meetingtopic);
                }
                 else if(operation.equalsIgnoreCase('TeamRoomInsert')){
                    mailHandler.setSubject('New Team Room Creation');
                    mailHandler.setHtmlBody('Dear '+objInvitee.User__r.Name+', <p> New Team Room has been created.<p>If you have any questions, please contact your Customer Service Representative. <p>Thank you,<br>GLOBALFOUNDRYVIEW Administrator.');          
                }
            
               
               
            mailHandler.setTargetObjectId(objInvitee.User__r.Id);
            mailHandler.setSaveAsActivity(false);
            lstEmailMsges.add(mailHandler);
        
        }
        // Sends the email
        try{
            Messaging.SendEmailResult [] r = Messaging.sendEmail(lstEmailMsges);
                       
        }catch(Exception e){
            System.debug(e.getMessage());
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, System.Label.MailSendErrorMsg));
        }
    }

}