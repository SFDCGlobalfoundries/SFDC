/**
    Trigger Name:  AccountRegionHeadMappingTrigger 
    Author:        Thomas Lai(TL)
    Description:   This Trigger Syncs region head and svp to Account & Oppoortunity
                   
    History: 
      TL           01232014    - Code creation.
      TL 		   31072014	   - Changed as per case 31543
      
**/
trigger AccountRegionHeadMappingTrigger on Account_Region_Head_Mapping__c (after update, after insert) {
    
    map<id, Account_Region_Head_Mapping__c> arhmap = new map<id, Account_Region_Head_Mapping__c>();
    set<id> usrIdSet = new set<id>();
    set<id> inActiveMappings = new set<id>();
    map<id, Account_Region_Head_Mapping__c> acct2Arhm = new map<id, Account_Region_Head_Mapping__c>();
    
    for(Account_Region_Head_Mapping__c mapping : trigger.new){
        if(trigger.isinsert ){
            arhmap.put(mapping.id, mapping);
            usrIdSet.addAll(new list<id>{mapping.region_head_lk__c, /*mapping.region_head_backup_lk__c,*/ mapping.Sales_SVP__c, mapping.Territory_Approver_LK__c});
            if(mapping.Strategic_Account__c != null) {
            	acct2Arhm.put(mapping.Strategic_Account__c, mapping);
            }
        }
        
        if(trigger.isUpdate) {
            if(mapping.isActive__c == false && trigger.oldmap.get(mapping.id).isActive__c != mapping.isActive__c ){
                inActiveMappings.add(mapping.id);
            } else if( mapping.region_head_lk__c != trigger.oldmap.get(mapping.id).region_head_lk__c
                //|| mapping.region_head_backup_lk__c != trigger.oldmap.get(mapping.id).region_head_backup_lk__c
                || mapping.Sales_SVP__c != trigger.oldmap.get(mapping.id).Sales_SVP__c
                || mapping.Territory_Approver_LK__c != trigger.oldmap.get(mapping.id).Territory_Approver_LK__c
                ||(mapping.isActive__c && trigger.oldmap.get(mapping.id).isActive__c != mapping.isActive__c)){
                
                arhmap.put(mapping.id, mapping);
                usrIdSet.addAll(new list<id>{mapping.region_head_lk__c, /*mapping.region_head_backup_lk__c,*/ mapping.Sales_SVP__c, mapping.Territory_Approver_LK__c});
                if(mapping.Strategic_Account__c != null) {
                    acct2Arhm.put(mapping.Strategic_Account__c, mapping);
                }
            }
        }
    }
    
    /*====================================== End of FOR LOOP =============================================*/
    
    /*-------------------------- Start Update account and oppty with new Head and SVP  -----------------------------------*/
    if(arhmap.size() > 0 || acct2Arhm.size() > 0){
    	AcctRegHeadMappingTgrHandler.bypassAcctTrigger = true;
    	ClsAccTriggerHandler.blnAccountShareRun = true;
    	list< Account> updatedAcct = AcctRegHeadMappingTgrHandler.updateAccount4NewMapping(usrIdSet, arhmap, acct2Arhm);
    	AcctRegHeadMappingTgrHandler.bypassOppTrigger = true;
    	AcctRegHeadMappingTgrHandler.updateOppty(updatedAcct);
    	AcctRegHeadMappingTgrHandler.bypassOppTrigger = false;
    	AcctRegHeadMappingTgrHandler.bypassAcctTrigger = false;
    	ClsAccTriggerHandler.blnAccountShareRun = false;
    }
    
    /*-------------------------- End Update account and oppty with new Head and SVP  -----------------------------------*/
    
    /*-------------------------- Start Inactive mapping logic  -----------------------------------*/
    if(trigger.isupdate && inActiveMappings.size() > 0){
    	AcctRegHeadMappingTgrHandler.bypassAcctTrigger = true;	
    	ClsAccTriggerHandler.blnAccountShareRun = true;
    	list< Account> updatedAcct = AcctRegHeadMappingTgrHandler.updateAccount4InactiveMappings(inActiveMappings);
    	AcctRegHeadMappingTgrHandler.bypassOppTrigger = true;
    	AcctRegHeadMappingTgrHandler.updateOppty(updatedAcct);
    	AcctRegHeadMappingTgrHandler.bypassOppTrigger = false;
    	AcctRegHeadMappingTgrHandler.bypassAcctTrigger = false;
    	ClsAccTriggerHandler.blnAccountShareRun = false;
    }
    /*-------------------------- End Inactive mapping logic  -----------------------------------*/
}