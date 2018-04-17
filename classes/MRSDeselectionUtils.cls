/*
SWGP-882: [PTRF WS] PTRF Layer Chip Deselection
Test class is:
- MRSDeselectionServiceTest
*/
public class MRSDeselectionUtils {
    
    public class NotificationResponse {
        public String transactionStatus {get;set;}
        public String transactionErrorMessage {get;set;}
        public String messageId {get;set;}
        public String ptrfNumber {get;set;}
        public List<LayerChipResponse> layerChipList {get;set;}
        public List<PTRFMaskLayerResponse> ptrfMaskLayerList {get;set;}
        public List<PTRFChipResponse> ptrfChipList {get;set;}
    }
    
    public class LayerChipResponse {
        public String status {get;set;}
        public String errorMessage {get;set;}
        public Integer no {get;set;}
        public String sfdcId {get;set;}
        public String layerNumber {get;set;}
        public String revision {get;set;}
        public String chipName {get;set;}
        public String romCode {get;set;}
    }
    
    public class PTRFMaskLayerResponse {
        public String status {get;set;}
        public String errorMessage {get;set;}
        public Integer no {get;set;}
        public String layerNumber {get;set;}
        public String revision {get;set;}
        public String romCode {get;set;}
    }
    
    public class PTRFChipResponse {
        public String status {get;set;}
        public String errorMessage {get;set;}
        public Integer no {get;set;}
        public String chipName {get;set;}
        public String chipType {get;set;}
    }
    
    public static SWIFT_Application_Log__c logUnhandledException(Exception e, String wsMsg, String msgId, String className, String methodName, String ptrfNumber, String errorMsg){
        
        if(wsMsg.length() > 32000) wsMsg   = wsMsg.subString(0,32000);
        
        SWIFT_Application_Log__c log    = new SWIFT_Application_Log__c(
            Debug_Level__c              = 'ERROR',     
            Apex_Component_Name__c      = className,     
            Method__c                   = methodName,
            Integration_Payload__c      = wsMsg,     
            Error_Message__c            = errorMsg,     
            Stack_Trace__c              = e.getStackTraceString(),
            Message_ID__c               = msgId + ' | ' + ptrfNumber
        );

        if(e != null && e.getMessage().containsIgnoreCase('unable to obtain exclusive access')) {
            log.Is_Auto_Retry__c = true;
            log.Retry_Status__c = 'New';
        }
        
        insert log; 
        return log;
    }
    
    public static SWIFT_Application_Log__c logRequestResponse(String request, String response, String errorMsg, String msgId, String className, String methodName, String ptrfNumber){
        
        if(request.length() > 32000)    request  = request.subString(0,32000);
        if(response.length() > 32000)   response = response.subString(0,32000);
        
        SWIFT_Application_Log__c log    = new SWIFT_Application_Log__c(
            Debug_Level__c              = 'DEBUG', 
            Apex_Component_Name__c      = className     , 
            Method__c                   = methodName,    
            Integration_Payload__c      = request, 
            Stack_Trace__c              = response, 
            Error_Message__c            = errorMsg,
            Message_ID__c               = msgId + ' | ' + ptrfNumber
        );
        
        insert log; 
        return log;
    }
}