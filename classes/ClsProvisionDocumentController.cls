/*
Type Name: ClsProvisionDocumentController 
Author: Cognizant 
Created Date: 12-June-2013
Reason: This class is used for provisioning documents.
Change History:
Author: 
Modified Date: 6/12/2013
Reason: To open up the Document Provisioning for Supplier Accounts.
Author: Cognizant Technology Solutions
Modified Date: 12-Dec-2013
Author: Cognizant
Modified Date: 21-Jan-2014
Reason: Fetch users which are already created in OT(Case 00004324)
Author: Cognizant
Modified Date: 26-sep-2014
Reason: Case 34664 
Author: Cognizant
Modified Date: 8-July-2015
Reason:modified for spec provisioning to supplier profile
……..
……..
*/
public class ClsProvisionDocumentController {
    
    /**
        Public Variable Declarations
     **/
     
    public  Map<String,String> mapAccountNames{get;set;}
    public  Map<String,User> mapUserNames{get;set;}
    public  Map<String,List<User>> mapAccountToUsers{get;set;}
    public  Design_Spec__c objDesignSpec{get;set;}  
    public  List<accUserWrapper> lstAccUserWrapper{get;set;}    
    public  Boolean isValidReleaseStatusForProvisioning{get;set;}
    public  Boolean isValidProfile{get;set;}
    public  Boolean isValidTechGeometry{get;set;}
    public  Boolean isValidSpecificationType{get;set;}
    public  Boolean showAddAccounts{get;set;}
    public  Id objDesignSpecId{get;set;}
    public  list<accountwrapper> accountSearchList{get;set;}
    public  Set<String> setSelectedAccountIds{get;set;}
    public  Boolean searchpanel{get;set;}
    public  Boolean editpanel{get;set;}
    public  string searchString{get;set;}
    public  Set<String> setUserIdsDeProvisioned{get;set;}
    private final Map<String, Schema.SObjectType> globalDescribe=Schema.getGlobalDescribe();
    public Map<String, Restricted_Tech_Geometry__c> mapRTG = Restricted_Tech_Geometry__c.getAll();
    public Map<String, Profiles_for_Provisioning__c> mapPFP = Profiles_for_Provisioning__c.getAll();
    string ProfileName;
    
    public Set<String> setUsersAlreadyProvisioned{get;set;}
    public boolean provionsedUser{get;set;} //added by cognizant for Case 34664
    //public  Integer UsersAlreadyProvisionedSize{get;set;}   
    /**
        This is the constructor of the Class
     **/
     
    public ClsProvisionDocumentController(ApexPages.StandardController controller){
        
        Set<Id> setProfileIds = new Set<Id>();
        Set<String> setAccountIds = new Set<String>();
        Set<String> setTempIds = new Set<String>();
        Set<Id> setUserIds = new Set<Id>();
        Set<String> setUserIdsProvisioned = new Set<String>();
        setUserIdsDeProvisioned = new Set<String>();
        setSelectedAccountIds = new Set<String>();
        List<Account> lstAccounts = new List<Account>();
        isValidProfile = false;
        accountSearchList = new list<accountwrapper>();
        editpanel = true;
        searchpanel = false;
        provionsedUser=false; //added by cognizant for Case 34664
        
        setUsersAlreadyProvisioned = new Set<String>();
          //Supplier Changes-001
        ProfileName=[select name from profile where id=:userInfo.getprofileid()].Name;
      
        setProfileIds.addAll(getValidProfiles());
       /* if(setProfileIds!=null && setProfileIds.contains(UserInfo.getProfileId())){
            isValidProfile = true;  
        }
        else{
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'You do not have proper permission for provisioning this design spec.');
            ApexPages.addMessage(myMsg);
        }*/
        
        objDesignSpecId = controller.getId();
        
        if(objDesignSpecId!=null){
            
            objDesignSpec = retrieveSpecInfo(objDesignSpecId);
            
/*--------------------modified for spec provisioning to supplier profile start--------------------------------------------------*/            
            List<PermissionSetAssignment> lstcurrentUserPerSet =   [   SELECT Id, PermissionSet.Name,AssigneeId
                                                                FROM PermissionSetAssignment
                                                                WHERE AssigneeId = :Userinfo.getUserId() and PermissionSet.Name=:label.FV_Permission_to_Provision_Spec];
        
            /*--------------added for ipdk access start--------------------------------------------------*/     
          provionsedUser=getGroup();
          if(((setProfileIds!=null && setProfileIds.contains(UserInfo.getProfileId()))|| !lstcurrentUserPerSet.isempty())  && objDesignSpec.Specification_Type__c!='IP Design Kit' ){
            isValidProfile = true;  
        }
        
        else if(((setProfileIds!=null && setProfileIds.contains(UserInfo.getProfileId())) || provionsedUser==True || !lstcurrentUserPerSet.isempty()) && objDesignSpec.Specification_Type__c=='IP Design Kit'){
            isValidProfile = true; 
/*--------------------modified for spec provisioning to supplier profile end--------------------------------------------------*/             
        }
        else{
            isValidProfile = false;  
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'You do not have proper permission for provisioning this design spec.');
            ApexPages.addMessage(myMsg);
        }  
 
        
    system.debug('isValidProfile $$'+isValidProfile );
    system.debug('isValidReleaseStatusForProvisioning$$'+isValidReleaseStatusForProvisioning);
    system.debug('isValidTechGeometry$$'+isValidTechGeometry);
    system.debug('isValidSpecificationType$$'+isValidSpecificationType);
    
    
 /*--------------added for ipdk access end--------------------------------------------------*/      
            
            isValidTechGeometry = verifyValidTechGeometry(objDesignSpec.Technology_Geometry__c);
            isValidSpecificationType = verifyValidSpecType(objDesignSpec.Specification_Type__c);
            showAddAccounts = showOrHideAddAccounts(objDesignSpec.Release_Status__c);
                
            lstAccUserWrapper = new List<accUserWrapper>();
            mapAccountToUsers = new Map<String,List<User>>();
            setUserIdsProvisioned.addAll(getAllExistingProvisionings(objDesignSpecId));
            setUsersAlreadyProvisioned.addAll(setUserIdsProvisioned);// added by cognizant for the Case 00004324
            
            if(objDesignSpec.Release_Status__c!=null && objDesignSpec.Release_Status__c.contains('White list')){
                setAccountIds.addAll(getAllWhiteListAccountIds(objDesignSpecId));
            }
            /*else if(objDesignSpec.Release_Status__c!=null && objDesignSpec.Release_Status__c.contains('Specific Account Release')){
                setAccountIds.addAll(getProvisionedAccountIds(setUserIdsDeProvisioned));
                
            }*/           
            if(setAccountIds!=null && setAccountIds.size()>0){
                                
                lstAccounts.addAll(getAllAccounts(setAccountIds));
                mapAccountToUsers.putAll(getAllRelatedUsers(setAccountIds,setUserIdsProvisioned));
                                
                for(String accId: setAccountIds){                   
                    if(!mapAccountToUsers.keySet().contains(accId)){                        
                        setTempIds.add(accId);      
                    }
                }
                
                if(setTempIds!=null && setTempIds.size()>0){                    
                    mapAccountToUsers.putAll(getAllNoUsers(setTempIds));                    
                }
                
                if(lstAccounts!=null && lstAccounts.size()>0){                  
                    lstAccUserWrapper.addAll(addUserAccountInfoToWrapper(lstAccounts));                                         
                }
                
                            
            }
 /*-------------------------added by cognizant for Case 34664 start----------------------------*/            
            
            if(objDesignSpec.Is_Latest_Revision__c==false && objDesignSpec.Specification_Type__c=='IP Design Kit' && isValidProfile ==true && isValidReleaseStatusForProvisioning==true && isValidTechGeometry==true && isValidSpecificationType==true)
            {
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.WARNING,'Alert! This is not the Latest Design Kit. Before you proceed, please be aware and understand the business risks involved in provisioning this older revision.');
             ApexPages.addMessage(myMsg);
            }
            
           
            
 /*-------------------------added by cognizant for Case 34664 end----------------------------*/  
          
          
       
       
        }
                               
    }
 /*---------------added by cognizant for Case 34664 start----------------------------------*/
public  Boolean getGroup()
{
 boolean isDSGroup;
 SET<id> SetofUserId=new SET<id>();
 List<GroupMember> lstmember=[Select GroupId,UserOrGroupId from GroupMember where GroupId =:System.label.DS_Group_Id];
 
 system.debug('lstmember$$$'+lstmember);
 
 if(lstmember<>null)
 {
     for(GroupMember objmember:lstmember)
     {
      SetofUserId.add(objmember.UserOrGroupId);
     }
 }
 
 
  system.debug('enter user1'+SetofUserId);
  system.debug('enter user2'+UserInfo.getUserId());
  
   //if(!(SetofUserId.contains(UserInfo.getUserId())) && objDesignSpec.Specification_Type__c=='IP Design Kit')
   if(!(SetofUserId.contains(UserInfo.getUserId())))
   {
   system.debug('enter else$$$');
   isDSGroup=false;
  // ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Only DS Group members/FAE users are allowed to provision iPDK.');
  // ApexPages.addMessage(myMsg);
   }
   else
    
   {
   system.debug('enter if$$$');
   isDSGroup=True;
   }
  
 system.debug('enter isDSGroup'+isDSGroup);
 return isDSGroup;
}
/*---------------added by cognizant for Case 34664 end----------------------------------*/    
       
    
    /**
        This method decides whether the Tech Geometry of the Design Spec record is in Restricted Tech Geometries.

        @method name: verifyValidTechGeometry
        @parameter:   Tech Geometry of the corresponding Design Spec record.
        @return :     True or False depending on whether it's a valid Tech Geometry or not.
     **/
     
    public  Boolean verifyValidTechGeometry(String techGeometry){
        
        Boolean isValid;
        
        if(techGeometry!=null){
            if(mapRTG.keySet().contains(techGeometry)){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'You cannot provision for Restricted Tech Geometries');
                ApexPages.addMessage(myMsg);
                isValid=false;          
            }
            else{
                isValid=true;
            }
        }
        else{
            isValid=true;
        }
        
        return isValid;
    }
    
    /**
        This method decides whether the Specification Type of the Design Spec record is in category.

        @method name: verifyValidSpecType
        @parameter:   Specification Type of the corresponding Design Spec record.
        @return :     True or False depending on whether it's a valid Specification Type for provisioning or not.
     **/
     
    public  Boolean verifyValidSpecType(String specType){
        
        Boolean isValid;
        
        if(specType!=null){
            if(specType=='Stepper Tooling Forms' || specType.contains('Reticle Grade Table')){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'You cannot provision for release category Reticle Grade Tables & Stepper Tooling Forms');
                ApexPages.addMessage(myMsg);
                isValid=false;          
            }
            else{
                isValid=true;
            }
        }
        else{
            isValid=true;
        }
        
        //Supplier Service Changes-005:Start 
        //Suppliers should only be able to provision Other and Technical Specification types
/*--------------------modified for spec provisioning to supplier profile start--------------------------------------------------*/         
        system.debug('UserInfo.getProfileId()$$$'+UserInfo.getProfileId());
        
        system.debug('label.supplierprofileid()$$$'+label.supplierprofileid);
        
        
        system.debug('######'+label.supplierprofileid.contains(UserInfo.getProfileId()));
        
        system.debug('######label.FV_Permission_to_Provision_Spec'+label.FV_Permission_to_Provision_Spec); 
       
        List<PermissionSetAssignment> lstcurrentUserPerSet =    [   SELECT Id, PermissionSet.Name,AssigneeId
                                                                FROM PermissionSetAssignment
                                                                WHERE AssigneeId = :Userinfo.getUserId() and PermissionSet.Name=:label.FV_Permission_to_Provision_Spec];
        
        system.debug('######lstcurrentUserPerSet '+lstcurrentUserPerSet);                                                        
                                                                
        if(objDesignSpec==null && (label.supplierprofileid.contains(UserInfo.getProfileId()) || !lstcurrentUserPerSet.isempty())){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'You cannot provision the related Specification type.');
            ApexPages.addMessage(myMsg);
            isValid=false; 
        }
        else if(objDesignSpec!=null && objDesignSpec.Specification_sub_class__c!='Other Specifications' && objDesignSpec.Specification_sub_class__c!='Technical Specifications' && (label.supplierprofileid.contains(UserInfo.getProfileId()) || !lstcurrentUserPerSet.isempty())){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'You cannot provision the related Specification type.');
            ApexPages.addMessage(myMsg);
            isValid=false; 
            system.debug('profile id:'+UserInfo.getProfileId());
        }
        //Supplier Service Changes-005:End
/*--------------------modified for spec provisioning to supplier profile end--------------------------------------------------*/         
        return isValid;
    }
    
    /**
        This method gets all the existing Provisionings corresponding to a Design Spec in deprovisioned state.

        @method name: getAllExistingProvisionings
        @parameter:   Id of the Design Spec.
        @return :     Set of User Ids to which provisioning information is present but in DeProvisioned state.
     **/
     
    public Set<String> getAllExistingProvisionings(Id specId){
        
        Set<String> setUserIds = new Set<String>();
        
        for(Document_Provisioning__c dp:[Select User__c, Design_Spec__c, Status__c,Final_User_Access__c from Document_Provisioning__c where Design_Spec__c =: specId]){
           /* if(dp.Status__c!='Provisioned' && dp.Status__c!='Sent For Approval'){
                setUserIdsDeProvisioned.add(dp.User__c);    
            }
            
           else {
           
                setUserIds.add(dp.User__c);                
            }   */
            
            if(dp.Status__c=='Provisioned'  || (dp.Status__c=='IPLAProvision' && dp.Final_User_Access__c==true) || (dp.Status__c=='IPLADeprovision' && dp.Final_User_Access__c==true) )
            {
            system.debug('dp.Status__c$$'+dp.Status__c);
                setUserIds.add(dp.User__c);    
            }
            
           else if(dp.Status__c!='Provisioned' && dp.Status__c!='Sent For Approval')
           {
            system.debug('else$$'+dp.Status__c);
             setUserIdsDeProvisioned.add(dp.User__c);                
            }
        }
        return setUserIds;
    }
       
    /**
        This method populates the accUserWrapper records so that the Provisioning information can be displayed on the Provisiong screen.

        @method name: addUserAccountInfoToWrapper
        @parameter:   List of Accounts to be displayed for Provisioning.
        @return :     List of accUserWrapper records to be displayed on page for Provisioning.
     **/
     
    public  List<accUserWrapper> addUserAccountInfoToWrapper(List<Account> lstAcc){
        
        List<accUserWrapper> lstAccWrap = new List<accUserWrapper>();
        
        for(Account acc: lstAcc){
            accUserWrapper objAccUserWrap = new accUserWrapper();
            List<User> lstUser = new List<User>();
            objAccUserWrap.accId = acc.Id;
            objAccUserWrap.accName = acc.Name;
            objAccUserWrap.shortName=acc.Short_Name__c;//added for Case 42841
            objAccUserWrap.accIsChecked = false;
            objAccUserWrap.mapUserIdToChecked = new Map<String, Boolean>();
            objAccUserWrap.Sortedcontactlist= new List<User>();//Cognizant Added on 25/11/2013
            if(mapAccountToUsers!=null && mapAccountToUsers.containsKey(acc.Id)){
                lstUser.addAll(mapAccountToUsers.get(acc.Id));
                objAccUserWrap.lstUserSize = lstUser.size();
                if(lstUser!=null && lstUser.size()>0){
                    for(User objUser: lstUser){
                    
                         if(setUsersAlreadyProvisioned.contains(objUser.Id))
                              objAccUserWrap.mapUserIdToChecked.put(objUser.Id,true);
                                  
                         else
                            objAccUserWrap.mapUserIdToChecked.put(objUser.Id,false);  
                            objAccUserWrap.Sortedcontactlist.add(objUser); //Cognizant Added on 25/11/2013
                                   
                    }       
                } 
                                                 
            }
            objAccUserWrap.Sortedcontactlist.sort();//Cognizant Added on 25/11/2013
            lstAccWrap.add(objAccUserWrap);         
        }
        
        return lstAccWrap;      
    }
    
    /**
        This method retrieves the Set of Valid Profiles corresponding to Provisioning.

        @method name: getValidProfiles
        @parameter:   None.
        @return :     set of Profile Ids of valid Profiles for Provisioning.
     **/
     
    public  Set<Id> getValidProfiles(){
        
        Set<Id> setProfileIds = new Set<Id>();
        
        if(mapPFP!=null && mapPFP.size()>0){
            for(Profile objProfile: [Select Id, Name from Profile where Name IN: mapPFP.KeySet()]){
                 setProfileIds.add(objProfile.Id);
             }
        }
         
        return setProfileIds;
    }
    
    /**
        This method retrieves the Design Spec information.

        @method name: retrieveSpecInfo
        @parameter:   Id of the Design Spec.
        @return :     Design Spec record information.
     **/
     
    public  Design_Spec__c retrieveSpecInfo(Id specId){
        
        Design_Spec__c objDS = new Design_Spec__c();
        
        /*objDS = [Select Id, Name, Document_Number__c, Revision__c, Revision_Release_Date__c, Lifecycle_Phase__c, Location_Fab__c,Specification_Type__c, Technology_Type__c,
                 Technology_Geometry__c, Source__c, Specification_sub_class__c, Release_Status__c from Design_Spec__c
                 where Id =: specId];*///commented by cognizant for case 34664
                 
        objDS = [Select Id, Name, Document_Number__c, Revision__c, Revision_Release_Date__c, Lifecycle_Phase__c, Location_Fab__c,Specification_Type__c, Technology_Type__c,
                 Technology_Geometry__c, Source__c, Specification_sub_class__c, Release_Status__c,Is_Latest_Revision__c  from Design_Spec__c
                 where Id =: specId];//modified by cognizant for case 34664
                 
                 
        return objDS;
            
    }
    
    /**
        This method gets all the Ids of the Accounts corresponding to the White Lists of the Design Spec.

        @method name: getAllWhiteListAccountIds
        @parameter:   Id of the Design Spec.
        @return :     Set of Ids of Accounts corresponding to the White List of the Design Spec.
     **/
     
    public  Set<String> getAllWhiteListAccountIds(String objDSId){
        
        Set<String> setAccIds = new Set<String>();
        
        if(objDSId!=null && objDSId!=''){
            for(White_List__c objWL:[Select Id, Account__c, Design_Spec__c from White_List__c where Design_Spec__c =:objDSId]){
                setAccIds.add(objWL.Account__c);
            }
        }
        
        return setAccIds;
        
    }
    
    /**
        This method gets all the Ids of the Accounts corresponding to the Provisioned Users of the Design Spec.

        @method name: getProvisionedAccountIds
        @parameter:   Set of Ids of the Provisioned Users.
        @return :     Set of Ids of Accounts corresponding to the Provisioned Users.
     **/
     
    public  Set<String> getProvisionedAccountIds(Set<String> setUserIds){
        
        Set<String> setAccIds = new Set<String>();
        
        if(setUserIds!=null && setUserIds.size()>0){
            for(User objUser:[Select Id,Name,Parent_Account_Id__c,Parent_Account_Name__c,Email,Contact_Created_In_Open_Text__c from User where Id IN:setUserIds and Contact_Created_In_Open_Text__c=true]){//modified by cognizant for Case 00004324
                setAccIds.add(objUser.Parent_Account_Id__c);
                setSelectedAccountIds.add(objUser.Parent_Account_Id__c);
            }
        }
        
        return setAccIds;
        
    }
    
    /**
        This method decides whether the Add Account button will be shown or hidden on the Provisioning page.

        @method name: showOrHideAddAccounts
        @parameter:   Release Status of the corresponding Design Spec record.
        @return :     True or False depending on whether the Add Account button needs to be shown or not.
     **/
     
    public  Boolean showOrHideAddAccounts(String releaseStatus){
        
        Boolean showAccounts;
        isValidReleaseStatusForProvisioning = false;    
        
        if(releaseStatus!=null){
            if(releaseStatus.contains('Specific Account Release')){ 
                showAccounts = true;    
            }
            else{
                showAccounts = false;
            }
            if(releaseStatus!='Internal Use Only' && releaseStatus!='General Release'){
                isValidReleaseStatusForProvisioning = true; 
            }
            else{
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'You cannot provision for Release Statuses of General Release or Internal Release');
                ApexPages.addMessage(myMsg);    
            }
        }
        else{
            showAccounts = false;   
        }
        
        return showAccounts;
    }
    
    /**
        This method gets the List of Accounts corresponding to the White List Records of a Design Spec.

        @method name: getAllAccounts
        @parameter:   Set of String of corresponding to the White List Records.
        @return :     List of Account Details.
     **/
     
    public  List<Account> getAllAccounts(Set<String> setAccIds){
        
        List<Account> lstAcc = new List<Account>();
        
        if(setAccIds!=null && setAccIds.size()>0){          
            mapAccountNames = new Map<String, String>();
            for(Account objAcc:[Select Id,Name,Short_Name__c from Account where Id IN:setAccIds]){
                lstAcc.add(objAcc);
                mapAccountNames.put(objAcc.Id,objAcc.Name);             
            }
    
        }
        return lstAcc;
        
    }
    
    /**
        This method gets the Map of Account to Users for those Account with child Portal Users.

        @method name: getAllRelatedUsers
        @parameter:   1. Set of String of Account Ids where provisioning is to be done.
                      2. Set of User Ids already provisioned corresponding to this Account
        @return :     Map of Account Ids to List of Users to be displayed for Provisioning.
     **/
     
    public  Map<String,List<User>> getAllRelatedUsers(Set<String> setAccIds,Set<String> setUserIdsProvisioned){
            
        Map<String,List<User>> mapAccToUsers = new Map<String,List<User>>();
        Set<Id> setUserIds = new Set<Id>();     
        if(setAccIds!=null && setAccIds.size()>0){
            
            mapUserNames = new Map<String,User>();          
            
            mapAccToUsers = new Map<String,List<User>>();
            for(User objUser:[Select Id,Name,Parent_Account_Id__c,Parent_Account_Name__c,Email,Contact_Created_In_Open_Text__c from User where Parent_Account_Id__c IN:setAccIds
            and isActive=true and Contact_Created_In_Open_Text__c=true/*and Id NOT IN: setUserIdsProvisioned*/]){//modified by cognizant for Case 00004324
                
                List<User> tempUserList = new List<User>();
                String accId = objUser.Parent_Account_Id__c;
    
                if(mapAccToUsers!=null){ 
                    if(mapAccToUsers.containsKey(accId)){
                        tempUserList = mapAccToUsers.get(accId) ;
                    }
                    tempUserList.add(objUser);
                    mapAccToUsers.put(accId , tempUserList);
                } 
                
                mapUserNames.put(objUser.Id, objUser);                              
            }
            
            if(setUserIdsDeProvisioned!=null && setUserIdsDeProvisioned.size()>0){
                for(User objUser:[Select Id,Name,Parent_Account_Id__c,Parent_Account_Name__c,Email,Contact_Created_In_Open_Text__c  from User where isActive=true and Id IN: setUserIdsDeProvisioned and Contact_Created_In_Open_Text__c=true]){  //modified by cognizant for Case 00004324                
                    mapUserNames.put(objUser.Id, objUser);                              
                }   
            }
    
        }
        
        return mapAccToUsers;
        
    }
    
    /**
        This method gets the Map of Account to Users for those Account with no Users.

        @method name: getAllNoUsers
        @parameter:   Set of String of Account Ids where provisioning is to be done.
        @return :     Map of Account Ids to List of Users to be displayed for Provisioning.
     **/
         
    public  Map<String,List<User>> getAllNoUsers(Set<String> setAccIds){
                
        Map<String,List<User>> mapAccToUsers = new Map<String,List<User>>();
        
        for(String tempId: setAccIds){                      
            List<User> lstTempUser = new List<User>();
            mapAccToUsers.put(tempId,lstTempUser);          
        }   
            
        return mapAccToUsers;
        
    }
    
    public  void openSearch(){
        
        searchString = null;
        accountSearchList.clear(); 
        editpanel = false;
        searchpanel = true;
       
    }
    
    public  void searchAccount(){               
        
        list<account> accountResult = new list<account>();
        accountSearchList = new list<accountwrapper>();
        
        Group grpEDAGroup = new Group();
        Group grpSupplier = new Group();
        List<GroupMember> grpMemberEDAGroup  = new List<GroupMember>(); 
        List<GroupMember> grpMemberSupplier  = new List<GroupMember>();
        Set<String> setEDAAccountIds = new Set<String>();
        Set<String> setSupplierAccountIds = new Set<String>(); 
        
        for(Group objGroup:[Select Id, Name from Group where name = 'EDA Group' OR name = 'Supplier Users Internal']){
            if(objGroup.Name == 'EDA Group'){
                grpEDAGroup = objGroup; 
            }
        //Supplier Change002-Start
           // else{
             //   grpSupplier = objGroup;
               if(objGroup.Name == 'Supplier Users Internal'){
                grpSupplier = objGroup;
            }   
        }
        //Supplier Change002-End
        grpMemberEDAGroup = [Select Id from GroupMember where GroupId =: grpEDAGroup.Id and UserOrGroupId =: UserInfo.getUserId()];
        grpMemberSupplier = [Select Id from GroupMember where GroupId =: grpSupplier.Id and UserOrGroupId =: UserInfo.getUserId()];
                             
        for(Account acc:[Select Id,Short_Name__c,recordTypeId, Recordtype.Name From Account where (Recordtype.Name = 'Enablement Partner' and 
                        Sub_Type__c = 'EDA Partner') OR (Recordtype.Name = 'Suppliers')]){
            if(acc.Recordtype.Name == 'Suppliers'){
                setSupplierAccountIds.add(acc.Id);
            }
            else{
                setEDAAccountIds.add(acc.Id);
            }
        }
        
        if(searchString != null && searchString != '')
        {  
/*------------------------added for Case  31838 start---------------------------------------------------------------------*/
         searchString=searchString.tolowercase();

/*------------------------added for Case  31838 end---------------------------------------------------------------------*/          
           
            String query = createQueryString('Account','WhiteListFields');  
            //query = query + ' where name like ' + '\'%' + searchString + '%\'';
            
            query = query + ' where (name like ' + '\'%' + searchString + '%\'';
            query = query + ' OR Short_Name__c like ' + '\'%' + searchString + '%\')';
            
            if(setSelectedAccountIds!=null && setSelectedAccountIds.size()>0){
                query = query + ' AND Id NOT IN: setSelectedAccountIds ';   
            } 
            if(grpMemberEDAGroup!=null && grpMemberEDAGroup.size()==0){
                query = query + ' AND Id NOT IN: setEDAAccountIds ';   
            } 
           //Supplier Change 003 - Start            
//            if(grpMemberSupplier!=null && grpMemberSupplier.size()==0){
            if((grpMemberSupplier!=null && grpMemberSupplier.size()==0) && !(profilename.tolowercase().indexof('admin')!=-1 && !(profilename.tolowercase().indexof('portal')!=-1))){
            //Supplier Change 003 - End
                query = query + ' AND Id NOT IN: setSupplierAccountIds ';   
            } 
            //Supplier Change 004 - Start
            if(grpMemberSupplier!=null && grpMemberSupplier.size()>0){
                query = query + ' AND Id IN: setSupplierAccountIds ';
            }
            //Supplier Change 004 - End         
           // query = query + ' order by Name';//commented for Case 42841
           query = query + ' order by Short_Name__c';//added for Case 42841
            System.debug('The querystring is '+query);                                                            
            accountResult = Database.Query(query);                  
        }
        
        else
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Please enter a search string'));
            return;    
        }
        
        if(!accountResult.isEmpty())
        {
            for(account a : accountResult)
            {
                accountSearchList.add(new accountwrapper(false,a));        
            }
        }
        
    }
    
    /**
        This method adds the selected accounts to the Provisioning wrapper list.

        @method name: addSelectedAccounts
        @parameter:   none.
        @return :     none.
     **/
     
    public  void addSelectedAccounts(){
        
        Set<Id> setProfileIds = new Set<Id>();
        Set<String> setTempIds = new Set<String>();
        Set<Id> setUserIds = new Set<Id>();
        Set<String> setUserIdsProvisioned = new Set<String>();
        List<Account> lstAccounts = new List<Account>();
        
        integer accountCount = 0;
        
        if(!accountSearchList.isEmpty()) 
        {
            for(accountWrapper a : accountSearchList)
            {
                if(a.isChecked)
                {
                    lstAccounts.add(a.accountFound);
                    setSelectedAccountIds.add(a.accountFound.Id); 
                    accountCount ++;   
                }
            }
            
            setUserIdsProvisioned.addAll(getAllExistingProvisionings(objDesignSpecId));
            
            setUsersAlreadyProvisioned.addAll(setUserIdsProvisioned);
           // UsersAlreadyProvisionedSize=setUsersAlreadyProvisioned.size();
            mapAccountToUsers.putAll(getAllRelatedUsers(setSelectedAccountIds,setUserIdsProvisioned));
                            
            for(String accId: setSelectedAccountIds){                   
                if(!mapAccountToUsers.keySet().contains(accId)){                        
                    setTempIds.add(accId);      
                }
            }
            
            if(setTempIds!=null && setTempIds.size()>0){                    
                mapAccountToUsers.putAll(getAllNoUsers(setTempIds));                    
            }
            
            if(lstAccounts!=null && lstAccounts.size()>0){                  
                lstAccUserWrapper.addAll(addUserAccountInfoToWrapper(lstAccounts));                                         
            }
            
        }

        if(accountCount == 0)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Please select atleast one account'));
            return; 
        }
        
        else
        {
            accountSearchList.clear();
            searchString = null;
            editpanel = true;
            searchpanel = false;
        }
        
    }
    
    /**
        This method cancels back from the Add Account page.

        @method name: cancelAddAccount
        @parameter:   none.
        @return :     none.
     **/
     
    public  void cancelAddAccount(){
    
        searchstring = null;
        accountSearchList.clear();
        editpanel = true;
        searchpanel = false;
    }
    
    /**
        This method creates the query string for searching on Account object.

        @method name: createQueryString
        @parameter:   1. Name of SObject.
                      2. Name of Field Set.
        @return :     Query string creation.
     **/
     
    public string createQueryString(string sObjectName,string fieldSetName)
    {
        String query = 'SELECT Id';
        Schema.DescribeSObjectResult res=globalDescribe.get(sObjectName).getDescribe();
        Map<String, Schema.FieldSet> fieldSetMap= res.fieldSets.getMap(); 
        Schema.FieldSet fs = fieldSetMap.get(fieldSetName);                        
        
        for(Schema.FieldSetMember fsm : fs.getFields() ) 
        {                                    
            query = query + ',' + fsm.getFieldPath();                                                                  
        }          
        
        query = query + ' from ' + sObjectName;
        
        return query;            
    }
    
    /**
        This method inserts the Document Provisioning records and returns to the detail page of the Design Spec record.

        @method name: insertProvisioningRecords
        @parameter:   None.
        @return :     PageReference to the detail page of the Spec record.
     **/
     
    public PageReference insertProvisioningRecords(){
        PageReference pageRef=null; // Added for 9696

    // Added for 9696
    
    if(lstAccUserWrapper.isEmpty())
    {
        Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.Error,Label.Acc_Req_For_Prov_Msg);
                Apexpages.addmessage(msg);

    }

    else
    {
    if(isCntctProvRequired()){ // Added for 9696
        Map<Id,List<Id>> mapProvisioning = new Map<Id,List<Id>>();
        Map<Id,List<Id>> mapProvisioningUpdates = new Map<Id,List<Id>>();
        Map<String,Boolean> tempProvisioningMap = new Map<String,Boolean>();
        Set<String> setProvisionedUserIds = new Set<String>();
        List<Id> lstUsersToBeProvisioned = new List<Id>();
        List<Id> lstProvisionsToBeUpdated = new List<Id>();
   
        if(lstAccUserWrapper!=null && lstAccUserWrapper.size()>0){
        
            for(accUserWrapper obj:lstAccUserWrapper){
                if(obj.mapUserIdToChecked!=null && obj.mapUserIdToChecked.size()>0){
                    tempProvisioningMap.putAll(obj.mapUserIdToChecked);
                    setProvisionedUserIds.addAll(obj.mapUserIdToChecked.keySet());      
                }
                        
            }
            
            if(setProvisionedUserIds!=null && setProvisionedUserIds.size()>0){
                
                for(String objUserId: setProvisionedUserIds){
                    if(tempProvisioningMap!=null && tempProvisioningMap.containsKey(objUserId)){
                        if(tempProvisioningMap.get(objUserId)){
                            if(setUserIdsDeProvisioned.contains(objUserId)){
                                lstProvisionsToBeUpdated.add(objUserId);        
                            }
                            else{
                                lstUsersToBeProvisioned.add(objUserId);     
                            }                                   
                        }
                    }       
                }
 
                if(lstUsersToBeProvisioned!=null && lstUsersToBeProvisioned.size()>0){
                    mapProvisioning.put(objDesignSpecId,lstUsersToBeProvisioned);
                    
                    if(mapProvisioning!=null && mapProvisioning.size()>0){
                        ClsProvisioningHandler controller = new ClsProvisioningHandler();
                        controller.doProvision(mapProvisioning, 'Spec');
                    }
                    
                }
                
                if(lstProvisionsToBeUpdated!=null && lstProvisionsToBeUpdated.size()>0){
                    mapProvisioningUpdates.put(objDesignSpecId,lstProvisionsToBeUpdated);
                    
                    if(mapProvisioningUpdates!=null && mapProvisioningUpdates.size()>0){
                        ClsProvisioningHandler controller = new ClsProvisioningHandler();
                        controller.doProvisionUpdates(mapProvisioningUpdates, 'Spec');
                    }
                    
                }
                    
            }
            
            
        }
        
        pageRef = new PageReference('/'+objDesignSpecId);  
        } /* Added for 9696 starts*/
    else
        {
            Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.Error,Label.Contact_Req_For_Prov_Msg);
                Apexpages.addmessage(msg);
           
        } 
    }   /* Added for 9696 ends*/
        return pageRef;
        
    }

        /*Added for case 9696 starts*/
    public Boolean isCntctProvRequired(){
    
    Map<String, Boolean> userProvReqMap=new Map<String, Boolean>();
    boolean flagVar=false;
    
    for(ClsProvisionDocumentController.accUserWrapper wrapObj : lstAccUserWrapper)
        {

        for(String usrId : wrapObj.mapUserIdToChecked.keySet())
        {
      if(wrapObj.mapUserIdToChecked.get(usrId) && !setUsersAlreadyProvisioned.contains(usrId))
         
            {
                   
                   flagVar =true;
                   break;
                            
            }

        }
        if(flagVar)
            break;
    }

    return flagVar;

  

    }
    /*Added for case 9696 ends*/  

    
    /***
        Class Name: accUserWrapper
        Type: Inner 
        Use: Wrapper, using to hold the Account and corresponding User records shown on Provisioning Page. 
     ***/
    
    public class accUserWrapper
    {
        public String accId{get;set;}
        public String accName{get;set;}
        public String shortName{get;set;}//added for Case 42841
        public Boolean accIsChecked{get;set;}
        public Map<String, Boolean> mapUserIdToChecked{get;set;}
        public Integer lstUserSize{get;set;}
        public List<User> Sortedcontactlist{get;set;} //Cognizant Added on 25/11/2013
    
    }
    
    /***
        Class Name: accountWrapper
        Type: Inner 
        Use: Wrapper, using to hold the Account Search Results. 
     ***/
     
    public class accountWrapper
    {
        public boolean isChecked{get;set;}
        public account accountFound{get;set;}
        
        public accountWrapper(boolean x,account y)
        {
            isChecked = x;
            accountFound = y;
        }
    }
}