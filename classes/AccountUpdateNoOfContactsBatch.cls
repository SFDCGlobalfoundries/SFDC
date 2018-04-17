/*
    Author: Zymark Ambat
    Description: This batch class is created to update the No_of_Contacts__f field in Account.
    History: 
        ZAmbat      05272014    - Code creation.
*/

global class AccountUpdateNoOfContactsBatch implements Database.Batchable<sObject> {
    global final string query = 'SELECT Id, AccountId FROM Contact WHERE AccountId != null AND (CreatedDate = TODAY OR LastModifiedDate = TODAY)';
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext ctx, List<Sobject> scope) {
        Set<Id> accountIds = new Set<Id>();
        for (Contact c : (List<Contact>)scope) {
            accountIds.add(c.AccountId);
        } 
        
        Map<Id, List<Contact>> mapAccountContact = new Map<Id, List<Contact>>(); 
        for (Contact c : [SELECT    Id
                                    , AccountId
                          FROM      Contact
                          WHERE     AccountId IN :accountIds]) {
            List<Contact> tempList = new List<Contact>();
            if (mapAccountContact.containsKey(c.AccountId)) {
                tempList = mapAccountContact.get(c.AccountId);
            } else {
                tempList = new List<Contact>();
            }
            
            tempList.add(c); 
            mapAccountContact.put(c.AccountId, tempList);
        }
        
        List<Account> listAccount = new List<Account>(); 
        for (Account a : [SELECT    Id
                                    , No_of_Contacts__c
                          FROM      Account
                          WHERE     Id IN :accountIds]) {
            if (mapAccountContact.containsKey(a.Id)) {
                a.No_of_Contacts__c = mapAccountContact.get(a.Id).size();
            } else {
                a.No_of_Contacts__c = 0;
            }
            
            listAccount.add(a);
        }
        
        if (listAccount.size() > 0) {
            update listAccount;
        }
    }
    
    global void finish(Database.BatchableContext BC){}
}