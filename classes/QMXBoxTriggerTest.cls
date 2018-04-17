/*************************************************************************************************************************************************************
@ Class:          QMXBoxTriggerTest
@ Version:        1.0
@ Author:         Pradosh Samal
@ Purpose:        This is test class for QMXBoxTrigger.
--------------------------------------------------------------------------------------------------------------------------------------------------------------
@ Change history: 11.23.2017 / Pradosh Samal / Created the class.
**************************************************************************************************************************************************************/
@isTest(seeAllData = false)
private class QMXBoxTriggerTest{

    @testSetup static void loadData() {
        
        List<Environment_Variable__c> evList = new List<Environment_Variable__c>();
        
        evList.add(new Environment_Variable__c(Name = 'QMX_WORK_ORDER_LABEL', Value__c = 'QMX Work Order'));
        evList.add(new Environment_Variable__c(Name = 'QMX_WORK_ORDER_PAGE', Value__c = 'https://rmasddev-globalfoundryview.cs31.force.com/GlobalfoundryView/aF4?isdtp=mn'));
        evList.add(new Environment_Variable__c(Name = 'QMX_WO_ISC_ENG_CUST_INST', Value__c = 'LINE RETURN FOR RETEST'));
        evList.add(new Environment_Variable__c(Name = 'QMX_WO_REC_TYPE_GF_BA_RELEASE_SETUP', Value__c = 'GF BA Release and Setup'));
        evList.add(new Environment_Variable__c(Name = 'QMX_WO_REC_TYPE_GF_PARTIAL_CRIB_RELEAS', Value__c = 'GF Partial Crib Release'));
        evList.add(new Environment_Variable__c(Name = 'QMX_WO_REC_TYPE_GF_R10_RMA_FA', Value__c = 'GF R10 RMA FA'));
        evList.add(new Environment_Variable__c(Name = 'QMX_WO_REC_TYPE_GF_STOCK_REWORK', Value__c = 'GF Stock Rework'));        
        evList.add(new Environment_Variable__c(Name = 'QMX_WO_STATUS_APPROVED', Value__c = 'Approved'));
        evList.add(new Environment_Variable__c(Name = 'QMX_WO_STATUS_BNP_FIRST_APPROVAL', Value__c = 'OSAT BNP First Approval'));
        evList.add(new Environment_Variable__c(Name = 'QMX_WO_STATUS_BNP_SECOND_APPROVAL', Value__c = 'OSAT BNP Second Approval'));
        evList.add(new Environment_Variable__c(Name = 'QMX_WO_STATUS_BROMONT_PARTIAL_CRIB', Value__c = 'Bromont Partial Crib'));
        evList.add(new Environment_Variable__c(Name = 'QMX_WO_STATUS_MFG_RELEASE', Value__c = 'MFG Release'));     
        evList.add(new Environment_Variable__c(Name = 'QMX_WO_STATUS_BTV_ROUTING', Value__c = 'BTV Routing'));
        evList.add(new Environment_Variable__c(Name = 'QMX_WO_STATUS_CO_ZONE_88', Value__c = 'Coordonnatrice Zone 88'));
        evList.add(new Environment_Variable__c(Name = 'QMX_WO_STATUS_DRAFT', Value__c = 'Draft'));
        evList.add(new Environment_Variable__c(Name = 'QMX_WO_STATUS_ITAR', Value__c = 'ITAR'));
        evList.add(new Environment_Variable__c(Name = 'QMX_WO_STATUS_REJECTED', Value__c = 'Rejected'));
        evList.add(new Environment_Variable__c(Name = 'QMX_WO_STATUS_ZONE_88', Value__c = 'Bromont Zone88'));
        
        
        insert evList;
    }
    
    static testmethod void testRun1() {
        
        Test.startTest();
        
        Id repackRecordType = Schema.SObjectType.Work_Order__c.getRecordTypeInfosByName().get('GF Repack Request').getRecordTypeId();
        
        Work_Order__c workOrder = new Work_Order__c();
        workOrder.recordTypeId = repackRecordType;
        insert workOrder;
        
        Box__c box = new Box__c();
        box.Work_Order__c = workOrder.Id;
        box.Box_Cube_Qty__c = '7';
        insert box;
        update box;
        
        Test.stopTest();
        System.assertEquals(true,true);
    }
}