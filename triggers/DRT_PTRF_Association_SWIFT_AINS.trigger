/*Author: Cognizant Technology SolutionsCompany: 
Description:    Trigger for DRT_PTRF_Association_SWIFT_AINS 
History:    Cognizant   
- Initial Version
*/

trigger DRT_PTRF_Association_SWIFT_AINS on DRT_PTRF_Association__c (After Insert) {
    
    /** Code added for functional development **/   
    set<String> setFrameDRTIds = new set<String>();
    set<String> setPrimeDRTIds = new set<String>();
    set<String> setPTRFIds = new set<String>();
    static string recursivecall = 'YES';
    list<PTRF__c> ptrfInsList = new list<PTRF__c>();
    map<string,string> ptrfDRTFMap = new map<string,string>();
    map<string,string> ptrfDRTPMap = new map<string,string>();
    map<String,String> mapDRTIdsToPTRFIds = new map <String,String>();
    
    for(DRT_PTRF_Association__c obj:trigger.new){
        if(obj.DRT__c!=null && obj.PTRF_Status__c == 'Perform Tapeout Options'){
            
            if(obj.DRT_Type__c=='Prime'){
                setPrimeDRTIds.add(obj.DRT__c); 
            }
            else{
                setFrameDRTIds.add(obj.DRT__c); 
            }
            setPTRFIds.add(obj.PTRF__c);
            mapDRTIdsToPTRFIds.put(obj.DRT__c,obj.PTRF__c);
            if(obj.DRT_Type__c == 'FRAME')
            ptrfDRTFMap.put(obj.PTRFNumber__c,obj.DRT_Name__c); 
            if(obj.DRT_Type__c == 'PRIME')
            ptrfDRTPMap.put(obj.PTRFNumber__c,obj.DRT_Name__c);         
        }
    }
    //MODIFIED FOR TASK 2139
    if(setPTRFIds != null && setPTRFIds.size() > 0 && recursivecall !='' )
    {
         for(PTRF__c ptrfIns : [select id,Prime_DRT__c,Name,Frame_DRT__c from PTRF__c where id IN : setPTRFIds])
         {
          if(ptrfDRTFMap.keyset().contains(ptrfIns.Name))
          ptrfIns.Frame_DRT__c  = ptrfDRTFMap.get(ptrfIns.Name);
          if(ptrfDRTPMap.keyset().contains(ptrfIns.Name))
          ptrfIns.Prime_DRT__c= ptrfDRTPMap.get(ptrfIns.Name);
          ptrfInsList.add(ptrfIns);
         }
         if(ptrfInsList != null && ptrfInsList.size() > 0)
         
         {system.debug('ptrf'+recursivecall+ptrfInsList);
         recursivecall = '';
         update ptrfInsList;
         }
    }
    
    
    if(mapDRTIdsToPTRFIds.size()>0){
        MRSHandlerUtility.addDRTChipsInMRS(setPrimeDRTIds,setFrameDRTIds,mapDRTIdsToPTRFIds,setPTRFIds);    
    }
    /** Code added for functional development **/
    
}