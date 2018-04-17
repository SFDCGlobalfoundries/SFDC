/*
    Author: Zymark Ambat
    Description: Trigger for Visitation_Record__c.
    History: 
        ZAmbat        08212014    - code creation.
        Vvemuru       06062016    - If region head for account doesn't exist error message is thrown to select a Region head before save
*/
trigger VisitationTrigger on Visitation_Record__c (before insert,after insert) { 
    if(trigger.isbefore) {
    
        Set<Id> setAcctIds = new Set<Id>(); 
        for(Visitation_Record__c v : trigger.new) {
            setAcctIds.add(v.Account__c);
        }  
                     
        Map<Id, Account> mapAccountRegionHead = new Map<Id, Account>([
            SELECT      Id
                        , Region_Head_lk__c
            FROM        Account
            WHERE       Id IN :setAcctIds
        ]);   
            
        for (Visitation_Record__c v : trigger.new) {
            if(v.Territory_Head_for_Approval__c == null) {
                v.Territory_Head_for_Approval__c = mapAccountRegionHead.get(v.Account__c).Region_Head_lk__c;
            }
        }
    }
    
    if(trigger.isafter) {
        List<Visitation_Record__c> visitList = new List<Visitation_Record__c>();
        for (Visitation_Record__c v : trigger.new) {
             
             
             if(v.Add_as_attendee_Host__c || v.Add_as_attendee_Requestor__c || v.Add_as_attendee_Escort__c) {
                 visitList.add(v);
             }
        }
        if(visitList.size() > 0) {
            VisitationExtension visit = new VisitationExtension();
            visit.insertAttendees(visitList);
        }
        
    }
}