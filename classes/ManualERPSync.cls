/*
    Author: Ariz Solito
    Description: Apex class for Integeration to AIA
    History: 
    Asolito      22/04/2013    - Apex code created
*/
public with sharing class ManualERPSync {
    private String accountId;
    private String logId;

    public ManualERPSync(){        
        this.accountId = ApexPages.currentPage().getParameters().get('id');
        this.logId = ApexPages.currentPage().getParameters().get('logid');
    }
    
    //Method will call AIA to send account details to ERP
    public PageReference init(){      
        for(Account currRec: [SELECT id FROM Account WHERE id = :this.accountId]){
            String result = AccountDetailChange.send2(currRec); 
                        
            for(IntegrationLog__c i: [SELECT erp_status__c FROM IntegrationLog__c WHERE id = :this.logId]){
                if(result == 'SUCCESS'){
                    ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.CONFIRM,'Record resend to ERP successfully.');                    
                    i.resend_to_ERP__c = true;
                    ApexPages.addMessage(msg);
                } else {
                    ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.ERROR,'Error resending the record to ERP. Please contact the administrator.');
                    i.resend_to_ERP__c = false;                
                    ApexPages.addMessage(msg);
                }
                i.erp_status__c = result;
                update i;
            }
        }
        return null;       
    }       
}