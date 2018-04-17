/*
Type Name: clsTaskGFCalActivityProvider
Author: Cognizant Technology Solutions
Created Date: 22-5-2013
Reason: Displays the open tasks of the logged in user in the calendar component. 
Change History:
Author: 
Modified Date: 
Reason: 
……..
……..
*/



public class clsTaskGFCalActivityProvider implements GFCalActivityProvider
{
    String typeName = 'ot';
    String typeLabel = 'Open Task';
    String backgroundColor = '#CCFFCC';

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
        The method is used to find all the open tasks of the logged in user.
        
        @method name: findActivities
        @parameter:   String 
        @return :     List<GFCalActivity>
    **/
    public List<GFCalActivity> findActivities(String id)
    {
       List<GFCalActivity> al = new List<GFCalActivity>();
       GFCalActivity a = null;              
                   
       List<GF_Task__c> openTaskList = new List<GF_Task__c>();              
       openTaskList = [SELECT Id, 
                              Name,
                              subject__c, 
                              Due_Date__c                              
                         from GF_Task__c
                        where assignTo__c =: UserInfo.getUserId()
                          and Due_Date__c > TODAY
                          and Status__c <> 'Completed'                        
                     order by Due_Date__c desc 
                        LIMIT 500];                         
      
       if(!openTaskList.isEmpty())
       {
           for(GF_Task__c trm : openTaskList)
           {
               a = new GFCalActivity();
               a.setId(trm.Id);
               a.setType(typeName);
               a.setSubject(trm.subject__c);
               a.setBackgroundColor(backgroundColor);
               a.setActivityDate(trm.Due_Date__c);          
               a.setStartDate(trm.Due_Date__c);
               a.setEndDate(trm.Due_Date__c);
               
               /*
               if(trm.Meeting_Type__c != null)
               {
                   a.put('meetingType',trm.Meeting_Type__c);
               }
               */               
               al.add(a);
           }
       }         
       return al;
    }
    
    /**
        The method is used to get the properties of the open task - color/label for display in the calendar component.
        
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
       //tl.add(new GFCalActivityType('mmtypedaily','meetingType','Daily','Daily Meetings',backgroundColor));
       //tl.add(new GFCalActivityType('mmtypebiweekly','meetingType','Bi-Weekly','Bi-Weekly Meetings',backgroundColor));
       //tl.add(new GFCalActivityType('mmtypemonthly','meetingType','Monthly','Monthly',backgroundColor));
       //tl.add(new GFCalActivityType('mmtypequarterly','meetingType','Quarterly','Quarterly Meetings',backgroundColor));
       //tl.add(new GFCalActivityType('mmtypeAnnual','meetingType','Annual','Annual Meetings',backgroundColor));
       //tl.add(new GFCalActivityType('mmtypenonperiod','meetingType','Non-Periodical','Non Periodical',backgroundColor));

       return tl;
    }
}