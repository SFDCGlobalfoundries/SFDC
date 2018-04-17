/*
    Author: Win Hwang
    Description: This webservice provides method to set the status to Re-open.
    History: 
        Win           07112013    - Code creation.
        Nbustillos    07292013    - Added new method submitForApproval().
        Nbustillos    08132013    - Updated code to change Environment variables:
                                     1. 'OPPTY_PROG_TM_ROLE_FTS' instead of 'OPPTY_PROG_TM_ROLE_FE'
                                     2. 'OPPTY_PROG_TM_ROLE_PFTS' instead of 'OPPTY_PROG_TM_ROLE_PFE'
        Aroy          09132013    - removed Status__c = 'Matched' as no longer required as per MD50.
        Nbustillos    10102013    - Added user validation on reOpen method().
        Nbustillos    10142013    - Added logic to reset record type for ReOpen.
                                  - Added validation logic for submitForApproval() method
        Nbustillos    10172013    - Added condition to check if email object is null. If so do not send email.
        Asolito       11112013    - Added enhancement for TASK - 471, moved custom apex email send codes to standard workflows.
        Nbustillos    11122013    - Added logic to filter only active user for populating approver lookups.
        ARoy          11142013    - Removed the DE - Customer Support and DE - Enablements from the Approver List (Task - 548).
        ARoy          11152013    - Added check for Oppotunity Program Team Member list before submit for approval.
        ARoy          11192013    - Added additional order by to keep DE - IP Technical at the top of the approver queue. 
        Asolito       01082014    - Added validation for certain PT numbers will have a require IP declaration component required 
                                    upon submit for approval
        Asolito       01162014    - Modified the sorting order of the approvers for the approval process   
        Tlai          30072014    - Changed as per case 29522                             
*/
global class IpDeclarationFormService {
    
    /**
    Use to set the IP Declaration status to 'Pending Resubmission'.
    How to assure authorization checking here? TODO:
    */
    webservice static String reOpen(String ipDecFormId) {
        String report = null;
        set<string> setValidRoles = new set<string>{EnvironmentVariable.get('OPPTY_PROG_TM_ROLE_AM'),
                                                    EnvironmentVariable.get('OPPTY_PROG_TM_ROLE_PAM'),
                                                    EnvironmentVariable.get('PPTY_PROG_TM_ROLE_FAE'),
                                                    EnvironmentVariable.get('OPPTY_PROG_TM_ROLE_FTS'),
                                                    EnvironmentVariable.get('OPPTY_PROG_TM_ROLE_PFTS'),
                                                    EnvironmentVariable.get('SYS_ADMIN')};
        try{
            boolean isAccess = false;            
            IP_Declaration_Form__c ipDecForm = [select Id, Status__c, OwnerId__c, Last_Assigned_Customer_User__c,
                                                Device_Name__c, LastModifiedBy__c, Name, CRM_Device_ID__c,
                                                Project_Name__c, Device__c, Device__r.Opportunity_Program__c
                                                from IP_Declaration_Form__c 
                                                where Id = :ipDecFormId limit 1];                                                          
            
            // Check if there is atleast valid role for this user 
            integer iValidMember = [select count() from Opportunity_Program_Team_Member__c where Opportunity_Program__c = :ipDecForm.Device__r.Opportunity_Program__c and
                                   Team_Role__c in :setValidRoles and User__c = :UserInfo.getUserId()];  
            
            // Check if this user is a DE Admin                    
            User objCurUser = [Select Id,profile.name, (Select PermissionSet.Name From PermissionSetAssignments where PermissionSet.Name = 'DE_Administrator') From User
                              where id = :UserInfo.getUserId()];  
            
            //Check if system administrator
            if(objCurUser.profile.name == EnvironmentVariable.get('SYS_ADMIN')){
                isAccess = true;
            }                               
            
            for(PermissionSetAssignment p : objCurUser.PermissionSetAssignments){
                system.debug('PermissionSet Name: ' + p.PermissionSet.Name);
                if(p.PermissionSet.Name=='DE_Administrator'){
                    isAccess = true;
                }                                
            }
            system.debug('iValidMember :' + iValidMember );  
            system.debug('isAccess :' + isAccess); 
            // validate if user is an AM/FE or DE Admin               
            if(iValidMember > 0 || isAccess){     
                                                                       
                // 09132013 - Aroy : Removed the Status__c = 'Matched' as no longer required as per MD50
                if(ipDecForm != null && (ipDecForm.Status__c == EnvironmentVariable.get('IP_DECLARATION_STATUS_APPROVED') || ipDecForm.Status__c == EnvironmentVariable.get('IP_DECLARATION_STATUS_PRECON'))){
                    ipDecForm.Status__c = 'Pending Resubmission';
                    ipDecForm.OwnerId__c = ipDecForm.Last_Assigned_Customer_User__c;
                    ipDecForm.Last_Assigned_Customer_User__c = Userinfo.getUserid();
                    ipDecForm.Reset_Record_Type__c = true;
                    update ipDecForm;
                    
                    //ASOLITO 11112013 - commented out email send code
                    //report = sendMail(ipDecForm);
                }
                
                return 'OK';
            }else{ return Error_Codes__c.getAll().get('IP_FORM_REOPEN_ERROR').Message__c;
                
            }
        }catch(Exception ex){ return ex.getMessage();
            
        }
    }
    

    
    //send the Mail
    //ASOLITO 11112013 - commented out email send code
    /* 
    private static String sendMail(IP_Declaration_Form__c ipDecForm){                               
        EmailTemplate temp1 = [SELECT id from EmailTemplate where name = 'IPDeclaration Reopen'];               
        User user = [select ContactId, Email from User where Id = :ipDecForm.Last_Assigned_Customer_User__c limit 1];               
        
        //Send the email template
        List<Messaging.SingleEmailMessage> templates = EmailUtil.generateEmailTemplate(temp1.id,
                                                                                       ipDecForm.id,
                                                                                       new List<String>{user.email},
                                                                                       null);
        List<Messaging.SingleEmailMessage> sendMsgs = new List<Messaging.SingleEmailMessage>();
        
        integer iTotalEmailToReserve = 0;    
        if(templates!=null){
            for(Messaging.SingleEmailMessage t :templates){
                
                Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
                msg.setToAddresses(t.getToAddresses());
                Id accountId = DeviceHelper.getAccountIdbyDeviceId(ipDecForm.Device__c);
                msg.setCcAddresses(DeviceHelper.getFEAMEmails(accountId));
                msg.setHTMLBody(t.getHTMLBody());
                msg.setPlainTextBody(t.getPlainTextBody());
                msg.setSubject(t.getSubject());
                sendMsgs.add(msg);
                
                // compute number of recipients
                iTotalEmailToReserve += (msg.getToaddresses().size() + msg.getCcAddresses().size()); 
            }
            
            try{
                Messaging.reserveSingleEmailCapacity(iTotalEmailToReserve);
                Messaging.sendEmail(sendMsgs);
            }catch(Exception e){
                System.debug('Email Error: ' + e.getMessage());
            }
        }
        return null;
          
    }*/  
      
    //ASolito 01082014
    //validation for required IP component for selected PT Numbers 
    public static Map<String,String> validateRequiredPTs(IP_Declaration_Form__c oIPForm){                 
        Map<String,String> result = new Map<String,String>();
        if(oIPForm <> null){ 
            String reqPTs = EnvironmentVariable.get('IP_DECLARATION_REQUIRED_PT');
            
            Set<String> PTs = new Set<String>();
            if(UtilsString.isNotBlank(reqPTs)){
                PTs.addAll(reqPTs.split('\\,'));
            }
            
            if(PTs.contains(oIPForm.device__r.process_technology_2__r.name)){
                //get the vendor name of the ip component which may be used if for error message
                for(Process_Technology_IP_Component__c p : [SELECT ip_component_from_ERP__r.fv_vendor__c
                                                              FROM Process_Technology_IP_Component__c
                                                              WHERE process_technology__c = :oIPForm.device__r.process_technology_2__c
                                                              AND ip_component_from_ERP__r.fv_vendor__c <> null
                                                              LIMIT 1]){                    
                    if(UtilsString.isNotBlank(p.ip_component_from_ERP__r.fv_vendor__c)){
                        result.put('vendor',p.ip_component_from_ERP__r.fv_vendor__c);
                    }                                                                    
                }
                
                //put dummy value on vendor name if its null  
                if(!result.containsKey('vendor')){ result.put('vendor','NO VENDOR NAME');
                    
                }                                                                                                                                                                 
            
                result.put('hasRequiredPT','true');
                List<String> IPCompIDs = new List<String>();
                for(IP_Declaration_Component__c i :oIPForm.IP_Declaration_Component__r){
                    IPCompIDs.add(i.master_IP_component__c);                                                
                }
                
                if(IPCompIDs.size() == 0){
                    result.put('validated','false');                                                                                                  
                } else {                
                    //check if at least 1 required IP has been declared and only 1 is selected
                    Integer count = [SELECT count() FROM Process_Technology_IP_Component__c
                                                    WHERE ip_component_from_ERP__c IN :IPCompIDs
                                                    AND process_technology__c = :oIPForm.device__r.process_technology_2__c];                                                                                                    
    
                    if(count == 1){      
                         result.put('validated','true');              
                    } else { 
                        result.put('validated','false');
                    }
                }                                
            } else { result.put('hasRequiredPT','false');     
                                                                               
            }
        }                                                                                                                                                    
        return result;       
    }
    
    webservice static String submitForApproval(String ipDecFormId) {
        String isSubmitted = null;
        boolean isAccess = false;
        //ASolito 01082014
        //flags required IP component for selected PT Numbers 
        //*******************************************************
        boolean requiresDeclaredIP = false;
        boolean hasRequiredDeclaredIP = false; 
        String vendorName;
        //*******************************************************
        try{
            // retrieve the Ip declaration form record
            IP_Declaration_Form__c oIPForm = [SELECT id, Device__r.Opportunity_Program__c, Step_1_Approver_1__c, 
                                                     Step_1_Approver_2__c, Step_1_Approver_3__c, Step_1_Approver_4__c, 
                                                     Step_1_Approver_5__c, Step_1_Approver_6__c, Step_1_Approver_7__c, 
                                                     Step_1_Approver_8__c, Step_1_Approver_9__c, Step_1_Approver_10__c, 
                                                     Status__c,device__r.process_technology_2__r.name,device__r.process_technology_2__c,
                                                     (SELECT master_IP_component__c FROM IP_Declaration_Component__r)
                                                FROM IP_Declaration_Form__c 
                                                WHERE Id = :ipDecFormId];            
                                             
             // Check if this user is a DE Admin                    
            User objCurUser = [Select Id,profile.name, profile.usertype, (Select PermissionSet.Name From PermissionSetAssignments where PermissionSet.Name = 'DE_Administrator') From User
                              where id = :UserInfo.getUserId()];  
            
            //Check if system administrator or portal user
            system.debug('>>> USERTYPE:' + objCurUser.Profile.UserType);
            if(objCurUser.profile.name == EnvironmentVariable.get('SYS_ADMIN') || objCurUser.profile.usertype==EnvironmentVariable.get('CUSTOMER_SUCCESS') || 
               objCurUser.profile.usertype==EnvironmentVariable.get('POWER_CUSTOMER_SUCCESS')){
                isAccess = true;
            }                               
            
            for(PermissionSetAssignment p : objCurUser.PermissionSetAssignments){
                system.debug('PermissionSet Name: ' + p.PermissionSet.Name);
                if(p.PermissionSet.Name=='DE_Administrator'){
                    isAccess = true;
                }                                
            }
                                    
            //ASolito 01082014
            //validation for required IP component for selected PT Numbers 
            //*******************************************************
            Map<String,String> result = validateRequiredPTs(oIPForm);
            if(result <> null){
                if(result.get('hasRequiredPT') == 'true'){
                    requiresDeclaredIP = true;
                    if(result.get('validated') == 'true'){
                        hasRequiredDeclaredIP = true;
                    } else {
                        //get the vendor name for error message
                        vendorName = result.get('vendor');
                        isAccess = false;
                    }
                }     
            }                          
            //*******************************************************
            
            // validate if user is an AM/FE or DE Admin               
            if(isAccess){  
                system.debug('oIPForm.Status__c ============================> ' + oIPForm.Status__c);
                system.debug('IP_DECLARATION_STATUS_UNDECLARED ============================> ' + EnvironmentVariable.get('IP_DECLARATION_STATUS_UNDECLARED'));
                system.debug('IP_DECLARATION_STATUS_DRAFT ============================> ' + EnvironmentVariable.get('IP_DECLARATION_STATUS_DRAFT'));
                system.debug('IP_DECLARATION_STATUS_REASSIGNED ============================> ' + EnvironmentVariable.get('IP_DECLARATION_STATUS_REASSIGNED'));
                system.debug('IP_DECLARATION_STATUS_PSUBMISSION ============================> ' + EnvironmentVariable.get('IP_DECLARATION_STATUS_PSUBMISSION'));
                system.debug('IP_DECLARATION_STATUS_RECALLED ============================> ' + EnvironmentVariable.get('IP_DECLARATION_STATUS_RECALLED'));
                
                // validate for valid status
                if(oIPForm != null && (oIPForm.Status__c == EnvironmentVariable.get('IP_DECLARATION_STATUS_UNDECLARED') || oIPForm.Status__c == EnvironmentVariable.get('IP_DECLARATION_STATUS_DRAFT') || 
                oIPForm.Status__c == EnvironmentVariable.get('IP_DECLARATION_STATUS_REASSIGNED') || oIPForm.Status__c == EnvironmentVariable.get('IP_DECLARATION_STATUS_PSUBMISSION') || 
                oIPForm.Status__c == EnvironmentVariable.get('IP_DECLARATION_STATUS_RECALLED'))){
                    
                    // reset all approvers
                    oIPForm.Step_1_Approver_1__c = null;
                    oIPForm.Step_1_Approver_2__c = null;
                    oIPForm.Step_1_Approver_3__c = null;
                    oIPForm.Step_1_Approver_4__c = null;
                    oIPForm.Step_1_Approver_5__c = null;
                    oIPForm.Step_1_Approver_6__c = null;
                    oIPForm.Step_1_Approver_7__c = null;
                    oIPForm.Step_1_Approver_8__c = null;
                    oIPForm.Step_1_Approver_9__c = null;
                    oIPForm.Step_1_Approver_10__c = null;
                    
                    // get all supported roles
                    List<String> setApproverRoles = new List<String>{ Environment_Variable__c.getInstance('OPPTY_PROG_TM_ROLE_DEIP').Value__c, 
                                                                      Environment_Variable__c.getInstance('OPPTY_PROG_TM_ROLE_PFTS').Value__c,
                                                                      Environment_Variable__c.getInstance('OPPTY_PROG_TM_ROLE_FTS').Value__c, 
                                                                      Environment_Variable__c.getInstance('OPPTY_PROG_TM_ROLE').Value__c                                                                                                                                                                                                                                                                                                                   
                                                                      };
                    
                    //get the priority roles first - DE IP and PFTS                                                  
                    List<Opportunity_Program_Team_Member__c> oppProgTMList1 = [select User__c,team_role__c from Opportunity_Program_Team_Member__c 
                                                                              where Team_Role__c in (:Environment_Variable__c.getInstance('OPPTY_PROG_TM_ROLE_DEIP').Value__c,
                                                                                                     :Environment_Variable__c.getInstance('OPPTY_PROG_TM_ROLE_PFTS').Value__c)
                                                                              and Opportunity_Program__c = :oIPForm.Device__r.Opportunity_Program__c  
                                                                              and User__r.IsActive = true order by Team_Role__c asc,createddate asc limit 10];
                    
                    //get secondary roles - FTS and FAE
                   List<Opportunity_Program_Team_Member__c> oppProgTMList2 = [select User__c,team_role__c from Opportunity_Program_Team_Member__c 
                                                                              where (Team_Role__c in (:Environment_Variable__c.getInstance('OPPTY_PROG_TM_ROLE_FTS').Value__c,
                                                                                                     :Environment_Variable__c.getInstance('OPPTY_PROG_TM_ROLE').Value__c)
                                                                                     OR ( Team_Role__c = 'Account Manager' AND Is_FAE__c = TRUE)
                                                                                     OR ( Team_Role__c = 'Primary Account Manager' AND Is_FAE__c = TRUE) )
                                                                              and Opportunity_Program__c = :oIPForm.Device__r.Opportunity_Program__c  
                                                                              and User__r.IsActive = true order by Team_Role__c desc,createddate asc limit 10];
                                                            
                  
                  
                   
                                                            
                   
                  // List<Opportunity_Program_Team_Member__c> oppProgTMList2 = [select User__c,team_role__c from Opportunity_Program_Team_Member__c limit 10];
                    system.debug('oppProgTMList1 $$'+oppProgTMList1);
                    system.debug('oppProgTMList2&&&&' +  oppProgTMList2);
                    List<Opportunity_Program_Team_Member__c> allTM = new List<Opportunity_Program_Team_Member__c>();
                    allTM.addAll(oppProgTMList1);

                    //check if there are remaining slots for secondary approvers                                                         
                    Integer remainingSlot = 10 - oppProgTMList1.size();
                    system.debug('remainingSlot ' + remainingSlot +' oppProgTMList2 ' +  oppProgTMList2);
                    for(Integer counter = 0; counter < remainingSlot; counter++){
                     system.debug('counter $$'+counter);
                     system.debug('oppProgTMList2$$'+oppProgTMList2.size());
                        if(oppProgTMList2.size() > counter){
                            allTM.add(oppProgTMList2[counter]);
                        } else {
                            break;
                        }    
                    }                                                                             

                    //create the sort order of the approvers
                    Map<String,List<String>> sortedUsers = new Map<String,List<String>>();
                    system.debug('allTM$$'+allTM);
                    for(Opportunity_Program_Team_Member__c oApprover : allTM){
                        if(sortedUsers.containsKey(oApprover.team_role__c)){
                            sortedUsers.get(oApprover.team_role__c).add(oApprover.user__c);
                        } else {
                            sortedUsers.put(oApprover.team_role__c,new List<String>{oApprover.user__c});
                        }
                    }
                    
                    if(sortedUsers.keySet().size() > 0){
                        integer ctr = 0;
                        list<string> apprList = new list<string>();//Tlai 30072014
                        for(String key :setApproverRoles){
                            if(sortedUsers.containsKey(key) && ctr < 10){
                                for(String u:sortedUsers.get(key)){
                                    if(ctr==0){
                                        oIPForm.Step_1_Approver_1__c = u;
                                    }else if(ctr==1){
                                         oIPForm.Step_1_Approver_2__c = u;
                                    }else if(ctr==2){
                                         oIPForm.Step_1_Approver_3__c = u;
                                    }else if(ctr==3){ 
                                        oIPForm.Step_1_Approver_4__c = u;
                                    }else if(ctr==4){
                                        oIPForm.Step_1_Approver_5__c = u;
                                    }else if(ctr==5){
                                        oIPForm.Step_1_Approver_6__c = u;
                                    }else if(ctr==6){
                                        oIPForm.Step_1_Approver_7__c = u;
                                    }else if(ctr==7){
                                        oIPForm.Step_1_Approver_8__c = u;
                                    }else if(ctr==8){
                                        oIPForm.Step_1_Approver_9__c = u;
                                    }else if(ctr==9){
                                        oIPForm.Step_1_Approver_10__c = u;
                                    }
                                    
                                    apprList.add(u);
                                    ctr++;
                                }
                            }
                        }                        
                        update oIPForm;
                        system.debug('oIPForm:'+oIPForm);
                        // submit the record for approval
                        system.debug([select id, status__c from IP_Declaration_Form__c where Id = :ipDecFormId]);
                        Approval.ProcessSubmitRequest oRequest = new Approval.ProcessSubmitRequest();
                        oRequest.setObjectId(ipDecFormId);
                        Approval.ProcessResult oResult = Approval.process(oRequest);
            
                        isSubmitted = (oResult.isSuccess())? 'OK' : 'ERROR';
                        
                        //Tlai 30072014 as per case 
                        if(oResult.isSuccess()){
                            EmailTemplate temp1 = [SELECT id from EmailTemplate where name = 'IPDeclaration_FormSubmission'];//For IP declaration Form submission
                            list<string> repList = new list<string>();
                            for(User usr: [select id, Portal_Email__c from User where id in :apprList]){
                                repList.add(usr.Portal_Email__c);
                            }
                            Messaging.SingleEmailMessage message = EmailUtil.generateEmailTemplate(temp1.id,
                                                                                            oIPForm.id,
                                                                                            null,
                                                                                            repList,
                                                                                            null,
                                                                                            new Map<String,String>());
                            message.saveAsActivity = false;
                            Messaging.reserveSingleEmailCapacity(repList.size());    
                            if(!Test.isRunningTest()){                                  
                                Messaging.sendEmail(new list<Messaging.SingleEmailMessage>{message});
                            }
                        }
                    }else{
                        isSubmitted = Error_Codes__c.getAll().get('IP_FORM_SUBMIT_NO_APPROVER').Message__c;
                    }
                }else{
                    isSubmitted = Error_Codes__c.getAll().get('IP_FORM_SUBMIT2_ERROR').Message__c;
                }
            }else{
                if(requiresDeclaredIP){
                    if(!hasRequiredDeclaredIP){
                        String err = Error_Codes__c.getAll().get('IP_FORM_SUBMIT3_ERROR').Message__c.replace('FV_VENDOR',vendorName);
                        isSubmitted = err;
                    }
                } else {
                    isSubmitted = Error_Codes__c.getAll().get('IP_FORM_SUBMIT_ERROR').Message__c;
                }
            }
        }catch(Exception e){
            isSubmitted = e.getMessage();        
        }
        return isSubmitted;
    }    
}