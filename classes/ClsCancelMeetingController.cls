/*
Type Name: ClsCancelMeetingController 
Author: Cognizant
Created Date: 29-May-2013
Reason: This class is used for cancelling of TeamRoom Meeting and the respective meeting occurances records.
Change History:
Author: 
Modified Date: 
Reason: 
……..
……..
*/

public class ClsCancelMeetingController {

    public String Id {get; set;}
    public String meetingStatus {get; set;} 
    public String createdByUser {get; set;}     

    public ClsCancelMeetingController(ApexPages.StandardController controller) {

        Id= Apexpages.currentPage().getParameters().get('id');
        system.debug('ID from page referenec '+Id);
        List<Team_Room_Meeting__c> teamRoomMeetingList = [SELECT CreatedById FROM Team_Room_Meeting__c where Id= :Id];
        system.debug('ID from page teamRoomMeetingList  '+teamRoomMeetingList );
        for(Team_Room_Meeting__c teamRoomMeetingObj : teamRoomMeetingList){
            createdByUser = teamRoomMeetingObj.CreatedById;
        }
        
        String loggedInUser = UserInfo.getUserId();
        if(loggedInUser.equalsIgnoreCase(createdByUser)){

        } else {
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'You are not the Owner of the Team Room Meeting. Hence you cannot cancel this meeting.'));
        }
        
        meetingStatus = checkMeetingStatus();
        if(meetingStatus.equalsIgnoreCase(System.Label.MeetingOccurrenceControllerCancelled)){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, System.Label.MeetingCancelledMessage));
        } 

    }
    
    /**
        This method is used for cancelling of TeamRoom Meeting and the respective meeting occurances records.
        @method name: cancelMeeting
        @parameter:   none.
        @return :     PageReference object.
    **/ 

     public Pagereference cancelMeeting() {

          String loggedInUser = UserInfo.getUserId();
          
          if(loggedInUser.equalsIgnoreCase(createdByUser)){
              if(!meetingStatus.equalsIgnoreCase(System.Label.MeetingOccurrenceControllerCancelled)){          
                updateMeetingOccurancesDB();
                sendmail();
              }
          } 
            
          PageReference p = new PageReference('/'+Id);
          p.getParameters().put('nooverride','1');
          return p; 
    }   
    
    /**
        This method is used for updating team room meeting new values to Database.
        @method name: updateMeetingOccurancesDB
        @parameter:   none.
        @return :     none.
    **/ 
    
    public void updateMeetingOccurancesDB(){
    
        List<Team_Room_Meeting__c> finalTeamRoomMeetingList = new List<Team_Room_Meeting__c>();
        List<GF_Meeting_Occurrence__c> finalMeetingOccList = new List<GF_Meeting_Occurrence__c>();

        List<Team_Room_Meeting__c> teamRoomMeetingList = [SELECT Id FROM Team_Room_Meeting__c where Id= :Id];
        for(Team_Room_Meeting__c teamRoomMeetingObj : teamRoomMeetingList){
             teamRoomMeetingObj.Status__c = System.Label.MeetingOccurrenceControllerCancelled;
             finalTeamRoomMeetingList.add(teamRoomMeetingObj);
        }


        List<GF_Meeting_Occurrence__c> meetingOccList = [SELECT Id FROM GF_Meeting_Occurrence__c where Team_Room_Meeting__c = :Id];
        for(GF_Meeting_Occurrence__c meetingOccObj : meetingOccList){
             meetingOccObj.Status__c = System.Label.MeetingOccurrenceControllerCancelled;
             finalMeetingOccList.add(meetingOccObj);
        }

        try{
            if(finalTeamRoomMeetingList!= null && !(finalTeamRoomMeetingList.isEmpty())){
                update finalTeamRoomMeetingList;
            }   
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
        @parameter:   none.
        @return :     none.
    **/ 

    public void sendmail(){

        Team_Room_Meeting__c teammeetingObj = [SELECT Id,Name,Agenda__c,Subject__c,Status__c,Start_DateTime__c,End_DateTime__c,Team_Room__c,Team_Room__r.Name,Team_Room__r.Owner.Name FROM Team_Room_Meeting__c where Id = :Id];
        String meetingDate = String.valueOf(teammeetingObj.Start_DateTime__c);
        String teamMeetingname = teammeetingObj.Name;
        String teamMeetingId = teammeetingObj.Id;
        String teamMeetingSubject = teammeetingObj.Subject__c;
        String teamRoomname  = teammeetingObj.Team_Room__r.Name;
        String teamRoomowner= teammeetingObj.Team_Room__r.Owner.Name;
        Datetime startdate = teammeetingObj.Start_DateTime__c;
        Datetime enddate = teammeetingObj.End_DateTime__c;
        String agenda = teammeetingObj.Agenda__c;
        String Status= teammeetingObj.Status__c;
        String operation = System.Label.TRMeetingCancelOperation;
        
        Messaging.SingleEmailMessage mailHandler = new Messaging.SingleEmailMessage();
        List <String> emailIds = new List<String>();
        //List<User> meetingInvList = [SELECT Email FROM User where Id in (SELECT User__c FROM GF_Meeting_Invitee__c where Team_Room_Meeting__c = :Id)];
        List<GF_Meeting_Invitee__c> meetingInvList=[SELECT User_Email_Address__c FROM GF_Meeting_Invitee__c where Team_Room_Meeting__c = :Id];
        System.debug(meetingInvList);
        //for(User meetingInvObj : meetingInvList){
        for(GF_Meeting_Invitee__c meetingInvObj : meetingInvList){
            //emailIds.add(meetingInvObj.Email);
            emailIds.add(meetingInvObj.User_Email_Address__c);
        }
        ClsMailUtility.sendMail(operation, emailids, teamMeetingSubject, meetingDate, '', '','',teamRoomname,teamRoomowner,teamMeetingId,startdate,enddate,agenda,Status);

    }
    
    /**
        This method is used for updating meeting occurances new values to Database.
        @method name: checkMeetingStatus
        @parameter:   none.
        @return :     String.
    **/ 
    
    public String checkMeetingStatus(){
        
        String meetingStatus = '';
    
        Team_Room_Meeting__c teamroommeetingobj = [SELECT Status__c FROM Team_Room_Meeting__c where Id= :Id];
        
        if(teamroommeetingobj.Status__c != null){
            meetingStatus = String.valueOf(teamroommeetingobj.Status__c);
        }
        
        return meetingStatus;
   }     

}