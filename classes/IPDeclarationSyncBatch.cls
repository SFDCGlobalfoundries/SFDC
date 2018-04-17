/*
    Author: Anirban Roy
    Description: This is the batch class for IP Declaration daily data synchronization with FV1.0. 
    History:
        ARoy        12062013    - code creation.
*/
global class IPDeclarationSyncBatch implements Database.Batchable<sObject>{
    
    // Query for IP Declaration Form for Manual Submission of Form.
    global final String query = 'select id, Email_Address__c, Manual_Submission_Required__c, Device__c from IP_Declaration_Form__c where Manual_Submission_Required__c = true';

    // Start of the Batch
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    
    // Method to submit the IP Declaration Form Approval Process and Email Address 
    // and reset the Manual_Submission_Required__c to false  
    global void execute(Database.BatchableContext ctx, List<Sobject> scope){
        // Getting IP Declaration Form List 
        List<IP_Declaration_Form__c> ipDecFormList = (List<IP_Declaration_Form__c>)scope;      
        List<String> ipDecFormIds = new List<String>();
        
        // Approval Process Variable Declarations
        Approval.ProcessResult[] processResult;
        Map<String,Boolean> processResMap = new Map<String,Boolean>();
        List<IP_Declaration_Form__c> ipDecFormNewList = new List<IP_Declaration_Form__c>();
        
        // Get Ids of IP Declaration Form
        for (IP_Declaration_Form__c ipDecForm: ipDecFormList) {
            ipDecFormIds.add(ipDecForm.Id);                                 
        }
        
        // Submit For Approval for IP Declaration Forms marked as Manual_Submission_Required__c = true
        try {
            processResult = submitForApprovalForBatch(ipDecFormIds);                        
        }catch (System.DmlException e) {
            System.debug('Exception Message From execute method of IPDeclarationSyncBatch :: ' + e.getMessage());
        }
        
        // Getting map of IP Dec record id and the approval submission status
        if(processResult != null){
            for(Approval.ProcessResult pr : processResult){
                processResMap.put(pr.getEntityId(),pr.isSuccess());
            }
        } 
        
        List<String> deviceIds = new List<String>();
        
        // Loop through the IP Dec Form List to mark the ones went through the approval process successfully        
        for (IP_Declaration_Form__c ipDecForm: ipDecFormList) {         
            if(!processResMap.isEmpty() && processResMap.containsKey(ipDecForm.Id) && processResMap.get(ipDecForm.Id)){
                // Remove the 'x' added in the Email_Address__c field by integration process
                if(ipDecForm.Email_Address__c != null && ipDecForm.Email_Address__c.endsWith('x')){
                    ipDecForm.Email_Address__c = ipDecForm.Email_Address__c.substring(0,ipDecForm.Email_Address__c.length()-1);             
                }
                
                //Reset the Manual Submission to false
                ipDecForm.Manual_Submission_Required__c = false;
                ipDecFormNewList.add(ipDecForm);
                deviceIds.add(ipDecForm.Device__c);
            }           
        }
        
        // Update the successful IP Declaration Form
        if(ipDecFormNewList.size()>0){
            update ipDecFormNewList;
            
            //Retrieving device to update send_for_integration__c flag to true
            List<Device__c> devList = [select   id,
                                                send_for_integration__c
                                       from     Device__c
                                       where    id in : deviceIds];
            
            // Creating a new list for updation of Device for sending outbound message
            List<Device__c> devNewList = new List<Device__c>();
            
            // update send_for_integration__c flag in Device to true
            for(Device__c dev : devList){
                boolean sendForOutbound = false;
                if(!dev.Send_for_Integration__c){
                    dev.Send_for_Integration__c = true;
                    sendForOutbound = true;
                }
                //Adding Device to the list for updation only when Send_for_Integration__c
                if(sendForOutbound){
                    devNewList.add(dev);
                }
            }
            
            //Update Device to send the outbound message
            if(devNewList.size()>0){
                update devNewList;
            }
        }              
                           
    }
    
    // End of the Batch
    global void finish(Database.BatchableContext BC){

    }
    
    // Submit For Approval For Batch Load
    private Approval.ProcessResult[] submitForApprovalForBatch(List<String> ipDecFormIds){
        Approval.ProcessResult[] processResults;
        try{
            // retrieve the map for Ip declaration form record
            Map<String,IP_Declaration_Form__c> ipDecFormMap = 
                                                    new Map<String,IP_Declaration_Form__c>([select  id, 
                                                                                                    Device__r.Opportunity_Program__c, 
                                                                                                    Step_1_Approver_1__c, 
                                                                                                    Step_1_Approver_2__c, 
                                                                                                    Step_1_Approver_3__c, 
                                                                                                    Step_1_Approver_4__c, 
                                                                                                    Step_1_Approver_5__c, 
                                                                                                    Step_1_Approver_6__c, 
                                                                                                    Step_1_Approver_7__c, 
                                                                                                    Step_1_Approver_8__c, 
                                                                                                    Step_1_Approver_9__c, 
                                                                                                    Step_1_Approver_10__c, 
                                                                                                    Status__c from IP_Declaration_Form__c 
                                                                                                    where Id in :ipDecFormIds]);
           // Add Opportunity Program in a Set
           Set<String> opptyProgIDs = new Set<String>();           
           for(IP_Declaration_Form__c ipDec : ipDecFormMap.values()){
                opptyProgIDs.add(ipDec.Device__r.Opportunity_Program__c);       
           }
           
           // get all supported roles
           set<String> setApproverRoles = new set<String>{ Environment_Variable__c.getInstance('OPPTY_PROG_TM_ROLE').Value__c,        
                                                           Environment_Variable__c.getInstance('OPPTY_PROG_TM_ROLE_FTS').Value__c,        
                                                           Environment_Variable__c.getInstance('OPPTY_PROG_TM_ROLE_PFTS').Value__c,                                                                                                                                                        
                                                           Environment_Variable__c.getInstance('OPPTY_PROG_TM_ROLE_DEIP').Value__c};
                                                           
           // retrieve the list of Opportunity Program Team Member
            List<Opportunity_Program_Team_Member__c> oppProgTMList = [select User__c, Opportunity_Program__c from Opportunity_Program_Team_Member__c 
                                                                     where (    Team_Role__c in :setApproverRoles 
                                                                            OR (Team_Role__c = 'Account Manager' AND Is_FAE__c = TRUE)
                                                                            OR (Team_Role__c = 'Primary Account Manager' AND Is_FAE__c = TRUE) )
                                                                     and Opportunity_Program__c in :opptyProgIDs  
                                                                     and User__r.IsActive = true order by Team_Role__c asc,createddate asc];
           
           // Map Opportunity Program with Users
           Map<String,List<String>> oppUsrMap = new Map<String,List<String>>();
           List<String> usrIds;           
           for(Opportunity_Program_Team_Member__c opptm : oppProgTMList){
                if(oppUsrMap.containsKey(opptm.Opportunity_Program__c)){
                    usrIds = oppUsrMap.get(opptm.Opportunity_Program__c);
                    usrIds.add(opptm.User__c);
                }else{
                    usrIds = new List<String>();
                    usrIds.add(opptm.User__c);
                    oppUsrMap.put(opptm.Opportunity_Program__c,usrIds);
                }       
           }
           
           // List of IP Declaration Form that needs to be updated with Approvers
           List<IP_Declaration_Form__c> ipDecFormList = new List<IP_Declaration_Form__c>();
           
           // List of IP Declaration Form which needs to be submitted for approval
           List<Approval.ProcessSubmitRequest> requests = new List<Approval.ProcessSubmitRequest> ();
           
           for(IP_Declaration_Form__c ipDec : ipDecFormMap.values()){
                // validate for valid status
                if(ipDec != null && (ipDec.Status__c == EnvironmentVariable.get('IP_DECLARATION_STATUS_UNDECLARED') || ipDec.Status__c == EnvironmentVariable.get('IP_DECLARATION_STATUS_DRAFT') || 
                ipDec.Status__c == EnvironmentVariable.get('IP_DECLARATION_STATUS_REASSIGNED') || ipDec.Status__c == EnvironmentVariable.get('IP_DECLARATION_STATUS_PSUBMISSION') || 
                ipDec.Status__c == EnvironmentVariable.get('IP_DECLARATION_STATUS_RECALLED'))){ 
                    // reset all approvers
                    ipDec.Step_1_Approver_1__c = null;
                    ipDec.Step_1_Approver_2__c = null;
                    ipDec.Step_1_Approver_3__c = null;
                    ipDec.Step_1_Approver_4__c = null;
                    ipDec.Step_1_Approver_5__c = null;
                    ipDec.Step_1_Approver_6__c = null;
                    ipDec.Step_1_Approver_7__c = null;
                    ipDec.Step_1_Approver_8__c = null;
                    ipDec.Step_1_Approver_9__c = null;
                    ipDec.Step_1_Approver_10__c = null;
                    
                    // Getting the list of users for the Opportunity Program
                    List<String> userIds = oppUsrMap.get(ipDec.Device__r.Opportunity_Program__c);
                    
                    // Assign Approvers from Oppotunity Program Team Members
                    if(userIds != null && userIds.size()>0){
                        integer ctr = 0;
                        for(String userId : userIds){
                            if(ctr==0){
                               ipDec.Step_1_Approver_1__c = userId;
                            }else if(ctr==1){
                                 ipDec.Step_1_Approver_2__c = userId;
                            }else if(ctr==2){
                                 ipDec.Step_1_Approver_3__c = userId;
                            }else if(ctr==3){ 
                                ipDec.Step_1_Approver_4__c = userId;
                            }else if(ctr==4){
                                ipDec.Step_1_Approver_5__c = userId;
                            }else if(ctr==5){
                                ipDec.Step_1_Approver_6__c = userId;
                            }else if(ctr==6){
                                ipDec.Step_1_Approver_7__c = userId;
                            }else if(ctr==7){
                                ipDec.Step_1_Approver_8__c = userId;
                            }else if(ctr==8){
                                ipDec.Step_1_Approver_9__c = userId;
                            }else if(ctr==9){
                                ipDec.Step_1_Approver_10__c = userId;
                            }
                            ctr++;
                        }                       
                        ipDecFormList.add(ipDec);
                        
                        // Approval Process request submission added to a list 
                        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                        req1.setObjectId(ipDec.Id);
                        requests.add(req1);
                    }                                       
                }               
           }
           
           // Update the IP Declaration Form records with Approver fields
           if(ipDecFormList.size()>0){
                update ipDecFormList;
           }
           
           // Submit the list of Approval Processes
           if(requests.size()>0){
                processResults = Approval.process(requests, true); 
           }                                                    
        }catch(Exception e){
            system.debug('Exception Message :: '+e.getMessage());
        }
        return processResults;
    }
}