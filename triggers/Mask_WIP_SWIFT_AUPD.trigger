/*
Type Name: Mask_WIP_SWIFT_AUPD 
Author: Cognizant 
Created Date: 1-June-2014
Reason: This trigger is wriiten on after update activity of Mask WIP. If Status is selected as Completed in Mask WIP 
        during update, then certain data from Mask WIP will be validated with Pairing Table.
*/
trigger Mask_WIP_SWIFT_AUPD on Mask_WIP__c (after update) {

    list<Mask_WIP__c> lstMaskWIP = new list<Mask_WIP__c>();
    
    for(Mask_WIP__c obj:trigger.new) {
        if(obj.Status__c == 'Completed' && Trigger.oldMap.get(obj.Id).Status__c != 'Completed' && obj.shipped_date__c != null) lstMaskWIP.add(obj);
    }

    if(lstMaskWIP.size()>0) MaskWIPHandlerUtility.validatePairingTableToShipMRSLayer(lstMaskWIP);
}