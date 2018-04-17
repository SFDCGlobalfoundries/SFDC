/*
Type Name: UserCreationForPortals Trigger
Author: Ashish Jadhav
Created Date: 12-02-2016
Reason: 
Change History:
Author: Global Foundries (Dinesh M Suggala)
Modified Date: 09-02-2017
Reason: Added the Functionality for Valid Email Domain. Whenever the email is changed in Contact the Corresponding User's Email related to Contact will get updated
��..
��..
*/
trigger UserCreationForPortals on Contact (after insert,after update) {
    if(trigger.isAfter && trigger.isUpdate && !system.isFuture()){
        UserCreationForPortalsHelper.UserCreationHelperMethod(trigger.new,trigger.oldMap);
        
        //Added by Dinesh on 12/1/2017 for Email Domain (Vijit) 
        Map<String, Contact> setUnamesCon = new Map<String, Contact>();       
        Map<String,Account> MapAcc=new Map<String,Account>(); 
        set<Id> accIdset=new set<Id>();
        for(Contact c:Trigger.New){
        accIdset.add(c.AccountId);
        }
        for(Account a:[Select Id,Valid_Email_Domain__c from Account where Id IN:accIdset]){
         for(Contact c:Trigger.New){
          if(c.AccountId==a.Id){
          MapAcc.put(c.Id,a);
          }
         }
        }
        for(Contact c : Trigger.new) {

            if (c.Email != Trigger.oldMap.get(c.Id).Email && c.Is_Portal_User_Active__c ==true) {
                
                String sepEmail=c.Email;
                
                if(MapAcc.get(c.Id).Valid_Email_Domain__c!=null && !(MapAcc.get(c.Id).Valid_Email_Domain__c.contains(sepEmail.SubStringAfter('@')))&& !sepEmail.Contains('@globalfoundries.com')){
                c.addError('The email domain of the contact does not match the valid email domain defined at the account');
                }
                else {
                setUnamesCon.put(c.Id,c);
                }
            } 
        }
            
        if(setUnamesCon.size()>0 && !setUnamesCon.isEmpty()){
        UserCreationForPortalsHelper.UpdateUserEmailSametoContactEmailMethod(setUnamesCon);    
    }
   }
}