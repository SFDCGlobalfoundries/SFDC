/**
* Author: Anil Kumar
* Company: JK Technosoft
* Project: MPW
* Description: Used for Exception Handler
* History:
*    Anil Kumar 29/08/2016 - Created
**/
public without sharing class MPWExceptionHandler {
    
    public MPWExceptionHandler(){
    
    }
    
    /*
    * Description : Method to retrieve Manufacturing Lot Assignment based on logged in user.
    */
    public static void exceptionHandler(Exception ex, String strSource, String strSourceFunction, String strReferenceId, String strReferenceInfo) {
        ApplicationLogWrapper objALW = new ApplicationLogWrapper();
        objALW.source = strSource;
        objALW.sourceFunction = strSourceFunction;
        objALW.ApplicationName = 'MPW Reservation';
        objALW.referenceId = strReferenceId;
        objALW.referenceInfo = strReferenceInfo;
        objALW.logMessage = 'Error Message=' + ex.getMessage() + ' At Line Number=' + ex.getLineNumber() + ' Stack Trace=' + ex.getStackTraceString();
        objALW.debugLevel = 'Error';
        objALW.logCode = ex.getTypeName();
        objALW.ex = ex.getCause();
        GlobalUtility.logMessage(objALW);
    }
}