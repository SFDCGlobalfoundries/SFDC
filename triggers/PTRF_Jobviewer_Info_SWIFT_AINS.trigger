/*
Type Name: PTRF_Jobviewer_Info_SWIFT_AINS
Author: Cognizant 
Created Date: 23-April-2014
Reason: PTRF_JobViewer_Info__c  After insert trigger
Change History:
Author: 
Modified Date: 
Reason: 
Author: Cognizant Technology Solutions
Modified Date:
……..
……..
 */

trigger PTRF_Jobviewer_Info_SWIFT_AINS on PTRF_JobViewer_Info__c (after insert) {
	
	set<String> setPTRFJVIUserIds = new set<String>();
	
	/** Whenever a user is added as a Customer or Foundry Jobviewer, adding that user to Swift_FoundryJobviewer Group and assigning that user the Permission Set **/
	for(PTRF_JobViewer_Info__c objPTRFJVI: trigger.new){
		if(objPTRFJVI.Jobview__c!=null && objPTRFJVI.Jobview__c=='Foundry' && objPTRFJVI.Jobview_Type__c!=null && objPTRFJVI.User__c!=null){
			setPTRFJVIUserIds.add(objPTRFJVI.User__c);	
		}		
	}
	if(setPTRFJVIUserIds.size()>0){
		if (System.isBatch() || System.isFuture()){
            PTRFHandler.addingFoundryJVtoGroupAndPermSet(setPTRFJVIUserIds); 
        }else{
            PTRFHandler.addingFoundryJVtoGroupAndPermSetFuture(setPTRFJVIUserIds); 
        } 	
	}
}