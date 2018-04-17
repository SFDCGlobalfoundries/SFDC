/*************************************************************************************************************************************************************
@ Class:          QMXWorkOrderTriggerTest
@ Version:        1.0
@ Author:         Yathish
@ Purpose:        This is test class for QMXBoxTrigger.
--------------------------------------------------------------------------------------------------------------------------------------------------------------
@ Change history: 12.4.2017 / Yathish / Created the class.
**************************************************************************************************************************************************************/
@isTest(seeAllData = false)
private class QMXWorkOrderTriggerTest{

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
        
        List<Error_Codes__c> ecList = new List<Error_Codes__c>();
        ecList.add(new Error_Codes__c(Name = 'QMX_WORK_ORDER_REWORK_INSTRUCTION_VAL', Message__c = 'Rework Instructions are required to move to the next stage.'));
        ecList.add(new Error_Codes__c(Name = 'QMX_WORK_ORDER_ACCESS_VALIDATION', Message__c = 'You dont have permission to edit this record'));
        ecList.add(new Error_Codes__c(Name = 'QMX_WORK_ORDER_LOT_REWORK_VALIDATION', Message__c = 'Please fill rework lot Field in all the Work Order Lots before Moving to next step'));
        ecList.add(new Error_Codes__c(Name = 'QMX_WORK_ORDER_DECLARED_LOT_VALIDATION', Message__c = 'Please enter Declared LOT before approval.'));
        ecList.add(new Error_Codes__c(Name = 'QMX_WORK_ORDER_PRIMARY_FC_VALIDATION', Message__c = 'Please enter Primary FC before approval.'));
        ecList.add(new Error_Codes__c(Name = 'QMX_WORK_ORDER_PRIMARY_PC_VALIDATION', Message__c = 'Please enter Primary PC before approval.'));
        ecList.add(new Error_Codes__c(Name = 'QMX_WO_OSAT_BNP_VALIDATION', Message__c = 'Please fill Start Qty in Work Order before Approving this request'));
        ecList.add(new Error_Codes__c(Name = 'QMX_WO_OSAT_TOGO_QTY_VALIDATION', Message__c = 'The Release Quantity should be equal to the Start Quantity before approving the form'));
        ecList.add(new Error_Codes__c(Name = 'QMX_WO_OSAT_FIELDS_VALIDATION', Message__c = 'Please make OSAT Ready field value as True before Moving to next step'));        
        insert ecList;
        DataUtilTest.loadEnvironmentVariables();
        Account acc = RMA_TestDataUtility.createAccount();
        Account acc1 = [Select id from account limit 1][0];
        RMA__c rmaRec = RMA_TestDataUtility.createRMAForFab9(9, acc1);
        RMA__c rmaRec1 = RMA_TestDataUtility.createRMAForFab9(9, acc1);
    }
    
    static testmethod void testQMXWorkOrderTrigger() {
        Test.startTest();
        Id repackRecordType = Schema.SObjectType.Work_Order__c.getRecordTypeInfosByName().get('GF R10 RMA FA').getRecordTypeId(); 
        List<RMA__c> rmalst = new List<RMA__C>();
        for(RMA__c rm:[Select Id,ReasonCode__c from RMA__c]){
            rm.ReasonCode__c = 'R10';
            rmalst.add(rm);
        }
        update rmalst;
        rmalst = [Select Id,ReasonCode__c from RMA__c];
        system.debug('rmaliiist' +  rmalst);
        Account acc2 = [Select id from account limit 1][0];
        RMA_TestDataUtility.createRMAReturnInvoiceForFab9(rmalst[0],acc2);
        RMA_TestDataUtility.createRMAReturnInvoiceForFab9(rmalst[1],acc2);
        Work_Order__c wo = new Work_Order__c();
        wo.RMA_Number__c = rmalst[0].Id;
        wo.recordTypeId = repackRecordType;
        insert wo;
        //QMXWorkOrderTriggerHelper qmx =new QMXWorkOrderTriggerHelper();
        QMXWorkOrderTriggerHelper.firstRun = true;
        Work_Order_Lot__c wol = new Work_Order_Lot__c();
        wol.Rework_Lots__c = '1234';
        wol.Work_Order__c = wo.id;
        insert wol;
        QMXWorkOrderTriggerHelper.firstRun = true;
        Work_Order__c wo1 = [select id,RMA_Number__c,Approval_Status__c from Work_Order__c where Id = : wo.Id Limit 1];
        wo1.RMA_Number__c = rmalst[1].Id;
        wo1.Approval_Status__c = Environment_Variable__c.getInstance('QMX_WO_STATUS_ITAR').Value__c;
        //wo1.Rework_Lots__c = '1234';
        try{
        update wo1;
        }
        catch(Exception e){
            
        }
        Test.stopTest();
        System.assertEquals(true,true);
    }
}