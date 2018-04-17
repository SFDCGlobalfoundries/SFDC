/*
    Author: Zymark Ambat
    Description: This Class manages the generation of Account Hierarchy records.
    History: 
        ZAmbat      06122013    - Code creation.
*/


public class AccountHierarchyGeneration {
    
    public static void InsertAccountHierarchy(List<Account> paramListAccount) {
        // Create Map - Hierarchy of Accounts Map
        Set<Id> accountIds = new Set<Id>();
        for (Account a : paramListAccount) {
        	accountIds.add(a.Id);
        }
        
        Map<Id, Id> mapHierarchyOfAccounts = AccountHierarchyGeneration.CreateHierarchyOfAccountsMap(accountIds);
        system.debug('accountIds ===============> ' + accountIds);
        system.debug('mapHierarchyOfAccounts ===============> ' + mapHierarchyOfAccounts);
        
        // Create Account Hierarchy
        List<Account_Hierarchy__c> listAccountHierarchy = AccountHierarchyGeneration.GenerateAccountHierarchy(paramListAccount, mapHierarchyOfAccounts);
    	insert listAccountHierarchy;
    }
    
    public static void UpdateAccountHierarchy(List<Account> paramListAccount) {
		// Get the affected Accounts
		List<Account> listAccounts = new List<Account>();
		for (Account a : paramListAccount) { 
			listAccounts.add(a);
			
			Set<Id> accountIds = new Set<Id>();
			Set<Id> newAccountIds = new Set<Id>();
			
			// Init
			accountIds.add(a.Id);
			do {
				for (Account acct : [SELECT		Id
												, ParentId
									 FROM		Account
									 WHERE		ParentId IN :accountIds]) {
					listAccounts.add(acct);
					newAccountIds.add(acct.Id);
				}
				
				if (newAccountIds.size() > 0) {
					accountIds = new Set<Id>();
					accountIds.addAll(newAccountIds);
					newAccountIds = new Set<Id>();
				} else {
					accountIds = new Set<Id>();
				}
			} while (accountIds.size() > 0);
		}
		
		// Delete the Account Hierarchy records of the affected accounts
		if (listAccounts.size() > 0) {
			Set<Id> deleteAccountIds = new Set<Id>();	
			for (Account a : listAccounts) {
				deleteAccountIds.add(a.Id);
			}
			
			List<Account_Hierarchy__c> listAccountHierarchy = [
				SELECT		Id
				FROM		Account_Hierarchy__c
				WHERE		Account_Id__c IN :deleteAccountIds
			];
			
			if (listAccountHierarchy.size() > 0) {
				// Delete Account Hierarchy
				DeletedRecordsManager.insertRecords(listAccountHierarchy, EnvironmentVariable.get('ACCOUNT_HIERARCHY_ENTITY'));
				
				delete listAccountHierarchy;
			}
			
			// Regenerate Account Hierarchy records
			AccountHierarchyGeneration.InsertAccountHierarchy(listAccounts);
		}
    }
    
    private static Map<Id, Id> CreateHierarchyOfAccountsMap (Set<Id> paramAccountIds) {
    	Map<Id, Id> returnMap = new Map<Id, Id>(); 
    	Set<Id> accountIds = new Set<Id>();
    	Set<Id> accountIdsNew = new Set<Id>();
    	
    	// Init
    	accountIds.addAll(paramAccountIds);
    	
    	do {
    		for (Account a : [SELECT	Id
    									, ParentId
    									, Parent.ParentId
    						  FROM		Account
    						  WHERE		Id IN :accountIds]) {
    			// Add Child - Parent Account
    			if (a.ParentId != null) {
    				returnMap.put(a.Id, a.ParentId);
    				
    				// Add Parent - Parent's Parent Account
	    			if (a.Parent.ParentId != null) {
	    				returnMap.put(a.ParentId, a.Parent.ParentId);
	    				accountIdsNew.add(a.Parent.ParentId);
	    			}
    			}	
    		}
    		
    		// Refresh values
    		accountIds = new Set<Id>();
    		if (accountIdsNew.size() > 0) {
    			accountIds.addAll(accountIdsNew);
    			accountIdsNew = new Set<Id>();
    		}
    	} while (accountIds.size() > 0);
    	
    	return returnMap;
    }
    
    private static List<Account_Hierarchy__c> GenerateAccountHierarchy(List<Account> paramListAccount, Map<Id, Id> mapHierarchyOfAccounts) {
    	List<Account_Hierarchy__c> listAccountHierarchy = new List<Account_Hierarchy__c>();
    	Set<Account_Hierarchy__c> setAccountHierarchy = new Set<Account_Hierarchy__c>();
    	for (Account a : paramListAccount) {
    		if (a.ParentId != null) {
	    		// Temp
	    		List<Account_Hierarchy__c> tempListAccountHierarchy = new List<Account_Hierarchy__c>();
	    		string baseAccountId;
	    		
	    		// Create Base Account Hierarchy records
	    		Account_Hierarchy__c ah = new Account_Hierarchy__c();
	    		ah.Account_Id__c = a.Id;
	    		ah.Parent_Id__c = a.Id;
	    		tempListAccountHierarchy.add(ah);
	    		
	    		// Init
	    		baseAccountId = a.Id;
	    		
	    		while (mapHierarchyOfAccounts.containsKey(baseAccountId)) {
	    			ah = new Account_Hierarchy__c();
	    			ah.Account_Id__c = a.Id;
	    			ah.Parent_Id__c = mapHierarchyOfAccounts.get(baseAccountId);
	    			tempListAccountHierarchy.add(ah);
	    			
	    			// Set
	    			baseAccountId = mapHierarchyOfAccounts.get(baseAccountId);
	    		}
	    		
	    		// Set Master Account
	    		for (Account_Hierarchy__c ahc : tempListAccountHierarchy) {
	    			ahc.Master_Account_Id__c = baseAccountId;
	    		}
	    		
	    		// Add to main Account Hierarchy list
	    		//listAccountHierarchy.addAll(tempListAccountHierarchy);
	    		setAccountHierarchy.addAll(tempListAccountHierarchy);
    		} else {
    			// Create Account Hierarchy record
    			Account_Hierarchy__c ah = new Account_Hierarchy__c();
	    		ah.Account_Id__c = a.Id;
	    		ah.Parent_Id__c = a.Id;
	    		ah.Master_Account_Id__c = a.Id;
	    		
	    		//listAccountHierarchy.add(ah);
	    		setAccountHierarchy.add(ah);
    		}
    	}
    	
    	listAccountHierarchy.addAll(setAccountHierarchy);
    	
    	return listAccountHierarchy;
    } 
}