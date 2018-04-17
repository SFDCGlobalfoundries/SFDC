/*
    Author: Zymark Ambat
    Description: Apex class called by the AccountTrigger to populate the Organization Unit field.
    History: 
        Zymark Ambat      04152013    - Code creation.
*/

public with sharing class AccountOrganizationUnitPopulate {
	
	public static void validateOrganizationUnit(Account acct) {
		if (acct.Organization_Unit__c != null) {
            // Check if the new value already exists in Organization Unit
            Set<String> setOU = new Set<String>();
            setOU.addAll(acct.Organization_Unit__c.split(';'));
            
            if (setOU.contains(acct.New_Organization_Unit_Request__c)) {
                acct.addError('Duplicate Organization Unit is not allowed.');
            }
        }
	}
	
    public static String populateOrganizationUnit(String orgUnit, String newOrgUnit) {
        String newValue;
        if (orgUnit == null || orgUnit.trim() == '') {
            newValue = newOrgUnit;
        } else {
            newValue = orgUnit + ';' + newOrgUnit;
        }
        
        return newValue;
	}
    
}