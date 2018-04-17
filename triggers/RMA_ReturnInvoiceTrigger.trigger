/**
* Company       :   Cognizant Technologies PTE Ltd.
* Description   :   Trigger to control the duplication check for the line items
* History       :   

        Initials        Date          Description
-----------------------------------------------------------------------------------------
        Nikhil Jain    09-Sep-15    Created the Trigger
        Nikhil Jain    05-Jan-16    Added logic to validate same Account and Fab
        Nikhil Jain    16-Jan-16    Added logic for Intercompany
        Shyam Nair     08-Feb-16    Added logic for removing lot numbers from Lot fields in RMA
**/

trigger RMA_ReturnInvoiceTrigger on RMA_Return_Invoice__c (before Insert, before Update, before Delete){
    if(!IntegrationUserUtil.isSkipTrigger()){
        if(Trigger.isBefore){
            if(Trigger.isInsert || Trigger.isUpdate){
                //Call method to check duplicates in existing RMAs or DNCN table
                RMA_ReturnInvoiceTrigger_Helper.checkDuplicate(Trigger.new);
                
                //Call method to check if the Line Items belong to the same Account and Fab as that of RMA
                RMA_ReturnInvoiceTrigger_Helper.checkAccountAndFab(Trigger.New);
                
                //Call method to check for Intercompany Logic
                RMA_ReturnInvoiceTrigger_Helper.checkIntercompanyLogic(Trigger.New);
            }
            else if(Trigger.isDelete){
                RMA_ReturnInvoiceTrigger_Helper.clearLotNoFromRMA(Trigger.Old);
            }
        }
    }
}