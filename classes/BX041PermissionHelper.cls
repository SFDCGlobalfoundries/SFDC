/**********************************************************************************************************************
    Class Name:    BX041PermissionHelper 
    Author:        Thomas Lai(TL) and Prosenjit Saha(PS)
    Description:   This Class manages permission on BX041 View Page.
    History: 
      TL           15082013    - Code creation.
      PS           11272013    - Code Modification
      TL           06122013    - Code Modifcation
      TL           23052014    - Changed logic to allow FAE or sysadmin to update closed cdrs
      TL           23062014    - Changed logic to allow Authorized Portal user to edit CDRS
      TL           09072014    - Added logic allowing FAE to reopen CDRS   
      VM       02232015     - updated the code to support the Internal Device CDRS functionality. added InternalDevice check to skip to the exsisting code and 
                     invoke the Internal Device CDRS approval process related functionality.
      
**********************************************************************************************************************/
public class BX041PermissionHelper{
    /*
    Method :        Set permission based on user profile
    Paremeter:      ID - BX041 ID 
                    ID - User ID
                    String - Profile Name
    Return Type:    List<Boolean> - Permission list 
    */
    
    public static list<boolean> getPermissions(Id bx041Id, Id userId, String profile) {
        
        boolean editable = true;
        boolean submitable = false;
        boolean piyeSltBtnVisible = false;
        boolean approvable = false;
        boolean rejectable = false;
        boolean backtrackable = false;
        boolean reopenable = false;
        
        boolean isCustomer = false;
        boolean isAuthorizedCustomer = false;//TLai 23062014
        boolean isAdmin = false;
        if(profile.contains('Portal')) {
            isCustomer = true;
            list<Portal_Tab_Access__c> ptaList = [select id from Portal_Tab_Access__c where User__c = :UserInfo.getUserId() and Change_request_report__c = true];
            if(ptaList.size() > 0){
                isAuthorizedCustomer = true;
            } else{
                editable = false;
            }
        } else{
            isCustomer = false;
            if(profile.contains('Admin')){
                isAdmin = true;
            } else {
                isAdmin = false;
            }
        }
           
        BX_041__c bx041 = [select   id,
                                    Approval_Status__c,
                                    Next_WorkItem_Id__c,
                                    device__r.Account__c,
                                    Device__r.Account__r.Region__c,
                                    device__r.Tapeout_Type__c,
                                    device__r.fab__c,
                                    Device__r.Proto_Lot_Start_ID__c,
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
                                    No_of_CE_Approver__c,
                                    BX_041_Status__c,
                                    Initial_Submitter__c,
                                    Approval_Step__c,
                                    Owner__c,
                                    Backtrack_Request__c,
                                    Device__r.OwnerId,
                                    Device__r.RecordType.DeveloperName,
                                    Device__r.Account__r.OwnerId
                            from BX_041__c 
                            where   id = :bx041Id];
                            
        boolean hasWorkItem = !String.isEmpty(bx041.Next_WorkItem_Id__c);
        /*  1. edit button --> editable  open to all profiles
            2. submit button --> submitable
            3. piyeSltBtnVisible button --> piyeSltBtnVisible
            4. approve button --> approvable
            5. reject button --> rejectable
            6. backtrack button --> backtrackable
        */
        
        //Added by Vijay 02132015
        Boolean isInternalDevice = false;
        if(bx041.Device__r.RecordType.DeveloperName != null && (bx041.Device__r.RecordType.DeveloperName == 'Internal_Device'  ||
          bx041.Device__r.RecordType.DeveloperName == 'Internal_Device_Read_Only')){
          isInternalDevice = true;    
      }
      String accountAdminRole = (Environment_Variable__c.getInstance('ACCT_TM_PRXY_TM_RL_AA') != null ) ? Environment_Variable__c.getInstance('ACCT_TM_PRXY_TM_RL_AA').value__c : 'Account Administrator'; 
      List<String> atpRoleList = new List<String>{accountAdminRole};
      
        //if cdrs record is uploaded by dataloader then Approval status is NULL.Code has been modified to cover that scenario.
        
        if(String.isEmpty(bx041.Approval_Status__c)){//1. after customer created a form; 2. after customer submit a form 3. after FAE created a form
            if(isAdmin) {
                if(hasWorkItem){
                  if(isInternalDevice){
                    piyeSltBtnVisible = true;
                      rejectable = true;
                  }else{
                      approvable = true;
                      rejectable = true;//
                  } 
                    /*if(BX041ApprovalHelper.isIntialSubmitterFAEOrFTS(bx041.initial_submitter__c)){
                        // after CE rejection, system submit to FAE/FTS for approval
                        rejectable = false;
                    } else {
                        rejectable = true;
                    }*/
                }else if(bx041.BX_041_Status__c == 'Pending Gap Closure' || bx041.BX_041_Status__c == 'Closed' || bx041.BX_041_Status__c == 'Frozen/Pending PID Assignment' ) {
                    backtrackable = true;
                }else if(bx041.BX_041_Status__c != 'Closed'){
                    submitable = true;
                }
                
            } 
            
            //for exisiting data submitable 
            else if(!isInternalDevice && isAuthorizedCustomer && bx041.BX_041_Status__c != 'Closed'){ // creator/submiter -- customer
                if(!hasWorkItem &&  (String.isEmpty(bx041.approval_step__c) || bx041.approval_step__c == 'Pending for Customer')){
                    submitable = true;
                }
            } else if(!isInternalDevice && (profile == 'GF FAE/FTS' || profile == 'GF FAE/FTS Lite' || profile == 'GF Sales User') && bx041.BX_041_Status__c != 'Closed'){
                if(!hasWorkItem && String.isEmpty(bx041.approval_step__c) && isFTSSubmitter(bx041, userid) ){//Added condition by Tlai 7/5/14
                    submitable = true;
                    
                }else if(hasWorkItem){// Customer submitted for approval
                    if(isFAEQueueMember(bx041,userid) ||(bx041.approver_1__c != null && userid == bx041.approver_1__c)){
                        approvable = true;
                        rejectable = true;
                        /*if(bx041.initial_submitter__c == 'Customer'){
                            rejectable = true;
                        } else{
                            rejectable = false;
                        }*/
                    }
                }
            }
            else if((profile == 'GF PIYE Platform' || profile == 'GF PIYE Standard' || profile =='GF PIYE Lite') && (bx041.BX_041_Status__c == 'Pending Gap Closure' || bx041.BX_041_Status__c == 'Closed' || bx041.BX_041_Status__c == 'Frozen/Pending PID Assignment' )){
                backtrackable = true;    
               System.debug('--IN GF PIYE--'+bx041.BX_041_Status__c);   
            }
            else if(!isInternalDevice && (profile == 'GF CE' || profile =='GF CE Lite')  && (bx041.BX_041_Status__c == 'Pending Gap Closure' || bx041.BX_041_Status__c == 'Closed' || bx041.BX_041_Status__c == 'Frozen/Pending PID Assignment' )){
                    backtrackable = true;     
            }
            //Added by Vijay 02132015
            else if(isInternalDevice && bx041.Approval_Step__c !='Pending for CE' && (userId == bx041.Device__r.OwnerId || isValidUser(bx041, userid, atpRoleList))){
              submitable = true;
            }
            //Added by Vijay 02132015
            else if(isInternalDevice && bx041.Approval_Step__c == 'Pending for CE'){
               if(hasWorkItem){
                 if( (profile == 'GF CE' || profile =='GF CE Lite') && hasWorkItem){
                    if(isCEApprover(bx041,userid)){
                        rejectable = true;
                        piyeSltBtnVisible = true;
                    }
                }else{ 
                   for(integer i = 1; i <= 3; i++){
                      Id approverId = (Id)bx041.get('Approver_' + i + '__c');
                        if(approverId == userId) { // current approver -- PIYE
                            if (hasWorkItem){
                                piyeSltBtnVisible = true;
                            rejectable = true;
                            }
                            
                            break;
                        }
                    }
                 }
               }
            }
            
            //Added by Vijay 02132015
            else if(isInternalDevice && userId == bx041.Device__r.Account__r.OwnerId && (bx041.BX_041_Status__c == 'Pending Gap Closure' || bx041.BX_041_Status__c == 'Closed' || bx041.BX_041_Status__c == 'Frozen/Pending PID Assignment')){
              backtrackable = true;
              System.debug('--IN GF PIYE--'+bx041.BX_041_Status__c);
            }
            
            //tlai 23052014
            if(bx041.BX_041_Status__c == 'Closed' && ! isAdmin && (profile != 'GF FAE/FTS' || isFTSSubmitter(bx041, userid) == false)) {
                editable = false;
            }
        } else if(!isInternalDevice && BX041ApprovalHelper.approvedByFAEOrFTS(bx041.Approval_Status__c)){// submit to FTS or backtrack to FTS or reject from
            if(isAdmin) {
                if(hasWorkItem){
                    piyeSltBtnVisible = true;
                    rejectable = true;
                    
                }else if(bx041.BX_041_Status__c != 'Closed'){
                    submitable = true;
                }
            } else if( (profile == 'GF FAE/FTS' || profile =='GF FAE/FTS Lite' || profile == 'GF Sales User') && !hasWorkItem){
                //if( bx041.BX_041_Status__c == 'Pending Submission' ){
                    if( isFAEQueueMember(bx041,userid) 
                          ||(bx041.approver_1__c != null && userid == bx041.approver_1__c)
                          || isFTSSubmitter(bx041, userid)
                     ){
                        submitable = true;
                    }
                    
               // }
                    
            } else if( (profile == 'GF CE' || profile =='GF CE Lite') && hasWorkItem){
                if(isCEApprover(bx041,userid)){
                    rejectable = true;
                    piyeSltBtnVisible = true;
                }
            } 
        } else if(bx041.Approval_Status__c == 'Approved by CE' ){
            if(isAdmin) {
                if(hasWorkItem){
                    approvable = true;
                    rejectable = true;
                }else {
                    piyeSltBtnVisible = true;
                }
            } else if( (profile == 'GF CE' || profile =='GF CE Lite') && !hasWorkItem){
                
                if(isCEApprover(bx041,userid)){
                    piyeSltBtnVisible = true;
                }
                    
          } else if( (profile == 'GF PIYE Platform' || profile == 'GF PIYE Standard') && hasWorkItem){
                for(integer i = 1; i <= 3; i++){
                    Id approverId = (Id)bx041.get('Approver_' + i + '__c');
                    if(approverId == userId) { // current approver -- PIYE
                        if (hasWorkItem){
                            rejectable = true;
                            approvable = true;
                        }
                        
                        break;
                    }
                }
            }else if(isInternalDevice && !hasWorkItem && userId == bx041.Device__r.Account__r.OwnerId){
              piyeSltBtnVisible = true;
            }
        } 
        
        else if(bx041.Approval_Status__c == 'Approved by PI/YE' ){//-  Once PI/YE approved (acknowledged) we lock the BX041 form.
            if(isAdmin && (bx041.BX_041_Status__c == 'Pending Gap Closure' ||bx041.BX_041_Status__c == 'Closed' || bx041.BX_041_Status__c == 'Frozen/Pending PID Assignment' )) {
                backtrackable = true;
                
            } else if( (profile == 'GF PIYE Platform' || profile =='GF PIYE Standard' || profile =='GF PIYE Lite') && (bx041.BX_041_Status__c == 'Pending Gap Closure' || bx041.BX_041_Status__c == 'Closed' || bx041.BX_041_Status__c == 'Frozen/Pending PID Assignment' )) {
                 for(integer i = 1; i <= 3; i++){
                    Id approverId = (Id)bx041.get('Approver_' + i + '__c');
                    if(approverId == userId) { // current approver -- PIYE
                        backtrackable = true;
                        break;
                    }
                }
            }
            /************chaged as per task TASK-323 *******************/
            else if( (profile == 'GF CE' || profile == 'GF CE Lite') && (bx041.BX_041_Status__c == 'Pending Gap Closure' || bx041.BX_041_Status__c == 'Closed' || bx041.BX_041_Status__c == 'Frozen/Pending PID Assignment' )){
                if(isCEApprover(bx041,userId)){
                    backtrackable = true;     
                }
            }
            //Tlai 23052014
             if(bx041.BX_041_Status__c == 'Closed' && ! isAdmin && (profile != 'GF FAE/FTS' || isFTSSubmitter(bx041, userid) == false)) {
                editable = false;
            }
            
           
        }
        
        
         //Tlai 09072014 added logic allowing FAE to reopen CDRS
         //Bhanu 25012015 Added logic to stop reopening CDRS by the fae if the proto lot is null
        if(bx041.BX_041_Status__c != 'Pending Submission' ){
            if(!isInternalDevice){
              if( isAdmin || (bx041.Device__r.Proto_Lot_Start_ID__c == null && ( (profile == 'GF FAE/FTS' || profile =='GF FAE/FTS Lite' || profile == 'GF Sales User') && (isFAEQueueMember(bx041,userid) || isFTSSubmitter(bx041, userid)))) )
                  reopenable = true;
              
              if(isCustomer)
                  editable = false;
            }else{
               if( isAdmin || userId == bx041.Device__r.OwnerId || isValidUser(bx041, userid, atpRoleList)){
                 reopenable = true;
               }
            }
        
        } 
        System.debug('-editable--'+editable +'--submitable--'+ submitable+'--piyeSltBtnVisible--'+piyeSltBtnVisible+'--approvable-- '+approvable
        +'--rejectable--'+rejectable+'--backtrackable-- '+ backtrackable+'--reopenable-- '+reopenable);
        return new boolean[]{editable, submitable, piyeSltBtnVisible,approvable,rejectable, backtrackable, reopenable};
    }
    private static boolean isFTSSubmitter(BX_041__c bx041, Id userId){
        List<String> ftsRoleList = new String[]{Environment_Variable__c.getInstance('ACCT_TM_PRXY_TM_RL_PFTS').value__c,
                                                Environment_Variable__c.getInstance('ACCT_TM_PRXY_TM_RL_FTS').value__c,
                                                Environment_Variable__c.getInstance('ACCT_TM_PRXY_TM_RL_FAE').value__c };
      /*modified by jabee */
     /* Integer result = [select count() 
                                from Account_Team_Proxy__c 
                                where User__c = :userId
                                    and Account__c = : bx041.Device__r.Account__c 
                                    and Team_Role__c in :ftsRoleList]; */
    
        Integer result = [SELECT count() 
                            FROM Account_Team_Proxy__c 
                            WHERE User__c = :userId
                                AND Account__c = : bx041.Device__r.Account__c 
                                AND (    Team_Role__c in :ftsRoleList
                                    OR ( Team_Role__c = 'Account Manager' AND Is_FAE__c = TRUE)
                                    OR ( Team_Role__c = 'Primary Account Manager' AND Is_FAE__c = TRUE))];
        if(result > 0){// FTS user can submit
            return true;
        }else {
            return false;
        }
    }
    private static boolean isFAEQueueMember(BX_041__c bx041, Id userId){
        String faeQueueName = 'BX041 FAE-'+ bx041.Device__r.Account__r.Region__c +' Approver Queue';
                               
        Integer result =  [SELECT count() 
                                            FROM GroupMember 
                                            where  group.type = 'Queue' 
                                               and group.name = : faeQueueName
                                               and UserOrGroupId = :userId];
        if(result > 0){// FAE queue member can submit
            return true;
        }else {
            return false;
        }
    }
    private static boolean isCEApprover(BX_041__c bx041, Id userId) {
        boolean isMPW = false;
        String ceQueueName = '';
        if(bx041.device__r.Tapeout_Type__c == 'GlobalShuttle MPW'){
            isMPW = true;
            string seq = '';
            if(bx041.device__r.fab__c == 'FAB 1'){
                seq = '1';
            }else if (bx041.device__r.fab__c == 'FAB 8'){
                seq = '8';
            }
            
            ceQueueName = 'BX041 CE-FAB' + seq +' Approver Queue';  
        }
        
        if(isMPW ) {// current approver -- CTS Queue
            Integer result =  [SELECT count() 
                                FROM GroupMember 
                                where  group.type = 'Queue' 
                                   and group.name = : ceQueueName
                                   and UserOrGroupId = :userId];
            if(result > 0){
                return true;
            }
        
            
        } else { //  current approve -- CE
             //TL 06122013 : Add criteria  bx041.Approval_Status__c == 'Approved by CE', because CE cannot see submit button after pIYE rejection from approval history  
            if(bx041.Approval_Status__c == 'Approved by PI/YE' || bx041.Approval_Status__c == 'Approved by CE'){ // for CE backtrack senario
                String roleName1 = Environment_Variable__c.getInstance('ACT_TM_PRXY_TM_RL_CE').value__c;
                String fabConditon = bx041.device__r.Fab__c ;
                Integer cnt = [select count() from Account_Team_Proxy__c 
                                                        where Account__c = :bx041.device__r.Account__c 
                                                        and Fab_Assignment__c includes( :fabConditon) 
                                                        and Team_Role__c = :roleName1 
                                                        and User__c = :userId
                                                        ];
                if(cnt > 0){
                    return true;                    
                }
            } else{ // for CE approver 
                for(integer i = 1; i <= bx041.No_of_CE_Approver__c; i++){
                    Id approverId = (Id)bx041.get('Approver_' + i + '__c');
                    if(approverId == userId) {
                        return true;
                    }
                }
            }
            
        }
        
        return false;
    }
    
    private static Boolean isValidUser(BX_041__c bx041, Id userId, List<String> atpRoleList){
       Integer result = [SELECT  count() 
                           FROM    Account_Team_Proxy__c 
                           WHERE  User__c = :userId AND Account__c = : bx041.Device__r.Account__c AND Team_Role__c IN : atpRoleList];
        if(result > 0){
          // Account Administrator can submit
            return true;
        }else {
            return false;
        }
    }
}