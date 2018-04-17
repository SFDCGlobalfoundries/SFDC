trigger IPTrigger on IP__c (after update) {
    //based on doc --> IP - Design Solution Feedback.docx
    set<IP__c> ipSet = new set<IP__c>();
    
    for(integer i = 0 ;i < trigger.new.size(); i++ ){
        if(trigger.new[i].PH1_QA_Status__c != trigger.old[i].PH1_QA_Status__c){
            ipSet.add(trigger.new[i]); 
        }
    }
    system.debug('**** hitting here.' );
    if(!ipSet.isEmpty()){
        system.debug('**** qa status is changed.' );
        set<id> acctSet = new set<id>();
        //step 1. prepare wrapper and populate properties
        map <id,BX041EmailHandler.IPNotificationWrapper>  device2WrpMap = new map<id,BX041EmailHandler.IPNotificationWrapper>();
        
        for(BX041_IP__c bx041IP : [select  BX_041__r.device__c,
                                           IP_Master__c,
                                           IP_Master__r.name,
                                           BX_041__r.device__r.account__c,
                                           BX_041__r.device__r.account__r.name,
                                           BX_041__r.device__r.name,
                                           BX_041__r.device__r.Stage__c,
                                           bx_041__r.device__r.Status__c
                                    from BX041_IP__c
                                    where IP_Master__c in :ipSet
                                      and BX_041__r.BX_041_Status__c = 'Closed'
                                      and (BX_041__r.device__r.Stage__c = 'Design In' OR  BX_041__r.device__r.Stage__c = 'Solutioning')
                                      and bx_041__r.device__r.Status__c = 'Active']){
                                        
            acctSet.add(bx041IP.BX_041__r.device__r.account__c);
            
            if(!device2WrpMap.containsKey(bx041IP.BX_041__r.device__c)){
                BX041EmailHandler.IPNotificationWrapper wp = new BX041EmailHandler.IPNotificationWrapper();
                wp.customerName = bx041IP.BX_041__r.device__r.account__r.name;
                wp.deviceId     = bx041IP.BX_041__r.device__r.name;
                wp.deviceStage  = bx041IP.BX_041__r.device__r.Stage__c;
                wp.customerSFID = bx041IP.BX_041__r.device__r.account__c;
                wp.ipNo         = bx041Ip.IP_Master__r.name;
                device2WrpMap.put(bx041IP.BX_041__r.device__c,wp);
            }
            
        }
        
        if(!device2WrpMap.isEmpty()){
            // step 2. retrieve FTS emails in account team proxy
            Map<id, list<string>> acctId2FtsMap = new Map<id, list<string>>();
            
            String rolePFTS = Environment_Variable__c.getInstance('ACCT_TM_PRXY_TM_RL_PFTS').value__c;
            String roleFTS = Environment_Variable__c.getInstance('ACCT_TM_PRXY_TM_RL_FTS').value__c;
            for(Account_Team_Proxy__c proxy : [SELECT Account__c,User__r.Email 
                                                FROM Account_Team_Proxy__c 
                                                WHERE Account__c in : acctSet 
                                                 AND (  Team_Role__c = :rolePFTS 
                                                     OR Team_Role__c = :roleFTS
                                                     OR ( Team_Role__c = 'Account Manager' AND Is_FAE__c = TRUE)
                                                     OR ( Team_Role__c = 'Primary Account Manager' AND Is_FAE__c = TRUE)) ]){
                if(acctId2FtsMap.containsKey(proxy.Account__c)){
                    acctId2FtsMap.get(proxy.Account__c).add(proxy.User__r.Email);
                } else {
                    list<string> emailList = new list <string>();
                    emailList.add(proxy.User__r.Email);
                    acctId2FtsMap.put(proxy.Account__c,emailList);
                }
            }
            
            // step 3. populate emails to wraper
            for(BX041EmailHandler.IPNotificationWrapper wp : device2WrpMap.values()){
                if(acctId2FtsMap.containsKey(wp.customerSFID)){
                    wp.emailList = acctId2FtsMap.get(wp.customerSFID);
                }
            }
            
            // step 4. send email via emailhandler
            //List<string> mergeFields = String[] {''};
            BX041EmailHandler.sendEmail(device2WrpMap.values(),'IP_DM_Change_Notification');
            system.debug('Sent Email to users.');
        
        }//end if
    }//end if
       
}