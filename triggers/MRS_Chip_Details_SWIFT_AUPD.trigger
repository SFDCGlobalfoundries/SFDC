/*
Name : 
Author: CognizantMRS_Chip_Details_SWIFT_AUPD 
Company: Cognizant Tech Solutions
Description: After Update Trigger on MRS Chip Details object. After update of MRS Chip Details record, system would check if 
            Synced with Oracle DB checkbox was false before update and it is true now, then it would call checkMRSpackageSync
            from MRSSwiftUtility. 
            Similarly after update of MRS Chip Details record, system would check if 
            created at Oracle DB checkbox was false before update and it is true now, then it would call syncMRSLayerChip
            from MRSpackageSyncHandler. 
            
History:
created     05/13/2014     
*/
trigger MRS_Chip_Details_SWIFT_AUPD on MRS_Chip_Details__c (after update) {
    if(!IntegrationUserUtil.isSkipTrigger()){
        Set<String> MRSId = new Set<String>();
        for(MRS_Chip_Details__c mcd :Trigger.New){
            System.debug('MRS_Chip_Details__c-->'+Trigger.New);
            if(Trigger.oldMap.get(mcd.Id).Synced_with_Oracle_DB__c ==false && mcd.Synced_with_Oracle_DB__c){
                MRSId.add(mcd.MRS__c);
                }
            }
        //call the method checkMRSpackageSync
        if(MRSId != null){
            MRSSwiftUtility.checkMRSpackageSync(MRSId);
        }
        
         //Child record invocation at first time sync
        Set<string> setMRSID = new Set<string>();
        for(MRS_Chip_Details__c pdl : Trigger.new){
            if(Trigger.oldMap.get(pdl.id).created_at_Oracle_DB__c==false && pdl.created_at_Oracle_DB__c)
                setMRSID.add(pdl.MRS__c);
            
        }
        
        if(!setMRSID.isEmpty()){
            MRSpackageSyncHandler.syncMRSLayerChip(setMRSID);
        }
    }
}