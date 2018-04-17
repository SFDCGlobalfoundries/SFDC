/*
Type Name: WhiteListTrigger Trigger
Author: Cognizant 
Created Date: 20-June-2013
Reason: 
Change History:
Author: 
Modified Date: 
Reason: 
……..
……..
*/

trigger WhiteListTrigger on White_List__c (before insert, before update, before delete) {

	Set<String> setPackageIds = new Set<String>();
	Set<String> setSubPDKIds = new Set<String>();
	Set<String> setSpecIds = new Set<String>();
	Map<String,Set<String>> mapExistingOnes = new Map<String,Set<String>>();
	
	if(trigger.isInsert || trigger.isUpdate){
		for(White_List__c objWL: trigger.new){
		    if((trigger.isInsert || (trigger.isUpdate && Trigger.oldMap.get(objWL.ID).Account__c!=objWL.Account__c))){
		    	if(objWL.Package__c!=null){
		    		setPackageIds.add(objWL.Package__c);	
		    	} 
		    	else if(objWL.Sub_PDK__c!=null){
		    		setSubPDKIds.add(objWL.Sub_PDK__c);	
		    	} 
		    	else if(objWL.Design_Spec__c!=null){
		    		setSpecIds.add(objWL.Design_Spec__c);	
		    	}                    		
	        }	        			
		}
	
		for(White_List__c objWL:[Select Id, Name, Package__c, Sub_PDK__c, Design_Spec__c, Account__c from White_List__c where Package__c IN:setPackageIds 
								OR Sub_PDK__c IN:setSubPDKIds OR Design_Spec__c IN:setSpecIds]){
			Set<String> setTempSets = new Set<String>();
			
			if(objWL.Package__c!=null){
		        if(mapExistingOnes!=null){ 
		            if(mapExistingOnes.containsKey(objWL.Package__c)){
		                setTempSets = mapExistingOnes.get(objWL.Package__c) ;
		            }
		            setTempSets.add(objWL.Account__c);
		            mapExistingOnes.put(objWL.Package__c , setTempSets);
		        }
			}
			else if(objWL.Sub_PDK__c!=null){
				if(mapExistingOnes!=null){ 
		            if(mapExistingOnes.containsKey(objWL.Sub_PDK__c)){
		                setTempSets = mapExistingOnes.get(objWL.Sub_PDK__c) ;
		            }
		            setTempSets.add(objWL.Account__c);
		            mapExistingOnes.put(objWL.Sub_PDK__c , setTempSets);
		        }
			} 	
			else if(objWL.Design_Spec__c!=null){
				if(mapExistingOnes!=null){ 
		            if(mapExistingOnes.containsKey(objWL.Design_Spec__c)){
		                setTempSets = mapExistingOnes.get(objWL.Design_Spec__c) ;
		            }
		            setTempSets.add(objWL.Account__c);
		            mapExistingOnes.put(objWL.Design_Spec__c , setTempSets);
		        }
			}			
		}
		
		for(White_List__c objWL: trigger.new){
			if(mapExistingOnes!=null){
			    if(objWL.Package__c!=null && mapExistingOnes.containsKey(objWL.Package__c)){
					if(mapExistingOnes.get(objWL.Package__c).contains(objWL.Account__c)){
						objWL.addError('There is already an existing White List with this Package and Account combination. Hence this White List cannot be created or updated');		
					}
			    }
			    else if(objWL.Sub_PDK__c!=null && mapExistingOnes.containsKey(objWL.Sub_PDK__c)){
					if(mapExistingOnes.get(objWL.Sub_PDK__c).contains(objWL.Account__c)){
						objWL.addError('There is already an existing White List with this Sub PDK and Account combination. Hence this White List cannot be created or updated');		
					}
			    }
			    else if(objWL.Design_Spec__c!=null && mapExistingOnes.containsKey(objWL.Design_Spec__c)){
					if(mapExistingOnes.get(objWL.Design_Spec__c).contains(objWL.Account__c)){
						objWL.addError('There is already an existing White List with this Design Spec and Account combination. Hence this White List cannot be created or updated');		
					}
			    }
			}			
		}
	}
	
	if(trigger.isdelete){		
		DesignSpecTriggerHandler.deprovisionForWhiteListDeletion(trigger.old);			
	}
	        
}