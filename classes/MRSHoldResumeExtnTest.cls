@isTest(SeeAllData=false)
public class MRSHoldResumeExtnTest{

    /**
    This method initialize data using throughout this test class.
    The create data method are: 
    - SwiftDataUtilityTest.customSystemData();
    @author     SWIFT TEAM
    @since      7-April-2015
    */
    @testSetup static void setup() {
        SwiftDataUtilityTest.customSystemData();
    }
    
  // Method to cover codes used for operations beforeLayer Status Update from Hold Resume Layer page                                             
    public static testMethod void MRSHoldResume(){
        // comment-out, refactor with testSetup method setup()
          // SwiftDataUtilityTest.customSystemData();
      Profile p = [SELECT Id FROM Profile Where Name = 'GF FAE/FTS'];
      User u = [Select Id,Name from User Where ProfileId = :p.Id And IsActive=true limit 1];
      Profile sysAdminProfile = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
      User thisUser = [SELECT Id FROM User WHERE ProfileId =:sysAdminProfile.Id and isActive=true and AccountId=null limit 1];
      
      Account acc;
      
      System.runAs (thisUser) {
      
        recordtype rt=[select id from recordtype where sobjecttype='Account' and developername='GLOBALFOUNDRIES_Internal'] ;
        acc = SwiftDataUtilityTest.createTestAccountForDRT();
        System.assertNotEquals(acc,null);
        acc.stage__c = 'Qualified'; 
        update acc;
      } 
        //System.runAs(u){
            Mask_Set_Title__c mst = SwiftDataUtilityTest.createMST('MYMST');
            insert mst;
                    
            PTRF__c ptrf = new PTRF__c(Name='ACOU',Order_Type__c = 'testOrder',Recticle_Type__c='Multi Layer Reticle (MLR)',Customer_jobview__c='Gating Mask Release',MaskSetTitle__c=mst.Id,Customer__c=acc.Id,Prime_Tapeout__c = true,Device_Id__c = '7FA2' );
            insert ptrf;
            
           Mask_Layer__c maskLayer = new Mask_Layer__c();
            maskLayer.Tapeout__c = true;
            maskLayer.Name = 'layer001' ; 
            maskLayer.Mask_Set_Title__c  = mst.id;
            maskLayer.PTRF__c = ptrf.Id;
            maskLayer.ROM_Code__c = 'AZ';
            maskLayer.Mask_Layer_Rev__c = '01'; 
            maskLayer.LogicalOperation__c = 'Foundry Std'; 
            maskLayer.LogicalOperationType__c = 'Foundry Std.';
            maskLayer.Mask_Layer_Number__c = 'layer001';
            insert maskLayer;       
    
            
            
            MRS__c mrs = new MRS__c(Full_Sync__c =true,Synced_with_Oracle_DB__c=false,MRS_Package_Sync__c=false,Mask_Set_Title__c=mst.Id);                                   
            insert mrs;
            
            MRS_Layer_Association__c mrsLayer1 = new MRS_Layer_Association__c(Name ='layer001',
                                                                              Synced_with_Oracle_DB__c=false,
                                                                              Mask_Layer_Rev__c = '899',
                                                                              Layer_Name__c = 'testLayer001',
                                                                              Layer_Status__c = 'In Progress',
                                                                              mrs__c = mrs.id,Tech_Geo__c = '0.02');
            insert mrslayer1;                                                                                                                                  
            MRS_Chip_Details__c mrsChip1 = new MRS_Chip_Details__c(Name='chip001',
                                                                   Synced_with_Oracle_DB__c=false,
                                                                   mrs__c = mrs.id);
            insert mrsChip1;                                                     
            MRS_Layer_Chip_Association__c layerChip1 = new MRS_Layer_Chip_Association__c(Name='layerChip001',
                                                                                         Synced_with_Oracle_DB__c=false,
                                                                                         Send_Prime_Data__c = 'Ready',
                                                                                         Layer__c=mrsLayer1.Id,
                                                                                         Chip__c=mrsChip1.Id,
                                                                                         PTRF__c=ptrf.Id,Device_Id__c = '7FA2',
                                                                                         Tech_Geo__c = '0.02',
                                                                                         Customer_Name__c=acc.Id);
            insert layerChip1;
            
           
            
            Test.StartTest();
            PageReference myVfPage = Page.VFMRSResumeHold;
            Test.setCurrentPage(myVfPage);
            ApexPages.currentPage().getHeaders().put('Host',system.label.Internal_URL);
            ApexPages.StandardController sc = new ApexPages.StandardController(new MRS__c());
    
            ClsMyDevices.account = new Cookie('account',acc.id,null,-1,false);
            ApexPages.currentPage().setCookies(new Cookie[]{ClsMyDevices.account});        
            
            ClsMyDevices.mst = new Cookie('mst',mst.id,null,-1,false);
            ApexPages.currentPage().setCookies(new Cookie[]{ClsMyDevices.mst});         
    
            MRSHoldResumeExtn holdResumeObj = new MRSHoldResumeExtn(sc);
            system.debug('CHECK PLEASE'+holdResumeObj.lstCustomer.size());
            holdResumeObj.selectedCustomerId = acc.Id;
            holdResumeObj.selectedMST = mst.Id;
            holdResumeObj.MSTIDString = mst.id;
            holdResumeObj.selectedlayerStatus = 'In Progress';
            holdResumeObj.selectedDeviceId = '7FA2';
            holdResumeObj.selectedTechGeo = '0.02';
            holdResumeObj.selectedMSTName = mst.id;
            holdResumeObj.isFilterApplied = false;
            holdResumeObj.FormatTechGeo(layerChip1.Tech_Geo__c);
            //holdResumeObj.getMRSLayerChipSummary();
            //holdResumeObj.getMRSTblData();
            holdResumeObj.displayErrorMsg();
            
            holdResumeObj.acfn_discard();
            //holdResumeObj.clearFilters();
            holdResumeObj.sendHoldWarning();
            holdResumeObj.sendMrsLayerId();
            holdResumeObj.getMaskSetTitle();
            holdResumeObj.selectedMST = mst.Id;
            holdResumeObj.getMSTLayer();
            //holdResumeObj.getMSTdeviceId();
            //holdResumeObj.getMSTtechGeo();
            //holdResumeObj.exportToCSV();
            //holdResumeObj.exportToPDF();
            //holdResumeObj.refreshTable();
            holdResumeObj.isChecking = false;
            holdResumeObj.isCheckBoxTrue();
            holdResumeObj.commentIsNull = 'commentIsNull';
            holdResumeObj.IsCommentBlank();
            holdResumeObj.MRSLAYERID = mrslayer1.Id;
            holdResumeObj.isHold = true;
            //holdResumeObj.layerStatusUpdateOnProceed();
            MRSHoldResumeExtn.MRSWrapper wrapperObj = new MRSHoldResumeExtn.MRSWrapper(mrsLayer1,2,true,true);
            wrapperObj.mrs = mrsLayer1;
            wrapperObj.layerId = '123';
            wrapperObj.layerName = 'RXAZ(123)';
            wrapperObj.layerStatus = 'In Progress';
            wrapperObj.count = 2;
            //wrapperObj.color = true;
            wrapperObj.isChecked = true;
            wrapperObj.MaskLayerName = 'RXAZ(123)';
            holdResumeObj.displayProceedData();
            holdResumeObj.setselectedLayerStatus('');
            Test.StopTest();
        //}

    }
   // Method to cover code used for updating status of layers from Hold Resume Page 
    public static testMethod void testLayerUpdateOnProceed(){
        // comment-out, refactor with testSetup method setup()
          // SwiftDataUtilityTest.customSystemData();
        Profile p = [SELECT Id FROM Profile Where Name = 'GF WWMS Executive'];
        User u = [Select Id,Name from User Where ProfileId = :p.Id And IsActive=true limit 1];
        
        Account acc = SwiftDataUtilityTest.createTestAccount();
        
        //System.runAs(u){
            recordtype rt=[select id from recordtype where sobjecttype='Account' and developername='GLOBALFOUNDRIES_Internal'] ;
           
            
            Mask_Set_Title__c mst = SwiftDataUtilityTest.createMST('MYMST');
            insert mst;
            
            List<Fab_Distribution_Table__c> lstFab = new List<Fab_Distribution_Table__c>();
             lstFab.add(new Fab_Distribution_Table__c(Fab_No__c='FAB1',Distribution_List__c='soham.oncloud9@gmail.com;ssaha.kolkata@gmail.com'));
             lstFab.add(new Fab_Distribution_Table__c(Fab_No__c='FAB2',Distribution_List__c='soham.oncloud9@gmail.com'));
              insert lstFab;
              
            List<PTRF__c> lstPTRF = new List<PTRF__c>();
            PTRF__c ptrf = new PTRF__c(Name='ACOU',Order_Type__c = 'testOrder',Recticle_Type__c='Multi Layer Reticle (MLR)',
            Customer_jobview__c='Gating Mask Release',MaskSetTitle__c=mst.Id,Customer__c=acc.Id,Device_Id__c = '7FA2',Fab__c='FAB2' );
            PTRF__c ptrf1 = new PTRF__c(Name='ACOV',Order_Type__c = 'testOrder',Recticle_Type__c='Multi Layer Reticle (MLR)',
            Customer_jobview__c='Gating Mask Release',MaskSetTitle__c=mst.Id,Customer__c=acc.Id,Device_Id__c = '7FA2' );
            lstPTRF.add(ptrf);
            lstPTRF.add(ptrf1);
             insert lstPTRF;
           
           List<Mask_Layer__c> lstmaskLayer = new List<Mask_Layer__c>();
            Mask_Layer__c maskLayer = new Mask_Layer__c();
                maskLayer.Tapeout__c = true;
                maskLayer.Name = 'layer001' ; 
                maskLayer.Mask_Set_Title__c  = mst.id;
                maskLayer.PTRF__c = lstPTRF[0].Id;
                maskLayer.ROM_Code__c = 'AZ';
                maskLayer.Mask_Layer_Rev__c = '01'; 
                maskLayer.LogicalOperation__c = 'Foundry Std'; 
                maskLayer.LogicalOperationType__c = 'Foundry Std.';
                maskLayer.Mask_Layer_Number__c = 'layer001';
             
            Mask_Layer__c maskLayer1 = new Mask_Layer__c();
                maskLayer1.Tapeout__c = true;
                maskLayer1.Name = 'layer001' ; 
                maskLayer1.Mask_Set_Title__c  = mst.id;
                maskLayer1.PTRF__c = lstPTRF[1].Id;
                maskLayer1.ROM_Code__c = 'AZ';
                maskLayer1.Mask_Layer_Rev__c = '01'; 
                maskLayer1.LogicalOperation__c = 'Foundry Std'; 
                maskLayer1.LogicalOperationType__c = 'Foundry Std.';
                maskLayer1.Mask_Layer_Number__c = 'layer001';
                
               lstmaskLayer.add(maskLayer);
               lstmasklayer.add(maskLayer1); 
                insert lstmaskLayer;     

            MRS__c mrs = new MRS__c(Full_Sync__c =true,Synced_with_Oracle_DB__c=false,MRS_Package_Sync__c=false,Mask_Set_Title__c=mst.Id);                                   
            insert mrs;
            
            MRS_Layer_Association__c mrsLayer1 = new MRS_Layer_Association__c(Name ='layer001',
                                                                              Synced_with_Oracle_DB__c=false,
                                                                              Mask_Layer_Rev__c = '899',
                                                                              Layer_Name__c = 'testLayer001',
                                                                              Layer_Status__c = 'Not Ready',
                                                                              mrs__c = mrs.id,Tech_Geo__c = '0.02');
            insert mrslayer1;                                                                                                                                  
            MRS_Chip_Details__c mrsChip1 = new MRS_Chip_Details__c(Name='chip001',
                                                                   Synced_with_Oracle_DB__c=false,
                                                                   mrs__c = mrs.id);
            insert mrsChip1;
            
            List<MRS_Layer_Chip_Association__c> lstLayerChip = new List<MRS_Layer_Chip_Association__c>();                                                     
            MRS_Layer_Chip_Association__c layerChip1 = new MRS_Layer_Chip_Association__c(Name='layerChip001',
                                                                                         Synced_with_Oracle_DB__c=false,
                                                                                         Send_Prime_Data__c = 'Ready',
                                                                                         Layer__c=mrsLayer1.Id,
                                                                                         Chip__c=mrsChip1.Id,
                                                                                         PTRF__c=lstPTRF[0].Id,
                                                                                         Customer_Name__c=acc.Id);
            MRS_Layer_Chip_Association__c layerChip2 = new MRS_Layer_Chip_Association__c(Name='layerChip002',
                                                                                         Synced_with_Oracle_DB__c=false,
                                                                                         Send_Prime_Data__c = 'Ready',
                                                                                         Layer__c=mrsLayer1.Id,
                                                                                         Chip__c=mrsChip1.Id,
                                                                                         PTRF__c=lstPTRF[1].Id,
                                                                                         Customer_Name__c=acc.Id);  
            lstLayerChip.add(layerChip1);
            lstLayerChip.add(layerChip2);                                                                                                                                                                                
            insert lstLayerChip;
            
            Test.StartTest();
          
            PageReference myVfPage1 = Page.VFMRSResumeHold;
            Test.setCurrentPage(myVfPage1);
            ApexPages.currentPage().getHeaders().put('Host',system.label.Internal_URL);
            //ApexPages.currentPage().getHeaders().put('Host',system.Label.SWIFT_Community_URL);
            Cookie account = new Cookie('account', acc.Id, null, -1, false);
            ApexPages.currentPage().setCookies(new Cookie[]{account});
            Cookie maskSetTitle = new Cookie('mst', mst.Id, null, -1, false);
            ApexPages.currentPage().setCookies(new Cookie[]{maskSetTitle});
            ApexPages.StandardController sc1 = new ApexPages.StandardController(new MRS__c());
            MRSHoldResumeExtn holdResumeObj1 = new MRSHoldResumeExtn(sc1);
            holdResumeObj1.selectedCustomerId = acc.Id;
            holdResumeObj1.selectedMST = mst.Id;
            holdResumeObj1.MRSLAYERID = mrslayer1.Id;
            holdResumeObj1.isHold = false;
            holdResumeObj1.layerStatusUpdateOnProceed();
            Test.StopTest();
        //}
    }
    
    public static testMethod void testLayerUpdateOnProceed2(){
        // comment-out, refactor with testSetup method setup()
          // SwiftDataUtilityTest.customSystemData();
        Profile p = [SELECT Id FROM Profile Where Name = 'GF WWMS Executive'];
        User u = [Select Id,Name from User Where ProfileId = :p.Id And IsActive=true limit 1];
        
        Account acc = SwiftDataUtilityTest.createTestAccount();
        
       // System.runAs(u){
            recordtype rt=[select id from recordtype where sobjecttype='Account' and developername='GLOBALFOUNDRIES_Internal'] ;
           
            
            Mask_Set_Title__c mst = SwiftDataUtilityTest.createMST('MYMST');
            insert mst;
            
            List<Fab_Distribution_Table__c> lstFab = new List<Fab_Distribution_Table__c>();
             lstFab.add(new Fab_Distribution_Table__c(Fab_No__c='FAB1',Distribution_List__c='soham.oncloud9@gmail.com;ssaha.kolkata@gmail.com'));
             lstFab.add(new Fab_Distribution_Table__c(Fab_No__c='FAB2',Distribution_List__c='soham.oncloud9@gmail.com'));
              insert lstFab;
            
            List<Maskshop_Configuration__c> lstMasks = new List<Maskshop_Configuration__c>();
              lstMasks.add(new Maskshop_Configuration__c(Name='mask1'));
              lstMasks.add(new Maskshop_Configuration__c(Name='mask2'));
               insert lstMasks;
               
            List<Released_Mask_Write_Distribution_List__c> lstDistList = new List<Released_Mask_Write_Distribution_List__c>();
              lstDistList.add(new Released_Mask_Write_Distribution_List__c(Maskshop__c=lstMasks[0].id,Distribution_List__c='soham.oncloud9@gmail.com;ssaha.kolkata@gmail.com'));
              lstDistList.add(new Released_Mask_Write_Distribution_List__c(Maskshop__c=lstMasks[1].id,Distribution_List__c='soham.oncloud9@gmail.com')); 
               insert lstDistList;
                
            List<PTRF__c> lstPTRF = new List<PTRF__c>();
            PTRF__c ptrf = new PTRF__c(Name='ACOU',Order_Type__c = 'testOrder',Recticle_Type__c='Multi Layer Reticle (MLR)',
            Customer_jobview__c='Gating Mask Release',MaskSetTitle__c=mst.Id,Customer__c=acc.Id,Device_Id__c = '7FA2',Fab__c='FAB2',Maskshop__c ='mask1');
            PTRF__c ptrf1 = new PTRF__c(Name='ACOV',Order_Type__c = 'testOrder',Recticle_Type__c='Multi Layer Reticle (MLR)',
            Customer_jobview__c='Gating Mask Release',MaskSetTitle__c=mst.Id,Customer__c=acc.Id,Device_Id__c = '7FA2',Maskshop__c ='mask2');
            lstPTRF.add(ptrf);
            lstPTRF.add(ptrf1);
             insert lstPTRF;
           
           List<Mask_Layer__c> lstmaskLayer = new List<Mask_Layer__c>();
            Mask_Layer__c maskLayer = new Mask_Layer__c();
                maskLayer.Tapeout__c = true;
                maskLayer.Name = 'layer001' ; 
                maskLayer.Mask_Set_Title__c  = mst.id;
                maskLayer.PTRF__c = lstPTRF[0].Id;
                maskLayer.ROM_Code__c = 'AZ';
                maskLayer.Mask_Layer_Rev__c = '01'; 
                maskLayer.LogicalOperation__c = 'Foundry Std'; 
                maskLayer.LogicalOperationType__c = 'Foundry Std.';
                maskLayer.Mask_Layer_Number__c = 'layer001';
             
            Mask_Layer__c maskLayer1 = new Mask_Layer__c();
                maskLayer1.Tapeout__c = true;
                maskLayer1.Name = 'layer001' ; 
                maskLayer1.Mask_Set_Title__c  = mst.id;
                maskLayer1.PTRF__c = lstPTRF[1].Id;
                maskLayer1.ROM_Code__c = 'AZ';
                maskLayer1.Mask_Layer_Rev__c = '01'; 
                maskLayer1.LogicalOperation__c = 'Foundry Std'; 
                maskLayer1.LogicalOperationType__c = 'Foundry Std.';
                maskLayer1.Mask_Layer_Number__c = 'layer001';
                
               lstmaskLayer.add(maskLayer);
               lstmasklayer.add(maskLayer1); 
                insert lstmaskLayer;     

            MRS__c mrs = new MRS__c(Full_Sync__c =true,Synced_with_Oracle_DB__c=false,MRS_Package_Sync__c=false,Mask_Set_Title__c=mst.Id);                                   
            insert mrs;
            
            MRS_Layer_Association__c mrsLayer1 = new MRS_Layer_Association__c(Name ='layer001',
                                                                              Synced_with_Oracle_DB__c=false,
                                                                              Mask_Layer_Rev__c = '899',
                                                                              Layer_Name__c = 'testLayer001',
                                                                              Layer_Status__c = 'Released',
                                                                              mrs__c = mrs.id,Tech_Geo__c = '0.02');
            insert mrslayer1;                                                                                                                                  
            MRS_Chip_Details__c mrsChip1 = new MRS_Chip_Details__c(Name='chip001',
                                                                   Synced_with_Oracle_DB__c=false,
                                                                   mrs__c = mrs.id);
            insert mrsChip1;
            
            List<MRS_Layer_Chip_Association__c> lstLayerChip = new List<MRS_Layer_Chip_Association__c>();                                                     
            MRS_Layer_Chip_Association__c layerChip1 = new MRS_Layer_Chip_Association__c(Name='layerChip001',
                                                                                         Synced_with_Oracle_DB__c=false,
                                                                                         Send_Prime_Data__c = 'Ready',
                                                                                         Layer__c=mrsLayer1.Id,
                                                                                         Chip__c=mrsChip1.Id,
                                                                                         PTRF__c=lstPTRF[0].Id,
                                                                                         Customer_Name__c=acc.Id);
            MRS_Layer_Chip_Association__c layerChip2 = new MRS_Layer_Chip_Association__c(Name='layerChip002',
                                                                                         Synced_with_Oracle_DB__c=false,
                                                                                         Send_Prime_Data__c = 'Ready',
                                                                                         Layer__c=mrsLayer1.Id,
                                                                                         Chip__c=mrsChip1.Id,
                                                                                         PTRF__c=lstPTRF[1].Id,
                                                                                         Customer_Name__c=acc.Id);  
            lstLayerChip.add(layerChip1);
            lstLayerChip.add(layerChip2);                                                                                                                                                                                
            insert lstLayerChip;
            
            Test.StartTest();
          
            PageReference myVfPage1 = Page.VFMRSResumeHold;
            Test.setCurrentPage(myVfPage1);
            ApexPages.currentPage().getHeaders().put('Host',system.label.Internal_URL);
            //ApexPages.currentPage().getHeaders().put('Host',system.Label.SWIFT_Community_URL);
            Cookie account = new Cookie('account', acc.Id, null, -1, false);
            ApexPages.currentPage().setCookies(new Cookie[]{account});
            Cookie maskSetTitle = new Cookie('mst', mst.Id, null, -1, false);
            ApexPages.currentPage().setCookies(new Cookie[]{maskSetTitle});
            ApexPages.StandardController sc1 = new ApexPages.StandardController(new MRS__c());
            MRSHoldResumeExtn holdResumeObj1 = new MRSHoldResumeExtn(sc1);
            holdResumeObj1.mapLayerAssoToStatus.put(mrslayer1.id,'Released');
            holdResumeObj1.selectedCustomerId = acc.Id;
            holdResumeObj1.selectedMST = mst.Id;
            holdResumeObj1.MRSLAYERID = mrslayer1.Id;
            holdResumeObj1.isHold = true;
            holdResumeObj1.layerStatusUpdateOnProceed();
            Test.StopTest();
       // }
    }
   // Method to test code for testing the primary method for populating Hold Resume Layer page with correct Layers 
    public static testMethod void testgetMRSLayerChipSummary(){
        // comment-out, refactor with testSetup method setup()
          // SwiftDataUtilityTest.customSystemData();
        Profile p = [SELECT Id FROM Profile Where Name = 'GF FAE/FTS'];
        User u = [Select Id,Name from User Where ProfileId = :p.Id And IsActive=true limit 1];
        Profile sysAdminProfile = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User thisUser = [SELECT Id FROM User WHERE ProfileId =:sysAdminProfile.Id and isActive=true limit 1];
        
        
        Account acc;
        System.runAs (thisUser) {
            recordtype rt=[select id from recordtype where sobjecttype='Account' and developername='GLOBALFOUNDRIES_Internal'] ;
            acc = SwiftDataUtilityTest.createTestAccount();
        }
        
        //System.runAs(u){
            Mask_Set_Title__c mst = SwiftDataUtilityTest.createMST('MYMST');
            insert mst;
            PTRF__c ptrf = new PTRF__c(Name='ACOU',Order_Type__c = 'testOrder',Recticle_Type__c='Multi Layer Reticle (MLR)',
            Customer_jobview__c='Gating Mask Release',MaskSetTitle__c=mst.Id,Customer__c=acc.Id,Device_Id__c = '7FA2' );
            insert ptrf;
            
            Mask_Layer__c maskLayer = new Mask_Layer__c();
            maskLayer.Tapeout__c = true;
            maskLayer.Name = 'layer001' ; 
            maskLayer.Mask_Set_Title__c  = mst.id;
            maskLayer.PTRF__c = ptrf.Id;
            maskLayer.ROM_Code__c = 'AZ';
            maskLayer.Mask_Layer_Rev__c = '01'; 
            maskLayer.LogicalOperation__c = 'Foundry Std'; 
            maskLayer.LogicalOperationType__c = 'Foundry Std.';
            maskLayer.Mask_Layer_Number__c = 'layer001';
            insert maskLayer; 
    
            MRS__c mrs = new MRS__c(Full_Sync__c =true,Synced_with_Oracle_DB__c=false,MRS_Package_Sync__c=false,Mask_Set_Title__c=mst.Id);                                   
            insert mrs;
            
            MRS_Layer_Association__c mrsLayer1 = new MRS_Layer_Association__c(Name ='layer001',
                                                                              Synced_with_Oracle_DB__c=false,
                                                                              Mask_Layer_Rev__c = '899',
                                                                              Layer_Name__c = 'testLayer001',
                                                                              Layer_Status__c = 'In Progress',
                                                                              mrs__c = mrs.id,Tech_Geo__c = '0.02');
            insert mrslayer1;                                                                                                                                  
            MRS_Chip_Details__c mrsChip1 = new MRS_Chip_Details__c(Name='chip001',
                                                                   Synced_with_Oracle_DB__c=false,
                                                                   mrs__c = mrs.id);
            insert mrsChip1;                                                     
            MRS_Layer_Chip_Association__c layerChip1 = new MRS_Layer_Chip_Association__c(Name='layerChip001',
                                                                                         Synced_with_Oracle_DB__c=false,
                                                                                         Send_Prime_Data__c = 'Ready',
                                                                                         Layer__c=mrsLayer1.Id,
                                                                                         Chip__c=mrsChip1.Id,
                                                                                         PTRF__c=ptrf.Id,
                                                                                         Customer_Name__c=acc.Id);
            insert layerChip1;
            Test.StartTest();
            PageReference myVfPage = Page.VFMRSResumeHold;
            Test.setCurrentPage(myVfPage);
            ApexPages.currentPage().getHeaders().put('Host',system.label.Internal_URL);
            ApexPages.StandardController sc = new ApexPages.StandardController(new MRS__c());
            MRSHoldResumeExtn holdResumeObj = new MRSHoldResumeExtn(sc);
            holdResumeObj.selectedCustomerId = acc.Id;
            holdResumeObj.selectedMST = mst.Id;
            holdResumeObj.MRSLAYERID = mrslayer1.Id;
            holdResumeObj.isHold = true;
            holdResumeObj.LayerIdString = mrsLayer1.id;
            List<MRSHoldResumeExtn.MRSWrapper> wrapperList = new List<MRSHoldResumeExtn.MRSWrapper>();
            MRSHoldResumeExtn.MRSWrapper wrapper = new MRSHoldResumeExtn.MRSWrapper(mrsLayer1,2,true,true);
            wrapper.mrs = mrsLayer1;
            wrapper.layerId = 'testLayerId';
            wrapper.layerName='layer001';
            wrapper.layerStatus='In Progress';
            wrapper.count=1;
            wrapper.isChecked=true;
            wrapper.MaskLayerName='RXAZ(12)';
            wrapperList.add(wrapper);
            holdResumeObj.mrsWrapperList = wrapperList;
            holdResumeObj.displayProceedData();
            //holdResumeObj.acfn_discard();
            holdResumeObj.colorOnProceed=false;
            holdResumeObj.displayProceedData();
            //holdResumeObj.acfn_discard();
            //holdResumeObj.getMRSLayerChipSummary();
            Test.StopTest();    
        //}
        
    }
    
   public static testMethod void MRSHoldResume2(){
        // comment-out, refactor with testSetup method setup()
          // SwiftDataUtilityTest.customSystemData();
      Profile p = [SELECT Id FROM Profile Where Name = 'GF FAE/FTS'];
      User u = [Select Id,Name from User Where ProfileId = :p.Id And IsActive=true limit 1];
      Profile sysAdminProfile = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
      User thisUser = [SELECT Id FROM User WHERE ProfileId =:sysAdminProfile.Id and isActive=true and AccountId=null limit 1];
      
      Account acc;
      Account acctn;
      
      System.runAs (thisUser) {
      
        acc = SwiftDataUtilityTest.createTestAccountForDRT();
        System.assertNotEquals(acc,null);
        acc.stage__c = 'Qualified'; 
        update acc;
        
         recordtype rt=[select id from recordtype where sobjecttype='Account' and developername='GLOBALFOUNDRIES_Internal'];
              
        acctn = new Account(
            name = 'TEST rec2',
            recordtypeid=rt.id,
            stage__c = 'Unqualified',
            short_name__c = 'TESTrec2',
            sub_type__c= 'Direct',
            site_department__c = 'test dept',
            transaction_type__c = 'Transactional',
            account_profile__c = 'Fabless - Emerging',
            Process_Tech_Interested__c = 'Mature (> 0.11um)',
            region__c = 'APJ',
            Market_Segment__c = 'Mobility',
            Sales_Territory__c = 'APJ-Japan',
            FE_Territory__c = 'APJ-FE-JAPAN',
            financial_territory__c = 'APJ-Japan',
            Corporate_Address_1__c = '50 water st',
             Bill_To_Address_1__c= '50 water st',
            Corporate_City__c = 'Lee',
            Bill_To_City__c='Lee',
            Corporate_Country__c = 'Japan',
             Bill_To_Country__c='Japan',
            Organization_Unit__c = 'GF Investment LLC OU',
            bill_to_location__c = 'YES',
            total_employee__c = 100,
            end_customer__c = 'people',
            Revenue_Potential__c = 'High Potential',
            Customer_Number__c='',
            Target_Account__c = 'Yes',
            siebel_account_id__c='1111',
            //--------------------------------
            Fab_9_10__c = 'No'
        );
            
        insert acctn;
        
        
        System.assertNotEquals(acctn,null);
        acctn.stage__c = 'Qualified'; 
        update acctn; 
      }
        
               

        //System.runAs(u){
            Mask_Set_Title__c mst = SwiftDataUtilityTest.createMST('MYMST');
            insert mst;
                    
            PTRF__c ptrf = new PTRF__c(Name='ACOU',Order_Type__c = 'testOrder',Recticle_Type__c='Multi Layer Reticle (MLR)',Customer_jobview__c='Gating Mask Release',MaskSetTitle__c=mst.Id,Customer__c=acc.Id,Prime_Tapeout__c = true, Device_Id__c = '7FA2'  );
            insert ptrf;
            
           Mask_Layer__c maskLayer = new Mask_Layer__c();
            maskLayer.Tapeout__c = true;
            maskLayer.Name = 'layer001' ; 
            maskLayer.Mask_Set_Title__c  = mst.id;
            maskLayer.PTRF__c = ptrf.Id;
            maskLayer.ROM_Code__c = 'AZ';
            maskLayer.Mask_Layer_Rev__c = '01'; 
            maskLayer.LogicalOperation__c = 'Foundry Std'; 
            maskLayer.LogicalOperationType__c = 'Foundry Std.';
             maskLayer.Mask_Layer_Number__c = 'layer001';
            insert maskLayer;       
    
            
            
            MRS__c mrs = new MRS__c(Full_Sync__c =true,Synced_with_Oracle_DB__c=false,MRS_Package_Sync__c=false,Mask_Set_Title__c=mst.Id);                                   
            insert mrs;
            
            MRS_Layer_Association__c mrsLayer1 = new MRS_Layer_Association__c(Name ='layer001',
                                                                              Synced_with_Oracle_DB__c=false,
                                                                              Mask_Layer_Rev__c = '899',
                                                                              Layer_Name__c = 'testLayer001',
                                                                              Layer_Status__c = 'In Progress',
                                                                              mrs__c = mrs.id,Tech_Geo__c = '0.02');
            insert mrslayer1;                                                                                                                                  
            MRS_Chip_Details__c mrsChip1 = new MRS_Chip_Details__c(Name='chip001',
                                                                   Synced_with_Oracle_DB__c=false,
                                                                   mrs__c = mrs.id);
            insert mrsChip1;                                                     
            MRS_Layer_Chip_Association__c layerChip1 = new MRS_Layer_Chip_Association__c(Name='layerChip001',
                                                                                         Synced_with_Oracle_DB__c=false,
                                                                                         Send_Prime_Data__c = 'Ready',
                                                                                         Layer__c=mrsLayer1.Id,
                                                                                         Chip__c=mrsChip1.Id,
                                                                                         PTRF__c=ptrf.Id,Device_Id__c = '7FA2',
                                                                                         Tech_Geo__c = '0.02',
                                                                                         Customer_Name__c=acc.Id);
            insert layerChip1;
            
           
            
            Test.StartTest();
            PageReference myVfPage = Page.VFMRSResumeHold;
            Test.setCurrentPage(myVfPage);
            ApexPages.currentPage().getHeaders().put('Host',system.label.Internal_URL);
            ApexPages.StandardController sc = new ApexPages.StandardController(new MRS__c());
    
            ClsMyDevices.account = new Cookie('account',acc.id,null,-1,false);
            ApexPages.currentPage().setCookies(new Cookie[]{ClsMyDevices.account});        
            
            ClsMyDevices.mst = new Cookie('mst',mst.id,null,-1,false);
            ApexPages.currentPage().setCookies(new Cookie[]{ClsMyDevices.mst});         
    
            MRSHoldResumeExtn holdResumeObj = new MRSHoldResumeExtn(sc);
            system.debug('CHECK PLEASE'+holdResumeObj.lstCustomer.size());
            holdResumeObj.selectedCustomerId = acc.Id;
            holdResumeObj.selectedMST = mst.Id;
            holdResumeObj.MSTIDString = mst.id;
            holdResumeObj.selectedlayerStatus = 'In Progress';
            holdResumeObj.selectedDeviceId = '7FA2';
            holdResumeObj.selectedTechGeo = '0.02';
            holdResumeObj.selectedMSTName = mst.name;
            holdResumeObj.isFilterApplied = false;
            holdResumeObj.FormatTechGeo(layerChip1.Tech_Geo__c);
            //holdResumeObj.getMRSLayerChipSummary();
            //holdResumeObj.getMRSTblData();
          
            holdResumeObj.clearFilters();
            
            holdResumeObj.getMSTdeviceId();
            //holdResumeObj.getMSTtechGeo();
            //holdResumeObj.exportToCSV();
            //holdResumeObj.exportToPDF();
            //holdResumeObj.refreshTable();
            holdResumeObj.isChecking = false;
            //holdResumeObj.isCheckBoxTrue();
            holdResumeObj.commentIsNull = 'commentIsNull';
            //holdResumeObj.IsCommentBlank();
            holdResumeObj.MRSLAYERID = mrslayer1.Id;
            holdResumeObj.isHold = true;
            //holdResumeObj.layerStatusUpdateOnProceed();
            MRSHoldResumeExtn.MRSWrapper wrapperObj = new MRSHoldResumeExtn.MRSWrapper(mrsLayer1,2,true,true);
            wrapperObj.mrs = mrsLayer1;
            wrapperObj.layerId = '123';
            wrapperObj.layerName = 'RXAZ(123)';
            wrapperObj.layerStatus = 'In Progress';
            wrapperObj.count = 2;
            //wrapperObj.color = true;
            wrapperObj.isChecked = true;
            wrapperObj.MaskLayerName = 'RXAZ(123)';
            //holdResumeObj.displayProceedData();
            holdResumeObj.setselectedLayerStatus('');
            Test.StopTest();
        //}
        //
    }
    
    
    public static testMethod void MRSHoldResume22(){
        // comment-out, refactor with testSetup method setup()
          // SwiftDataUtilityTest.customSystemData();
      Profile p = [SELECT Id FROM Profile Where Name = 'GF FAE/FTS'];
      User u = [Select Id,Name from User Where ProfileId = :p.Id And IsActive=true limit 1];
      Profile sysAdminProfile = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
      User thisUser = [SELECT Id FROM User WHERE ProfileId =:sysAdminProfile.Id and isActive=true and AccountId=null limit 1];
      
      Account acc;
      Account acctn;
      
      System.runAs (thisUser) {
      
        acc = SwiftDataUtilityTest.createTestAccountForDRT();
        System.assertNotEquals(acc,null);
        acc.stage__c = 'Qualified'; 
        update acc;
        
         recordtype rt=[select id from recordtype where sobjecttype='Account' and developername='GLOBALFOUNDRIES_Internal'];
              
        acctn = new Account(
            name = 'TEST rec2',
            recordtypeid=rt.id,
            stage__c = 'Unqualified',
            short_name__c = 'TESTrec2',
            sub_type__c= 'Direct',
            site_department__c = 'test dept',
            transaction_type__c = 'Transactional',
            account_profile__c = 'Fabless - Emerging',
            Process_Tech_Interested__c = 'Mature (> 0.11um)',
            region__c = 'APJ',
            Market_Segment__c = 'Mobility',
            Sales_Territory__c = 'APJ-Japan',
            FE_Territory__c = 'APJ-FE-JAPAN',
            financial_territory__c = 'APJ-Japan',
            Corporate_Address_1__c = '50 water st',
             Bill_To_Address_1__c= '50 water st',
            Corporate_City__c = 'Lee',
            Bill_To_City__c='Lee',
            Corporate_Country__c = 'Japan',
             Bill_To_Country__c='Japan',
            Organization_Unit__c = 'GF Investment LLC OU',
            bill_to_location__c = 'YES',
            total_employee__c = 100,
            end_customer__c = 'people',
            Revenue_Potential__c = 'High Potential',
            Customer_Number__c='',
            Target_Account__c = 'Yes',
            siebel_account_id__c='1111',
            //--------------------------------
            Fab_9_10__c = 'No'
        );
            
        insert acctn;
        
        System.assertNotEquals(acctn,null);
        acctn.stage__c = 'Qualified'; 
        update acctn;        
        
      }

      //  System.runAs(u){
        Mask_Set_Title__c mst = SwiftDataUtilityTest.createMST('MYMST');
        insert mst;
                
        PTRF__c ptrf = new PTRF__c(Name='ACOU',Order_Type__c = 'testOrder',Recticle_Type__c='Multi Layer Reticle (MLR)',Customer_jobview__c='Gating Mask Release',MaskSetTitle__c=mst.Id,Customer__c=acc.Id,Prime_Tapeout__c = true, Device_Id__c = '7FA2'  );
        insert ptrf;
        
       Mask_Layer__c maskLayer = new Mask_Layer__c();
        maskLayer.Tapeout__c = true;
        maskLayer.Name = 'layer001' ; 
        maskLayer.Mask_Set_Title__c  = mst.id;
        maskLayer.PTRF__c = ptrf.Id;
        maskLayer.ROM_Code__c = 'AZ';
        maskLayer.Mask_Layer_Rev__c = '01'; 
        maskLayer.LogicalOperation__c = 'Foundry Std'; 
        maskLayer.LogicalOperationType__c = 'Foundry Std.';
         maskLayer.Mask_Layer_Number__c = 'layer001';
        insert maskLayer;       

        
        
        MRS__c mrs = new MRS__c(Full_Sync__c =true,Synced_with_Oracle_DB__c=false,MRS_Package_Sync__c=false,Mask_Set_Title__c=mst.Id);                                   
        insert mrs;
        
        MRS_Layer_Association__c mrsLayer1 = new MRS_Layer_Association__c(Name ='layer001',
                                                                          Synced_with_Oracle_DB__c=false,
                                                                          Mask_Layer_Rev__c = '899',
                                                                          Layer_Name__c = 'testLayer001',
                                                                          Layer_Status__c = 'In Progress',
                                                                          mrs__c = mrs.id,Tech_Geo__c = '0.02');
        insert mrslayer1;                                                                                                                                  
        MRS_Chip_Details__c mrsChip1 = new MRS_Chip_Details__c(Name='chip001',
                                                               Synced_with_Oracle_DB__c=false,
                                                               mrs__c = mrs.id);
        insert mrsChip1;                                                     
        MRS_Layer_Chip_Association__c layerChip1 = new MRS_Layer_Chip_Association__c(Name='layerChip001',
                                                                                     Synced_with_Oracle_DB__c=false,
                                                                                     Send_Prime_Data__c = 'Ready',
                                                                                     Layer__c=mrsLayer1.Id,
                                                                                     Chip__c=mrsChip1.Id,
                                                                                     PTRF__c=ptrf.Id,Device_Id__c = '7FA2',
                                                                                     Tech_Geo__c = '0.02',
                                                                                     Customer_Name__c=acc.Id);
        insert layerChip1;
        
       
        
        Test.StartTest();
        PageReference myVfPage = Page.VFMRSResumeHold;
        Test.setCurrentPage(myVfPage);
        ApexPages.currentPage().getHeaders().put('Host',system.label.Internal_URL);
        ApexPages.StandardController sc = new ApexPages.StandardController(new MRS__c());

        ClsMyDevices.account = new Cookie('account',acc.id,null,-1,false);
        ApexPages.currentPage().setCookies(new Cookie[]{ClsMyDevices.account});        
        
        ClsMyDevices.mst = new Cookie('mst',mst.id,null,-1,false);
        ApexPages.currentPage().setCookies(new Cookie[]{ClsMyDevices.mst});         

        MRSHoldResumeExtn holdResumeObj = new MRSHoldResumeExtn(sc);
        system.debug('CHECK PLEASE'+holdResumeObj.lstCustomer.size());
        holdResumeObj.selectedCustomerId = acc.Id;
        holdResumeObj.selectedMST = mst.Id;
        holdResumeObj.MSTIDString = mst.id;
        holdResumeObj.selectedlayerStatus = 'In Progress';
        holdResumeObj.selectedDeviceId = '7FA2';
        holdResumeObj.selectedTechGeo = '0.02';
        holdResumeObj.selectedMSTName = mst.name;
        holdResumeObj.isFilterApplied = false;
        holdResumeObj.FormatTechGeo(layerChip1.Tech_Geo__c);
        //holdResumeObj.getMRSLayerChipSummary();
        //holdResumeObj.getMRSTblData();
         holdResumeObj.getMSTtechGeo();
        //holdResumeObj.exportToCSV();
        //holdResumeObj.exportToPDF();
        //holdResumeObj.refreshTable();
        holdResumeObj.isChecking = false;
        //holdResumeObj.isCheckBoxTrue();
        holdResumeObj.commentIsNull = 'commentIsNull';
        //holdResumeObj.IsCommentBlank();
        holdResumeObj.MRSLAYERID = mrslayer1.Id;
        holdResumeObj.isHold = true;
        //holdResumeObj.layerStatusUpdateOnProceed();
        MRSHoldResumeExtn.MRSWrapper wrapperObj = new MRSHoldResumeExtn.MRSWrapper(mrsLayer1,2,true,true);
        wrapperObj.mrs = mrsLayer1;
        wrapperObj.layerId = '123';
        wrapperObj.layerName = 'RXAZ(123)';
        wrapperObj.layerStatus = 'In Progress';
        wrapperObj.count = 2;
        //wrapperObj.color = true;
        wrapperObj.isChecked = true;
        wrapperObj.MaskLayerName = 'RXAZ(123)';
        //holdResumeObj.displayProceedData();
        holdResumeObj.setselectedLayerStatus('');
        Test.StopTest();
       // }
        
    }
    
    
  public static testMethod void MRSHoldResume3(){
        // comment-out, refactor with testSetup method setup()
          // SwiftDataUtilityTest.customSystemData();
      Profile p = [SELECT Id FROM Profile Where Name = 'GF FAE/FTS'];
      User u = [Select Id,Name from User Where ProfileId = :p.Id And IsActive=true limit 1];
      Profile sysAdminProfile = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
      User thisUser = [SELECT Id FROM User WHERE ProfileId =:sysAdminProfile.Id and isActive=true and AccountId=null limit 1];
      
      Account acc;
      
      System.runAs (thisUser) {
      
        recordtype rt=[select id from recordtype where sobjecttype='Account' and developername='GLOBALFOUNDRIES_Internal'] ;
        acc = SwiftDataUtilityTest.createTestAccountForDRT();
        System.assertNotEquals(acc,null);
        acc.stage__c = 'Qualified'; 
        update acc;
        
      }
        
      //  System.runAs(u){
            Mask_Set_Title__c mst = SwiftDataUtilityTest.createMST('MYMST');
            insert mst;
                    
            PTRF__c ptrf = new PTRF__c(Name='ACOU',Order_Type__c = 'testOrder',Recticle_Type__c='Multi Layer Reticle (MLR)',Customer_jobview__c='Gating Mask Release',MaskSetTitle__c=mst.Id,Customer__c=acc.Id,Prime_Tapeout__c = true,Device_Id__c = '7FA2'  );
            insert ptrf;
            
           Mask_Layer__c maskLayer = new Mask_Layer__c();
            maskLayer.Tapeout__c = true;
            maskLayer.Name = 'layer001' ; 
            maskLayer.Mask_Set_Title__c  = mst.id;
            maskLayer.PTRF__c = ptrf.Id;
            maskLayer.ROM_Code__c = 'AZ';
            maskLayer.Mask_Layer_Rev__c = '01'; 
            maskLayer.LogicalOperation__c = 'Foundry Std'; 
            maskLayer.LogicalOperationType__c = 'Foundry Std.';
             maskLayer.Mask_Layer_Number__c = 'layer001';
            insert maskLayer;       
    
            
            
            MRS__c mrs = new MRS__c(Full_Sync__c =true,Synced_with_Oracle_DB__c=false,MRS_Package_Sync__c=false,Mask_Set_Title__c=mst.Id);                                   
            insert mrs;
            
            MRS_Layer_Association__c mrsLayer1 = new MRS_Layer_Association__c(Name ='layer001',
                                                                              Synced_with_Oracle_DB__c=false,
                                                                              Mask_Layer_Rev__c = '899',
                                                                              Layer_Name__c = 'testLayer001',
                                                                              Layer_Status__c = 'In Progress',
                                                                              mrs__c = mrs.id,Tech_Geo__c = '0.02');
            insert mrslayer1;                                                                                                                                  
            MRS_Chip_Details__c mrsChip1 = new MRS_Chip_Details__c(Name='chip001',
                                                                   Synced_with_Oracle_DB__c=false,
                                                                   mrs__c = mrs.id);
            insert mrsChip1;                                                     
            MRS_Layer_Chip_Association__c layerChip1 = new MRS_Layer_Chip_Association__c(Name='layerChip001',
                                                                                         Synced_with_Oracle_DB__c=false,
                                                                                         Send_Prime_Data__c = 'Ready',
                                                                                         Layer__c=mrsLayer1.Id,
                                                                                         Chip__c=mrsChip1.Id,
                                                                                         PTRF__c=ptrf.Id,Device_Id__c = '7FA2',
                                                                                         Tech_Geo__c = '0.02',
                                                                                         Customer_Name__c=acc.Id);
            insert layerChip1;
            
           
            
            Test.StartTest();
            PageReference myVfPage = Page.VFMRSResumeHold;
            Test.setCurrentPage(myVfPage);
            ApexPages.currentPage().getHeaders().put('Host',system.label.Internal_URL);
            ApexPages.StandardController sc = new ApexPages.StandardController(new MRS__c());
           
            MRSHoldResumeExtn holdResumeObj = new MRSHoldResumeExtn(sc);
            system.debug('CHECK PLEASE'+holdResumeObj.lstCustomer.size());
            holdResumeObj.selectedCustomerId = acc.Id;
            holdResumeObj.selectedMST = mst.Id;
            holdResumeObj.MSTIDString = mst.id;
            holdResumeObj.selectedlayerStatus = 'In Progress';
            holdResumeObj.selectedDeviceId = '7FA2';
            holdResumeObj.selectedTechGeo = '0.02';
            holdResumeObj.selectedMSTName = mst.name;
            holdResumeObj.isFilterApplied = false;
            holdResumeObj.FormatTechGeo(layerChip1.Tech_Geo__c);
            //holdResumeObj.getMRSLayerChipSummary();
            holdResumeObj.isFilterApplied = true; 
            holdResumeObj.getMRSTblData();
          
          
            holdResumeObj.exportToCSV();
            holdResumeObj.exportToPDF();
            //holdResumeObj.refreshTable();
            holdResumeObj.isChecking = false;
            //holdResumeObj.isCheckBoxTrue();
            holdResumeObj.commentIsNull = 'commentIsNull';
            //holdResumeObj.IsCommentBlank();
            holdResumeObj.MRSLAYERID = mrslayer1.Id;
            holdResumeObj.isHold = true;
            //holdResumeObj.layerStatusUpdateOnProceed();
            MRSHoldResumeExtn.MRSWrapper wrapperObj = new MRSHoldResumeExtn.MRSWrapper(mrsLayer1,2,true,true);
            wrapperObj.mrs = mrsLayer1;
            wrapperObj.layerId = '123';
            wrapperObj.layerName = 'RXAZ(123)';
            wrapperObj.layerStatus = 'In Progress';
            wrapperObj.count = 2;
            //wrapperObj.color = true;
            wrapperObj.isChecked = true;
            wrapperObj.MaskLayerName = 'RXAZ(123)';
            //holdResumeObj.displayProceedData();
            holdResumeObj.setselectedLayerStatus('');
            Test.StopTest();
      //  }
    }
     
   public static testMethod void MRSHoldResume4(){
        // comment-out, refactor with testSetup method setup()
          // SwiftDataUtilityTest.customSystemData();
      Profile p = [SELECT Id FROM Profile Where Name = 'GF FAE/FTS'];
      User u = [Select Id,Name from User Where ProfileId = :p.Id And IsActive=true limit 1];
      Profile sysAdminProfile = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
      User thisUser = [SELECT Id FROM User WHERE ProfileId =:sysAdminProfile.Id and isActive=true and AccountId=null limit 1];
      
      Account acc;
      
      System.runAs (thisUser) {
      
        recordtype rt=[select id from recordtype where sobjecttype='Account' and developername='GLOBALFOUNDRIES_Internal'] ;
        acc = SwiftDataUtilityTest.createTestAccountForDRT();
        System.assertNotEquals(acc,null);
        acc.stage__c = 'Qualified'; 
        update acc;
        
      }
        
     //   System.runAs(u){
        Mask_Set_Title__c mst = SwiftDataUtilityTest.createMST('MYMST');
        insert mst;
                
        PTRF__c ptrf = new PTRF__c(Name='ACOU',Order_Type__c = 'testOrder',Recticle_Type__c='Multi Layer Reticle (MLR)',Customer_jobview__c='Gating Mask Release',MaskSetTitle__c=mst.Id,Customer__c=acc.Id,Prime_Tapeout__c = true,Device_Id__c = '7FA2'  );
        insert ptrf;
        
       Mask_Layer__c maskLayer = new Mask_Layer__c();
        maskLayer.Tapeout__c = true;
        maskLayer.Name = 'layer001' ; 
        maskLayer.Mask_Set_Title__c  = mst.id;
        maskLayer.PTRF__c = ptrf.Id;
        maskLayer.ROM_Code__c = 'AZ';
        maskLayer.Mask_Layer_Rev__c = '01'; 
        maskLayer.LogicalOperation__c = 'Foundry Std'; 
        maskLayer.LogicalOperationType__c = 'Foundry Std.';
         maskLayer.Mask_Layer_Number__c = 'layer001';
        insert maskLayer;       

        
        
        MRS__c mrs = new MRS__c(Full_Sync__c =true,Synced_with_Oracle_DB__c=false,MRS_Package_Sync__c=false,Mask_Set_Title__c=mst.Id);                                   
        insert mrs;
        
        MRS_Layer_Association__c mrsLayer1 = new MRS_Layer_Association__c(Name ='layer001',
                                                                          Synced_with_Oracle_DB__c=false,
                                                                          Mask_Layer_Rev__c = '899',
                                                                          Layer_Name__c = 'testLayer001',
                                                                          Layer_Status__c = 'In Progress',
                                                                          mrs__c = mrs.id,Tech_Geo__c = '0.02');
        insert mrslayer1;                                                                                                                                  
        MRS_Chip_Details__c mrsChip1 = new MRS_Chip_Details__c(Name='chip001',
                                                               Synced_with_Oracle_DB__c=false,
                                                               mrs__c = mrs.id);
        insert mrsChip1;                                                     
        MRS_Layer_Chip_Association__c layerChip1 = new MRS_Layer_Chip_Association__c(Name='layerChip001',
                                                                                     Synced_with_Oracle_DB__c=false,
                                                                                     Send_Prime_Data__c = 'Ready',
                                                                                     Layer__c=mrsLayer1.Id,
                                                                                     Chip__c=mrsChip1.Id,
                                                                                     PTRF__c=ptrf.Id,Device_Id__c = '7FA2',
                                                                                     Tech_Geo__c = '0.02',
                                                                                     Customer_Name__c=acc.Id);
        insert layerChip1;
        
       
        
        Test.StartTest();
        PageReference myVfPage = Page.VFMRSResumeHold;
        Test.setCurrentPage(myVfPage);
        ApexPages.currentPage().getHeaders().put('Host',system.label.Internal_URL);
        ApexPages.StandardController sc = new ApexPages.StandardController(new MRS__c());
       
        MRSHoldResumeExtn holdResumeObj = new MRSHoldResumeExtn(sc);
        system.debug('CHECK PLEASE'+holdResumeObj.lstCustomer.size());
        holdResumeObj.selectedCustomerId = acc.Id;
        holdResumeObj.selectedMST = mst.Id;
        holdResumeObj.MSTIDString = mst.id;
        holdResumeObj.selectedlayerStatus = 'In Progress';
        holdResumeObj.selectedDeviceId = '7FA2';
        holdResumeObj.selectedTechGeo = '0.02';
        holdResumeObj.selectedMSTName = mst.name;
        holdResumeObj.isFilterApplied = false;
       
        holdResumeObj.refreshTable();
        holdResumeObj.acfn_discardfirst();
        Test.StopTest();
      //  }
        
    }     
  
  
   public static testMethod void maskWipHandlerUtilityMethod(){
            Profile sysAdminProfile = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User thisUser = [SELECT Id FROM User WHERE ProfileId =:sysAdminProfile.Id and isActive=true limit 1];
        System.runAs (thisUser) { 
            // comment-out, refactor with testSetup method setup()
          // SwiftDataUtilityTest.customSystemData();
            Mask_Set_Title__c objMST = SwiftDataUtilityTest.createMST('MST001');
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

}