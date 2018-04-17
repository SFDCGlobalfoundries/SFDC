/*
    Author: Harsha Vardhan
    Company: Cognizant
    Project: DRC/DFM Application
    Description: This batch class is used to share the collaborator records with FabX_CollaboratorReader groups based on progressbar status.

    History: Harsha:10/1/16
**/ 
global class BatchFabgroupShare  implements Database.Batchable<sObject>{
    global String query;
    global Database.QueryLocator start(Database.BatchableContext BC){ 
        
        query= 'SELECT Id,IsCustomerAcceptsRisk__c,Created_By_Shortname__c,Submitted_By_Shortname__c,Selected_AM__c,Selected_Customers__c,Waiver_Status__c,IsCustomerAgreeToFix__c,IsGfAcceptsRisk__c,Is_releasedToCustomer__c,Account_Manager_Approver1__c,Account_Manager_Approver2__c,Account_Manager_Approver3__c,Account_Manager__c,Account_Name__c,Account_Short_Name__c,Account__c,Approval_Field_Engineer__c,Created_Date__c,Customer_Full_Name__c,customer_Options__c,DFM_Service_DRCPLUS__c,DRC_Deck_Version__c,FAB__c,isAllPartyApproved__c,Prime_Die_Name__c,PTSR_Number__c,PTSR_Service_Type__c,Progressbar_staus__c,PTSR_Status__c,Workflow_Status__c FROM Wavier_Collaborator__c WHERE Progressbar_staus__c=\'Pending for FAE\' ';      
        return Database.getQueryLocator(query);
        
    }
    
    global void execute(Database.BatchableContext BC,List<Wavier_Collaborator__c> WaiverList){
        String WaiverObjId = '';
        
        try{
        List<Wavier_Collaborator__c> WaiverListWithAccount = new List<Wavier_Collaborator__c>();
        Set<Id> Fab1users = DfmUtilityCls.getUsersFromPublicGroup('Fab1_CollaboratorReader')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('Fab1_CollaboratorReader').keySet():NULL;
        Set<Id> Fab7users = DfmUtilityCls.getUsersFromPublicGroup('Fab7_CollaboratorReader')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('Fab7_CollaboratorReader').keySet():NULL;
        Set<Id> Fab8users = DfmUtilityCls.getUsersFromPublicGroup('Fab8_CollaboratorReader')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('Fab8_CollaboratorReader').keySet():NULL;
        Set<Id> Fab10users = DfmUtilityCls.getUsersFromPublicGroup('Fab10_CollaboratorReader')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('Fab10_CollaboratorReader').keySet():NULL;
        
        for(Wavier_Collaborator__c WaiverObj : WaiverList){
            WaiverObjId = WaiverObj.ID;
            if(Fab1users<>NULL && !Fab1users.isEmpty()) {
                DfmUtilityCls.shareRecord(WaiverObj.Id,Fab1users,'Read');
            } 
            if(Fab7users<>NULL && !Fab7users.isEmpty()) {
                DfmUtilityCls.shareRecord(WaiverObj.Id,Fab7users,'Read');
            }
            if(Fab8users<>NULL && !Fab8users.isEmpty()) {
                DfmUtilityCls.shareRecord(WaiverObj.Id,Fab8users,'Read');
            }
            if(Fab10users<>NULL && !Fab10users.isEmpty()) {
                DfmUtilityCls.shareRecord(WaiverObj.Id,Fab10users,'Read');
                //system.debug('@result'+WaiverObjId);
       		 }
    		}
    	}catch(Exception e){
       GlobalUtility.logMessage('Debug', 'BatchFabgroupShare', 'execute()', WaiverObjId, 'Batch Fab group sharing', 'exception occured', 'payLoad','Other SFDC',e, 2300);
    }
    }
    global void finish(Database.BatchableContext BC){
        
    }
    
}