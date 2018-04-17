/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest(SeeAllData = true)
private class FV_DocumentProvisioningUtilTest {

    static testMethod void dpUtilityTest() {
       List<Account> listOfAcc = new List<Account>();
       List<Id> listOfAccIds = new List<Id>();
       List<Design_Spec__c> listOfDSpec = new List<Design_Spec__c>();
       Account acc = FV_PDKTestDataTest.getAccount();
       listOfAcc.add(acc);
       listOfAccIds.add(acc.Id);
       
       ID pdk = FV_PDKTestDataTest.getPdk();
       
       Sub_PDK__c sPdk = FV_PDKTestDataTest.getSubPdk('PDK 1','Specific Account Release', pdk, 'Demo B1');
       Sub_PDK__c sPdk1 = FV_PDKTestDataTest.getSubPdk('PDK 2','Specific Account Release', pdk, 'Demo B2'+system.now());
       
       Design_Spec__c dSpec1 = FV_PDKTestDataTest.getDesignSpec('Specific Account Release', 'abc', 'Spec 1', pdk, 11111, '0.11UM');
       Design_Spec__c dSpec2 = FV_PDKTestDataTest.getDesignSpec('Release To white list', 'abc', 'Spec 2', pdk, 12121, '0.11UM');
       Design_Spec__c dSpec3 = FV_PDKTestDataTest.getDesignSpec('Specific Account Release', 'abc', 'Spec 3', pdk, 3344, '0.11UM');
       Design_Spec__c dSpec4 = FV_PDKTestDataTest.getDesignSpec('Release To white list', 'abc', 'Spec 4', pdk, 44, '0.11UM');
       
       listOfDSpec.add(dSpec1);
       listOfDSpec.add(dSpec2);
       listOfDSpec.add(dSpec3);
       listOfDSpec.add(dSpec4);
       
       insert listOfDSpec;
       
       White_List__c wList = FV_PDKTestDataTest.getWhiteList(listOfDSpec[1].Id, acc.Id);
       
       List<Sub_PDK_Spec__c> listOfSPdkSpecs = new List<Sub_PDK_Spec__c>();
       Sub_PDK_Spec__c sps1 = FV_PDKTestDataTest.getSubPdkSpec(sPdk.Id,listOfDSpec[0].Id,'5555');
       Sub_PDK_Spec__c sps2 = FV_PDKTestDataTest.getSubPdkSpec(sPdk.Id,listOfDSpec[1].Id,'11');
       Sub_PDK_Spec__c sps3 = FV_PDKTestDataTest.getSubPdkSpec(sPdk1.Id,listOfDSpec[2].Id,'222');
       Sub_PDK_Spec__c sps4 = FV_PDKTestDataTest.getSubPdkSpec(sPdk1.Id,listOfDSpec[3].Id,'333');
       
       listOfSPdkSpecs.add(sps1);
       listOfSPdkSpecs.add(sps2);
       listOfSPdkSpecs.add(sps3);
       listOfSPdkSpecs.add(sps4);
       
       insert listOfSPdkSpecs;
      
       Package__c objPkg = FV_PDKTestDataTest.getPackage(acc);
         
       Test.startTest();
       
           FV_DocumentProvisioningUtil.provisionNewPDK(sPdk, listOfAcc);
           FV_DocumentProvisioningUtil.provisionNewPDK(sPdk1, listOfAcc);
           List<document_provisioning__c> dProLst = new List<document_provisioning__c>();
            
           document_provisioning__c dp1 = FV_PDKTestDataTest.getDocumentProvisioningRecords(objPkg.Id, sPdk.Id, listOfDSpec[0].Id, acc.Id,Id.valueOf(UserInfo.getUserId()),'Provisioned');
           document_provisioning__c dp2 = FV_PDKTestDataTest.getDocumentProvisioningRecords(objPkg.Id, sPdk1.Id, listOfDSpec[1].Id, acc.Id,Id.valueOf(UserInfo.getUserId()),'Provisioned');
           
           dProLst.add(dp1); 
           dProLst.add(dp2);
           
           insert dProLst; 
           List<Id> sPdkLst = new List<Id>(); 
           sPdkLst.add(sPdk.Id);
           
          
           FV_DocumentProvisioningUtil.updatePdkProvisioning(listOfSPdkSpecs);
           FV_DocumentProvisioningUtil.updatePdkProvisioningforWL(listOfSPdkSpecs);
           FV_DocumentProvisioningUtil.updatePdkProvisioningforWLnoChange(listOfSPdkSpecs);
           FV_DocumentProvisioningUtil.deprovisionPDK(sPdk.Id,listOfAccIds);            
           set<Id> subpdkids = new set<ID>();
           subpdkids.add(sPdk.Id);
           FV_DocumentProvisioningUtil.deprovisionPDKBulk(subpdkids,listOfAccIds);            
          
           
                     
           document_provisioning__c dp3 = FV_PDKTestDataTest.getDocumentProvisioningRecords(objPkg.Id, sPdk1.Id, listOfDSpec[2].Id, acc.Id,Id.valueOf(UserInfo.getUserId()),'Provisioned');
           document_provisioning__c dp4 = FV_PDKTestDataTest.getDocumentProvisioningRecords(objPkg.Id, sPdk.Id, listOfDSpec[3].Id, acc.Id,Id.valueOf(UserInfo.getUserId()),'Provisioned');
           
           List<document_provisioning__c> dProLst1 = new List<document_provisioning__c>();
           
           dProLst1.add(dp3);
           dProLst1.add(dp4);
           
           insert dProLst1;
           Set<Id> setOfPdkIds = new Set<Id>();
           setOfPdkIds.add(sPdk.Id);
           
           FV_DocumentProvisioningUtil.deProvisionUpdatePDK(setOfPdkIds, listOfSPdkSpecs);  
           FV_DocumentProvisioningUtil.deProvisionUpdatePDKforSpecRemove(setOfPdkIds, listOfSPdkSpecs);  
       Test.stopTest();
    }
    static testMethod void dpUtilityTest2() {
       List<Account> listOfAcc = new List<Account>();
       List<Id> listOfAccIds = new List<Id>();
       List<Design_Spec__c> listOfDSpec = new List<Design_Spec__c>();
       Account acc = FV_PDKTestDataTest.getAccount();
       listOfAcc.add(acc);
       listOfAccIds.add(acc.Id);
       
       ID pdk = FV_PDKTestDataTest.getPdk();
       
       Sub_PDK__c sPdk = FV_PDKTestDataTest.getSubPdk('PDK 1','Specific Account Release', pdk, 'Demo B1');
       Sub_PDK__c sPdk1 = FV_PDKTestDataTest.getSubPdk('PDK 2','Specific Account Release', pdk, 'Demo B2'+system.now());
       
       Design_Spec__c dSpec1 = FV_PDKTestDataTest.getDesignSpec('Specific Account Release', 'abc', 'Spec 1', pdk, 11111, '0.11UM');
       Design_Spec__c dSpec2 = FV_PDKTestDataTest.getDesignSpec('Release To white list', 'abc', 'Spec 2', pdk, 12121, '0.11UM');
       Design_Spec__c dSpec3 = FV_PDKTestDataTest.getDesignSpec('Specific Account Release', 'abc', 'Spec 3', pdk, 3344, '0.11UM');
       Design_Spec__c dSpec4 = FV_PDKTestDataTest.getDesignSpec('Release To white list', 'abc', 'Spec 4', pdk, 44, '0.11UM');
       
       listOfDSpec.add(dSpec1);
       listOfDSpec.add(dSpec2);
       listOfDSpec.add(dSpec3);
       listOfDSpec.add(dSpec4);
       
       insert listOfDSpec;
       
       White_List__c wList = FV_PDKTestDataTest.getWhiteList(listOfDSpec[1].Id, acc.Id);
       
       List<Sub_PDK_Spec__c> listOfSPdkSpecs = new List<Sub_PDK_Spec__c>();
       Sub_PDK_Spec__c sps1 = FV_PDKTestDataTest.getSubPdkSpec(sPdk.Id,listOfDSpec[0].Id,'5555');
       Sub_PDK_Spec__c sps2 = FV_PDKTestDataTest.getSubPdkSpec(sPdk.Id,listOfDSpec[1].Id,'11');
       Sub_PDK_Spec__c sps3 = FV_PDKTestDataTest.getSubPdkSpec(sPdk1.Id,listOfDSpec[2].Id,'222');
       Sub_PDK_Spec__c sps4 = FV_PDKTestDataTest.getSubPdkSpec(sPdk1.Id,listOfDSpec[3].Id,'333');
       
       listOfSPdkSpecs.add(sps1);
       listOfSPdkSpecs.add(sps2);
       listOfSPdkSpecs.add(sps3);
       listOfSPdkSpecs.add(sps4);
       
       insert listOfSPdkSpecs;
      
       Package__c objPkg = FV_PDKTestDataTest.getPackage(acc);
         
       Test.startTest();
       
           FV_DocumentProvisioningUtil.provisionNewPDK(sPdk, listOfAcc);
           FV_DocumentProvisioningUtil.provisionNewPDK(sPdk1, listOfAcc);
           List<document_provisioning__c> dProLst = new List<document_provisioning__c>();
            
           document_provisioning__c dp1 = FV_PDKTestDataTest.getDocumentProvisioningRecords(objPkg.Id, sPdk.Id, listOfDSpec[0].Id, acc.Id,Id.valueOf(UserInfo.getUserId()),'Provisioned');
           document_provisioning__c dp2 = FV_PDKTestDataTest.getDocumentProvisioningRecords(objPkg.Id, sPdk1.Id, listOfDSpec[1].Id, acc.Id,Id.valueOf(UserInfo.getUserId()),'Provisioned');
           
           dProLst.add(dp1); 
           dProLst.add(dp2);
           
           insert dProLst; 
           List<Id> sPdkLst = new List<Id>(); 
           sPdkLst.add(sPdk.Id);
           
          
           FV_DocumentProvisioningUtil.updatePdkProvisioning(listOfSPdkSpecs);
           FV_DocumentProvisioningUtil.updatePdkProvisioningforWL(listOfSPdkSpecs);
           FV_DocumentProvisioningUtil.updatePdkProvisioningforWLnoChange(listOfSPdkSpecs);           
           set<Id> subpdkids = new set<ID>();
           subpdkids.add(sPdk.Id);
           FV_DocumentProvisioningUtil.deprovisionPDKBulk(subpdkids,listOfAccIds);            
          
           
                     
           document_provisioning__c dp3 = FV_PDKTestDataTest.getDocumentProvisioningRecords(objPkg.Id, sPdk1.Id, listOfDSpec[2].Id, acc.Id,Id.valueOf(UserInfo.getUserId()),'Provisioned');
           document_provisioning__c dp4 = FV_PDKTestDataTest.getDocumentProvisioningRecords(objPkg.Id, sPdk.Id, listOfDSpec[3].Id, acc.Id,Id.valueOf(UserInfo.getUserId()),'Provisioned');
           
           List<document_provisioning__c> dProLst1 = new List<document_provisioning__c>();
           
           dProLst1.add(dp3);
           dProLst1.add(dp4);
           
           insert dProLst1;
           Set<Id> setOfPdkIds = new Set<Id>();
           setOfPdkIds.add(sPdk.Id);
           
           FV_DocumentProvisioningUtil.deProvisionUpdatePDK(setOfPdkIds, listOfSPdkSpecs);  
           FV_DocumentProvisioningUtil.deProvisionUpdatePDKforSpecRemove(setOfPdkIds, listOfSPdkSpecs);  
       Test.stopTest();
    }
    
}