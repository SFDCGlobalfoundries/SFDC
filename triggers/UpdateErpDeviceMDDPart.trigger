trigger UpdateErpDeviceMDDPart on Part__c (before insert, before update, after insert, after update) {
    MDD_ERP_Update__c md = MDD_ERP_Update__c.getInstance('ERP Updates');
    if(md != null && md.Is_Active__c){
        Set<String> strs = new Set<String>();
        for(Part__c p: trigger.new){
            strs.add(p.Part_Number__c);
        }
        Map<String,Id> partERPDeviceMap = new Map<String,Id>();
        for(ERP_Device__c e: [Select Id,Part_Number__c,Lead_Level__c, MSL_Rating__c, Max_Num_Cycles__c from ERP_Device__c where Part_Number__c in: strs]){
            partERPDeviceMap.put(e.Part_Number__c, e.Id);
        }
        List<ERP_Device__c> erpUpdates = new List<ERP_Device__c>();
        List<ERP_Device__c> erpInserts = new List<ERP_Device__c>();
        Map<String,Id> partNumIdMap = new Map<String,Id>();
        for(Part__c p: trigger.new){
            partNumIdMap.put(p.Part_Number__c,p.Id);
            if(partERPDeviceMap.containsKey(p.Part_Number__c)){
                if(trigger.isBefore)
                    p.ERP_Device__c = partERPDeviceMap.get(p.Part_Number__c);
                if(trigger.isAfter){
                    ERP_Device__c eObj = new ERP_Device__c(Id=partERPDeviceMap.get(p.Part_Number__c));
                    //eObj.MSL_Rating__c = p.MSL_Rating__c; Commeted BY Ravi Teja as the MSL rating field on ERP is number and on Part is text
                    eObj.Lead_Level__c = p.Lead_Level__c;
                    eObj.Max_Num_Cycles__c = p.Number_of_reflow_Cycles__c;
                    eObj.Package_Type__c = P.Package_Type__c;
                    eObj.Part_Type__c = P.Part_Type__c;
                    erpUpdates.add(eObj);
                }
            }
            else{
                if(trigger.isAfter){
                    ERP_Device__c eObjIns = new ERP_Device__c();
                    //eObjIns.MSL_Rating__c = p.MSL_Rating__c; Commeted BY Ravi Teja as the MSL rating field on ERP is number and on Part is text
                    eObjIns.Lead_Level__c = p.Lead_Level__c;
                    eObjIns.Max_Num_Cycles__c = p.Number_of_reflow_Cycles__c;
                    eObjIns.Package_Type__c = P.Package_Type__c;
                    eObjIns.Part_Type__c = P.Part_Type__c;
                    eObjIns.Name = p.Part_Number__c;
                    eObjIns.Part_Number__c = p.Part_Number__c;
                    erpInserts.add(eObjIns);
                }
            }
        }
        if(erpUpdates.size() > 0)
            update erpUpdates;
        if(erpInserts.size() > 0){
            insert erpInserts;
            Map<Id,Id> partDeviceMap = new Map<Id,Id>();
            for(ERP_Device__c e: erpInserts){
                if(partNumIdMap.containsKey(e.Name)){
                    partDeviceMap.put(partNumIdMap.get(e.Name),e.Id);
                }
            }
            if(partDeviceMap.size() > 0)
                MDDPartHandler.updatePartWithERPDevice(partDeviceMap);
        }
    }
}