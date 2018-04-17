/*
    Author: Zymark Ambat
    Description: Apex class called by the AccountTrigger to validate Account.
    History: 
        Zymark Ambat      05222013    - Code creation.
*/

public with sharing class AccountValidation {

	public static List<Account> validateContacts(Set<Id> accountIds) {
		List<Account> returnList = new List<Account>(); 
		
		for (Account a : [SELECT 	Id
								 	, (Select Id FROM Contacts)
						  FROM		Account
						  WHERE		Id IN :accountIds]) {
						  	
			if (a.Contacts.size() <= 0) {
				returnList.add(a);
			}	
			
		}
		
		return returnList;
	}

}