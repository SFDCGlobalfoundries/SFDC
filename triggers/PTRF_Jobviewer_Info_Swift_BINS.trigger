/*
Author: Cognizant
Company: Cognizant
Description: MRS CAD Integration Webservice
History:
created     15/8/2014     
*/
trigger PTRF_Jobviewer_Info_Swift_BINS on PTRF_JobViewer_Info__c (before insert) {
for(PTRF_JobViewer_Info__c msk : Trigger.new)
{
msk.ptrfJobviewerUniqueIdentifier__c = msk.Name+msk.Email_Address__c+msk.PTRF__c+msk.Jobview__c+msk.Jobview_Type__c+msk.User__c;
}

}