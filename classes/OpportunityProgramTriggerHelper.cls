/*************************************************************************************************************************************************************
@ Class:          OpportunityProgramTriggerHelper
@ Version:        1.0
@ Author:         Pradosh Samal (pradosh.samal@globalfoundries.com)
@ Purpose:        Helper class which consist of logics used in Opportunity Program Triggers.
--------------------------------------------------------------------------------------------------------------------------------------------------------------
@ Change history: 07.02.2016 / Pradosh Samal / Created the class.
          
**************************************************************************************************************************************************************/
Public Class OpportunityProgramTriggerHelper{
    
    /*Global Variables*/
    public       Map<Id,Opportunity_Program__c>                  triggerOldMap          { get; set; }
    public       Map<Id,Opportunity_Program__c>                  triggerNewMap          { get; set; }
    
    
    /*********************************************************************************************************************************************************
    @ Constructor:    OpportunityProgramTriggerHelper
    @ Version:        1.0
    @ Author:         Pradosh Samal (pradosh.samal@globalfoundries.com)
    @ Purpose:        Initialises the class for controller instance.
    **********************************************************************************************************************************************************/     
    public OpportunityProgramTriggerHelper(){      
        
        triggerOldMap = ((Map<Id,Opportunity_Program__c>)Trigger.oldMap);
        triggerNewMap = ((Map<Id,Opportunity_Program__c>)Trigger.newMap);
    }
    
    /*********************************************************************************************************************************************************
    @ Method:         createDefaultOppIssue()
    @ Version:        1.0
    @ Author:         Pradosh Samal (pradosh.samal@globalfoundries.com)
    @ Purpose:        This Method is used to create default Milstone Opportunity Issues.
    **********************************************************************************************************************************************************/

    public void createDefaultOppIssue(){
        
        Set<Id> opportunityProgramIdSet = new Set<Id>();
        
        for(Opportunity_Program__c oppProgram : (List<Opportunity_Program__c>) Trigger.New){
        
            opportunityProgramIdSet.add(oppProgram.Id);
        }
        
        createDefaultOppIssue(opportunityProgramIdSet);
    }
    
     /*********************************************************************************************************************************************************
    @ Method:         createDefaultOppIssue(Set<Id> opportunityProgramIdSet)
    @ Version:        1.0
    @ Author:         Pradosh Samal (pradosh.samal@globalfoundries.com)
    @ Purpose:        This future method is used to create default Milstone Opportunity Issues.
    **********************************************************************************************************************************************************/
    
    @future
    public static void createDefaultOppIssue(Set<Id> opportunityProgramIdSet){
        
        Set<Id> opportunityIdSet = new Set<Id>();
        Map<Id, Id> optyOptyProgramIdMap = new Map<Id, Id>();
        
        for(Opportunity_Program__c  opportunityProgram : [SELECT Id, Opportunity__c FROM Opportunity_Program__c WHERE Id IN :opportunityProgramIdSet]){
            
            if(opportunityProgram.Opportunity__c != NULL){
                
                opportunityIdSet.add(opportunityProgram.Opportunity__c);
                optyOptyProgramIdMap.put(opportunityProgram.Opportunity__c, opportunityProgram.Id);
            }
        }
        
        Map<Id, Opportunity> opportunityMap = new Map<Id, Opportunity>([SELECT Id, OwnerId, CloseDate, X1st_Product_TO_Date__c, Primary_Opportunity_FAE__c FROM Opportunity WHERE Id IN :opportunityIdSet]);
        
        List<Device_Gap__c> defaultOppIssueList = new List<Device_Gap__c>();
        Device_Gap__c tempOppIssue;
        
        for ( Id optyId : opportunityMap.keySet() ){
            
            if(opportunityMap.get(optyId).CloseDate != NULL){
                
                tempOppIssue = new Device_Gap__c();
                tempOppIssue.Opportunity__c = optyId;
                
                if(optyOptyProgramIdMap.get(optyId) != NULL){
                    
                    tempOppIssue.Opportunity_Program__c = optyOptyProgramIdMap.get(optyId);
                }
                
                tempOppIssue.Gap_Type__c = 'Milestone';
                tempOppIssue.Gap_Sub_Type__c = 'Close Date';
                tempOppIssue.Select_Engagement_Step__c = 'B. DWIN Pre-Product Definition Plan & Resourcing (Schedule for achieving DWIN, Benchmarking)';
                tempOppIssue.Area__c = 'Milestone';
                tempOppIssue.Issue_Comments__c = 'Close Date';
                tempOppIssue.Select_Status__c = 'M - Milestone';
                tempOppIssue.Improve_Prob__c = 0;
                tempOppIssue.Improve_Prob_P__c = 0;
                tempOppIssue.Action_to_Close_Issue__c = '<< Design Win Close Date >>';
                tempOppIssue.Solution_Owner__c = opportunityMap.get(optyId).OwnerId;
                tempOppIssue.Action_Close_Date__c = opportunityMap.get(optyId).CloseDate;
                tempOppIssue.Need_by_Date__c = opportunityMap.get(optyId).CloseDate;
                
                defaultOppIssueList.add(tempOppIssue);
            }
            
            if(opportunityMap.get(optyId).X1st_Product_TO_Date__c != NULL){
                
                tempOppIssue = new Device_Gap__c();
                tempOppIssue.Opportunity__c = optyId;
                
                if(optyOptyProgramIdMap.get(optyId) != NULL){
                    
                    tempOppIssue.Opportunity_Program__c = optyOptyProgramIdMap.get(optyId);
                }
                
                tempOppIssue.Gap_Type__c = 'Milestone';
                tempOppIssue.Gap_Sub_Type__c = '1st Product TO';
                tempOppIssue.Select_Engagement_Step__c = 'B. DWIN Pre-Product Definition Plan & Resourcing (Schedule for achieving DWIN, Benchmarking)';
                tempOppIssue.Area__c = 'Milestone';
                tempOppIssue.Issue_Comments__c = '1st Prod TO';
                tempOppIssue.Select_Status__c = 'M - Milestone';
                tempOppIssue.Improve_Prob__c = 0;
                tempOppIssue.Improve_Prob_P__c = 0;
                tempOppIssue.Action_to_Close_Issue__c = '<< 1st Product TO Date >>';
                
                if(opportunityMap.get(optyId).Primary_Opportunity_FAE__c != NULL){
                    
                    tempOppIssue.Solution_Owner__c = opportunityMap.get(optyId).Primary_Opportunity_FAE__c;
                }
                
                tempOppIssue.Action_Close_Date__c = opportunityMap.get(optyId).X1st_Product_TO_Date__c;
                tempOppIssue.Need_by_Date__c = opportunityMap.get(optyId).X1st_Product_TO_Date__c;
                
                defaultOppIssueList.add(tempOppIssue);
            }
        }
        
        if(defaultOppIssueList.size() > 0){
                
            insert defaultOppIssueList;
        }
    }
}