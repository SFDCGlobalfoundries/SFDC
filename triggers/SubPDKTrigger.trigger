/*
Type Name: SubPDKTrigger Trigger
Author: Cognizant 
Created Date: 20-June-2013
Reason: 
Change History:
Change History:
Author: Cognizant 
Modified Date: 9/1/2014
Reason: Change in the PDK name 
??..
??..
*/

trigger SubPDKTrigger on Sub_PDK__c (before insert,before update) {
    
    
    Set<String> setParentPDKIds = new Set<String>();
    Map<String,Set<String>> mapExistingSubPDKs = new Map<String,Set<String>>();
    Map<String,String> mapPDKIdsToPDKNames = new Map<String,String>();
    
    string str='';//added by cognizant
    Set<String> setPDKIds = new Set<String>();//added by cognizant
    Set<String> setDesignSpecId= new Set<String>();//added by cognizant
    Set<String> SetPatchId= new Set<String>();//added by cognizant
    
    List<Design_Spec__c> lstDesignSpec=new List<Design_Spec__c>();//added by cognizant
    Map<String,String> mapPDKIdsToPDKDoctitle= new Map<String,String>();//added by cognizant
    List<PDK_Patch__c> lstPatch =new List<PDK_Patch__c>();//added by cognizant
    String PDKVersion;//added by cognizant
    
    for(Sub_PDK__c objSubPDK: trigger.new){
        if(trigger.isInsert || (trigger.isUpdate && ((Trigger.oldMap.get(objSubPDK.ID).Bundle_Name__c==null) || 
        (Trigger.oldMap.get(objSubPDK.ID).Bundle_Name__c.toLowerCase()!=objSubPDK.Bundle_Name__c.toLowerCase())))){
           if(objSubPDK.PDK__c!=null){
                setParentPDKIds.add(objSubPDK.PDK__c);
                setPDKIds.add(objSubPDK.Id);//added by cognizant
           }        
        }           
    }

    system.debug('<<<<<<<<<<+setPDKIds::'+setPDKIds);
    if(setParentPDKIds!=null && setParentPDKIds.size()>0){
        for(PDK__c objPDK:[Select Id, Name,Master_PDK_Full_Name__c,PDK_DocTitle__c from PDK__c where Id IN:setParentPDKIds]){//modified by cognizant
            mapPDKIdsToPDKNames.put(objPDK.Id,objPDK.Master_PDK_Full_Name__c); 
            mapPDKIdsToPDKDoctitle.put(objPDK.Id,objPDK.PDK_DocTitle__c); //added by cognizant
        }
        
        
  /*-------------added by cognizant for the Case 00002585--------------------------------------------------------------------*/ 
  if(setPDKIds!=null && setPDKIds.size()>0){     
        for(Sub_PDK_Spec__c objPDKspec:[Select Id,Name,Sub_PDK__c,Design_Spec__c from Sub_PDK_Spec__c where Sub_PDK__c IN:setPDKIds]){
            system.debug('enter setDesignSpecId@@@'+objPDKspec.Design_Spec__c);
            setDesignSpecId.add(objPDKspec.Design_Spec__c);
        }
    }    
        system.debug('setDesignSpecId@@@'+setDesignSpecId);
        
      if(setDesignSpecId!=null && setDesignSpecId.size()>0){   
       lstDesignSpec =[select id,name,PDK_Patch__c,PDK__c from Design_Spec__c where Id IN:setDesignSpecId and PDK__c =null];
       
       }
       
      if(lstDesignSpec!=null && lstDesignSpec.size()>0){ 
       for(Design_Spec__c objDesignSpec :lstDesignSpec)
       {
       SetPatchId.add(objDesignSpec.PDK_Patch__c);
       
       }
       }
       
      if(SetPatchId!=null && SetPatchId.size()>0){  
       lstPatch =[select Id,name,PDK_Revision_Release_Date__c,PDK_Version__c from PDK_Patch__c where Id IN:SetPatchId order by Master_PDK_Patch_Counter__c desc ];
       }
       
       if(lstPatch.size()>0)
       {
       PDKVersion =lstPatch[0].PDK_Version__c ;
       }
       
       system.debug('lstPatch @@@'+lstPatch);
       system.debug('PDKVersion @@@'+PDKVersion );
 /*--------------------------------------------------------------------------------------------------------------------------*/       
        for(Sub_PDK__c objSubPDK:[Select Id, Name, Bundle_Name__c, PDK__c, PDK__r.Name from Sub_PDK__c where PDK__c IN:setParentPDKIds]){
            Set<String> setTempSets = new Set<String>();
        
            if(mapExistingSubPDKs!=null){ 
                if(mapExistingSubPDKs.containsKey(objSubPDK.PDK__c)){
                    setTempSets = mapExistingSubPDKs.get(objSubPDK.PDK__c) ;
                }
                if(objSubPDK.Bundle_Name__c!=null){             
                    setTempSets.add(objSubPDK.Bundle_Name__c.toLowerCase());
                    mapExistingSubPDKs.put(objSubPDK.PDK__c , setTempSets);
                }
            }                           
        }
        
        for(Sub_PDK__c objSubPDK: trigger.new){
        
/*---------------------modified the for loop by cognizant for the Case 00002585-------------------------------------------------------------------------*/       
           if(mapExistingSubPDKs!=null && mapExistingSubPDKs.containsKey(objSubPDK.PDK__c)){
            if(mapExistingSubPDKs.get(objSubPDK.PDK__c).contains(objSubPDK.Bundle_Name__c.toLowerCase())){
                    objSubPDK.addError('This PDK Bundle Name already exists for this Master PDK.Please give a unique PDK Bundle Name.');        
                }
                else
                {
                  system.debug('enter elses@@@');
                         if(lstDesignSpec.size()==0)
                         {
                         	str='PDK ' + mapPDKIdsToPDKNames.get(objSubPDK.PDK__c) + ' - ' +objSubPDK.Bundle_Name__c;
                        	/*if(str.length()>255){
								objSubPDK.addError('The PDK Name should not be  greater than 255 length character');
							}*/
                     		if(str.length()>80)
                         	{
                          		objSubPDK.Name = str.substring(0,80);
                         	}
                        	else
                        	{
                         		system.debug('enter elseif lstDesignSpec1');
                         		objSubPDK.Name = str;
                         		system.debug('objSubPDK.Name@@2'+objSubPDK.Name);
                         	}
                            objSubPDK.Full_PDK_Name__c = str; 
                         }  
                         else
                         {
                         	system.debug('enter elseif lstDesignSpec1');
                         	if(mapPDKIdsToPDKDoctitle.get(objSubPDK.PDK__c)!=null && PDKVersion !=null)
                            {
                            	str='PDK ' + mapPDKIdsToPDKDoctitle.get(objSubPDK.PDK__c) + ' '+PDKVersion +' - ' +objSubPDK.Bundle_Name__c;//modified by cognizant on 5th feb
                             	/*if(str.length()>255){
								 	objSubPDK.addError('The PDK Name should not be  greater than 255 length character');
								}*/
                                if(str.length()>80)
                                {
                                	objSubPDK.Name = str.substring(0,80);
                                }
                                else
                                {
                                	objSubPDK.Name = str;//modified by cognizant on 5th feb
                                }
                                system.debug('<<<<<<str-::'+str+'>>>>>>objSubPDK.Name-::'+objSubPDK.Name);
                                objSubPDK.Full_PDK_Name__c = str;
                             }
                             else if(mapPDKIdsToPDKDoctitle.get(objSubPDK.PDK__c)==null && PDKVersion !=null)
                             {
                             	str= 'PDK ' +''+PDKVersion +' - ' +objSubPDK.Bundle_Name__c;
                             	/*if(str.length()>255){
								 	objSubPDK.addError('The PDK Name should not be  greater than 255 length character');
								}*/
                             	if(str.length()>80)
                                { 
                                	objSubPDK.Name = str.substring(0,80);
                                }
                               	else
                               	{ 
                                	objSubPDK.Name = 'PDK ' +''+PDKVersion +' - ' +objSubPDK.Bundle_Name__c;
                                }
                                objSubPDK.Full_PDK_Name__c = str;
                             }
                             else if(mapPDKIdsToPDKDoctitle.get(objSubPDK.PDK__c)!=null && PDKVersion ==null)
                             {
                             	str='PDK ' + mapPDKIdsToPDKDoctitle.get(objSubPDK.PDK__c) +' - ' +objSubPDK.Bundle_Name__c;
                                /*if(str.length()>255){
								 	objSubPDK.addError('The PDK Name should not be  greater than 255 length character');
								}*/
                                if(str.length()>80)
                                {
                                 objSubPDK.Name = str.substring(0,80);
                                }
                                else
                                {
                                objSubPDK.Name = str;
                                }
                         		objSubPDK.Full_PDK_Name__c = str;	
                             }
                         }   
                   }           
            }
/*-----------------------------------------------------------------------------------------------------------------------*/                          
        }
        

    }
    
}