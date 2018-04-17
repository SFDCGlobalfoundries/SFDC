/*
Author: Cognizant Technology Solutions
Company: 
Description:This is the controller Test class of MRSpackageSyncHandler.
                 
History:
Cognizant     18032014     - Initial Version
Updated on    28082014
*/

@istest(SeeAllData=false)
public class MRSpackageSyncHandlerTest {
public static testMethod void mrsSyncHandlerTest(){
          /*MRS__c mrs1 = new MRS__c(Synced_with_Oracle_DB__c=false,
                                   MRS_Package_Sync__c=false
                                   );
          insert mrs1; */
          
          Mask_Set_Title__c mst = SwiftDataUtilityTest.createMST('MYMST1');
          insert mst; 
          
          MRS__c mrs1 = new MRS__c(Full_Sync__c =true,                                   
            Synced_with_Oracle_DB__c=false,                                   
            MRS_Package_Sync__c=false,                                   
            Mask_Set_Title__c=mst.Id);          
            insert mrs1;
            
          MRS_Layer_Association__c mrsLayer1 = new MRS_Layer_Association__c(Name ='layer001',
                                                                           Synced_with_Oracle_DB__c=false,
                                                                           MRS__c = mrs1.id);
          insert mrsLayer1; 
          
          MRS_Chip_Details__c mrsChip1 = new MRS_Chip_Details__c(Name='chip001',
                                                                Synced_with_Oracle_DB__c=false,
                                                                MRS__c = mrs1.id);
          insert mrsChip1;
          
          PTRF__c ptrf1 = new PTRF__c(Name='ACOU1',MaskSetTitle__c =mst.Id,Order_Type__c = 'testOrder1',Recticle_Type__c='Multi Layer Reticle (MLR)',Customer_jobview__c='Gating Mask Release');
          insert ptrf1; 

          
           MRS_Layer_Chip_Association__c layerChip1 = new MRS_Layer_Chip_Association__c(Name='LayrChipAs001',Synced_with_Oracle_DB__c=false,
                                                                                      Layer__c = mrsLayer1.id,
                                                                                      Chip__c = mrsChip1.id,
                                                                                      PTRF__c=ptrf1.Id);                                                      
          insert layerChip1; 
                    
          Set<Id> setMRSIds = new Set<Id>{mrs1.id};
          test.startTest();
          MRSpackageSyncHandler.invokeMRSchldSync(setMRSIds);
          
          // test script for updating the MRS objects as first synced with oracle equals to true
          
          MRS__c mrs2 = [SELECT Id,Synced_with_Oracle_DB__c from MRS__c WHERE Id =: mrs1.Id];    
          mrs2.Synced_with_Oracle_DB__c = true;
          update mrs2;
          
          MRS_Layer_Association__c mrsLayer2 = [SELECT Id,Synced_with_Oracle_DB__c from MRS_Layer_Association__c WHERE Id =: mrsLayer1.Id];
          mrsLayer2.Synced_with_Oracle_DB__c = true;
          update mrsLayer2;
          
          MRS_Chip_Details__c mrsChip2 = [SELECT Id,Synced_with_Oracle_DB__c from MRS_Chip_Details__c WHERE Id =: mrsChip1.Id];  
          mrsChip2.Synced_with_Oracle_DB__c = true;
          update mrsChip2; 
          
          MRS_Layer_Chip_Association__c layerChip2 = [SELECT Id,Synced_with_Oracle_DB__c from MRS_Layer_Chip_Association__c WHERE Id =: layerChip1.Id]; 
          layerChip2.Synced_with_Oracle_DB__c = true;     
          update layerChip2;  
          
          Set<Id> setNewMRSIds = new Set<Id>{mrs2.id};
          
          MRSpackageSyncHandler.invokeMRSchldSync(setNewMRSIds);
          System.assertEquals(true,mrsChip2.Synced_with_Oracle_DB__c);
          
          Set<Id> setNewMRSId = new Set<Id>();
          
          MRSpackageSyncHandler.invokeMRSchldSync(setNewMRSId);    
          test.stopTest();
   }
   public static testMethod void checkMRSpackageSyncTest(){
          /*MRS__c mrs1 = new MRS__c(Synced_with_Oracle_DB__c=false,
                                   MRS_Package_Sync__c=false
                                   );
          insert mrs1; */
          
          Mask_Set_Title__c mst = SwiftDataUtilityTest.createMST('MYMST1');
          insert mst; 
          
          MRS__c mrs1 = new MRS__c(Full_Sync__c =true,                                   
            Synced_with_Oracle_DB__c=false,                                   
            MRS_Package_Sync__c=false,                                   
            Mask_Set_Title__c=mst.Id);          
            insert mrs1;
            
          MRS_Layer_Association__c mrsLayer1 = new MRS_Layer_Association__c(Name ='layer001',
                                                                           Synced_with_Oracle_DB__c=false,
                                                                           MRS__c = mrs1.id);
          insert mrsLayer1; 
          
          MRS_Chip_Details__c mrsChip1 = new MRS_Chip_Details__c(Name='chip001',
                                                                Synced_with_Oracle_DB__c=false,
                                                                MRS__c = mrs1.id);
          insert mrsChip1;
          
          PTRF__c ptrf1 = new PTRF__c(Name='ACOU1',MaskSetTitle__c =mst.Id,Order_Type__c = 'testOrder1',Recticle_Type__c='Multi Layer Reticle (MLR)',Customer_jobview__c='Gating Mask Release');
          insert ptrf1; 

          
           MRS_Layer_Chip_Association__c layerChip1 = new MRS_Layer_Chip_Association__c(Name='LayrChipAs001',Synced_with_Oracle_DB__c=false,
                                                                                      Layer__c = mrsLayer1.id,
                                                                                      Chip__c = mrsChip1.id,
                                                                                      PTRF__c=ptrf1.Id);                                                      
          insert layerChip1; 
                    
          Set<String> setMRSIds = new Set<String>{mrs1.id};
          Set<String> setMRSId = new Set<String>();
          test.startTest();
          MRSSwiftUtility.checkMRSpackageSync(setMRSId);             
          test.stopTest();
   }
   public static testMethod void syncMRSNotesTest(){
          /*MRS__c mrs1 = new MRS__c(Synced_with_Oracle_DB__c=false,
                                   MRS_Package_Sync__c=false
                                   );
          insert mrs1; */
             
          Mask_Set_Title__c mst = SwiftDataUtilityTest.createMST('MYMST3');
          insert mst; 
          
          MRS__c mrs1 = new MRS__c(Full_Sync__c =true,                                   
            Synced_with_Oracle_DB__c=false,                                   
            MRS_Package_Sync__c=false,                                   
            Mask_Set_Title__c=mst.Id);          
            insert mrs1;
            
          MRS_Layer_Association__c mrsLayer1 = new MRS_Layer_Association__c(Name ='layer003',
                                                                           Synced_with_Oracle_DB__c=false,
                                                                           MRS__c = mrs1.id);
          insert mrsLayer1; 
          
          MRS_Chip_Details__c mrsChip1 = new MRS_Chip_Details__c(Name='chip003',
                                                                Synced_with_Oracle_DB__c=false,
                                                                MRS__c = mrs1.id);
          insert mrsChip1;
           
          PTRF__c ptrf1 = new PTRF__c(Name='ACOU3',MaskSetTitle__c =mst.Id,Order_Type__c = 'testOrder3',Recticle_Type__c='Multi Layer Reticle (MLR)',Customer_jobview__c='Gating Mask Release');
          insert ptrf1; 

          
           MRS_Layer_Chip_Association__c layerChip1 = new MRS_Layer_Chip_Association__c(Name='LayrChipAs003',Synced_with_Oracle_DB__c=false,
                                                                                      Layer__c = mrsLayer1.id,
                                                                                      Chip__c = mrsChip1.id,
                                                                                      PTRF__c=ptrf1.Id);                                                      
          insert layerChip1;
          Set<String> setMRSIds = new Set<String>{mrs1.id};
          Set<String> setMRSId = new Set<String>();
          test.startTest();
          MRSpackageSyncHandler.syncMRSNotes(setMRSIds);
          MRSpackageSyncHandler.syncMRSNotes(setMRSId);
          test.stopTest();
   } 

   public static testMethod void syncMRSLayerChipTest(){
          /* MRS__c mrs1 = new MRS__c(Synced_with_Oracle_DB__c=false,
                                   MRS_Package_Sync__c=false,
                                   First_Sync_with_Oracle__c=false
                                   );
          insert mrs1; */
           
          Mask_Set_Title__c mst = SwiftDataUtilityTest.createMST('MYMST');
          insert mst; 
          
          MRS__c mrs1 = new MRS__c(Full_Sync__c =true,                                   
            Synced_with_Oracle_DB__c=false,                                   
            MRS_Package_Sync__c=false,                                   
            Mask_Set_Title__c=mst.Id);          
            insert mrs1;
            
          MRS_Layer_Association__c mrsLayer1 = new MRS_Layer_Association__c(Name ='layer01',
                                                                           Synced_with_Oracle_DB__c=false,
                                                                           First_Sync_with_Oracle__c=false,
                                                                           MRS__c = mrs1.id);
          insert mrsLayer1; 
          
          MRS_Chip_Details__c mrsChip1 = new MRS_Chip_Details__c(Name='chip01',
                                                                Synced_with_Oracle_DB__c=false,
                                                                First_Sync_with_Oracle__c=false,
                                                                MRS__c = mrs1.id);
          insert mrsChip1;
          
          PTRF__c ptrf1 = new PTRF__c(Name='ACOU2',MaskSetTitle__c =mst.Id,Order_Type__c = 'testOrder2',Recticle_Type__c='Multi Layer Reticle (MLR)',Customer_jobview__c='Gating Mask Release');
          insert ptrf1; 
          
          MRS_Layer_Chip_Association__c layerChip1 = new MRS_Layer_Chip_Association__c(Name='LayrChipAs001',
                                                                                      Synced_with_Oracle_DB__c=false,
                                                                                      Layer__c = mrsLayer1.id,
                                                                                      Chip__c = mrsChip1.id,
                                                                                      PTRF__c=ptrf1.Id);                                                      
          insert layerChip1; 
                    
          Set<String> setMRSIds = new Set<String>{mrs1.id};
          test.startTest();
          MRSpackageSyncHandler.syncMRSLayerChip(setMRSIds); 
          
          MRS__c mrs2 = [SELECT Id,Synced_with_Oracle_DB__c from MRS__c WHERE Id =: mrs1.Id];    
          mrs2.Synced_with_Oracle_DB__c = true;
          mrs2.First_Sync_with_Oracle__c=false;
          update mrs2;
          
          MRS_Layer_Association__c mrsLayer2 = [SELECT Id,Synced_with_Oracle_DB__c from MRS_Layer_Association__c WHERE mrs__c =: mrs2.Id];
          mrsLayer2.Synced_with_Oracle_DB__c = true;
          mrsLayer2.First_Sync_with_Oracle__c=false;
          update mrsLayer2;
          
          Set<String> setNewMRSId = new Set<String>{mrs2.id};
          MRSpackageSyncHandler.syncMRSLayerChip(setNewMRSId);
          
          System.assertEquals(false, mrs2.First_Sync_with_Oracle__c);
          
          MRS__c mrsid = new MRS__c();
          Set<String> setNewMRSId1 = new Set<String>{mrsid.Id};
          MRSpackageSyncHandler.syncMRSLayerChip(setNewMRSId1);
          test.stopTest();
   }
}