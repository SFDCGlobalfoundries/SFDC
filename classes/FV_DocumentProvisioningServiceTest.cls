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
private class FV_DocumentProvisioningServiceTest {

    static testMethod void FV_DocumentProvisioningServiceTest() {
        List<Account> listOfAcc = new List<Account>();
        List<Id> listOfAccIds = new List<Id>();
        List<Design_Spec__c> listOfDSpec = new List<Design_Spec__c>();
        Account acc = FV_PDKTestDataTest.getAccount();
        listOfAcc.add(acc);
        listOfAccIds.add(acc.Id);
       
        ID pdk = FV_PDKTestDataTest.getPdk();
        //Sub_PDK__c sPdk = FV_PDKTestDataTest.getSubPdk('PDK 1','Specific Account Release', pdk, 'Demo B1');
        Sub_PDK__c sPdk = FV_PDKTestDataTest.getSubPdk('PDK 1','Release To white list', pdk, 'Demo B1');
        Design_Spec__c dSpec1 = FV_PDKTestDataTest.getDesignSpec('Specific Account Release', 'abc', 'Spec 1', pdk, 11111, '0.11UM');
        Design_Spec__c dSpec2 = FV_PDKTestDataTest.getDesignSpec('Release To white list', 'abc', 'Spec 2', pdk, 12121, '0.11UM');
        listOfDSpec.add(dSpec1);
        listOfDSpec.add(dSpec2);
        
        insert listOfDSpec;
        
         Test.startTest();
            Package__c objPkg = FV_PDKTestDataTest.getPackage(acc);
            List<document_provisioning__c> dProLst = new List<document_provisioning__c>();
            document_provisioning__c dp1 = FV_PDKTestDataTest.getDocumentProvisioningRecords(objPkg.Id, sPdk.Id, listOfDSpec[0].Id, acc.Id,Id.valueOf(UserInfo.getUserId()),'Provisioned');
            dp1.PDK_Spec_Names__c = 'prov1;prov2;prov3';
            document_provisioning__c dp2 = FV_PDKTestDataTest.getDocumentProvisioningRecords(objPkg.Id, sPdk.Id, listOfDSpec[1].Id, acc.Id,Id.valueOf(UserInfo.getUserId()),'Provisioned In Progress');
            dp2.PDK_Spec_Names__c = 'prov1;prov2;prov3';
            
           
            dProLst.add(dp1); 
            dProLst.add(dp2);
           
            insert dProLst;
            
            List<FV_DocumentProvisioningService.PDKProInfo> lstofPdkInfo = new List<FV_DocumentProvisioningService.PDKProInfo>();
            FV_DocumentProvisioningService.responseInfo respService = new FV_DocumentProvisioningService.responseInfo(true,'');
            
            FV_DocumentProvisioningService.PDKProInfo pdkService1 = new FV_DocumentProvisioningService.PDKProInfo();
            pdkService1.accShortname='acc1';
            pdkService1.dpId = String.valueOf(dProLst[0].Id);
            pdkService1.failureSpecInfo=''; //3212a:bb342&&Error meeesge
            pdkService1.PARAM1='11:22;33:44';
            pdkService1.specAssDeProOtIds='';
            pdkService1.specAssOtIds='12121212:223344;232323232:55555';
            pdkService1.specNamesDeProv ='';
            pdkService1.specNamesProv ='prov1;prov2;prov3';
            pdkService1.status='Provisioned';
            pdkService1.subPdkId=String.valueOf(sPdk.Sub_PDK_OpenText_Id__c);
            
            FV_DocumentProvisioningService.PDKProInfo pdkService2 = new FV_DocumentProvisioningService.PDKProInfo();
            pdkService2.accShortname='acc2';
            pdkService2.dpId = String.valueOf(dProLst[1].Id);
            pdkService2.failureSpecInfo='';
            pdkService2.PARAM1='11:22;33:44';
            pdkService2.specAssDeProOtIds='12121:22334;2323232:555';
            pdkService2.specAssOtIds='';
            pdkService2.specNamesDeProv ='prov1;prov2;prov3';
            pdkService2.specNamesProv ='';
            pdkService2.status='Provisioned';
            pdkService2.otErrorMsg = '3212a:bb342&&';
            pdkService2.specAssDeProOtIds='ot1111:sp1111;ot222:sp222';
            pdkService2.subPdkId=String.valueOf(sPdk.Sub_PDK_OpenText_Id__c);
            
            lstofPdkInfo.add(pdkService1);
            lstofPdkInfo.add(pdkService2);
            
            FV_DocumentProvisioningService.PdkProResponseService(lstofPdkInfo);
            FV_DocumentProvisioningService.sendEmail(dp1.id);
        Test.stopTest();       
    }
}