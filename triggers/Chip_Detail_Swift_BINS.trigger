/*
Author: Cognizant
Company: Cognizant
Description: MRS CAD Integration Webservice
History:
created     15/8/2014     
*/
trigger Chip_Detail_Swift_BINS on Chip_Detail__c (before insert) {
for(Chip_Detail__c msk : Trigger.new)
{
msk.chipDetailUniqueIdentifier__c = msk.Name+msk.PTRF__c+msk.Chip_Size_X__c+msk.Chip_Size_Y__c;
}

}