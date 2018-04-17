/*
Author: Cognizant Technology Solutions
Company: 
Description:    DRTpackageSyncHandler Test Class.
        
History:
    Cognizant     18082014     - Initial Version
*/


@istest(SeeAllData=false)
public class DRTpackageSyncHandlerTest {
public static testMethod void DRTSyncHandlerTest(){
       DRT__c drt1 = new DRT__c(Name='NewDRT1',
                                   Synced_with_Oracle_DB__c=false,
                                   DRT_Package_Sync__c=false
                                   );
          insert drt1; 
          
          PRIME_DRT_Layer_Association__c drtLayer1 = new PRIME_DRT_Layer_Association__c(Name ='layer001',
                                                                           Synced_with_Oracle_DB__c=false,
                                                                           DRT__c = drt1.id);
          insert drtLayer1; 
          
          PRIME_DRT_Chip_Association__c drtChip1 = new PRIME_DRT_Chip_Association__c(Name='chip001',
                                                                Synced_with_Oracle_DB__c=false,
                                                                DRT__c = drt1.id);
          insert drtChip1;
          
          
          PRIME_DRT_Chip_Layer_Summary__c layerChip1 = new PRIME_DRT_Chip_Layer_Summary__c(Synced_with_Oracle_DB__c=false,
                                                                                      Layer__c = drtLayer1.id,
                                                                                      Chip__c = drtChip1.id);                                                      
          insert layerChip1;
          
          DRT_PTRF_Association__c drtPTRF1 = new DRT_PTRF_Association__c(Synced_with_Oracle_DB__c=false,
                                                                DRT__c = drt1.id);
          insert drtPTRF1;
    
          Frame_DRT_Association__c drtFrame1 = new Frame_DRT_Association__c(Synced_with_Oracle_DB__c=false,
                                                                DRT__c = drt1.id);
          insert drtFrame1;    
          
          Set<Id> setDRTIds = new Set<Id>{drt1.id};
          test.startTest();
          DRTpackageSyncHandler.invokeDRTchldSync(setDRTIds);
          
          
          // test script for updating the DRT objects as first synced with oracle equals to true
          
          DRT__c drt2 = [SELECT Id,Synced_with_Oracle_DB__c from DRT__c WHERE Id =: drt1.Id];    
          drt2.Synced_with_Oracle_DB__c = true;
          update drt2;
          
          PRIME_DRT_Layer_Association__c drtLayer2 = [SELECT Id,Synced_with_Oracle_DB__c from PRIME_DRT_Layer_Association__c WHERE Id =: drtLayer1.Id];
          drtLayer2.Synced_with_Oracle_DB__c = true;
          update drtLayer2;
          
          PRIME_DRT_Chip_Association__c drtChip2 = [SELECT Id,Synced_with_Oracle_DB__c from PRIME_DRT_Chip_Association__c WHERE Id =: drtChip1.Id];  
          drtChip2.Synced_with_Oracle_DB__c = true;
          update drtChip2; 
          
          PRIME_DRT_Chip_Layer_Summary__c layerChip2 = [SELECT Id,Synced_with_Oracle_DB__c from PRIME_DRT_Chip_Layer_Summary__c WHERE Id =: layerChip1.Id]; 
          layerChip2.Synced_with_Oracle_DB__c = true;     
          update layerChip2;  
          
          DRT_PTRF_Association__c drtPTRF2 = [SELECT Id,Synced_with_Oracle_DB__c from DRT_PTRF_Association__c WHERE Id =: drtPTRF1.Id];  
          drtPTRF2.Synced_with_Oracle_DB__c = true;
          update drtPTRF2;
    
          Frame_DRT_Association__c drtFrame2 = [SELECT Id,Synced_with_Oracle_DB__c from Frame_DRT_Association__c WHERE Id =: drtFrame1.Id];  
          drtFrame2.Synced_with_Oracle_DB__c = true;
          update drtFrame2;
          
          Set<Id> setNewDRTIds = new Set<Id>{drt2.id};
          
          DRTpackageSyncHandler.invokeDRTchldSync(setNewDRTIds);
          test.stopTest();
          Set<string> setNewDRTstringIds = new Set<string>{drt2.id};

          DRTpackageSyncHandler.syncDRTLayerChip(setNewDRTstringIds);
   }
   
   public static testMethod void syncDRTLayerChipTest(){
       DRT__c drt1 = new DRT__c(Name='NewDRT2',
                                   Synced_with_Oracle_DB__c=false,
                                   DRT_Package_Sync__c=false,
                                   First_Sync_with_Oracle__c=false
                                   );
          insert drt1; 
          
          PRIME_DRT_Layer_Association__c drtLayer1 = new PRIME_DRT_Layer_Association__c(Name ='layer01',
                                                                           Synced_with_Oracle_DB__c=false,
                                                                           First_Sync_with_Oracle__c=false,
                                                                           DRT__c = drt1.id);
          insert drtLayer1; 
          
          PRIME_DRT_Chip_Association__c drtChip1 = new PRIME_DRT_Chip_Association__c(Name='chip01',
                                                                Synced_with_Oracle_DB__c=false,
                                                                First_Sync_with_Oracle__c=false,
                                                                DRT__c = drt1.id);
          insert drtChip1;
          
          
          PRIME_DRT_Chip_Layer_Summary__c layerChip1 = new PRIME_DRT_Chip_Layer_Summary__c(Synced_with_Oracle_DB__c=false,
                                                                                      Layer__c = drtLayer1.id,
                                                                                      Chip__c = drtChip1.id);                                                      
          insert layerChip1;
          
          DRT_PTRF_Association__c drtPTRF1 = new DRT_PTRF_Association__c(Synced_with_Oracle_DB__c=false,
                                                                DRT__c = drt1.id);
          insert drtPTRF1;
    
          Frame_DRT_Association__c drtFrame1 = new Frame_DRT_Association__c(Synced_with_Oracle_DB__c=false,
                                                                DRT__c = drt1.id);
          insert drtFrame1;    
          
          Set<Id> setDRTIds = new Set<Id>{drt1.id};
          test.startTest();
          //DRTpackageSyncHandler.syncDRTLayerChip(setDRTIds); 
          
          DRT__c drt2 = [SELECT Id,Synced_with_Oracle_DB__c from DRT__c WHERE Id =: drt1.Id];    
          drt2.Synced_with_Oracle_DB__c = true;
          drt2.First_Sync_with_Oracle__c=false;
          update drt2;
          
          PRIME_DRT_Layer_Association__c drtLayer2 = [SELECT Id,Synced_with_Oracle_DB__c from PRIME_DRT_Layer_Association__c WHERE drt__c =: drt2.Id];
          drtLayer2.Synced_with_Oracle_DB__c = true;
          drtLayer2.First_Sync_with_Oracle__c=false;
          update drtLayer2;
          
          Set<Id> setNewDRTId = new Set<Id>{drt2.id};
          //DRTpackageSyncHandler.syncDRTLayerChip(setNewDRTId);
          test.stopTest();
   }
   public static testMethod void syncDRTLayerChipNegativeTest()
   {
          Set<String> setNewDRTId = new Set<String>();
          DRT__c drt1 = new DRT__c(Name='NewDRT2',
                                   status__c='Draft',
                                   Synced_with_Oracle_DB__c=false,
                                   DRT_Package_Sync__c=false,
                                   First_Sync_with_Oracle__c=false
                                   );
          insert drt1; 
          drt1.status__c='Active';   
          test.startTest();
          update drt1;
          DRTpackageSyncHandler.syncDRTLayerChip(setNewDRTId);
          test.stopTest();
   }

}