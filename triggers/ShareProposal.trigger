/***********************************************************************************************************************************
Trigger: ShareProposal
------------------------------------------------------------------------------------------------------------------------------------
Author:		Shivam Sharma (shivam.sharma@globalfoundries.com)
Created Date:  12/12/2016 (mm/dd/yyyy)
Reason:		Proposals would be associated with Devices, Accounts but since the relationship is not Master-Detail, the access would not be controlled by them.
			So purpose of this trigger to provide proposal edit access to all the Users having access to Device and all the FAEs linked to Account through AccountTeamProxy
Note:		  The Share object for the Quote/Proposal is only accessible if OWD is not 'Public Read/Write'
************************************************************************************************************************************/
trigger ShareProposal on Apttus_Proposal__Proposal__c (After Insert, After Update) {
    
    if(NPCCopyConfigurationController.InsideNPCCopyConfig) {
      if(Trigger.isAfter && Trigger.isUpdate) {
        if(NPCCopyConfigurationController.ShareProposalAfterUpdate) { return;}
          NPCCopyConfigurationController.ShareProposalAfterUpdate = true; }
    }
    if(ProposalSharing.hasRun) return;
    ProposalSharing.hasRun = true;
    
    Map<String, Apttus_Proposal__Proposal__share> oldShares = null;
	Map<String, Apttus_Proposal__Proposal__share> newShares = null;
	ProposalSharing classInstance = new ProposalSharing();
	if(Trigger.isUpdate)
		oldShares = classInstance.findOldShares(Trigger.oldMap.keySet());
    
	newShares = classInstance.createSharesToInsert(Trigger.newMap);
	
	if(oldShares != null && newShares != null){
		for(String key : oldShares.keySet())
			if(newShares.containsKey(key)){
				oldShares.remove(key);
				newShares.remove(key);
			}
	}
	if(oldShares != null && !oldShares.isEmpty())
		Database.delete(oldShares.values(), false);
	if(newShares != null && !newShares.isEmpty())
		Database.insert(newShares.values(), false);
}