/*
* @ Author :- Ram Rai
* @ Description :- Class contains logic for Custom look up for subscribing other User.
* @ Date :- 20/06/2017

Change History:
    DATE            NAME                    Comments

    28-Jun-2017     Ram Rai                 Removed Hard Coding.
    03-Jul-2017     Ram Rai                 Removed the Code for Map Of users            
    10-Jul-2017     Ram Rai                 Added the code to Display FMS enabled Contact #issue 393
    20-Jul-2017 	Ram Rai					modified the query for subscription logic

**/

public class FMSSubscribeLookupController{
public List<User> users { get; set; }  
public Id frmId{get;set;}
public Form_Management_System__c formObj {get;set;}
public List<Contact> lstCont;
public Set<Id> permSetId;
public Set<Id> accId = new Set<Id>();
public Set<Id> accId1 = new Set<Id>();
public Map<Id,Id> accPrt = new Map<Id,Id>(); 
public Map<Id,List<Account>> accMap = new Map<Id,List<Account>>();    
Map<Id,List<String>> accountHierarchyMap = new Map<Id,List<String>>();
public Set<string> customerLeftValues{get;set;}
List<String> acctHierIds = new List<String>();
public set<Id> conId; 
Map<Id,String> prmMap = new Map<Id,String>(); 
public final String FMS_Internal_Users = EnvironmentVariable.get('FMS_Internal_Users'); 
public final String FMS_Admin_Users = EnvironmentVariable.get('FMS_Admin_Users');
public List<Portal_Tab_Access__c> lstTabAcces = new List<Portal_Tab_Access__c>();

    public FMSSubscribeLookupController(){
    
        users = new List<User>();
        set<id> usrId = new  set<id>();
        frmId=  ApexPages.currentPage().getParameters().get('id'); 
        formObj = [SELECT id, name,Customer_Name__c FROM Form_Management_System__c WHERE id = :frmId]; 
        lstCont = [Select id from contact where accountid =: formObj.Customer_Name__c];          
        permSetId = new Set<Id>();
        conId = new Set<Id>();
        customerLeftValues = new Set<String>(); 
             
        Account acc = [select id,parentid from account where id = : formObj.Customer_Name__c];  
        accId.add(acc.id);        
        // Code added by Ram Rai to show FMS enable Contact  
        for (Contact cn:[Select id,(select id from Access_Setup__r where Tapeout_Fab_9_10__c =true limit 1) from contact where accountid =: formObj.Customer_Name__c] ){
            for(Portal_Tab_Access__c pta : cn.Access_Setup__r){
               conId.add(cn.id); 
           }          
        }
        
         List<PermissionSet> permissionSetRecord = new List<PermissionSet>();
         permissionSetRecord = [select id, Label from PermissionSet where Label =: 'FMS Admin Users' or Label =:'FMS Internal Users'];   
         for(PermissionSet   psR: permissionSetRecord){
             prmMap.put(psR.Id,psR.Label);  
         }     
         
         List<PermissionSetAssignment> permissionSetList = new List<PermissionSetAssignment>();
         permissionSetList = [select AssigneeId from PermissionSetAssignment where PermissionSetId in : prmMap.keyset()];
         
         for(PermissionSetAssignment p : permissionSetList){
               
               usrId.add(p.AssigneeId);    
          }
           
          usrId.remove(UserInfo.getUserId());
           
    
        String currentAccId = acc.id;
        
        for(Account_Hierarchy__c ahc : [select parent_id__c,account_id__c from Account_Hierarchy__c where Account_Id__c =:currentAccId ]){
            accId.add(ahc.parent_id__c);
        }
         // Code added by Ram Rai to show FMS enable Contact    
       for(Contact cn : [SELECT id, Name,account.name,(select id from Access_Setup__r where Tapeout_Fab_9_10__c =true limit 1),accountid,Account.SAP_Account_Number__c FROM Contact WHERE (accountid in:accId and ( Is_Portal_User_Active__c =true and Is_Portal_User_Created__c =true))]){                 
		if(cn.Access_Setup__r!=null && cn.Access_Setup__r.size()>0){
           for(Portal_Tab_Access__c pta : cn.Access_Setup__r){
               conId.add(cn.id); 
           }
        }                  
       }
       
       for(User usr : [select id,ContactId  from user where ContactId in :conId]){
           
           usrId.add(usr.id);       
        }    
        //20-7-2017 Ram Rai- modified the query for subscription logic
      users = [SELECT Id, Name, FirstName, LastName, Email, Phone, Profile.Name, Profile.UserType, Account.Name FROM User where id in:usrId];             
    }
}