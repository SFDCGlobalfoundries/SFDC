@isTest
public class DRTHandlerUtilityTestAuditTrail {
	
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
   AuditTrail()
 */ 
    @isTest
    public static void fetchDRTAuditTrailTest(){
    	// replaced by testSetup method
        //SwiftDataUtilityTest.customSystemData();
        
        Account acc = SwiftDataUtilityTest.createTestAccount();
        List<Mask_Set_Title__c> mstList=SwiftDataUtilityTest.maskSetTitleList(1);
        
        List<DRT__c> drtList=SwiftDataUtilityTest.createDRTList(2,mstList[0]);
        
        DRT__c drt=drtList[0];
        drt.Customer_Name__c=acc.Id;
        drt.Name='MYMST_PRIME_DRT_035.001';
        update drt;
        
        system.assertEquals(drt.Name,'MYMST_PRIME_DRT_035.001');
        
        DRT__c drt2=new DRT__c();
        drt2.Copied_From__c=drt.Id;
        
        DRT__c drt3=new DRT__c();
        drt2.Old_Rev_DRT__c=drt.Id;
        
        List<PRIME_DRT_Layer_Association__c> pdlaList=SwiftDataUtilityTest.createPDLA(drt.Id);
        
        pdlaList[0].name='10';
        pdlaList[0].isCreatedLater__c = true;
        pdlaList[1].name='20';
        pdlaList[1].IsSoftDeleted__c = true;
        
        update pdlaList;
        
        List<PRIME_DRT_Chip_Association__c> pdcaList=SwiftDataUtilityTest.createPDCA(drt.Id,mstList[0].Id);
        pdcaList[0].name='tt123';
        pdcaList[0].isCreatedLater__c = true;
        
        pdcaList[1].name='tt456';
        pdcaList[1].IsSoftDeleted__c = true;
        
        update pdcaList;
        
        list<DRT__History> lstDRTHistory = DRTHandlerUtility.fetchDRTHistory(drt.Id);
        list<PRIME_DRT_Chip_Association__History> lstPrimeDRTChipAssocHistory = DRTHandlerUtility.fetchPrimeDRTChipAssocHistory(drt.Id);
        list<PRIME_DRT_Layer_Association__History> lstPrimeDRTLayerAssocHistory = DRTHandlerUtility.fetchPrimeDRTLayerAssocHistory(drt.Id);
        
        DRT__History drt_his1 = new DRT__History();
        drt_his1.Field = 'created';
        drt_his1.Parent = drt2; 
        
        DRT__History drt_his2 = new DRT__History();
        drt_his2.Field = 'created';
        drt_his2.Parent = drt3; 
        
        DRT__History drt_his4 = new DRT__History();
        drt_his4.Field = 'name';
        drt_his4.Parent = drt; 
        
        lstDRTHistory.clear();
        lstDRTHistory.add(drt_his1);
        lstDRTHistory.add(drt_his2);
        lstDRTHistory.add(drt_his4);
        
        PRIME_DRT_Chip_Association__History pdca_history=new PRIME_DRT_Chip_Association__History();
        pdca_history.Field ='created';
        pdca_history.ParentId = pdcaList[0].Id;
        pdca_history.Parent=pdcaList[0];
        
        PRIME_DRT_Chip_Association__History pdca_history2=new PRIME_DRT_Chip_Association__History();
        pdca_history2.Field ='IsSoftDeleted__c';
        pdca_history2.ParentId = pdcaList[1].Id;
        pdca_history2.Parent=pdcaList[1];
        
        PRIME_DRT_Chip_Association__History pdca_history3=new PRIME_DRT_Chip_Association__History();
        pdca_history3.Field ='Name';
        pdca_history3.ParentId = pdcaList[1].Id;
        pdca_history3.Parent=pdcaList[1];
        
        PRIME_DRT_Layer_Association__History pdla_history1 = new PRIME_DRT_Layer_Association__History();
        pdla_history1.Field='created';
        pdla_history1.Parent=pdlaList[0];
        
        PRIME_DRT_Layer_Association__History pdla_history2 = new PRIME_DRT_Layer_Association__History();
        pdla_history2.Field='IsSoftDeleted__c';
        pdla_history2.Parent=pdlaList[1];
        
        PRIME_DRT_Layer_Association__History pdla_history3 = new PRIME_DRT_Layer_Association__History();
        pdla_history3.Field='Name';
        pdla_history3.Parent=pdlaList[1];
        
        PRIME_DRT_Layer_Association__History pdla_history4 = new PRIME_DRT_Layer_Association__History();
        pdla_history4.Field='Retrofit_Mask_Rev__c';
        pdla_history4.Parent=pdlaList[1];
        
        PRIME_DRT_Layer_Association__History pdla_history5 = new PRIME_DRT_Layer_Association__History();
        pdla_history5.Field='Retrofit_ROM_Code__c';
        pdla_history5.Parent=pdlaList[1];
        
        test.startTest();
        DRTHandlerUtility.fetchDRTAuditTrail(drt,lstDRTHistory,new list<PRIME_DRT_Chip_Association__History>{pdca_history},new list<PRIME_DRT_Layer_Association__History>{pdla_history1});
        DRTHandlerUtility.fetchDRTAuditTrail(drt,lstDRTHistory,new list<PRIME_DRT_Chip_Association__History>{pdca_history2},new list<PRIME_DRT_Layer_Association__History>{pdla_history2});
        DRTHandlerUtility.fetchDRTAuditTrail(drt,lstDRTHistory,new list<PRIME_DRT_Chip_Association__History>{pdca_history3},new list<PRIME_DRT_Layer_Association__History>{pdla_history3});
        DRTHandlerUtility.fetchDRTAuditTrail(drt,lstDRTHistory,new list<PRIME_DRT_Chip_Association__History>{pdca_history3},new list<PRIME_DRT_Layer_Association__History>{pdla_history4});
        DRTHandlerUtility.fetchDRTAuditTrail(drt,lstDRTHistory,new list<PRIME_DRT_Chip_Association__History>{pdca_history3},new list<PRIME_DRT_Layer_Association__History>{pdla_history5});
        // jun17
        DRTHandlerUtility.AuditTrail objAuditTrail = new DRTHandlerUtility.AuditTrail(string.valueOf(system.today()),'test','test','test','test','test');
        test.stopTest();
    }
    
    
    @isTest
    public static void testDummyMethod(){
    	Integer a = new DRTHandlerUtility().mthdDummy();
    	//System.assertEquals(1, a);
    }
    
    @isTest
    public static void testDummyMethod2(){
        Integer a = new DRTHandlerUtility().mthdDummy2();
        //System.assertEquals(1, a);
    }
}