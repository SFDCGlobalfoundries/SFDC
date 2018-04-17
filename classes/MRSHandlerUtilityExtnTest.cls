@isTest
private class MRSHandlerUtilityExtnTest {

    @testSetup static void setup() {
        SwiftDataUtilityTest.customSystemData();
        
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
            Layer_Name__c = 'AZ', Layer_Status__c = 'Not Ready', mrs__c = mrs1.id, tech_geo__c = '0.028', hold_by__c = UserInfo.getUserId()
        );
        insert mrslayer1;
        
        MRS_Chip_Details__c mrsChip1 = new MRS_Chip_Details__c( Name='PD123', Synced_with_Oracle_DB__c=false, mrs__c = mrs1.id);        
        insert mrsChip1; 
        
        MRS_Chip_Details__c mrsChip2 = new MRS_Chip_Details__c( Name='Frame', Synced_with_Oracle_DB__c=false, mrs__c = mrs1.id);        
        insert mrsChip2; 
        
        MRS_Layer_Chip_Association__c layerChip1 = new MRS_Layer_Chip_Association__c(
            Synced_with_Oracle_DB__c=false, Send_Frame_Data__c = 'N.A.', Send_Prime_Data__c = 'N.A.', /*DRT__c=drt1.id,*/
            Layer__c=mrsLayer1.Id, Foundry_GDSOUT_Review__c = 'N.A.', Chip__c=mrsChip1.Id, PTRF__c=ptrf1.Id, GlobalShuttle_MEBES_Jobview__c= 'N.A.',
            TDTI_MPW_MEBES_Jobview__c = 'N.A.', MDP_MEBES_Jobview__c = 'N.A.', Tapeout_Centre_MEBES_Jobview__c = 'N.A.',         
            Tapeout_Applications_MEBES_Jobview__c = 'N.A.', Foundry_MEBES_Jobview__c = 'N.A.', Customer_MEBES_Jobview__c = 'N.A.',
            Frame_MEBES_Received__c = 'Done', Prime_MEBES_Received__c = 'N.A.', Mask_Set_Title_Id__c = mst.id, PTRF_Or_DRT__c = 'PTRF', Layer_Chip_Status__c = 'Released'
        );
        insert layerChip1;
        
        MRS_Layer_Chip_Association__c layerChip2 = new MRS_Layer_Chip_Association__c(
            Synced_with_Oracle_DB__c=false, Send_Frame_Data__c = 'N.A.', Send_Prime_Data__c = 'N.A.', /*DRT__c=drt1.id,*/
            Layer__c=mrsLayer1.Id, Foundry_GDSOUT_Review__c = 'N.A.', Chip__c=mrsChip2.Id, PTRF__c=ptrf1.Id, GlobalShuttle_MEBES_Jobview__c= 'N.A.',
            TDTI_MPW_MEBES_Jobview__c = 'N.A.', MDP_MEBES_Jobview__c = 'N.A.', Tapeout_Centre_MEBES_Jobview__c = 'N.A.',         
            Tapeout_Applications_MEBES_Jobview__c = 'N.A.', Foundry_MEBES_Jobview__c = 'N.A.', Customer_MEBES_Jobview__c = 'N.A.',
            Frame_MEBES_Received__c = 'N.A.', Prime_MEBES_Received__c = 'Done', Mask_Set_Title_Id__c = mst.id, PTRF_Or_DRT__c = 'PTRF', Layer_Chip_Status__c = 'Released'
        );
        insert layerChip2;
    }
    
    @isTest
    static void testHasFrameAndPrime() {
        MRS_Layer_Association__c layer = [select id,Tech_Geo_Int__c from MRS_Layer_Association__c layer where name = 'BV' limit 1];
        
        List<MRS_Layer_Chip_Association__c> mrsLayerChips = [select id,Layer__c,Layer_Chip_Status__c from MRS_Layer_Chip_Association__c where chip__r.name in ('Frame','PD123')];
        
        try {MRSHandlerUtilityExtn.hasFrameAndPrime(layer, mrsLayerChips);} catch(exception e) {}
    }
    
    @isTest 
    static void testLogException() {
        try{
            Integer i = Integer.valueOf('1.o');
        }catch(Exception ex){
            MRSHandlerUtilityExtn.logException(ex, 'TesClass','TestMethod');
        }
    }
    
    @isTest
    static void testValidateLayerStatusUpdate() {
        Mask_Set_Title__c objMST = SwiftDataUtilityTest.createMST('MST001');
        insert objMST;
        MRS__c objMRS = new MRS__c(Mask_Set_Title__c=objMST.Id);
        insert objMRS;
        List<MRS_Layer_Association__c> listMRSLA = new List<MRS_Layer_Association__c>();
        MRS_Layer_Association__c objMRSLA1 = new MRS_Layer_Association__c(MRS__c=objMRS.Id,Layer_Status__c='Shipped',Name='RX',Mask_Layer_Rev__c='AZ',ROM_Code__c='123');
        MRS_Layer_Association__c objMRSLA2 = new MRS_Layer_Association__c(MRS__c=objMRS.Id,Layer_Status__c='Shipped',Name='RY',Mask_Layer_Rev__c='AZ',ROM_Code__c='123');
        listMRSLA.add(objMRSLA1);
        listMRSLA.add(objMRSLA2);
        insert listMRSLA;
        
        System.Test.startTest();
        
        for(MRS_Layer_Association__c layer : listMRSLA){
            layer.Layer_Status__c   = 'Released';
        }
        update listMRSLA;
        
        System.Test.stopTest();
    }
    
    @isTest
    static void test_sendPendingHoldResumeEmail() {
        String emailTemplate = 'Swift_Layer_On_Hold_Warning';

        map<id, mrs_layer_association__c> targetLayers = new map<id, mrs_layer_association__c>([select id,name,mask_layer_rev__c,Mask_Set_Title_Name__c,tech_geo_int__c from mrs_layer_association__c limit 1]);
        
        //create customer setting Environment_Variable__c techGeoCutOff = Environment_Variable__c.getInstance('SWIFT_Notify_Email_Cutoff');
        Environment_Variable__c env = new Environment_Variable__c();
        env.name = 'SWIFT_Notify_Email_Cutoff';
        env.value__c = '0';
        
        RecordType rcType = [select id,name from RecordType where name = 'General'];
        
        //create ecs: 
        Email_Config_Settings__c ecs = new Email_Config_Settings__c(
            TO__c = '#Email:hoanglong.luu@globalfoundries.com',
            Tech_Geo_Value__c = '0.028',
            Email_Template_Name__c = emailTemplate,
            RecordTypeId = rcType.Id,
            Available_For_Use__c = true
        );
        insert ecs;
        
        System.Test.startTest();
        MRSHandlerUtilityExtn.sendPendingHoldResumeEmail_future(emailTemplate, targetLayers.keySet());
        System.Test.stopTest();
    }
    
    @isTest static void test_resetSyncingFlagChip() {
        System.Test.startTest();
        mrs_layer_chip_association__c m = [select id from mrs_layer_chip_association__c limit 1];
        MRSHandlerUtilityExtn.resetSyncingFlagChip(new set<id>{m.Id});
        System.Test.stopTest();
    }
    
    @isTest static void test_resetSyncingFlagLayer() {
        System.Test.startTest();
        mrs_layer_association__c m = [select id from mrs_layer_association__c limit 1];
        MRSHandlerUtilityExtn.resetSyncingFlagLayer(new set<id>{m.Id});
        System.Test.stopTest();
    }
}