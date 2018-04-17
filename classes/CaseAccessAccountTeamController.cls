/*
Type Name: CaseAccessAccountTeamController 
Author: Cognizant
Created Date: 24th-Mar-2014
Reason: This class is used for assiging case access for Account Team Members.
Test Class: CaseAccessAccountTeamTest
Change History:
Author: 
Modified Date: 
……..
……..
--
*/

public class CaseAccessAccountTeamController {
    
    Map < String, AccountTeamModel > atMap = new Map < String, AccountTeamModel > ();
        
    public List < AccountTeamModel > AccountTeamModelList {get; set;}
    public Set < Id > userIds;
    
    public final string contentIds { get; set;} //Store account Id
    public string AccountName { get; set;}
    
    public Boolean profilePic { get; set; }
    public Boolean isDataFound {get;set; }
    public Boolean isError {get;set; }
    
     /** 
     Wrapper class to hold the value of  Account Share details
     Account Team Members for each  Account
     **/
    public class AccountTeamModel {
        public AccountShare accShare {get; set; }
        
        public String TeamMemberName { get; set;}
        public String TeamRoleName { get; set; }
        public String AccountAccessLevel {get; set;}
        public String OpportunityAccessLevel {get; set;}
        public String ContactAccessLevel {get; set;}
        public String smallphotourl {get;set;}
        
        public Boolean IsDeleted {get;set;}
        
    }
    
    /**
    Constructor of the Class
    @Constructor name: CaseAccessAccountTeamController
    @parameter:   AccountShare StandardController 
    @return :     NA.
    **/
    public CaseAccessAccountTeamController(ApexPages.StandardController controller) {

        profilePic = true;
        isDataFound = false;
        AccountTeamModelList = new List < AccountTeamModel > ();
        atMap = new Map < String, AccountTeamModel > ();
        
        if (ApexPages.currentPage().getParameters().get('aid') != null) {
            contentIds = validateId(ApexPages.currentPage().getParameters().get('aid'));
        }
                
        userIds = New Set < Id > ();
        if (contentIds != null) {
            AccountTeamMemberLoadData(contentIds);
        } else {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Info, System.Label.Case_Access_for_Account_Team_Members_Info);
            ApexPages.addMessage(myMsg);
        }

    }
    
    static public String validateId(String Idparam) {
        String id = String.escapeSingleQuotes(Idparam);
        if ((id.length() == 15 || id.length() == 18) && Pattern.matches('^[a-zA-Z0-9]*$', id) || (id.startsWith('001'))) {
            return id;
        }
        return null;
    }
    
    /**
    This method is used for converting values for Case Access.
    @method name: AccessLevel
    @parameter:   String Case Access Type.
    @return :     String Case Access Type Converted
    **/
    private String AccessLevel(String objAccess) {
        String strAccess;
        if (objAccess == 'Edit') {strAccess = 'Read/Write';} 
        else if (objAccess == 'All') {strAccess = 'Read/Write';} 
        else if (objAccess == 'Read') {strAccess = 'Read Only';} 
        else if (objAccess == 'None') {strAccess = 'Private';} 
        else { strAccess = objAccess;}
        return strAccess;
    }

    /**
    This method is used for fatch data from Account Team Member as per account.
    @method name: AccountTeamMemberLoadData
    @parameter:   String account Id.
    @return :     NA
    **/
    private void AccountTeamMemberLoadData(String contentIds) {
        for (AccountTeamMember accT: [SELECT AccountAccessLevel, AccountId, Account.Name, CreatedById, CreatedDate,
            Id, IsDeleted, TeamMemberRole, UserId, User.Name, User.smallphotourl FROM AccountTeamMember where AccountId = : contentIds
        ]) {
            userIds.add(accT.UserId);
            AccountName = accT.Account.Name;
            AccountTeamModel atMod = new AccountTeamModel();
            atMod.TeamMemberName = accT.User.Name;
            atMod.TeamRoleName = accT.TeamMemberRole;
            atMod.smallphotourl = accT.User.smallphotourl;
            atMap.Put(accT.UserId, atMod);
        }
         system.debug('*******M**A**P**U**S**E*R*'+atMap);
        if (atMap != null && atMap.Size() > 0) {
            for (AccountShare accSha: [select id, AccountAccessLevel, AccountId, CaseAccessLevel, OpportunityAccessLevel, IsDeleted, ContactAccessLevel,
                RowCause, UserOrGroupId from AccountShare
                where AccountId = : contentIds And UserOrGroupId In: userIds And RowCause='Team'
            ]) {
                AccountTeamModel objATM = atMap.get(accSha.UserOrGroupId);
                objATM.AccountAccessLevel = AccessLevel(accSha.AccountAccessLevel);
                objATM.OpportunityAccessLevel = AccessLevel(accSha.OpportunityAccessLevel);
                objATM.ContactAccessLevel = AccessLevel(accSha.ContactAccessLevel);
                objATM.accShare = accSha;
                AccountTeamModelList.add(objATM);
                system.debug('*********A**C***C**O**U**N**T*******'+AccountTeamModelList);
                isDataFound = True;
            }
        } else {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.WARNING, System.Label.Case_Access_for_Account_Team_Members_Warning);
            ApexPages.addMessage(myMsg);
        }

    }

    /**
    This method is used for updating Account Share data as per account.
    @method name: UpdateRecords
    @parameter:   NA.
    @return :     NA.
    **/
    public PageReference UpdateRecords() {

        try {
            List < AccountShare > AccountShareList = New List < AccountShare > ();
            for (AccountTeamModel objacc: AccountTeamModelList) {
                AccountShare accountShare = New AccountShare();
                accountShare.Id = objacc.accShare.Id;
                accountShare.CaseAccessLevel = objacc.accShare.CaseAccessLevel;
                AccountShareList.add(accountShare);
            }

            if (AccountShareList != null && AccountShareList.Size() > 0) {
                update AccountShareList;
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM, System.Label.Case_Access_for_Account_Team_Members_Confirm);
                ApexPages.addMessage(myMsg);
            }
            
        } catch (Exception e) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
            ApexPages.addMessage(myMsg);
        }
        return null;
    }

}