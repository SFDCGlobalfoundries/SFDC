/*
    Author: Zymark Ambat
    Description: This serves as the test class for the DeviceCopyController Class.
    History: 
        ZAmbat      07232013    - Code creation.
        ZAmbat      10032013    - updated code as per TASK-348.
        ARoy        10112013    - Modified to make it work in customer portal.
        ZAmbat      11132013    - Added Fab Filter as part of the NPC Enhancements (CE approvers should be based on the device fab).
        ZAmbat      11262013    - Updated code to check for Device Sharing and for Portal User navigation.
        ZAmbat      12052013    - Updated code to remove Comments/Additional Remarks and Attachment validation as per TASK-663.
        ZAmbat      01152014    - Updated code to add error handling on NPC Form submission.
        ARoy        01292014    - Updated the code to add NPC Form Submitter in case its submitted by Customer Portal User.
        ZAmbat      12032014    - Updated code to fix issue where NPC Forms submitted for FAB 3 CEs go to FAB 3E CEs.
        DBiswal     12152014    - Updated code to add FAE Approval when Reason for New Part is ''.  
        Vijay       03112015    - updated code to support the Internal Device NPC Form Approval functionality. 
        DBiswal     03232015    - Updated code to validate mask layers for NPCs with New Probe Card Flow and ShortLoop Flow. 
        Prajnith    10102016    - Updated code for fixing Device reactivation.                    
*/

public class NPCFormApprovalProcessController {
    
    private string recId {get;set;}
    private string portal {get;set;}
    private string shareDevice {get;set;}

    public NPCFormApprovalProcessController(){
        this.recId = ApexPages.currentPage().getParameters().get('id');
        this.portal = ApexPages.currentPage().getParameters().get('portal');
        this.shareDevice = ApexPages.currentPage().getParameters().get('share');
    }
    
    public PageReference submitNPCForm() {      
        String id = this.recId;
        system.debug('id ====================> ' + id);     
        List<GroupMember> lstgMembers = new List<GroupMember>();
        string returnMessage = '';
        
        // Retrieve NPC Information
        //DBiswal - Added more fields to query for FAE Approval        
        New_Part_Creation_Form__c npcForm = [
            SELECT      Id
                        , BASE_Device__c
                        , Litho_Status__c
                        , Is_reticle_available__c
                        , Notification_Group__c
                        , NRE_25K_USD__c
                        , Risk_Waiver__c
                        , Min_Order_qty_agreement_with_customer__c
                        , Min_Order_Create__c
                        , No_of_Approvers__c
                        , No_of_FAE_Approvers__c
                        , New_Part_ID__c
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
                        , FAE_Approver_1__c
                        , FAE_Approver_2__c
                        , FAE_Approver_3__c                        
                        , NPC_Form_Status__c
                        , Comments__c
                        , Comments2__c              // Dipak 15112016
                        , NPC_Form_Submitter__c
                        , Reason_for_New_Part__c 
                        , Originating_Device__c
                        , BASE_Device__r.RecordType.DeveloperName
                        , (SELECT Layer__c,New_Part_Creation_Form__c from Masks__r)                       
            FROM        New_Part_Creation_Form__c
            WHERE       Id = :id
        ];               
        
        //DBiswal 12152014 - Check the profile of User
        Id profileId = userinfo.getProfileId();
        String profileName = [Select Id,Name from Profile where Id=:profileId].Name;
        //DBiswal 03232015 - For Mask layer validation
        Boolean maskCheck = false;
        if(profileName == 'GF FAE/FTS'){
            if((npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_PROBE_NEW_CARD').Value__c 
                || npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_SHORTLOOP_FLOW').Value__c) && npcForm.Masks__r.size() > 0){
                maskCheck = true;
            } else if(npcForm.Reason_for_New_Part__c != Environment_Variable__c.getInstance('NPC_REASON_PROBE_NEW_CARD').Value__c 
                    && npcForm.Reason_for_New_Part__c != Environment_Variable__c.getInstance('NPC_REASON_SHORTLOOP_FLOW').Value__c){
                    maskCheck = true;
            } else{
                maskCheck = false;
            }
            } else if(profileName != 'GF CSR' && profileName != 'GF FAE/FTS'){
                if((npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_PROBE_NEW_CARD').Value__c 
                    || npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_SHORTLOOP_FLOW').Value__c) && npcForm.Masks__r.size() > 0){
                    maskCheck = true;
                } else if(npcForm.Reason_for_New_Part__c != Environment_Variable__c.getInstance('NPC_REASON_PROBE_NEW_CARD').Value__c 
                        && npcForm.Reason_for_New_Part__c != Environment_Variable__c.getInstance('NPC_REASON_SHORTLOOP_FLOW').Value__c){
                        maskCheck = true;
                } else{
                    maskCheck = false;
                }
            } else {
                maskCheck = true;
            }
                
            if(maskCheck == true){
            //Added by Vijay 03042015 -- Check Base Device type(Customer Device or Internal)
            if(npcForm != null && npcForm.BASE_Device__r.RecordType.DeveloperName != null && (npcForm.BASE_Device__r.RecordType.DeveloperName == 'Device' || 
                        npcForm.BASE_Device__r.RecordType.DeveloperName == 'Read_Only')){
                    
                Boolean isCSR = false;
                if(npcForm.Reason_for_New_Part__c == 'New Probe Card Flow'
                    && (npcForm.NPC_Form_Status__c == 'Draft'
                    || npcForm.NPC_Form_Status__c == 'Pending Submission'
                    || npcForm.NPC_Form_Status__c == 'Pending Resubmission')
                    && !(profileName == 'GF CE' || profileName == 'GF FAE/FTS' || profileName == 'GF System Admin' 
                    || profileName == 'GF Integration' || profileName == 'System Administrator')){
                        isCSR = true;
                }
                                
                    // Retrieve Device Information
                    Device__c device = [
                        SELECT      Id                        
                                    , Opportunity_Program__c
                                    , Fab__c
                        FROM        Device__c                        
                        WHERE       Id = :npcForm.Originating_Device__c
                    ];
                   
                                
                    
                    if(isCSR == false)    //DBiswal 12152014 
                    {                    
                      if (device.Opportunity_Program__c != null) {
                        // Retrieve Opportunity Program Team Members
                        // ZAmbat 11132013 - Added Fab Filter (CE approvers should be based on the device fab)
                        List<Opportunity_Program_Team_Member__c> tempListOPTM = [
                            SELECT      Id
                                        , User__c
                                        , Fab_Assignment__c
                            FROM        Opportunity_Program_Team_Member__c
                            WHERE       Opportunity_Program__c = :device.Opportunity_Program__c
                                        AND Team_Role__c = 'Customer Engineer'
                                        AND User__r.IsActive = true
                                        AND Fab_Assignment__c LIKE :('%' + device.Fab__c + '%')
                            ORDER BY    CreatedDate
                            LIMIT 10
                        ];
                        
                        // ZAmbat 12032014
                        List<Opportunity_Program_Team_Member__c> listOPTM = new List<Opportunity_Program_Team_Member__c>();
                         if (tempListOPTM.size() > 0) {
                            if (device.Fab__c == 'FAB 3') {
                                for (Opportunity_Program_Team_Member__c o : tempListOPTM) {
                                    List<string> listFab = o.Fab_Assignment__c.split(';');
                                    Set<string> setFab = new Set<string>();
                                    setFab.addAll(listFab);
                                    if (setFab.contains('FAB 3')) {
                                        listOPTM.add(o);
                                    }
                                }
                            } else {
                                listOPTM.addAll(tempListOPTM);
                            }
                        }
                        
                        // Clear values
                        npcForm.Approver_1__c = null;
                        npcForm.Approver_2__c = null;
                        npcForm.Approver_3__c = null;
                        npcForm.Approver_4__c = null;
                        npcForm.Approver_5__c = null;
                        npcForm.Approver_6__c = null;
                        npcForm.Approver_7__c = null;
                        npcForm.Approver_8__c = null;
                        npcForm.Approver_9__c = null;
                        npcForm.Approver_10__c = null;
                        
                        // Dipak 02112016 Start
           if(npcForm.Reason_For_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_STF').Value__c 
                                 && npcForm.Is_reticle_available__c == EnvironmentVariable.get('NPC_STF_Reticle_GF') 
                                                         && npcForm.Litho_Status__c!='Yes'){                                                         
             if((device.Fab__c == 'FAB 2' || device.Fab__c == 'FAB 3' || device.Fab__c == 'FAB 5') && 
                                             npcForm.Litho_Status__c!='Yes'){
                   lstgMembers.addAll([SELECT Group.Name,Group.Id,UserorgroupId 
                                               FROM GroupMember WHERE Group.Type = 'Queue' AND 
                                               Group.Name =: EnvironmentVariable.get('NPC_Litho_Fab_235')]);  
                 
                   }
              else if(device.Fab__c == 'FAB 3E' && npcForm.Litho_Status__c!='Yes'){lstgMembers.addAll([SELECT Group.Name,Group.Id,UserorgroupId FROM GroupMember WHERE Group.Type = 'Queue' AND  Group.Name =: EnvironmentVariable.get('NPC_Litho_Fab_3E')]);}
              else if(device.Fab__c == 'FAB 7' && npcForm.Litho_Status__c!='Yes'){ lstgMembers.addAll([SELECT Group.Name,Group.Id,UserorgroupId FROM GroupMember WHERE Group.Type = 'Queue' AND Group.Name =: EnvironmentVariable.get('NPC_Litho_Fab_7')]);}  
              else if(device.Fab__c == 'FAB 6' && npcForm.Litho_Status__c!='Yes'){lstgMembers.addAll([SELECT Group.Name,Group.Id,UserorgroupId FROM GroupMember WHERE Group.Type = 'Queue' AND Group.Name =: EnvironmentVariable.get('NPC_Litho_Fab_6')]);}                    
            }
            system.debug('***UserorgroupId***'+lstgMembers);
    // Dipak 02112016 End
                        // Fill in Approvers
                        npcForm.No_of_Approvers__c = listOPTM.size();
                        if (listOPTM.size() > 0) {
                            //added by Vijay 05012015
                            Integer cnt = 1;
                            for(Integer i = 0; i < listOPTM.size()  ;i++ ){
                                npcForm.put('Approver_'+cnt+'__c', listOPTM[i].User__c);
                                cnt++;
                            }                            
                            
                            // 01292014 ARoy : Assign the NPC Form Submitter field in case of Customer Portal User
                            if(this.portal != null && this.portal.trim() != '') {
                                npcForm.NPC_Form_Submitter__c = UserInfo.getUserId();
                            }
                             
                             if (lstgMembers.size() > 0 && npcForm.Reason_For_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_STF').Value__c 
                                          && npcForm.Is_reticle_available__c == EnvironmentVariable.get('NPC_STF_Reticle_GF') && npcForm.Litho_Status__c!='Yes') {
                                     // Clear values                                
                                npcForm.No_of_LithoApprovers__c = lstgMembers.size();                                                                                                        
                                npcForm.Assignee_1__c = null;
                                npcForm.Assignee_2__c = null;
                                npcForm.Assignee_3__c = null;
                                                      

                                Integer cnt2 = 1;
                                for(Integer i = 0; i < lstgMembers.size();i++ ){
                                    string userID = lstgMembers[i].UserorgroupId;
                                    if(userID.startsWith('005')){                                                                          
                                        npcForm.put('Assignee_'+cnt2+'__c', userID);
                                        cnt2++;
                                    }
                                }                                                                                                   
                               }                                                                                                                              
                            // Update NPC Form
                            update npcForm;
                            
                            // Check if device share is needed
                            Device__Share ds = new Device__Share();
                            if (this.shareDevice != null && this.shareDevice.trim() != '') {
                                ds.ParentId = npcForm.BASE_Device__c;
                                ds.UserOrGroupId = UserInfo.getUserId();
                                ds.AccessLevel = 'Edit';
                                ds.RowCause = 'Opportunity_Program_Team__c';
                                
                                insert ds;
                            }
                            
                            // Submit NPC Form for Approval
                            // ZAmbat 01152014
                            try {
                                Approval.ProcessSubmitRequest psr = new Approval.ProcessSubmitRequest();
                                psr.setObjectId(npcForm.Id);
                                
                                Approval.ProcessResult result = Approval.process(psr);
                                if(result.isSuccess()){
                                    String currentUrl = ApexPages.currentPage().getUrl();                                    
                                    
                                    // Delete sharing
                                    if (this.shareDevice != null && this.shareDevice.trim() != '') {
                                        List<Device__Share> listDS = [
                                            SELECT      Id
                                            FROM        Device__Share
                                            WHERE       Id = :ds.Id
                                        ];                                                                               
                                        delete listDS;
                                    }
                                    
                                    PageReference pgr;                                    
                                    if(this.portal != null && this.portal.trim() != '') {                                        
                                        pgr = new PageReference('/GlobalfoundryView/NPCFormReadOnlyVF?id=' + id);
                                    } else {
                                        pgr = new PageReference('/' + id);
                                    }
                                    pgr.setRedirect(true); 
                                    return pgr;
                                }
                            } catch (Exception e) {
                                ApexPages.addmessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Error: ' + e.getMessage()));
                            }
                        } else {
                            returnMessage = Error_Codes__c.getInstance('NO_APPROVERS').Message__c;
                            ApexPages.addmessage(
                                new ApexPages.Message(ApexPages.severity.ERROR,returnMessage) 
                            );
                        }
                    }  
                    else {
                        returnMessage = Error_Codes__c.getInstance('NO_OPPTY_PROGRAM_ON_DEVICE').Message__c;
                        ApexPages.addmessage(
                            new ApexPages.Message(ApexPages.severity.ERROR,returnMessage) 
                        );
                    }                
                return null;
                //return returnMessage;
            }
//

             //DBiswal 12152014 - For FAE Approval
                    else{
                        if (device.Opportunity_Program__c != null) {
                            // Retrieve Opportunity Program Team Members
                            List<Opportunity_Program_Team_Member__c> listOPTMFAE = [
                                SELECT      Id, Team_Role__c
                                            , User__c
                                FROM        Opportunity_Program_Team_Member__c
                                WHERE       Opportunity_Program__c = :device.Opportunity_Program__c
                                            AND (  Team_Role__c = 'Primary Field Technical Support'
                                                OR Team_Role__c = 'Primary Field Application Engineer'
                                                OR Team_Role__c = 'Field Technical Support'
                                                OR Team_Role__c = 'Field Application Engineer'
                                                OR (Team_Role__c = 'Account Manager' AND Is_FAE__c = TRUE)
                                                OR (Team_Role__c = 'Primary Account Manager' AND Is_FAE__c = TRUE) )
                                            AND User__r.IsActive = true
                                ORDER BY    CreatedDate
                                LIMIT 3
                            ];
                            system.debug('1111111111111'+ listOPTMFAE);
                                                        
                            //Njain 08Jun16 Sorting the OPTM keeping PFAE on top
                            listOPTMFAE = Utility.getSortedOPTMforPFAE(listOPTMFAE);
                            
                            // Clear values
                            npcForm.FAE_Approver_1__c = null;
                            npcForm.FAE_Approver_2__c = null;
                            npcForm.FAE_Approver_3__c = null;
                            
                            
                            // Fill in FAE Approvers
                            npcForm.No_of_FAE_Approvers__c = listOPTMFAE.size();
                            
                            if (listOPTMFAE.size() > 0) {
                                //added by Vijay 05012015
                                Integer cnt = 1;
                                for(Integer i = 0; i < listOPTMFAE.size(); i++){
                                    npcForm.put('FAE_Approver_'+cnt+'__c', listOPTMFAE[i].User__c);
                                    cnt++;
                                }                                
                                                        
                                if(this.portal != null && this.portal.trim() != '') {
                                    npcForm.NPC_Form_Submitter__c = UserInfo.getUserId();
                                }
                                
                                // Update NPC Form
                                try{
                                    update npcForm;
                                }catch(DMLException e){
                                    ApexPages.addmessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Error: ' + e.getMessage()));
                                }
                                
                                // Check if device share is needed
                                Device__Share dsf = new Device__Share();
                                if (this.shareDevice != null && this.shareDevice.trim() != '') {
                                    dsf.ParentId = npcForm.BASE_Device__c;
                                    dsf.UserOrGroupId = UserInfo.getUserId();
                                    dsf.AccessLevel = 'Edit';
                                    dsf.RowCause = 'Opportunity_Program_Team__c';
                                    
                                    insert dsf;
                                }
                                
                                // Submit NPC Form for Approval
                                try {
                                    Approval.ProcessSubmitRequest psrf = new Approval.ProcessSubmitRequest();
                                    psrf.setObjectId(npcForm.Id);                            
                                    Approval.ProcessResult resultf = Approval.process(psrf);                                                       
                                    List<ProcessInstance> processInstances = [select Id, Status, TargetObjectId,
                                                        (select ActorId, Comments, ProcessInstanceId, OriginalActorId, StepStatus from Steps order by CreatedDate asc)
                                                from ProcessInstance where TargetObjectId = :npcForm.Id];                                    
                                    if(resultf.isSuccess()){
                                        String currentUrl = ApexPages.currentPage().getUrl();
                                        
                                        // Delete sharing
                                        if (this.shareDevice != null && this.shareDevice.trim() != '') {
                                            List<Device__Share> listDSF = [
                                                SELECT      Id
                                                FROM        Device__Share
                                                WHERE       Id = :dsf.Id
                                            ];
                                            
                                            delete listDSF;
                                        }
                                        cancel();
                                        /*PageReference pgrf;
                                        if(this.portal != null && this.portal.trim() != '') {
                                            pgrf = new PageReference('/GlobalfoundryView/NPCFormReadOnlyVF?id=' + id);
                                        } else {
                                            pgrf = new PageReference('/' + id);
                                        }
                                        pgrf.setRedirect(true); 
                                        return pgrf;
                                        */
                                    }
                                } catch (Exception e) {
                                    ApexPages.addmessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Error: ' + e.getMessage()));
                                }
                            }else {
                                returnMessage = Error_Codes__c.getInstance('NO_APPROVERS').Message__c;
                                ApexPages.addmessage(new ApexPages.Message(ApexPages.severity.ERROR,returnMessage));
                            }
                        }else {
                            returnMessage = Error_Codes__c.getInstance('NO_OPPTY_PROGRAM_ON_DEVICE').Message__c;
                            ApexPages.addmessage(new ApexPages.Message(ApexPages.severity.ERROR,returnMessage));
                        }
                    }
                    
            }                          
             else{   
                try {
                    if(npcForm != null){
                        Approval.ProcessSubmitRequest processSubmitRequest = new Approval.ProcessSubmitRequest();
                        processSubmitRequest.setObjectId(npcForm.Id);                        
                        Approval.ProcessResult processResult = Approval.process(processSubmitRequest);
                        if(processResult.isSuccess()){
                            PageReference pageRef = new PageReference('/' + id);
                            return pageRef;
                        }
                    }
                }catch(Exception e){
                     ApexPages.addmessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Error: ' + e.getMessage()));
                }
            }
            return null;            
            }else{
                errormessage();
                ApexPages.addmessage(new ApexPages.Message(ApexPages.severity.ERROR, Error_Codes__c.getInstance('NPC_MASK_COUNT_FOR_APPROVAL_VALIDATION').Message__c));
                return null;
            }      
    }

    public void errormessage(){
            ApexPages.addmessage(new ApexPages.Message(ApexPages.severity.ERROR, Error_Codes__c.getInstance('NPC_MASK_COUNT_FOR_APPROVAL_VALIDATION').Message__c));    
            ApexPages.addmessage(new ApexPages.Message(ApexPages.severity.ERROR, Error_Codes__c.getInstance('NPC_MASK_COUNT_FOR_APPROVAL_VALIDATION').Message__c));                
            ApexPages.addmessage(new ApexPages.Message(ApexPages.severity.ERROR, Error_Codes__c.getInstance('NPC_MASK_COUNT_FOR_APPROVAL_VALIDATION').Message__c));                
    }
    
    public PageReference cancel(){
        String id = this.recId;
        String currentUrl = ApexPages.currentPage().getUrl();
        PageReference pgr;        
        if(this.portal != null && this.portal.trim() != '') {            
            pgr = new PageReference('/GlobalfoundryView/NPCFormReadOnlyVF?id=' + id);
        } else {
            pgr = new PageReference('/' + id);
        }
        return pgr;
    }
    
    

}