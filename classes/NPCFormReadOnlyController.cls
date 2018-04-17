/*
    Author: Zymark Ambat
    Description: This Class serves as the controller for the NPCFormReadOnlyVF.
    History: 
        ZAmbat      11252013    - Code creation.
        ZAmbat      12092013    - Updated code of checking URL.
        ZAmbat      12182013    - Updated code to change logic of giving Edit permission to NPC Form.  Only NPC Form owners will be able to edit NPC Forms.
        ZAmbat      12182013    - Update code regarding NPC Form status after 2nd step rejection:  From no change in status ('In Execution') to 'Pending Resubmission'.
        ARoy        01282014    - Updated query to sort the mask layers based on layer and Is Mask Modified to show the changed ones first. (Case : 00004630)
        ZAmbat      01282014    - Updated code as per CASE 4515.
        ARoy        01292014    - Updated the code for the NPC Form Recall functionality for the Customer Portal User. (Case : 00004883)
        ZAmbat      03252014    - Updated code as per Case 4882.
        ZAmbat      04032014    - Updated code as per CASE 7400.
        ZAmbat      04042014    - Updated code as per CASE 8489.
        ZAmbat      06062014    - Updated code as per CASE 8490.
        ZAmbat      06062014    - Updated code as per CASE 24014.
        ZAmbat      06252014    - Updated code to show Additional Recipients.
        ZAmbat      07092014    - Updated code as per CASE 27667.
        DBiswal     11242014    - Updated code to allow GF System Admin to cancel NPC Form record.
        ZAmbat      12022014    - Updated code as per CASE 7573.
        DBiswal     12042014    - Updated code to add cloning of NPC Records.
        DBiswal     01202015    - Updated code for New Reason for New Part field value.
        DBiswal     03062015    - Updated code for Reason for New Part new field value 'ShortLoop Flow'.
        DBiswal     05042015    - Updated code to update NPC new part Id to 'VOID' if it is cancelled.
        DBiswal     05272015    - Updated code to remove sorting of Mask based on Layer.
        KOKA GOPI   07042015    - Updated Automotive_Grade__c for readonly page   
        Prajnith    10102016    - Updated code for fixing Device reactivation         
*/

public class NPCFormReadOnlyController {
    public boolean showCancel {get;set;}
    public boolean showEdit {get;set;}
    public boolean showSubmit {get;set;}
    public New_Part_Creation_Form__c npcForm {get;set;}
    public Device__c device {get;set;}
    public List<Mask__c> listMask {get;set;}
    public List<WrapperDevice> listDevice {get;set;}
    public List<Attachment> listAttachment {get;set;}
    public List<WrapperHistory> listApprovalHistory {get;set;}
    public List<Device__Share> listDS {get;set;}
    public List<string> listAdditionalRecipients {get;set;}
    public string caseNumber {get;set;}
    private New_Part_Creation_Form__c npcForm1 {get;set;}
    // Variable to show Recall button
    public boolean showNPCRecallButton {get;set;}
    
    public NPCFormReadOnlyController(ApexPages.StandardController controller) {
        // Check current URL
        //system.debug('Current URL ====================> ' + ApexPages.currentPage().getHeaders().get('referer'));
        system.debug('Current URL Host ====================> ' +  ApexPages.currentPage().getHeaders().get('host'));
        // Init
        this.showCancel = false;
        
        retrieveNPCDetails();
        // ZAmbat 12182013 - Removed
        //if (this.npcForm.NPC_Form_Status__c == Environment_Variable__c.getInstance('NPC_STATUS_IN_EXEC').Value__c) {
        // ZAmbat 12182013
        //ZAmbat 06062014
        if (this.npcForm.NPC_Form_Status__c == Environment_Variable__c.getInstance('NPC_STATUS_PEND_SUBMISSION').Value__c) {
            this.showCancel = true;  
        } else if (this.npcForm.NPC_Form_Status__c == Environment_Variable__c.getInstance('NPC_STATUS_PEND_RESUB').Value__c) {
            checkNPCStatus();
        }
        checkNPCEdit();
        // 01292014 ARoy : Recall Functionality
        this.showNPCRecallButton = false;
        checkNPCRecallStatus();
    }
    
    public PageReference checkInstance() {
        PageReference pageRef;
        // ZAmbat 12092013 - Removed
        //if (ApexPages.currentPage().getHeaders().get('referer').indexOf('GlobalfoundryView') == -1) {
        // ZAmbat 12092013
        if (ApexPages.currentPage().getHeaders().get('host').indexOf('globalfoundryview') == -1) {
            //pageRef = new PageReference('/' + ApexPages.currentPage().getParameters().get('id') + '?nooverride=1');
            pageRef = new PageReference('/apex/NPCFormInternalReadOnlyVF?id=' + ApexPages.currentPage().getParameters().get('id'));
            pageRef.setRedirect(true);
        }
        
        return pageRef;
    }
    
    public void retrieveNPCDetails() {
        this.npcForm = [
            SELECT      Id
                        , Name
                        , Account__c
                        , Originating_Device__c
                        , BASE_Device__c
                        , Fab__c
                        , Reference_Id__c
                        , New_Part_ID__c
                        , Reason_for_New_Part__c
                        , Tapeout_Required__c
                        , Secure_Device__c
                        , Comments__c
                        , Comments2__c             // Dipak 15112016
                        , RecordTypeId
                        , Account_Short_Name__c
                        , Automotive_Device__c
                        , Device_Mask_Set_Title__c
                        , NPC_Form_Status__c
                        , Account_Name__c
                        , BASE_Device__r.Name
                        , Originating_Device__r.Name
                        , Owner__c
                        , Mask_Set_Title__c
                        , NPC_Form_Submitter__c
                        , Require_To_Create_The_New_Part__c
                        , New_Customer_Name__c
                        , Case__c
                        , Case__r.CaseNumber
                        , New_Customer_Short_Name__c
                        , Additional_Recipient_1__c
                        , Additional_Recipient_2__c
                        , Additional_Recipient_3__c
                        , Additional_Recipient_4__c
                        , Additional_Recipient_5__c
                        , Current_Forecast_Tapeout_Date__c
                        , New_Fab__c
                        , Automotive_Grade__c
            FROM        New_Part_Creation_Form__c
            WHERE       Id = :ApexPages.currentPage().getParameters().get('id')
        ];
        
        // ZAmbat 06252014
        retrieveAdditionalRecipientNames();
        
        if (this.npcForm.Case__c != null) {
            this.caseNumber = this.npcForm.Case__r.CaseNumber;
        } else {
            this.caseNumber = '';
        }
        
        //DBiswal 05272015
        this.listMask = [
            SELECT      Id
                        , Name
                        , Layer__c
                        , Original_Mask__c
                        , Modified_Mask__c
                        , New_Part_Creation_Form__c
                        , Is_Mask_Modified__c
            FROM        Mask__c
            WHERE       New_Part_Creation_Form__c = :this.npcForm.Id
            ORDER BY Is_Mask_Modified__c ASC, Layer__c ASC
        ];
        
        Set<Id> deviceIds = new Set<Id>(); 
        this.listDevice = new List<WrapperDevice>();
        for (Device__c d : [SELECT      Id
                                        , Name
                                        , CRMDID__c
                                        , Stage__c
                                        , Status__c
                            FROM        Device__c
                            WHERE       NPC_Form__c = :this.npcForm.Id]) {
            WrapperDevice wd = new WrapperDevice();
            wd.Id = d.Id;
            wd.Name = d.Name;
            wd.CRMDID = d.CRMDID__c;
            wd.Stage = d.Stage__c;
            wd.Status = d.Status__c;
            
            this.listDevice.add(wd);
            deviceIds.add(d.Id);
        }
        
        // Check Device Sharing
        Map<string, string> mapDeviceShare = new Map<string, string>();
        for (Device__Share ds : [SELECT     ParentID
                                 FROM       Device__Share
                                 WHERE      ParentID IN :deviceIds 
                                            AND UserOrGroupId = :UserInfo.getUserId()]) {
            mapDeviceShare.put(ds.ParentID, ds.ParentID);
        }
        
        for (WrapperDevice wd : this.listDevice) {
            if (mapDeviceShare.containsKey(wd.Id)) {
                wd.hasShare = true;
            } else {
                wd.hasShare = false;
            }
        }
        
        this.listAttachment = [
            SELECT      Id
                        , Name
                        , LastModifiedDate
                        , CreatedById
            FROM        Attachment
            WHERE       ParentId = :this.npcForm.Id
            ORDER BY    LastModifiedDate DESC
        ];
        
        List<ProcessInstance> listPI = [
                SELECT          Id
                FROM            ProcessInstance
                WHERE           TargetObjectId = :this.npcForm.Id
                ORDER BY        CreatedDate DESC
        ];
        
        Set<Id> piIds = new Set<Id>();
        for (ProcessInstance pi : listPI) {
                piIds.add(pi.Id);
        }
        
        if (listPI.size() > 0) {
            
            this.listApprovalHistory = new List<WrapperHistory>();
            for (ProcessInstanceStep pis : [SELECT          Id
                                                            , CreatedDate
                                                            , StepStatus
                                                            , OriginalActor.Name
                                                            , Actor.Name
                                                            , Comments
                                            FROM            ProcessInstanceStep
                                            WHERE           ProcessInstanceId IN :piIds
                                            ORDER BY        CreatedDate DESC
                                                            , ProcessInstanceId DESC]) {
                WrapperHistory h = new WrapperHistory();
                h.Comments = pis.Comments;
                if (pis.StepStatus == 'Started') {
                    h.StepStatus = 'Submitted';
                }
                // 01292014 ARoy : Recall Functionality
                //====Start====//
                else if(pis.StepStatus == 'Removed') {
                    h.StepStatus = 'Recalled';
                }
                //====End======//
                else {
                    h.StepStatus = pis.StepStatus;
                }
                h.AssignedTo = pis.OriginalActor.Name;
                h.ActualApprover = pis.Actor.Name;
                
                string strOffset = pis.CreatedDate.format('Z');
                string strOffsetHours = strOffset.substring(0,3);
                if(strOffsetHours.startsWith('+')) {
                  strOffsetHours = strOffsetHours.substring(1);
                }
                
                h.CreatedDate = pis.CreatedDate.addHours(integer.valueOf(strOffsetHours));
                
                this.listApprovalHistory.add(h);
            }
        }
    }
    
    public PageReference editNPC() {
        PageReference pageRef;
        pageRef = new PageReference('/GlobalfoundryView/apex/NPCFormVF?id=' + this.npcForm.Id);
        pageRef.setRedirect(true);
        
        return pageRef;
    }
    
    public PageReference submitNPC() {
        PageReference pageRef;
        if (this.listDS.size() > 0) {
            pageRef = new PageReference('/GlobalfoundryView/apex/NPCFormApproval?id=' + this.npcForm.Id + '&portal=1');
        } else {
            pageRef = new PageReference('/GlobalfoundryView/apex/NPCFormApproval?id=' + this.npcForm.Id + '&portal=1&share=1');
        }

        pageRef.setRedirect(true);
        
        return pageRef;
    }
    
    public void checkNPCStatus() {
        List<RecordType> listRT = [
            SELECT      Id
                        , Name
            FROM        RecordType
            WHERE       Id = :this.npcForm.RecordTypeId
        ];
        
        system.debug('listRT =================> ' + listRT);
        
        if (listRT.size() > 0) {
            if (listRT[0].Name == 'StatusRejected') {
                this.showCancel = true;
            }
        }
        
        system.debug('this.showCancel =================> ' + this.showCancel);
    }
    
    public void checkNPCEdit() {
        // Check if User has access to device
        this.listDS = new List<Device__Share>();
        this.listDS = [
            SELECT      ParentID
            FROM        Device__Share
            WHERE       ParentID = :this.npcForm.Originating_Device__c 
                        AND UserOrGroupId = :UserInfo.getUserId()
        ];
        
        // ZAmbat 12182013 - Removed
        //if (this.listDS.size() > 0 && (this.npcForm.NPC_Form_Status__c == Environment_Variable__c.getInstance('NPC_STATUS_PEND_SUBMISSION').Value__c || this.npcForm.NPC_Form_Status__c == Environment_Variable__c.getInstance('NPC_STATUS_PEND_RESUB').Value__c || (this.npcForm.NPC_Form_Status__c == Environment_Variable__c.getInstance('NPC_STATUS_IN_EXEC').Value__c && this.showCancel == true))) {
        // ZAmbat 12182013 - Removed
        //if (UserInfo.getUserId() == this.npcForm.Owner__c && (this.npcForm.NPC_Form_Status__c == Environment_Variable__c.getInstance('NPC_STATUS_PEND_SUBMISSION').Value__c || this.npcForm.NPC_Form_Status__c == Environment_Variable__c.getInstance('NPC_STATUS_PEND_RESUB').Value__c || (this.npcForm.NPC_Form_Status__c == Environment_Variable__c.getInstance('NPC_STATUS_IN_EXEC').Value__c && this.showCancel == true))) {
        // ZAmbat 12182013
        if (this.npcForm.NPC_Form_Status__c == Environment_Variable__c.getInstance('NPC_STATUS_PEND_SUBMISSION').Value__c || this.npcForm.NPC_Form_Status__c == Environment_Variable__c.getInstance('NPC_STATUS_PEND_RESUB').Value__c) {
            this.showSubmit = true;
            if (UserInfo.getUserId() == this.npcForm.Owner__c) {
                this.showEdit = true;
            } else {
                this.showEdit = false;
            }
        } else {
            this.showSubmit = false;
            this.showEdit = false;
        }
    }
    
    public PageReference cancelNPC() {
        PageReference pageRef;
        
        //11242014 DBiswal - Added condition for GF System Admin
        Id profileId=userinfo.getProfileId();
        String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
        
        if (UserInfo.getUserId() == this.npcForm.Owner__c || profileName == 'GF System Admin' || profileName == 'System Administrator') {
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
                // ZAmbat 03252014
                //if (this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_RETROFIT').Value__c) {
                if (this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_RETROFIT').Value__c || this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_RETROFIT_ADD_ROM').Value__c || this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_PROBE_NEW_CARD').Value__c || this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_FAB_TRANSFER').Value__c || this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_CHANGE_PID').Value__c || this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_STARTINGMATERIAL').Value__c || this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_BACKGROUNDTHICKNESS').Value__c || this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_SHORTLOOP_FLOW').Value__c || (this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_OTHERS').Value__c && this.npcForm.Require_To_Create_The_New_Part__c == Environment_Variable__c.getInstance('NPC_REQUIRE_TO_CREATE_YES').Value__c)) {
                    this.npcForm.Device_Status__c = Environment_Variable__c.getInstance('NPC_STATUS_VOID').Value__c;
                }
                this.npcForm.RecordTypeId = rt.Id;
                //DBiswal 05042015
                this.npcForm.New_Part_ID__c = Environment_Variable__c.getInstance('NPC_STATUS_VOID').Value__c.toUpperCase() + '-' + this.npcForm.New_Part_ID__c; 
                update this.npcForm;
                
                // Update device status to 'Void'
                // Update device name to 'Void-<NPC Name>'
                // ZAmbat 03252014
                //if (this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_RETROFIT').Value__c) {
                /*if (this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_RETROFIT').Value__c
                    || this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_RETROFIT_ADD_ROM').Value__c
                    || this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_PROBE_NEW_CARD').Value__c
                    || this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_FAB_TRANSFER').Value__c
                    || this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_CHANGE_PID').Value__c
                    || this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_STARTINGMATERIAL').Value__c    //DBiswal 01202015
                    || this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_BACKGROUNDTHICKNESS').Value__c    //DBiswal 01202015
                    || this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_SHORTLOOP_FLOW').Value__c
                    || (this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_OTHERS').Value__c && this.npcForm.Require_To_Create_The_New_Part__c == Environment_Variable__c.getInstance('NPC_REQUIRE_TO_CREATE_YES').Value__c)) {
                 */
                 if (this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_RETROFIT').Value__c || this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_RETROFIT_ADD_ROM').Value__c || this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_PROBE_NEW_CARD').Value__c || this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_FAB_TRANSFER').Value__c || this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_CHANGE_PID').Value__c || this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_STARTINGMATERIAL').Value__c || this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_BACKGROUNDTHICKNESS').Value__c || this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_SHORTLOOP_FLOW').Value__c || (this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_OTHERS').Value__c && this.npcForm.Require_To_Create_The_New_Part__c == Environment_Variable__c.getInstance('NPC_REQUIRE_TO_CREATE_YES').Value__c)) {   
                    List<Device__c> listDevice1 = [
                        SELECT      Id
                                    , Name
                                    , Status__c
                                    , Stage__c
                        FROM        Device__c
                        WHERE       NPC_Form__c = :this.npcForm.Id
                                    AND Tapeout_Type__c = :Environment_Variable__c.getInstance('DEVICE_TAPEOUT_TYPE_RETROFIT').Value__c
                    ];
                    
                    if (listDevice1.size() > 0) {
                        this.device = listDevice1[0];
                        //DBiswal 05072015
                        if(this.device.Stage__c == Environment_Variable__c.getInstance('DEVICE_STAGE_TAPEOUT').Value__c){
                            this.device.Stage__c = Environment_Variable__c.getInstance('DEVICE_STAGE_DESIGNIN').Value__c;
                            update this.device;
                            
                            this.device.Name = Environment_Variable__c.getInstance('DEVICE_STAGE_VOID').Value__c + '-' + this.npcForm.Name; 
                            update this.device;
                            
                            this.device.Status__c = Environment_Variable__c.getInstance('DEVICE_STAGE_VOID').Value__c;
                            update this.device;
                        } else {
                            this.device.Name = Environment_Variable__c.getInstance('DEVICE_STAGE_VOID').Value__c + '-' + this.npcForm.Name; 
                            update this.device;
                        
                            this.device.Status__c = Environment_Variable__c.getInstance('DEVICE_STAGE_VOID').Value__c;
                            update this.device;
                        }
                    }
                }
                
                pageRef = new PageReference('/GlobalfoundryView/NPCFormReadOnlyVF?id=' + this.npcForm.Id);
                pageRef.setRedirect(true);
            } catch (Exception e) {
                ApexPages.addmessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Error: ' + e.getMessage()));  
            }
        } else {
            ApexPages.addmessage(new ApexPages.Message(ApexPages.severity.ERROR, Environment_Variable__c.getInstance('NPC_CANCEL_VALIDATION').Value__c));
        }
                return pageRef;
    }
    
    //12042014 DBiswal - Clone the NPC Form record
    public PageReference cloneNPC(){
        PageReference pageRef = new PageReference('/apex/NPCFormVF?id=' + this.npcForm.Id);
        pageRef.getParameters().put('clone','1');
        
        pageRef.setRedirect(true);   
        return pageRef;
    }
    
    // 01292014 ARoy : Recall Functionality
    // Start of method to check for the NPC Form Status and show the Recall button for Approval
    public void checkNPCRecallStatus(){
        if(UserInfo.getUserId() == this.npcForm.NPC_Form_Submitter__c 
            && this.npcForm.NPC_Form_Status__c == Environment_Variable__c.getInstance('NPC_STATUS_SUBMITTED').Value__c){
            this.showNPCRecallButton = true;
        }
    }
    // End of method   
    
    // 01292014 ARoy : Recall Functionality
    // Start of method for NPC recall functionality
    public PageReference recallNPC() {
        PageReference pageRef;
        if (this.listDS.size() > 0) {
            pageRef = new PageReference('/GlobalfoundryView/apex/NPCFormRecallApproval?id=' + this.npcForm.Id);
        } else {
            pageRef = new PageReference('/GlobalfoundryView/apex/NPCFormRecallApproval?id=' + this.npcForm.Id + '&share=1');
        }

        pageRef.setRedirect(true);
        
        return pageRef;
    }
    // End of method
     // Dipak 27092016 for Picklist value to Radio button conversion Start
     public List<SelectOption> getTypes(){
            Schema.sObjectType sobject_type = New_Part_Creation_Form__c.getSObjectType();

            Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();

            Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
          
            List<Schema.PicklistEntry> pick_list_values = field_map.get('Min_Order_Create__c').getDescribe().getPickListValues();

            List<selectOption> options = new List<selectOption>();

           for (Schema.PicklistEntry a : pick_list_values) {
                      options.add(new selectOption(a.getLabel(), a.getValue()));
          }
      return options;
      }
      // Dipak 27092016 End
    // ZAmbat 06252014
    public void retrieveAdditionalRecipientNames() {
        this.listAdditionalRecipients = new List<string>();
        Set<Id> recipientIds = new Set<Id>(); 
        
        if (this.npcForm.Additional_Recipient_1__c != null) {
            recipientIds.add(this.npcForm.Additional_Recipient_1__c);
        }
        
        if (this.npcForm.Additional_Recipient_2__c != null) {
            recipientIds.add(this.npcForm.Additional_Recipient_2__c);
        }
        
        if (this.npcForm.Additional_Recipient_3__c != null) {
            recipientIds.add(this.npcForm.Additional_Recipient_3__c);
        }
        
        if (this.npcForm.Additional_Recipient_4__c != null) {
            recipientIds.add(this.npcForm.Additional_Recipient_4__c);
        }
        
        if (this.npcForm.Additional_Recipient_5__c != null) {
            recipientIds.add(this.npcForm.Additional_Recipient_5__c);
        }
        
        if (recipientIds.size() > 0) {
            for (User u : [SELECT       Id
                                        , Name
                           FROM         User
                           WHERE        Id IN :recipientIds
                           ORDER BY     Name]) {
                this.listAdditionalRecipients.add(u.Name);
            }
        }
    }
    
    public class WrapperDevice {
        public string Id {get;set;}
        public string Name {get;set;}
        public string CRMDID {get;set;}
        public string Stage {get;set;}
        public string Status {get;set;} 
        public boolean hasShare {get;set;}
    }
    
    public class WrapperHistory { 
        public datetime CreatedDate {get;set;}
        public string StepStatus {get;set;}
        public string AssignedTo {get;set;}
        public string ActualApprover {get;set;}
        public string Comments {get;set;}
        
        public WrapperHistory(){}
    }
}