/*------------------------------------------------------------  
Author:        Prajnith Karra
Company:       Global Foundries
Description:   A Trigger handler class to check whether DP status is chagned or not
History
<Date>      <Authors Name>     <Brief Description of Change>
------------------------------------------------------------*/
public with sharing class FV_ASICNewsAlertTriggerHandler {

    public static void onAfterInsertUpdate(Map<Id,ASIC_News_Alert__c> newMap, Map<Id,ASIC_News_Alert__c> oldMap){
        
        map<ID,Boolean> MasterPDKMap = new map<ID,Boolean>();       
        set<ID> dpIDs = new set<ID>();  
        
        for(ASIC_News_Alert__c oAlert:newMap.values()){
            if(trigger.isInsert){
                MasterPDKMap.put(oAlert.Master_PDK__c,oAlert.Active__c);
            }           
            if(trigger.isUpdate && oldMap.containsKey(oAlert.ID) && oldMap.get(oAlert.ID).Active__c != oAlert.Active__c){
                MasterPDKMap.put(oAlert.Master_PDK__c,oAlert.Active__c);
            }       
        }
        
        if(!MasterPDKMap.isEmpty()){
                for(Document_Provisioning__c DP : [SELECT ID,Sub_PDK__r.PDK__C,AccountID__c,Sub_PDK__c,Status__c FROM Document_Provisioning__c WHERE  Sub_PDK__c != null AND Sub_PDK__r.PDK__C IN: MasterPDKMap.keyset() AND Sub_PDK__r.PDK__r.Master_PDK_ASIC__c =: true ]){
                                                      if( (dp.Status__c == 'Provisioned' || dp.Status__c == 'IPLAProvision' || dp.Status__c == 'De-Provisioned' || dp.Status__c == 'Rejected' || dp.Status__c == 'IPLADeprovision')){
                                                            dpIDs.add(DP.ID);                                               
                                                      }
                }  
        }
        if(!dpIDs.isEmpty()){
            FV_ASICNewsAlertShare.EnableSharing(dpIDs,'FROMASIC');
        }
        
    }
}