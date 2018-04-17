/*------------------------------------------------------------  
Author:        Chyan Yee Goh
Company:       Salesforce.com
Description:   A global utility class for common functions
Test Class:    GlobalUtility_Test
History
<Date>      <Authors Name>     <Brief Description of Change>
------------------------------------------------------------*/

public without sharing class GlobalUtility {
    
    private static final string DEBUG='Debug';
    private static final string INFO='Info';
    private static final string ERROR='Error';
    private static final string WARNING='Warning';


    public static void logMessage(String logLevel, String sourceClass, String sourceFunction, String referenceId, String referenceInfo, String logMessage, String payLoad,string ApplicationName,Exception ex, long timeTaken) {
    /*------------------------------------------------------------
    Author:        Chyan Yee Goh
    Company:       Salesforce.com
    Description:   Overloaded Method to log a single record to the application log table
    Inputs:        logLevel - Debug, Error, Info, Warning
                   sourceClass - Originating trigger or utility class
                   sourceFunction - Method in class above that caused the message
                   referneceId - Process Identifier (e.g. Job Id)
                   referenceInfo - Process information
                   payLoad - Optional based on integration messages
                   ex - the standard exception object for errors
                   timeTaken - The time in milliseconds of the transaction

    History
    <Date>      <Authors Name>     <Brief Description of Change>
    ------------------------------------------------------------*/
               
        ApplicationLogWrapper msg = new ApplicationLogWrapper();
        
        msg.source = sourceClass;
        msg.logMessage = logMessage;
        msg.sourceFunction = sourceFunction;
        msg.referenceId = referenceId;
        msg.referenceInfo = referenceInfo;
        msg.payload = payLoad;
        msg.debugLevel = logLevel;
        msg.ex = ex;
        msg.Timer = timeTaken;
        msg.ApplicationName=ApplicationName;
        
        logMessage( msg );
        
    }    
    public static void logMessage(ApplicationLogWrapper appLog)
    {
    /*------------------------------------------------------------
    Author:        Chyan Yee Goh
    Company:       Salesforce.com
    Description:   Overloaded Method to log a single record to the application log table
    Inputs:        The application log wrapper object

    History
    <Date>      <Authors Name>     <Brief Description of Change>
    ------------------------------------------------------------*/
        
        List<ApplicationLogWrapper> appLogs = new List<ApplicationLogWrapper>();
        
        appLogs.add ( appLog );
        
        logMessage ( appLogs );

    }
    
    @future
    public static void logMessage_new(string source, string sourceFunction, string ApplicationName, string referenceId, string referenceInfo, string logMessage, string payload, string debugLevel)
    {
    /*------------------------------------------------------------
    Author:        Chyan Yee Goh
    Company:       Salesforce.com
    Description:   Overloaded Method to log a single record to the application log table
    Inputs:        The application log wrapper object

    History
    <Date>      <Authors Name>     <Brief Description of Change>
    ------------------------------------------------------------*/
        ApplicationLogWrapper appLog = new  ApplicationLogWrapper();
            appLog.source = source;
            appLog.sourceFunction = sourceFunction;
            appLog.ApplicationName = ApplicationName;
            appLog.referenceId = referenceId;
            appLog.referenceInfo = referenceInfo;
            appLog.logMessage = logMessage;
            appLog.payload = payload;
            appLog.debugLevel = debugLevel;
            
        List<ApplicationLogWrapper> appLogs = new List<ApplicationLogWrapper>();
        
        appLogs.add ( appLog );
        
        logMessage ( appLogs );

    }
    
    public static void logMessage(List<ApplicationLogWrapper> appLogs)
    {
    /*------------------------------------------------------------
    Author:        Chyan Yee Goh
    Company:       Salesforce.com
    Description:   Overloaded Method to log multiple records to the application log table
                   Called directly from trigger context to prevent governor limit exceptions
    Inputs:        The application log wrapper object

    History
    <Date>      <Authors Name>     <Brief Description of Change>
    ------------------------------------------------------------*/
        List<Application_Log__c> insertAppLogs = new List<Application_Log__c>();
        
        for(ApplicationLogWrapper appLog : appLogs){
        
            Application_Log__c log = new Application_Log__c();
            
            log.Source__c = appLog.source;
            log.Source_Function__c = appLog.sourceFunction;
            log.Reference_Id__c = appLog.referenceId;
            log.Reference_Info__c = appLog.referenceInfo;
            log.Message__c = appLog.logMessage;
            log.Integration_Payload__c = appLog.payload;
            
            if(appLog.ex != null){
                log.Stack_Trace__c = appLog.ex.getStackTraceString();
                log.Message__c = applog.ex.getMessage();
            }
            
            log.Debug_Level__c = appLog.debugLevel;
            log.Log_Code__c = appLog.logCode;
            log.Timer__c = appLog.timer;
            log.Application_Name__c = appLog.ApplicationName;
            
            boolean validInsert = false;
            
            //optimisation - move these to a global constant
            if(appLog.debugLevel == DEBUG && System_Log_Setting__c.getInstance().Debug__c){
                validInsert = true;
            }
            if(appLog.debugLevel == ERROR && System_Log_Setting__c.getInstance().Error__c){
                validInsert = true;
            }
            if(appLog.debugLevel == INFO && System_Log_Setting__c.getInstance().Info__c){
                validInsert = true;
            }
            if(appLog.debugLevel == WARNING && System_Log_Setting__c.getInstance().Warning__c){
                validInsert = true;
            }      
            if(validInsert){
                insertAppLogs.add(log);
            }
        }
        
        if ( insertAppLogs.size() != 0 ){
            insert insertAppLogs;
        }
        
    }
}