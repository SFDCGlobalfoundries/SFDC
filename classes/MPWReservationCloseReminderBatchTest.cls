/*
    Author: Anil Kumar
    Description: Batch class is used to send email notification 7 days before closing the reservation form.
    History: 
        Anil Kumar 12/29/2016 - Code creation.
        Kanishk Singh 6/2/2017 - Updated class as per salesforce standard
        Code Coverage 100%
*/ 

@isTest 
public class MPWReservationCloseReminderBatchTest {
    public static testMethod void MPWReservationCloseReminderBatchTest1(){
        MPWReservationCloseReminder__c cs = new MPWReservationCloseReminder__c();
        cs.Name = 'Test CS';
        cs.ToAddress__c = 'test@test.com';
        cs.CC_Address_1__c = 'test1@test.com';
        cs.CC_Address_2__c = 'test2@test.com';
        cs.CC_Address_3__c = 'test3@test.com';
        cs.CC_Address_4__c = 'test4@test.com';
        cs.CC_Address_5__c = 'test5@test.com';
        cs.CC_Address_6__c = 'test6@test.com';
        cs.CC_Address_7__c = 'test7@test.com';
        cs.CC_Address_8__c = 'test8@test.com';
        cs.Active__c = true;
        
        Database.SaveResult result = Database.insert(cs);
        System.assert(result.isSuccess());
        
        MPW_Train_Maintenance__c m1 = new MPW_Train_Maintenance__c();
        m1.Name = 'TestMPW1';
        m1.Customer_Tapeout_Date__c = Date.today();
        m1.Other_Tapeout_Date__c = Date.today();
        m1.MPW_Train_No__c = 'testMpwTrainNo1';
        m1.Active__c = true;
        m1.Publish__c = true;
        m1.Reservation_Close_Date__c = Date.today()+7;
        m1.Geometry__c = 'Geometry';
        m1.CDRS_Submit_Date__c = Date.today();
        m1.Cancellation_Deadline__c = Date.today();
        m1.GDSII_Cutoff_for_Dry_Run_DRC__c = DateTime.now();
        m1.Tapeout_Date_Other_Participant__c = Date.today();
        m1.Customer_Tapeout_Date__c = Date.today();
       
        result = Database.insert(m1);
        System.assert(result.isSuccess());
       
       Test.startTest();
  
        MPWReservationCloseReminderBatch obj = new MPWReservationCloseReminderBatch();
        Database.executeBatch(obj);
        
       Test.stopTest();
  
    }
    
    public static testMethod void MPWReservationCloseReminderBatchTest2(){
        List<MPW_Train_Maintenance__c> lstTrain = new List<MPW_Train_Maintenance__c>();
        MPW_Train_Maintenance__c m1 = new MPW_Train_Maintenance__c();
        m1.Name = 'TestMPW1';
        m1.Customer_Tapeout_Date__c = Date.today();
        m1.Other_Tapeout_Date__c = Date.today();
        m1.MPW_Train_No__c = 'testMpwTrainNo1';
        m1.Active__c = true;
        m1.Publish__c = true;
        m1.Reservation_Close_Date__c = Date.today()+7;
        m1.Geometry__c = 'Geometry';
        m1.CDRS_Submit_Date__c = Date.today();
        m1.Cancellation_Deadline__c = Date.today();
        m1.GDSII_Cutoff_for_Dry_Run_DRC__c = DateTime.now();
        m1.Tapeout_Date_Other_Participant__c = Date.today();
        m1.Customer_Tapeout_Date__c = Date.today();
        lstTrain.add(m1); 
        
        MPW_Train_Maintenance__c m2 = new MPW_Train_Maintenance__c();
        m2.Name = 'TestMPW2';
        m2.Customer_Tapeout_Date__c = Date.today();
        m2.Other_Tapeout_Date__c = Date.today();
        m2.MPW_Train_No__c = 'testMpwTrainNo2';
        m2.Active__c = true;
        m2.Publish__c = true;
        m2.Reservation_Close_Date__c = Date.today()+7;
        m2.Geometry__c = 'Geometry';
        m2.CDRS_Submit_Date__c = Date.today();
        m2.Cancellation_Deadline__c = Date.today();
        m2.GDSII_Cutoff_for_Dry_Run_DRC__c = DateTime.now();
        m2.Tapeout_Date_Other_Participant__c = Date.today();
        m2.Customer_Tapeout_Date__c = Date.today();
        lstTrain.add(m2); 
        
       // insert lstTrain; 
        List<Database.SaveResult> lstresult = Database.insert(lstTrain);
        System.assert(lstresult.size()>0);
      
       Test.startTest(); 
        MPWReservationCloseReminderBatch obj = new MPWReservationCloseReminderBatch();
        Database.executeBatch(obj);
      Test.stopTest();  
    }
}