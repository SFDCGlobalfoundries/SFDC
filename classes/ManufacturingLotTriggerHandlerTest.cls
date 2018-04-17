/**
* Author: Anil Kumar
* Company: JK Technosoft
* Project: MPW
* Description: Test Class for ManufacturingLotTriggerHandler
* History:
*    Anil Kumar 07/07/2016 - Created
**/
@isTest
private class ManufacturingLotTriggerHandlerTest {

    static testMethod void ManufacturingLotTriggerHandlerTest1() {
		Test.StartTest();
		
		List<Manufacturing_Lot__c> lstMfg = new List<Manufacturing_Lot__c>();
        
        Manufacturing_Lot__c oMfg = new Manufacturing_Lot__c();
        oMfg.Name = 'PARENT LOT';   
        oMfg.Manufacturing_Lot_Id__c = 'LOTABC';
        oMfg.Parent_Lot_Id__c = '';
        oMfg.Device_ID_MES__c = '1234';
        oMfg.Lot_Type__c = 'test lot';
        insert oMfg;

        MPW_WIP_Lot__c oWIP = new MPW_WIP_Lot__c();
        oWIP.Manufacturing_Lot__c = oMfg.Id;
        oWIP.Assignment_Type__c  = 'End Part';
        oWIP.MPW_MES_Part_ID__c = '1234';
        insert oWIP;
		
		Manufacturing_Lot__c oMfg1 = new Manufacturing_Lot__c();
        oMfg1.Manufacturing_Lot_Id__c = 'LOTABC.01';
        oMfg1.Name = 'CHILD LOT 1';
        oMfg1.Parent_Lot_Id__c = 'LOTABC';
        oMfg1.Device_ID_MES__c = '1234'; 
        oMfg1.Lot_Type__c = 'test lot';
        lstMfg.add(oMfg1);
		
        Manufacturing_Lot__c oMfg2 = new Manufacturing_Lot__c();
        oMfg2.Manufacturing_Lot_Id__c = 'LOTABC.02';
        oMfg2.Name = 'CHILD LOT 2';
        oMfg2.Parent_Lot_Id__c = 'LOTABC';
        oMfg2.Device_ID_MES__c = '1234'; 
        oMfg2.Lot_Type__c = 'test lot';
        lstMfg.add(oMfg2);
        
		insert lstMfg;
        
        oMfg2.Lot_Type__c = 'test lot2';
        update oMfg2;
		
		Test.stopTest(); 
	}
}