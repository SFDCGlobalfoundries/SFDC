/***************************************************************************************************************************
Class:         DeviceChecklistSyncTaskSchedulerTest
----------------------------------------------------------------------------------------------------------------------------
Author:        Joydev Mondol (Cognizant - 153480)
Created Date:  11/07/2014
Reason:        Test class that covers scheduler class "DeviceChecklistSyncTaskBatchScheduler"

Change Log:    Created     -     JOYDEV     -     28/07/2014  
Change Log:    Updated     -     Sreedhar   -     10/02/2014
                [Reason]   Removed TASKRAY Application Objects Dependency                           
***************************************************************************************************************************/

@isTest(SeeAllData=false)
public class DeviceChecklistSyncTaskSchedulerTest {
    @testSetup
    static void testDataSetup(){
        DataUtilTest.loadEnvironmentVariables();
    }
    
    
    public static testMethod void SchedulerTest1() {
        createSyncVariables();
        test.startTest();
            String day = string.valueOf(system.now().day());                                                        
            String month = string.valueOf(system.now().month());                                                    
            String hour = string.valueOf(system.now().minute() == 59? system.now().hour()+1 : system.now().hour());                                                      
            String minute = string.valueOf(system.now().minute() == 59? 0 : system.now().minute()+ 1);                                              
            String second = string.valueOf(system.now().second());                                                  
            String year = string.valueOf(system.now().year());                                                      
                                                                                                                    
            String szJobName = 'Job-' + second + '_' + minute + '_' + hour + '_' + day + '_' + month + '_' + year;  
            String szSchedule = second + ' ' + minute + ' ' + hour + ' ' + day + ' ' + month + ' ? ' + year;                
            
            
            DeviceChecklistSyncTaskBatchScheduler scheduled = new DeviceChecklistSyncTaskBatchScheduler();   
            scheduled.Interval = 1;   
            String szJobId = system.schedule(szJobName, szSchedule, scheduled);        
            
            CronTrigger ct = [SELECT Id, 
                                     CronExpression, 
                                     TimesTriggered, 
                                     NextFireTime 
                                FROM CronTrigger 
                               WHERE Id = :szJobId];        
            
            System.assertEquals(szSchedule, ct.CronExpression);
        test.stopTest();
    }
    
    public static void createSyncVariables() {        
        insert new SyncTaskFrequency__c(Name = 'Sync Interval',                                        
                                        Frequency__c = 10,                                        
                                        Last_Sync_Date_Time__c = datetime.now());    
    }
}