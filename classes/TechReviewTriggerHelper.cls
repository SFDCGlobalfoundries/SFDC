/**
@Author < Varsha Tomar >
@name < TechReviewTriggerHelper >
@CreateDate < 11/21/2016 >
@Description < Helper class for TechReviewTrigger >
@Version <1.1>
@Modified By: Arijit
*/
public class TechReviewTriggerHelper 
{  
    // method invoked on after insert event
    // method to update option stage when Tech Review is created
    public void updateOptionStageOnInsert() 
    {
        // list of option ids related to Tech Review
        List<Id> optionIds = new List<Id>();
        Id foundryRecTypeId = Schema.SObjectType.Tech_Review_Summary__c.getRecordTypeInfosByName().get('Foundry').getRecordTypeId();                     
        //SP4: Arijit - On Creation Of Tech Review Record if Condition Satisfy the Move Stage to Design Execution
        Set<Id> approvedToRtmOptionIds = new Set<Id>();
        for(Tech_Review_Summary__c tr : (List<Tech_Review_Summary__c>)Trigger.new) 
        {
            if(String.valueOf(tr.RecordTypeId) == String.valueOf(foundryRecTypeId)) 
            {                             
                if(tr.Tech_Review_Outcome_Status__c != null &&  tr.Meeting_Date__c != null && tr.Meeting_Result__c != null) //Arijit: Criteria change to move Option Stage to Design Execution (SP3 error)
                {
                    approvedToRtmOptionIds.add(tr.Option__c);
                }
            }
        }       
        // query options which are in 'Reconciliation' stage
        Map<Id, Customer_Requirement__c> optionsMap = new Map<Id, Customer_Requirement__c>(
                                    [select id from Customer_Requirement__c where id in :approvedToRtmOptionIds and
                                                Option_Stage__c = 'Reconciliation']);
        
        // clear option id list
        approvedToRtmOptionIds.clear();
        // add option ids whose stage is 'Reconciliation'
        approvedToRtmOptionIds.addAll(optionsMap.keySet());
        
        BnP_OptionUtility ctrl = new BnP_OptionUtility();
        // call generic method to update option stage
        if(approvedToRtmOptionIds != null && approvedToRtmOptionIds.size() > 0) 
        {
            optionIds.addAll(approvedToRtmOptionIds);
            ctrl.updateOptionStages(optionIds, 'Design Execution');
        }
        
    }
    
    // method to update option stage when Tech Review is updated
    public void updateOptionStageOnUpdate() {
        updateOptionStageToPrototypeFulfilment();
        updateOptionStageToDesignExecution();
    }
    
    // method to update option stage when Tech Review is updated
    public void updateOptionStageToDesignExecution() 
    {
        Id foundryRecTypeId = Schema.SObjectType.Tech_Review_Summary__c.getRecordTypeInfosByName().get('Foundry').getRecordTypeId();
        
        Set<Id> approvedToRtmOptionIds = new Set<Id>();
        for(Tech_Review_Summary__c tr : (List<Tech_Review_Summary__c>)Trigger.new) 
        {
            if(String.valueOf(tr.RecordTypeId) == String.valueOf(foundryRecTypeId)) 
            {
                Tech_Review_Summary__c techRevOld = (Tech_Review_Summary__c)System.trigger.oldMap.get(tr.id);               
                if(tr.Tech_Review_Outcome_Status__c != null &&  tr.Meeting_Date__c != null && tr.Meeting_Result__c != null) //Arijit: Criteria change to move Option Stage to Design Execution (SP3 error)
                {
                    approvedToRtmOptionIds.add(tr.Option__c);
                }
            }
        }
        
        // query options which are in 'Bid and Quote' stage
        Map<Id, Customer_Requirement__c> optionsMap = new Map<Id, Customer_Requirement__c>(
                                    [select id from Customer_Requirement__c where id in :approvedToRtmOptionIds and
                                                Option_Stage__c = 'Reconciliation']);
        
        // clear option id list
        approvedToRtmOptionIds.clear();
        // add option ids whose stage is 'Bid and Quote'
        approvedToRtmOptionIds.addAll(optionsMap.keySet());
        
        List<Id> optionIds = new List<Id>();
        BnP_OptionUtility ctrl = new BnP_OptionUtility();
        // call generic method to update option stage
        
        if(approvedToRtmOptionIds != null && approvedToRtmOptionIds.size() > 0) {
            optionIds.addAll(approvedToRtmOptionIds);
            ctrl.updateOptionStages(optionIds, 'Design Execution');
        }
    }
    
    // method to update option stage when Tech Review is updated
    public void updateOptionStageToPrototypeFulfilment() 
    {
        Id foundryRecTypeId = Schema.SObjectType.Tech_Review_Summary__c.getRecordTypeInfosByName().get('Foundry').getRecordTypeId();
        
        Set<Id> rtmDateOptionIds = new Set<Id>();
        for(Tech_Review_Summary__c tr : (List<Tech_Review_Summary__c>)Trigger.new) 
        {
            if(String.valueOf(tr.RecordTypeId) == String.valueOf(foundryRecTypeId)) 
            {
                Tech_Review_Summary__c techRevOld = (Tech_Review_Summary__c)System.trigger.oldMap.get(tr.id);
                //if((techRevOld.RIT_outlook__c == null && tr.RIT_outlook__c != null) || (techRevOld.RTM_outlook__c == null && tr.RTM_outlook__c != null)) //Arijit:15/03/2017  (SP-3 Changes)
                if(tr.RIT_outlook__c != null && tr.RTM_outlook__c != null && tr.Approval_to_proceed_to_RTM__c) //Arijit: Criteria change to move Option Stage to Prototype Fulfilment 
                {
                    rtmDateOptionIds.add(tr.Option__c);
                }
            }
        }
        
        // query options which are in 'Bid and Quote' stage
        Map<Id, Customer_Requirement__c> optionsMap = new Map<Id, Customer_Requirement__c>(
                                    [select id from Customer_Requirement__c where id in :rtmDateOptionIds and
                                (Option_Stage__c = 'Reconciliation' or Option_Stage__c = 'Design Execution')]);
        
        // clear option id list
        rtmDateOptionIds.clear();
        // add option ids whose stage is 'Bid and Quote'
        rtmDateOptionIds.addAll(optionsMap.keySet());
        
        List<Id> optionIds = new List<Id>();
        BnP_OptionUtility ctrl = new BnP_OptionUtility();
        // call generic method to update option stage
        
        
        if(rtmDateOptionIds != null && rtmDateOptionIds.size() > 0) 
        {
            optionIds.addAll(rtmDateOptionIds);
            ctrl.updateOptionStages(optionIds, 'Prototype Fulfillment');
        }
    }
    
    public void updateRTMReadyDateOnOption(){
        Map<Id,Tech_Review_Summary__c> triggerOldMap = ((Map<Id,Tech_Review_Summary__c>)Trigger.oldMap);
        Customer_Requirement__c optn;
        List<Customer_Requirement__c> optnList = new List<Customer_Requirement__c>();
        
        Id foundryRecTypeId = Schema.SObjectType.Tech_Review_Summary__c.getRecordTypeInfosByName().get('Foundry').getRecordTypeId();
        
        try{
            for(Tech_Review_Summary__c tr : (List<Tech_Review_Summary__c>)Trigger.new){               
                if(String.valueOf(tr.RecordTypeId) == String.valueOf(foundryRecTypeId)){                
                    if(tr.Option_RTM_Ready__c != null){                    
                        if(triggerOldMap != null){                            
                            if(tr.Option_RTM_Ready__c != triggerOldMap.get(tr.id).Option_RTM_Ready__c){                           
                                optn = new Customer_Requirement__c(id=tr.Option__c);
                                optn.RTM_Ready_Date__c = tr.Option_RTM_Ready__c;
                                optn.RTM_Ready_Date_Updated_By_Email__c = userinfo.getuseremail();
                                optn.RTM_Ready_Date_Updated_By_ID__c = userinfo.getuserid();
                            }                            
                        }
                        else{                            
                            optn = new Customer_Requirement__c(id=tr.Option__c);
                            optn.RTM_Ready_Date__c = tr.Option_RTM_Ready__c;
                            optn.RTM_Ready_Date_Updated_By_Email__c = userinfo.getuseremail();
                            optn.RTM_Ready_Date_Updated_By_ID__c = userinfo.getuserid();
                        }
                        optnList.add(optn);
                    }
                }
            }            
            if(!optnList.isEmpty()){
                database.update(optnList);
            }
        }catch(Exception e){
            system.debug('Exception is thrown during update of rtm ready date on option' + e.getmessage());
            GlobalUtility.logMessage('Error','TechReviewTriggerHelper','updateRTMReadyDateOnOption','','Exception is thrown during update of rtm ready date on option',String.valueof(e.getMessage()),'','BnP',e,0);
        }
    }
}