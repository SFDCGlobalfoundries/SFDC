/**
* Company       :   Cognizant Technologies PTE Ltd.
* Description   :   Trigger Handler for Trigger on Invoice object.
* History       :   
        Initials        Date          Description
-----------------------------------------------------------------------------------------
        Nikhil Jain    18-Jan-16      Created the Class
**/
public class RMA_Invoice_Trigger_Handler{
    
    //Method to populate Mfg Lot Id on the Invoice record.
    public static void PopulateMfgLot(List<Invoice__c> TriggerNew){
        
        Map<String,Manufacturing_Lot__c> mapLotvsMfgLot = new Map<String,Manufacturing_Lot__c>();
        Set<String> setLotNumbers = new Set<String>();
        
        //Prepare set for unique Lot Names
        for(Invoice__c invRec: TriggerNew){
            setLotNumbers.add(invRec.Lot_Name__c);
        }
        
        //Prepare map for Lot Name and MfgLot Id
        for(Manufacturing_Lot__c mfgLot: [SELECT Id,Manufacturing_Lot_Id__c,Fab_Code__c FROM Manufacturing_Lot__c 
                                            WHERE Manufacturing_Lot_Id__c in :setLotNumbers]){
            mapLotvsMfgLot.put(mfgLot.Manufacturing_Lot_Id__c, mfgLot);
        }
        
        //Populate Manufacturing Lot Id on the Invoice
        for(Invoice__c invRec: TriggerNew){
            if(mapLotvsMfgLot.containsKey(invRec.Lot_Name__c) &&  mapLotvsMfgLot.containsKey(invRec.Lot_Name__c) != NULL){
                invRec.Manufacturing_Lot__c = mapLotvsMfgLot.get(invRec.Lot_Name__c).Id;
                invRec.Fab_Code__c          = mapLotvsMfgLot.get(invRec.Lot_Name__c).Fab_Code__c;
                
            }
        }
        
    }
    
}