/**
SWGP-882
This test class will cover:

Classes:
- MRSDeselectionService
- MRSDeselectionServiceHandler
- MRSDeselectionUtils
- MRSPLMDRWRetryController
Trigger:
-Swift_Application_Log_SWIFT_AUPD
*/
@isTest
private class MRSDeselectionServiceTest {
    
    @testSetup
    static void setupTestData() {
        Test.startTest();
        try {
            Environment_Variable__c env = new Environment_Variable__c();
            env.name = 'SWIFT_L_C_DESELECTION_DEBUG_SWITCH';
            env.value__c = 'ON';
            insert env;
        } catch(exception e) {}
        initialData();
        //initialData2();
        Test.stopTest();
    }  

    static testMethod void myUnitTest() {
        
        mrs_layer_chip_association__c lc = [select id from mrs_layer_chip_association__c limit 1];
        
        MRSDeselectionService.Notification msg = new MRSDeselectionService.Notification();
        msg.messageId = 'id1234';
        msg.ptrfNumber = 'PTRF-20189-522';
        msg.timeStamp = system.now();
        msg.layerChipList = new List<MRSDeselectionService.LayerChip>();
        msg.ptrfMaskLayerList = new List<MRSDeselectionService.PTRFMaskLayer>();
        msg.ptrfChipList = new List<MRSDeselectionService.PTRFChip>();
        
        MRSDeselectionService.LayerChip msgLc = new MRSDeselectionService.LayerChip();
        msgLc.no = 1;
        msgLc.sfdcId = lc.id;
        msg.layerChipList.add(msgLc);

        MRSDeselectionService.PTRFMaskLayer msgLayer = new MRSDeselectionService.PTRFMaskLayer();
        msgLayer.no = 1;
        msgLayer.layerNumber = 'V0';
        msgLayer.revision = 'AZ';
        msg.ptrfMaskLayerList.add(msgLayer);
        
        MRSDeselectionService.PTRFChip msgChip = new MRSDeselectionService.PTRFChip();
        msgChip.no = 1;
        msgChip.chipName = 'PD1';
        msgChip.chipType = 'Prime Die';
        msg.ptrfChipList.add(msgChip);
        
        test.startTest();
        MRSDeselectionService.notification(msg);
        test.stopTest();
    }
    
    static testMethod void myUnitTest3() {
        mrs_layer_chip_association__c lc = [select id from mrs_layer_chip_association__c limit 1];
        
        MRSDeselectionService.Notification msg = new MRSDeselectionService.Notification();
        msg.messageId = 'id1234';
        msg.ptrfNumber = 'PTRF-20189-522';
        msg.timeStamp = system.now();
        msg.layerChipList = new List<MRSDeselectionService.LayerChip>();
        msg.ptrfMaskLayerList = new List<MRSDeselectionService.PTRFMaskLayer>();
        msg.ptrfChipList = new List<MRSDeselectionService.PTRFChip>();
        
        MRSDeselectionService.LayerChip msgLc = new MRSDeselectionService.LayerChip();
        msgLc.no = 1;
        msgLc.sfdcId = lc.id + 'X';
        msg.layerChipList.add(msgLc);

        MRSDeselectionService.PTRFMaskLayer msgLayer = new MRSDeselectionService.PTRFMaskLayer();
        msgLayer.no = 1;
        msgLayer.layerNumber = 'V0';
        msgLayer.revision = 'AZ';
        msg.ptrfMaskLayerList.add(msgLayer);
        
        MRSDeselectionService.PTRFChip msgChip = new MRSDeselectionService.PTRFChip();
        msgChip.no = 1;
        msgChip.chipName = 'PD1';
        msgChip.chipType = 'Prime Die';
        msg.ptrfChipList.add(msgChip);        
        MRSDeselectionService.notification(msg);
    }
    
    static testMethod void myUnitTest4() {
        MRSDeselectionService.notification(null);
    }
    
    static testMethod void myUnitTest5() {
        initialData2();
        mrs_layer_chip_association__c lc = [select id from mrs_layer_chip_association__c where ptrf__r.name = 'PTRF-MISSING' limit 1];
        
        MRSDeselectionService.Notification msg = new MRSDeselectionService.Notification();
        msg.messageId = 'id1234';
        msg.ptrfNumber = 'PTRF-20189-522';
        msg.timeStamp = system.now();
        msg.layerChipList = new List<MRSDeselectionService.LayerChip>();
        msg.ptrfMaskLayerList = new List<MRSDeselectionService.PTRFMaskLayer>();
        msg.ptrfChipList = new List<MRSDeselectionService.PTRFChip>();
        
        MRSDeselectionService.LayerChip msgLc = new MRSDeselectionService.LayerChip();
        msgLc.no = 1;
        msgLc.sfdcId = lc.id;
        msg.layerChipList.add(msgLc);

        MRSDeselectionService.PTRFMaskLayer msgLayer = new MRSDeselectionService.PTRFMaskLayer();
        msgLayer.no = 1;
        msgLayer.layerNumber = 'V11';
        msgLayer.revision = 'AZ';
        msg.ptrfMaskLayerList.add(msgLayer);
        
        MRSDeselectionService.PTRFChip msgChip = new MRSDeselectionService.PTRFChip();
        msgChip.no = 1;
        msgChip.chipName = 'MISSING_CHIP';
        msgChip.chipType = 'Prime Die';
        msg.ptrfChipList.add(msgChip);
        
        test.startTest();
        MRSDeselectionService.notification(msg);
        test.stopTest();
    }
    
    //this test method will trigger a dmlexception by sending duplicate chip
    static testMethod void myUnitTest6() {
        
        mrs_layer_chip_association__c lc = [select id from mrs_layer_chip_association__c limit 1];
        
        MRSDeselectionService.Notification msg = new MRSDeselectionService.Notification();
        msg.messageId = 'id1234';
        msg.ptrfNumber = 'PTRF-20189-522';
        msg.timeStamp = system.now();
        msg.layerChipList = new List<MRSDeselectionService.LayerChip>();
        msg.ptrfMaskLayerList = new List<MRSDeselectionService.PTRFMaskLayer>();
        msg.ptrfChipList = new List<MRSDeselectionService.PTRFChip>();
        
        MRSDeselectionService.LayerChip msgLc = new MRSDeselectionService.LayerChip();
        msgLc.no = 1;
        msgLc.sfdcId = lc.id;
        msg.layerChipList.add(msgLc);

        MRSDeselectionService.PTRFMaskLayer msgLayer = new MRSDeselectionService.PTRFMaskLayer();
        msgLayer.no = 1;
        msgLayer.layerNumber = 'V0';
        msgLayer.revision = 'AZ';
        msg.ptrfMaskLayerList.add(msgLayer);
        
        MRSDeselectionService.PTRFChip msgChip = new MRSDeselectionService.PTRFChip();
        msgChip.no = 1;
        msgChip.chipName = 'PD1';
        msgChip.chipType = 'Prime Die';
        msg.ptrfChipList.add(msgChip);
        
        MRSDeselectionService.PTRFChip msgChip2 = new MRSDeselectionService.PTRFChip();
        msgChip2.no = 2;
        msgChip2.chipName = 'PD1';
        msgChip2.chipType = 'Prime Die';
        msg.ptrfChipList.add(msgChip2);
        
        test.startTest();
        MRSDeselectionService.notification(msg);
        test.stopTest();
    }
    
    public static void initialData() {
                
        Mask_Set_Title__c mst = SwiftDataUtilityTest.createMST( 'ZIN789');
        insert mst;
        
        DRT__c drt1 = new DRT__c( Name='testFrame', Synced_with_Oracle_DB__c=false, DRT_Package_Sync__c=false, Status__c='Active', Mask_Set_Title__c = mst.Id );          
        insert drt1;
        
        PTRF__c ptrf1 = new PTRF__c( Name='PTRF-20189-522', Order_Type__c = 'testOrder1', Recticle_Type__c='Multi Layer Reticle (MLR)', 
            Customer_jobview__c='Gating Mask Release', MaskSetTitle__c = mst.id, Status__c = 'Perform Tapeout Options'
        );
        insert ptrf1;
        
        //insert mask layer
        Mask_Layer__c mask = new Mask_Layer__c(Name='V0',Mask_Layer_Number__c='V0',Mask_Layer_Rev__c='AZ',
            LogicalOperation__c='Foundry Std',LogicalOperationType__c='Foundry Std',Sort_Order__c=1,Tapeout__c=true,
            ptrf__c=ptrf1.Id
        );
        insert mask;
        
        //insert chip detail
        Chip_Detail__c chip = new Chip_Detail__c(Name='PD1',Tapeout__c=true,ptrf__c=ptrf1.Id);
        insert chip;
        
        DRT_PTRF_Association__c drtPtrfIns = new DRT_PTRF_Association__c( DRT__c = drt1.id, PTRF__c = ptrf1.id);
        //insert drtPtrfIns ;
        
        MRS__c mrs1 = new MRS__c( Full_Sync__c =true, Synced_with_Oracle_DB__c=false, MRS_Package_Sync__c=false, Mask_Set_Title__c=mst.Id);
        insert mrs1;
        
        MRS_Layer_Association__c mrsLayer1 = new MRS_Layer_Association__c( Name ='BV', Synced_with_Oracle_DB__c=false, Mask_Layer_Rev__c = 'AZ',
            Layer_Name__c = 'V0', Layer_Status__c = 'Not Ready', mrs__c = mrs1.id
        );
        insert mrslayer1;
        
        MRS_Layer_Association__c mrsLayer2 = new MRS_Layer_Association__c( Name ='C7', Synced_with_Oracle_DB__c=false, Mask_Layer_Rev__c = 'AZ',
            Layer_Name__c = 'V1', Layer_Status__c = 'Not Ready', mrs__c = mrs1.id
        );
        insert mrslayer2;   
        
        MRS_Chip_Details__c mrsChip1 = new MRS_Chip_Details__c( Name='PD1', Synced_with_Oracle_DB__c=false, mrs__c = mrs1.id);        
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
    
    
    
    
    public static void initialData2() {
                
        Mask_Set_Title__c mst = SwiftDataUtilityTest.createMST( 'ZIN7890');
        insert mst;
        
        DRT__c drt1 = new DRT__c( Name='testFrame', Synced_with_Oracle_DB__c=false, DRT_Package_Sync__c=false, Status__c='Active', Mask_Set_Title__c = mst.Id );          
        insert drt1;
        
        
        //reference in myUnitTest5()
        PTRF__c ptrf1 = new PTRF__c( Name='PTRF-MISSING', Order_Type__c = 'testOrder1', Recticle_Type__c='Multi Layer Reticle (MLR)', 
            Customer_jobview__c='Gating Mask Release', MaskSetTitle__c = mst.id, Status__c = 'Perform Tapeout Options'
        );
        insert ptrf1;
        
        //insert mask layer
        Mask_Layer__c mask = new Mask_Layer__c(Name='V0',Mask_Layer_Number__c='V0',Mask_Layer_Rev__c='AZ',
            LogicalOperation__c='Foundry Std',LogicalOperationType__c='Foundry Std',Sort_Order__c=1,Tapeout__c=true,
            ptrf__c=ptrf1.Id
        );
        insert mask;
        
        //insert chip detail
        Chip_Detail__c chip = new Chip_Detail__c(Name='PD1',Tapeout__c=true,ptrf__c=ptrf1.Id);
        insert chip;
        
        DRT_PTRF_Association__c drtPtrfIns = new DRT_PTRF_Association__c( DRT__c = drt1.id, PTRF__c = ptrf1.id);
        //insert drtPtrfIns ;
        
        MRS__c mrs1 = new MRS__c( Full_Sync__c =true, Synced_with_Oracle_DB__c=false, MRS_Package_Sync__c=false, Mask_Set_Title__c=mst.Id);
        insert mrs1;
        
        MRS_Layer_Association__c mrsLayer1 = new MRS_Layer_Association__c( Name ='BV', Synced_with_Oracle_DB__c=false, Mask_Layer_Rev__c = 'AZ',
            Layer_Name__c = 'V0', Layer_Status__c = 'Not Ready', mrs__c = mrs1.id
        );
        insert mrslayer1;
        
        MRS_Layer_Association__c mrsLayer2 = new MRS_Layer_Association__c( Name ='C7', Synced_with_Oracle_DB__c=false, Mask_Layer_Rev__c = 'AZ',
            Layer_Name__c = 'V1', Layer_Status__c = 'Not Ready', mrs__c = mrs1.id
        );
        insert mrslayer2;   
        
        MRS_Chip_Details__c mrsChip1 = new MRS_Chip_Details__c( Name='PD1', Synced_with_Oracle_DB__c=false, mrs__c = mrs1.id);        
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