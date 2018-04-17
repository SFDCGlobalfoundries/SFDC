/*
* @ Author :- SUHAS BARGI
* @ Description :- Template 2 - Reminder for: Release of DRC Report to Customer, scheduled batch to trigger the mail
* @ 
* @ template  2 - isReleaseToCustomer-false, status = open, workflowStatus-pending
* @ L4: DFM Review Report sent from Mantis AND in Stage “pending FAE” >2days. THEN IF Release Report pending for every 24hrs until closed
* @ Date :- 15 MARCH 2016
* @ Change History :-  
**/
global class DRCReleaseToCustEMailNotifiyBatch implements Database.Batchable<sObject> {

    global Database.QueryLocator start(Database.BatchableContext BC){  
        
        Date previousDate = date.Today().addDays(-2);
        
         return Database.getQueryLocator([SELECT Id,IsCustomerAcceptsRisk__c,Created_By_Shortname__c,Submitted_By_Shortname__c,Selected_AM__c,Selected_Customers__c,Waiver_Status__c,
                                                IsCustomerAgreeToFix__c,IsGfAcceptsRisk__c,Is_releasedToCustomer__c,Account_Manager_Approver1__c,Account_Manager_Approver2__c,Progressbar_staus__c,
                                                Account_Manager_Approver3__c,Account_Manager__c,Account_Name__c,Account_Short_Name__c,Account__c,Approval_Field_Engineer__c, Mask_Set_Title__c,Prime_Die__c,
                                                Created_Date__c,Customer_Full_Name__c,customer_Options__c,DFM_Service_DRCPLUS__c,DRC_Deck_Version__c,FAB__c,isAllPartyApproved__c,
                                                Prime_Die_Name__c,Top_Cell_Name__c,PTSR_Number__c,PTSR_Service_Type__c,PTSR_Status__c,Workflow_Status__c, DRB_Group_uIds__c, Name                                           
                                          FROM  Wavier_Collaborator__c 
                                          WHERE  LastModifiedDate <= : previousDate AND Is_releasedToCustomer__c=FALSE AND Waiver_Status__c='OPEN' AND Workflow_Status__c='Pending' AND Is_Sync_with_AIA__c=TRUE 
                                        ]);        
    }
    
    global void execute(Database.BatchableContext BC, List<Wavier_Collaborator__c> waiverList){
       
         if (waiverList<>NULL && !waiverList.isEmpty()){
            
            for (Wavier_Collaborator__c waiverRule : waiverList){
                
                if(waiverRule.PTSR_Service_Type__c.contains('DRC')){
                 
                 DRCEmailImplementation.drcReminderReleaseReportToCustomer(waiverRule);
                }else{  
                
                DFMEmailImplementation.DFM_Reminder_ReleaseofReport2Cust(waiverRule);
                }
            }
             
        }
       
    }
    
    
    
    global void finish(Database.BatchableContext BC){
        
    }
}