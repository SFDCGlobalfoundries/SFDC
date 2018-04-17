/*
Type Name: PDKPatchTrigger Trigger
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

trigger PDKPatchTrigger on PDK_Patch__c (after update) {
        
    /** PDK Patch Lifecycle Phase updated with Obsolete - Start **/ 
    Set<Id>  setPDKPatchIdsObsolete = new Set<Id>();
    Map<Id, String> mapPDKIdsToPDKNames = new Map<Id, String>(); //added by cognizant on 9/1/2014
    Set<Id> modifiedPatchIds = new Set<Id>() ; // Added for Issue -25527 on 02062014     
    for(PDK_Patch__c objPatch: trigger.new){
         
        if(objPatch.Patch_PDK_Lifecycle_Phase__c!=null && objPatch.Patch_PDK_Lifecycle_Phase__c=='Obsolete' && 
        objPatch.Patch_PDK_Lifecycle_Phase__c!=Trigger.oldMap.get(objPatch.ID).Patch_PDK_Lifecycle_Phase__c){
            setPDKPatchIdsObsolete.add(objPatch.ID);
        }
        
/*-----------------------added by cognizant for the Case 00002585-----------------------------------------------------------------------*/
        if(objPatch.PDK_Version__c!=Trigger.oldMap.get(objPatch.ID).PDK_Version__c || objPatch.PDK_Revision_Release_Date__c!=Trigger.oldMap.get(objPatch.ID).PDK_Revision_Release_Date__c)
        {
         system.debug('objPatch.PDK__r.Id@@'+objPatch.PDK__r.Id);
         system.debug('objPatch.PDK__r.Name@@'+objPatch.PDK__r.Name);
         mapPDKIdsToPDKNames.put(objPatch.PDK__c,objPatch.PDK__r.Master_PDK_Full_Name__c);
         modifiedPatchIds.add(objPatch.Id) ;  // Added for Issue -25527 on 02062014         
        }
       
    } 
 /*------------------------------------------------------------------------------------------------------------------*/   
    if(setPDKPatchIdsObsolete!=null && setPDKPatchIdsObsolete.size()>0){
        DesignSpecTriggerHandler.deprovisionAllForObsoletePDKPatch(setPDKPatchIdsObsolete);       
    }
    /** PDK Patch Lifecycle Phase updated with Obsolete - End **/ 
/*-----------------------added by cognizant for the Case 00002585-----------------------------------------------------------------------*/    
    if(mapPDKIdsToPDKNames!=null && mapPDKIdsToPDKNames.size()>0){
        //DesignSpecTriggerHandler.modifySubPDKName(mapPDKIdsToPDKNames); // Commented for CR -25527 on 02062014
        DesignSpecTriggerHandler.modifySubPDKNameForPatchRevDateChange(modifiedPatchIds) ; // Added for CR -25527 on 02062014
        system.debug('enter   mapPDKIdsToPDKNames!=null @@@'+mapPDKIdsToPDKNames); 
    }
/*------------------------------------------------------------------------------------------------------------------*/       
}