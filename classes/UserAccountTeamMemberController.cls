/*
	Author:
	Description: This is a controller class for UserAccountTeamMember and EditAccountTeamMember VF page. 
	History:
		ARoy        04292013    - code modified for addition of Fab Assignment column.
		ZAmbat      05162013    - modified code to add validation if the assigned role is 'Customer Engineer' or 'Fab Planner'.
		Nbustillos  08142013    - Updated code to use Environment Variable/Error Codes for hardcoded values.
		TLai        18032014    - Added logic to flag PFTS/BCSR replacement
		TLai    	09042014  	- Added logic to update atp record only when it is changed
		Tlai    	11072014  	- Merged two controllers into one
		Vijay     	02102015  	- added isInternalAccount boolean variable to check the Account type and if it is Internal Account, the Opportunity Access column will
									not be shown on Page
		Vijay   	05062015  	- By default Opportunity Access is set to 'Private' for Internal Account.
		NJain		05122016	- Changes for AM as FAE.
*/
public with sharing class UserAccountTeamMemberController {
	
	public List<AccountTeamProxyModel> AccountTeamProxyList{get;set;}
	public List<ReplaceUserWrapper> ReplaceUserWrapList{get;set;}
	public string contentIds{get;set;}
	public string AccountName{get;set;}
	public boolean Fabdisable{get;set;}
	//added by Vijay -  created class variable isInternalAccount
	public boolean isInternalAccount {get;set;}
	public static final String GLOBALFOUNDRIES_INTERNAL_ACCOUNT_RECTYPE = 'GLOBALFOUNDRIES_Internal';

	public Account_Team_Proxy__c atpProxObj {get;set;}
	public boolean displayPopup {get; set;}
	public boolean Popup{get; set;}  
	static final string ACCT_TM_PRXY_TM_RL_PAM= EnvironmentVariable.get('ACCT_TM_PRXY_TM_RL_PAM');
	static final string ACCT_TM_PRXY_TM_RL_PCSR= EnvironmentVariable.get('ACCT_TM_PRXY_TM_RL_PCSR');
	Public List<Account_Team_Proxy__c> NewAccontTeamProxList{get;set;}
	Public boolean ConfromUserReplase{get;set;}
	Public boolean ConfromUser2Replase{get;set;}
	Public boolean SearchResult{get;set;}
	Map<Id,Account_Team_Proxy__c> ATPUserUpdMap=new Map<Id,Account_Team_Proxy__c>();

	public class AccountTeamProxyModel{
		public Account_Team_Proxy__c atpObj{get;set;}
		public boolean Fabassign {get;set;}
		public String oldRole {get; set;}
		public String oldAcctAccess {get; set;} //Tlai 09042014
		public String oldOppAccess {get; set;}//Tlai 09042014
		public String oldFabAssignment {get; set;}//Tlai 09042014
		public boolean oldDeleteFlag{get; set;}
		public boolean oldFAEflag{get; set;}
		public boolean readonly {get; set;}
	}

	public UserAccountTeamMemberController(ApexPages.StandardController stdController) {
		system.debug('Running in ext constuctor');
		String atpId = stdController.getId();  
		Account_Team_Proxy__c myAcctProxy = [Select id, Account__c from Account_Team_Proxy__c  where id =:atpId limit 1];
		contentIds = myAcctProxy.Account__c;
		this.initiate();
	}

	public UserAccountTeamMemberController(){
		system.debug('Running in custom constuctor');
		contentIds = apexpages.currentpage().getparameters().get('id');
		atpProxObj=new Account_Team_Proxy__c();  
		ConfromUserReplase=true;
		SearchResult=false;
		NewAccontTeamProxList=new list<Account_Team_Proxy__c>();
		this.initiate();
	}

	private void initiate(){
		AccountTeamProxyList = new List<AccountTeamProxyModel>();
		isInternalAccount = false;
		if(contentIds !=null) {
			List<Account> accountList = [select name, RecordType.DeveloperName from Account where id=:contentIds limit 1];
			if(accountList.size() > 0 ){
				AccountName = accountList[0].Name;
				if(accountList[0].RecordType.DeveloperName == GLOBALFOUNDRIES_INTERNAL_ACCOUNT_RECTYPE){
					isInternalAccount = true;
				}
			}
			for(Account_Team_Proxy__c atp : [SELECT Id,User__c,User__r.Name,User__r.fab_assigned__c,Account__c,Account_Access__c,
			Opportunity_Access__c,Sequence_No__c,Team_Role__c,Account_Role_ID__c,
			Flag_for_Delete__c,Fab_Assignment__c,Is_FAE__c
			FROM Account_Team_Proxy__c WHERE Account__c =:contentIds]){
				AccountTeamProxyModel atpMod  = new AccountTeamProxyModel();
				atpMod.atpObj          = atp;
				atpMod.Fabassign       = true;
				//Tlai
				atpMod.oldRole           = atp.Team_Role__c;
				atpMod.oldAcctAccess     = atp.Account_Access__c;//Tlai 09042014
				atpMod.oldOppAccess      = atp.Opportunity_Access__c;//Tlai 09042014
				atpMod.oldFabAssignment  = atp.Fab_Assignment__c;//Tlai 09042014
				atpMod.oldDeleteFlag     = atp.Flag_for_Delete__c;
				atpMod.oldFAEflag        = atp.Is_FAE__c;
				atpMod.readonly          = (atpMod.atpObj.Flag_for_Delete__c || (atpMod.atpObj.Team_role__c == 'Primary Account Manager' && atpMod.oldRole =='Primary Account Manager'))?true:false;
				AccountTeamProxyList.add(atpMod);
			}
		}    
		addNewRow();
	}

	public PageReference addNewRow(){
		Account_Team_Proxy__c atpTemp = new Account_Team_Proxy__c();
		AccountTeamProxyModel atpMod=new AccountTeamProxyModel();
		atpMod.atpObj=atpTemp;
		atpMod.atpObj.Account_Access__c     = 'Read Only';
		atpMod.atpObj.Opportunity_Access__c = 'Read Only';
		atpmod.Fabassign=false;
		atpmod.oldRole = null;
		atpmod.oldAcctAccess = null;
		atpmod.oldOppAccess = null;
		atpmod.oldFabAssignment = null;
		atpMod.oldDeleteFlag = false;
		atpMod.oldFAEflag = false;
		AccountTeamProxyList.add(atpMod);
		Fabdisable=false;
		return null;
	}

	public PageReference Save(){
		Map<String, Account_Team_Proxy__c> atpMap = new Map<String, Account_Team_Proxy__c>();
		PageReference acctPage = new PageReference('/'+ contentIds);
		List<Account_Team_Proxy__c> updateAtpList = new List<Account_Team_Proxy__c>();
		List<Account_Team_Proxy__c> insertAtpList = new List<Account_Team_Proxy__c>();
		
		Set<Id> fabUserIds = new Set<Id>();
		boolean hasNewPFTS = false;
		boolean hasOldPFTS = false;
		boolean hasNewBCSR = false;
		boolean hasOldBCSR = false;
		final string ACCT_TM_PRXY_TM_RL_PFTS = Environment_Variable__c.getinstance('ACCT_TM_PRXY_TM_RL_PFTS').value__c;
		final string ACCT_TM_PRXY_TM_RL_BCSR = Environment_Variable__c.getinstance('ACCT_TM_PRXY_TM_RL_BCSR').value__c;
		for(AccountTeamProxyModel atpModel :AccountTeamProxyList){
			if(atpModel.atpObj.User__c !=null){
				
				if (atpModel.atpObj.Account_Access__c==null){
					atpModel.atpObj.addError(Error_Codes__c.getInstance('ACCT_TM_NO_ACCT_ACCESS_ERROR').Message__c);
					return null;
				}
				
				if (atpModel.atpObj.Opportunity_Access__c==null && !isInternalAccount){
					atpModel.atpObj.addError(Error_Codes__c.getInstance('ACCT_TM_NO_OPPTY_ACCESS_ERROR').Message__c);
					return null;
				}
				if (atpModel.atpObj.Team_Role__c==null ){
					atpModel.atpObj.addError(Error_Codes__c.getInstance('ACCT_TM_NO_ROLE_ERROR').Message__c);
					return null;
				}
				
				
				if(atpModel.atpObj.Account__c ==null)
				atpModel.atpObj.Account__c=contentIds;
				
				if(atpModel.atpObj.Team_Role__c == Environment_Variable__c.getinstance('ACCT_TM_PRXY_TM_RL_PAM').value__c || 
						atpModel.atpObj.Team_Role__c == Environment_Variable__c.getinstance('ACCT_TM_PRXY_TM_RL_PCSR').value__c || 
						atpModel.atpObj.Team_Role__c == Environment_Variable__c.getinstance('ACCT_TM_PRXY_TM_RL_BCSR').value__c || 
						atpModel.atpObj.Team_Role__c == Environment_Variable__c.getinstance('ACCT_TM_PRXY_TM_RL_PFTS').value__c){
					if (atpMap.containsKey(atpModel.atpObj.Team_Role__c+atpModel.atpObj.Account__C)){
						
						atpModel.atpObj.addError('Duplicate Role: '+ atpModel.atpObj.Team_Role__c);
						return null;
					} 
					else{
						atpMap.put(atpModel.atpObj.Team_Role__c+atpModel.atpObj.Account__C, atpModel.atpObj);
					}
					
					// Added by ZAmbat, 05162013
				}else if(atpModel.atpObj.Team_Role__c == Environment_Variable__c.getinstance('ACT_TM_PRXY_TM_RL_CE').value__c || 
						atpModel.atpObj.Team_Role__c == Environment_Variable__c.getinstance('ACCT_TM_PRXY_TM_RL_FP').value__c) {
					fabUserIds.add(atpModel.atpObj.User__c);
				}
				
				// added by Tlai 18032014, mark flag when PFTS or BCSR is replaced
				if(atpModel.atpObj.id == null && atpModel.atpObj.Team_Role__c == ACCT_TM_PRXY_TM_RL_PFTS) {
					hasNewPFTS = true;
				}else if(atpModel.atpObj.id == null && atpModel.atpObj.Team_Role__c == ACCT_TM_PRXY_TM_RL_BCSR ){
					hasNewBCSR = true;
				}else if(atpModel.atpObj.id != null && atpModel.atpObj.Team_Role__c != ACCT_TM_PRXY_TM_RL_BCSR && atpModel.oldRole == ACCT_TM_PRXY_TM_RL_BCSR ){
					hasOldBCSR = true;
				}else if(atpModel.atpObj.id != null && atpModel.atpObj.Team_Role__c != ACCT_TM_PRXY_TM_RL_PFTS && atpModel.oldRole == ACCT_TM_PRXY_TM_RL_PFTS ){
					hasOldPFTS = true;
				}
				
				//added by Vijay 05062015 for Internal Account Opportunity access is not required so it is set to Private
				if(String.isBlank(atpModel.atpObj.Opportunity_Access__c) && isInternalAccount){
					atpModel.atpObj.Opportunity_Access__c = 'Private';
				}
				
				//Njain: reset the is FAE flag if the Role is chnaged from Account Manager
				if( atpModel.atpObj != NULL && atpModel.atpObj.Id != NULL && 
						atpModel.atpObj.Team_Role__c != atpModel.oldRole && 
						atpModel.atpObj.Team_Role__c != 'Account Manager' && 
						atpModel.atpObj.Team_Role__c != 'Primary Account Manager'){
					atpModel.atpObj.Is_FAE__c = false;
				}
				
				if(atpModel.atpObj.id == null){
					insertAtpList.add(atpModel.atpObj);
				}
				
				//Tlai 09042014 : added code to update atp only when it is changed
				else if(   atpModel.atpObj.Account_Access__c != atpModel.oldAcctAccess 
						|| atpModel.atpObj.Opportunity_Access__c != atpModel.oldOppAccess 
						|| atpModel.atpObj.Team_Role__c != atpModel.oldRole
						|| atpModel.atpObj.Fab_Assignment__c != atpModel.oldFabAssignment
						|| atpModel.atpObj.Flag_for_Delete__c != atpModel.oldDeleteFlag
						|| atpModel.atpObj.Is_FAE__c != atpModel.oldFAEflag){
					updateAtpList.add(atpModel.atpObj);
				}
			}
		}
		// Added by ZAmbat, 05162013
		if(fabUserIds.size() > 0){
			// Check if these users have Fab Assignment
			map<Id, User> mapUsersNoFab = new map<Id, User>([SELECT Id , Name FROM  User WHERE Id IN :fabUserIds AND (Fab_Assigned__c = '' OR Fab_Assigned__c = null)]);
			
			// Validate the Account Team Proxy members
			if (mapUsersNoFab.size() > 0) {
				list<Account_Team_Proxy__c> atps = new list<Account_Team_Proxy__c>();
				atps.addAll(insertAtpList);
				atps.addAll(updateAtpList);
				for (Account_Team_Proxy__c a : atps) {
					if (mapUsersNoFab.containsKey(a.User__c)) {
						Error_Codes__c ec = Error_Codes__c.getInstance('FAB ASSIGNMENT IS REQUIRED');
						a.addError(ec.Message__c);
						return null;
					}
				}   
			}
			
		}
		try{
			system.debug('New ATP No.:' + insertAtpList.size() + ' Update ATP No.:' + updateAtpList.size());   
			if(insertAtpList.size() > 0){
				// added by Tlai 18032014, mark flag when PFTS or BCSR is replaced
				if((hasNewPFTS && hasOldPFTS) || (hasNewBCSR && hasOldBCSR)){
					AccountTriggerRun.skipATPValidation = true;
				}
				insert insertAtpList;
			}
			
			if(updateAtpList.size() > 0){
				AccountTriggerRun.skipATPValidation = false;
				update updateAtpList;
			}
			Fabdisable=true;
			return acctPage;
		}catch(Exception e){
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getdmlMessage(0));  
			ApexPages.addMessage(myMsg);
		}
		return null;
	}

	public pagereference Cancel(){
		pagereference PRF=new pagereference('/'+contentIds);
		PRF.setRedirect(true);
		return PRF;
	}
	
	public Class ReplaceUserWrapper{
		Public list<Account_Team_Proxy__c> ListAccTeamProxy{get;set;}
		Public list<Opportunity_Program_Team_Member__c> ListOpptyProgramTeamMember{get;set;}
		public ReplaceUserWrapper(list<Account_Team_Proxy__c> AccTeamPro,list<Opportunity_Program_Team_Member__c> OpptyProgTeamMember){
			ListAccTeamProxy=AccTeamPro;
			ListOpptyProgramTeamMember=OpptyProgTeamMember;
		}
	}
	
	Public pagereference SearchAccountTeamProxy(){
		
		ATPUserUpdMap=new Map<Id,Account_Team_Proxy__c>([Select id,user__c,account__r.Primary_CSR__c,account__r.Account_Manager__c,
		user__r.Name,user1__c,Account__c,Team_Role__c,Account_Access__c,
		Opportunity_Access__c from  Account_Team_Proxy__c 
		where user__c=:atpProxObj.user__c limit 50000]);

		NewAccontTeamProxList=ATPUserUpdMap.Values();
		
		if(atpProxObj.user__c==null ){
			atpProxObj.addError(Error_Codes__c.getInstance('ATP_TO_OR_FROM_VALUE_CHECK').Message__c);
			return null;
		}
		if(ATPUserUpdMap.size()>0 && NewAccontTeamProxList.size()>0)
		{
			ConfromUserReplase=false;
			ConfromUser2Replase=true;
		}
		else
		{
			atpProxObj.addError(Error_Codes__c.getInstance('ATP_NO_USER_FOUND').Message__c);
			
		}
		return null;
	}
	
	public pagereference ReplaceUser()
	{
		SearchResult=true;
		ReplaceUserWrapList=new list<ReplaceUserWrapper>();
		
		pagereference PRF;
		List<Account_Team_Proxy__c> lstATP =  new List<Account_Team_Proxy__c>();
		List<Opportunity_Program_Team_Member__c> lstOpptyProgTeamMember =  new List<Opportunity_Program_Team_Member__c>();
		List<Opportunity_Program__Share> lstOpptyProgShare= new List<Opportunity_Program__Share>();
		List<Opportunity_Program__Share> lstOpptyProgShareDel= new List<Opportunity_Program__Share>();
		
		
		
		Map<Id,Opportunity_Program_Team_Member__c> MapOpptyProgTeamMember=new Map<Id,Opportunity_Program_Team_Member__c>([Select id,User__c from Opportunity_Program_Team_Member__c where User__c=:atpProxObj.user__c]);
		Map<Id,Opportunity_Program__Share> MapOpptyProgramShare=new Map<Id,Opportunity_Program__Share>([SELECT ParentId,RowCause,UserOrGroupId,AccessLevel FROM Opportunity_Program__Share where UserOrGroupId=:atpProxObj.user__c]);
		
		if(atpProxObj.user__c==null || atpProxObj.user1__c==null){
			atpProxObj.addError(Error_Codes__c.getInstance('ATP_TO_OR_FROM_VALUE_CHECK').Message__c);
			return null;
		}
		
		if(atpProxObj.user__c==atpProxObj.user1__c){
			atpProxObj.addError(Error_Codes__c.getInstance('ATP_DOES_NOT_HAVE_SAME_VALUE').Message__c);
			return null;
		}
		
		if(ATPUserUpdMap.size()>0 || MapOpptyProgTeamMember.size()>0 || MapOpptyProgramShare.size()>0){
			NewAccontTeamProxList=ATPUserUpdMap.Values();
			for(Account_Team_Proxy__c ATPUPD : ATPUserUpdMap.Values()){
				
				ATPUPD.user__c=atpProxObj.user1__c;
				if(ATPUPD.user__c ==atpProxObj.user1__c && ATPUPD.Team_Role__c==ACCT_TM_PRXY_TM_RL_PAM)
				{
					ATPUPD.account__r.Account_Manager__c=atpProxObj.user1__c;
				}
				if(ATPUPD.user__c ==atpProxObj.user1__c && ATPUPD.Team_Role__c==ACCT_TM_PRXY_TM_RL_PCSR)
				{
					ATPUPD.account__r.Primary_CSR__c=atpProxObj.user1__c;
				}
				lstATP.add(ATPUPD);
				
			}
			for(Opportunity_Program_Team_Member__c OPTProgTeam : MapOpptyProgTeamMember.Values()){
				
				OPTProgTeam.User__c=atpProxObj.user1__c;
				lstOpptyProgTeamMember.add(OPTProgTeam);
			}
			for(Opportunity_Program__Share OppProgramShare : MapOpptyProgramShare.values()){
				
				Opportunity_Program__Share oppShare = new Opportunity_Program__Share();
				oppShare.UserOrGroupId=atpProxObj.user1__c;
				oppShare.AccessLevel = OppProgramShare.AccessLevel ;
				oppShare.ParentId = OppProgramShare.ParentId ;
				oppShare.RowCause = Opportunity_Program__Share.RowCause.Manual;

				
				lstOpptyProgShare.add(oppShare);
				if( OppProgramShare.RowCause !='Owner'  && OppProgramShare.RowCause !='Custom Object Sharing Rule')
				lstOpptyProgShareDel.add(OppProgramShare);
				
				
			}
			if(lstATP.size()>0 || lstOpptyProgTeamMember.size()>0){
				ReplaceUserWrapList.add(new ReplaceUserWrapper(lstATP,lstOpptyProgTeamMember));
			}
			if(ReplaceUserWrapList.size()>0){
				
				Database.SaveResult[] srList;                    
				List<Sobject> tobeUpdated = new List<Sobject>();
				List<Opportunity_Program_Team_Member__c> tobeUpdatedopt = new List<Opportunity_Program_Team_Member__c>();
				List<Account_Team_Proxy__c> tobeUpdatedatp = new List<Account_Team_Proxy__c>();
				for(ReplaceUserWrapper RepUsrWrap : ReplaceUserWrapList){
					tobeUpdatedopt.addall(RepUsrWrap.ListOpptyProgramTeamMember);
					tobeUpdatedatp.addall(RepUsrWrap.ListAccTeamProxy);                        
				}
				tobeUpdated.addAll((List<SObject>)tobeUpdatedopt);
				tobeUpdated.addAll((List<SObject>)tobeUpdatedatp);
				
				
				srList = Database.update(tobeUpdated, false);                       
				
				list<Database.Error> lsterror= new list<Database.Error>();
				for (Database.SaveResult sr : srList) {

					if (sr.isSuccess()) {               
						// Operation was successful, so get the ID of the record that was processed
						
						System.debug('Successfully Updated. User ATP Records: ' + sr.getId());
					}
					
					else {
						
						// Operation failed, so get all errors               
						
						for(Database.Error err : sr.getErrors()) {
							
							System.debug('The following error has occurred.');                   
							
							System.debug(err.getStatusCode() + ': ' + err.getMessage());
							
							System.debug('Account fields that affected this error: ' + err.getFields());
							lsterror.add( err);
							
							
						}
						
						
					}

				}
				
				if(lstOpptyProgShareDel.size()>0)
				{
					delete lstOpptyProgShareDel; 
				}
				if(lstOpptyProgShare.size()>0){
					
					Insert lstOpptyProgShare;
				}
				if(lsterror.size()>0)
				{
					String AdminMail= system.label.Case_Support_email_id;
					string SetReplyTo=system.label.SetReplyTo;
					Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
					mail.setToAddresses(new String[] {AdminMail});
					mail.setReplyTo(SetReplyTo);
					mail.setSenderDisplayName(system.label.SetSubjectATP);
					mail.setSubject(system.label.SetSubjectATP);
					mail.setPlainTextBody('The mail processing encountered following exception:-'+ lsterror);
					Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
				}   
				
				

				ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Error_Codes__c.getInstance('ATP_RECORD_UPDATE').Message__c  );  
				ApexPages.addMessage(myMsg);
				atpProxObj.user__c=null;atpProxObj.user1__c =null;
				
				ConfromUserReplase=true;
				ConfromUser2Replase=false;
				return null;
			}
			PRF=new pagereference('/'+contentIds);
			PRF.setRedirect(true);
		}
		else
		{
			atpProxObj.addError(Error_Codes__c.getInstance('ATP_NO_USER_FOUND').Message__c);
			
		}
		
		return PRF;          
	}
	
}