public class ApplicationLogWrapper {
/*------------------------------------------------------------  
Author:        Chyan Yee Goh
Company:       Salesforce.com
Description:   A wrapper class for application log messages
Test Class:   GlobalUtility_Test
History
<Date>      <Authors Name>     <Brief Description of Change>
------------------------------------------------------------*/

    public string source {get;set;}
    public string sourceFunction {get;set;}
    public string referenceId {get;set;}
    public string referenceInfo{get;set;}
    public string logMessage {get;set;}
    public string payload {get;set;}
    public Exception ex {get;set;}
    public string debugLevel {get;set;}
    public string logCode {get;set;}
    public long timer {get;set;}
    public string ApplicationName{get;set;}
    
}