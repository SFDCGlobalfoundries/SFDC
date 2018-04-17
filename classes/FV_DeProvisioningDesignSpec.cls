/*
Type Name: FV_DeProvisioningDesignSpec 
Author :- Kunal Patil
Company :- CTS
Created Date: 07-April-2015
Reason: This class is used for deprovisioning documents.
*/
public class FV_DeProvisioningDesignSpec{

    public  Map<String,String> mapAccountNames{get;set;}
    public  Map<String,User> mapUserNames{get;set;}
    public  Map<String,List<User>> mapAccountToUsers{get;set;}
    public  Design_Spec__c objDesignSpec{get;set;}  
    //public  List<accUserWrapper> lstAccUserWrapper{get;set;}    
    public  Boolean isValidReleaseStatusForProvisioning{get;set;}
    public  Boolean isValidProfile{get;set;}
    public  Boolean isValidTechGeometry{get;set;}
    public  Boolean isValidSpecificationType{get;set;}  
    public  Id objDesignSpecId{get;set;}
    public List<AccountWapper> searchResult {get; set;}
    
    public List<Id> lstOfSelectedAccounts;
    public Map<String, Restricted_Tech_Geometry__c> mapRTG = Restricted_Tech_Geometry__c.getAll();
    public Map<String, Profiles_for_Provisioning__c> mapPFP = Profiles_for_Provisioning__c.getAll();
    public boolean provionsedUser{get;set;} //added by cognizant for Case 34664
    public FV_DeProvisioningDesignSpec(ApexPages.StandardController controller){
        
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
        objDesignSpecId = controller.getId();
        
        if(objDesignSpecId!=null){
            searchResult =new list<AccountWapper>();
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
            list<Document_Provisioning__c> DPList = new list<Document_Provisioning__c>();
            set<ID> accIds = new set<ID>();
            map<ID,Account> accMap = new map<ID,Account>(); 
            DPList = [SELECT AccountID__c,AccountID__r.Name,AccountID__r.Site_Department__c,AccountID__r.Stage__c,AccountID__r.Parent_Account_Name__c,
                                                     AccountID__r.Parent_Account_Short_Name__c,AccountID__r.Short_Name__c,AccountID__r.ASIC_Business_Flag__c,Sub_PDK__c, Status__c 
                                             FROM   Document_Provisioning__c 
                                             WHERE  Design_Spec__c =: objDesignSpecId 
                                             AND    (Status__c = 'Provisioned' OR Status__c ='IPLAProvision' OR Status__c ='IPLADeprovision') order by AccountID__r.Short_Name__c];
            
             for(Document_Provisioning__c dp :DPList){
                if(dp.accountID__c != null)
                    accIDs.add(dp.accountID__c);
            }
            
            if(!accIDs.isEmpty())            
            accMap = new map<ID,Account>([SELECT ID,Name,Site_Department__c,Stage__c,Short_Name__c,ASIC_Business_Flag__c,Parent_Account_Name__c ,Parent_Account_Short_Name__c  FROM Account WHERE ID IN:accIDs]);                                                           
                                             
             
                                                         
            for(Document_Provisioning__c dp : DPList ){//modified for Case 42841
                if (dp<>NULL && accMap != null && accMap.containsKey(dp.accountID__c)){
                    AccountWapper accWrapper = new AccountWapper();
                    accWrapper.acct = accMap.get(dp.accountID__c);    
                   /*accWrapper.acct = new Account(Id=dp.AccountID__c,Name = dp.AccountID__r.Name,
                                                 Site_Department__c = dp.AccountID__r.Site_Department__c,
                                                 Stage__c = dp.AccountID__r.Stage__c,
                                                 Short_Name__c = dp.AccountID__r.Short_Name__c);
                   */                              
                 
                   searchResult.add(accWrapper);
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
 for(GroupMember objmember:lstmember)
 {
  SetofUserId.add(objmember.UserOrGroupId);
 }
  
   if(!(SetofUserId.contains(UserInfo.getUserId())))
   {
   isDSGroup=false;
   }
   else
    
   {
   system.debug('enter if$$$');
   isDSGroup=True;
   }
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
                 Technology_Geometry__c, Source__c, Specification_sub_class__c, Release_Status__c,Specification_ASIC_Flag__c from Design_Spec__c
                 where Id =: specId];
                 
        return objDS;
            
    }
    
    // Method help to do de-provisioning
    public pageReference doDeProvisioning(){
        
        List<Document_Provisioning__c> lstOfDpToDeprovision = new List<Document_Provisioning__c>();
        try {
            if (isAccSelected()){
                List<Id> listOfSubPDKIds = new List<Id>();
                if (objDesignSpecId<>NULL){
                    FV_DeProvisioningDesignSpec.deprovisionDesignSpec(objDesignSpecId, lstOfSelectedAccounts);
                }
            } else {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please select at least 1 Account for PDK De-Provisioning.'));
                return null;
            }
        
        } catch (Exception e){
            system.debug('Exception ::  '+e.getMessage());
        }
        
        return new PageReference('/'+objDesignSpecId);
    }
    
    // Method help to check if account is selected for provisioning or not
    public boolean isAccSelected(){
        
        Boolean isSelected = false;
        lstOfSelectedAccounts = new List<Id>();
        
        if(searchResult<>Null && !searchResult.isEmpty()){
            for (AccountWapper wrapper : searchResult){
                if (wrapper.selected){
                    lstOfSelectedAccounts.add(wrapper.acct.Id);
                }
            }                   
        }
        if (lstOfSelectedAccounts<>Null && !lstOfSelectedAccounts.isEmpty()){
            isSelected = true;
        }
        return isSelected;
    }
    
    /*
    * @ Author :- Kunal Patil
    * @ Company :- CTS
    * @ Date  :- 07/04/2015
    * @ Description :- Method will help to deprovision accounts when it is removed from white list of Design spec 
                        or user explicitly click on deprovision button   
    **/
    
    public static boolean deprovisionDesignSpec(Id objDesignSpecId,List<ID> accList){ 
        List<Document_Provisioning__c> lstOfDpToDeprovision = new List<Document_Provisioning__c>();
        List<Document_Provisioning__c> listOfDpRecords = new List<Document_Provisioning__c>();
        Boolean isTrue = false;
        listOfDpRecords =[SELECT Sub_PDK__r.Sub_PDK_OpenText_Id__c,AccountID__c,is_De_Prov_From_UI__c
                                                            FROM Document_Provisioning__c
                                                            WHERE (Status__c = 'Provisioned' OR Status__c ='IPLAProvision' OR Status__c ='IPLADeprovision')
                                                            AND AccountID__c IN : accList
                                                            AND Design_Spec__c =:objDesignSpecId];
        try {
            if (listOfDpRecords<>NULL && !listOfDpRecords.isEmpty()){
                for (Document_Provisioning__c DP : listOfDpRecords){
                    if(DP<>NULL){                                   
                        DP.Status__c = 'De-Provisioning In Progress';
                        if(!system.isFuture() && !system.isBatch() && !dp.is_De_Prov_From_UI__c){
                           dp.is_De_Prov_From_UI__c=true;   
                        }
                        lstOfDpToDeprovision.add(DP);
                    }                    
                }                       
            }
            if (lstOfDpToDeprovision<>NULL && !lstOfDpToDeprovision.isEmpty()){
                isTrue = true;
                update lstOfDpToDeprovision;
            }
        } catch (Exception e){
            system.debug('Exception ::  '+e.getMessage());
        }
        return isTrue;
    }
    
    public class AccountWapper{
         public Account acct {get; set;}
         public boolean selected {get;set;}
         public AccountWapper(){
             if(acct==null){acct = new Account();}
         }
    }
    

}