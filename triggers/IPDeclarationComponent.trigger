/*
    Author: Ariz Solito
    Description: Apex trigger for IP declaration component matching
    History: 
    Asolito      07/11/2013    - Apex coded created
*/
trigger IPDeclarationComponent on IP_Declaration_Component__c (after insert, after update) {	
	Set<String> recIDs = new Set<String>();
	for(IP_Declaration_Component__c t: trigger.new){
		recIDs.add(t.ip_declaration_form__c);
	}
	 
	if(!IPDeclarationMatching.hasMatchingRun){
		IPDeclarationMatching.processMatching(recIds);		
	}	
}