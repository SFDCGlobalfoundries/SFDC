/*
    Trigger Name:  BX041Trigger
    Author:        Prosenjit Saha(PS) and Thomas Lai(TL)
    Description:   This Trigger Syncs Configuration status and bx041 status from BX041 to Device.
                   and set next approvers when request is approved/rejected.
    History: 
      PS           03072013    - Code creation.
      TL           02072013    - Code Modification.
      DBiswal      05112014    - Added conditions to update Device when Approval_Step__c is changed.
      VM           02182015    - updated the code to support the CDRS functionality for Internal Device.
      MS           06082015    - Added code to update CDRS approval user on Device using Aprover1,Approver2 and Approver 3.
      
*/

trigger BX041Trigger on BX_041__c (after insert, after update, before update) {
    if(!IntegrationUserUtil.isSkipTrigger()){
        if(trigger.isbefore){
            for(BX_041__c bx041 : trigger.new){
                if(bx041.Approval_Action__c == 'Reject' && trigger.oldmap.get(bx041.id).Approval_Action__c != 'Reject'){
                    if(trigger.oldmap.get(bx041.id).approval_step__c == 'Pending for FAE/FTS' || trigger.oldmap.get(bx041.id).approval_step__c == 'Pending for FAE' || trigger.oldmap.get(bx041.id).approval_step__c == 'Pending for FTS'){
                        bx041.Approval_Status__c = '';
                        bx041.BX_041_Status__c = 'Pending Submission';
                        bx041.Approval_Step__c = 'Pending for Customer';
                    }else if(trigger.oldmap.get(bx041.id).approval_step__c == 'Pending for CE'){
                        if(bx041.Action_on_VF__c == true){
                            if(bx041.Initial_Submitter__c == 'Customer'){//auto submission to FAE/FTS on behalf of Customer
                                bx041.Approval_Status__c = '';
                                bx041.BX_041_Status__c = 'Pending Submission';
                                bx041.Approval_Step__c = 'Pending for Customer(AutoSubmission)';
                            }else { // pending for FAE/FTS manual submission
                                System.debug('In rejectReq ---------------'+bx041.Approval_Status__c);
                                if(String.isNotBlank(bx041.Approval_Status__c)){
                                    bx041.Approval_Status__c = 'Approved by FAE/FTS';
                                    bx041.Approval_Step__c = 'Pending for FAE/FTS';
                                }else{
                                    bx041.Approval_Status__c = '';
                                    bx041.Approval_Step__c = '';
                                }
                                bx041.BX_041_Status__c = 'Pending Submission';
                            }
                        } else {//reject from homepage, pending for FAE/FTS manual submission
                            //updated by Vijay 02172015 
                            System.debug('In rejectReq ---------------'+bx041.Approval_Status__c);
                            if(String.isNotBlank(bx041.Approval_Status__c)){
                                bx041.Approval_Status__c = 'Approved by FAE/FTS';
                                bx041.Approval_Step__c = 'Pending for FAE/FTS';
                            }else{
                                bx041.Approval_Status__c = '';
                                bx041.Approval_Step__c = '';
                            }
                            bx041.BX_041_Status__c = 'Pending Submission';
                        }
                        
                    }else if(trigger.oldmap.get(bx041.id).approval_step__c == 'Pending for PIYE'){
                        if(bx041.Action_on_VF__c == true){//auto submission to CE
                            //updated by Vijay 02182015
                            if(String.isNotBlank(bx041.Approval_Status__c)){
                                bx041.Approval_Status__c = 'Approved by FAE/FTS';
                                bx041.Approval_Step__c = 'Pending for FAE/FTS(AutoSubmission)';
                            }else{
                                bx041.Approval_Status__c = '';
                                bx041.Approval_Step__c = 'Pending for CE(AutoSubmission)';
                            }
                            bx041.BX_041_Status__c = 'Pending Submission';
                        }else {// reject from homepae
                            bx041.Approval_Status__c = 'Approved by CE';
                            bx041.BX_041_Status__c = 'Pending Review';
                            bx041.Approval_Step__c = 'Pending for CE';
                        }
                    }
                    bx041.Next_WorkItem_Id__c = null;
                    bx041.Backtrack_Request__c = null;
                    bx041.Action_on_VF__c = false;
                    bx041ApprovalHelper.clearApprovers(bx041);
                }else if(bx041.Approval_Action__c == 'Approve' && trigger.oldmap.get(bx041.id).Approval_Action__c != 'Approve'){
                    if(trigger.oldmap.get(bx041.id).approval_step__c == 'Pending for FAE/FTS'  ||trigger.oldmap.get(bx041.id).approval_step__c == 'Pending for FAE'  || trigger.oldmap.get(bx041.id).approval_step__c == 'Pending for FTS'){
                        bx041.Approval_Step__c = 'Pending for FAE/FTS';
                        bx041.Approval_Status__c = 'Approved by FAE/FTS';
                        //bx041.BX_041_Status__c = 'Pending Submission';
                    }else if(trigger.oldmap.get(bx041.id).approval_step__c == 'Pending for CE'){
                        bx041.Approval_Status__c = 'Approved by CE';
                        //bx041.BX_041_Status__c = 'Pending Review';
                        bx041.Approval_Step__c = 'Pending for CE';
                        
                    }else if(trigger.oldmap.get(bx041.id).approval_step__c == 'Pending for PIYE'){
                        bx041.Approval_Status__c = 'Approved by PI/YE';
                        bx041.BX_041_Status__c = 'Frozen/Pending PID Assignment';
                        bx041.Approval_Step__c = 'Approved';
                    }
                   
                   bx041.Action_on_VF__c = false;
                   bx041.Next_WorkItem_Id__c = null;
                   bx041.Backtrack_Request__c = null;
                }
            }
        }
        else if(trigger.isAfter){
        //Map to fetch Approver1,Approver2 and Approver3.
        
         Map<Id, BX_041__c> CDRSMap 
                    = new Map<Id, BX_041__c>([SELECT Id
                                                        , Approver_1__r.HCM_Login_ID__c
                                                        ,Approver_2__r.HCM_Login_ID__c
                                                        ,Approver_3__r.HCM_Login_ID__c
                                                    FROM BX_041__c
                                                    WHERE Id IN :Trigger.New]);
            
            /* sync configuration status, bx041 status, request PID & assigned PID onto device  ==> Start */
            list<Device__c> deviceList = new list<Device__c>();
            Set<id> bx041Set = new Set<id>();
            
            for(Integer i=0;i< trigger.new.size();i++){
                Device__c device;
                if(trigger.isInsert && trigger.new[i].device__r.Copy_Device_Link__c == NULL){
                    device = new Device__c(id = trigger.new[i].device__c, 
                                                      //Configuration_Status__c = trigger.new[i].Configuration_Status__c, 
                                                      BX041_Status__c = trigger.new[i].BX_041_Status__c, 
                                                      IP_Gap__c = trigger.new[i].GAP_Closed__c);
                    //09-27-2013: added process ID and IP GAP as per part of new req
                    //7/10/2013 Thomas: updated to fix issue - when copying device, requested PID is cleared on Device
                    if(trigger.new[i].Assigned_Process_ID__c != null && trigger.new[i].device__r.Assigned_Process_ID__c != trigger.new[i].Assigned_Process_ID__c ){
                        device.Assigned_Process_ID__c = trigger.new[i].Assigned_Process_ID__c;
                    }
                    if(trigger.new[i].Requested_Process_ID__c != null && trigger.new[i].device__r.Requested_Process_ID__c != trigger.new[i].Requested_Process_ID__c){
                        device.Requested_Process_ID__c = trigger.new[i].Requested_Process_ID__c;
                    }
                    
                    deviceList.add(device);
                }else if(trigger.isUpdate){
                    system.debug('inside cdrs2');
                    if(//trigger.new[i].Configuration_Status__c != trigger.old[i].Configuration_Status__c || //configuration status was changed
                       trigger.new[i].BX_041_Status__c != trigger.old[i].BX_041_Status__c ||  // bx041 status was changed
                       //trigger.new[i].GAP_Closed__c != trigger.old[i].GAP_Closed__c ||   
                       trigger.new[i].Assigned_Process_ID__c != trigger.old[i].Assigned_Process_ID__c  ||
                       trigger.new[i].Requested_Process_ID__c != trigger.old[i].Requested_Process_ID__c ||
                       trigger.new[i].Approval_Step__c != trigger.old[i].Approval_Step__c ){
                           system.debug('inside cdrs3');
                            Device = new Device__c(id = trigger.new[i].device__c);
                            //09-27-2013: added process ID and IP GAP as per part of new req
							/*
                            if(trigger.new[i].Configuration_Status__c != trigger.old[i].Configuration_Status__c){
                                device.Configuration_Status__c = trigger.new[i].Configuration_Status__c;
                            } */
                            
                            if(trigger.new[i].BX_041_Status__c != trigger.old[i].BX_041_Status__c){
                                device.BX041_Status__c = trigger.new[i].BX_041_Status__c;
                            }
                            /*
                            if(trigger.new[i].GAP_Closed__c != trigger.old[i].GAP_Closed__c){
                                device.IP_Gap__c = trigger.new[i].GAP_Closed__c;
                            }
                            */
                            if(trigger.new[i].Assigned_Process_ID__c != trigger.old[i].Assigned_Process_ID__c ){
                                device.Assigned_Process_ID__c = trigger.new[i].Assigned_Process_ID__c;
                            }
                            if( trigger.new[i].Requested_Process_ID__c != trigger.old[i].Requested_Process_ID__c ){
                                device.Requested_Process_ID__c = trigger.new[i].Requested_Process_ID__c;
                            }                            
                            // 05112014 DBiswal - Added conditions to get Device ID when Approval_Step__c is changed.
                            if( trigger.new[i].Approval_Step__c == 'Pending for PIYE' || trigger.new[i].Approval_Step__c == 'Approved' ){
                                device.BX041_Status__c = trigger.new[i].BX_041_Status__c;
                            }
                            
                            deviceList.add(device);
                            system.debug('Update device' + device.name+'+++'+deviceList);
                       }
                   // 18/10/2013  added: New req - send emails to CE&FTS when bx041 is closed
                    if(trigger.new[i].BX_041_Status__c == 'Closed' && trigger.new[i].BX_041_Status__c != trigger.old[i].BX_041_Status__c){
                        Bx041Set.add(trigger.new[i].id);
                    }
                    // Fronzon/PID bx041s that need alert.
                    if(trigger.new[i].BX_041_Status__c == 'Frozen/Pending PID Assignment' && trigger.old[i].BX_041_Status__c == 'Pending Acknowledgement'){
                        Bx041Set.add(trigger.new[i].id);    
                    } 
                    
                    // 18/11/10 Thomas added: new req - send email to AM/CSR when CDRS statuc changed from pending review to pending acknoledgement
                    if(trigger.new[i].BX_041_Status__c == 'Pending Acknowledgement' && trigger.old[i].BX_041_Status__c == 'Pending Review'){
                        Bx041Set.add(trigger.new[i].id);
                    } 
                    
                    //rejected bx041s that need alert.
                    if(trigger.new[i].approval_action__c == 'Reject' && trigger.old[i].approval_action__c != 'Reject'){
                        if( trigger.new[i].approval_step__c == 'Pending for CE' || trigger.new[i].approval_step__c == 'Pending for FAE/FTS'
                            || trigger.new[i].approval_step__c == 'Pending for Customer(AutoSubmission)' || trigger.new[i].approval_step__c == 'Pending for FAE/FTS(AutoSubmission)'
                            || trigger.new[i].approval_step__c == 'Pending for Customer'){
                            Bx041Set.add(trigger.new[i].id);
                        } 
                            
                    } 
                    
                        //Added to implement CDRS approver user updation on Device using Aprover1,Aprover2,Approver3 on CDRS.
                        
                        BX_041__c CDRSDevice = CDRSMap.get(trigger.new[i].id);
                        string CDRSApprovalUser ='';
                        If ((trigger.new[i].Approval_Status__c =='Approved by PI/YE' || trigger.new[i].Approval_Status__c =='Approved by CE') &&(trigger.new[i].Approval_Step__c =='Approved' || trigger.new[i].Approval_Step__c =='Pending for PIYE'))
                        if (CDRSDevice.Approver_1__r.HCM_Login_ID__c != Null) {
                            CDRSApprovalUser = CDRSDevice.Approver_1__r.HCM_Login_ID__c ;
                        }
                         if (CDRSDevice.Approver_2__r.HCM_Login_ID__c != Null) {
                            CDRSApprovalUser += ',' + CDRSDevice.Approver_2__r.HCM_Login_ID__c;
                        }
                        if (CDRSDevice.Approver_3__r.HCM_Login_ID__c != Null) {
                            CDRSApprovalUser += ',' +CDRSDevice.Approver_3__r.HCM_Login_ID__c;
                        }
                        
                        if(Device!=null) Device.CDRS_approval_User__c = CDRSApprovalUser;
                        else Device=new device__c(id = trigger.new[i].device__c,CDRS_approval_User__c=CDRSApprovalUser);
                        
                       // deviceList.add(device);
                        
                
                }
                
            }
            system.debug('Test is running: '+Test.isRunningtest());
            if(!deviceList.isEmpty() && !Test.isRunningtest() ){
                update deviceList;
            }
            
            /* sync configuration status, bx041 status, request PID & assigned PID onto device  ==> End */
            
            /* Send Emails alert when bx041 is clodes  ==> Start */
            if(!Bx041Set.isEmpty()){
                map<string, list<BX_041__c> > bx041Map = new map<string, list<BX_041__c> > ();
                bx041Map.put('GF_Device_Requirements_Closed_Template', new list<BX_041__c>());
                bx041Map.put('GF_Device_Frozen_Pending_PID_Assignment_Template', new list<BX_041__c>());
                bx041Map.put('GF_Device_Requirements_Rejected_Email_Template_4FAEFTS',new list<BX_041__c>());
                bx041Map.put('GF_Device_Requirements_Rejected_Email_Template_4CE',new list<BX_041__c>());
                bx041Map.put('GF_Device_Requirements_Rejected_Email_Template_4Customer',new list<BX_041__c>());
                bx041Map.put('GF_Device_Requirement_PO_Issuance_Approved_Template',new list<BX_041__c>());
                
                for(BX_041__c Bx041 : [Select id,
                                                          device__r.Account__c, // stackholder
                                                          device__r.Account__r.Name,
                                                          device__r.Account__r.region__c,
                                                          device__r.Name,
                                                          device__r.Device_ID__c,
                                                          device__r.Account_Short_Name__c,
                                                          device__r.Opportunity2__r.Name,
                                                          device__r.CRMDID__c,
                                                          device__r.Forecasted_GDSII_Date__c,
                                                          device__r.Fab__c,
                                                          device__r.Geometry__c,
                                                          device__r.Tapeout_Type__c, // CE approver
                                                          approver_1__c,
                                                          approver_2__c,
                                                          approver_3__c,
                                                          BX_041_Status__c,
                                                          Backtrack_Request__c,
                                                          approval_step__c,
                                                          Approval_Action__c,
                                                          createdbyid
                                                          
                                                    From BX_041__c
                                                    Where id in : Bx041Set]){
                    
                    if(bx041.BX_041_Status__c == 'Closed'){
                        bx041Map.get('GF_Device_Requirements_Closed_Template').add(bx041);
                    } else if(bx041.BX_041_Status__c == 'Pending Acknowledgement'){
                        // 18/11/13 Thomas Added: new req - send email to AM/CSR when CDRS statuc changed from pending review to pending acknoledgement
                        bx041Map.get('GF_Device_Requirement_PO_Issuance_Approved_Template').add(bx041);
                    } else if(bx041.BX_041_Status__c == 'Frozen/Pending PID Assignment'){
                        bx041Map.get('GF_Device_Frozen_Pending_PID_Assignment_Template').add(bx041);
                    } else if(bx041.approval_action__c == 'Reject'){
                        if(bx041.approval_step__c == 'Pending for FAE/FTS' || bx041.approval_step__c == 'Pending for Customer(AutoSubmission)' ){
                            bx041Map.get('GF_Device_Requirements_Rejected_Email_Template_4FAEFTS').add(bx041);
                        }else if(bx041.approval_step__c == 'Pending for CE' || bx041.approval_step__c == 'Pending for FAE/FTS(AutoSubmission)'){
                            bx041Map.get('GF_Device_Requirements_Rejected_Email_Template_4CE').add(bx041);
                        }else if(bx041.approval_step__c == 'Pending for Customer'){
                            bx041Map.get('GF_Device_Requirements_Rejected_Email_Template_4Customer').add(bx041);
                        }
                    }               
                }
                
                BX041EmailHandler.sendEmailAllInOne(bx041Map);
            }
            /** Send Emails alert when bx041 is clodes  ==> End **/
        }
    }
}