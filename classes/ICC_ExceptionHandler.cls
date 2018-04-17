/**
* Author: Anil Kumar Reddy L
* Company: JK Technosoft
* Project: ICC
* Description: Used for Exception Handler
* History:
*    Anil Kumar Reddy L 12/05/2017 - Created
**/
public without sharing class ICC_ExceptionHandler {
    
    public ICC_ExceptionHandler(){
    
    }
    
    /*
    * Description : Method to retrieve Manufacturing Lot Assignment based on logged in user.
    */
    public static void exceptionHandler(Exception ex, String strSource, String strSourceFunction, String strReferenceId, String strReferenceInfo) {
        ApplicationLogWrapper objALW = new ApplicationLogWrapper();
        objALW.source = strSource;
        objALW.sourceFunction = strSourceFunction;
        objALW.ApplicationName = 'ICC';
        objALW.referenceId = strReferenceId;
        objALW.referenceInfo = strReferenceInfo;
        objALW.logMessage = 'Error Message=' + ex.getMessage() + ' At Line Number=' + ex.getLineNumber() + ' Stack Trace=' + ex.getStackTraceString();
        objALW.debugLevel = 'Error';
        objALW.logCode = ex.getTypeName();
        objALW.ex = ex.getCause();
        GlobalUtility.logMessage(objALW);
    }
}