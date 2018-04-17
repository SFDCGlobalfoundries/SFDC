/*
    Author: Zymark Ambat
    Description: This Class serves as the controller for the NPCFormVF.
    History: 
        ZAmbat      06202013    - Code creation.
        ZAmbat      10012013    - Updated codes as per TASK-299.
        ZAmbat      10022013    - Updated codes as per TASK-348.
        ZAmbat      10092013    - updated code - added accountName to reflect account name in portal.
        ZAmbat      10212013    - updated code to revert back to NPCFormTest when web service is called from a test class.
        ZAmbat      10242013    - updated code to validate New Part Id only if Reason for New Part is 'Retrofit'.
        ZAmbat      10252013    - updated code to add validation of New Part Id against other NPC records when Reason for New Part is 'Retrofit'.
        ZAmbat      10282013    - updated code to remove Device Id + Tapeout Type validation.
        ZAmbat      11052013    - updated code to add SSL.
        ZAmbat      11222013    - updated code to redirect to My Devices Page after saving if Account != User's Account (Portal User).
        ZAmbat      11252013    - updated code to retrieve Mask Layers for NPC records with no saved Mask Layers.  
        ZAmbat      11262013    - updated code for navigation of Portal users upon saving.
        ZAmbat      12042013    - updated code to disable edit of Mask Layers when status is not 'Pending Submission', 'Pending Resubmission' and 'In Execution' (Rejected).
        ZAmbat      12052013    - Updated code to replace '-' or '-U' on the last part only (TASK-663). 
        ZAmbat      12092013    - Updated code of checking URL.
        ZAmbat      12102013    - Updated code to add checking for GF CE Edit permission.
        ARoy        01062014    - Updated code to add Mask Layers when MES Reference Id is not present. Fix for Case 00004080.
        ZAmbat      01152014    - Updated code to add sorting to Mask Layers and disable the autopopulation of New Part Id when MES Reference Id = 'NotAvailable'.
        ZAmbat      01282014    - Updated code as per CASE 4515.
        ZAmbat      01282014    - Updated code as per CASE 5250.
        ZAmbat      02192014    - Updated code to update New Part Id validation (related to CASE 5250). 
        ZAmbat      02202014    - Updated code to pass value ('OBSOLETE' or 'RETROFIT') to new parameter in MESService.
        ZAmbat      03042014    - Updated code as per CASE 4882.
        ZAmbat      04032014    - Updated code as per CASE 7400.
        ZAmbat      04042014    - Updated code as per CASE 8489.
        ZAmbat      06102014    - Updated code as per CASE 14180.
        ZAmbat      06102014    - Updated code as per CASE 16179.
        ZAmbat      07022014    - Updated code to check if New Part Id already exists in Device (Device__c.Name OR Device__c.Device_Id__c).
        ZAmbat      07092014    - Updated code as per CASE 27667.
        ZAmbat      08122014    - Updated code as per CASE 31810.
        ZAmbat      08192014    - Updated code as per CASE 32408.
        DBiswal     11242014    - Added code to append 'CO' to reference ids of devices with fab values FAB3/5.
        ZAmbat      12022014    - Updated code as per CASE 7573.
        DBiswal     12042014    - Updated code to add clone functionality.        
        Vijay       12012014    - added isError flag to show the validation messages on popup window and redirect to device detail page
        DBiswal     01132015    - Added code to remove Mask Ids from Cloning and flag for read only fields. 
        DBiswal     01202015    - Added code for new Reason for New Part field values.
        DBiswal     03022015    - Updated code for New Part Id Validation.
        DBiswal     03052015    - Updated code for probe card Intelligence and Reason for New Part 'ShortLoop Flow'.
        DBiswal     03252015    - Updated code to validate 'PC' and 'SL' for probe card and ShortLoop NPCs.
        DBiswal     05042015    - Updated code to add the Reason for Parts which creates Device.
        SNune       18092015    - Modified code to fix the clone issue for FAB1,FAB8, Case 00047410
        Prajnith    10102016    - Updated code for fixing Device reactivation.        
*/

public class NPCFormController {
    public New_Part_Creation_Form__c npcForm {get;set;}
    public Device__c device {get;set;}
    public Map<string, string> mapNewPartId {get;set;}
    public Map<string, List<Mask__c>> mapMask {get;set;}
    public Map<Id, Account> mapAccount {get;set;}
    public List<Mask__c> listMask {get;set;}
    public List<SelectOption> listReferenceIds {get;set;}
    public List<SelectOption> listAccountNames1 {get;set;}
    public List<SelectOption> listAccountNames2 {get;set;}
    public List<SelectOption> listAccountNames3 {get;set;}
    public List<AttachmentWrapper> listAttachments {get; set;}
    public boolean fromDevicePage {get;set;}
    public boolean isEdit {get;set;}
    public boolean isOnLoad {get;set;}
    public boolean isFromPortal {get;set;}
    public boolean isAddMaskClicked {get;set;}
 
    public boolean disableButton {get;set;}
    public boolean disableSaveAddAttachment {get;set;}
    public boolean changeURL {get;set;}
    public boolean isRejected {get;set;}
    public boolean isGFCE {get;set;}
    public boolean hasDevice {get;set;}
    public boolean isEditFromPortal {get;set;}
    public boolean isClone {get;set;}    //DBiswal 12042014
    public boolean isAdmin {get; set;}   //DBiswal 01132015 
    public string npcFormId {get;set;}
    public string deviceId {get;set;}
    public string userId {get;set;}
    public string portalUserAccountId {get;set;}
    public string attachId {get;set;}
    public string accountName {get;set;}
    public string blankString {get;set;}    
    public string origNPCReason {get;set;}
    public string origMESReferenceId {get;set;}
    public string origNewPartId {get;set;}
    public string origRequireToCreateTheNewPart {get;set;}
    public Set<User> listUnselectedRecipients {get;set;}
    public Set<User> listSelectedRecipients {get;set;}
    public List<string> unselectedRecipients {get;set;}
    public List<string> selectedRecipients {get;set;}
    public Map<Id, User> mapRecipients {get;set;}
    public string litho_2013 {get;set;}
    public string litho_2014 {get;set;}
    public string litho_2015 {get;set;}
    Public Integer last3 {get;set;}
    Public Integer last2 {get;set;}        
    Public Integer last1 {get;set;}
    Public Integer next3 {get;set;}
    Public Integer next2 {get;set;}
    Public Integer next1 {get;set;}
    //Added for Mask Layer addition. Fix for Case 00004080.
    //start
    public List<SelectOption> maskLayerOptions {get; set;}
    public List<MaskWrapper> maskWrappers {get; set;}
    public static Integer toDelIdent {get; set;}
    public static Integer addCount {get; set;}
    private Integer nextIdent=0;
    public boolean isMaskAlert {get; set;}
    //end
    
    public Boolean isError{get; set;}
    
    // Dipak 07092016 start
    public ShippingReport__c shipRep{get;set;}
    public Boolean isnrechecked {get;set;}
    public Boolean isrwchecked {get;set;}
    public List<String> tempLst {get;set;}
    public String commaSepratedList {get;set;}

   
    public boolean isDeviceReactivation {get;set;}
    // Dipak 07092016 end
    
    // Constructor
    public NPCFormController() {
       
        // Init
        this.device = new Device__c();
        this.shipRep = new ShippingReport__c();
        this.npcForm = new New_Part_Creation_Form__c();
        this.listMask = new List<Mask__c>();
        //Added for Mask Layer addition. Fix for Case 00004080.
        //start
        this.maskLayerOptions = new List<SelectOption>();
        this.maskWrappers=new List<MaskWrapper>();
        this.isMaskAlert = false;
        //end
        this.mapNewPartId = new Map<string, string>();
        this.mapMask = new Map<string, List<Mask__c>>();
        this.listReferenceIds = new List<SelectOption>();
        this.listAttachments = new List<AttachmentWrapper>();
        this.deviceId = ApexPages.currentPage().getParameters().get('deviceId');
        //this.deviceId = 'a0lO0000000FYrE'; // test
        this.npcFormId = ApexPages.currentPage().getParameters().get('id');
        this.userid = ApexPages.currentPage().getParameters().get('userId');
        this.disableButton = true;
        this.disableSaveAddAttachment = false;
        this.changeURL = false;
        this.isRejected = false;
        this.isGFCE = false;
        this.hasDevice = false;
        this.isEditFromPortal = false;
        this.isDeviceReactivation  = false;
        this.isClone = false;    //DBiswal 12042014        
        this.listUnselectedRecipients = new Set<User>();
        this.listSelectedRecipients = new Set<User>();
        this.unselectedRecipients = new List<string>();
        this.selectedRecipients = new List<string>();
        this.mapRecipients = new Map<Id, User>();
        this.isError = false;
        this.isAdmin = false;    //DBiswal 01132015
        this.isAddMaskClicked = false;
         //Dipak 07092016 Start
        isnrechecked=npcForm.NRE_25K_USD__c;
        isrwchecked=npcForm.Risk_Waiver__c;
     
        
                   
        //Dipak 07092016 End
        
        // ZAmbat 12102013
        string gfce = ApexPages.currentPage().getParameters().get('gfce');
        if (gfce != null && gfce.trim() != '') {
            this.isGFCE = true;
        }
        
        //DBiswal 12042014
        String cloneyes = ApexPages.currentPage().getParameters().get('clone');
        if(cloneyes != null && cloneyes.trim() != ''){
            this.isClone = true;
        }
        
        //DBiswal 01132015 - For disabling editing of Secure Device and Automotive Device fields
        String profileName=[Select Id,Name from Profile where Id=:UserInfo.getProfileId()].Name;
        if(profileName == 'System Administrator' || profileName == 'GF System Admin' || profileName == 'GF Integration'){ this.isAdmin = true; }
        
        //Yathish st
        retrievePastYearActualLoading(ApexPages.currentPage().getParameters().get('deviceId'));  
        //yathish end   
        // Set attachment
        AttachmentWrapper aw = new AttachmentWrapper();
        aw.id = 'NPCFormVF:form1:BlkEdit:repeatAttach:0:attach';
        aw.label = 'Attachment(s)';
        aw.attachment = new Attachment();
        this.listAttachments.add(aw);
        
        if (this.npcFormId != null && this.npcFormId.trim() != '') {
            this.fromDevicePage = false;
            this.isEdit = true;
            this.isOnLoad = true;
            this.isFromPortal = false;
            
            // Retrieve NPC Form details
            retrieveNPCFormDetails();
            retrieveAdditionalRecipients();
            
            // Check if the Edit is from Portal
            User u = [
                    SELECT      Id
                                        , ContactId
                    FROM        User
                    WHERE       Id = :UserInfo.getUserId()
                ];
            
            if (u.ContactId != null) { this.isEditFromPortal = true;}
            
            // ZAmbat 03042014
            // Check if NPC Form has Device
            if (this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_RETROFIT').Value__c
                || this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_RETROFIT_ADD_ROM').Value__c
                || this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_PROBE_NEW_CARD').Value__c
                || this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_STARTINGMATERIAL').Value__c    //DBiswal 01202015
                || this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_BACKGROUNDTHICKNESS').Value__c    //DBiswal 01202015
                || this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_SHORTLOOP_FLOW').Value__c
                || (this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_OTHERS').Value__c && this.npcForm.Require_To_Create_The_New_Part__c == Environment_Variable__c.getInstance('NPC_REQUIRE_TO_CREATE_YES').Value__c)) {
                checkForRetrofitDevice();
            }
        } else {
            if (this.deviceId != null && this.deviceId.trim() != '') {
                this.fromDevicePage = true;
                this.isEdit = false;
                this.isOnLoad = false;
                this.isFromPortal = false;
                
                // Retrieve Device Details 
                retrieveDeviceDetails();
                retrieveAdditionalRecipients();
            } else if (this.userId != null && this.userId.trim() != '') {
                this.fromDevicePage = false;
                this.isEdit = false;
                this.isOnLoad = false;
                this.isFromPortal = true;
                
                // Init Account
                retrieveUserAccount();
                retrieveAdditionalRecipients();
            } else {
                this.fromDevicePage = false;
                this.isEdit = false;
                this.isOnLoad = false;
                this.isFromPortal = false;
            }
        }
        
        system.debug('this.isEdit =================> ' + this.isEdit);
        if (this.isEdit == false) {
            if (this.npcForm.Reason_for_New_Part__c == null || this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_RETROFIT').Value__c || this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_RETROFIT_ADD_ROM').Value__c) {
                this.npcForm.Require_To_Create_The_New_Part__c = Environment_Variable__c.getInstance('NPC_REQUIRE_TO_CREATE_YES').Value__c;
            } else if (this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_OTHERS').Value__c) {    this.npcForm.Require_To_Create_The_New_Part__c = null; } else { this.npcForm.Require_To_Create_The_New_Part__c = Environment_Variable__c.getInstance('NPC_REQUIRE_TO_CREATE_NO').Value__c;}
        }
        
        getAccountNames();
    }

    public void getEmailAddress(){
      list<string> strlst=new list<string>();
      String str = npcForm.Notification_Group__c;
         System.debug('===str==='+str);
       if(strlst.size()>0){
       for(String strFinal: str.split(';')){
            strlst.add(strFinal);
              System.debug('===Final val==='+strFinal);
          }
        } 
       System.debug('===Final List==='+strlst);
    }

   //Dipak 19092016 End
    public void retrieveNPCFormDetails() {
        // Get NPC Form
        this.npcForm = [
            SELECT      Id
                        , Name
                        , Primary_Device_AM__c       // Dipak 17102016
                        , Primary_Device_AM2__C 
                        , Notification_Group__c
                        , Risk_Waiver__c
                        , NRE_25K_USD__c
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
                        , Comments2__c           // Dipak 15112016
                        , RecordTypeId
                        , RecordType.Name
                        , Account_Short_Name__c
                        , Automotive_Device__c
                        , Device_Mask_Set_Title__c
                        , Mask_Set_Title__c
                        , NPC_Form_Status__c
                        , Reason_for_editing__c
                        , Require_To_Create_The_New_Part__c
                        , New_Customer_Name__c
                        , Case__c
                        , New_Customer_Short_Name__c
                        , Additional_Recipient_1__c
                        , Additional_Recipient_2__c
                        , Additional_Recipient_3__c
                        , Additional_Recipient_4__c
                        , Additional_Recipient_5__c
                        , Current_Forecast_Tapeout_Date__c
                        , New_Fab__c,Is_reticle_available__c,Next_3_Years_1__c,Next_3_Years_2__c,Next_3_Years_3__c
                        ,Past_3_Years_1__c,Past_3_Years_2__c,Past_3_Years_3__c
            FROM        New_Part_Creation_Form__c
            WHERE       Id = :this.npcFormId
        ];
        
        if (this.device.Fab__c != 'FAB 1' && this.device.Fab__c != 'FAB 8') {
            // Get Mask
            //DBiswal 06022015
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
            
            // Put in map
            this.mapNewPartId.put(this.npcForm.Reference_Id__c, this.npcForm.New_Part_ID__c);
            if (this.listMask.size() > 0) {
                this.mapMask.put(this.npcForm.Reference_Id__c, this.listMask);
            }
        }
        
        // ZAmbat 12042013
        if (this.npcForm.NPC_Form_Status__c == Environment_Variable__c.getInstance('NPC_STATUS_IN_EXEC').Value__c && this.npcForm.RecordType.Name == Environment_Variable__c.getInstance('NPC_STATUSREJECTED').Value__c) {
            this.isRejected = true;
        } else {
            this.isRejected = false;
        }
        
        // ZAmbat 03042014
        if (this.isEdit == true) {
            this.origNPCReason = this.npcForm.Reason_for_New_Part__c;
            this.origMESReferenceId = this.npcForm.Reference_Id__c;
            this.origNewPartId = this.npcForm.New_Part_ID__c;
            this.origRequireToCreateTheNewPart = this.npcForm.Require_To_Create_The_New_Part__c;
        }
        //this.npcForm.NPC_Form_Status__c = 'Draft';
        
        this.hasDevice = true;        
        if (this.isClone) {
            this.npcForm.NPC_Form_Status__c = null;
        }
        
        // Retrieve Device details
        retrieveDeviceDetails();
        
        // ZAmbat 12112013 - Removed
        // Set Default Reference Id in Picklist
        
    }
    
    public void retrieveDeviceDetails() {
        string pDeviceId;
        if (this.deviceId != null) {
            pDeviceId = this.deviceId;
        } else {
            //pDeviceId = this.npcForm.BASE_Device__c;
            pDeviceId = this.npcForm.Originating_Device__c;
        }
        system.debug('pDeviceId ================> ' + pDeviceId);
        List<Device__c> listDevice = [
            SELECT      Id
                        , Name
                        , Primary_Device_AM__c       // Dipak 17102016
                        , Account__c
                        , Account__r.Name
                        , Assigned_Process_ID__r.PID_Number__c
                        , Assigned_Process_ID__r.Name
                        , Account_Short_Name__c
                        , Device_Type__c
                        , CRMDID__c
                        , Fab__c
                        , PLM_Device_Id__c
                        , Device_Mask_Set_Title__c
                        , Secure_Device__c
                        , Automotive_Device__c
                        , Device_Base_Id__c
                        , Device_Complete__c
                        , Stage__c
                        , Status__c
                        , Tapeout_Type__c
                        , Assigned_Process_ID__r.ATTRIBUTE_READINESS_CALCULATED__c
                        , Assigned_Process_ID__r.Available_to_Sell__c
                        , STF_Process_ID__c
            FROM        Device__c
            WHERE       Id = :pDeviceId
        ];
        
        if (listDevice.size() > 0) {
            this.device = listDevice[0];
            // query from Process Object
            if(this.device.STF_Process_ID__c != null){
            List<Process__c>  oProcesslist = [SELECT ID,Name,Available_to_Sell__c FROM Process__c WHERE Name =: this.device.STF_Process_ID__c];
           if(oProcesslist.size() > 0 ){
                    Process__c oProcess = oProcesslist[0]; 
                    NPCForm.PID_Status__c = oProcess.Available_to_Sell__c;
                    NPCForm.PID__c =  oProcess.Name;                                                          
           }
           }


            if(!this.device.Device_Complete__c) {
                String errorMsg = '';
                if (Error_Codes__c.getInstance('DEVICE_COMPLETION')!= null){
                    errorMsg =  Error_Codes__c.getInstance('DEVICE_COMPLETION').Message__c;
                    errorMsg = (!String.isBlank(errorMsg)) ? errorMsg : 'Required fields are missing on Device.';
                }else{
                    errorMsg = 'Required fields are missing on Device.';
                }
                isError = true;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, errorMsg));
                return;
            }
            if (this.isEdit == false) { 
                if (listDevice[0].Device_Type__c == 'Base') {
                    //this.device = listDevice[0];
                    this.npcForm.BASE_Device__c = listDevice[0].Id;
                } else {
                    //this.device = retrieveBaseDevice(listDevice[0].CRMDID__c, listDevice[0].Device_Base_Id__c);
                    Device__c tempDevice = retrieveBaseDevice(listDevice[0].CRMDID__c, listDevice[0].Device_Base_Id__c);
                    if (tempDevice != null) {
                        this.npcForm.BASE_Device__c = tempDevice.Id;                         
                    }
                }                
            }
        }
       
        if (this.device.Id != null) {
            // Reset values
            if (this.isOnLoad == false) {
                this.listMask = new List<Mask__c>();
                this.listReferenceIds = new List<SelectOption>();
                this.npcForm.Reference_Id__c = null;
                this.npcForm.Fab__c = this.device.Fab__c;
                this.npcForm.Secure_Device__c = this.device.Secure_Device__c;
                this.npcForm.Automotive_Device__c = this.device.Automotive_Device__c;
            }
            
            // Validate if Device has PLM Device Id and Device Mask Set Title
            //if (this.device.PLM_Device_Id__c == null || this.device.Device_Mask_Set_Title__c == null) {
            // ZAmbat 10022013
            // ZAmbat 01282014
            
                // Assign values
                if (this.isEdit == false) {
                    this.npcForm.Account__c = this.device.Account__c;
                    //this.npcForm.BASE_Device__c = this.device.Id;
                    this.npcForm.Originating_Device__c = this.device.Id;
                    this.npcForm.Tapeout_Required__c = null;
                    // ZAmbat 01282014
                    this.npcForm.Mask_Set_Title__c = this.device.Device_Mask_Set_Title__c;
                }

                // Retrieve Reference Ids
                try {
                    if (this.device.Fab__c != 'FAB 1' && this.device.Fab__c != 'FAB 8') {
                        retrieveReferenceIds();
                    } else {
                        // ZAmbat 10012013
                        this.listReferenceIds = new List<SelectOption>();
                        this.listReferenceIds.add(new SelectOption('', 'N/A'));
                        this.npcForm.Reason_for_New_Part__c = Environment_Variable__c.getInstance('NPC_REASON_RETROFIT').Value__c;
                        this.npcForm.Tapeout_Required__c = Environment_Variable__c.getInstance('NPC_TAPEOUT_REQUIRED_YES').Value__c;
                    }
                } catch (Exception e) {
                    // Display error message
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, e.getMessage()));  
                }
                
                if (this.device.Fab__c != 'FAB 1' && this.device.Fab__c != 'FAB 8') {
                    // Enable Search buttons
                    this.disableButton = false;
                }
            //}
        } else {
            // Set
            this.disableSaveAddAttachment = true;
            this.isError = true;
            // Display error message
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Error_Codes__c.getInstance('NPC_NO_BASE_DEVICE').Message__c));
        }
    }
   
   // Dipak 24102016 Start 
    public void retrieveAccountTeamProxy() {
       
    }
    // Dipak 24102016 End
    
    @TestVisible
    private void retrieveUserAccount() {
        User u = [
            SELECT      Contact.AccountId
                        , Contact.Account.Name
            FROM        User
            WHERE       Id = :this.userId
        ];
        
        if (u.Contact.AccountId != null) {
            this.npcForm.Account__c = u.Contact.AccountId;
            this.accountName = u.Contact.Account.Name;
            this.portalUserAccountId = u.Contact.AccountId;
        }
    }
    
    public void getAccountNames() {
        this.listAccountNames1 = new List<SelectOption>();
        this.listAccountNames2 = new List<SelectOption>();
        this.listAccountNames3 = new List<SelectOption>();
        this.mapAccount = new Map<Id, Account>();
        
        if (this.isFromPortal == true) {
            this.listAccountNames1 = retrieveAccountNamesByHierarchy();
        } else {
                integer ctr = 0;
            for (Account a : [SELECT        Id
                                            , Name
                                            , Short_Name__c
                              FROM          Account
                              WHERE         RecordType.Name IN ('Customer', 'Enablement Partner', 'Reseller')
                                             AND Stage__c NOT IN ('UnQualified', 'Inactive')
                                            // AND Stage__c != 'Inactive'  // dipak 22112016
                              ORDER BY      Name]) { 
                ctr++;
                if (ctr <= 1000) {
                        this.listAccountNames1.add(new SelectOption(a.Id, a.Name));
                } else if (ctr > 1000 && ctr <= 2000) {
                        this.listAccountNames2.add(new SelectOption(a.Id, a.Name));
                } else if (ctr > 2000 && ctr <= 3000) {
                        this.listAccountNames3.add(new SelectOption(a.Id, a.Name));
                }
                
                this.mapAccount.put(a.Id, a);
            }
        }
        
        // Set default
        if (this.npcForm.New_Customer_Name__c == null) {
            if (this.listAccountNames1.size() > 0) {
                this.npcForm.New_Customer_Name__c = this.listAccountNames1[0].getValue();
            }
        } else {
            this.npcForm.New_Customer_Name__c = [SELECT Id FROM Account WHERE Name = :this.npcForm.New_Customer_Name__c AND Short_Name__c = :this.npcForm.New_Customer_Short_Name__c LIMIT 1].Id;
        }
    } 
    
    public List<SelectOption> retrieveAccountNamesByHierarchy() {
        List<SelectOption> tempListAccountName = new List<SelectOption>();
        List<Account> accList = new List<Account>( [
                                                    SELECT      Id
                                                                , ParentId
                                                    FROM        Account
                                                    //WHERE       Name = :this.accountName
                                                    WHERE       Id = :this.portalUserAccountId
                                                ]);
        // Get Account Id
        Account a = !accList.isEmpty() ? accList[0] : null;
        
        // Get Accounts in the Account Hierarchy
        Set<Id> accountIds = new Set<Id>();
        if (a != null && a.ParentId != null) {
            for (Account_Hierarchy__c ah : [SELECT      Parent_Id__c
                                            FROM        Account_Hierarchy__c
                                            WHERE       Account_Id__c = :a.Id
                                                        AND Parent_Id__c != :a.Id]) { 
                accountIds.add(ah.Parent_Id__c);
            }
        } 
        if(a!=null){
            for (Account_Hierarchy__c ah : [SELECT      Account_Id__c
                                            FROM        Account_Hierarchy__c
                                            WHERE       Parent_Id__c = :a.Id
                                                        AND Account_Id__c != :a.Id]) { 
                accountIds.add(ah.Account_Id__c);
            }
        }
        if (accountIds.size() > 0) {
            for (Account acct : [SELECT         Id
                                                , Name
                                                , Short_Name__c
                                 FROM           Account
                                 WHERE          Id IN :accountIds
                                                AND Stage__c != 'Inactive'
                                 ORDER BY       Name]) {
                tempListAccountName.add(new SelectOption(acct.Id, acct.Name));
                this.mapAccount.put(acct.Id, acct);
            }
        }
        
        return tempListAccountName;
    }
    
    public string getAccountShortName() {
        if (this.npcForm.New_Customer_Name__c != null) {
            this.npcForm.New_Customer_Short_Name__c = mapAccount.get(this.npcForm.New_Customer_Name__c).Short_Name__c;
        }
        
        return this.npcForm.New_Customer_Short_Name__c;
    }
    
    public void retrieveReferenceIds() {
            
              
        // Clear Mask Info
        //this.listMask = new List<Mask__c>();
        this.isAddMaskClicked = false;    //DBiswal 03052015
        
        // Assign values to this.listReferenceIds
        if (this.isEdit == false) {
            this.npcForm.Reference_Id__c = null;
        }
        
        
        
       
        // Assign
        this.isOnLoad = false;
        
        // Get first part of Base Device's PLM Device Id
        

        if (this.device.PLM_Device_Id__c != null) {
            string pPLMDeviceId = this.device.PLM_Device_Id__c.substringBefore('-');
            system.debug('pPLMDeviceId ===============> ' + pPLMDeviceId);
            
            // Retrieve Reference Ids
            MESService.processResponse_element res = new MESService.processResponse_element();
            MESService.SFMESSyncService_pt syncService = new MESService.SFMESSyncService_pt();
            
            // ZAmbat 02202014
            system.debug('npcForm.Reason_for_New_Part__c =========================> ' + this.npcForm.Reason_for_New_Part__c);
            string deviceType;
            if (this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_STF').Value__c) {
                deviceType = Environment_Variable__c.getInstance('MES_DEVICETYPE_OBSOLETE').Value__c;

            } else {
                deviceType = Environment_Variable__c.getInstance('MES_DEVICETYPE_RETROFIT').Value__c;
            }
            
            // ZAmbat 10212013
            if (!Test.isRunningTest()) {
                // ZAmbat 11/05/2013
                syncService.clientCertName_x = Environment_Variable__c.getInstance('SELF_SIGNED_CERTIFICATE').value__c;                
                // Adding Fab with PLM Device Id by two hashtags
                String tempPLMDeviceIdFab = pPLMDeviceId+'##'+this.device.Fab__c;
                system.debug('tempPLMDeviceIdFab ==> '+tempPLMDeviceIdFab);
                
                //11242014 DBiswal - Added 'CO' to reference ID of FAB3/5 Devices
                String npcPrefix = Environment_Variable__c.getInstance('NPC_FAB3_FAB5_PREFIX').Value__c ;
                if((this.device.Fab__c == 'FAB 3' || this.device.Fab__c == 'FAB 5')){
                    if(!tempPLMDeviceIdFab.startsWith(npcPrefix)){
                        tempPLMDeviceIdFab = npcPrefix + tempPLMDeviceIdFab;
                    }
                }           
                system.debug('tempPLMDeviceIdFab2 ==> '+tempPLMDeviceIdFab);
             
                res = syncService.process(tempPLMDeviceIdFab, null, null, null, deviceType);
            } else {
                res = NPCFormTest.MESServiceMockResponse();
            }
            
            system.debug('Response (Reference Ids) ================> ' + res);
            
            List<MESService.NPC_PART_MAST_TYPE_TOUT_element> listParts = res.NPC_PART_MAST_TYPE_TOUT;
            system.debug('listParts =============> ' + listParts);
            
            // ZAmbat 12112013
            // Set Default Reference Id in Picklist
            Set<String> sortedSet = new Set<String>();
            // ZAmbat 03042014
            //if (this.isEdit == true) {
            if (this.isEdit == true 
                && (this.npcForm.Reason_for_New_Part__c == this.origNPCReason
                    || (this.npcForm.Reason_for_New_Part__c != Environment_Variable__c.getInstance('NPC_REASON_STF').Value__c && this.origNPCReason != Environment_Variable__c.getInstance('NPC_REASON_STF').Value__c))) {
                if (this.npcForm.Reference_Id__c != null && this.npcForm.Reference_Id__c.trim() != '') {
                    //sortedSet.add(this.npcForm.Reference_Id__c);
                    sortedSet.add(this.origMESReferenceId);
                }
            }
            
            // ZAmbat 12112013 - Removed
            
            
            // ZAmbat 12112013
            if (listParts != null) {
                for (MESService.NPC_PART_MAST_TYPE_TOUT_element n : listParts) {
                    sortedSet.add(n.PART_ID);
                }
            } 
            
            this.listReferenceIds = new List<SelectOption>();
            if (sortedSet.size() > 0) {
                //this.listReferenceIds = new List<SelectOption>();
                
                // Sort list
                List<String> sortedList = new List<String>();
                sortedList.addAll(sortedSet);
                sortedList.sort();
                    
                for (string s : sortedList) {
                    this.listReferenceIds.add(new SelectOption(s, s));
                }
                
                // Set Default               
                if (this.isEdit == false) {
                    this.npcForm.Reference_Id__c = this.listReferenceIds[0].getValue();
                } else {
                    if (this.npcForm.Reason_for_New_Part__c != this.origNPCReason
                        && ((this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_STF').Value__c && this.origNPCReason != Environment_Variable__c.getInstance('NPC_REASON_STF').Value__c)
                             || (this.npcForm.Reason_for_New_Part__c != Environment_Variable__c.getInstance('NPC_REASON_STF').Value__c && this.origNPCReason == Environment_Variable__c.getInstance('NPC_REASON_STF').Value__c))) {
                        this.npcForm.Reference_Id__c = this.listReferenceIds[0].getValue(); 
                    } else {
                        if (this.isClone) {
                            if (this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_PROBE_NEW_CARD').Value__c) {
                                this.npcForm.New_Part_ID__c = Environment_Variable__c.getInstance('NPC_NEW_PROBE_CARD_PREFIX').Value__c + this.listReferenceIds[0].getValue();
                            } else if (this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_SHORTLOOP_FLOW').Value__c) {
                                this.npcForm.New_Part_ID__c = Environment_Variable__c.getInstance('NPC_NEW_PART_ID_SL').Value__c + this.listReferenceIds[0].getValue();
                            } else {
                                this.npcForm.Reference_Id__c = this.listReferenceIds[0].getValue();
                            }
                        } else {
                            this.npcForm.Reference_Id__c = this.origMESReferenceId;
                        }
                    }
                }
                
                if (this.isEdit == false) {
                    // ZAmbat 01152014
                    //Condition modified by Sunil Arora for case # 24171,to avoidupdating  New_Part_ID__c for pending resubmisison status.
                    if (this.npcForm.Reference_Id__c != 'NotAvailable' && this.hasDevice == false) {
                        if (this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_PROBE_NEW_CARD').Value__c) {
                            this.npcForm.New_Part_ID__c = Environment_Variable__c.getInstance('NPC_NEW_PROBE_CARD_PREFIX').Value__c + this.npcForm.Reference_Id__c;
                        } else if (this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_SHORTLOOP_FLOW').Value__c) {
                                this.npcForm.New_Part_ID__c = Environment_Variable__c.getInstance('NPC_NEW_PART_ID_SL').Value__c + this.npcForm.Reference_Id__c;
                        } else {
                            this.npcForm.New_Part_ID__c = this.npcForm.Reference_Id__c;     
                        }
                    } else {
                        this.npcForm.New_Part_ID__c = '';
                    }
                }
                
                // Clear Mask Info
                this.listMask = new List<Mask__c>();
                
                // Refresh table values
                retrieveMaskDetails();
            } else {                                
                // Added for Mask Layer retrieval based on Fab. Fix for Case 00004080.
                advancedSearchReferenceIds();
                //populateMaskLayers(res);
                // Commented for Mask Layer addition as the error message is shown inline.
                // Show error message
                //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Error_Codes__c.getInstance('NPC_NO_REFERENCE_IDS').Message__c));
            }
            
            // Assign
            this.isOnLoad = false;
        } else {
            // ZAmbat 10022013
            advancedSearchReferenceIds();
        }
        
        if (this.isEdit == false) {
            if (this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_RETROFIT').Value__c || this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_RETROFIT_ADD_ROM').Value__c) {
                this.npcForm.Require_To_Create_The_New_Part__c = Environment_Variable__c.getInstance('NPC_REQUIRE_TO_CREATE_YES').Value__c;
            } else {
                this.npcForm.Require_To_Create_The_New_Part__c = Environment_Variable__c.getInstance('NPC_REQUIRE_TO_CREATE_NO').Value__c;
            }
        } else {
            if (this.npcForm.Reason_for_New_Part__c != this.origNPCReason) {
                if (this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_RETROFIT').Value__c || this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_RETROFIT_ADD_ROM').Value__c) {
                    this.npcForm.Require_To_Create_The_New_Part__c = Environment_Variable__c.getInstance('NPC_REQUIRE_TO_CREATE_YES').Value__c;
                } else {
                    this.npcForm.Require_To_Create_The_New_Part__c = Environment_Variable__c.getInstance('NPC_REQUIRE_TO_CREATE_NO').Value__c;
                }
            } else {
                if (this.origRequireToCreateTheNewPart != null) {
                    this.npcForm.Require_To_Create_The_New_Part__c = this.origRequireToCreateTheNewPart;
                } else {
                    if (this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_RETROFIT').Value__c || this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_RETROFIT_ADD_ROM').Value__c) {
                        this.npcForm.Require_To_Create_The_New_Part__c = Environment_Variable__c.getInstance('NPC_REQUIRE_TO_CREATE_YES').Value__c;
                    } else {
                        this.npcForm.Require_To_Create_The_New_Part__c = Environment_Variable__c.getInstance('NPC_REQUIRE_TO_CREATE_NO').Value__c;
                    }
                }
            }
        }
        
        if (this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_PROBE_NEW_CARD').Value__c) {
            this.isMaskAlert = false;
        }
    }
    
    public void advancedSearchReferenceIds() {
        system.debug('Entered advanced search!!!');
        // Clear Mask Info
        //this.listMask = new List<Mask__c>();
        
        // Assign values to this.listReferenceIds
        string tempReferenceId = this.npcForm.Reference_Id__c;
        this.npcForm.Reference_Id__c = null;
        
        // Assign
        this.isOnLoad = false;
        
        // Get first part of Base Device's PLM Device Id
        
        
        if (this.device.Account_Short_Name__c != null && this.device.Fab__c != null) {
            string pAccountId = this.device.Account_Short_Name__c;
            string pFab = this.device.Fab__c;
            system.debug('pAccountId ===============> ' + pAccountId);
            system.debug('pFab ===============> ' + pFab);
            
            // Retrieve Reference Ids
            MESService.processResponse_element res = new MESService.processResponse_element();
            MESService.SFMESSyncService_pt syncService = new MESService.SFMESSyncService_pt();
            
            // ZAmbat 02202014
            system.debug('npcForm.Reason_for_New_Part__c =========================> ' + this.npcForm.Reason_for_New_Part__c);
            string deviceType;
            if (this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_STF').Value__c) {                        
                deviceType = Environment_Variable__c.getInstance('MES_DEVICETYPE_OBSOLETE').Value__c;
                system.debug('deviceType =========================> ' + deviceType);
            } else {
                deviceType = Environment_Variable__c.getInstance('MES_DEVICETYPE_RETROFIT').Value__c;
            }
            
            // ZAmbat 10212013
            if (!Test.isRunningTest()) {
                // ZAmbat 11/05/2013
                syncService.clientCertName_x = Environment_Variable__c.getInstance('SELF_SIGNED_CERTIFICATE').value__c;

                system.debug('pAccountId ======> '+ pAccountId);
                system.debug('pFab ====> '+ pFab);
                system.debug('deviceType ====> '+ deviceType);
                res = syncService.process(null, pAccountId, pFab, null, deviceType);
            } else {
                res = NPCFormTest.MESServiceMockResponse();
            }
            
            system.debug('Response (Reference Ids) ================> ' + res);
            
            List<MESService.NPC_PART_MAST_TYPE_TOUT_element> listParts = res.NPC_PART_MAST_TYPE_TOUT;
            system.debug('listParts =============> ' + listParts);
            
            // ZAmbat 12112013
            // Set Default Reference Id in Picklist
            Set<String> sortedSet = new Set<String>();
            // ZAmbat 03042014
            //if (this.isEdit == true) {
            if (this.isEdit == true 
                && (this.npcForm.Reason_for_New_Part__c == this.origNPCReason
                    || (this.npcForm.Reason_for_New_Part__c != Environment_Variable__c.getInstance('NPC_REASON_STF').Value__c && this.origNPCReason != Environment_Variable__c.getInstance('NPC_REASON_STF').Value__c))) {
                if (this.npcForm.Reference_Id__c != null && this.npcForm.Reference_Id__c.trim() != '') {
                    //sortedSet.add(this.npcForm.Reference_Id__c);
                    sortedSet.add(this.origMESReferenceId);
                }
            }
            
            // ZAmbat 12112013 - Removed
            
            system.debug('Check for listParts!!!');
            // ZAmbat 12112013
            if (listParts != null) {
                for (MESService.NPC_PART_MAST_TYPE_TOUT_element n : listParts) {
                    sortedSet.add(n.PART_ID);
                }
            } 
            system.debug('sortedSet ======================> ' + sortedSet);
            system.debug('sortedSet size ======================> ' + sortedSet.size());
            this.listReferenceIds = new List<SelectOption>();
            if (sortedSet.size() > 0) {
                //this.listReferenceIds = new List<SelectOption>();
                
                // Sort list
                List<String> sortedList = new List<String>();
                sortedList.addAll(sortedSet);
                sortedList.sort();
                    
                for (string s : sortedList) {
                    this.listReferenceIds.add(new SelectOption(s, s));
                }
                
                this.listReferenceIds.add(new SelectOption('NotAvailable', 'NotAvailable'));                

                if (this.isEdit == false) {
                    // ZAmbat 01152014
                    //Condition modified by Sunil Arora for case # 24171,to avoidupdating  New_Part_ID__c for pending resubmisison status.
                    if (this.npcForm.Reference_Id__c != 'NotAvailable' && this.hasDevice == false) {
                        if (this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_PROBE_NEW_CARD').Value__c) {
                            this.npcForm.New_Part_ID__c = Environment_Variable__c.getInstance('NPC_NEW_PROBE_CARD_PREFIX').Value__c + this.npcForm.Reference_Id__c;
                        } else if (this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_SHORTLOOP_FLOW').Value__c) {
                            this.npcForm.New_Part_ID__c = Environment_Variable__c.getInstance('NPC_NEW_PART_ID_SL').Value__c + this.npcForm.Reference_Id__c;
                        } else {
                            this.npcForm.New_Part_ID__c = this.npcForm.Reference_Id__c;     
                        }
                    } else {
                        this.npcForm.New_Part_ID__c = '';
                    }
                
                    // Set Default
                    this.npcForm.Reference_Id__c = this.listReferenceIds[0].getValue();
                } else {
                    if (this.npcForm.Reason_for_New_Part__c != this.origNPCReason
                        && ((this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_STF').Value__c && this.origNPCReason != Environment_Variable__c.getInstance('NPC_REASON_STF').Value__c)
                             || (this.npcForm.Reason_for_New_Part__c != Environment_Variable__c.getInstance('NPC_REASON_STF').Value__c && this.origNPCReason == Environment_Variable__c.getInstance('NPC_REASON_STF').Value__c))) {
                        this.npcForm.Reference_Id__c = this.listReferenceIds[0].getValue(); 
                    } else {
                        if (this.isClone) {
                            if (this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_PROBE_NEW_CARD').Value__c) {
                                this.npcForm.New_Part_ID__c = Environment_Variable__c.getInstance('NPC_NEW_PROBE_CARD_PREFIX').Value__c + this.listReferenceIds[0].getValue();
                            } else if (this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_SHORTLOOP_FLOW').Value__c) {
                                this.npcForm.New_Part_ID__c = Environment_Variable__c.getInstance('NPC_NEW_PART_ID_SL').Value__c + this.listReferenceIds[0].getValue();
                            } else {
                                this.npcForm.Reference_Id__c = this.listReferenceIds[0].getValue();
                            }
                        } else {
                            this.npcForm.Reference_Id__c = this.origMESReferenceId;
                        }
                    }
                }                
                
                // Refresh table values
                retrieveMaskDetails();
                //populateMaskLayers(res);
            } else {
                // Set Default
                //this.npcForm.Reference_Id__c = tempReferenceId;
                this.npcForm.Reference_Id__c = this.origMESReferenceId;
                system.debug('this.listReferenceIds ======================> ' + this.listReferenceIds);
                //Added for Mask Layer addition. Fix for Case 00004080.
                this.maskLayerOptions = new List<SelectOption>();
                populateMaskLayers(res);
                
                // Show error message
                //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Error_Codes__c.getInstance('NPC_NO_REFERENCE_IDS').Message__c));
            }
            
            // Assign
            this.isOnLoad = false;
        } else {
            // Show error message 
            this.isError = true;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Error_Codes__c.getInstance('NPC_ACCT_SHORTNAME_FAB_VALIDATION').Message__c));
        }
    }
    
    
    
    public Attachment getRemoveAttachment() {
        if (this.attachId == null) {
            for (AttachmentWrapper aw : this.listAttachments) {
                aw.attachment = new Attachment();
            }
        } else {
            for (AttachmentWrapper aw : this.listAttachments) {
                if (this.attachId == aw.id) {
                    aw.attachment = new Attachment();
                }
            }
            
            this.attachId = null;
        }
        
        return new Attachment();
    }
    
    public void addMore() {
        AttachmentWrapper aw = new AttachmentWrapper();
        aw.id = 'NPCFormVF:form1:BlkEdit:repeatAttach:' + this.listAttachments.size() + ':attach';
        aw.label = '';
        aw.attachment = new Attachment();
        this.listAttachments.add(aw);
    }
    
    public void retrieveMaskDetails() {
        this.isMaskAlert = true;
        this.isAddMaskClicked = false;    //DBiswal 03052015
        system.debug('this.maskLayerOptions ==> '+this.maskLayerOptions);
        system.debug('isMaskAlert ==>'+isMaskAlert);
        this.listMask = new List<Mask__c>();        
        //this.listMask1 = new List<Mask__c>();
        //DBiswal 03052015
        if (this.npcForm.Reference_Id__c != null && this.npcForm.Reference_Id__c != 'NotAvailable') { 
        //if (this.npcForm.Reference_Id__c != null && this.npcForm.Reference_Id__c != 'NotAvailable' && this.npcForm.Reason_for_New_Part__c != Environment_Variable__c.getInstance('NPC_REASON_PROBE_NEW_CARD').Value__c) {
            // ZAmbat 11252013
            //if (this.mapMask.containsKey(this.npcForm.Reference_Id__c)) {
            boolean fetchRecords = true;
            this.maskWrappers = new List<MaskWrapper>(); 
            
            if (this.mapMask.containsKey(this.npcForm.Reference_Id__c)) {
                //DBiswal 05272015 - checking masks again for cloned record
                if (this.mapMask.get(this.npcForm.Reference_Id__c).size() > 0 && !this.isClone && 
                    this.origNPCReason != Environment_Variable__c.getInstance('NPC_REASON_PROBE_NEW_CARD').Value__c && this.origNPCReason != Environment_Variable__c.getInstance('NPC_REASON_SHORTLOOP_FLOW').Value__c) {
                    fetchRecords = false;
                }
            } 
            
            if (fetchRecords == false) {
                this.listMask = this.mapMask.get(this.npcForm.Reference_Id__c);
            } else {
                MESService.processResponse_element res = new MESService.processResponse_element();
                MESService.SFMESSyncService_pt syncService = new MESService.SFMESSyncService_pt();
                system.debug('this.npcForm.Reference_Id__c ================> ' + this.npcForm.Reference_Id__c);
                
                // ZAmbat 02202014
                system.debug('npcForm.Reason_for_New_Part__c in Mask Details =========================> ' + this.npcForm.Reason_for_New_Part__c);
                string deviceType;
                if (this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_STF').Value__c) {
                    deviceType = Environment_Variable__c.getInstance('MES_DEVICETYPE_OBSOLETE').Value__c;
                } else {
                    deviceType = Environment_Variable__c.getInstance('MES_DEVICETYPE_RETROFIT').Value__c;
                }
                
                // ZAmbat 10212013
                if (!Test.isRunningTest()) {
                    // ZAmbat 11/05/2013
                    syncService.clientCertName_x = Environment_Variable__c.getInstance('SELF_SIGNED_CERTIFICATE').value__c;
                    res = syncService.process(null, null, null, this.npcForm.Reference_Id__c, deviceType);
                } else {
                    res = NPCFormTest.MESServiceMockResponse();
                }
                
                system.debug('Response (Mask Layer Ids) ================> ' + res);
                
                List<MESService.WEB_PART_PHOTO_STAGE_TYPE_TOUT_element> listMasks = res.WEB_PART_PHOTO_STAGE_TYPE_TOUT;
                system.debug('listMasks =============> ' + listMasks);
                if (listMasks != null) {
                    system.debug('listMasks size =============> ' + listMasks.size());
                    // ZAmbat 12112013
                    Set<String> tempMaskSet = new Set<String>();
                    List<String> tempMaskList = new List<String>();
                    Map<string, Mask__c> mapMask = new Map<string, Mask__c>();
                    for (MESService.WEB_PART_PHOTO_STAGE_TYPE_TOUT_element w : listMasks) {
                        system.debug('w.LAYER_NO =======================> ' + w.LAYER_NO);
                        system.debug('w.RECTICLE_ID =======================> ' + w.RECTICLE_ID);
                        Mask__c m = new Mask__c();
                        m.Original_Mask__c = w.RECTICLE_ID;
                        m.Layer__c = w.LAYER_NO;
                        m.Modified_Mask__c = w.RECTICLE_ID;
                        
                        // mapMask.put(w.LAYER_NO + '-' + w.RECTICLE_ID, m);
                        //tempMaskList.add(w.LAYER_NO + '-' + w.RECTICLE_ID);
                        // tempMaskSet.add(w.LAYER_NO + '-' + w.RECTICLE_ID); Commented 05052015
                        
                        // Added 05052015
                        this.listMask.add(m);
                    }
                    system.debug('tempMaskSet size =======================> ' + tempMaskSet.size());
                    // Sort Masks
                    // Commented 05052015
                    
                    system.debug('this.listMask size =======================> ' + this.listMask.size());
                }                
            }
        }
        
        //DBiswal 03052015
        if((this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_PROBE_NEW_CARD').Value__c 
            || this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_SHORTLOOP_FLOW').Value__c)
            && this.listMask.size() > 0){
            if(this.isEdit == false || this.isClone == true){               
                for(Mask__c m2: this.listMask){
                    this.maskWrappers.add(new MaskWrapper(nextIdent++,m2));
                }                 
            } else {
                if (this.mapMask.containsKey(this.npcForm.Reference_Id__c) && this.mapMask.get(this.npcForm.Reference_Id__c).size() > 0){
                    List<Mask__c> listMaskSaved = this.mapMask.get(this.npcForm.Reference_Id__c);
                    Integer row =0;
                    Set<String> layerMatch = new Set<String>();
                        
                    for(Mask__c m3: listMaskSaved){
                        row = nextIdent++;
                        this.maskWrappers.add(new MaskWrapper(row,m3,true));
                        layerMatch.add(m3.Layer__c);
                    }                            
                        
                   for(Mask__c m2: this.listMask){
                       if(layerMatch.size() > 0){                                
                           if(!layerMatch.contains(m2.Layer__c)){
                               this.maskWrappers.add(new MaskWrapper(row++,m2,false));
                           }                                
                       } else{
                           this.maskWrappers.add(new MaskWrapper(row++,m2,false));
                       }
                   }
                    
                } else{
                    for(Mask__c m2: this.listMask){
                        this.maskWrappers.add(new MaskWrapper(nextIdent++,m2));
                    }                    
                }              
            }
        }
        
        //Added for Mask Layer addition. Fix for Case 00004080.
        //start
        if(this.npcForm.Reference_Id__c == null || this.npcForm.Reference_Id__c == 'NotAvailable'){
            this.listMask = new List<Mask__c>();
            maskWrappers = new List<MaskWrapper>();
            
            if(this.maskLayerOptions.size()==0){
                // Retrieve Reference Ids
                MESService.processResponse_element res1 = new MESService.processResponse_element();
                MESService.SFMESSyncService_pt syncService1 = new MESService.SFMESSyncService_pt();
                
                string deviceType;
                if (this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_STF').Value__c) {                    
                    deviceType = Environment_Variable__c.getInstance('MES_DEVICETYPE_OBSOLETE').Value__c;
                    system.debug('deviceType =========================> ' + deviceType);
                } else {
                    deviceType = Environment_Variable__c.getInstance('MES_DEVICETYPE_RETROFIT').Value__c;
                }
                
                // ZAmbat 10212013
                if (!Test.isRunningTest()) {
                    // ZAmbat 11/05/2013
                    syncService1.clientCertName_x = Environment_Variable__c.getInstance('SELF_SIGNED_CERTIFICATE').value__c;                
                    // Adding Fab with PLM Device Id by two hashtags                
                    String tempPLMDeviceIdFab = 'NotAvailable##'+this.device.Fab__c;
                    system.debug('tempPLMDeviceIdFab ==> '+tempPLMDeviceIdFab);
                  
                    res1 = syncService1.process(tempPLMDeviceIdFab, null, null, null, deviceType);
                } else {
                    res1 = NPCFormTest.MESServiceMockResponse();
                }
                
                system.debug('Response (Reference Ids) ================> ' + res1);                                 
                
                // Getting the mask layers for the Fab into a list for display
                List<MESService.WEB_PART_PHOTO_STAGE_TYPE_TOUT_element> listMLayer = res1.WEB_PART_PHOTO_STAGE_TYPE_TOUT;
                system.debug('listMasksLayers =============> ' + listMLayer);
                
                if (listMLayer != null) {
                    Integer i=0;
                    List<string> tempMaskList = new List<string>();
                      
                    
                    // ZAmbat 01152014
                    for (MESService.WEB_PART_PHOTO_STAGE_TYPE_TOUT_element w : listMLayer) {
                        if(w.LAYER_NO != null){
                            tempMaskList.add(w.LAYER_NO);
                        }
                    } 
                    
                    this.maskLayerOptions.add(new SelectOption('', '--None--'));
                    if (tempMaskList.size() > 0) {
                        tempMaskList.sort();
                        for (string s : tempMaskList) {
                            this.maskLayerOptions.add(new SelectOption(s, s));
                        }
                    }
                }
            }
            
            List<Mask__c> existingMask = [
                    SELECT      Layer__c,
                                Original_Mask__c,
                                Modified_Mask__c,
                                New_Part_Creation_Form__c
                    FROM        Mask__c
                    WHERE       New_Part_Creation_Form__c = :this.npcForm.Id 
                    AND         Original_Mask__c = null
                ];                
            
            if(existingMask!=null && existingMask.size()>0 && this.isClone == false){    //DBiswal 01132015 - Added clone flag
                for(Mask__c m1:existingMask){
                    maskWrappers.add(new MaskWrapper(nextIdent++,m1));
                }
            }else{
                for(Integer i=0;i<5;i++){
                    maskWrappers.add(new MaskWrapper(nextIdent++,null));
                }
            }
        }
        //end
        
        // ZAmbat 12112013
        //Condition modified by Sunil Arora for case # 24171,to avoid updating  New_Part_ID__c for pending resubmisison status.
        if (this.hasDevice == false && (this.npcForm.NPC_Form_Status__c == null || this.npcForm.NPC_Form_Status__c.trim() == '' || this.npcForm.NPC_Form_Status__c == Environment_Variable__c.getInstance('NPC_STATUS_PEND_SUBMISSION').Value__c || this.npcForm.NPC_Form_Status__c == Environment_Variable__c.getInstance('NPC_STATUS_PEND_RESUB').Value__c)) {
            if (this.mapNewPartId.containsKey(this.npcForm.Reference_Id__c) && !this.isClone) {
                if (this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_PROBE_NEW_CARD').Value__c) {
                    if (this.mapNewPartId.get(this.npcForm.Reference_Id__c).startsWith(Environment_Variable__c.getInstance('NPC_NEW_PROBE_CARD_PREFIX').Value__c)) {
                        this.npcForm.New_Part_ID__c = this.mapNewPartId.get(this.npcForm.Reference_Id__c);
                    } else if (this.mapNewPartId.get(this.npcForm.Reference_Id__c).startsWith(Environment_Variable__c.getInstance('NPC_NEW_PART_ID_SL').Value__c)) {
                        this.npcForm.New_Part_ID__c = Environment_Variable__c.getInstance('NPC_NEW_PROBE_CARD_PREFIX').Value__c + this.mapNewPartId.get(this.npcForm.Reference_Id__c).substring(2);
                    } else {
                        this.npcForm.New_Part_ID__c = Environment_Variable__c.getInstance('NPC_NEW_PROBE_CARD_PREFIX').Value__c + this.mapNewPartId.get(this.npcForm.Reference_Id__c);         
                    }
                } else if (this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_SHORTLOOP_FLOW').Value__c) {
                    if (this.mapNewPartId.get(this.npcForm.Reference_Id__c).startsWith(Environment_Variable__c.getInstance('NPC_NEW_PART_ID_SL').Value__c)) {
                        this.npcForm.New_Part_ID__c = this.mapNewPartId.get(this.npcForm.Reference_Id__c);
                    } else if (this.mapNewPartId.get(this.npcForm.Reference_Id__c).startsWith(Environment_Variable__c.getInstance('NPC_NEW_PROBE_CARD_PREFIX').Value__c)) {
                        this.npcForm.New_Part_ID__c = Environment_Variable__c.getInstance('NPC_NEW_PART_ID_SL').Value__c + this.mapNewPartId.get(this.npcForm.Reference_Id__c).substring(2);
                    } else {
                        this.npcForm.New_Part_ID__c = Environment_Variable__c.getInstance('NPC_NEW_PART_ID_SL').Value__c + this.mapNewPartId.get(this.npcForm.Reference_Id__c);         
                    }
                } else {
                    this.npcForm.New_Part_ID__c = this.mapNewPartId.get(this.npcForm.Reference_Id__c);
                }
            } else {
                // ZAmbat 01152014
                //if (this.isEdit == false) {
                    //Condition modified by Sunil Arora for case # 24171,to avoid updating  New_Part_ID__c for pending resubmisison status.
                    if (this.npcForm.Reference_Id__c != 'NotAvailable' && this.hasDevice == false) {
                        if (this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_PROBE_NEW_CARD').Value__c) {
                            if (this.npcForm.Reference_Id__c != null) {
                                this.npcForm.New_Part_ID__c = Environment_Variable__c.getInstance('NPC_NEW_PROBE_CARD_PREFIX').Value__c + this.npcForm.Reference_Id__c;        
                            } else {
                                this.npcForm.New_Part_ID__c = Environment_Variable__c.getInstance('NPC_NEW_PROBE_CARD_PREFIX').Value__c + this.listReferenceIds[0].getValue();            
                            }
                        } else if (this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_SHORTLOOP_FLOW').Value__c) {
                            if (this.npcForm.Reference_Id__c != null) {
                                this.npcForm.New_Part_ID__c = Environment_Variable__c.getInstance('NPC_NEW_PART_ID_SL').Value__c + this.npcForm.Reference_Id__c;        
                            } else {
                                this.npcForm.New_Part_ID__c = Environment_Variable__c.getInstance('NPC_NEW_PART_ID_SL').Value__c + this.listReferenceIds[0].getValue();            
                            }
                        } else {
                            if (this.npcForm.Reference_Id__c != null) {
                                this.npcForm.New_Part_ID__c = this.npcForm.Reference_Id__c;
                            } else {
                                this.npcForm.New_Part_ID__c = this.listReferenceIds[0].getValue();
                            }
                        }     
                    } else {
                        this.npcForm.New_Part_ID__c = '';
                    }
                
            }
        }
        
        if (this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_PROBE_NEW_CARD').Value__c) {
            this.isMaskAlert = false;
        }
    }
    
    public PageReference save() {
        // Init
        system.debug('in save method1');
        PageReference pageRef;
        
        try {
            // Validate if Device has PLM Device Id and Device Mask Set Title
            system.debug('this.device.PLM_Device_Id__c ===============> ' + this.device.PLM_Device_Id__c);
           // system.debug('this.device.Device_Mask_Set_Title__c ===============> ' + this.NPCFormControllerdevice.Device_Mask_Set_Title__c);
            //
            //if ((this.device.PLM_Device_Id__c == null || this.device.Device_Mask_Set_Title__c == null) && (this.device.Fab__c != 'FAB 1' && this.device.Fab__c != 'FAB 8')) {
            // ZAmbat 10022013
            //if (this.device.Device_Mask_Set_Title__c == null) {
            // ZAmbat 01282014
            // Dipak 19092016 Start
             if (this.npcForm.Reason_for_New_Part__c != null
                 && Environment_Variable__c.getInstance('NPC_REASON_CUSTOMERNAMECHANGE').Value__c != null
                 && Label.ECN_Date_Range != null
                 && Label.ECN_Date_Error_Message != null
                 && this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_CUSTOMERNAMECHANGE').Value__c) {
                    
                    Date restrictedDate = Date.today().addDays(Integer.valueOf(Label.ECN_Date_Range));

                    if(this.npcForm.ECN_Change_Date__c <= restrictedDate){
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,  Label.ECN_Date_Error_Message));
                        return null;
                    }
             }
             
            if (this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_STF').Value__c){ //yathish st
                  system.debug('***here***'+this.npcForm.Originating_Device__c);
                  this.npcForm.Originating_Device__c = this.npcForm.BASE_Device__c;            
                  system.debug('***here***'+this.npcForm.Originating_Device__c);                  
                   
                   // query and check if an existing NPC records with Device Reactivation.
                   this.NPCForm.Device_Status__c = EnvironmentVariable.get('DEVICE_STATUS_ACTIVE');                   
                        list<New_Part_Creation_Form__c> oldNpcList = [SELECT ID FROM New_Part_Creation_Form__c WHERE BASE_Device__c=: this.deviceId AND Reason_for_New_Part__c =: Environment_Variable__c.getInstance('NPC_REASON_STF').Value__c AND (NPC_Form_Status__c != 'Executed' and NPC_Form_Status__c != 'Not Executed') And Id !=: this.npcForm.Id];
                            if(!oldNpcList.isEmpty() && oldNpcList.size() >0){
                            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, EnvironmentVariable.get('NPC_STF_Existing'))); refreshAttachments(); return null;
                            }                        
                   
                   if(this.npcForm.Is_reticle_available__c == 'NO') {                   
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, EnvironmentVariable.get('NPC_STF_NoActivation'))); refreshAttachments(); return null;
                   }
                   if(this.npcForm.Comments__c == '' || this.npcForm.Comments__c ==null ) {                   
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, EnvironmentVariable.get('NPC_STF_SELECT_REASON'))); refreshAttachments(); return null;
                   }                   
                   if(this.npcForm.Is_reticle_available__c =='' || this.npcForm.Is_reticle_available__c ==null ) {                                 
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, EnvironmentVariable.get('NPC_STF_FullSet_Reticle'))); refreshAttachments(); return null;
                   }                   
                   if(this.npcForm.Is_reticle_available__c != 'NO'){
                   if(( this.npcForm.Next_3_Years_1__c==null) ||(this.npcForm.Next_3_Years_2__c==null) || ( this.npcForm.Next_3_Years_3__c==null)) {                
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, EnvironmentVariable.get('NPC_STF_Next3_VALIDATE'))); refreshAttachments(); return null;
                   }
                   if( ( this.npcForm.Past_3_Years_1__c ==null) ||(this.npcForm.Past_3_Years_2__c==null) || ( this.npcForm.Past_3_Years_3__c ==null)) {                
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, EnvironmentVariable.get('NPC_STF_PAST_LOADING'))); refreshAttachments(); return null;
                   }
                   if(npcForm.Notification_Group__c != null && this.npcForm.Notification_Group__c != ''){                      
                       String str = npcForm.Notification_Group__c;              
                       String emailRegex = '^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$'; // source: <a href="http://www.regular-expressions.info/email.html" target="_blank" rel="nofollow">http://www.regular-expressions.info/email.html</a>
                       Pattern MyPattern = Pattern.compile(emailRegex);                            
                        if(str.split(';').size()>0){
                        for(String strFinal: str.split(';')){
                            Matcher MyMatcher = MyPattern.matcher(strFinal); 
                            if (!MyMatcher.matches()){
                                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, EnvironmentVariable.get('NPC_STF_Email_Validate') +'- '+strFinal));                                    
                                return null;                                                                
                            }                                                                                                                   
                            }                                                                       
                            }
                                                                                
                   }   
                   
                   }
                                      
                   
                   
                   //yathish end
                   
                  
                   if(this.Device.stage__c != 'EOL'|| this.Device.Status__c != 'Active' || this.Device.Tapeout_Type__c == 'GlobalShuttle MPW'){
                     string errorMessage = '';
                       if(this.Device.stage__c != 'EOL'){
                            errorMessage = EnvironmentVariable.get('NPC_STF_Device_EOL_VALIDATE');
                            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, errorMessage)); 
                            refreshAttachments();
                            return null;                           
                        }
                        
                        if(this.Device.Status__c != 'Active'){
                            errorMessage = EnvironmentVariable.get('NPC_STF_Device_ACTIVE_VALIDATE');
                             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, errorMessage));
                            refreshAttachments();
                            return null;
                        }
                        /*if(this.Device.Tapeout_Type__c == 'GlobalShuttle MPW'){
                            errorMessage = 'No Device Reactivation is allowed,if Device TapeOut Type is GlobalShuttle MPW ';
                            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, errorMessage));                            
                           refreshAttachments();
                            return null; 
                        } 
                        */                  
                   }                   
            }
            // Dipak 19092016 End    
            if (this.npcForm.Mask_Set_Title__c == null) {
                // Check the Device Fab
                system.debug('in if 1');
                if (this.device.Fab__c != 'FAB 1' && this.device.Fab__c != 'FAB 8') {
                    system.debug('in if 2');
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Error_Codes__c.getInstance('NPC_PLM_MASK_VALIDATION').Message__c));
                    refreshAttachments();
                    return null;    
                } else {
                    system.debug('in else 1');
                    // Check Tapeout Required
                    if (this.npcForm.Tapeout_Required__c != 'Yes') {
                        system.debug('in if 3');
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Error_Codes__c.getInstance('NPC_PLM_MASK_VALIDATION').Message__c));
                        refreshAttachments();
                        return null;
                    }
                }   
            }
            system.debug('in if 4');
            if (this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_FAB_TRANSFER').Value__c
                && (this.npcForm.New_Fab__c == null || this.npcForm.New_Fab__c == '')) {
                system.debug('in if 5');
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please provide a value for New Fab'));
                refreshAttachments();
                return null;
            }
            
            // ZAmbat 06102014
            // Check if New Part Id starts with 'SL'
            //DBiswal 03232015 - Commented
            
            
            //DBiswal 03252015 - Validate 'PC' and 'SL' for probe card and ShortLoop NPCs
            if (this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_PROBE_NEW_CARD').Value__c
                && this.npcForm.New_Part_ID__c.substring(0, 2) != Environment_Variable__c.getInstance('NPC_NEW_PROBE_CARD_PREFIX').Value__c) {
                system.debug('in if 6');
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Error_Codes__c.getInstance('NPC_NEW_PART_ID_SHOULD_START_WITH_PC').Message__c));
                refreshAttachments();
                return null;        
            }
            system.debug('in if 7');
            if (this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_SHORTLOOP_FLOW').Value__c
                && this.npcForm.New_Part_ID__c.substring(0, 2) != Environment_Variable__c.getInstance('NPC_NEW_PART_ID_SL').Value__c) {
                system.debug('in if 8');
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Error_Codes__c.getInstance('NPC_NEW_PART_ID_SHOULD_START_WITH_SL').Message__c));
                system.debug('in if 9');
                refreshAttachments();
                return null;        
            }
            system.debug('in if 10');
            system.debug('***this.npcForm.New_Part_ID__c***'+this.npcForm.New_Part_ID__c);            
            // Validate New Part Id Characters
            // Added IF condition Dipak 28092016 Start
            if (this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_STF').Value__c){ this.npcForm.New_Part_ID__c = this.device.Name; this.npcForm.Primary_Device_AM__c = this.device.Primary_Device_AM__c; this.npcform.No_of_AM_Approvers__c = 1;            updateAMDetails();}





           // if (this.npcForm.Reason_for_New_Part__c != Environment_Variable__c.getInstance('NPC_REASON_STF').Value__c){
               Pattern isValid = Pattern.Compile('^[0-9A-Za-z\\-\\_\\.]+$');
               Matcher newPartIdMatch = isValid.matcher(this.npcForm.New_Part_ID__c);
            system.debug('in if 11');
            
            // Added IF condition Dipak 28092016 End
            if (!newPartIdMatch.matches()) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Error_Codes__c.getInstance('NPC_NEW_PART_ID_ERROR').Message__c));
                refreshAttachments();
                return null;
            }
          //}              
            // Validate New Part Id
            // ZAmbat 10242013
            //if (this.isEdit == false) 
            system.debug('this.npcForm.Reason_for_New_Part__c ======================> ' + this.npcForm.Reason_for_New_Part__c);
            system.debug('NPC_REASON_PROBE_NEW_CARD ======================> ' + Environment_Variable__c.getInstance('NPC_REASON_PROBE_NEW_CARD').Value__c);
            system.debug('this.isEdit ======================> ' + this.isEdit);
            if (this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_RETROFIT').Value__c
                || this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_RETROFIT_ADD_ROM').Value__c
                || this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_PROBE_NEW_CARD').Value__c
                || this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_FAB_TRANSFER').Value__c
                || this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_CHANGE_PID').Value__c
                || this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_STARTINGMATERIAL').Value__c    //DBiswal 01202015
                || this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_BACKGROUNDTHICKNESS').Value__c    //DBiswal 01202015
                || this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_SHORTLOOP_FLOW').Value__c
                || (this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_OTHERS').Value__c && this.npcForm.Require_To_Create_The_New_Part__c == Environment_Variable__c.getInstance('NPC_REQUIRE_TO_CREATE_YES').Value__c)) {
                
                
                // ZAmbat 12062013 - Removed
                // ZAmbat 10282013
                
                
                // ZAmbat 07102014
                // Validate if Current Forecast Tapeout Date has value
                //if (this.npcForm.Current_Forecast_Tapeout_Date__c == null) {
                // ZAmbat 08122014
                system.debug('in if 12'+ this.npcForm.Current_Forecast_Tapeout_Date__c);
                if (this.npcForm.Current_Forecast_Tapeout_Date__c == null 
                    && this.npcForm.Tapeout_Required__c == 'Yes'
                    && (this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_RETROFIT').Value__c
                        || this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_RETROFIT_ADD_ROM').Value__c
                        || this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_FAB_TRANSFER').Value__c
                        || this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_CHANGE_PID').Value__c
                        || this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_STARTINGMATERIAL').Value__c
                        || this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_BACKGROUNDTHICKNESS').Value__c    //DBiswal 01202015
                        || this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_SHORTLOOP_FLOW').Value__c)) {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Error_Codes__c.getInstance('NPC_CURRENT_FORECAST_DATE_BLANK').Message__c));
                    refreshAttachments();
                    return null;
                }
                               
                     // ZAmbat 12062013
                List<Device__c> tempListDevice = new List<Device__c>(); 
                string tempName = this.npcForm.New_Part_ID__c;
                string origNewpart = this.npcForm.New_Part_ID__c;
                // Check if New Part Id has '-U' or '-'
                if (this.npcForm.New_Part_ID__c.indexOf('-') > -1) {
                    List<string> listCharacters = Environment_Variable__c.getInstance('NPC_NEW_PART_ID_REPLACE_LIST').Value__c.split(';');
                    string lastPart = this.npcForm.New_Part_ID__c.substring(this.npcForm.New_Part_ID__c.lastIndexOf('-'));
                    
                    for (string s : listCharacters) {
                        system.debug('s ===================> ' + s);
                        lastPart = lastPart.toUpperCase().replace(s, '');
                    }
                    
                    if (lastPart.length() == 2) {
                        try {
                            Integer numberCheck = Integer.valueOf(lastPart);
                            tempName = this.npcForm.New_Part_ID__c.substring(0, this.npcForm.New_Part_ID__c.lastIndexOf('-')) + '.' + String.valueOf(numberCheck).leftPad(2).replace(' ', '0');
                            system.debug('tempName ======================> ' + tempName);
                        } catch (Exception e) {
                            tempName = this.npcForm.New_Part_ID__c;
                        }
                    }
                }
                
                
                
                // ZAmbat 07022014
                tempListDevice = [
                    SELECT      Id
                                , NPC_Form__c
                                , Name
                                , Device_ID__c
                    FROM        Device__c
                    WHERE       Name = :tempName.toUpperCase()
                                OR Name = :origNewpart.toUpperCase()
                                OR Device_Id__c = :(tempName + Environment_Variable__c.getInstance('NPC_REASON_RETROFIT').Value__c).toUpperCase()
                                OR Device_Id__c = :origNewpart.toUpperCase()
                ];
                system.debug('Deepti'+this.isEdit+'****'+this.isClone+'****'+origNewpart.toUpperCase()+'**'+tempListDevice.size()+'**'+this.npcForm.New_Part_ID__c.toUpperCase()+'**'+tempListDevice+'**'+this.npcForm.Id);
                
                if (tempListDevice.size() > 0) {
                    if (this.isEdit == true && tempListDevice.size() == 1 && tempListDevice[0].NPC_Form__c == this.npcForm.Id) {
                        // Validate against other NPC records
                        // ZAmbat 01282014 - Added condition on the query (Reason for New Part = 'Retrofit')
                        // ZAmbat 02192014 - Added condition on the query (NPC Form Status != 'Not Executed')
                        // DBiswal 05042015 - Added the Reason for Parts which creates Device.
                        List<New_Part_Creation_Form__c> listNPC = [
                                SELECT          Id
                                FROM            New_Part_Creation_Form__c
                                WHERE           New_Part_ID__c = :this.npcForm.New_Part_ID__c.toUpperCase()
                                                AND Id != :this.npcForm.Id
                                                AND (Reason_for_New_Part__c = :Environment_Variable__c.getInstance('NPC_REASON_RETROFIT').Value__c
                                                    OR Reason_for_New_Part__c = :Environment_Variable__c.getInstance('NPC_REASON_RETROFIT_ADD_ROM').Value__c
                                                    OR Reason_for_New_Part__c = :Environment_Variable__c.getInstance('NPC_REASON_PROBE_NEW_CARD').Value__c 
                                                    OR Reason_for_New_Part__c = :Environment_Variable__c.getInstance('NPC_REASON_FAB_TRANSFER').Value__c 
                                                    OR Reason_for_New_Part__c = :Environment_Variable__c.getInstance('NPC_REASON_CHANGE_PID').Value__c 
                                                    OR Reason_for_New_Part__c = :Environment_Variable__c.getInstance('NPC_REASON_STARTINGMATERIAL').Value__c 
                                                    OR Reason_for_New_Part__c = :Environment_Variable__c.getInstance('NPC_REASON_BACKGROUNDTHICKNESS').Value__c 
                                                    OR Reason_for_New_Part__c = :Environment_Variable__c.getInstance('NPC_REASON_SHORTLOOP_FLOW').Value__c 
                                                    OR (Reason_for_New_Part__c = :Environment_Variable__c.getInstance('NPC_REASON_OTHERS').Value__c AND Require_To_Create_The_New_Part__c = :Environment_Variable__c.getInstance('NPC_REQUIRE_TO_CREATE_YES').Value__c)) 
                                                AND NPC_Form_Status__c != :Environment_Variable__c.getInstance('NPC_STATUS_NOT_EXEC').Value__c
                        ];
                        
                        if (listNPC.size() > 0) {
                            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Error_Codes__c.getInstance('NPC_NEW_PART_ID_VALIDATION_UNIQUE').Message__c));
                            refreshAttachments();
                            return null;
                        }
                    } else {
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Error_Codes__c.getInstance('NPC_NEW_PART_ID_VALIDATION').Message__c));
                        refreshAttachments();
                        return null;
                    }
                    //DBiswal 03022015
                    Integer showCount = 0;
                    if(this.npcForm.NPC_Form_Status__c == 'Draft' || this.npcForm.NPC_Form_Status__c == 'Pending Submission' 
                        || this.npcForm.NPC_Form_Status__c == '' || this.isClone == true){
                        for(Device__c dev: tempListDevice){
                            if(dev.Name == origNewpart.toUpperCase() || dev.Name == tempName.toUpperCase() || dev.Device_ID__c.contains(origNewpart.toUpperCase())){
                                showCount++;
                            }
                        }
                    }
                    if(showCount > 0){
                        system.debug('Deepti inside 1st'+tempListDevice[0].Name+'***'+tempListDevice[0].Device_ID__c);
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Error_Codes__c.getInstance('NPC_NEW_PART_ID_VALIDATION').Message__c));
                        refreshAttachments();
                        return null;
                    }
                } else {
                    // ZAmbat 10252013
                    // Validate against other NPC records
                    // ZAmbat 01282014 - Added condition on the query (Reason for New Part = 'Retrofit')
                    // ZAmbat 02192014 - Added condition on the query (NPC Form Status != 'Not Executed')
                    // DBiswal 05042015 - Added the Reason for Parts which creates Device.
                    List<New_Part_Creation_Form__c> listNPC = [
                            SELECT          Id
                            FROM            New_Part_Creation_Form__c
                            WHERE           New_Part_ID__c = :this.npcForm.New_Part_ID__c.toUpperCase()
                                            AND Id != :(this.isClone ? '' : this.npcForm.Id)
                                            AND (Reason_for_New_Part__c = :Environment_Variable__c.getInstance('NPC_REASON_RETROFIT').Value__c
                                                OR Reason_for_New_Part__c = :Environment_Variable__c.getInstance('NPC_REASON_RETROFIT_ADD_ROM').Value__c
                                                OR Reason_for_New_Part__c = :Environment_Variable__c.getInstance('NPC_REASON_PROBE_NEW_CARD').Value__c 
                                                OR Reason_for_New_Part__c = :Environment_Variable__c.getInstance('NPC_REASON_FAB_TRANSFER').Value__c 
                                                OR Reason_for_New_Part__c = :Environment_Variable__c.getInstance('NPC_REASON_CHANGE_PID').Value__c 
                                                OR Reason_for_New_Part__c = :Environment_Variable__c.getInstance('NPC_REASON_STARTINGMATERIAL').Value__c 
                                                OR Reason_for_New_Part__c = :Environment_Variable__c.getInstance('NPC_REASON_BACKGROUNDTHICKNESS').Value__c 
                                                OR Reason_for_New_Part__c = :Environment_Variable__c.getInstance('NPC_REASON_SHORTLOOP_FLOW').Value__c
                                                OR (Reason_for_New_Part__c = :Environment_Variable__c.getInstance('NPC_REASON_OTHERS').Value__c AND Require_To_Create_The_New_Part__c = :Environment_Variable__c.getInstance('NPC_REQUIRE_TO_CREATE_YES').Value__c))
                                            AND NPC_Form_Status__c != :Environment_Variable__c.getInstance('NPC_STATUS_NOT_EXEC').Value__c
                    ];
                   system.debug('in if 13'); 
                    if (listNPC.size() > 0) {
                        system.debug('in if 14');
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Error_Codes__c.getInstance('NPC_NEW_PART_ID_VALIDATION_UNIQUE').Message__c));
                        refreshAttachments();
                        return null;
                    }
                }
            } else {
                this.npcForm.Current_Forecast_Tapeout_Date__c = null;
            }
            
            // Validate Comment / Attachment
            
            
            // Check Base Device's Fab
            if ((this.device.Fab__c == 'FAB 1' || this.device.Fab__c == 'FAB 8') && (this.npcForm.Tapeout_Required__c == 'No') && (this.npcForm.Reason_for_New_Part__c == 'Retrofit')) {
                // Show Error Message
               system.debug('in if 15');
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Error_Codes__c.getInstance('NPC_FAB_VALIDATION').Message__c));
                refreshAttachments();
                return null;
            } else {
                system.debug('in if 16');
                // Save NPC Form
                //this.npcForm.Name = this.device.Name + this.npcForm.Reference_Id__c;
                if (this.isEdit == false) {
                    this.npcForm.Account__c = this.device.Account__c;
                    //this.npcForm.BASE_Device__c = this.device.Id;
                    this.npcForm.Originating_Device__c = this.device.Id;
                    system.debug('****this.npcForm.Originating_Device__c****'+this.npcForm.Originating_Device__c);
                     

                    // Check Tapeout Required
                    //if ((this.device.Fab__c == 'FAB 1' || this.device.Fab__c == 'FAB 8') && (this.npcForm.Tapeout_Required__c == 'Yes')) {
                    if ((this.device.Fab__c == 'FAB 1' || this.device.Fab__c == 'FAB 8') && (this.npcForm.Tapeout_Required__c == 'Yes') && (this.npcForm.Reason_for_New_Part__c == 'Retrofit')) {
                        this.npcForm.NPC_Form_Status__c = 'In Execution';
                        system.debug('in if 17');
                        // Set record type
                        RecordType rt = [
                            SELECT      Id
                            FROM        RecordType
                            WHERE       Name = :Environment_Variable__c.getInstance('NPC_STATUSSUBMITTED').Value__c
                                        AND SObjectType = 'New_Part_Creation_Form__c'
                        ];
                        
                        this.npcForm.RecordTypeId = rt.Id;
                    }
                }
                
                if (this.npcForm.Reason_for_New_Part__c != Environment_Variable__c.getInstance('NPC_REASON_CUSTOMERNAMECHANGE').Value__c) {
                    this.npcForm.New_Customer_Short_Name__c = null;
                    this.npcForm.New_Customer_Name__c = null;
                    system.debug('in if 18');
                } else {
                    this.npcForm.New_Customer_Short_Name__c = mapAccount.get(this.npcForm.New_Customer_Name__c).Short_Name__c;
                    this.npcForm.New_Customer_Name__c = mapAccount.get(this.npcForm.New_Customer_Name__c).Name;
                    system.debug('in if 19');
                }
                
                // Clear values
                this.npcForm.Additional_Recipient_1__c = null;
                this.npcForm.Additional_Recipient_2__c = null;
                this.npcForm.Additional_Recipient_3__c = null;
                this.npcForm.Additional_Recipient_4__c = null;
                this.npcForm.Additional_Recipient_5__c = null;
                
                integer z = 0;
                for (User u : this.listSelectedRecipients) {
                    if (z == 0) {
                        this.npcForm.Additional_Recipient_1__c = u.Id;
                    } else if (z == 1) {
                        this.npcForm.Additional_Recipient_2__c = u.Id;
                    } else if (z == 2) {
                        this.npcForm.Additional_Recipient_3__c = u.Id;
                    } else if (z == 3) {
                        this.npcForm.Additional_Recipient_4__c = u.Id;
                    } else if (z == 4) {
                        this.npcForm.Additional_Recipient_5__c = u.Id;
                    }
                    
                    z++;
                }
                system.debug('in if 20');
                if (this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_PROBE_NEW_CARD').Value__c
                    || this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_OTHERS').Value__c) {
                    this.npcForm.Current_Forecast_Tapeout_Date__c = null;
                }
                
                if (this.npcForm.Reason_for_New_Part__c != Environment_Variable__c.getInstance('NPC_REASON_FAB_TRANSFER').Value__c) {
                    this.npcForm.New_Fab__c = null;
                }
                
                //DBiswal 12042014 - Inserting a cloned record
                //SNune   18092015  - Modified code to fix the clone issue for FAB1,FAB8, Case 00047410
                if(this.isClone == true){
                    //Set default values
                    this.npcForm.id = null;
                     if ((this.device.Fab__c == 'FAB 1' || this.device.Fab__c == 'FAB 8') && (this.npcForm.Tapeout_Required__c == 'Yes') && (this.npcForm.Reason_for_New_Part__c == 'Retrofit')) {
                        this.npcForm.NPC_Form_Status__c = 'In Execution';
                        
                        // Set record type
                        RecordType rt = [
                            SELECT      Id
                            FROM        RecordType
                            WHERE       Name = :Environment_Variable__c.getInstance('NPC_STATUSSUBMITTED').Value__c
                                        AND SObjectType = 'New_Part_Creation_Form__c'
                        ];
                        
                        this.npcForm.RecordTypeId = rt.Id;
                    }else{
                        this.npcForm.NPC_Form_Status__c = Environment_Variable__c.getInstance('NPC_STATUS_PEND_SUBMISSION').Value__c;
                        //Set Record Type
                        RecordType rt1 = [
                                SELECT      Id
                                FROM        RecordType
                                WHERE       Name = :Environment_Variable__c.getInstance('NPC_STATUSNOTSUBMITTED').Value__c
                                            AND SObjectType = 'New_Part_Creation_Form__c'
                            ];
                        this.npcForm.RecordTypeId = rt1.Id;
                    }
                }
                system.debug('in if 21');
                upsert this.npcForm;
                system.debug('in if 22');
                
                
                // Save Attachment(s)
                List<Attachment> listInsertAttachments = new List<Attachment>(); 
                for (AttachmentWrapper a : this.listAttachments) {
                    if (a.attachment.Body != null) {
                        a.attachment.ParentId = this.npcForm.Id;
                        listInsertAttachments.add(a.attachment);
                    }
                }
                
                if (listInsertAttachments.size() > 0) {
                    insert listInsertAttachments;
                }
                
                // ZAmbat 12112013 - Removed
                // Save Masks
                
                
                // ZAmbat 12112013
                //if (this.isEdit == true && !this.mapMask.containsKey(this.npcForm.Reference_Id__c)) {
                if (this.isEdit == true) {
                    // Delete existing masks
                    List<Mask__c> tempListMask = [
                        SELECT      Id
                        FROM        Mask__c
                        WHERE       New_Part_Creation_Form__c = :this.npcForm.Id
                    ];
                    
                    if (tempListMask.size() > 0) {
                        DELETE tempListMask;
                    }
                }
                
                //DBiswal 04202015 - changed to fix mask insert issue
                if (this.listMask.size() > 0 && this.npcForm.Reason_for_New_Part__c != Environment_Variable__c.getInstance('NPC_REASON_FAB_TRANSFER').Value__c && this.npcForm.Reason_for_New_Part__c != Environment_Variable__c.getInstance('NPC_REASON_CHANGE_PID').Value__c) {
                    
                    
                    // Clone for fresh insert
                    List<Mask__c> listMaskNew = new List<Mask__c>();
                    //DBiswal 03052015
                    if(this.npcForm.Reason_for_New_Part__c != Environment_Variable__c.getInstance('NPC_REASON_PROBE_NEW_CARD').Value__c
                        && this.npcForm.Reason_for_New_Part__c != Environment_Variable__c.getInstance('NPC_REASON_SHORTLOOP_FLOW').Value__c){
                        for (Mask__c m : this.listMask) {
                            Mask__c newMask = m.clone(false, true);
                            newMask.New_Part_Creation_Form__c = this.npcForm.Id;
                        
                            listMaskNew.add(newMask);
                        }
                    } else {
                        for (MaskWrapper m : this.maskWrappers) {
                            if(((m.mask.Layer__c!=null && m.mask.Layer__c!='') 
                                || (m.mask.Modified_Mask__c!=null && m.mask.Modified_Mask__c!=''))
                                && m.isSelected == true){                           
                                Mask__c newMask1 = m.mask.clone(false, true);
                                newMask1.New_Part_Creation_Form__c = this.npcForm.Id;
                                
                                listMaskNew.add(newMask1);
                            }
                        }
                    }
                    if (listMaskNew.size() > 0) {
                        insert listMaskNew;
                    }
                }
                
                //Added for Mask Layer addition. Fix for Case 00004080.
                        //start
                else if(this.maskWrappers.size() > 0 && this.npcForm.Reason_for_New_Part__c != Environment_Variable__c.getInstance('NPC_REASON_FAB_TRANSFER').Value__c && this.npcForm.Reason_for_New_Part__c != Environment_Variable__c.getInstance('NPC_REASON_CHANGE_PID').Value__c){                
                                         
                    // Delete existing masks
                    List<Mask__c> tempListMask = [
                        SELECT      Id
                        FROM        Mask__c
                        WHERE       New_Part_Creation_Form__c = :this.npcForm.Id
                    ];
                    
                    if (tempListMask.size() > 0) {
                        DELETE tempListMask;
                    }
                    
                    
                    List<Mask__c> newMaskList = new List<Mask__c>();
                    //DBiswal 03042015
                    if(this.npcForm.Reason_for_New_Part__c != Environment_Variable__c.getInstance('NPC_REASON_PROBE_NEW_CARD').Value__c
                        && this.npcForm.Reason_for_New_Part__c != Environment_Variable__c.getInstance('NPC_REASON_SHORTLOOP_FLOW').Value__c){
                        for (MaskWrapper m : this.maskWrappers) {
                            if((m.mask.Layer__c!=null && m.mask.Layer__c!='') || (m.mask.Modified_Mask__c!=null && m.mask.Modified_Mask__c!='')){                           
                                Mask__c tempMask = new Mask__c();
                                tempMask.Layer__c = m.mask.Layer__c;
                                tempMask.Modified_Mask__c = m.mask.Modified_Mask__c;
                                tempMask.New_Part_Creation_Form__c = this.npcForm.Id;
                                
                                newMaskList.add(tempMask);                            }
                        }
                    } else {
                        for (MaskWrapper m : this.maskWrappers) {
                            if(((m.mask.Layer__c!=null && m.mask.Layer__c!='') 
                                || (m.mask.Modified_Mask__c!=null && m.mask.Modified_Mask__c!=''))
                                && m.isSelected == true){                           
                                Mask__c tempMask = new Mask__c();
                                tempMask.Layer__c = m.mask.Layer__c;
                                tempMask.Modified_Mask__c = m.mask.Modified_Mask__c;
                                tempMask.New_Part_Creation_Form__c = this.npcForm.Id;
                                
                                newMaskList.add(tempMask);
                            }
                        }
                    }
                    if(newMaskList.size()>0){                    
                        insert newMaskList;
                    }
                }
                //end
                // Set Value
                
                    // Go to detail page
                    // ZAmbat 11222013 - Removed 
                    //pageRef = new PageReference('/' + this.npcForm.Id);
                //}
                
                // ZAmbat 11222013
                //if (this.isFromPortal == true && this.portalUserAccountId != this.npcForm.Account__c) {
                    //pageRef = new PageReference('/GlobalfoundryView/MyDevices?name=NPCList&sfdc.tabName=01r900000003eSG');
                
                // ZAmbat 12092013 - Removed
                //string currentURL = ApexPages.currentPage().getHeaders().get('referer');
                //if (this.isFromPortal == true || currentURL.indexOf('GlobalfoundryView') != -1) {
                
                // ZAmbat 12092013
                string currentURL = ApexPages.currentPage().getHeaders().get('host');
                if (this.isFromPortal == true || currentURL.indexOf('globalfoundryview') != -1) {
                    // ZAmbat 11262013
                    pageRef = new PageReference('/GlobalfoundryView/apex/NPCFormReadOnlyVF?id=' + this.npcForm.Id); 
                } else {
                    pageRef = new PageReference('/' + this.npcForm.Id);
                }
                pageRef.setRedirect(true);
            }
        } catch (Exception e) {
            if (e.getMessage().indexOf('DUPLICATE_VALUE') > -1) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Error_Codes__c.getInstance('DUPLICATE_NEW_PART_ID').Message__c));
                refreshAttachments();
            } else {
              //  ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, e.getMessage()));
                 ApexPages.addMessages(e);              
                refreshAttachments();
            }
        }
        
        return pageRef;
    }    
    
    @TestVisible
    private Device__c retrieveBaseDevice(string crmdid, string deviceBaseId) {
        // Assign
        Device__c device = new Device__c();
        
        // Get Base CRMDID
        string baseCRMDID = crmdid.substringBefore('.') + '.00';
        
        // Init
        List<Device__c> listDevice = new List<Device__c>(); 
        
        // Find Base Device through CRMDID
        listDevice = [
            SELECT      Id
                        , Name
                        , Account__c
                        , Account__r.Name
                        , Account_Short_Name__c
                        , Device_Type__c
                        , CRMDID__c
                        , Fab__c
                        , PLM_Device_Id__c
                        , Device_Mask_Set_Title__c
                        , Secure_Device__c
                        , Automotive_Device__c
                        , Device_Base_Id__c
            FROM        Device__c
            WHERE       CRMDID__c = :baseCRMDID
        ];
        
        if (listDevice.size() > 0) {
            device = listDevice[0];
        } else {
            if (deviceBaseId != null) {
                // Find Base Device through Base Device Id
                listDevice = [
                    SELECT      Id
                                , Name
                                , Account__c
                                , Account__r.Name
                                , Account_Short_Name__c
                                , Device_Type__c
                                , CRMDID__c
                                , Fab__c
                                , PLM_Device_Id__c
                                , Device_Mask_Set_Title__c
                                , Secure_Device__c
                                , Automotive_Device__c
                                , Device_Base_Id__c
                    FROM        Device__c
                    WHERE       CRMDID__c = :deviceBaseId
                ];
                
                if (listDevice.size() > 0) {
                    device = listDevice[0];
                }
            }
        }
        
        return device;
    }
    
    public string retrieveObjectPrefix(string sfdcObject) {
        Map<String, Schema.SObjectType> globalDescribe = Schema.getGlobalDescribe();
        string objPrefix = globalDescribe.get(sfdcObject).getDescribe().getkeyprefix();
        
        return objPrefix;
    }
    
    public PageReference cancel() {
        PageReference pageRef;
        
        // ZAmbat 12092013 - Removed
        //string currentURL = ApexPages.currentPage().getHeaders().get('referer');
        //if (this.isFromPortal == true || currentURL.indexOf('GlobalfoundryView') != -1) {
        
        // ZAmbat 12092013
        string currentURL = ApexPages.currentPage().getHeaders().get('host');
        if (this.isFromPortal == true || currentURL.indexOf('globalfoundryview') != -1) {
            if (this.npcForm.Id != null) {
                pageRef = new PageReference('/GlobalfoundryView/apex/NPCFormReadOnlyVF?id=' + this.npcForm.Id);
            } else {
                pageRef = new PageReference('/GlobalfoundryView/MyDevices?name=NPCList&sfdc.tabName=01r900000003eSG');
            }
        } else if (this.isEdit == true) {
            pageRef = new PageReference('/' + this.npcForm.Id);
        } else if (this.fromDevicePage == true) {
            pageRef = new PageReference('/' + this.deviceId);
        } else {
            pageRef = new PageReference('/' + retrieveObjectPrefix('New_Part_Creation_Form__c') + '/o');
        }
        
        pageRef.setRedirect(true);
        return pageRef;
    } 
    
    public void refreshAttachments() {
        // Set attachment
        this.listAttachments = new List<AttachmentWrapper>();
        AttachmentWrapper aw = new AttachmentWrapper();
        aw.id = 'NPCFormVF:form1:BlkEdit:repeatAttach:0:attach';
        aw.label = 'Attachment(s)';
        aw.attachment = new Attachment();
        this.listAttachments.add(aw);
    }
    
    // ZAmbat 03042014
    public void checkForRetrofitDevice() {
        if (!this.isClone) {
            List<Device__c> listRetrofitDevice = [
                SELECT      Id
                FROM        Device__c
                WHERE       Device_Type__c = :Environment_Variable__c.getInstance('DEVICE_TYPE_RETROFIT').Value__c
                            AND NPC_Form__c = :this.npcForm.Id
            ];  

            if (listRetrofitDevice.size() > 0) {
                this.hasDevice = true;
            }
        } else {
            this.hasDevice = false;
        }
        this.hasDevice = true; 
    }
    
    public class AttachmentWrapper {
        public string id {get;set;}
        public string label {get;set;}
        public Attachment attachment {get;set;} 
    }
    
    //Added for Mask Layer addition. Fix for Case 00004080.
    //start
    public class MaskWrapper
    {
      public Mask__c mask {get; private set;}
      public Integer ident {get; private set;}
      public Boolean isSelected {get; set;}    //DBiswal 03032015
       
      public MaskWrapper(Integer inIdent, Mask__c m)
      {
           ident=inIdent;
           if(m==null){
               mask=new Mask__c();
           }else{
               mask=m;
           }
           if(isSelected == null){
               isSelected = false;
           }
      }
      
      //DBiswal 03112015
      public MaskWrapper(Integer inIdent, Mask__c m, Boolean selected)
      {
           ident=inIdent;
           if(m==null){
               mask=new Mask__c();
           }else{
               mask=m;
           }
           isSelected = selected;
      }
    }
    
    public void delWrapper()
    {
        Integer toDelPos=-1;
        for (Integer idx=0; idx<maskWrappers.size(); idx++)
        {
            if (maskWrappers[idx].ident==toDelIdent)
            {
                toDelPos=idx;
            }
        }
   
        if (toDelPos!=-1)
        {
            maskWrappers.remove(toDelPos);
        }
    }
  
    public void addRows()
    {
        //DBiswal 03122015        
        If((this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_PROBE_NEW_CARD').Value__c 
            || this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_SHORTLOOP_FLOW').Value__c)
            && (this.npcForm.Reference_Id__c != 'NotAvailable')){
            this.isAddMaskClicked = true;    
        } else {
            this.isAddMaskClicked = false;
        }
        for (Integer idx=0; idx<addCount; idx++)
        {
            maskWrappers.add(new MaskWrapper(nextIdent++,null));
        }
    }
    
    //Added for Mask Layer population based on Fab. Fix for Case 00004080.
    public void populateMaskLayers(MESService.processResponse_element res){
        system.debug('populateMaskLayers!!!!!!!!');
        if(this.listReferenceIds == null || this.listReferenceIds.size() == 0) {
            this.listReferenceIds = new List<SelectOption>();
            this.listReferenceIds.add(new SelectOption('NotAvailable', 'NotAvailable'));
            this.npcForm.Reference_Id__c = this.listReferenceIds[0].getValue(); 
            
            if (this.isEdit == false) {
                // ZAmbat 01152014
                //Condition modified by Sunil Arora for case # 24171,to avoidupdating  New_Part_ID__c for pending resubmisison status.
                if (this.npcForm.Reference_Id__c != 'NotAvailable' && this.hasDevice == false) {
                    if (this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_PROBE_NEW_CARD').Value__c) {
                        this.npcForm.New_Part_ID__c = Environment_Variable__c.getInstance('NPC_NEW_PROBE_CARD_PREFIX').Value__c + this.npcForm.Reference_Id__c;
                    } if (this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_SHORTLOOP_FLOW').Value__c) {
                        this.npcForm.New_Part_ID__c = Environment_Variable__c.getInstance('NPC_NEW_PART_ID_SL').Value__c + this.npcForm.Reference_Id__c;
                    } else {
                        this.npcForm.New_Part_ID__c = this.npcForm.Reference_Id__c;     
                    }
                } else {
                    this.npcForm.New_Part_ID__c = '';
                }
            }
        }
        
        // Getting the mask layers for the Fab into a list for display
        List<MESService.WEB_PART_PHOTO_STAGE_TYPE_TOUT_element> listMl = res.WEB_PART_PHOTO_STAGE_TYPE_TOUT;
        system.debug('listMasksLayers in populateMaskLayers =============> ' + listMl);
        
        if (listMl != null && this.maskLayerOptions != null && this.maskLayerOptions.size()==0) {
              
            
            // ZAmbat 01152014
            List<string> tempMaskList = new List<string>();
            for (MESService.WEB_PART_PHOTO_STAGE_TYPE_TOUT_element w : listMl) {
                if(w.LAYER_NO != null){
                    tempMaskList.add(w.LAYER_NO);
                }
            }
            
            this.maskLayerOptions.add(new SelectOption('', '--None--'));
            if (tempMaskList.size() > 0) {
                tempMaskList.sort();
                for (string s : tempMaskList) {
                    this.maskLayerOptions.add(new SelectOption(s, s));
                }
            }
        }                
        // Refresh table values
        retrieveMaskDetails();
    }    
    //end
    //Yathish St : To get past 3 years actual loading
    public void retrievePastYearActualLoading(String devId)
    {
        last3 = Integer.valueOf(Date.Today().Year()-3);
        last2 = Integer.valueOf(Date.Today().Year()-2);
        last1 = Integer.valueOf(Date.Today().Year()-1);
        next1 = Integer.valueOf(Date.Today().Year());
        next2 = Integer.valueOf(Date.Today().Year()+1);
        next3 = Integer.valueOf(Date.Today().Year()+2);
        
        
    }
    //Yathish End
    // ZAmbat 06102014
    public void retrieveAdditionalRecipients() {
        // Refresh values
        this.listUnselectedRecipients = new Set<User>();
        this.listSelectedRecipients = new Set<User>();
        this.unselectedRecipients = new List<string>();
        this.selectedRecipients = new List<string>();
        this.mapRecipients = new Map<Id, User>();
        
        // Get users within the Account Hierarchy
        if (this.npcForm.Account__c != null) {
            // Get Account Id
            Account a = [
                SELECT      Id
                            , ParentId
                FROM        Account
                WHERE       Id = :this.npcForm.Account__c
            ];
            
            // Get Accounts in the Account Hierarchy
            Set <Id> accountIds = new Set<Id>();
            if (a.ParentId != null) {
                for (Account_Hierarchy__c ah : [SELECT      Parent_Id__c
                                                FROM        Account_Hierarchy__c
                                                WHERE       Account_Id__c = :a.Id
                                                            AND Parent_Id__c != :a.Id]) { 
                    accountIds.add(ah.Parent_Id__c);
                }
            } 
               
            // Check for Devices below the Account Hierarchy
            for (Account_Hierarchy__c ah : [SELECT      Account_Id__c
                                            FROM        Account_Hierarchy__c
                                            WHERE       Parent_Id__c = :a.Id
                                                        AND Account_Id__c != :a.Id]) { 
                accountIds.add(ah.Account_Id__c);
            }
            
            // Add User's Account Id
            accountIds.add(a.Id);
            
            // Get contacts/users 
            for (User u : [SELECT       Id
                                        , Name
                                        , (SELECT Id FROM Portal_Tab_Access__r WHERE My_Devices__c = true AND New_Part_Creation_after_Proto_form__c = true)
                           FROM         User
                           WHERE        Contact.AccountId IN :accountIds
                                                        AND IsActive = true
                                        AND Id != :UserInfo.getUserId()]) {
                if (u.Portal_Tab_Access__r.size() > 0) {
                    this.listUnselectedRecipients.add(u);
                    this.mapRecipients.put(u.Id, u);
                }
            }
            
            // Edit mode
            if (this.isEdit) {
                if (this.npcForm.Additional_Recipient_1__c != null) {
                    this.unselectedRecipients.add(this.npcForm.Additional_Recipient_1__c);
                }
                
                if (this.npcForm.Additional_Recipient_2__c != null) {
                    this.unselectedRecipients.add(this.npcForm.Additional_Recipient_2__c);
                }
                
                if (this.npcForm.Additional_Recipient_3__c != null) {
                    this.unselectedRecipients.add(this.npcForm.Additional_Recipient_3__c);
                }
                
                if (this.npcForm.Additional_Recipient_4__c != null) {
                    this.unselectedRecipients.add(this.npcForm.Additional_Recipient_4__c);
                }
                
                if (this.npcForm.Additional_Recipient_5__c != null) {
                    this.unselectedRecipients.add(this.npcForm.Additional_Recipient_5__c);
                }

                if (this.unselectedRecipients.size() > 0) {
                    selectValues();
                }
            }
        }
    }
    
    public PageReference selectValues() {
        if ((this.unselectedRecipients.size() + this.listSelectedRecipients.size()) <= integer.valueOf(Environment_Variable__c.getInstance('NPC_ADDITIONAL_RECIPIENTS_MAX').Value__c)) {
            this.selectedRecipients.clear();
    
            for(String s : this.unselectedRecipients){
                this.listUnselectedRecipients.remove(this.mapRecipients.get(s));
                this.listSelectedRecipients.add(this.mapRecipients.get(s));
            }
        } else {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Error_Codes__c.getInstance('NPC_RECIPIENTS_MORE_THAN_MAX').Message__c));
        }
        
        return null;
    }
    
    public PageReference unselectValues() {
        this.unselectedRecipients.clear();

        for(String s : this.selectedRecipients){
            this.listSelectedRecipients.remove(this.mapRecipients.get(s));
            this.listUnselectedRecipients.add(this.mapRecipients.get(s));
        }

        return null;
    }
    
    public List<SelectOption> getUnselectedRecipientsList() {
        List<SelectOption> options = new List<SelectOption>();
        List<string> tempList = new List<String>();
        Map<string, User> tempMap = new Map<string, User>(); 
        for (User u : this.listUnselectedRecipients) {
            tempList.add(u.Name + '-' + u.Id);
            tempMap.put(u.Name + '-' + u.Id, u);
        }

        tempList.sort();
        for (string s : tempList) {
            options.add(new SelectOption(tempMap.get(s).Id, tempMap.get(s).Name));
        }
        
        return options;
    }
    
    public List<SelectOption> getSelectedRecipientsList() {
        List<SelectOption> options = new List<SelectOption>();
        List<string> tempList = new List<String>();
        Map<string, User> tempMap = new Map<string, User>(); 
        for (User u : this.listSelectedRecipients) {
            tempList.add(u.Name + '-' + u.Id);
            tempMap.put(u.Name + '-' + u.Id, u);
        }
        
        tempList.sort();
        for (string s : tempList) {
            options.add(new SelectOption(tempMap.get(s).Id, tempMap.get(s).Name));
        }
        
        return options;
    }
     public List<SelectOption> getFabList() {
        List<SelectOption> options = new List<SelectOption>();
        //options.add(new SelectOption('FAB 1', 'FAB 1', this.device.Fab__c == 'FAB 1' ? true : false));
        options.add(new SelectOption('', '--None--'));
        options.add(new SelectOption('FAB 2', 'FAB 2', this.device.Fab__c == 'FAB 2' ? true : false));
        options.add(new SelectOption('FAB 3', 'FAB 3', this.device.Fab__c == 'FAB 3' ? true : false));
        options.add(new SelectOption('FAB 3E', 'FAB 3E', this.device.Fab__c == 'FAB 3E' ? true : false));
        options.add(new SelectOption('FAB 5', 'FAB 5', this.device.Fab__c == 'FAB 5' ? true : false));
        options.add(new SelectOption('FAB 6', 'FAB 6', this.device.Fab__c == 'FAB 6' ? true : false));
        options.add(new SelectOption('FAB 7', 'FAB 7', this.device.Fab__c == 'FAB 7' ? true : false));
        //options.add(new SelectOption('FAB 8', 'FAB 8', this.device.Fab__c == 'FAB 8' ? true : false));
        //options.add(new SelectOption('FAB 9', 'FAB 9', this.device.Fab__c == 'FAB 9' ? true : false));
        
        return options;
     }
     
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
     public string getShowMaskDiv() {
         string showDiv = '';
         if (this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_FAB_TRANSFER').Value__c 
             || this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_CHANGE_PID').Value__c) {
             showDiv = 'display: none;';
         } 

         return showDiv;
     }
      public void updateAMDetails(){
    
             List<Account_Team_Proxy__c> tempListAccAM = [
                                            SELECT Id,
                                                    User__c,
                                                    user__r.Name,
                                                    Team_Role__c,
                                                    user__r.LastLoginDate 
                                            FROM Account_Team_Proxy__c 
                                            WHERE Account__c = :this.npcform.Account__c 

                                                    AND ( Team_Role__c =: EnvironmentVariable.get('OPPTY_PROG_TM_ROLE_PAM') OR Team_Role__c =: EnvironmentVariable.get('OPPTY_PROG_TM_ROLE_AM'))
                                                    AND User__r.IsActive = true 
                                            ORDER BY user__r.LastLoginDate   DESC ]; 
            
               if(tempListAccAM.size() > 0){
                  //this.npcForm.Primary_Device_AM__c = this.device.Primary_Device_AM__c;
                   for(Account_Team_Proxy__c atp :tempListAccAM){

                        if(atp.Team_Role__c == EnvironmentVariable.get('OPPTY_PROG_TM_ROLE_PAM')){
                            this.npcform.Primary_Device_AM__c  = tempListAccAM[0].User__c;
                            npcform.No_of_AM_Approvers__c = 1;                          
                        }
                        if(this.device.Primary_Device_AM__c != null && atp.Team_Role__c == EnvironmentVariable.get('OPPTY_PROG_TM_ROLE_AM') && tempListAccAM.size() >= 1){
                            this.npcform.Primary_Device_AM2__C  = tempListAccAM[0].User__c; npcform.No_of_AM_Approvers__c = 2;}


                        if(tempListAccAM.size() > 1 && atp.Team_Role__c == EnvironmentVariable.get('OPPTY_PROG_TM_ROLE_AM')){
                            this.npcform.Primary_Device_AM2__C  = tempListAccAM[1].User__c; npcform.No_of_AM_Approvers__c = 2;}                                           


                   }                       
             }
             
               
             
    }  
}