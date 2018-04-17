/*
* @ Author :- SUHAS BARGI
* @ Description :- Template 6: reminder mail, scheduled batch - At least one GF-Review-result = (“FDCC” OR “FDi”) for >2days. THEN IF Release Report pending for every 24hrs until closed
* @ Item8 Template – Notification of Foundry-to-risk open approval, FAE trigger foundry-to-risk approval AND open for <2d
* @ Date :- 15 MAY 2017
* @ Change History :-  
**/

global class DWC_WaiverRuleListEditBatch implements Database.Batchable<sObject> {
    
    private List<id> ruleListsForUpdate = new List<id>();
    
    public DWC_WaiverRuleListEditBatch(List<id> ruleLists) {
        ruleListsForUpdate = ruleLists;
    }
    global Database.QueryLocator start(Database.BatchableContext BC){ 
         return Database.getQueryLocator([SELECT Account_Manager_Approver__c,AIA_Is_Sync_Message__c,Customer_Closing_Comment__c,
                                                   Customer_Review_Request__c,Design_Rule_Name__c,Final_Stage__c,Final_Status__c,GF_Internal_Closing_Comment__c,GF_Review_Comment__c,
                                                   GF_Review_Results__c,Hierarchial_Error_Count__c,Id,Image_Path__c,isAllPartyApproved__c,IsCustomerAcceptsRisk__c,
                                                   IsCustomerAgreeToFix__c,IsGfAcceptsRisk__c,Is_Sync_with_AIA__c,LastModifiedDate,RecallApprovalProcess__c,Disagree__c,Old_Image_Path__c,Warning__c,
                                                   MantisId__c,Name,Number_of_Violation__c,RuleId_Txt__c,RuleId__c,Rule_Description__c,SelectedBox__c,
                                                   Stage__c,Waiver_Collaborator__c FROM Waiver_Rule_List__c WHERE 
                                          (Stage__c = 'FCC' OR Stage__c = 'IFD' OR Stage__c = 'FD') AND Id  IN :ruleListsForUpdate ]);       
    }
    
    global void execute(Database.BatchableContext BC, List<Waiver_Rule_List__c> waiverRuleList){
        
        system.debug('rule list details'+waiverRuleList.size());
        system.debug('rule list details'+waiverRuleList);
        List<Waiver_Rule_List__c> modifiedWaiverRuleList = new List<Waiver_Rule_List__c>();
         if (waiverRuleList<>NULL && !waiverRuleList.isEmpty()){            
            for (Waiver_Rule_List__c w : waiverRuleList){
                if(w.Stage__c=='FCC' || w.Stage__c=='iFD' || w.Stage__c=='IFD' ){
                    w.Final_Stage__c='OPEN';
                    w.Revert_Rule__c=false; 
                    w.SelectedBox__c=false;
                    w.isIntermediateSave__c=false;
                    w.IsGfAcceptsRisk__c=false;
                    w.IsCustomerAgreeToFix__c=false;
                    w.IsCustomerAcceptsRisk__c=false;
                    w.AcceptRisk__c=false;
                    w.Disagree__c=false;
                    w.isAllPartyApproved__c=false;
                    w.Customer_Closing_Comment__c='';
                    w.GF_Internal_Closing_Comment__c='';
                    
                }
                modifiedWaiverRuleList.add(w);
            }
            update modifiedWaiverRuleList;
          
        }
       
    } 
    
    
    
    global void finish(Database.BatchableContext BC){
        
    }
}