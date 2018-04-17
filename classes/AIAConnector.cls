/*
    Author: Ariz Solito
    Description: Apex class for Integeration to AIA
    History: 
    Asolito      17/04/2013    - Apex code created
*/
public class AIAConnector {
    public static final String AIAENDPOINT = getConnectionParam('AIA_TO_ERP_ENDPOINT');
    public static final String CERTIFICATE =  getConnectionParam('SELF_SIGNED_CERTIFICATE');
    
    //Method will be used by VF
    public static String sendAccount(String XMLPayload){
        //flag will stop the trigger from calling the callout again
        AccountDetailChange.hasRun = true;          
        try {
            HttpRequest req = new HttpRequest();            
            req.setEndpoint(AIAENDPOINT);
            req.setMethod('POST');
            req.setHeader('Content-Type','text/xml; charset=utf-8');
            req.setBody(XMLPayload);
            req.setTimeout(20000);            
        
            if(!Test.isRunningTest()){
                req.setClientCertificateName(CERTIFICATE);
                
                Http http = new Http();
                HTTPResponse res = http.send(req);
                if(res.getStatus() == 'OK'){
                    return 'SUCCESS';   
                }               
            } else {
                //Fire exception in test class
                throw new TestClassException ('throw error!');
            }
            return 'ERROR';                     
                                                                                    
        } catch (Exception e){
            System.debug(e);
            return 'ERROR'; 
        }       
    }
     
    //Method will be used by triggers
    @Future (callout=true)
    public static void sendAccount(String accountId, String XMLPayload){
        //flag will stop the trigger from calling the callout again
        AccountDetailChange.hasRun = true;          
        try {
            HttpRequest req = new HttpRequest();
            req.setEndpoint(AIAENDPOINT);
            req.setMethod('POST');
            req.setHeader('Content-Type','text/xml; charset=utf-8');
            req.setBody(XMLPayload);
            req.setTimeout(20000);
            
         
            String result;
            if(!Test.isRunningTest()){
                req.setClientCertificateName(CERTIFICATE);
                
                Http http = new Http();
                HTTPResponse res = http.send(req);
            system.debug('Cert='+req);
                System.debug(res);
                System.debug(res.getBody());
                
                result = res.getStatus();
            } else {
                result = 'OK';
            }
            
            for(Account a :[SELECT erp_status_message__c FROM Account WHERE id = :accountId]){
                if(result == 'OK'){
                    a.erp_status_message__c = 'SUCCESS';
                } else {
                    a.erp_status_message__c = 'ERROR';
                }
                update a;
                                                
                logStatus(a.id,'Account',a.erp_status_message__c);
            }  
            
            //Fire exception in test class
            if(Test.isRunningTest()){
                throw new TestClassException ('throw error!');
            }                     
                
        } catch (Exception e){
            System.debug(e);
            for(Account a :[SELECT erp_status_message__c FROM Account WHERE id = :accountId]){
                a.erp_status_message__c = 'ERROR';
                update a;
                
                logStatus(a.id,'Account','ERROR');
            }   
        }       
    }
    
    //Check if the callout has been made more than once 
    //in a span of 5 seconds for the same record
    public static Boolean checkMultipleFiring(String recordId){
        Datetime dupDatetimeCheck = datetime.now().addSeconds(-5);
        for(IntegrationLog__c i : [SELECT integrationID__c 
                                     FROM IntegrationLog__c 
                                     WHERE createdDate >= :dupDatetimeCheck 
                                     AND createdDate <= :Datetime.now()
                                     AND sfdc_row_id__c = :recordId]){
            return true;
        }
        return false;
    }
    
    //Create new Integration log record after callout
    public static void logStatus(String recordId, String objectType, String status){                        
        if(!checkMultipleFiring(recordId)){
            IntegrationLog__c log = new IntegrationLog__c();
            log.object__c = objectType;
            log.sfdc_row_id__c = recordId; 
            log.erp_status__c = status;       
            log.integrationID__c = recordId+'-'+datetime.now();      
            insert log; 
        }
    }
    
    //Method will get the transformed value of the country
    public static String getConnectionParam(String key){
        Environment_Variable__c setting = Environment_Variable__c.getInstance(key);
        //we need to check for a null value on the field, the setting object is always not null.
        if(setting <> null){
            if(setting.value__c <> null){
                return setting.value__c;
            }
        }  
        return key;     
    }
}