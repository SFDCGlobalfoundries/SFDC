/*
    Author: Prajnith Karra
    Description: This Class serves as the controller for the NPCFormNPCPIYUpdateRecordLinkVF.
    History: 
       Prajnith    10102016    - Class creation for Device reactivation.
*/

public class NPCFormRecordNPCPIYUpdateLinkController{
    public Id npcFormId {get;set;}
    public string sfdcInternal = EnvironmentVariable.get('SFDC_INSTANCE');
    public string sfdcPortal = EnvironmentVariable.get('SFDC_CUSTOMER_PORTAL');
  
    public NPCFormRecordNPCPIYUpdateLinkController() {}
    
    public string getRecordLink() {
        return this.sfdcInternal + '/apex/NPCPIYUpdate?id=' + this.npcFormId;
    }
}