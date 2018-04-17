/*
* @ Author :- navneet Rajput
* @ Company :- CTS
* @ Description :- Class help to de-provision PDK bundle
* @ Change History :-
**/ 

public without sharing class FV_DeProvisioningPDK {
    
    public Id objSubPDKId{get;set;}
    public  Sub_PDK__c objSubPDK{get;set;}
    public Map<String, Profiles_for_Provisioning__c> mapPFP = Profiles_for_Provisioning__c.getAll();
    public List<AccountWapper> searchResult {get; set;}
    public Boolean isValidProfile {get;set;}
    public List<Id> lstOfSelectedAccounts;
    public Boolean isReadyForProvisioning{get;set;} 
    public FV_DeProvisioningPDK(ApexPages.StandardController controller){
        
        Set<Id> setProfileIds = new Set<Id>();
        isValidProfile = false;
        isReadyForProvisioning = false;
        setProfileIds.addAll(getValidProfiles());
        
        if(setProfileIds!=null && setProfileIds.contains(UserInfo.getProfileId())){
            isValidProfile = true;  
        }
        else{
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'You do not have proper permission for provisioning this sub pdk.');
            ApexPages.addMessage(myMsg);
        }
        objSubPDKId = controller.getId();
        
        if (objSubPDKId<>NULL){
            
            objSubPDK = retrieveSubPDKInfo(objSubPDKId);
            if(objSubPDK.Ready_For_Provisioning__c)
                isReadyForProvisioning = true;
            else{
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'You cannot De-Provisioned Bundle untill ready for provisioning checkbox is checked.');
                ApexPages.addMessage(myMsg);                
            }
            searchResult =new list<AccountWapper>();
            list<Document_Provisioning__c> DPList = new list<Document_Provisioning__c>();
            set<ID> accIds = new set<ID>();
            map<ID,Account> accMap = new map<ID,Account>();    
             DPList  = [SELECT AccountID__c,AccountID__r.Name,AccountID__r.Site_Department__c,AccountID__r.Stage__c,AccountID__r.Parent_Account_Name__c,
                                                     AccountID__r.Parent_Account_Short_Name__c,AccountID__r.Short_Name__c,Sub_PDK__c, Status__c 
                                             FROM   Document_Provisioning__c 
                                             WHERE  Sub_PDK__c =: objSubPDKId 
                                             AND    Status__c = 'Provisioned' order by AccountID__r.Short_Name__c];
            for(Document_Provisioning__c dp :DPList){
                if(dp.accountID__c != null)
                    accIDs.add(dp.accountID__c);
            }   
            if(!accIDs.isEmpty())            
            accMap = new map<ID,Account>([SELECT ID,Name,Site_Department__c,Stage__c,Short_Name__c,ASIC_Business_Flag__c,Parent_Account_Name__c ,Parent_Account_Short_Name__c  FROM Account WHERE ID IN: accIDs]);                                                           
            for(Document_Provisioning__c dp :DPList){//modified for Case 42841
                if (dp<>NULL && accMap != null && accMap.containsKey(dp.accountID__c) ){
                    AccountWapper accWrapper = new AccountWapper();
                     accWrapper.acct = accMap.get(dp.accountID__c);                    
                 /*  accWrapper.acct = new Account(Id=dp.AccountID__c,Name = dp.AccountID__r.Name,
                                                 Site_Department__c = dp.AccountID__r.Site_Department__c,
                                                 Stage__c = dp.AccountID__r.Stage__c,
                                                 Short_Name__c = dp.AccountID__r.Short_Name__c);
                  */                               
                   searchResult.add(accWrapper);
                }
                 
            }
        } 
        
        if (searchResult == NULL || searchResult.isEmpty()){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'No Accout available for deprovisioning.');
            ApexPages.addMessage(myMsg);
        }
        // Get All provisioned DP records 
    }
    
    // Get valid profiles for deprovision PDK
    public  Set<Id> getValidProfiles(){
        
        Set<Id> setProfileIds = new Set<Id>();
        
        if(mapPFP!=null && mapPFP.size()>0){
            for(Profile objProfile: [Select Id, Name from Profile where Name IN: mapPFP.KeySet()]){
                 setProfileIds.add(objProfile.Id);
             }
        }
         
        return setProfileIds;
    }
    // Retrive PDK information
    public  Sub_PDK__c retrieveSubPDKInfo(Id subPDKId){
        
        Sub_PDK__c objSPDK = new Sub_PDK__c();
        
        objSPDK = [Select Id, Name, Sub_PDK_Version__c, Sub_PDK_Revision_Release_Date__c, Sub_PDK_Lifecycle_Phase__c, Sub_PDK_Location_Fab__c,Technology__c,
                 Tech_Geometry__c, Sub_PDK_Sub_class__c, Release_Status__c,Ready_For_Provisioning__c,PDK_Bundle_ASIC__c from Sub_PDK__c
                 where Id =: subPDKId];
                 
        return objSPDK;
            
    }
    
    // Method help to do de-provisioning
    public pageReference doDeProvisioning(){
        
        List<Document_Provisioning__c> lstOfDpToDeprovision = new List<Document_Provisioning__c>();
        try {
            if (isAccSelected()){
                List<Id> listOfSubPDKIds = new List<Id>();
                if (objSubPDKId<>NULL){
                    //listOfSubPDKIds.add(objSubPDKId);
                    FV_DocumentProvisioningUtil.deprovisionPDK(objSubPDKId, lstOfSelectedAccounts);
                }
                /*if (lstOfSelectedAccounts<>NULL && !lstOfSelectedAccounts.isEmpty()){
                    for (Document_Provisioning__c DP : [SELECT Id,Status__c,AccountID__c FROM Document_Provisioning__c 
                                                        WHERE Sub_PDK__c =: objSubPDKId 
                                                        AND Status__c = 'Provisioned' 
                                                        AND AccountID__c IN : lstOfSelectedAccounts]){
                                                            
                        DP.Status__c = 'De-Provisioning In Progress';
                        DP.Sync_With_OpenText__c = false;                   
                        lstOfDpToDeprovision.add(DP);                    
                    }                       
                }
                system.debug('lstOfDpToDeprovision>>>>>>>>>>>'+lstOfDpToDeprovision);
                if (lstOfDpToDeprovision<>NULL && !lstOfDpToDeprovision.isEmpty()){
                    
                    update lstOfDpToDeprovision;
                }*/
                
            } else {
                system.debug('Inside else select at least one Account ###########');
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please select at least 1 Account for PDK De-Provisioning.'));
                return null;
            }
        
        } catch (Exception e){
            system.debug('Exception ::  '+e.getMessage());
        }
        
        return new PageReference('/'+objSubPDKId);
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
        system.debug('lstOfSelectedAccounts>>>>>>>>>>>>'+lstOfSelectedAccounts);
        if (lstOfSelectedAccounts<>Null && !lstOfSelectedAccounts.isEmpty()){
            isSelected = true;
        }
        return isSelected;
    }
    
    public PageReference back(){
        
        return new PageReference('/'+objSubPDKId);
    }
    
    public class AccountWapper{
         public Account acct {get; set;}
         public boolean selected {get;set;}
         public AccountWapper(){
             if(acct==null){acct = new Account();}
         }
    }
    
}