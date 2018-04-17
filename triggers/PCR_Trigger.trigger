/*
    Author: 
    Description: This is the trigger for POR_Change_Review__c object. 
    History:
        Yash kumar        07082014    - Created a new trigger.
*/ 

trigger PCR_Trigger on POR_Change_Review__c (after insert, after update) {
    Map<Id,Date> pcrMap=new Map<Id,Date>();
    List<GMPL_BX009__c> gmplLst=new List<GMPL_BX009__c>();
    for(POR_Change_Review__c pcr: trigger.new){
        if(pcrMap.size()>0 && pcrMap.containsKey(pcr.Program_Affected__c) && pcr.PCR_Status__c=='Open'){
            if(pcr.PC_Review_Date__c> pcrMap.get(pcr.Program_Affected__c)){
                pcrMap.put(pcr.Program_Affected__c,pcr.PC_Review_Date__c);
            }
        
        }else if ( pcr.PCR_Status__c=='Open' && (pcrMap.size()==0 || !pcrMap.containsKey(pcr.Program_Affected__c))){
            pcrMap.put(pcr.Program_Affected__c,pcr.PC_Review_Date__c);
        
        }else if(pcr.PCR_Status__c!='Closed' && (pcrMap.size()==0 || !pcrMap.containsKey(pcr.Program_Affected__c))){
            pcrMap.put(pcr.Program_Affected__c,pcr.PC_Review_Date__c);
        }
        else if(pcr.PCR_Status__c=='Closed' && (pcrMap.size()==0 || !pcrMap.containsKey(pcr.Program_Affected__c))){
            pcrMap.put(pcr.Program_Affected__c,pcr.PC_Review_Date__c);
        }
        }
        
        GMPL_BX009__c[] gmplREecords=[Select Id,PCR_Date__c from GMPL_BX009__c where Id IN:pcrMap.keySet()];
        for(Integer i=0;i<gmplREecords.size();i++){
            if(pcrMap.containsKey(gmplREecords[i].Id) && (gmplREecords[i].PCR_Date__c== null || gmplREecords[i].PCR_Date__c!= null)){//pcrMap.get(gmplREecords[i].Id) > gmplREecords[i].PCR_Date__c)){
            {
                gmplLst.add(new GMPL_BX009__c(Id=gmplREecords[i].Id,PCR_Date__c=pcrMap.get(gmplREecords[i].Id)) );
            }
        }
        
        if(gmplLst!=null && gmplLst.size()>0){
            update gmplLst;
        }
    
    }
    
}