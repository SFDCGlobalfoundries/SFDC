/*
    History: 
        NJain       23-Jun-15      - Created the trigger combining existing(LotRequest_beforeInsertUpdate &LotRequest_afterUpdate)
        ZAmbat      11032014       - Updated code as per CASE 35698.
        NJain       18-Jun-2015    - Updated the trigger and removed unwanted LOC
                                     Added the logic for updating the Stage as per recommendations.
                                     Added the logic for populating Planner Recommendation based upon Approval.
       Rnadella    09/02/2015        -Added the logic for Email invocation when Approval process is Recalled  
      Jabee        06/09/2017      - Added line 89 to do the Recursive check
*/

trigger LotServiceRequestTrigger on Lot_Request__c (before insert, before update, after update) {
    
    if(System.Label.SkipLotServiceRequestTrigger.equalsIgnoreCase('false')){
        
        if(Trigger.isBefore){
            Set<String> setAccountId = new Set<String>();
            map<String, Account_Team_Proxy__c> mapAccntAcntTeamProxy = new map<String, Account_Team_Proxy__c>();
            
            //++ ZAmbat 11032014 -- Populating the Lot Request Price Table based on the Fab
            List<Lot_Request__c> listLotRequest = new List<Lot_Request__c>();
            for(Lot_Request__c lotReq:  Trigger.new){
                setAccountId.add(lotReq.Account__c);            
                if (    (trigger.isInsert 
                         && lotReq.Date_Customer_Submitted_Request__c != null
                         && lotReq.Fab__c != null
                         /*&& lotReq.Geometry__c != null*/)
                     || (trigger.isUpdate
                         && (lotReq.Date_Customer_Submitted_Request__c != trigger.oldMap.get(lotReq.Id).Date_Customer_Submitted_Request__c
                             || lotReq.Fab__c != trigger.oldMap.get(lotReq.Id).Fab__c
                             /*|| lotReq.Geometry__c != trigger.oldMap.get(lotReq.Id).Geometry__c*/))
                 ){
                    listLotRequest.add(lotReq);
                }
            }        
            if (listLotRequest.size() > 0) {
                LotServiceRequest_TriggerHandler.populateTimePriceTables(listLotRequest);
            }
            //-- ZAmbat 11032014 -- Populating the Lot Request Price Table based on the Fab
                    
            //++ Populating Assigned Primary and Backup CSRs
            for(Account_Team_Proxy__c accntTeamProxy: [SELECT User__c,id,Account__c,Team_Role__c from Account_Team_Proxy__c 
                                                        WHERE Account__c in: setAccountId 
                                                          AND Team_Role__c in ('Primary Customer Service Rep','Backup Customer Service Rep')]){
                mapAccntAcntTeamProxy.put(accntTeamProxy.Account__c+';'+accntTeamProxy.Team_Role__c, accntTeamProxy);
            }
            
            for(Lot_Request__c lotReq: Trigger.new){        
                if(lotReq.Account__c != NULL){            
                    if(mapAccntAcntTeamProxy.get(lotReq.Account__c+';'+'Primary Customer Service Rep') != NULL){
                        lotReq.Assigned_CSR_CSR__c = mapAccntAcntTeamProxy.get(lotReq.Account__c+';'+'Primary Customer Service Rep').User__c;
                    }            
                    if(mapAccntAcntTeamProxy.get(lotReq.Account__c+';'+'Backup Customer Service Rep') != NULL){
                        lotReq.Assigned_Backup_CSR_CSR__c = mapAccntAcntTeamProxy.get(lotReq.Account__c+';'+'Backup Customer Service Rep').User__c;
                    }
                }
            }
            //-- for populating Assigned Primary and Backup CSRs
            
            //++ NJain - 18Jun15 -- Updating Stage and Planner Recommendations
            if(Trigger.isBefore && Trigger.isUpdate){
                //List<Lot_Request__c> lstLotReqToProcess = new List<Lot_Request__c>();
                List<Lot_Request__c> lstLotReqForPlannerRec = new List<Lot_Request__c>();
                for(Lot_Request__c lotReq: Trigger.New){
                    //if(lotReq.Expedite_Manager_Recommendation_EM__c != Trigger.OldMap.get(lotReq.Id).Expedite_Manager_Recommendation_EM__c){
                    //    lstLotReqToProcess.add(lotReq);
                    //}
                    if(lotReq.Stage__c != Trigger.oldMap.get(lotReq.Id).Stage__c &&
                       (lotReq.Stage__c == 'Fully Approved' || lotReq.Stage__c == 'Closed - Rejected')){
                        lstLotReqForPlannerRec.add(lotReq);
                    }
                }            
                //Updating the Stage of the Lot Request as per the Recommendations from EMs.
                //if(!lstLotReqToProcess.isEmpty()){
                //    LotServiceRequest_TriggerHandler.updateStage(lstLotReqToProcess, Trigger.OldMap);
                //}            
                //Populating Planner Recommendation (P) based upon Approval.
                if(!lstLotReqForPlannerRec.isEmpty()){
                    LotServiceRequest_TriggerHandler.updatePlannerRec(lstLotReqForPlannerRec, Trigger.OldMap);
                }
            }
            //++ NJain - 18Jun15 -- Updating Stage and Planner Recommendations
        
        }
        
        //++Added by Nikhil-- 18-Jun-15
        if(Trigger.isAfter && Trigger.isUpdate){
             if(MRSCheckRecursive.isFirstRun())
            {
                List<Lot_Request__c> lstLotReqToProcess = new List<Lot_Request__c>();
                 List<Lot_Request__c> lstLotRecall = new List<Lot_Request__c>();
                for(Lot_Request__c lotReq: Trigger.New){
                    if(lotReq.Expedite_Manager_Recommendation_EM__c != Trigger.OldMap.get(lotReq.Id).Expedite_Manager_Recommendation_EM__c){
                        lstLotReqToProcess.add(lotReq);
                    }
                     system.debug(lotReq.Expedite_Manager_Recommendation_EM__c+'*****T*E'+Trigger.OldMap.get(lotReq.Id).Stage__c+'*S*T****'+lotReq.Stage__c);
                    if(!Test.isRunningTest()){
                        if(   (lotReq.Expedite_Manager_Recommendation_EM__c == '' || lotReq.Expedite_Manager_Recommendation_EM__c == NULL)
                           && (lotReq.Stage__c == 'Pending Planner Response' || lotReq.Stage__c == 'Closed - Rejected')
                           && Trigger.OldMap.get(lotReq.Id).Stage__c == 'Submitted for Review by Expedite Manager'){
                            lotReq.addError('Please provide EM Recommendations to Approve/Reject the request.');
                        }
                    }
                    
                }
                LotServiceRequest_TriggerHandler.ApproveRejectRec(lstLotReqToProcess, Trigger.OldMap);
                 //--Added by Nikhil-- 18-Jun-15
                 
                  //++Added by Ravi-- 2-sept-15
                for(Lot_Request__c lr:trigger.new ){
                
                 if(lr.Recalled__c==true && trigger.oldMap.get(lr.id).Recalled__c != true){
                    lstLotRecall.add(lr);
                 }
                
                }
                if(!lstLotRecall.isEmpty()){
                    
                    LotApprovalProcessUtil.sendEmailtoApprovers(lstLotRecall);
                }
                //--Added by Ravi-- 2-sept-15
            }
        }
       
    }
}