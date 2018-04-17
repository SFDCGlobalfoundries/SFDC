@isTest(SeeAllData=false)

private class TECNHandlerUtilityTest {
    
    
    @testSetup static void setupTestData() {
        //DataUtilTest.loadEnvironmentVariables();
        //Customer_Number__c cnc = new Customer_Number__c();
        //cnc.name = 'Update Customer No';
        //cnc.Customer_No__c = 11155;
        //insert cnc;
        
        DataUtilTest.loadEnvironmentVariables();
        
        init();
    }
    
    /*Test method for trigger Mask_Layer_SWIFT_AUPD*/
    public static testMethod void Mask_Layer_SWIFT_AUPD_trigger_test() {
        ptrf__c ptrf = [select id from ptrf__c limit 1];
        
        Mask_Layer__c maskLayer1 = new Mask_Layer__c(
            Name = 'V1',
            Mask_Layer_Number__c = 'V1',
            ptrf__c = ptrf.id,
            Tapeout__c = true,
            
            Mask_Layer_Rev__c = 'BZ',
            LogicalOperation__c = 'TECN-134;TECN-mrs;TECN-drt',
            LogicalOperationType__c = 'TECN'
        );
    }
    
    //liftOffUnUsedTECN(list<Mask_Layer__c> listMaskLayer)
    public static testMethod void liftOffUnUsedTECN_test1() {
        list<Mask_Layer__c> listMaskLayer = [
            select id,rom_code__c,PTRF__r.MaskSetTitle__c,Mask_Layer_Number__c,ptrf__c,
                Mask_Layer_Rev__c,PTRF__r.Tech_Geo_Value__c,LogicalOperation__c,LogicalOperationType__c
            from Mask_Layer__c
            where ptrf__r.name = 'PTRF-20148-76-A'
        ];
        
        Test.StartTest();
        TECNHandlerUtility.liftOffUnUsedTECN(listMaskLayer);
        Test.StopTest();
    }
    
    public static testMethod void liftOffUnUsedTECN_test2() {
        
        //==========
        list<mrs_layer_association__c> tempMap = [
            select id
            from mrs_layer_association__c
            limit 3
        ];
        
        for(mrs_layer_association__c m: tempMap) {
           m.rom_code__c = '003';
        }
        
        update tempMap;
        
        //==========
        list<Mask_Layer__c> listMaskLayer = [
            select id,rom_code__c,PTRF__r.MaskSetTitle__c,Mask_Layer_Number__c,ptrf__c,
                Mask_Layer_Rev__c,PTRF__r.Tech_Geo_Value__c,LogicalOperation__c,LogicalOperationType__c
            from Mask_Layer__c
            limit 3
        ];
        
        for(Mask_Layer__c m: listMaskLayer) {
           m.rom_code__c = '003';
        }
        
        update listMaskLayer;
        listMaskLayer.remove(0);
        //==========
        
        Test.StartTest();
        TECNHandlerUtility.liftOffUnUsedTECN(listMaskLayer);
        Test.StopTest();
    }
    
    public static testMethod void liftOffUnUsedTECN_test3() {
        
        list<ptrf__c> ptrfToRemove = [
            select id 
            from ptrf__c
            where name in ('PTRF-20148-76-B','PTRF-20148-76-C')
        ];
        
        list<mrs_layer_chip_association__c> layerCHipsToDelete = [
            select id
            from mrs_layer_chip_association__c
            where ptrf__c IN :ptrfToRemove
        ];
        delete layerCHipsToDelete;
        
        list<Mask_Layer__c> listMaskLayerToDelete = [
            select id
            from Mask_Layer__c
            where ptrf__c IN :ptrfToRemove
        ];
        delete listMaskLayerToDelete;
        
        delete ptrfToRemove;
        
        list<Mask_Layer__c> listMaskLayer = [
            select id,rom_code__c,PTRF__r.MaskSetTitle__c,Mask_Layer_Number__c,ptrf__c,
                Mask_Layer_Rev__c,PTRF__r.Tech_Geo_Value__c,LogicalOperation__c,LogicalOperationType__c
            from Mask_Layer__c
            where ptrf__r.name = 'PTRF-20148-76-A'
        ];
        
        Test.StartTest();
        TECNHandlerUtility.liftOffUnUsedTECN(listMaskLayer);
        Test.StopTest();
    }
    
    public static testMethod void retrieveMaskLayersById_test4() {
        map<id, Mask_Layer__c> mapTemp = new map<id, Mask_Layer__c>([
            select id
            from Mask_Layer__c
            limit 1
        ]);
        Test.startTest();
        TECNHandlerUtility.retrieveMaskLayersById(mapTemp.keySet());
        Test.stopTest();
    }
    
    public static testMethod void retrieveMaskLayersByPtrfId_test5() {
        map<id, ptrf__c> mapTemp = new map<id, ptrf__c>([
            select id 
            from ptrf__c
            where name in ('PTRF-20148-76-B','PTRF-20148-76-C')
        ]);
        
        list<Id> ptrfIdList = new list<Id>();
        ptrfIdList.addAll(mapTemp.keySet());
        Test.startTest();
        TECNHandlerUtility.retrieveMaskLayersByPtrfId(ptrfIdList);
        Test.stopTest();
    }
    
    public static testMethod void liftOffUnUsedTECN_future_test6() {
        try { TECNHandlerUtility.liftOffUnUsedTECN_future(new set<Id>(), null); } catch(Exception testNoCatch){}
        try { TECNHandlerUtility.liftOffUnUsedTECN_future(null, new list<Id>()); } catch(Exception testNoCatch){}
    }
    
    public static testMethod void liftOffUnUsedTECN_fromVoidLayerChip_future_test7() {
        //==========
        list<mrs_layer_association__c> tempMap = [
            select id
            from mrs_layer_association__c
            limit 3
        ];
        
        for(mrs_layer_association__c m: tempMap) {
           m.rom_code__c = '003';
        }
        
        update tempMap;
        //==========
        list<Mask_Layer__c> listMaskLayer = [
            select id,rom_code__c,PTRF__r.MaskSetTitle__c,Mask_Layer_Number__c,ptrf__c,
                Mask_Layer_Rev__c,PTRF__r.Tech_Geo_Value__c,LogicalOperation__c,LogicalOperationType__c
            from Mask_Layer__c
            limit 3
        ];
        
        for(Mask_Layer__c m: listMaskLayer) {
           m.rom_code__c = '003';
        }
        
        update listMaskLayer;
        //==========
        list<MRS_Layer_Chip_Association__c> listVoidLayerChip = [
            select id,layer__c
            from mrs_layer_chip_association__c
            where ptrf__r.name = 'PTRF-20148-76-A'
        ];
        listVoidLayerChip[0].layer_chip_status__c = 'Void';
        update listVoidLayerChip;
        
        
        set<Id> layerChipIdSet = new set<id>();
        layerChipIdSet.add(listVoidLayerChip[0].id);
        
        set<Id> layerIdSet = new set<id>();
        layerIdSet.add(listVoidLayerChip[0].layer__c);
        
        Test.StartTest();
        TECNHandlerUtility.liftOffUnUsedTECN_fromVoidLayerChip_future(layerChipIdSet, layerIdSet);
        Test.StopTest();
    }  
    
    /*This method is also covered MRS_Layer_Chip_Association_SWIFT_AUPD trigger*/
    public static testMethod void liftOffUnUsedTECN_fromVoidLayerChip_future_test8() {
        list<MRS_Layer_Chip_Association__c> listVoidLayerChip = [
            select id,layer__c
            from mrs_layer_chip_association__c
            where ptrf__r.name = 'PTRF-20148-76-A'
        ];
        listVoidLayerChip[0].layer_chip_status__c = 'Void';
        update listVoidLayerChip;
        
        
        set<Id> layerChipIdSet = new set<id>();
        layerChipIdSet.add(listVoidLayerChip[0].id);
        
        set<Id> layerIdSet = new set<id>();
        layerIdSet.add(listVoidLayerChip[0].layer__c);
        
        Test.StartTest();
        TECNHandlerUtility.liftOffUnUsedTECN_fromVoidLayerChip_future(layerChipIdSet, layerIdSet);
        Test.StopTest();
    }
    
    /*to be called in @testSetup method*/
    public static void init() {
        //insert mask set title 
        Mask_Set_Title__c mst = SwiftDataUtilityTest.createMST('TEST12');
        insert mst;
        
        list<ptrf__c> ptrfToInsert = new list<ptrf__c>();
        //1. PTRF-20148-76-A: layer V1-BZ, TECN = TECN-134;TECN-mrs;TECN-drt
        PTRF__c ptrf1 = new PTRF__c( 
            Name='PTRF-20148-76-A', 
            Tech_Geo_Value__c = '0.022',
            Order_Type__c = 'New Prototype', 
            Recticle_Type__c='Single Layer Reticle (SLR)', 
            Customer_jobview__c='Gating Mask Release', 
            MaskSetTitle__c = mst.id, 
            Status__c = 'Perform Tapeout Options'
        );
        
        ptrfToInsert.add(ptrf1);
        //insert ptrf1;
        
        //2. PTRF-20148-76-B: layer V1-BZ, TECN = TECN-134
        PTRF__c ptrf2 = new PTRF__c( 
            Name='PTRF-20148-76-B', 
            Tech_Geo_Value__c = '0.022',
            Order_Type__c = 'New Prototype', 
            Recticle_Type__c='Single Layer Reticle (SLR)', 
            Customer_jobview__c='Gating Mask Release', 
            MaskSetTitle__c = mst.id, 
            Status__c = 'Perform Tapeout Options'
        );
        
        ptrfToInsert.add(ptrf2);
        //insert ptrf2;
        
        //3. PTRF-20148-76-C: layer V1-BZ, TECN = TECN-drt
        PTRF__c ptrf3 = new PTRF__c( 
            Name='PTRF-20148-76-C', 
            Tech_Geo_Value__c = '0.022',
            Order_Type__c = 'New Prototype', 
            Recticle_Type__c='Single Layer Reticle (SLR)', 
            Customer_jobview__c='Gating Mask Release', 
            MaskSetTitle__c = mst.id, 
            Status__c = 'Perform Tapeout Options'
        );
        
        ptrfToInsert.add(ptrf3);
        insert ptrfToInsert;
        
        list<Mask_Layer__c> maskLayersToInsert = new list<Mask_Layer__c>();
        
        Mask_Layer__c maskLayer1 = new Mask_Layer__c(
            Name = 'V1',
            Mask_Layer_Number__c = 'V1',
            ptrf__c = ptrf1.id,
            Tapeout__c = true,
            
            Mask_Layer_Rev__c = 'BZ',
            LogicalOperation__c = 'TECN-134;TECN-mrs;TECN-drt',
            LogicalOperationType__c = 'TECN'
        );
        
        maskLayersToInsert.add(maskLayer1);
        
        Mask_Layer__c maskLayer2 = new Mask_Layer__c(
            Name = 'V1',
            Mask_Layer_Number__c = 'V1',
            ptrf__c = ptrf2.id,
            Tapeout__c = true,
            
            Mask_Layer_Rev__c = 'BZ',
            LogicalOperation__c = 'TECN-134',
            LogicalOperationType__c = 'TECN'
        );
        
        maskLayersToInsert.add(maskLayer2);
        
        Mask_Layer__c maskLayer3 = new Mask_Layer__c(
            Name = 'V1',
            Mask_Layer_Number__c = 'V1',
            ptrf__c = ptrf3.id,
            Tapeout__c = true,
            
            Mask_Layer_Rev__c = 'BZ',
            LogicalOperation__c = 'TECN-drt',
            LogicalOperationType__c = 'TECN'
        );
        
        maskLayersToInsert.add(maskLayer3);
        insert maskLayersToInsert;        
        
        MRS__c mrs1 = new MRS__c( Full_Sync__c =true, Synced_with_Oracle_DB__c=false, MRS_Package_Sync__c=false, Mask_Set_Title__c=mst.Id);
        insert mrs1;
        
        MRS_Layer_Association__c mrsLayer1 = new MRS_Layer_Association__c( 
            Name ='V1', Mask_Layer_Rev__c = 'BZ',
            LogicalOperation__c = 'TECN-134;TECN-mrs;TECN-drt',
            LogicalOperationType__c = 'TECN',
            Layer_Unique_Identifier__c = mst.id + 'V1BZ0.022',
            
            Synced_with_Oracle_DB__c=false, 
            Layer_Name__c = 'V1', Layer_Status__c = 'Not Ready', mrs__c = mrs1.id
        );
        insert mrslayer1;
        
        list<MRS_Chip_Details__c> chipDetailsToInsert = new list<MRS_Chip_Details__c>();
        MRS_Chip_Details__c mrsChip1 = new MRS_Chip_Details__c( Name='CHIP1', Synced_with_Oracle_DB__c=false, mrs__c = mrs1.id);
        chipDetailsToInsert.add(mrsChip1);
        MRS_Chip_Details__c mrsChip2 = new MRS_Chip_Details__c( Name='CHIP2', Synced_with_Oracle_DB__c=false, mrs__c = mrs1.id);
        chipDetailsToInsert.add(mrsChip2);
        MRS_Chip_Details__c mrsChip3 = new MRS_Chip_Details__c( Name='CHIP3', Synced_with_Oracle_DB__c=false, mrs__c = mrs1.id);
        chipDetailsToInsert.add(mrsChip3);        
        
        insert chipDetailsToInsert;

        list<MRS_Layer_Chip_Association__c> layerChipToInsert = new list<MRS_Layer_Chip_Association__c>();
        
        MRS_Layer_Chip_Association__c layerChip1 = new MRS_Layer_Chip_Association__c(
            Layer__c=mrsLayer1.Id, 
            PTRF__c=ptrf1.Id,    
            Chip__c=mrsChip1.Id,       
            
            Synced_with_Oracle_DB__c=false, Send_Frame_Data__c = 'Not Done', Send_Prime_Data__c = 'Not Done', 
            Foundry_GDSOUT_Review__c = 'Not Ready',   GlobalShuttle_MEBES_Jobview__c= 'Not Ready',
            TDTI_MPW_MEBES_Jobview__c = 'Not Ready', MDP_MEBES_Jobview__c = 'Not Ready', Tapeout_Centre_MEBES_Jobview__c = 'Not Ready',         
            Tapeout_Applications_MEBES_Jobview__c = 'Not Ready', Foundry_MEBES_Jobview__c = 'Not Ready', Customer_MEBES_Jobview__c = 'Not Ready',
            Frame_MEBES_Received__c = 'Not Done', Prime_MEBES_Received__c = 'Not Done', Mask_Set_Title_Id__c = mst.id, PTRF_Or_DRT__c = 'PTRF'
        );
        
        layerChipToInsert.add(layerChip1);
        
        MRS_Layer_Chip_Association__c layerChip2 = new MRS_Layer_Chip_Association__c(
            Layer__c=mrsLayer1.Id, 
            PTRF__c=ptrf2.Id,    
            Chip__c=mrsChip2.Id,       
            
            Synced_with_Oracle_DB__c=false, Send_Frame_Data__c = 'Not Done', Send_Prime_Data__c = 'Not Done', 
            Foundry_GDSOUT_Review__c = 'Not Ready',   GlobalShuttle_MEBES_Jobview__c= 'Not Ready',
            TDTI_MPW_MEBES_Jobview__c = 'Not Ready', MDP_MEBES_Jobview__c = 'Not Ready', Tapeout_Centre_MEBES_Jobview__c = 'Not Ready',         
            Tapeout_Applications_MEBES_Jobview__c = 'Not Ready', Foundry_MEBES_Jobview__c = 'Not Ready', Customer_MEBES_Jobview__c = 'Not Ready',
            Frame_MEBES_Received__c = 'Not Done', Prime_MEBES_Received__c = 'Not Done', Mask_Set_Title_Id__c = mst.id, PTRF_Or_DRT__c = 'PTRF'
        );
        
        layerChipToInsert.add(layerChip2);
        
        MRS_Layer_Chip_Association__c layerChip3 = new MRS_Layer_Chip_Association__c(
            Layer__c=mrsLayer1.Id, 
            PTRF__c=ptrf3.Id,    
            Chip__c=mrsChip3.Id,       
            
            Synced_with_Oracle_DB__c=false, Send_Frame_Data__c = 'Not Done', Send_Prime_Data__c = 'Not Done', 
            Foundry_GDSOUT_Review__c = 'Not Ready',   GlobalShuttle_MEBES_Jobview__c= 'Not Ready',
            TDTI_MPW_MEBES_Jobview__c = 'Not Ready', MDP_MEBES_Jobview__c = 'Not Ready', Tapeout_Centre_MEBES_Jobview__c = 'Not Ready',         
            Tapeout_Applications_MEBES_Jobview__c = 'Not Ready', Foundry_MEBES_Jobview__c = 'Not Ready', Customer_MEBES_Jobview__c = 'Not Ready',
            Frame_MEBES_Received__c = 'Not Done', Prime_MEBES_Received__c = 'Not Done', Mask_Set_Title_Id__c = mst.id, PTRF_Or_DRT__c = 'PTRF'
        );
        
        layerChipToInsert.add(layerChip3);
        
        insert layerChipToInsert;
    }
       
    
    
    //===================================================================
    static testMethod void releaseMRSLayersForReleasedTECNs_test() {
        SwiftDataUtilityTest.customSystemData();      
        Profile sysAdminProfile = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User thisUser = [SELECT Id FROM User WHERE ProfileId =:sysAdminProfile.Id and isActive=true limit 1];
        System.runAs (thisUser) { 
            Mask_Set_Title__c objMST = SwiftDataUtilityTest.createMST('MST001');
            insert objMST;
            MRS__c objMRS = new MRS__c(Mask_Set_Title__c=objMST.Id);
            insert objMRS;
            List<MRS_Layer_Association__c> listMRSLA = new List<MRS_Layer_Association__c>();
            MRS_Layer_Association__c objMRSLA1 = new MRS_Layer_Association__c(MRS__c=objMRS.Id,Layer_Status__c='Pending Foundry Release',Layer_Status_Text__c='Pending Foundry Release',LogicalOperation__c='TECN008215',LogicalOperationType__c='TECN');
            MRS_Layer_Association__c objMRSLA2 = new MRS_Layer_Association__c(MRS__c=objMRS.Id,Layer_Status__c='Pending Foundry Release',Layer_Status_Text__c='Pending Foundry Release',LogicalOperation__c='TECN008215;TECN008216',LogicalOperationType__c='TECN');
            listMRSLA.add(objMRSLA1);
            listMRSLA.add(objMRSLA2);
            insert listMRSLA;
            List<TECN__c> listTECN = new List<TECN__c>();
            TECN__c objTECN0 = new TECN__c(TECN_No__c='TECN00821601',TECN_Status__c='In Progress',Related_TECN_No__c='TECN008216');      
            insert objTECN0;
            TECN__c objTECN1 = new TECN__c(TECN_No__c='TECN00821501',TECN_Status__c='Released',Related_TECN_No__c='TECN008215');
            TECN__c objTECN2 = new TECN__c(TECN_No__c='TECN00821502',TECN_Status__c='Released',Related_TECN_No__c='TECN008215'); 
            TECN__c objTECN3 = new TECN__c(TECN_No__c='TECN00821602',TECN_Status__c='In Progress',Related_TECN_No__c='TECN008216');          
            listTECN.add(objTECN1);
            listTECN.add(objTECN2);
            listTECN.add(objTECN3);
            test.startTest();
            insert listTECN;
            MRS_Layer_Association__c objMRSLAModified = [Select Layer_Status__c from MRS_Layer_Association__c where Id=:objMRSLA1.Id];  
            system.assertEquals(objMRSLAModified.Layer_Status__c,'Released');
            objTECN0.TECN_Status__c='Released';
            update objTECN0;
            objTECN3.TECN_Status__c='Released';
            update objTECN3;
            test.stopTest();
        }
    }
}