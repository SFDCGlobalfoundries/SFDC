/*
Type Name: ClsDeProvisionSpecController 
Author: Cognizant 
Created Date: 12-June-2013
Reason: This class is used for deprovisioning documents.
Change History:
Author: Cognizant 
Modified Date: 25/11/2013
Reason: sorting of users
Author: Cognizant
Modified Date: 21-Jan-2014
Reason: Fetch users which are already created in OT(Case 00004324)
Author: Cognizant
Modified Date: 11-Aug-2014
Reason: Case 22278
Author: Cognizant
Modified Date: 23-sep-2014
Reason: Case 35160
??..
??..
*/
public class ClsDeProvisionSpecController{

    public  Map<String,String> mapAccountNames{get;set;}
    public  Map<String,User> mapUserNames{get;set;}
    public  Map<String,List<User>> mapAccountToUsers{get;set;}
    public  Design_Spec__c objDesignSpec{get;set;}  
    public  List<accUserWrapper> lstAccUserWrapper{get;set;}    
    public  Boolean isValidReleaseStatusForProvisioning{get;set;}
    public  Boolean isValidProfile{get;set;}
    public  Boolean isValidTechGeometry{get;set;}
    public  Boolean isValidSpecificationType{get;set;}  
    public  Id objDesignSpecId{get;set;}
    public Map<String, Restricted_Tech_Geometry__c> mapRTG = Restricted_Tech_Geometry__c.getAll();
    public Map<String, Profiles_for_Provisioning__c> mapPFP = Profiles_for_Provisioning__c.getAll();
    public boolean provionsedUser{get;set;} //added by cognizant for Case 34664
    public ClsDeProvisionSpecController(ApexPages.StandardController controller){
        
        Set<Id> setProfileIds = new Set<Id>();
        Set<String> setAccountIds = new Set<String>();
        Set<String> setTempIds = new Set<String>();
        Set<Id> setUserIds = new Set<Id>();
        Set<String> setUserIdsProvisioned = new Set<String>();
        List<Account> lstAccounts = new List<Account>();
        isValidProfile = false;
        isValidReleaseStatusForProvisioning = false; 
        provionsedUser=false; //added by cognizant for Case 34664
        setProfileIds.addAll(getValidProfiles());
       /* if(setProfileIds!=null && setProfileIds.contains(UserInfo.getProfileId())){
            isValidProfile = true;  
        }
        else{
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'You do not have proper permission for de-provisioning this design spec.');
            ApexPages.addMessage(myMsg);
        }*/
        
        objDesignSpecId = controller.getId();
        
        if(objDesignSpecId!=null){
            
            objDesignSpec = retrieveSpecInfo(objDesignSpecId);
/*----------------------added for IPDK access start----------------------------------------------*/            
           provionsedUser=getGroup();//added by cognizant for Case 34664
           
           if(setProfileIds!=null && setProfileIds.contains(UserInfo.getProfileId()) && objDesignSpec.Specification_Type__c!='IP Design Kit' ){
            isValidProfile = true;  
        }
        
        else if((setProfileIds!=null && setProfileIds.contains(UserInfo.getProfileId()) || provionsedUser==True) && objDesignSpec.Specification_Type__c=='IP Design Kit'){
            isValidProfile = true;  
        }
        else{
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'You do not have proper permission for provisioning this design spec.');
            ApexPages.addMessage(myMsg);
        }  
           
 /*----------------------added for IPDK access end----------------------------------------------*/ 
            
            isValidTechGeometry = verifyValidTechGeometry(objDesignSpec.Technology_Geometry__c);
            isValidSpecificationType = verifyValidSpecType(objDesignSpec.Specification_Type__c);
            if(objDesignSpec.Release_Status__c!='Internal Use Only' && objDesignSpec.Release_Status__c!='General Release'){
                isValidReleaseStatusForProvisioning = true; 
            }
            else{
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'You cannot de-provision for Release Statuses of General Release or Internal Release');
                ApexPages.addMessage(myMsg);    
            }           
            lstAccUserWrapper = new List<accUserWrapper>();
            mapAccountToUsers = new Map<String,List<User>>();
            setUserIdsProvisioned.addAll(getAllExistingProvisionings(objDesignSpecId));
                    
            if(setUserIdsProvisioned!=null && setUserIdsProvisioned.size()>0){
                                
                mapAccountToUsers.putAll(getAllRelatedUsers(setUserIdsProvisioned));
                
                if(mapAccountToUsers!=null && mapAccountToUsers.size()>0){
                                
                    lstAccounts.addAll(getAllAccounts(mapAccountToUsers.keySet()));
                                                
                    if(lstAccounts!=null && lstAccounts.size()>0){                  
                        lstAccUserWrapper.addAll(addUserAccountInfoToWrapper(lstAccounts));                                         
                    }
                
                }
                            
            }

           
        }
        
                               
    }
/*---------------added by cognizant for Case 34664 start----------------------------------*/
public  Boolean getGroup()
{
 boolean isDSGroup;
 SET<id> SetofUserId=new SET<id>();
 List<GroupMember> lstmember=[Select GroupId,UserOrGroupId from GroupMember where GroupId =:System.label.DS_Group_Id];
 system.debug('lstmember$$$'+lstmember);
 for(GroupMember objmember:lstmember)
 {
  SetofUserId.add(objmember.UserOrGroupId);
 }

 
  system.debug('enter user1'+SetofUserId);
  system.debug('enter user2'+UserInfo.getUserId());
  
   if(!(SetofUserId.contains(UserInfo.getUserId())))
   {
   system.debug('enter else$$$');
   isDSGroup=false;
   //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Only DS Group members are allowed to De-provision iPDK.');
   //ApexPages.addMessage(myMsg);
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
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'You cannot de-provision for Restricted Tech Geometries');
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
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'You cannot de-provision for release category Reticle Grade Tables & Stepper Tooling Forms');
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
    
    public Set<String> getAllExistingProvisionings(Id specId){
        
        Set<String> setUserIds = new Set<String>();
        
        //for(Document_Provisioning__c dp:[Select User__c, Design_Spec__c, Status__c,Final_User_Access__c  from Document_Provisioning__c where Design_Spec__c =: specId AND Status__c = 'Provisioned']){
        for(Document_Provisioning__c dp:[Select User__c, 
                                                Design_Spec__c, 
                                                Status__c from Document_Provisioning__c 
                                                where Design_Spec__c =: specId AND (Status__c = 'Provisioned' OR (Status__c = 'IPLAProvision' AND Final_User_Access__c=true) OR (Status__c = 'IPLADeprovision' AND  Final_User_Access__c=true))]){
           
          
            setUserIds.add(dp.User__c); 
        }
        return setUserIds;
    }
    
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
    
    public  List<accUserWrapper> addUserAccountInfoToWrapper(List<Account> lstAcc){
        
        List<accUserWrapper> lstAccWrap = new List<accUserWrapper>();
        
        for(Account acc: lstAcc){
            accUserWrapper objAccUserWrap = new accUserWrapper();
            List<User> lstUser = new List<User>();
            objAccUserWrap.accId = acc.Id;
            objAccUserWrap.accName = acc.Name;
            objAccUserWrap.accShortName = acc.Short_Name__c;//added for Case 42841
            objAccUserWrap.accIsChecked = false;
            objAccUserWrap.mapUserIdToChecked = new Map<String, Boolean>();
            objAccUserWrap.Sortedcontactlist= new List<User>();//Cognizant added on 25/11/2013

            
            if(mapAccountToUsers!=null && mapAccountToUsers.containsKey(acc.Id)){
                lstUser.addAll(mapAccountToUsers.get(acc.Id));
                objAccUserWrap.lstUserSize = lstUser.size();
                if(lstUser!=null && lstUser.size()>0){
                    for(User objUser: lstUser){
                        
                        objAccUserWrap.mapUserIdToChecked.put(objUser.Id,false);   
                        objAccUserWrap.Sortedcontactlist.add(objUser);   //Cognizant added on 25/11/2013       
                    }       
                }                                   
            }
            objAccUserWrap.Sortedcontactlist.sort();   //Cognizant added on 25/11/2013                                
 
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
    
    public  Design_Spec__c retrieveSpecInfo(Id specId){
        
        Design_Spec__c objDS = new Design_Spec__c();
        
        objDS = [Select Id, Name, Document_Number__c, Revision__c, Revision_Release_Date__c, Lifecycle_Phase__c, Location_Fab__c,Specification_Type__c, Technology_Type__c,
                 Technology_Geometry__c, Source__c, Specification_sub_class__c, Release_Status__c from Design_Spec__c
                 where Id =: specId];
                 
        return objDS;
            
    }
         
    public  Map<String,List<User>> getAllRelatedUsers(Set<String> setUserIdsProvisioned){
            
        Map<String,List<User>> mapAccToUsers = new Map<String,List<User>>();
        Set<Id> setUserIds = new Set<Id>();     
        if(setUserIdsProvisioned!=null && setUserIdsProvisioned.size()>0){
            
            mapUserNames = new Map<String,User>();
            mapAccountNames = new Map<String,String>();         
            
            mapAccToUsers = new Map<String,List<User>>();
            for(User objUser:[Select Id,Name,Parent_Account_Id__c,Parent_Account_Name__c,Contact_Created_In_Open_Text__c,Email from User where Id IN:setUserIdsProvisioned and Contact_Created_In_Open_Text__c =true]){//modified by cognizant for case 00004324
                
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
    
        }
        
        return mapAccToUsers;
        
    }
    
    public PageReference removeProvisioningRecords(){
        
        Map<Id,List<Id>> mapDeProvisioning = new Map<Id,List<Id>>();
        Map<String,Boolean> tempProvisioningMap = new Map<String,Boolean>();
        Set<String> setProvisionedUserIds = new Set<String>();
        List<Id> lstUsersToBeDeProvisioned = new List<Id>();
        boolean noContacts;//added by cognizant for Case 22278
        if(lstAccUserWrapper!=null && lstAccUserWrapper.size()>0){
        
            for(accUserWrapper obj:lstAccUserWrapper){
                if(obj.mapUserIdToChecked!=null && obj.mapUserIdToChecked.size()>0){
                    tempProvisioningMap.putAll(obj.mapUserIdToChecked);
                    setProvisionedUserIds.addAll(obj.mapUserIdToChecked.keySet());      
                }
                        
            }
            /*-----------------added by cognizant for Case 22278 start------------------------------------------*/                        
            for(accUserWrapper obj:lstAccUserWrapper)
            {
                if(setProvisionedUserIds!=null && setProvisionedUserIds.size()>0){
                        for(String objUserId: setProvisionedUserIds)
                        {
                            if(obj.mapUserIdToChecked.get(objUserId)==true)
                            {
                            noContacts=false;
                            system.debug('noContacts&&&&'+noContacts);
                            break;
                            }
                            else
                            {
                            system.debug('noContacts else&&&&'+noContacts);
                            noContacts=true;
                            }
                        }
/*------------------------------added for emergency case 35160 start------------------------------------------*/                    
                    if(noContacts==false)
                    {
                    break;
                    }
/*-----------------------added for emergency case 35160 end-------------------------------------------------------*/                        
                    
                }
            
            }  
/*-----------------added by cognizant for Case 22278 end------------------------------------------*/  
            
            if(setProvisionedUserIds!=null && setProvisionedUserIds.size()>0){
                for(String objUserId: setProvisionedUserIds){
                    if(tempProvisioningMap!=null && tempProvisioningMap.containsKey(objUserId)){
                        if(tempProvisioningMap.get(objUserId)){
                            lstUsersToBeDeProvisioned.add(objUserId);       
                        }
                    }       
                }
                
                if(lstUsersToBeDeProvisioned!=null && lstUsersToBeDeProvisioned.size()>0){
                    mapDeProvisioning.put(objDesignSpecId,lstUsersToBeDeProvisioned);
                    
                    if(mapDeProvisioning!=null && mapDeProvisioning.size()>0){
                        System.debug('Contents of Map is ' + mapDeProvisioning);
                        ClsProvisioningHandler controller = new ClsProvisioningHandler();
                        controller.deProvisioningMethod(mapDeProvisioning, 'Spec');
                    }
                    
                }
                    
            }
            
            
        }
        
/*-----------commented by cognizant for Case 22278 start---------------------------------------*/        
       /* PageReference pageRef = new PageReference('/'+objDesignSpecId);  
        return pageRef;*/
/*-----------commented by cognizant for Case 22278 end---------------------------------------*/ 
/*-----------added by cognizant for Case 22278 start---------------------------------------*/                 
        if(noContacts==false)
        {
        PageReference pageRef = new PageReference('/'+objDesignSpecId);  
        return pageRef;
        }
        else
        {
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'No contacts selected for deprovisioning.');
        ApexPages.addMessage(myMsg);
        return null;
        }
/*-----------added by cognizant for Case 22278 end---------------------------------------*/
        
    }
    
    public class accUserWrapper
    {
        public String accId{get;set;}
        public String accName{get;set;}
        public String accshortName{get;set;}//added for Case 42841
        public Boolean accIsChecked{get;set;}
        public Map<String, Boolean> mapUserIdToChecked{get;set;}
        public Integer lstUserSize{get;set;}
        public List<User> Sortedcontactlist{get;set;}//Cognizant added on 25/11/2013

    
    }
    
    

}