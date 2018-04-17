trigger Notes_SWIFT_AUPD on Notes__c (After update) {
    if(!IntegrationUserUtil.isSkipTrigger()){
            Set<String> objID = new Set<String>();
            for(Notes__c obj :Trigger.New){
                if(Trigger.oldMap.get(obj.Id).Synced_with_Oracle_DB__c ==false && obj.Synced_with_Oracle_DB__c){
                    objID.add(obj.Id);
                }
            }
                
                //call the method checkMRSpackageSync
                if(objID != null){
                    MRSSwiftUtility.checkMRSpackageSync(objID);
                }
    }
}