/*    Author: Cognizant    
Description: Apex test class for SwiftDRTPackSyncUtilityTest class    
History:     
Cognizant      05/15/2014    - Apex code created    
         
*/
@istest(SeeAllData=False)

public with sharing class SwiftDRTPackSyncUtilityTest {
    public static testMethod void checkDRTpackageSyncTest(){
          
          
          DRT__c drt1 = new DRT__c(Name='NewDRT1',
                                   Synced_with_Oracle_DB__c=false,
                                   DRT_Package_Sync__c=false
                                   );
          insert drt1; 
          
          PRIME_DRT_Layer_Association__c drtLayer1 = new PRIME_DRT_Layer_Association__c(Name ='layer001',
                                                                           Synced_with_Oracle_DB__c=false,
                                                                           DRT__c = drt1.id);
          insert drtLayer1; 
          
          LIST<PRIME_DRT_Layer_Association__c> drtLayer1List=new LIST<PRIME_DRT_Layer_Association__c>();
          drtLayer1List.add(drtLayer1);
          
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
          
          Mask_Set_Title__c mst = SwiftDataUtilityTest.createMST('MYMST1');          
          insert mst; 
                              
          MRS__c mrs1 = new MRS__c(Full_Sync__c =true,                                               
          Synced_with_Oracle_DB__c=false,                                               
          MRS_Package_Sync__c=false,                                               
          Mask_Set_Title__c=mst.Id);                      
          insert mrs1;
          
          map<id,list<PRIME_DRT_Layer_Association__c>> mapdrtLayAss = new map<id,list<PRIME_DRT_Layer_Association__c>>();
          mapdrtLayAss.put(drtLayer1.Id,drtLayer1List);
           
          //Select User__c, Account__c, Team_Role__c from Account_Team_Proxy__c where Account__c IN:setAccIds AND Team_Role__c 
          //User u1 = [Select Id,Email from User Where HCM_Login_ID__c = 'E9214']; 
          //String s = 'c';
          //LIST<Account> act=new LIST<ACCOUNT>();
          //act=Database.query('SELECT Id FROM Account WHERE Name != NULL');
          //if(act.size() > 0) 
          //{
           //Account_Team_Proxy__c acc=new Account_Team_Proxy__c(User__c=u1.Id,Account__c='001N000000EXSqY',Team_Role__c='Field Application Engineer');
           //insert acc;
          
          //Account_Team_Proxy__c acc=new Account_Team_Proxy__c(User__c=u1.Id,Account__c=act[0].Id,Team_Role__c='Field Application Engineer');          
          //}                                                                                                                     
          Set<String> setDRTIds = new Set<String>{drt1.id};
          Set<String> setMRSIds = new Set<String>{mrs1.Id};
          SwiftUtility.checkMRSpackageSyncFunc(setMRSIds);
          SwiftUtility.checkMRSpackageSyncFuncfuture(setMRSIds);
          SwiftUtility.CheckMRSpackageSyncFunc(setMRSIds);
          SwiftUtility.CheckMRSpackageSyncFuncfuture(setMRSIds);
          SwiftUtility.CheckMRSpackageSyncFuncnonfuture(setMRSIds);
          //setAccIds=get('001N000000EXSqY');
          test.startTest();
          SwiftUtility.checkDRTpackageSync(setDRTIds);
          SwiftUtility.checkDRTpackageSyncFuncfuture(setDRTIds);
          SwiftUtility.checkDRTpackageSyncFunc(setDRTIds);
          SwiftUtility.checkDRTpackageSyncFuncfuture(setDRTIds);
          SwiftUtility.checkDRTpackageSyncFuncnonfuture(setDRTIds);
          //SwiftUtility.drtPckgSyncTrigger(setDRTIds);
          SwiftUtility.checkDRTpackageSync(setDRTIds);
          
          SwiftUtility.checkMRSpackageSyncFunc(setMRSIds);
          SwiftUtility.checkMRSpackageSyncFuncfuture(setMRSIds);
          SwiftUtility.CheckMRSpackageSyncFuncnonfuture(setMRSIds);
          
          //Set<String> acc = new Set<String>();
          
          //SwiftUtility.fetchFEUsers(acc);
          
          //SwiftUtility.CheckMRSpackageSyncFunc(setMRSIds);
          //SwiftUtility.CheckMRSpackageSyncFuncfuture(setMRSIds);
          
          
          //Account a=new Account(Name='Test011');
          //insert a;
          
          //Account_Team_Proxy__c acc=new Account_Team_Proxy__c(User__c=u1.Id,Account__c=a.Id,Team_Role__c='Field Application Engineer');
          //insert acc;

          //if(acc.size()> 0) 
          //{
          //SwiftUtility.fetchFEUsers(setAccIds);
          //}
          
          // test script for updating the DRT objects as synced with oracle db equals to true
          
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
          
                    
          Set<String> setNewDRTIds = new Set<String>{drt2.id};
          
          SwiftUtility.checkDRTpackageSync(setNewDRTIds);
          
          //System.assertEquals(TRUE,drt2.DRT_Package_Sync__c);
          
          test.stopTest();                                                      
      } 
      //Test method for PRIME_DRT_Chip_Layer_Summary_SWIFT_AUPD trigger
    public static testMethod void testPRIME_DRT_Chip_Layer_Summary_SWIFT_AUPD(){
          
          Test.StartTest();
          Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
          User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
          LocaleSidKey='en_US', ProfileId = p.Id, 
          TimeZoneSidKey='America/Los_Angeles', UserName='GFIntegraionUser@testorg.com');
          insert u;
          System.runAs(u){
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
          
          
          PRIME_DRT_Chip_Layer_Summary__c layerChip1 = new PRIME_DRT_Chip_Layer_Summary__c(Synced_with_Oracle_DB__c=true,
                                                                                      Layer__c = drtLayer1.id,
                                                                                      Chip__c = drtChip1.id);                                                      
          insert layerChip1;
          PRIME_DRT_Chip_Layer_Summary__c layerChip2 = layerChip1; 
          layerChip2.Synced_with_Oracle_DB__c = false; 
                        
          update layerChip2;
          }
          Test.StopTest();
      }
      public static testMethod void checkDRTPckgSyncTriggerTest()
      {
          
          
          DRT__c drt = new DRT__c(Name='NewDRT1',
                                   Synced_with_Oracle_DB__c=false,
                                   DRT_Package_Sync__c=false
                                   );
          insert drt; 
          set<id> drtID = new set<id>();
          drtID.add(drt.id);
          swiftutility.drtPckgSyncTrigger(drtID);
     }
}