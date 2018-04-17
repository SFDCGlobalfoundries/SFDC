/*
 Type Name: ClsTeamRoomMeetingExtension
 Author: Cognizant Technology Solutions
 Created Date: 8-Jun-2013
 Reason: This class is responsible to make the team room meeting with meeting occurences and associated the team room members as meeting invitees.
 Change History:
 Author: 
 Modified Date: 
 Reason: 
 …….. 
 ……..
*/

public without sharing class ClsTeamRoomMeetingExtension
{
 
    /**
    
    Variable Declaration
    
    */
    public String recurrValue{get;set;}
    public String dailyrecurrValue{get;set;}
    public String monthlyrecurrValue{get;set;}
    public String yearlyrecurrValue{get;set;}
    public String recurrItems{get;set;}
    public String recurrPicklist{get;set;}
    public String meetingSubject{get;set;}
    public String sampleDateField { get;set;}
    public String sampleEndDateField { get;set;}
    public String startTime{get;set;}
    public String endTime{get;set;}
    public String day{get;set;}
    public String showPrivilegemessage{get;set;}
    public Boolean showTRMPrivilegeSection{get;set;}
    public Boolean showTRMEditSection{get;set;} 
    public Boolean recurrenceCheck{get;set;}
    public Boolean showrecurrPanel{get;set;}
    public Boolean dailyRecurrence{get;set;}
    public Boolean weeklyRecurrence{get;set;}
    public Boolean monthlyRecurrence{get;set;}
    public Boolean yearlyRecurrence{get;set;}
    public Boolean showEndDate{get;set;}
    public Boolean sundaycheck{get;set;}
    public Boolean mondaycheck{get;set;}
    public Boolean tuesdaycheck{get;set;}
    public Boolean wednesdaycheck{get;set;}
    public Boolean thursdaycheck{get;set;}
    public Boolean fridaycheck{get;set;}
    public Boolean saturdaycheck{get;set;}
    public Integer numberofmonths{get;set;}
    public Set<String> originalvalues = new Set<String>();
    public Set<string> leftvalues = new Set<string>();
    public Set<string> rightvalues = new Set<string>();
    public list<String> dayList = new List<String>();
    public list<String> leftselected{get;set;}
    public list<String> rightselected{get;set;}
    public list<Team_Room_Member__c> memberList = new list<Team_Room_Member__c>();
    public list<GF_Meeting_Invitee__c > inviteeList = new list<GF_Meeting_Invitee__c >();
    public list<String> selectedTRMwithAcct = new list<String>();
    public map<String,Id> selectedmembersMap = new map<String,Id>();
    public String sunday,monday,tuesday,wednesday,thursday,friday,saturday,sthr,stmin,endhr,endmin,sec,strdate,enddate,startdatetimeStamp,enddatetimeStamp,meetingocctimeStamp,acctwithMember,strmonthDate;
    public Integer monthday;
    public Date monthDate;
    public Date meetingStartDate,meetingEndDate;
    public Boolean recordEdit;
    public String selectedDayString;

    
    Team_Room_Meeting__c teamroommeetingObj = new Team_Room_Meeting__c();
    GF_Meeting_Occurrence__c meetingoccurObj = new GF_Meeting_Occurrence__c();
    GF_Meeting_Invitee__c inviteeObj = new GF_Meeting_Invitee__c();
    public list<GF_Meeting_Occurrence__c>meetingoccurList=new list<GF_Meeting_Occurrence__c>();
    Team_Room_Meeting__c editteamroommeetingObj = new Team_Room_Meeting__c();
    public list<GF_Meeting_Occurrence__c>editmeetingoccurList=new list<GF_Meeting_Occurrence__c>();
    public list<GF_Meeting_Invitee__c > editinviteeList = new list<GF_Meeting_Invitee__c >();
    public set<Id >inviteeIdsSet = new set<Id>();
    public Set<String> oldvalues = new Set<String>();
    
    
    ApexPages.standardController cancelController = null;
    
    /**
        This method helps to make the list of team room member with respect to team room id and check the user profile.
        
        @method name: ClsTeamRoomMeetingExtension
        @return : none
    */
    public ClsTeamRoomMeetingExtension(ApexPages.StandardController controller) 
    {
          this.teamroommeetingObj = (Team_Room_Meeting__c)controller.getRecord();
          String teamRoomId = ApexPages.CurrentPage().getParameters().get('trid');
          String teamRoomMeetingId = ApexPages.CurrentPage().getParameters().get('id');
          showPrivilegemessage = System.Label.TRM_Privilege_Message;
          if(teamRoomId !=null){
              teamroommeetingObj.Team_Room__c = teamRoomId;
              showEndDate = true;
              showTRMPrivilegeSection = false;
                  showTRMEditSection = true;
          }
          else if(teamRoomMeetingId !=null)
          {
              
              teamRoomId = teamroommeetingObj.Team_Room__c;
              showEndDate = false;
              recordEdit = true;
              editteamRoomMeetingObj = [Select t.Subject__c, 
                                        t.Start_DateTime__c, 
                                        t.End_DateTime__c, 
                                        t.Description__c,
                                        t.DailyRecurrence__c,
                                        t.MonthlyRecurrence__c,
                                        t.WeeklyRecurrence__c  
                                        From Team_Room_Meeting__c t
                                        where t.Id =: teamroommeetingObj.Id];
                                        
              editmeetingoccurList = [Select Id 
                                             from GF_Meeting_Occurrence__c 
                                             where Team_Room_Meeting__c =: teamroommeetingObj.Id];
                                     
                                     
              editinviteeList = [Select g.User__c,
                                        g.Id,
                                        g.User__r.Name,
                                        g.User__r.Profile.Name,
                                        g.User__r.Contact.Account.Name 
                                        from GF_Meeting_Invitee__c g
                                        where g.Team_Room_Meeting__c =: teamroommeetingObj.Id]; 
                                        
              if(editinviteeList.size()>0)
              {
                  for(GF_Meeting_Invitee__c inviteeObj : editinviteeList)
                  {
                      inviteeIdsSet.add(inviteeObj.User__c);
                  }
              }
             
               
              if(editteamRoomMeetingObj.Start_DateTime__c < System.now())  
              {                    
                  showTRMPrivilegeSection = true;
                  showTRMEditSection = false;
              }
              else
              {
                  showTRMPrivilegeSection = false;
                  showTRMEditSection = true;
              }                               
                    
              
              meetingSubject = editteamRoomMeetingObj.Subject__c;
              //if(editteamRoomMeetingObj.Start_DateTime__c != NULL && editteamRoomMeetingObj.End_DateTime__c != NULL)
              {                          
                  sampleDateField = editteamRoomMeetingObj.Start_DateTime__c.format('MM/dd/yyyy');
                  sampleEndDateField = editteamRoomMeetingObj.End_DateTime__c.format('MM/dd/yyyy');
                  if(editteamRoomMeetingObj.Start_DateTime__c.hour() >=0 && editteamRoomMeetingObj.Start_DateTime__c.hour() <=9 && editteamRoomMeetingObj.Start_DateTime__c.minute() == 0)
                      startTime = '0'+editteamRoomMeetingObj.Start_DateTime__c.hour() + ':'+ editteamRoomMeetingObj.Start_DateTime__c.minute()+'0';
                  else if (editteamRoomMeetingObj.Start_DateTime__c.hour() >=0 && editteamRoomMeetingObj.Start_DateTime__c.hour() <=9 && editteamRoomMeetingObj.Start_DateTime__c.minute() != 0)
                      startTime = '0'+editteamRoomMeetingObj.Start_DateTime__c.hour() + ':'+ editteamRoomMeetingObj.Start_DateTime__c.minute();
                  else if (editteamRoomMeetingObj.Start_DateTime__c.hour() >9 && editteamRoomMeetingObj.Start_DateTime__c.minute() == 0)
                      startTime = editteamRoomMeetingObj.Start_DateTime__c.hour() + ':'+ editteamRoomMeetingObj.Start_DateTime__c.minute()+'0';
                  else
                      startTime = editteamRoomMeetingObj.Start_DateTime__c.hour() + ':'+ editteamRoomMeetingObj.Start_DateTime__c.minute();    
                   
                      
                      
                  if(editteamRoomMeetingObj.End_DateTime__c.hour() >=0 && editteamRoomMeetingObj.End_DateTime__c.hour() <=9 && editteamRoomMeetingObj.End_DateTime__c.minute() == 0)
                      endTime = '0'+editteamRoomMeetingObj.End_DateTime__c.hour() + ':'+ editteamRoomMeetingObj.End_DateTime__c.minute()+'0';
                  else if (editteamRoomMeetingObj.End_DateTime__c.hour() >=0 && editteamRoomMeetingObj.End_DateTime__c.hour() <=9 && editteamRoomMeetingObj.End_DateTime__c.minute() != 0)
                      endTime = '0'+editteamRoomMeetingObj.End_DateTime__c.hour() + ':'+ editteamRoomMeetingObj.End_DateTime__c.minute();
                  else if (editteamRoomMeetingObj.End_DateTime__c.hour() >9 && editteamRoomMeetingObj.End_DateTime__c.minute() == 0)
                      endTime = editteamRoomMeetingObj.End_DateTime__c.hour() + ':'+ editteamRoomMeetingObj.End_DateTime__c.minute()+'0';
                  else
                      endTime = editteamRoomMeetingObj.End_DateTime__c.hour() + ':'+ editteamRoomMeetingObj.End_DateTime__c.minute(); 
                  
                  
                  System.debug('startTime-------------->'+startTime);
                  System.debug('endTime-------------->'+endTime);
                  
              }
              
              
          }
          
          
          
          cancelController = controller;
          
         
          if(inviteeIdsSet.size()>0)
          {
              memberList = [Select t.User__r.Name,
                               t.User__c,
                               t.User__r.Id,
                               t.User__r.Profile.Name,
                               t.Id, 
                               t.User__r.Contact.Account.Name
                               From Team_Room_Member__c t where t.Team_Room__c =: teamRoomId
                               and t.User__c !=: inviteeIdsSet];
                               
                               
             for(GF_Meeting_Invitee__c inviteeObj : editinviteeList)
             {
                 //Modified by Sunil Arora for Case # 10023 to add Overage Portal profiles in the list
                 if((inviteeObj.User__r.Profile.Name == System.Label.CustomerPortalAdmin) || (inviteeObj.User__r.Profile.Name ==System.Label.CustomerPortalProfile) || 
                 	(inviteeObj.User__r.Profile.Name ==System.Label.OverageCustomerPortalAdmin)|| (inviteeObj.User__r.Profile.Name ==System.Label.OverageCustomerPortalProfile)||
                 	(inviteeObj.User__r.Profile.Name ==System.Label.OverageSupplierPortalProfile)|| (inviteeObj.User__r.Profile.Name ==System.Label.OverageSupplierPortalAdmin)||
                 	(inviteeObj.User__r.Profile.Name ==System.Label.OverageResellerPortalProfile)|| (inviteeObj.User__r.Profile.Name ==System.Label.OverageResellerPortalAdmin)||
                 	(inviteeObj.User__r.Profile.Name ==System.Label.OverageEnablementPartnerPortalProfile)|| (inviteeObj.User__r.Profile.Name ==System.Label.OverageEnablementPartnerPortalAdmin)||
                    (inviteeObj.User__r.Profile.Name == System.Label.EnablementPartnerPortalAdmin) || (inviteeObj.User__r.Profile.Name == System.Label.EnablementPartnerPortalProfile) ||
                    (inviteeObj.User__r.Profile.Name == System.Label.ResellerPortalAdmin) ||(inviteeObj.User__r.Profile.Name == System.Label.ResellerPortalProfile) ||
                    (inviteeObj.User__r.Profile.Name == System.Label.SupplierPortalAdmin) || (inviteeObj.User__r.Profile.Name == System.Label.SupplierPortalProfile)) 
                 
                    acctwithMember = inviteeObj.User__r.Contact.Account.Name + '-' + inviteeObj.User__r.Name;   
                 else
                     acctwithMember = inviteeObj.User__r.Name +'-' + System.Label.Internal_Label;  
                 oldvalues.add(acctwithMember);
                 selectedmembersMap.put(acctwithMember,inviteeObj.User__r.Id);
                 rightvalues.addall(oldvalues);
                 
             }
          }
          else
          {
               memberList = [Select t.User__r.Name,
                               t.User__c,
                               t.User__r.Id,
                               t.User__r.Profile.Name,
                               t.Id, 
                               t.User__r.Contact.Account.Name
                               From Team_Room_Member__c t where t.Team_Room__c =: teamRoomId];
                               
         }
          
          
          if(memberList.size()>0)
          {
             for(Team_Room_Member__c trmObj : memberList)
             {
                 if((trmObj.User__r.Profile.Name == System.Label.CustomerPortalAdmin) || (trmObj.User__r.Profile.Name ==System.Label.CustomerPortalProfile)||
                    (trmObj.User__r.Profile.Name == System.Label.EnablementPartnerPortalAdmin) || (trmObj.User__r.Profile.Name == System.Label.EnablementPartnerPortalProfile) ||
                    (trmObj.User__r.Profile.Name == System.Label.ResellerPortalAdmin) ||(trmObj.User__r.Profile.Name == System.Label.ResellerPortalProfile) ||
                    (trmObj.User__r.Profile.Name == System.Label.SupplierPortalAdmin) || (trmObj.User__r.Profile.Name == System.Label.SupplierPortalProfile))
                        acctwithMember = trmObj.User__r.Contact.Account.Name + '-' + trmObj.User__r.Name; 
                 else
                        acctwithMember = trmObj.User__r.Name +'-' + System.Label.Internal_Label; 
                
                    
                 originalvalues.add(acctwithMember);
                 selectedmembersMap.put(acctwithMember,trmObj.User__r.Id);
                 
             }
            
          }
              leftselected = new List<String>();
              rightselected = new List<String>();
              leftvalues.addAll(originalValues);
              
              if(editteamRoomMeetingObj.DailyRecurrence__c != NULL)
              {
                  if(editteamRoomMeetingObj.DailyRecurrence__c == 'Daily')
                  {
                      recurrenceCheck = true;
                      showrecurrPanel = true;
                      dailyRecurrence = true;
                      recurrValue = editteamRoomMeetingObj.DailyRecurrence__c; 
                  } 
                  else
                  {
                      recurrenceCheck = true;
                      showrecurrPanel = true;
                      dailyRecurrence = true;
                      recurrValue = 'Daily';
                      dailyrecurrValue = 'everyweekday';
                  }  
              }
              else if (editteamRoomMeetingObj.MonthlyRecurrence__c != NULL)
              {
                  recurrenceCheck = true;
                  showrecurrPanel = true;
                  recurrValue = 'Monthly';
                  monthlyRecurrence = true;
                  monthlyrecurrValue = 'onDay';
                  recurrPicklist = editteamRoomMeetingObj.MonthlyRecurrence__c;
              }
              else if (editteamRoomMeetingObj.WeeklyRecurrence__c != NULL)
              {
                  recurrenceCheck = true;
                  showrecurrPanel = true;
                  recurrValue = 'Weekly';
                  weeklyRecurrence = true;
                  String selectedweekDay = editteamRoomMeetingObj.WeeklyRecurrence__c;
                  if(selectedweekDay.contains('Sunday'))
                  {
                      sundaycheck = true;
                      sunday = 'Sunday';
                  }
                  if(selectedweekDay.contains('Monday'))
                  {
                       mondaycheck = true;
                       monday = 'Monday';
                  }
                  if(selectedweekDay.contains('Tuesday'))
                  {
                      tuesdaycheck = true;
                      tuesday = 'Tuesday';
                  }
                  if(selectedweekDay.contains('Wednesday'))
                  {
                      wednesdaycheck = true;
                      wednesday = 'Wednesday';
                  }
                  if(selectedweekDay.contains('Thursday'))
                  {
                      thursdaycheck = true;
                      thursday = 'Thursday';
                  }
                  if(selectedweekDay.contains('Friday'))
                  {
                      fridaycheck = true;
                      friday = 'Friday';
                  }
                  if(selectedweekDay.contains('Saturday'))
                  {
                      saturdaycheck = true;
                      saturday = 'Saturday';
                  }
              }
              
    }
    
    /**
        This method is used to make the picklist values(day numbers) for months.
        
        @method name: getItems
        @return : day numbers
    */
    public List<SelectOption> getItems() 
    {
            List<SelectOption> options = new List<SelectOption>();
            for(Integer i = 1;i<=28;i++)
            {
                String s = string.valueof(i);
                options.add(new SelectOption(s,s));
            }
           return options;
    }
    
    /**
        This method is used to make the picklist values(time stamps) for time stamps.
        
        @method name: gettimeStamps
        @return : time stamps
    */
     
      public List<SelectOption> gettimeStamps() 
      {
           List<SelectOption> options = new List<SelectOption>();
           options.add(new SelectOption('00:00','12:00 AM'));
           options.add(new SelectOption('00:30','12:30 AM'));
           options.add(new SelectOption('01:00','1:00 AM'));
           options.add(new SelectOption('01:30','1:30 AM'));
           options.add(new SelectOption('02:00','2:00 AM'));
           options.add(new SelectOption('02:30','2:30 AM'));
           options.add(new SelectOption('03:00','3:00 AM'));
           options.add(new SelectOption('03:30','3:30 AM'));
           options.add(new SelectOption('04:00','4:00 AM'));
           options.add(new SelectOption('04:30','4:30 AM'));
           options.add(new SelectOption('05:00','5:00 AM'));
           options.add(new SelectOption('05:30','5:30 AM'));
           options.add(new SelectOption('06:00','6:00 AM'));
           options.add(new SelectOption('06:30','6:30 AM'));
           options.add(new SelectOption('07:00','7:00 AM'));
           options.add(new SelectOption('07:30','7:30 AM'));
           options.add(new SelectOption('08:00','8:00 AM'));
           options.add(new SelectOption('08:30','8:30 AM'));
           options.add(new SelectOption('09:00','9:00 AM'));
           options.add(new SelectOption('09:30','9:30 AM'));
           options.add(new SelectOption('10:00','10:00 AM'));
           options.add(new SelectOption('10:30','10:30 AM'));
           options.add(new SelectOption('11:00','11:00 AM'));
           options.add(new SelectOption('11:30','11:30 AM'));
           options.add(new SelectOption('12:00','12:00 PM'));
           options.add(new SelectOption('12:30','12:30 PM'));
           options.add(new SelectOption('13:00','1:00 PM'));
           options.add(new SelectOption('13:30','1:30 PM'));
           options.add(new SelectOption('14:00','2:00 PM'));
           options.add(new SelectOption('14:30','2:30 PM'));
           options.add(new SelectOption('15:00','3:00 PM'));
           options.add(new SelectOption('15:30','3:30 PM'));
           options.add(new SelectOption('16:00','4:00 PM'));
           options.add(new SelectOption('16:30','4:30 PM'));
           options.add(new SelectOption('17:00','5:00 PM'));
           options.add(new SelectOption('17:30','5:30 PM'));
           options.add(new SelectOption('18:00','6:00 PM'));
           options.add(new SelectOption('18:30','6:30 PM'));
           options.add(new SelectOption('19:00','7:00 PM'));
           options.add(new SelectOption('19:30','7:30 PM'));
           options.add(new SelectOption('20:00','8:00 PM'));
           options.add(new SelectOption('20:30','8:30 PM'));
           options.add(new SelectOption('21:00','9:00 PM'));
           options.add(new SelectOption('21:30','9:30 PM'));
           options.add(new SelectOption('22:00','10:00 PM'));
           options.add(new SelectOption('22:30','10:30 PM'));
           options.add(new SelectOption('23:00','11:00 PM'));
           options.add(new SelectOption('23:30','11:30 PM'));
               
           
           return options;
      }
      /**
        This method controls the visibility recurrence section.
        
        @method name: showrecurrSection
        @return : none
     */
      public void showrecurrSection()
      {
         if(recurrenceCheck == true)
         {
             showrecurrPanel = true;
             showEndDate = false;
         }
         else
         {
             showrecurrPanel = false; 
             showEndDate = true;
             sampleEndDateField = NULL;
             //sampleEndDateField = sampleDateField;
         }
             
         dailyRecurrence = false;
         weeklyRecurrence= false;
         monthlyRecurrence= false;
         yearlyRecurrence= false; 
         recurrValue=NULL; 
         dailyrecurrValue = NULL;
         monthlyrecurrValue = NULL;     
      }
      /**
        This method controls the  recurrence type [daily/weekly/monthly] section.
        
        @method name: recurrSelection
        @return : none
     */
      public void recurrSelection()
      {
                
            
            if(recurrValue == 'Daily')
            {
                   
                    dailyRecurrence = true;
                    weeklyRecurrence= false;
                    monthlyRecurrence= false;
                    yearlyRecurrence= false;
            }
            if(recurrValue == 'Weekly')
            {
                    
                    dailyRecurrence = false;
                    weeklyRecurrence= true;
                    monthlyRecurrence= false;
                    yearlyRecurrence= false;
            }
            if(recurrValue == 'Monthly')
            {
                    dailyRecurrence = false;
                    weeklyRecurrence= false;
                    monthlyRecurrence= true;
                    yearlyRecurrence= false;
            }
            if(recurrValue == 'Yearly')
            {
                    dailyRecurrence = false;
                    weeklyRecurrence= false;
                    monthlyRecurrence= false;
                    yearlyRecurrence= true;
            }
       }
       
       /**
            This method holds the value of day when user selects Sunday checkbox.
        
            @method name: sundaycall
            @return : null
       */
       public pagereference sundaycall()
       {
              if(day == 'Sunday' && sundaycheck == true)
                 sunday = day;
              else
                 sunday = ''; 
              
              
             return null;
       }
       
       /**
            This method holds the value of day when user selects Monday checkbox.
        
            @method name: mondaycall
            @return : null
       */
       public pagereference mondaycall()
       {
             if(day == 'Monday' && mondaycheck == true)
                 monday = day;
             else
                 monday = ''; 
                 
            
             return null;
       }
       
       /**
            This method holds the value of day when user selects Tuesday checkbox.
        
            @method name: tuesdaycall
            @return : null
       */
       public pagereference tuesdaycall()
       {
             if(day == 'Tuesday' && tuesdaycheck == true)
                 tuesday = day;
             else
                 tuesday = '';
                 
            
             return null;
       }
       
       /**
            This method holds the value of day when user selects Wednesday checkbox.
        
            @method name: wednesdaycall
            @return : null
       */
       public pagereference wednesdaycall()
       {
              if(day == 'Wednesday' && wednesdaycheck == true)
                 wednesday = day;
             else
                 wednesday = '';
                 
            
             return null;
       }
       
       /**
            This method holds the value of day when user selects Thursday checkbox.
        
            @method name: thursdaycall
            @return : null
       */
       public pagereference thursdaycall()
       {
              if(day == 'Thursday' && thursdaycheck == true)
                 thursday = day;
              else
                  thursday = '';
                   
                 
             return null;
       }
       
       /**
            This method holds the value of day when user selects Friday checkbox.
        
            @method name: fridaycall
            @return : null
      */
       public pagereference fridaycall()
       {
              if(day == 'Friday' && fridaycheck == true)
                 friday= day;
              else
                 friday= ''; 
                 
                 
             return null;
        }
        
        /**
            This method holds the value of day when user selects Saturday checkbox.
        
            @method name: saturdaycall
            @return : null
        */
        public pagereference saturdaycall()
        {
              if(day == 'Saturday' && saturdaycheck == true)
                 saturday = day;
              else 
                  saturday = '';
                  
                  
             return null;
         }
         
        /**
            This method is used to select the values from the multi select picklist.
        
            @method name: selectclick
            @return : null
        */
        public PageReference selectclick()
        {
            rightselected.clear();
            for(String s : leftselected)
            {
                leftvalues.remove(s);
                rightvalues.add(s);
            }
            return null;
        }
        /**
            This method is used to unselect the values from the multi select picklist.
        
            @method name: unselectclick
            @return : null
        */
        public PageReference unselectclick()
        {
            leftselected.clear();
            for(String s : rightselected)
            {
                rightvalues.remove(s);
                leftvalues.add(s);
            }
            return null;
        }
 
        /**
            This method is used to take the unselected values from the multi select picklist.
        
            @method name: getunSelectedValues
            @return : null
        */
        public List<SelectOption> getunSelectedValues()
        {
            List<SelectOption> options = new List<SelectOption>();
            List<string> tempList = new List<String>();
            tempList.addAll(leftvalues);
            tempList.sort();
            for(string s : tempList)
                options.add(new SelectOption(s,s));
            return options;
        }
    
        /**
            This method is used to take the user selected values from the multi select picklist.
        
            @method name: getSelectedValues
            @return : null
        */
        public List<SelectOption> getSelectedValues()
        {
            selectedTRMwithAcct.clear();
            List<SelectOption> options1 = new List<SelectOption>();
            List<string> tempList = new List<String>();
            tempList.addAll(rightvalues);
            tempList.sort();
            for(String s : tempList)
            {
                selectedTRMwithAcct.add(s);
                options1.add(new SelectOption(s,s));
            }
                
            return options1;
        }
        
        /**
            This method is used to create the team room meeting with meeting occurences and associated the 
            team room members as meeting invitees and controls the exceptions. 
        
            @method name: saveTeamRoomMeeting
        
        */
         public pagereference saveTeamRoomMeeting()
         {
             
              if(!(String.isBlank(sampleDateField))) 
              {
                  String[] stringStartDate = sampleDateField.split('/');
                  Integer sm =  Integer.valueOf(stringStartDate[0]);
                  Integer sd = Integer.valueOf(stringStartDate[1]);
                  Integer sy = Integer.valueOf(stringStartDate[2]);
                  meetingStartDate = date.newInstance(sy,sm,sd);
              }
              if(!(String.isBlank(sampleEndDateField)))
              {
                  String[] stringEndDate = sampleEndDateField.split('/');
                  Integer em =  Integer.valueOf(stringEndDate [0]);
                  Integer ed = Integer.valueOf(stringEndDate [1]);
                  Integer ey = Integer.valueOf(stringEndDate [2]);
                  meetingEndDate = date.newInstance(ey,em,ed);
              }
             
             dayList.add(monday);             
             dayList.add(tuesday);            
             dayList.add(wednesday);             
             dayList.add(thursday);            
             dayList.add(friday);             
             dayList.add(saturday);             
             dayList.add(sunday);
             
             if(String.isBlank(sampleDateField))
             {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,System.Label.TRM_Check_StartDate));
             }
             if((String.isBlank(sampleEndDateField)) && recurrenceCheck == true)
             {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,System.Label.TRM_Set_EndDate));
             }
             else if(meetingStartDate < date.today())
             {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,System.Label.TRM_Comp_StartDate));
             }
             
             else if (meetingStartDate > meetingEndDate )
             {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,System.Label.TRM_Check_EndDate));
             }
             else if (startTime >= endTime)
             {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,System.Label.TRM_Comp_EndDate));
             }
              else if (String.isBlank(meetingSubject)) //(meetingSubject == NULL)
             {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,System.Label.TRM_Check_Subject));
             }
             else if (recurrenceCheck == true && recurrValue == NULL)
             {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,System.Label.TRM_Check_RecurrenceCheckbox));
             }
             else if (recurrValue != NULL &&  sampleEndDateField == NULL)
             {
                  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,System.Label.TRM_Check_SetEndDate));
             }
             else if (recurrValue == 'Weekly' && sundaycheck == false && mondaycheck == false && tuesdaycheck == false && wednesdaycheck == false && thursdaycheck == false && fridaycheck == false && saturdaycheck == false)
             {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,System.Label.TRM_Check_WeeklyOccurrence));
             }
             
             else if (recurrValue == 'Monthly' && monthlyrecurrValue == NULL)
             {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, System.Label.TRM_Check_MonthlyOccurrence)); 
             }
             /*else if (recordEdit == true && recurrenceCheck == false && meetingStartDate != meetingEndDate)
             {
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,System.Label.TRM_Check_EndDate_Recurrence)); 
             } */
             else if (selectedTRMwithAcct.size()==0)
             {
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,System.Label.TRM_Check_TeamRoomMember)); 
             }
             else
             {
                 sthr = startTime.substringbefore(':');
                 stmin= startTime.substringafter(':');
                 endhr= endTime.substringbefore(':');
                 endmin= endTime.substringafter(':');
                 sec = '00';
                 strdate = String.valueof(meetingStartDate);
                 enddate = String.valueof(meetingEndDate );
                 if(recurrPickList!=NULL)
                 {
                      monthday = Integer.valueof(recurrPickList.trim());
                      monthDate= Date.newInstance(meetingStartDate.year(),meetingStartDate.month(),monthday );
                      strmonthDate = String.valueof(monthDate);
                 }
                 if(meetingEndDate == NULL)
                     enddate = strdate;
                 
                 startdatetimeStamp = strdate  + ' ' +sthr + ':' + stmin + ':' + sec ;
                 enddatetimeStamp = enddate + ' ' +endhr + ':' + endmin + ':' + sec ;
                 meetingocctimeStamp = strdate  + ' ' +endhr + ':' + endmin + ':' + sec ;
                 String monthlystarttimestamp = strmonthDate + ' ' +sthr + ':' + stmin + ':' + sec ;
                 String monthlyendtimestamp = strmonthDate + ' '+endhr + ':' + endmin + ':' + sec ;
                 teamroommeetingObj.Start_DateTime__c = Datetime.valueof(startdatetimeStamp) ;
                 teamroommeetingObj.End_DateTime__c = Datetime.valueof(enddatetimeStamp);
                 teamroommeetingObj.Subject__c = meetingSubject;
                 teamroommeetingObj.Status__c = 'Open';
                 teamroommeetingObj.Type__c = 'Meeting';
                 teamroommeetingObj.DailyRecurrence__c = NULL;
                 teamroommeetingObj.MonthlyRecurrence__c = NULL;
                 teamroommeetingObj.WeeklyRecurrence__c = '';
                 if(recurrValue == 'Daily' && dailyrecurrValue == 'everyweekday')
                 {
                     teamroommeetingObj.DailyRecurrence__c = 'everyweekday';
                     teamroommeetingObj.MonthlyRecurrence__c = NULL;
                     teamroommeetingObj.WeeklyRecurrence__c = '';
                 }
                 else if(recurrValue == 'Daily' && dailyrecurrValue == NULL)
                 {
                     teamroommeetingObj.DailyRecurrence__c = 'Daily';
                     teamroommeetingObj.MonthlyRecurrence__c = NULL;
                     teamroommeetingObj.WeeklyRecurrence__c = '';
                 }
                 else if(recurrValue == 'Monthly' && monthlyrecurrValue != NULL)
                 {
                     teamroommeetingObj.MonthlyRecurrence__c = recurrPicklist;
                     teamroommeetingObj.DailyRecurrence__c = NULL;
                     teamroommeetingObj.WeeklyRecurrence__c = '';
                 }
                 else if(recurrValue == 'Weekly')
                 {
                    for(String selectedDay : dayList)
                    {
                        if(selectedDay != NULL)
                        {
                            if(selectedDayString != NULL)
                                selectedDayString = selectedDayString + selectedDay + ';';
                            else
                                selectedDayString = selectedDay + ';';
                        }
                   }
                   teamroommeetingObj.WeeklyRecurrence__c = selectedDayString;
                   teamroommeetingObj.DailyRecurrence__c = NULL;
                   teamroommeetingObj.MonthlyRecurrence__c = NULL;
                }

             
                 try
                 {
                     upsert teamroommeetingObj;
                     if(editmeetingoccurList.size()>0)
                     {
                         delete editmeetingoccurList;
                     }
                     if(editInviteeList.size()>0)
                     {
                         delete editInviteeList;
                     }
                  
                 }catch(Exception ex)
                 {
                     System.debug(ex);
                 }
                 integer intDays =  teamroommeetingObj.Start_DateTime__c.Date().daysBetween(teamroommeetingObj.End_DateTime__c.Date());
                 integer intMonths = teamroommeetingObj.Start_DateTime__c.Date().monthsBetween(teamroommeetingObj.End_DateTime__c.Date()); 
                 
                 if(recurrValue == 'Daily' && dailyrecurrValue == 'everyweekday')
                 {
                     for(integer count = 0;count<(intDays+1);count++)
                     {
                       meetingoccurObj = new GF_Meeting_Occurrence__c();
                       if((teamroommeetingObj.Start_DateTime__c.addDays(count).format('EEEE')!='Saturday')&&(teamroommeetingObj.Start_DateTime__c.addDays(count).format('EEEE')!='Sunday'))
                       {
                           meetingoccurObj.Team_Room_Meeting__c = teamroommeetingObj.Id;
                           meetingoccurObj.Start_Time__c = teamroommeetingObj.Start_DateTime__c.addDays(count); 
                           meetingoccurObj.End_Time__c = Datetime.valueof(meetingocctimeStamp).addDays(count);
                           meetingoccurObj.Status__c = 'Open';
                           meetingoccurObj.Agenda__c  = teamroommeetingObj.Agenda__c;
                           meetingoccurList.add(meetingoccurObj);
                       } 
                     }
                 }
                else if(recurrValue == 'Daily' && dailyrecurrValue == NULL)
                {
                     for(integer count = 0;count<(intDays+1);count++)
                     {
                       meetingoccurObj = new GF_Meeting_Occurrence__c();
                       meetingoccurObj.Team_Room_Meeting__c = teamroommeetingObj.Id;
                       meetingoccurObj.Start_Time__c = teamroommeetingObj.Start_DateTime__c.addDays(count); 
                       meetingoccurObj.End_Time__c = Datetime.valueof(meetingocctimeStamp).addDays(count);
                       meetingoccurObj.Status__c = 'Open';
                       meetingoccurObj.Agenda__c  = teamroommeetingObj.Agenda__c;
                       meetingoccurList.add(meetingoccurObj);
                    }
                     
                }
                else if(recurrValue == 'Weekly')
                {
                    
                     Integer numberofweeks = (intDays+1)/7;
                     for(Integer count = 0;count<(intDays+1);count++)
                     {
                        meetingoccurObj = new GF_Meeting_Occurrence__c();  
                        for(String selectedDate : dayList)
                        {
                            if(teamroommeetingObj.Start_DateTime__c.addDays(count).format('EEEE')== selectedDate)
                            {
                                meetingoccurObj.Team_Room_Meeting__c = teamroommeetingObj.Id;
                                if(teamroommeetingObj.Start_DateTime__c.addDays(count)>=Datetime.valueof(startdatetimeStamp ) && Datetime.valueof(meetingocctimeStamp).addDays(count)<=Datetime.valueof(enddatetimeStamp ) )
                                {
                                   meetingoccurObj.Start_Time__c = teamroommeetingObj.Start_DateTime__c.addDays(count); 
                                   meetingoccurObj.End_Time__c = Datetime.valueof(meetingocctimeStamp).addDays(count);
                                }
                             } 
                         }
                         meetingoccurObj.Status__c = 'Open';
                         meetingoccurObj.Agenda__c  = teamroommeetingObj.Agenda__c;
                         meetingoccurList.add(meetingoccurObj);
                     }  
                }
                else if(recurrValue == 'Monthly' && monthlyrecurrValue != NULL)
                {
                        for(integer count = 0;count<=intMonths;count++)
                        {
                            meetingoccurObj = new GF_Meeting_Occurrence__c();
                            meetingoccurObj.Team_Room_Meeting__c = teamroommeetingObj.Id;
                            if(Datetime.valueof(monthlystarttimestamp ).addMonths(count)>= Datetime.valueof(startdatetimeStamp ) && Datetime.valueof(monthlyendtimestamp ).addMonths(count)<=Datetime.valueof(enddatetimeStamp ) )
                            {
                                meetingoccurObj.Start_Time__c = Datetime.valueof(monthlystarttimestamp ).addMonths(count);
                                meetingoccurObj.End_Time__c = Datetime.valueof(monthlyendtimestamp ).addMonths(count);
                                meetingoccurObj.Status__c = 'Open';
                                meetingoccurObj.Agenda__c  = teamroommeetingObj.Agenda__c;
                                meetingoccurList.add(meetingoccurObj);
                             }
                         }
                }
                else
                {
                     meetingoccurObj = new GF_Meeting_Occurrence__c();
                     meetingoccurObj.Team_Room_Meeting__c = teamroommeetingObj.Id;
                     meetingoccurObj.Start_Time__c = teamroommeetingObj.Start_DateTime__c; 
                     meetingoccurObj.End_Time__c = teamroommeetingObj.End_DateTime__c;
                     meetingoccurObj.Status__c = 'Open';
                     meetingoccurObj.Agenda__c  = teamroommeetingObj.Agenda__c;
                     meetingoccurList.add(meetingoccurObj);  
                }
                if(meetingoccurList.size()>0)
                {
                    try
                    {
                        insert meetingoccurList;
                    }catch(Exception ex)
                     {
                         System.debug(ex);
                     }
                }
                
                if(selectedTRMwithAcct.size()>0)
                {
                    for(String acctwithTRM : selectedTRMwithAcct)
                    {
                        
                        Id teamroommemberID = selectedmembersMap.get(acctwithTRM);
                        inviteeObj = new GF_Meeting_Invitee__c();
                        inviteeObj.Team_Room_Meeting__c = teamroommeetingObj.Id;
                        inviteeObj.User__c = teamroommemberID;
                        
                        
                        inviteeList.add(inviteeObj);  
                    }
                }
                if(inviteeList.size()>0)
                {
                   try
                   {
                       insert inviteeList;
                   }catch(Exception ex)
                    {
                        System.debug(ex);
                    }
                }
                return new pagereference ('/'+teamroommeetingObj.Id);
                
             }
           
            return null;
         }
         
        /**
            This method is used to cancel the page and navigate the previous page.
        
            @method name: cancelTeamRoomMeeting
            @return : Team Room Detail Page
        */
         public pagereference cancelTeamRoomMeeting()
         {
            return  cancelController.cancel();
         }
         
        
}