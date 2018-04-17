/*
Type Name: clsSendMeetingNotesSelectPage 
Author: Cognizant 
Created Date: 05-June-2013
Reason: This class is used to send meeting notes to the users from the team room meeting related list.  
Change History:
Author: 
Modified Date: 
Reason: 
……..
……..
*/


public with sharing class clsSendMeetingNotesSelectPage {
    //variables for the page VFSendMeetingNotesSelectPage
    public String TeamRoomMeetingID;
    public List<GF_Meeting_Occurrence__c> MeetingOccurrenceList {get; set;}
    public List<wrapperMeetingOccurrence> WrappMO {get; set;}
    public Team_Room_Meeting__c trm {get; set;}
    public List<GF_Meeting_Occurrence__c> MeetOcc = new List<GF_Meeting_Occurrence__c>();
    //variables for the page VFSendMeetingNotesList
    public String MeetingOccurrenceID;
    public Team_Room_Meeting__c TeamRoomMeeting {get;set;} 
    public GF_Meeting_Occurrence__c MeetingOcc {get;set;} 
    public List<id> InviteesUsersID = new List<id>();  
    public List<user> InviteesUsers {get;set;}     
    public String NewEmail{get;set;}
    public List<WrapperclsSendMeetingNotes> wrapper {get;set;} 
    public list<attachment> lstAtt{get;set;}
    public boolean limitAttachment{get;set;}
    /**
        This constructor finds all the related meeting occurrence records for the users to select from the list. 
        
        @method name: clsSendMeetingNotes 
        @parameter:   Set the standard controller sObject record details in to the controller.
        @return :     none
    **/
    
    public clsSendMeetingNotesSelectPage(ApexPages.StandardController controller) {
        TeamRoomMeetingID = ApexPages.currentPage().getParameters().get('id');
        trm = [SELECT id,Subject__c,
                      name
               FROM   Team_Room_Meeting__c 
               WHERE  ID = : TeamRoomMeetingID ];
        //wrapper to generate the meeting occurrence records in the VFSendMeetingNotesSelectPage page.
        WrappMO =  new List<wrapperMeetingOccurrence>();
        User currentUser = [Select TimeZoneSidKey from User where id =: USerInfo.getUserId()];
        for(GF_Meeting_Occurrence__c MO: [SELECT id,name,Start_Time__c,End_Time__c,Status__c FROM GF_Meeting_Occurrence__c WHERE Team_Room_Meeting__c = :TeamRoomMeetingID]){
            wrapperMeetingOccurrence tempWrap = new wrapperMeetingOccurrence();
            tempWrap.CheckBox = false;
            Datetime GMTStartDate = MO.Start_Time__c ;
            String strConvertedStartDate = GMTStartDate.format('MM/dd/yyyy h:mm a',currentUser.TimeZoneSidKey);
            tempWrap.meetingoccTime = strConvertedStartDate ;
            Datetime GMTEndDate = MO.End_Time__c ;
            String strConvertedEndDate = GMTEndDate .format('MM/dd/yyyy h:mm a',currentUser.TimeZoneSidKey);
            tempWrap.meetingoccEndTime = strConvertedEndDate ;
            tempWrap.MeetingOcc = MO;            
            WrappMO.add(tempWrap);
        }    
        //initializing the wrapper list in the constructor.
        wrapper = new List<WrapperclsSendMeetingNotes>();
        
        //Adding attachment related initialization
            lstatt=new list<attachment>();
            lstatt.add(new attachment());
            limitAttachment=false;                       
    }
    /**
        This method saves the meeting occurrence record that will be used to send mail to the users.
        
        @method name: saveMeetingOccurrence
        @parameter:   none 
        @return :     pagereference
    **/    
    public pagereference saveMeetingOccurrence(){
        //to find the selected meeting occurrence record from the VF page VFSendMeetingNotesSelectPage
        for(wrapperMeetingOccurrence wmo: WrappMO ){
            if(wmo.CheckBox == true){
                MeetOcc.add(wmo.MeetingOcc);  
                MeetingOcc = [SELECT id,Meeting_Notes__c FROM GF_Meeting_Occurrence__c WHERE id = :wmo.MeetingOcc.ID]; 
            }
        }
        if(MeetOcc.size() <= 0){
            //error message::
            trm.adderror('Please select a Meeting Occurrence');
            return null;
        }
        else{
        addUsersFromTeamRoomMeeting(MeetingOcc); 
        //redirecting to the send email page.       
        PageReference pfc = new PageReference('/apex/VFSendMeetingNotesList?id='+TeamRoomMeetingID );
        return pfc;
        }
        
    }
    
    //Method to add more attachment files
    public void addmore(){
        if(lstatt.size()<5)
            lstatt.add(new attachment());
        if(lstatt.size()==5)
            limitAttachment=true;
    
    }
    
    //methods
    /**
        This method will populate all the users from invitee object who are related to the team room meeting.
        Also, it will populate the meeting notes from the selected meeting occurrence record.
        
        @method name: addUsersFromTeamRoomMeeting
        @parameter:   GF_Meeting_Occurrence__c record
        @return :     none
    **/  
    public void addUsersFromTeamRoomMeeting(GF_Meeting_Occurrence__c GMO){
        //to extract all the users related to the team room meeting
        for(GF_Meeting_Invitee__c mi : [SELECT User__r.Name,User_Email_Address__c, id FROM GF_Meeting_Invitee__c WHERE Team_Room_Meeting__c = :TeamRoomMeetingID]){
            //InviteesUsersID.add(mi.User__c);
            WrapperclsSendMeetingNotes tempWrap = new WrapperclsSendMeetingNotes ();
            tempWrap.name = mi.User__r.Name;
            tempWrap.Email = mi.User_Email_Address__c;
            tempWrap.count = wrapper.size();
            wrapper.add(tempWrap);          
            
            
        }
        //creating wrapper..
        /*
        for(user u: [SELECT id,
                            Email,
                            name 
                     FROM   user 
                     WHERE  id  
                     IN     :InviteesUsersID]){
            WrapperclsSendMeetingNotes tempWrap = new WrapperclsSendMeetingNotes ();
            tempWrap.name = u.name;
            tempWrap.Email = u.email;
            tempWrap.count = wrapper.size();
            wrapper.add(tempWrap);     
        
        } */   
        
    }
     
    /**
        This function adds new users(email id) in the recipient list 
        @method name: addNewUser
        @parameter:   none
        @return :     none
    **/     
    public void addNewUser(){
        //invitees splited by the comma operator are only acceptable. 
        List<String> Invitees = NewEmail.Split(',',0);
        //preparing the wrapper list to print in the VF page VFSendMeetingNotes
        for(String s : Invitees ){
            s=s.trim();
            //calling the function isUserEmailValid to verify the email address. 
            if(isUserEmailValid(s) == TRUE){
                WrapperclsSendMeetingNotes tempWrap = new WrapperclsSendMeetingNotes ();
                tempWrap.name = null;
                tempWrap.Email = s;
                tempWrap.count = wrapper.size();
                wrapper.add(tempWrap); 
                NewEmail = null; 
                     
            }
            //Error message:
            else{
                trm.adderror('Please add valid email address');    
            }    
        }
        
    }
     //Helper methods::::
    
    /**
        This function verifies the email ids of the recipients 
        @method name: isUserEmailValid
        @parameter:   String (to verify the email id)
        @return :     Boolean
    **/  
    public boolean isUserEmailValid(String userEmail) {
        Boolean flag = false;
        if(userEmail != null) {
            String  emailRegex      = '([a-zA-Z0-9_\\-\\.]+)@((\\[a-z]{1,3}\\.[a-z]{1,3}\\.[a-z]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})';
            Pattern emailPattern    = Pattern.compile(emailRegex);
            Matcher emailMatcher    = emailPattern.matcher(userEmail.trim());
            flag                    =  emailMatcher.matches();
        }
        return flag;
    }
    /**
        This function sends email to the recipients 
        @method name: SendEmail
        @parameter:   none
        @return :     pageReference 
    **/
    public pageReference SendEmail(){
        List<String> UserList = new List<String> ();
        String operation = 'SendMeetingNotes';
        
        
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        //adding the subject from the team room meeting record
        message.setSubject(trm.Subject__c);
        //adding the email body from the meeting occurrence record.
        message.setHtmlBody(MeetingOcc.Meeting_Notes__c);
        
        //Create email attachment      
        if(lstatt.size()>0){
        list<Messaging.EmailFileAttachment> lstefa=new list<Messaging.EmailFileAttachment>();
        boolean nullcheck=false;
        for(attachment at:lstatt){
        if(at.body!=null){
        Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
        efa.setFileName(at.name);
        Blob b=at.body;
        efa.setBody(b);
        nullcheck=true;
        lstefa.add(efa);
        system.debug('inside attachment');
        }
        }
        if(nullcheck)
            message.setFileAttachments(lstefa);    
        }
        //adding users in the recipient list.
        for(WrapperclsSendMeetingNotes s: wrapper){
            UserList.add(s.email);    
        }
        
        message.setToAddresses(UserList);
        //sending emails
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { message });
        
        // Commenting out utility class method so that attachments can also be sent with email.
        //ClsMailUtility.sendMail(operation, UserList, MeetingOcc.Meeting_Notes__c,'' , '', '', '');
        
        //returning to the meeting occurrence detail page. 
        PageReference pfc = new PageReference('/'+MeetingOcc.id);
        return pfc;
    }
    /**
        This function removes recipients from the VF page.  
        @method name: removeUser
        @parameter:   none
        @return :     pageReference 
    **/
    
    public pageReference removeUser(){
        integer i;   
        //to get the row count of the wraper list.    
        i = integer.valueof(ApexPages.currentPage().getParameters().get('countRow'));         
        if (wrapper.size()>=0){
            wrapper.remove(i);
            //calling reset wrapper to reset the wrapper count 
            resetWrapper();            
        }    
        
        return null;     
    }
    /**
        This function resets the wrapper count field  
        @method name: resetWrapper
        @parameter:   none
        @return :     none
    **/
    public void resetWrapper(){
        for(integer i=0; i<wrapper.size(); i++){
            wrapper[i].count = i;            
        }
    }
    /**
        This function sets the selected meeting occurrence in the wrapper class  
        @method name: resetWrapper
        @parameter:   none
        @return :     none
    **/
    public void setWrapperMORadio(){
        String b = ApexPages.currentPage().getParameters().get('MeetoccID');   
        for(wrapperMeetingOccurrence wm : WrappMO ){
            if(wm.MeetingOcc.id == b ){
                wm.CheckBox =true;
            }
        }
    }
    
    //Wrapper Classes
    
    /**
        This inner class used as the wrapper class for the VFSendMeetingNotesSelectPage page.   
        @Class name: wrapperMeetingOccurrence
        @parameter:   none
        @return :     none
    **/
    
    public class wrapperMeetingOccurrence{
        public Boolean CheckBox {get; set;}
        public GF_Meeting_Occurrence__c MeetingOcc {get; set;}
        public String meetingoccTime{get;set;}
        public String meetingoccEndTime{get;set;}
        
         
    
    }
    /**
        This inner class used as the wrapper class for VFSendMeetingNotesList page.   
        @Class name: WrapperclsSendMeetingNotes 
        @parameter:   none
        @return :     none
    **/
    public class WrapperclsSendMeetingNotes {
        public string name { get ; set ;}
        public string Email { get ; set ;}
        public integer count { get ; set ;}
        public string UserType { get ; set ;} 
    }
}