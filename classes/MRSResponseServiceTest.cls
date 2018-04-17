/*
SWGP-998
Test class for MRSResponseService
*/
@isTest 
private class MRSResponseServiceTest {
    
    @testSetup
    static void setupTestData() {        
        MRS_Layer_Association_SWIFT_AINS_Test.initialData();
    }

    static testMethod void myUnitTes1() {
        mrs_layer_association__c m = [select id from mrs_layer_association__c limit 1];
        MRSResponseService.ResponseMessage msg = new MRSResponseService.ResponseMessage();
        msg.sfdcId = m.id;
        msg.status = 'success';
        msg.message = '';
        
        list<MRSResponseService.ResponseMessage> l = new list<MRSResponseService.ResponseMessage>();
        l.add(msg);
        MRSResponseService.notification(l);
    }
    
    static testMethod void myUnitTes2() {
        mrs_layer_chip_association__c m = [select id from mrs_layer_chip_association__c limit 1];
        MRSResponseService.ResponseMessage msg = new MRSResponseService.ResponseMessage();
        msg.sfdcId = m.id;
        msg.status = 'error';
        msg.message = 'error';
        list<MRSResponseService.ResponseMessage> l = new list<MRSResponseService.ResponseMessage>();
        l.add(msg);
        MRSResponseService.notification(l);
    }
}