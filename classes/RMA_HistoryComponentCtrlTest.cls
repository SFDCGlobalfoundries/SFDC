@isTest(SeeAllData = true)
private class RMA_HistoryComponentCtrlTest {
    
    static testmethod void testRun(){
        RMA__c dev = [select id  from RMA__c where is_legacy__c = false and Status__c = 'Submitted' limit 1];
        RMA_HistoryComponentCtrl gcc = new RMA_HistoryComponentCtrl();
        gcc.myObject = dev;
        gcc.recordLimit = 50;
        gcc.getObjectHistory();
        gcc.reportDevName = 'RMA_with_Field_History';
        gcc.getReportUrl();
    }
    
}