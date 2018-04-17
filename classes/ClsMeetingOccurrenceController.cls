/*
Type Name: ClsMeetingOccurrenceController 
Author: Cognizant
Created Date: 24-May-2013
Reason: This class is used for cancelling and rescheduling of meeting occurances and sending mails to individual users.
Change History:
Author: 
Modified Date: 
Reason: 
……..
……..
*/

public class ClsMeetingOccurrenceController {

    public String Id {get; set;}
    public String methodCalled {get; set;}
    public String dateDisplay {get; set;}
    public String meetingStatus {get; set;}
    public String success {get; set;}
    public String createdByUser {get; set;}         
    private GF_Meeting_Occurrence__c objmeetingOccurances;

    public ClsMeetingOccurrenceController(ApexPages.StandardController controller) {

        methodCalled=Apexpages.currentPage().getParameters().get('button');
        Id= Apexpages.currentPage().getParameters().get('id');
        this.objmeetingOccurances = (GF_Meeting_Occurrence__c)controller.getRecord();
        success = 'false';      
        System.debug('****************Intialising success************************');
        
        List<Team_Room_Meeting__c> teamRoomMeetingList = [SELECT CreatedById FROM Team_Room_Meeting__c where Id in (SELECT Team_Room_Meeting__c FROM GF_Meeting_Occurrence__c where Id = :Id)];
        for(Team_Room_Meeting__c teamRoomMeetingObj : teamRoomMeetingList){
            createdByUser = teamRoomMeetingObj.CreatedById;
        }    
        
        meetingStatus = checkMeetingStatus();
        if(meetingStatus.equalsIgnoreCase(System.Label.MeetingOccurrenceControllerCancelled)){
            dateDisplay = 'DisplayNo';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, System.Label.MeetingCancelledMessage));
        } else {
            String loggedInUser = UserInfo.getUserId();
            if(loggedInUser.equalsIgnoreCase(createdByUser)){
              if(methodCalled != null){
                if(methodCalled.equalsIgnoreCase(System.Label.MeetingOccurrenceControllerCancel)){
                    dateDisplay = System.Label.CancelMeetingDisplayNo;
                } else {
                    dateDisplay = System.Label.CancelMeetingDisplayYes;
                }          
              }    
            } else {
                  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'You are not the Owner of the Team Room Meeting. Hence you cannot reschedule / cancel this meeting.'));
            }         
        }
    }

    /**
        This method is used for cancelling and rescheduling of meeting occurances and sending mails to individual users.
        @method name: cancelRescheduleAction
        @parameter:   none.
        @return :     PageReference object.
    **/ 

     public Pagereference cancelRescheduleAction() {
        
          String loggedInUser = UserInfo.getUserId();          
         
          if(loggedInUser.equalsIgnoreCase(createdByUser)){
              if(!meetingStatus.equalsIgnoreCase(System.Label.MeetingOccurrenceControllerCancelled)){ 
                    updateMeetingOccurancesDB(methodCalled);
                    sendmail(methodCalled);             
              } 
          }
          
          PageReference p = new PageReference('/'+Id);
          //p.getParameters().put('nooverride','1');
          return p; 
    }   
    
    /**
        This method is used for updating meeting occurances new values to Database.
        @method name: updateMeetingOccurancesDB
        @parameter:   String.
        @return :     none.
    **/ 
    
    public void updateMeetingOccurancesDB(String operation){
    
        List<GF_Meeting_Occurrence__c> finalMeetingOccList = new List<GF_Meeting_Occurrence__c>();
        List<GF_Meeting_Occurrence__c> meetingOccList = [SELECT Id FROM GF_Meeting_Occurrence__c where Id= :Id];

        if(operation.equalsIgnoreCase(System.Label.MeetingOccurrenceControllerCancel)){
            for(GF_Meeting_Occurrence__c meetingOccObj : meetingOccList){
                meetingOccObj.Status__c = System.Label.MeetingOccurrenceControllerCancelled;
                finalMeetingOccList.add(meetingOccObj);
            }
        } else {
            for(GF_Meeting_Occurrence__c meetingOccObj : meetingOccList){
                meetingOccObj.Start_Time__c = objmeetingOccurances.Start_Time__c;
                meetingOccObj.End_Time__c = objmeetingOccurances.End_Time__c;
                finalMeetingOccList.add(meetingOccObj);
            }
        }
        try{
            if(finalMeetingOccList!= null && !(finalMeetingOccList.isEmpty())){
                update finalMeetingOccList;
            }   
        }catch(DMLException de){
             System.debug(de.getMessage());
        }
    }
    
    /**
        This method is used for sending mails to individual users on cancellation and rescheduling.
        @method name: sendmail
        @parameter:   String.
        @return :     none.
    **/ 

    public void sendmail(String operation){

        System.debug('Mail is going to be sent.**************************************************');
        
        
        GF_Meeting_Occurrence__c meetingOccobj = [SELECT Name,Meeting_Date__c,Start_Time__c,End_Time__c FROM GF_Meeting_Occurrence__c where Id= :Id];
        String meetingDate = String.valueOf(meetingOccobj.Meeting_Date__c);
        String meetingOccName = meetingOccobj.Name;
        String meetingOccStartDateTime = String.valueOf(meetingOccobj.Start_Time__c);
        String meetingOccEndDateTime = String.valueOf(meetingOccobj.End_Time__c);
        Team_Room_Meeting__c teamRoomMeetingobj = [SELECT Name,Subject__c,Start_DateTime__c,End_DateTime__c,Agenda__c,Status__c,Id,Team_Room__c,Team_Room__r.Owner.Name,Team_Room__r.Name FROM Team_Room_Meeting__c where Id in (SELECT Team_Room_Meeting__c FROM GF_Meeting_Occurrence__c where Id = :Id)];
        String teamMeetingname = teamRoomMeetingobj.Name;
        String teamMeetingId = teamRoomMeetingobj.Id;
        String meetingtopic= teamRoomMeetingobj.Subject__c;
        String teamRoomname = teamRoomMeetingobj.Team_Room__r.Name;
        String teamRoomowner= teamRoomMeetingobj.Team_Room__r.Owner.Name;
        Datetime startdate = teamRoomMeetingobj.Start_DateTime__c;
        Datetime enddate = teamRoomMeetingobj.End_DateTime__c;
        String agenda = teamRoomMeetingobj.Agenda__c;
        String Status= teamRoomMeetingobj.Status__c;
        
        List <String> emailIds = new List<String>();
        List <String> additionalEmailIds = new List<String>();
        List<Id> userids = new List<Id>();
        
        // Get the user list of meeting invitees from corresponding parent TeamRoomMeeting object.
        //List<User> meetingInvList = [SELECT Id,Email FROM User where Id in (SELECT User__c FROM GF_Meeting_Invitee__c where Team_Room_Meeting__c = :teamMeetingId)];
        List<GF_Meeting_Invitee__c> meetingInvList = [SELECT User_Email_Address__c FROM GF_Meeting_Invitee__c where Team_Room_Meeting__c = :teamMeetingId];
        for(GF_Meeting_Invitee__c meetingInvObj : meetingInvList){
            emailIds.add(meetingInvObj.User_Email_Address__c);
        }

        // Get the user list of meeting invitees from MeetingOccurence object if there are any additional invitees for that particular occurance.
        //List<User> additionalMeetingInvList = [SELECT Id,Email FROM User where Id in (SELECT User__c FROM GF_Meeting_Invitee__c where GF_Meeting_Occurrence__c = :Id)];
        List<GF_Meeting_Invitee__c> additionalMeetingInvList = [SELECT User_Email_Address__c FROM GF_Meeting_Invitee__c where GF_Meeting_Occurrence__c = :Id];
        for(GF_Meeting_Invitee__c meetingInvObj : additionalMeetingInvList){
            additionalEmailIds.add(meetingInvObj.User_Email_Address__c);
        }
        
        emailIds.addAll(additionalEmailIds);
        
        ClsMailUtility.sendMail(operation, emailids, meetingtopic, meetingDate, meetingOccStartDateTime, meetingOccEndDateTime, '',teamRoomname,teamRoomowner,teamMeetingId,startdate,enddate,agenda,Status);
        success = 'true';
        System.debug('****************Sending mail....success is set to true************************');
        System.debug('*********************success***********************'+success);
        
    }
    
    /**
        This method is used for updating meeting occurances new values to Database.
        @method name: checkMeetingStatus
        @parameter:   none.
        @return :     String.
    **/ 
    
    public String checkMeetingStatus(){
    
        String meetingStatus = '';
        
        GF_Meeting_Occurrence__c meetingOccobj = [SELECT Status__c FROM GF_Meeting_Occurrence__c where Id= :Id];
        
        if(meetingOccobj.Status__c != null){
            meetingStatus = String.valueOf(meetingOccobj.Status__c);
        }
        return meetingStatus;
   }    
}