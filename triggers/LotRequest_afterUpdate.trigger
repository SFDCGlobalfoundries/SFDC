trigger LotRequest_afterUpdate on Lot_Request__c (after update) {
    //Commenting the Trigger for future deletion from Production.
    
    Integer i = 0;
    i=i+1;
    // NJain    17Jun-15
    // Commenting the logic as this is now being implemented when the Lot Instruction
    // is updated by the Mfg Lot change so as to automate the process.
    /*
    Set<String> setLotReqIds = new Set<String>();
    map<String,List<Lot_Instruction__c>> mapStrLotInstr = new map<String,List<Lot_Instruction__c>>();
    List<Lot_Request__c> lstRequestsToUpdate = new List<Lot_Request__c>();
    
    for(Lot_Request__c lotReq:Trigger.new){
        if((lotReq.Stage__c=='Fully Approved'||lotReq.Stage__c=='Under Execution') && Trigger.oldMap.get(lotReq.id).Stage__c != lotReq.Stage__c){
            setLotReqIds.add(lotReq.id);
        }
    }
    
    List<Lot_Request__c> lstLotRequests = [select id,(select name,New_CSD_P__c, Actual_Fab_Out_Date__c,Did_Actual_FOD_meets_AbleToSupport_FOD__c,
                                                        Did_Ship_Date_Meet_New_CSD__c from Request_to_Lot_Tags__r) 
                                            from Lot_Request__c where id in:setLotReqIds];
    
    for(Lot_Request__c lr:lstLotRequests){
        mapStrLotInstr.put(lr.id,lr.Request_to_Lot_Tags__r);
    }
    
    for(String ReqId:mapStrLotInstr.keySet()){
        boolean flag= false;
        for(Lot_Instruction__c lotInstr:mapStrLotInstr.get(ReqId)){
            if(lotInstr.Actual_Fab_Out_Date__c  == NULL || lotInstr.New_CSD_P__c == NULL){
                flag = true;
                break;
            }
        }
        
        if(flag == false){
            Integer Passed = 0;
            Integer Missed = 0;
            for(Lot_Instruction__c lotInstr:mapStrLotInstr.get(ReqId)){
                //++ chaged the logic as per King's mail -- Oct.07,2013
                if(lotInstr.Did_Ship_Date_Meet_New_CSD__c == 'Yes'){
                    Passed = Passed + 1;
                }
                else if(lotInstr.Did_Ship_Date_Meet_New_CSD__c == 'No'){
                    Missed = Missed+1;
                }else{}
                //-- chaged the logic as per King's mail -- Oct.07,2013
            }
            Lot_Request__c lotReq = new Lot_Request__c(id=ReqId);
            lotReq.No_of_Passed_Instructions__c = Passed;
            lotReq.No_of_Missed_Instructions__c = Missed;
            if(Missed == 0 && Passed != 0){
                lotReq.Stage__c = 'Closed - Fully Executed';
            }else if(Missed != 0){
                lotReq.Stage__c = 'Closed - Partially Executed';
            }
            lstRequestsToUpdate.add(lotReq);
        }
    }
    
    if(!lstRequestsToUpdate.isEmpty()){
        Database.update(lstRequestsToUpdate);
    }
    
    
    //++Added by Nikhil-- 18-Jun-15
    if(Trigger.isAfter && Trigger.isUpdate){
        List<Lot_Request__c> lstLotReqToProcess = new List<Lot_Request__c>();
        for(Lot_Request__c lotReq: Trigger.New){
            if(lotReq.Expedite_Manager_Recommendation_EM__c != Trigger.OldMap.get(lotReq.Id).Expedite_Manager_Recommendation_EM__c){
                lstLotReqToProcess.add(lotReq);
            }
        }
        LotServiceRequest_TriggerHandler.ApproveRejectRec(lstLotReqToProcess, Trigger.OldMap);
    }
    //--Added by Nikhil-- 18-Jun-15
    */   
}