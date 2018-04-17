@isTest 
public class MRS_CADServiceTest {
    
    @testSetup
    static void setupTestData() {
        List<SObject> lstEnvVar = Test.loadData(Environment_Variable__c.sObjectType,'SWIFTTestEnvironmentVariablesData');//default value for flag should be ON
    }  
    
    static testMethod void test1() {
        list<MRS_CADService.MRSDataRecievedOnLayerGeneration> requests = new list<MRS_CADService.MRSDataRecievedOnLayerGeneration>();
        requests.add(new MRS_CADService.MRSDataRecievedOnLayerGeneration());
        
        test.startTest();
        try {
            MRS_CADService.sync_Layer_Generation_Job_Completion(requests);
        } catch(exception e) {}
        test.stopTest(); 
    }
    
    static testMethod void test2() {
        list<MRS_CADService.MRSDataRecievedOnSendPrimeData> requests = new list<MRS_CADService.MRSDataRecievedOnSendPrimeData>();
        requests.add(new MRS_CADService.MRSDataRecievedOnSendPrimeData());
        
        test.startTest(); 
        try { 
            MRS_CADService.sync_Send_Prime_Data_Job_Completion(requests);
        } catch(exception e) {}
        test.stopTest();
    }
    
    static testMethod void test3() {
        list<MRS_CADService.MRSDataRecievedOnSendFrameData> requests = new list<MRS_CADService.MRSDataRecievedOnSendFrameData>();
        requests.add(new MRS_CADService.MRSDataRecievedOnSendFrameData());
        
        test.startTest();
        try {
            MRS_CADService.sync_Send_Frame_Data_Job_Completion(requests);
        } catch(exception e) {}
        test.stopTest();
    }
    
    static testMethod void test4() {
        list<MRS_CADService.MRSDataRecievedOnSyncRemoteJobView> requests = new list<MRS_CADService.MRSDataRecievedOnSyncRemoteJobView>();
        requests.add(new MRS_CADService.MRSDataRecievedOnSyncRemoteJobView());
        
        test.startTest();
        try {
            MRS_CADService.sync_Remote_Jobview_Setup_Ready(requests);
        } catch(exception e) {}
        test.stopTest();
    }
    
    static testMethod void test5() {
        list<MRS_CADService.MRSDataRecievedOnSyncMEBESReceive> requests = new list<MRS_CADService.MRSDataRecievedOnSyncMEBESReceive>();
        requests.add(new MRS_CADService.MRSDataRecievedOnSyncMEBESReceive());
        
        test.startTest();
        try {            
            MRS_CADService.sync_Receive_MEBES_Data_from_Maskshop(requests);             
        } catch(exception e) {}
        test.stopTest();
    }
    
    static testMethod void test6() {
        list<MRS_CADService.MRSDataRecievedOnORCNStatusChange> requests = new list<MRS_CADService.MRSDataRecievedOnORCNStatusChange>();
        requests.add(new MRS_CADService.MRSDataRecievedOnORCNStatusChange());
        
        test.startTest();
        try { 
            MRS_CADService.sync_ORCN_Job_Status_Change(requests); 
        } catch(exception e) {}
        test.stopTest();
    }
    
    static testMethod void test7() {
        
        try {
            MRSWebserviceException sample = new MRSWebserviceException();
            sample.init();
        } catch(exception e) {}
        
        try {
            throw new MRSWebserviceException('We are sorry!!! 503 Service Unavailable. The server is currently unavailable (because it is overloaded or down for maintenance).');
        } catch(exception e) {}
        
    }
    
    static testMethod void test8() {
        //MRS_CADService.sendMailLayerChip(map<string, list<string>> mapchipsMissing, map<string, list<string>> maplayersMissing, string messageid, string MST, datetime requestTime, string subjectAdd) {
        String s = '1;2;3;4;5;6;7;8;9';
        list<String> randomList = s.split(';');
        
        map<string, list<string>> mapchipsMissing = new map<string, list<string>>();
        mapchipsMissing.put('key1', randomList);
        
        map<string, list<string>> maplayersMissing = new map<string, list<string>>();
        maplayersMissing.put('key2', randomList);
        
        string messageid = 'msg-id-1';
        string MST = 'msttst';
        datetime requestTime = system.now();
        string subjectAdd = 'UNIT-TEST: ';
        
        Environment_Variable__c env = Environment_Variable__c.getInstance('SWIFT_CAD_EMAIL');
        if(null == env) {
            env = new Environment_Variable__c();
            env.name = 'SWIFT_CAD_EMAIL';
        }
        env.value__c = 'test@globalfoundries.com';
        upsert env;
        
        try{
            MRS_CADService.sendMailLayerChip(mapchipsMissing, maplayersMissing, messageid, MST, requestTime, subjectAdd);
        } catch(exception e) {}
    }
}