/*
    Author: Zymark Ambat
    Description: This serves as the Controller for NPCCancelFormVF.
    History: 
        ZAmbat      11142013    - Code creation.
*/
        
public class NPCCancelFormController {
    public string npcId {get;set;}
    public New_Part_Creation_Form__c npcForm {get;set;}
    public Device__c device {get;set;}
    
    public NPCCancelFormController() {
        this.npcId = ApexPages.currentPage().getParameters().get('id');
    }
    
    public PageReference cancelNPC() {
        this.npcForm = [
            SELECT      Id
                        , Name
                        , NPC_Form_Status__c
                        , Device_Status__c
                        , Owner__c
                        , RecordTypeId
                        , Reason_for_New_Part__c
            FROM        New_Part_Creation_Form__c
            WHERE       Id = :this.npcId
        ];
        
        // Validate user
        if (UserInfo.getUserId() == this.npcForm.Owner__c) {
            try {
                // Update NPC Form Status to 'Not Executed'
                // Update record type to 'StatusSubmitted'
                // Update NPC Device Status to 'Void'
                RecordType rt = [
                    SELECT      Id
                    FROM        RecordType
                    WHERE       SObjectType = 'New_Part_Creation_Form__c'
                                AND Name = 'StatusSubmitted'
                ];
                
                this.npcForm.NPC_Form_Status__c = Environment_Variable__c.getInstance('NPC_STATUS_NOT_EXEC').Value__c;
                if (this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_RETROFIT').Value__c) {
                    this.npcForm.Device_Status__c = Environment_Variable__c.getInstance('NPC_STATUS_VOID').Value__c;
                }
                this.npcForm.RecordTypeId = rt.Id;
                update this.npcForm;
                
                // Update device status to 'Void'
                // Update device name to 'Void-<NPC Name>'
                if (this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_RETROFIT').Value__c) {
                    this.device = [
                        SELECT      Id
                                    , Name
                                    , Status__c
                        FROM        Device__c
                        WHERE       NPC_Form__c = :this.npcForm.Id
                                    AND Tapeout_Type__c = :Environment_Variable__c.getInstance('DEVICE_TAPEOUT_TYPE_RETROFIT').Value__c
                    ];
                    
                    this.device.Name = Environment_Variable__c.getInstance('DEVICE_STAGE_VOID').Value__c + '-' + this.npcForm.Name; 
                    update this.device;
                    
                    this.device.Status__c = Environment_Variable__c.getInstance('DEVICE_STAGE_VOID').Value__c;
                    update this.device;
                }
                
                // Redirect page
                String currentUrl = ApexPages.currentPage().getUrl();
                PageReference pageRef;
                
                if(currentUrl.indexOf('GlobalfoundryView') != -1){
                    pageRef = new PageReference(this.npcForm.Id);
                }else{
                    pageRef = new PageReference('/' + this.npcForm.Id);
                }
                
                pageRef.setRedirect(true);
                return pageRef;
            } catch (Exception e) {
                ApexPages.addmessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Error: ' + e.getMessage()));  
            }
        } else {
            ApexPages.addmessage(new ApexPages.Message(ApexPages.severity.ERROR, Environment_Variable__c.getInstance('NPC_CANCEL_VALIDATION').Value__c));
        }
        
        return null;
    } 
    
    public PageReference cancel(){
        string currentUrl = ApexPages.currentPage().getUrl();
        PageReference pageRef;
        
        if(currentUrl.indexOf('GlobalfoundryView') != -1){
            pageRef = new PageReference(this.npcForm.Id);
        }else{
            pageRef = new PageReference('/' + this.npcForm.Id);
        }
        
        return pageRef;
    }
}