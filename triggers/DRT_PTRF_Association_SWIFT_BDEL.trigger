/*
Author: Cognizant Technology Solutions
Company: 
Description:    Trigger for DRT MRS
History:
    Cognizant     18032014     - Initial Version
*/
trigger DRT_PTRF_Association_SWIFT_BDEL on DRT_PTRF_Association__c (before delete) {

    set<String> setPTRFIds = new set<String>();
    set<String> setDRTIds = new set<String>();

    for(DRT_PTRF_Association__c drtPTRFAsso: Trigger.Old )
    {
        if(drtPTRFAsso.PTRF_Status__c == 'Perform Tapeout Options'){
            setPTRFIds.add(drtPTRFAsso.PTRF__c);
            setDRTIds.add(drtPTRFAsso.DRT__c); 
        }                   
    }
    if(setPTRFIds!=null && setPTRFIds.size()>0 && setDRTIds!=null && setDRTIds.size()>0)
    {
        MRSHandlerUtility.cancelDRTChipsInMRS(setPTRFIds,setDRTIds); 
    }
    //Code for syncing DRT PTRF deletion with dotNET PTRF system
    list<string> lstdrtPTRF = new list<string>();
    for(DRT_PTRF_Association__c drtPTRFAsso: Trigger.Old ){
        lstdrtPTRF.add(drtPTRFAsso.id+'::'+drtPTRFAsso.DRT_Name__c+'::'+drtPTRFAsso.PTRFNumber__c + '::' +datetime.now().addHours(8));
    }
    if(lstdrtPTRF.size()>0){
        DRTSwiftUtility.syncdrtPTRFdeletion(lstdrtPTRF);
    }  
}