/*
    Author: Zymark Ambat
    Description: This class clears the Assigned PID in CDRS if PIYE rejects an NPC form.
    History: 
        ZAmbat      02102015    - Code creation.
*/

public class NPCFormCDRS {
    public static void clearAssignedPID(Set<Id> npcIds) {
        List<BX_041__c> listCDRS = new List<BX_041__c>();
        for (Device__c d : [SELECT    Id
                                      , (SELECT    Id
                                                   , Assigned_Process_Id__c
                                         FROM      BX_041__r)
                            FROM      Device__c
                            WHERE     NPC_Form__c IN :npcIds]) {
            if (d.BX_041__r.size() > 0) {
                for (BX_041__c b : d.BX_041__r) {
                    b.Assigned_Process_Id__c = null;
                }
                
                listCDRS.add(d.BX_041__r);
            }
        }
        
        if (listCDRS.size() > 0) {
            update listCDRS;
        }
    }
}