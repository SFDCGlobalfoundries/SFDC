/*
Type Name: EndCustomerDuplicatePreventerTrigger Trigger
Author: IBM  
Created Date: 16th-DEC-2013
Reason: This trigger is used to stop wrong entries as per business conditions
Change History:
Author: 
Modified Date: 
Reason: 
*/
trigger EndCustomerDuplicatePreventerTrigger on End_Customer__c (before insert, before update)
{
    Map<String,Integer> accountResellerIdMap = new Map<String,Integer>();
    Set<Id> accountIdSet=new Set<Id>();
    Set<Id> accountResellerIdSet=new Set<Id>();
    
    Integer count=0;

    for(End_Customer__c ec : trigger.new){
        accountIdSet.add(ec.Account__c);
        accountResellerIdSet.add(ec.Assigned_Reseller__c);
        
        if(accountResellerIdMap !=null && accountResellerIdMap.size() > 0){
            if(accountResellerIdMap.containsKey(ec.Account__c+'|'+ec.Assigned_Reseller__c)){
                count=accountResellerIdMap.get(ec.Account__c+'|'+ec.Assigned_Reseller__c);
            }
        }else{
            count=0;
        }
        accountResellerIdMap.put(ec.Account__c+'|'+ec.Assigned_Reseller__c,count+1);
    }
    
    End_Customer__c[] existingEcLst=[Select Id, Account__c, Assigned_Reseller__c From End_Customer__c where Assigned_Reseller__c IN :accountResellerIdSet and Account__c IN: accountIdSet];
    for(Integer i=0;i<existingEcLst.size();i++){
        if(accountResellerIdMap!=null && accountResellerIdMap.size()>0){
            if(accountResellerIdMap.containsKey(existingEcLst[i].Account__c+'|'+existingEcLst[i].Assigned_Reseller__c)){
                count=accountResellerIdMap.get(existingEcLst[i].Account__c+'|'+existingEcLst[i].Assigned_Reseller__c);
            }
        }else{
            count=0;
        }
    
        accountResellerIdMap.put(existingEcLst[i].Account__c+'|'+existingEcLst[i].Assigned_Reseller__c,count+1);
  
    }
    
    if(trigger.isInsert){
        for(End_Customer__c endCustomer : trigger.new){
            if(accountResellerIdMap!=null && accountResellerIdMap.size()>0){
                if(accountResellerIdMap.containsKey(endCustomer.Account__c+'|'+endCustomer.Assigned_Reseller__c) && accountResellerIdMap.get(endCustomer.Account__c+'|'+endCustomer.Assigned_Reseller__c)>1){
                    endCustomer.Assigned_Reseller__c.addError('Reseller already there in list for this Account');
                }else if(endCustomer.Account__c == endCustomer.Assigned_Reseller__c){
                    endCustomer.Assigned_Reseller__c.addError('Reseller should be different from Account');
                }
            }
        }
    }else if (trigger.isUpdate){
        for(Integer i=0;i<trigger.new.size();i++){
            if(accountResellerIdMap!=null && accountResellerIdMap.size()>0){
                if(trigger.new[i].Assigned_Reseller__c!= trigger.old[i].Assigned_Reseller__c && accountResellerIdMap.containsKey(trigger.new[i].Account__c+'|'+trigger.new[i].Assigned_Reseller__c) && accountResellerIdMap.get(trigger.new[i].Account__c+'|'+trigger.new[i].Assigned_Reseller__c)>1){
                	trigger.new[i].Assigned_Reseller__c.addError('Reseller already there in list for this Account');
                }else if((trigger.new[i].Assigned_Reseller__c!= trigger.old[i].Assigned_Reseller__c) && (trigger.new[i].Account__c == trigger.new[i].Assigned_Reseller__c)){
                    trigger.new[i].Assigned_Reseller__c.addError('Reseller should be different from Account ... ');
                } 
            }
        }
    }
}