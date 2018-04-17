/***************************************************************************************************************************************
Class:		 ProposalSharing
----------------------------------------------------------------------------------------------------------------------------------------
Author:		Shivam Sharma ( shivam.sharma@globalfoundries.com)
Created Date:  12/12/2016 (mm/dd/yyyy)
Reason:		Proposals would be associated with Devices, Accounts but since the relationship is not Master-Detail, the access would not be controlled by them.
			So purpose of this class is to provide proposal edit access to all the Users having access to Device and all the FAEs linked to Account through AccountTeamProxy
Note:		The Share object for the Quote/Proposal is only accessible if OWD is not 'Public Read/Write'
****************************************************************************************************************************************/
public class ProposalSharing { 
    public static Boolean hasRun = false;
	private List<Profile> lstProfiles;
	public ProposalSharing(){
		lstProfiles = [Select Id from Profile where Name LIKE '%FAE%'];
	}
	//Method to fetch all the existing ProposalShares with RowCause as 'ApexSharing__c'
	public Map<String, Apttus_Proposal__Proposal__share> findOldShares(Set<Id> setProposalIds){
		Map<String, Apttus_Proposal__Proposal__share> sharesByUserId = new Map<String, Apttus_Proposal__Proposal__share>();
		List<Apttus_Proposal__Proposal__share> lstShares = [select ParentId, UserOrGroupId from Apttus_Proposal__Proposal__share where RowCause = 'ApexSharing__c' AND ParentId IN : setProposalIds AND AccessLevel = 'Edit'];
		for(Apttus_Proposal__Proposal__share share : lstShares){
			sharesByUserId.put(share.ParentId +'_'+share.UserOrGroupId, share);
		}
		return sharesByUserId;
	}
	//Method to create proposalShares for all the Users having access to Device and all the FAEs linked to Account through AccountTeamProxy
	public Map<String, Apttus_Proposal__Proposal__share> createSharesToInsert(Map<Id, Apttus_Proposal__Proposal__c> proposalMap){
		Map<String, Apttus_Proposal__Proposal__share> sharesByUserId = new Map<String, Apttus_Proposal__Proposal__share>();
		Set<Id> setOfDeviceIds = new Set<Id>();
		Set<Id> setOfAccountIds = new Set<Id>();
		for(Apttus_Proposal__Proposal__c proposal : proposalMap.values()){
			if(proposal.Device__c != null)
				setOfDeviceIds.add(proposal.Device__c);
			if(proposal.Apttus_Proposal__Account__c != null)
				setOfAccountIds.add(proposal.Apttus_Proposal__Account__c);
		}
		
		Map<Id, Set<Id>> usersByDevice = new Map<Id, Set<Id>>();
		List<Device__share> deviceShares = [select ParentId, UserOrGroupId from Device__share where ParentId IN:setOfDeviceIds];
			for(Device__share dShare : deviceShares){
				Set<Id> setOfUsers = new Set<Id>();
				if(usersByDevice.containsKey(dShare.ParentId))
					setOfUsers = usersByDevice.get(dShare.ParentId);
				setOfUsers.add(dShare.UserOrGroupId);
				usersByDevice.put(dShare.ParentId, setOfUsers);
			}
		deviceShares.clear();
		
		Map<Id, Set<Id>> usersByAccount = new Map<Id, Set<Id>>();
		List<Account_Team_Proxy__c> accTeamProxy = [ Select Account__c, User__c from Account_Team_Proxy__c where (Account__c IN : setOfAccountIds) AND (User__r.ProfileId IN : lstProfiles)];
			for(Account_Team_Proxy__c atp : accTeamProxy){
				Set<Id> setOfUsers = new Set<Id>();
				if(usersByAccount.containsKey(atp.Account__c))
					setOfUsers = usersByAccount.get(atp.Account__c);
				setOfUsers.add(atp.User__c);			
				usersByAccount.put(atp.Account__c, setOfUsers);
			}
		accTeamProxy.clear();
		
		//Now we have "List of UserIDs By Devices" and "List of UserIDs By Accounts" in 'usersByDevice' and 'usersByAccount' respectively.
		for(Apttus_Proposal__Proposal__c proposal : proposalMap.values()){
			Set<Id> usersOfProposal = new Set<Id>();
			if(proposal.Device__c != null && usersByDevice.containsKey(proposal.Device__c))
				usersOfProposal.addAll(usersByDevice.get(proposal.Device__c));	
			if(proposal.Apttus_Proposal__Account__c != null && usersByAccount.containsKey(proposal.Apttus_Proposal__Account__c))
				usersOfProposal.addAll(usersByAccount.get(proposal.Apttus_Proposal__Account__c));	
				
			for(Id userId : usersOfProposal){
				Apttus_Proposal__Proposal__share newShare = new Apttus_Proposal__Proposal__share();
				newShare.ParentId = proposal.Id;
				newShare.UserOrGroupId = userId;
				newShare.AccessLevel = 'Edit';
				newShare.RowCause = 'ApexSharing__c';
				sharesByUserId.put(newShare.ParentId +'_'+newShare.UserOrGroupId, newShare);
			}
		}
		return sharesByUserId;
	}
}