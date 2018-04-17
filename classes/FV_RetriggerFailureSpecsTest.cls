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
private class FV_RetriggerFailureSpecsTest {

    static testMethod void FV_RetriggerFailureSpecsTest() {
        
        List<Account> listOfAcc = new List<Account>();
       	List<Id> listOfAccIds = new List<Id>();
       	List<Design_Spec__c> listOfDSpec = new List<Design_Spec__c>();
       	Account acc = FV_PDKTestDataTest.getAccount();
       	listOfAcc.add(acc);
       	listOfAccIds.add(acc.Id);
       
       	ID pdk = FV_PDKTestDataTest.getPdk();
       	//Sub_PDK__c sPdk = FV_PDKTestDataTest.getSubPdk('PDK 1','Specific Account Release', pdk, 'Demo B1');
		Sub_PDK__c sPdk = FV_PDKTestDataTest.getSubPdk('PDK 1','Release To white list', pdk, 'Demo B1');
		Sub_PDK__c sPdk1 = FV_PDKTestDataTest.getSubPdk('PDK 2','Specific Account Release', pdk, 'Demo B2');
		
		PDK_Patch__c patch = FV_PDKTestDataTest.getPdkPatch(pdk);
		Design_Spec__c dSpec1 = FV_PDKTestDataTest.getDesignSpec('Specific Account Release', 'abc', 'Spec 1', pdk, 11111, '0.11UM');
       	Design_Spec__c dSpec2 = FV_PDKTestDataTest.getDesignSpec('Release To white list', 'abc', 'Spec 2', pdk, 12121, '0.11UM');
       	Design_Spec__c dSpec3 = FV_PDKTestDataTest.getPDKPatchSpec('Specific Account Release', 'abc', 'Spec 2', patch.Id, 88, '0.11UM');
        listOfDSpec.add(dSpec1);
        listOfDSpec.add(dSpec2);
        listOfDSpec.add(dSpec3);
        insert listOfDSpec;
        
        Test.startTest();
        	Package__c objPkg = FV_PDKTestDataTest.getPackage(acc);
        	List<document_provisioning__c> dProLst = new List<document_provisioning__c>();
	       	document_provisioning__c dp1 = FV_PDKTestDataTest.getDocumentProvisioningRecords(objPkg.Id, sPdk.Id, listOfDSpec[0].Id, acc.Id,Id.valueOf(UserInfo.getUserId()),'Provisioned');
	       	document_provisioning__c dp2 = FV_PDKTestDataTest.getDocumentProvisioningRecords(objPkg.Id, sPdk1.Id, listOfDSpec[1].Id, acc.Id,Id.valueOf(UserInfo.getUserId()),'De-Provisioned');
	       
	       	dProLst.add(dp1); 
	       	dProLst.add(dp2);
	       
	       	insert dProLst;
	       
	       FV_RetriggerFailureSpecs.provFailureSpecs(dProLst[0].Id);
	       FV_RetriggerFailureSpecs.provFailureSpecs(dProLst[1].Id);
	       
        Test.stopTest();
        
    }
}