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
 @isTest(SeeAllData = false)
 private class FV_PDKSpecAssociationServiceTest {
    static testMethod void FV_PDKSpecAssociationServiceTest() {
        DataUtilTest.loadEnvironmentVariables();
        Account acc = FV_PDKTestDataTest.getAccount();
        List<Design_Spec__c> listOfDSpec = new List<Design_Spec__c>();
        ID pdk = FV_PDKTestDataTest.getPdk();
        Sub_PDK__c sPdk = FV_PDKTestDataTest.getSubPdk('PDK 1','Release To white list', pdk, 'Demo B1');
        Design_Spec__c dSpec1 = FV_PDKTestDataTest.getDesignSpec('Specific Account Release', 'abc', 'Spec 1', pdk, 11111, '0.11UM');
        Design_Spec__c dSpec2 = FV_PDKTestDataTest.getDesignSpec('Release To white list', 'abc', 'Spec 2', pdk, 12121, '0.11UM');
        listOfDSpec.add(dSpec1);
        listOfDSpec.add(dSpec2);
        insert listOfDSpec;
        
        White_List__c wl = new White_List__c();
        wl.Design_Spec__c = dSpec2.id;
        wl.Account__c = acc.id;
        insert wl;
        
        Sub_PDK_Spec__c subPdkSpec1 = new Sub_PDK_Spec__c();
        subPdkSpec1.Sub_PDK__c = sPdk.id;
        subPdkSpec1.Design_Spec__c = dSpec1.id;
        insert subPdkSpec1;
        
        Sub_PDK_Spec__c subPdkSpec2 = new Sub_PDK_Spec__c();
        subPdkSpec2.Sub_PDK__c = sPdk.id;
        subPdkSpec2.Design_Spec__c = dSpec2.id;
        insert subPdkSpec2;
        
        document_provisioning__c dp1 = FV_PDKTestDataTest.getDocumentProvisioningRecords(null, sPdk.Id,null,acc.Id,Id.valueOf(UserInfo.getUserId()),'Provisioned');
        insert dp1;
        FV_PDKSpecAssociationService.PDKSpecAssociationInfo pdkSpecInfo = new FV_PDKSpecAssociationService.PDKSpecAssociationInfo();
        pdkSpecInfo.subPdkId = sPdk.id;
        pdkSpecInfo.subPdkOtId = '111111';
        pdkSpecInfo.isReadyForProvision = true;
        pdkSpecInfo.failureSpecInfo = null;
        pdkSpecInfo.specAssSalesforceIds = subPdkSpec1.id+';'+subPdkSpec2.id;
        FV_PDKSpecAssociationService.PdkSpecResponseService(pdkSpecInfo);
        FV_PDKSpecAssociationService.sendEmail(sPdk.id);
        FV_PDKSpecAssociationService.deleteAllDPrecordsRelatedtoPDK(sPdk.id);
    }
 }