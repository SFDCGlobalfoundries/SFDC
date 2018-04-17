public class TeamRoomGFCalActivityProvider implements GFCalActivityProvider
{
    String typeName = 'mm';
    String typeLabel = 'Meeting Minutes';
    String backgroundColor = '#FFCC99';

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