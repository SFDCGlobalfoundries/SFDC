/*
Type Name: clsTeamRoomManageMembership 
Author: Cognizant
Created Date: 21-May-2013
Reason: This class is used for adding Team Room Members to Team Room. 
Change History:
Author: Cognizant
Modified Date: 23/9/2014
Modified By: IBM
Reason: To give read/write access to moderators for case # 27650
Author: Cognizant
Modified Date: 23/3/2015
Modified By: Sunita
Reason: To delete multiple users at one go(Case 38937)
……..
……..
*/
public with sharing class clsTeamRoomManageMembership {

    
    
    public with sharing class clsAccountMember{
        public boolean blnSavedRecord{get;set;}
        public String sAccountId{get;set;}
        public String sAccountName {get;set;}
        public String sMemberRole{get;set;}
        public List<Team_Room_Member__c > TRMListforAccount{get;set;}   
    }
    
    public with sharing class clsGroupMember{
        public boolean blnSavedRecord{get;set;}
        public String sGroupId {get;set;}
        public String sGroupName {get;set;}
        public String sMemberRole{get;set;}
        public List<Team_Room_Member__c > TRMListforGroup{get;set;}
    }
    
    private String sTeamRoomId;
    public Boolean blnExternalUser{get;set;}
    public Boolean IsinternalUser{get;set;}
    public ID AccId{get;set;}


    public Boolean deleteflag{get;set;}
    
    public List<clsAccountMember> AccountTeamList{get;set;}
    
    public List<clsGroupMember> GroupMemberList{get;set;}
    
    public List<Team_Room_Member__c> IndividualMemberList{get;set;}
    
    private Map<String,String> AccountIdNameMap=new Map<String,String>();
    private Map<String,String> GroupIdNameMap=new Map<String,String>();
    
    public String sDelRecordId{get;set;}
    Transient private Map<Id,List<GroupMember>> groupMemberMap=new Map<Id,List<GroupMember>>(); 
    
    private Map<Id,List<AccountTeamMember>> AccTeamMemMap=new  Map<Id,List<AccountTeamMember>>();
    
    //Code updated on 09/16/2013
    public Boolean isAddDelMember { get ; set ;} // boolean to  check whether the current user has the permission to add or delete related members
    Profile objProfile=new Profile();
    
    //contructor declared
    public clsTeamRoomManageMembership ()
    {
        isAddDelMember =false;
        sTeamRoomId=apexpages.currentpage().getparameters().get('id');
        blnExternalUser=false;
        objProfile=[Select Name from Profile where id=:Userinfo.getProfileId()];
        //Modified by Sunil Arora for Case # 10023 to add Overage Portal profiles
        if ((objProfile.Name==System.Label.CustomerPortalAdmin) || (objProfile.Name==System.Label.CustomerPortalProfile) || 
            (objProfile.Name==System.Label.OverageCustomerPortalAdmin) || (objProfile.Name==System.Label.OverageCustomerPortalProfile) ||
            (objProfile.Name==System.Label.OverageSupplierPortalProfile) || (objProfile.Name==System.Label.OverageSupplierPortalAdmin) ||
            (objProfile.Name==System.Label.OverageResellerPortalProfile) || (objProfile.Name==System.Label.OverageResellerPortalAdmin) ||
            (objProfile.Name==System.Label.OverageEnablementPartnerPortalProfile) || (objProfile.Name==System.Label.OverageEnablementPartnerPortalAdmin) ||
            (objProfile.Name==System.Label.EnablementPartnerPortalAdmin) || (objProfile.Name==System.Label.EnablementPartnerPortalProfile) || 
            (objProfile.Name==System.Label.ResellerPortalAdmin) || (objProfile.Name==System.Label.ResellerPortalProfile) || 
            (objProfile.Name==System.Label.SupplierPortalAdmin) || (objProfile.Name==System.Label.SupplierPortalProfile)) 
        {
            blnExternalUser=true;       
        }
        
        
        AccountTeamList=new List<clsAccountMember>();
        GroupMemberList=new List<clsGroupMember>();
        IndividualMemberList = new List<Team_Room_Member__c>();

        AccountIdNameMap=new Map<String,String>();
        
        for (Team_Room_Account__c objTeamRoomAccount:[Select Team_Room__c,Account__r.Name,Name,Account__r.Id 
                                                        From Team_Room_Account__c where Team_Room__c=:sTeamRoomId])
        {
            AccountIdNameMap.put(objTeamRoomAccount.Account__r.Id, objTeamRoomAccount.Account__r.Name);                                                     
        }
        if (blnExternalUser==false){
            groupMemberMap=new Map<Id,List<GroupMember>>(); 
            for (Group objGroup: [SELECT Id,Name,RelatedId,Type,(Select Id,
                                                           UserOrGroupId,
                                                           Group.Name,
                                                           GroupId
                                                           from GroupMembers) FROM Group where Type='Regular'])
            {
                
                if (objGroup.GroupMembers.size()>0) {
                    GroupIdNameMap.put(objGroup.Id,objGroup.Name);
                    groupMemberMap.put(objGroup.Id,objGroup.GroupMembers);
                }   
            }
        }
        dataFetch();
        checkUserPermissions();
        Team_Room_Member__c objTeamRoomMem=new Team_Room_Member__c();
        objTeamRoomMem.Team_Room__c=sTeamRoomId;
        IndividualMemberList.add(objTeamRoomMem);
        
        User Userobj=[Select Id,AccountId from User where Id=:UserInfo.getUserId()];
        System.debug('@@@Userobj'+Userobj);
      //  boolean deleteflag=false;
        AccId=Userobj.AccountId;
        System.debug('AccId------->'+AccId);
        for(Team_room_Member__c TRMobj:IndividualMemberList)
        {
        
        if(TRMobj.User__r.AccountId==AccId)
        {
        deleteflag=True;
        }
        else        
        {
        deleteflag=false;
        }

        }


        if (blnExternalUser==false) {
            clsAccountMember objAccountMember=new clsAccountMember();
            AccountTeamList.add(objAccountMember);
            
            clsGroupMember objGroupMember=new clsGroupMember(); 
            GroupMemberList.add(objGroupMember);
        }
    }
 //fetching all the Team Room members for the Team room   
    
    private void dataFetch(){
        
        Map<String,List<Team_Room_Member__c>> AccountMemberMap=new Map<String,List<Team_Room_Member__c>>();
        Map<String,List<Team_Room_Member__c>> TeamGroupMemberMap=new Map<String,List<Team_Room_Member__c>>();
/*------------------------added for view state  error-----------------------------------------*/        
        Map<Id,List<GroupMember>> groupMemberMap=new Map<Id,List<GroupMember>>(); 
        if (blnExternalUser==false){
            groupMemberMap=new Map<Id,List<GroupMember>>(); 
            for (Group objGroup: [SELECT Id,Name,RelatedId,Type,(Select Id,
                                                           UserOrGroupId,
                                                           Group.Name,
                                                           GroupId
                                                           from GroupMembers) FROM Group where Type='Regular'])
            {
                
                if (objGroup.GroupMembers.size()>0) {
                    
                    groupMemberMap.put(objGroup.Id,objGroup.GroupMembers);
                }   
            }
        }
/*------------------------added for view state  error end-----------------------------------------*/         
        List<Team_Room_Member__c> TeamMemberTempList=new List<Team_Room_Member__c>();
        
        for (Team_Room_Member__c objTeamRoomMember: [Select User__c,User__r.UserType,User__r.AccountId,User__r.Name, Team_Room__c, Team_Room_Role__c, Public_Group_Name__c, User_Selected__c,
                                                        Account__c, Account__r.Name From Team_Room_Member__c 
                                                        Where Team_Room__c=: sTeamRoomId Order By User__r.Name DESC])
        {
            TeamMemberTempList=new List<Team_Room_Member__c>();
            if (objTeamRoomMember.Account__c!=null){
                if (AccountMemberMap.containsKey(objTeamRoomMember.Account__c)){
                    TeamMemberTempList=AccountMemberMap.get(objTeamRoomMember.Account__c);
                    TeamMemberTempList.add(objTeamRoomMember);
                }else {
                    TeamMemberTempList.add(objTeamRoomMember);
                }
                AccountMemberMap.put(objTeamRoomMember.Account__c,TeamMemberTempList);
            } else if (objTeamRoomMember.Public_Group_Name__c!=null){
                if (TeamGroupMemberMap.containsKey(objTeamRoomMember.Public_Group_Name__c)){
                    TeamMemberTempList=TeamGroupMemberMap.get(objTeamRoomMember.Public_Group_Name__c);
                    TeamMemberTempList.add(objTeamRoomMember);
                }else {
                    TeamMemberTempList.add(objTeamRoomMember);
                }
                TeamGroupMemberMap.put(objTeamRoomMember.Public_Group_Name__c,TeamMemberTempList);  
            } else{
                if (objTeamRoomMember.Team_Room_Role__c =='Owner') {
                    objTeamRoomMember.Team_Room_Role__c ='Owner';   
                } else if (objTeamRoomMember.Team_Room_Role__c =='Moderator') {
                    objTeamRoomMember.Team_Room_Role__c ='Moderator';   
                } else {
                    objTeamRoomMember.Team_Room_Role__c='Member';
                }
                objTeamRoomMember.User_Selected__c=false;//added by sunita
                IndividualMemberList.add(objTeamRoomMember);
            }           
        }

  
      
        if (blnExternalUser==false) {
            
            AccTeamMemMap=new  Map<Id,List<AccountTeamMember>>();
            List<AccountTeamMember> AccTeamMemberList=new List<AccountTeamMember>(); 
            if (AccountIdNameMap.size()>0){
                for (AccountTeamMember objAccTeamMember:[SELECT UserId,AccountId FROM AccountTeamMember WHERE AccountId IN:AccountIdNameMap.keySet() and User.isActive=true]){ // SOQL Filter 'And UserId.isActive=true' Added by Cognizant on 06052014 for Case-00020275
                    AccTeamMemberList=new List<AccountTeamMember>(); 
                    if(AccTeamMemMap.containsKey(objAccTeamMember.AccountId)){
                        AccTeamMemberList=  AccTeamMemMap.get(objAccTeamMember.AccountId);
                        AccTeamMemberList.add(objAccTeamMember);
                        AccTeamMemMap.put(objAccTeamMember.AccountId,AccTeamMemberList);    
                    }else{
                        AccTeamMemberList.add(objAccTeamMember);
                        AccTeamMemMap.put(objAccTeamMember.AccountId,AccTeamMemberList);                                    
                    }               
                }
            }
            Boolean blnUserExistsTemp=false;
            if (AccountMemberMap!=null){
                clsAccountMember objAccountMember=new clsAccountMember();
                
                for (String sAccountId:AccountMemberMap.keySet()){
                    objAccountMember=new clsAccountMember();
                    objAccountMember.blnSavedRecord=true;
                    objAccountMember.sAccountId=sAccountId;
                    objAccountMember.sAccountName=AccountIdNameMap.get(sAccountId);
                    if (AccountMemberMap.get(sAccountId)[0].Team_Room_Role__c =='Moderator') 
                    {
                        objAccountMember.sMemberRole='Moderator';
                    } else {
                        objAccountMember.sMemberRole='Member';
                    }
                    TeamMemberTempList=new List<Team_Room_Member__c>();
                    AccTeamMemberList=new List<AccountTeamMember>(); 
                    TeamMemberTempList=AccountMemberMap.get(sAccountId);
                    AccTeamMemberList=AccTeamMemMap.get(sAccountId);
                    
                    Team_Room_Member__c objTeamRoomMemTemp=new Team_Room_Member__c();
                    if (AccTeamMemberList.size()>0) {
                        for (AccountTeamMember objAccTeamMem:AccTeamMemberList) {
                            blnUserExistsTemp=false;
                            for (Team_Room_Member__c objTeamRoomMem: TeamMemberTempList){
                                if (String.valueOf(objTeamRoomMem.User__c).equals(String.valueOf(objAccTeamMem.UserId))){
                                    blnUserExistsTemp=true;
                                }
                            }
                            if (blnUserExistsTemp==false){
                                objTeamRoomMemTemp=new Team_Room_Member__c();
                                objTeamRoomMemTemp.Team_Room__c=sTeamRoomId;
                                objTeamRoomMemTemp.Account__c=  sAccountId;
                                objTeamRoomMemTemp.Team_Room_Role__c=objAccountMember.sMemberRole;
                                objTeamRoomMemTemp.User__c=objAccTeamMem.UserId;
                                TeamMemberTempList.add(objTeamRoomMemTemp);
                            }
                        }
                    }
                    objAccountMember.TRMListforAccount=TeamMemberTempList;
                    AccountTeamList.add(objAccountMember);
                }
            }
            
     
            
            if (TeamGroupMemberMap!=null){
                clsGroupMember objGroupMember=new clsGroupMember();
                blnUserExistsTemp=false;
                List<GroupMember> groupMemTempList=new List<GroupMember>(); 
                for (String sGroupId:TeamGroupMemberMap.keySet()){
                    objGroupMember=new clsGroupMember();
                    objGroupMember.blnSavedRecord=true; 
                    objGroupMember.sGroupId=sGroupId;
                    objGroupMember.sGroupName=GroupIdNameMap.get(sGroupId);
                    if (TeamGroupMemberMap.get(sGroupId)[0].Team_Room_Role__c =='Moderator')
                    { 
                        objGroupMember.sMemberRole='Moderator';
                    }else {
                        objGroupMember.sMemberRole='Member';    
                    }
                    TeamMemberTempList=new List<Team_Room_Member__c>();
                    groupMemTempList=new List<GroupMember>();
                    TeamMemberTempList=TeamGroupMemberMap.get(sGroupId);
                    groupMemTempList=groupMemberMap.get(sGroupId);
                    
                    Team_Room_Member__c objTeamRoomMemGroupTemp=new Team_Room_Member__c();
                    if (groupMemTempList.size()>0){
                        for (GroupMember objGrpMem:groupMemTempList){
                            blnUserExistsTemp=false;
                            for (Team_Room_Member__c objTeamRoomMem: TeamMemberTempList){
                                if (String.valueOf(objTeamRoomMem.User__c).equals(String.valueOf(objGrpMem.UserOrGroupId))){
                                    blnUserExistsTemp=true;
                                }       
                            }   
                            if (blnUserExistsTemp==false){
                                String sTUserId=objGrpMem.UserOrGroupId;
                                if (sTUserId.substring(0,3).equals('005')) {
                                    objTeamRoomMemGroupTemp=new Team_Room_Member__c();
                                    objTeamRoomMemGroupTemp.Team_Room__c=sTeamRoomId;
                                    objTeamRoomMemGroupTemp.Public_Group_Name__c=sGroupId;
                                    objTeamRoomMemGroupTemp.Team_Room_Role__c=objGroupMember.sMemberRole;
                                    objTeamRoomMemGroupTemp.User__c=objGrpMem.UserOrGroupId;
                                    TeamMemberTempList.add(objTeamRoomMemGroupTemp);
                                }
                            }
                        }   
                    }
                    
                    objGroupMember.TRMListforGroup=TeamMemberTempList;
                    GroupMemberList.add(objGroupMember);
                }
            }
            
            

        }   
    }
 //populating the member dropdown list   
    public List<SelectOption> MemberRoleList
    {
        get {
            MemberRoleList=new List<Selectoption>();
            MemberRoleList.add(new Selectoption('','--None--'));
            MemberRoleList.add(new Selectoption('Moderator','Moderator'));
            MemberRoleList.add(new Selectoption('Member','Member'));   
            return MemberRoleList;
        }
        
        Set;
    }
 //populating the Account dropdown list     
    public List<SelectOption> AccountList
    {
        get{
            AccountList= new List<SelectOption>();
            AccountList.add(new Selectoption('','--None--'));
            for (String sAccountId: AccountIdNameMap.keySet()){
                AccountList.add(new Selectoption(sAccountId,AccountIdNameMap.get(sAccountId))); 
            }
            return AccountList;
        }
        set{
            
        }
    }
    
  //populating the Group dropdown list  
    public List<SelectOption> PublicGroupList{
        get {
            PublicGroupList=new List<SelectOption>();
            PublicGroupList.add(new Selectoption('','--None--'));
            for (String sGroupId: GroupIdNameMap.keySet()){
                PublicGroupList.add(new Selectoption(sGroupId,GroupIdNameMap.get(sGroupId)));   
            }
            return PublicGroupList; 
        }
        set{
            
        }
    }
//add row for individual user      
    public PageReference addUserRow() {
        Team_Room_Member__c objTRM=new Team_Room_Member__c();
        objTRM.Team_Room__c=sTeamRoomId;
        IndividualMemberList.add(objTRM);
        return null;
    }
    
    //add row for account 
    public PageReference addAccountRow()
    {
        for (clsAccountMember objTempAccountMember:AccountTeamList){
            objTempAccountMember.sAccountName=AccountIdNameMap.get(objTempAccountMember.sAccountId);       
        }
        clsAccountMember ATM =new clsAccountMember();
        AccountTeamList.add(ATM);
        return null;
    }
    
    //add row for group
    public PageReference addGroupRow()
    {
        for (clsGroupMember objTempgroupMember:GroupMemberList){
            objTempgroupMember.sGroupName=GroupIdNameMap.get(objTempgroupMember.sGroupId);       
        }
        clsGroupMember GrpMember =new clsGroupMember ();
        GroupMemberList.add(GrpMember );
        return null;
    }

    //Delete Individual User Record
    public PageReference deleteUser()
    {
        PageReference TRPage = new PageReference('/'+ sTeamRoomId);
        Boolean noMemberforDel =false;//added for Case 38937
        Boolean MaxUserExceeded=false;//added for Case 38937
        try {
           //  List<Team_Room_Member__c> delTeamRoomMemberList=[Select Id from Team_Room_Member__c Where Team_Room__c=:sTeamRoomId and User__c=:sDelRecordId];//commented for case 38937
           List<Team_Room_Member__c> delTeamRoomMemberList=new List<Team_Room_Member__c>();//added for Case 38937
 /*---------------------- added for Case 38937 start-------------------------------------------------*/         
           for(Team_Room_Member__c trmObj :IndividualMemberList)
           {
            if(trmObj.User_Selected__c==true)
            {
            delTeamRoomMemberList.add(trmObj);
            }
           
            
           
           }
            system.debug('delTeamRoomMemberList&&&'+delTeamRoomMemberList);
            system.debug('IndividualMemberList&&&'+IndividualMemberList);
            if(delTeamRoomMemberList.size()>0 && delTeamRoomMemberList.size()<=Integer.valueof(System.label.FV_MaxNumberOfUsersTobeDeletedfromTRM) )
            {
            delete delTeamRoomMemberList;
            }
            else if(delTeamRoomMemberList.size()>Integer.valueof(System.label.FV_MaxNumberOfUsersTobeDeletedfromTRM))
            {
            MaxUserExceeded=true;
            
            }
            else if(delTeamRoomMemberList.size()==0)
            {
            noMemberforDel =true;
            
            }
 /*---------------------- added for Case 38937 end-------------------------------------------------*/                 
            //dataFetch();
            
        } catch(Exception ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,ex.getMessage())); 
        }
        //return null;
 /*---------------------- added for Case 38937 start-------------------------------------------------*/           
        
        if(noMemberforDel==true)
        {
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Select at least one checkbox to delete user'));        
         return null;       
        }
        else if(MaxUserExceeded==true)
        {
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Can not delete more than 30 users at a time'));        
         return null;  
        }
        else
        {
        return TRPage;
        }
        
  /*---------------------- added for Case 38937 end-------------------------------------------------*/          
    }
    
   //Delete an Account Record 
    public PageReference deleteAccount()
    {
        PageReference TRPage = new PageReference('/'+ sTeamRoomId);
        try {
            List<Team_Room_Member__c> delTeamRoomMemberList=[Select Id,User_Selected__c from Team_Room_Member__c Where Team_Room__c=:sTeamRoomId and Account__c=:sDelRecordId];
            delete delTeamRoomMemberList;
            //dataFetch();
        } catch(Exception ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,ex.getMessage())); 
        }
        //return null;
        return TRPage;
    }
 //Delete Group Record    
    public PageReference deleteGroup()
    {
        PageReference TRPage = new PageReference('/'+ sTeamRoomId);
        try {
            List<Team_Room_Member__c> delTeamRoomMemberList=[Select Id,User_Selected__c from Team_Room_Member__c Where Team_Room__c=:sTeamRoomId and Public_Group_Name__c=:sDelRecordId];
            delete delTeamRoomMemberList;
            //dataFetch();
        } catch(Exception ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,ex.getMessage())); 
        }
        //return null;
        return TRPage;
    }
  //Cancel button   
    public PageReference Cancel(){
        PageReference TRPage = new PageReference('/'+ sTeamRoomId);
        return TRPage;  
    }
 
    
    public PageReference Save(){
        try{
            PageReference TRPage = new PageReference('/'+ sTeamRoomId);
            List<Team_Room_Member__c> ActIndividualUserList=new List<Team_Room_Member__c>();
            List<Team_Room_Member__c> TeamRoomAccMemberList = new List<Team_Room_Member__c>();
            List<Team_Room_Member__c> TeamRoomGroupMemberList = new List<Team_Room_Member__c>();
            
            Boolean blnDuplicateUser=false;
            Boolean blnNonAccountUser=false;
            Boolean blnDuplicateAccount=false;
            Boolean blnMissingAccountRole=false;
            Boolean blnDuplicateGroup=false;
            Boolean blnMissingGroupRole=false;
            IsinternalUser=false;
            
/*----------------------------view state------------------------------------------------*/  

          Map<Id,List<GroupMember>> groupMemberMap =new Map<Id,List<GroupMember>>(); 
            if (blnExternalUser==false){
            groupMemberMap=new Map<Id,List<GroupMember>>(); 
            for (Group objGroup: [SELECT Id,Name,RelatedId,Type,(Select Id,
                                                           UserOrGroupId,
                                                           Group.Name,
                                                           GroupId
                                                           from GroupMembers) FROM Group where Type='Regular'])
            {
                
                if (objGroup.GroupMembers.size()>0) {
                    
                    groupMemberMap.put(objGroup.Id,objGroup.GroupMembers);
                }   
            }
        }
        
/*----------------------------view state------------------------------------------------*/             
            Map<Id,Team_Room_Member__c> selectedUserIdMap=new Map<Id,Team_Room_Member__c>();
            for (Team_Room_Member__c objTeamRoomMember: IndividualMemberList){
                if (selectedUserIdMap.containsKey(objTeamRoomMember.User__c)){
                    blnDuplicateUser=true;  
                    break;
                }else{
                    selectedUserIdMap.put(objTeamRoomMember.User__c,objTeamRoomMember); 
                }       
            }
 //Displaying error message when duplicate user is selected           
            if (blnDuplicateUser){
                //System.debug('$$$$$$$$$$$$$$$$$$$ Duplicate User');
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Duplicate User added. Please remove the duplicate user')); 
            }
            
          
            if (blnDuplicateUser==false) {
                
                List<User> userList=[SELECT Id,AccountId, UserType FROM User WHERE Id IN:selectedUserIdMap.keyset()];
                
                
                Team_Room_Member__c objTeamRoomMemberTemp=new Team_Room_Member__c();
               if(blnExternalUser==false)
               {
                for (User objUser:userList){
                    objTeamRoomMemberTemp=new Team_Room_Member__c();
                    objTeamRoomMemberTemp=selectedUserIdMap.get(objUser.Id);
//check if the user is internal user                  
                    if (objUser.UserType.equals('Standard')){
                    
                    
 // setting the Team room member role when role selected is moderator
                        if (objTeamRoomMemberTemp.Team_Room_Role__c=='Owner') {
                            objTeamRoomMemberTemp.Team_Room_Role__c='Owner';
                        } else if (objTeamRoomMemberTemp.Team_Room_Role__c=='Moderator') {
                            objTeamRoomMemberTemp.Team_Room_Role__c='Moderator';
                        } else {
// setting the Team room member role when role selected is member
                            objTeamRoomMemberTemp.Team_Room_Role__c='Internal Member';
                        }
                        selectedUserIdMap.put(objUser.Id,objTeamRoomMemberTemp);
                    } else {
 // setting the Team room member role when role selected is moderator or member for external user                 
                        //System.debug('$$$$$$$$$$$$$$$$$ Account Id :' + objUser.Contact.AccountId);
                        if (AccountIdNameMap.containskey(objUser.AccountId)) {
                        
                         system.debug('@@@AccountIdNameMap.containskey');
                            if (objTeamRoomMemberTemp.Team_Room_Role__c=='Moderator') {
                            
                               system.debug('@@@moderator');
                                objTeamRoomMemberTemp.Team_Room_Role__c='Moderator';
                            } else {
                            
                             system.debug('@@@External');
                                objTeamRoomMemberTemp.Team_Room_Role__c='External Member';
                            }       
                            selectedUserIdMap.put(objUser.Id,objTeamRoomMemberTemp);
                        } else {
                        
                            
                            blnNonAccountUser=true;
                            
                            system.debug('@@@blnNonAccountUser');
                            break;  
                        }
                    }                   
                }
                }
                
 /*----------when logged in user is external user----------------------------------------------------*/               
                else if (blnExternalUser==True) 
                {
                
                  system.debug('@@blnExternalUser');
                    for (User objUser:userList)
                    {
                    
                       system.debug('@@enter for');
                        objTeamRoomMemberTemp=new Team_Room_Member__c();
                        objTeamRoomMemberTemp=selectedUserIdMap.get(objUser.Id);
    //check if the user is internal user                  
                        if (objUser.UserType.equals('Standard') && objTeamRoomMemberTemp.Id==null)
                        {
                        
                           system.debug('@@Standard');
                            IsinternalUser=True;
                            break;  
                            
                         }   
                        else if(objUser.UserType!='Standard' && objTeamRoomMemberTemp.Id==null)
                         {
                           system.debug('@@notStandard');
                          if(objUser.AccountId==AccId)
                          {
                           if (objTeamRoomMemberTemp.Team_Room_Role__c=='Moderator') 
                           {
                            objTeamRoomMemberTemp.Team_Room_Role__c='Moderator';
                            } 
                            else 
                            {

                            objTeamRoomMemberTemp.Team_Room_Role__c='External Member';
                            }
                          
                          }
                          else
                          {
                          system.debug('@@final else');
                          IsinternalUser=True;
                          break;
                          }
                          
                          
                         }
                    
                    }
                    
                    
                  }  
                
           system.debug('@@IsinternalUser'+IsinternalUser);
                
 /*---------------------------------------------------------------------------------------------------------------------*/               
 //displaying error message when user sel;ected is not the member of associated account               
                if (blnNonAccountUser || IsinternalUser){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'User is not a member of the associated accounts'));        
                }
                
 
                if (blnNonAccountUser==false && IsinternalUser==false){
                    
                    ActIndividualUserList=selectedUserIdMap.values();
                    
                    if (blnExternalUser==false) {
                        //Account Team save Logic
                        Map<Id,String> AccountDupCheckMap=new Map<Id,String>();
                        
                        for (clsAccountMember objAccMem: AccountTeamList){
                            if (objAccMem.sMemberRole==''){
                                blnMissingAccountRole=true;
                                break;      
                            }
                            if (AccountDupCheckMap.containsKey(objAccMem.sAccountId)){
                                blnDuplicateAccount=true;   
                                break;
                            }else{
                                AccountDupCheckMap.put(objAccMem.sAccountId,objAccMem.sAccountName);    
                            }
                        }
  //displaying error message when duplicate account is selected                      
                        if (blnDuplicateAccount){
                            //System.debug('$$$$$$$$$$$$$$$$$$$ Duplicate User');
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Duplicate Account added. Please remove the duplicate Account'));   
                        }
                        if (blnMissingAccountRole){
                            //System.debug('$$$$$$$$$$$$$$$$$$$ Duplicate User');
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please provide a role for account team members'));
                        }
                        if (blnDuplicateAccount==false && blnMissingAccountRole==false) {
                            
                            List<Team_Room_Member__c> tempTeamRoomMemList = new List<Team_Room_Member__c>();
                            Team_Room_Member__c objTeamRoomMemTemp=new Team_Room_Member__c();
                            for (clsAccountMember objAccMem: AccountTeamList){
                                tempTeamRoomMemList = new List<Team_Room_Member__c>();
                                //System.debug('&&&&&&&&&&&&&&&& Saved Record:' + objAccMem.blnSavedRecord);
                                if (objAccMem.blnSavedRecord==null){
                                    if (objAccMem.sAccountId!=null){
                                        for (AccountTeamMember objAccTeamMem:AccTeamMemMap.get(objAccMem.sAccountId)) {
                                            objTeamRoomMemTemp=new Team_Room_Member__c();
                                            objTeamRoomMemTemp.Team_Room__c=sTeamRoomId;
                                            objTeamRoomMemTemp.Account__c=  objAccMem.sAccountId;
                                            objTeamRoomMemTemp.Team_Room_Role__c=objAccMem.sMemberRole;
                                            objTeamRoomMemTemp.User__c=objAccTeamMem.UserId;
                                            tempTeamRoomMemList.add(objTeamRoomMemTemp);    
                                        }
                                    }
                                }else if (objAccMem.blnSavedRecord){
                                    
                                    tempTeamRoomMemList=objAccMem.TRMListforAccount;
                                    for (Team_Room_Member__c objTmpTeamRoomMem : tempTeamRoomMemList){
                                        objTmpTeamRoomMem.Team_Room_Role__c=objAccMem.sMemberRole;      
                                    }
                                }
    //adding the team members of all the account selected in a list                            
                                TeamRoomAccMemberList.addAll(tempTeamRoomMemList);
                            }
                            
                            //Group Duplicacy Check
                            Map<Id,String> GroupDupCheckMap=new Map<Id,String>();
                            
                            for (clsGroupMember objGrpMem: GroupMemberList){
                                if (objGrpMem.sMemberRole==''){
                                    blnMissingGroupRole=true;
                                    break;      
                                }
                                if (GroupDupCheckMap.containsKey(objGrpMem.sGroupId)){
                                    blnDuplicateGroup=true; 
                                    break;
                                }else{
                                    GroupDupCheckMap.put(objGrpMem.sGroupId,objGrpMem.sGroupName);  
                                }
                            }
                            if (blnDuplicateGroup){
                                //System.debug('$$$$$$$$$$$$$$$$$$$ Duplicate User');
                                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Duplicate Group added. Please remove the duplicate Group'));   
                            }
                            if (blnMissingGroupRole){
                                //System.debug('$$$$$$$$$$$$$$$$$$$ Duplicate User');
                                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please provide a role for account team members'));
                            }
                            if (blnDuplicateGroup==false && blnMissingGroupRole==false) {
                                //Public Group save Logic
                                
                                tempTeamRoomMemList = new List<Team_Room_Member__c>();
                                objTeamRoomMemTemp=new Team_Room_Member__c();
                                for (clsGroupMember objGroupMem: GroupMemberList){
                                    tempTeamRoomMemList = new List<Team_Room_Member__c>();
                                    if (objGroupMem.blnSavedRecord==null){
                                        if (objGroupMem.sGroupId!=null){    
                                            for (GroupMember objGrpTeamMem:groupMemberMap.get(objGroupMem.sGroupId)) {
                                                String sTUserId=objGrpTeamMem.UserOrGroupId;
          //checking the group selected contains only users                                      
                                                if (sTUserId.substring(0,3).equals('005')) {
                                                    objTeamRoomMemTemp=new Team_Room_Member__c();
                                                    objTeamRoomMemTemp.Team_Room__c=sTeamRoomId;
                                                    objTeamRoomMemTemp.Public_Group_Name__c=objGroupMem.sGroupId;
                                                    objTeamRoomMemTemp.Team_Room_Role__c=objGroupMem.sMemberRole;
                                                    objTeamRoomMemTemp.User__c=sTUserId;
                                                }
                                                tempTeamRoomMemList.add(objTeamRoomMemTemp);    
                                            }
                                        }
                                    }else if (objGroupMem.blnSavedRecord){
                                        
                                        tempTeamRoomMemList=objGroupMem.TRMListforGroup;    
                                        for (Team_Room_Member__c objTmpTeamRoomMem : tempTeamRoomMemList){
                                            objTmpTeamRoomMem.Team_Room_Role__c=objGroupMem.sMemberRole;        
                                        }
                                        
                                    }
    //adding all the members of the group in a list                                
                                    if (tempTeamRoomMemList.size()>0){
                                        TeamRoomGroupMemberList.addAll(tempTeamRoomMemList);
                                    }
                                }
                            }//End of blnDuplicate=false Loop
                        }//End of blnDuplicateAccount=false Loop
                        
                    }//End of blnExternalUser=false
                    
                }//End of blnNonAccountUser=false Loop
            }//End of blnDuplicateUser=false Loop
            if(IsinternalUser==false)
            {
            if ((blnDuplicateUser) || (blnNonAccountUser) || (blnDuplicateAccount) || (blnMissingAccountRole) || 
                    (blnDuplicateGroup) || (blnMissingGroupRole)) {
                return null;
            }else {
                Map<Id,Team_Room_Member__c> upsertableUserMap=new Map<Id,Team_Room_Member__c>();
                List<Team_Room_Member__c> upsertableUserList=new List<Team_Room_Member__c>();
                for (Team_Room_Member__c objUpsertTeamMember: ActIndividualUserList){
                    if (objUpsertTeamMember.User__c!=null){
                        if (upsertableUserMap.containsKey(objUpsertTeamMember.User__c)==false){
                            upsertableUserMap.put(objUpsertTeamMember.User__c,objUpsertTeamMember); 
                        }
                      
                    }
                }
                
                if (blnExternalUser==false) {
                    Team_Room_Member__c objMapMember=new Team_Room_Member__c();
                    for (Team_Room_Member__c objUpsertTeamMember: TeamRoomAccMemberList){
                        objMapMember=new Team_Room_Member__c();    
                        if (objUpsertTeamMember.User__c!=null){
                            if (upsertableUserMap.containsKey(objUpsertTeamMember.User__c)==false){
                             system.debug('@@enter false of acc');
                              system.debug('@@objUpsertTeamMember.Id'+objUpsertTeamMember.Id);
                                upsertableUserMap.put(objUpsertTeamMember.User__c,objUpsertTeamMember);         
                            } else if (upsertableUserMap.containsKey(objUpsertTeamMember.User__c)==true) {
                                objMapMember=upsertableUserMap.get(objUpsertTeamMember.User__c);
                                if ((objMapMember.Id==null) && (objUpsertTeamMember.Id==null)){
                                
                                 
                                    //do nothing
                                }else if ((objMapMember.Id!=null) && (objUpsertTeamMember.Id==null)){
                                    
                                    if(objMapMember.Team_Room_Role__c=='Owner')
                                    {
                                    objMapMember.Team_Room_Role__c='Owner';
                                    }
                                    else if(objMapMember.Team_Room_Role__c=='Moderator')
                                    {
                                    objMapMember.Team_Room_Role__c='Moderator';
                                    }
                                    else if(objMapMember.Team_Room_Role__c.contains('Member') && objUpsertTeamMember.Team_Room_Role__c=='Moderator')
                                    {
                                    objMapMember.Team_Room_Role__c='Moderator';
                                    
                                    }
                                    else if(objMapMember.Team_Room_Role__c.contains('Member') && objUpsertTeamMember.Team_Room_Role__c.contains('Member'))
                                    {
                                        /* if (objMapMember.User__r.UserType.equals('Standard'))
                                         {
                                         objMapMember.Team_Room_Role__c='Internal Member';
                                         }
                                         else
                                         {
                                         objMapMember.Team_Room_Role__c='External Member';
                                         }*/
                                          objMapMember.Team_Room_Role__c='Member';
                                     }
                                    
                                    upsertableUserMap.put(objUpsertTeamMember.User__c,objMapMember);                        
                                } else if ((objMapMember.Id==null) && (objUpsertTeamMember.Id!=null)){
                                    
                                  if(objUpsertTeamMember.Team_Room_Role__c=='Moderator' || objMapMember.Team_Room_Role__c=='Moderator' )
                                    {
                                    
                                    objUpsertTeamMember.Team_Room_Role__c='Moderator';
                                    objUpsertTeamMember.Account__c=null;
                                    }
                                  
                                    upsertableUserMap.put(objUpsertTeamMember.User__c,objUpsertTeamMember);         
                                }
                               
                            }
                        }
                    }
                    
                    
                    
                    objMapMember=new Team_Room_Member__c();
                    for (Team_Room_Member__c objUpsertTeamMember: TeamRoomGroupMemberList){
                        objMapMember=new Team_Room_Member__c();    
                        if (objUpsertTeamMember.User__c!=null){
                            if (upsertableUserMap.containsKey(objUpsertTeamMember.User__c)==false){
                              
                                upsertableUserMap.put(objUpsertTeamMember.User__c,objUpsertTeamMember);         
                            }
                            else if (upsertableUserMap.containsKey(objUpsertTeamMember.User__c)==true) 
                            
                            {
                                objMapMember=upsertableUserMap.get(objUpsertTeamMember.User__c);
                                if ((objMapMember.Id==null) && (objUpsertTeamMember.Id==null))
                                {
                                
                                 
                                    //do nothing
                                }
                                else if ((objMapMember.Id!=null) && (objUpsertTeamMember.Id==null))
                                {
                                
                                 if(objMapMember.Team_Room_Role__c=='Owner')
                                    {
                                    objMapMember.Team_Room_Role__c='Owner';
                                    }
                                    else if(objMapMember.Team_Room_Role__c=='Moderator')
                                    {
                                    objMapMember.Team_Room_Role__c='Moderator';
                                    }
                                    else if(objMapMember.Team_Room_Role__c.contains('Member') && objUpsertTeamMember.Team_Room_Role__c=='Moderator')
                                    {
                                    objMapMember.Team_Room_Role__c='Moderator';
                                    }
                                    else if(objMapMember.Team_Room_Role__c.contains('Member') && objUpsertTeamMember.Team_Room_Role__c.contains('Member'))
                                    {
                                        /* if (objMapMember.User__r.UserType.equals('Standard'))
                                         {
                                         objMapMember.Team_Room_Role__c='Internal Member';
                                         }
                                         else
                                         {
                                         objMapMember.Team_Room_Role__c='External Member';
                                         }*/
                                         objMapMember.Team_Room_Role__c='Member';
                                     }
                                
                                
                                upsertableUserMap.put(objUpsertTeamMember.User__c,objMapMember);   
                                }
                                
                               else if ((objMapMember.Id==null) && (objUpsertTeamMember.Id!=null))
                                {
                                 if(objUpsertTeamMember.Team_Room_Role__c=='Moderator' || objMapMember.Team_Room_Role__c=='Moderator' )
                                    {
                                    
                                    objUpsertTeamMember.Team_Room_Role__c='Moderator';
                                     objUpsertTeamMember.Public_Group_Name__c='';
                                    }
                                  
                                upsertableUserMap.put(objUpsertTeamMember.User__c,objUpsertTeamMember); 
                                 
                                 }
                            }
                        }   
                    }
                 } 
                
                if (upsertableUserMap.size()>0){
                    System.debug('%%%%%%%%%%%%%%%%%% Key Data: '+ upsertableUserMap.keySet());
                    Team_Room_Member__c objTeamRoomMemberTemp=new Team_Room_Member__c();
                    List<User> userList=[SELECT Id,AccountId, UserType FROM User WHERE Id IN:upsertableUserMap.keyset()];
                    for (User objUser:userList){
                        objTeamRoomMemberTemp=new Team_Room_Member__c();
                        objTeamRoomMemberTemp=upsertableUserMap.get(objUser.Id);
                        if (objUser.UserType.equals('Standard')){
                            if (objTeamRoomMemberTemp.Team_Room_Role__c=='Owner') {
                                objTeamRoomMemberTemp.Team_Room_Role__c='Owner';
                            } else if (objTeamRoomMemberTemp.Team_Room_Role__c=='Moderator') {
                                objTeamRoomMemberTemp.Team_Room_Role__c='Moderator';
                                objTeamRoomMemberTemp.Access__c='Read/Write';//added by Sunil Arora for case # 27650
                            } else {
                                objTeamRoomMemberTemp.Team_Room_Role__c='Internal Member';
                            }
                            upsertableUserMap.put(objUser.Id,objTeamRoomMemberTemp);
                        } else {
                            if (objTeamRoomMemberTemp.Team_Room_Role__c=='Moderator') {
                                objTeamRoomMemberTemp.Team_Room_Role__c='Moderator';
                                objTeamRoomMemberTemp.Access__c='Read/Write';//added by Sunil Arora for case # 27650
                            } else {
                                objTeamRoomMemberTemp.Team_Room_Role__c='External Member';
                            }       
                            upsertableUserMap.put(objUser.Id,objTeamRoomMemberTemp);
                        }                   
                    }
   //upsert is total member list selected  
                    System.debug('%%%%%%%%%%%%%%%%%% Map:' + upsertableUserMap);
                    upsertableUserList=upsertableUserMap.values();
                    System.debug('%%%%%%%%%%%%%%%%%% Data:' + upsertableUserList);
                    upsert upsertableUserList;
                    
                }
                
                return TRPage;
            }
            
            }
            
        }catch(DMLException ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getDMLMessage(0)));  
            return null;
        }
        catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));  
            return null;
        }
        return null;
    }
    
        /**
        This method is used to check whether the current user has the permission to add or delete related members
        
        @method name: checkUserPermissions
        @parameter:   none
        @return :     none
    **/
    private void checkUserPermissions(){
        
        
        //check if the current user is the owner of the team room 
        Team_Room__c objTeamRoom=[Select OwnerId, (Select User__c,Team_Room_Role__c From Team_Room_Members__r) From Team_Room__c where id=:sTeamRoomId];
        System.debug('1');
        if(objTeamRoom.OwnerId==UserInfo.getUserId()){
            System.debug('2');
            isAddDelMember=true;
            System.debug('3');
        }else{
            System.debug('4');
            //else check if the current user is a system administrator
            //for(Profile p:[Select Id from Profile where Name='System Administrator' OR Name='GF Global Admin' OR Name='GF System Admin' OR Name='GF Training Admin' OR Name='GF Regional Admin']){
                //if(UserInfo.getProfileId()==p.Id){
            if(objProfile.Name=='System Administrator' || objProfile.Name=='GF Global Admin' || objProfile.Name=='GF System Admin' || objProfile.Name=='GF Training Admin' || objProfile.Name=='GF Regional Admin'){
                System.debug('5');
                isAddDelMember=true;
                System.debug('6');
            }
            System.debug('7');
        }
        System.debug('8');
        //else check if the current user is a moderator
        if(!isAddDelMember){
            System.debug('9');
            for(Team_Room_Member__c trm:objTeamRoom.Team_Room_Members__r){
                System.debug('10');
                if(trm.User__c==UserInfo.getUserId() && trm.Team_Room_Role__c=='Moderator'){
                    System.debug('11');
                    isAddDelMember=true;
                    System.debug('12');
                }
                System.debug('13');
            }
            System.debug('14');
        }
        System.debug('15');
    }
}