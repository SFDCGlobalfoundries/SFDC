@istest
public class RetryMRSDRTBatchableTest{
// Test method of RetryMRSLayerChipSyncOracleBatchable Class
    @istest (SeeAllData=false)
    static void RetryMRSLayerChipSyncOracleUnitTest() 
    {  
          CreateRetryMRSDRT();
          try
          {
          Test.StartTest();
          List<AsyncApexJob> aajList = [ select id,Status from AsyncApexJob];
            for ( AsyncApexJob aaj : aajList ) {
                System.abortJob(aaj.id);
            } 
          // Test method of RetryMRSLayerChipSyncOracleBatchable Class
          RetryMRSLayerChipSyncOracleBatchable reassign = new RetryMRSLayerChipSyncOracleBatchable();
          reassign.Query= 'SELECT Id, Name FROM MRS_Layer_Chip_Association__c WHERE Synced_with_Oracle_DB__c = false AND LastModifieddate <= TODAY';
          reassign.Field = 'Trigger_Oracle_DB_Sync_Manual__c';
          reassign.Value = True;
          ID batchprocessid = Database.executeBatch(reassign); 
          Test.StopTest(); 
           }
           catch(exception e){} 
    }
    // Test method of RetryDRTpackageSyncOracleBatchable Class
   @istest (SeeAllData=false)
   static void RetryDRTpackageSyncOracleBatchableUnitTest() 
    {  
          CreateRetryMRSDRT();
          try
          {
          Test.StartTest();
          List<AsyncApexJob> aajList = [ select id,Status from AsyncApexJob];
            for ( AsyncApexJob aaj : aajList ) {
                System.abortJob(aaj.id);
            }
          RetryDRTpackageSyncOracleBatchable reassign = new RetryDRTpackageSyncOracleBatchable();
          reassign.Query='SELECT Id, Name FROM DRT__c WHERE DRT_Package_Sync__c=TRUE and Synced_with_Oracle_DB__c = false AND LastModifiedDate <= TODAY';
          reassign.Field = 'Trigger_Oracle_DB_FullPackageSync_Manual__c';
          reassign.Value = True;
          ID batchprocessid = Database.executeBatch(reassign);
          Test.StopTest(); 
           }
           catch(exception e){}   
    }
    // Test method of RetryMRSLayerSyncOracleBatchable Class
    @istest (SeeAllData=false)
    static void RetryMRSLayerSyncOracleBatchableUnitTest() 
    {  
          CreateRetryMRSDRT();
          try
          {
          Test.StartTest();
          List<AsyncApexJob> aajList = [ select id,Status from AsyncApexJob];
            for ( AsyncApexJob aaj : aajList ) {
                System.abortJob(aaj.id);
            }
          RetryMRSLayerSyncOracleBatchable reassign = new RetryMRSLayerSyncOracleBatchable();
          reassign.Query='SELECT Id, Name FROM MRS_Layer_Association__c WHERE Synced_with_Oracle_DB__c = false AND LastModifieddate <= TODAY';
          reassign.Field = 'Trigger_Oracle_DB_Sync_Manual__c';
          reassign.Value = True;
          ID batchprocessid = Database.executeBatch(reassign);
          Test.StopTest(); 
           }
           catch(exception e){}   
    }
    // Test method of RetryMRSChipSyncOracleBatchable Class
    @istest (SeeAllData=false)
    static void RetryMRSChipSyncOracleBatchableUnitTest() 
    {  
          CreateRetryMRSDRT();
          try
          {
          Test.StartTest();
          List<AsyncApexJob> aajList = [ select id,Status from AsyncApexJob];
            for ( AsyncApexJob aaj : aajList ) {
                System.abortJob(aaj.id);
            }
          RetryMRSChipSyncOracleBatchable reassign = new RetryMRSChipSyncOracleBatchable();
          reassign.Query= 'SELECT Id, Name FROM MRS_Chip_Details__c WHERE Synced_with_Oracle_DB__c = false AND LastModifieddate <= TODAY';          
          reassign.Field = 'Trigger_Oracle_DB_Sync_Manual__c';
          reassign.Value = True;
          ID batchprocessid = Database.executeBatch(reassign);
          Test.StopTest(); 
           }
           catch(exception e){}   
    }
     // Test method of RetryMRSLayerStatusSyncdotNETBatchable Class
    @istest (SeeAllData=false)
    static void RetryMRSLayerStatusSyncdotNETBatchableUnitTest() 
    {  
          CreateRetryMRSDRT();
          try
          {
          Test.StartTest();
          List<AsyncApexJob> aajList = [ select id,Status from AsyncApexJob];
            for ( AsyncApexJob aaj : aajList ) {
                System.abortJob(aaj.id);
            }
          RetryMRSLayerStatusSyncdotNETBatchable reassign = new RetryMRSLayerStatusSyncdotNETBatchable();
          reassign.Query='SELECT Id, Name FROM MRS_Layer_Chip_Association__c WHERE Sync_PTRF_Layer_to_SWIFT_dotNET__c = false AND LastModifieddate <= TODAY';
          reassign.Field = 'Trigger_DotNet_Sync_Manual__c';
          reassign.Value = True;
          ID batchprocessid = Database.executeBatch(reassign);
          Test.StopTest(); 
           }
           catch(exception e){}   
    }
    // Test method of retryMRSNotesSyncOracleBatchable Class
    @istest (SeeAllData=false)
    static void retryMRSNotesSyncOracleBatchableUnitTest() 
    {  
          CreateRetryMRSDRT();
          try
          {
          Test.StartTest();
          List<AsyncApexJob> aajList = [ select id,Status from AsyncApexJob];
            for ( AsyncApexJob aaj : aajList ) {
                System.abortJob(aaj.id);
            }
          retryMRSNotesSyncOracleBatchable reassign = new retryMRSNotesSyncOracleBatchable();
          reassign.Query='SELECT Id, Name FROM Notes__c WHERE Synced_with_Oracle_DB__c = false AND LastModifieddate <= TODAY';
          reassign.Field = 'Trigger_Oracle_DB_Sync_Manual__c';
          reassign.Value = True;
          ID batchprocessid = Database.executeBatch(reassign);
          Test.StopTest(); 
           }
           catch(exception e){}   
    }
 // Test method of RetryDRTassctnSyncOracleBatchable Class
    @istest (SeeAllData=false)
    static void RetryDRTassctnSyncOracleBatchableUnitTest() 
    {  
          CreateRetryMRSDRT();
          try
          {
          Test.StartTest();
          List<AsyncApexJob> aajList = [ select id,Status from AsyncApexJob];
            for ( AsyncApexJob aaj : aajList ) {
                System.abortJob(aaj.id);
            }
          RetryDRTassctnSyncOracleBatchable reassign = new RetryDRTassctnSyncOracleBatchable();
          reassign.Query='SELECT Id, Name FROM Frame_DRT_Association__c WHERE Synced_with_Oracle_DB__c = false AND LastModifieddate <= TODAY';
          reassign.Field = 'Trigger_Oracle_DB_Sync_Manual__c';
          reassign.Value = True;
          ID batchprocessid = Database.executeBatch(reassign);
          Test.StopTest(); 
           }
           catch(exception e){}   
    }
    // Test method of RetryTapeoutAppSyncOracleBatchable Class
    @istest (SeeAllData=false)
    static void RetryTapeoutAppSyncOracleBatchableUnitTest() 
    {  
          CreateRetryMRSDRT();
          try
          {
          Test.StartTest();
          List<AsyncApexJob> aajList = [ select id,Status from AsyncApexJob];
            for ( AsyncApexJob aaj : aajList ) {
                System.abortJob(aaj.id);
            }
          RetryTapeoutAppSyncOracleBatchable reassign = new RetryTapeoutAppSyncOracleBatchable();
          reassign.Query='SELECT Id, Name FROM Tapeout_Applications_MEBES_Jobview_Confi__c WHERE Synced_with_Oracle_DB__c = false AND LastModifieddate <= TODAY';
          reassign.Field = 'Trigger_Oracle_DB_Sync_Manual__c';
          reassign.Value = True;
          ID batchprocessid = Database.executeBatch(reassign);
          Test.StopTest(); 
           }
           catch(exception e){}   
    }
    // Test method of RetryDRTsyncOracleBatchable Class
    @istest (SeeAllData=false)
    static void RetryDRTsyncOracleBatchableUnitTest() 
    {  
          CreateRetryMRSDRT();
          try
          {
          Test.StartTest();
          List<AsyncApexJob> aajList = [ select id,Status from AsyncApexJob];
            for ( AsyncApexJob aaj : aajList ) {
                System.abortJob(aaj.id);
            }
          RetryDRTsyncOracleBatchable reassign = new RetryDRTsyncOracleBatchable();
          reassign.Query= 'SELECT Id, Name FROM DRT__c WHERE Synced_with_Oracle_DB__c = false AND LastModifieddate <= TODAY';
          reassign.Field = 'Trigger_Oracle_DB_Sync_Manual__c';
          reassign.Value = True;
          ID batchprocessid = Database.executeBatch(reassign);
          Test.StopTest(); 
           }
           catch(exception e){}   
    }
  // Test method of RetryMRSsyncOracleBatchable Class
    @istest (SeeAllData=false)
    static void RetryMRSsyncOracleBatchableUnitTest() 
    {  
          CreateRetryMRSDRT();
          try
          {
          Test.StartTest();
          List<AsyncApexJob> aajList = [ select id,Status from AsyncApexJob];
            for ( AsyncApexJob aaj : aajList ) {
                System.abortJob(aaj.id);
            }
          RetryMRSsyncOracleBatchable reassign = new RetryMRSsyncOracleBatchable();
          reassign.Query='SELECT Id, Name FROM MRS__c WHERE Synced_with_Oracle_DB__c = false AND LastModifieddate <= TODAY';
          reassign.Field = 'Trigger_Oracle_DB_Sync_Manual__c';
          reassign.Value = True;
          ID batchprocessid = Database.executeBatch(reassign);
          Test.StopTest(); 
           }
           catch(exception e){}   
    }
    // Test method of RetryPrimeDRTLayerSyncOracleBatchable Class
    @istest (SeeAllData=false)
    static void RetryPrimeDRTLayerSyncOracleBatchableUnitTest() 
    {  
          CreateRetryMRSDRT();
          try
          {
          Test.StartTest();
          List<AsyncApexJob> aajList = [ select id,Status from AsyncApexJob];
            for ( AsyncApexJob aaj : aajList ) {
                System.abortJob(aaj.id);
            }
          RetryPrimeDRTLayerSyncOracleBatchable reassign = new RetryPrimeDRTLayerSyncOracleBatchable();
          reassign.Query='SELECT Id, Name FROM PRIME_DRT_Chip_Layer_Summary__c WHERE Synced_with_Oracle_DB__c = false AND LastModifieddate <= TODAY';
          reassign.Field = 'Trigger_Oracle_DB_Sync_Manual__c';
          reassign.Value = True;
          ID batchprocessid = Database.executeBatch(reassign);
          Test.StopTest(); 
           }
           catch(exception e){}   
    }
  // Test method of RetryMRSPrimeFrameSyncdotNETBatchable Class
    @istest (SeeAllData=false)
    static void RetryMRSPrimeFrameSyncdotNETBatchableUnitTest() 
    {  
          CreateRetryMRSDRT();
          try
          {
          Test.StartTest();
          List<AsyncApexJob> aajList = [ select id,Status from AsyncApexJob];
            for ( AsyncApexJob aaj : aajList ) {
                System.abortJob(aaj.id);
            }
            
          RetryMRSPrimeFrameSyncdotNETBatchable reassign = new RetryMRSPrimeFrameSyncdotNETBatchable();
          reassign.Query='SELECT Id, Name,All_Send_Prime_Done__c,All_Send_Frame_Done__c FROM MRS_Layer_Chip_Association__c WHERE  Sync_PTRF_Layer_SendPrimeFrame_dotNET__c = false AND LastModifieddate<= TODAY';
          reassign.Value = True;
          ID batchprocessid = Database.executeBatch(reassign);
          
          RetryMRSPrimeFrameSyncdotNETBatchable reassign2 = new RetryMRSPrimeFrameSyncdotNETBatchable();
          reassign2.Query='SELECT Id, Name,All_Send_Prime_Done__c,All_Send_Frame_Done__c FROM MRS_Layer_Chip_Association__c WHERE  Sync_PTRF_Layer_SendPrimeFrame_dotNET__c = false AND LastModifieddate<= TODAY';
          reassign2.Value = True;
          ID batchprocessid2= Database.executeBatch(reassign2);
          
          RetryMRSPrimeFrameSyncdotNETBatchable reassign1 = new RetryMRSPrimeFrameSyncdotNETBatchable();
          //reassign.Query='SELECT Id, Name,All_Send_Prime_Done__c,All_Send_Frame_Done__c FROM MRS_Layer_Chip_Association__c WHERE Sync_PTRF_Layer_SendPrimeFrame_dotNET__c = false AND LastModifieddate<= TODAY';
          //reassign1.Value = True;
          ID batchprocessid1 = Database.executeBatch(reassign1);
          
          Test.StopTest(); 
           }
           catch(exception e){}   
    }
    
 // Test method of RetryDRTPTRFsyncOracleBatchable Class
    @istest (SeeAllData=false)
    static void RetryDRTPTRFsyncOracleBatchableUnitTest() 
    {  
          CreateRetryMRSDRT();
          try
          {
          Test.StartTest();
          List<AsyncApexJob> aajList = [ select id,Status from AsyncApexJob];
            for ( AsyncApexJob aaj : aajList ) {
                System.abortJob(aaj.id);
            }
          RetryDRTPTRFsyncOracleBatchable reassign = new RetryDRTPTRFsyncOracleBatchable();
          reassign.Query='SELECT Id, Name FROM DRT_PTRF_Association__c WHERE Synced_with_Oracle_DB__c = false AND LastModifiedDate <= TODAY';
          reassign.Field = 'Trigger_Oracle_DB_Sync_Manual__c';
          reassign.Value = True;
          ID batchprocessid = Database.executeBatch(reassign);
          Test.StopTest(); 
           }
           catch(exception e){}   
    }
    // Test method of RetryFrameDisapprvlSyncdotNETBatchable Class
    @istest (SeeAllData=false)
    static void RetryFrameDisapprvlSyncdotNETBatchableUnitTest() 
    {  
          CreateRetryMRSDRT();
          try
          {
          Test.StartTest();
          List<AsyncApexJob> aajList = [ select id,Status from AsyncApexJob];
            for ( AsyncApexJob aaj : aajList ) {
                System.abortJob(aaj.id);
            }
          RetryFrameDisapprvlSyncdotNETBatchable reassign = new RetryFrameDisapprvlSyncdotNETBatchable();
          reassign.Query='SELECT Id, Name FROM Notes__c WHERE Frame_Disapproval_Sync_with_dotNET__c = false AND LastModifieddate <= TODAY';
          reassign.Field = 'Trigger_Oracle_DB_FrameMockup_Sync_Manua__c';
          reassign.Value = True;
          ID batchprocessid = Database.executeBatch(reassign);
          Test.StopTest(); 
           }
           catch(exception e){}   
    }
     // Test method of RetryFrameDisapprvlSyncdotNETBatchable Class
    
    @istest (SeeAllData=false)
    static void RetyFabDistriSyncOracleBatchableUnitTest() 
    {  
          CreateRetryMRSDRT();
          
          try
          {
          Test.StartTest();
          List<AsyncApexJob> aajList = [ select id,Status from AsyncApexJob];
            for ( AsyncApexJob aaj : aajList ) {
                System.abortJob(aaj.id);
            }
          RetyFabDistriSyncOracleBatchable reassign = new RetyFabDistriSyncOracleBatchable();
          reassign.Query='SELECT Id, Name FROM Fab_Distribution_Table__c WHERE Synced_with_Oracle_DB__c = false AND LastModifieddate <= TODAY';
          reassign.Field = 'Trigger_Oracle_DB_Sync_Manual__c';
          reassign.Value = True;
          ID batchprocessid = Database.executeBatch(reassign);
          Test.StopTest(); 
           }
           catch(exception e){}   
    }
   // Test method of RetryMSTconfigSyncOracleBatchable Class
    @istest (SeeAllData=false)
    static void RetryMSTconfigSyncOracleBatchableUnitTest() 
    {  
          CreateRetryMRSDRT();
          try
          {
          Test.StartTest();
          List<AsyncApexJob> aajList = [ select id,Status from AsyncApexJob];
            for ( AsyncApexJob aaj : aajList ) {
                System.abortJob(aaj.id);
            }
          RetryMSTconfigSyncOracleBatchable reassign = new RetryMSTconfigSyncOracleBatchable();
          reassign.Query='SELECT Id, Name FROM MST_Config__c WHERE Synced_with_Oracle_DB__c = false AND LastModifieddate <= TODAY';
          reassign.Field = 'Trigger_Oracle_DB_Sync_Manual__c';
          reassign.Value = True;
          ID batchprocessid = Database.executeBatch(reassign);
          Test.StopTest(); 
           }
           catch(exception e){}   
    } 
  // Test method of RetryMRSpackageSyncOracleBatchable Class
    
    @istest (SeeAllData=false)
    static void RetryMRSpackageSyncOracleBatchableUnitTest() 
    {  
          CreateRetryMRSDRT();
          try
          {
          Test.StartTest();
          List<AsyncApexJob> aajList = [ select id,Status from AsyncApexJob];
            for ( AsyncApexJob aaj : aajList ) {
                System.abortJob(aaj.id);
            }
          RetryMRSpackageSyncOracleBatchable reassign = new RetryMRSpackageSyncOracleBatchable();
          reassign.Query='SELECT Id, Name FROM MRS__c WHERE Synced_with_Oracle_DB__c = false AND LastModifieddate <= TODAY';
          reassign.Field = 'Trigger_Oracle_DB_FullPackageSync_Manual__c';
          reassign.Value = True;
          ID batchprocessid = Database.executeBatch(reassign);
          Test.StopTest(); 
           }
           catch(exception e){}   
    }
    // Test method of RetryMSTsyncOracleBatchable Class
    @istest (SeeAllData=false)
    static void RetryMSTsyncOracleBatchableUnitTest() 
    {  
          CreateRetryMRSDRT();
          try
          {
          Test.StartTest();
          List<AsyncApexJob> aajList = [ select id,Status from AsyncApexJob];
            for ( AsyncApexJob aaj : aajList ) {
                System.abortJob(aaj.id);
            }
          RetryMSTsyncOracleBatchable reassign = new RetryMSTsyncOracleBatchable();
          reassign.Query='SELECT Id, Name FROM Mask_Set_Title__c WHERE Synced_with_Oracle_DB__c = false AND LastModifieddate <= TODAY';
          reassign.Field = 'Trigger_Oracle_DB_Sync_Manual__c';
          reassign.Value = True;
          ID batchprocessid = Database.executeBatch(reassign);
          Test.StopTest(); 
           }
           catch(exception e){}   
    } 
     // Test method of RetryPrimeDRTchipSyncOracleBatchable Class
   @istest (SeeAllData=false)
   static void RetryPrimeDRTchipSyncOracleBatchableUnitTest() 
    {  
          CreateRetryMRSDRT();
          try
          {
          Test.StartTest();
          List<AsyncApexJob> aajList = [ select id,Status from AsyncApexJob];
            for ( AsyncApexJob aaj : aajList ) {
                System.abortJob(aaj.id);
            } 
          RetryPrimeDRTchipSyncOracleBatchable reassign = new RetryPrimeDRTchipSyncOracleBatchable();
          reassign.Query='SELECT Id, Name FROM PRIME_DRT_Chip_Association__c WHERE Synced_with_Oracle_DB__c = false AND LastModifieddate <= TODAY';
          reassign.Field = 'Trigger_Oracle_DB_Sync_Manual__c';
          reassign.Value = True;
          ID batchprocessid = Database.executeBatch(reassign);
          Test.StopTest(); 
           }
           catch(exception e){}   
    } 
      // Test method of RetryDRTLayerChipSyncOracleBatchable Class
    @istest (SeeAllData=false)
    static void RetryDRTLayerChipSyncOracleBatchableUnitTest() 
    {  
          CreateRetryMRSDRT();
          try
          {
          Test.StartTest();
          List<AsyncApexJob> aajList = [ select id,Status from AsyncApexJob];
            for ( AsyncApexJob aaj : aajList ) {
                System.abortJob(aaj.id);
            }
          RetryDRTLayerChipSyncOracleBatchable reassign = new RetryDRTLayerChipSyncOracleBatchable();
          reassign.Query='SELECT Id, Name FROM PRIME_DRT_Chip_Association__c WHERE Synced_with_Oracle_DB__c = false AND LastModifieddate <= TODAY';
          reassign.Field = 'Trigger_Oracle_DB_Sync_Manual__c';
          reassign.Value = True;
          ID batchprocessid = Database.executeBatch(reassign);
          Test.StopTest(); 
           }
           catch(exception e){}   
    } 
   // Test method of RetryDRTsyncdotNETBatchable Class
    @istest (SeeAllData=false)
    static void RetryDRTsyncdotNETBatchableUnitTest() 
    {  
          CreateRetryMRSDRT();
          try
          {
          Test.StartTest();
          List<AsyncApexJob> aajList = [ select id,Status from AsyncApexJob];
            for ( AsyncApexJob aaj : aajList ) {
                System.abortJob(aaj.id);
            }
          RetryDRTsyncdotNETBatchable reassign = new RetryDRTsyncdotNETBatchable();
          reassign.Query= 'SELECT Id, Name FROM DRT__c WHERE Sync_DRT_Rev_dot_NET__c = false AND LastModifieddate <= TODAY';
          reassign.Field = 'Trigger_Oracle_DB_ReviseSync_Manual__c';
          reassign.Value = True;
          ID batchprocessid = Database.executeBatch(reassign);
          Test.StopTest(); 
           }
           catch(exception e){}   
    } 

    //Method to create Records
    public static void CreateRetryMRSDRT()
    {
         list<Environment_Variable__c> lstEV = new list<Environment_Variable__c>();
          lstEV.add(new Environment_Variable__c(Name='MRSSyncObject', Value__c='MRS'));
          lstEV.add(new Environment_Variable__c(Name='DRTSyncObject', Value__c='DRT'));
          lstEV.add(new Environment_Variable__c(Name='SWIFT_ADMIN_EMAIL', Value__c='swiftadmin@gf.com;cadadmin@gf.com'));
          
          try{
              insert lstEV;
          }catch(exception e){}
          Mask_Set_Title__c mst = SwiftDataUtilityTest.createMST('TESTMST');
          insert mst;
          
          DRT__c drt=new DRT__c(name='DRT001',Mask_Set_Title__c=mst.Id,DRT_Package_Sync__c=TRUE,Synced_with_Oracle_DB__c = false);
          insert drt;
   
          PTRF__c ptrf = new PTRF__c(Name='ACOU001',
                                     MaskSetTitle__c =mst.Id,
                                     Order_Type__c = 'testOrder001',
                                     //Synced_with_Oracle_DB__c=false,
                                     Recticle_Type__c='Multi Layer Reticle (MLR)',
                                     Customer_jobview__c='Gating Mask Release'
                                     //createddate=System.now().adddays(-2),
                                     //lastmodifieddate=System.now().adddays(-1)
                                     );
          insert ptrf;
          
          PRIME_DRT_Chip_Association__c pdrtchip=new PRIME_DRT_Chip_Association__c(Name='Primedrt001',Mask_Set_Title__c=mst.Id,DRT__c=drt.Id,Synced_with_Oracle_DB__c = false);

          insert pdrtchip;
          
          MRS__c mrs = new MRS__c(Full_Sync__c =true,
                                   Synced_with_Oracle_DB__c=false,
                                   MRS_Package_Sync__c=false,
                                   Mask_Set_Title__c=mst.Id
                                   //createddate=System.now().adddays(-2),
                                   //lastmodifieddate=System.now().adddays(-1)
                                   );
          insert mrs;                             
          MRS_Layer_Association__c mrsLayer = new MRS_Layer_Association__c(Name ='layer001',
                                                                           Synced_with_Oracle_DB__c=false,
                                                                           Mask_Layer_Rev__c = '899',
                                                                           Layer_Name__c = 'testLayer001',
                                                                           Layer_Status__c = 'Not Ready',
                                                                           mrs__c = mrs.id
                                                                           //createddate=System.now().adddays(-2),
                                                                           //lastmodifieddate=System.now().adddays(-1)
                                                                           );
          insert mrslayer;  
                                                                                                                                                    
          MRS_Chip_Details__c mrsChip = new MRS_Chip_Details__c(Name='chip001',
                                                                Synced_with_Oracle_DB__c=false,
                                                                mrs__c = mrs.id
                                                                //createddate=System.now().adddays(-2),
                                                                //lastmodifieddate=System.now().adddays(-2)
                                                                );
          insert mrsChip;  
          
          MST_Config__c mstconfig=new MST_Config__c(Mask_Set_Title__c=mst.Id,Synced_with_Oracle_DB__c = false);
          insert mstconfig;
          
          MRS_Layer_Chip_Association__c layerChip = new MRS_Layer_Chip_Association__c(Name='layerChip001',
                                                                                      Synced_with_Oracle_DB__c=false,
                                                                                      //createddate=System.now().adddays(-2),
                                                                                      //lastmodifieddate=System.now().adddays(-1),
                                                                                      Layer__c=mrsLayer.Id,
                                                                                      Chip__c=mrsChip.Id,
                                                                                      PTRF__c=ptrf.Id,
                                                                                      All_Send_Frame_Done__c = TRUE,
                                                                                      All_Send_Prime_Done__c=TRUE,
                                                                                      Sync_PTRF_Layer_SendPrimeFrame_dotNET__c = false);
          
         
          insert layerChip;
          
          MRS_Layer_Chip_Association__c layerChip1 = new MRS_Layer_Chip_Association__c(Name='layerChip002',
                                                                                      Synced_with_Oracle_DB__c=false,
                                                                                      //createddate=System.now().adddays(-2),
                                                                                      //lastmodifieddate=System.now().adddays(-1),
                                                                                      Layer__c=mrsLayer.Id,
                                                                                      Chip__c=mrsChip.Id,
                                                                                      PTRF__c=ptrf.Id,
                                                                                      All_Send_Frame_Done__c = TRUE,
                                                                                      All_Send_Prime_Done__c=TRUE,
                                                                                      Sync_PTRF_Layer_SendPrimeFrame_dotNET__c = false);
          
         
          insert layerChip1;
          
          Fab_Distribution_Table__c febDisTab=new Fab_Distribution_Table__c(Fab_No__c='FAB 1',Distribution_List__c='Test011',Synced_with_Oracle_DB__c = false,Trigger_Oracle_DB_Sync_Manual__c=false,isDeleted__c=false);
          insert febDisTab;
          
          Notes__c notes=new Notes__c(Synced_with_Oracle_DB__c = false,MRS_Layer_Association__c=mrslayer.Id,ParentId__c=layerChip.Id);
          insert notes;
          
          DRT_PTRF_Association__c drtptrfass=new DRT_PTRF_Association__c(Synced_with_Oracle_DB__c = false,
                                                                         DRT__c=drt.Id,
                                                                         PTRF__c=ptrf.Id);
          insert drtptrfass;
          
          PRIME_DRT_Layer_Association__c primedrtlayerasso=new PRIME_DRT_Layer_Association__c(name='Test001',DRT__c=drt.Id,Synced_with_Oracle_DB__c = false);
          try{
          insert primedrtlayerasso;
          }catch(exception e){}
          
          Frame_DRT_Association__c frmdrtassociation=new Frame_DRT_Association__c(DRT__c=drt.Id,Mask_Set_Title__c=mst.Id,Synced_with_Oracle_DB__c = false);
          insert frmdrtassociation;
          
          Tapeout_Applications_MEBES_Jobview_Confi__c TapAppMeb=new Tapeout_Applications_MEBES_Jobview_Confi__c(Synced_with_Oracle_DB__c = false,Tapeout_Application_Jobview__c='Test001');
          insert TapAppMeb;
          
          PRIME_DRT_Chip_Layer_Summary__c primedrtSummary=new PRIME_DRT_Chip_Layer_Summary__c(Synced_with_Oracle_DB__c = false,
                                   Chip__c=pdrtchip.Id,Layer__c=primedrtlayerasso.id);
          insert primedrtSummary;
    }
   
    //Test coverage of MRSCADResponseCalloutService
    
    MRSCADResponseCalloutService.chipLayerStatus chiplyrSt=new MRSCADResponseCalloutService.chipLayerStatus();
    MRSCADResponseCalloutService.serviceMRSfeedbackResponse_element sermrsfdbkRes=new MRSCADResponseCalloutService.serviceMRSfeedbackResponse_element();
    MRSCADResponseCalloutService.layer layer1=new MRSCADResponseCalloutService.layer();
    MRSCADResponseCalloutService.serviceMRSfeedbackRequest sermrsfdbkReq=new MRSCADResponseCalloutService.serviceMRSfeedbackRequest();
    MRSCADResponseCalloutService.transactionStatus tranStatus=new MRSCADResponseCalloutService.transactionStatus();  
    
@istest (SeeAllData=true)
Public static void testSync_MEBES(){
            
            User sysAdminUser = [SELECT Id,Name FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true].get(0);
            List<HCM_Employee__c> hcmList = SwiftDataUtilityTest.createHCMEmployee(5);
          
          
          system.runAs(sysAdminUser)
          {
          list<User> u1List = SwiftDataUtilityTest.createTestUser(hcmList);
          User u1 = u1List[1];
          
          
          list<Mask_Set_Title__c> lstMst = new list<Mask_Set_Title__c>();
          Mask_Set_Title__c mst = SwiftDataUtilityTest.createMST('QWERTY');
          //insert mst;
          lstMst.add(mst);
          Mask_Set_Title__c mst1 = SwiftDataUtilityTest.createMST('WERTYQ');
          //insert mst1;
          lstMst.add(mst1);
          insert lstMst;
          //mst = lstMst.get(0);
          //mst1 = lstMst.get(1);
          
          PTRF__c ptrf1 = new PTRF__c(Name='PTRF-QWERTY',Order_Type__c = 'testOrder1',Recticle_Type__c='Multi Layer Reticle (MLR)',Customer_jobview__c='Gating Mask Release');
          insert ptrf1;
          ////
          PTRF__c ptrf2 = new PTRF__c(Name='ABC2D',Order_Type__c = 'testOrder2',Recticle_Type__c='Multi Layer Reticle (MLR)',Customer_jobview__c='Gating Mask Release');
          insert ptrf2;
          ////
          MRS__c mrs1 = new MRS__c(Full_Sync__c =true,
                                   Synced_with_Oracle_DB__c=false,
                                   MRS_Package_Sync__c=false,
                                   Mask_Set_Title__c=mst.Id);
          insert mrs1;                             
          MRS_Layer_Association__c mrsLayer1 = new MRS_Layer_Association__c(Name ='testLayer001',
                                                                           Synced_with_Oracle_DB__c=false,
                                                                           Mask_Layer_Rev__c = '899',
                                                                           Layer_Name__c = 'testLayer001',
                                                                           Layer_Status__c = 'Not Ready',
                                                                           mrs__c = mrs1.id);
          insert mrslayer1;  
          MRS_Layer_Association__c mrsLayer2 = new MRS_Layer_Association__c(Name ='testLayer002',
                                                                           Synced_with_Oracle_DB__c=false,
                                                                           Mask_Layer_Rev__c = '900',
                                                                           Layer_Name__c = 'testLayer002',
                                                                           Layer_Status__c = 'Not Ready',
                                                                           mrs__c = mrs1.id);
          insert mrslayer2; 
                                                                                                                                          
          MRS_Chip_Details__c mrsChip1 = new MRS_Chip_Details__c(Name='chip001',
                                                                Synced_with_Oracle_DB__c=false,
                                                                mrs__c = mrs1.id);
          insert mrsChip1; 
           MRS_Chip_Details__c mrsChip2 = new MRS_Chip_Details__c(Name='Frame',
                                                                Synced_with_Oracle_DB__c=false,
                                                                mrs__c = mrs1.id);
          insert mrsChip2;                                                     
          MRS_Layer_Chip_Association__c layerChip1 = new MRS_Layer_Chip_Association__c(Name='layerChip001',
                                                                                      Synced_with_Oracle_DB__c=false,
                                                                                      Send_Frame_Data__c = 'N.A.',
                                                                                      Send_Prime_Data__c = 'N.A.',
                                                                                      
                                                                                      Layer__c=mrsLayer1.Id,
                                                                                      Foundry_GDSOUT_Review__c = 'Not Ready',
                                                                                      Chip__c=mrsChip1.Id,
                                                                                      PTRF__c=ptrf1.Id,
                                                                                      GlobalShuttle_MEBES_Jobview__c= 'Not Ready',
                                                                                      TDTI_MPW_MEBES_Jobview__c = 'Not Ready',
                                                                                      MDP_MEBES_Jobview__c = 'Not Ready',
                                                                                      Tapeout_Centre_MEBES_Jobview__c = 'Not Ready',
                                                                                      Tapeout_Applications_MEBES_Jobview__c = 'Not Ready',
                                                                                      Foundry_MEBES_Jobview__c = 'Not Ready',
                                                                                      Customer_MEBES_Jobview__c = 'Not Ready'
                                                                                      );
          insert layerChip1;
           MRS_Layer_Chip_Association__c layerChip2 = new MRS_Layer_Chip_Association__c(Name='Frame',
                                                                                      Synced_with_Oracle_DB__c=false,
                                                                                      Send_Frame_Data__c = 'N.A.',
                                                                                      Send_Prime_Data__c = 'N.A.',
                                                                                      Layer__c=mrsLayer1.Id,
                                                                                      Foundry_GDSOUT_Review__c = 'Not Ready',
                                                                                      Chip__c=mrsChip2.Id,
                                                                                      PTRF__c=ptrf1.Id,
                                                                                      GlobalShuttle_MEBES_Jobview__c= 'Not Ready',
                                                                                      TDTI_MPW_MEBES_Jobview__c = 'Not Ready',
                                                                                      MDP_MEBES_Jobview__c = 'Not Ready',
                                                                                      Tapeout_Centre_MEBES_Jobview__c = 'Not Ready',
                                                                                      Tapeout_Applications_MEBES_Jobview__c = 'Not Ready',
                                                                                      Foundry_MEBES_Jobview__c = 'Not Ready',
                                                                                      Customer_MEBES_Jobview__c = 'Not Ready');
          insert layerChip2;
          
          PTRF_JobViewer_Info__c tempJobViewer = new PTRF_JobViewer_Info__c(Name='testJobViewer',User__c=u1.Id,
                                                                      PTRF__c=ptrf1.Id,Jobview__c='Foundry',Jobview_Type__c='MEBES Jobview',
                                                                      Email_Address__c='satyajit.kumarsingh@cognizant.com');
          insert tempJobViewer;
            list<string> lstchipNotFound = new list<string>();
            list<string> lstLayerNotFound = new list<string>();
            String chipNotFound = 'chip004';  
            String layerNotFound = 'layer003';
            lstchipNotFound.add(chipNotFound);
            lstLayerNotFound.add(layerNotFound);
           
           
         
            MRS_CADService.MSTPtrfChipLayer PtrfChipLayer = new MRS_CADService.MSTPtrfChipLayer();
            MRS_CADService.mstPtrfChipLayerList = new List<MRS_CADService.MSTPtrfChipLayer>(); 
            
            //Test method for class LayerData
            List<MRS_CADService.LayerData> tempLayerData= new List<MRS_CADService.LayerData>();
            MRS_CADService.LayerData templyr ;
            for(Integer i=0;i<1;i++){
            templyr= new MRS_CADService.LayerData();
            templyr.maskLayer = 'testLayer001';
            templyr.maskRev = '899';
            templyr.resetFlag = true;
            templyr.jobStatus = 'SUCCESS';
            tempLayerData.add(templyr);
            }
            
            /////
            MRS_CADService.LayerData templyr1 ;
            for(Integer i=0;i<1;i++){
            templyr1= new MRS_CADService.LayerData();
            templyr1.maskLayer = 'testLayer002';
            templyr1.maskRev = '900';
            templyr1.resetFlag = true;
            templyr1.jobStatus = 'SUCCESS';
            tempLayerData.add(templyr1);
            }         
            /////
            
            /////
            /**
            MRS_CADService.LayerData templyr2 ;
            for(Integer i=0;i<1;i++){
            templyr2= new MRS_CADService.LayerData();
            templyr2.maskLayer = 'testLayer002';
            templyr2.maskRev = '900';
            templyr2.resetFlag = false;
            templyr2.jobStatus = 'SUCCESS';
            tempLayerData.add(templyr2);
            }    
            **/
            /////
                
            //Test method for class ChipData
            List<MRS_CADService.ChipData> tempChipData = new List<MRS_CADService.ChipData>();
            MRS_CADService.ChipData tempChip;
            for(Integer i=0;i<1;i++){
            tempChip = new MRS_CADService.ChipData();
            tempChip.chipName = 'chip001';
            tempChip.chipType = 'testChipType';
            tempChip.layer = new list<MRS_CADService.LayerData>();
            tempChip.layer.addAll(tempLayerData);
            tempChipData.add(tempChip);
            }
            /////
            MRS_CADService.ChipData tempChip1;
            for(Integer i=0;i<1;i++){
            tempChip1 = new MRS_CADService.ChipData();
            tempChip1.chipName = 'Frame';
            tempChip1.chipType = 'Frame';
            tempChip1.layer = new list<MRS_CADService.LayerData>();
            tempChip1.layer.addAll(tempLayerData);
            tempChipData.add(tempChip1);
            }
            /////            

            //Test method for class PTRFData
            List<MRS_CADService.PTRFData> tempPtrf = new List<MRS_CADService.PTRFData>();
            MRS_CADService.PTRFData tempPtrfData;
            for(Integer i=0;i<1;i++){
            tempPtrfData= new MRS_CADService.PTRFData();
            tempPtrfData.ptrfNumber ='PTRF-QWERTY';
            tempPtrfData.technology = 'testTech';
            tempPtrfData.chip = new list<MRS_CADService.ChipData>();
            tempPtrfData.chip.addAll(tempChipData);
            //tempPtrfData.chip = tempChipData; 
            tempPtrf.add(tempPtrfData);
            }
            
            ////////
            /**
            MRS_CADService.PTRFData tempPtrfData1;
            for(Integer i=0;i<1;i++){
            tempPtrfData1= new MRS_CADService.PTRFData();
            tempPtrfData1.ptrfNumber ='ABCD';
            tempPtrfData1.technology = 'testTech1';
            tempPtrfData1.chip = new list<MRS_CADService.ChipData>();
            tempPtrfData1.chip.addAll(tempChipData);
 
            tempPtrf.add(tempPtrfData1);
            }
           **/
            // Test sync_Remote_Jobview_Setup_Ready()
            List<MRS_CADService.JobDeckData> lstJobDeck = new List<MRS_CADService.JobDeckData>();
            MRS_CADService.JobDeckData tempDeckData;
            for(Integer i=0;i<1;i++){
            tempDeckData= new MRS_CADService.JobDeckData();
            tempDeckData.jobDeck = 'testJobDeck';
            lstJobDeck.add(tempDeckData);
            }
            /////
            MRS_CADService.JobDeckData tempDeckData1;
            for(Integer i=0;i<1;i++){
            tempDeckData1= new MRS_CADService.JobDeckData();
            tempDeckData1.jobDeck = 'testJobDeck1';
            lstJobDeck.add(tempDeckData1);
            }           
            /////
            List<MRS_CADService.JobViewData> lstJobView = new List<MRS_CADService.JobViewData>();
            MRS_CADService.JobViewData tempjobView;
            for(Integer i=0;i<1;i++){
            tempjobView= new MRS_CADService.JobViewData();
            tempjobView.jobViewGroup = 'Customer';
            tempjobView.jobViewType = 'Mask_Layout';
            tempjobView.jobViewRemarks = 'testViewRemarks';
            tempjobView.jobDecks = lstJobDeck;
            tempjobView.emailToList = 'testEmailLists';
            tempjobView.ptrf = tempPtrf;
            lstJobView.add(tempjobView);
            }
            
            /////
            
            
            List<MRS_CADService.MRSDataRecievedOnSyncRemoteJobView> lstSendResmoteJob = new List<MRS_CADService.MRSDataRecievedOnSyncRemoteJobView>();  
            //MRS_CADService.MRSDataRecievedOnSyncRemoteJobView tempRemoteJobView;
            for(Integer i=0;i<1;i++){
            MRS_CADService.MRSDataRecievedOnSyncRemoteJobView tempRemoteJobView = new MRS_CADService.MRSDataRecievedOnSyncRemoteJobView();
            tempRemoteJobView.messageID = 'testmsg01';
            tempRemoteJobView.maskSetTitle = mst.Name;
            tempRemoteJobView.jobView = lstJobView;
            lstSendResmoteJob.add(tempRemoteJobView);
            }
            
            ////
            for(Integer i=0;i<1;i++){
            MRS_CADService.MRSDataRecievedOnSyncRemoteJobView tempRemoteJobView1 = new MRS_CADService.MRSDataRecievedOnSyncRemoteJobView();
            tempRemoteJobView1.messageID = 'testmsg02';
            tempRemoteJobView1.maskSetTitle = mst1.Name;
            tempRemoteJobView1.jobView = lstJobView;
            lstSendResmoteJob.add(tempRemoteJobView1);
            }
            // test sync_Receive_MEBES_Data_from_Maskshop()
            List<MRS_CADService.MRSDataRecievedOnSyncMEBESReceive> lstSyncMEBES = new List<MRS_CADService.MRSDataRecievedOnSyncMEBESReceive>();
            MRS_CADService.MRSDataRecievedOnSyncMEBESReceive tmepSyncMEBES;
            
            tmepSyncMEBES= new MRS_CADService.MRSDataRecievedOnSyncMEBESReceive();
            tmepSyncMEBES.messageID = 'testmsg01';
            tmepSyncMEBES.maskSetTitle = mst.Name;
            tmepSyncMEBES.jobdecks = lstJobDeck;
            tmepSyncMEBES.jobViewRemarks = 'testjobViewRemarks';
            tmepSyncMEBES.ptrf = tempPtrf;
            tmepSyncMEBES.customerJobViewAtFoundry = true;
            lstSyncMEBES.add(tmepSyncMEBES);         
            
             test.startTest();
            MRS_CADService.sync_Receive_MEBES_Data_from_Maskshop(lstSyncMEBES);
           test.stopTest();
           MRS_CADService.MRSDataRecievedOnSyncMEBESReceive tmepSyncMEBES1;
            /**
            lstSyncMEBES.clear();
            tmepSyncMEBES1= new MRS_CADService.MRSDataRecievedOnSyncMEBESReceive();
            tmepSyncMEBES1.messageID = 'testmsg06';
            tmepSyncMEBES1.maskSetTitle = mst1.Name;
            tmepSyncMEBES1.jobdecks = lstJobDeck;
            tmepSyncMEBES1.jobViewRemarks = 'testjobViewRemarks';
            tmepSyncMEBES1.ptrf = tempPtrf;
            tmepSyncMEBES1.customerJobViewAtFoundry = false;
            lstSyncMEBES.add(tmepSyncMEBES1);
            MRS_CADService.sync_Receive_MEBES_Data_from_Maskshop(lstSyncMEBES);
            **/
            list<ptrf__c> lstPTRF = new list<ptrf__c>();
            lstPTRF.add(new PTRF__c(id=ptrf1.id, status__c='Cancel'));
            lstPTRF.add(new PTRF__c(id=ptrf2.id, status__c='Cancel'));
            update lstPTRF;
            MRS_CADService.sync_Receive_MEBES_Data_from_Maskshop(lstSyncMEBES);
           }
        }
        
        @istest (SeeAllData=true)
        Public static void testSync_MEBESCustomerJobView(){
            
            User sysAdminUser = [SELECT Id,Name FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true].get(0);
            List<HCM_Employee__c> hcmList = SwiftDataUtilityTest.createHCMEmployee(5);
          
          
          system.runAs(sysAdminUser)
          {
          list<User> u1List = SwiftDataUtilityTest.createTestUser(hcmList);
          User u1 = u1List[1];
            
          list<Mask_Set_Title__c> lstMst = new list<Mask_Set_Title__c>();
          Mask_Set_Title__c mst = SwiftDataUtilityTest.createMST('QWERTY');
          //insert mst;
          lstMst.add(mst);
          Mask_Set_Title__c mst1 = SwiftDataUtilityTest.createMST('WERTYQ');
          //insert mst1;
          lstMst.add(mst1);
          insert lstMst;
          //mst = lstMst.get(0);
          //mst1 = lstMst.get(1);
          PTRF__c ptrf1 = new PTRF__c(Name='PTRF-QWERTY',Order_Type__c = 'testOrder1',Recticle_Type__c='Multi Layer Reticle (MLR)',Customer_jobview__c='Gating Mask Release');
          insert ptrf1;
          ////
          PTRF__c ptrf2 = new PTRF__c(Name='ABC2D',Order_Type__c = 'testOrder2',Recticle_Type__c='Multi Layer Reticle (MLR)',Customer_jobview__c='Gating Mask Release');
          insert ptrf2;
          ////
          MRS__c mrs1 = new MRS__c(Full_Sync__c =true,
                                   Synced_with_Oracle_DB__c=false,
                                   MRS_Package_Sync__c=false,
                                   Mask_Set_Title__c=mst.Id);
          insert mrs1;                             
          MRS_Layer_Association__c mrsLayer1 = new MRS_Layer_Association__c(Name ='testLayer001',
                                                                           Synced_with_Oracle_DB__c=false,
                                                                           Mask_Layer_Rev__c = '899',
                                                                           Layer_Name__c = 'testLayer001',
                                                                           Layer_Status__c = 'Not Ready',
                                                                           mrs__c = mrs1.id);
          insert mrslayer1;  
          MRS_Layer_Association__c mrsLayer2 = new MRS_Layer_Association__c(Name ='testLayer002',
                                                                           Synced_with_Oracle_DB__c=false,
                                                                           Mask_Layer_Rev__c = '900',
                                                                           Layer_Name__c = 'testLayer002',
                                                                           Layer_Status__c = 'Not Ready',
                                                                           mrs__c = mrs1.id);
          insert mrslayer2; 
                                                                                                                                          
          MRS_Chip_Details__c mrsChip1 = new MRS_Chip_Details__c(Name='chip001',
                                                                Synced_with_Oracle_DB__c=false,
                                                                mrs__c = mrs1.id);
          insert mrsChip1; 
           MRS_Chip_Details__c mrsChip2 = new MRS_Chip_Details__c(Name='Frame',
                                                                Synced_with_Oracle_DB__c=false,
                                                                mrs__c = mrs1.id);
          insert mrsChip2;                                                     
          MRS_Layer_Chip_Association__c layerChip1 = new MRS_Layer_Chip_Association__c(Name='layerChip001',
                                                                                      Synced_with_Oracle_DB__c=false,
                                                                                      Send_Frame_Data__c = 'N.A.',
                                                                                      Send_Prime_Data__c = 'N.A.',
                                                                                      
                                                                                      Layer__c=mrsLayer1.Id,
                                                                                      Foundry_GDSOUT_Review__c = 'Not Ready',
                                                                                      Chip__c=mrsChip1.Id,
                                                                                      PTRF__c=ptrf1.Id,
                                                                                      GlobalShuttle_MEBES_Jobview__c= 'Not Ready',
                                                                                      TDTI_MPW_MEBES_Jobview__c = 'Not Ready',
                                                                                      MDP_MEBES_Jobview__c = 'Not Ready',
                                                                                      Tapeout_Centre_MEBES_Jobview__c = 'Not Ready',
                                                                                      Tapeout_Applications_MEBES_Jobview__c = 'Not Ready',
                                                                                      Foundry_MEBES_Jobview__c = 'Not Ready',
                                                                                      Customer_MEBES_Jobview__c = 'Not Ready');
          insert layerChip1;
           MRS_Layer_Chip_Association__c layerChip2 = new MRS_Layer_Chip_Association__c(Name='Frame',
                                                                                      Synced_with_Oracle_DB__c=false,
                                                                                      Send_Frame_Data__c = 'N.A.',
                                                                                      Send_Prime_Data__c = 'N.A.',
                                                                                      Layer__c=mrsLayer1.Id,
                                                                                      Foundry_GDSOUT_Review__c = 'Not Ready',
                                                                                      Chip__c=mrsChip2.Id,
                                                                                      PTRF__c=ptrf1.Id,
                                                                                      GlobalShuttle_MEBES_Jobview__c= 'Not Ready',
                                                                                      TDTI_MPW_MEBES_Jobview__c = 'Not Ready',
                                                                                      MDP_MEBES_Jobview__c = 'Not Ready',
                                                                                      Tapeout_Centre_MEBES_Jobview__c = 'Not Ready',
                                                                                      Tapeout_Applications_MEBES_Jobview__c = 'Not Ready',
                                                                                      Foundry_MEBES_Jobview__c = 'Not Ready',
                                                                                      Customer_MEBES_Jobview__c = 'Not Ready');
          insert layerChip2;
          
          PTRF_JobViewer_Info__c tempJobViewer = new PTRF_JobViewer_Info__c(Name='testJobViewer',User__c=u1.Id,
                                                                      PTRF__c=ptrf1.Id,Jobview__c='Foundry',Jobview_Type__c='MEBES Jobview',
                                                                      Email_Address__c='satyajit.kumarsingh@cognizant.com');
          insert tempJobViewer;
            list<string> lstchipNotFound = new list<string>();
            list<string> lstLayerNotFound = new list<string>();
            String chipNotFound = 'chip004';  
            String layerNotFound = 'layer003';
            lstchipNotFound.add(chipNotFound);
            lstLayerNotFound.add(layerNotFound);
           
           
         
            MRS_CADService.MSTPtrfChipLayer PtrfChipLayer = new MRS_CADService.MSTPtrfChipLayer();
            MRS_CADService.mstPtrfChipLayerList = new List<MRS_CADService.MSTPtrfChipLayer>(); 
            
            //Test method for class LayerData
            List<MRS_CADService.LayerData> tempLayerData= new List<MRS_CADService.LayerData>();
            MRS_CADService.LayerData templyr ;
            for(Integer i=0;i<1;i++){
            templyr= new MRS_CADService.LayerData();
            templyr.maskLayer = 'testLayer001';
            templyr.maskRev = '899';
            templyr.resetFlag = false;
            templyr.jobStatus = 'SUCCESS';
            tempLayerData.add(templyr);
            }
            
            /////
            MRS_CADService.LayerData templyr1 ;
            for(Integer i=0;i<1;i++){
            templyr1= new MRS_CADService.LayerData();
            templyr1.maskLayer = 'testLayer002';
            templyr1.maskRev = '900';
            templyr1.resetFlag = false;
            templyr1.jobStatus = 'SUCCESS';
            tempLayerData.add(templyr1);
            }         
            /////
            
            /////
            /**
            MRS_CADService.LayerData templyr2 ;
            for(Integer i=0;i<1;i++){
            templyr2= new MRS_CADService.LayerData();
            templyr2.maskLayer = 'testLayer002';
            templyr2.maskRev = '900';
            templyr2.resetFlag = false;
            templyr2.jobStatus = 'SUCCESS';
            tempLayerData.add(templyr2);
            }    
            **/
            /////
                
            //Test method for class ChipData
            List<MRS_CADService.ChipData> tempChipData = new List<MRS_CADService.ChipData>();
            MRS_CADService.ChipData tempChip;
            for(Integer i=0;i<1;i++){
            tempChip = new MRS_CADService.ChipData();
            tempChip.chipName = 'chip001';
            tempChip.chipType = 'testChipType';
            tempChip.layer = new list<MRS_CADService.LayerData>();
            tempChip.layer.addAll(tempLayerData);
            tempChipData.add(tempChip);
            }
            /////
            MRS_CADService.ChipData tempChip1;
            for(Integer i=0;i<1;i++){
            tempChip1 = new MRS_CADService.ChipData();
            tempChip1.chipName = 'Frame';
            tempChip1.chipType = 'Frame';
            tempChip1.layer = new list<MRS_CADService.LayerData>();
            tempChip1.layer.addAll(tempLayerData);
            tempChipData.add(tempChip1);
            }
            /////            

            //Test method for class PTRFData
            List<MRS_CADService.PTRFData> tempPtrf = new List<MRS_CADService.PTRFData>();
            MRS_CADService.PTRFData tempPtrfData;
            for(Integer i=0;i<1;i++){
            tempPtrfData= new MRS_CADService.PTRFData();
            tempPtrfData.ptrfNumber ='PTRF-QWERTY';
            tempPtrfData.technology = 'testTech';
            tempPtrfData.chip = new list<MRS_CADService.ChipData>();
            tempPtrfData.chip.addAll(tempChipData);
            //tempPtrfData.chip = tempChipData; 
            tempPtrf.add(tempPtrfData);
            }
            
            ////////
            /**
            MRS_CADService.PTRFData tempPtrfData1;
            for(Integer i=0;i<1;i++){
            tempPtrfData1= new MRS_CADService.PTRFData();
            tempPtrfData1.ptrfNumber ='ABCD';
            tempPtrfData1.technology = 'testTech1';
            tempPtrfData1.chip = new list<MRS_CADService.ChipData>();
            tempPtrfData1.chip.addAll(tempChipData);
 
            tempPtrf.add(tempPtrfData1);
            }
           **/
            // Test sync_Remote_Jobview_Setup_Ready()
            List<MRS_CADService.JobDeckData> lstJobDeck = new List<MRS_CADService.JobDeckData>();
            MRS_CADService.JobDeckData tempDeckData;
            for(Integer i=0;i<1;i++){
            tempDeckData= new MRS_CADService.JobDeckData();
            tempDeckData.jobDeck = 'testJobDeck';
            lstJobDeck.add(tempDeckData);
            }
            /////
            MRS_CADService.JobDeckData tempDeckData1;
            for(Integer i=0;i<1;i++){
            tempDeckData1= new MRS_CADService.JobDeckData();
            tempDeckData1.jobDeck = 'testJobDeck1';
            lstJobDeck.add(tempDeckData1);
            }           
            /////
            List<MRS_CADService.JobViewData> lstJobView = new List<MRS_CADService.JobViewData>();
            MRS_CADService.JobViewData tempjobView;
            for(Integer i=0;i<1;i++){
            tempjobView= new MRS_CADService.JobViewData();
            tempjobView.jobViewGroup = 'Customer';
            tempjobView.jobViewType = 'Mask_Layout';
            tempjobView.jobViewRemarks = 'testViewRemarks';
            tempjobView.jobDecks = lstJobDeck;
            tempjobView.emailToList = 'testEmailLists';
            tempjobView.ptrf = tempPtrf;
            lstJobView.add(tempjobView);
            }
            
            /////
            
            
            List<MRS_CADService.MRSDataRecievedOnSyncRemoteJobView> lstSendResmoteJob = new List<MRS_CADService.MRSDataRecievedOnSyncRemoteJobView>();  
            //MRS_CADService.MRSDataRecievedOnSyncRemoteJobView tempRemoteJobView;
            for(Integer i=0;i<1;i++){
            MRS_CADService.MRSDataRecievedOnSyncRemoteJobView tempRemoteJobView = new MRS_CADService.MRSDataRecievedOnSyncRemoteJobView();
            tempRemoteJobView.messageID = 'testmsg01';
            tempRemoteJobView.maskSetTitle = mst.Name;
            tempRemoteJobView.jobView = lstJobView;
            lstSendResmoteJob.add(tempRemoteJobView);
            }
            
            ////
            for(Integer i=0;i<1;i++){
            MRS_CADService.MRSDataRecievedOnSyncRemoteJobView tempRemoteJobView1 = new MRS_CADService.MRSDataRecievedOnSyncRemoteJobView();
            tempRemoteJobView1.messageID = 'testmsg02';
            tempRemoteJobView1.maskSetTitle = mst1.Name;
            tempRemoteJobView1.jobView = lstJobView;
            lstSendResmoteJob.add(tempRemoteJobView1);
            }
            // test sync_Receive_MEBES_Data_from_Maskshop()
            List<MRS_CADService.MRSDataRecievedOnSyncMEBESReceive> lstSyncMEBES = new List<MRS_CADService.MRSDataRecievedOnSyncMEBESReceive>();
            MRS_CADService.MRSDataRecievedOnSyncMEBESReceive tmepSyncMEBES;
            
            tmepSyncMEBES= new MRS_CADService.MRSDataRecievedOnSyncMEBESReceive();
            tmepSyncMEBES.messageID = 'testmsg01';
            tmepSyncMEBES.maskSetTitle = mst.Name;
            tmepSyncMEBES.jobdecks = lstJobDeck;
            tmepSyncMEBES.jobViewRemarks = 'testjobViewRemarks';
            tmepSyncMEBES.ptrf = tempPtrf;
            tmepSyncMEBES.customerJobViewAtFoundry = false;
            lstSyncMEBES.add(tmepSyncMEBES);         
            
             test.startTest();
            MRS_CADService.sync_Receive_MEBES_Data_from_Maskshop(lstSyncMEBES);
           test.stopTest();
           MRS_CADService.MRSDataRecievedOnSyncMEBESReceive tmepSyncMEBES1;
           
            
           
           }
        }
        
        @istest (SeeAllData=true)
        Public static void testSync_MEBESCJBReset(){
            
            User sysAdminUser = [SELECT Id,Name FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true].get(0);
            List<HCM_Employee__c> hcmList = SwiftDataUtilityTest.createHCMEmployee(5);
          
          
          system.runAs(sysAdminUser)
          {
          list<User> u1List = SwiftDataUtilityTest.createTestUser(hcmList);
          User u1 = u1List[1];
            
          list<Mask_Set_Title__c> lstMst = new list<Mask_Set_Title__c>();
          Mask_Set_Title__c mst = SwiftDataUtilityTest.createMST('QWERTY');
          //insert mst;
          lstMst.add(mst);
          Mask_Set_Title__c mst1 = SwiftDataUtilityTest.createMST('WERTYQ');
          //insert mst1;
          lstMst.add(mst1);
          insert lstMst;
          //mst = lstMst.get(0);
          //mst1 = lstMst.get(1);
          PTRF__c ptrf1 = new PTRF__c(Name='PTRF-QWERTY',Order_Type__c = 'testOrder1',Recticle_Type__c='Multi Layer Reticle (MLR)',Customer_jobview__c='Gating Mask Release');
          insert ptrf1;
          ////
          PTRF__c ptrf2 = new PTRF__c(Name='ABC2D',Order_Type__c = 'testOrder2',Recticle_Type__c='Multi Layer Reticle (MLR)',Customer_jobview__c='Gating Mask Release');
          insert ptrf2;
          ////
          MRS__c mrs1 = new MRS__c(Full_Sync__c =true,
                                   Synced_with_Oracle_DB__c=false,
                                   MRS_Package_Sync__c=false,
                                   Mask_Set_Title__c=mst.Id);
          insert mrs1;                             
          MRS_Layer_Association__c mrsLayer1 = new MRS_Layer_Association__c(Name ='testLayer001',
                                                                           Synced_with_Oracle_DB__c=false,
                                                                           Mask_Layer_Rev__c = '899',
                                                                           Layer_Name__c = 'testLayer001',
                                                                           Layer_Status__c = 'Not Ready',
                                                                           mrs__c = mrs1.id);
          insert mrslayer1;  
          MRS_Layer_Association__c mrsLayer2 = new MRS_Layer_Association__c(Name ='testLayer002',
                                                                           Synced_with_Oracle_DB__c=false,
                                                                           Mask_Layer_Rev__c = '900',
                                                                           Layer_Name__c = 'testLayer002',
                                                                           Layer_Status__c = 'Not Ready',
                                                                           mrs__c = mrs1.id);
          insert mrslayer2; 
                                                                                                                                          
          MRS_Chip_Details__c mrsChip1 = new MRS_Chip_Details__c(Name='chip001',
                                                                Synced_with_Oracle_DB__c=false,
                                                                mrs__c = mrs1.id);
          insert mrsChip1; 
           MRS_Chip_Details__c mrsChip2 = new MRS_Chip_Details__c(Name='Frame',
                                                                Synced_with_Oracle_DB__c=false,
                                                                mrs__c = mrs1.id);
          insert mrsChip2;                                                     
          MRS_Layer_Chip_Association__c layerChip1 = new MRS_Layer_Chip_Association__c(Name='layerChip001',
                                                                                      Synced_with_Oracle_DB__c=false,
                                                                                      Send_Frame_Data__c = 'N.A.',
                                                                                      Send_Prime_Data__c = 'N.A.',
                                                                                      
                                                                                      Layer__c=mrsLayer1.Id,
                                                                                      Foundry_GDSOUT_Review__c = 'Not Ready',
                                                                                      Chip__c=mrsChip1.Id,
                                                                                      PTRF__c=ptrf1.Id,
                                                                                      GlobalShuttle_MEBES_Jobview__c= 'Not Ready',
                                                                                      TDTI_MPW_MEBES_Jobview__c = 'Not Ready',
                                                                                      MDP_MEBES_Jobview__c = 'Not Ready',
                                                                                      Tapeout_Centre_MEBES_Jobview__c = 'Not Ready',
                                                                                      Tapeout_Applications_MEBES_Jobview__c = 'Not Ready',
                                                                                      Foundry_MEBES_Jobview__c = 'Not Ready',
                                                                                      Customer_MEBES_Jobview__c = 'Not Ready'
                                                                                      );
          insert layerChip1;
           MRS_Layer_Chip_Association__c layerChip2 = new MRS_Layer_Chip_Association__c(Name='Frame',
                                                                                      Synced_with_Oracle_DB__c=false,
                                                                                      Send_Frame_Data__c = 'N.A.',
                                                                                      Send_Prime_Data__c = 'N.A.',
                                                                                      Layer__c=mrsLayer1.Id,
                                                                                      Foundry_GDSOUT_Review__c = 'Not Ready',
                                                                                      Chip__c=mrsChip2.Id,
                                                                                      PTRF__c=ptrf1.Id,
                                                                                      GlobalShuttle_MEBES_Jobview__c= 'Not Ready',
                                                                                      TDTI_MPW_MEBES_Jobview__c = 'Not Ready',
                                                                                      MDP_MEBES_Jobview__c = 'Not Ready',
                                                                                      Tapeout_Centre_MEBES_Jobview__c = 'Not Ready',
                                                                                      Tapeout_Applications_MEBES_Jobview__c = 'Not Ready',
                                                                                      Foundry_MEBES_Jobview__c = 'Not Ready',
                                                                                      Customer_MEBES_Jobview__c = 'Not Ready');
          insert layerChip2;
          
          PTRF_JobViewer_Info__c tempJobViewer = new PTRF_JobViewer_Info__c(Name='testJobViewer',User__c=u1.Id,
                                                                      PTRF__c=ptrf1.Id,Jobview__c='Foundry',Jobview_Type__c='MEBES Jobview',
                                                                      Email_Address__c='satyajit.kumarsingh@cognizant.com');
          insert tempJobViewer;
            list<string> lstchipNotFound = new list<string>();
            list<string> lstLayerNotFound = new list<string>();
            String chipNotFound = 'chip004';  
            String layerNotFound = 'layer003';
            lstchipNotFound.add(chipNotFound);
            lstLayerNotFound.add(layerNotFound);
           
           
         
            MRS_CADService.MSTPtrfChipLayer PtrfChipLayer = new MRS_CADService.MSTPtrfChipLayer();
            MRS_CADService.mstPtrfChipLayerList = new List<MRS_CADService.MSTPtrfChipLayer>(); 
            
            //Test method for class LayerData
            List<MRS_CADService.LayerData> tempLayerData= new List<MRS_CADService.LayerData>();
            MRS_CADService.LayerData templyr ;
            for(Integer i=0;i<1;i++){
            templyr= new MRS_CADService.LayerData();
            templyr.maskLayer = 'testLayer001';
            templyr.maskRev = '899';
            templyr.resetFlag = false;
            templyr.jobStatus = 'SUCCESS';
            tempLayerData.add(templyr);
            }
            
            /////
            MRS_CADService.LayerData templyr1 ;
            for(Integer i=0;i<1;i++){
            templyr1= new MRS_CADService.LayerData();
            templyr1.maskLayer = 'testLayer002';
            templyr1.maskRev = '900';
            templyr1.resetFlag = false;
            templyr1.jobStatus = 'SUCCESS';
            tempLayerData.add(templyr1);
            }         
            /////
            
            /////
            /**
            MRS_CADService.LayerData templyr2 ;
            for(Integer i=0;i<1;i++){
            templyr2= new MRS_CADService.LayerData();
            templyr2.maskLayer = 'testLayer002';
            templyr2.maskRev = '900';
            templyr2.resetFlag = false;
            templyr2.jobStatus = 'SUCCESS';
            tempLayerData.add(templyr2);
            }    
            **/
            /////
                
            //Test method for class ChipData
            List<MRS_CADService.ChipData> tempChipData = new List<MRS_CADService.ChipData>();
            MRS_CADService.ChipData tempChip;
            for(Integer i=0;i<1;i++){
            tempChip = new MRS_CADService.ChipData();
            tempChip.chipName = 'chip001';
            tempChip.chipType = 'testChipType';
            tempChip.layer = new list<MRS_CADService.LayerData>();
            tempChip.layer.addAll(tempLayerData);
            tempChipData.add(tempChip);
            }
            /////
            MRS_CADService.ChipData tempChip1;
            for(Integer i=0;i<1;i++){
            tempChip1 = new MRS_CADService.ChipData();
            tempChip1.chipName = 'Frame';
            tempChip1.chipType = 'Frame';
            tempChip1.layer = new list<MRS_CADService.LayerData>();
            tempChip1.layer.addAll(tempLayerData);
            tempChipData.add(tempChip1);
            }
            /////            

            //Test method for class PTRFData
            List<MRS_CADService.PTRFData> tempPtrf = new List<MRS_CADService.PTRFData>();
            MRS_CADService.PTRFData tempPtrfData;
            for(Integer i=0;i<1;i++){
            tempPtrfData= new MRS_CADService.PTRFData();
            tempPtrfData.ptrfNumber ='PTRF-QWERTY';
            tempPtrfData.technology = 'testTech';
            tempPtrfData.chip = new list<MRS_CADService.ChipData>();
            tempPtrfData.chip.addAll(tempChipData);
            //tempPtrfData.chip = tempChipData; 
            tempPtrf.add(tempPtrfData);
            }
            
            ////////
            /**
            MRS_CADService.PTRFData tempPtrfData1;
            for(Integer i=0;i<1;i++){
            tempPtrfData1= new MRS_CADService.PTRFData();
            tempPtrfData1.ptrfNumber ='ABCD';
            tempPtrfData1.technology = 'testTech1';
            tempPtrfData1.chip = new list<MRS_CADService.ChipData>();
            tempPtrfData1.chip.addAll(tempChipData);
 
            tempPtrf.add(tempPtrfData1);
            }
           **/
            // Test sync_Remote_Jobview_Setup_Ready()
            List<MRS_CADService.JobDeckData> lstJobDeck = new List<MRS_CADService.JobDeckData>();
            MRS_CADService.JobDeckData tempDeckData;
            for(Integer i=0;i<1;i++){
            tempDeckData= new MRS_CADService.JobDeckData();
            tempDeckData.jobDeck = 'testJobDeck';
            lstJobDeck.add(tempDeckData);
            }
            /////
            MRS_CADService.JobDeckData tempDeckData1;
            for(Integer i=0;i<1;i++){
            tempDeckData1= new MRS_CADService.JobDeckData();
            tempDeckData1.jobDeck = 'testJobDeck1';
            lstJobDeck.add(tempDeckData1);
            }           
            /////
            List<MRS_CADService.JobViewData> lstJobView = new List<MRS_CADService.JobViewData>();
            MRS_CADService.JobViewData tempjobView;
            for(Integer i=0;i<1;i++){
            tempjobView= new MRS_CADService.JobViewData();
            tempjobView.jobViewGroup = 'Customer';
            tempjobView.jobViewType = 'Mask_Layout';
            tempjobView.jobViewRemarks = 'testViewRemarks';
            tempjobView.jobDecks = lstJobDeck;
            tempjobView.emailToList = 'testEmailLists';
            tempjobView.ptrf = tempPtrf;
            lstJobView.add(tempjobView);
            }
            
            /////
            
            
            List<MRS_CADService.MRSDataRecievedOnSyncRemoteJobView> lstSendResmoteJob = new List<MRS_CADService.MRSDataRecievedOnSyncRemoteJobView>();  
            //MRS_CADService.MRSDataRecievedOnSyncRemoteJobView tempRemoteJobView;
            for(Integer i=0;i<1;i++){
            MRS_CADService.MRSDataRecievedOnSyncRemoteJobView tempRemoteJobView = new MRS_CADService.MRSDataRecievedOnSyncRemoteJobView();
            tempRemoteJobView.messageID = 'testmsg01';
            tempRemoteJobView.maskSetTitle = mst.Name;
            tempRemoteJobView.jobView = lstJobView;
            lstSendResmoteJob.add(tempRemoteJobView);
            }
            
            ////
            for(Integer i=0;i<1;i++){
            MRS_CADService.MRSDataRecievedOnSyncRemoteJobView tempRemoteJobView1 = new MRS_CADService.MRSDataRecievedOnSyncRemoteJobView();
            tempRemoteJobView1.messageID = 'testmsg02';
            tempRemoteJobView1.maskSetTitle = mst1.Name;
            tempRemoteJobView1.jobView = lstJobView;
            lstSendResmoteJob.add(tempRemoteJobView1);
            }
            // test sync_Receive_MEBES_Data_from_Maskshop()
            List<MRS_CADService.MRSDataRecievedOnSyncMEBESReceive> lstSyncMEBES = new List<MRS_CADService.MRSDataRecievedOnSyncMEBESReceive>();
            MRS_CADService.MRSDataRecievedOnSyncMEBESReceive tmepSyncMEBES;
            
            tmepSyncMEBES= new MRS_CADService.MRSDataRecievedOnSyncMEBESReceive();
            tmepSyncMEBES.messageID = 'testmsg01';
            tmepSyncMEBES.maskSetTitle = mst.Name;
            tmepSyncMEBES.jobdecks = lstJobDeck;
            tmepSyncMEBES.jobViewRemarks = 'testjobViewRemarks';
            tmepSyncMEBES.ptrf = tempPtrf;
            tmepSyncMEBES.customerJobViewAtFoundry = true;
            lstSyncMEBES.add(tmepSyncMEBES);         
            
             test.startTest();
            MRS_CADService.sync_Receive_MEBES_Data_from_Maskshop(lstSyncMEBES);
            MRS_CADService.sync_Receive_MEBES_Data_from_Maskshop(lstSyncMEBES);
           test.stopTest();
                   
           
           }
        }
        
        @istest (SeeAllData=true)
        Public static void testSync_MEBESCustomerJobViewCJBReset(){
            
            User sysAdminUser = [SELECT Id,Name FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true].get(0);
            List<HCM_Employee__c> hcmList = SwiftDataUtilityTest.createHCMEmployee(5);
          
          
          system.runAs(sysAdminUser)
          {
          list<User> u1List = SwiftDataUtilityTest.createTestUser(hcmList);
          User u1 = u1List[1];
            
          list<Mask_Set_Title__c> lstMst = new list<Mask_Set_Title__c>();
          Mask_Set_Title__c mst = SwiftDataUtilityTest.createMST('QWERTY');
          //insert mst;
          lstMst.add(mst);
          Mask_Set_Title__c mst1 = SwiftDataUtilityTest.createMST('WERTYQ');
          //insert mst1;
          lstMst.add(mst1);
          insert lstMst;
          //mst = lstMst.get(0);
          //mst1 = lstMst.get(1);
          PTRF__c ptrf1 = new PTRF__c(Name='PTRF-QWERTY',Order_Type__c = 'testOrder1',Recticle_Type__c='Multi Layer Reticle (MLR)',Customer_jobview__c='Gating Mask Release');
          insert ptrf1;
          ////
          PTRF__c ptrf2 = new PTRF__c(Name='ABC2D',Order_Type__c = 'testOrder2',Recticle_Type__c='Multi Layer Reticle (MLR)',Customer_jobview__c='Gating Mask Release');
          insert ptrf2;
          ////
          MRS__c mrs1 = new MRS__c(Full_Sync__c =true,
                                   Synced_with_Oracle_DB__c=false,
                                   MRS_Package_Sync__c=false,
                                   Mask_Set_Title__c=mst.Id);
          insert mrs1;                             
          MRS_Layer_Association__c mrsLayer1 = new MRS_Layer_Association__c(Name ='testLayer001',
                                                                           Synced_with_Oracle_DB__c=false,
                                                                           Mask_Layer_Rev__c = '899',
                                                                           Layer_Name__c = 'testLayer001',
                                                                           Layer_Status__c = 'Not Ready',
                                                                           mrs__c = mrs1.id);
          insert mrslayer1;  
          MRS_Layer_Association__c mrsLayer2 = new MRS_Layer_Association__c(Name ='testLayer002',
                                                                           Synced_with_Oracle_DB__c=false,
                                                                           Mask_Layer_Rev__c = '900',
                                                                           Layer_Name__c = 'testLayer002',
                                                                           Layer_Status__c = 'Not Ready',
                                                                           mrs__c = mrs1.id);
          insert mrslayer2; 
                                                                                                                                          
          MRS_Chip_Details__c mrsChip1 = new MRS_Chip_Details__c(Name='chip001',
                                                                Synced_with_Oracle_DB__c=false,
                                                                mrs__c = mrs1.id);
          insert mrsChip1; 
           MRS_Chip_Details__c mrsChip2 = new MRS_Chip_Details__c(Name='Frame',
                                                                Synced_with_Oracle_DB__c=false,
                                                                mrs__c = mrs1.id);
          insert mrsChip2;                                                     
          MRS_Layer_Chip_Association__c layerChip1 = new MRS_Layer_Chip_Association__c(Name='layerChip001',
                                                                                      Synced_with_Oracle_DB__c=false,
                                                                                      Send_Frame_Data__c = 'N.A.',
                                                                                      Send_Prime_Data__c = 'N.A.',
                                                                                      
                                                                                      Layer__c=mrsLayer1.Id,
                                                                                      Foundry_GDSOUT_Review__c = 'Not Ready',
                                                                                      Chip__c=mrsChip1.Id,
                                                                                      PTRF__c=ptrf1.Id,
                                                                                      GlobalShuttle_MEBES_Jobview__c= 'Not Ready',
                                                                                      TDTI_MPW_MEBES_Jobview__c = 'Not Ready',
                                                                                      MDP_MEBES_Jobview__c = 'Not Ready',
                                                                                      Tapeout_Centre_MEBES_Jobview__c = 'Not Ready',
                                                                                      Tapeout_Applications_MEBES_Jobview__c = 'Not Ready',
                                                                                      Foundry_MEBES_Jobview__c = 'Not Ready',
                                                                                      Customer_MEBES_Jobview__c = 'Not Ready');
          insert layerChip1;
           MRS_Layer_Chip_Association__c layerChip2 = new MRS_Layer_Chip_Association__c(Name='Frame',
                                                                                      Synced_with_Oracle_DB__c=false,
                                                                                      Send_Frame_Data__c = 'N.A.',
                                                                                      Send_Prime_Data__c = 'N.A.',
                                                                                      Layer__c=mrsLayer1.Id,
                                                                                      Foundry_GDSOUT_Review__c = 'Not Ready',
                                                                                      Chip__c=mrsChip2.Id,
                                                                                      PTRF__c=ptrf1.Id,
                                                                                      GlobalShuttle_MEBES_Jobview__c= 'Not Ready',
                                                                                      TDTI_MPW_MEBES_Jobview__c = 'Not Ready',
                                                                                      MDP_MEBES_Jobview__c = 'Not Ready',
                                                                                      Tapeout_Centre_MEBES_Jobview__c = 'Not Ready',
                                                                                      Tapeout_Applications_MEBES_Jobview__c = 'Not Ready',
                                                                                      Foundry_MEBES_Jobview__c = 'Not Ready',
                                                                                      Customer_MEBES_Jobview__c = 'Not Ready');
          insert layerChip2;
          
          PTRF_JobViewer_Info__c tempJobViewer = new PTRF_JobViewer_Info__c(Name='testJobViewer',User__c=u1.Id,
                                                                      PTRF__c=ptrf1.Id,Jobview__c='Foundry',Jobview_Type__c='MEBES Jobview',
                                                                      Email_Address__c='satyajit.kumarsingh@cognizant.com');
          insert tempJobViewer;
            list<string> lstchipNotFound = new list<string>();
            list<string> lstLayerNotFound = new list<string>();
            String chipNotFound = 'chip004';  
            String layerNotFound = 'layer003';
            lstchipNotFound.add(chipNotFound);
            lstLayerNotFound.add(layerNotFound);
           
           
         
            MRS_CADService.MSTPtrfChipLayer PtrfChipLayer = new MRS_CADService.MSTPtrfChipLayer();
            MRS_CADService.mstPtrfChipLayerList = new List<MRS_CADService.MSTPtrfChipLayer>(); 
            
            //Test method for class LayerData
            List<MRS_CADService.LayerData> tempLayerData= new List<MRS_CADService.LayerData>();
            MRS_CADService.LayerData templyr ;
            for(Integer i=0;i<1;i++){
            templyr= new MRS_CADService.LayerData();
            templyr.maskLayer = 'testLayer001';
            templyr.maskRev = '899';
            templyr.resetFlag = true;
            templyr.jobStatus = 'SUCCESS';
            tempLayerData.add(templyr);
            }
            
            /////
            MRS_CADService.LayerData templyr1 ;
            for(Integer i=0;i<1;i++){
            templyr1= new MRS_CADService.LayerData();
            templyr1.maskLayer = 'testLayer002';
            templyr1.maskRev = '900';
            templyr1.resetFlag = true;
            templyr1.jobStatus = 'SUCCESS';
            tempLayerData.add(templyr1);
            }         
            /////
            
            /////
            
                
            //Test method for class ChipData
            List<MRS_CADService.ChipData> tempChipData = new List<MRS_CADService.ChipData>();
            MRS_CADService.ChipData tempChip;
            for(Integer i=0;i<1;i++){
            tempChip = new MRS_CADService.ChipData();
            tempChip.chipName = 'chip001';
            tempChip.chipType = 'testChipType';
            tempChip.layer = new list<MRS_CADService.LayerData>();
            tempChip.layer.addAll(tempLayerData);
            tempChipData.add(tempChip);
            }
            /////
            MRS_CADService.ChipData tempChip1;
            for(Integer i=0;i<1;i++){
            tempChip1 = new MRS_CADService.ChipData();
            tempChip1.chipName = 'Frame';
            tempChip1.chipType = 'Frame';
            tempChip1.layer = new list<MRS_CADService.LayerData>();
            tempChip1.layer.addAll(tempLayerData);
            tempChipData.add(tempChip1);
            }
            /////            

            //Test method for class PTRFData
            List<MRS_CADService.PTRFData> tempPtrf = new List<MRS_CADService.PTRFData>();
            MRS_CADService.PTRFData tempPtrfData;
            for(Integer i=0;i<1;i++){
            tempPtrfData= new MRS_CADService.PTRFData();
            tempPtrfData.ptrfNumber ='PTRF-QWERTY';
            tempPtrfData.technology = 'testTech';
            tempPtrfData.chip = new list<MRS_CADService.ChipData>();
            tempPtrfData.chip.addAll(tempChipData);
            //tempPtrfData.chip = tempChipData; 
            tempPtrf.add(tempPtrfData);
            }
            
            ////////
            /**
            MRS_CADService.PTRFData tempPtrfData1;
            for(Integer i=0;i<1;i++){
            tempPtrfData1= new MRS_CADService.PTRFData();
            tempPtrfData1.ptrfNumber ='ABCD';
            tempPtrfData1.technology = 'testTech1';
            tempPtrfData1.chip = new list<MRS_CADService.ChipData>();
            tempPtrfData1.chip.addAll(tempChipData);
 
            tempPtrf.add(tempPtrfData1);
            }
           **/
            // Test sync_Remote_Jobview_Setup_Ready()
            List<MRS_CADService.JobDeckData> lstJobDeck = new List<MRS_CADService.JobDeckData>();
            MRS_CADService.JobDeckData tempDeckData;
            for(Integer i=0;i<1;i++){
            tempDeckData= new MRS_CADService.JobDeckData();
            tempDeckData.jobDeck = 'testJobDeck';
            lstJobDeck.add(tempDeckData);
            }
            /////
            MRS_CADService.JobDeckData tempDeckData1;
            for(Integer i=0;i<1;i++){
            tempDeckData1= new MRS_CADService.JobDeckData();
            tempDeckData1.jobDeck = 'testJobDeck1';
            lstJobDeck.add(tempDeckData1);
            }           
            /////
            List<MRS_CADService.JobViewData> lstJobView = new List<MRS_CADService.JobViewData>();
            MRS_CADService.JobViewData tempjobView;
            for(Integer i=0;i<1;i++){
            tempjobView= new MRS_CADService.JobViewData();
            tempjobView.jobViewGroup = 'Customer';
            tempjobView.jobViewType = 'Mask_Layout';
            tempjobView.jobViewRemarks = 'testViewRemarks';
            tempjobView.jobDecks = lstJobDeck;
            tempjobView.emailToList = 'testEmailLists';
            tempjobView.ptrf = tempPtrf;
            lstJobView.add(tempjobView);
            }
            
            /////
            
            
            List<MRS_CADService.MRSDataRecievedOnSyncRemoteJobView> lstSendResmoteJob = new List<MRS_CADService.MRSDataRecievedOnSyncRemoteJobView>();  
            //MRS_CADService.MRSDataRecievedOnSyncRemoteJobView tempRemoteJobView;
            for(Integer i=0;i<1;i++){
            MRS_CADService.MRSDataRecievedOnSyncRemoteJobView tempRemoteJobView = new MRS_CADService.MRSDataRecievedOnSyncRemoteJobView();
            tempRemoteJobView.messageID = 'testmsg01';
            tempRemoteJobView.maskSetTitle = mst.Name;
            tempRemoteJobView.jobView = lstJobView;
            lstSendResmoteJob.add(tempRemoteJobView);
            }
            
            ////
            for(Integer i=0;i<1;i++){
            MRS_CADService.MRSDataRecievedOnSyncRemoteJobView tempRemoteJobView1 = new MRS_CADService.MRSDataRecievedOnSyncRemoteJobView();
            tempRemoteJobView1.messageID = 'testmsg02';
            tempRemoteJobView1.maskSetTitle = mst1.Name;
            tempRemoteJobView1.jobView = lstJobView;
            lstSendResmoteJob.add(tempRemoteJobView1);
            }
            // test sync_Receive_MEBES_Data_from_Maskshop()
            List<MRS_CADService.MRSDataRecievedOnSyncMEBESReceive> lstSyncMEBES = new List<MRS_CADService.MRSDataRecievedOnSyncMEBESReceive>();
            MRS_CADService.MRSDataRecievedOnSyncMEBESReceive tmepSyncMEBES;
            
            tmepSyncMEBES= new MRS_CADService.MRSDataRecievedOnSyncMEBESReceive();
            tmepSyncMEBES.messageID = 'testmsg01';
            tmepSyncMEBES.maskSetTitle = mst.Name;
            tmepSyncMEBES.jobdecks = lstJobDeck;
            tmepSyncMEBES.jobViewRemarks = 'testjobViewRemarks';
            tmepSyncMEBES.ptrf = tempPtrf;
            tmepSyncMEBES.customerJobViewAtFoundry = false;
            lstSyncMEBES.add(tmepSyncMEBES);         
            
             test.startTest();
            MRS_CADService.sync_Receive_MEBES_Data_from_Maskshop(lstSyncMEBES);
            MRS_CADService.sync_Receive_MEBES_Data_from_Maskshop(lstSyncMEBES);
           test.stopTest();
           
           
            
           
           }
        }
        
        @istest (SeeAllData=true)
        Public static void testSync_MEBESCustomerJobViewCJBResetMissigLayerChip(){
            
            User sysAdminUser = [SELECT Id,Name FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true].get(0);
            List<HCM_Employee__c> hcmList = SwiftDataUtilityTest.createHCMEmployee(5);
          
          
          system.runAs(sysAdminUser)
          {
          list<User> u1List = SwiftDataUtilityTest.createTestUser(hcmList);
          User u1 = u1List[1];
            
          list<Mask_Set_Title__c> lstMst = new list<Mask_Set_Title__c>();
          Mask_Set_Title__c mst = SwiftDataUtilityTest.createMST('QWERTY');
          //insert mst;
          lstMst.add(mst);
          Mask_Set_Title__c mst1 = SwiftDataUtilityTest.createMST('WERTYQ');
          //insert mst1;
          lstMst.add(mst1);
          insert lstMst;
          //mst = lstMst.get(0);
          //mst1 = lstMst.get(1);
          PTRF__c ptrf1 = new PTRF__c(Name='PTRF-QWERTY',Order_Type__c = 'testOrder1',Recticle_Type__c='Multi Layer Reticle (MLR)',Customer_jobview__c='Gating Mask Release');
          insert ptrf1;
          ////
          PTRF__c ptrf2 = new PTRF__c(Name='ABC2D',Order_Type__c = 'testOrder2',Recticle_Type__c='Multi Layer Reticle (MLR)',Customer_jobview__c='Gating Mask Release');
          insert ptrf2;
          ////
          MRS__c mrs1 = new MRS__c(Full_Sync__c =true,
                                   Synced_with_Oracle_DB__c=false,
                                   MRS_Package_Sync__c=false,
                                   Mask_Set_Title__c=mst.Id);
          insert mrs1;                             
          MRS_Layer_Association__c mrsLayer1 = new MRS_Layer_Association__c(Name ='testLayer001',
                                                                           Synced_with_Oracle_DB__c=false,
                                                                           Mask_Layer_Rev__c = '899',
                                                                           Layer_Name__c = 'testLayer001',
                                                                           Layer_Status__c = 'Not Ready',
                                                                           mrs__c = mrs1.id);
          insert mrslayer1;  
          MRS_Layer_Association__c mrsLayer2 = new MRS_Layer_Association__c(Name ='testLayer002',
                                                                           Synced_with_Oracle_DB__c=false,
                                                                           Mask_Layer_Rev__c = '900',
                                                                           Layer_Name__c = 'testLayer002',
                                                                           Layer_Status__c = 'Not Ready',
                                                                           mrs__c = mrs1.id);
          insert mrslayer2; 
                                                                                                                                          
          MRS_Chip_Details__c mrsChip1 = new MRS_Chip_Details__c(Name='chip001',
                                                                Synced_with_Oracle_DB__c=false,
                                                                mrs__c = mrs1.id);
          insert mrsChip1; 
           MRS_Chip_Details__c mrsChip2 = new MRS_Chip_Details__c(Name='Frame',
                                                                Synced_with_Oracle_DB__c=false,
                                                                mrs__c = mrs1.id);
          insert mrsChip2;                                                     
          MRS_Layer_Chip_Association__c layerChip1 = new MRS_Layer_Chip_Association__c(Name='layerChip001',
                                                                                      Synced_with_Oracle_DB__c=false,
                                                                                      Send_Frame_Data__c = 'N.A.',
                                                                                      Send_Prime_Data__c = 'N.A.',
                                                                                      
                                                                                      Layer__c=mrsLayer1.Id,
                                                                                      Foundry_GDSOUT_Review__c = 'Not Ready',
                                                                                      Chip__c=mrsChip1.Id,
                                                                                      PTRF__c=ptrf1.Id,
                                                                                      GlobalShuttle_MEBES_Jobview__c= 'Not Ready',
                                                                                      TDTI_MPW_MEBES_Jobview__c = 'Not Ready',
                                                                                      MDP_MEBES_Jobview__c = 'Not Ready',
                                                                                      Tapeout_Centre_MEBES_Jobview__c = 'Not Ready',
                                                                                      Tapeout_Applications_MEBES_Jobview__c = 'Not Ready',
                                                                                      Foundry_MEBES_Jobview__c = 'Not Ready',
                                                                                      Customer_MEBES_Jobview__c = 'Not Ready');
          insert layerChip1;
           MRS_Layer_Chip_Association__c layerChip2 = new MRS_Layer_Chip_Association__c(Name='Frame',
                                                                                      Synced_with_Oracle_DB__c=false,
                                                                                      Send_Frame_Data__c = 'N.A.',
                                                                                      Send_Prime_Data__c = 'N.A.',
                                                                                      Layer__c=mrsLayer1.Id,
                                                                                      Foundry_GDSOUT_Review__c = 'Not Ready',
                                                                                      Chip__c=mrsChip2.Id,
                                                                                      PTRF__c=ptrf1.Id,
                                                                                      GlobalShuttle_MEBES_Jobview__c= 'Not Ready',
                                                                                      TDTI_MPW_MEBES_Jobview__c = 'Not Ready',
                                                                                      MDP_MEBES_Jobview__c = 'Not Ready',
                                                                                      Tapeout_Centre_MEBES_Jobview__c = 'Not Ready',
                                                                                      Tapeout_Applications_MEBES_Jobview__c = 'Not Ready',
                                                                                      Foundry_MEBES_Jobview__c = 'Not Ready',
                                                                                      Customer_MEBES_Jobview__c = 'Not Ready');
          insert layerChip2;
          
          PTRF_JobViewer_Info__c tempJobViewer = new PTRF_JobViewer_Info__c(Name='testJobViewer',User__c=u1.Id,
                                                                      PTRF__c=ptrf1.Id,Jobview__c='Foundry',Jobview_Type__c='MEBES Jobview',
                                                                      Email_Address__c='satyajit.kumarsingh@cognizant.com');
          insert tempJobViewer;
            list<string> lstchipNotFound = new list<string>();
            list<string> lstLayerNotFound = new list<string>();
            String chipNotFound = 'chip004';  
            String layerNotFound = 'layer003';
            lstchipNotFound.add(chipNotFound);
            lstLayerNotFound.add(layerNotFound);
           
           
         
            MRS_CADService.MSTPtrfChipLayer PtrfChipLayer = new MRS_CADService.MSTPtrfChipLayer();
            MRS_CADService.mstPtrfChipLayerList = new List<MRS_CADService.MSTPtrfChipLayer>(); 
            
            //For Missing LayerData
            List<MRS_CADService.LayerData> tempLayerData= new List<MRS_CADService.LayerData>();
            MRS_CADService.LayerData templyr ;
            
            templyr= new MRS_CADService.LayerData();
            templyr.maskLayer = 'MissingLayer001';
            templyr.maskRev = '899';
            templyr.resetFlag = true;
            templyr.jobStatus = 'SUCCESS';
            tempLayerData.add(templyr);
           
            
            /////
            MRS_CADService.LayerData templyr1 ;
            
            templyr1= new MRS_CADService.LayerData();
            templyr1.maskLayer = 'MissingLayer002';
            templyr1.maskRev = '900';
            templyr1.resetFlag = true;
            templyr1.jobStatus = 'SUCCESS';
            tempLayerData.add(templyr1);
                     
            /////
            
            /////
            
                
            //Test method for class ChipData
            List<MRS_CADService.ChipData> tempChipData = new List<MRS_CADService.ChipData>();
            MRS_CADService.ChipData tempChip;
            for(Integer i=0;i<1;i++){
            tempChip = new MRS_CADService.ChipData();
            tempChip.chipName = 'chip001';
            tempChip.chipType = 'testChipType';
            tempChip.layer = new list<MRS_CADService.LayerData>();
            tempChip.layer.addAll(tempLayerData);
            tempChipData.add(tempChip);
            }
            /////
            MRS_CADService.ChipData tempChip1;
            for(Integer i=0;i<1;i++){
            tempChip1 = new MRS_CADService.ChipData();
            tempChip1.chipName = 'Frame';
            tempChip1.chipType = 'Frame';
            tempChip1.layer = new list<MRS_CADService.LayerData>();
            tempChip1.layer.addAll(tempLayerData);
            tempChipData.add(tempChip1);
            }
            /////            

            //Test method for class PTRFData
            List<MRS_CADService.PTRFData> tempPtrf = new List<MRS_CADService.PTRFData>();
            MRS_CADService.PTRFData tempPtrfData;
            for(Integer i=0;i<1;i++){
            tempPtrfData= new MRS_CADService.PTRFData();
            tempPtrfData.ptrfNumber ='PTRF-QWERTY';
            tempPtrfData.technology = 'testTech';
            tempPtrfData.chip = new list<MRS_CADService.ChipData>();
            tempPtrfData.chip.addAll(tempChipData);
            //tempPtrfData.chip = tempChipData; 
            tempPtrf.add(tempPtrfData);
            }
                                
            
            // test sync_Receive_MEBES_Data_from_Maskshop()
            List<MRS_CADService.MRSDataRecievedOnSyncMEBESReceive> lstSyncMEBES = new List<MRS_CADService.MRSDataRecievedOnSyncMEBESReceive>();
            MRS_CADService.MRSDataRecievedOnSyncMEBESReceive tmepSyncMEBES;
            
            tmepSyncMEBES= new MRS_CADService.MRSDataRecievedOnSyncMEBESReceive();
            tmepSyncMEBES.messageID = 'testmsg01';
            tmepSyncMEBES.maskSetTitle = mst.Name;
            tmepSyncMEBES.ptrf = tempPtrf;
            tmepSyncMEBES.customerJobViewAtFoundry = false;
            lstSyncMEBES.add(tmepSyncMEBES);         
            
             
            MRS_CADService.sync_Receive_MEBES_Data_from_Maskshop(lstSyncMEBES);
           
           //For Missing LayerData
            List<MRS_CADService.LayerData> tempLayerData2= new List<MRS_CADService.LayerData>();
            MRS_CADService.LayerData templyr2 ;
            
            templyr2= new MRS_CADService.LayerData();
            templyr2.maskLayer = 'MissingLayer001';
            templyr2.maskRev = '899';
            templyr2.resetFlag = true;
            templyr2.jobStatus = 'SUCCESS';
            tempLayerData2.add(templyr2);
           
            
            /////
            MRS_CADService.LayerData templyr11 ;
            
            templyr11= new MRS_CADService.LayerData();
            templyr11.maskLayer = 'MissingLayer002';
            templyr11.maskRev = '900';
            templyr11.resetFlag = true;
            templyr11.jobStatus = 'SUCCESS';
            tempLayerData2.add(templyr11);
                     
            /////
            
            /////
            
                
            //Test method for class ChipData
            List<MRS_CADService.ChipData> tempChipData2 = new List<MRS_CADService.ChipData>();
            MRS_CADService.ChipData tempChip2;
            for(Integer i=0;i<1;i++){
            tempChip2 = new MRS_CADService.ChipData();
            tempChip2.chipName = 'Misssingchip001';
            tempChip2.chipType = 'testChipType';
            tempChip2.layer = new list<MRS_CADService.LayerData>();
            tempChip2.layer.addAll(tempLayerData2);
            tempChipData2.add(tempChip2);
            }
            /////
            MRS_CADService.ChipData tempChip11;
            for(Integer i=0;i<1;i++){
            tempChip11 = new MRS_CADService.ChipData();
            tempChip11.chipName = 'MissingFrame';
            tempChip11.chipType = 'Frame';
            tempChip11.layer = new list<MRS_CADService.LayerData>();
            tempChip11.layer.addAll(tempLayerData2);
            tempChipData2.add(tempChip11);
            }
            /////            

            //Test method for class PTRFData
            List<MRS_CADService.PTRFData> tempPtrf2 = new List<MRS_CADService.PTRFData>();
            MRS_CADService.PTRFData tempPtrfData3;
            for(Integer i=0;i<1;i++){
            tempPtrfData3= new MRS_CADService.PTRFData();
            tempPtrfData3.ptrfNumber ='PTRF-QWERTY';
            tempPtrfData3.technology = 'testTech';
            tempPtrfData3.chip = new list<MRS_CADService.ChipData>();
            tempPtrfData3.chip.addAll(tempChipData);
            //tempPtrfData.chip = tempChipData; 
            tempPtrf2.add(tempPtrfData3);
            }
                                
            
            // test sync_Receive_MEBES_Data_from_Maskshop()
            List<MRS_CADService.MRSDataRecievedOnSyncMEBESReceive> lstSyncMEBES2 = new List<MRS_CADService.MRSDataRecievedOnSyncMEBESReceive>();
            MRS_CADService.MRSDataRecievedOnSyncMEBESReceive tmepSyncMEBES2;
            
            tmepSyncMEBES2= new MRS_CADService.MRSDataRecievedOnSyncMEBESReceive();
            tmepSyncMEBES2.messageID = 'testmsg01';
            tmepSyncMEBES2.maskSetTitle = mst.Name;
            tmepSyncMEBES2.ptrf = tempPtrf2;
            tmepSyncMEBES2.customerJobViewAtFoundry = false;
            lstSyncMEBES2.add(tmepSyncMEBES2);         
 
            MRS_CADService.sync_Receive_MEBES_Data_from_Maskshop(lstSyncMEBES2);
           
            //For Missing LayerData
            List<MRS_CADService.LayerData> tempLayerData3= new List<MRS_CADService.LayerData>();
            MRS_CADService.LayerData templyr3 ;
            
            templyr3= new MRS_CADService.LayerData();
            templyr3.maskLayer = 'MissingLayer001';
            templyr3.maskRev = '899';
            templyr3.resetFlag = true;
            templyr3.jobStatus = 'SUCCESS';
            tempLayerData3.add(templyr3);
           
            
            /////
            MRS_CADService.LayerData templyr111 ;
            
            templyr111= new MRS_CADService.LayerData();
            templyr111.maskLayer = 'MissingLayer002';
            templyr111.maskRev = '900';
            templyr111.resetFlag = true;
            templyr111.jobStatus = 'SUCCESS';
            tempLayerData3.add(templyr111);
                     
            /////
            
            /////
            
                
            //Test method for class ChipData
            List<MRS_CADService.ChipData> tempChipData3 = new List<MRS_CADService.ChipData>();
            MRS_CADService.ChipData tempChip3;
            for(Integer i=0;i<1;i++){
            tempChip3 = new MRS_CADService.ChipData();
            tempChip3.chipName = 'chip001';
            tempChip3.chipType = 'testChipType';
            tempChip3.layer = new list<MRS_CADService.LayerData>();
            tempChip3.layer.addAll(tempLayerData3);
            tempChipData3.add(tempChip3);
            }
            /////
            MRS_CADService.ChipData tempChip4;
            for(Integer i=0;i<1;i++){
            tempChip4 = new MRS_CADService.ChipData();
            tempChip4.chipName = 'Frame';
            tempChip4.chipType = 'Frame';
            tempChip4.layer = new list<MRS_CADService.LayerData>();
            tempChip4.layer.addAll(tempLayerData);
            tempChipData3.add(tempChip4);
            }
            /////            

            //Test method for class PTRFData
            List<MRS_CADService.PTRFData> tempPtrf4 = new List<MRS_CADService.PTRFData>();
            MRS_CADService.PTRFData tempPtrfData4;
            for(Integer i=0;i<1;i++){
            tempPtrfData4= new MRS_CADService.PTRFData();
            tempPtrfData4.ptrfNumber ='PTRF-QWERTY-Missing';
            tempPtrfData4.technology = 'testTech';
            tempPtrfData4.chip = new list<MRS_CADService.ChipData>();
            tempPtrfData4.chip.addAll(tempChipData3);
            //tempPtrfData.chip = tempChipData3; 
            tempPtrf4.add(tempPtrfData4);
            }
                                
            
            // test sync_Receive_MEBES_Data_from_Maskshop()
            List<MRS_CADService.MRSDataRecievedOnSyncMEBESReceive> lstSyncMEBES3 = new List<MRS_CADService.MRSDataRecievedOnSyncMEBESReceive>();
            MRS_CADService.MRSDataRecievedOnSyncMEBESReceive tmepSyncMEBES4;
            
            tmepSyncMEBES4= new MRS_CADService.MRSDataRecievedOnSyncMEBESReceive();
            tmepSyncMEBES4.messageID = 'testmsg01';
            tmepSyncMEBES4.maskSetTitle = mst.Name;
            tmepSyncMEBES4.ptrf = tempPtrf;
            tmepSyncMEBES4.customerJobViewAtFoundry = false;
            lstSyncMEBES3.add(tmepSyncMEBES4);         
            
             
            MRS_CADService.sync_Receive_MEBES_Data_from_Maskshop(lstSyncMEBES3);
           
            
           
           }
        }
}