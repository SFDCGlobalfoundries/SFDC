/*
Author: Cognizant
Company: Cognizant
Description: MRS CAD Integration Webservice
History:
created     15/8/2014     
*/
trigger MaskLayer_Swift_BINS on Mask_Layer__c (before insert) {
for(Mask_Layer__c msk : Trigger.new)
{
msk.MaskLayerUniqueIdentifier__c = msk.Name+msk.PTRF__c+msk.Mask_Layer_Rev__c+msk.ROM_Code__c;
}

}