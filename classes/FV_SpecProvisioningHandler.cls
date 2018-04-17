/*
* @ Author :- Kunal Patil
* @ Company :- CTS
* @ Description :- Class help to provision Specification
* @ Date :- 31/03/2015
* @ History :- 
* @ History :- Sandesh 05/02/2018
    Changes regarding CHG0046457
*   New Methods created
    1) hideRegionJustification : to hide and display Back-end Section Region & justification
    2) allRegion : create region which can show on Back-end section as a drop down
    3) sendEmailToRegionUsers : decides the email sent to users which users
    4) validateAAPExistForDP : decides whether the email send back-end requestor or not
*   --> Method "Search Account" : Added logic to remove supplier from search list 
*   --> Method "DoProvision" : Added logic to assign value for Back-end request & called sendEmailToRegionUsers method to send email after DP create
*   --> Method "updateDeProvisionedDp" : update old record type with new "IP DK Record Type" if Specification Type is "IP DesignKit"
*    
**/

public  class FV_SpecProvisioningHandler  {
    
    /**
        Public Variable Declarations
     **/
     
    public  Map<String,String> mapAccountNames{get;set;}
    public  Map<String,User> mapUserNames{get;set;}
    public  Map<String,List<User>> mapAccountToUsers{get;set;}
    public  Design_Spec__c objDesignSpec{get;set;}      
    public  Boolean isValidReleaseStatusForProvisioning{get;set;}
    public  Boolean isValidProfile{get;set;}
    public  Boolean isValidTechGeometry{get;set;}
    public  Boolean isValidSpecificationType{get;set;}
    public  Boolean showAddAccounts{get;set;}
    public  Id objDesignSpecId{get;set;}
    public  list<AccountWapper> searchResult{get;set;}
    public  Set<String> setSelectedAccountIds{get;set;}
    public Boolean renderSearchResults{get;set;}
    public  Boolean searchpanel{get;set;}
    public  Boolean editpanel{get;set;}
    public  string searchString{get;set;}
    public  Set<String> setUserIdsDeProvisioned{get;set;}
    private final Map<String, Schema.SObjectType> globalDescribe=Schema.getGlobalDescribe();
    public Map<String, Restricted_Tech_Geometry__c> mapRTG = Restricted_Tech_Geometry__c.getAll();
    public Map<String, Profiles_for_Provisioning__c> mapPFP = Profiles_for_Provisioning__c.getAll();
    public Map<String, Provisioning_Profiles_with_Approval__c> mapPPWA = Provisioning_Profiles_with_Approval__c.getAll();
    public Document_Provisioning__c documetProv {get;set;}
    public Id docProDesignIPDKSpecRtype {get;set;}
    // list will be used for mass provision of document provisioning records
    List<Document_Provisioning__c> lstOfDP = new List<Document_Provisioning__c>();
    string ProfileName;
    
    public Set<String> setUsersAlreadyProvisioned{get;set;}
    public boolean provionsedUser{get;set;} //added by cognizant for Case 34664
    public List<Account> lstOfSelectedAccounts;
    
    public Boolean isDisplay {get;set;}
    public String backEndKitHelpText {get;set;}
    private String doNotReply;
    public String regionHelpText {get;set;}
    private String selectRegionValue;
    @TestVisible 
    private Map<String,List<String>> mapRegHCMIds;   
    public String isbackendkit{get;set;}
    public List<SelectOption> isbackendkitOptions{get;set;}
    public String region{get;set;}
    public String justification{get;set;}
	private static String staticIsbackendkit;
	private static String staticRegion;
	private static String staticJusti;
    
    
    /**
        This is the constructor of the Class
     **/
    public FV_SpecProvisioningHandler(ApexPages.StandardController controller){
          
        Set<Id> setProfileIds = new Set<Id>();
        Set<String> setAccountIds = new Set<String>();
        Set<String> setTempIds = new Set<String>();
        Set<Id> setUserIds = new Set<Id>();
        setUserIdsDeProvisioned = new Set<String>();
        setSelectedAccountIds = new Set<String>();
        renderSearchResults= false;
        List<Account> lstAccounts = new List<Account>();
        isValidProfile = true;
        searchResult = new list<AccountWapper>();
        list<AccountWapper> searchResultOld;
        editpanel = true;
        searchpanel = false;
        provionsedUser=false; //added by cognizant for Case 34664
        lstOfSelectedAccounts = new List<Account>();
        setUsersAlreadyProvisioned = new Set<String>();
        
       
        //New vairable Assigmenet //Added By Sandesh
       // documetProv = new Document_Provisioning__c();
        isDisplay = true;
        backEndKitHelpText = IPDK_Constant__c.getValues('BackEndKitHelpText') !=null ? IPDK_Constant__c.getValues('BackEndKitHelpText').value__c : '';
        doNotReply =IPDK_Constant__c.getValues('DoNotReplyEmail') !=null  ? IPDK_Constant__c.getValues('DoNotReplyEmail').value__c : '';
        regionHelpText =IPDK_Constant__c.getValues('RegionHelpText') !=null ? IPDK_Constant__c.getValues('RegionHelpText').value__c : '';
        selectRegionValue =IPDK_Constant__c.getValues('SelectRegionValue') !=null ? IPDK_Constant__c.getValues('SelectRegionValue').value__c : '';
        //Veriables Assigment End          
       
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
         if(((setProfileIds!=null && setProfileIds.contains(UserInfo.getProfileId())) || !lstcurrentUserPerSet.isempty()) && objDesignSpec.Specification_Type__c!='IP Design Kit' ){
            isValidProfile = true;  
        }
        
        else if((setProfileIds!=null && setProfileIds.contains(UserInfo.getProfileId()) || provionsedUser==True || !lstcurrentUserPerSet.isempty()) && objDesignSpec.Specification_Type__c=='IP Design Kit'){
            isValidProfile = true; 
            
        }
        else{
            isValidProfile = false;  
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'You do not have proper permission for provisioning this design spec.');
            ApexPages.addMessage(myMsg);
        }  
 
 /*--------------added for ipdk access end--------------------------------------------------*/      
            
            isValidTechGeometry = verifyValidTechGeometry(objDesignSpec.Technology_Geometry__c);
            isValidSpecificationType = verifyValidSpecType(objDesignSpec.Specification_Type__c);
            showAddAccounts = showOrHideAddAccounts(objDesignSpec.Release_Status__c);
                
            mapAccountToUsers = new Map<String,List<User>>();
            
            if (objDesignSpec.Release_Status__c.toLowerCase().contains('white list')){
                    searchResultOld =new list<AccountWapper>();
                    list<White_List__c> wlList = new list<White_List__c>();
                    set<ID> accIds = new set<ID>();
                    map<ID,Account> accMap = new map<ID,Account>();
                    wlList = [select account__c,account__r.Name,account__r.Site_Department__c,account__r.Stage__c,account__r.Parent_Account_Name__c,
                                                 account__r.ASIC_Business_Flag__c,account__r.Parent_Account_Short_Name__c,account__r.Short_Name__c,Sub_PDK__c,account__r.Account_Present_In_OT__c 
                                          from white_List__c 
                                          where Design_Spec__c=:objDesignSpecId];
                    for(White_List__c wl:wlList){
                        if(wl.account__c != null)
                            accIds.add(wl.account__c);
                    }
                    if(!accIds.isEmpty())
                    accMap = new map<ID,Account>([SELECT ASIC_Business_Flag__c,ID,Name,Site_Department__c,Stage__c,Short_Name__c,Parent_Account_Name__c ,Parent_Account_Short_Name__c,Account_Present_In_OT__c  FROM Account WHERE ID IN: accIds ]);
                    for(White_List__c wl:wlList){
                        if (wl<>Null && accMap != null && accMap.containsKey(wl.account__c)){
                           AccountWapper accWrapper = new AccountWapper();
                           accWrapper.acct = accMap.get(wl.account__c);                           
                           /*accWrapper.acct = new Account(id=wl.account__c,name = wl.account__r.Name,
                                                         Site_Department__c = wl.account__r.Site_Department__c,
                                                         Stage__c = wl.account__r.Stage__c,
                                                         Short_Name__c = wl.account__r.Short_Name__c,Account_Present_In_OT__c=wl.account__r.Account_Present_In_OT__c); 
                            */
                                                                                     
                           //accWrapper.selected = false;
                           //accWrapper.isAlreadyProvisioned=false;                              
                           searchResultOld.add(accWrapper);
                        }
                    }
                    
                    Map<Id,Id> acctMap = new Map<Id,Id>();
                    // ADDED to disabled checkbox
                    List<Document_Provisioning__c> listOfDpRecords = [SELECT Id,Name,AccountID__c,AccountID__r.Short_Name__c,sub_PDK__c,status__c
                                                                        FROM Document_Provisioning__c
                                                                        WHERE Design_Spec__c = : objDesignSpecId
                                                                        AND status__c IN ('Provisioned','Provisioning In Progress','Sent For Approval','De-Provisioning In Progress','IPLAProvision','IPLADeprovision')
                                                                     ];
                    
                    if(listOfDpRecords<>NULL && !listOfDpRecords.isEmpty()){                                                 
                        for(Document_Provisioning__c dp : listOfDpRecords){
                            if(!acctMap.containsKey(dp.AccountID__c)){
                                acctMap.put(dp.AccountID__c,dp.AccountID__c);
                            }
                        }
                    }
                    if(searchResultOld<>NULL && !searchResultOld.isEmpty()){
                        for(AccountWapper acc : searchResultOld){
                            if (acc<>Null){
                               AccountWapper w = new AccountWapper();
                               if(acctMap<>NULL && acctMap.containsKey(acc.acct.Id)){
                                    w.acct = acc.acct;
                                    w.selected = true;
                                    w.isAlreadyProvisioned=true;
                               } else {
                                    w.acct = acc.acct;   
                                    w.selected = false;
                                    w.isAlreadyProvisioned=false;
                               }
                               searchResult.add(w);
                            }
                        }
                    }    
                    system.debug('Search Result >>>>>>'+searchResult);
                    if(searchResult!=null && !searchResult.isEmpty()){
                        renderSearchResults = true; 
                    }
                }
           
 /*-------------------------added by cognizant for Case 34664 start----------------------------*/            
            
            if(objDesignSpec.Is_Latest_Revision__c==false && objDesignSpec.Specification_Type__c=='IP Design Kit' && isValidProfile ==true && isValidReleaseStatusForProvisioning==true && isValidTechGeometry==true && isValidSpecificationType==true)
            {
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Alert! This is not the Latest Design Kit. Before you proceed, please be aware and understand the business risks involved in provisioning this older revision.');
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
        
        List<PermissionSetAssignment> lstcurrentUserPerSet =    [   SELECT Id, PermissionSet.Name,AssigneeId
                                                                FROM PermissionSetAssignment
                                                                WHERE AssigneeId = :Userinfo.getUserId() and PermissionSet.Name=:label.FV_Permission_to_Provision_Spec];
                                                                
        //Supplier Service Changes-005:Start 
        //Suppliers should only be able to provision Other and Technical Specification types
        if(objDesignSpec==null && (label.supplierprofileid.contains(UserInfo.getProfileId()) || !lstcurrentUserPerSet.isempty())){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'You cannot provision the related Specification type.');
            ApexPages.addMessage(myMsg);
            isValid=false; 
        }
        else if(objDesignSpec!=null && objDesignSpec.Specification_sub_class__c!='Other Specifications' && objDesignSpec.Specification_sub_class__c!='Technical Specifications' && !objDesignSpec.Specification_sub_class__c.contains ('ASIC') && (label.supplierprofileid.contains(UserInfo.getProfileId()) || !lstcurrentUserPerSet.isempty())){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'You cannot provision the related Specification type.');
            ApexPages.addMessage(myMsg);
            isValid=false; 
            system.debug('profile id:'+UserInfo.getProfileId());
        }
        //Supplier Service Changes-005:End
        
        return isValid;
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
        objDS = [Select Id, Name, Document_Number__c,OwnerId,Revision__c, Revision_Release_Date__c,OpenText_ID__c,Lifecycle_Phase__c, Location_Fab__c,Specification_Type__c, Technology_Type__c,
                 Technology_Geometry__c, Source__c, Specification_sub_class__c, Release_Status__c,Is_Latest_Revision__c,Specification_ASIC_Flag__c   from Design_Spec__c
                 where Id =: specId];
                 
        return objDS;
            
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
    
    // Account Search
    public pageReference searchAccount(){
        system.debug('Inside Search Account >>>>>>>>>>>>>>>');
        if(searchString!=null && searchString.length()>1){
            searchResult =new list<AccountWapper>();
            string searchstrng='%'+searchString.toLowerCase()+'%';
            Map<Id,Id> acctMap = new Map<Id,Id>();
            // ADDED to disabled checkbox
            List<Document_Provisioning__c> listOfDpRecords = [SELECT Id,Name,AccountID__c,AccountID__r.Short_Name__c,sub_PDK__c,status__c
                                                                FROM Document_Provisioning__c
                                                                WHERE Design_Spec__c = : objDesignSpecId
                                                                AND status__c IN ('Provisioned','Provisioning In Progress','Sent For Approval','De-Provisioning In Progress','IPLAProvision','IPLADeprovision')
                                                             ];
            
            if(listOfDpRecords<>NULL && !listOfDpRecords.isEmpty()){                                                 
                for(Document_Provisioning__c dp : listOfDpRecords){
                    if(!acctMap.containsKey(dp.AccountID__c)){
                        acctMap.put(dp.AccountID__c,dp.AccountID__c);
                    }
                }
            }
			//Added logic to remove supplier from search list //Added By Sandesh
            for(Account acc : [select ASIC_Business_Flag__c,name,id,Site_Department__c,Stage__c,Parent_Account_Name__c,Parent_Account_Short_Name__c,Short_Name__c,Account_Present_In_OT__c
                                from account where (name like :searchstrng OR Short_Name__c like :searchstrng)
								AND (RecordType.DeveloperName IN ('Customer','Enablement_Partner','Reseller','GLOBALFOUNDRIES_Internal')
                                    OR (RecordType.DeveloperName ='Suppliers' AND Supplier_Type__c='Manufacturing Vendor') ) ]){ 
                if (acc<>Null){
                   AccountWapper w = new AccountWapper();
                   if(acctMap<>NULL && acctMap.containsKey(acc.Id)){
                        w.acct = acc;
                        w.selected = true;
                        w.isAlreadyProvisioned=true;
                   } else {
                        w.acct = acc;   
                        w.selected = false;
                        w.isAlreadyProvisioned=false;
                   }
                   searchResult.add(w);
                }
            }
            system.debug('Search Result >>>>>>'+searchResult);
            if(searchResult!=null && !searchResult.isEmpty()){
                renderSearchResults = true;
                 
            } else{ 
                renderSearchResults = false;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Account not found for entered account name. Please try another accout name.'));
            }
            
        } else{
            renderSearchResults = false;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please provide atleast 2 characters to search Account for provisioning.'));
        }  
        return null;
    }
    
    //drop down value which show in back-end kit section as a change set CHG0046457
    public List<SelectOption> isbackendlist{
     get{
        Schema.DescribeFieldResult statusFieldDescription = Document_Provisioning__c.Is_BE_Required__c.getDescribe();
        isbackendkitOptions= new list<SelectOption>();
        isbackendkitOptions.add(new SelectOption('-None-','-None-'));
        isbackendkitOptions.add(new SelectOption('Yes','Yes'));
        isbackendkitOptions.add(new SelectOption('No','No'));
        return isbackendkitOptions;
       }  
        
        set;
      
      }
    
    /**
        This method decides Back-end Section Region & justification is hide or display
        Change Set: CHG0046457
    **/
    public void hideRegionJustification(){
        if(isbackendkit==null ||isbackendkit.equalsIgnoreCase('None') || isbackendkit.equalsIgnoreCase('Yes')){
            isDisplay = true;
        }
        else{
            isDisplay = false;
        }
        system.debug('****isDisplay'+isDisplay);
    }
    
    /**
        This method create region which can show on Back-end section as a drop down
        Change Set: CHG0046457
    **/
   public List<SelectOption> allRegion
    {
        get{
            allRegion = new List<SelectOption>();
            mapRegHCMIds = new Map<String,List<String>>();
            allRegion.add(new SelectOption('None', '--None--'));
            for(IPDK_BackEndRegionKit__c backEnd :IPDK_BackEndRegionKit__c.getall().values()){
                allRegion.add(new SelectOption(backEnd.Name, backEnd.RegionName__c));
                if(!mapRegHCMIds.containsKey(backEnd.RegionName__c)){
                    mapRegHCMIds.put(backEnd.RegionName__c,backEnd.Federation_ID__c.split(','));
                }
            }
            return allRegion;
        }
        set;
    }
    
    /**
        This method decides the email sent to users which users
        Change Set: CHG0046457
    **/
    @TestVisible
    private void sendEmailToRegionUsers(Map<String,List<String>> regHCM, Id specId){ 
        EmailTemplate template =  [SELECT Id,Name,Subject,Body FROM EmailTemplate WHERE DeveloperName = 'Req_IPDK_Backend_Email' LIMIT 1];
        
        List<String> regHCMIds = new List<String>();
        String be_Req_Email = UserInfo.getUserEmail();
       // if(documetProv.BE_Region__c !=null)
          //  regHCMIds.addAll(regHCM.get(documetProv.BE_Region__c));
          if(region!=null)
              regHCMIds.addAll(regHCM.get(region));
        String[] toaddress = new String[]{};
        User us = new User();    
        for(User user:[Select Id,Name,Email,FederationIdentifier From User Where IsActive =true AND FederationIdentifier IN :regHCMIds]){
           toaddress.add(user.Email);
           us = user; 
        } 
        
        try{
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(toaddress);
            mail.setCcAddresses(new String[]{doNotReply,be_Req_Email});
            mail.setTargetObjectId(us.Id);
            mail.setWhatId(specId);
            mail.setTemplateId(template.Id);
            mail.setSaveAsActivity(false); 
            system.debug('--email---'+mail);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
        }
        catch(Exception e){
            for(Integer i = 0; i < e.getNumDml(); i++) {
                    // Process exception here
                    GlobalUtility.logMessage('Error','FV_SpecProvisioningHandler','PDK Provisioning','',e.getDmlMessage(i),String.valueof(e.getMessage()),'','PDK Provisioning',e,0);
                    System.debug(e.getDmlMessage(i)); 
                }
        }
    }
    
    /**
        This method decides whether the email send back-end requestor or not
        Change Set: CHG0046457
    **/
    private Boolean validateAAPExistForDP(List<Document_Provisioning__c> lstDP){
        Set<String> setIDS = new Set<String>();
        set<Id> setAccountIds = new Set<Id>();
        String specificationId;
        for(Document_Provisioning__c dp :lstDP){
            setIDS.add(dp.Id);
        }
        for(Document_Provisioning__c dp :[SELECT Id,Name,AccountID__c,recordTypeId,RecordType.DeveloperName,Design_Spec__c 
                                            FROM Document_Provisioning__c 
                                            WHERE RecordType.DeveloperName ='IP_DK_Record_Type' 
                                            AND Is_BE_Required__c = 'Yes'
                                            AND Id IN:setIDS]){
            setAccountIds.add(dp.AccountID__c);
            specificationId = (specificationId !='') ?dp.Design_Spec__c : '';                                    
        }
        
        Map<Id,IPDK_License_Information__c> lstAAPS = new Map<Id,IPDK_License_Information__c>([Select Id,Name,Account__c,Specification__c 
                                                                                               From IPDK_License_Information__c 
                                                                                               Where Account__c IN :setAccountIds
                                                                                               And Specification__c =:specificationId]);
        if(lstAAPS !=null && setAccountIds !=null && setAccountIds.size()>lstAAPS.size()){
            return true;
        }
        
        return false;
        
    }
    
    // Method Help to provision DesignSpec for provisioning
    public pageReference doProvision(){

        //Logic to validate region field required 
        //Change Set: CHG0046457 //Added By Sandesh
        if(region !=null && isbackendkit!=null 
           && region.equalsIgnoreCase('None') && isbackendkit.equalsIgnoreCase('Yes')){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, selectRegionValue));
            return null;
        }
		FV_SpecProvisioningHandler.staticIsbackendkit = isbackendkit;
		FV_SpecProvisioningHandler.staticRegion = region;
		FV_SpecProvisioningHandler.staticJusti = justification;
		
       //logic End
               
        system.debug('Inside doProvisioning Method >>>>>>>>>>');     
        String accAlreadyProNames = '';
        Id docProDesignSpecRtype;
        
        if(Schema.SObjectType.Document_Provisioning__c.getRecordTypeInfosByName()<>NULL){
            if(Schema.SObjectType.Document_Provisioning__c.getRecordTypeInfosByName().get('Design Spec Record Type')<>NULL){
                docProDesignSpecRtype = Schema.SObjectType.Document_Provisioning__c.getRecordTypeInfosByName().get('Design Spec Record Type').getRecordTypeId();
            }   
            
            //defined new "IP DK Record Type" //Added by Sandesh  
            if(Schema.SObjectType.Document_Provisioning__c.getRecordTypeInfosByName().get('IP DK Record Type')<>NULL){
                docProDesignIPDKSpecRtype = Schema.SObjectType.Document_Provisioning__c.getRecordTypeInfosByName().get('IP DK Record Type').getRecordTypeId();
            }
            //Logic End
        }  
        system.debug('accAlreadyProNames>>>>>>>>>>>'+accAlreadyProNames);
        SavePoint sp;
        try{
            sp = DataBase.setSavepoint();
            if (searchResult<>Null && !searchResult.isEmpty()){
                if (isAccSelected()){
                    /*--------------------------added for Case 41455 start------------------------------------------------------------  */ 
                    string accnames='';               
                    boolean showerror=false;
                    datetime d= datetime.now(); 
                    system.debug('lstOfSelectedAccounts$$>>>>>krishanu>>>>>>'+lstOfSelectedAccounts);
                    for(Account accobj:lstOfSelectedAccounts)
                    {
                     system.debug('Account_Present_In_OT_>>>>>>>>>>>'+accobj.Account_Present_In_OT__c);
                        if(accobj.Account_Present_In_OT__c==false || accobj.Short_Name__c==null || accobj.Short_Name__c=='')
                        {
                            showerror=true;
                            break;
                        }
                        else
                        {
                           showerror=false;
                        }
                    }
                    
                    for(Account accobj:lstOfSelectedAccounts)
                    {
                    
                        if(accobj.Account_Present_In_OT__c==false || accobj.Short_Name__c==null || accobj.Short_Name__c=='')
                        {
                            if(accnames=='')
                            {
                                accnames='"'+accobj.Name+'"';
                            }
                            else
                            {
                                accnames=accnames+','+'"'+accobj.Name+'"';  
                             
                            }
                       }
                    }
                    system.debug('accnamefinal>>>>>>'+accnames);
                    system.debug('showerror$$>>>>>>>>>>>'+showerror);
 /*----------------------------added for Case 41455 end----------------------------------------------------------*/                        
                    
                    if(showerror==false)//added for case 41455
                    {
                    List<Account> lstOfSelectedAcc = FV_SpecProvisioningHandler.updateDeProvisionedDp(lstOfSelectedAccounts,objDesignSpec.Id);
                    // List of selected account send for provisioning from UI
                    if (lstOfSelectedAcc<>Null && !lstOfSelectedAcc.isEmpty()){
                        for (Account acc : lstOfSelectedAcc){
                            Document_Provisioning__c DP = new Document_Provisioning__c();
                            //DP = documetProv; //Assigned VF value from documetProv to DP 
                            //Change Set: CHG0046457 //Added By Sandesh
                            DP.Is_BE_Required__c=isbackendkit;
                            DP.BE_Region__c=region;
                            DP.BE_Justification__c=justification;
                            DP.Design_Spec__c = objDesignSpec.id;
                            DP.DSpecOTId__c = objDesignSpec.OpenText_ID__c+':NONE';
                            if(objDesignSpec!=null && objDesignSpec.Release_Status__c.equalsIgnoreCase('Specific Account Release with Spec owner Approval')){
                                DP.Status__c = 'Sent For Approval';
                            } else {
                                DP.Status__c = 'Provisioning In Progress';
                               // DP.Status_For_IPDK__c = 'Provisioning In Progress';//added for IPLA changes
                            }
                            DP.AccountID__c = acc.id;
                            DP.Acc_Short_Name__c = acc.Short_Name__c;
                            
                            //Added logic to assign value for Back-end request 
                            //Change Set: CHG0046457 //Added By Sandesh 
                            if(docProDesignIPDKSpecRtype !=null && objDesignSpec !=null && objDesignSpec.Specification_Type__c !=null 
                                && objDesignSpec.Specification_Type__c.equalsIgnoreCase('IP Design Kit')){
                                    DP.recordTypeId = docProDesignIPDKSpecRtype;
                                    DP.BE_Region__c = (DP.BE_Region__c !=null && !DP.BE_Region__c.equalsIgnoreCase('None'))?DP.BE_Region__c:'';
                                    DP.BE_Requestor__c = UserInfo.getUserId();
                                }
                            else if(docProDesignSpecRtype<>NULL){
                                DP.recordTypeId = docProDesignSpecRtype;
                            } //End logic
                            DP.Spec_Owner__c = objDesignSpec.OwnerId;
                            lstOfDP.add(DP);

                        }
                    }
                    
                    if(lstOfDP<>Null && !lstOfDP.isEmpty()){
                        insert lstOfDP;
                        
                        //send Email if back-end 'Yes' and AA is not approved 
                        //Change Set: CHG0046457 //Added by Sandesh
                        if(validateAAPExistForDP(lstOfDP)){
                            sendEmailToRegionUsers(mapRegHCMIds,objDesignSpec.id);
                        }//Logic End
                            
                    }
                } 
                else
                    {
                    String errorMessage = 'Account'+' '+accnames+' '+'is/are not fully enabled yet.'+'<br/>'+
                                          'Please ensure the following conditions in Account are met before attempting to provision it again:'+
                                          '<ul><li>'+'Every Account must have a "Short Name."'+'</li>'+
                                          '<li>'+'Each Account must have at least one Contact that is an active portal user. (Note: This will enable "Account Present in OT" to be checked to allow account to be selected for provisioning.)'+'</li></ul>';    
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,errorMessage));
                    return null;
                    
                    }   
                }else {
                    system.debug('Inside else select at least one Account ###########');
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please select at least 1 Account for Spec provisioning.'));
                    return null;
                }
            } else {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please search and add at least 1 Account for Spec provisioning.'));
                    return null;
            }
            
        } catch (Exception e){
            DataBase.rollback(sp);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
            //return null;
        }
        return new PageReference('/'+objDesignSpecId);
    }
    
    // Method help to check if account is selected for provisioning or not
    public boolean isAccSelected(){
        
        Boolean isSelected = false;
        lstOfSelectedAccounts = new List<Account>();
        
        if(searchResult<>Null && !searchResult.isEmpty()){
            for (AccountWapper wrapper : searchResult){
                if (wrapper.selected && !wrapper.isAlreadyProvisioned){
                    lstOfSelectedAccounts.add(wrapper.acct);
                }
            }                   
        }
        system.debug('lstOfSelectedAccounts>>>>>>>>>>>>'+lstOfSelectedAccounts);
        if (lstOfSelectedAccounts<>Null && !lstOfSelectedAccounts.isEmpty()){
            isSelected = true;
        }
        return isSelected;
    }
    
    // Update already provisioned Document provisioning record
    public static List<Account> updateDeProvisionedDp(List<Account> lstOfSelectedAccounts,Id objDesignSpecId){
        Map<Id,Account> mapOfAccount = new Map<Id,Account>();
        List<Document_Provisioning__c> listOfDpRecords = new List<Document_Provisioning__c>();
        List<Document_Provisioning__c> updatedDpRecords = new List<Document_Provisioning__c>();
        Set<Id> setOfAccIds = new Set<Id>();
        //Change Set: CHG0046457 //Added by Sandesh
        String docProDesignIPDKSpecRtype;
        
        if(Schema.SObjectType.Document_Provisioning__c.getRecordTypeInfosByName()<>NULL){
            if(Schema.SObjectType.Document_Provisioning__c.getRecordTypeInfosByName().get('IP DK Record Type')<>NULL){
                docProDesignIPDKSpecRtype = Schema.SObjectType.Document_Provisioning__c.getRecordTypeInfosByName().get('IP DK Record Type').getRecordTypeId();
            }
        } 
        //Ended Logic by Sandesh 
        
        List<Account> lstOfAccsNotDepro = new List<Account>();// prepare list of account which are not deprovisioned and which are new for provisioning
        if (lstOfSelectedAccounts<>NULL && !lstOfSelectedAccounts.isEmpty()){
            for (Account acc : lstOfSelectedAccounts){
                if (!mapOfAccount.containsKey(acc.Id)){
                    mapOfAccount.put(acc.Id,acc);   
                }
            }
        }
        if(mapOfAccount<>NULL && !mapOfAccount.isEmpty()){
            listOfDpRecords = [SELECT Id,Name,AccountID__r.Short_Name__c,sub_PDK__c,status__c,is_De_Prov_From_UI__c,Sub_PDK__r.Release_Status__c,Design_Spec__r.Specification_Type__c FROM Document_Provisioning__c
                               WHERE Design_Spec__c = : objDesignSpecId
                               AND AccountID__c IN : mapOfAccount.keySet()
                               AND status__c IN ('De-Provisioned','Rejected')];

        }
        if (listOfDpRecords<>NULL && !listOfDpRecords.isEmpty()){
            for (Document_Provisioning__c dp: listOfDpRecords){
                setOfAccIds.add(dp.AccountID__c);
                if (dp.status__c=='De-Provisioned' && dp.Sub_PDK__r.Release_Status__c!='Specific Account Release with Spec owner Approval' && dp.Sub_PDK__r.Release_Status__c!='Internal Use Only' ){
                    dp.status__c = 'Provisioning In Progress';  
                    //dp.Status_For_IPDK__c = 'Provisioning In Progress'; //added for IPLA changes
                }
                if (dp.status__c=='Rejected' || (dp.status__c=='De-Provisioned' && dp.Sub_PDK__r.Release_Status__c=='Specific Account Release with Spec owner Approval')){
                    dp.status__c='Sent For Approval';
                }
                
                dp.isProvUpdate__c = false;
                dP.isDeProUpdate__c = false;
                if(!system.isFuture() && !system.isBatch() && dp.is_De_Prov_From_UI__c){
                   dp.is_De_Prov_From_UI__c=false;  
                }
                
                //update old record type with new "IP DK Record Type" if Specification Type is "IP DesignKit" 
                //Change Set: CHG0046457 //Added By Sandesh
                if(docProDesignIPDKSpecRtype !=null && dp !=null && dp.Design_Spec__r.Specification_Type__c !=null 
                    && dp.Design_Spec__r.Specification_Type__c.equalsIgnoreCase('IP Design Kit')){
                    dp.recordTypeId = docProDesignIPDKSpecRtype;
                    dp.BE_Requestor__c = UserInfo.getUserId();
                    dp.BE_Region__c = staticRegion;
                    dp.BE_Justification__c = staticJusti;
                    dp.Is_BE_Required__c = staticIsbackendkit;    
                }//Logic End
                
                updatedDpRecords.add(dp);
            }
            try{
                if(updatedDpRecords<>NULL && !updatedDpRecords.isEmpty()){
                    update updatedDpRecords;
                }
            } catch (Exception e){
                system.debug('Exception Occureed in updateDeProvisionedDp Method :: '+e.getMessage());  
            }
            if (setOfAccIds<>NULL && !setOfAccIds.isEmpty()){
                for(Id accId : mapOfAccount.keySet()){
                    if (!setOfAccIds.contains(accId)){
                        lstOfAccsNotDepro.add(mapOfAccount.get(accId));
                    }
                }
            }
            
        } else {
            lstOfAccsNotDepro.addAll(lstOfSelectedAccounts);
        }
        system.debug('lstOfAccsNotDepro >>>>>>>>>>>'+lstOfAccsNotDepro);
        return lstOfAccsNotDepro;
    }
    
    /***
        Class Name: accountWrapper
        Type: Inner 
        Use: Wrapper, using to hold the Account Search Results. 
     ***/
     
    public class AccountWapper{
         public Account acct {get; set;}
         public boolean selected {get;set;}
         public boolean isAlreadyProvisioned {get;set;}
         public AccountWapper(){
             if(acct==null){acct = new Account();}
         }
    }
}