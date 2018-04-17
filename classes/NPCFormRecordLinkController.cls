/*
    Author: Zymark Ambat
    Description: This Class serves as the controller for the NPCFormRecordLinkVF.
    History: 
        ZAmbat      12162013    - Code creation.
*/

public class NPCFormRecordLinkController {
	public Id npcFormId {get;set;}
	public string sfdcInternal = EnvironmentVariable.get('SFDC_INSTANCE');
 	public string sfdcPortal = EnvironmentVariable.get('SFDC_CUSTOMER_PORTAL');
  
	public NPCFormRecordLinkController() {}
	
	public string getRecordLink() {
		return this.sfdcInternal + '/' + this.npcFormId;
	}
}