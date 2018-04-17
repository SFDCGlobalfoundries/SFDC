/**
* Author: Anil Kumar Reddy L
* Company: JK Technosoft
* Project: ICC
* Description: Test Class for ICC_ExceptionHandler
* History
*    Anil Kumar Reddy L 23/05/2017 - Created
**/
@isTest
private class ICC_ExceptionHandler_Test {
    static testMethod void exceptionHandler () {
        //ICC_ExceptionHandler oClass = new ICC_ExceptionHandler();
        try {
            Integer i = 1/0;
        }catch(Exception ex) {
            String strSource = 'ICC_ExceptionHandler';
            String strSourceFunction = 'exceptionHandler'; 
            String strReferenceId = '';
            String strReferenceInfo = 'Exception Handler';
            ICC_ExceptionHandler.exceptionHandler(ex, strSource, strSourceFunction, strReferenceId, strReferenceInfo);
        }
    }
}