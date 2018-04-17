@isTest
private class FV_PDKProvisioningSchedulerTest {

    static testMethod void pdkProvisioningSchedulerTest() {
    
        Test.StartTest();
            System.schedule('Document Provisioning'+system.now(), '0 00 00 * * ?', new FV_DocumentProvRetriggerScheduler());
        Test.StopTest();
    }
    
}