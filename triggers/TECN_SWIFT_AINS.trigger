/*
Type Name: TECN_SWIFT_AINS
Author: Cognizant 
Created Date: 9-June-2014
Reason: TECN After Insert Trigger to set related Mask Layer status to 'Released' when all associated TECN status is 'Released'
Change History:
Author: 
Modified Date: 
Reason: 
Author: Cognizant Technology Solutions
Modified Date:
……..
……..
*/

trigger TECN_SWIFT_AINS on TECN__c (after insert) {
       
    set<String> setTECNNos = new set<String>();
    
    for(TECN__c tecnObject : trigger.new){
        if(tecnObject.TECN_Status__c == 'Released'){            
            setTECNNos.add(tecnObject.Related_TECN_No__c);
        }
    }
    if(setTECNNos.size() > 0){
        TECNHandlerUtility.releaseMRSLayersForReleasedTECNs(setTECNNos);
    }
}