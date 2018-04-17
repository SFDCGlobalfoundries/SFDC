@istest(SeeAllData=false)
public class DRTSwiftUtilityTest {
public static testMethod void checkDRTpackageSyncTest()
    {
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
          
          Set<String> setDRTIds = new Set<String>{drt1.id};
          test.startTest();
          DRTSwiftUtility.checkDRTpackageSync(setDRTIds);
          
          // Bulkifying the code coverage
          
          DRT__c drt2 = new DRT__c(Name='NewDRT2',
                                   Synced_with_Oracle_DB__c=false,
                                   DRT_Package_Sync__c=false
                                   );
          insert drt2; 
          
          PRIME_DRT_Layer_Association__c drtLayer01 = new PRIME_DRT_Layer_Association__c(Name ='layer011',
                                                                           Synced_with_Oracle_DB__c=false,
                                                                           DRT__c = drt2.id);
          insert drtLayer01; 

          PRIME_DRT_Layer_Association__c drtLayer02 = new PRIME_DRT_Layer_Association__c(Name ='layer012',
                                                                           Synced_with_Oracle_DB__c=false,
                                                                           DRT__c = drt2.id);
          insert drtLayer02; 
          
          PRIME_DRT_Chip_Association__c drtChip01 = new PRIME_DRT_Chip_Association__c(Name='chip011',
                                                                Synced_with_Oracle_DB__c=false,
                                                                DRT__c = drt2.id);
          insert drtChip01;
          
          PRIME_DRT_Chip_Association__c drtChip02 = new PRIME_DRT_Chip_Association__c(Name='chip012',
                                                                Synced_with_Oracle_DB__c=false,
                                                                DRT__c = drt2.id);
          insert drtChip02;
          PRIME_DRT_Chip_Layer_Summary__c layerChip01 = new PRIME_DRT_Chip_Layer_Summary__c(Synced_with_Oracle_DB__c=false,
                                                                                      Layer__c = drtLayer01.id,
                                                                                      Chip__c = drtChip01.id);                                                      
          insert layerChip01;
          PRIME_DRT_Chip_Layer_Summary__c layerChip02 = new PRIME_DRT_Chip_Layer_Summary__c(Synced_with_Oracle_DB__c=false,
                                                                                      Layer__c = drtLayer02.id,
                                                                                      Chip__c = drtChip02.id);                                                      
          insert layerChip02;
          
          DRT_PTRF_Association__c drtPTRF01 = new DRT_PTRF_Association__c(Synced_with_Oracle_DB__c=false,
                                                                DRT__c = drt2.id);
          insert drtPTRF01;
          DRT_PTRF_Association__c drtPTRF02 = new DRT_PTRF_Association__c(Synced_with_Oracle_DB__c=false,
                                                                DRT__c = drt2.id);
          insert drtPTRF02;
          Frame_DRT_Association__c drtFrame01 = new Frame_DRT_Association__c(Synced_with_Oracle_DB__c=false,
                                                                DRT__c = drt2.id);
          insert drtFrame01;  
          
          Frame_DRT_Association__c drtFrame02 = new Frame_DRT_Association__c(Synced_with_Oracle_DB__c=false,
                                                                DRT__c = drt2.id);
          insert drtFrame02; 
          
          Set<String> setDRTIds1 = new Set<String>{drt2.id};
          DRTSwiftUtility.checkDRTpackageSync(setDRTIds1);
          test.stopTest();
   }
   
    public static testMethod void createMSTfromPTRFTest()
    {
          Mask_Set_Title__c mst = SwiftDataUtilityTest.createMST('MYMST1');
          insert mst; 
          
          ptrf__c ptrf=new ptrf__c(Name='PTRF01',MaskSetTitle__c=mst.id,Order_Type__c='Test01',Recticle_Type__c='Single Layer Reticle (SLR)');
          
          insert ptrf;       

          //Set<String> setMSTIds = new Set<String>{mst.id};
          //string mstids=NULL;
          test.startTest();
          DRTSwiftUtility.createMSTfromPTRF(mst.id,ptrf.id, 'Single Layer Reticle (SLR)');
          test.stopTest();
          
          list<environment_variable__c> lstEV = new list<Environment_variable__c>();
          lstEV.add(new environment_variable__c (Name='SELF_SIGNED_CERTIFICATE',value__c='NO'));
          lstEV.add(new environment_variable__c (Name='SWIFT_MRS_PTRF_EndPoint',value__c='test.gfoundries.com'));
          lstEV.add(new environment_variable__c (Name='SWIFT_MRS_PTRF_OnOff',value__c='OFF'));
          insert lstEV;
          string temp ='testSFDCid::TestDRT::testPTRF::'+string.valueOf(system.now());
          list<string> lstdrtPTRF = new list<string>();
          lstdrtPTRF.add(temp);
          drtswiftutility.syncdrtPTRFdeletion(lstdrtPTRF);
          
   }
}