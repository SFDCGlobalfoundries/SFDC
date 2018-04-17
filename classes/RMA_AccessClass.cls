/**
* Company       :   Cognizant Technologies PTE Ltd.
* Description   :   Functionality to control the accessibility of the fields and tabs for the logged-in user.
* History       :   

        Initials        Date          Description
-----------------------------------------------------------------------------------------
        Nikhil Jain    17-Nov-15      Created the Class
**/

public class RMA_AccessClass{
    
    //variables for the individual tab fields editability
    public boolean infoTab{get;set;}
    public boolean dispTab{get;set;}
    public boolean dispByQtyTab{get;set;}
    public boolean techTab{get;set;}
    public boolean regnTab{get;set;}
    public boolean fincTab{get;set;}
    public boolean isCSR{get;set;}
    public boolean canAckn{get;set;}
    public boolean rejectAckn{get;set;}
    public boolean isReturnToGF{get;set;}
    public boolean isScrap{get;set;}
    public boolean isApprover{get;set;}
        
    //variables for the individual tab visibility
    public boolean techTabActive{get;set;}
    public boolean regnTabActive{get;set;}
    public boolean fincTabActive{get;set;}
    
    RMA__c RMArecord = new RMA__c();
    
    //Constructor
    public RMA_AccessClass(ApexPages.StandardController controller){
        canAckn = false;
        RMArecord = (RMA__c)controller.getRecord();
        boolean hasEditAccess = false;
        boolean isOwner = false;
        boolean isCSRGroupMember = false;
        
        //to check owner
        if(RMArecord.OwnerId == userInfo.getUserId()){
            isOwner = true;
        }
        else{
            for(Account_Team_Proxy__c proxy : [select User__c from Account_Team_Proxy__c where Account__c =: RMArecord.Customer__c
                                              and User__c =: userInfo.getUserId()
                                              and Team_Role__c IN ('Primary Customer Service Rep','Backup Customer Service Rep','Customer Service Rep')]){
                if(proxy != NULL && proxy.User__c != RMArecord.OwnerId){
                    isOwner = true;
                }
            }
        }
        
        //to check Customer Engineer
        for(Account_Team_Proxy__c proxy : [select User__c from Account_Team_Proxy__c where Account__c =: RMArecord.Customer__c
                                            and User__c =: userInfo.getUserId()
                                            and Team_Role__c = 'Customer Engineer']){
            if(proxy != NULL){
                canAckn = true;
            }                                       
            
        }
        
        //NJain - 21Oct16 - to check if the user is added in the RMA CSR Red group (applicable only for Fab 9 an 10 RMAs)
        if(RMA_Utility.checkFab9or10(RMArecord.Fab__c)){
            List<GroupMember> groupUserCSR = [SELECT UserOrGroupId FROM GroupMember  WHERE Group.DeveloperName = 'RMA_CSR_Fab_9_10' AND UserOrGroupId = :UserInfo.getUserId()];
            if(groupUserCSR != NULL && !groupUserCSR.isEmpty()){
                isCSRGroupMember = true;
            }
        }        
        
        isCSR = isOwner || hasAdminPriv() || isCSRGroupMember;
        
        //Fetch the permission from the RMA Access metadata as per the workflow stage of the current RMA
        RMA_Access__mdt rmaAccessList = [SELECT Id,Group_Name__c,RMA_Info_Tab__c,Disposition_By_Quality_Tab__c,Disposition_Tab__c,Technical_Validation_Tab__c,
                                            Regional_Validation_Tab__c, Finance_Validation_Tab__c
                                          FROM RMA_Access__mdt WHERE Workflow_Stage__c = :RMArecord.Workflow_Stage__c limit 1];
        
        if(RMArecord.Workflow_Stage__c == RMA_Constants.PEN_FAB_VAL){
            if(RMA_Utility.checkFab9or10(RMArecord.Fab__c)){
                hasEditAccess = QueryRMAaccessOrGroups('Fab','RMA '+ RMArecord.Business_Category__c +' Quality Team',RMArecord.Id); 
            }
            else{
                hasEditAccess = QueryRMAaccessOrGroups('Fab','RMA '+ RMArecord.Fab__c,RMArecord.Id);    
            }
        }else if(RMArecord.Workflow_Stage__c == RMA_Constants.PEN_TNK_VAL ){
            hasEditAccess = QueryRMAaccessOrGroups('Turnkey','RMA Turnkey '+ RMArecord.Fab__c,RMArecord.Id);
        }else if(RMArecord.Workflow_Stage__c == RMA_Constants.PEN_NONFAB_VAL ){
            hasEditAccess = QueryRMAaccessOrGroups('Non Fab',NULL,RMArecord.Id);
        }else{
            hasEditAccess = True;
        }
        infoTab = hasEditAccess && rmaAccessList.RMA_Info_Tab__c;
        dispTab = hasEditAccess && rmaAccessList.Disposition_Tab__c;
        dispByQtyTab = hasEditAccess && rmaAccessList.Disposition_By_Quality_Tab__c;
        techTab = hasEditAccess && rmaAccessList.Technical_Validation_Tab__c;
        regnTab = hasEditAccess && rmaAccessList.Regional_Validation_Tab__c;
        fincTab = hasEditAccess && rmaAccessList.Finance_Validation_Tab__c;
                
        if(RMArecord.Status__c == RMA_Constants.SUBMITTED_STATUS){
            
            //set flags for acknowledging receipt of wafers or scrap certificates
            if( RMArecord.Disposition_of_Wafers__c.equalsIgnoreCase('Return to GF') ||
                RMArecord.Disposition_of_Wafers__c.equalsIgnoreCase('Return to GF and to Scrap at Customer Site')){
                if(!RMA_Utility.checkFab9or10(RMArecord.Fab__c)){
                    isReturnToGF = canAckn || checkReturnToGF() || checkStorePersonnel() || hasAdminPriv();
                }else{
                    isReturnToGF = checkReturnToGF() || checkStorePersonnel() || hasAdminPriv();
                }                
            }
            if( RMArecord.Disposition_of_Wafers__c.equalsIgnoreCase('To Scrap at Customer Site') ||
                RMArecord.Disposition_of_Wafers__c.equalsIgnoreCase('Return to GF and to Scrap at Customer Site')){
                if(!RMA_Utility.checkFab9or10(RMArecord.Fab__c)){
                    isScrap = checkScrap() || checkStorePersonnel() || isCSR;
                }else{
                    isScrap = checkScrap() || isCSR;
                }
            }
            
            if( RMArecord.Workflow_Stage__c == RMA_Constants.PEN_SCR_CRT || 
                RMArecord.Workflow_Stage__c == RMA_Constants.PEN_REC_WAF  || 
                RMArecord.Workflow_Stage__c == RMA_Constants.PEN_REC_SCR){
                
                if(RMA_Utility.checkFab9or10(RMArecord.Fab__c)){
                    if(RMArecord.Workflow_Stage__c == RMA_Constants.PEN_SCR_CRT){
                        rejectAckn = isScrap;
                    }else if(RMArecord.Workflow_Stage__c == RMA_Constants.PEN_REC_WAF){
                        rejectAckn = isReturnToGF;
                    }else if(RMArecord.Workflow_Stage__c == RMA_Constants.PEN_REC_SCR){
                        rejectAckn = isScrap || isReturnToGF;
                    }
                }else{
                    rejectAckn = canAckn || checkReturnToGF() || checkScrap() || checkStorePersonnel() || hasAdminPriv() || isCSR;
                }
            }
            else if(   RMArecord.Workflow_Stage__c.startsWithIgnoreCase('Pending for Regional')
                    || RMArecord.Workflow_Stage__c.equalsIgnoreCase(RMA_Constants.PEN_CQ_VAL)       
                    || RMArecord.Workflow_Stage__c.startsWithIgnoreCase('Pending for Product Engineering')
                    || RMArecord.Workflow_Stage__c.startsWithIgnoreCase('Pending for Finance Approval')
                    || RMArecord.Workflow_Stage__c.equalsIgnoreCase(RMA_Constants.PEN_FAB_VAL)
                    || RMArecord.Workflow_Stage__c.equalsIgnoreCase(RMA_Constants.PEN_TNK_VAL)
                    || RMArecord.Workflow_Stage__c.equalsIgnoreCase(RMA_Constants.PEN_NONFAB_VAL)){
                isApprover = RMA_Utility.checkApprover(RMArecord.Id) || hasAdminPriv();
            }
        }
        
        if(RMArecord.Id != NULL){
            RMA_Utility.RMAwrapper rmaWrap = new RMA_Utility.RMAwrapper(0,0,0);
            rmaWrap = RMA_Utility.getRMAtotalSystemMode(RMArecord.Id);
            CheckTabVisibility(rmaWrap.grandTotalCSR);
        }
        
    }
    
    //Method to check if the user has Edit access from either group or RMA Access User
    public boolean QueryRMAaccessOrGroups(String category, String queueName,String rmaId){
        boolean isRMAaccessUser = false;
        boolean isQueueUser = false;
        boolean isAdmin = false;
        
        //Check if logged-in user has admin access
        isAdmin = hasAdminPriv();
        
        //Check if the logged-in user is added as the RMA Access User
        if(category != NULL && category != ''){
            List<RMA_Access_User__c> lstRMAaccess = [SELECT Id FROM RMA_Access_User__c
                                                        WHERE Category__c = :category 
                                                          AND User__c = :UserInfo.getUserId()
                                                          AND RMA__c  = :rmaId];
            if(!lstRMAaccess.isEmpty()){
                isRMAaccessUser = true;
            }
        }
        
        //Check if the user is present in the public group for the current workflow stage to which the approval has been sent
        if(queueName != NULL && queueName != ''){
            List<Id> lstGroupsToCheck = new List<Id>();
            for(GroupMember gm: [SELECT Id,UserOrGroupId  FROM GroupMember
                                 WHERE Group.Type = 'Queue' AND 
                                       Group.Name = :queueName]){
                if(string.valueOf(gm.UserOrGroupId).startsWith('00G')){
                    lstGroupsToCheck.add(gm.UserOrGroupId);
                }else if(gm.UserOrGroupId == UserInfo.getUserId()){
                    isQueueUser = true;
                    break;
                }
            }
            if(!isQueueUser && !lstGroupsToCheck.isEmpty()){
                List<GroupMember> lstGroupMember = [SELECT Id FROM GroupMember
                                                        WHERE UserOrGroupId = :UserInfo.getUserId() AND 
                                                              Group.Type = 'Regular' AND 
                                                              GroupId in :lstGroupsToCheck];                                        
                if(!lstGroupMember.isEmpty()){
                    isQueueUser = true;
                }
            }
        }
        return (isQueueUser || isRMAaccessUser || isAdmin);
    }
    
    //Method to check if the logged-in user is a system administrator.
    public static boolean hasAdminPriv(){
        Profile p = [select Name from Profile where Id =: userInfo.getProfileId()];
        if(    p.Name.equalsIgnoreCase('System Administrator')
            || p.Name.equalsIgnoreCase('GF Integration')){
            return true;
        }
        return false;
    }
    
    //Method for tab visibility
    public void CheckTabVisibility(Decimal grandTotalCSR){
        techTabActive = false;
        regnTabActive = false;
        fincTabActive = false;
        string StgBeforeRej = '';
        string StgBeforeVoid = '';
        String queryText = '';
        
        queryText += 'select Id,Cycle_time_for_Fab_Validation__c,Cycle_Time_for_Finance_Approval__c,Cycle_Time_for_Regional_Approval__c,';
        queryText += 'Cycle_Time_for_Customer_Qty_Validation__c,RMA_Reason_Code__c,IS_SMPLSI__c,IS_FAB_9_10__c,Category__c from RMA_Cycle_Time_Settings__mdt';
        queryText += ' where Category__c = \''+RMArecord.RMA_Category__c+'\' and IS_SMPLSI__c = '+RMArecord.Is_SMPLSI__c+'';
        if(RMA_Utility.checkFab9or10(RMArecord.Fab__c)){
            queryText += ' and IS_FAB_9_10__c = true and RMA_Reason_Code__c = \''+RMArecord.ReasonCode__c+'\'';
        }
        queryText += ' limit 1';
        
        List<RMA_Cycle_Time_Settings__mdt> lstRMACycleTime = database.query(queryText);
                                                                    
        if(!lstRMACycleTime.isEmpty()){
        
            RMA_Cycle_Time_Settings__mdt rmaCycleTime = lstRMACycleTime[0];
            
            //Control the tab visibility on Rejection
            if(RMArecord.Status__c != NULL && RMArecord.Status__c != '' && RMArecord.Status__c.equalsIgnoreCase(RMA_Constants.REJECTED_STATUS)){
                StgBeforeRej = CheckStageBeforeRejection(RMArecord.Id);
            }else if(RMArecord.Status__c != NULL && RMArecord.Status__c != '' && RMArecord.Status__c.equalsIgnoreCase(RMA_Constants.VOIDED_STATUS)){
                StgBeforeVoid = CheckStageBeforeVoid(RMArecord.Id);
            }
			
            //Visibility of Technical Validation Tab
            if(rmaCycleTime.Cycle_time_for_Fab_Validation__c != 0){
                if(RMArecord.Status__c != NULL && RMArecord.Status__c != ''){
                    if(RMArecord.Status__c.equalsIgnoreCase(RMA_Constants.SUBMITTED_STATUS) &&
                        !RMArecord.Workflow_Stage__c.equalsIgnoreCase('') &&
                        !RMArecord.Workflow_Stage__c.equalsIgnoreCase(RMA_Constants.PEN_CQ_VAL)){
                        techTabActive = true;
                    }
                    else if(RMArecord.Status__c.equalsIgnoreCase(RMA_Constants.REJECTED_STATUS)){
                        if(StgBeforeRej.equalsIgnoreCase(RMA_Constants.PEN_FAB_VAL)
                        || StgBeforeRej.equalsIgnoreCase(RMA_Constants.PEN_TNK_VAL)
                        || StgBeforeRej.equalsIgnoreCase(RMA_Constants.PEN_NONFAB_VAL)
                        || StgBeforeRej.equalsIgnoreCase(RMA_Constants.PEN_PRD_ENG)
                        //Njain-23-Jun16- Added as a fix to display Technical Tab on Rejection.
                        || StgBeforeRej.startsWithIgnoreCase('Pending for Regional')
                        || StgBeforeRej.startsWithIgnoreCase('Pending for Finance')
                        || StgBeforeRej.startsWithIgnoreCase('Pending for Receipt')){
                            techTabActive = true;
                        }
                    }
                    //NJain - 19Aug16 - Included this check for Visibility of Tab on Voiding the RMA.
                    else if(RMArecord.Status__c.equalsIgnoreCase(RMA_Constants.VOIDED_STATUS)){
                        if(StgBeforeVoid != NULL && (
                           StgBeforeVoid.equalsIgnoreCase(RMA_Constants.PEN_FAB_VAL)
                        || StgBeforeVoid.equalsIgnoreCase(RMA_Constants.PEN_TNK_VAL)
                        || StgBeforeVoid.equalsIgnoreCase(RMA_Constants.PEN_NONFAB_VAL)
                        || StgBeforeVoid.equalsIgnoreCase(RMA_Constants.PEN_PRD_ENG)
                        || StgBeforeVoid.startsWithIgnoreCase('Pending for Regional')
                        || StgBeforeVoid.startsWithIgnoreCase('Pending for Finance')
                        || StgBeforeVoid.startsWithIgnoreCase('Pending for Receipt'))){
                            techTabActive = true;
                        }
                    }
                    else if(!RMArecord.Workflow_Stage__c.equalsIgnoreCase('') &&
                             !RMArecord.Workflow_Stage__c.equalsIgnoreCase(RMA_Constants.RMA_RAISED) &&
                             !RMArecord.Workflow_Stage__c.equalsIgnoreCase(RMA_Constants.PEN_CQ_VAL)){
                        techTabActive = True;
                    }
                    else{
                        techTabActive = false;
                    }
                }
                
                //Njain-23-Jun16- Hide the Technical Tab for R50 with amount <= 2000
                //SNAIR-9-Aug16-Added check for Fab 9 or 10
                if(RMA_Utility.checkFab9or10(RMArecord.Fab__c) &&
                    !RMArecord.Status__c.equalsIgnoreCase(RMA_Constants.REJECTED_STATUS) && 
                    RMArecord.RMA_Category__c == 'Technical/ Turnkey' && 
                    RMArecord.ReasonCode__c == 'R50' && 
                    grandTotalCSR <= 2000){
                    techTabActive = false;
                }
            }
            
            //Visibility of Regional Validation Tab
            if(rmaCycleTime.Cycle_Time_for_Regional_Approval__c != 0){
                if(RMArecord.Status__c != NULL && RMArecord.Status__c != '' && RMArecord.Status__c.equalsIgnoreCase(RMA_Constants.DRAFT_STATUS)){
                    //techTabActive = False; //commented on 22Jan16 
                    regnTabActive = False;
                }else if(RMArecord.Workflow_Stage__c.equalsIgnoreCase(RMA_Constants.REJECTED_RMA)){
                    if(StgBeforeRej.startsWithIgnoreCase('Pending for Regional') ||
                       StgBeforeRej.startsWithIgnoreCase('Pending for Finance') ||
                       StgBeforeRej.startsWithIgnoreCase('Pending for Receipt')
                    ){
                        regnTabActive = True;
                    }
                }
                //NJain - 19Aug16 - Included this check for Visibility of Tab on Voiding the RMA.
                else if(RMArecord.Status__c.equalsIgnoreCase(RMA_Constants.VOIDED_STATUS)){
                    if(StgBeforeVoid != NULL && (
                       StgBeforeVoid.startsWithIgnoreCase('Pending for Regional') ||
                       StgBeforeVoid.startsWithIgnoreCase('Pending for Finance') ||
                       StgBeforeVoid.startsWithIgnoreCase('Pending for Receipt'))){
                        regnTabActive = true;
                    }
                }
                else if(!RMArecord.Workflow_Stage__c.equalsIgnoreCase('') &&
                         !RMArecord.Workflow_Stage__c.equalsIgnoreCase(RMA_Constants.RMA_RAISED) &&
                         !RMArecord.Workflow_Stage__c.equalsIgnoreCase(RMA_Constants.PEN_FAB_VAL) &&
                         !RMArecord.Workflow_Stage__c.equalsIgnoreCase(RMA_Constants.PEN_TNK_VAL) &&
                         !RMArecord.Workflow_Stage__c.equalsIgnoreCase(RMA_Constants.PEN_NONFAB_VAL) &&
                         !RMArecord.Workflow_Stage__c.equalsIgnoreCase(RMA_Constants.PEN_PRD_ENG) &&
                         !RMArecord.Workflow_Stage__c.equalsIgnoreCase(RMA_Constants.PEN_CQ_VAL)){
                    regnTabActive = True;
                }else{
                    regnTabActive = False;
                }
                
                //Njain-23-Jun16- Hide the Regional Tab for R50 with amount <= 2000
                if(!RMArecord.Workflow_Stage__c.equalsIgnoreCase(RMA_Constants.REJECTED_RMA) &&
                    RMArecord.RMA_Category__c == 'Technical/ Turnkey' && 
                    RMArecord.ReasonCode__c == 'R50' && 
                    grandTotalCSR <= 2000){
                    regnTabActive = false;
                }
            }
            
            //Visibility of Finance Validation Tab
            if(rmaCycleTime.Cycle_Time_for_Finance_Approval__c != 0 || RMArecord.RMA_Category__c == 'Rework'){
                if(RMArecord.Status__c != NULL && RMArecord.Status__c != '' && RMArecord.Status__c.equalsIgnoreCase(RMA_Constants.DRAFT_STATUS)){
                    fincTabActive = False;
                }else if(RMArecord.Workflow_Stage__c.equalsIgnoreCase(RMA_Constants.REJECTED_RMA)){
                    if(StgBeforeRej.startsWithIgnoreCase('Pending for Finance')){
                        fincTabActive = True;
                    }
                }
                //NJain - 19Aug16 - Included this check for Visibility of Tab on Voiding the RMA.
                else if(RMArecord.Status__c.equalsIgnoreCase(RMA_Constants.VOIDED_STATUS)){
                    if(StgBeforeVoid != NULL && StgBeforeVoid.startsWithIgnoreCase('Pending for Finance')){
                        fincTabActive = True;
                    }
                }
                else if(!RMArecord.Workflow_Stage__c.equalsIgnoreCase('') &&
                         !RMArecord.Workflow_Stage__c.equalsIgnoreCase(RMA_Constants.RMA_RAISED) &&
                         !RMArecord.Workflow_Stage__c.equalsIgnoreCase(RMA_Constants.PEN_FAB_VAL) &&
                         !RMArecord.Workflow_Stage__c.equalsIgnoreCase(RMA_Constants.PEN_TNK_VAL) &&
                         !RMArecord.Workflow_Stage__c.equalsIgnoreCase(RMA_Constants.PEN_NONFAB_VAL) &&
                         !RMArecord.Workflow_Stage__c.equalsIgnoreCase(RMA_Constants.PEN_PRD_ENG) &&
                         !RMArecord.Workflow_Stage__c.equalsIgnoreCase(RMA_Constants.PEN_PRD_MGR) &&
                         !RMArecord.Workflow_Stage__c.equalsIgnoreCase(RMA_Constants.PEN_PRD_DIR) &&
                         !RMArecord.Workflow_Stage__c.equalsIgnoreCase(RMA_Constants.DIS_NOT_DEF) &&
                         !RMArecord.Workflow_Stage__c.equalsIgnoreCase(RMA_Constants.PEN_CQ_VAL) &&
                         !RMArecord.Workflow_Stage__c.equalsIgnoreCase(RMA_Constants.PEN_LOG_APPR) &&
                         !RMArecord.Workflow_Stage__c.equalsIgnoreCase(RMA_Constants.PEN_CSR_MGR_APPR) &&
                         !RMArecord.Workflow_Stage__c.startsWithIgnoreCase('Pending for Regional') &&
                         !RMArecord.Workflow_Stage__c.startsWithIgnoreCase('Pending for Receipt')){
                    fincTabActive = True;
                }else{
                    fincTabActive = False;
                }
            }
            
        }
        
    }
    
    //to check if current user is Store Personnel
    public boolean checkStorePersonnel(){
        boolean isStorePersonnel = false;
            
        Set<Id> groupMemberIdList = new Set<Id>();
        List<Id> groupIdList = new List<Id>();
        String queueName = 'RMA Store Personnel- '+RMArecord.Fab__c;
        
        if(RMA_Utility.checkFab9or10(RMArecord.Fab__c)){
            if(RMArecord.Return_Location__c == 'APLC'){
                queueName = 'RMA APLC Members';
            }else if(RMArecord.Return_Location__c == 'Burlington'){
                queueName = 'RMA Zone88 Members';
            }
        }
        for(GroupMember member : [select UserOrGroupId from GroupMember where Group.Name =: queueName and Group.Type = 'Queue']){
            if(((String)member.UserOrGroupId).startsWith(RMA_Constants.GROUP_KEYPREFIX)){
                groupMemberIdList.add(member.UserOrGroupId);
            }
        }
        if(!groupMemberIdList.isEmpty()){
            List<GroupMember> member = [select UserOrGroupId from GroupMember where GroupId IN: groupMemberIdList and UserOrGroupId =: UserInfo.getUserId()];
            if(member != NULL && !member.isEmpty()){
                isStorePersonnel = true;
            }
        }
        
        return isStorePersonnel;
    }
    
    //For Return to GF
    public boolean checkReturnToGF(){
        List<RMA_Access_User__c> rmaAccessUserList = [select Id,User__c,Category__c from RMA_Access_User__c where RMA__c =: RMArecord.Id 
                                                        and Category__c = 'Return Wafer' and User__c =: UserInfo.getUserId()]; 
        if(rmaAccessUserList != NULL && !rmaAccessUserList.isEmpty()){
            return true;    
        }
        else{
            return false;
        }
    }
    
    //For To Scrap at Customer Site 
    public boolean checkScrap(){
        List<RMA_Access_User__c> rmaAccessUserList = [select Id,User__c,Category__c from RMA_Access_User__c where RMA__c =: RMArecord.Id 
                                                        and Category__c = 'Scrap Certificate' and User__c =: UserInfo.getUserId()]; 
        if(rmaAccessUserList != NULL && !rmaAccessUserList.isEmpty()){
            return true;    
        }
        else{
            return false;
        }
    }
    
    public String CheckStageBeforeRejection(String rmaId){        
        for(RMA__History rmaHistory : [SELECT oldValue,NewValue,ParentId,Field,CreatedDate 
                                        FROM RMA__History 
                                        WHERE ParentId = :rmaId 
                                          AND Field = 'Workflow_Stage__c' 
                                        ORDER BY CreatedDate Desc LIMIT 1000]){
            if(rmaHistory.NewValue == RMA_Constants.REJECTED_RMA){
                return string.valueOf(rmaHistory.OldValue);
                break;
            }
        }
        return null;
    }
    
    //NJain - 19Aug16 - Method to fetch the stage before the record was Rejected and Voided.
    public String CheckStageBeforeVoid(String rmaId){
        integer indexNo = 0;
        List<RMA__History> lstRMAHistory = [SELECT oldValue,NewValue,ParentId,Field,CreatedDate 
                                            FROM RMA__History 
                                            WHERE ParentId = :rmaId 
                                              AND Field = 'Workflow_Stage__c' 
                                            ORDER BY CreatedDate Desc LIMIT 1000];
        for(RMA__History rmaHistory : lstRMAHistory){
            if(rmaHistory.NewValue == RMA_Constants.VOIDED_RMA || rmaHistory.NewValue == 'Voided by System'){
                if(rmaHistory.OldValue == RMA_Constants.RMA_RAISED){
                    return string.valueOf(rmaHistory.OldValue);
                }else{
                    return string.valueOf(lstRMAHistory[indexNo + 1].OldValue);
                }
                break;
            }
            indexNo++;
        }
        return null;
    }
}