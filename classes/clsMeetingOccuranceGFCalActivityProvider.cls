/*
Type Name: clsMeetingOccuranceGFCalActivityProvider
Author: Cognizant Technology Solutions
Created Date: 21-5-2013
Reason: Displays the open meeting occurances of the logged in user in calendar component.
Change History:
Author: 
Modified Date: 
Reason: 
……..
…….. 
*/



public class clsMeetingOccuranceGFCalActivityProvider implements GFCalActivityProvider
{
    String typeName = 'mm';
    String typeLabel = 'Open Meeting Occurrence';
    String backgroundColor = '#FFCCCC';

    /*
    public List<GFCalActivity> findActivities(String id)
    {
       List<GFCalActivity> al = new List<GFCalActivity>();
       GFCalActivity a = null;
       
       List<Team_Room_Meeting_Minutes__c> mlist = [SELECT Id, Name, Meeting_Type__c,Meeting_Date__c from Team_Room_Meeting_Minutes__c where Team_Room__c = :id order by Meeting_Date__c desc LIMIT 500];
       for(Team_Room_Meeting_Minutes__c trm:mlist)
       {
           a = new GFCalActivity();
           a.setId(trm.Id);
           a.setType(typeName);
           a.setSubject(trm.Name);
           a.setBackgroundColor(backgroundColor);
           a.setStartDate(trm.Meeting_Date__c);
           if(trm.Meeting_Type__c != null)
           {
               a.put('meetingType',trm.Meeting_Type__c);
           }
          
           al.add(a);
       }
       return al;
    }
    */
    
    
     /**
        The method is used to find all the Open Meeting Occurrences of the logged in user.
        
        @method name: findActivities
        @parameter:   String 
        @return :     List<GFCalActivity>
    **/
    public List<GFCalActivity> findActivities(String id)
    {
       List<GFCalActivity> al = new List<GFCalActivity>();
       GFCalActivity a = null;
       
       List<Team_Room_Member__c> TR = new List<Team_Room_Member__c>();      
       TR = [select Team_Room__c 
               from Team_Room_Member__c 
              where User__c =: UserInfo.getUserId()];
                     
       if(!TR.isEmpty())
       {
           Set<id> TRid = new Set<Id>();
           
           for(Team_Room_Member__c x : TR)
           {
               TRid.add(x.Team_Room__c);    
           }
           //Added for new RecordType check team room record Type if Pre FV2 Teamroom remove 
           
           RecordType r = [select id,Name from RecordType where name='Pre FV2 Teamroom'];
           List<Team_Room__c> teamRoomList = new List<Team_Room__c>();
           teamRoomList = [Select t.id ,RecordTypeId From Team_Room__c t where id in :TRid];
           for(Team_Room__c tc : teamRoomList){
             
               if(tc.RecordTypeId == r.id){
                 TRid.remove(tc.id);
               }  
           }
           
           List<Team_Room_Meeting__c> TRMeeting = new List<Team_Room_Meeting__c>();              
           TRMeeting = [select id 
                          from Team_Room_Meeting__c 
                         where team_room__c in :TRid];
                         
           if(!TRMeeting.isEmpty())
           {                   
               Datetime currentDateTime = System.now();
               
               List<GF_Meeting_Occurrence__c> MOlist = new List<GF_Meeting_Occurrence__c>();              
               MOlist = [SELECT Id, 
                                Name, 
                                Start_Time__c,
                                End_Time__c,
                                Meeting_Date__c,
                                Team_Room_Meeting__r.Subject__c 
                           from GF_Meeting_Occurrence__c
                          where Team_Room_Meeting__c in:TRMeeting
                            and Status__c <> 'Cancelled'
                            and End_Time__c > :currentDateTime
                       order by Meeting_Date__c desc 
                          LIMIT 500];
          
               if(!MOlist.isEmpty())
               {
                   for(GF_Meeting_Occurrence__c trm : MOlist)
                   {
                       a = new GFCalActivity();
                       a.setId(trm.Id);
                       a.setType(typeName);
                       a.setSubject(trm.Team_Room_Meeting__r.Subject__c);
                       a.setBackgroundColor(backgroundColor); 
                       a.setActivityDate(trm.Meeting_Date__c);          
                       a.setStartDate(trm.Start_Time__c.date());
                       a.setEndDate(trm.End_Time__c.date());
                       
                       /*
                       if(trm.Meeting_Type__c != null)
                       {
                           a.put('meetingType',trm.Meeting_Type__c);
                       }
                       */
                       
                       al.add(a);
                   }
               }
            }                
       }                            
       return al;
    }
    
     /**
        The method is used to get the properties of the Open Meeting Occurrence - color/label for display in the calendar component.
        
        @method name: getActivityTypes
        @parameter:   none
        @return :     List<GFCalActivityType>
    **/
    public List<GFCalActivityType> getActivityTypes()
    {
       List<GFCalActivityType> tl = new List<GFCalActivityType>();
       GFCalActivityType type = new GFCalActivityType();
       type.setTypeCode(typeName);
       type.setTypeLabel(typeLabel);
       type.setBackgroundColor(backgroundColor);
       tl.add(type);
              
       //tl.add(new GFCalActivityType('mmtypeweekly','meetingType','Weekly','Weekly Meetings',backgroundColor));
      // tl.add(new GFCalActivityType('mmtypedaily','meetingType','Daily','Daily Meetings',backgroundColor));
      // tl.add(new GFCalActivityType('mmtypebiweekly','meetingType','Bi-Weekly','Bi-Weekly Meetings',backgroundColor));
      // tl.add(new GFCalActivityType('mmtypemonthly','meetingType','Monthly','Monthly',backgroundColor));
      // tl.add(new GFCalActivityType('mmtypequarterly','meetingType','Quarterly','Quarterly Meetings',backgroundColor));
      // tl.add(new GFCalActivityType('mmtypeAnnual','meetingType','Annual','Annual Meetings',backgroundColor));
      // tl.add(new GFCalActivityType('mmtypenonperiod','meetingType','Non-Periodical','Non Periodical',backgroundColor));

       return tl;
    }
}