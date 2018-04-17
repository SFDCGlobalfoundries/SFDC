/*
Type Name: ClsUpdateAccountDeactivationError 
Author: Cognizant
Created Date: 26-April-2013
Reason: This batch class is used to marks the account for which the user deactivation has failed while inactivating the account. 
Change History:
Author: 
Modified Date: 
Reason: 
……..
…….. 
*/
global class ClsUpdateAccountDeactivationError implements Database.Batchable<sObject>
{
    String Query;
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        query='Select id ,Name,Stage__c,Portal_User_Deactivation_Error__c,Customer_Portal_Admin__C from Account where Stage__c=\'Inactive\' and Customer_Portal_Admin__c!=null ';
        return Database.getQueryLocator(query);
    }


    global void execute(Database.BatchableContext info, List<Account> scope)
    {
        set<string> AccountIds= new set<string>();
        for(Account accobj:scope)
        {
            //  Account accountObj=(Account)accobj;
            AccountIds.add(accobj.Id);
        }
        Map<String,Integer> portalUserAccountMap =new Map<String,Integer>();
        
        for(User portalUser:[SELECT Id,Name,Contact.accountId,IsActive FROM User WHERE Contact.accountId=:AccountIds and IsActive!=false])
        { 
            portalUserAccountMap.put(portalUser.Contact.accountId,1);
        }
        if(portalUserAccountMap.size()>0)
        {
            //accobj.Portal_User_Deactivation_Error__c=true;
            String sAccId='';            
            for (Account accObj:scope)
            {
                  sAccId=accObj.Id;        
                  if (portalUserAccountMap.containsKey(sAccId))
                  {
                      accObj.Portal_User_Deactivation_Error__c=true;              
                  }                  
            }       
        }
        update scope;
    }   
    global void finish(Database.BatchableContext info){} 
}