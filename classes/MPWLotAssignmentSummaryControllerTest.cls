/**
* Author: Anil Kumar
* Company: JK Technosoft
* Project: MPW
* Description: Test Class for MPWLotAssignmentSummaryController
* History:
*    Anil Kumar 07/07/2016 - Created
**/
@isTest
private class MPWLotAssignmentSummaryControllerTest {

    static testMethod void MPWLotAssignmentSummaryControllerTest1() {
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        
        User u2 = new User(Alias = 'test769', Email='test76579@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', UserName='test76579@testorg.com');
        
        System.runAs(u2){ 
            Manufacturing_Lot__c obj = new Manufacturing_Lot__c();
            obj.Name = 'test';
            obj.Manufacturing_Lot_Id__c = '132323';
            obj.Parent_Lot_Id__c = '1323231';
            obj.Device_ID_MES__c = 'Device';
            obj.Current_Scheduled_Date_CSD__c = Date.today();
            obj.Fab_Group__c = 'FAB 1';
            insert obj;
                
            MPW_WIP_Lot__c mpw = new MPW_WIP_Lot__c();
            mpw.Manufacturing_Lot__c = obj.Id;
            mpw.Assignment_Type__c  = 'End Part';
            mpw.MPW_MES_Part_ID__c = 'testm';
            mpw.Saved_User__c = u2.Id;
            mpw.Assignment_Group_Name__c = 'Assignment';
            mpw.Bare_Die_Shipment_Forecast_Date_OR__c = Date.today();
            insert mpw;
            
            ApexPages.currentPage().getParameters().put('name', mpw.Assignment_Group_Name__c);
            MPWLotAssignmentSummaryController cntrl = new MPWLotAssignmentSummaryController();
             
            cntrl.saveAssignmentSummary();  
            cntrl.strAssignmentName = 'Assignment';
            cntrl.strAssignmentUserId = u2.Id;
            cntrl.loadPopupMPWWIPLot();
        }
    }
}