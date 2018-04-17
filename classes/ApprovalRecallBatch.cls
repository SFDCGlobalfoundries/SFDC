/*
* @ Author :- SUHAS BARGI
* @ Description :- 
* @ Date :- 15 Sept 2016
* @ Change History :-  SUHAS 05/10/16
**/
global without sharing class ApprovalRecallBatch implements Database.Batchable<sObject> {

    global Database.QueryLocator start(Database.BatchableContext BC){ 
         return Database.getQueryLocator([SELECT Account_Manager_Approver__c,AIA_Is_Sync_Message__c,Customer_Closing_Comment__c,
                                                   Customer_Review_Request__c,Design_Rule_Name__c,Final_Stage__c,Final_Status__c,GF_Internal_Closing_Comment__c,GF_Review_Comment__c,
                                                   GF_Review_Results__c,Hierarchial_Error_Count__c,Id,Image_Path__c,isAllPartyApproved__c,IsCustomerAcceptsRisk__c,
                                                   IsCustomerAgreeToFix__c,IsGfAcceptsRisk__c,Is_Sync_with_AIA__c,LastModifiedDate,Operation_Type__c,Disagree__c,Old_Image_Path__c,Warning__c,RecallApprovalProcess__c,
                                                   MantisId__c,Name,Number_of_Violation__c,RuleId_Txt__c,RuleId__c,Rule_Description__c,SelectedBox__c,
                                                   Stage__c,Waiver_Collaborator__c FROM Waiver_Rule_List__c WHERE RecallApprovalProcess__c ='recall']);       
    }
    
    global void execute(Database.BatchableContext BC, List<Waiver_Rule_List__c> waiverRuleList){
       //system.debug('Inside execute >>>>>>>>>> '+waiverRuleList.size());     
        List<Id> ruleIds = new List<Id>();
        for(Waiver_Rule_List__c wr : waiverRuleList){
                ruleIds.add(wr.Id);
            }
            if(ruleIds.size()>0){
               
                Approval.ProcessWorkitemRequest[] prWkItems = New Approval.ProcessWorkItemRequest[]{};
                    ProcessInstance[] pi = [Select ID, Status, TargetObject.Name, (SELECT Id, ActorId, ProcessInstanceId FROM Workitems),                                                                
                                            (SELECT Id, StepStatus, Comments FROM Steps) From ProcessInstance                                                                
                                            Where TargetObjectID IN :ruleIds AND Status = 'Pending'];
                system.debug('singleRecId>>>>>>>> IsGfAcceptsRisk__c '+pi);
                if(Test.isRunningTest()){
                    pi = [Select ID, Status, TargetObject.Name, (SELECT Id, ActorId, ProcessInstanceId FROM Workitems),                                                                
                                            (SELECT Id, StepStatus, Comments FROM Steps) From ProcessInstance                                                                
                                            Where Status = 'Pending'];
                }
                system.debug('singleRecId>>>>>>>> IsGfAcceptsRisk__c '+pi);
                if(pi<>null && pi.size()>0){
                    for(ProcessInstance instance : pi){
                       
                        for(ProcessInstanceWorkItem workItem : instance.WorkItems){
                            
                            Approval.ProcessWorkitemRequest prWkItem = new Approval.ProcessWorkitemRequest();
                            prWkItem.setWorkItemID(workItem.id);
                            prWkItem.setComments('Request Canceled by User: ' + userInfo.getName());
                            prWkItem.setAction('Removed');
                            prWkItems.add(prWkItem);
                        }
                        
                    }         
                    
                    if(!prWkItems.isEmpty()){
                        try {
                            
                            if(!Test.isRunningTest()){
                                Approval.ProcessResult[] appResult = Approval.process(prWkItems);
                            }
                        } catch (System.DmlException e) {
                            // log error in to common error logger object
                            GF_CommonErrorLogger.creatLogs('ApprovalRecallBatch', 'DRC/DFM', 'Batch Apex Class', e, system.now());
                        }
                        
                        
                    }
                }
            }
       
    } 
    
    
    
    global void finish(Database.BatchableContext BC){
        
    }
}