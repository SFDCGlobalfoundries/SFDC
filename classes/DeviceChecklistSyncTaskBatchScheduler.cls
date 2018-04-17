/***************************************************************************************************************************************
Class:         DeviceChecklistSyncTaskBatchScheduler
----------------------------------------------------------------------------------------------------------------------------------------
Author:        Joydev Mondol (Cognizant - 153480)
Created Date:  08/07/2014
Reason:        Schedule class to sync task completion on opportunities and device updates as follows:
               (1) Schedule job runs at 10 minutes interval for batch class - 'DeviceChecklistSyncTaskBatch'
               
*=====================================================================================================================*
|    Developer Console Snippet:                                                                                       |
*---------------------------------------------------------------------------------------------------------------------*
|        String day = string.valueOf(system.now().day());                                                             |
|        String month = string.valueOf(system.now().month());                                                         |
|        String hour = string.valueOf(system.now().hour());                                                           |
|        String minute = string.valueOf(system.now().minute() + 1);                                                   |
|        String second = string.valueOf(system.now().second());                                                       |
|        String year = string.valueOf(system.now().year());                                                           |
|                                                                                                                     |
|        String szJobName = 'Job-' + second + '_' + minute + '_' + hour + '_' + day + '_' + month + '_' + year;       |
|        String szSchedule = '0 ' + minute + ' ' + hour + ' ' + day + ' ' + month + ' ? ' + year;                     |
|                                                                                                                     |
|        System.schedule(szJobName, szSchedule, new DeviceChecklistSyncTaskBatchScheduler());                         |
*=====================================================================================================================*

Change Log:    Created     -     JOYDEV     -     08/07/2014
Change Log:    Updated     -     JOYDEV     -     11/07/2014
               Reason: Code fix to handle: seconds should range 0 - 59 in the cron string
                                           minutes should range 0 - 59 in the cron string
                                           hours should range 0 - 23 in the cron string
Change Log:    Updated     -     JOYDEV     -     14/07/2014
               Reason: Enhancement - Batch inteval is custom setting driven now
Change Log:    Updated     -     JOYDEV     -     29/07/2014
               Reason: code moved to DeviceChecklistSyncTaskBatch.Finish() method to avoid async overlap
                       (*) Code cleaned !
Change Log:    Updated     -     Sreedhar   -     10/02/2014
                [Reason]   Removed TASKRAY Application Objects Dependency  
****************************************************************************************************************************************/

global without sharing class DeviceChecklistSyncTaskBatchScheduler implements Schedulable {
    
    /*inteval in minutes - real time interval*/
    global Integer Interval { get; set; }
    
    /*last sync timestamp*/
    global DateTime LastSyncDateTime { get; set; }
    
    global void execute(SchedulableContext sc) {
        
        /*fetch sync variables from custom setting*/
        SyncTaskFrequency__c syncSetting = [SELECT Id,
                                                   Name,
                                                   Frequency__c,
                                                   Last_Sync_Date_Time__c
                                              FROM SyncTaskFrequency__c
                                             WHERE Name = 'Sync Interval'];
        
        /*set inteval from custom setting if not set externally*/
        Interval = (Interval != Null ? Interval : Integer.valueOf(syncSetting.Frequency__c));
                    
        /*set last sync time stamp from custom setting if not set externally*/
        LastSyncDateTime = (LastSyncDateTime != Null ? LastSyncDateTime : syncSetting.Last_Sync_Date_Time__c);    
        
        /*update sync variable with current timestamp for next batch reference*/
        syncSetting.Last_Sync_Date_Time__c = Datetime.now();
        update syncSetting;
        
        DeviceChecklistSyncTaskBatch.Interval = Interval;
        DeviceChecklistSyncTaskBatch.LastSyncDateTime = LastSyncDateTime;
        
        database.executeBatch(new DeviceChecklistSyncTaskBatch());
    }
}