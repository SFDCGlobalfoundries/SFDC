/*
Type Name: SubPDKSpecTrigger Trigger
Author: Cognizant 
Created Date: 20-June-2013
Reason: 
Change History:
Author: Cognizant 
Modified Date: 9/1/2014
Reason: Change in the PDK name 
??..
??..
*/

trigger SubPDKSpecTrigger on Sub_PDK_Spec__c (before delete, after insert,after delete) {// modified by cognizant 
  
if(Trigger.isbefore && Trigger.isDelete)
{    
    List<Sub_PDK_Spec__c>  lstSubPDKSpec = new List<Sub_PDK_Spec__c>();
    
    for(Sub_PDK_Spec__c objSPS: trigger.old){
        lstSubPDKSpec.add(objSPS);  
    }
    if(lstSubPDKSpec!=null && lstSubPDKSpec.size()>0){
        //DesignSpecTriggerHandler.deassociateSpecFromSubPDK(lstSubPDKSpec);
        //FV_deassociateSpecFromSubPDK.deassociateSpecFromSubPDK(lstSubPDKSpec);
    }
}   
/*------------------------------added by cognizant for the Case 00002585----------------------------------------------------------------------------*/

else if(Trigger.isafter && Trigger.isDelete)
{
    String str='';
    List<Sub_PDK_Spec__c> lstSubPdkSpec1 = new List<Sub_PDK_Spec__c>() ;
    List<Sub_PDK__c> lstSubPdk1 = new List<Sub_PDK__c>() ;
    Map<ID,Set<ID>> map_pdk_to_specs1 = new Map<ID,Set<ID>>() ; 
    Map<Id, String> mapPDKIdsToPDKNames1 = new Map<Id, String>();// added by cognizant
    
    
    Set<String> setSubPDKIds1 = new Set<String>();//added by cognizant
    Set<String> setDesignSpecId1= new Set<String>();//added by cognizant
    Set<String> SetPatchId1= new Set<String>();//added by cognizant
    
    List<Design_Spec__c> lstDesignSpec1=new List<Design_Spec__c>();//added by cognizant
    Map<String,String> mapPDKIdsToPDKDoctitle1= new Map<String,String>();//added by cognizant
    List<PDK_Patch__c> lstPatch1 =new List<PDK_Patch__c>();//added by cognizant
    String PDKVersion1;//added by cognizant
    List<Sub_PDK__c> listSPDKNamesMod1 = new List<Sub_PDK__c>();
    
    for (Sub_PDK_Spec__c spec1 : Trigger.old)
    {
        if(map_pdk_to_specs1.containsKey(spec1.Sub_PDK__c) ){
         
            Set<ID> tempSetIds1 =  map_pdk_to_specs1.get(spec1.Sub_PDK__c)   ; 
            tempSetIds1.add(spec1.Design_Spec__c) ; 
            map_pdk_to_specs1.put(spec1.Sub_PDK__c,tempSetIds1) ; // preapare map : Key->PDK-id value->setof userids
                      
        }
        else{
            Set<ID> tempSetIds1 = new Set<ID>() ;
            tempSetIds1.add(spec1.Design_Spec__c) ;
            map_pdk_to_specs1.put(spec1.Sub_PDK__c,tempSetIds1) ;
        }
    }

         system.debug('map_pdk_to_specs1@'+map_pdk_to_specs1);
        if(map_pdk_to_specs1!=null && map_pdk_to_specs1.size()>0)
         {       
          
         
         for(Sub_PDK__c objSubPDK:[Select Id, Name, Bundle_Name__c, PDK__c,PDK__r.Name,PDK__r.Master_PDK_Full_Name__c,PDK__r.PDK_DocTitle__c from Sub_PDK__c where Id IN:map_pdk_to_specs1.keySet()])
           
            {
            
            setSubPDKIds1.add(objSubPDK.Id);
            mapPDKIdsToPDKNames1.put(objSubPDK.PDK__c,objSubPDK.PDK__r.Master_PDK_Full_Name__c);
            mapPDKIdsToPDKDoctitle1.put(objSubPDK.PDK__c,objSubPDK.PDK__r.PDK_DocTitle__c);
            }
            
            system.debug('setSubPDKIds1@@@'+setSubPDKIds1);
            if(setSubPDKIds1!=null && setSubPDKIds1.size()>0)
            {
                 for(Sub_PDK_Spec__c objPDKspec:[Select Id,Name,Sub_PDK__c,Design_Spec__c from Sub_PDK_Spec__c where Sub_PDK__c IN:setSubPDKIds1]){
                setDesignSpecId1.add(objPDKspec.Design_Spec__c);
            
                }
            }
            
            system.debug('setDesignSpecId1@@@'+setDesignSpecId1);
            
              if(setDesignSpecId1!=null && setDesignSpecId1.size()>0)
              { 
               lstDesignSpec1 =[select id,name,PDK_Patch__c,PDK__c from Design_Spec__c where Id IN:setDesignSpecId1 and PDK__c =''];
              } 
              
               system.debug('lstDesignSpec1 @@@'+lstDesignSpec1);
           if(lstDesignSpec1 !=null && lstDesignSpec1.size()>0)
          { 
               for(Design_Spec__c objDesignSpec :lstDesignSpec1)
               {
               SetPatchId1.add(objDesignSpec.PDK_Patch__c);
               
               }
           
           }
           
         system.debug('SetPatchId1@@@'+SetPatchId1);  
       if(SetPatchId1 !=null && SetPatchId1.size()>0)
       {    
       lstPatch1 =[select Id,name,PDK_Revision_Release_Date__c,PDK_Version__c from PDK_Patch__c where Id IN:SetPatchId1 order by Master_PDK_Patch_Counter__c desc ];
       
       }
      //  system.debug('lstPatch @@@'+lstPatch);
        
       if(lstPatch1.size()>0)
       {
       PDKVersion1 =lstPatch1[0].PDK_Version__c ;
       }
       system.debug('lstPatch1 @@@'+lstPatch1);
       system.debug('PDKVersion1 @@@'+PDKVersion1 );
       
       for(Sub_PDK__c objSubPDK:[Select Id, Name, Bundle_Name__c, PDK__c from Sub_PDK__c where Id IN:map_pdk_to_specs1.keySet()])
       {
       		if(lstDesignSpec1.size()==0)
            {
            	str= 'PDK ' + mapPDKIdsToPDKNames1.get(objSubPDK.PDK__c) + ' - ' +objSubPDK.Bundle_Name__c;
                /*if(str.length()>255){
					objSubPDK.addError('The PDK Name should not be  greater than 255 length character');
				}*/
                if(str.length()>80)
                {
                	objSubPDK.Name = str.substring(0,80);//Added by kunal
                }
                else
                {
                	objSubPDK.Name = str;
                }
                objSubPDK.Full_PDK_Name__c = str;//Added by kunal      
             }  
           	 else
             {
             	if(mapPDKIdsToPDKDoctitle1.get(objSubPDK.PDK__c)!=null && PDKVersion1 !=null)
                {
                	str='PDK ' + mapPDKIdsToPDKDoctitle1.get(objSubPDK.PDK__c) + ' '+PDKVersion1 +' - ' +objSubPDK.Bundle_Name__c;//modified by cognizant on 5th feb
                    /*if(str.length()>255){
						objSubPDK.addError('The PDK Name should not be  greater than 255 length character');
					}*/
                    if(str.length()>80)
                    {
                    	objSubPDK.Name = str.substring(0,80);//Added by kunal	
                    }
                    else
                    {   
                    	objSubPDK.Name = str;//modified by cognizant on 5th feb
                    }
                    objSubPDK.Full_PDK_Name__c = str;//Added by kunal
                 }
                 else if(mapPDKIdsToPDKDoctitle1.get(objSubPDK.PDK__c)==null && PDKVersion1 !=null)
                 {   
                 	str='PDK ' +''+PDKVersion1 +' - ' +objSubPDK.Bundle_Name__c;
                    /*if(str.length()>255){
						objSubPDK.addError('The PDK Name should not be  greater than 255 length character');
					}*/
                    if(str.length()>80)
                    {
                    	objSubPDK.Name = str.substring(0,80);//Added by kunal
                    }
                    else
                    {
                    	objSubPDK.Name = str;
                    }
                    objSubPDK.Full_PDK_Name__c = str;//Added by kunal       
                 }
                 else if(mapPDKIdsToPDKDoctitle1.get(objSubPDK.PDK__c)!=null && PDKVersion1 ==null)
                 {
                 	str='PDK ' + mapPDKIdsToPDKDoctitle1.get(objSubPDK.PDK__c) +' - ' +objSubPDK.Bundle_Name__c;
                    /*if(str.length()>255){
						objSubPDK.addError('The PDK Name should not be  greater than 255 length character');
					}*/
                    if(str.length()>80)
                    {
                    	objSubPDK.Name = str.substring(0,80);//Added by kunal
                    }
                    else
                    {
                    	objSubPDK.Name = str;
                    }
                    objSubPDK.Full_PDK_Name__c = str;//Added by kunal       
                 }
              	}   
                         
                         
        listSPDKNamesMod1.add(objSubPDK);           
            
       }
       
        if(listSPDKNamesMod1!=null && listSPDKNamesMod1.size()>0){
                try{
                    update listSPDKNamesMod1;
                }
                catch(Exception ex){
                    System.debug(ex);
                }       
            }   
    }     
   }      

 else if(Trigger.isInsert && Trigger.isAfter)
{
/**/
   
    List<Sub_PDK_Spec__c> lstSubPdkSpec = new List<Sub_PDK_Spec__c>() ;
    List<Sub_PDK__c> lstSubPdk = new List<Sub_PDK__c>() ;
    Map<ID,Set<ID>> map_pdk_to_specs = new Map<ID,Set<ID>>() ; 
    Map<Id, String> mapPDKIdsToPDKNames = new Map<Id, String>();// added by cognizant
    
     string str1='';//added by cognizant
    Set<String> setSubPDKIds = new Set<String>();//added by cognizant
    Set<String> setDesignSpecId= new Set<String>();//added by cognizant
    Set<String> SetPatchId= new Set<String>();//added by cognizant
    
    List<Design_Spec__c> lstDesignSpec=new List<Design_Spec__c>();//added by cognizant
    Map<String,String> mapPDKIdsToPDKDoctitle= new Map<String,String>();//added by cognizant
    List<PDK_Patch__c> lstPatch =new List<PDK_Patch__c>();//added by cognizant
    String PDKVersion;//added by cognizant
    List<Sub_PDK__c> listSPDKNamesMod = new List<Sub_PDK__c>();
    
    for (Sub_PDK_Spec__c sps : Trigger.new)
    {
        if(map_pdk_to_specs.containsKey(sps.Sub_PDK__c) ){
         
            Set<ID> tempSetIds =  map_pdk_to_specs.get(sps.Sub_PDK__c)   ; 
            tempSetIds.add(sps.Design_Spec__c) ; 
            map_pdk_to_specs.put(sps.Sub_PDK__c,tempSetIds) ; // preapare map : Key->PDK-id value->setof userids
                      
        }
        else{
            Set<ID> tempSetIds = new Set<ID>() ;
            tempSetIds.add(sps.Design_Spec__c) ;
            map_pdk_to_specs.put(sps.Sub_PDK__c,tempSetIds) ;
        }
    }
    
         system.debug('map_pdk_to_specs@'+map_pdk_to_specs);
        if(map_pdk_to_specs!=null && map_pdk_to_specs.size()>0)
         {       
          
         
         for(Sub_PDK__c objSubPDK:[Select Id, Name, Bundle_Name__c, PDK__c,PDK__r.Name,PDK__r.Master_PDK_Full_Name__c,PDK__r.PDK_DocTitle__c from Sub_PDK__c where Id IN:map_pdk_to_specs.keySet()])
           
            {
            
            setSubPDKIds.add(objSubPDK.Id);
            mapPDKIdsToPDKNames.put(objSubPDK.PDK__c,objSubPDK.PDK__r.Master_PDK_Full_Name__c);
            mapPDKIdsToPDKDoctitle.put(objSubPDK.PDK__c,objSubPDK.PDK__r.PDK_DocTitle__c);
            }
            
            system.debug('setSubPDKIds@@@'+setSubPDKIds);
            if(setSubPDKIds!=null && setSubPDKIds.size()>0)
            {
                 for(Sub_PDK_Spec__c objPDKspec:[Select Id,Name,Sub_PDK__c,Design_Spec__c from Sub_PDK_Spec__c where Sub_PDK__c IN:setSubPDKIds]){
                setDesignSpecId.add(objPDKspec.Design_Spec__c);
            
                }
            }
            
            system.debug('setDesignSpecId@@@'+setDesignSpecId);
            
              if(setDesignSpecId!=null && setDesignSpecId.size()>0)
              { 
               lstDesignSpec =[select id,name,PDK_Patch__c,PDK__c from Design_Spec__c where Id IN:setDesignSpecId and PDK__c =''];
              } 
              
               system.debug('lstDesignSpec @@@'+lstDesignSpec);
           if(lstDesignSpec !=null && lstDesignSpec.size()>0)
          { 
               for(Design_Spec__c objDesignSpec :lstDesignSpec)
               {
               SetPatchId.add(objDesignSpec.PDK_Patch__c);
               
               }
           
           }
           
         system.debug('SetPatchId@@@'+SetPatchId);  
       if(SetPatchId !=null && SetPatchId.size()>0)
       {    
       lstPatch =[select Id,name,PDK_Revision_Release_Date__c,PDK_Version__c from PDK_Patch__c where Id IN:SetPatchId order by Master_PDK_Patch_Counter__c desc ];
       
       }
      //  system.debug('lstPatch @@@'+lstPatch);
        
       if(lstPatch.size()>0)
       {
       PDKVersion =lstPatch[0].PDK_Version__c ;
       }
       system.debug('lstPatch @@@'+lstPatch);
       system.debug('PDKVersion @@@'+PDKVersion );
       
       for(Sub_PDK__c objSubPDK:[Select Id, Name, Bundle_Name__c, PDK__c from Sub_PDK__c where Id IN:map_pdk_to_specs.keySet()])
       	{
        	if(lstDesignSpec.size()==0)
            {
            	str1= 'PDK ' + mapPDKIdsToPDKNames.get(objSubPDK.PDK__c) + ' - ' +objSubPDK.Bundle_Name__c;
           		/*if(str1.length()>255){
					objSubPDK.addError('The PDK Name should not be  greater than 255 length character');
				}*/
				if(str1.length()>80)
                {
                	objSubPDK.Name = str1.substring(0,80);
                }
                else
                {
                	objSubPDK.Name = str1;
                }
             	objSubPDK.Full_PDK_Name__c = str1; 
            }  
            else
            {
            	if(mapPDKIdsToPDKDoctitle.get(objSubPDK.PDK__c)!=null && PDKVersion !=null)
                {
                	str1='PDK ' + mapPDKIdsToPDKDoctitle.get(objSubPDK.PDK__c) + ' '+PDKVersion +' - ' +objSubPDK.Bundle_Name__c;//modified by cognizant on 5th feb
                    /*if(str1.length()>255){
						objSubPDK.addError('The PDK Name should not be  greater than 255 length character');
					}*/
                    if(str1.length()>80)
                    {
                    	objSubPDK.Name = str1.substring(0,80);
                    }
                    else
                    {   
                    	objSubPDK.Name = str1;//modified by cognizant on 5th feb
                    }      
                    objSubPDK.Full_PDK_Name__c = str1;
               	}
                else if(mapPDKIdsToPDKDoctitle.get(objSubPDK.PDK__c)==null && PDKVersion !=null)
                {
                	str1='PDK ' +''+PDKVersion +' - ' +objSubPDK.Bundle_Name__c;
                    /*if(str1.length()>255){
						objSubPDK.addError('The PDK Name should not be  greater than 255 length character');
					}*/
                    if(str1.length()>80)
                    {
                    	objSubPDK.Name = str1.substring(0,80);
                    }
                    else
                    {
                    	objSubPDK.Name = str1;
                    }
     				objSubPDK.Full_PDK_Name__c = str1; 
                 }
                 else if(mapPDKIdsToPDKDoctitle.get(objSubPDK.PDK__c)!=null && PDKVersion ==null)
                 {
                 	str1= 'PDK ' + mapPDKIdsToPDKDoctitle.get(objSubPDK.PDK__c) +' - ' +objSubPDK.Bundle_Name__c; 
                    /*if(str1.length()>255){
						objSubPDK.addError('The PDK Name should not be  greater than 255 length character');
					}*/
                    if(str1.length()>80)
                    {
                    	objSubPDK.Name = str1.substring(0,80);
                    }
                    else
                    {
                    	objSubPDK.Name =  'PDK ' + mapPDKIdsToPDKDoctitle.get(objSubPDK.PDK__c) +' - ' +objSubPDK.Bundle_Name__c;
                    }
                    objSubPDK.Full_PDK_Name__c = str1;
                    }
                 }   
                         
                         
        listSPDKNamesMod.add(objSubPDK);           
            
       }
       
        if(listSPDKNamesMod!=null && listSPDKNamesMod.size()>0){
                try{
                    update listSPDKNamesMod;
                }
                catch(Exception ex){
                    System.debug(ex);
                }       
            }   
    }     
         
/*----------------------------------------------------------------------------------------------------------------*/    
    
   
/**/    
}
        
}