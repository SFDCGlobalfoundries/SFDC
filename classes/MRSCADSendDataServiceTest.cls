/*
* Refer to MRSCADGeneralServiceTest
*/
@isTest
private class MRSCADSendDataServiceTest {

    @testSetup
    static void setupTestData() {
        
        MRSCADGeneralServiceTest.initialData();
    }

    //reset flag false
    static testMethod void test_MRSCADSendDataService_reset_false() {
        
        MRSCADGeneralService.fetchService(MRSCADGeneralService.WS_SEND_DATA).handleRequest('{"sourceInboundRequestTimestamp":"2015-07-13T03:06:22.000Z","reTapeoutFlag":false,' 
            + '"ptrf":[{"technology":"0.020","ptrfNumber":"PTRF-20189-522","chip":[{"layer":[{"resetFlag":true,"maskRev":"AZ","maskLayer":"BV","jobStatus":null},' 
            + '{"resetFlag":true,"maskRev":"AZ","maskLayer":"C7","jobStatus":null}],"chipType":"PRIME","chipName":"PD123"}]}],"messageID":"TEST-SEND-DATA-MSG-01",' 
            + '"maskSetTitle":"ZIN789","jobStatus":"SUCCESS"}');
        
        mrs_layer_chip_association__c layerChip = [select id,Send_Prime_Data__c from mrs_layer_chip_association__c where Mask_Layer__c = 'BV'];
        system.assertEquals('Done', layerChip.Send_Prime_Data__c);//after ws called, send prime should be done
    }
    
    //reset flag true
    static testMethod void test_MRSCADSendDataService_reset_true() {
        
        mrs_layer_chip_association__c layerChip = [select id from mrs_layer_chip_association__c limit 1];
        layerChip.Tapeout_Centre_MEBES_Jobview__c = 'Released';//this value should be reset after run
        update layerChip;
        
        MRSCADGeneralService.fetchService(MRSCADGeneralService.WS_SEND_DATA).handleRequest('{"sourceInboundRequestTimestamp":"2015-07-13T03:06:22.000Z","reTapeoutFlag":true,' 
            + '"ptrf":[{"technology":"0.020","ptrfNumber":"PTRF-20189-522","chip":[{"layer":[{"resetFlag":true,"maskRev":"AZ","maskLayer":"BV","jobStatus":null},' 
            + '{"resetFlag":true,"maskRev":"AZ","maskLayer":"C7","jobStatus":null}],"chipType":"PRIME","chipName":"PD123"}]}],"messageID":"TEST-SEND-DATA-MSG-01",' 
            + '"maskSetTitle":"ZIN789","jobStatus":"SUCCESS"}');
            
        layerChip = [select id,Tapeout_Centre_MEBES_Jobview__c from mrs_layer_chip_association__c where id = :layerChip.Id];            
        system.assertEquals('Not Ready', layerChip.Tapeout_Centre_MEBES_Jobview__c);//released > not ready due to retapeout
    }
    
    //layer is shipped
    static testMethod void test_MRSCADSendDataService_incorrect_layer_status() {
        
        mrs_layer_association__c layer = [select id from mrs_layer_association__c limit 1];
        layer.Layer_Status__c = 'Shipped';
        update layer;
        
        MRSCADGeneralService.fetchService(MRSCADGeneralService.WS_SEND_DATA).handleRequest('{"sourceInboundRequestTimestamp":"2015-07-13T03:06:22.000Z","reTapeoutFlag":false,' 
            + '"ptrf":[{"technology":"0.020","ptrfNumber":"PTRF-20189-522","chip":[{"layer":[{"resetFlag":true,"maskRev":"AZ","maskLayer":"BV","jobStatus":null},' 
            + '{"resetFlag":true,"maskRev":"AZ","maskLayer":"C7","jobStatus":null}],"chipType":"PRIME","chipName":"PD123"}]}],"messageID":"TEST-SEND-DATA-MSG-01",' 
            + '"maskSetTitle":"ZIN789","jobStatus":"SUCCESS"}');
        
        layer = [select id,Layer_Status__c from mrs_layer_association__c where Id = :layer.Id];
        system.assertEquals('Shipped', layer.Layer_Status__c);//layer status remain Shipped after ws call due to no action taken if shipped
    }
    
    //incorrect layer chip
    static testMethod void test_MRSCADSendDataService_incorrect_layer_chip_status() {
        
        mrs_layer_chip_association__c layerChip = [select id from mrs_layer_chip_association__c limit 1];
        layerChip.Layer_Chip_Status__c = 'Hold';
        update layerChip;
        
        MRSCADGeneralService.fetchService(MRSCADGeneralService.WS_SEND_DATA).handleRequest('{"sourceInboundRequestTimestamp":"2015-07-13T03:06:22.000Z","reTapeoutFlag":false,' 
            + '"ptrf":[{"technology":"0.020","ptrfNumber":"PTRF-20189-522","chip":[{"layer":[{"resetFlag":true,"maskRev":"AZ","maskLayer":"BV","jobStatus":null},' 
            + '{"resetFlag":true,"maskRev":"AZ","maskLayer":"C7","jobStatus":null}],"chipType":"PRIME","chipName":"PD123"}]}],"messageID":"TEST-SEND-DATA-MSG-01",' 
            + '"maskSetTitle":"ZIN789","jobStatus":"SUCCESS"}');
            
        layerChip = [select id,Layer_Chip_Status__c from mrs_layer_chip_association__c where id = :layerChip.Id];
        system.assertEquals('Hold', layerChip.Layer_Chip_Status__c);//layer chip status remain Hold after ws call due to no action taken if Hold
    }
    
    //record sync with update request: change timestamp of sfdc chip to bigger than msg time for reset true/false
    static testMethod void test_MRSCADSendDataService_sync_update_request() {
        
        mrs_layer_chip_association__c layerChip = [select id from mrs_layer_chip_association__c limit 1];
        layerChip.Last_Sync_Req_Timestamp_Send_Prime__c = DateTime.valueOf('2015-08-01 03:06:22.000');
        layerChip.Last_Sync_Req_Timestamp_Send_Frame__c = DateTime.valueOf('2015-08-01 03:06:22.000');
        update layerChip;
        
        MRSCADGeneralService.fetchService(MRSCADGeneralService.WS_SEND_DATA).handleRequest('{"sourceInboundRequestTimestamp":"2015-07-13T03:06:22.000Z","reTapeoutFlag":false,' 
            + '"ptrf":[{"technology":"0.020","ptrfNumber":"PTRF-20189-522","chip":[{"layer":[{"resetFlag":true,"maskRev":"AZ","maskLayer":"BV","jobStatus":null},' 
            + '{"resetFlag":true,"maskRev":"AZ","maskLayer":"C7","jobStatus":null}],"chipType":"PRIME","chipName":"PD123"}]}],"messageID":"TEST-SEND-DATA-MSG-01",' 
            + '"maskSetTitle":"ZIN789","jobStatus":"SUCCESS"}');
        
        layerChip = [select id,Send_Prime_Data__c from mrs_layer_chip_association__c where Mask_Layer__c = 'BV'];
        system.assertEquals('Not Done', layerChip.Send_Prime_Data__c);//record already synced, send prime no-changed
    }
}