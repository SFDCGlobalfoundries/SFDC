/*
Type Name: UpdateAccountManager Trigger
Author: Cognizant 
Created Date: 11th May-2013
Reason: This trigger is used for updaing the Account manager and customer portal admin field in contact.
Change History: 
Author:  Amit Kumar Ojha
Modified Date: 19th July 2017
Reason: Invoked the ITAR Certification Helper Class for Portal Users
Author:  Dinesh Suggala
Modified Date: 12th March 2018
Reason: Invoked the method uncheckptabitaraccess
……..
……..
*/


trigger UpdateAccountManager on Contact (after insert, after update) 

{
   if(Trigger.isAfter) { 
       if(Trigger.isInsert){  
           List<Contact> contactList = new List<Contact>();
           List<Id> accIdList = new List<Id>();
           for(contact contactObj: trigger.new)
           {
               accIdList.add(contactObj.AccountId);
           }
           if(accIdList.size()>0)
           {  
                ClsAccTriggerHandler.updateManager(accIdList);
           }
       }
       if(!IntegrationUserUtil.isSkipTrigger()) {
           if(Trigger.isUpdate) {
           set<Id> conset=new set<Id>();
               for(Contact con : Trigger.new) {
                   if(con.ITAR_Access_Requested__c != null && con.ITAR_Access_Requested__c == true && Trigger.oldmap.get(con.Id).ITAR_Access_Requested__c == false) {
                        ITAR_Certified_Utility.appProvisionExternalUserAlert(Trigger.oldMap, Trigger.newMap);
                   }    
                    else if(con.ITAR_Certified__c!=null && con.ITAR_Certified__c==false && Trigger.oldmap.get(con.Id).ITAR_Certified__c== true){
                       conset.add(con.Id);                      
                    }      
               }
               ITAR_Certified_Utility.uncheckptabitaraccess(conset);
           }
       }
   }       
}