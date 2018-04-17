/*
    Author: Ariz Solito
    Description: Apex test class for the ErroCode
    History: 
        Asolito     21102014    - Code creation.
*/

@isTest(SeeAllData=true)
private class ErrorCodeTest {
    
    static testMethod void testClass(){
        
        //test 1 error code call
        ErrorCode.get('GDS_TRANSLATE_VALIDATION');        
    }
}