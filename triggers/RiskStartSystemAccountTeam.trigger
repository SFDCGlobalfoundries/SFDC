/**
* Author: Bhupesh Mukhija
* Company: Cognizant Technology Solutions
* Description: Trigger for Setting Primary Account Manager and FAB Planner
* History:
*     BMUkhija             21032013           Initial Draft
*     Vixit Bhardwaj       15012014           New Process defined at Step 2
*     Sunil Arora          22012015           added a validation for case # 38447   
*     Pradosh Samal        21062017           Changes for pending approval reminder   
**/

trigger RiskStartSystemAccountTeam on Risk_Start_System__c (before insert, before update) {

    // Get all Custom Setting Values for RSS Stage and Account Team Roles.
    final String STATUS_PENDING_CUSTOMER_PLANNING 
        = CS_Risk_Start__c.getInstance('STATUS_PENDING_CUSTOMER_PLANNING').RS_Status_Error__c;
    final String STATUS_Pending_Sales_Account_Inputs 
        = CS_Risk_Start__c.getInstance('STATUS_Pending_Sales_Account_Inputs').RS_Status_Error__c;
    final String ROLE_PRIMARY_ACCOUNT_MANAGER
        = Account_Team_Roles__c.getInstance('ROLE_PRIMARY_ACCOUNT_MANAGER').Role__c;
    final String ROLE_ACCOUNT_MANAGER 
        = Account_Team_Roles__c.getInstance('ROLE_ACCOUNT_MANAGER').Role__c;
    final String ROLE_FAB_PLANNER 
        = Account_Team_Roles__c.getInstance('ROLE_FAB_PLANNER').Role__c;
    String ERROR_NO_FAB_PLANNER = CS_Risk_Start__c.getInstance('ERROR_NO_FAB_PLANNERS').RS_Status_Error__c;      
    String Expected_PO_Date = CS_Risk_Start__c.getInstance('Expected_PO_Date').RS_Status_Error__c;
    
    String STATUS_REJECTED=CS_Risk_Start__c.getInstance('STATUS_REJECTED').RS_Status_Error__c;
    String PLANNERS_FAB1 = Environment_Variable__c.getInstance('PLANNERS_FAB1').Value__c;
    String PLANNERS_FAB2 = Environment_Variable__c.getInstance('PLANNERS_FAB2').Value__c;
    String PLANNERS_FAB3 = Environment_Variable__c.getInstance('PLANNERS_FAB3').Value__c;
    String PLANNERS_FAB3E = Environment_Variable__c.getInstance('PLANNERS_FAB3E').Value__c;
    String PLANNERS_FAB5 = Environment_Variable__c.getInstance('PLANNERS_FAB5').Value__c;
    String PLANNERS_FAB6 = Environment_Variable__c.getInstance('PLANNERS_FAB6').Value__c;
    String PLANNERS_FAB7 = Environment_Variable__c.getInstance('PLANNERS_FAB7').Value__c;
    String PLANNERS_FAB8 = Environment_Variable__c.getInstance('PLANNERS_FAB8').Value__c;

    List<Risk_Start_System__c> lRiskStartSystems = Trigger.new;

    Risk_Start_System__c riskStartSystem;
        
    List<Account_Team_Proxy__c> lAccountManagersProxies = new List<Account_Team_Proxy__c>();
    List<Account_Team_Proxy__c> lAccountFabPlannersProxies = new List<Account_Team_Proxy__c>();
    

    Set<Id> sAccountIds = new Set<Id>();

    String strGroupName;
    List<User> lstUsers = new List<User>();
    List<String> lstFabNames = new List<String>();
     //----------------------case #44042------------Start
    Set<id> setAcctIds = new Set<id>(); 
    Set<string> setterr = new Set<string>();
    
    for(Risk_Start_System__c R : trigger.new) {
      setAcctIds.add(R.Customer_Name__c);
    } 
    Map<string,id> mapAcc1 = new Map<string,id>();
    for(Account AccReg: [select id,Financial_Territory__c from Account WHERE id IN : setAcctIds ])//
    {
        setterr.add(AccReg.Financial_Territory__c);
        mapAcc1.put(AccReg.Financial_Territory__c,AccReg.id);
    }
    Map<string,string> mapAcc = new Map<string,string>();
    for(Account_Region_Head_Mapping__c AccReg: [select id,Region_Head_LK__c,Sales_Territory__c from Account_Region_Head_Mapping__c WHERE Sales_Territory__c IN : setterr and isActive__c=true])//
    {
        if(mapAcc1.containskey(AccReg.Sales_Territory__c))
        {
            mapAcc.put(mapAcc1.get(AccReg.Sales_Territory__c),AccReg.Region_Head_LK__c);
        }
    }
    for (Risk_Start_System__c R : trigger.new) {
    //r.addError('oppLst'+ R.Customer_Name__r.Financial_Territory__c); 
        if(R.Status__c =='Draft')
        {
            R.Regional_Head__c = mapAcc.get(R.Customer_Name__c);
        }
    }
    //----------------------END case
    
        
    if (lRiskStartSystems != null && !lRiskStartSystems.isEmpty()) {

        riskStartSystem = new Risk_Start_System__c();
        riskStartSystem.Fab__c = lRiskStartSystems[0].Fab__C;
        if(riskStartSystem.Fab__c == 'Fab 1') {
            strGroupName = PLANNERS_FAB1;
        } 
        if(riskStartSystem.Fab__c == 'Fab 2'){
            strGroupName = PLANNERS_FAB2;
        } 
        if(riskStartSystem.Fab__c == 'Fab 3'){
            strGroupName = PLANNERS_FAB3;
        }
        if(riskStartSystem.Fab__c == 'Fab 3E'){
            strGroupName = PLANNERS_FAB3E;
        }
        if(riskStartSystem.Fab__c == 'Fab 5'){
            strGroupName = PLANNERS_FAB5;
        }
        if(riskStartSystem.Fab__c == 'Fab 6'){
            strGroupName = PLANNERS_FAB6;
        }
        if(riskStartSystem.Fab__c == 'Fab 7'){
            strGroupName = PLANNERS_FAB7;
        }
        if(riskStartSystem.Fab__c == 'Fab 8'){
            strGroupName = PLANNERS_FAB8;
        }

        //Fetching the Group ID
        if (strGroupName!= null && strGroupName !='') {
        
           Id groupId = null;
            List<Group> lstGroup = [SELECT Name, Id FROM Group Where Name =: strGroupName and Type = 'Regular'];
            if (lstGroup != null && !lstGroup.isEmpty()) {
                groupId = lstGroup[0].id;
            }

            //Fetching Group Members
            List<GroupMember> lstGroupMembers = [SELECT UserOrGroupId, GroupId FROM GroupMember where Groupid =: groupId];
            List<Id> lstGroupMemberIds = new List<Id>();
            if (lstGroupMembers != null && !lstGroupMembers.isEmpty()) {
            
                for(integer i=0; i<lstGroupMembers.size(); i++){
                    lstGroupMemberIds.add(lstGroupMembers [i].UserOrGroupId);
                }

                // Fetching Active Users
                if(lstGroupMemberIds.size() >0 ){
                    lstUsers=[Select u.Id, u.IsActive, u.Name, u.Username, u.Fab_Assigned__c from User u where u.IsActive=true and u.Id IN:lstGroupMemberIds 
                    // and u.Fab_Assigned__c INCLUDES (:riskStartSystem.Fab__c) 
                    limit 15];
                }
            }
        }

        for (Risk_Start_System__c eachRiskStartSystem: lRiskStartSystems) {
            sAccountIds.add(eachRiskStartSystem.Customer_Name__c);          
        }
                                   
        if (Trigger.isInsert) {         
    
            // Get all Account Manager(s) for all Risk Start Systems Accounts.
            lAccountManagersProxies = [SELECT Account__c
                                            , User__c
                                            , Team_Role__c 
                                       FROM Account_Team_Proxy__c 
                                       WHERE Account__c IN: sAccountIds 
                                        AND (Team_Role__c = :ROLE_ACCOUNT_MANAGER 
                                            OR Team_Role__c = :ROLE_PRIMARY_ACCOUNT_MANAGER)
                                        AND Flag_for_Delete__c = false 
                                        AND User__r.isActive = true];
            
            // Call Helper method to update Primary Account Manager and FAB Planner.

            RiskStartSystemHelper.updateAccountManagers(lRiskStartSystems, lAccountManagersProxies);
           
            // Call Helper method to Insert FAB Planner.
            if (lstUsers!= null && !lstUsers.isEmpty()) {
                RiskStartSystemHelper.updateFabPlanningUsers(lRiskStartSystems, lstUsers);
            }

        } else if (Trigger.isUpdate) {
            List<Risk_Start_System__c> lRiskStartTemp = new List<Risk_Start_System__c>();

            /* ----Start   Add validatation case# 1659 and case # 38447*/
            for (Risk_Start_System__c eachRss: lRiskStartSystems) {
                if( trigger.oldmap.get(eachRss.Id).Status__c == STATUS_Pending_Sales_Account_Inputs && eachRss.Expected_PO_Date__c == null && eachRss.Status__c != STATUS_REJECTED && eachRss.Status__c !='Draft' )
                {
                    lRiskStartSystems.get(0).addError(Expected_PO_Date);   
                }
                
                if( trigger.oldmap.get(eachRss.Id).Status__c == STATUS_Pending_Sales_Account_Inputs && eachRss.Expected_Shipment_Date__c == null && eachRss.Status__c != STATUS_REJECTED && eachRss.Status__c !='Draft' )
                {
                    lRiskStartSystems.get(0).addError(Expected_PO_Date);   
                }
            }
            /* ----End Add validatation case# 1659 */
            
            // Call Helper method to update FAB Planner.
       
            if (lstUsers!= null && !lstUsers.isEmpty()) {
                RiskStartSystemHelper.updateFabPlanningUsers(lRiskStartSystems, lstUsers);
            }
          
            // Add Error to all Risk Start System Records if Fab Planners are not found.
            if (lRiskStartTemp != null && !lRiskStartTemp.isEmpty()) {
                for (Risk_Start_System__c eachRss: lRiskStartTemp) {
                    eachRss.addError(ERROR_NO_FAB_PLANNER.replace('MERGE_FAB', eachRss.Fab__c));
                }
            }

        }
    }
    
    if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)){
        
        RiskStartSystemHelper.validatePoDate(Trigger.old, Trigger.new);
    }
    
    if(Trigger.isBefore && Trigger.isUpdate){
        
        RiskStartSystemHelper.resetApprovalReminder(Trigger.new, Trigger.oldMap);
    }
}