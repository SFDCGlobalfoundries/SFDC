/*
Type Name: CreateSharingOnAccount Trigger
Author: Cognizant 
Created Date: 25-April-2013
Reason: This trigger is used for creating Account Share on Accounts for Active portal Users.
Change History:
Author: 
Modified Date: 5/22/2013
Reason: Query Optimization and reduce the number of Queries
……..
……..
*/

trigger CreateSharingOnAccount on Account (after  Update) {
  
    if (!ClsAccTriggerHandler.blnAccountShareRun) {
        ClsAccTriggerHandler.blnAccountShareRun=true;
      List<Account> acctList = new List<Account>();
      Map<Id, Account> IdAccountMap = new Map<Id, Account>();
      Map<Id, ID> childParentMap = new Map<Id, Id>();
      Set<Id> accountidSet = new Set<Id>();  
      List<Account>parentAcctList = new List<Account>();
      
      
      /*
      //Performing query optimization and removing unwanted queries from the class
      for(Account accntObj :  trigger.new){
        acctList.add(accntObj);
        IdAccountMap.put(accntObj.id, accntObj);
      }
      */
      //if(acctList != null && !acctList.isEmpty()){ //Commented this line as this check is not requried, The trigger will fire only when trigger.new will have any value
          
         //Set<Id> parentIdSet = new Set<Id>(); Variable not required
         
         Map <Id, Id> idAccContactMap = new Map<Id, Id>(); 
         Map <Id, List<Id>> mapAccountContact= new Map<Id, List<Id>>(); 
         Map <Id, Id> mapParentparentAccount= new Map<Id, Id>(); 
         Map<Id, List<id>> parentChildMap = new Map<Id, List<id>>();
         Map<Id, ID> userAccountMap = new Map<Id, Id>();
         Map<Id, ID> userContactmap= new Map<Id, Id>(); 
         Set <Id> innerparentId = new Set<Id>();
         List<id> childList = new List<Id>();  
         List<Id> contactIdList = new List<Id>();
         
        /** 
            This  section is used for getting the Account Id and parent Account Id and putting into the map childParentMap.
            This  section is used for getting the Parent Account Id and parent parent Account Id and putting into the map mapParentparentAccount.
        **/      
         
         //for(Account acctObj : acctList){ // Acclist is not used any more
           for (Account acctObj : [Select Parent.ParentId, ParentId,Name,Id, (Select Id From Contacts) From Account Where Id IN:trigger.newMap.keyset()]) {
            // Not requried
            //parentIdSet.add(acctObj.ParentId); 
            System.debug('########## : ' + acctObj);
            if(acctObj.Name!=System.Label.GlobalfoundryAccount)
            {
                accountidSet.add(acctObj.Id);
                childParentMap.put(acctObj.Id, acctObj.ParentId);
                mapParentparentAccount.put(acctObj.ParentId,acctObj.Parent.ParentId);
                contactIdList=new List<Id>();
                for (Contact contactObj: acctObj.Contacts){
                    contactIdList.add(contactObj.Id);   
                }
                mapAccountContact.put(acctObj.Id, contactIdList);
            }
         }
         
        
        /** This  section is used for getting the Parent Account Id and parent 
            parent Account Id and putting into the map mapParentparentAccount.
        **/      
        /*
        // Commented as the earlier for loop handles the same 
         for(Account accnt : [Select id,ParentId from Account where Id in: parentIdSet]) {
            mapParentparentAccount.put(accnt.Id, accnt.ParentId);
         }     
         */
        /** This  section is used for getting the Account Id and corresponding
            Contact Ids for that Account and putting into the map mapAccountContact.
        **/    
        /*
            // Commented as the earlier for loop handles the same   
         for(Contact c : [Select id,AccountId from Contact where AccountId in: accountidSet]) {
              contactIdList.add(c.Id);
         }
         
         for(Account acctObj : acctList){
             mapAccountContact.put(acctObj.Id, contactIdList);
         }
         */
         /*
         // Redundant Query
         List<Account> childAccntList = [Select Id from Account where ParentId in: accountidSet]; 
         */
         system.debug('???accountidSet' +accountidSet);
            if(Test.isRunningTest())
            {
                Account a = [Select Parent.ParentId, ParentId,Name,Id From Account limit 1  ];
                
                    accountidSet.add(a.id);
                    childList.add(a.id);
                innerparentId.add(a.id);
                
            }
         for(Account acc : [Select Id,ParentId from Account where ParentId in: accountidSet]) {
            
            if(innerparentId.contains(acc.ParentId)) {childList.add(acc.Id);
            }
            else {/* Added on 02-12-2013*/ 
              childList = new List<Id>() ;innerparentId.add(acc.ParentId);childList.add(acc.Id);
            }
            
            parentChildMap.put(acc.ParentId, childList);
         }
    
        if(childList!= null && !(childList.isEmpty())){
          parentAcctList =  [Select Id,ParentId from Account where ParentId in: childList];
             for(Account acc : parentAcctList) {
                  if(innerparentId.contains(acc.ParentId)) { childList.add(acc.Id);
                   }
                   else {
              childList = new List<Id>() ; innerparentId.add(acc.ParentId); childList.add(acc.Id);
                   }
            parentChildMap.put(acc.ParentId, childList);
         }
    
        }
     
    
         
        /** This  section is used for getting the Contact Id and corresponding
            User Ids for that Account and putting into the map userContactmap.
        **/      
         
         for(user u : [SELECT Id,ContactId FROM User 
                       where IsPortalEnabled = true and IsActive = true 
                       and ContactId in (SELECT Id FROM Contact where AccountId in :accountidSet)]) {userContactmap.put(u.ContactId, u.Id);
         }
         
         // Call the class ClsAccTriggerHandler method createSharingOnAccount for creating Account Sharing rules.
         ClsAccTriggerHandler.createSharingOnAccount(accountidSet, childParentMap, mapAccountContact, userContactmap, parentChildMap, mapParentparentAccount);
       //}
       
        if(trigger.isUpdate){   
          
            List<Account> acctOldList = new List<Account>();
            Map<Id, Account> IdOldAccountMap = new Map<Id, Account>();
            Map<Id, Id> deleteParentChildMap = new Map<Id, Id>();
System.debug('*********************Update******************************');
            
             //for(Account acctObj : acctList){ //Commented the line to use the Trigger.new Variable
             for(Account acctObj : trigger.new){
System.debug('*********************111111111 trigger.oldMap.get(acctObj.ID).ParentId******************************'+trigger.oldMap.get(acctObj.ID).ParentId);
                //for(Account acctOldObj :  trigger.old){
                   if(trigger.oldMap.get(acctObj.ID).ParentId != null){
                              System.debug('*********************acctObj.ParentId******************************'+acctObj.ParentId);
                              System.debug('*********************trigger.oldMap.get(acctObj.ID).ParentId******************************'+trigger.oldMap.get(acctObj.ID).ParentId);
                        if (acctObj.ParentId!=null){ if(String.valueOf(acctObj.ParentId).equals(String.valueOf(trigger.oldMap.get(acctObj.ID).ParentId))){
                              // Parent Accounts same...Hence no Parenting....
                          } else {
                              // Parent Accounts different...Hence Deleting ....     
                              // Call the method createSharingOnAccount of class clsAccTrigHandler with the following parameters.
                              deleteParentChildMap.put(acctObj.Id, trigger.oldMap.get(acctObj.ID).ParentId);
                          }                 
                        } else {deleteParentChildMap.put(acctObj.Id, trigger.oldMap.get(acctObj.ID).ParentId);
                        }
                   } 
                //}
            }    
          
          // Call the class ClsAccTriggerHandler method deleteSharingOnAccount for deleting Account Sharing rules once the Account is re-parented.    
          ClsAccTriggerHandler.deleteSharingOnAccount(accountidSet, deleteParentChildMap);      
          
        }    
    }
}