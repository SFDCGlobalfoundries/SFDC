/*
    Author: Zymark Ambat
    Description: This Class serves as the Controller for the IPDeclarationChangeOwnershipVF VF Component.
    History: 
        ZAmbat      07172013    - Code creation.
*/

public class IPDeclarationChangeOwnershipController {
	
	public Id ipDeclarationId {get;set;}
	public string previousOwnerName {get;set;}
	public IP_Declaration_Form__c ipDeclarationForm {get;set;}
	
	public IPDeclarationChangeOwnershipController() {
		// Retrieve IP Declaration details
		List<IP_Declaration_Form__c> listIPDeclarationForm = [
			SELECT		Id
						, Name
						, Device_Name__c
						, Notes_to_New_Owner__c
						, CRM_Device_ID__c
						, Project_Name__c
			FROM		IP_Declaration_Form__c
			WHERE		Id = :this.ipDeclarationId
		];
		
		if (listIPDeclarationForm.size() > 0) {
			this.ipDeclarationForm = listIPDeclarationForm[0];
		}
	}

}