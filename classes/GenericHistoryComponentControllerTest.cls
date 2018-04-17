@isTest(SeeAllData = true)
private class GenericHistoryComponentControllerTest{

    static testmethod void testRun(){
        Device__c dev = [select id from device__c where stage__c = 'Design In' limit 1];
        GenericHistoryComponentController gcc = new GenericHistoryComponentController();
        gcc.myObject = dev;
        gcc.recordLimit = 50;
        gcc.getObjectHistory();
    }
}