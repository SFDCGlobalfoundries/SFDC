/*
Type Name: CreateSharingOnContact Trigger
Author: Cognizant 
Created Date: 25-April-2013
Reason: This trigger is used for Adding Sharing on Contacts when the Contact is converted into Portal Users. 
        It gets the Account Hierarchy for the newly created Portal User and creates sharing records for the Portal User.
Change History:
Author: 
Modified Date: 5/22/2013
Reason: Query and code optimization
……..
……..
*/
trigger CreateSharingOnContact on Contact (after Insert, after  Update, before Update, before insert) {
    public final String CreateSharingOnContactCheck = EnvironmentVariable.get('CreateSharingOnContactCheck');
    if (trigger.isUpdate && trigger.isAfter) { 
        if (!ClsContactTriggerHandler.blnContactShareRun) {
            ClsContactTriggerHandler.blnContactShareRun=true;
            List<Contact> contactList = new List<Contact>();
            List<Id> acctList = new List<Id>();      
            Set<Id> contactIdSet = new Set<Id>();  
            Map<Id, ID> childParentMap = new Map<Id, Id>();  
            Set<Id> parentIdSet = new Set<Id>();
            Set<Id> accountidSet = new Set<Id>();  
            Map <Id, Id> idAccContactMap = new Map<Id, Id>(); 
            Map <Id, List<Id>> mapAccountContact= new Map<Id, List<Id>>(); 
            Map <Id, Id> mapParentparentAccount= new Map<Id, Id>(); 
            Map<Id, List<id>> parentChildMap = new Map<Id, List<id>>();
            Map<Id, ID> userAccountMap = new Map<Id, Id>();
            Map<Id, ID> userContactmap= new Map<Id, Id>(); 
            Set <Id> innerparentId = new Set<Id>();
            List<id> childList = new List<Id>();  
            List<id> contactIdsList = new List<Id>(); 
            for(Contact contactObj :  trigger.new){
               system.debug('contactObj.Is_Portal_User_Active__c--->'+contactObj.Is_Portal_User_Active__c);//offshore
               system.debug('trigger.oldMap.get(contactObj.ID).Is_Portal_User_Active__c' +trigger.oldMap.get(contactObj.ID).Is_Portal_User_Active__c);//offshore
                //if (contactObj.Is_Portal_User_Active__c==true && trigger.oldMap.get(contactObj.ID).Is_Portal_User_Active__c==false) {
                  if (contactObj.Is_Portal_User_Active__c==true && trigger.oldMap.get(contactObj.ID).Is_Portal_User_Active__c==Boolean.ValueOf(CreateSharingOnContactCheck)) {
                    contactIdSet.add(contactObj.Id);
                    accountidSet.add(contactObj.AccountId);
                    contactIdsList=new List<Id>();
                    if (mapAccountContact.containsKey(contactObj.AccountId)){contactIdsList=mapAccountContact.get(contactObj.AccountId);contactIdsList.add(contactObj.ID);mapAccountContact.put(contactObj.AccountId,contactIdsList);         
                    }else {
                        contactIdsList.add(contactObj.ID);
                        mapAccountContact.put(contactObj.AccountId,contactIdsList);         
                    }
                   
                }
            }

            for (Account acctObj : [Select Parent.ParentId, ParentId, Id From Account Where Id IN:accountidSet]) {
                childParentMap.put(acctObj.Id, acctObj.ParentId);
                mapParentparentAccount.put(acctObj.ParentId,acctObj.Parent.ParentId);
            }
        
            for(Account acc : [Select Id,ParentId from Account where ParentId in: accountidSet]) {if(innerparentId.contains(acc.ParentId)) {childList.add(acc.Id);
                }else {
              childList = new List<Id>() ;                                      
                    innerparentId.add(acc.ParentId);
                    childList.add(acc.Id);
                }
                parentChildMap.put(acc.ParentId, childList);
            }       
            for(Account acc : [Select Id,ParentId from Account where ParentId in: childList]) {if(innerparentId.contains(acc.ParentId)) {childList.add(acc.Id);
                } else {
              childList = new List<Id>() ;                                   
                    innerparentId.add(acc.ParentId);
                    childList.add(acc.Id);
                }
                parentChildMap.put(acc.ParentId, childList);
            }    
         
            for(user u : [SELECT Id,ContactId FROM User where IsPortalEnabled = true and IsActive = true and ContactId IN: contactIdSet]) {userContactmap.put(u.ContactId, u.Id);
            }
         
            ClsAccTriggerHandler.createSharingOnAccount(accountidSet, childParentMap, mapAccountContact, userContactmap, parentChildMap, mapParentparentAccount);
        }
    }                
    
   if(trigger.isUpdate && trigger.isAfter){ 
         Set<Id> contactIds = new Set<Id>();
         Map<Id,String> contactDepts = new Map<Id,String>();            
         for(Contact objContact: trigger.new){
            if(objContact.Department__c != Trigger.oldMap.get(objContact.ID).Department__c){
                contactIds.add(objContact.ID);
                contactDepts.put(objContact.ID,objContact.Department__c);
            }   
         }
         if(contactIds!=null && contactIds.size()>0){           
            ClsContactTriggerHandler.updatePortalTabAccess(contactIds, contactDepts);
         }  
   }
    
   if(trigger.isInsert && trigger.isBefore){
       Contact objContact = trigger.new[0];
       List<Contact> childContactList = new List<Contact>();
       Integer countContacts;
       String parentContactId;
       //Account accRecord=[Select Id,Name from account where Id=:objContact.accountId and Name='TEST GLOBALFOUNDRY ACCOUNT'];
       List<Account> accList=[Select Id,Name from account where Id=:objContact.accountId and Name=:System.Label.GlobalfoundryAccount];
       if(accList.size()==0){  
        if(objContact.accountId!=null){
           parentContactId = objContact.accountId;
           countContacts = [Select COUNT() from Contact where accountId =: parentContactId]; 
           
           if(countContacts==0){
               if(objContact.Role__c!=null){
                      if(!objContact.Role__c.contains('Primary Account Admin')){
                            objContact.Role__c = objContact.Role__c + ' ; Primary Account Admin';
                       }
               }
               else{
                      objContact.Role__c = 'Primary Account Admin';    
                }               
           }
           else if(objContact.Role__c!=null && objContact.Role__c.contains( 'Primary Account Admin')){
               objContact.addError(' Only the first Contact of an Account can have the Primary Account Admin Role. Choose another role  ');    
           }               
       }
      } 
       
   }

   if(trigger.isUpdate && trigger.isAfter){         
        set<String> setPortalLogins = new set<String>();
        for(Contact objContact:trigger.new){
            if(!objContact.is_Portal_User_Active__c && Trigger.oldMap.get(objContact.ID).is_Portal_User_Active__c){   
                //added by cognizant on 17thdec2013
                if(objContact.Login_Id__c!=null)   setPortalLogins.add(objContact.Login_Id__c.toLowerCase());                                   
            }           
        }
        if(setPortalLogins!=null && !(setPortalLogins.isEmpty())){
            System.debug (' ** Value of Set of Portal Login Ids is ** ' + setPortalLogins);
            if (System.isBatch() || System.isFuture())
            {
                ClsUserTriggerHandler.deleteAccountShortName(setPortalLogins);
            }else{
                ClsUserTriggerHandler.deleteAccountShortNameFuture(setPortalLogins);
            }
        }
    }
    
    if(Trigger.isAfter){
        if(Trigger.isInsert){
            ClsContactTriggerHandler contTriggerHandler = new ClsContactTriggerHandler(Trigger.isExecuting, Trigger.size);
            contTriggerHandler.OnAfterInsert(Trigger.new);
        }
        if(Trigger.isUpdate){
            Contact objContact = trigger.new[0];
            if(objContact.Is_Portal_User_Active__c == false){
                ClsContactTriggerHandler contTriggerHandler =new ClsContactTriggerHandler (Trigger.isExecuting, Trigger.size);
                contTriggerHandler.OnAfterDelete(Trigger.oldMap,Trigger.new);
            } else{
                ClsContactTriggerHandler contTriggerHandler = new ClsContactTriggerHandler(Trigger.isExecuting, Trigger.size);
                contTriggerHandler.OnAfterUpdate(Trigger.oldMap,Trigger.new);  
            }
        }
    }
}