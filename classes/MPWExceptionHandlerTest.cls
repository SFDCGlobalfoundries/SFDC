/**
* Author: Anil Kumar
* Company: JK Technosoft
* Project: MPW
* Description: Test Class for MPWExceptionHandler
* History:
*    Anil Kumar 13/09/2016 - Created
**/
@isTest
private class MPWExceptionHandlerTest {
    static testMethod void MPWExceptionHandlerTest1 () {
        MPWExceptionHandler oClass = new MPWExceptionHandler();
        try {
            Integer i = 1/0;
        }catch(Exception ex) {
            String strSource = 'MPWExceptionHandler';
            String strSourceFunction = 'exceptionHandler'; 
            String strReferenceId = '';
            String strReferenceInfo = 'Exception Handler';
            MPWExceptionHandler.exceptionHandler(ex, strSource, strSourceFunction, strReferenceId, strReferenceInfo);
        }
    }
}