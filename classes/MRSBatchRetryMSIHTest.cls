/**
This test class covers:
- MRSBatchRetryMSIH
- MRSBatchRetryMSIHSchedulable
- MRSMSIHScheduleDispatcher

Cover triggers:
- MRS_SWIFT_BDEL
- MRS_Layer_Association_SWIFT_BDEL
- MRS_Layer_Chip_Association_SWIFT_BDEL
 */
@isTest
private class MRSBatchRetryMSIHTest {
    
    @testSetup 
    static void init() {
        SwiftDataUtilityTest.customSystemData();
        MRS_Layer_Association_SWIFT_AINS_Test.initialData();
    }

    //test for MRSBatchRetryMSIHSchedulable & MRSMSIHScheduleDispatcher
    static testMethod void test1() {
        Test.startTest();
        Datetime sysTime = System.now().addMinutes(1);
	    String cronExpression = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
	    MRSMSIHScheduleDispatcher scheduledBatch = new MRSMSIHScheduleDispatcher();
	    System.schedule( '1MRSBatchRetryMSIHS-' + sysTime, cronExpression, scheduledBatch );
	    System.schedule( '2MRSBatchRetryMSIHS-' + sysTime, cronExpression, scheduledBatch );
	    System.schedule( '3MRSBatchRetryMSIHS-' + sysTime, cronExpression, scheduledBatch );
	    System.schedule( '4MRSBatchRetryMSIHS-' + sysTime, cronExpression, scheduledBatch );
	    System.schedule( '5MRSBatchRetryMSIHS-' + sysTime, cronExpression, scheduledBatch );
	    System.schedule( '6MRSBatchRetryMSIHS-' + sysTime, cronExpression, scheduledBatch );
        Test.stopTest();
    }
    
    static testMethod void test2() {
        delete [select id from mrs_layer_chip_association__c limit 1];    
    }
    
    static testMethod void test3() {
        delete [select id from mrs_layer_association__c limit 1];    
    }
    
    static testMethod void test4() {
        delete [select id from mrs__c limit 1];    
    }
   
}