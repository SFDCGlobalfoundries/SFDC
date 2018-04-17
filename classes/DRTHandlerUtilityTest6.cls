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
@isTest
private class DRTHandlerUtilityTest6 {

    /**
	This method initialize data using throughout this test class.
	The create data method are: 
	- SwiftDataUtilityTest.customSystemData();
	@author		SWIFT TEAM
	@since		7-April-2015
	*/
	@testSetup static void setup() {
		SwiftDataUtilityTest.customSystemData();
	}
	
	 /*
   This test method tests the below functionality of the class DRTHandlerUtility
   fetchNewChipLayerData()
 	*/ 
    @isTest
    public static void fetchNewChipLayerDataTest(){
        //load the custom settings
        // comment-out, refactor with testSetup method setup()
		// SwiftDataUtilityTest.customSystemData();
        
        Account acc = SwiftDataUtilityTest.createTestAccount();
        List<Mask_Set_Title__c> mstList=SwiftDataUtilityTest.maskSetTitleList(1);
        
        List<DRT__c> drtList=SwiftDataUtilityTest.createDRTList1(1,mstList[0],acc.Id);
        DRT__c drt=drtList[0];
        List<PRIME_DRT_Layer_Association__c> pdlaList=SwiftDataUtilityTest.createPDLA(drt.Id);
        
        List<PRIME_DRT_Chip_Association__c> pdcaList=SwiftDataUtilityTest.createPDCA(drt.Id,mstList[0].Id);
        
        List<PRIME_DRT_Chip_Layer_Summary__c> pdcls=SwiftDataUtilityTest.createPDCLS(pdlaList,pdcaList);
        
        MST_Config__c mstConfig = SwiftDataUtilityTest.createMSTconfig(acc.Id,mstList[0].Id);
        Opportunity oppr = SwiftDataUtilityTest.createOpportunityDRT(acc.Id);
        Opportunity_Program__c opprProg = SwiftDataUtilityTest.createOpportunityProgramDRT(acc.Id, oppr.Id);
        
        Process_Technology__c pt = SwiftDataUtilityTest.createProcessTechnology();
        test.startTest();
        Device__c testDevice = SwiftDataUtilityTest.createDeviceWithPT(acc.Id, oppr.Id,opprProg.Id,pt.Id);
        PTRF__c ptrf=SwiftDataUtilityTest.createPTRF_ForDRT(mstList[0].Id, testDevice.Id,acc.Id);
        DRT_PTRF_Association__c dpa = SwiftDataUtilityTest.createDPA(drt.Id,ptrf.Id);
        Chip_Detail__c chip_Detail=SwiftDataUtilityTest.createChipDetailDRT(ptrf.Id);
        List<Frame_DRT_Association__c> fdaList=SwiftDataUtilityTest.createFDA(drt);
        Mask_Layer__c maskLayer=SwiftDataUtilityTest.createMaskLayerDRT(ptrf);
        
        List<DRTHandlerUtility.MaskLayerWrapper> mlwList =new List<DRTHandlerUtility.MaskLayerWrapper>{new DRTHandlerUtility.MaskLayerWrapper('111','AZ','001')};
        
        list<DRTHandlerUtility.MaskRevROMCodeWrapper> maskRevRomCodeList = DRTHandlerUtility.fetchNewChipLayerData(chip_Detail.name,mlwList,mstList[0].Id,mstList[0].Id,ptrf.Tech_Geo__c,1);
        system.assertEquals(maskRevRomCodeList.size(),1);
        test.stopTest();
    }
    
   /*
   This test method tests the below functionality of the class DRTHandlerUtility
   fetchDRTDetails()
 	*/ 
    @isTest
    public static void fetchDRTDetailsTest(){
        
        // comment-out, refactor with testSetup method setup()
		// SwiftDataUtilityTest.customSystemData();
        
        Account acc = SwiftDataUtilityTest.createTestAccount();
        List<Mask_Set_Title__c> mstList=SwiftDataUtilityTest.maskSetTitleList(1);
        
        List<DRT__c> drtList=SwiftDataUtilityTest.createDRTList(1,mstList[0]);
        
        DRT__c drt=drtList[0];
        
        drt.Customer_Name__c=acc.Id;
        drt.Name='MYMST_PRIME_DRT_035.001';
        
        update drt;
        
        test.startTest();
        DRT__c drt1=DRTHandlerUtility.fetchDRTDetails(drt.Id);
        system.assert(drt1!=null);
        system.assertEquals(drt1.name, drt.name);
        test.stopTest();
    }
    
     /*
   This test method tests the below functionality of the class DRTHandlerUtility
   fetchPrimeDRTLayerAssociationList()
   fetchPrimeDRTChipAssociationList()
   fetchPrimeDRTChipLayerSummaryList()
   fetchDrtPTRFAssociation()
   fetchMapOfIdAndMSTName()
 	*/ 
    @isTest
    public static void fetchPrimeDRTLayerAssociationListTest(){
        // comment-out, refactor with testSetup method setup()
		// SwiftDataUtilityTest.customSystemData();
        
        Account acc = SwiftDataUtilityTest.createTestAccount();
        List<Mask_Set_Title__c> mstList=SwiftDataUtilityTest.maskSetTitleList(1);
        
        List<DRT__c> drtList=SwiftDataUtilityTest.createDRTList(1,mstList[0]);
        
        DRT__c drt=drtList[0];
        
        drt.Customer_Name__c=acc.Id;
        drt.Name='MYMST_PRIME_DRT_035.001';
        
        update drt;
        
        List<PRIME_DRT_Layer_Association__c> pdlaList=SwiftDataUtilityTest.createPDLA(drt.Id);
        
        List<PRIME_DRT_Chip_Association__c> pdcaList=SwiftDataUtilityTest.createPDCA(drt.Id,mstList[0].Id);
        
        List<PRIME_DRT_Chip_Layer_Summary__c> pdcls=SwiftDataUtilityTest.createPDCLS(pdlaList,pdcaList);
        
        MST_Config__c mstConfig = SwiftDataUtilityTest.createMSTconfig(acc.Id,mstList[0].Id);
        Opportunity oppr = SwiftDataUtilityTest.createOpportunityDRT(acc.Id);
        Opportunity_Program__c opprProg = SwiftDataUtilityTest.createOpportunityProgramDRT(acc.Id, oppr.Id);
        
        Process_Technology__c pt = SwiftDataUtilityTest.createProcessTechnology();
        test.startTest();
        Device__c testDevice = SwiftDataUtilityTest.createDeviceWithPT(acc.Id,oppr.Id, opprProg.Id,pt.Id);
        PTRF__c ptrf=SwiftDataUtilityTest.createPTRF_ForDRT(mstList[0].Id, testDevice.Id,acc.Id);
        Chip_Detail__c chip_Detail=SwiftDataUtilityTest.createChipDetailDRT(ptrf.Id);
        List<Frame_DRT_Association__c> fdaList=SwiftDataUtilityTest.createFDA(drt);
        Mask_Layer__c maskLayer=SwiftDataUtilityTest.createMaskLayerDRT(ptrf);
        DRT_PTRF_Association__c dpa = SwiftDataUtilityTest.createDPA(drt.Id,ptrf.Id);
        
        
        list<PRIME_DRT_Layer_Association__c> pdlaList1=DRTHandlerUtility.fetchPrimeDRTLayerAssociationList(drt.Id);
        system.assertEquals(pdlaList1.size(), 3);
        list<PRIME_DRT_Chip_Association__c> pdcaList1=DRTHandlerUtility.fetchPrimeDRTChipAssociationList(drt.Id);
        system.assertEquals(pdcaList1.size(), 2);
        list<PRIME_DRT_Chip_Layer_Summary__c> pdclsList1=DRTHandlerUtility.fetchPrimeDRTChipLayerSummaryList(pdlaList,pdcaList);
        system.assertEquals(pdclsList1.size(), 2);
        list<DRT_PTRF_Association__c> dpaList=DRTHandlerUtility.fetchDrtPTRFAssociation(drt.Id);
        system.assertEquals(dpaList.size(), 1);
        Map<Id,String> dpaMap=DRTHandlerUtility.fetchMapOfIdAndMSTName(new List<DRT_PTRF_Association__c>{dpa}); 
        system.assertEquals(dpaMap.size(), 0);
        test.stopTest();
    }
    
     /*
   This test method tests the below functionality of the class DRTHandlerUtility
   isCreateDRTApplicable()
   isViewDRTApplicable()
   isEditDRTApplicable()
 	*/ 
    @isTest
    public static void isTapeoutCentreUserTest(){
        
        User u2;
        
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        System.runAs ( thisUser ) {
            
            Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
            u2 = new User(alias = 'testMRS', email='testMRS@test.com',
            emailencodingkey='UTF-8', lastname='testMRSLast', firstname='testMRSFirst', languagelocalekey='en_US',
            localesidkey='en_US', profileid = p.Id, 
            timezonesidkey='America/Los_Angeles', username='testMRS@test.com',communitynickname='testMRS',FederationIdentifier='Test');   
            
            Insert u2;
            
            Group testGroup = [select id,developername from group where developername = 'Swift_Tapeout_Centre'];
            
            GroupMember GM = new GroupMember();
            GM.GroupId = testGroup.id;
            GM.UserOrGroupId = u2.Id;
            insert GM;   
        }
        System.RunAs(u2){
            // comment-out, refactor with testSetup method setup()
			// SwiftDataUtilityTest.customSystemData();
        
            Account acc = SwiftDataUtilityTest.createTestAccount();
        
            List<Mask_Set_Title__c> mstList=SwiftDataUtilityTest.maskSetTitleList(1);
        
            List<DRT__c> drtList=SwiftDataUtilityTest.createDRTList(1,mstList[0]);
            
            DRT__c drt=drtList[0];
            
            drt.Customer_Name__c=acc.Id;
            drt.Name='MYMST_PRIME_DRT_035.001';
            
            update drt;
            
            test.startTest();
            boolean isCreate = DRTHandlerUtility.isCreateDRTApplicable();
            system.assertEquals(isCreate, true);
            boolean isView=DRTHandlerUtility.isViewDRTApplicable();
            system.assertEquals(isView,true);
            boolean isEdit = DRTHandlerUtility.isEditDRTApplicable(drt);
            system.assertEquals(isEdit,true);
            test.stopTest();
       }                     
    }
    
  
	
}