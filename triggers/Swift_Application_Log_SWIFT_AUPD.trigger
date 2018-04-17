/*
SWIFT TEAM is honoured to provide a way to retry failure in SFDC!!!

Test class is Swift_Application_Log_SWIFT_AUPD_TEST
*/
trigger Swift_Application_Log_SWIFT_AUPD on SWIFT_Application_Log__c (before update) {  
    
    //this trigger will process 1 record at a time
    //no bulkify        
    for(SWIFT_Application_Log__c s: trigger.new) 
    {
        if(trigger.oldmap.get(s.id).Retry_Status__c != s.Retry_Status__c && s.Retry_Status__c == 'In Queue' && s.Is_Auto_Retry__c && null != s.Apex_Component_Name__c) 
        {
            MRSPLMDRWRetryController.invokeRetry(s);
            s.Retry_Status__c = 'Completed'; 
        }
    }
}