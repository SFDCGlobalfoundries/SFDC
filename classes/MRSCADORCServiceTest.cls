@isTest
private class MRSCADORCServiceTest {
	
	@testSetup
    static void setupTestData() {
        MRSCADGeneralServiceTest.initialData();
    }

    static testMethod void test_MRSCADSendDataService_1() {
        String msg = '{"sourceInboundRequestTimestamp":"2016-04-16T18:39:44.000Z","ptrf":['
        	+ '{"technology":"0.020","ptrfNumber":"PTRF-20189-522","chip":[{"layer":[{"resetFlag"' 
        	+ ':false,"maskRev":"AZ","maskLayer":"BV","jobStatus":"pass"},{"resetFlag":false,"maskRev"'
        	+ ':"AZ","maskLayer":"C7","jobStatus":"pend"}],"chipType":"Prime","chipName":"PD123"}]}],' 
        	+ '"messageID":"LONG-ORC-TEST-089","maskSetTitle":"ZIN789"}';
    	MRSCADGeneralService.fetchService(MRSCADGeneralService.WS_ORC).handleRequest(msg);
    	MRSCADGeneralService.fetchService(MRSCADGeneralService.WS_ORC).handleRequest(msg);//test record already synced
    }
    
    static testMethod void test_MRSCADSendDataService_2() {
        String msg = '{"sourceInboundRequestTimestamp":"2016-04-16T18:39:44.000Z","ptrf":['
        	+ '{"technology":"0.020","ptrfNumber":"PTRF-20189-522","chip":[{"layer":[{"resetFlag"' 
        	+ ':false,"maskRev":"AZ","maskLayer":"BV","jobStatus":"none"},{"resetFlag":false,"maskRev"'
        	+ ':"AZ","maskLayer":"C7","jobStatus":null}],"chipType":"Prime","chipName":"PD123"}]}],' 
        	+ '"messageID":"LONG-ORC-TEST-089","maskSetTitle":"ZIN789"}';
    	MRSCADGeneralService.fetchService(MRSCADGeneralService.WS_ORC).handleRequest(msg);
    }
    
    static testMethod void test_MRSCADSendDataService_3() {
        String msg = '{"sourceInboundRequestTimestamp":"2016-04-16T18:39:44.000Z","ptrf":['
        	+ '{"technology":"0.020","ptrfNumber":"PTRF-20189-522","chip":[{"layer":[{"resetFlag"' 
        	+ ':false,"maskRev":"AZ","maskLayer":"BVV","jobStatus":"pass"},{"resetFlag":false,"maskRev"'
        	+ ':"AZ","maskLayer":"C7","jobStatus":""}],"chipType":"Prime","chipName":"PD123"}]}],' 
        	+ '"messageID":"LONG-ORC-TEST-089","maskSetTitle":"ZIN789"}';
    	MRSCADGeneralService.fetchService(MRSCADGeneralService.WS_ORC).handleRequest(msg);
    }
    
    static testMethod void test_MRSCADSendDataService_4() {
    	list<mrs_layer_chip_association__c> lstChip = [select id from mrs_layer_chip_association__c where layer__r.name in ('BV','C7')];
    	lstChip[0].layer_chip_status__c = 'Cancel';    	
    	update lstChip;
    	
    	test.startTest();
        String msg = '{"sourceInboundRequestTimestamp":"2016-04-16T18:39:44.000Z","ptrf":['
        	+ '{"technology":"0.020","ptrfNumber":"PTRF-20189-522","chip":[{"layer":[{"resetFlag"' 
        	+ ':false,"maskRev":"AZ","maskLayer":"BV","jobStatus":"pass"},{"resetFlag":false,"maskRev"'
        	+ ':"AZ","maskLayer":"C7","jobStatus":""}],"chipType":"Prime","chipName":"PD123"}]}],' 
        	+ '"messageID":"LONG-ORC-TEST-089","maskSetTitle":"ZIN789"}';
    	MRSCADGeneralService.fetchService(MRSCADGeneralService.WS_ORC).handleRequest(msg);
    	test.stopTest();
    }
    
    static testMethod void test_MRSCADSendDataService_5() {
        String msg = '{"sourceInboundRequestTimestamp": "2016-04-16T18:39:44.000Z","ptrf": null,"messageID": "LONG-ORC-TEST-089","maskSetTitle": "ZIN789"}';
    	MRSCADGeneralService.fetchService(MRSCADGeneralService.WS_ORC).handleRequest(msg);
    }
    
    static testMethod void test_MRSCADSendDataService_6() {
        String msg = '{"sourceInboundRequestTimestamp":"2016-04-16T18:39:44.000Z","ptrf":[{"technology":"0.020","ptrfNumber":"PTRF-8220-9228","chip":null}],"messageID":"LONG-ORC-TEST-089","maskSetTitle":"ZIN789"}';
    	MRSCADGeneralService.fetchService(MRSCADGeneralService.WS_ORC).handleRequest(msg);
    }
    
    static testMethod void test_MRSCADSendDataService_7() {
        String msg = '{"sourceInboundRequestTimestamp":"2016-04-16T18:39:44.000Z","ptrf":[{"technology":"0.020","ptrfNumber":"PTRF-20189-522","chip":[{"layer":null,"chipType":"Prime","chipName":"PD123"}]}],"messageID":"LONG-ORC-TEST-089","maskSetTitle":"ZIN789"}';
    	MRSCADGeneralService.fetchService(MRSCADGeneralService.WS_ORC).handleRequest(msg);
    }
    
    static testMethod void test_MRSCADSendDataService_8() {
        String msg = '{"sourceInboundRequestTimestamp":"2016-04-16T18:39:44.000Z","ptrf":[{"technology":"0.020","ptrfNumber":"PTRF-20189-522","chip":[{"layer":[{"resetFlag":false,"maskRev":"AZ","maskLayer":"BV","jobStatus":"pass"},{"resetFlag":false,"maskRev":"AZ","maskLayer":"C7","jobStatus":"pend"}],"chipType":"Prime","chipName":"NOT_FOUND"},{"layer":[{"resetFlag":false,"maskRev":"AZ","maskLayer":"BV","jobStatus":"pass"},{"resetFlag":false,"maskRev":"AZ","maskLayer":"C7","jobStatus":"pend"}],"chipType":"Prime","chipName":"PD123"}]}],"messageID":"LONG-ORC-TEST-089","maskSetTitle":"ZIN789"}';
    	MRSCADGeneralService.fetchService(MRSCADGeneralService.WS_ORC).handleRequest(msg);
    }
    
    static testMethod void test_MRSCADSendDataService_9() {
    	list<mrs_layer_chip_association__c> lstChip = [select id from mrs_layer_chip_association__c where layer__r.name in ('BV','C7')];
    	for(mrs_layer_chip_association__c m: lstChip) {
    		m.Is_ORC_Updated__c = true;
    	}
    	update lstChip;
        String msg = '{"sourceInboundRequestTimestamp":"2016-04-16T18:39:44.000Z","ptrf":['
        	+ '{"technology":"0.020","ptrfNumber":"PTRF-20189-522","chip":[{"layer":[{"resetFlag"' 
        	+ ':false,"maskRev":"AZ","maskLayer":"BV","jobStatus":"pass"},{"resetFlag":false,"maskRev"'
        	+ ':"AZ","maskLayer":"C7","jobStatus":"pend"}],"chipType":"Prime","chipName":"PD123"}]}],' 
        	+ '"messageID":"LONG-ORC-TEST-089","maskSetTitle":"ZIN789"}';
    	MRSCADGeneralService.fetchService(MRSCADGeneralService.WS_ORC).handleRequest(msg);
    	MRSCADGeneralService.fetchService(MRSCADGeneralService.WS_ORC).handleRequest(msg);//test record already synced
    }
    
    static testMethod void test_MRSCADSendDataService_10() {
    	list<mrs_layer_chip_association__c> lstChip = [select id from mrs_layer_chip_association__c where layer__r.name in ('BV','C7')];
    	for(mrs_layer_chip_association__c m: lstChip) {
    		m.layer_chip_status__c = 'Void';
    	}
    	update lstChip;
        String msg = '{"sourceInboundRequestTimestamp":"2016-04-16T18:39:44.000Z","ptrf":['
        	+ '{"technology":"0.020","ptrfNumber":"PTRF-20189-522","chip":[{"layer":[{"resetFlag"' 
        	+ ':false,"maskRev":"AZ","maskLayer":"BV","jobStatus":"pass"},{"resetFlag":false,"maskRev"'
        	+ ':"AZ","maskLayer":"C7","jobStatus":"pend"}],"chipType":"Prime","chipName":"PD123"}]}],' 
        	+ '"messageID":"LONG-ORC-TEST-089","maskSetTitle":"ZIN789"}';
    	MRSCADGeneralService.fetchService(MRSCADGeneralService.WS_ORC).handleRequest(msg);
    	MRSCADGeneralService.fetchService(MRSCADGeneralService.WS_ORC).handleRequest(msg);//test record already synced
    }
    
    static testMethod void test_MRSCADSendDataService_11() {
    	list<mrs_layer_association__c> lstChip = [select id from mrs_layer_association__c];
    	for(mrs_layer_association__c m: lstChip) {
    		m.layer_status__c = 'Shipped';
    	}
    	update lstChip;
        String msg = '{"sourceInboundRequestTimestamp":"2016-04-16T18:39:44.000Z","ptrf":['
        	+ '{"technology":"0.020","ptrfNumber":"PTRF-20189-522","chip":[{"layer":[{"resetFlag"' 
        	+ ':false,"maskRev":"AZ","maskLayer":"BV","jobStatus":"pass"},{"resetFlag":false,"maskRev"'
        	+ ':"AZ","maskLayer":"C7","jobStatus":"pend"}],"chipType":"Prime","chipName":"PD123"}]}],' 
        	+ '"messageID":"LONG-ORC-TEST-089","maskSetTitle":"ZIN789"}';
    	MRSCADGeneralService.fetchService(MRSCADGeneralService.WS_ORC).handleRequest(msg);
    	MRSCADGeneralService.fetchService(MRSCADGeneralService.WS_ORC).handleRequest(msg);//test record already synced
    }
    
    static testMethod void test_MRSCADSendDataService_12() {
    	list<mrs_layer_chip_association__c> lstChip = [select id,layer__c,name from mrs_layer_chip_association__c where layer__r.name in ('BV','C7')];
    	mrs_layer_chip_association__c m = lstChip.get(0);
    	m.Id = null;
    	lstChip.add(m);
    	MRSCADORCService con = new MRSCADORCService();
    	try {con.postProcessing(lstChip);}catch(Exception e){}
    	//MRSCADORCService 
    }
}