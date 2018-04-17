/*
Type Name: TECN_SWIFT_AUPD
Author: Cognizant 
Created Date: 3-April-2014
Reason: TECN After Trigger to set related Mask Layer status to 'Released' when all associated TECN status is 'Released'
Change History:
Author: 
Modified Date: 
Reason: 
Author: Cognizant Technology Solutions
Modified Date:
��..
��..
*/

trigger TECN_SWIFT_AUPD on TECN__c (After Update) {
       
    set<String> setTECNNos = new set<String>();
    
    for(TECN__c tecnObject : trigger.new){
        if( (tecnObject.TECN_Status__c == 'Released' && Trigger.oldMap.get(tecnObject.Id).TECN_Status__c!='Released') 
        		|| (tecnObject.TECN_Status__c == 'Expired' && Trigger.oldMap.get(tecnObject.Id).TECN_Status__c!='Expired')){            
            setTECNNos.add(tecnObject.Related_TECN_No__c);
        }
    }
    if(setTECNNos.size() > 0){
        TECNHandlerUtility.releaseMRSLayersForReleasedTECNs(setTECNNos);
    }
}