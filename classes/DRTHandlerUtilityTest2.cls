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
private class DRTHandlerUtilityTest2 {

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
   handleErrorOnPLM_TECN()
*/  
	@isTest
	public static void handleErrorOnPLM_TECNTest(){
	    // comment-out, refactor with testSetup method setup()
		// SwiftDataUtilityTest.customSystemData();
	    Account acc = SwiftDataUtilityTest.createTestAccount();
	    Exception ex;
	    try{
	        acc.Id='123';
	        update acc;
	    }catch(Exception e){
	        ex=e;   
	    }
	    DRTHandlerUtility.handleErrorOnPLM_TECN(ex,'Account',new Set<String>{'Account'},'Test Mail');   
	    
	}

	/*
	   This test method tests the below functionality of the class DRTHandlerUtility
	   handleErrorOnSyncDRTPackageSync()
	*/ 
	@isTest
	public static void handleErrorOnSyncDRTPackageSyncTest(){
	     // comment-out, refactor with testSetup method setup()
		// SwiftDataUtilityTest.customSystemData();
	    Account acc = SwiftDataUtilityTest.createTestAccount();
	    Exception ex;
	    try{
	        Integer i =1/0;
	    }catch(Exception e){
	        ex=e;   
	    }
	    DRTHandlerUtility.handleErrorOnSyncDRTPackageSync(ex,new list<String>{acc.Id},'Test Mail');  
	    
	}   
	
	/*
	   This test method tests the below functionality of the class DRTHandlerUtility
	   handleErrorOnMRSCADResponseService()
	*/ 
	@isTest
	public static void handleErrorOnMRSCADResponseServiceTest(){
	    // comment-out, refactor with testSetup method setup()
		// SwiftDataUtilityTest.customSystemData();
	    Account acc = SwiftDataUtilityTest.createTestAccount();
	    Exception ex;
	    try{
	        acc.Id='123';
	        update acc;
	    }catch(Exception e){
	        ex=e;   
	    }
	    DRTHandlerUtility.handleErrorOnMRSCADResponseService(ex,new set<String>{'Account'},'Test Mail');    
	    
	}   
	
	/*
	   This test method tests the below functionality of the class DRTHandlerUtility
	   handleErrorOnMRSCADResponseServiceDRT()
	*/ 
	@isTest
	public static void handleErrorOnMRSCADResponseServiceDRTTest(){
	    // comment-out, refactor with testSetup method setup()
		// SwiftDataUtilityTest.customSystemData();
	    Account acc = SwiftDataUtilityTest.createTestAccount();
	    Exception ex;
	    try{
	        acc.Id='123';
	        update acc;
	    }catch(Exception e){
	        ex=e;   
	    }
	    DRTHandlerUtility.handleErrorOnMRSCADResponseServiceDRT(ex,new set<String>{'Account'},'Test Mail'); 
	    
	}   
	
	
	
	
	

}