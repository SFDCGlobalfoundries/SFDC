public class RMA_CAR_and_Invoice_Details_For_STM{

    public String rmaRecId{get;set;}
    
    
    public List<RMA_PRF_CAR_Particulars__c> getlstRMACAR(){
        return [select Car__c,Lot__c from RMA_PRF_CAR_Particulars__c where RecordTypeId =: RMA_Constants.PRFCAR_CAR and RMA__c =: rmaRecId];
    }
    
    public List<RMA_Return_Invoice__c> getlstRMAReturnInvoice(){
        return [select Invoice_Number__c,Invoice_Date__c,Purchase_Order_Number__c,Lot_Number__c,Wafer_Quantity__c,Total_Wfr_Qty_after_validation__c,
                Final_RMA_Wfr_Qty_To_Issue_CN_SO__c,Wafer_Id_Fab_Validated__c,Wafer_Id_Regional_Personnel_Recommended__c,
                Wafer_Id_CSR_Submission__c,Wafer_Die_Unit_Price__c, RMA__r.Workflow_Stage__c, RMA__r.RMA_Category__c from RMA_Return_Invoice__c where RMA__c =: rmaRecId];
    }


}