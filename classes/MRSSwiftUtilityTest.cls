/*    Author: Cognizant    
Description: Apex test class for SwiftMRSPackSyncUtilityTest class    
History:     
Cognizant      05/15/2014    - Apex code created    
              
*/
@istest(SeeAllData=false)

public with sharing class MRSSwiftUtilityTest {
    public static testMethod void checkMRSpackageSyncTest(){
          Mask_Set_Title__c mst = SwiftDataUtilityTest.createMST('MYMST');
          insert mst;
          
          MRS__c mrs1 = new MRS__c(Full_Sync__c =true,
                                   Synced_with_Oracle_DB__c=false,
                                   MRS_Package_Sync__c=false,
                                   Mask_Set_Title__c=mst.Id);
          insert mrs1;                             
          MRS_Layer_Association__c mrsLayer1 = new MRS_Layer_Association__c(Name ='layer001',
                                                                           Synced_with_Oracle_DB__c=false,
                                                                           mrs__c = mrs1.id);
          insert mrslayer1;
           
          MRS_Layer_Association__c mrsLayer3 = new MRS_Layer_Association__c(Name ='layer003',
                                                                           Synced_with_Oracle_DB__c=false,
                                                                           mrs__c = mrs1.id);
          insert mrslayer3;  

          MRS_Layer_Association__c mrsLayer5 = new MRS_Layer_Association__c(Name ='layer005',
                                                                           Synced_with_Oracle_DB__c=false,
                                       Last_Sync_Request_Timestamp__c=system.now(),
                                                                           mrs__c = mrs1.id);
          insert mrslayer5;
                                                                                                                                            
          MRS_Chip_Details__c mrsChip1 = new MRS_Chip_Details__c(Name='chip001',
                                                                Synced_with_Oracle_DB__c=false,
                                                                mrs__c = mrs1.id);
          insert mrsChip1;
           
          MRS_Chip_Details__c mrsChip3 = new MRS_Chip_Details__c(Name='chip003',
                                                                Synced_with_Oracle_DB__c=false,
                                                                mrs__c = mrs1.id);
          insert mrsChip3;   
                                                               
          MRS_Layer_Chip_Association__c layerChip1 = new MRS_Layer_Chip_Association__c(Name='layerChip001',
                                                                                      Synced_with_Oracle_DB__c=false,
                                                                                      Layer__c=mrsLayer1.Id,
                                                                                      Chip__c=mrsChip1.Id,
                                                                                      Mask_Set_Title_Id__c=mst.id);                                                      
          insert layerChip1;
          
          MRS_Layer_Chip_Association__c layerChip11 = new MRS_Layer_Chip_Association__c(Name='layerChip002',
                                                                                      Synced_with_Oracle_DB__c=TRUE,
                                                                                      Layer__c=mrsLayer1.Id,
                                                                                      Chip__c=mrsChip1.Id,
                                                                                      Mask_Set_Title_Id__c=mst.id);                                                      
          insert layerChip11;
          
          MRS_Layer_Chip_Association__c layerChip12 = new MRS_Layer_Chip_Association__c(Name='layerChip003',
                                                                                      Synced_with_Oracle_DB__c=FALSE,
                                                                                      Layer__c=mrsLayer1.Id,
                                                                                      Chip__c=mrsChip1.Id,
                                                                                      Mask_Set_Title_Id__c=mst.id);                                                      
          insert layerChip12;
                                                                                            
          Set<String> setMRSIds = new Set<String>{mrs1.id};
                    
          test.startTest();
          
          
          MRSSwiftUtility.checkMRSpackageSync(setMRSIds);
                   
          //Set<String> setMRSId1s = new Set<String>();
          //MRSSwiftUtility.checkMRSpackageSync(setMRSId1s);
          
          // test script for updating the MRS objects as synced with oracle db equals to true
          
          MRS__c mrs2 = [SELECT Id,Synced_with_Oracle_DB__c from MRS__c WHERE Id =: mrs1.Id];    
          mrs2.Synced_with_Oracle_DB__c = true;
          update mrs2;
          
          MRS_Layer_Association__c mrsLayer2= [SELECT Id,Synced_with_Oracle_DB__c,Layer_Status__c,Last_Sync_Request_Timestamp__c from MRS_Layer_Association__c WHERE Id =: mrsLayer1.Id];
          mrsLayer2.Synced_with_Oracle_DB__c = true;
          mrsLayer2.Layer_Status__c = 'Shipped';          
          mrsLayer2.Last_Sync_Request_Timestamp__c = mrsLayer1.Last_Sync_Request_Timestamp__c;          
          update mrsLayer2;
          

          MRS_Layer_Association__c mrsLayer4= [SELECT Id,Synced_with_Oracle_DB__c,Layer_Status__c,Last_Sync_Request_Timestamp__c from MRS_Layer_Association__c WHERE Id =: mrsLayer3.Id];
          mrsLayer4.Synced_with_Oracle_DB__c = true;
          mrsLayer4.Layer_Status__c = 'Released';          
          mrsLayer4.Last_Sync_Request_Timestamp__c = mrsLayer3.Last_Sync_Request_Timestamp__c;          
          update mrsLayer4;

      MRS_Layer_Association__c mrsLayer6= [SELECT Id,Synced_with_Oracle_DB__c,Layer_Status__c,Last_Sync_Request_Timestamp__c from MRS_Layer_Association__c WHERE Id =: mrsLayer5.Id];
          mrsLayer6.Synced_with_Oracle_DB__c = true;
          mrsLayer6.Layer_Status__c = 'Released';          
          mrsLayer6.Last_Sync_Request_Timestamp__c = mrsLayer5.Last_Sync_Request_Timestamp__c;          
          update mrsLayer6;
          
          MRS_Chip_Details__c mrsChip2 = [SELECT Id,Synced_with_Oracle_DB__c from MRS_Chip_Details__c WHERE Id =: mrsChip1.Id];  
          mrsChip2.Synced_with_Oracle_DB__c = true;
          update mrsChip2; 
          
          MRS_Chip_Details__c mrsChip4 = [SELECT Id,Synced_with_Oracle_DB__c from MRS_Chip_Details__c WHERE Id =: mrsChip3.Id];  
          mrsChip4.Synced_with_Oracle_DB__c = true;
          update mrsChip4; 
          
          MRS_Layer_Chip_Association__c layerChip2 = [SELECT Id,Synced_with_Oracle_DB__c from MRS_Layer_Chip_Association__c WHERE Id =: layerChip1.Id]; 
          layerChip2.Synced_with_Oracle_DB__c = true;     
          update layerChip2;    
          
          Set<String> setNewMRSIds = new Set<String>{mrs2.id};
          
          MRSSwiftUtility.checkMRSpackageSync(setNewMRSIds);
          
          MRS__c mrsFinal = [SELECT Id,Synced_with_Oracle_DB__c,MRS_Package_Sync__c from MRS__c WHERE Id =: mrs2.Id];
          
          System.assertEquals(FALSE,mrsFinal.MRS_Package_Sync__c);          
          test.stopTest();                                                      
      }
     // Test method for the class MRS_PLM_TECNservice
           Public static TestMethod void testSyncTECNWS(){
           List<MRS_PLM_TECNservice.TECNproxy> lstTECHproxy = new List<MRS_PLM_TECNservice.TECNproxy>();
           MRS_PLM_TECNservice.TECNproxy TECNproxy = new MRS_PLM_TECNservice.TECNproxy();
           TECNproxy.messgaeID ='tstmsg001';
           TECNproxy.relatedTECNno = 'testTECNno1';
           TECNproxy.TECNno='Techno1';
           TECNproxy.docTypeECNInfo='docTypeECNInfo1';
           TECNproxy.affectedDoc='affectedDoc';
           TECNproxy.originator='originator';
           TECNproxy.status='Active';
           TECNproxy.maskSetTitle='MYMST';
           TECNproxy.maskLayersNo = 'testMasklayer';
           TECNproxy.primeDies = 'testPrimedies';
           lstTECHproxy.add(TECNproxy); 
           MRS_PLM_TECNservice.syncTECNWS(lstTECHproxy);
           }

  }