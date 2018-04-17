/*
    Author: Win
    Created Date: Feb/25/2013 
    Description: Test class for SFDCConstants
    Test cases: 
    1. 
*/

@isTest
public class SFDCConstantsTest{

    static testMethod void doTest1(){
        test.startTest();
        System.assertEquals(SFDCConstants.IMPLEMENTATION_STAGE, 'Implementation');
        test.stopTest();

    }
}