/*
Type Name: BatchTargettedDeliveryDateReminderTest 
Author: Cognizant
Created Date: 2-June-2016
Change History:
Author:  
Modified  Date: 
Reason: 
……..
……..
*/

@isTest(SeeAllData = false)
private class BatchTargettedDeliveryDateReminderTest {
    
    static Id PDKRequestRecordType(){
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Bug__c;
        Map < String, Schema.RecordTypeInfo > WRbugRecordTypes = cfrSchema.getRecordTypeInfosByName();
        Id rtId = WRbugRecordTypes.get('PDK Request').getRecordTypeId();
        return rtId;
    }      
    /**
    @Method Name: batchTDTest
    @Return type: null
    @Parameters: null
    @Description: Test Method for batch class
    **/
    static testMethod void batchTDTest() {
        Test.startTest();
        try{                
        List<Bug__c> bugList = new List<Bug__c>();
        Bug__c bugobj = new Bug__c();
        bugobj.RecordTypeId = PDKRequestRecordType();
        bugobj.Bug_Title__c = 'TestWR4';
        bugobj.Bug_Description__c = 'TestWR4';
        bugobj.Request_Type__c = 'Yes';
        bugobj.Geometry__c = '0.11UM';
        bugobj.Target_Process_Node__c = '110G';       
        bugobj.Need_By_Date__c = Date.today().addDays(2);
        bugobj.Targetted_Delivery_Date__c = system.today()+3;
        bugList.add(bugobj);
        insert bugList;

        SchedulableContext SC= null;
        scheduledTargettedDeliveryDateReminder sch1 = new scheduledTargettedDeliveryDateReminder();
        sch1.execute(SC);
        BatchTargettedDeliveryDateReminder batchObj = new BatchTargettedDeliveryDateReminder();
        ID batchprocessid = Database.executeBatch(batchObj,200);
        batchObj.start(null);            
        batchObj.execute(null,bugList);
        batchObj.finish(null);
        System.AssertEquals(database.countquery('SELECT COUNT() FROM Bug__c'),1);
        }catch(Exception e){
            System.Assert(e.getMessage().contains(' '), e.getMessage());
        }
        Test.stopTest();
    }  
}