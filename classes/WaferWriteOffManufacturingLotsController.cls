/*
    Author: Zymark Ambat
    Description: Apex class for WaferWriteOffManufacturingLotsVF component.
    History: 
        ZAmbat      02182015    - Apex code created
*/
public class WaferWriteOffManufacturingLotsController {
    public string waferWriteOffId {get;set;}

    public WaferWriteOffManufacturingLotsController() {}
    
    public List<WaferWriteOff_ManufacturingLot__c> getLotInfo() {
        return [
            SELECT      Manufacturing_Lot__r.Name
                        , Manufacturing_Lot__r.Device_ID_MES__c
                        , Manufacturing_Lot__r.Lot_Type__c
                        , Manufacturing_Lot__r.Stage_Id__c
                        , Die_Qty__c
                        , Wafer_Qty__c
                        , Lot_Start_Date__c
                        , Aged_Days__c
                        , Status__c
            FROM        WaferWriteOff_ManufacturingLot__c
            WHERE       Wafer_Write_Off__c = :this.waferWriteOffId
            ORDER BY    Manufacturing_Lot__r.Name ASC
        ];
    }
}