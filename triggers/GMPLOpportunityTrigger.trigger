/*
    Author: Anirban Roy        
    Description: Trigger on GMPL Opportunity Association object.
    History: 
      ARoy  04232014    - Code Creation
*/

trigger GMPLOpportunityTrigger on GMPL_Opportunity__c (after insert, after update) {
	
	if(trigger.isAfter){

		if(trigger.isInsert){		
			// Insert value into First_Product_Test_Chip_Tape_out_Commi__c, Fst_Product_Test_Chip_Tape_out_Expected__c fields of GMPL/BX009 object 
			// from First Product To Date of GMPL Opportunity object
			GMPLOpportunityTriggerHandler.gmplBX009ProdToDateInsert(trigger.new);
		}
		
		if(trigger.isUpdate){
			// Update value into First_Product_Test_Chip_Tape_out_Commi__c, Fst_Product_Test_Chip_Tape_out_Expected__c fields of GMPL/BX009 object 
			// from First Product To Date of GMPL Opportunity object
			GMPLOpportunityTriggerHandler.gmplBX009ProdToDateUpdate(trigger.new,trigger.oldMap);
		}		
	}
		
}