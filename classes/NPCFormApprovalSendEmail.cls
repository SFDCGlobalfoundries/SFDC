/*
    Author: Ariz Solito
    Description: Apex class for sending email notification during NPC approval
    History: 
        ASolito      08142013    - Apex code created
        ZAmbat       09302013    - Added customer_ID__c and new_part_id__c fields in the NPC query (sendEmail(List<String> NPCIDs,Map<ID,New_Part_Creation_Form__c> oldMap))
        ARoy         09302013    - Code merged from NPCEmailHelper class so that a single class is used for NPC Form Approval Mail.
        ZAmbat       10082013    - Changed NPC Status 'Submitted' to 'Pending CE Approval'.
        ARoy         10112013    - Added formula fields like user_email__c and user_manager_email__c for Opportunity Program Team Member query.
        Nbustillos   10142013    - Updated subject for TEMPLATE5.
        ZAmbat       10162013    - Added CEs as recipients for the NPC 24 hour reminder email. Changed hardcoded values to Environment Variables.
        ZAmbat       10172013    - Added handling of email daily limit.
        ASolito      10302013    - Commented email codes and move the logic to workflow rule to minimize daily email limit
        ZAmbat       11152013    - updated code to retrieve Approval Process comments upon Rejection.
        ZAmbat       11212013    - updated code to add validation on the number of recipients.
        ZAmbat       12172013    - updated code to replace NPC Reference Id with New Part Id in the email subject. Added function to check whether the npc record link to be shown in the email should be portal or internal.
        ARoy         02042014    - updated the code to send email for recall of Approval Process.
        ARoy         02072014    - updated check to handle the daily email limit error. (Case 00005687)
        ARoy         03042014    - commented section as Fab 2,3,5,6 approvers are populated into PIYE Approver lookups.
        ZAmbat       06102014    - Updated code as per CASE 16179.
        ZAmbat       10282014    - Updated code as per CASE 35753.
        DBiswal      12182014    - Updated code to send mail to FE when Reason for new Part is 'Fab to Fab Transfer'. 
        Sunil        04272015    - Updated code to add field PIYE_Approver_4__c for case # 40782  
        Prajnith    10102016    - Updated code for fixing Device reactivation              
*/
public class NPCFormApprovalSendEmail {
    
    private static final string OPPTY_PROG_TM_ROLE_CE = EnvironmentVariable.get('OPPTY_PROG_TM_ROLE_CE');
    private static final string OPPTY_PROG_TM_ROLE_FTS = EnvironmentVariable.get('OPPTY_PROG_TM_ROLE_FTS');
    private static final string OPPTY_PROG_TM_ROLE_PFTS = EnvironmentVariable.get('OPPTY_PROG_TM_ROLE_PFTS');
    private static final string OPPTY_PROG_TM_ROLE_CS = EnvironmentVariable.get('OPPTY_PROG_TM_ROLE_CS');
    private static final string TEMPLATE1 = EnvironmentVariable.get('NPC_MAIL_TO_ORIGINATOR');
    private static final string TEMPLATE2 = EnvironmentVariable.get('NPC_MAIL_TO_CE');
    private static final string TEMPLATE3 = EnvironmentVariable.get('NPC_MAIL_TO_FE_CSR');
    private static final string TEMPLATE4 = EnvironmentVariable.get('NPC_MAIL_TO_ORIG_FE_CSR_CE_CE_SYSTEMS');
    private static final string TEMPLATE5 = EnvironmentVariable.get('NPC_MAIL_TO_CE_SUPERVISOR');
    private static final string TEMPLATE6 = EnvironmentVariable.get('NPC_Mail_To_NG_Member');
    
    //=========added by copying from NPCEmailHelper==========// 
    private static final string NPC_STATUS_EXEC = EnvironmentVariable.get('NPC_STATUS_EXEC');
    private static final string NPC_STATUS_IN_EXEC = EnvironmentVariable.get('NPC_STATUS_IN_EXEC');
    private static final string NPC_STATUS_SUBMITTED = EnvironmentVariable.get('NPC_STATUS_SUBMITTED');
    private static final string NPC_STATUS_NOT_EXEC = EnvironmentVariable.get('NPC_STATUS_NOT_EXEC');
    private static final string NPC_STATUS_PEND_RESUB = EnvironmentVariable.get('NPC_STATUS_PEND_RESUB');
    private static final string NPC_STATUS_PEND_CE = EnvironmentVariable.get('NPC_STATUS_SUBMITTED');
    private static final string NPC_STATUS_DRAFT = EnvironmentVariable.get('NPC_STATUS_DRAFT');
    private static final string NPC_STATUS_PEND_SUBMISSION = EnvironmentVariable.get('NPC_STATUS_PEND_SUBMISSION');
    private static final string NPC_STATUS_PEND_LITHO = EnvironmentVariable.get('NPC_PEND_LITHO');
    private static final string NPC_STATUS_PEND_AM = EnvironmentVariable.get('NPC_PEND_AM_APPROVAL');
    
    private static final string NPC_EMAIL_TEMP_REJECT = EnvironmentVariable.get('NPC_EMAIL_TEMP_REJECT');
    private static final string NPC_EMAIL_TEMP_IN_EXEC = EnvironmentVariable.get('NPC_EMAIL_TEMP_IN_EXEC');
    private static final string NPC_EMAIL_TEMP_EXECUTED = EnvironmentVariable.get('NPC_EMAIL_TEMP_EXECUTED');
    private static final string NPC_EMAIL_TEMP_PEND_EXEC = EnvironmentVariable.get('NPC_EMAIL_TEMP_PEND_EXEC');
    private static final string NPC_EMAIL_TO_FAE_FOR_ACTION = EnvironmentVariable.get('NPC_EMAIL_TO_FAE_FOR_ACTION');
    //=========================================================//
    private static final string NPC_EMAIL_TEMP_RECALL = EnvironmentVariable.get('NPC_EMAIL_TEMP_RECALL');
    //DBiswal 12182014
    private static final string OPPTY_PROG_TM_ROLE_FAE = EnvironmentVariable.get('OPPTY_PROG_TM_ROLE_FAE');
    private static final string NPC_STATUS_PEND_PID_REASSIGN = EnvironmentVariable.get('NPC_STATUS_PEND_PID_REASSIGN');
    private static final string NPC_REASON_FAB_TRANSFER = EnvironmentVariable.get('NPC_REASON_FAB_TRANSFER');
    private static final string NPC_REASON_CHANGE_PID = EnvironmentVariable.get('NPC_REASON_CHANGE_PID');
    
    //Method will get masks related to the NPC form
    private static Map<String,List<Mask__c>> getMasks(List<String> NPCIDs){
        Map<String,List<Mask__c>> result = new Map<String,List<Mask__c>>();
        
        for(Mask__c m : [SELECT modified_mask__c,new_part_creation_form__c 
                           FROM Mask__c
                           WHERE new_part_creation_form__c IN :NPCIDs]){
            if(result.containsKey(m.new_part_creation_form__c)){ result.get(m.new_part_creation_form__c).add(m);} 
            else { result.put(m.new_part_creation_form__c,new List<Mask__c>{m});}                 
        }    
        return result;
    }
    
    //Method will get the oppty team members
    private static Map<String,List<Opportunity_Program_Team_Member__c>> getOpptyTeamMembers(List<String> opptyProgIDs){
        Map<String,List<Opportunity_Program_Team_Member__c>> result = new Map<String,List<Opportunity_Program_Team_Member__c>>();   
    
        for(Opportunity_Program_Team_Member__c m : [SELECT team_role__c,user_full_name__c,user__r.email,user__r.phone,
                                                           user__r.manager.email,opportunity_program__c,user_email__c, user_manager_email__c, Fab_Assignment__c
                                                      FROM Opportunity_Program_Team_Member__c
                                                      WHERE opportunity_program__c IN :opptyProgIDs]){
            system.debug('user__r.email==>'+m.user__r.email);
            if(result.containsKey(m.opportunity_program__c)){
                result.get(m.opportunity_program__c).add(m);
            } else {
                result.put(m.opportunity_program__c,new List<Opportunity_Program_Team_Member__c>{m});
            }                                               
        }
        return result;                                                              
    }
    
    //Method will get the oppty team members and masks for each NPC
    private static List<EmailComponents> getTeamMembersAndMasks(List<EmailComponents> comps){
        //get the NPC and Oppty Program IDs
        List<String> opptyProgIDs = new List<String>();
        List<String> NPCIDs = new List<String>();
        for(EmailComponents c: comps){
            opptyProgIDs.add(c.opptyProgId);
            NPCIDs.add(c.currRec.id);
        }
        
        //get the masks and team members and associate it to each email components
        Map<String,List<Mask__c>> masks = getMasks(NPCIDs);
        Map<String,List<Opportunity_Program_Team_Member__c>> opptyTeamMembers = getOpptyTeamMembers(opptyProgIDs);
        
        for(EmailComponents c: comps){
            if(masks.containsKey(c.currRec.id)){
                c.addMasks(masks.get(c.currRec.id));
            }
            
            if(opptyTeamMembers.containsKey(c.opptyProgId)){
                c.addTeamMembers(opptyTeamMembers.get(c.opptyProgId), c.currRec.Fab__c);
            }        
        }
        return comps;   
    }
    
    //Method will be called by the batch class NPCEmailSendBatch
    
    //ASOLITO 10302013 Codes commented out and moved the email triggering to workflow rule
    //to minimize the daily email limit               
    
    //Updated code to add field PIYE_Approver_4__c for case # 40782
    public static void sendEmail(List<String> NPCIDs,Map<ID,New_Part_Creation_Form__c> oldMap){
        List<EmailComponents> comps = new List<EmailComponents>();
        for(New_Part_Creation_Form__c n : [SELECT npc_form_status__c,name,fab__c,reference_id__c,account_short_name__c,
                                                  Notification_Group__c,                    // Dipak 25102016
                                                  base_device__r.opportunity_program__c,owner__r.email,owner__r.name,
                                                  customer_ID__c,new_part_id__c,Send_Reject_Email_Flag__c,Send_Recall_Email_Flag__c,
                                                  PIYE_Approver_1__c,PIYE_Approver_2__c,PIYE_Approver_3__c, PIYE_Approver_4__c,
                                                  PIYE_Approver_1__r.Email,PIYE_Approver_2__r.Email,PIYE_Approver_3__r.Email, PIYE_Approver_4__r.Email,
                                                  Additional_Recipient_1__c,Additional_Recipient_2__c,Additional_Recipient_3__c,
                                                  Additional_Recipient_4__c,Additional_Recipient_5__c,Additional_Recipient_1__r.Portal_Email__c,
                                                  Additional_Recipient_2__r.Portal_Email__c,Additional_Recipient_3__r.Portal_Email__c,Additional_Recipient_4__r.Portal_Email__c,
                                                  Additional_Recipient_5__r.Portal_Email__c,Reason_for_New_Part__c
                                             FROM New_Part_Creation_Form__c
                                             WHERE id IN :NPCIDs]){
            comps.add(new EmailComponents(n));                                      
        }
        
        comps = getTeamMembersAndMasks(comps);  
        
        //send emails
        List<Messaging.SingleEmailMessage> msgs = new List<Messaging.SingleEmailMessage>();
        Map<String,String> emailMap = new Map<String,String>();
        List<New_Part_Creation_Form__c> listRejectNPC = new List<New_Part_Creation_Form__c>();
        // List for NPC Recall Email
        List<New_Part_Creation_Form__c> listRecallNPC = new List<New_Part_Creation_Form__c>();
        
        //===commented after merging code from NPCEmailHelper======// 
        
        
        //=====modified after copying from NPCEmailHelper======// 
        for( EmailTemplate e: [ SELECT  name,
                                        id 
                                FROM 
                                EmailTemplate 
                                WHERE name IN (:TEMPLATE1,:TEMPLATE2,:TEMPLATE3,:TEMPLATE4,:TEMPLATE6,:NPC_EMAIL_TEMP_REJECT,:NPC_EMAIL_TEMP_IN_EXEC,:NPC_EMAIL_TEMP_EXECUTED,:NPC_EMAIL_TEMP_RECALL,:NPC_EMAIL_TO_FAE_FOR_ACTION)]){
            emailMap.put(e.name,e.id);
        }
        //=====================================================//                                                       
          system.debug('comps****'+comps);      
        for(EmailComponents comp: comps){ 
            New_Part_Creation_Form__c currRec = comp.currRec;
            New_Part_Creation_Form__c oldRec = oldMap.get(currRec.id);
                                                
            //Send email to owner after approval submission
            // Dipak 26102016 start 
            if(currRec.Notification_Group__c != '' || currRec.Notification_Group__c != null){
              system.debug('email is ');
              List<String> listEmailRecipients = new List<String>();
                    listEmailRecipients.add(comp.ownerEmail);
                    system.debug('listEmailRecipients1 =============================> ' + listEmailRecipients);
                 
              }
               // Dipak 26102016 end      
              
                // added by prajnith for null exception 
                // 2/22/2017                                           
                if((currRec.Reason_for_New_Part__c == EnvironmentVariable.get('NPC_REASON_STF') && (currRec.npc_form_status__c == NPC_STATUS_PEND_LITHO || currRec.npc_form_status__c == NPC_STATUS_PEND_AM)  && (oldRec.npc_form_status__c == NPC_STATUS_DRAFT || oldRec.npc_form_status__c == NPC_STATUS_PEND_RESUB || oldRec.npc_form_status__c == NPC_STATUS_PEND_SUBMISSION)) || (currRec.npc_form_status__c == NPC_STATUS_PEND_CE && (oldRec.npc_form_status__c == NPC_STATUS_DRAFT || oldRec.npc_form_status__c == NPC_STATUS_PEND_RESUB || oldRec.npc_form_status__c == NPC_STATUS_PEND_SUBMISSION)))                            
                 { 
                if(comp.ownerEmail <> null){
                    // ZAmbat 06162014
                    List<String> listEmailRecipients = new List<String>();
                    listEmailRecipients.add(comp.ownerEmail);
                    system.debug('listEmailRecipients3 =============================> ' + listEmailRecipients);
                    if (comp.AdditionalRecipientsEmails.size() > 0) {
                        listEmailRecipients.addAll(comp.AdditionalRecipientsEmails);
                        system.debug('listEmailRecipients4 =============================> ' + listEmailRecipients);
                    }
                    system.debug('listEmailRecipients =============================> ' + listEmailRecipients);
                    // Dipak 25102016 Start
                    //Yathish st
                    
                    //Yathish end
                    system.debug('listEmailRecipients notif=============================> ' + listEmailRecipients);
                     // Dipak 25102016 End
                    try {
                        // ZAmbat 10172013 - Added handling of email daily limit
                        Messaging.reserveSingleEmailCapacity(listEmailRecipients.size() + 1);
                        String subject = 'NPC After Proto Form Confirmation: ref #'+ currRec.name +' '+ currRec.fab__c + 
                                         '('+currRec.new_part_id__c+') (Originator)';    
                        
                        // ZAmbat 12172013                 
                        comp.mergeFields.put('{RECORDLINK}', NPCFormApprovalSendEmail.generateRecordLink(currRec.id));
                        
                        
                             
                        Messaging.SingleEmailMessage msg = EmailUtil.generateEmailTemplate(emailMap.get(TEMPLATE1),
                                                                                           currRec.id,
                                                                                           subject,
                                                                                           //new List<String>{comp.ownerEmail},
                                                                                           listEmailRecipients,
                                                                                           null,
                                                                                           comp.mergeFields);
                        if(UtilsString.isNotBlank(comp.ownerEmail) && msg != null){
                            msgs.add(msg);                                                                                                                              
                        }   
                    } catch (Exception e) {
                        system.debug('Error ==========> ' + e.getMessage());
                    }        
                }   
                if(Test.isRunningTest()){
                    comp.notifgrpEmail.add('Test@gmail.com;test@yahoo.com;');
                }
                //Yathish St
                if(comp.notifgrpEmail.size() > 0){
                    // ZAmbat 06162014
                    List<String> listEmailRecipients = new List<String>();
                    
                        listEmailRecipients.addAll(comp.notifgrpEmail[0].split(';'));
                 
                    system.debug('listEmailRecipients notif=============================> ' + listEmailRecipients);
                     // Dipak 25102016 End
                    try {
                        // ZAmbat 10172013 - Added handling of email daily limit
                        Messaging.reserveSingleEmailCapacity(listEmailRecipients.size() + 1);
                        String subject = 'NPC : Device reactivation : ref #'+ currRec.name +' '+ currRec.fab__c + 
                                         '('+currRec.new_part_id__c+')';    
                        
                        // ZAmbat 12172013                 
                        comp.mergeFields.put('{RECORDLINK}', NPCFormApprovalSendEmail.generateRecordLink(currRec.id));
                        
                        
                             
                        Messaging.SingleEmailMessage msg = EmailUtil.generateEmailTemplate(emailMap.get(TEMPLATE6),
                                                                                           currRec.id,
                                                                                           subject,
                                                                                           //new List<String>{comp.ownerEmail},
                                                                                           listEmailRecipients,
                                                                                           null,
                                                                                           comp.mergeFields);
                        if(UtilsString.isNotBlank(comp.notifgrpEmail) && msg != null){
                            msgs.add(msg);                                                                                                                              
                        }   
                    } catch (Exception e) {
                        system.debug('Error ==========> ' + e.getMessage());
                    }        
                }
                //Yathish End                                                                                                                                                                   
                           
                List<String> combineEmails = new List<String>();
                combineEmails.addAll(comp.FEEmails);
                combineEmails.addAll(comp.CSREmails);
                
                Set<string> setCombineEmails = new Set<string>();
                setCombineEmails.addAll(combineEmails);
                
                combineEmails = new List<String>();
                combineEmails.addAll(setCombineEmails);
                
                system.debug('combinemails =================> ' + combineEmails);
                system.debug('combinemails size =================> ' + combineEmails.size());
                
                // ZAmbat 11212013 - Check number of to recipients
                if (combineEmails.size() > 100) {
                    List<String> tempCombineEmails = new List<String>();
                    for (integer i=0; i<100; i++) { tempCombineEmails.add(combineEmails[i]);}
                    
                    combineEmails = new List<String>(); combineEmails.addAll(tempCombineEmails);
                    system.debug('new combinemails =================> ' + combineEmails);
                    system.debug('new combinemails size =================> ' + combineEmails.size());
                }
                
                if(combineEmails.size() > 0){ 
                    // ZAmbat 10172013 - Added handling of email daily limit
                    try {
                        Messaging.reserveSingleEmailCapacity(combineEmails.size() + 1);  
                        String subject = 'NPC After Proto Form (ref #'+currRec.name+') Requested by '+
                                         comp.ownerName +' for '+ currRec.account_short_name__c +' '+ currRec.fab__c + 
                                         '('+currRec.new_part_id__c+') (FE/CSR)';
                                                                                                                   
                        Messaging.SingleEmailMessage msg3 = EmailUtil.generateEmailTemplate(emailMap.get(TEMPLATE3),
                                                                                           currRec.id,
                                                                                           subject,
                                                                                           combineEmails,
                                                                                           null,
                                                                                           comp.mergeFields);
                        if(combineEmails.size() > 0 && msg3 != null){  
                            msgs.add(msg3);                                                                                                                              
                        }
                    } catch (Exception e) {
                        system.debug('Error ==========> ' + e.getMessage());
                    } 
                }
            //send email after status is set to In Execution                                                                                                                                                                                                                                                                                                    
            //} else if(currRec.npc_form_status__c == 'In Execution' && oldRec.npc_form_status__c == 'Submitted'){
            
            //ASOLITO 10302013 Codes commented out and moved the email triggering to workflow rule
            //to minimize the daily email limit               
            } 
            //DBiswal 12182014 - For Sending mail to FAE users when status id Pending PID Reassignment
            if(currRec.npc_form_status__c == NPC_STATUS_PEND_PID_REASSIGN &&  oldRec.npc_form_status__c == NPC_STATUS_SUBMITTED && (currRec.Reason_for_New_Part__c == NPC_REASON_FAB_TRANSFER || currRec.Reason_for_New_Part__c == NPC_REASON_CHANGE_PID)){                 
                List<String> listFAERecipients = new List<String>();
                listFAERecipients.addAll(comp.FAEEmails);listFAERecipients.addAll(comp.FEEMails); List<String> listCERecipients = new List<String>();listCERecipients.addAll(comp.CEEmails);
                system.debug('listFAERecipients ========================> ' + listFAERecipients.size()); 
                if(listFAERecipients.size() > 0){ Map<String,String> mergeFieldsMap = new Map<String,String>();mergeFieldsMap.put('{DeviceLink}', NPCFormApprovalSendEmail.generateNPCDeviceLink(currRec.id));                    
                    try {
                        //Added handling of email daily limit
                        Messaging.reserveSingleEmailCapacity(listFAERecipients.size() + listCERecipients.size() + 1);
                        String subject = 'NPC Form (ref #' + currRec.name + ') (' + currRec.NPC_Form_Status__c + ') by FAE';                        
                        Messaging.SingleEmailMessage msg4 = EmailUtil.generateEmailTemplate(emailMap.get(NPC_EMAIL_TO_FAE_FOR_ACTION),currRec.id,subject,listFAERecipients,listCERecipients,mergeFieldsMap);
                        if(UtilsString.isNotBlank(comp.ownerEmail) && msg4 != null){ msgs.add(msg4);}   
                    } catch (Exception e) {
                        system.debug('Error ==========> ' + e.getMessage());
                    }        
                }
            }
            
            //=====================added after copying from NPCEmailHelper==========================//
            // send email when status is set to 'Not Executed' or 'Pending Resubmission'
                           
            if(currRec.npc_form_status__c != oldRec.npc_form_status__c 
                && currRec.Send_Reject_Email_Flag__c == true
                && (currRec.npc_form_status__c == NPC_STATUS_NOT_EXEC || currRec.npc_form_status__c == NPC_STATUS_PEND_RESUB)){
                
                listRejectNPC.add(currRec);
                
                if(comp.ownerEmail <> null){
                    List<String> combineEmails = new List<String>();               
                    combineEmails.addAll(comp.FEEmails);
                    combineEmails.addAll(comp.CEEmails);
                    combineEmails.addAll(comp.CSREmails);
                    
                    //==============Added for PIYE Approvers for all Fabs===============//
                    //Updated code to add field PIYE_Approver_4__c for case # 40782
                    if(oldRec.npc_form_status__c == NPC_STATUS_IN_EXEC && currRec.npc_form_status__c == NPC_STATUS_PEND_RESUB){
                        if(currRec.PIYE_Approver_1__c != null){
                            combineEmails.add(currRec.PIYE_Approver_1__r.Email);
                        }
                        if(currRec.PIYE_Approver_2__c != null){
                            combineEmails.add(currRec.PIYE_Approver_2__r.Email);
                        }
                        if(currRec.PIYE_Approver_3__c != null){
                            combineEmails.add(currRec.PIYE_Approver_3__r.Email);
                        }
                        if(currRec.PIYE_Approver_4__c != null){
                            combineEmails.add(currRec.PIYE_Approver_4__r.Email);
                        }
                        // Commented section as Fab 2,3,5,6 approvers are populated into PIYE Approver lookups
                                            
                    }
                    //============End of Assignment of PIYE Approvers for all Fabs=====//
                    
                    Set<string> setCombineEmails = new Set<string>();
                    setCombineEmails.addAll(combineEmails);
                    
                    combineEmails = new List<String>();
                    combineEmails.addAll(setCombineEmails);
                    
                    // ZAmbat 11152013 - Retrieve Reject reason/comment
                    // Get the latest action from Approval Process
                    List<ProcessInstance> listProcessInstance = [
                        SELECT      Id
                                    , (SELECT Comments FROM Steps WHERE StepStatus != 'NoResponse' ORDER BY CreatedDate DESC)
                        FROM        ProcessInstance
                        WHERE       TargetObjectId = :currRec.Id
                                    AND Status = 'Rejected'
                        ORDER BY    LastModifiedDate DESC
                        LIMIT 1
                    ];
                    
                    // Set message
                    comp.mergeFields.put('{REASON}', Environment_Variable__c.getInstance('NO_COMMENTS_FOUND').Value__c);
                    
                    // Check if there are comments made on the Approval Process
                    if (listProcessInstance.size() > 0) {
                        if(listProcessInstance[0].Steps.size() > 0) {
                            if(listProcessInstance[0].Steps[0].Comments != null){ comp.mergeFields.put('{REASON}', listProcessInstance[0].Steps[0].Comments); }                            }                            
                    }
                    
                    system.debug('combinemails =================> ' + combineEmails);
                    system.debug('combinemails size =================> ' + combineEmails.size());
                    
                    // ZAmbat 11212013 - Check number of cc recipients
                    if (combineEmails.size() > 25) {
                        List<String> tempCombineEmails = new List<String>();
                        for (integer i=0; i<25; i++) {tempCombineEmails.add(combineEmails[i]);}
                        
                        combineEmails = new List<String>();
                        combineEmails.addAll(tempCombineEmails);
                        system.debug('new combinemails =================> ' + combineEmails);
                        system.debug('new combinemails size =================> ' + combineEmails.size());
                    }
                    
                    // ZAmbat 06162014
                    List<String> listEmailRecipients = new List<String>();
                    listEmailRecipients.add(comp.ownerEmail);
                    if (comp.AdditionalRecipientsEmails.size() > 0) {
                        listEmailRecipients.addAll(comp.AdditionalRecipientsEmails);
                    }
                    // Dipak 25102016 Start
                   
                    // Dipak 25102016 End
                    // ZAmbat 10172013 - Added handling of email daily limit
                    try {
                        Messaging.reserveSingleEmailCapacity(listEmailRecipients.size() + combineEmails.size() + 1);
                        Messaging.SingleEmailMessage msg = EmailUtil.generateEmailTemplate(emailMap.get(NPC_EMAIL_TEMP_REJECT),
                                                                                           currRec.id,
                                                                                           null,
                                                                                           //new List<String>{comp.ownerEmail},
                                                                                           listEmailRecipients,
                                                                                           combineEmails,
                                                                                           comp.mergeFields);
                        if(UtilsString.isNotBlank(comp.ownerEmail) && msg != null){  
                            msgs.add(msg);                                                                                                                              
                        }
                    } catch (Exception e) {
                        system.debug('Error ==========> ' + e.getMessage());
                    } 
                }   
            }
            
            // send mail when an approval process is recalled
            //=================start===================================//
            if(currRec.npc_form_status__c != oldRec.npc_form_status__c 
                && currRec.Send_Recall_Email_Flag__c == true
                && currRec.npc_form_status__c == NPC_STATUS_PEND_RESUB){
                
                listRecallNPC.add(currRec);
                
                if(comp.ownerEmail <> null){
                    List<String> combineEmails = new List<String>();               
                    combineEmails.addAll(comp.FEEmails);
                    combineEmails.addAll(comp.CEEmails);
                    combineEmails.addAll(comp.CSREmails);
                    
                    //==============Added for PIYE Approvers for all Fabs===============//
                    //Updated code to add field PIYE_Approver_4__c for case # 40782
                    if(oldRec.npc_form_status__c == NPC_STATUS_IN_EXEC && currRec.npc_form_status__c == NPC_STATUS_PEND_RESUB){
                        if(currRec.PIYE_Approver_1__c != null){
                            combineEmails.add(currRec.PIYE_Approver_1__r.Email);
                        }
                        if(currRec.PIYE_Approver_2__c != null){
                            combineEmails.add(currRec.PIYE_Approver_2__r.Email);
                        }
                        if(currRec.PIYE_Approver_3__c != null){
                            combineEmails.add(currRec.PIYE_Approver_3__r.Email);
                        }
                        if(currRec.PIYE_Approver_4__c != null){
                            combineEmails.add(currRec.PIYE_Approver_4__r.Email);
                        }
                        // Commented section as Fab 2,3,5,6 approvers are populated into PIYE Approver lookups
                                            
                    }
                    //============End of Assignment of PIYE Approvers for all Fabs=====//
                    
                    Set<string> setCombineEmails = new Set<string>();
                    setCombineEmails.addAll(combineEmails);
                    
                    combineEmails = new List<String>();
                    combineEmails.addAll(setCombineEmails);
                    
                    List<ProcessInstance> listProcessInstance = [
                        SELECT      Id
                                    , (SELECT Comments FROM Steps WHERE StepStatus != 'NoResponse' ORDER BY CreatedDate DESC)
                        FROM        ProcessInstance
                        WHERE       TargetObjectId = :currRec.Id
                                    AND Status = 'Removed'
                        ORDER BY    LastModifiedDate DESC
                        LIMIT 1
                    ];
                    
                    // Set message
                    comp.mergeFields.put('{REASON}', Environment_Variable__c.getInstance('NO_COMMENTS_FOUND').Value__c);
                    
                    // Check if there are comments made on the Approval Process
                    if (listProcessInstance.size() > 0) {
                        if (listProcessInstance[0].Steps.size() > 0) {
                            if(listProcessInstance[0].Steps[0].Comments != null){
                                comp.mergeFields.put('{REASON}', listProcessInstance[0].Steps[0].Comments); 
                            }                            
                        }
                    }
                    
                    system.debug('combinemails for recall =================> ' + combineEmails);
                    system.debug('combinemails size for recall =================> ' + combineEmails.size());
                    
                    if (combineEmails.size() > 25) {
                        List<String> tempCombineEmails = new List<String>();
                        for (integer i=0; i<25; i++) {
                            tempCombineEmails.add(combineEmails[i]);
                        }
                        
                        combineEmails = new List<String>();
                        combineEmails.addAll(tempCombineEmails);
                        system.debug('new combinemails for recall =================> ' + combineEmails);
                        system.debug('new combinemails size for recall =================> ' + combineEmails.size());
                    }
                    
                    // ZAmbat 06162014
                    List<String> listEmailRecipients = new List<String>();
                    listEmailRecipients.add(comp.ownerEmail);
                    if (comp.AdditionalRecipientsEmails.size() > 0) {
                        listEmailRecipients.addAll(comp.AdditionalRecipientsEmails);
                    }
                    system.debug('listEmailRecipients =============================> ' + listEmailRecipients);
                    // Dipak 25102016 Start
                  //  if (comp.notifgrpEmail.size() > 0) {
                  //      listEmailRecipients.addAll(comp.notifgrpEmail);
                  //  }
                  //  system.debug('listEmailRecipients notif=============================> ' + listEmailRecipients);
                    // Dipak 25102016 End
                    try {
                        system.debug('listEmailRecipients12 =============================> ' + listEmailRecipients);
                        Messaging.reserveSingleEmailCapacity(listEmailRecipients.size() + combineEmails.size() + 1);
                        Messaging.SingleEmailMessage msg = EmailUtil.generateEmailTemplate(emailMap.get(NPC_EMAIL_TEMP_RECALL),
                                                                                           currRec.id,
                                                                                           null,
                                                                                           //new List<String>{comp.ownerEmail},
                                                                                           listEmailRecipients,
                                                                                           combineEmails, 
                                                                                           comp.mergeFields);
                        if(UtilsString.isNotBlank(comp.ownerEmail) && msg != null){  
                            msgs.add(msg);                                                                                                                              
                        }
                    } catch (Exception e) {
                        system.debug('Error while recall ==========> ' + e.getMessage());
                    } 
                }   
            }
            //==================end====================================//                   
            
            // send email when status is Execution
            
            //ASOLITO 10302013 Codes commented out and moved the email triggering to workflow rule
            //to minimize the daily email limit               
            
            
            //================end of added after copying from NPCEmailHelper===============================//
        }
        system.debug('msgs.size() ===========================> ' + msgs.size());
        if(msgs.size() > 0){
            if (!Test.isRunningTest()) { Messaging.sendEmail(msgs);}  
        }     
        
        if (listRejectNPC.size() > 0) {
            for (New_Part_Creation_Form__c n : listRejectNPC) {
                n.Send_Reject_Email_Flag__c = false;
            }
            
            update listRejectNPC;
        }
        
        //===added for NPC Form Recall=====//
        if (listRecallNPC.size() > 0) {
            for (New_Part_Creation_Form__c n : listRecallNPC) {
                n.Send_Recall_Email_Flag__c = false;
            }
            
            update listRecallNPC;
        }
        //============end==================//                                     
    }
    
    // ZAmbat 12172013
    private static string generateRecordLink(string pNPCId) {
        // Check the originator (NPC Owner)
        string recordURL;
        string sfdcInternal = EnvironmentVariable.get('SFDC_INSTANCE');
        string sfdcPortal = EnvironmentVariable.get('SFDC_CUSTOMER_PORTAL');
        
        New_Part_Creation_Form__c npc = [
            SELECT      Owner__c
            FROM        New_Part_Creation_Form__c
            WHERE       Id = :pNPCId
        ];
        
        User u = [
            SELECT      AccountId
            FROM        User
            WHERE       Id = :npc.Owner__c
        ];
        
        if (u.AccountId != null) {
            // Customer Portal User
            recordURL = sfdcPortal + '/' + pNPCId;
        } else {
            // Internal User
            recordURL = sfdcInternal + '/' + pNPCId;
        }
        
        return recordURL;
    }
    
    public static string generateNPCDeviceLink(string pNPCId) {
        // Check the originator (NPC Owner)
        string recordURL;
        string sfdcInternal = EnvironmentVariable.get('SFDC_INSTANCE');
        string sfdcPortal = EnvironmentVariable.get('SFDC_CUSTOMER_PORTAL');
        
        
        New_Part_Creation_Form__c npc = [
            SELECT      Owner__c
            FROM        New_Part_Creation_Form__c
            WHERE       Id = :pNPCId
        ];
        
        User u = [
            SELECT      AccountId
            FROM        User
            WHERE       Id = :npc.Owner__c
        ];
        
        Device__c d = [
            SELECT    Id
            FROM      Device__c
            WHERE     Tapeout_Type__c = 'Retrofit'
                      AND NPC_Form__c = :pNPCId
            LIMIT 1
        ];
        
        if (u.AccountId != null) {
            // Customer Portal User
            recordURL = sfdcPortal + '/' + d.Id;
        } else {
            // Internal User
            recordURL = sfdcInternal + '/' + d.Id;
        }
        
        return recordURL;
    }
    
    public class EmailComponents {
        public String opptyProgId;      
        public String ownerEmail;
        public String ownerName;
        public Map<String,String> mergeFields;
        public List<String> CEEmails;
        public List<String> CEManagerEmails;
        public List<String> FEEmails;
        public List<String> CSREmails;
        public List<String> FAEEmails;    //DBiswal 12182014        
        public List<String> AdditionalRecipientsEmails;
        public List<String> notifgrpEmail;   // Dipak 25102016
        public New_Part_Creation_Form__c currRec;
        private List<Opportunity_Program_Team_Member__c> teamMembers;
        private List<Mask__c> masks;
        
        public EmailComponents(New_Part_Creation_Form__c currRec){
            this.mergeFields = new Map<String,String>();
            this.CEEmails = new List<String>();
            this.CEManagerEmails = new List<String>();
            this.FEEmails = new List<String>();
            this.FAEEmails = new List<String>();    //DBiswal 12182014            
            this.CSREmails = new List<String>();
            this.AdditionalRecipientsEmails = new List<String>(); 
            
            this.currRec = currRec;                       
            this.opptyProgId = currRec.base_device__r.opportunity_program__c;                                     
            this.ownerEmail = currRec.owner__r.email;
            this.ownerName = currRec.owner__r.name;
            this.notifgrpEmail = new List<String>();    // Dipak 25102016
            
            if (currRec.Additional_Recipient_1__c != null) {                                 
                this.AdditionalRecipientsEmails.add(currRec.Additional_Recipient_1__r.Portal_Email__c);
            }
            
            if (currRec.Additional_Recipient_2__c != null) {                                 
                this.AdditionalRecipientsEmails.add(currRec.Additional_Recipient_2__r.Portal_Email__c);
            }
            
            if (currRec.Additional_Recipient_3__c != null) {                                 
                this.AdditionalRecipientsEmails.add(currRec.Additional_Recipient_3__r.Portal_Email__c);
            }
            
            if (currRec.Additional_Recipient_4__c != null) {                                 
                this.AdditionalRecipientsEmails.add(currRec.Additional_Recipient_4__r.Portal_Email__c);
            }
            
            if (currRec.Additional_Recipient_5__c != null) {                                 
                this.AdditionalRecipientsEmails.add(currRec.Additional_Recipient_5__r.Portal_Email__c);
            }
            if (currRec.Notification_Group__c != null) {               // Dipak 25102016                     
                this.notifgrpEmail.add(currRec.Notification_Group__c);  // Dipak 25102016
            }
        }
        
        //Method will generate the masks
        public void addMasks(List<Mask__c> masks){
            this.masks = masks;
            
            //get the masks under the NPC
            String mergeFieldMask = '<table>';
            
            for(Mask__c m : [SELECT original_mask__c,modified_mask__c 
                               FROM Mask__c
                               WHERE new_part_creation_form__c = :currRec.id]){
                if(m.original_mask__c <> m.modified_mask__c){
                    mergeFieldMask += '<tr><td style="font-weight:bold;color:red">' + m.modified_mask__c + '</td><tr/>';                 
                } else {
                    mergeFieldMask += '<tr><td>' + m.modified_mask__c + '<td/></tr>';                 
                }
            } 
             mergeFieldMask = mergeFieldMask + '</table>'; 
            this.mergeFields.put('{MASKSET}',mergeFieldMask);                       
        }
        
        //Method will generate the team member details
        public void addTeamMembers( List<Opportunity_Program_Team_Member__c> teamMembers, string fab){
            this.teamMembers = teamMembers;
            
            //create the custom merge fields for the email          
            String mergeFieldFE = '';
            String mergeFieldCE = '';
            String mergeFieldCSR = '';
            String usrPhone = ''; 
            
            //get the oppty team members of the NPC                      
            for(Opportunity_Program_Team_Member__c m : teamMembers){                                                            
                if(m.user__r.phone <> null){
                    usrPhone = ' ('+ m.user__r.phone + '), ';       
                }else{
                    usrPhone = ','; 
                }
                if(m.team_role__c.contains(OPPTY_PROG_TM_ROLE_FTS) || m.team_role__c.contains(OPPTY_PROG_TM_ROLE_PFTS)) {
                    mergeFieldFE += m.user_full_name__c + usrPhone;
                    //system.debug('1===>'+m.user__r.email);                                        
                    //this.FEEMails.add(m.user__r.email);
                    this.FEEMails.add(m.user_email__c);
                } else if(m.team_role__c.contains(OPPTY_PROG_TM_ROLE_CE)){
                    if (!test.isRunningTest()) {
                     system.debug('value of fab assignment '+m+'      '+  m.fab_assignment__c);
                        if (m.fab_assignment__c.indexOf(fab) != -1) {
                          
                            mergeFieldCE += m.user_full_name__c + usrPhone;
                            //system.debug('2===>'+m.user__r.email); 
                            //this.CEEMails.add(m.user__r.email);
                            this.CEEMails.add(m.user_email__c);
                            //if(UtilsString.isNotBlank(m.user__r.manager.email)){
                            if(UtilsString.isNotBlank(m.user_manager_email__c)){                    
                                system.debug('3===>'+m.user__r.email);
                                //this.CEManagerEmails.add(m.user__r.manager.email);
                                this.CEManagerEmails.add(m.user_manager_email__c);
                            }
                        }
                    } else {
                        mergeFieldCE += m.user_full_name__c + usrPhone;
                        this.CEEMails.add(m.user_email__c);
                        if(UtilsString.isNotBlank(m.user_manager_email__c)){                    
                            this.CEManagerEmails.add(m.user_manager_email__c);
                        }
                    }
                } else if(m.team_role__c.contains(OPPTY_PROG_TM_ROLE_CS)){
                    mergeFieldCSR += m.user_full_name__c + usrPhone;
                    //system.debug('4===>'+m.user__r.email);
                    //this.CSREMails.add(m.user__r.email);
                    this.CSREMails.add(m.user_email__c);
                 }
                //DBiswal 12182014
                else if(m.team_role__c.contains(OPPTY_PROG_TM_ROLE_FAE)){
                    //mergeFieldFAE += m.user_full_name__c + usrPhone;
                    //system.debug('1===>'+m.user__r.email);                                        
                    //this.FEEMails.add(m.user__r.email);
                    this.FAEEMails.add(m.user_email__c);                    
                }                                                                                                                                           
            }   
            
            mergeFieldFE = mergeFieldFE.removeEnd(',');
            mergeFieldCE = mergeFieldCE.removeEnd(',');
            mergeFieldCSR = mergeFieldCSR.removeEnd(',');
            
            this.mergeFields.put('{CE}',mergeFieldCE);
            this.mergeFields.put('{FE}',mergeFieldFE);               
            this.mergeFields.put('{CSR}',mergeFieldCSR);                        
        }                
    }   
}