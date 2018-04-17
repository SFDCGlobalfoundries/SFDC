/*
 * @ Author 		:- Anil Kumar Reddy L
 * @ Description 	:- Trigger logic on SalesOrderLine
 * @ Date 			:- 19/04/2017
 * @ Change History :-  
 **/
trigger salesOrderTrigger on Sales_Order_Line__c (after Insert ,after Update) {
    
    //Invoking genric class for sharing records to Accounts and its hirarchy Accounts.
    if(Trigger.isAfter){
        ICC_SharingRecordsToAccountClass reportSharing  = new ICC_SharingRecordsToAccountClass();
        if(Trigger.isInsert){
            if(checkRecursive.runOnce()){
        	reportSharing.shareRecordsToAccounts(Trigger.New,'Sales_Order_Line__Share');   
        }
        }
        if(Trigger.isUpdate){
            if(checkRecursive.runOnce()){
            reportSharing.sharingToUpdatedAccounts(trigger.newMap,Trigger.OldMap,'Sales_Order_Line__Share');
            }
        }
    }
}