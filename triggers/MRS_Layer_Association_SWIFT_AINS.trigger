/*
test class is: MRS_Layer_Association_SWIFT_AINS_Test
*/
trigger MRS_Layer_Association_SWIFT_AINS on MRS_Layer_Association__c (after insert) {
    
    //swgp-998
    list<MRS_Layer_Syncing_Status__c> rList = new list<MRS_Layer_Syncing_Status__c>();
    
    for(MRS_Layer_Association__c m: Trigger.new) {
        rList.add(new MRS_Layer_Syncing_Status__c(MRS_Layer_Association__c = m.Id));
    }
    
    insert rList;
    //swgp-998-END
}