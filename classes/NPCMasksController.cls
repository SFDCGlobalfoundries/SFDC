/*
    Author: Zymark Ambat
    Description: Apex class for NPCMasksVF component.
    History: 
        ZAmbat      10092013    - Apex code created
        Asolito     01082014    - Added is modified field on the query for highlighting masks on the VF
*/
public class NPCMasksController {
    public Id paramId {get;set;}
    public string paramType {get;set;}
    public string newLine {
        get {return '\r\n';}
        set;
    }
    
    public NPCMasksController(){}
    
    public List<Mask__c> getMasks() {
        List<Mask__c> returnList = [
            SELECT      original_mask__c,modified_mask__c 
            FROM        Mask__c
            WHERE       new_part_creation_form__c = :paramId
        ];
        
        return returnList;
    }
}