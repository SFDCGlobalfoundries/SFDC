/**
* Author: Anil Kumar
* Company: JK Technosoft
* Project: MPW
* Description: Test Class for MPWLotAssignmentNotificationBatch
* History:
*    Anil Kumar 07/07/2016 - Created
**/
@isTest
private class MPWLotAssignmentNotificationBatchTest {

    static testMethod void MPWLotAssignmentNotificationBatchTest1() {
        
       Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        
        User u2 = new User(Alias = 'test769', Email='test76579@testorg.com', 
                           EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                           LocaleSidKey='en_US', ProfileId = p.Id, 
                           TimeZoneSidKey='America/Los_Angeles', UserName='test76579@testorg.com');
        insert u2;
        
        
        
        
        Manufacturing_Lot__c objChild1 = new Manufacturing_Lot__c();
        objChild1.Name = 'testobjChild1';
        objChild1.Manufacturing_Lot_Id__c = '132323';
        objChild1.Device_ID_MES__c = 'Device';
        objChild1.Current_Scheduled_Date_CSD__c = date.today();
        insert objChild1;
        
        
        MPW_Train_Maintenance__c mptrain = new MPW_Train_Maintenance__c();
        mptrain.Name = 'strMPWTrain';
        insert mptrain;
        
        MPW_Reservation__c mpwRes = new MPW_Reservation__c();
        mpwRes.Name = 'Test Mpwres' ;
        mpwRes.Form_Status__c = 'Pending';
        mpwRes.Category__c = 'Customer';
        mpwRes.Form_Status__c = 'Accepted by MPW Tapeout';
        mpwRes.MPW_Train_Name__c = mptrain.Id;
        insert mpwRes;
        
        MPW_Prime_Die__c primedie = new MPW_Prime_Die__c();
        primedie.Prime_Die_Name__c = 'teste die';
        primedie.MPW_Form__c = mpwRes.id;
        primedie.Drawn_Die_Size_Y_um__c = 'test y';
        primedie.Drawn_Die_Size_X_um__c = 'test x';
        primedie.Device_Type__c = 'test ice';
        //primedie.Delivery_Qty_Die_Form__c = 'DeliveryQty';
        insert primedie;
        
        MPW_WIP_Lot__c mpw = new MPW_WIP_Lot__c();
        mpw.Manufacturing_Lot__c = objChild1.Id;
        mpw.Assignment_Type__c  = 'End Part';
        mpw.MPW_MES_Part_ID__c = 'testm';
        mpw.Notification_Start_Date__c = Date.today()-2;
        mpw.Notification_End_Date__c = Date.today()+1;
        mpw.Notification_Interval_Days__c = 2;
        mpw.MPW_Prime_Die__c = primedie.Id;
        //mpw.Bare_Die_Shipment_Forecast_Date_BL__c = date.today()-1;
        mpw.Bare_Die_Shipment_Forecast_Date_OR__c = date.Today();
        mpw.Assignment_Type__c = 'End Part';
        mpw.Saved_User__c = u2.Id;
        insert mpw;
        
        List<MPW_WIP_Lot__c> lstMPW= [SELECT Id, Assignment_Group_Name__c, Saved_User__c, Saved_User__r.Name, Saved_User__r.Email,
                        Manufacturing_Lot__c, Manufacturing_Lot_Id__c, MPW_Prime_Die__c, Prime_Die_Name__c, MPW_form__c, MPW_Prime_Die__r.MPW_Form__c,
                        MPW_Prime_Die__r.MPW_Form__r.Customer_Company_Name__c, MPW_Form_Customer_Account_Name__c, MPW_Train_Name__c, MPW_MES_Part_ID__c, Assignment_Type__c, 
                        Notification_Interval_Days__c, Bare_Die_Shipment_Forecast_Date_BL__c, Bare_Die_Shipment_Forecast_Date_OR__c, Notification_Start_Date__c, Notification_End_Date__c, Notification_Active__c 
                        FROM MPW_WIP_Lot__c WHERE Id =: mpw.Id];
        
        
         Test.startTest();
        MPWLotAssignmentNotificationBatch cntrl = new MPWLotAssignmentNotificationBatch();
       
        Database.executeBatch(cntrl,1);
        cntrl.start(null);
        cntrl.execute(null,lstMPW);
        cntrl.finish(null);  
        Test.stopTest();
          
        
    }
}