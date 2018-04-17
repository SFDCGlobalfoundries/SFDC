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
private class DRTHandlerUtilityTest5 {

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
   revisedDRTFunctionality()
 */ 
    
    @isTest
    public static void revisedDRTFunctionalityTest(){
        // comment-out, refactor with testSetup method setup()
		// SwiftDataUtilityTest.customSystemData();
        
        Account acc = SwiftDataUtilityTest.createTestAccount();
        List<Mask_Set_Title__c> mstList=SwiftDataUtilityTest.maskSetTitleList(1);
        DRT__c drt = new DRT__C( Name='MYMST_PRIME_DRT_001.001', Customer_Name__c=acc.id,
                              Status__c='Active',
                              Type__c='PRIME',
                              Tech_Geo__c = '0.02UM',
                              Mask_Set_Title__c = mstList[0].id);
        
        DRT__c revisedDrt = new DRT__C( Name='MYMST_PRIME_DRT_001.002', Customer_Name__c=acc.id,
                              Status__c='Active',
                              Type__c='PRIME',
                              Tech_Geo__c = '0.02UM',
                              Mask_Set_Title__c = mstList[0].id);
                              
        insert new list<DRT__c>{drt,revisedDrt};                              
        
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
        Chip_Detail__c chip_Detail=SwiftDataUtilityTest.createChipDetailDRT(ptrf.Id);
        Mask_Layer__c maskLayer=SwiftDataUtilityTest.createMaskLayerDRT(ptrf);
        DRT_PTRF_Association__c dpa = SwiftDataUtilityTest.createDPA(drt.Id,ptrf.Id);
        DRTHandlerUtility.revisedDRTFunctionality(revisedDrt.name,drt.Id);
        system.assertEquals(revisedDrt.Status__c,'Active');
        test.stopTest();    
    }
    
   /*
   This test method tests the below functionality of the class DRTHandlerUtility
   closeDRTonPTRFclose()
 */ 
    @isTest
    public static void closeDRTonPTRFcloseTest(){
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
        PTRF__c ptrf=SwiftDataUtilityTest.createPTRF_DRT(mstList[0].Id, testDevice.Id);
        Chip_Detail__c chip_Detail=SwiftDataUtilityTest.createChipDetailDRT(ptrf.Id);
        List<Frame_DRT_Association__c> fdaList=SwiftDataUtilityTest.createFDA(drt);
        Mask_Layer__c maskLayer=SwiftDataUtilityTest.createMaskLayerDRT(ptrf);
        DRT_PTRF_Association__c dpa = SwiftDataUtilityTest.createDPA(drt.Id,ptrf.Id);
        
        Set<String> var=new Set<String>();
        var.add(ptrf.Id);
        DRTHandlerUtility.closeDRTonPTRFclose(var);
        system.assertEquals(drt.Status__c,'Active');
        test.stopTest();
    }
    
    
    /*
   This test method tests the below functionality of the class DRTHandlerUtility
   insertDRTDetails()
 */ 
    @isTest
    public static void insertDRTDetailsTest(){
        // comment-out, refactor with testSetup method setup()
		// SwiftDataUtilityTest.customSystemData();
        
        Account acc = SwiftDataUtilityTest.createTestAccount();
        List<Mask_Set_Title__c> mstList=SwiftDataUtilityTest.maskSetTitleList(1);
        
        DRT__c drt=new DRT__C(Name='test',
                              Status__c='Active',
                              Type__c='PRIME',
                              Mask_Set_Title__c = mstList[0].id);
        
        drt.Customer_Name__c=acc.Id;
        drt.Name='MYMST_PRIME_DRT_035.001';
        
        test.startTest();
        Database.saveresult sr = DRTHandlerUtility.insertDRTDetails(drt);
        system.assertEquals(sr.isSuccess(),true);
        test.stopTest();
    }
    
     /*
   This test method tests the below functionality of the class DRTHandlerUtility
   insertDRT()
 */ 
    @isTest
    public static void insertDRTTest(){
        // comment-out, refactor with testSetup method setup()
		// SwiftDataUtilityTest.customSystemData();
        Account acc = SwiftDataUtilityTest.createTestAccount();
        List<Mask_Set_Title__c> mstList=SwiftDataUtilityTest.maskSetTitleList(1);
        DRT__c drt=new DRT__C(Name='test',
                              Status__c='Active',
                              Type__c='PRIME',
                              Mask_Set_Title__c = mstList[0].id);
        
        drt.Customer_Name__c=acc.Id;
        drt.Name='MYMST_PRIME_DRT_035.001';
        test.startTest();
        PRIME_DRT_Layer_Association__c pdla=new PRIME_DRT_Layer_Association__c(Retrofit_Mask_Rev__c='test',
                                  Retrofit_ROM_Code__c='test',Retrofit_Tech_Geo__c='test');
        List<PRIME_DRT_Layer_Association__c> pdlaList=new  List<PRIME_DRT_Layer_Association__c>{pdla};
        
        PRIME_DRT_Chip_Association__c pdca=new PRIME_DRT_Chip_Association__c(name='test',
                                              Mask_Set_Title__c=mstList[0].id);
        List<PRIME_DRT_Chip_Association__c> pdcaList=new List<PRIME_DRT_Chip_Association__c>{pdca};
        
        
        PRIME_DRT_Chip_Layer_Summary__c pdcla=new PRIME_DRT_Chip_Layer_Summary__c(Chip__c=pdcaList[0].id,Layer__c=pdlaList[0].id,
                                              Mask_Layer_Rev__c='test',ROM_Code__c='test',
                                              IsActive__c=true,Logical_Operation_Type__c='test',
                                              Logical_Operation__c='test');
        List<PRIME_DRT_Chip_Layer_Summary__c> pdcls=new List<PRIME_DRT_Chip_Layer_Summary__c>{pdcla};
          
        
        Id drtId = DRTHandlerUtility.insertDRT(drt,pdlaList,pdcaList,pdcls);
        Drt__c drtObj = [select id,status__c from drt__c where id = :drtId];
        system.assertEquals(drtObj.Status__c, 'Active');
        test.stopTest();
    }
    
 
	
	
}