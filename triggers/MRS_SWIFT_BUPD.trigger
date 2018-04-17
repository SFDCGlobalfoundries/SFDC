/*
Author: Cognizant
Company: Cognizant Tech Solutions
Description: Before Update Trigger on MRS object
History:
created     04/5/2014 

- Updated 16-June-2016: SWIFT optimized number of records retrieved in soql (add filter to the QUERIES)    
*/
trigger MRS_SWIFT_BUPD on MRS__c (Before update) {

    if(!IntegrationUserUtil.isSkipTrigger()) {
      
        set<string> setMST = new set<string>();
        
        for(MRS__c mrs :Trigger.New) {
            
            if(mrs.Mask_Set_Title__c!=null) {
                setMST.add(string.valueOf(mrs.Mask_Set_Title__c).substring(0,15));
                setMST.add(string.valueOf(mrs.Mask_Set_Title__c));
            }
        }    
            
        set<id> setMRSPackagentSync = new set<id>(); 
        
        for(MRS_Layer_Association__c dLayer : [select MRS__c from MRS_Layer_Association__c where MRS__c in :trigger.newmap.keyset() and Synced_with_Oracle_DB__c = false]) {  
            setMRSPackagentSync.add(dLayer.MRS__c);
        }
        
        for(MRS_Chip_Details__c dChip :[select MRS__c from MRS_Chip_Details__c where MRS__c in :trigger.newmap.keyset()  and Synced_with_Oracle_DB__c = false]) {
            setMRSPackagentSync.add(dChip.MRS__c);
        }
        
        for(MRS_Layer_Chip_Association__c dFrame : [select MRS_ID__c from MRS_Layer_Chip_Association__c where Mask_Set_Title_Id__c in :setMST and Synced_with_Oracle_DB__c = false]) {
            setMRSPackagentSync.add(dframe.MRS_ID__c); 
        }
      
        for(Notes__c dFrame : [select MRS_ID__c from Notes__c where Mask_Set_Title_Id__c in :setMST and Synced_with_Oracle_DB__c = false]) {
            setMRSPackagentSync.add(dframe.MRS_ID__c);
        }
      
        for(MRS__c mrs:Trigger.new) {
            
            if((setMRSPackagentSync.isEmpty() || !setMRSPackagentSync.contains(mrs.id)) && mrs.Synced_with_Oracle_DB__c) mrs.MRS_Package_Sync__c = true;
            
            if(mrs.Synced_with_Oracle_DB__c) {
                mrs.First_Sync_with_Oracle__c = true;
                mrs.Created_at_Oracle_DB__c = true;
            }       
        }
    }
}