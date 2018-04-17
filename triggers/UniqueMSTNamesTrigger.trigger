/*
    Author: Mallika Seth
    Description: This Trigger runs logic on mask set title name for duplicate check.
    History: 
        Mseth  28082015    - Creation
        Devendra 23/08/2017 fix for prod issue changes in line number 27 added condition for isupdate
		Devendra 30/08/2017 Added code for rom codes check
		Devendra 12/09/2017 Added code for mst duplicate check in rom code
*/
trigger UniqueMSTNamesTrigger on Mask_Set_Title__c (Before Insert,Before Update) {
     if(!IntegrationUserUtil.isSkipTrigger() && !Device_triggerHelper.stopMSTTriggerforFab9_10){
        Map<String, Mask_Set_Title__c> mapMaskSetTitle = new Map<String, Mask_Set_Title__c>();
        List<String>lstMSTIDNew = new List<String>();
        List<Device__c>lstDevice = new List<Device__c>();
			string mstNames='';
         	integer i=0;
         integer recSize=Trigger.new.size();
            for (Mask_Set_Title__c MST : Trigger.new){
               mapMaskSetTitle.put(MST.Name, MST);
               lstMSTIDNew.add(MST.ID);
                if(i==recSize-1){
                    mstNames += ' MaskSetTitle_From_PTRF__c like \'%'+MST.Name+'%\' ';    
                }else{
                    mstNames += ' MaskSetTitle_From_PTRF__c like \'%'+MST.Name+'%\' or ';
                }
                i++;

            }
         	set<string> nameSet=new set<string>();
         	nameSet.addall(mapMaskSetTitle.keyset());
         	string query='SELECT Name,MaskSetTitle_From_PTRF__c FROM Mask_Set_Title__c WHERE (Name IN: nameSet OR '+ mstNames +' ) AND Id NOT IN :lstMSTIDNew';
            Set<String> setExistingMST = new Set<String>();
         	List<Mask_Set_Title__c> masKList=database.query(query);
            for(Mask_Set_Title__c mst: masKList){
                List<string> MSTRoMCodes=new List<string>();
                if(string.isnotblank(mst.MaskSetTitle_From_PTRF__c))MSTRoMCodes=mst.MaskSetTitle_From_PTRF__c.split(';');
                setExistingMST.addAll(MSTRoMCodes);    
                setExistingMST.add(mst.Name);
             }//updated code for rom code check
             system.debug('total soql queries:'+limits.getQueries());
             
             list<Device__c> lstDeviceMST = new list<Device__c>();
         	Map<id,set<string>> techSet=new Map<id,set<string>>();
            if(Trigger.IsUpdate ){                
                for(Device__c dev: [SELECT ID,Reticle_Type__c,Mask_Set_Title_Lookup__c,Geometry_NM__c FROM Device__c WHERE Mask_Set_Title_Lookup__c IN: lstMSTIDNew]){
                    lstDeviceMST.add(dev);
                    if(techSet.containsKey(dev.Mask_Set_Title_Lookup__c))techSet.get(dev.Mask_Set_Title_Lookup__c).add(String.valueof(dev.Geometry_NM__c));
                    else techSet.put(dev.Mask_Set_Title_Lookup__c,new Set<string>{String.valueof(dev.Geometry_NM__c)});
                }
                
            }
             
             system.debug('total soql queries:'+limits.getQueries());
             Map<String,String> mapMSTMPRF = new Map<String,String>();
             for(Pairing_Table__c pairingTable :[SELECT ID,PRF_Number__c,Mask_Set_Title_Text__c 
                                                 from Pairing_Table__c where Mask_Set_Title_Text__c IN: mapMaskSetTitle.keySet()
                                                 ORDER BY PRF_Number__c DESC 
                                                 NULLS LAST LIMIT 1]){ mapMSTMPRF.put(pairingTable.Mask_Set_Title_Text__c ,pairingTable.PRF_Number__c);
                
               }
            for (Mask_Set_Title__c MST : Trigger.new){
              If(setExistingMST != NULL && 
                        setExistingMST.contains(MST.Name)){
             
                MST.name.addError('This Mask set title already exists');
              }
              If(!techSet.isempty() && techSet.get(MST.id)!=NULL && techSet.get(MST.id).SIZE()>0){
                  List<string> tempList=new List<string>();
                  tempList.addall(techSet.get(MST.id));
                    MST.Technology__c = string.join(tempList,' \r\n');                       
              }
              // Update MPRF number on mask set title
              If(mapMSTMPRF!= Null && mapMSTMPRF.containsKey(MST.Name)){ MST.MPRF__c = mapMSTMPRF.get(MST.Name) ;
              }
              if(Trigger.IsUpdate && MST.Reticle_Type__c != Trigger.oldMap.get(MST.Id).Reticle_Type__c){
                         
                  For(Device__c Dev : lstDeviceMST){
                       if(Dev.Mask_Set_Title_Lookup__c == MST.ID){
                           Dev.Reticle_Type__c = MST.Reticle_Type__c; Dev.Manual_Creation__c = True;  lstDevice.add(Dev); 
                       }
                  }
                  
             }  
            }
            
            // Updating Reticle Type on Device.
            if (lstDevice.size() > 0) {  update lstDevice;
                for(Device__c Dev : lstDevice)Dev.Manual_Creation__c = False;
                update lstDevice;
           }
     }

}