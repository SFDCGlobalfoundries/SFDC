/*
Type Name: ClsDeProvisionSubPDKController 
Author: Cognizant 
Created Date: 12-June-2013
Reason: This class is used for deprovisioning Sub PDKs.
Change History:
Author: Cognizant 
Modified Date: 25/11/2013
Reason: sorting of users
Author: Cognizant
Modified Date: 21-Jan-2014
Reason: Fetch users which are already created in OT(Case 00004324)
Author: Cognizant
Modified Date: 11-Aug-2014
Reason: case 22278
Author: Cognizant
Modified Date: 23-Sep-2014
Reason: case 35160
??..
??..
*/
public class ClsDeProvisionSubPDKController{

    public  Map<String,String> mapAccountNames{get;set;}
    public  Map<String,User> mapUserNames{get;set;}
    public  Map<String,List<User>> mapAccountToUsers{get;set;}
    public  Sub_PDK__c objSubPDK{get;set;}  
    public  List<accUserWrapper> lstAccUserWrapper{get;set;}    
    public  Boolean isValidProfile{get;set;}    
    public  Id objSubPDKId{get;set;}
    public Map<String, Profiles_for_Provisioning__c> mapPFP = Profiles_for_Provisioning__c.getAll();
    
    
    public ClsDeProvisionSubPDKController(ApexPages.StandardController controller){
        
        Set<Id> setProfileIds = new Set<Id>();
        Set<String> setAccountIds = new Set<String>();
        Set<String> setTempIds = new Set<String>();
        Set<Id> setUserIds = new Set<Id>();
        Set<String> setUserIdsProvisioned = new Set<String>();
        List<Account> lstAccounts = new List<Account>();
        isValidProfile = false;
        
        setProfileIds.addAll(getValidProfiles());
        if(setProfileIds!=null && setProfileIds.contains(UserInfo.getProfileId())){
            isValidProfile = true;  
        }
        else{
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'You do not have proper permission for provisioning this sub pdk.');
            ApexPages.addMessage(myMsg);
        }
        
        objSubPDKId = controller.getId();
        
        if(objSubPDKId!=null){
            
            objSubPDK = retrieveSubPDKInfo(objSubPDKId);
                        
            lstAccUserWrapper = new List<accUserWrapper>();
            mapAccountToUsers = new Map<String,List<User>>();
            setUserIdsProvisioned.addAll(getAllExistingProvisionings(objSubPDKId));
                    
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
    
    public Set<String> getAllExistingProvisionings(Id subPDKId){
        
        Set<String> setUserIds = new Set<String>();
        
        for(Document_Provisioning__c dp:[Select User__c, Sub_PDK__c, Status__c from Document_Provisioning__c where Sub_PDK__c =: subPDKId AND Status__c = 'Provisioned']){
            setUserIds.add(dp.User__c); 
        }
        return setUserIds;
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
    
    public  List<accUserWrapper> addUserAccountInfoToWrapper(List<Account> lstAcc){
        
        List<accUserWrapper> lstAccWrap = new List<accUserWrapper>();
        
        for(Account acc: lstAcc){
            accUserWrapper objAccUserWrap = new accUserWrapper();
            List<User> lstUser = new List<User>();
            objAccUserWrap.accId = acc.Id;
            objAccUserWrap.accName = acc.Name;
            objAccUserWrap.accIsChecked = false;
            objAccUserWrap.mapUserIdToChecked = new Map<String, Boolean>();
            objAccUserWrap.Sortedcontactlist= new List<User>(); //Cognizant added on 25/11/2013

            if(mapAccountToUsers!=null && mapAccountToUsers.containsKey(acc.Id)){
                lstUser.addAll(mapAccountToUsers.get(acc.Id));
                objAccUserWrap.lstUserSize = lstUser.size();
                if(lstUser!=null && lstUser.size()>0){
                    for(User objUser: lstUser){
                        
                        objAccUserWrap.mapUserIdToChecked.put(objUser.Id,false);  
                        objAccUserWrap.Sortedcontactlist.add(objUser); //Cognizant added on 25/11/2013
          
                    }       
                }                                   
            }
            objAccUserWrap.Sortedcontactlist.sort();  //Cognizant added on 25/11/2013                                 

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
        
        Sub_PDK__c objSPDK = new Sub_PDK__c();
        
        objSPDK = [Select Id, Name, Sub_PDK_Version__c, Sub_PDK_Revision_Release_Date__c, Sub_PDK_Lifecycle_Phase__c, Sub_PDK_Location_Fab__c,Technology__c,
                 Tech_Geometry__c, Sub_PDK_Sub_class__c, Release_Status__c from Sub_PDK__c
                 where Id =: subPDKId];
                 
        return objSPDK;
            
    }
         
    public  Map<String,List<User>> getAllRelatedUsers(Set<String> setUserIdsProvisioned){
        Map<String,List<User>> mapAccToUsers = new Map<String,List<User>>();
        Set<Id> setUserIds = new Set<Id>();     
        if(setUserIdsProvisioned!=null && setUserIdsProvisioned.size()>0){
            
            mapUserNames = new Map<String,User>();
            mapAccountNames = new Map<String,String>();         
            
            mapAccToUsers = new Map<String,List<User>>();
            for(User objUser:[Select Id,Name,Parent_Account_Id__c,Parent_Account_Name__c,Email,Contact_Created_In_Open_Text__c from User where Id IN:setUserIdsProvisioned and Contact_Created_In_Open_Text__c=true order by Name])//modified by Cognizant for case 00004324
            {
                
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
/*-----------------------added for emergency case 35160  end-------------------------------------------------------*/
                    
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
                    mapDeProvisioning.put(objSubPDKId,lstUsersToBeDeProvisioned);
                    
                    if(mapDeProvisioning!=null && mapDeProvisioning.size()>0){
                        ClsProvisioningHandler controller = new ClsProvisioningHandler();
                        controller.deProvisioningMethod(mapDeProvisioning, 'SubPDK');
                    }
                    
                }
                    
            }
            
            
        }
        
/*-----------commented by cognizant for Case 22278 start---------------------------------------*/        
       /* PageReference pageRef = new PageReference('/'+objSubPDKId);  
        return pageRef;*/
/*-----------commented by cognizant for Case 22278 end---------------------------------------*/    
/*-----------added by cognizant for Case 22278 start---------------------------------------*/        
        if(noContacts==false)
        {
        PageReference pageRef = new PageReference('/'+objSubPDKId);  
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
        public Boolean accIsChecked{get;set;}
        public Map<String, Boolean> mapUserIdToChecked{get;set;}
        public Integer lstUserSize{get;set;}
        public List<User> Sortedcontactlist{get;set;}//Cognizant added on 25/11/2013


    
    }
    
    

}