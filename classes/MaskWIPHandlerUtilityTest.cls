@isTest(SeeAllData=false)
private class MaskWIPHandlerUtilityTest {
    
    @testSetup
    static void init() {
        SwiftDataUtilityTest.customSystemData();
        initData();
    }

    static testMethod void myUnitTest() {
        Profile sysAdminProfile = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User thisUser = [SELECT Id FROM User WHERE ProfileId =:sysAdminProfile.Id and isActive=true limit 1];
        list<mrs__c> lstToDelete = [select id from mrs__c];
        delete lstToDelete;
        list<Mask_Set_Title__c> lstToDelete2 = [select id from Mask_Set_Title__c];
        delete lstToDelete2;
        list<Pairing_Table__c> lstToDelete3  = [select id from Pairing_Table__c];
        delete lstToDelete3;
        list<Mask_WIP__c> lstToDelete4  = [select id from Mask_WIP__c];
        delete lstToDelete4;
        System.runAs (thisUser) {            
            Mask_Set_Title__c objMST = new Mask_Set_Title__c(Name='MST001',Reticle_Type__c ='Multi Layer Reticle (MLR)');
            insert objMST;
            MRS__c objMRS = new MRS__c(Mask_Set_Title__c=objMST.Id);
            insert objMRS;
            List<MRS_Layer_Association__c> listMRSLA = new List<MRS_Layer_Association__c>();
            MRS_Layer_Association__c objMRSLA0 = new MRS_Layer_Association__c(MRS__c=objMRS.Id,Name='RX',Mask_Layer_Rev__c='AZ',Layer_Status__c='Released');
            MRS_Layer_Association__c objMRSLA1 = new MRS_Layer_Association__c(MRS__c=objMRS.Id,Name='RX',Mask_Layer_Rev__c='AZ',ROM_Code__c='123',Layer_Status__c='Released');
            MRS_Layer_Association__c objMRSLA2 = new MRS_Layer_Association__c(MRS__c=objMRS.Id,Name='RY',Mask_Layer_Rev__c='AY',ROM_Code__c='123',Layer_Status__c='Released');
            MRS_Layer_Association__c objMRSLA3 = new MRS_Layer_Association__c(MRS__c=objMRS.Id,Name='RY',Mask_Layer_Rev__c='AY',ROM_Code__c='123',Layer_Status__c='Hold',Tech_Geo__c='0.019UM');
            MRS_Layer_Association__c objMRSLA4 = new MRS_Layer_Association__c(MRS__c=objMRS.Id,Name='SX',Mask_Layer_Rev__c='AC',ROM_Code__c='531',Layer_Status__c='Released',Generated_Mask_Title__c='MST001-SXAC');
            MRS_Layer_Association__c objMRSLA5 = new MRS_Layer_Association__c(MRS__c=objMRS.Id,Name='SX',Mask_Layer_Rev__c='AC',ROM_Code__c='531',Layer_Status__c='Hold',Generated_Mask_Title__c='MST001-SXAC',Tech_Geo__c='0.019UM');
            MRS_Layer_Association__c objMRSLA6 = new MRS_Layer_Association__c(MRS__c=objMRS.Id,Name='SX',Mask_Layer_Rev__c='AC',Layer_Status__c='Hold',Generated_Mask_Title__c='MST001-SXAC',Tech_Geo__c='0.019UM');
            listMRSLA.add(objMRSLA0);
            listMRSLA.add(objMRSLA1);
            listMRSLA.add(objMRSLA2);
            listMRSLA.add(objMRSLA3);
            listMRSLA.add(objMRSLA4);
            listMRSLA.add(objMRSLA5);
            listMRSLA.add(objMRSLA6);
            insert listMRSLA;
            Pairing_Table__c objPT = new Pairing_Table__c(Name='PT1',Mask_Set_Title__c=objMST.Id,Mask_Title__c='MST001-RXAZ',Image1__c='RXAZ123',Image2__c='RYAY123',Image3__c='SXBZ',Image4__c='TXDZ',Mask_Set_Title_Text__c='MST001');
            insert objPT;
            List<Mask_WIP__c> listMWIP = new List<Mask_WIP__c>();
            Mask_WIP__c objMWIP1 = new Mask_WIP__c(Name='MWIP1',Mask_Set_Title__c=objMST.Id,Status__c='Completed',Mask_Title__c='MST001-RXAZV1N1',Mask_Set_Title_Text__c='MST001');
            Mask_WIP__c objMWIP2 = new Mask_WIP__c(Name='MWIP2',Mask_Set_Title__c=objMST.Id,Status__c='Completed',Mask_Title__c='MST002-RXAZV1N1',Mask_Set_Title_Text__c='MST002');
            Mask_WIP__c objMWIP3 = new Mask_WIP__c(Name='MWIP3',Mask_Set_Title__c=objMST.Id,Status__c='None',Mask_Title__c='MST001-SXACV1N1',Mask_Set_Title_Text__c='MST001');
            listMWIP.add(objMWIP1);
            listMWIP.add(objMWIP2);
            listMWIP.add(objMWIP3);
            test.starttest();
            insert listMWIP;
            objMWIP3.Status__c='Completed';
            update objMWIP3;
            test.stopTest();
        }
    }
    
    static testMethod void test_validatePairingTableToShipMRSLayer() {
        list<Mask_WIP__c> listMaskWIPs = [
            select id,name,mask_set_title__c,status__c,mask_title__c,mask_set_title_text__c,Shipped_Date__c
            from Mask_WIP__c 
            where Name IN ('MWIP1','MWIP2','MWIP3','MST001-CKAZQKMZ','MST001-RMBZQKMZ','MST001-RKAZQKMZ')
        ];
        
        MaskWIPHandlerUtility.validatePairingTableToShipMRSLayer(listMaskWIPs);
    }
    
    static testMethod void test_sendEmailToTapeoutCentreForHoldLayers() {
        
        EmailTemplate et=[Select id,Subject,Body,HtmlValue from EmailTemplate where DeveloperName=:'Swift_Hold_Mask_Layer_For_Shipped_Mask_WIP'];
        et.Body = et.HtmlValue;
        update et;
        
        test.startTest();
        list<MRS_Layer_Association__c> lstLayers = [
            select Id,LogicalOperation__c,Mask_Set_Title_Name__c,Layer_Status__c,Name,Mask_Layer_Rev__c,
                    ROM_Code__c,Generated_Mask_Title__c,Tech_Geo__c,MRS__r.Mask_Set_Title__r.Name,tech_geo_int__c
            from MRS_Layer_Association__c
            where mrs__r.Mask_Set_Title__r.Name = 'MST001'
            limit 1
        ];
        map<String,MRS_Layer_Association__c> mapMaskLayersInHoldState = new map<String,MRS_Layer_Association__c>();
        for(MRS_Layer_Association__c objMRSLA: lstLayers) {
            String layerCombo;
            if(objMRSLA.ROM_Code__c!=null && objMRSLA.ROM_Code__c!='####' && objMRSLA.ROM_Code__c!='null' && objMRSLA.ROM_Code__c!='NULL'){
                layerCombo= objMRSLA.Name+objMRSLA.Mask_Layer_Rev__c+objMRSLA.ROM_Code__c;
            }else{
                layerCombo= objMRSLA.Name+objMRSLA.Mask_Layer_Rev__c;   
            }
            mapMaskLayersInHoldState.put(layerCombo, objMRSLA);
        }
        
        MaskWIPHandlerUtility.sendEmailToTapeoutCentreForHoldLayers(mapMaskLayersInHoldState);
        test.stopTest();
    }
    
    //if(objMRSLA.ROM_Code__c!=null && objMRSLA.ROM_Code__c!='####' && objMRSLA.ROM_Code__c!='null' && objMRSLA.ROM_Code__c!='NULL'){
      //              layerCombo= objMRSLA.Name+objMRSLA.Mask_Layer_Rev__c+objMRSLA.ROM_Code__c;
        //        }else{
          //          layerCombo= objMRSLA.Name+objMRSLA.Mask_Layer_Rev__c;
            //    }
    
    static void initData() {
        Mask_Set_Title__c objMST = new Mask_Set_Title__c(Name='MST001',Reticle_Type__c ='Multi Layer Reticle (MLR)');
        insert objMST;
        
        PTRF__c ptrf1 = new PTRF__c( Name='PTRF-20189-522', Order_Type__c = 'testOrder1', Recticle_Type__c='Multi Layer Reticle (MLR)', 
                Customer_jobview__c='Gating Mask Release', MaskSetTitle__c = objMST.id, Status__c = 'Perform Tapeout Options'
            );
            insert ptrf1;
            
        
        MRS__c objMRS = new MRS__c(Mask_Set_Title__c=objMST.Id);
        insert objMRS;
        List<MRS_Layer_Association__c> listMRSLA = new List<MRS_Layer_Association__c>();
        
        MRS_Layer_Association__c objMRSLA0 = new MRS_Layer_Association__c(MRS__c=objMRS.Id,Name='RX',Mask_Layer_Rev__c='AZ',Layer_Status__c='Released',Tech_Geo__c='0.020UM');
        MRS_Layer_Association__c objMRSLA1 = new MRS_Layer_Association__c(MRS__c=objMRS.Id,Name='RX',Mask_Layer_Rev__c='AZ',ROM_Code__c='123',Layer_Status__c='Released',Tech_Geo__c='0.028UM');
        MRS_Layer_Association__c objMRSLA2 = new MRS_Layer_Association__c(MRS__c=objMRS.Id,Name='RY',Mask_Layer_Rev__c='AY',ROM_Code__c='123',Layer_Status__c='Released',Tech_Geo__c='0.020UM');
        MRS_Layer_Association__c objMRSLA3 = new MRS_Layer_Association__c(MRS__c=objMRS.Id,Name='RY',Mask_Layer_Rev__c='AY',ROM_Code__c='123',Layer_Status__c='Hold',Tech_Geo__c='0.020UM');
        MRS_Layer_Association__c objMRSLA4 = new MRS_Layer_Association__c(MRS__c=objMRS.Id,Name='SX',Mask_Layer_Rev__c='AC',ROM_Code__c='531',Layer_Status__c='Released',Generated_Mask_Title__c='MST001-SXAC',Tech_Geo__c='0.020UM');
        MRS_Layer_Association__c objMRSLA5 = new MRS_Layer_Association__c(MRS__c=objMRS.Id,Name='SX',Mask_Layer_Rev__c='AC',ROM_Code__c='531',Layer_Status__c='Hold',Generated_Mask_Title__c='MST001-SXAC',Tech_Geo__c='0.019UM');
        MRS_Layer_Association__c objMRSLA6 = new MRS_Layer_Association__c(MRS__c=objMRS.Id,Name='SX',Mask_Layer_Rev__c='AC',Layer_Status__c='Hold',Generated_Mask_Title__c='MST001-SXAC',Tech_Geo__c='0.028UM');  
        
        
        
        MRS_Layer_Association__c objMRSLA_7 = new MRS_Layer_Association__c(MRS__c=objMRS.Id,Name='RK',Mask_Layer_Rev__c='AZ',Layer_Status__c='In Progress',Generated_Mask_Title__c='MST001-RKAZQKMZ',Tech_Geo__c='0.020UM');
        MRS_Layer_Association__c objMRSLA_8 = new MRS_Layer_Association__c(MRS__c=objMRS.Id,Name='CK',Mask_Layer_Rev__c='AZ',Layer_Status__c='In Progress',Generated_Mask_Title__c='MST001CKAZ',Tech_Geo__c='0.020UM');
        
        MRS_Layer_Association__c objMRSLA_9 = new MRS_Layer_Association__c(MRS__c=objMRS.Id,Name='RM',Mask_Layer_Rev__c='BZ',Layer_Status__c='In Progress',Tech_Geo__c='0.020UM');
        
        listMRSLA.add(objMRSLA0);
        listMRSLA.add(objMRSLA1);
        listMRSLA.add(objMRSLA2);
        listMRSLA.add(objMRSLA3);
        listMRSLA.add(objMRSLA4);
        listMRSLA.add(objMRSLA5);
        listMRSLA.add(objMRSLA6);
        listMRSLA.add(objMRSLA_7);
        listMRSLA.add(objMRSLA_8);
        listMRSLA.add(objMRSLA_9);
        insert listMRSLA;
        
        MRS_Chip_Details__c mrsChip1 = new MRS_Chip_Details__c( Name='PD123', Synced_with_Oracle_DB__c=false, mrs__c = objMRS.id);        
            insert mrsChip1; 
            
        MRS_Layer_Chip_Association__c layerChip1 = new MRS_Layer_Chip_Association__c(
            Synced_with_Oracle_DB__c=false, Send_Frame_Data__c = 'Not Done', Send_Prime_Data__c = 'Not Done', /*DRT__c=drt1.id,*/
            
            Layer__c=objMRSLA_7.Id, 
            
            Foundry_GDSOUT_Review__c = 'Not Ready', Chip__c=mrsChip1.Id, PTRF__c=ptrf1.Id, GlobalShuttle_MEBES_Jobview__c= 'Not Ready',
            TDTI_MPW_MEBES_Jobview__c = 'Not Ready', MDP_MEBES_Jobview__c = 'Not Ready', Tapeout_Centre_MEBES_Jobview__c = 'Not Ready',         
            Tapeout_Applications_MEBES_Jobview__c = 'Not Ready', Foundry_MEBES_Jobview__c = 'Not Ready', Customer_MEBES_Jobview__c = 'Not Ready',
            Frame_MEBES_Received__c = 'Done', Prime_MEBES_Received__c = 'Not Done', Mask_Set_Title_Id__c = objMST.id, PTRF_Or_DRT__c = 'PTRF',
            layer_chip_status__c = 'In Progress'
        );
        list<MRS_Layer_Chip_Association__c> listlChip = new list<MRS_Layer_Chip_Association__c>();
        listlChip.add(layerChip1);
        
        MRS_Layer_Chip_Association__c layerChip2 = new MRS_Layer_Chip_Association__c(
            Synced_with_Oracle_DB__c=false, Send_Frame_Data__c = 'Not Done', Send_Prime_Data__c = 'Not Done', /*DRT__c=drt1.id,*/
            
            Layer__c=objMRSLA_8.Id, 
            
            Foundry_GDSOUT_Review__c = 'Not Ready', Chip__c=mrsChip1.Id, PTRF__c=ptrf1.Id, GlobalShuttle_MEBES_Jobview__c= 'Not Ready',
            TDTI_MPW_MEBES_Jobview__c = 'Not Ready', MDP_MEBES_Jobview__c = 'Not Ready', Tapeout_Centre_MEBES_Jobview__c = 'Not Ready',         
            Tapeout_Applications_MEBES_Jobview__c = 'Not Ready', Foundry_MEBES_Jobview__c = 'Not Ready', Customer_MEBES_Jobview__c = 'Not Ready',
            Frame_MEBES_Received__c = 'Done', Prime_MEBES_Received__c = 'Not Done', Mask_Set_Title_Id__c = objMST.id, PTRF_Or_DRT__c = 'PTRF',
            
            layer_chip_status__c = 'In Progress'
        );
        listlChip.add(layerChip2);
        
        
        MRS_Layer_Chip_Association__c layerChip3 = new MRS_Layer_Chip_Association__c(
            Synced_with_Oracle_DB__c=false, Send_Frame_Data__c = 'Not Done', Send_Prime_Data__c = 'Not Done', /*DRT__c=drt1.id,*/
            
            Layer__c=objMRSLA_9.Id, 
            
            Foundry_GDSOUT_Review__c = 'Not Ready', Chip__c=mrsChip1.Id, PTRF__c=ptrf1.Id, GlobalShuttle_MEBES_Jobview__c= 'Not Ready',
            TDTI_MPW_MEBES_Jobview__c = 'Not Ready', MDP_MEBES_Jobview__c = 'Not Ready', Tapeout_Centre_MEBES_Jobview__c = 'Not Ready',         
            Tapeout_Applications_MEBES_Jobview__c = 'Not Ready', Foundry_MEBES_Jobview__c = 'Not Ready', Customer_MEBES_Jobview__c = 'Not Ready',
            Frame_MEBES_Received__c = 'Done', Prime_MEBES_Received__c = 'Not Done', Mask_Set_Title_Id__c = objMST.id, PTRF_Or_DRT__c = 'PTRF',
            layer_chip_status__c = 'In Progress'
        );
        listlChip.add(layerChip3);
        insert listlChip;
        
        Pairing_Table__c objPT = new Pairing_Table__c(Name='PT1',Mask_Set_Title__c=objMST.Id,Mask_Title__c='MST001-RXAZ',Image1__c='RXAZ123',Image2__c='RYAY123',Image3__c='SXBZ',Image4__c='TXDZ',Mask_Set_Title_Text__c='MST001');
        Pairing_Table__c objPT2 = new Pairing_Table__c(
            Name='MST001-RKAZ',Mask_Set_Title__c=objMST.Id,Mask_Title__c='MST001-RKAZ',Image1__c='RKAZ',
            Image2__c='CKAZ',Image3__c='SXBZ',Image4__c='TXDZ',Mask_Set_Title_Text__c='MST001'
        );
        
        insert objPT;
        insert objPT2;
        
        
        List<Mask_WIP__c> listMWIP = new List<Mask_WIP__c>();
        Mask_WIP__c objMWIP1 = new Mask_WIP__c(Name='MWIP1',Mask_Set_Title__c=objMST.Id,Status__c='Completed',Mask_Title__c='MST001-RXAZV1N1',Mask_Set_Title_Text__c='MST001');
        Mask_WIP__c objMWIP2 = new Mask_WIP__c(Name='MWIP2',Mask_Set_Title__c=objMST.Id,Status__c='Completed',Mask_Title__c='MST002-RXAZV1N1',Mask_Set_Title_Text__c='MST002');
        Mask_WIP__c objMWIP3 = new Mask_WIP__c(Name='MWIP3',Mask_Set_Title__c=objMST.Id,Status__c='None',Mask_Title__c='MST001-SXACV1N1',Mask_Set_Title_Text__c='MST001');
        
        Mask_WIP__c objMWIP_4 = new Mask_WIP__c(Name='MST001-RKAZQKMZ',Mask_Set_Title__c=objMST.Id,Status__c='Completed',Mask_Title__c='MST001-RKAZQKMZ',Mask_Set_Title_Text__c='MST001');
        Mask_WIP__c objMWIP_5 = new Mask_WIP__c(Name='MST001-CKAZQKMZ',Mask_Set_Title__c=objMST.Id,Status__c='Completed',Mask_Title__c='MST001-CKAZV1N1',Mask_Set_Title_Text__c='MST001');
        Mask_WIP__c objMWIP_6 = new Mask_WIP__c(Name='MST001-RMBZQKMZ',Mask_Set_Title__c=objMST.Id,Status__c='Completed',Mask_Title__c='MST001-RMBZQKMZ',Mask_Set_Title_Text__c='MST001');
        
        listMWIP.add(objMWIP1);
        listMWIP.add(objMWIP2);
        listMWIP.add(objMWIP3);
        listMWIP.add(objMWIP_4);
        listMWIP.add(objMWIP_5);
        listMWIP.add(objMWIP_6);
        insert listMWIP;
        objMWIP3.Status__c='Completed';
        update objMWIP3;
    }
}