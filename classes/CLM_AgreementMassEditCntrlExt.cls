/**
 * This Extension Class is used by Mass Edit Agreement.page to update few fields for a set of records.
 * Author: Ruchi Talwaria
 * Created Date: 6/13/2017
 */

public with sharing class CLM_AgreementMassEditCntrlExt {
    
    private ApexPages.StandardController stdController = null;
    public List<Apttus__APTS_Agreement__c> agrList{get;set;}
    public List<User> userlist1 {get;set;}
    public String userEmailID {get; set;}
    public String sClass {get; set;}
    public String searchvalue {get; set;}
    
    public CLM_AgreementMassEditCntrlExt(){
        
    }
    
    public CLM_AgreementMassEditCntrlExt(ApexPages.StandardController stdController){
        this.stdController = stdController;
        userlist1 = new List<User>();
        List<string> IDS = ApexPages.currentPage().getParameters().get('ids').split(',',-2);
        Set<String> values = new Set<String>();
        values.addAll(Environment_Variable__c.getInstance('NDA_MassEdit_RecordTypes').Value__c.split(','));
        if(!IDS.isEmpty() && values != NULL){
            agrList = [select Id,Name,Apttus__FF_Agreement_Number__c,Apttus__Status_Category__c,Apttus__Status__c,GF_Contract_End_Date__c, Warning_Notice_Recipient_1__c,Warning_Notice_Recipient_2__c,Warning_Notice_Recipient_3__c,CLM_Contract_Administrator__c,CLM_Contract_Description__c,CLM_Renewal_Notes__c,CLM_Other_Notes__c
                                                   from Apttus__APTS_Agreement__c where id = :IDS and RecordType.DeveloperName IN: values];            
        }
        
    }
        
    public PageReference doSave() { 
        try{
            if(agrList != NULL && agrList.size() > 0){
                database.update(agrList);                
            }            
        }catch(DMLException e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Failure to perform operation due to following reason:-\n'+e));
                 return null;            
        }        
        PageReference pageRef = RedirectToList();  
        return pageRef; 
    }
    
    
    public PageReference doCancel() {                
        PageReference pageRef = RedirectToList();  
        return pageRef; 
    }
    
    public PageReference RedirectToList() {               
        Schema.DescribeSObjectResult result = Apttus__APTS_Agreement__c.SObjectType.getDescribe(); 
        PageReference pageRef = new PageReference('/' + result.getKeyPrefix()); 
        pageRef.setRedirect(true); 
        return pageRef; 
    }
    
    
    public PageReference userEmailLookUp(){
       
        String searchvalue = searchvalue!=NULL ? searchvalue : '';
        String searchStr = '';
        userEmailID = ApexPages.currentPage().getParameters().get('emailId');
        sClass = ApexPages.currentPage().getParameters().get('sclass');
        if(userEmailID != null && userEmailID != ''){
            searchStr = '%'+userEmailID+'%'; 
        }
        if(searchvalue != null && searchvalue != ''){
            searchStr =  '%'+searchvalue+'%';        			
        }
        if(searchStr != ''){
            userlist1 = [Select id,Name,MobilePhone,Email,Manager.Name from User where Email LIKE :searchStr AND isActive = true AND UserType = 'Standard' ORDER BY NAME];
            if(userlist1.size() == 0){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'No user found'));                
            }
        }
         return null;
           
    }

}