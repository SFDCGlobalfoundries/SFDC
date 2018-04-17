/*
 Type Name: ClsSendMeetingInviteController
 Author: Cognizant Technology Solutions
 Created Date: 12-Jun-2013
 Reason: This class is responsible for sending mail to invitees.
 Change History:
 Author: 
 Modified Date: 
 Reason: 
 …….. 
 ……..
*/

public without sharing class ClsSendMeetingInviteController 
{
    
    /**
    
    Variable Declaration
    
    */
    public Id teamroommeetingId{get;set;}
    public List<GF_Meeting_Invitee__c>inviteeList{get;set;}
    public Boolean disableConfirmButton{get;set;}
    ApexPages.standardController cancelController = null;
    String teamMeetingname,meetingtopic,teamRoomname,teamRoomowner,agenda,Status;
    Datetime startdate,enddate;
    Team_Room_Meeting__c teammeetingObj = new Team_Room_Meeting__c();
    Team_Room_Meeting__c checkteammeetingObj = new Team_Room_Meeting__c();
    List <String> emailIds = new List<String>();
    List<GF_Meeting_Invitee__c>  meetingInvList = new List<GF_Meeting_Invitee__c> ();
    
     /**
        This method helps to make the list of invitee with respect to team room meeting id.
        
        @method name: ClsSendMeetingInviteController
        @return : null
     */
     
     
    public ClsSendMeetingInviteController(ApexPages.StandardController controller) 
    {
       
       cancelController = controller;
       teamroommeetingId = Apexpages.currentPage().getParameters().get('id');
       inviteeList = [Select g.User__r.Name,
                             g.User_Email_Address__c,
                             g.Team_Room_Meeting__r.Name,
                             g.Team_Room_Meeting__r.Start_DateTime__c,
                             g.Team_Room_Meeting__r.End_DateTime__c, 
                             g.Name From GF_Meeting_Invitee__c g
                             where g.Team_Room_Meeting__c =:teamroommeetingId];                      
      
      checkteammeetingObj = [Select Status__c from Team_Room_Meeting__c where Id =:teamroommeetingId];
      if(checkteammeetingObj.Status__c != 'Open')
      {
         disableConfirmButton = true;
         ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Status of Associated Team Room Meeting is '+checkteammeetingObj.Status__c+'. So, You can not send the mail to Invitees.'));  
      } 

    }
    /**
        This method is used to send the emails to invitee list.
        
        @method name: sendmail
        @return : Team Room Meeting Detail Page
     */
     
     public pagereference sendmail()
     {

        Messaging.SingleEmailMessage mailHandler = new Messaging.SingleEmailMessage();
        teammeetingObj = [SELECT Name,Agenda__c,Status__c,Subject__c,Start_DateTime__c,End_DateTime__c,Team_Room__c,Team_Room__r.Name,Team_Room__r.Owner.Name FROM Team_Room_Meeting__c where Id = :teamroommeetingId];
        teamMeetingname = teammeetingObj.Name;
        teamRoomname = teammeetingObj.Team_Room__r.Name ;
        teamRoomowner=teammeetingObj.Team_Room__r.Owner.Name;
        meetingtopic = teammeetingObj.Subject__c;
        startdate = teammeetingObj.Start_DateTime__c;
        enddate = teammeetingObj.End_DateTime__c;
        agenda = teammeetingObj.Agenda__c;
        Status= teammeetingObj.Status__c;
        //meetingInvList = [SELECT Email FROM User where Id in (SELECT User__c FROM GF_Meeting_Invitee__c where Team_Room_Meeting__c = :teamroommeetingId)];
        meetingInvList=[SELECT User_Email_Address__c FROM GF_Meeting_Invitee__c where Team_Room_Meeting__c = :teamroommeetingId];
        for(GF_Meeting_Invitee__c meetingInvObj : meetingInvList){
            //emailIds.add(meetingInvObj.Email);
            emailIds.add(meetingInvObj.User_Email_Address__c);
        }
        String operation = 'SendMeetingInvitee';
        
        //mailHandler.setSubject(System.Label.SendEmailInviteeSubject);
//        mailHandler.setSubject('Meeting Invitation : '+''+meetingtopic);
//        mailHandler.setHtmlBody(System.Label.FirstInviteeEmailBody+' '+meetingtopic +' '+ 'on' +' ' +teammeetingObj.Start_DateTime__c+System.Label.SecondInviteeEmailBody);
//        mailHandler.setToAddresses(emailids);
//        mailHandler.setSaveAsActivity(false);
        //Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mailHandler}); 

/*        try{
        Messaging.SendEmailResult [] r = 
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mailHandler});           
        }catch(Exception e){
            System.debug(e.getMessage());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, '<font color="red">Some paremeters missing for sending Email. Please include Invitees and Check again.</font>'));
        }    
  */      
        ClsMailUtility.sendMail(operation, emailids, meetingtopic, String.valueOf(teammeetingObj.Start_DateTime__c), '', '','',teamRoomname,teamRoomowner,teamroommeetingId,startdate,enddate,agenda,Status);
        
        return new pagereference('/'+teamroommeetingId);           
        
    }
    /**
        This method is used to cancel the page and navigate the previous page.
        
        @method name: cancelSendingMail
        @return : Team Room Meeting Detail Page
     */
    public pagereference cancelSendingMail()
    {
        return  cancelController.cancel();
    }

}