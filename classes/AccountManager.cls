/*
    Author: Anirban Roy
    Description: This class manages the copy functionality of Corporate Address fields to Billing Address
    			 fields of Account.	
    History:
        ARoy  04152013    - code creation.
*/
public with sharing class AccountManager {
	
	static final string ACCOUNT_STAGE_AUTHORIZED = EnvironmentVariable.get('ACCOUNT_STG_AUTH');
	static final string ACCOUNT_STAGE_INACTIVE = EnvironmentVariable.get('ACCOUNT_STG_INACT');
	// This method copies the address from the Corporate Address fields 
	// to the Billing Address fields
	public static void copyAddress(List<Account> accList){
		for(Account acc: accList){
			if(acc.Copy_Address__c && !(acc.Stage__c==AccountManager.ACCOUNT_STAGE_AUTHORIZED || acc.Stage__c==AccountManager.ACCOUNT_STAGE_INACTIVE)){
				acc.Bill_To_Address_1__c = acc.Corporate_Address_1__c;
				acc.Bill_To_Address_2__c = acc.Corporate_Address_2__c;
				acc.Bill_To_Address_3__c = acc.Corporate_Address_3__c;
				acc.Bill_To_Address_4__c = acc.Corporate_Address_4__c;
				acc.Bill_To_City__c = acc.Corporate_City__c;
				acc.Bill_To_State__c = acc.Corporate_State__c;
				acc.Bill_To_Country__c = acc.Corporate_Country__c;
				acc.Bill_To_Postal_Zip_Code__c = acc.Corporate_Postal_Zip_Code__c;
				acc.Copy_Address__c = false;
			}
		}
	}
}