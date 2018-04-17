/*
* Refer to MRSCADGeneralServiceTest
*/
@isTest(seeAllData=false)
public class MRSCADMEBESReceivedServiceTest {

    @testSetup
    static void setupTestData() {
        
        MRSCADGeneralServiceTest.initialData();
    }
    
    //retapeout flag = true
    static testMethod void test_MRSCADMEBESReceivedService_reset_true() {
        
        MRSCADGeneralService.fetchService(MRSCADGeneralService.WS_MEBES_RECEIVED).handleRequest('{"sourceInboundRequestTimestamp":"2015-07-03T03:06:22.000Z",'
            + '"ptrf":[{"technology":"0.020","ptrfNumber":"PTRF-20189-522","chip":[{"layer":[{"resetFlag":true,"maskRev":"AZ","maskLayer":"BV","jobStatus":null},'
            + '{"resetFlag":true,"maskRev":"AZ","maskLayer":"C7","jobStatus":null}],"chipType":"PRIME","chipName":"PD123"}]}],"messageID":"TEST-RECEIVED-MEBES-MSG-01",' 
            + '"maskSetTitle":"ZIN789","jobViewRemarks":"Tapeout for Device MK7008<BR>URL: https://ijdv.tce.com.tw/sgd<BR>URL: https://rjdv.tce.com.tw",' 
            + '"jobdecks":[{"jobDeck":"c0f6q10_001.jb"}],"customerJobViewAtFoundry":true}');
    }
    
    //retapeout flag = false
    static testMethod void test_MRSCADMEBESReceivedService_reset_false() {
        
        MRSCADGeneralService.fetchService(MRSCADGeneralService.WS_MEBES_RECEIVED).handleRequest('{"sourceInboundRequestTimestamp":"2015-07-03T03:06:22.000Z",'
            + '"ptrf":[{"technology":"0.020","ptrfNumber":"PTRF-20189-522","chip":[{"layer":[{"resetFlag":false,"maskRev":"AZ","maskLayer":"BV","jobStatus":null},'
            + '{"resetFlag":false,"maskRev":"AZ","maskLayer":"C7","jobStatus":null}],"chipType":"PRIME","chipName":"PD123"}]}],"messageID":"TEST-RECEIVED-MEBES-MSG-01",' 
            + '"maskSetTitle":"ZIN789","jobViewRemarks":"Tapeout for Device MK7008<BR>URL: https://ijdv.tce.com.tw/sgd<BR>URL: https://rjdv.tce.com.tw",' 
            + '"jobdecks":[{"jobDeck":"c0f6q10_001.jb"}],"customerJobViewAtFoundry":true}');
    }
    
    //layer is shipped test: change layer to shipped
    static testMethod void test_MRSCADMEBESReceivedService_incorrect_layer_status() {
        
        mrs_layer_association__c layer = [select id from mrs_layer_association__c limit 1];
        layer.Layer_Status__c = 'Shipped';
        update layer;
                
        MRSCADGeneralService.fetchService(MRSCADGeneralService.WS_MEBES_RECEIVED).handleRequest('{"sourceInboundRequestTimestamp":"2015-07-03T03:06:22.000Z",'
            + '"ptrf":[{"technology":"0.020","ptrfNumber":"PTRF-20189-522","chip":[{"layer":[{"resetFlag":false,"maskRev":"AZ","maskLayer":"BV","jobStatus":null},'
            + '{"resetFlag":false,"maskRev":"AZ","maskLayer":"C7","jobStatus":null}],"chipType":"PRIME","chipName":"PD123"}]}],"messageID":"TEST-RECEIVED-MEBES-MSG-01",' 
            + '"maskSetTitle":"ZIN789","jobViewRemarks":"Tapeout for Device MK7008<BR>URL: https://ijdv.tce.com.tw/sgd<BR>URL: https://rjdv.tce.com.tw",' 
            + '"jobdecks":[{"jobDeck":"c0f6q10_001.jb"}],"customerJobViewAtFoundry":true}');
    }
    
    //incorrect layer chip status: change layer chip status to Hold
    static testMethod void test_MRSCADMEBESReceivedService_incorrect_layer_chip_status() {
        
        mrs_layer_chip_association__c layerChip = [select id from mrs_layer_chip_association__c limit 1];
        layerChip.Layer_Chip_Status__c = 'Hold';
        update layerChip;
                
        MRSCADGeneralService.fetchService(MRSCADGeneralService.WS_MEBES_RECEIVED).handleRequest('{"sourceInboundRequestTimestamp":"2015-07-03T03:06:22.000Z",'
            + '"ptrf":[{"technology":"0.020","ptrfNumber":"PTRF-20189-522","chip":[{"layer":[{"resetFlag":false,"maskRev":"AZ","maskLayer":"BV","jobStatus":null},'
            + '{"resetFlag":false,"maskRev":"AZ","maskLayer":"C7","jobStatus":null}],"chipType":"PRIME","chipName":"PD123"}]}],"messageID":"TEST-RECEIVED-MEBES-MSG-01",' 
            + '"maskSetTitle":"ZIN789","jobViewRemarks":"Tapeout for Device MK7008<BR>URL: https://ijdv.tce.com.tw/sgd<BR>URL: https://rjdv.tce.com.tw",' 
            + '"jobdecks":[{"jobDeck":"c0f6q10_001.jb"}],"customerJobViewAtFoundry":true}');
    }
    
    //record sync with update request: change timestamp of sfdc chip to bigger than msg time for reset true/false
    static testMethod void test_MRSCADMEBESReceivedService_sync_update_request() {
        
        mrs_layer_chip_association__c layerChip = [select id from mrs_layer_chip_association__c limit 1];
        layerChip.Last_Sync_Req_Timestamp_Receive_MEBES__c = DateTime.valueOf('2015-08-01 03:06:22.000');
        update layerChip;
                
        MRSCADGeneralService.fetchService(MRSCADGeneralService.WS_MEBES_RECEIVED).handleRequest('{"sourceInboundRequestTimestamp":"2015-07-03T03:06:22.000Z",'
            + '"ptrf":[{"technology":"0.020","ptrfNumber":"PTRF-20189-522","chip":[{"layer":[{"resetFlag":false,"maskRev":"AZ","maskLayer":"BV","jobStatus":null},'
            + '{"resetFlag":false,"maskRev":"AZ","maskLayer":"C7","jobStatus":null}],"chipType":"PRIME","chipName":"PD123"}]}],"messageID":"TEST-RECEIVED-MEBES-MSG-01",' 
            + '"maskSetTitle":"ZIN789","jobViewRemarks":"Tapeout for Device MK7008<BR>URL: https://ijdv.tce.com.tw/sgd<BR>URL: https://rjdv.tce.com.tw",' 
            + '"jobdecks":[{"jobDeck":"c0f6q10_001.jb"}],"customerJobViewAtFoundry":true}');
    }
    
    //record is manual update: change is updated field of mebes receive and 1 jv field to true
    static testMethod void test_MRSCADMEBESReceivedService_manualUpdate() {
        
        mrs_layer_chip_association__c layerChip = [select id from mrs_layer_chip_association__c limit 1];
        layerChip.Is_Prime_MEBES_Received_Updated__c = true;
        layerChip.Is_Frame_MEBES_Received_Updated__c = true;
        layerChip.Is_Foundry_MEBES_Jobview_Updated__c = true;
        update layerChip;
                
        MRSCADGeneralService.fetchService(MRSCADGeneralService.WS_MEBES_RECEIVED).handleRequest('{"sourceInboundRequestTimestamp":"2015-07-03T03:06:22.000Z",'
            + '"ptrf":[{"technology":"0.020","ptrfNumber":"PTRF-20189-522","chip":[{"layer":[{"resetFlag":false,"maskRev":"AZ","maskLayer":"BV","jobStatus":null},'
            + '{"resetFlag":false,"maskRev":"AZ","maskLayer":"C7","jobStatus":null}],"chipType":"PRIME","chipName":"PD123"}]}],"messageID":"TEST-RECEIVED-MEBES-MSG-01",' 
            + '"maskSetTitle":"ZIN789","jobViewRemarks":"Tapeout for Device MK7008<BR>URL: https://ijdv.tce.com.tw/sgd<BR>URL: https://rjdv.tce.com.tw",' 
            + '"jobdecks":[{"jobDeck":"c0f6q10_001.jb"}],"customerJobViewAtFoundry":true}');
    }
}