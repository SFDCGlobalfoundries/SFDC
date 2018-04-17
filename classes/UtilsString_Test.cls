/*
    Author: Ariz Solito
    Description: Apex test class for UtilsString
    History: 
    Asolito      23/04/2013    - Apex code created
*/
@isTest(SeeAllData=false)
public with sharing class UtilsString_Test {
	
	static testMethod void testClass(){
		//String test
		String str = 'abcbc';		
		System.assert(UtilsString.isNotBlank(str));
		
		//Generic object test
		Object obj = null;
		System.assert(!UtilsString.isNotBlank(obj));
	}
}