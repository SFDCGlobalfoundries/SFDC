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
private class FV_DesignSpecDocProvisioningServiceTest {

    static testMethod void FV_DesignSpecDocProvisioningServiceTest() {
    	List<Account> listOfAcc = new List<Account>();
       	List<Id> listOfAccIds = new List<Id>();
       	List<Design_Spec__c> listOfDSpec = new List<Design_Spec__c>();
       	Account acc = FV_PDKTestDataTest.getAccount();
       	listOfAcc.add(acc);
       	listOfAccIds.add(acc.Id);
       
		Design_Spec__c dSpec1 = FV_PDKTestDataTest.getDesignSpec('Specific Account Release', 'abc', 'Spec 1', null, 11111, '0.11UM');
       	Design_Spec__c dSpec2 = FV_PDKTestDataTest.getDesignSpec('Release To white list', 'abc', 'Spec 2',null, 12121, '0.11UM');
        listOfDSpec.add(dSpec1);
        listOfDSpec.add(dSpec2);
        
        insert listOfDSpec;
        
         Test.startTest();
        	List<document_provisioning__c> dProLst = new List<document_provisioning__c>();
	       	document_provisioning__c dp1 = FV_PDKTestDataTest.getDocumentProvisioningRecords(null,null, listOfDSpec[0].Id, acc.Id,Id.valueOf(UserInfo.getUserId()),'Provisioned');
	       	document_provisioning__c dp2 = FV_PDKTestDataTest.getDocumentProvisioningRecords(null,null, listOfDSpec[1].Id, acc.Id,Id.valueOf(UserInfo.getUserId()),'Provisioned In Progress');
	       	//document_provisioning__c dp2 = FV_PDKTestDataTest.getDocumentProvisioningRecords(objPkg.Id, sPdk1.Id, listOfDSpec[1].Id, acc.Id,Id.valueOf(UserInfo.getUserId()),'Sent For Approval');
	       
	       	dProLst.add(dp1); 
	       	dProLst.add(dp2);
	       
	       	insert dProLst;
	       	
	       	List<FV_DesignSpecDocProvisioningService.DesignSpecProInfo> lstofDesignSpecProInfo = new List<FV_DesignSpecDocProvisioningService.DesignSpecProInfo>();
	       	FV_DesignSpecDocProvisioningService.responseInfo respService = new FV_DesignSpecDocProvisioningService.responseInfo(true,'');
	       	
	       	FV_DesignSpecDocProvisioningService.DesignSpecProInfo designSpecService1 = new FV_DesignSpecDocProvisioningService.DesignSpecProInfo();
	       	designSpecService1.dpId = String.valueOf(dProLst[0].Id);
	       	designSpecService1.isSyncWithOt = true;
	       	designSpecService1.status='Provisioned';
	       	designSpecService1.otErrorMsg = '';
	       	
	       	FV_DesignSpecDocProvisioningService.DesignSpecProInfo designSpecService2 = new FV_DesignSpecDocProvisioningService.DesignSpecProInfo();
	       	//pdkService2.accShortname='acc2';
	       	designSpecService2.dpId = String.valueOf(dProLst[1].Id);
	       	designSpecService2.status='Provisioned';
	       	
	       	lstofDesignSpecProInfo.add(designSpecService1);
	       	lstofDesignSpecProInfo.add(designSpecService2);
	       	
	       	FV_DesignSpecDocProvisioningService.DesignSpecResponseService(lstofDesignSpecProInfo);
	       	
	    Test.stopTest(); 	   
    }
}