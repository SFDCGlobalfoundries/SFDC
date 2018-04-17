/*
Type Name: PDKTrigger Trigger
Author: Cognizant 
Created Date: 20-June-2013
Reason: 
Change History:
Author: Cognizant 
Modified Date: 9/1/2014
Reason: Change in the PDK name 
��..
��..
*/

trigger PDKTrigger on PDK__c (before update,after update) {
        
    Set<Id>  setPDKIdsRevisionChanged = new Set<Id>();
    
    /** PDK Lifecycle Phase updated with Obsolete - Start **/ 
    Set<Id>  setPDKIdsObsolete = new Set<Id>();
    /** PDK Lifecycle Phase updated with Obsolete - End **/ 
    
    Map<Id, String> mapPDKIdsToPDKNames = new Map<Id, String>();
    
    Map<Decimal, String> mapRevisionIdsToIds = new Map<Decimal, String>();

    for(PDK__c objPDK: trigger.new){
                
        /** PDK Lifecycle Phase updated with Obsolete - Start **/
        if(trigger.isAfter){
            if(objPDK.PDK_Lifecycle_Phase__c!=null && objPDK.PDK_Lifecycle_Phase__c=='Obsolete' && 
            objPDK.PDK_Lifecycle_Phase__c!=Trigger.oldMap.get(objPDK.ID).PDK_Lifecycle_Phase__c){
                setPDKIdsObsolete.add(objPDK.ID);
            }
 // commented by cognizant for the Case 00002585           
           /*  if(objPDK.Name!=Trigger.oldMap.get(objPDK.ID).Name){
                mapPDKIdsToPDKNames.put(objPDK.Id,objPDK.Name);
            }*/
/*-----------------------added by cognizant for the Case 00002585-----------------------------------------------------------------------*/         
            if(objPDK.Master_PDK_Full_Name__c!=Trigger.oldMap.get(objPDK.ID).Master_PDK_Full_Name__c || objPDK.PDK_DocTitle__c !=Trigger.oldMap.get(objPDK.ID).PDK_DocTitle__c){
                mapPDKIdsToPDKNames.put(objPDK.Id,objPDK.Master_PDK_Full_Name__c);
            }
        }
        
/*------------------------------------------------------------------------------------------------------------------*/   
        /** PDK Lifecycle Phase updated with Obsolete - End **/ 
        
        if(trigger.isBefore){
            if(objPDK.PDK_Version__c!=Trigger.oldMap.get(objPDK.ID).PDK_Version__c){
                setPDKIdsRevisionChanged.add(objPDK.ID);
                mapRevisionIdsToIds.put(objPDK.Old_Revision_Id__c,objPDK.ID);       
            }
        }
    } 
    
    /** PDK Lifecycle Phase updated with Obsolete - Start **/ 
    if(setPDKIdsObsolete!=null && setPDKIdsObsolete.size()>0){
        DesignSpecTriggerHandler.deprovisionAllForObsoletePDK(setPDKIdsObsolete);       
    }
    /** PDK Lifecycle Phase updated with Obsolete - End **/ 
       
    /*if(setPDKIdsRevisionChanged!=null && setPDKIdsRevisionChanged.size()>0){
        DesignSpecTriggerHandler.assignSpecsToOldPDK(setPDKIdsRevisionChanged,mapRevisionIdsToIds);     
    }*/
    
    if(setPDKIdsRevisionChanged!=null && setPDKIdsRevisionChanged.size()>0){
        DesignSpecTriggerHandler.reassignSpecsToPDK(setPDKIdsRevisionChanged);      
    }
    
    if(mapPDKIdsToPDKNames!=null && mapPDKIdsToPDKNames.size()>0){
        DesignSpecTriggerHandler.modifySubPDKName(mapPDKIdsToPDKNames); 
        system.debug('enter   mapPDKIdsToPDKNames!=null @@@'); 
    }
    
}