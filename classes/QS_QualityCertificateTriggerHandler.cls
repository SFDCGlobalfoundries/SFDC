/**
 * Author: Vijay Mahajan
 * Company: Cognizant Technology Solutions Asia Pacific Pte Ltd
 * Description: It is a QS_QualityCertificateTriggerHandler class. It contains methods for each trigger events like before insert, 
                update etc which invoke actual business logic.
 *             
 * History:
 * <Vijay>     04032014 - class created
 * <Vijay> 	   28032014 - As Quality Certificate sharing is handled on page level. Removed the sharing business logic	
 */
public with sharing class QS_QualityCertificateTriggerHandler{
    
    private Boolean isExecuting = false;
    private Integer size = 0;
    public static Boolean isExecuted = false;
    
    /**
     * This is parametrized constructor
     *
     * @param   isExecuting     boolean variable to check trigger execution context
     * @param   size            size of list processing in trigger execution context
     */      
    public QS_QualityCertificateTriggerHandler(Boolean isExecuting, Integer size){
        this.isExecuting = isExecuting;
        this.size = size;
    }
    
    /**
     * This method accepts trigger context variables for on after update event and call the actual business logic
     *
     * @param   oldQualityCerts         list of old Quality Certificate records
     * @param   updatedQualityCerts     list of updated Quality Certificate records
     * @param   oldQualityCertMap       map of old Quality Certificate records
     * @param   updatedQualityCertMap   map of updated Quality Certificate records
     */ 
    public void OnAfterUpdate(Quality_Certificate__c[] oldQualityCerts, Quality_Certificate__c[] updatedQualityCerts, 
                              Map<ID, Quality_Certificate__c>  oldQualityCertMap, Map<ID, Quality_Certificate__c>  updatedQualityCertMap ){
       Set<Id> qualityCertIdSet = new Set<Id>();
       System.debug('Is Trigger Executed---------'+isExecuted); 
       if(!isExecuted){                     
           for(Quality_Certificate__c qualityCertificate:updatedQualityCerts){
                System.debug('QualityCertificate======='+qualityCertificate);
                System.debug('oldQualityCertMap.get(qualityCertificate.Id)======='+oldQualityCertMap.get(qualityCertificate.Id));
                if(qualityCertificate.Stage__c == 'Approved' && oldQualityCertMap.get(qualityCertificate.Id).Stage__c != 'Approved'){
                    System.debug('Approved Quality Certificate======='+qualityCertificate.Stage__c);
                    qualityCertIdSet.add(qualityCertificate.Id);
                }
           }
           if(qualityCertIdSet != null && !qualityCertIdSet.isEmpty()){
               Map<Id,Quality_Certificate__c> qualityCertMap = getQualityCertificates(qualityCertIdSet);
               System.debug('qualityCertMap -----'+qualityCertMap);
               publishQualityDocuments(updatedQualityCerts, qualityCertMap);
           }
           isExecuted = true;
       }
    }
    
    /**
     * This method accepts Quality Certificate Ids and retrieves Quality Certificate map along with Quality Certificate attachments and associated customer details.
     *
     * @param   QualityCertIdSet    Set of Quality Certificate Ids
     * @return  qualityCertMap      Map of Quality Certificate
     */
    private Map<Id, Quality_Certificate__c> getQualityCertificates(Set<Id> QualityCertIdSet){
        Map<Id,Quality_Certificate__c> qualityCertMap =new Map<Id,Quality_Certificate__c>([SELECT     Id,Name, Stage__c,
                                                                                            (SELECT   Id,Name,Ready_to_Publish__c 
                                                                                             FROM     UploadQC__r 
                                                                                             WHERE    Ready_To_Publish__c = false) 
                                                                                           FROM       Quality_Certificate__c 
                                                                                           WHERE      Id IN :QualityCertIdSet]);
        return qualityCertMap;
    }
    
    /**
     * This method publish the Quality Certificate Attachments based Quality Certificate status
     *
     * @param   qualityCerts        list of Quality Certificate records
     * @param   qualityCertMap      Map of Quality Certificate
     */
    private void publishQualityDocuments(List<Quality_Certificate__c> qualityCerts, 
                                            Map<ID, Quality_Certificate__c> qualityCertMap){
        List<UploadQC__c> updateUploadQCList = new List<UploadQC__c>();
        
        if(qualityCerts != null && !qualityCerts.isEmpty()){
            for(Quality_Certificate__c qualityCert : qualityCerts){
                if(qualityCert.Stage__c == 'Approved'){
                    List<UploadQC__c> uploadQCList = qualityCertMap.get(qualityCert.Id).UploadQc__r;
                    if(uploadQCList != null && !uploadQCList.isEmpty()){
                        System.debug('uploadQCList========='+uploadQCList);
                        for(UploadQC__c uploadQc : uploadQCList){
                             uploadQc.Ready_To_Publish__c=true;  
                             updateUploadQCList.add(uploadQc);                
                        }
                    }
                }
            }
        }
        if(updateUploadQCList != null && !updateUploadQCList.isEmpty()){
            Database.update(updateUploadQCList);
        }
    }
    
    
    
    
    
    
}