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
private class FV_RetriggerPdkSpecAssociationTest {
	static testMethod void FV_RetriggerPdkSpecAssociationTest() {
		List<Design_Spec__c> listOfDSpec = new List<Design_Spec__c>();
		ID pdk = FV_PDKTestDataTest.getPdk();
 		Sub_PDK__c sPdk = FV_PDKTestDataTest.getSubPdk('PDK 1','Release To white list', pdk, 'Demo B1');
 		Design_Spec__c dSpec1 = FV_PDKTestDataTest.getDesignSpec('Specific Account Release', 'abc', 'Spec 1', pdk, 11111, '0.11UM');
       	Design_Spec__c dSpec2 = FV_PDKTestDataTest.getDesignSpec('Release To white list', 'abc', 'Spec 2', pdk, 12121, '0.11UM');
        listOfDSpec.add(dSpec1);
        listOfDSpec.add(dSpec2);
        insert listOfDSpec;
        
        Sub_PDK_Spec__c subPdkSpec1 = new Sub_PDK_Spec__c();
        subPdkSpec1.Sub_PDK__c = sPdk.id;
        subPdkSpec1.Design_Spec__c = dSpec1.id;
        insert subPdkSpec1;
        
        Sub_PDK_Spec__c subPdkSpec2 = new Sub_PDK_Spec__c();
        subPdkSpec2.Sub_PDK__c = sPdk.id;
        subPdkSpec2.Design_Spec__c = dSpec2.id;
        insert subPdkSpec2;
		FV_RetriggerPdkSpecAssociation.retriggerPdkSpecs(sPdk.id);
	}
}