/**
 * This class contains unit tests for validating the behavior of Apex classes:
 *  - MRSPLMDRWService
 *  - MRSPLMDRWServiceHandler
 * =============================
 */
@isTest
private class MRSPLMDRWServiceTest {

    @testSetup
    static void setupTestData() {
        Test.startTest();
        initialData();
        Test.stopTest();
    }

    //test MRSPLMDRWServiceTest.serviceCall()
    static testMethod void test_MRSPLMDRWServiceTest_serviceCall() {
        Test.startTest();
        MRSPLMDRWService.callService(getPLMMessage());
        
        ptrf__c ptrf = [select id from ptrf__c limit 1];
        ptrf.status__c = 'Open';
        update ptrf;
        MRSPLMDRWService.callService(getPLMMessage());
        
        Environment_Variable__c switchValue = Environment_Variable__c.getInstance('SWIFT_PLM_DRWR_SWITCH'); 
        switchValue.value__c = 'OFF';
        update switchValue;
        MRSPLMDRWService.callService(getPLMMessage());
        Test.stopTest();
    }
    
    //test MRSPLMDRWServiceTest.serviceCall()
    static testMethod void test_MRSPLMDRWServiceTest_serviceCall_layerNotFound_invalid_layerStatus() {
        Test.startTest();
        MRSPLMDRWService.PlmDrwPTRF msg = getPLMMessage();
        msg.layers.get(0).maskLayerNumber = 'AK';
        MRSPLMDRWService.callService(msg);
        
        mrs_layer_association__c layer = [select id from mrs_layer_association__c limit 1];
        layer.layer_status__c = 'Released';
        update layer;
        MRSPLMDRWService.callService(getPLMMessage());
        Test.stopTest();
    }
    
    //test MRSPLMDRWServiceHandler.handleRequest(): validate() error
    static testMethod void test_MRSPLMDRWServiceHandler_handleRequest1() {
        MRSPLMDRWService.PlmDrwPTRF msgData = getPLMMessage();
        msgData.ptrfNumber = 'PTRF_NOT_FOUND';
        MRSPLMDRWServiceHandler.fetch().handleRequest(json.serialize(msgData));
    }
    
    //test MRSPLMDRWServiceHandler.handleRequest(): MSG_PTRF_HAS_NO_CHIP
    static testMethod void test_MRSPLMDRWServiceHandler_handleRequest2() {
        MRSPLMDRWService.PlmDrwPTRF msgData = getPLMMessage();
        delete [select id from mrs_layer_chip_association__c where ptrf__r.name = :msgData.ptrfNumber];
        MRSPLMDRWServiceHandler.fetch().handleRequest(json.serialize(msgData));
    }
    
    //test MRSPLMDRWServiceHandler.postProcessing(): error update
    static testMethod void test_MRSPLMDRWServiceHandler_postProcessing() {
        list<mrs_layer_chip_association__c> lcToUpdateList = new list<mrs_layer_chip_association__c>();
        lcToUpdateList.add(new mrs_layer_chip_association__c(layer_chip_status__c = 'In Progress'));
        try { MRSPLMDRWServiceHandler.fetch().postProcessing(lcToUpdateList); } catch(Exception e) {}
    }
    
    //test MRSPLMDRWServiceHandler.handleResponse()
    static testMethod void test_MRSPLMDRWServiceHandler_handleResponse() {
        Test.startTest();
        MRSPLMDRWServiceHandler handler = MRSPLMDRWServiceHandler.fetch();
        MRSPLMDRWServiceHandler.Message mess = new MRSPLMDRWServiceHandler.Message('Msg1','Description1',true);
        handler.layerErrorMap.put('Key1', mess);
        handler.plmPtrfData = getPLMMessage();
        handler.handleResponse();//handleResponse() cover
        mess.getStatus();//Message.getStatus() cover
        MRSPLMDRWServiceHandler.sendResponse('123','456');
        Test.stopTest();
        mess.isError = false;
        mess.getStatus();
    }
    
    /**
    * Initialize request message
    */
    public static MRSPLMDRWService.PlmDrwPTRF getPLMMessage() {
        
        MRSPLMDRWService.PlmDrwPTRF msgData = new MRSPLMDRWService.PlmDrwPTRF();
        msgData.messageID = 'TEST-PLM-123';
        msgData.ptrfNumber = 'PTRF-20189-522';
        msgData.layers = new list<MRSPLMDRWService.PlmDrwLayer>();
        
        MRSPLMDRWService.PlmDrwLayer layer1 = new MRSPLMDRWService.PlmDrwLayer();
        layer1.maskLayerNumber = 'BV';
        layer1.maskRev = 'AZ';
        
        MRSPLMDRWService.PlmDrwLayer layer2 = new MRSPLMDRWService.PlmDrwLayer();
        layer2.maskLayerNumber = 'C7';
        layer2.maskRev = 'AZ';
        
        list<MRSPLMDRWService.PlmDrwPrimeDie> primeDiees = new list<MRSPLMDRWService.PlmDrwPrimeDie>();
        for(Integer i = 0; i<3; i++) {
            MRSPLMDRWService.PlmDrwPrimeDie pd = new MRSPLMDRWService.PlmDrwPrimeDie();
            pd.primeDie = 'PD' + i;
            primeDiees.add(pd);
        }
        
        layer1.primeDies = primeDiees;
        layer2.primeDies = primeDiees;
        
        msgData.layers.add(layer1);
        msgData.layers.add(layer2);
        
        return msgData;
    }
    
    /**
    * Initialize data for test methods
    * use across MRSCAD* class
    */
    public static void initialData() {
        List<SObject> lstEnvVar = Test.loadData(Environment_Variable__c.sObjectType,'SWIFTTestEnvironmentVariablesData');//default value for flag should be ON
        
        Environment_Variable__c switchValue = new Environment_Variable__c(Name='SWIFT_PLM_DRWR_SWITCH',Value__c='ON');
        insert switchValue;
        
        //Mask_Set_Title__c mst = new Mask_Set_Title__c( Name='ZIN789', Description__c='Test Description for MST', Status__c='Active', Is_Available_For_Use__c=true );
        Mask_Set_Title__c mst = SwiftDataUtilityTest.createMST( 'ZIN789');
        insert mst;
        
        DRT__c drt1 = new DRT__c( Name='testFrame', Synced_with_Oracle_DB__c=false, DRT_Package_Sync__c=false, Status__c='Active', Mask_Set_Title__c = mst.Id );          
        insert drt1;
        
        PTRF__c ptrf1 = new PTRF__c( Name='PTRF-20189-522', Order_Type__c = 'testOrder1', Recticle_Type__c='Multi Layer Reticle (MLR)', 
            Customer_jobview__c='Gating Mask Release', MaskSetTitle__c = mst.id, Status__c = 'Perform Tapeout Options'
        );
        insert ptrf1;
        //DRT_PTRF_Association__c drtPtrfIns = new DRT_PTRF_Association__c( DRT__c = drt1.id, PTRF__c = ptrf1.id);
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
        
        MRS_Chip_Details__c mrsChip1 = new MRS_Chip_Details__c( Name='PD0', Synced_with_Oracle_DB__c=false, mrs__c = mrs1.id);        
        insert mrsChip1; 
        
        MRS_Chip_Details__c mrsChip2 = new MRS_Chip_Details__c( Name='PD1', Synced_with_Oracle_DB__c=false, mrs__c = mrs1.id);        
        insert mrsChip2; 
        
        MRS_Chip_Details__c mrsChip3 = new MRS_Chip_Details__c( Name='PD2', Synced_with_Oracle_DB__c=false, mrs__c = mrs1.id);        
        insert mrsChip3;
        
        MRS_Layer_Chip_Association__c layerChip1 = new MRS_Layer_Chip_Association__c(
            Synced_with_Oracle_DB__c=false, Send_Frame_Data__c = 'Not Done', Send_Prime_Data__c = 'Not Done', /*DRT__c=drt1.id,*/
            Layer__c=mrsLayer1.Id, Foundry_GDSOUT_Review__c = 'Not Ready', Chip__c=mrsChip1.Id, PTRF__c=ptrf1.Id, GlobalShuttle_MEBES_Jobview__c= 'Not Ready',
            TDTI_MPW_MEBES_Jobview__c = 'Not Ready', MDP_MEBES_Jobview__c = 'Not Ready', Tapeout_Centre_MEBES_Jobview__c = 'Not Ready',         
            Tapeout_Applications_MEBES_Jobview__c = 'Not Ready', Foundry_MEBES_Jobview__c = 'Not Ready', Customer_MEBES_Jobview__c = 'Not Ready',
            Frame_MEBES_Received__c = 'Not Done', Prime_MEBES_Received__c = 'Not Done', Mask_Set_Title_Id__c = mst.id, PTRF_Or_DRT__c = 'PTRF',
            DRW__c = 'In Progress'
        );
        insert layerChip1;
        
        MRS_Layer_Chip_Association__c layerChip1a = new MRS_Layer_Chip_Association__c(
            Synced_with_Oracle_DB__c=false, Send_Frame_Data__c = 'Not Done', Send_Prime_Data__c = 'Not Done', /*DRT__c=drt1.id,*/
            Layer__c=mrsLayer1.Id, Foundry_GDSOUT_Review__c = 'Not Ready', Chip__c=mrsChip2.Id, PTRF__c=ptrf1.Id, GlobalShuttle_MEBES_Jobview__c= 'Not Ready',
            TDTI_MPW_MEBES_Jobview__c = 'Not Ready', MDP_MEBES_Jobview__c = 'Not Ready', Tapeout_Centre_MEBES_Jobview__c = 'Not Ready',         
            Tapeout_Applications_MEBES_Jobview__c = 'Not Ready', Foundry_MEBES_Jobview__c = 'Not Ready', Customer_MEBES_Jobview__c = 'Not Ready',
            Frame_MEBES_Received__c = 'Not Done', Prime_MEBES_Received__c = 'Not Done', Mask_Set_Title_Id__c = mst.id, PTRF_Or_DRT__c = 'PTRF',
            DRW__c = 'In Progress'
        );
        insert layerChip1a;
        
        MRS_Layer_Chip_Association__c layerChip1b = new MRS_Layer_Chip_Association__c(
            Synced_with_Oracle_DB__c=false, Send_Frame_Data__c = 'Not Done', Send_Prime_Data__c = 'Not Done', /*DRT__c=drt1.id,*/
            Layer__c=mrsLayer1.Id, Foundry_GDSOUT_Review__c = 'Not Ready', Chip__c=mrsChip3.Id, PTRF__c=ptrf1.Id, GlobalShuttle_MEBES_Jobview__c= 'Not Ready',
            TDTI_MPW_MEBES_Jobview__c = 'Not Ready', MDP_MEBES_Jobview__c = 'Not Ready', Tapeout_Centre_MEBES_Jobview__c = 'Not Ready',         
            Tapeout_Applications_MEBES_Jobview__c = 'Not Ready', Foundry_MEBES_Jobview__c = 'Not Ready', Customer_MEBES_Jobview__c = 'Not Ready',
            Frame_MEBES_Received__c = 'Not Done', Prime_MEBES_Received__c = 'Not Done', Mask_Set_Title_Id__c = mst.id, PTRF_Or_DRT__c = 'PTRF',
            DRW__c = 'In Progress'
        );
        insert layerChip1b;
        
        MRS_Layer_Chip_Association__c layerChip2 = new MRS_Layer_Chip_Association__c(
            Synced_with_Oracle_DB__c=false, Send_Frame_Data__c = 'Not Done', Send_Prime_Data__c = 'Not Done',  DRT__c=drt1.id,
            Layer__c=mrsLayer2.Id, Foundry_GDSOUT_Review__c = 'Not Ready', Chip__c=mrsChip1.Id, PTRF__c=ptrf1.Id, GlobalShuttle_MEBES_Jobview__c= 'Not Ready',
            TDTI_MPW_MEBES_Jobview__c = 'Not Ready', MDP_MEBES_Jobview__c = 'Not Ready', Tapeout_Centre_MEBES_Jobview__c = 'Not Ready',
            Tapeout_Applications_MEBES_Jobview__c = 'Not Ready', Foundry_MEBES_Jobview__c = 'Not Ready', Customer_MEBES_Jobview__c = 'Not Ready',
            Frame_MEBES_Received__c = 'Not Done', Prime_MEBES_Received__c = 'Not Done', Mask_Set_Title_Id__c = mst.id, PTRF_Or_DRT__c = 'DRT',
            DRW__c = 'In Progress'
        );
        insert layerChip2;
    }
}