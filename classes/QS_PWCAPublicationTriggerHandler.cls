/**
 * Author: Vijay Mahajan
 * Company: Cognizant Technology Solutions Asia Pacific Pte Ltd
 * Description: It is a QS_PWCAPublicationTriggerHandler class. It contains methods for each trigger events like before insert, 
 				update etc which invoke actual business logic.
 *             
 * History:
 * <Vijay>     04032014 - class created
 *  <Vijay>    28032014 - As PWCA Publication sharing is handled on page level. Removed the sharing business logic
 */
public with sharing class QS_PWCAPublicationTriggerHandler{
    
    private Boolean isExecuting = false;
    private Integer size = 0;
    public static Boolean isExecuted = false;
    
    /**
     * This is parametrized constructor
     *
     * @param	isExecuting		boolean variable to check trigger execution context
     * @param	size			size of list processing in trigger execution context
     */    
    public QS_PWCAPublicationTriggerHandler(Boolean isExecuting, Integer size){
        this.isExecuting = isExecuting;
        this.size = size;
    }
    
    /**
     * This method accepts trigger context variables for on after update event and call the actual business logic
     *
     * @param	oldPWCAPublications			list of old PWCA Publication records
     * @param	updatedPWCAPublications		list of updated PWCA Publication records
     * @param	oldPWCAPublicationMap		map of old PWCA Publication records
     * @param	updatedPWCAPublicationMap	map of updated PWCA Publication records
     */ 
    public void OnAfterUpdate(PWCA_publication__c[] oldPWCAPublications, PWCA_publication__c[] updatedPWCAPublications, 
                              Map<ID, PWCA_publication__c>  oldPWCAPublicationMap, Map<ID, PWCA_publication__c>  updatedPWCAPublicationMap ){
       Set<Id> pwcaPublicationIdSet = new Set<Id>();
       System.debug('Is Trigger Executed---------'+isExecuted); 
       if(!isExecuted){                     
           for(PWCA_publication__c pwcaPublication:updatedPWCAPublications){
                if(pwcaPublication.ready_to_Publish__c && !oldPWCAPublicationMap.get(pwcaPublication.Id).ready_to_Publish__c){
                    System.debug('Ready to publish PWCA Publication======='+pwcaPublication.ready_to_Publish__c);
                    pwcaPublicationIdSet.add(pwcaPublication.Id);
                }
           }
           try{
	           if(pwcaPublicationIdSet != null && !pwcaPublicationIdSet.isEmpty()){
	               Map<Id,PWCA_publication__c> pwcaPublicationMap = getPWCAPublicationificates(pwcaPublicationIdSet);
	               System.debug('pwcaPublicationMap -----'+pwcaPublicationMap);
	               publishPWCAPublicationDocuments(updatedPWCAPublications, pwcaPublicationMap);
	           }
           }catch(Exception e){
           		System.debug('Exception in onafterupdate event on PWCA Publication object'+e.getMessage());
           } 
           isExecuted = true;
       }
    }
    
    /**
     * This method accepts PWCA Publication Ids and retrieves PWCA Publication map along with PWCA attachments and associated customer details.
     *
     * @param	pwcaPublicationIdSet	Set of PWCA Publication Ids
     * @return	pwcaPublicationMap		Map of PWCA Publication
     */
    private Map<Id, PWCA_publication__c> getPWCAPublicationificates(Set<Id> pwcaPublicationIdSet){
        Map<Id,PWCA_publication__c> pwcaPublicationMap = null;
        if(pwcaPublicationIdSet != null && !pwcaPublicationIdSet.isEmpty()){
	        pwcaPublicationMap = new Map<Id,PWCA_publication__c>([SELECT     Id,Name ,Ready_to_Publish__c,
						                                         (SELECT    Id,Name,Ready_to_Publish__c 
						                                          FROM      PWCA_Attachments__r 
						                                          WHERE     ready_to_Publish__c = false) 
						                                         FROM       PWCA_publication__c 
						                                         WHERE      Id IN :pwcaPublicationIdSet]);
        }
        return pwcaPublicationMap;
    }
    
    /**
     * This method publish the PWCA Attachments based PWCA Publication status
     *
     * @param	pwcaPublications		list of PWCA Publication records
     * @param	pwcaPublicationMap		Map of PWCA Publication
     */
    private void publishPWCAPublicationDocuments(List<PWCA_publication__c> pwcaPublications, 
                                            Map<ID, PWCA_publication__c> pwcaPublicationMap){
        List<PWCA_Attachments__c > updatePWCAPublicationList = new List<PWCA_Attachments__c >();
        if(pwcaPublications != null && !pwcaPublications.isEmpty()){
            for(PWCA_publication__c pwcaPublication : pwcaPublications){
                if(pwcaPublication.Ready_to_Publish__c){
                    List<PWCA_Attachments__c> pwcaAttachmentList = pwcaPublicationMap.get(pwcaPublication.Id).PWCA_Attachments__r;
                    System.debug('pwcaPublicationList========='+pwcaAttachmentList);
                    if(pwcaAttachmentList != null && !pwcaAttachmentList.isEmpty()){
                        System.debug('pwcaPublicationList========='+pwcaAttachmentList);
                        for(PWCA_Attachments__c pwcaAttachment : pwcaAttachmentList){
                             pwcaAttachment.Ready_To_Publish__c=true;  
                             updatePWCAPublicationList.add(pwcaAttachment);                
                        }
                    }
                }
            }
        }
        if(updatePWCAPublicationList != null && !updatePWCAPublicationList.isEmpty()){
            Database.update(updatePWCAPublicationList, false);
        }
    }
}