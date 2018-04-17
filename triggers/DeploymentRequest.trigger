/*
    Author: Nino Bustillos
    Description: Validates that owner cannot approve the request.
    History:
        04272014    Nbustillos    - code creation.
*/
trigger DeploymentRequest on Deployment_Request__c (after update) {

    // Check if user does not have skip trigger logic.
    if(!IntegrationUserUtil.isSkipTrigger()){
        List<Deployment_Request__c> lstDRRevStatUpdated = new List<Deployment_Request__c>();
        
        // iterate to all DR
        for(Deployment_Request__c oDR : trigger.new){
            Deployment_Request__c oOldDR = trigger.oldMap.get(oDR.Id);
        
            // check if review status was changed, one of the approval statuses updated by Approval Process and creator
            // updating the record.
            System.debug('OLD Review Status: ' + oOldDR.RM_Review_Status__c);
            System.debug('NEW Review Status: ' + oDR.RM_Review_Status__c);
            System.debug('CreatedById: ' + oDR.CreatedById);
            System.debug('LastModifiedById: ' + oDR.LastModifiedById);
            if((oOldDR.RM_Review_Status__c!=oDR.RM_Review_Status__c) && 
               (oDR.RM_Review_Status__c =='SDM Approval' || oDR.RM_Review_Status__c=='Approved' || oDR.RM_Review_Status__c=='Rejected') && 
               (oDR.CreatedById==oDR.LastModifiedById)){
                
                // add error message to prevent update.
                oDR.addError('Deployment Request creator cannot approve/reject the record.');
            }
        }
    }
}