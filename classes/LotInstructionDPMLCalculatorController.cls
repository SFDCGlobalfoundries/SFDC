/*
    Author: Zymark Ambat
    Description: This Class serves as the controller for LotInstructionDPMLCalculatorVF.
    History: 
        ZAmbat      10312014    - Code creation.
*/

public class LotInstructionDPMLCalculatorController {
    public Lot_Instruction__c lotInstruction {get;set;}
    public decimal dpmlValue {get;set;}
    
    public LotInstructionDPMLCalculatorController() {
        this.lotInstruction = [
            SELECT      Id
                        , Name
                        , Lead_Time_Adder_Days__c
                        , Remaining_Mask_Count_at_New_CRD_Submiss__c
                        , New_CRD_Submitted_Date__c
                        , New_CRD_DPML__c
                        , Submitted_Customer_Request_Date_CRD__c
            FROM        Lot_Instruction__c
            WHERE       Id = :ApexPages.currentPage().getParameters().get('id')
        ];
        
        if (this.lotInstruction.Lead_Time_Adder_Days__c != null
            && this.lotInstruction.Remaining_Mask_Count_at_New_CRD_Submiss__c != null
            && this.lotInstruction.New_CRD_Submitted_Date__c != null
            && this.lotInstruction.New_CRD_DPML__c != null
            && this.lotInstruction.Submitted_Customer_Request_Date_CRD__c != null) {
            calculateDPML();
        }
    }
    
    public PageReference calculateDPML() {
        decimal datediff = decimal.valueOf(this.lotInstruction.Submitted_Customer_Request_Date_CRD__c.daysBetween(this.lotInstruction.New_CRD_Submitted_Date__c));
        this.dpmlValue = (datediff - this.lotInstruction.Lead_Time_Adder_Days__c)/this.lotInstruction.Remaining_Mask_Count_at_New_CRD_Submiss__c;
        this.dpmlValue.setScale(1, System.RoundingMode.UP);
        return null;
    }
    
    public PageReference calculateShipDate() {
        decimal tempValue = ((this.lotInstruction.Remaining_Mask_Count_at_New_CRD_Submiss__c * this.dpmlValue) + this.lotInstruction.Lead_Time_Adder_Days__c).round(System.RoundingMode.UP);
        this.lotInstruction.New_CRD_Submitted_Date__c = this.lotInstruction.Submitted_Customer_Request_Date_CRD__c.addDays(integer.valueOf(tempValue));
        return null;
    }
    
    public void clear() {
        this.lotInstruction = new Lot_Instruction__c();
        this.dpmlValue = 0.0;
    }
}