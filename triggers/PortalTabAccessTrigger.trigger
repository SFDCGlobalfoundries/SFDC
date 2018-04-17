/*
Type Name: PortalTabAccessTrigger 
Author: Cognizant
Created Date: 19-April-2013
Reason: This trigger calls the class PortalTabTabAccessTriggerHandler for assigning Tab access to Portal users
Change History: 
Author: Amit Kumar Ojha
Modified Date: 12-Sept-2017
Reason: Restrict trigger to re-assign the Permission Set when no changes has been done on edit of the Access Set Up record
……..
……..
*/



trigger PortalTabAccessTrigger on Portal_Tab_Access__c (after insert,after update) 
{
	String PortaltabaccessId = '';
	Boolean isAccessChanged = false;
	String setofIds = '';
	String addsetofIdsOnUpdate = '';
	Set<String> uniqueIds = new Set<String>();
			        
	if(Trigger.isAfter && Trigger.isInsert) {
	    for (Portal_Tab_Access__c ptaObj: trigger.new)
	    {
	    	//adding the Ids of portal tab access to the string                                      
		    PortaltabaccessId = PortaltabaccessId+ptaObj.Id+ '|';
	    }
	    setofIds = PortaltabaccessId.Substring(0,PortaltabaccessId.length()-1);
	}
	//calling the class  ClsPortalTabAccessTriggerHandler
	// if(!RecursionPrevent.isAlreadyModified()) if (System.isBatch() || System.isFuture()) ClsPortalTabAccessTriggerHandler.assignTabAccess(setofIds); else ClsPortalTabAccessTriggerHandler.assignTabAccessFuture(setofIds);
	if(!IntegrationUserUtil.isSkipTrigger()) {
	 	if(!RecursionPrevent.isAlreadyModified()) {
		 	if(Trigger.isAfter) {
			 	if(Trigger.isInsert) {
			 		if (System.isBatch() || System.isFuture()) 
				 		ClsPortalTabAccessTriggerHandler.assignTabAccess(setofIds); 
				 	else 
				 		ClsPortalTabAccessTriggerHandler.assignTabAccessFuture(setofIds);
			 	} else if(Trigger.isUpdate) {
				 	// [Amit : 09 Sept 2017] - Making the Trigger to fire only when any of the Field present in the Access Set up Page gets updated
				 	Portal_Tab_Access__c ptaObject = new Portal_Tab_Access__c(); // This takes all available fields from the required object. 
			        Schema.SObjectType objType = ptaObject.getSObjectType(); 
			        Map<String, Schema.SObjectField> mapFields = Schema.SObjectType.Portal_Tab_Access__c.fields.getMap(); 
			        // Getting the ITAR Access Set Up Fields from the Custom Setting
			        List<ITAR_Access_Set_up_Fields__c> itarAccessSetUpFields = ITAR_Access_Set_up_Fields__c.getAll().values();
			        Set<String> itarFields = new Set<String>();
			        
			        for(ITAR_Access_Set_up_Fields__c itarAccSet : itarAccessSetUpFields) {
						itarFields.add(itarAccSet.Name);
					}
					
			        Set<String> allFields = new Set<String>();
			        // Removing System Fields which are getting caught in an Update Operation
			        if(!mapFields.isEmpty() && mapFields.keyset() != null) {
			        	allFields.addAll(mapFields.keyset());
			        	
			        	if(mapFields.keyset().contains('lastmodifieddate')) {
			        		allFields.remove('lastmodifieddate');
			        	} 
			        	if(mapFields.keyset().contains('systemmodstamp')) {
			        		allFields.remove('systemmodstamp');
			        	}
			        	if(mapFields.keyset().contains('lastmodifiedbyid')) {
			        		allFields.remove('lastmodifiedbyid');
			        	}
			        	if(!itarFields.isEmpty()) {
			        		allFields.removeAll(itarFields);
			        	}
			        	
			        }
			        
			        for(Portal_Tab_Access__c ptaObj : trigger.new) {
			            Portal_Tab_Access__c oldptaObj = trigger.oldMap.get(ptaObj.Id);
			            
						if(!allFields.isEmpty()) {
				            for (String str : allFields) { 
		                    	
		                    	if(ptaObj.get(str) != oldptaObj.get(str)) { 
								    isAccessChanged = true;		
								    // In order to restrict adding the Duplicate Ids
    								uniqueIds.add(ptaObj.Id);
					            }
				            }
						}
			        }
			        
			        for(String s : uniqueIds) {
			        	PortaltabaccessId = PortaltabaccessId + s + '|';
			        }
			        
			        if(PortaltabaccessId != null && PortaltabaccessId != '') {
			        	addsetofIdsOnUpdate = PortaltabaccessId.Substring(0,PortaltabaccessId.length()-1);
			        }
			        	
			        if(isAccessChanged && addsetofIdsOnUpdate != null) {
			        	if (System.isBatch() || System.isFuture()) {
					 		ClsPortalTabAccessTriggerHandler.assignTabAccess(addsetofIdsOnUpdate); 
			        	} else { 
					 		ClsPortalTabAccessTriggerHandler.assignTabAccessFuture(addsetofIdsOnUpdate); 	
			        	}
			        	isAccessChanged = false;		 		
			        }
			 	}
		 	}
	 	} 		
	 }
}