/**
* Author: Bhupesh Mukhija
* Company: Cognizant Technology Solutions
* Description: Helper Class for Risk Start System
* History:
*   BMUkhija               21032013           Initial Draft
*   Vixit Bhardwaj         15012014           New Process defined at Step 2
*   Pradosh Samal          10042017           Case-00065983-Adding Account Manager
*   Pradosh Samal          21062017           Changes for Pending aaproval reminder    
**/

global class RiskStartSystemHelper {

    /** 
        Method for New Approval Process on Risk Start System Helper.
        Makes sure that the Status is not equals to Draft or Rejected
    */
    Webservice static String processApprovalNew (String riskStartSystemId) {
    
        final String STATUS_DRAFT = CS_Risk_Start__c.getInstance('STATUS_DRAFT').RS_Status_Error__c;
        final String STATUS_REJECTED = CS_Risk_Start__c.getInstance('STATUS_REJECTED').RS_Status_Error__c;
        String retVal = null;
             

        Risk_Start_System__c riskStartSystem
            = [SELECT Customer_Name__c
                    , Status__c
               FROM Risk_Start_System__c 
               WHERE Id =: riskStartSystemId];
 
        Approval.ProcessSubmitRequest approvalReq = new Approval.ProcessSubmitRequest();
        approvalReq.setObjectId(riskStartSystem.Id);
        
        Approval.ProcessResult processResult;
        if (riskStartSystem.Status__c.equalsIgnoreCase(STATUS_DRAFT) || riskStartSystem.Status__c.equalsIgnoreCase(STATUS_REJECTED)) {
            processResult = Approval.process(approvalReq);

            retVal = 'success';
        } else {
            retVal = 'failure';
        }
        return retVal;
    }

    // This method updates Account Manager(s) Risk Start System.
    public static void updateAccountManagers(List<Risk_Start_System__c> lRiskStartSystems, List<Account_Team_Proxy__c> lAccountTeamProxies) {
        final String ROLE_PRIMARY_ACCOUNT_MANAGER
            = Account_Team_Roles__c.getInstance('ROLE_PRIMARY_ACCOUNT_MANAGER').Role__c;
        final String ROLE_ACCOUNT_MANAGER 
            = Account_Team_Roles__c.getInstance('ROLE_ACCOUNT_MANAGER').Role__c;
        // Set Corrosponding Account Manager(s) to Risk Start System.
        String accountManager;
        Boolean flagAccountManager = false;
        if (lAccountTeamProxies != null && !lAccountTeamProxies.isEmpty()) {
            for (Risk_Start_System__c eachRiskStartSystem: lRiskStartSystems) {
                eachRiskStartSystem.Account_Manager_1__c = null;
                eachRiskStartSystem.Account_Manager_2__c = null;
                eachRiskStartSystem.Sales_Account_Manager__c = null;
                eachRiskStartSystem.Account_Manager_3__c = null;
                eachRiskStartSystem.Account_Manager_4__c = null;
                eachRiskStartSystem.Account_Manager_5__c = null;
                for (Account_Team_Proxy__c eachAccountTeamProxy: lAccountTeamProxies) {
                    if (eachRiskStartSystem.Customer_Name__c == eachAccountTeamProxy.Account__c) {
                        if (eachAccountTeamProxy.Team_Role__c.equalsIgnoreCase(ROLE_PRIMARY_ACCOUNT_MANAGER)
                            || eachAccountTeamProxy.Team_Role__c.equalsIgnoreCase(ROLE_ACCOUNT_MANAGER)) {
                            if (!flagAccountManager) {
                                accountManager = eachAccountTeamProxy.User__c;
                                eachRiskStartSystem.Account_Manager_1__c = accountManager;
                                eachRiskStartSystem.Account_Manager_2__c = accountManager;
                                eachRiskStartSystem.Account_Manager_3__c = accountManager;
                                eachRiskStartSystem.Account_Manager_4__c = accountManager;
                                eachRiskStartSystem.Account_Manager_5__c = accountManager;
                                flagAccountManager = true;
                            }

                            if (eachAccountTeamProxy.Team_Role__c.equalsIgnoreCase(ROLE_PRIMARY_ACCOUNT_MANAGER)) {
                                eachRiskStartSystem.Sales_Account_Manager__c = eachAccountTeamProxy.User__c;                                
                            } else {
                                if (eachRiskStartSystem.Account_Manager_1__c == accountManager) {
                                    eachRiskStartSystem.Account_Manager_1__c = eachAccountTeamProxy.User__c;
                                } else if (eachRiskStartSystem.Account_Manager_2__c == accountManager) {
                                    eachRiskStartSystem.Account_Manager_2__c = eachAccountTeamProxy.User__c;
                                }
                                else if (eachRiskStartSystem.Account_Manager_3__c == accountManager) {
                                    eachRiskStartSystem.Account_Manager_3__c = eachAccountTeamProxy.User__c;
                                }
                                else if (eachRiskStartSystem.Account_Manager_4__c == accountManager) {
                                    eachRiskStartSystem.Account_Manager_4__c = eachAccountTeamProxy.User__c;
                                }
                                else if (eachRiskStartSystem.Account_Manager_5__c == accountManager) {
                                    eachRiskStartSystem.Account_Manager_5__c = eachAccountTeamProxy.User__c;
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    /* This method updates Fab Planner(s) for Risk Start Systems.
    */  
    public static List<Risk_Start_System__c> updateFabPlanningUsers(List<Risk_Start_System__c> lRiskStartSystems, List<User> IUsers) {
        Boolean flagFabPlanners = false;
        List<Risk_Start_System__c> retVal = new List<Risk_Start_System__c>();
        for (Risk_Start_System__c eachRiskStartSystem: lRiskStartSystems) { 
            if (IUsers!= null && !IUsers.isEmpty()) {
                if( IUsers.size() == 1 ){
                    if(IUsers[0].id !=null){
                        eachRiskStartSystem.Fab_Planning_User_1__c = IUsers[0].id;
                        eachRiskStartSystem.Fab_Planning_User_2__c = IUsers[0].id;
                        eachRiskStartSystem.Fab_Planning_User_3__c = IUsers[0].id;
                        eachRiskStartSystem.Fab_Planning_User_4__c = IUsers[0].id;
                        eachRiskStartSystem.Fab_Planning_User_5__c = IUsers[0].id; 
                         eachRiskStartSystem.Fab_Planner_1__c = IUsers[0].id;
                         eachRiskStartSystem.Fab_Planner_2__c = IUsers[0].id;
                         eachRiskStartSystem.Fab_Planner_3__c = IUsers[0].id;
                         eachRiskStartSystem.Fab_Planner_4__c = IUsers[0].id;
                         eachRiskStartSystem.Fab_Planner_5__c = IUsers[0].id;
                         eachRiskStartSystem.Fab_Planner_6__c = IUsers[0].id;
                         eachRiskStartSystem.Fab_Planner_7__c = IUsers[0].id;
                         eachRiskStartSystem.Fab_Planner_8__c = IUsers[0].id;
                         eachRiskStartSystem.Fab_Planner_9__c = IUsers[0].id;
                         eachRiskStartSystem.Fab_Planner_10__c = IUsers[0].id;
                    }
                }
                if( IUsers.size() == 2 ){
                    if(IUsers[1].id !=null){
                        eachRiskStartSystem.Fab_Planning_User_1__c = IUsers[0].id;
                        eachRiskStartSystem.Fab_Planning_User_2__c = IUsers[1].id;
                        eachRiskStartSystem.Fab_Planning_User_3__c = IUsers[0].id;
                        eachRiskStartSystem.Fab_Planning_User_4__c = IUsers[1].id;
                        eachRiskStartSystem.Fab_Planning_User_5__c = IUsers[0].id;                      
                         eachRiskStartSystem.Fab_Planner_1__c = IUsers[1].id;
                         eachRiskStartSystem.Fab_Planner_2__c = IUsers[0].id;
                         eachRiskStartSystem.Fab_Planner_3__c = IUsers[1].id;
                         eachRiskStartSystem.Fab_Planner_4__c = IUsers[0].id;
                         eachRiskStartSystem.Fab_Planner_5__c = IUsers[1].id;
                         eachRiskStartSystem.Fab_Planner_6__c = IUsers[0].id;
                         eachRiskStartSystem.Fab_Planner_7__c = IUsers[1].id;
                         eachRiskStartSystem.Fab_Planner_8__c = IUsers[0].id;
                         eachRiskStartSystem.Fab_Planner_9__c = IUsers[1].id;
                         eachRiskStartSystem.Fab_Planner_10__c = IUsers[0].id;
                    }
                }
                if( IUsers.size() == 3 ){
                    if(IUsers[2].id !=null){
                        eachRiskStartSystem.Fab_Planning_User_1__c = IUsers[0].id;
                        eachRiskStartSystem.Fab_Planning_User_2__c = IUsers[1].id;
                        eachRiskStartSystem.Fab_Planning_User_3__c = IUsers[2].id;
                        eachRiskStartSystem.Fab_Planning_User_4__c = IUsers[0].id;
                        eachRiskStartSystem.Fab_Planning_User_5__c = IUsers[1].id;                          
                         eachRiskStartSystem.Fab_Planner_1__c = IUsers[2].id;
                         eachRiskStartSystem.Fab_Planner_2__c = IUsers[0].id;
                         eachRiskStartSystem.Fab_Planner_3__c = IUsers[1].id;
                         eachRiskStartSystem.Fab_Planner_4__c = IUsers[2].id;
                         eachRiskStartSystem.Fab_Planner_5__c = IUsers[0].id;
                         eachRiskStartSystem.Fab_Planner_6__c = IUsers[1].id;
                         eachRiskStartSystem.Fab_Planner_7__c = IUsers[2].id;
                         eachRiskStartSystem.Fab_Planner_8__c = IUsers[0].id;
                         eachRiskStartSystem.Fab_Planner_9__c = IUsers[1].id;
                         eachRiskStartSystem.Fab_Planner_10__c = IUsers[2].id;
                    }
                }
                if( IUsers.size() == 4 ){
                    if(IUsers[3].id !=null){
                        eachRiskStartSystem.Fab_Planning_User_1__c = IUsers[0].id;
                        eachRiskStartSystem.Fab_Planning_User_2__c = IUsers[1].id;
                        eachRiskStartSystem.Fab_Planning_User_3__c = IUsers[2].id;
                        eachRiskStartSystem.Fab_Planning_User_4__c = IUsers[3].id;
                        eachRiskStartSystem.Fab_Planning_User_5__c = IUsers[2].id;                      
                         eachRiskStartSystem.Fab_Planner_1__c = IUsers[1].id;
                         eachRiskStartSystem.Fab_Planner_2__c = IUsers[0].id;
                         eachRiskStartSystem.Fab_Planner_3__c = IUsers[3].id;
                         eachRiskStartSystem.Fab_Planner_4__c = IUsers[2].id;
                         eachRiskStartSystem.Fab_Planner_5__c = IUsers[1].id;
                         eachRiskStartSystem.Fab_Planner_6__c = IUsers[0].id;
                         eachRiskStartSystem.Fab_Planner_7__c = IUsers[3].id;
                         eachRiskStartSystem.Fab_Planner_8__c = IUsers[2].id;
                         eachRiskStartSystem.Fab_Planner_9__c = IUsers[1].id;
                         eachRiskStartSystem.Fab_Planner_10__c = IUsers[0].id;
                    }
                }
                if( IUsers.size() == 5 ){
                    if(IUsers[4].id !=null){
                        eachRiskStartSystem.Fab_Planning_User_1__c = IUsers[0].id;
                        eachRiskStartSystem.Fab_Planning_User_2__c = IUsers[1].id;
                        eachRiskStartSystem.Fab_Planning_User_3__c = IUsers[2].id;
                        eachRiskStartSystem.Fab_Planning_User_4__c = IUsers[3].id;
                        eachRiskStartSystem.Fab_Planning_User_5__c = IUsers[4].id;
                         eachRiskStartSystem.Fab_Planner_1__c = IUsers[4].id;
                         eachRiskStartSystem.Fab_Planner_2__c = IUsers[3].id;
                         eachRiskStartSystem.Fab_Planner_3__c = IUsers[2].id;
                         eachRiskStartSystem.Fab_Planner_4__c = IUsers[1].id;
                         eachRiskStartSystem.Fab_Planner_5__c = IUsers[0].id;
                         eachRiskStartSystem.Fab_Planner_6__c = IUsers[4].id;
                         eachRiskStartSystem.Fab_Planner_7__c = IUsers[3].id;
                         eachRiskStartSystem.Fab_Planner_8__c = IUsers[2].id;
                         eachRiskStartSystem.Fab_Planner_9__c = IUsers[1].id;
                         eachRiskStartSystem.Fab_Planner_10__c = IUsers[0].id;
                    }
                }
                if( IUsers.size() == 6 ){
                    if(IUsers[5].id !=null){
                        eachRiskStartSystem.Fab_Planning_User_1__c = IUsers[0].id;
                        eachRiskStartSystem.Fab_Planning_User_2__c = IUsers[1].id;
                        eachRiskStartSystem.Fab_Planning_User_3__c = IUsers[2].id;
                        eachRiskStartSystem.Fab_Planning_User_4__c = IUsers[3].id;
                        eachRiskStartSystem.Fab_Planning_User_5__c = IUsers[4].id;
                         eachRiskStartSystem.Fab_Planner_1__c = IUsers[5].id;
                         eachRiskStartSystem.Fab_Planner_2__c = IUsers[2].id;
                         eachRiskStartSystem.Fab_Planner_3__c = IUsers[1].id;
                         eachRiskStartSystem.Fab_Planner_4__c = IUsers[0].id;
                         eachRiskStartSystem.Fab_Planner_5__c = IUsers[5].id;
                         eachRiskStartSystem.Fab_Planner_6__c = IUsers[4].id;
                         eachRiskStartSystem.Fab_Planner_7__c = IUsers[3].id;
                         eachRiskStartSystem.Fab_Planner_8__c = IUsers[2].id;
                         eachRiskStartSystem.Fab_Planner_9__c = IUsers[1].id;
                         eachRiskStartSystem.Fab_Planner_10__c = IUsers[0].id;
                    }
                }
                if( IUsers.size() == 7 ){
                    if(IUsers[6].id !=null){
                        eachRiskStartSystem.Fab_Planning_User_1__c = IUsers[0].id;
                        eachRiskStartSystem.Fab_Planning_User_2__c = IUsers[1].id;
                        eachRiskStartSystem.Fab_Planning_User_3__c = IUsers[2].id;
                        eachRiskStartSystem.Fab_Planning_User_4__c = IUsers[3].id;
                        eachRiskStartSystem.Fab_Planning_User_5__c = IUsers[4].id;
                         eachRiskStartSystem.Fab_Planner_1__c = IUsers[5].id;
                         eachRiskStartSystem.Fab_Planner_2__c = IUsers[6].id;
                         eachRiskStartSystem.Fab_Planner_3__c = IUsers[0].id;
                         eachRiskStartSystem.Fab_Planner_4__c = IUsers[6].id;
                         eachRiskStartSystem.Fab_Planner_5__c = IUsers[5].id;
                         eachRiskStartSystem.Fab_Planner_6__c = IUsers[4].id;
                         eachRiskStartSystem.Fab_Planner_7__c = IUsers[3].id;
                         eachRiskStartSystem.Fab_Planner_8__c = IUsers[2].id;
                         eachRiskStartSystem.Fab_Planner_9__c = IUsers[1].id;
                         eachRiskStartSystem.Fab_Planner_10__c = IUsers[0].id;
                    }
                }
                if( IUsers.size() == 8 ){
                    if(IUsers[7].id !=null){
                        eachRiskStartSystem.Fab_Planning_User_1__c = IUsers[0].id;
                        eachRiskStartSystem.Fab_Planning_User_2__c = IUsers[1].id;
                        eachRiskStartSystem.Fab_Planning_User_3__c = IUsers[2].id;
                        eachRiskStartSystem.Fab_Planning_User_4__c = IUsers[3].id;
                        eachRiskStartSystem.Fab_Planning_User_5__c = IUsers[4].id;
                         eachRiskStartSystem.Fab_Planner_1__c = IUsers[5].id;
                         eachRiskStartSystem.Fab_Planner_2__c = IUsers[6].id;
                         eachRiskStartSystem.Fab_Planner_3__c = IUsers[7].id;
                         eachRiskStartSystem.Fab_Planner_4__c = IUsers[6].id;
                         eachRiskStartSystem.Fab_Planner_5__c = IUsers[5].id;
                         eachRiskStartSystem.Fab_Planner_6__c = IUsers[4].id;
                         eachRiskStartSystem.Fab_Planner_7__c = IUsers[3].id;
                         eachRiskStartSystem.Fab_Planner_8__c = IUsers[2].id;
                         eachRiskStartSystem.Fab_Planner_9__c = IUsers[1].id;
                         eachRiskStartSystem.Fab_Planner_10__c = IUsers[0].id;
                    }
                }
                if( IUsers.size() == 9 ){
                    if(IUsers[8].id !=null){
                        eachRiskStartSystem.Fab_Planning_User_1__c = IUsers[0].id;
                        eachRiskStartSystem.Fab_Planning_User_2__c = IUsers[1].id;
                        eachRiskStartSystem.Fab_Planning_User_3__c = IUsers[2].id;
                        eachRiskStartSystem.Fab_Planning_User_4__c = IUsers[3].id;
                        eachRiskStartSystem.Fab_Planning_User_5__c = IUsers[4].id;
                         eachRiskStartSystem.Fab_Planner_1__c = IUsers[5].id;
                         eachRiskStartSystem.Fab_Planner_2__c = IUsers[6].id;
                         eachRiskStartSystem.Fab_Planner_3__c = IUsers[7].id;
                         eachRiskStartSystem.Fab_Planner_4__c = IUsers[8].id;
                         eachRiskStartSystem.Fab_Planner_5__c = IUsers[5].id;
                         eachRiskStartSystem.Fab_Planner_6__c = IUsers[4].id;
                         eachRiskStartSystem.Fab_Planner_7__c = IUsers[3].id;
                         eachRiskStartSystem.Fab_Planner_8__c = IUsers[2].id;
                         eachRiskStartSystem.Fab_Planner_9__c = IUsers[1].id;
                         eachRiskStartSystem.Fab_Planner_10__c = IUsers[0].id;
                    }
                }
                if( IUsers.size() == 10 ){
                    if(IUsers[9].id !=null){
                        eachRiskStartSystem.Fab_Planning_User_1__c = IUsers[0].id;
                        eachRiskStartSystem.Fab_Planning_User_2__c = IUsers[1].id;
                        eachRiskStartSystem.Fab_Planning_User_3__c = IUsers[2].id;
                        eachRiskStartSystem.Fab_Planning_User_4__c = IUsers[3].id;
                        eachRiskStartSystem.Fab_Planning_User_5__c = IUsers[4].id;
                         eachRiskStartSystem.Fab_Planner_1__c = IUsers[5].id;
                         eachRiskStartSystem.Fab_Planner_2__c = IUsers[6].id;
                         eachRiskStartSystem.Fab_Planner_3__c = IUsers[7].id;
                         eachRiskStartSystem.Fab_Planner_4__c = IUsers[8].id;
                         eachRiskStartSystem.Fab_Planner_5__c = IUsers[9].id;
                         eachRiskStartSystem.Fab_Planner_6__c = IUsers[4].id;
                         eachRiskStartSystem.Fab_Planner_7__c = IUsers[3].id;
                         eachRiskStartSystem.Fab_Planner_8__c = IUsers[2].id;
                         eachRiskStartSystem.Fab_Planner_9__c = IUsers[1].id;
                         eachRiskStartSystem.Fab_Planner_10__c = IUsers[0].id;
                    }
                }
                if( IUsers.size() == 11 ){
                    if(IUsers[10].id !=null){
                        eachRiskStartSystem.Fab_Planning_User_1__c = IUsers[0].id;
                        eachRiskStartSystem.Fab_Planning_User_2__c = IUsers[1].id;
                        eachRiskStartSystem.Fab_Planning_User_3__c = IUsers[2].id;
                        eachRiskStartSystem.Fab_Planning_User_4__c = IUsers[3].id;
                        eachRiskStartSystem.Fab_Planning_User_5__c = IUsers[4].id;
                         eachRiskStartSystem.Fab_Planner_1__c = IUsers[5].id;
                         eachRiskStartSystem.Fab_Planner_2__c = IUsers[6].id;
                         eachRiskStartSystem.Fab_Planner_3__c = IUsers[7].id;
                         eachRiskStartSystem.Fab_Planner_4__c = IUsers[8].id;
                         eachRiskStartSystem.Fab_Planner_5__c = IUsers[9].id;
                         eachRiskStartSystem.Fab_Planner_6__c = IUsers[10].id;
                         eachRiskStartSystem.Fab_Planner_7__c = IUsers[3].id;
                         eachRiskStartSystem.Fab_Planner_8__c = IUsers[2].id;
                         eachRiskStartSystem.Fab_Planner_9__c = IUsers[1].id;
                         eachRiskStartSystem.Fab_Planner_10__c = IUsers[0].id;
                    }
                }
                if( IUsers.size() == 12 ){
                    if(IUsers[11].id !=null){
                        eachRiskStartSystem.Fab_Planning_User_1__c = IUsers[0].id;
                        eachRiskStartSystem.Fab_Planning_User_2__c = IUsers[1].id;
                        eachRiskStartSystem.Fab_Planning_User_3__c = IUsers[2].id;
                        eachRiskStartSystem.Fab_Planning_User_4__c = IUsers[3].id;
                        eachRiskStartSystem.Fab_Planning_User_5__c = IUsers[4].id;
                         eachRiskStartSystem.Fab_Planner_1__c = IUsers[5].id;
                         eachRiskStartSystem.Fab_Planner_2__c = IUsers[6].id;
                         eachRiskStartSystem.Fab_Planner_3__c = IUsers[7].id;
                         eachRiskStartSystem.Fab_Planner_4__c = IUsers[8].id;
                         eachRiskStartSystem.Fab_Planner_5__c = IUsers[9].id;
                         eachRiskStartSystem.Fab_Planner_6__c = IUsers[10].id;
                         eachRiskStartSystem.Fab_Planner_7__c = IUsers[11].id;
                         eachRiskStartSystem.Fab_Planner_8__c = IUsers[2].id;
                         eachRiskStartSystem.Fab_Planner_9__c = IUsers[1].id;
                         eachRiskStartSystem.Fab_Planner_10__c = IUsers[0].id;
                    }
                }
                if( IUsers.size() == 13 ){
                    if(IUsers[12].id !=null){
                        eachRiskStartSystem.Fab_Planning_User_1__c = IUsers[0].id;
                        eachRiskStartSystem.Fab_Planning_User_2__c = IUsers[1].id;
                        eachRiskStartSystem.Fab_Planning_User_3__c = IUsers[2].id;
                        eachRiskStartSystem.Fab_Planning_User_4__c = IUsers[3].id;
                        eachRiskStartSystem.Fab_Planning_User_5__c = IUsers[4].id;
                         eachRiskStartSystem.Fab_Planner_1__c = IUsers[5].id;
                         eachRiskStartSystem.Fab_Planner_2__c = IUsers[6].id;
                         eachRiskStartSystem.Fab_Planner_3__c = IUsers[7].id;
                         eachRiskStartSystem.Fab_Planner_4__c = IUsers[8].id;
                         eachRiskStartSystem.Fab_Planner_5__c = IUsers[9].id;
                         eachRiskStartSystem.Fab_Planner_6__c = IUsers[10].id;
                         eachRiskStartSystem.Fab_Planner_7__c = IUsers[11].id;
                         eachRiskStartSystem.Fab_Planner_8__c = IUsers[12].id;
                         eachRiskStartSystem.Fab_Planner_9__c = IUsers[1].id;
                         eachRiskStartSystem.Fab_Planner_10__c = IUsers[0].id;
                    }
                }
                if( IUsers.size() == 14 ){
                    if(IUsers[13].id !=null){
                        eachRiskStartSystem.Fab_Planning_User_1__c = IUsers[0].id;
                        eachRiskStartSystem.Fab_Planning_User_2__c = IUsers[1].id;
                        eachRiskStartSystem.Fab_Planning_User_3__c = IUsers[2].id;
                        eachRiskStartSystem.Fab_Planning_User_4__c = IUsers[3].id;
                        eachRiskStartSystem.Fab_Planning_User_5__c = IUsers[4].id;
                         eachRiskStartSystem.Fab_Planner_1__c = IUsers[5].id;
                         eachRiskStartSystem.Fab_Planner_2__c = IUsers[6].id;
                         eachRiskStartSystem.Fab_Planner_3__c = IUsers[7].id;
                         eachRiskStartSystem.Fab_Planner_4__c = IUsers[8].id;
                         eachRiskStartSystem.Fab_Planner_5__c = IUsers[9].id;
                         eachRiskStartSystem.Fab_Planner_6__c = IUsers[10].id;
                         eachRiskStartSystem.Fab_Planner_7__c = IUsers[11].id;
                         eachRiskStartSystem.Fab_Planner_8__c = IUsers[12].id;
                         eachRiskStartSystem.Fab_Planner_9__c = IUsers[13].id;
                         eachRiskStartSystem.Fab_Planner_10__c = IUsers[0].id;
                    }
                }
                if( IUsers.size() == 15 ){
                    if(IUsers[14].id !=null){
                        eachRiskStartSystem.Fab_Planning_User_1__c = IUsers[0].id;
                        eachRiskStartSystem.Fab_Planning_User_2__c = IUsers[1].id;
                        eachRiskStartSystem.Fab_Planning_User_3__c = IUsers[2].id;
                        eachRiskStartSystem.Fab_Planning_User_4__c = IUsers[3].id;
                        eachRiskStartSystem.Fab_Planning_User_5__c = IUsers[4].id;
                         eachRiskStartSystem.Fab_Planner_1__c = IUsers[5].id;
                         eachRiskStartSystem.Fab_Planner_2__c = IUsers[6].id;
                         eachRiskStartSystem.Fab_Planner_3__c = IUsers[7].id;
                         eachRiskStartSystem.Fab_Planner_4__c = IUsers[8].id;
                         eachRiskStartSystem.Fab_Planner_5__c = IUsers[9].id;
                         eachRiskStartSystem.Fab_Planner_6__c = IUsers[10].id;
                         eachRiskStartSystem.Fab_Planner_7__c = IUsers[11].id;
                         eachRiskStartSystem.Fab_Planner_8__c = IUsers[12].id;
                         eachRiskStartSystem.Fab_Planner_9__c = IUsers[13].id;
                         eachRiskStartSystem.Fab_Planner_10__c = IUsers[14].id;
                    }
                }
            }

            // Collect all Risk Starts where No Fab Planners found. 
            if (!flagFabPlanners) {
                retVal.add(eachRiskStartSystem); 
            }
            flagFabPlanners = false;
        }
        return retVal;      
    }
    
    public static void validatePoDate(List<Risk_Start_System__c> oldRSSList, List<Risk_Start_System__c> newRSSList) {
        
        if(newRSSList == null)return;
        
        Boolean isError = false;
        String errorMessage = '';
        
        for(Risk_Start_System__c rssObject : newRSSList){
            
            isError = false;
            errorMessage = 'Please enter a valid ';
            
            rssObject.PO_Cycle_Time__c = null;
            //rssObject.Scrap_Cycle_Time__c = null;
            //rssObject.Write_Off_Cycle_Time__c = null;
            //rssObject.Void_Cycle_Time__c = null;
        
            if(rssObject.PO_Arrival_Date__c != null && ! validateDate(rssObject.PO_Arrival_Date__c, rssObject, 'PO Arrival') ){
                
                isError = true;
                errorMessage += 'PO Arrival Date';
            }
            /*
            if(rssObject.Scrap_Date__c != null && ! validateDate(rssObject.Scrap_Date__c, rssObject, 'Scrap') ){
                
                if(isError){
                    errorMessage += ', Scrap Date';
                }
                else{
                    isError = true;
                    errorMessage += 'Scrap Date';
                }
            }
            
            if(rssObject.Write_Off_Date__c != null && ! validateDate(rssObject.Write_Off_Date__c, rssObject, 'Write Off') ){
                
                if(isError){
                    errorMessage += ', Write Off Date';
                }
                else{
                    isError = true;
                    errorMessage += 'Write Off Date';
                }
            }
            
            if(rssObject.Void_Date__c != null && ! validateDate(rssObject.Void_Date__c, rssObject, 'Void Date') ){
                
                if(isError){
                    errorMessage += ', Void Date';
                }
                else{
                    isError = true;
                    errorMessage += 'Void Date';
                }
            }
            */
            if(isError && ! Test.isRunningTest()){
                rssObject.addError(errorMessage + '. ( ex. MM/DD/YYYY)');
            }
        }
    }
    
    private static Boolean validateDate(String dateString, Risk_Start_System__c rssObject, String fieldType) {
        
        List<String> tempPODateList = dateString.split(';');
        List<String> tempPODatePartList;
         
        String tempString = null;
        
        for(String tempDate : tempPODateList){
            
            tempPODatePartList = tempDate.split('/');
            
            if(tempPODatePartList.size() != 3){
                
                return false;
            }
            else{
                try{
                    Date.valueOf(tempPODatePartList[2].trim() + '-' + tempPODatePartList[0].trim() + '-' + tempPODatePartList[1].trim());
                }
                catch(Exception e){
                    return false; 
                }
            }
            
            if( rssObject.Expected_PO_Date__c != null ){
                
                if(tempString != null){
                    
                    tempString += ';' + rssObject.Expected_PO_Date__c.daysBetween(Date.valueOf(tempPODatePartList[2].trim() + '-' + tempPODatePartList[0].trim() + '-' + tempPODatePartList[1].trim()));
                }
                else{
                
                    tempString = String.valueOf( rssObject.Expected_PO_Date__c.daysBetween(Date.valueOf(tempPODatePartList[2].trim() + '-' + tempPODatePartList[0].trim() + '-' + tempPODatePartList[1].trim())) );
                }
            }
        }
        
        if(fieldType.equalsIgnoreCase('PO Arrival')){
            
            rssObject.PO_Cycle_Time__c = tempString;
        }
        /*else if(fieldType.equalsIgnoreCase('Scrap')){
            
            rssObject.Scrap_Cycle_Time__c = tempString;
        }
        else if(fieldType.equalsIgnoreCase('Write Off')){
            
            rssObject.Write_Off_Cycle_Time__c = tempString;
        }
        else if(fieldType.equalsIgnoreCase('Void Date')){
            
            rssObject.Void_Cycle_Time__c = tempString;
        }
        */
        return true;
    }
    
    /*********************************************************************************************************************************************************
    @ Method:         resetApprovalReminder
    @ Version:        1.0
    @ Author:         Pradosh Samal(pradosh.samal@globalfoundries.com)
    @ Purpose:        This method is used to reset pending approval reminder flag.
    **********************************************************************************************************************************************************/
    public static void resetApprovalReminder(List<Risk_Start_System__c> newRSSList, Map<Id, Risk_Start_System__c> oldRSSMap) {
        
        for(Risk_Start_System__c riskStartSystem : newRSSList){
            
            if(riskStartSystem.Status__c != oldRSSMap.get(riskStartSystem.Id).Status__c){
                
                riskStartSystem.First_Approval_Reminder__c  = FALSE;
                riskStartSystem.Second_Approval_Reminder__c = FALSE;
                riskStartSystem.Third_Approval_Reminder__c  = FALSE;
            }
        }
    }
}