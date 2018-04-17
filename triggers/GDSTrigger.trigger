/*
    Author: Anirban Roy
    Description: Trigger on GDS object for insert and update operation.  
    History:
        ARoy        10242014    - code creation. 
        Asolito     11262014    - removed Multi_Source_Translating__c population logic 
                                  since GDS status will be sync back to the proposal using 
                                  the field Multi_Source_Tapeout_Approval_Stage__c              
*/

trigger GDSTrigger on GDS__c (before insert,after update) {
    
    //==========Update GDS status back for Multi Source Tapeout into Configuration object===========//
    if(Trigger.isAfter && Trigger.isUpdate){
        
        Map<Id,String> configIdStatusMap = new Map<Id,String>();
        for(GDS__c gds : trigger.new){
            if(gds.Status__c != trigger.oldMap.get(gds.Id).Status__c){
                configIdStatusMap.put(gds.Quote_Proposal__c,gds.Status__c);
            }         
        }
        
        if(configIdStatusMap.size()>0){
            List<Apttus_Proposal__Proposal__c> configList = new List<Apttus_Proposal__Proposal__c>();
            for(Apttus_Proposal__Proposal__c prop : [select     Id
                                                                , Multi_Source_Tapeout_Approval_Stage__c
                                                     from       Apttus_Proposal__Proposal__c
                                                     where      Id in :configIdStatusMap.keySet()
                                                    ]){
                prop.Multi_Source_Tapeout_Approval_Stage__c = configIdStatusMap.get(prop.Id);
                configList.add(prop);   
            }
            if(configList.size()>0){
                update configList;
            }
        }
    }
    //================================================End===============================================================//
    
    //====================================Populate the Master Account Short Name========================================//
    if(Trigger.isBefore && Trigger.isInsert){
        Set<Id> configIds = new Set<Id>();
        Map<Id,String> gdsIdacctShrtNmMap = new Map<Id,String>();
        Map<Id,String> gdsIdmstrAcctShrtNmMap = new Map<Id,String>();
        
        for(GDS__c gds : trigger.new){
            if(gds.Quote_Proposal__c != null){
                configIds.add(gds.Quote_Proposal__c);
            }
        }
        
        // Query to get the account short name from GDS
        if(configIds.size()>0){         
            for(Apttus_Proposal__Proposal__c prop : [select     id
                                                                , Apttus_Proposal__Account__r.Short_Name__c
                                                    from        Apttus_Proposal__Proposal__c
                                                    where       id in :configIds
                                                   ]){
                if(prop.Apttus_Proposal__Account__r.Short_Name__c != null 
                    && prop.Apttus_Proposal__Account__r.Short_Name__c != ''){
                    gdsIdacctShrtNmMap.put(prop.id,prop.Apttus_Proposal__Account__r.Short_Name__c);
                }                       
            }                       
        }
        system.debug('gdsIdacctShrtNmMap ==> '+gdsIdacctShrtNmMap);
        
        // Query the Account Hierarchy to get the master account information
        if(gdsIdacctShrtNmMap.size()>0){
            for(Account_Hierarchy__c ah : [select   id
                                                    , Master_Account_Short_Name__c
                                                    , Account_Short_Name__c
                                           from     Account_Hierarchy__c
                                           where    Account_Short_Name__c in :gdsIdacctShrtNmMap.values()
                                          ]){
                if(ah.Master_Account_Short_Name__c != null){
                    for(Id gdsId : gdsIdacctShrtNmMap.keySet()){
                        if(ah.Account_Short_Name__c == gdsIdacctShrtNmMap.get(gdsId)){
                            gdsIdmstrAcctShrtNmMap.put(gdsId,ah.Master_Account_Short_Name__c);
                        }
                    }
                }   
            }
        }
        system.debug('gdsIdmstrAcctShrtNmMap ==> '+gdsIdmstrAcctShrtNmMap);
        
        // Populate the master account short name
        for(GDS__c gds : trigger.new){
            if(!gdsIdmstrAcctShrtNmMap.isEmpty() && gdsIdmstrAcctShrtNmMap.containsKey(gds.Quote_Proposal__c)){
                gds.Master_Account_Short_Name__c = gdsIdmstrAcctShrtNmMap.get(gds.Quote_Proposal__c);
            }   
        }       
    }   
    //================================================End===============================================================//
}