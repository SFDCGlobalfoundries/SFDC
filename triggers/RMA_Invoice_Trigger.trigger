/**
* Company       :   Cognizant Technologies PTE Ltd.
* Description   :   Trigger on Invoice object to populate the Manufacturing Lot Lookup.
* History       :   

        Initials        Date          Description
-----------------------------------------------------------------------------------------
        Nikhil Jain    18-Jan-16      Created the Trigger
**/

trigger RMA_Invoice_Trigger on Invoice__c (Before Insert) {
	if(Trigger.isBefore){
		if(Trigger.isInsert){
			RMA_Invoice_Trigger_Handler.PopulateMfgLot(Trigger.New);
		}
	}
}