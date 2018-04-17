/*
Type Name: ClsProvisionSubPDKController 
Author: Cognizant 
Created Date: 12-June-2013
Reason: This class is used for provisioning documents.
Change History:
Author: 
Modified Date: 6/12/2013
Reason: Document Provisioning
Change History:
Author: Cognizant 
Modified Date: 11/25/2013
Reason: sorting of users while provisioning
Author: Cognizant
Modified Date: 21-Jan-2014
Reason: Fetch users which are already created in OT(Case 00004324)
……..
……..
*/
public class ClsProvisionSubPDKController{

    public  Map<String,String> mapAccountNames{get;set;}
    public  Map<String,User> mapUserNames{get;set;}
    public  Map<String,List<User>> mapAccountToUsers{get;set;}
    public  Sub_PDK__c objSubPDK{get;set;}  
    public  List<accUserWrapper> lstAccUserWrapper{get;set;}
    public  Boolean isValidReleaseStatusForProvisioning{get;set;}   
    public  Boolean isValidProfile{get;set;}
    public  Boolean isValidTechGeometry{get;set;}
    public  Boolean showAddAccounts{get;set;}
    public  Id objSubPDKId{get;set;}
    public  list<accountwrapper> accountSearchList{get;set;}
    public  Set<String> setSelectedAccountIds{get;set;}
    public  Boolean searchpanel{get;set;}
    public  Boolean editpanel{get;set;}
    public  string searchString{get;set;}
    public  Set<String> setUserIdsDeProvisioned{get;set;}
    private final Map<String, Schema.SObjectType> globalDescribe=Schema.getGlobalDescribe();
    public Map<String, Restricted_Tech_Geometry__c> mapRTG = Restricted_Tech_Geometry__c.getAll();
    public Map<String, Profiles_for_Provisioning__c> mapPFP = Profiles_for_Provisioning__c.getAll();
    /** Restrict from Provisioning Sub PDKs when PDK is Obsolete - Start **/           
    public boolean isNotObsoletePDK{get;set;}
    /** Restrict from Provisioning Sub PDKs when PDK is Obsolete - End **/ 
    
    public Set<String> setUsersAlreadyProvisioned{get;set;}
  //  public  Integer UsersAlreadyProvisionedSize{get;set;} 
    public ClsProvisionSubPDKController(ApexPages.StandardController controller){
        
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
        /** Restrict from Provisioning Sub PDKs when PDK is Obsolete - Start **/
        isNotObsoletePDK = false; 
        
        /** Restrict from Provisioning Sub PDKs when PDK is Obsolete - End **/ 
        
        setUsersAlreadyProvisioned = new Set<String>();
        
        setProfileIds.addAll(getValidProfiles());
        if(setProfileIds!=null && setProfileIds.contains(UserInfo.getProfileId())){
            isValidProfile = true;  
        }
        else{
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'You do not have proper permission for de-provisioning this sub pdk.');
            ApexPages.addMessage(myMsg);
        }
        
        objSubPDKId = controller.getId();
        
        if(objSubPDKId!=null){
            
            objSubPDK = retrieveSubPDKInfo(objSubPDKId);
            
            isValidTechGeometry = verifyValidTechGeometry(objSubPDK.Tech_Geometry__c);
            /** Restrict from Provisioning Sub PDKs when PDK is Obsolete - Start **/
            isNotObsoletePDK = verifyNonObsoleteMasterPDK(objSubPDK.PDK__c);
            /** Restrict from Provisioning Sub PDKs when PDK is Obsolete - End **/
            showAddAccounts = showOrHideAddAccounts(objSubPDK.Release_Status__c);
            setAccountIds.addAll(getAllWhiteListAccountIds(objSubPDKId));   
            lstAccUserWrapper = new List<accUserWrapper>();
            mapAccountToUsers = new Map<String,List<User>>();
            setUserIdsProvisioned.addAll(getAllExistingProvisionings(objSubPDKId));
            
            setUsersAlreadyProvisioned.addall(setUserIdsProvisioned); //added by cognizant for case 00004324
       
            if(objSubPDK.Release_Status__c!=null && objSubPDK.Release_Status__c.contains('White list')){
                setAccountIds.addAll(getAllWhiteListAccountIds(objSubPDKId));
            }

            /*else if(objSubPDK.Release_Status__c!=null && objSubPDK.Release_Status__c.contains('Specific Account Release')){
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




        }
                               
    }
    
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
    
    /** Restrict from Provisioning Sub PDKs when PDK is Obsolete - Start **/
    
    /**
        This method decides whether the PDK is Obsolete or not and restricts Sub PDK Provisioning.

        @method name: verifyNonObsoleteMasterPDK
        @parameter:   Master PDK Id of Sub PDK Record.
        @return :     False or True depending on whether PDK is Obsolete or not.
     **/
     
    public  Boolean verifyNonObsoleteMasterPDK(Id pdkId){
        

        Boolean isValid;
        

        if(pdkId!=null){
            for(PDK__c obj:[Select Id, PDK_Lifecycle_Phase__c from PDK__c where Id=:pdkId]){
                if(obj.PDK_Lifecycle_Phase__c=='Obsolete'){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'You cannot provision for Obsolete Master PDKs');
                    ApexPages.addMessage(myMsg);
                    isValid = false;        
                }

                else{
                    isValid = true;
                }   
            }
        }
        




        return isValid;
    }
    
    /** Restrict from Provisioning Sub PDKs when PDK is Obsolete - End **/
    
    public Set<String> getAllExistingProvisionings(Id subPDKId){
        
        Set<String> setUserIds = new Set<String>();
        
        for(Document_Provisioning__c dp:[Select User__c, Sub_PDK__c, Status__c from Document_Provisioning__c where Sub_PDK__c =: subPDKId]){
            if(dp.Status__c!='Provisioned' && dp.Status__c!='Sent For Approval'){
                setUserIdsDeProvisioned.add(dp.User__c);    
            }
            else{
                setUserIds.add(dp.User__c);                
            }    

        }
        return setUserIds;
    }
    
    
    public  List<accUserWrapper> addUserAccountInfoToWrapper(List<Account> lstAcc){
        
        List<accUserWrapper> lstAccWrap = new List<accUserWrapper>();
        
        for(Account acc: lstAcc){
            accUserWrapper objAccUserWrap = new accUserWrapper();
            List<User> lstUser = new List<User>();
            objAccUserWrap.accId = acc.Id;
            objAccUserWrap.accName = acc.Name;
            objAccUserWrap.accIsChecked = false;
            objAccUserWrap.mapUserIdToChecked = new Map<String, Boolean>();
            objAccUserWrap.Sortedcontactlist= new List<User>();//Cognizant Added on 25/11/2013
            
            if(mapAccountToUsers!=null && mapAccountToUsers.containsKey(acc.Id)){
                lstUser.addAll(mapAccountToUsers.get(acc.Id));
                objAccUserWrap.lstUserSize = lstUser.size();
                if(lstUser!=null && lstUser.size()>0){
                    for(User objUser: lstUser){
                     
                        if(setUsersAlreadyProvisioned.contains(objUser.Id))
                             {
                              objAccUserWrap.mapUserIdToChecked.put(objUser.Id,true);
                              }
                              
                         else  
                         {   
                        objAccUserWrap.mapUserIdToChecked.put(objUser.Id,false);
                        }
                        objAccUserWrap.Sortedcontactlist.add(objuser); //Cognizant Added on 25/11/2013   
                              
                    }  
                      
                } 
              
                                    
            }
            objAccUserWrap.Sortedcontactlist.sort(); //Cognizant Added on 25/11/2013
            lstAccWrap.add(objAccUserWrap);         
        }
        
        return lstAccWrap;      
    }
    
    public  Set<Id> getValidProfiles(){
        
        Set<Id> setProfileIds = new Set<Id>();
        
        if(mapPFP!=null && mapPFP.size()>0){
            for(Profile objProfile: [Select Id, Name from Profile where Name IN: mapPFP.KeySet()]){
                 setProfileIds.add(objProfile.Id);
             }

        }
         
        return setProfileIds;
    }
    
    public  Sub_PDK__c retrieveSubPDKInfo(Id subPDKId){
        
        Sub_PDK__c objSubPDK = new Sub_PDK__c();
        
        objSubPDK = [Select Id, Name, Sub_PDK_Version__c, Sub_PDK_Location_Fab__c, Sub_PDK_Revision_Release_Date__c, Sub_PDK_Lifecycle_Phase__c, 
                 Sub_PDK_Sub_class__c, Technology__c,Tech_Geometry__c, Release_Status__c, PDK__c from Sub_PDK__c
                 where Id =: subPDKId];
                 
        return objSubPDK;
            
    }
    public  Set<String> getAllWhiteListAccountIds(String objSubPDKId){
        
        Set<String> setAccIds = new Set<String>();
        
        if(objSubPDKId!=null && objSubPDKId!=''){
            for(White_List__c objWL:[Select Id, Account__c, Sub_PDK__c from White_List__c where Sub_PDK__c =:objSubPDKId]){
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
    
    public  List<Account> getAllAccounts(Set<String> setAccIds){
        
        List<Account> lstAcc = new List<Account>();
        
        if(setAccIds!=null && setAccIds.size()>0){          
            mapAccountNames = new Map<String, String>();
            for(Account objAcc:[Select Id,Name from Account where Id IN:setAccIds]){
                lstAcc.add(objAcc);
                mapAccountNames.put(objAcc.Id,objAcc.Name);             
            }
    
        }
        return lstAcc;
        
    }
    
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
                for(User objUser:[Select Id,Name,Parent_Account_Id__c,Parent_Account_Name__c,Email,Contact_Created_In_Open_Text__c from User where isActive=true and Id IN: setUserIdsDeProvisioned and Contact_Created_In_Open_Text__c=true]){  //modified by cognizant for Case 00004324                
                    mapUserNames.put(objUser.Id, objUser);                              
                }   
            }


    
        }
        


        return mapAccToUsers;
        

    }
    
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
        
        for(Group objGroup:[Select Id, Name from Group where name = 'EDA Group' OR name = 'Supplier']){
            if(objGroup.Name == 'EDA Group'){
                grpEDAGroup = objGroup; 
            }

            else{
                grpSupplier = objGroup;
            }   

        }
        

        grpMemberEDAGroup = [Select Id from GroupMember where GroupId =: grpEDAGroup.Id and UserOrGroupId =: UserInfo.getUserId()];
        grpMemberSupplier = [Select Id from GroupMember where GroupId =: grpSupplier.Id and UserOrGroupId =: UserInfo.getUserId()];
                             
        for(Account acc:[Select Id, recordTypeId, Recordtype.Name From Account where (Recordtype.Name = 'Enablement Partner' and 
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
            if(grpMemberSupplier!=null && grpMemberSupplier.size()==0){
                query = query + ' AND Id NOT IN: setSupplierAccountIds ';   
            } 
                     
            query = query + ' order by Name';
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
            
            setUserIdsProvisioned.addAll(getAllExistingProvisionings(objSubPDKId));
            
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
    
    public  void cancelAddAccount(){
    
        searchstring = null;
        accountSearchList.clear();
        editpanel = true;
        searchpanel = false;
    }
    
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
    
    public PageReference insertProvisioningRecords(){

      
        PageReference pageRef=null;
    
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
                    mapProvisioning.put(objSubPDKId,lstUsersToBeProvisioned);
                    

                    if(mapProvisioning!=null && mapProvisioning.size()>0){
                        ClsProvisioningHandler controller = new ClsProvisioningHandler();
                        controller.doProvision(mapProvisioning, 'SubPDK');
                    }
                    
                }
                




                if(lstProvisionsToBeUpdated!=null && lstProvisionsToBeUpdated.size()>0){
                    mapProvisioningUpdates.put(objSubPDKId,lstProvisionsToBeUpdated);
                    

                    if(mapProvisioningUpdates!=null && mapProvisioningUpdates.size()>0){
                        ClsProvisioningHandler controller = new ClsProvisioningHandler();
                        //controller.doProvisionUpdates(mapProvisioningUpdates, 'SubPDK'); /* Commented on 10-DEC-2013 */
                        controller.doProvision(mapProvisioningUpdates, 'SubPDK'); /* Added on 10-DEC-2013 */                        
                    }
                    
                }
                    
            }





            
            
        }

        
        pageRef = new PageReference('/'+objSubPDKId); 
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
    
    for(ClsProvisionSubPDKController.accUserWrapper wrapObj : lstAccUserWrapper)
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
    
    public class accUserWrapper
    {
        public String accId{get;set;}
        public String accName{get;set;}
        public Boolean accIsChecked{get;set;}
        public Map<String, Boolean> mapUserIdToChecked{get;set;}
        public Integer lstUserSize{get;set;}
        public List<User> Sortedcontactlist{get;set;}//Cognizant Added on 25/11/2013
    
    }
    
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