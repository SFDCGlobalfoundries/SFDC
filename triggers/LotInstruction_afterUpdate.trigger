trigger LotInstruction_afterUpdate on Lot_Instruction__c (before insert, before update,after update) {
    //Commenting the codes for Future Deletion
    Integer i= 1;
    /*
    if((trigger.IsAfter) &&(trigger.IsUpdate))
    {
    
        //++ Creating snapshot of Lot Instruction whenever the Lot Type is changed
        List<Lot_Snapshot__c> lstLotSnapshot = new List<Lot_Snapshot__c>();
        
        for(Lot_Instruction__c lotInstRec:Trigger.new){
            if(lotInstRec.Lot_Type__c != Trigger.oldMap.get(lotInstRec.id).Lot_Type__c)
            {
                Lot_Snapshot__c lotSnapshot = new Lot_Snapshot__c();
                
                lotSnapshot.BEOL_Progress_Before_Change__c             = Trigger.oldMap.get(lotInstRec.id).BEOL_Progress_ML__c;
                lotSnapshot.Current_Mask_Being_Processed_Before_Chan__c= Trigger.oldMap.get(lotInstRec.id).Current_Mask_Layer_Being_Processed_ML__c;
                lotSnapshot.Current_Wafer_Lot_Progress_Quartile_Befo__c= Trigger.oldMap.get(lotInstRec.id).Current_Wafer_Lot_Progress_Quartile_ML__c;
                lotSnapshot.FEOL_Progress_Before_Change__c             = Trigger.oldMap.get(lotInstRec.id).FEOL_Progress_ML__c;
                lotSnapshot.Lot_Type_Changed_To__c                     = lotInstRec.Lot_Type__c;
                lotSnapshot.Lot_Type_Change_From__c                    = Trigger.oldMap.get(lotInstRec.id).Lot_Type__c;
                lotSnapshot.Manufacturing_Lot__c                       = lotInstRec.Manufacturing_Lot__c;
                lotSnapshot.Remaining_Mask_Count_Before_Change__c      = Trigger.oldMap.get(lotInstRec.id).Remaining_Mask_Count_ML__c;
                lotSnapshot.Request_to_Lot_Tag__c                      = lotInstRec.id;
                lotSnapshot.Total_BEOL_Count_Before_Change__c          = Trigger.oldMap.get(lotInstRec.id).Total_BEOL_Count_ML__c;
                lotSnapshot.Total_FEOL_Count_Before_Change__c          = Trigger.oldMap.get(lotInstRec.id).Total_FEOL_Count_ML__c;
                lotSnapshot.Total_Mask_Count_Before_Change__c          = Trigger.oldMap.get(lotInstRec.id).Total_Mask_Count_ML__c;
                lotSnapshot.Wafer_Lot_Progress_Before_Change__c        = Trigger.oldMap.get(lotInstRec.id).Wafer_Lot_Progress_ML__c;
                
                lstLotSnapshot.add(lotSnapshot);
            }
        }
        
        if(!lstLotSnapshot.isEmpty()){
            Database.insert(lstLotSnapshot);
        }
        //-- Creating snapshot of Lot Instruction whenever the Lot Type is changed
        
    }
    */
    /*
    //--------------Start Yash Code-------
    if((trigger.isbefore) && ((trigger.IsInsert ) ||(trigger.IsUpdate)))
    {
        Set<ID> setLotIds =new Set<ID>();
        for(Lot_Instruction__c lotInst: Trigger.new){
            setLotIds.add(lotInst.Manufacturing_Lot__c);        
        } 
        List<Manufacturing_Lot__c> lstLotRequests = [select id,Current_Wafer_Quantity_In_Lot__c from Manufacturing_Lot__c where id in:setLotIds ];
        System.debug('>>>>>>>lstLotRequests.size()>>>>>>>>'+lstLotRequests.size());
        if(lstLotRequests.size()>0)
        {
            for(Lot_Instruction__c lotInstru: Trigger.new){
                for(integer i=0; i<lstLotRequests.size();i++)
                {
                    if(lotInstru.Current_Wafer_Quantity_in_the_Lot_ML__c <>lstLotRequests[i].Current_Wafer_Quantity_In_Lot__c)
                    {
                        lotInstru.Current_Wafer_Quantity_in_the_Lot_ML__c  = lstLotRequests[i].Current_Wafer_Quantity_In_Lot__c;
                    }
                }
                
                
            }
            //Current_Wafer_Quantity_in_the_Lot_ML__c  <> Manufacturing_Lot__r.Current_Wafer_Quantity_In_Lot__c
        }
    }
    //--------------End Yash Code-------
    */
}