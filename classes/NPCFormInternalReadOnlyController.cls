/*
    Author: Zymark Ambat
    Description: This Class serves as the controller for the NPCFormInternalReadOnlyVF.
    History: 
        ZAmbat      12092013    - Code creation.
        ZAmbat      12182013    - Update code regarding NPC Form status after 2nd step rejection:  From no change in status ('In Execution') to 'Pending Resubmission'.
        ARoy        01102014    - Update code to customize the Approve/Reject link on the Approval History section.
        ARoy        01282014    - Updated code to sort the mask layers based on layer and Is Mask Modified to show the changed ones first. (Case : 00004630)
        ZAmbat      01282014    - Updated code as per CASE 4515.
        ARoy        02182014    - Updated code as per case 6925.
        ZAmbat      03032014    - Updated code to show field history tracking for NPC (CASE 7407).
        ARoy        03042014    - Updated for Approver Reassignment for NPC. (Case 00007578)
        ZAmbat      03252014    - Updated code as per Case 4882.
        ZAmbat      04032014    - Updated code as per CASE 7400.
        ZAmbat      04042014    - Updated code as per CASE 8489.
        ZAmbat      06062014    - Updated code as per CASE 8490.
        ZAmbat      07092014    - Updated code as per CASE 27667.
        DBiswal     11242014    - Updated code to allow GF System Admin to cancel NPC Form record.
        DBiswal     12012014    - Updated code to include clone.
        DBiswal     12152014    - Updated code for displaying buttons for FAE approval.
        DBiswal     01202015    - Updated code for New Reason for New Part field value. 
        Prashant    04232015    - Updated code for localtime capture as per timezone set in user in NPC history(Case #00040644 ).

        Sunil       04272015    - Updated code to add field PIYE_Approver_4__c for case # 40782   
        DBiswal     05042015    - Updated code to update NPC new part Id to 'VOID' if it is cancelled.
        DBiswal     05272015    - Updated code to remove sorting of Mask based on Layer.  
        SNune       20102015    - Updated code to fix case 40544.  
        KOKA GOPI   07042015    - Updated Automotive_Grade__c for readonly page  
        Prajnith    10102016    - Updated code for fixing Device reactivation.           
*/

public class NPCFormInternalReadOnlyController {
    public boolean showCancel {get;set;}
    public boolean showEdit {get;set;}
    public boolean showSubmit {get;set;}
    public boolean showLockIcon {get;set;}
    public string userProfileName {get;set;}
    public Device__c device {get;set;}    // Dipak 17112016
    public New_Part_Creation_Form__c npcForm {get;set;}
    public List<FieldHistoryWrapper> listHistory {get;set;}
    public List<FieldHistoryWrapper> listNPCHistory {get;set;}
    public List<Mask__c> listMasks {get;set;}
    public boolean showAppRejSection {get;set;}
    public boolean isLoggedinUserAssignee {get;set;}
    Public Integer last3 {get;set;}
    Public Integer last2 {get;set;}        
    Public Integer last1 {get;set;}
    Public Integer next3 {get;set;}
    Public Integer next2 {get;set;}
    Public Integer next1 {get;set;}   
    
    public NPCFormInternalReadOnlyController(ApexPages.StandardController controller) {
        // Init
        this.device = new Device__c();  // Dipak 17112016
        this.showCancel = false;
        this.showEdit = false;
        this.showSubmit = false;
        this.showLockIcon = false;
        this.listHistory = new List<FieldHistoryWrapper>();
        this.listNPCHistory = new List<FieldHistoryWrapper>();
        this.showAppRejSection = false;
        

    
        retrieveNPCDetails();     
        checkUserProfile();
        checkNPCFormStatus();
        retrieveFieldHistory();       
        retrieveMasks();
    }
    
    /* 
        Used this code to update Approvers to the designated User lookup fields for approval 
        and giving access to the Approve/Reject section.
    */
    public void init(){
        updateApprover();
        checkDisplayAppRejSection();
    }

    //Updated code by Sunil to add field PIYE_Approver_4__c for case # 40782
    public void retrieveNPCDetails() {
        this.npcForm = [
            SELECT      Id
                        , Name
                        , NPC_Device_Reactivation_Status__c   // Dipak 21112016
                        , PID_Status__c
                        , Process_ID__r.Name
                        , NRE_25K_USD_Is_Acknowledged_by_Customer__c
                        , NRE_Comments__c
                        , Risk_Waiver__c
                        , Originating_Device__r.Assigned_Process_Name__c
                        , Originating_Device__r.Assigned_Process_ID__r.Name
                        , Planned_Implementation_Date__c
                        , Actual_Implementation_Date__c
                        , Assignee_1__c
                        , Assignee_2__c
                        , Assignee_3__c
                        , Primary_Device_AM__c
                        , Primary_Device_AM2__c
                        , PI_YE_Approval_Status__c 
                        , Notification_Group__c
                        , Date_to_Ship_Reticle_to_Mask_Shop__c
                        , Min_Order_qty_agreement_with_customer__c
                        , Min_Order_qty_agreement_customer_Text__c
                        , Mask_Shop_Name__c
                        , Mask_Shop_Site__c
                        , Mask_Shop_Address__c
                        , PI_YE_Update_Status__c
                        , Is_reticle_available__c
                        , STF_Activation_Steps__c
                        , Litho_Status__c
                        , Litho_Validate_Reticle_is_in_GF__c
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
                        , Comments2__c            // Dipak 14112016
                        , RecordTypeId
                        , Account_Short_Name__c
                        , Automotive_Device__c
                        , Device_Mask_Set_Title__c
                        , NPC_Form_Status__c
                        , Account_Name__c
                        , BASE_Device__r.Name
                        , Owner__c
                        , NPC_Form_Submitted_Date__c
                        , CreatedById
                        , LastModifiedById
                        , Last_Sync_to_PLM_Status__c
                        , PLM_Sync_Status__c
                        , PLM_Error_Message__c
                        , CreatedDate
                        , LastModifiedDate
                        , Reason_for_editing__c
                        , Mask_Set_Title__c
                        , PIYE_Approver_1__c
                        , PIYE_Approver_2__c
                        , PIYE_Approver_3__c, PIYE_Approver_4__c
                        , Approver_1__c
                        , Approver_2__c
                        , Approver_3__c
                        , Approver_4__c
                        , Approver_5__c
                        , Approver_6__c
                        , Approver_7__c
                        , Approver_8__c
                        , Approver_9__c
                        , Approver_10__c
                        , BASE_Device__r.OwnerId
                        , Require_To_Create_The_New_Part__c
                        , New_Customer_Name__c
                        , Case__c
                        , New_Customer_Short_Name__c
                        , Current_Forecast_Tapeout_Date__c
                        , FAE_Approver_1__c
                        , FAE_Approver_2__c
                        , FAE_Approver_3__c
                        , New_Fab__c
                        , Action__c
                        , Automotive_Grade__c,Next_3_Years_1__c,Next_3_Years_2__c,Next_3_Years_3__c
                        ,Past_3_Years_1__c,Past_3_Years_2__c,Past_3_Years_3__c   
                        ,ECN_Change_Date__c                                              
            FROM        New_Part_Creation_Form__c
            WHERE       Id = :ApexPages.currentPage().getParameters().get('id')
        ];
       
        next1 = Integer.valueOf(NPCForm.CreatedDate.Year());
        next2 = next1+1;
        next3 = next1+2;
        last3 = next1-3;
        last2 = next1-2;
        last1 = next1-1;        
         
      
        
    }
    
    public void checkUserProfile() {
        // Check if User is GF CE
        User u = [
            SELECT      Profile.Name
            FROM        User
            WHERE       Id = :UserInfo.getUserId()
        ];
        
        this.userProfileName = u.Profile.Name;
        if(npcForm.Assignee_1__c == u.ID || npcForm.Assignee_2__c == u.ID){
            isLoggedinUserAssignee = true;
        }
        else
        {
            isLoggedinUserAssignee = false;
        }
    }
    
    public void checkNPCFormStatus() {
                
        if (this.npcForm.NPC_Form_Status__c == Environment_Variable__c.getInstance('NPC_STATUS_PEND_SUBMISSION').Value__c) {
            this.showEdit = true;
            this.showSubmit = true;
            
            //ZAmbat 06062014
            this.showCancel = true;  
        } else if (this.npcForm.NPC_Form_Status__c == Environment_Variable__c.getInstance('NPC_STATUS_SUBMITTED').Value__c) {
            if (this.userProfileName == Environment_Variable__c.getInstance('GF_CE').Value__c) {
                this.showEdit = true;
            }
            this.showLockIcon = true;
        }
        //DBiswal 12152014 - Display edit button
        else if (this.npcForm.NPC_Form_Status__c == EnvironmentVariable.get('NPC_STATUS_PEND_MASK_ADD_FE')) {
            this.showEdit = true;
        }
        //DBiswal 12182014 - Hide Submit for Approval button
         else if (this.npcForm.NPC_Form_Status__c == EnvironmentVariable.get('NPC_STATUS_PEND_PID_REASSIGN')
                  && (this.npcForm.Reason_for_New_Part__c == EnvironmentVariable.get('NPC_REASON_FAB_TRANSFER')
                      || this.npcForm.Reason_for_New_Part__c == EnvironmentVariable.get('NPC_REASON_CHANGE_PID'))) {
            this.showLockIcon = true;
            this.showSubmit = false;
        }            
       
         else if (this.npcForm.NPC_Form_Status__c == Environment_Variable__c.getInstance('NPC_STATUS_PEND_RESUB').Value__c) {
            // Check if record is rejected
            List<RecordType> listRT = [
                SELECT      Id
                            , Name
                FROM        RecordType
                WHERE       Id = :this.npcForm.RecordTypeId
            ];
            
            if (listRT.size() > 0) {
                if (listRT[0].Name == 'StatusRejected') {
                    this.showCancel = true; 
                } 
            }
            
            this.showEdit = true;
            this.showSubmit = true;
        } else {
            this.showLockIcon = true;
        }
        if(userProfileName.contains('Litho') && this.npcForm.Reason_for_New_Part__c == EnvironmentVariable.get('NPC_REASON_STF')){
            this.showEdit = this.showSubmit = this.showCancel = false;                      
        }
    }
    
    public PageReference editNPC() {
        PageReference pageRef;
        //Yathish St did some modification to add device Id to URL
        if (this.npcForm.NPC_Form_Status__c == Environment_Variable__c.getInstance('NPC_STATUS_SUBMITTED').Value__c && this.userProfileName == Environment_Variable__c.getInstance('GF_CE').Value__c) {
            pageRef = new PageReference('/apex/NPCFormVF?id=' + this.npcForm.Id + '&gfce=1' +'&deviceId='+this.npcForm.Originating_Device__c);
        } else {
            pageRef = new PageReference('/apex/NPCFormVF?id=' + this.npcForm.Id +'&deviceId='+this.npcForm.Originating_Device__c);
        }
        pageRef.setRedirect(true);
        //Yathish end
        return pageRef;
    }
    
    public PageReference submitNPC() {
       
        PageReference pageRef = new PageReference('/apex/NPCFormApproval?id=' + this.npcForm.Id);
        pageRef.setRedirect(true);
        
        return pageRef;
    }
    
    public PageReference cancelNPC() {
        PageReference pageRef;
        
        //11242014 DBiswal - Added condition for GF System Admin
        if (UserInfo.getUserId() == this.npcForm.Owner__c || this.userProfileName == 'GF System Admin' || this.userProfileName == 'System Administrator') {
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
                if (this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_RETROFIT').Value__c
                        || this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_RETROFIT_ADD_ROM').Value__c
                        || this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_PROBE_NEW_CARD').Value__c
                        || this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_FAB_TRANSFER').Value__c
                        || this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_CHANGE_PID').Value__c
                        || this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_STARTINGMATERIAL').Value__c    //DBiswal 01202015
                        || this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_BACKGROUNDTHICKNESS').Value__c    //DBiswal 01202015
                        || this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_SHORTLOOP_FLOW').Value__c
                        || (this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_OTHERS').Value__c && this.npcForm.Require_To_Create_The_New_Part__c == Environment_Variable__c.getInstance('NPC_REQUIRE_TO_CREATE_YES').Value__c)) {
                    this.npcForm.Device_Status__c = Environment_Variable__c.getInstance('NPC_STATUS_VOID').Value__c;
                }
                this.npcForm.RecordTypeId = rt.Id;
                //DBiswal 05042015
                this.npcForm.New_Part_ID__c = Environment_Variable__c.getInstance('NPC_STATUS_VOID').Value__c.toUpperCase() + '-' + this.npcForm.New_Part_ID__c; 
                update this.npcForm;
                
                // Update device status to 'Void'
                // Update device name to 'Void-<NPC Name>'
                // ZAmbat 03252014
                
                if (this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_RETROFIT').Value__c
                        || this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_RETROFIT_ADD_ROM').Value__c
                        || this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_PROBE_NEW_CARD').Value__c
                        || this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_FAB_TRANSFER').Value__c
                        || this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_CHANGE_PID').Value__c
                        || this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_STARTINGMATERIAL').Value__c    //DBiswal 01202015
                        || this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_BACKGROUNDTHICKNESS').Value__c    //DBiswal 01202015
                        || this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_SHORTLOOP_FLOW').Value__c
                        || (this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_OTHERS').Value__c && this.npcForm.Require_To_Create_The_New_Part__c == Environment_Variable__c.getInstance('NPC_REQUIRE_TO_CREATE_YES').Value__c)) {
                    List<Device__c> listDevice = [
                        SELECT      Id
                                    , Name
                                    , Assigned_Process_Name__c
                                    , Assigned_Process_ID__r.Name  // Dipak 17112016
                                    , Status__c
                                    , Stage__c
                        FROM        Device__c
                        WHERE       NPC_Form__c = :this.npcForm.Id
                                    AND Tapeout_Type__c = :Environment_Variable__c.getInstance('DEVICE_TAPEOUT_TYPE_RETROFIT').Value__c
                    ];
                    
                    if (listDevice.size() > 0) {
                        Device__c device = listDevice[0];
                        //DBiswal 05072015
                        if(device.Stage__c == Environment_Variable__c.getInstance('DEVICE_STAGE_TAPEOUT').Value__c){
                            device.Stage__c = Environment_Variable__c.getInstance('DEVICE_STAGE_DESIGNIN').Value__c;
                            update device;
                            
                            device.Name = Environment_Variable__c.getInstance('DEVICE_STAGE_VOID').Value__c + '-' + this.npcForm.Name; 
                            update device;
                            
                            device.Status__c = Environment_Variable__c.getInstance('DEVICE_STAGE_VOID').Value__c;
                            update device;
                        } else {
                            device.Name = Environment_Variable__c.getInstance('DEVICE_STAGE_VOID').Value__c + '-' + this.npcForm.Name; 
                            update device;
                        
                            device.Status__c = Environment_Variable__c.getInstance('DEVICE_STAGE_VOID').Value__c;
                            update device;
                        }
                    }
                }
                
                pageRef = new PageReference('/apex/NPCFormInternalReadOnlyVF?id=' + this.npcForm.Id);
                pageRef.setRedirect(true);
            } catch (Exception e) {
                ApexPages.addmessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Error: ' + e.getMessage()));  
            }
        } else {
            ApexPages.addmessage(new ApexPages.Message(ApexPages.severity.ERROR, Environment_Variable__c.getInstance('NPC_CANCEL_VALIDATION').Value__c));
        }
        
        return pageRef;
    }
    
        //12012014 DBiswal - Clone the NPC Form record
    public PageReference cloneNPC(){
        PageReference pageRef = new PageReference('/apex/NPCFormVF?id=' + this.npcForm.Id);
        pageRef.getParameters().put('clone','1');
        
        pageRef.setRedirect(true);        
        return pageRef;
    }
    
    public PageReference apprRej()
    {      
                               
           if(this.npcForm.Reason_for_New_Part__c == EnvironmentVariable.get('NPC_REASON_STF')
              && this.npcForm.STF_Activation_Steps__c != 'Step 1'
              && this.npcForm.NPC_Form_Status__c != Environment_Variable__c.getInstance('NPC_STATUS_IN_EXEC').Value__c
              && (this.npcForm.Is_reticle_available__c == EnvironmentVariable.get('NPC_STF_Reticle_GF'))){     
               return returnURL(npcForm.Id,'NPCLithoFormValidation');    
         }
         else if(this.npcForm.Reason_for_New_Part__c == EnvironmentVariable.get('NPC_REASON_STF')
              && this.npcForm.STF_Activation_Steps__c == 'Step 2'
              && this.npcForm.NPC_Form_Status__c != Environment_Variable__c.getInstance('NPC_STATUS_IN_EXEC').Value__c
              && (this.npcForm.Is_reticle_available__c == EnvironmentVariable.get('NPC_STF_Reticle_Customer'))){                  
                    return returnURL(npcForm.Id,'NPCLithoFormValidation');              
         }                  
         else if(this.npcForm.Reason_for_New_Part__c == EnvironmentVariable.get('NPC_REASON_STF')
           && this.npcForm.NPC_Form_Status__c == Environment_Variable__c.getInstance('NPC_STATUS_IN_EXEC').Value__c
           && this.npcForm.PI_YE_Update_Status__c != 'Status 1'){    
             if(npcForm.Is_reticle_available__c == 'Yes,at GF' && npcForm.NPC_Form_Status__c == 'In Execution' &&  (npcForm.Assignee_1__c != null ||npcForm.Assignee_2__c != null)){                                      
                return returnURL(npcForm.Id,'NPCPIYUpdate');                 
             }
             else if(npcForm.Is_reticle_available__c == EnvironmentVariable.get('NPC_STF_Reticle_Customer')  && npcForm.NPC_Form_Status__c == 'In Execution' &&  (npcForm.Assignee_1__c != null ||npcForm.Assignee_2__c != null))
             {
                 if(npcForm.Planned_Implementation_Date__c == null){
                    return returnURL(npcForm.Id,'NPCPIYUpdate'); 
                 }
                 if(npcForm.Planned_Implementation_Date__c != null  && npcForm.Mask_Shop_Address__c == null){
                        return returnURL(npcForm.Id,'NPCMaskReticleShopInfo'); 
                 }
                  if(npcForm.Planned_Implementation_Date__c != null  && npcForm.Mask_Shop_Address__c != null && npcForm.Actual_Implementation_Date__c == null){
                        return returnURL(npcForm.Id,'NPCPIYUpdate'); 
                 }                                                                                          
             }
                return returnURL(npcForm.Id,'NPCPIYApproval'); 
              
         }
      // Added by Dipak 24102016 Start   
     else if(this.npcForm.Reason_for_New_Part__c == EnvironmentVariable.get('NPC_REASON_STF')
          && this.npcForm.NPC_Form_Status__c == Environment_Variable__c.getInstance('NPC_STATUS_IN_EXEC').Value__c
          && this.npcForm.PI_YE_Update_Status__c == 'Status 1'){    
                  return returnURL(npcForm.Id,'NPCPIYUpdate'); 
               
         }
         // Added by Dipak 24102016 End
         // Added by Dipak 04102016 End
         else{
             return returnURL(npcForm.Id,'NPCFormMultiApproval');         
        }
    }
  
    public void checkDisplayAppRejSection(){                
        if(this.npcForm.NPC_Form_Status__c == Environment_Variable__c.getInstance('NPC_STATUS_SUBMITTED').Value__c
            && (this.npcForm.Approver_1__c == UserInfo.getUserId()
            || this.npcForm.Approver_2__c == UserInfo.getUserId()
            || this.npcForm.Approver_3__c == UserInfo.getUserId()
            || this.npcForm.Approver_4__c == UserInfo.getUserId()
            || this.npcForm.Approver_5__c == UserInfo.getUserId()
            || this.npcForm.Approver_6__c == UserInfo.getUserId()
            || this.npcForm.Approver_7__c == UserInfo.getUserId()
            || this.npcForm.Approver_8__c == UserInfo.getUserId()
            || this.npcForm.Approver_9__c == UserInfo.getUserId()
            || this.npcForm.Approver_10__c == UserInfo.getUserId())){
            this.showAppRejSection = true;    
        }      
        //Updated code by Sunil to add field PIYE_Approver_4__c for case # 40782
        // SNune        20102015    - Updated code to fix case 40544   
        if(this.npcForm.NPC_Form_Status__c == Environment_Variable__c.getInstance('NPC_STATUS_IN_EXEC').Value__c
            && ((this.npcForm.PIYE_Approver_1__c == UserInfo.getUserId()
            || this.npcForm.PIYE_Approver_2__c == UserInfo.getUserId()
            || this.npcForm.PIYE_Approver_3__c == UserInfo.getUserId() || this.npcForm.PIYE_Approver_4__c == UserInfo.getUserId()) && (!(Environment_Variable__c.getInstance('NPC_FAB_LIST').Value__c).contains(this.npcForm.Fab__c) || this.npcForm.Reason_for_New_Part__c == EnvironmentVariable.get('NPC_REASON_FAB_TRANSFER')))){
                
            this.showAppRejSection = true; 
        }
        
        //DBiswal 12152014 - To display Approve/Reject section for FAE Approval
        if(this.npcForm.NPC_Form_Status__c == EnvironmentVariable.get('NPC_STATUS_PEND_MASK_ADD_FE')
            && this.npcForm.Reason_for_New_Part__c == 'New Probe Card Flow'
            && (this.npcForm.FAE_Approver_1__c == UserInfo.getUserId()
            || this.npcForm.FAE_Approver_2__c == UserInfo.getUserId()
            || this.npcForm.FAE_Approver_3__c == UserInfo.getUserId())){
            this.showAppRejSection = true; 
        }

        //DBiswal 12182014 - To hide Approve/Reject section for fab to fab transfer
        if(this.npcForm.NPC_Form_Status__c == EnvironmentVariable.get('NPC_STATUS_PEND_PID_REASSIGN') 
            && (this.npcForm.Reason_for_New_Part__c == EnvironmentVariable.get('NPC_REASON_FAB_TRANSFER')
                || this.npcForm.Reason_for_New_Part__c == EnvironmentVariable.get('NPC_REASON_CHANGE_PID'))){
            this.showAppRejSection = false; 
        }
                        
        if(this.npcForm.NPC_Form_Status__c == Environment_Variable__c.getInstance('NPC_STATUS_IN_EXEC').Value__c            
            && (Environment_Variable__c.getInstance('NPC_FAB_LIST').Value__c).contains(this.npcForm.Fab__c)){
            String[] npcFabApprovers = Environment_Variable__c.getInstance('Fab235Approvers').Value__c.split(',');
            for(String npcFabApp : npcFabApprovers){
                if(UserInfo.getUserId().contains(npcFabApp)){
                    this.showAppRejSection = true;
                    break;
                }
            }           
        }
                
        if((this.npcForm.NPC_Form_Status__c == Environment_Variable__c.getInstance('NPC_STATUS_SUBMITTED').Value__c
           ||this.npcForm.NPC_Form_Status__c == Environment_Variable__c.getInstance('NPC_STATUS_IN_EXEC').Value__c)
           ||this.npcForm.NPC_Form_Status__c == EnvironmentVariable.get('NPC_STATUS_PEND_MASK_ADD_FE')
           &&this.showAppRejSection==false){
           User objUsr = [Select Id,profile.name from User where id = :UserInfo.getUserId()];
           if(objUsr.profile.name == Environment_Variable__c.getInstance('SYS_ADMIN').Value__c ||objUsr.profile.name == Environment_Variable__c.getInstance('GF_INTEGRATION').Value__c ||objUsr.profile.name == Environment_Variable__c.getInstance('GF_SYSTEM_ADMIN').Value__c ||objUsr.profile.name == Environment_Variable__c.getInstance('GF_GLOBAL_ADMIN').Value__c ||objUsr.profile.name == Environment_Variable__c.getInstance('CTS_DEVELOPER').Value__c ||objUsr.profile.name == Environment_Variable__c.getInstance('GF_DEVELOPER').Value__c){ this.showAppRejSection = true;}}
        //Yathish St - to avoid displaying Approve/Reject Button 
        if (this.npcForm.NPC_Form_Status__c != Environment_Variable__c.getInstance('NPC_STATUS_PEND_RESUB').Value__c 
        && this.npcForm.NPC_Form_Status__c != Environment_Variable__c.getInstance('NPC_STATUS_PEND_SUBMISSION').Value__c             
        && this.npcForm.Reason_for_New_Part__c == EnvironmentVariable.get('NPC_REASON_STF')) {
           //Yathish Logic goes here
           User objUsr = [Select Id,profile.name from User where id = :UserInfo.getUserId()];
           if(this.npcForm.NPC_Form_Status__c == 'Pending Litho Verification' && (this.npcForm.Assignee_1__c == UserInfo.getUserId() || this.npcForm.Assignee_2__c == UserInfo.getUserId()  || this.npcForm.Assignee_3__c == UserInfo.getUserId())){ this.showAppRejSection = true; }
           else if(this.npcForm.NPC_Form_Status__c == 'Pending AM Approval' &&  (this.npcForm.Primary_Device_AM__c == UserInfo.getUserId() || this.npcForm.Primary_Device_AM2__c == UserInfo.getUserId() )){ this.showAppRejSection = true;}
           else if(this.npcForm.NPC_Form_Status__c == Environment_Variable__c.getInstance('NPC_STATUS_SUBMITTED').Value__c  && (this.npcForm.Approver_1__c == UserInfo.getUserId() || this.npcForm.Approver_2__c == UserInfo.getUserId() || this.npcForm.Approver_3__c == UserInfo.getUserId()|| this.npcForm.Approver_4__c == UserInfo.getUserId()|| this.npcForm.Approver_5__c == UserInfo.getUserId()|| this.npcForm.Approver_6__c == UserInfo.getUserId()|| this.npcForm.Approver_7__c == UserInfo.getUserId()|| this.npcForm.Approver_8__c == UserInfo.getUserId()|| this.npcForm.Approver_9__c == UserInfo.getUserId()|| this.npcForm.Approver_10__c == UserInfo.getUserId())){this.showAppRejSection = true;}
           else if(this.npcForm.NPC_Form_Status__c == Environment_Variable__c.getInstance('NPC_STATUS_IN_EXEC').Value__c && ((this.npcForm.PIYE_Approver_1__c == UserInfo.getUserId() || this.npcForm.PIYE_Approver_2__c == UserInfo.getUserId() || this.npcForm.PIYE_Approver_3__c == UserInfo.getUserId() || this.npcForm.PIYE_Approver_4__c == UserInfo.getUserId()))){ this.showAppRejSection = true;}
           else if(this.npcForm.NPC_Form_Status__c == Environment_Variable__c.getInstance('NPC_STATUS_IN_EXEC').Value__c && this.npcForm.PI_YE_Approval_Status__c == 'Status 1' && (this.npcForm.Assignee_1__c == UserInfo.getUserId()  || this.npcForm.Assignee_2__c == UserInfo.getUserId())){ this.showAppRejSection = true; }
           else if(this.npcForm.NPC_Form_Status__c == Environment_Variable__c.getInstance('NPC_STATUS_IN_EXEC').Value__c && this.npcForm.PI_YE_Approval_Status__c == 'Status 1' && (this.npcForm.Approver_1__c == UserInfo.getUserId()  || this.npcForm.Approver_2__c== UserInfo.getUserId())){ this.showAppRejSection = true;}
           else if(objUsr.profile.name == Environment_Variable__c.getInstance('SYS_ADMIN').Value__c ||objUsr.profile.name == Environment_Variable__c.getInstance('GF_INTEGRATION').Value__c ||objUsr.profile.name == Environment_Variable__c.getInstance('GF_SYSTEM_ADMIN').Value__c ||objUsr.profile.name == Environment_Variable__c.getInstance('GF_GLOBAL_ADMIN').Value__c ||objUsr.profile.name == Environment_Variable__c.getInstance('CTS_DEVELOPER').Value__c ||objUsr.profile.name == Environment_Variable__c.getInstance('GF_DEVELOPER').Value__c){             this.showAppRejSection = true;}
           else{this.showAppRejSection = false;}            
        }
        if(this.npcForm.NPC_Form_Status__c == Environment_Variable__c.getInstance('NPC_STATUS_PEND_RESUB').Value__c){ this.showAppRejSection = false;}
        //Yathish End
    }
    
    public void retrieveFieldHistory() {
        this.listHistory = new List<FieldHistoryWrapper>();
        
        // Get Mask Field History
        Set<Id> maskIds = new Set<Id>();
        for (Mask__c m : [SELECT        Id
                          FROM          Mask__c
                          WHERE         New_Part_Creation_Form__c = :this.npcForm.Id]) { 
            maskIds.add(m.Id);
        }
        
        for (Mask__History h : [SELECT      Id
                                            , Field
                                            , OldValue
                                            , NewValue
                                            , CreatedDate
                                            , CreatedById 
                                            , CreatedBy.Name
                                FROM        Mask__History
                                WHERE       ParentId IN :maskIds
                                            AND Field = 'Modified_Mask__c'
                                ORDER BY    CreatedDate DESC
                                LIMIT 50]) {
            FieldHistoryWrapper fhw = new FieldHistoryWrapper();
            fhw.id = h.Id;
            //fhw.dateUpdated = h.CreatedDate;
            //Prashant
            TimeZone tz = UserInfo.getTimeZone();
            DateTime localTime = h.CreatedDate.AddSeconds(tz.getOffset(h.CreatedDate)/1000);
            fhw.dateUpdated =localTime ;
            //--------
            fhw.userId = h.CreatedById;
            fhw.userName = h.CreatedBy.Name;
            fhw.description = 'Changed <b>Modified Mask</b> from ' + h.OldValue + ' to <b>' + h.NewValue + '</b>.';
            this.listHistory.add(fhw);
        }
        
        // ZAmbat 03032014
        this.listNPCHistory = new List<FieldHistoryWrapper>();
        Map<string, string> mapLabels = new Map<string, string>();
        mapLabels.put('Automotive_Device__c', Schema.New_Part_Creation_Form__c.fields.Automotive_Device__c.getDescribe().getLabel());
        mapLabels.put('Mask_Set_Title__c', Schema.New_Part_Creation_Form__c.fields.Mask_Set_Title__c.getDescribe().getLabel());
        mapLabels.put('Secure_Device__c', Schema.New_Part_Creation_Form__c.fields.Secure_Device__c.getDescribe().getLabel());
        mapLabels.put('Current_Forecast_Tapeout_Date__c', Schema.New_Part_Creation_Form__c.fields.Current_Forecast_Tapeout_Date__c.getDescribe().getLabel());
        
        // Get NPC Field History
        for (New_Part_Creation_Form__History h : [SELECT      Id
                                                              , Field
                                                              , OldValue
                                                              , NewValue
                                                              , CreatedDate
                                                              , CreatedById 
                                                              , CreatedBy.Name
                                                  FROM        New_Part_Creation_Form__History
                                                  WHERE       ParentId = :this.npcForm.Id
                                                              AND Field IN ('Automotive_Device__c', 'Mask_Set_Title__c', 'Secure_Device__c', 'Current_Forecast_Tapeout_Date__c')
                                                  ORDER BY    CreatedDate DESC
                                                  LIMIT 50]) {
            FieldHistoryWrapper fhw = new FieldHistoryWrapper();
            fhw.id = h.Id;
            //fhw.dateUpdated = h.CreatedDate;
            //Prashant
             TimeZone tz = UserInfo.getTimeZone();
            DateTime localTime = h.CreatedDate.AddSeconds(tz.getOffset(h.CreatedDate)/1000);
            fhw.dateUpdated =localTime ;
            //--------
            fhw.userId = h.CreatedById;
            fhw.userName = h.CreatedBy.Name;
            if (h.Field == 'Current_Forecast_Tapeout_Date__c') {
                Date dOldValue;
                Date dNewValue;
                
                if (h.OldValue != null) {
                    DateTime dtOldValue = DateTime.valueOf(string.valueOf(h.OldValue));
                    dOldValue = date.newInstance(dtOldValue.year(), dtOldValue.month(), dtOldValue.day());
                }
                    
                if (h.NewValue != null) {
                    DateTime dtNewValue = DateTime.valueOf(string.valueOf(h.NewValue));
                    dNewValue = date.newInstance(dtNewValue.year(), dtNewValue.month(), dtNewValue.day());
                }
                
                if (h.OldValue != null && h.NewValue != null) {
                    fhw.description = 'Changed <b>' + mapLabels.get(h.Field) + '</b> from ' + dOldValue.format() + ' to <b>' + dNewValue.format() + '</b>.';
                } else if (h.OldValue == null && h.NewValue != null) {
                    fhw.description = 'Changed <b>' + mapLabels.get(h.Field) + '</b> from ' + h.OldValue + ' to <b>' + dNewValue.format() + '</b>.';
                } else if (h.OldValue != null && h.NewValue == null) {
                    fhw.description = 'Changed <b>' + mapLabels.get(h.Field) + '</b> from ' + dOldValue.format() + ' to <b>' + h.NewValue + '</b>.';
                }
            } else {
                fhw.description = 'Changed <b>' + mapLabels.get(h.Field) + '</b> from ' + h.OldValue + ' to <b>' + h.NewValue + '</b>.';
            }
            this.listNPCHistory.add(fhw);
        }
    }
    
    public void retrieveMasks(){
        this.listMasks = new List<Mask__c>();
        
        //DBiswal 05272015
        //Get Masks Based on modified masks at top of the list with additional sorting by layer.
        this.listMasks = [
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
        
    }
    
    // Added for Approver Reassignment
    public void updateApprover(){       
        List<Id> approverIds = new List<Id>();
        boolean isUpdateCheck=false;
        Map<String,String> approversMapHistory = new Map<String,String>(); 
        Integer countApprover = 0;
        String usrId='';
        for(ProcessInstanceStep processInsStep : [
                                                        SELECT      ProcessInstance.Status, 
                                                                    ProcessInstance.TargetObjectId,
                                                                    ProcessInstanceId,
                                                                    OriginalActorId,
                                                                    OriginalActor.Name,
                                                                    Id,
                                                                    ActorId,
                                                                    Actor.Name,
                                                                    Actor.Type,
                                                                    CreatedDate,
                                                                    StepStatus
                                                        FROM        ProcessInstanceStep
                                                        WHERE       ProcessInstance.TargetObjectId = :npcForm.Id
                                                        AND         ProcessInstance.Status = 'Pending'
                                                        AND         StepStatus = 'Reassigned'
                                                        ORDER BY    Createddate DESC
                                                    ]){
            if(countApprover == 1){
                approversMapHistory.put(processInsStep.OriginalActorId,processInsStep.ActorId);                
            }
            countApprover++;
        }
        
        for(ProcessInstanceWorkitem p :[
                                            SELECT  ProcessInstance.Status, 
                                                    ProcessInstance.TargetObjectId,
                                                    ProcessInstanceId,
                                                    OriginalActorId,
                                                    Id,
                                                    ActorId,
                                                    Actor.Name,
                                                    Actor.Type 
                                            FROM    ProcessInstanceWorkitem
                                            WHERE   ProcessInstance.TargetObjectId = :npcForm.Id
                                            AND     ProcessInstance.Status = 'Pending'
                                        ]){
            
            if(p.OriginalActorId != p.ActorId && p.Actor.Type == 'User'){               
                String curApprover = approversMapHistory.get(p.OriginalActorId)!=null?approversMapHistory.get(p.OriginalActorId):p.OriginalActorId;
                if(npcForm.NPC_Form_Status__c == Environment_Variable__c.getInstance('NPC_STATUS_SUBMITTED').Value__c){                 
                    if(npcForm.Approver_1__c == curApprover){
                        npcForm.Approver_1__c = p.ActorId;
                        usrId = p.ActorId;
                        isUpdateCheck=true;
                        break;
                    }else if(npcForm.Approver_2__c == curApprover){
                        npcForm.Approver_2__c = p.ActorId;
                        usrId = p.ActorId;
                        isUpdateCheck=true;
                        break;
                    }else if(npcForm.Approver_3__c == curApprover){
                        npcForm.Approver_3__c = p.ActorId;
                        usrId = p.ActorId;
                        isUpdateCheck=true;
                        break;
                    }else if(npcForm.Approver_4__c == curApprover){
                        npcForm.Approver_4__c = p.ActorId;
                        usrId = p.ActorId;
                        isUpdateCheck=true;
                        break;
                    }else if(npcForm.Approver_5__c == curApprover){
                        npcForm.Approver_5__c = p.ActorId;
                        usrId = p.ActorId;
                        isUpdateCheck=true;
                        break;
                    }else if(npcForm.Approver_6__c == curApprover){
                        npcForm.Approver_6__c = p.ActorId;
                        usrId = p.ActorId;
                        isUpdateCheck=true;
                        break;
                    }else if(npcForm.Approver_7__c == curApprover){
                        npcForm.Approver_7__c = p.ActorId;
                        usrId = p.ActorId;
                        isUpdateCheck=true;
                        break;
                    }else if(npcForm.Approver_8__c == curApprover){
                        npcForm.Approver_8__c = p.ActorId;
                        usrId = p.ActorId;
                        isUpdateCheck=true;
                        break;
                    }else if(npcForm.Approver_9__c == curApprover){
                        npcForm.Approver_9__c = p.ActorId;
                        usrId = p.ActorId;
                        isUpdateCheck=true;
                        break;
                    }else if(npcForm.Approver_10__c == curApprover){
                        npcForm.Approver_10__c = p.ActorId;
                        usrId = p.ActorId;
                        isUpdateCheck=true;
                        break;
                    }
                }
                
                // If the reassigned approver is within the PIYE approvers and assign the corresponding approver with the reassigned approver
                //Updated code by Sunil to add field PIYE_Approver_4__c for case # 40782
                if(npcForm.NPC_Form_Status__c == Environment_Variable__c.getInstance('NPC_STATUS_IN_EXEC').Value__c){
                    if(npcForm.PIYE_Approver_1__c == curApprover){                        
                        npcForm.PIYE_Approver_1__c = p.ActorId;
                        usrId = p.ActorId;
                        isUpdateCheck=true;
                        break;
                    }else if(npcForm.PIYE_Approver_2__c == curApprover){
                        npcForm.PIYE_Approver_2__c = p.ActorId;
                        usrId = p.ActorId;
                        isUpdateCheck=true;
                        break;
                    }else if(npcForm.PIYE_Approver_3__c == curApprover){
                        npcForm.PIYE_Approver_3__c = p.ActorId;
                        usrId = p.ActorId;
                        isUpdateCheck=true;
                        break;
                    }else if(npcForm.PIYE_Approver_4__c == curApprover){
                        npcForm.PIYE_Approver_4__c = p.ActorId;
                        usrId = p.ActorId;
                        isUpdateCheck=true;
                        break;
                    }
                }                               
            }
        }
        
        if(isUpdateCheck){
            update npcForm;
            if(usrId != ''){
                addToDeviceShare(usrId, npcForm);
            }
        }
                
    }
    
    // Add users to the Device Share
    private void addToDeviceShare(String usrId, New_Part_Creation_Form__c npcForm){            
        if(usrId != npcForm.BASE_Device__r.OwnerId){
            Device__Share ds = new Device__Share();
            ds.AccessLevel = 'Edit';
            ds.RowCause = Schema.Device__Share.RowCause.NPC_Approver__c;
            ds.ParentId = npcForm.BASE_Device__c;
            ds.UserOrGroupId = usrId;
            insert ds;
        }
    } 
    
    public class FieldHistoryWrapper {
        public string id {get;set;}
        public datetime dateUpdated {get;set;}
        public string userId {get;set;}
        public string userName {get;set;}
        public string description {get;set;}
        
        public FieldHistoryWrapper(){}
    }
   // Dipak 26102016 Start 
    public class EmailComponents {
        
        public List<String> notifgrpEmail;   // Dipak 25102016
        public New_Part_Creation_Form__c currRec;
        
        public EmailComponents(New_Part_Creation_Form__c currRec){
                
            this.currRec = currRec; 
            this.notifgrpEmail = new List<String>();    // Dipak 25102016

            if (currRec.Notification_Group__c != null) {               // Dipak 25102016                     
                this.notifgrpEmail.add(currRec.Notification_Group__c);  // Dipak 25102016
            }
        }
       } 
         // Dipak 26102016 End
     public  PageReference returnURL (ID recordID,String pageName)
     {
             PageReference pgref = new PageReference('/apex/'+pageName);
                    pgref.getParameters().put('id',recordID);
                    pgref.setRedirect(true);
                    return pgref;
                    
     }    
}