/*
Type Name: MRS_Layer_Chip_Association_SWIFT_AINS 
Author: Cognizant 
Created Date: 29-April-2014
Reason: MRS_Layer_Chip_Association__c  After insert trigger
Change History:
Author: 
Modified Date: 
Reason: 
Author: Cognizant Technology Solutions
Modified Date:
��..
��..

Test class is MRSHandlerUtilityTest2
 */
trigger MRS_Layer_Chip_Association_SWIFT_AINS on MRS_Layer_Chip_Association__c (after insert) {
    set<String> setLayerIds = new set<String>();
    
    /* Code added for adding Layer Chip object to Set */
    if(MRSHandlerUtility.numberOfLayerChipRecords!=null){
        MRSHandlerUtility.numberOfLayerChipRecords = MRSHandlerUtility.numberOfLayerChipRecords - trigger.new.size();
        if(MRSHandlerUtility.numberOfLayerChipRecords>=0){
            for(MRS_Layer_Chip_Association__c mrsLayerChipObject : trigger.new){
                setLayerIds.add(mrsLayerChipObject.Layer__c);
            }
        }
    }else{
        for(MRS_Layer_Chip_Association__c mrsLayerChipObject : trigger.new){
            setLayerIds.add(mrsLayerChipObject.Layer__c);           
        }
    }
    
    if(setLayerIds.size()>0){                  
        MRSHandlerUtility.setMRSLayerRecalculatedValuesOnLayerCreation(setLayerIds);
    }

    //SWGP-998
    list<MRS_Layer_Chip_Syncing_Status__c> rList = new list<MRS_Layer_Chip_Syncing_Status__c>();
    for(MRS_Layer_Chip_Association__c m : trigger.new){
        rList.add(new MRS_Layer_Chip_Syncing_Status__c(MRS_Layer_Chip_Association__c = m.id));
    }
    insert rList;
    //SWGP-998-END
}