/*
* Refer to MRSCADGeneralServiceTest
*/
@isTest
private class MRSCADRJVServiceTest {
    
    @testSetup
    static void setupTestData() {
        
        MRSCADGeneralServiceTest.initialData();
    }

    //test reset flag false
    static testMethod void test_MRSCADRJVService_reset_false() {
        
        mrs_layer_chip_association__c layerChip = [select id from mrs_layer_chip_association__c limit 1];
        layerChip.Tapeout_Centre_MEBES_Jobview__c = 'Not Ready';
        update layerChip;
        
        MRSCADGeneralService.fetchService(MRSCADGeneralService.WS_REMOTE_JOBVIEW).handleRequest('{"sourceInboundRequestTimestamp":"2015-08-03T03:06:22.000Z","messageID":"TEST-MSG-01",' 
            + '"maskSetTitle":"ZIN789","jobView":[{"ptrf":[{"technology":"0.020","ptrfNumber":"PTRF-20189-522","chip":[{"layer":[{"resetFlag":false,"maskRev":"AZ",' 
            + '"maskLayer":"BV","jobStatus":null},{"resetFlag":false,"maskRev":"AZ","maskLayer":"C7","jobStatus":null}],"chipType":"PRIME","chipName":"PD123"}]}],' 
            + '"jobViewType":"MASK_LAYOUT","jobViewRemarks":"Tapeout for Device MK7008<BR>URL: https://ijdv.tce.com.tw/sgd<BR>URL: https://rjdv.tce.com.tw",' 
            + '"jobViewGroup":"FOUNDRY","jobDecks":[{"jobDeck":"c0f6q10_001.jb"}],"emailToList":"hoanglong.luu@globalfoundries.com hoanglongluuvt@gmail.com"}]}');
        
        layerChip = [select id,Tapeout_Centre_MEBES_Jobview__c from mrs_layer_chip_association__c where id = :layerChip.Id];
        system.assertEquals('Ready', layerChip.Tapeout_Centre_MEBES_Jobview__c);//Not Ready > ready
    }
    
    //test reset flag true
    static testMethod void test_MRSCADRJVService_reset_true() {
        
        mrs_layer_chip_association__c layerChip = [select id from mrs_layer_chip_association__c limit 1];
        layerChip.Tapeout_Centre_MEBES_Jobview__c = 'Released';//this value should be reset after run
        update layerChip;
        
        MRSCADGeneralService.fetchService(MRSCADGeneralService.WS_REMOTE_JOBVIEW).handleRequest('{"sourceInboundRequestTimestamp":"2015-08-03T03:06:22.000Z","messageID":"TEST-MSG-01",' 
            + '"maskSetTitle":"ZIN789","jobView":[{"ptrf":[{"technology":"0.020","ptrfNumber":"PTRF-20189-522","chip":[{"layer":[{"resetFlag":true,"maskRev":"AZ",' 
            + '"maskLayer":"BV","jobStatus":null},{"resetFlag":true,"maskRev":"AZ","maskLayer":"C7","jobStatus":null}],"chipType":"PRIME","chipName":"PD123"}]}],' 
            + '"jobViewType":"MASK_LAYOUT","jobViewRemarks":"Tapeout for Device MK7008<BR>URL: https://ijdv.tce.com.tw/sgd<BR>URL: https://rjdv.tce.com.tw",' 
            + '"jobViewGroup":"FOUNDRY","jobDecks":[{"jobDeck":"c0f6q10_001.jb"}],"emailToList":"hoanglong.luu@globalfoundries.com hoanglongluuvt@gmail.com"}]}');

        layerChip = [select id,Tapeout_Centre_MEBES_Jobview__c from mrs_layer_chip_association__c where id = :layerChip.Id];
        system.assertEquals('Ready', layerChip.Tapeout_Centre_MEBES_Jobview__c);//released > ready due to retapeout
    }
    
    //layer is shipped
    static testMethod void test_MRSCADRJVService_incorrect_layer_status() {
        
        mrs_layer_association__c layer = [select id from mrs_layer_association__c limit 1];
        layer.Layer_Status__c = 'Shipped';
        update layer;
        
        MRSCADGeneralService.fetchService(MRSCADGeneralService.WS_REMOTE_JOBVIEW).handleRequest('{"sourceInboundRequestTimestamp":"2015-08-03T03:06:22.000Z","messageID":"TEST-MSG-01",' 
            + '"maskSetTitle":"ZIN789","jobView":[{"ptrf":[{"technology":"0.020","ptrfNumber":"PTRF-20189-522","chip":[{"layer":[{"resetFlag":false,"maskRev":"AZ",' 
            + '"maskLayer":"BV","jobStatus":null},{"resetFlag":false,"maskRev":"AZ","maskLayer":"C7","jobStatus":null}],"chipType":"PRIME","chipName":"PD123"}]}],' 
            + '"jobViewType":"MASK_LAYOUT","jobViewRemarks":"Tapeout for Device MK7008<BR>URL: https://ijdv.tce.com.tw/sgd<BR>URL: https://rjdv.tce.com.tw",' 
            + '"jobViewGroup":"FOUNDRY","jobDecks":[{"jobDeck":"c0f6q10_001.jb"}],"emailToList":"hoanglong.luu@globalfoundries.com hoanglongluuvt@gmail.com"}]}');     
    
        layer = [select id,Layer_Status__c from mrs_layer_association__c where Id = :layer.Id];
        system.assertEquals('Shipped', layer.Layer_Status__c);//layer status remain Shipped after ws call due to no action taken if shipped
    }
    
    //incorrect layer chip status is Hold
    static testMethod void test_MRSCADRJVService_incorrect_layer_chip_status() {
        
        mrs_layer_chip_association__c layerChip = [select id from mrs_layer_chip_association__c limit 1];
        layerChip.Layer_Chip_Status__c = 'Hold';
        update layerChip;
        
        MRSCADGeneralService.fetchService(MRSCADGeneralService.WS_REMOTE_JOBVIEW).handleRequest('{"sourceInboundRequestTimestamp":"2015-08-03T03:06:22.000Z","messageID":"TEST-MSG-01",' 
            + '"maskSetTitle":"ZIN789","jobView":[{"ptrf":[{"technology":"0.020","ptrfNumber":"PTRF-20189-522","chip":[{"layer":[{"resetFlag":false,"maskRev":"AZ",' 
            + '"maskLayer":"BV","jobStatus":null},{"resetFlag":false,"maskRev":"AZ","maskLayer":"C7","jobStatus":null}],"chipType":"PRIME","chipName":"PD123"}]}],' 
            + '"jobViewType":"MASK_LAYOUT","jobViewRemarks":"Tapeout for Device MK7008<BR>URL: https://ijdv.tce.com.tw/sgd<BR>URL: https://rjdv.tce.com.tw",' 
            + '"jobViewGroup":"FOUNDRY","jobDecks":[{"jobDeck":"c0f6q10_001.jb"}],"emailToList":"hoanglong.luu@globalfoundries.com hoanglongluuvt@gmail.com"}]}');    
    
        layerChip = [select id,Layer_Chip_Status__c from mrs_layer_chip_association__c where id = :layerChip.Id];
        system.assertEquals('Hold', layerChip.Layer_Chip_Status__c);//layer chip status remain Hold after ws call due to no action taken if Hold
    }
    
    //record sync with update request: change timestamp of sfdc chip to bigger than msg time for reset true/false
    static testMethod void test_MRSCADRJVService_sync_update_request() {
        
        mrs_layer_chip_association__c layerChip = [select id from mrs_layer_chip_association__c limit 1];
        layerChip.Last_Sync_Req_Timestamp_Remote_JobCust__c = DateTime.valueOf('2015-08-01 03:06:22.000');
        layerChip.Last_Sync_Req_Timestamp_Remote_Jobview__c = DateTime.valueOf('2015-08-01 03:06:22.000');
        update layerChip;
        
        DateTime expected = layerChip.Last_Sync_Req_Timestamp_Remote_Jobview__c;
        
        MRSCADGeneralService.fetchService(MRSCADGeneralService.WS_REMOTE_JOBVIEW).handleRequest('{"sourceInboundRequestTimestamp":"2015-06-03T03:06:22.000Z","messageID":"TEST-MSG-01",' 
            + '"maskSetTitle":"ZIN789","jobView":[{"ptrf":[{"technology":"0.020","ptrfNumber":"PTRF-20189-522","chip":[{"layer":[{"resetFlag":false,"maskRev":"AZ",' 
            + '"maskLayer":"BV","jobStatus":null},{"resetFlag":false,"maskRev":"AZ","maskLayer":"C7","jobStatus":null}],"chipType":"PRIME","chipName":"PD123"}]}],' 
            + '"jobViewType":"MASK_LAYOUT","jobViewRemarks":"Tapeout for Device MK7008<BR>URL: https://ijdv.tce.com.tw/sgd<BR>URL: https://rjdv.tce.com.tw",' 
            + '"jobViewGroup":"FOUNDRY","jobDecks":[{"jobDeck":"c0f6q10_001.jb"}],"emailToList":"hoanglong.luu@globalfoundries.com hoanglongluuvt@gmail.com"}]}');

        layerChip = [select id,Last_Sync_Req_Timestamp_Remote_Jobview__c from mrs_layer_chip_association__c where id = :layerChip.Id];
        system.assertEquals(expected, layerChip.Last_Sync_Req_Timestamp_Remote_Jobview__c);//record already synced, send prime no-changed
    }
    
    static testMethod void test_MRSCADRJVService_manualUpdate() {
        
        mrs_layer_chip_association__c layerChip = [select id from mrs_layer_chip_association__c limit 1];
		layerChip.Is_Customer_Prime_Remote_Jobview_Updated__c = true;
		layerChip.Is_Customer_Frame_Remote_Jobview_Updated__c = true;
		layerChip.Is_Foundry_Frame_Remote_Jobview_Updated__c = true;
		layerChip.Is_Foundry_Prime_Remote_Jobview_Updated__c = true;
        layerChip.Is_Foundry_MEBES_Jobview_Updated__c = true;
        update layerChip;
        
        MRSCADGeneralService.fetchService(MRSCADGeneralService.WS_REMOTE_JOBVIEW).handleRequest('{"sourceInboundRequestTimestamp":"2015-08-03T03:06:22.000Z","messageID":"TEST-MSG-01",' 
            + '"maskSetTitle":"ZIN789","jobView":[{"ptrf":[{"technology":"0.020","ptrfNumber":"PTRF-20189-522","chip":[{"layer":[{"resetFlag":false,"maskRev":"AZ",' 
            + '"maskLayer":"BV","jobStatus":null},{"resetFlag":false,"maskRev":"AZ","maskLayer":"C7","jobStatus":null}],"chipType":"PRIME","chipName":"PD123"}]}],' 
            + '"jobViewType":"MASK_LAYOUT","jobViewRemarks":"Tapeout for Device MK7008<BR>URL: https://ijdv.tce.com.tw/sgd<BR>URL: https://rjdv.tce.com.tw",' 
            + '"jobViewGroup":"FOUNDRY","jobDecks":[{"jobDeck":"c0f6q10_001.jb"}],"emailToList":"hoanglong.luu@globalfoundries.com hoanglongluuvt@gmail.com"}]}');
    }
}