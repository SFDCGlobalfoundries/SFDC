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
private class DRTHandlerUtilityTest9 {

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
   validateMainTableData()
 */ 
    @isTest
    public static void validateMainTableDataTest(){
        // comment-out, refactor with testSetup method setup()
		// SwiftDataUtilityTest.customSystemData();
        
        Account acc = SwiftDataUtilityTest.createTestAccount();
        List<Mask_Set_Title__c> mstList=SwiftDataUtilityTest.maskSetTitleList(1);
        
        List<DRT__c> drtList=SwiftDataUtilityTest.createDRTList(1,mstList[0]);
        
        DRT__c drt=drtList[0];
        
        drt.Customer_Name__c=acc.Id;
        drt.Name='MYMST_PRIME_DRT_035.001';
        test.startTest();
        update drt;
        
        system.assertEquals(drt.Name,'MYMST_PRIME_DRT_035.001');
        
        List<PRIME_DRT_Chip_Association__c> pdcaList=SwiftDataUtilityTest.createPDCA(drt.Id,mstList[0].Id);
        List<PRIME_DRT_Chip_Association__c> pdcaList2=SwiftDataUtilityTest.createPDCA(drt.Id,null);
        List<PRIME_DRT_Chip_Association__c> pdcaList3=SwiftDataUtilityTest.createPDCA(drt.Id,mstList[0].Id);
        pdcaList3[0].name='';
        update pdcaList3[0];
        
        List<PRIME_DRT_Chip_Association__c> pdcaList4=SwiftDataUtilityTest.createPDCA(drt.Id,mstList[0].Id);
        pdcaList4[0].name='Prime';
        update pdcaList4[0];  
        
        List<PRIME_DRT_Chip_Association__c> pdcaList5=SwiftDataUtilityTest.createPDCA(drt.Id,mstList[0].Id);
        pdcaList5[0].name='#123Test';
        update pdcaList5[0];
          
      
      DRTHandlerUtility.ErrorDetails ed=new DRTHandlerUtility().validateMainTableData(pdcaList,drt);
      system.assertNotEquals(ed, null);
      DRTHandlerUtility.ErrorDetails ed1=new DRTHandlerUtility().validateMainTableData(pdcaList2,drt);
      system.assertNotEquals(ed1, null);
      DRTHandlerUtility.ErrorDetails ed2=new DRTHandlerUtility().validateMainTableData(pdcaList3,drt);
      system.assertNotEquals(ed2, null);
      DRTHandlerUtility.ErrorDetails ed3=new DRTHandlerUtility().validateMainTableData(pdcaList4,drt);
      system.assertNotEquals(ed3, null);
      DRTHandlerUtility.ErrorDetails ed4=new DRTHandlerUtility().validateMainTableData(pdcaList5,drt);
      system.assertNotEquals(ed4, null);
      DRTHandlerUtility.ErrorDetails ed5=new DRTHandlerUtility().validateMainTableData(null,drt);
      system.assertNotEquals(ed5, null);
      test.stopTest();
    }
    
     /*
   This test method tests the below functionality of the class DRTHandlerUtility
   fetchMaskRevROMCodeList()
 */ 
    @isTest
    public static void fetchMaskRevROMCodeListTest(){
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
        
        List<DRTHandlerUtility.MaskLayerWrapper> mlwList =new List<DRTHandlerUtility.MaskLayerWrapper>{new DRTHandlerUtility.MaskLayerWrapper('MLN001','RMR1','RRC1')};
        List<DRTHandlerUtility.ChipWrapper> cwList = new List<DRTHandlerUtility.ChipWrapper>{new DRTHandlerUtility.ChipWrapper(mstList[0].Id,chip_Detail.Name)};
        new DRTHandlerUtility().fetchMaskRevROMCodeList(mstList[0].Id,drt.DRT_Type__c,ptrf.Tech_Geo__c,mlwList,cwList,new List<Mask_Layer__c>{maskLayer},1);
        test.stopTest();
    }
    
     /*
   This test method tests the below functionality of the class DRTHandlerUtility
   fetchFrameDRTAssociation()
 	*/ 
    @isTest
    public static void fetchFrameDRTAssociationTest(){
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
      
      list<Frame_DRT_Association__c> frameDrtAssoc=DRTHandlerUtility.fetchFrameDRTAssociation(drt.Id);
      system.assertEquals(frameDrtAssoc.size(),3);
      test.stopTest();
    }
    
     /*
   This test method tests the below functionality of the class DRTHandlerUtility
   isReviseApplicable()
 	*/ 
    @isTest
    public static void isReviseApplicableTest(){
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
        Device__c testDevice = SwiftDataUtilityTest.createDeviceWithPT(acc.Id,oppr.Id, opprProg.Id,pt.Id);
        PTRF__c ptrf=SwiftDataUtilityTest.createPTRF_ForDRT(mstList[0].Id, testDevice.Id,acc.Id);
        Chip_Detail__c chip_Detail=SwiftDataUtilityTest.createChipDetailDRT(ptrf.Id);
        List<Frame_DRT_Association__c> fdaList=SwiftDataUtilityTest.createFDA(drt);
        Mask_Layer__c maskLayer=SwiftDataUtilityTest.createMaskLayerDRT(ptrf);
        DRT_PTRF_Association__c dpa = SwiftDataUtilityTest.createDPA(drt.Id,ptrf.Id);
        
        Boolean isRevise = DRTHandlerUtility.isReviseApplicable(drt.Id);
        system.assertEquals(isRevise, false);
        Boolean isRevise1 = DRTHandlerUtility.isReviseApplicable(null);
        system.assertEquals(isRevise1, false);
        test.stopTest();    
    }
}