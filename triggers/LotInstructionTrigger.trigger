/*
    History: 
        NJain       23-Jun-2015 -   Removed the logic for populating Passed and Missed Instructions through Code.
                                    Restructured the existing code for assigning Current_Wafer_Quantity_in_the_Lot_ML__c
                                    Added logic for populating PO Lead Time on Lot Instruction record
*/
trigger LotInstructionTrigger on Lot_Instruction__c (before insert, before update,after update){
    if(System.Label.SkipLotInstructionTrigger.equalsIgnoreCase('false')){

        if(Trigger.IsAfter && Trigger.IsUpdate){
			  LotInstructionUtil.updateLotId(trigger.newMap,trigger.oldMap);//Added by ravi for Lot phase 3 
            //++ Creating snapshot of Lot Instruction whenever the Lot Type is changed
            List<Lot_Snapshot__c> lstLotSnapshot = new List<Lot_Snapshot__c>();
            for(Lot_Instruction__c lotInstRec:Trigger.new){
                if(lotInstRec.Lot_Type__c != Trigger.oldMap.get(lotInstRec.id).Lot_Type__c){
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
        
        //-------Start Yash Code-------
        // Nikhil : Restructured the existing code and logic for populating PO Lead Time on Lot Instruction record
        if(Trigger.IsBefore && (Trigger.IsInsert || Trigger.IsUpdate)){
            Set<ID> setLotIds =new Set<ID>();
            for(Lot_Instruction__c lotInst: Trigger.new){
                setLotIds.add(lotInst.Manufacturing_Lot__c);        
            }
            Map<String,Manufacturing_Lot__c> mapMfgLots = new Map<String,Manufacturing_Lot__c>([SELECT Id,Current_Wafer_Quantity_In_Lot__c,
                                                                                                       Customer_Device_Id__c,Device_ID_MES__c
                                                                                                FROM Manufacturing_Lot__c 
                                                                                                WHERE Id in :setLotIds]);
            Map<String,String> mapDevicePOLeadTime = new map<String,String>();
            List<String> lstCRMDevices = new List<String>();
            for(Manufacturing_Lot__c mfgLot: mapMfgLots.values()){
                lstCRMDevices.add(mfgLot.Device_ID_MES__c);
            }
            for(PO_Lead_Time__c poLeadTime: [select id,Base_Device__c from PO_Lead_Time__c where Base_Device__c in :lstCRMDevices]){
                mapDevicePOLeadTime.put(poLeadTime.Base_Device__c, poLeadTime.Id);
            }
            
            for(Lot_Instruction__c lotInstru: Trigger.new){
                if(mapMfgLots.get(lotInstru.Manufacturing_Lot__c) != NULL && 
                   lotInstru.Current_Wafer_Quantity_in_the_Lot_ML__c != mapMfgLots.get(lotInstru.Manufacturing_Lot__c).Current_Wafer_Quantity_In_Lot__c){
                    lotInstru.Current_Wafer_Quantity_in_the_Lot_ML__c = mapMfgLots.get(lotInstru.Manufacturing_Lot__c).Current_Wafer_Quantity_In_Lot__c;
                }
                
                if(mapMfgLots.get(lotInstru.Manufacturing_Lot__c) != NULL && 
                   mapDevicePOLeadTime.get(mapMfgLots.get(lotInstru.Manufacturing_Lot__c).Device_ID_MES__c) != NULL &&
                   mapDevicePOLeadTime.get(mapMfgLots.get(lotInstru.Manufacturing_Lot__c).Device_ID_MES__c) != ''){
                    lotInstru.PO_Lead_Time__c = mapDevicePOLeadTime.get(mapMfgLots.get(lotInstru.Manufacturing_Lot__c).Device_ID_MES__c);
                }
            }
        }
        //-------End Yash Code-------
    }
}