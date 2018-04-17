/*
    Author:         Pradosh Samal
    Description:    Utility apex class for Account Owner update
    History: 
    PSamal 31032016 - Apex code created.
    
*/

public class AccountChangeOwnerUtil { 
    /*
    This asynchronous method updates the Account Owner field with the corresponding lead created by user
    */
    @future
    public static void updateOwnerId(Set<Id> accountIdSet) {
    
        List<Account> accountList = [SELECT Id, OwnerId, Lead_Created_By__c FROM Account WHERE Id IN : accountIdSet AND Lead_Created_By__c != null];
        
        for(Account account : accountList){
            
            account.OwnerId = account.Lead_Created_By__c;
            
            account.Account_Manager__c = account.Lead_Created_By__c;
        }
        
        update accountList;
    }
}