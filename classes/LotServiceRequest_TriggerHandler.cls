public class LotServiceRequest_TriggerHandler{
    
    /* Approve/Reject based on the field values. */
    public static void ApproveRejectRec(List<Lot_Request__c> lstLotReq,Map<Id,Lot_Request__C> lotReqOldMap){
        List<Lot_Instruction__c> lstLotInstrToUpdate = new List<Lot_Instruction__c>();
        List<Lot_Request__c> lstLotReqForCSD = new List<Lot_Request__c>();
        
        for(Lot_Request__c lotReq : lstLotReq){
            if(lotReqOldMap.get(lotReq.Id).Stage__c == 'Submitted for Review by Expedite Manager'){
                
                //Lot Service Requests to be Approved or Rejected
                if(lotReq.Expedite_Manager_Recommendation_EM__c == 'Approved Under Corridor' || 
                   lotReq.Expedite_Manager_Recommendation_EM__c == 'Approved for Planner Feedback' ||
                   lotReq.Expedite_Manager_Recommendation_EM__c == 'Approved under Contract'
                   //Added by ravi as a part of lot phase 3 
                ){
                    approveRecord(lotReq);
                }else if(lotReq.Expedite_Manager_Recommendation_EM__c == 'Rejected'){
                    rejectRecord(lotReq);
                }
                
                //Lot Service Requests for which the Lot Instructions needs to updated for New CSD (P) date
                if(lotReq.Expedite_Manager_Recommendation_EM__c != 'Rejected' &&
                   lotReq.Expedite_Manager_Recommendation_EM__c != ''){
                    lstLotReqForCSD.add(lotReq);
                }
            }
            //Incase of Fast Track Approval
            else if((lotReqOldMap.get(lotReq.Id).Stage__c == 'Acknowledged by CSR' ||
                      lotReqOldMap.get(lotReq.Id).Stage__c == 'New Request') && 
                      lotReq.Stage__c == 'Pending Planner Response' &&
                      lotReq.Expedite_Manager_Recommendation_EM__c == 'Approval Not Required'){
                lstLotReqForCSD.add(lotReq);
            }
        }
        
        // New CSD (P) population in Lot Instructions at Pending Planner Response / Request for Planner feedback with Current CSD Date
        for(Lot_Instruction__c lotInstr: [SELECT Id,New_CSD_P__c,Current_CSD_ML_at_time_of_Submission__c 
                                            FROM Lot_Instruction__c 
                                            WHERE Lot_Request__c in :lstLotReqForCSD]){
            lotInstr.New_CSD_P__c = lotInstr.Current_CSD_ML_at_time_of_Submission__c ;
            lstLotInstrToUpdate.add(lotInstr);
        }
        try{
            if(!lstLotInstrToUpdate.isEmpty()){
                update(lstLotInstrToUpdate);
            }
        }catch(Exception e){
            for(Lot_Request__c lotReq: lstLotReqForCSD){
                lotReq.addError('Some Error Occurred : '+ e.getdmlMessage(0));
            }
        }
        
    }
    
    /* Get ProcessInstanceWorkItemId using SOQL */
    public static Id getWorkItemId(Id targetObjectId){
        Id retVal = null;
        for(ProcessInstanceWorkitem workItem: [SELECT p.Id from ProcessInstanceWorkitem p
                                                WHERE p.ProcessInstance.TargetObjectId =: targetObjectId
                                                  AND p.ProcessInstance.Status = 'Pending'])
        {
            retVal  =  workItem.Id;
        }
        return retVal;
    }
    
    /* This method will Approve the Lot Service Request */
    public static void approveRecord(Lot_Request__c lotReq){
        Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
        req.setComments('Approving request automatically by system on Field Update');
        req.setAction('Approve');
        req.setNextApproverIds(new Id[] {UserInfo.getUserId()});
        Id workItemId = getWorkItemId(lotReq.id); 
        
        if(workItemId == NULL){
            lotReq.addError('Some Exception occurred. Please contact system administrator.');
            system.debug('###Exception###');
        }
        else{
            req.setWorkitemId(workItemId);
             system.debug('before updating ' +lotReq.stage__c);
            // Submit the request for approval
            Approval.ProcessResult result =  Approval.process(req);
        }
    }
    
    /* This method will Reject the Lot Service Request */
    public static void rejectRecord(Lot_Request__c lotReq){
        Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
        req.setComments('Rejected request using Trigger');
        req.setAction('Reject');
        Id workItemId = getWorkItemId(lotReq.id);   

        if(workItemId == null){
            lotReq.addError('Error Occured in Trigger');
        }
        else{
            req.setWorkitemId(workItemId);
            // Submit the request for approval
            Approval.ProcessResult result =  Approval.process(req);
        }
    }
    
    /* Updating the Stage of the Lot Service Request based on the Expedite Manager Recommendation (EM) */
    /*public static void updateStage(List<Lot_Request__c> lstLotReqToProcess, Map<Id,Lot_Request__c> TriggerOldMap){
        for(Lot_Request__c lotReq: lstLotReqToProcess){
            if(TriggerOldMap.get(lotReq.Id).Stage__c == 'Submitted for Review by Expedite Manager'){
                if(lotReq.Expedite_Manager_Recommendation_EM__c == 'Approved Under Corridor' || 
                   lotReq.Expedite_Manager_Recommendation_EM__c == 'Approved for Planner Feedback'
                ){
                    lotReq.Stage__c = 'Pending Planner Response';
                }else if(lotReq.Expedite_Manager_Recommendation_EM__c == 'Rejected'){
                    lotReq.Stage__c = 'Closed - Rejected';
                }
            }
        }
    }*/
    
    
    /* This method will update the Planner Recommendations (P) based on the EM Recommendations and the Approve/Reject response and
       several Date Calculations based on CSD and CRD dates.
    */  
    public static void updatePlannerRec(List<Lot_Request__c> lstLotReqForPlannerRec, Map<Id,Lot_Request__c> TriggerOldMap){
        
        Map<String,Integer> mapCSDmeetCRD = new Map<String,Integer>();                                
        Map<String,Integer> mapCSDNewLHCurrent = new Map<String,Integer>();                                
        
        List<Lot_Instruction__c> lstLotInstrToUpdate = new List<Lot_Instruction__c>();
        //List<Lot_Request__c> lstLotReqForCSDatPlSbms = new List<Lot_Request__c>();
        
        //checking the count of Lot instructions in which the CSD meets CRD under a Lot Service Request
        for(AggregateResult lotInstrAggr: [SELECT count(Id) cnt,Lot_Request__c  
                                            FROM Lot_Instruction__c 
                                            WHERE New_CSD_P_Meets_SubmittedCRD__c = true 
                                                AND Lot_Request__c  in: lstLotReqForPlannerRec
                                            GROUP BY Lot_Request__c]){
            mapCSDmeetCRD.put(String.valueOf(lotInstrAggr.get('Lot_Request__c')),Integer.valueOf(lotInstrAggr.get('cnt')));
        }
        
        //checking the count of Lot instructions in which the NEW CSD (P) less than the Current CSD (ML) under a Lot Service Request
        for(AggregateResult lotInstrAggr: [SELECT count(Id) cnt,Lot_Request__c  
                                            FROM Lot_Instruction__c 
                                            WHERE New_CSD_P_Earlier_Than_Current_CSD__c = true 
                                                AND Lot_Request__c  in: lstLotReqForPlannerRec
                                            GROUP BY Lot_Request__c]){
            mapCSDNewLHCurrent.put(String.valueOf(lotInstrAggr.get('Lot_Request__c')),Integer.valueOf(lotInstrAggr.get('cnt')));
        }
        map<Id,Lot_Request__c> mapIdLotRequest = new Map<Id,Lot_Request__c>();
        //Updating the Planner Recommendations (P) accordingly based on the Stage, EM Recommendations and Dates in Lot Instructions
        for(Lot_Request__c lotReq: lstLotReqForPlannerRec){
            if(lotReq.Stage__c == 'Fully Approved'){
                //lstLotReqForCSDatPlSbms.add(lotReq);
                mapIdLotRequest.put(lotReq.Id,lotReq);
                
                if(lotReq.Customer_Requested_Lot_Qty__c == mapCSDmeetCRD.get(lotReq.Id)){
                    lotReq.Planner_Recommendation_P__c = 'Supported to meet CRD';
                }else if(lotReq.Customer_Requested_Lot_Qty__c != mapCSDmeetCRD.get(lotReq.Id) &&
                         lotReq.Customer_Requested_Lot_Qty__c == mapCSDNewLHCurrent.get(lotReq.Id)){
                    lotReq.Planner_Recommendation_P__c = 'Supported with improved CSD but not meeting CRD';
                }else if(lotReq.Customer_Requested_Lot_Qty__c != mapCSDmeetCRD.get(lotReq.Id) &&
                         lotReq.Customer_Requested_Lot_Qty__c != mapCSDNewLHCurrent.get(lotReq.Id)){
                    if(lotReq.Expedite_Manager_Recommendation_EM__c != 'Approved Under Corridor'){
                        if(mapCSDNewLHCurrent.get(lotReq.Id) > 0){
                            lotReq.Planner_Recommendation_P__c = 'Request Partially Supported (Multiple Lots)';
                        }else{
                            lotReq.addError('For this request under Non-Corridor approval, none of the Lots is meeting Current CSD(ML)');
                        }
                    }else{
                        lotReq.addError('For this request Under Corridor approval, New CSD (P) should be earlier than the Current CSD (ML) for all the associated Lot Instructions');
                    }
                }
            }else if(lotReq.Stage__c == 'Closed - Rejected'){
                if(lotReq.Expedite_Manager_Recommendation_EM__c == 'Approved Under Corridor'){
                    //This is not executed as the Stage is changed to EM when Planner rejects the request.
                }else{
                    lotReq.Planner_Recommendation_P__c = 'Unable to Support';
                }
            }
        }
        //Populate 'Current CSD at Planner Submission Stage' in Lot Instructions at Time of Approval of Lot Service Request by Planners
        //Manufacturing_Lot__r.Current_Scheduled_Date_CSD__c Added By Jabee.
        for(Lot_Instruction__c lotInstr: [SELECT Id,Current_CSD_at_Planner_Submission_Stage__c,Current_CSD_ML_at_time_of_Submission__c ,Manufacturing_Lot__r.Current_Scheduled_Date_CSD__c,Lot_Request__c
                                            FROM Lot_Instruction__c 
                                            WHERE Lot_Request__c in :mapIdLotRequest.keySet()]){
            if(lotInstr.Current_CSD_ML_at_time_of_Submission__c!=null){                                
                lotInstr.Current_CSD_at_Planner_Submission_Stage__c = lotInstr.Current_CSD_ML_at_time_of_Submission__c ;
            }
            else{//Added By Jabee
                if(lotInstr.Manufacturing_Lot__r.Current_Scheduled_Date_CSD__c!=null){
                    lotInstr.Current_CSD_ML_at_time_of_Submission__c=lotInstr.Manufacturing_Lot__r.Current_Scheduled_Date_CSD__c;
                     lotInstr.Current_CSD_at_Planner_Submission_Stage__c = lotInstr.Current_CSD_ML_at_time_of_Submission__c ;
                }
            }
            lstLotInstrToUpdate.add(lotInstr);
        }
        if(!lstLotInstrToUpdate.isEmpty()){
            Database.SaveResult[] SR = Database.update(lstLotInstrToUpdate,false);
            Database.Error[] err;
            System.debug('####Lots Updation Status####:' + SR);
            
            for(Integer i=0;i<SR.size();i++){
                if(!SR[i].isSuccess()){//only look at failures, and NOT Successes
                  system.debug(SR[i]. getErrors());
                   err=SR[i].getErrors();
                  system.debug('###Erroneous Record####:'+ lstLotInstrToUpdate[i]); //Failed Record
                  mapIdLotRequest.get(lstLotInstrToUpdate[i].Lot_Request__c).addError(err[i].getMessage());
                }
            }
        }      
    }
    
    /*
    Author: Zymark Ambat
    Description: This method populates the Lot_Request_Price_Table__c fields in the Lot Service Request record.
    History: 
        ZAmbat    11032013       - Code creation.
        NJain     25-Jun-2015    - Updated the logic for population of Lot Request Price Table.
                                   Removed logic for popiulating Fab Cycle Time Table at Lot Service Request level.
    */
    public static void populateTimePriceTables(List<Lot_Request__c> listLotRequest){
        
        map<string, Id> mapLRPT = new map<string, Id>();
        for (Lot_Request_Price_Table__c l : [SELECT     Id, Fab__c, Effective_Quarter__c
                                             FROM       Lot_Request_Price_Table__c
                                             WHERE      Active__c = true]) { 
            mapLRPT.put(l.Fab__c, l.Id);
        }
        
        for (Lot_Request__c l : listLotRequest) {
            //Populating the Lot Request Price Table based on the Fab at Lot Request level.
            if(mapLRPT.containsKey(l.Fab__c)){
                l.Lot_Request_Price_Table__c = mapLRPT.get(l.Fab__c);
            }else{
                l.Lot_Request_Price_Table__c = NULL;
            }
        }
    }
}