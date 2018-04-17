/*
Type Name: clsSendMeetingNotes
Author: Cognizant 
Created Date: 06-June-2013
Reason: This class is used to send meeting notes to the users. 
Change History:
Author: 
Modified Date: 
Reason: 
……..
……..
*/

public class clsSendMeetingNotes {
    
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
        This constructor finds all related users and prepares the wrapper named "wrapper".         
        
        @method name: clsSendMeetingNotes 
        @parameter:   Set the standard controller sObject record details in to the controller.
        @return :     none
    **/
    public clsSendMeetingNotes(ApexPages.StandardController controller) {
        MeetingOccurrenceID = ApexPages.currentPage().getParameters().get('id'); 
        //query to find the meeting occurrence record.
        MeetingOcc = [SELECT id,
                             Meeting_Notes__c,
                             Team_Room_Meeting__c                             
                      FROM   GF_Meeting_Occurrence__c 
                      WHERE  id = :MeetingOccurrenceID];
            
        //query to find the subject of the team room meeting record. 
        TeamRoomMeeting = [SELECT id,
                                 Subject__c
                          FROM   Team_Room_Meeting__c 
                          WHERE  id = :MeetingOcc.Team_Room_Meeting__c];
        
        //generating list of Id of the users from the team room meeting 
        //Inviteee should come from all the team room meeting record.
        /*
        for(GF_Meeting_Invitee__c mi : [SELECT User__c, id FROM GF_Meeting_Invitee__c WHERE Team_Room_Meeting__c = :TeamRoomMeeting.id]){
            InviteesUsersID.add(mi.User__c);  
              
        }
        //generating Wrapper to the users in the VF page "VFSendMeetingNotes"
        if(InviteesUsersID.size() != 0 ){
            wrapper = new List<WrapperclsSendMeetingNotes>();
            InviteesUsers = [SELECT id,Email,name FROM user WHERE id  IN :InviteesUsersID];    
            for(user u: [SELECT id,Email,name FROM user WHERE id  IN :InviteesUsersID])  {
                WrapperclsSendMeetingNotes tempWrap = new WrapperclsSendMeetingNotes ();
                tempWrap.name = u.name;
                tempWrap.Email = u.email;
                tempWrap.count = wrapper.size();
                wrapper.add(tempWrap);   
            } 
            
        }
        */
        wrapper = new List<WrapperclsSendMeetingNotes>();   
        for(GF_Meeting_Invitee__c mi : [SELECT User__r.Name,User_Email_Address__c, id FROM GF_Meeting_Invitee__c WHERE Team_Room_Meeting__c = :TeamRoomMeeting.id]){
            WrapperclsSendMeetingNotes tempWrap = new WrapperclsSendMeetingNotes ();
            tempWrap.name = mi.User__r.Name;
            tempWrap.Email = mi.User_Email_Address__c;
            tempWrap.count = wrapper.size();
            wrapper.add(tempWrap);  
        
        }        
        lstatt=new list<attachment>();
        lstatt.add(new attachment());
        limitAttachment=false;
        
        
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
            else{
                //Error message:
                MeetingOcc.adderror('Please add valid email address');    
            }    
        }
        
    }
    
    public void addmore(){
        if(lstatt.size()<5)
            lstatt.add(new attachment());
        if(lstatt.size()==5)
            limitAttachment=true;
    
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
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        //adding the subject from the team room meeting record
        message.setSubject(TeamRoomMeeting.Subject__c);
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
        //adding the email body from the meeting occurrence record.
        if(MeetingOcc.Meeting_Notes__c == null){
            MeetingOcc.Meeting_Notes__c = '';
        }
        message.setHtmlBody(MeetingOcc.Meeting_Notes__c);
        //adding users in the recipient list.
        for(WrapperclsSendMeetingNotes s: wrapper){
            UserList.add(s.email);    
        }
        
        if(UserList.isEmpty()){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Please enter a valid email id and try again.'));
            return null;
        } else {
            message.setToAddresses(UserList);
            //sending emails
            try{
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { message });
            }catch(Exception e){
                System.debug(e.getMessage());
            }   
            //returning to the meeting occurrence detail page.
            PageReference pfc = new PageReference('/'+MeetingOccurrenceID);
            return pfc;         
        }

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
        This inner class used as the wrapper class.   
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