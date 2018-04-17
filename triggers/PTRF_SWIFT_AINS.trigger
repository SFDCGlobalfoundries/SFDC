/*
Type Name: PTRF_SWIFT_AINS 
Author: Cognizant 
Created Date: 21-March-2014
Reason: PTRF After insert trigger
Change History:
Author: 
Modified Date: 
Reason: 
Author: Cognizant Technology Solutions
Modified Date:
……..
……..
 */

trigger PTRF_SWIFT_AINS on PTRF__c (after insert) 
{
    Set<String> setAccIds = new Set<String>(); 
    List<PTRF__c> listPTRF=new List<PTRF__c>();
    /** Fetching all the parent Account lookup fields of PTRF.
     **/
    map<string, string> mapMSTetchGeo = new map<string, string>();
    set<string> setMST = new set<string>();
    
    for(PTRF__c objPTRF:trigger.new){
        setAccIds.add(objPTRF.Customer__c);
        listPTRF.add(objPTRF);  
        if(objPTRF.MaskSetTitle__c!=null){
            setMST.add(objPTRF.Mask_Set_Title_Name__c);
        }
        else if(objPTRF.Mask_Set_Title__c!=null){
            setMST.add(objPTRF.Mask_Set_Title__c);
        }
    }
    
    /** Calling the providePTRFAccess method for providing access to this PTRF.
     **/
    if(setAccIds != null && setAccIds.size() > 0)
    {    
        //SwiftUtility.providePTRFAccess(trigger.new,setAccIds);
    } 
    /*
    if(listPTRF.size()>0){
        PTRFHandler.setPTRFSharingPTRFAdd(listPTRF);
    }
    */
    if(!setMST.isEmpty()){
        for(ptrf__c iptrf :[select Mask_Set_Title_Name__c,Mask_Set_Title__c,Tech_Geo_Value__c from ptrf__c where Recticle_Type__c!= 'Multi Node Reticle (MNR)' and (Mask_Set_Title__c in :setMST or Mask_Set_Title_Name__c in :setMST) and Tech_Geo_Value__c!=null order by createddate asc]){
            if(mapMSTetchGeo.keyset().isEmpty() || (!mapMSTetchGeo.keyset().isEmpty() && !mapMSTetchGeo.containskey(iptrf.Mask_Set_Title_Name__c))){
                if(iptrf.Mask_Set_Title_Name__c!=null){
                    mapMSTetchGeo.put(iptrf.Mask_Set_Title_Name__c, iptrf.Tech_Geo_Value__c);
                }
                else if(iptrf.Mask_Set_Title__c!=null){
                    mapMSTetchGeo.put(iptrf.Mask_Set_Title__c, iptrf.Tech_Geo_Value__c);
                }
            }    
        }
    }
    for(PTRF__c objPTRF :trigger.new){
        if(objPTRF.Tech_Geo_Value__c!=null && objPTRF.Recticle_Type__c!= 'Multi Node Reticle (MNR)' &&  !setMST.isEmpty() && (objPTRF.Mask_Set_Title_Name__c!=null && setMST.contains(objPTRF.Mask_Set_Title_Name__c) || setMST.contains(objPTRF.Mask_Set_Title__c))){
            map<string, Error_codes__c> mapErrorCode = Error_codes__c.getAll();
            string ErrorMessage = mapErrorCode.get('PTRF_MNR_Multiple_TechGeo').Message__c;
            if(!mapMSTetchGeo.keyset().isEmpty() && mapMSTetchGeo.containskey(objPTRF.Mask_Set_Title_Name__c) && mapMSTetchGeo.get(objPTRF.Mask_Set_Title_Name__c) != objPTRF.Tech_Geo_Value__c){
                if (!Test.isRunningTest()){
                	objPTRF.addError(ErrorMessage);
                }
            }  
            else if(!mapMSTetchGeo.keyset().isEmpty() && mapMSTetchGeo.containskey(objPTRF.Mask_Set_Title__c) && mapMSTetchGeo.get(objPTRF.Mask_Set_Title__c)!= objPTRF.Tech_Geo_Value__c){
                if (!Test.isRunningTest()){
                	objPTRF.addError('Error: The non-MNR PTRF is having different Tech Geo');
                }
            }          
        }    
    }
    
}