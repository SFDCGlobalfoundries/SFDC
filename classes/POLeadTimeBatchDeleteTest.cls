/**
*    Company       :   Cognizant Technologies PTE Ltd.
*    Description   :   Test Class for class: POLeadTimeBatchDelete
*    History       :   

        Initials        Date                Description
-----------------------------------------------------------------------------------------
        CTS            03-Oct-2014          Test class created.
**/

 
@isTest(SEEALLDATA = false)
private class POLeadTimeBatchDeleteTest{
    
    public static testMethod void testMethod1(){
        
        PO_Lead_Time_Report__c poLeadReportRecord= new PO_Lead_Time_Report__c();
        poLeadReportRecord.Account__c = 'testAccount';
        poLeadReportRecord.Device__c = 'test Device';
        poLeadReportRecord.Device_Stage__c = 'test device stage';
        poLeadReportRecord.DPML__c = '1';
        poLeadReportRecord.DPML_Selected__c = '1';
        poLeadReportRecord.Fab__c = 'FAB 1';
        poLeadReportRecord.Fab_Queue_Time__c = 'gfabQueue';
        poLeadReportRecord.Geometry__c = 'testGM';
        poLeadReportRecord.ML_Count__c = 'testML';
        poLeadReportRecord.PF_Adder__c = 'testPF'; 
        poLeadReportRecord.PO_Raise_Date__c = System.TODAY(); 
        poLeadReportRecord.Process_Id__c = 'testd';
        poLeadReportRecord.Account_Short_Name__c = 'testAcc'; 
        poLeadReportRecord.Total_Lead_Time__c = 'testTime';
        poLeadReportRecord.User_Id__c = UserInfo.getUserId(); 
        poLeadReportRecord.Wafer_Shipped_Date__c = System.TODAY() + 2; 
        insert poLeadReportRecord;
        
        Test.startTest();
            POLeadTimeBatchDelete obj = new POLeadTimeBatchDelete(System.TODAY(), System.TODAY(), System.TODAY(), System.TODAY(), System.TODAY(), System.TODAY(), 'select id from PO_Lead_Time__c limit 1', '1', new List<String>{'test1','test2'}, new List<string>{'test3','test4'}, UserInfo.getUserId(), true);    
            database.executeBatch(obj,1);
        Test.stopTest();
    }
    
}