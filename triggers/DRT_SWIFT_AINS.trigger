trigger DRT_SWIFT_AINS on DRT__c (after insert) {
    if(CheckRecursive.runOnce()) {
        Set<String> setCustomerIds = new Set<String>();
        list<DRT__c> listActivatedDRT = new list<DRT__c>();
        for(DRT__c objDRT:trigger.new){
            if(objDRT.Status__c=='Active'){        
                setCustomerIds.add(objDRT.Customer_Name__c);
                listActivatedDRT.add(objDRT);
            } 
        }        
        if(setCustomerIds!=null && setCustomerIds.size()>0){
            //DRTHandlerUtility.sendMassEmailOnDRTActivation(listActivatedDRT,setCustomerIds);
        }
    }
}