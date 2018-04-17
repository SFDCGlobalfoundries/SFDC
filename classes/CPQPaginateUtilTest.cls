/*
  Author: Anirban Roy
  Description: This is the test class for the CPQPaginateUtil class.
  History:
    ARoy        10272014    - code creation.                           
*/

@isTest(SeeAllData=false)
public class CPQPaginateUtilTest {
	
	static testMethod void cpqPaginationTest(){
		test.startTest();
		
		// Instantiate the util class
		CPQPaginateUtil pgUtil = new CPQPaginateUtil(10,20);
		
		// Instantiate the wrapper class
		CPQPaginateUtil.Pager pg = new CPQPaginateUtil.Pager(1,true); 
		
		// Increment the page number
		pgUtil.increment();
		
		// Decrement the page number
		pgUtil.decrement();
		
		test.stopTest();		
	}
	
}