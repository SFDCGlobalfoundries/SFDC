/*
Author: Cognizant Technology Solutions
Company: 
Description:    Trigger for DRT MRS
History:
    Cognizant     18032014     - Initial Version
*/
trigger DRT_PTRF_Association_SWIFT_AUPD  on DRT_PTRF_Association__c (after update){
    
    /** Code added for functional development **/ 
    set<String> setPTRFIds = new set<String>();
    set<String> setPTRF_drtIds = new set<String>();  
    set<String> setFrameDRTIds = new set<String>();
    set<String> setPrimeDRTIds = new set<String>();
    map<string,string> ptrfDRTFMap = new map<string,string>();
    map<string,string> ptrfDRTPMap = new map<string,string>();
    list<PTRF__c> ptrfInsList = new list<PTRF__c>();
    map<String,String> mapOldDRTIdsToNewDRTIds = new map <String,String>();
    
    for(DRT_PTRF_Association__c obj:trigger.new){
    system.debug('DRT PTRF'+obj.DRT__c);
        if(obj.DRT__c!=null && Trigger.oldMap.get(obj.Id).DRT__c!=null && obj.DRT__c!=Trigger.oldMap.get(obj.Id).DRT__c && obj.PTRF_Status__c == 'Perform Tapeout Options' &&
        obj.Last_Sync_Request_Timestamp__c==Trigger.oldMap.get(obj.Id).Last_Sync_Request_Timestamp__c){           
            if(obj.DRT_Type__c=='Prime'){
                setPrimeDRTIds.add(obj.DRT__c); 
            }else{
                setFrameDRTIds.add(obj.DRT__c); 
            }
            mapOldDRTIdsToNewDRTIds.put(Trigger.oldMap.get(obj.Id).DRT__c,obj.DRT__c); 
            setPTRFIds.add(obj.PTRF__c); 
                          
        }
        if(obj.DRT__c!=null && Trigger.oldMap.get(obj.Id).DRT__c!=null && obj.DRT__c!=Trigger.oldMap.get(obj.Id).DRT__c)
        {
           setPTRF_drtIds.add(obj.PTRF__c); 
           if(obj.DRT_Type__c == 'FRAME')
            ptrfDRTFMap.put(obj.PTRFNumber__c,obj.DRT_Name__c); 
            if(obj.DRT_Type__c == 'PRIME')
            ptrfDRTPMap.put(obj.PTRFNumber__c,obj.DRT_Name__c); 
        }
    }
    
    if(mapOldDRTIdsToNewDRTIds.size()>0){
        if (System.isBatch() || System.isFuture()){
            MRSHandlerUtility.uprevDRTChipsInMRS(setPTRFIds,setPrimeDRTIds,setFrameDRTIds,mapOldDRTIdsToNewDRTIds); 
        }else{
            MRSHandlerUtility.uprevDRTChipsInMRSFuture(setPTRFIds,setPrimeDRTIds,setFrameDRTIds,mapOldDRTIdsToNewDRTIds); 
        }
        //MRSHandlerUtility.uprevDRTChipsInMRS(setPTRFIds,setPrimeDRTIds,setFrameDRTIds,mapOldDRTIdsToNewDRTIds);    
    }
    /** Code added for functional development **/
    
    if(!IntegrationUserUtil.isSkipTrigger()){
        Set<String> drtID = new Set<String>();
        for(DRT_PTRF_Association__c pdl : Trigger.new){
            if(Trigger.oldMap.get(pdl.id).Synced_with_Oracle_DB__c==false && pdl.Synced_with_Oracle_DB__c)
                drtID.add(pdl.DRT__c);
            
        }
        
        if(drtID!=null){
            SwiftUtility.checkDRTpackageSync(drtID);
            
        }
     }
     
     if(setPTRF_drtIds!= null && setPTRF_drtIds.size() > 0 )
    {
         for(PTRF__c ptrfIns : [select id,Prime_DRT__c,Name,Frame_DRT__c from PTRF__c where id IN : setPTRF_drtIds])
         {
          if(ptrfDRTFMap.keyset().contains(ptrfIns.Name))
          ptrfIns.Frame_DRT__c  = ptrfDRTFMap.get(ptrfIns.Name);
          if(ptrfDRTPMap.keyset().contains(ptrfIns.Name))
          ptrfIns.Prime_DRT__c= ptrfDRTPMap.get(ptrfIns.Name);
          ptrfInsList.add(ptrfIns);
         }
         if(ptrfInsList != null && ptrfInsList.size() > 0  && PTRF_DotNetService.recursivecall =='YES' )
         
         {system.debug('testing'+PTRF_DotNetService.recursivecall  );
         PTRF_DotNetService.recursivecall ='NO';
         update ptrfInsList;
         }
    }   
}