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
private class DRTHandlerUtilityTest7 {

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
   fetchLayerNos()
 */  
    @isTest
    public static void fetchLayerNosTest(){
        // comment-out, refactor with testSetup method setup()
		// SwiftDataUtilityTest.customSystemData();
        Account acc = SwiftDataUtilityTest.createTestAccount();
        List<Mask_Set_Title__c> mstList = SwiftDataUtilityTest.maskSetTitleList(2);
        List<DRT__c> drtList=SwiftDataUtilityTest.createDRTList1(1,mstList[0],acc.Id);
        DRT__c drt=drtList[0];
        MST_Config__c mstConfig = SwiftDataUtilityTest.createMSTconfig(acc.Id,mstList[0].Id);
        Opportunity opp = SwiftDataUtilityTest.createOpportunityDRT(acc.Id);
        Opportunity_Program__c oppProg = SwiftDataUtilityTest.createOpportunityProgramDRT(acc.Id, opp.Id);
        Process_Technology__c pt = SwiftDataUtilityTest.createProcessTechnology();
        
        test.startTest();
        
        Device__c testDevice = SwiftDataUtilityTest.createDeviceWithPT(acc.Id, opp.Id,oppProg.Id,pt.Id);
        PTRF__c ptrf = SwiftDataUtilityTest.createPTRF_ForDRT(mstList[0].Id, testDevice.Id,acc.Id);
        DRT_PTRF_Association__c dpa = SwiftDataUtilityTest.createDPA(drt.Id,ptrf.Id);
        Mask_Layer__c maskLayer=SwiftDataUtilityTest.createMaskLayerDRT(ptrf);
        
       
        set<String> maskLayerSet1=DRTHandlerUtility.fetchLayerNos(mstList[0].Id,drt.Tech_Geo__c);
        system.assertNotEquals(maskLayerSet1.size(), 0);
        String maskLayerNo = (new list<string>(maskLayerSet1))[0];
        system.assertEquals(maskLayerNo,'');
        set<String> maskLayerSet2=DRTHandlerUtility.fetchLayerNos(mstList[0].Id,'');
        system.assertEquals(maskLayerSet2.size(), 2);
        test.stopTest();
    }
     /*
   This test method tests the below functionality of the class DRTHandlerUtility
   fetchMaskRevROMCode()
 */ 
    @isTest
    public static void fetchMaskRevROMCodeTest(){
        // comment-out, refactor with testSetup method setup()
		// SwiftDataUtilityTest.customSystemData();
        
        Account acc = SwiftDataUtilityTest.createTestAccount();
        List<Mask_Set_Title__c> mstList=SwiftDataUtilityTest.maskSetTitleList(1);
        
        List<DRT__c> drtList=SwiftDataUtilityTest.createDRTList1(1,mstList[0],acc.Id);
        DRT__C drt = drtList[0];
        
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
        DRT_PTRF_Association__c dpa = SwiftDataUtilityTest.createDPA(drt.Id,ptrf.Id);
        Chip_Detail__c chip_Detail=SwiftDataUtilityTest.createChipDetailDRT(ptrf.Id);
        Mask_Layer__c maskLayer=SwiftDataUtilityTest.createMaskLayerDRT(ptrf);
        
        list<list<String>> lstMaskRevROMCode = DRTHandlerUtility.fetchMaskRevROMCode(mstList[0].Id,maskLayer.Mask_Layer_Number__c,drt.Tech_Geo__c);
        system.assertNotEquals(lstMaskRevROMCode.size(),0);
        DRTHandlerUtility.fetchMaskRevROMCode(mstList[0].Id,maskLayer.Mask_Layer_Number__c,'');
        system.assertNotEquals(lstMaskRevROMCode.size(),0);        
        DRTHandlerUtility.MaskRevROMCodeWrapper mWrapper = new DRTHandlerUtility.MaskRevROMCodeWrapper('test','test');
        test.stopTest();
    }
    
       /*
   This test method tests the below functionality of the class DRTHandlerUtility
   fetchChipDetails()
   fetchMaskLayers
   fetchUniqueMaskLayers
 */ 
    
    @isTest
    public static void fetchMaskLayersTest(){
        //load the custom settings
        // comment-out, refactor with testSetup method setup()
		// SwiftDataUtilityTest.customSystemData();
        
        Account acc = SwiftDataUtilityTest.createTestAccount();
        List<Mask_Set_Title__c> mstList=SwiftDataUtilityTest.maskSetTitleList(1);
        
        List<DRT__c> drtList=SwiftDataUtilityTest.createDRTList1(1,mstList[0],acc.Id);
        DRT__c drt = drtList[0];
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
        DRT_PTRF_Association__c dpa = SwiftDataUtilityTest.createDPA(drt.Id,ptrf.Id);
        Chip_Detail__c chip_Detail=SwiftDataUtilityTest.createChipDetailDRT(ptrf.Id);
        Mask_Layer__c maskLayer=SwiftDataUtilityTest.createMaskLayerDRT(ptrf);
        
       
        list<Chip_Detail__c> cdList=DRTHandlerUtility.fetchChipDetails(mstList[0].Id,drt.Tech_Geo__c);
        system.assertEquals(cdList.size(),0);
        
        list<Mask_Layer__c> maskLayerList = DRTHandlerUtility.fetchMaskLayers(mstList[0].Id,drt.Type__c,drt.Tech_Geo__c);
        system.assertEquals(maskLayerList.size(),0);
        
        
        DRT__c drt1=drtList[0];
        drt1.Type__c = 'frame';
        update drt1;
        
        ptrf.Frame_Tapeout__c=true;
        ptrf.Prime_Tapeout__c=false;
        update ptrf;
        
        list<Mask_Layer__c> maskLayerList1 = DRTHandlerUtility.fetchMaskLayers(mstList[0].Id,drt1.Type__c,drt.Tech_Geo__c);
        system.assertEquals(maskLayerList1.size(),0);
        
        list<Mask_Layer__c> uniqueMaskLayerList = DRTHandlerUtility.fetchUniqueMaskLayers(new list<Mask_Layer__c>{maskLayer});
        system.assertEquals(uniqueMaskLayerList.size(), 1);
        
        DRTHandlerUtility.MaskRevROMCodeWrapper mObject1 = new DRTHandlerUtility.MaskRevROMCodeWrapper('AZ','123');
        mObject1.htmlId = 'm-1-2';
        mObject1.colorClass = DRTHandlerUtility.alternateColorClass;
        
        DRTHandlerUtility.MaskRevROMCodeWrapper mObject2 = new DRTHandlerUtility.MaskRevROMCodeWrapper('','');
        
        test.stopTest();
    }
    
     /*
   This test method tests the below functionality of the class DRTHandlerUtility
   fetchChipLayerComboData()
 */ 
    @isTest
    public static void fetchChipLayerComboDataTest(){
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
        PTRF__c ptrf=SwiftDataUtilityTest.createPTRF_ForDRT(mstList[0].Id, testDevice.Id, acc.Id);
        Chip_Detail__c chip_Detail=SwiftDataUtilityTest.createChipDetailDRT(ptrf.Id);
        //List<Frame_DRT_Association__c> fdaList=SwiftDataUtilityTest.createFDA(drt);
        Mask_Layer__c maskLayer=SwiftDataUtilityTest.createMaskLayerDRT(ptrf);
        
        list<list<string>> chipLayerCombo = DRTHandlerUtility.fetchChipLayerComboData(chip_Detail.name,maskLayer.Mask_Layer_Number__c,mstList[0].Id,mstList[0].id,ptrf.Tech_Geo__c); 
        system.assertEquals(chipLayerCombo.size(),2);
        test.stopTest();
    }
    
   
}