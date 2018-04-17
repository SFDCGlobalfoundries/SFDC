/*
* Common test class for:
*       MRSCADGeneralService
*       MRSCADMEBESReceivedService
*       MRSCADRJVService
*       MRSCADSendDataService
*
* For complete test coverage, should run together with each individual ws test class
*       MRSCADMEBESReceivedServiceTest
*       MRSCADRJVServiceTest
*       MRSCADSendDataServiceTest 
*/
@isTest
public class MRSCADGeneralServiceTest {
    
    @testSetup
    static void setupTestData() {
        
        initialData();
    }  
    
    static testMethod void test_MRSCADGeneralService() {
        
        MRSCADGeneralService service = new MRSCADGeneralService();
        system.assertNotEquals(null, service.messageId);
    }
    
    static testMethod void test_fetchService_handleRequest() {
        
        //test error missing mst in message
        MRSCADGeneralService.fetchService('MRSCADMEBESReceivedService').handleRequest('{"sourceInboundRequestTimestamp":"2015-07-03T03:06:22.000Z","ptrf":[{"technology":"0.020","ptrfNumber":"PTRF-20189-522","chip":[{"layer":[{"resetFlag":true,"maskRev":"AZ","maskLayer":"BV","jobStatus":null},{"resetFlag":true,"maskRev":"AZ","maskLayer":"C7","jobStatus":null}],"chipType":"PRIME","chipName":"PD123"}]}],"messageID":"TEST-RECEIVED-MEBES-MSG-01","maskSetTitle":"","jobViewRemarks":"Tapeout for Device MK7008<BR>URL: https://ijdv.tce.com.tw/sgd<BR>URL: https://rjdv.tce.com.tw","jobdecks":[{"jobDeck":"c0f6q10_001.jb"}],"customerJobViewAtFoundry":true}');
        
        //test error invalid ptrf status
        ptrf__c ptrf1 = [select id from ptrf__c where name = 'PTRF-20189-522'];
        ptrf1.Status__c = 'Open';
        update ptrf1;
        MRSCADGeneralService.fetchService('MRSCADMEBESReceivedService').handleRequest('{"sourceInboundRequestTimestamp":"2015-07-03T03:06:22.000Z","ptrf":[{"technology":"0.020","ptrfNumber":"PTRF-20189-522","chip":[{"layer":[{"resetFlag":true,"maskRev":"AZ","maskLayer":"BV","jobStatus":null},{"resetFlag":true,"maskRev":"AZ","maskLayer":"C7","jobStatus":null}],"chipType":"PRIME","chipName":"PD123"}]}],"messageID":"TEST-RECEIVED-MEBES-MSG-01","maskSetTitle":"ZIN789","jobViewRemarks":"Tapeout for Device MK7008<BR>URL: https://ijdv.tce.com.tw/sgd<BR>URL: https://rjdv.tce.com.tw","jobdecks":[{"jobDeck":"c0f6q10_001.jb"}],"customerJobViewAtFoundry":true}');        
    }
    
    static testMethod void test_validateFormat_sendErrorEmail_logUnhandledException() {
        
        //test logUnhandledException() & sendErrorEmail()
        try {
            Integer testExceptionNumber = Integer.valueOf('a') - 1;    
        } catch(Exception e) {
            SWIFT_Application_Log__c log = MRSCADGeneralService.logUnhandledException(e, 'EXCEPTION-MSG-1', 'EXCEPTION-MSG-ID', 'ThisClass', 'ThisMethod', 'PTRF-TEST-001');
            system.assertNotEquals(null, log.Id);
            MRSCADGeneralService.sendErrorEmail(e, 'LOG-ID-123', 'wsClass', 'msgId', 'mst', 'ptrfNumber');            
        }
        
        //test validateFormat()
        MRSCADGeneralService service = new MRSCADGeneralService();
        MRSCADGeneralService.Message result = service.validateFormat('msg');
        system.assertEquals(false, result.isError);
        system.assertEquals('SUCCESS', result.getStatus());
        
        MRSCADGeneralService.Message errorMsgCheck = new MRSCADGeneralService.Message('', '', true);
        system.assertEquals('ERROR', errorMsgCheck.getStatus());
    }
    
    static testMethod void test_main_flow() {
        //test main flow, correct data
        MRSCADGeneralService.fetchService('MRSCADMEBESReceivedService').handleRequest('{"sourceInboundRequestTimestamp":"2015-07-03T03:06:22.000Z","ptrf":[{"technology":"0.020","ptrfNumber":"PTRF-20189-522","chip":[{"layer":[{"resetFlag":true,"maskRev":"AZ","maskLayer":"BV","jobStatus":null},{"resetFlag":true,"maskRev":"AZ","maskLayer":"C7","jobStatus":null}],"chipType":"PRIME","chipName":"PD123"}]}],"messageID":"TEST-RECEIVED-MEBES-MSG-01","maskSetTitle":"ZIN789","jobViewRemarks":"Tapeout for Device MK7008<BR>URL: https://ijdv.tce.com.tw/sgd<BR>URL: https://rjdv.tce.com.tw","jobdecks":[{"jobDeck":"c0f6q10_001.jb"}],"customerJobViewAtFoundry":true}');
    }
    
    static testMethod void test_empty_chip() {
        //test empty chips in sfdc
        List<mrs_layer_chip_association__c> testChips = [select id from mrs_layer_chip_association__c];
        delete testChips;
        MRSCADGeneralService.fetchService('MRSCADMEBESReceivedService').handleRequest('{"sourceInboundRequestTimestamp":"2015-07-03T03:06:22.000Z","ptrf":[{"technology":"0.020","ptrfNumber":"PTRF-20189-522","chip":[{"layer":[{"resetFlag":true,"maskRev":"AZ","maskLayer":"BV","jobStatus":null},{"resetFlag":true,"maskRev":"AZ","maskLayer":"C7","jobStatus":null}],"chipType":"PRIME","chipName":"PD123"}]}],"messageID":"TEST-RECEIVED-MEBES-MSG-01","maskSetTitle":"ZIN789","jobViewRemarks":"Tapeout for Device MK7008<BR>URL: https://ijdv.tce.com.tw/sgd<BR>URL: https://rjdv.tce.com.tw","jobdecks":[{"jobDeck":"c0f6q10_001.jb"}],"customerJobViewAtFoundry":true}');        
    }
    
    static testMethod void test_retrievePtrfChip() {
        
        MRSCADGeneralService service = new MRSCADGeneralService();
        service.mst = 'ZIN789';        
        MRS_CADService.PTRFData ptrfData = new MRS_CADService.PTRFData();
        ptrfData.ptrfNumber = 'PTRF-20189-522';        
        service.ptrfData = ptrfData;        
        service.setChipName = new set<String>{'PD123'};
        service.setLayerNumber = new set<String>{'BV','C7'};
        service.setLayerRev = new set<String>{'AZ'};        
        
        //test methods
        system.assert(service.retrievePtrfChip().size() > 0);//test retrievePtrfChip()
        service.processWS();//test processWS()    
        service.wsMessage = 'error';
        service.handleRequest(null);//test exception block of handleRequest()
        service.ptrfData = null;
        try{ service.handleResponse('null'); } catch(Exception e) {}
    }
    
    /**
    * Initialize data for test methods
    * use across MRSCAD* class
    */
    public static void initialData() {
        List<SObject> lstEnvVar = Test.loadData(Environment_Variable__c.sObjectType,'SWIFTTestEnvironmentVariablesData');//default value for flag should be ON
        
        Mask_Set_Title__c mst = SwiftDataUtilityTest.createMST( 'ZIN789');
        insert mst;
        
        DRT__c drt1 = new DRT__c( Name='testFrame', Synced_with_Oracle_DB__c=false, DRT_Package_Sync__c=false, Status__c='Active', Mask_Set_Title__c = mst.Id );          
        insert drt1;
        
        PTRF__c ptrf1 = new PTRF__c( Name='PTRF-20189-522', Order_Type__c = 'testOrder1', Recticle_Type__c='Multi Layer Reticle (MLR)', 
            Customer_jobview__c='Gating Mask Release', MaskSetTitle__c = mst.id, Status__c = 'Perform Tapeout Options'
        );
        insert ptrf1;
        
        DRT_PTRF_Association__c drtPtrfIns = new DRT_PTRF_Association__c( DRT__c = drt1.id, PTRF__c = ptrf1.id);
        //insert drtPtrfIns ;
        
        MRS__c mrs1 = new MRS__c( Full_Sync__c =true, Synced_with_Oracle_DB__c=false, MRS_Package_Sync__c=false, Mask_Set_Title__c=mst.Id);
        insert mrs1;
        
        MRS_Layer_Association__c mrsLayer1 = new MRS_Layer_Association__c( Name ='BV', Synced_with_Oracle_DB__c=false, Mask_Layer_Rev__c = 'AZ',
            Layer_Name__c = 'AZ', Layer_Status__c = 'Not Ready', mrs__c = mrs1.id
        );
        insert mrslayer1;
        
        MRS_Layer_Association__c mrsLayer2 = new MRS_Layer_Association__c( Name ='C7', Synced_with_Oracle_DB__c=false, Mask_Layer_Rev__c = 'AZ',
            Layer_Name__c = 'C7', Layer_Status__c = 'Not Ready', mrs__c = mrs1.id
        );
        insert mrslayer2;   
        
        MRS_Chip_Details__c mrsChip1 = new MRS_Chip_Details__c( Name='PD123', Synced_with_Oracle_DB__c=false, mrs__c = mrs1.id);        
        insert mrsChip1; 
        
        MRS_Layer_Chip_Association__c layerChip1 = new MRS_Layer_Chip_Association__c(
            Synced_with_Oracle_DB__c=false, Send_Frame_Data__c = 'Not Done', Send_Prime_Data__c = 'Not Done', /*DRT__c=drt1.id,*/
            Layer__c=mrsLayer1.Id, Foundry_GDSOUT_Review__c = 'Not Ready', Chip__c=mrsChip1.Id, PTRF__c=ptrf1.Id, GlobalShuttle_MEBES_Jobview__c= 'Not Ready',
            TDTI_MPW_MEBES_Jobview__c = 'Not Ready', MDP_MEBES_Jobview__c = 'Not Ready', Tapeout_Centre_MEBES_Jobview__c = 'Not Ready',         
            Tapeout_Applications_MEBES_Jobview__c = 'Not Ready', Foundry_MEBES_Jobview__c = 'Not Ready', Customer_MEBES_Jobview__c = 'Not Ready',
            Frame_MEBES_Received__c = 'Not Done', Prime_MEBES_Received__c = 'Not Done', Mask_Set_Title_Id__c = mst.id, PTRF_Or_DRT__c = 'PTRF'
        );
        insert layerChip1;
        
        MRS_Layer_Chip_Association__c layerChip2 = new MRS_Layer_Chip_Association__c(
            Synced_with_Oracle_DB__c=false, Send_Frame_Data__c = 'Not Done', Send_Prime_Data__c = 'Not Done',  DRT__c=drt1.id,
            Layer__c=mrsLayer2.Id, Foundry_GDSOUT_Review__c = 'Not Ready', Chip__c=mrsChip1.Id, PTRF__c=ptrf1.Id, GlobalShuttle_MEBES_Jobview__c= 'Not Ready',
            TDTI_MPW_MEBES_Jobview__c = 'Not Ready', MDP_MEBES_Jobview__c = 'Not Ready', Tapeout_Centre_MEBES_Jobview__c = 'Not Ready',
            Tapeout_Applications_MEBES_Jobview__c = 'Not Ready', Foundry_MEBES_Jobview__c = 'Not Ready', Customer_MEBES_Jobview__c = 'Not Ready',
            Frame_MEBES_Received__c = 'Not Done', Prime_MEBES_Received__c = 'Not Done', Mask_Set_Title_Id__c = mst.id, PTRF_Or_DRT__c = 'DRT'
        );
        insert layerChip2;
    }
}