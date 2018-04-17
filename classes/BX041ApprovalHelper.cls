/*
    Class Name:    BX041ApprovalHelper 
    Author:        Prosenjit Saha(PS) and Thomas Lai(TL)
    Description:   This Class manages Approval process for BX041.
    History: 
      TL           15082013    - Code creation.
      PS           11192013    - Code Modification.
      VM           02232015    - updated the code to support the Internal Device CDRS functionality. added InternalDevice check to skip to the exsisting code and 
                                 invoke the Internal Device CDRS approval process related functionality.
      SA           09162015    - code modified by Sunil Arora for case # 46750 to create share record for base device

*/
public class BX041ApprovalHelper{
    /*
    Method :        Approve/Reject aprroval Request
    Paremeter:      ID - workItem ID 
                    String - Action
                    String - Comment
    Return Type:    Boolean - result of Approve/Reject action
    */
    private boolean changeRequest(Id workItemId, String action, String comment) {
        list<ProcessInstanceWorkitem> piwList = [select id from ProcessInstanceWorkitem where id = : workItemId];
        if(piwList.isEmpty())return false;              
       
        Approval.ProcessWorkitemRequest pwr = new Approval.ProcessWorkitemRequest();
        System.debug('@@@@@@@@@@@@@@@@pwr @@@'+pwr + '@@@@@@'+ workItemId );
        System.debug('@@@@@@@@@@@@@@@@Comments @@@'+comment+ '@@@@@@action@@'+ action);
        pwr.setComments(comment);
        pwr.setAction(action);
        pwr.setWorkitemId(workItemId);        
        if(action =='Removed' && comment ==null)
        {
            Approval.process(pwr,false);
            return true;
        }
        else
        {
        Approval.ProcessResult result =  Approval.process(pwr);
        System.debug('@@@@@@@@@@@@@@@@result @@@'+result  );
        return result.isSuccess();
        }
        
    }
    /*
    Method :        Recall aprroval Request
    Paremeter:      BX_041__c - BX041
                    String - Comment
    Return Type:    String - message of result
    */
    public void recallReq(BX_041__c bx041, string comment){
        changeRequest(bx041.next_Workitem_Id__c, 'Removed', comment);       
    }
    /*
    Method :        Reject aprroval Request
    Paremeter:      ID - BX041 ID 
                    String - Comment
    Return Type:    String - message of result
    */
    public String rejectReq(Id bx041Id, string comment){
        BX_041__c bx041 = [select id,Next_WorkItem_Id__c, Action_on_VF__c, Device__r.RecordType.DeveloperName from BX_041__c where id = : bx041Id ];
        if(String.isEmpty(bx041.Next_WorkItem_Id__c)) return 'Unable to reject the CDRS, please refresh the page.';
        
        bx041.Action_on_VF__c = true;

        //Added by Vijay 02172015 
        if(bx041.Device__r.RecordType.DeveloperName != null && (bx041.Device__r.RecordType.DeveloperName == 'Internal_Device' || bx041.Device__r.RecordType.DeveloperName =='Internal_Device_Read_Only')){
            System.debug('rejectReq in Customer Device loop ----');
            System.debug('In rejectReq ---------------'+bx041);
            bx041.Approval_Status__c ='';
        }
        
        update bx041;
       
        boolean isSuccess = false;
        try{
            isSuccess =  changeRequest(bx041.Next_WorkItem_Id__c,'Reject',comment);
        }catch(Exception ex) {isSuccess = false; return ex.getMessage();}
                    
        if(isSuccess ){
            bx041 = [select Id, Approval_Step__c,BX_041_Status__c,Approval_Status__c
                        from BX_041__c
                        where id = :bx041Id];
            //BX041EmailHandler.sendEmailOne(bx041,'GF_Device_Requirements_Rejected_Email_Template',comment);
            System.debug('In Autosubmission ---------------'+bx041);
            if(bx041 != null && String.isNotBlank(bx041.Approval_Step__c) && bx041.Approval_Step__c.contains('AutoSubmission')) {
                try{
                    String result = submitForApproval(bx041id,'Auto Submission after rejection.', null);
                    if(result != null){
                        revertBX041(bx041);return result;
                        
                    }
                }catch(Exception ex){
                    revertBX041(bx041);return null;
                    
                }
            } 
        
            return null;
        } else   return 'Failed to reject the CDRS, please contact system admin.';
        
    }
    
    public void revertBX041(BX_041__c bx041){
        if(bx041.Approval_Status__c == 'Approved by FAE/FTS'){//rejected by PIYE and failed to auto submit to CE
            bx041.Approval_Status__c = 'Approved by CE';bx041.BX_041_Status__c = 'Pending Review';bx041.Approval_Step__c = 'Pending for CE';
            
            
        }else if(bx041.Approval_Status__c == ''){//Reject by CE and faild to auto submit to FAE/FTS
            bx041.Approval_Status__c = 'Approved by FAE/FTS';bx041.BX_041_Status__c = 'Pending Submission';bx041.Approval_Step__c = 'Pending for FAE/FTS';
            
            
        }
        update bx041;
    }
    /*
    Method :        Approve aprroval Request
    Paremeter:      ID - BX041 ID 
                    String - Comment
    Return Type:    String - message of result
    */
    public String approveReq(Id bx041Id, string comment){

        BX_041__c bx041 = [select id,Next_WorkItem_Id__c from BX_041__c where id = : bx041Id ];
        
        if(String.isEmpty(bx041.Next_WorkItem_Id__c)) return 'Unable to approve the CDRS, please refresh the page.';
        
        boolean isSuccess = false;
        try{
            isSuccess =  changeRequest(bx041.Next_WorkItem_Id__c,'Approve',comment);
        }catch(Exception ex) {
            isSuccess = false;return ex.getMessage();
            
        }

        if(isSuccess){
            bx041 = [select Id, Approval_Step__c,Approval_Status__c,BX_041_Status__c
                        from BX_041__c
                        where id = :bx041Id];
                        
            if(bx041.BX_041_Status__c == 'Pending Submission') {
                try{
                    return submitForApproval(bx041Id, 'Auto Submission after approval.',null);
                } catch(Exception ex){return ex.getMessage();}

            }
            
            return null;
        } else  return 'Failed to approve the CDRS, please contact system admin.';
           
        
    }
    /*
    Method :        Submit request
    Paremeter:      ID - BX041 ID 
                    Boolean - Is reject acton
                    List<ID> - approver id list
    Return Type:    String - message of result
    */
    public String submitForApproval(id bx041Id, string comment,list<id> userList){
        
        BX_041__c bx041 = [select   Id,
                                    Approval_Status__c,
                                    BX_041_Status__c,                                   
                                    Next_WorkItem_Id__c,
                                    No_of_CE_Approver__c,
                                    Approver_1__c,
                                    Approver_2__c,
                                    Approver_3__c,
                                    Approver_4__c,
                                    Approver_5__c,
                                    Approver_6__c,
                                    Approver_7__c,
                                    Approver_8__c,
                                    Approver_9__c,
                                    Approver_10__c,
                                    device__r.Account__c,
                                    device__r.Fab__c,
                                    device__r.Tapeout_Type__c,
                                    Device__r.RecordType.DeveloperName,
                                    Device__r.Account__r.OwnerId                                                               
                                from BX_041__c
                                where id = :bx041Id
                                for update
                                    ];
        boolean updateFlag = false;
        
        //Added by Vijay 02132015
        Boolean isInternalDevice = false;
        if(bx041 != null && bx041.Device__r.RecordType.DeveloperName != null && (bx041.Device__r.RecordType.DeveloperName == 'Internal_Device'  ||
            bx041.Device__r.RecordType.DeveloperName == 'Internal_Device_Read_Only')){
            isInternalDevice = true;        
        }
        
        Savepoint sp = Database.setSavepoint();
        if(!String.isEmpty(bx041.Next_WorkItem_Id__c)) return 'Request is already submitted, please refresh page.';
            
        
        system.debug('22222' + bx041.BX_041_Status__c);
        system.debug('bx041.Approval_Status__c-----------' + bx041.Approval_Status__c);
        system.debug('isInternalDevice-----------' + isInternalDevice);
        if(!isInternalDevice && String.isEmpty(bx041.Approval_Status__c) ){// Customer submits
            if(!setFTSApprover(bx041)){ return 'Primary FTS or FTS not found in Account Team Proxy.';}
                               
            if(bx041.BX_041_Status__c != 'Pending Submission') { bx041.BX_041_Status__c = 'Pending Submission';}
                            
            updateFlag = true;
        }else if(!isInternalDevice && BX041ApprovalHelper.approvedByFAEOrFTS(bx041.Approval_Status__c) ){// FAE/FTS submits
            if(bx041.BX_041_Status__c == 'Pending Submission'){
                bx041.BX_041_Status__c = 'Pending Review';
                updateFlag = true;
            }
            if(bx041.device__r.Tapeout_Type__c != 'GlobalShuttle MPW' ){// Non-MPW device should be approved by CE users presenting in account team proxy
                if(!setCEApprover(bx041) ){ return 'No CE assigned for '+ bx041.device__r.Fab__c +' found in Account Team Proxy.'; }
              
                updateFlag = true;
            }
            
        }else if(bx041.Approval_Status__c == 'Approved by CE' && userList != null){// CE submits
            if(bx041.BX_041_Status__c == 'Pending Review'){
                bx041.BX_041_Status__c = 'Pending Acknowledgement';
            }
            clearApprovers(bx041);
            
            for(integer i = 1 ; i<= userList.size(); i++){
                bx041.put('Approver_'+ i +'__c', userList[i-1]);
            }
            bx041.No_of_CE_Approver__c = userList.size();
            updateFlag = true;
        }else if(isInternalDevice && String.isEmpty(bx041.Approval_Status__c)){
            //Added by Vijay 02132015
            system.debug('bx041.Approval_Status__c-----------' + bx041.Approval_Status__c);
            if(bx041.BX_041_Status__c == 'Pending Submission'){
                bx041.BX_041_Status__c = 'Pending Review';
                updateFlag = true;
            }
            if(bx041.device__r.Tapeout_Type__c != 'GlobalShuttle MPW' ){
                bx041.Approver_1__c = bx041.Device__r.Account__r.OwnerId ;
                bx041.No_of_CE_Approver__c = 1;
            }
        }
        system.debug('bx041.Approval_Status__c-----------' + bx041);
        update bx041;
        
        if(String.isEmpty(comment)){ comment = 'Submit for Approval...';}
            
        
        Id workItemId = null;
        
        try{
            workItemId = submitRequest(bx041Id, comment);
            if(workItemId != null){
                //query modified by Sunil Arora for case # 46750 to create share record for base device
                bx041 = [select id,
                                Next_WorkItem_Id__c,
                                Approval_Status__c,
                                device__c,device__r.Base_Device__c,
                                device__r.ownerid                            
                         from BX_041__c 
                         where id = : bx041Id];
                bx041.Next_WorkItem_Id__c = workItemId;
                update bx041;
                
                if((bx041.Approval_Status__c == 'Approved by CE' || bx041.Approval_Status__c == 'Approved by Account Owner') && userList != null){
                    shareDevicePIYEUsers(bx041,userList);       
                }
                
                return null;
            } else { return 'Failed to submit the CDRS, please contact system admin';}
                
            
        }catch(Exception ex){
            database.rollback(sp);return ex.getMessage();
            
        }

    }
    
    
    /*******************************************************************************************
    @Method:        shareDevicePIYEUsers
    @Parameter:     Device ID, List of Users
    @Reruen Type:   NULL
    ********************************************************************************************/
    public void shareDevicePIYEUsers(BX_041__c bx041, List<id> PIYEusers){
        List<device__share > deivceShareList = new List<device__share >();
        for(id userid : PIYEusers){
            if(userid == bx041.device__r.ownerid){
                continue;
            }
            device__share shareRecord = new device__share();
            shareRecord.ParentId        =    bx041.Device__c;
            shareRecord.UserOrGroupId   =    userid;
            shareRecord.AccessLevel     =    'Read';
            deivceShareList.add(shareRecord );
            
            //Code added by Sunil Arora for case # 46750 to create share record for base device
            if(bx041.device__r.Base_Device__c!=null){
                device__share shareRecord2 = new device__share();
                shareRecord2.ParentId        =    bx041.device__r.Base_Device__c;
                shareRecord2.UserOrGroupId   =    userid;
                shareRecord2.AccessLevel     =    'Read';
                deivceShareList.add(shareRecord2 );
            }
            
        }
        System.debug('***deivceShareList***'+deivceShareList);
        insert deivceShareList;
        
    }
    
    
    /*
    Method :        Back track approval request
    Paremeter:      ID - BX041 ID 
    Return Type:    String - message of result
    */
    public String BackTrackApproval(Id bx041Id, String comment, String backTrackStatus){
        BX_041__c bx041 = [select   id,
                                    //BX_041_Opportunity_Program__c,
                                    device__r.Account__c,
                                    Approval_Status__c,
                                    BX_041_Status__c,
                                    Backtrack_Request__c,
                                    Approval_Step__c,
                                    Approver_1__c,
                                    Approver_2__c,
                                    Approver_3__c,
                                    Approver_4__c,
                                    Approver_5__c,
                                    Approver_6__c,
                                    Approver_7__c,
                                    Approver_8__c,
                                    Approver_9__c,
                                    Approver_10__c,
                                    device__r.Fab__c,
                                    device__r.Tapeout_Type__c,
                                    initial_submitter__c,
                                    device__r.Current_Forecast_Tapeout_Date__c,
                                    assigned_process_id__c,
                                    GAP_Closed__c,
                                    device__r.RecordType.DeveloperName,
                                    Device__r.Account__r.OwnerId
                            from BX_041__c 
                            where id = : bx041Id
                            for update
                            ];
                            
        //Added by Vijay 02132015
        Boolean isInternalDevice = false;
        if(bx041 != null && bx041.Device__r.RecordType.DeveloperName != null && (bx041.Device__r.RecordType.DeveloperName == 'Internal_Device'  ||
            bx041.Device__r.RecordType.DeveloperName == 'Internal_Device_Read_Only')){
            isInternalDevice = true;        
        }
                            
        if(!String.isEmpty(backTrackStatus) && (bx041.BX_041_Status__c == 'Closed' || bx041.BX_041_Status__c == 'Frozen/Pending PID Assignment' || bx041.BX_041_Status__c == 'Pending Gap Closure')){
            if(bx041.BX_041_Status__c == 'Closed' && bx041.device__r.Current_Forecast_Tapeout_Date__c < system.today()){ return 'Backtrack is not allow for Closed CDRS form with Current Forecast Tapeout Date in the past';}

            if(bx041.approval_step__c != 'Approved'){return 'Unable to backtrack the CDRS, please refresh page or contact system admin.'; }
           
                
            bx041.Backtrack_Request__c = backTrackStatus;
            bx041.GAP_Closed__c = false;
            if(bx041.assigned_process_id__c != null){
                bx041.assigned_process_id__c = null;
                //---------------------------PS:11192013: code change ----------------------------//
                //clearing all values of the Assigned PID(PI/YE) of the process information.
    
                List<process_information__c> ListPI = new List<process_information__c>();//final update list
                for(process_information__c pi : [SELECT id,
                                                        PIYE__c,
                                                        BX_041__c 
                                              FROM      process_information__c
                                              WHERE     BX_041__c  = :bx041.ID]){
                    pi.PIYE__c = NULL;
                    ListPI.add(pi);
                }
                update ListPI;//update all process information records. 
             }
            
            
            
            //--------------------------PS:11192013: code change ----------------------------//
            boolean submitFlag = true;        
            if(bx041.Backtrack_Request__c == 'Backtrack to FTS'){
                if(bx041.initial_Submitter__c == 'Customer'){
                    bx041.Approval_Status__c = '';
                    bx041.BX_041_Status__c = 'Pending Submission';
                    bx041.Approval_Step__c = 'Pending for Customer';
                    if(!setFTSApprover(bx041)){
                        return 'Primary FTS or FTS not found in Account Team Proxy.';
                    } 
                }else{//submit manually
                    //Added by Vijay 02172015
                    if(isInternalDevice){
                        bx041.Approval_Status__c = '';
                        bx041.Approval_Step__c = '';
                        System.debug('In If Backtrack to FTS isInternalDevice---------------------'+isInternalDevice);
                    }else{
                        bx041.Approval_Status__c = 'Approved by FAE/FTS';
                        bx041.Approval_Step__c = 'Pending for FAE/FTS';
                        System.debug('In else Backtrack to FTS Customer Device---------------------');
                    }
                    bx041.BX_041_Status__c = 'Pending Submission';
                    submitFlag = false;
                    clearApprovers(bx041);
                }
            }else if(bx041.Backtrack_Request__c == 'Backtrack to CE'){
                //Added by Vijay 02172015
                if(isInternalDevice){
                    bx041.Approval_Status__c ='';
                    clearApprovers(bx041);
                    if(bx041.device__r.Tapeout_Type__c != 'GlobalShuttle MPW' ){
                        bx041.Approver_1__c = bx041.Device__r.Account__r.OwnerId;
                        bx041.No_of_CE_Approver__c = 1;
                    }
                    System.debug('In If Backtrack to CE isInternalDevice---------------------'+isInternalDevice);
                }else{
                    bx041.Approval_Status__c = 'Approved by FAE/FTS';
                    if(!setCEApprover(bx041)){ return 'No matching CE for '+ bx041.device__r.Fab__c+' in Account Team Proxy.';}
                    System.debug('In else Backtrack to CE Customer Device---------------------');
                }
                bx041.BX_041_Status__c = 'Pending Review';
                bx041.Approval_Step__c = 'Pending for CE';
            }
            
            update bx041; 
            if(!submitFlag){ return null;}
                
            
            if(String.isEmpty(comment)){ comment = bx041.Backtrack_Request__c;}
               
            
            Id workItemId =null;
            
            try{
                workItemId = submitRequest(bx041Id, comment);
            }catch(Exception ex){
                if(bx041.Backtrack_Request__c == 'Backtrack to FTS'){//manually submit
                    if(isInternalDevice){
                        bx041.Approval_Status__c = ''; bx041.BX_041_Status__c = 'Pending Submission';bx041.Approval_Step__c = '';
                    }else{
                        bx041.Approval_Status__c = 'Approved by FAE/FTS';bx041.BX_041_Status__c = 'Pending Submission';bx041.Approval_Step__c = 'Pending for FAE/FTS';
                    }
                }else if(bx041.Backtrack_Request__c == 'Backtrack to CE'){//manually submit
                    if(isInternalDevice){
                        bx041.Approval_Status__c = ''; bx041.BX_041_Status__c = 'Pending Review'; bx041.Approval_Step__c = 'Pending for CE';
                    }else{
                        bx041.Approval_Status__c = 'Approved by CE'; bx041.BX_041_Status__c = 'Pending Review'; bx041.Approval_Step__c = 'Pending for CE';
                    } 
                }
                
                update bx041;
                return ex.getmessage();
            }
            if(workItemId != null){
                bx041 = [select   id,
                                  Next_WorkItem_Id__c,
                                  device__r.Account__c, // stackholder
                                  device__r.Account__r.Name,
                                  device__r.Account__r.region__c,
                                  device__r.Device_ID__c,
                                  device__r.Account_Short_Name__c,
                                  device__r.Opportunity2__r.Name,
                                  device__r.CRMDID__c,
                                  device__r.Forecasted_GDSII_Date__c,
                                  device__r.Fab__c,
                                  device__r.Geometry__c,
                                  device__r.Tapeout_Type__c, // CE approver
                                  Backtrack_Request__c,
                                  Device__r.Name,
                                  Approval_Step__c
                            from BX_041__c 
                            where id = : bx041Id];
                bx041.Next_WorkItem_Id__c = workItemId;
                update bx041;
                
                //send email***
               if(!test.isrunningtest())BX041EmailHandler.sendEmailOne(bx041,'GF_Device_Requirement_Backtrack_Template','');
               return null;
            } else {return 'Failed to backtrack, please contract system admin.';}
                
            
            
        } 
        
        return 'The BX041 Record cannot be backtracked.';
       
    }
    /*
    Method :        Clear all approver fields of BX041
    Paremeter:      ID - BX041 ID 
    Return Type:    NA
    */
    public static void clearApprovers(BX_041__c bx041){
        for(integer i=1;i<=10;i++){
            bx041.put('Approver_'+ i+ '__c',null);
        }
        bx041.No_of_CE_Approver__c = 0;
    }
    /*
    Method :        Set approver1 of BX041
    Paremeter:      ID - BX041 ID 
    Return Type:    Boolean - result of operation
    */
    private boolean setFTSApprover(BX_041__c bx041){
        clearApprovers(bx041);
        list<string> roleList = new list<String> {Environment_Variable__c.getInstance('ACCT_TM_PRXY_TM_RL_PFTS').value__c,
                                                  Environment_Variable__c.getInstance('ACCT_TM_PRXY_TM_RL_FTS').value__c,
                                                  Environment_Variable__c.getInstance('ACCT_TM_PRXY_TM_RL_FAE').value__c
                                                };
        Account_Team_Proxy__c[] proxy = [SELECT User__c,Team_Role__c 
                                            FROM Account_Team_Proxy__c 
                                            WHERE Account__c = :bx041.device__r.Account__c 
                                                AND (    Team_Role__c = :roleList 
                                                    OR ( Team_Role__c = 'Account Manager' AND Is_FAE__c = TRUE)
                                                    OR ( Team_Role__c = 'Primary Account Manager' AND Is_FAE__c = TRUE) )
                                                AND User__r.isActive = true
                                                ORDER BY team_role__c desc
                                                LIMIT 1];
        //Njain 08Jun16 Sorting ATP keeping PFAE on top
        proxy = Utility.getSortedFAE(proxy);
        
        if(proxy != null && proxy.size() > 0 && proxy[0].User__c != null){
            bx041.Approver_1__c = proxy[0].User__c;
            bx041.No_of_CE_Approver__c = 1;  
            return true;
        } else { return false;}
            
        
    }
    /*
    Method :        Set approvers of BX041
    Paremeter:      ID - BX041 ID 
    Return Type:    Boolean - result of operation
    */
    private boolean setCEApprover(BX_041__c bx041){
        clearApprovers(bx041);
        if(bx041.device__r.Tapeout_Type__c == 'GlobalShuttle MPW'){
            // bx041.No_of_CE_Approver__c = 1;
            return true;
        }
        
        String roleName1 = Environment_Variable__c.getInstance('ACT_TM_PRXY_TM_RL_CE').value__c;
        String fabConditon = bx041.device__r.Fab__c ;
        list<Account_Team_Proxy__c> apprlist = [select User__c 
                                                from Account_Team_Proxy__c 
                                                where Account__c = :bx041.device__r.Account__c 
                                                    and Fab_Assignment__c includes( :fabConditon) 
                                                    and Team_Role__c = :roleName1  
                                                    and User__r.isActive = true
                                                order by createddate limit 10];
        if(apprlist != null && apprlist.size() > 0 ){
            for(integer i=1; i<= apprlist.size(); i++) {
                bx041.put('Approver_'+ i+ '__c',apprlist[i-1].User__c);
            }
            bx041.No_of_CE_Approver__c = apprlist.size();
            return true;
        } else {return false;}
            
        
        
    }
    /*
    Method :        call api to submit request
    Paremeter:      ID - BX041 ID 
    Return Type:    ID - workitem id
    */
    private Id submitRequest(Id bx041Id, String comment) {
        Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
        req.setComments(comment);
        req.setObjectId(bx041Id);  
        Approval.Processresult result = Approval.process(req);
        if(result.isSuccess()){
            List<Id> newWorkItemIds = result.getNewWorkitemIds();
            system.debug('workitem size : '+newWorkItemIds.size());
            if(!newWorkItemIds.isEmpty()) {
                return newWorkItemIds.get(0);
            }
        }
        
        return null;
    }
    
    public static boolean approvedByFAEOrFTS(String approvalStatus){
        if(approvalStatus == 'Approved by FAE/FTS' || approvalStatus == 'Approved by FAE' || approvalStatus == 'Approved by FTS'){
            return true;
        } else {
            return false;
        }
    }
    
}