/*
* @ Author :- SUHAS BARGI
* @ Description :- Template 6: reminder mail, scheduled batch - At least one GF-Review-result = (“FDCC” OR “FDi”) for >2days. THEN IF Release Report pending for every 24hrs until closed
* @ Item8 Template – Notification of Foundry-to-risk open approval, FAE trigger foundry-to-risk approval AND open for <2d
* @ Date :- 15 MARCH 2016
* @ Change History :-  
**/
global class DRCFAENotifyToCustDiscussionBatch implements Database.Batchable<sObject> {

    global Database.QueryLocator start(Database.BatchableContext BC){ 
    	
    	Date previousDate = date.Today().addDays(-2);
    	
         return Database.getQueryLocator([SELECT Account_Manager_Approver__c,AIA_Is_Sync_Message__c,CreatedById,CreatedDate,Customer_Closing_Comment__c,Customer_Review_Request__c,
                                          Design_Rule_Name__c,Final_Stage__c,Final_Status__c,GF_Internal_Closing_Comment__c,GF_Review_Comment__c,GF_Review_Results__c,
                                          Hierarchial_Error_Count__c,Id,Image_Path__c,isAllPartyApproved__c,IsCustomerAcceptsRisk__c,Disagree__c,Old_Image_Path__c,Warning__c,RecallApprovalProcess__c,
                                          IsCustomerAgreeToFix__c,IsDeleted,IsGfAcceptsRisk__c,Is_Sync_with_AIA__c,LastModifiedDate,
                                          MantisId__c,Name,Number_of_Violation__c,RuleId_Txt__c,RuleId__c,Rule_Description__c,SelectedBox__c,
                                         Stage__c,SystemModstamp,Waiver_Collaborator__c,Waiver_Collaborator__r.PTSR_Service_Type__c FROM Waiver_Rule_List__c WHERE LastModifiedDate <= : previousDate AND
                                          (Stage__c = 'FCC' OR Stage__c = 'IFD' OR Stage__c = 'iFD' OR Stage__c = 'FD') AND (Waiver_Collaborator__r.PTSR_Status__c !='Closed' AND Waiver_Collaborator__r.Workflow_Status__c != 'Cancel')
                                            AND isAllPartyApproved__c = FALSE 
                                          AND IsCustomerAcceptsRisk__c = FALSE AND IsCustomerAgreeToFix__c = FALSE  
        								]);       
    }
    
    global void execute(Database.BatchableContext BC, List<Waiver_Rule_List__c> waiverRuleList){
   		//system.debug('Inside execute >>>>>>>>>> '+waiverRuleList.size());     
        
        //Set<Id> setOfWaiverCollaboratorIdsForTemplate6= new Set<Id>();
        Map<Id, Waiver_Rule_List__c > collaboratorsTemplate6 = new Map<Id, Waiver_Rule_List__c >();
        Map<Id, Waiver_Rule_List__c > collaboratorsTemplate7 = new Map<Id, Waiver_Rule_List__c >();
        Map<Id, Waiver_Rule_List__c > collaboratorsTemplate8 = new Map<Id, Waiver_Rule_List__c >();
        //Set<Id> setOfWaiverCollaboratorIdsForTemplate7= new Set<Id>();//DFM Enhancements
        Set<Id> setOfWaiverCollaboratorIdsForTemplate8= new Set<Id>();
        
         if (waiverRuleList<>NULL && !waiverRuleList.isEmpty()){
            
            for (Waiver_Rule_List__c waiverRule : waiverRuleList){
                if(!waiverRule.IsGfAcceptsRisk__c && !waiverRule.Disagree__c){//for template 6 when IsGfAcceptsRisk__c is false 
                    if(waiverRule.Waiver_Collaborator__r.PTSR_Service_Type__c.contains('DRC')){
                        //setOfWaiverCollaboratorIdsForTemplate6.add(waiverRule.Waiver_Collaborator__c);
                        collaboratorsTemplate6.put(waiverRule.Waiver_Collaborator__c, waiverRule);
                    }else{
                        //setOfWaiverCollaboratorIdsForTemplate7.add(waiverRule.Waiver_Collaborator__c);
                        collaboratorsTemplate7.put(waiverRule.Waiver_Collaborator__c, waiverRule);
                    }
                }else { // if IsGfAcceptsRisk__c and AllPartyApproval is false then send template 8 
                setOfWaiverCollaboratorIdsForTemplate8.add(waiverRule.Waiver_Collaborator__c);
                //collaboratorsTemplate8.put(waiverRule.Waiver_Collaborator__c, waiverRule); 
                }
            }
              // if(!collaboratorsTemplate6.isEmpty()){
            //     DRCEmailImplementation.drcNotAllDecisionMadebyCustomer(collaboratorsTemplate6); 
            // }
             //if(!collaboratorsTemplate7.isEmpty()){
            //     DFMEmailImplementation.NotificationofCustomerDecisionForReporting(collaboratorsTemplate7);
            // }
            
             for(Id collaboratorId : collaboratorsTemplate6.keySet()){
                 system.debug(' collaboratorsTemplate6.keySet() >>>>>>>>>> '+collaboratorId);  
                 DRCEmailImplementation.drcNotAllDecisionMadebyCust(collaboratorId); 
             }
            for(Id collaboratorId : setOfWaiverCollaboratorIdsForTemplate8){
                 DRCEmailImplementation.getDRCRuleListPendingApprovals(collaboratorId); 
             }
            for(Id collaboratorId : collaboratorsTemplate7.keySet()){
                 system.debug(' collaboratorsTemplate7.keySet() >>>>>>>>>> '+collaboratorId);  
                 DFMEmailImplementation.NotificationofCustomerDecisionForReport(collaboratorId);
            }
  				
        }
       
    } 
    
    
    
    global void finish(Database.BatchableContext BC){
        
    }
}