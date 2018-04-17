/***************************************************************************************************************************
Class:         DeviceChecklistSyncTaskBatch
----------------------------------------------------------------------------------------------------------------------------
Author:        Joydev Mondol (Cognizant - 153480)
Created Date:  08/07/2014
Reason:        Batch class to sync task completion on opportunities and device updates as follows:

               (1) Schedule job runs and checks all updated Opportunities and Devices which have Device Checklist and are 
                   updated after previous successfully ran scheduled job.
               (2) Query Device Checklists and Task related to those updated Opportunities and Devices and update tasks 
                   which satisfy complete condition.
               (3) In Checklist_Task__c object, we have following fields : Dependent Object, Dependent Field, 
                   Dependent Field Completed Value, Dependent Field Type. Dependent Object can be  Opportunity OR Device 
               
               Example: “TaskX” of “DeviceChecklistA” and “ DeviceChecklistA” related to “Opportunity1” and “Device1”

                        Task X’s definition:
                        
                        Dependent Object:                 Opportunity
                        Dependent Field:                  Status__c
                        Dependent Field Type:             Picklist
                        Dependent Field Completed Value:  Design Won
                        
                        If “Opportunity1” is updated and Opportunity1’s Status__c is equal to “Design Won” then “TaskX” 
                        should be automatically completed (set: Is_Completed__c = true).

Change Log:    Created     -     JOYDEV     -     08/07/2014
Change Log:    Updated     -     JOYDEV     -     10/07/2014
               Reason: New logic - If “Opportunity1” is updated and Opportunity1’s Status__c is equal to “Design Won” then 
                                   “TaskX” should be automatically completed (set: Is_Completed__c = true) else uncompleted 
                                   (set: Is_Completed__c = true)
Change Log:    Updated     -     JOYDEV     -     11/07/2014
               Reason: New logic - If “Dependent_Field_Completed_Value__c” contains the string “__notnull”then task should 
                                   be automatically completed (set: Is_Completed__c = true)
                       New logic - If “Dependent_Field_Type__c” is Multi-select picklist, the value comparision logic with 
                                   field “Dependent_Field_Completed_Value__c” needs to be updated to handle unordered comma 
                                   separated picklist values
                       (*) Code optimized !
Change Log:    Updated     -     JOYDEV     -     14/07/2014
               Reason: Code fix - (1) "System.QueryException: duplicate field selected:" in the dynamic SOQL for opportunity 
                                       and device;
                                  (2) "System.NullPointerException: Attempt to de-reference a null object:
                                       Class.DeviceChecklistSyncTaskBatch.Execute: line 161, column 1";
Change Log:    Updated     -     JOYDEV     -     22/07/2014   
               Reason: Code fix - (1) "_NULL" changed to "__NOTNULL"  
Change Log:    Updated     -     JOYDEV     -     29/07/2014   
               Reason: New functionality - 
                                  (1) Need to capture scheduled sync job start time.
                                  (2) User should be able to initiate sync job for opened checklist and it needs to 
                                      capture user click sync start date time in Last Sync Date field of the checklist.
                                  (3) Header (in device checklist hierarchy view page) should show which ever is latest 
                                      either scheduled sync job start time OR user initiated sync. 
                       Code moved - Logic moved to DeviceChecklistSyncTaskBatchUtil.ExecuteUtil from Execute method for
                                    modularity.   
                                    Logic moved to DeviceChecklistSyncTaskBatchUtil.SOQLUtil from Start method for
                                    modularity.   
                                    logic moved from DeviceChecklistSyncTaskBatchScheduler.execute() method to avoid async 
                                    overlap   
Change Log:    Updated     -     JOYDEV     -     31/07/2014   
               Reason: New functionality - 
                                  (1) Need to send errors to specified email id in custom setting if any    
                       (*) Code cleaned !  
                       (*) Batch made Stateful !
Change Log:    Updated     -     Sreedhar   -     10/02/2014
                [Reason]   Removed TASKRAY Application Objects Dependency                                                
***************************************************************************************************************************/

global without sharing class DeviceChecklistSyncTaskBatch implements Database.Batchable<Sobject>, Database.Stateful {
   
    /*schedule interval in minutes*/
    global static Integer Interval { get; set; }
    
    /*last sync timestamp*/
    global static DateTime LastSyncDateTime { get; set; }
    
    /*final NOT-NULL String (can be fetched from custom setting to make it flexible)*/
    final static String NotNullVal = '__notnull';
    
    /*Util classes*/
    DeviceChecklistCDRSReferenceBatchUtil CDRSUtil;
    DeviceChecklistSyncTaskBatchUtil DCUtil;
    
    /*impletement 'start' method of Database.Batchable class*/
    global Database.QueryLocator Start(Database.BatchableContext BC) {
        CDRSUtil = new DeviceChecklistCDRSReferenceBatchUtil();
        DCUtil = new DeviceChecklistSyncTaskBatchUtil();
        
        CDRSUtil.Interval = DCUtil.Interval = Interval;
        CDRSUtil.LastSyncDateTime = DCUtil.LastSyncDateTime = LastSyncDateTime;
        
        CDRSUtil.ExecuteUtil(Database.Query(CDRSUtil.SOQLUtil()));
                     
        return Database.getQueryLocator(DCUtil.SOQLUtil());
    }

    /*impletement 'execute' method of Database.Batchable class*/
    global void Execute(Database.BatchableContext BC, List<Checklist_Task__c> scope) {
        DCUtil.Interval = Interval;
        DCUtil.LastSyncDateTime = LastSyncDateTime;
        DCUtil.ExecuteUtil(scope);
    }

    /*Implement 'finish' method of Database.Batchable class - (schedule next job)*/
    global void Finish(Database.BatchableContext BC) {
        /*send the error log to the recipients specified in custom setting*/
        String[] recipients = new List<String>();
        
        for(SyncTaskErrorDL__c rep : SyncTaskErrorDL__c.getall().values()) {
            recipients.add(rep.Email__c);
        }
                
        DCUtil.SendMail(recipients);
        if(SyncTaskFrequency__c.getInstance('Sync Interval') == null){
          SyncTaskFrequency__c syncFrequencySetup = new SyncTaskFrequency__c(Name='Sync Interval', 
                                                            Last_Sync_Date_Time__c = Datetime.now() - 1,
                                                            Frequency__c = 30);
          insert syncFrequencySetup;
        }
        
        /*set inteval from custom setting if not set externally*/
        Interval = (Interval != Null ? Interval : 
                    Integer.valueOf(SyncTaskFrequency__c.getInstance('Sync Interval').Frequency__c));
        
        /*set last sync time stamp from custom setting if not set externally*/
        LastSyncDateTime = (LastSyncDateTime != Null ? LastSyncDateTime : 
                            SyncTaskFrequency__c.getInstance('Sync Interval').Last_Sync_Date_Time__c);
        
        String year = string.valueOf(system.now().year());
        String month = string.valueOf(system.now().month());
        String day = string.valueOf(system.now().day());
        String hour = string.valueOf(system.now().hour());
        String minute = string.valueOf(system.now().minute());
        String second = string.valueOf(system.now().second());

        NextScheduleHolder nextSchedule = new NextScheduleHolder(year, month, day, hour, minute, second);
        
        Integer nxtYr = Integer.valueOf(year) + 1;
        Integer nxtMnth = Integer.valueOf(month) + 1;
        Integer nxtDay = Integer.valueOf(day) + 1;
        Integer nxtHr = Integer.valueOf(hour) + 1;
        Integer nxtMin = Integer.valueOf(minute) + Interval;
        
        if(nxtMin <= 59) {
            nextSchedule.minute = string.valueOf(nxtMin);
        } else if(nxtHr <= 23) {
            nextSchedule.hour = string.valueOf(nxtHr);
            nextSchedule.minute = '0';
        } else if(nxtDay <= Date.daysInMonth(nxtYr - 1, nxtMnth - 1)) {
            nextSchedule.day = string.valueOf(nxtDay);nextSchedule.hour = '0';nextSchedule.minute = '0';
        } else if(nxtMnth <= 12) {
            nextSchedule.month = string.valueOf(nxtMnth);nextSchedule.day = '1'; nextSchedule.hour = '0'; nextSchedule.minute = '0';
        } else {
            nextSchedule.year = string.valueOf(nxtYr); nextSchedule.month = '1'; nextSchedule.day = '1'; nextSchedule.hour = '0'; nextSchedule.minute = '0';
        }
        
        String szJobName = 'Device Checklist Job-' + nextSchedule.second + '_' + nextSchedule.minute + '_' + nextSchedule.hour + '_' + nextSchedule.day + '_' + nextSchedule.month + '_' + nextSchedule.year;
        szJobName = szJobName + String.valueOf(Math.random()).substring(0,4);
        String szSchedule = '0 ' + nextSchedule.minute + ' ' + nextSchedule.hour + ' ' + nextSchedule.day + ' ' + nextSchedule.month + ' ?' + ' ' + nextSchedule.year;
        
        System.schedule(szJobName, szSchedule, new DeviceChecklistSyncTaskBatchScheduler());
    }

    public class NextScheduleHolder{
      public NextScheduleHolder(String year, String month, String day, String hour, String minute, String second){
        this.year = year;
        this.month = month;
        this.day = day;
        this.hour = hour;
        this.minute = minute;
        this.second = second;
      }
      public string year{get; set;}
      public string month{get; set;}
      public string day{get; set;}
      public string hour{get; set;}
      public string minute{get; set;}
      public string second{get; set;}
    }
}