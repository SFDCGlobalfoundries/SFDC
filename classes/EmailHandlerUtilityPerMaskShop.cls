public class EmailHandlerUtilityPerMaskShop
{
        public static void sendEmailPerMaskshop(EmailTemplate et,List<MRS_Layer_Association__c> mrsList,List<MRS_Layer_Chip_Association__c> lstMRSLChpAsso,String Comments,Map<Id,String> mapLayerAssoToStatus,Boolean statusCheck){
        try{

         map<id,MRS_Layer_Association__c> mapUpdatedLayers = new map<id,MRS_Layer_Association__c>();
             for(MRS_Layer_Association__c m:mrsList){
              if(mapUpdatedLayers==null)
                mapUpdatedLayers = new map<id,MRS_Layer_Association__c>();
              mapUpdatedLayers.put(m.id,m);  
             }

        map<String,list<String>> mapMaskshopToDLs = new map<String,list<String>>();
        map<String,list<String>> mapFabToDLs = new map<String,list<String>>();
        map<String,String> mapNameValuePair = new Map<String,String>();
      
        set<String> setCustomerIds = new set<String>();
        String maskSetTitleName;
        Boolean isCustomer;
        List<String> customerEmailId = new List<String>();
        List<String> proxyEmailId = new List<String>();
        List<Account_Team_Proxy__c> accProxyList = new List<Account_Team_Proxy__c>();
        List<User> customerId = new List<User>();
        Set<Id> contactIdSet = new Set<Id>();
        Set<Id> validContactIdSet = new Set<Id>();
                
        //Variable Declaration - Ends
        List<String> lstTeamRoles = Environment_Variable__c.getInstance('SwiftFETeamRoles').Value__c.split(',');
        if(lstMRSLChpAsso!=null && lstMRSLChpAsso.size()>0){
         accProxyList = [SELECT Account__c,Name,User_Email__c,User__r.IsActive FROM Account_Team_Proxy__c WHERE Account__c =:lstMRSLChpAsso[0].Customer_Name__c AND Team_Role__c IN :lstTeamRoles AND User__r.IsActive=true];
        } 
         for(Account_Team_Proxy__c accProxy:accProxyList){
           proxyEmailId.add(accProxy.User_Email__c);
         }
         
        // User & OrgwideEmailAddress query
        User u = [SELECT Id,Name,AccountId,Portal_Email__c,Username from User WHERE Id =:UserInfo.getuserId()];
         mapNameValuePair.put('USER_NAME',u.name);
         mapNameValuePair.put('USER_ID',u.Username);
         if(Comments!=null) 
          mapNameValuePair.put('REASON',Comments);
         else
          mapNameValuePair.put('REASON',''); 
         if(String.valueOf(u.AccountId) != null && String.valueOf(u.AccountId) != ''){
              isCustomer = true;
          }
          else{
               isCustomer = false;
          }
          
          if(!isCustomer)
           customerEmailId.add(u.Portal_Email__c);
           
             if(lstMRSLChpAsso!=null && lstMRSLChpAsso.size()>0){ 
               customerId = [Select Id,Portal_Email__c,IsActive,ContactId from User WHERE AccountId = :lstMRSLChpAsso[0].Customer_Name__c and IsActive=true];
             }
             
           if(/*Label.MRS_Send_Email_To_Customer.equalsIgnoreCase('yes') &&*/ isCustomer && customerId.size()>0){ 
            for(user custId :customerId){
                
               if(custId.ContactId!=null){
               
                contactIdSet.add(custId.ContactId);  
              }                       
            }
           }
          // RMG 
          Boolean flagForRMG=false;
          List<GroupMember> groupMemberlst = new List<GroupMember>();
            Group groupObj = [SELECT Name,Id FROM Group WHERE Name='Swift RMG'];
            
           if(groupObj!=null)
            groupMemberlst = [SELECT GroupId,UserOrGroupId FROM GroupMember WHERE GroupId=:groupObj.id];
            
           if(groupMemberlst!=null && groupMemberlst.size()>0){
            for(GroupMember grpMem : groupMemberlst){
              if(grpMem.UserOrGroupId == u.Id){
                flagForRMG = true;
               }
            }
           } 
          // Portal Tab Access
         List<Portal_Tab_Access__c> portalTabAccessList = new List<Portal_Tab_Access__c>();  
         if(contactIdSet.size()>0)  
          portalTabAccessList = [SELECT Contact__c,My_Devices__c,PTRF__c FROM Portal_Tab_Access__c WHERE Contact__c IN :contactIdSet];  
        
         if(portalTabAccessList!=null && portalTabAccessList.size()>0){  
            for(Portal_Tab_Access__c pTAObj : portalTabAccessList){
                if(pTAObj.My_Devices__c && pTAObj.PTRF__c){
                   validContactIdSet.add(pTAObj.Contact__c);
                }
             }
          }  
          
         if(validContactIdSet.size()>0){
           for(user custId :customerId){
            if(validContactIdSet.contains(custId.ContactId)){
             
             customerEmailId.add(custId.Portal_Email__c);
             }
           }
         } 
         
         OrgWideEmailAddress Orgid=[Select id, DisplayName From OrgWideEmailAddress where DisplayName=:'GLOBALFOUNDRIES' LIMIT 1];
        
        //Retrieving Maskshop Email Distribution List and Populating Map of Maskshops to Maskshop Email Distribution List
      
            for(Released_Mask_Write_Distribution_List__c obj:[Select Distribution_List__c,Maskshop__r.Name from Released_Mask_Write_Distribution_List__c
                                                              ]){
                list<String> listDLs = new list<String>();
                if(mapMaskshopToDLs.containsKey(obj.Maskshop__r.Name.toUppercase())){
                    listDLs.addAll(mapMaskshopToDLs.get(obj.Maskshop__r.Name.toUppercase()));     
                }
                if(obj.Distribution_List__c.contains(';')){                 
                    listDLs.addAll(obj.Distribution_List__c.split(';'));                      
                }else{
                    listDLs.add(obj.Distribution_List__c); 
                }
                mapMaskshopToDLs.put(obj.Maskshop__r.Name.toUppercase(), listDLs);   
            }   
      
        
                //Retrieving Fab Email Distribution List and Populating Map of Fabs to Fab Email Distribution List
        
            for(Fab_Distribution_Table__c obj:[Select Fab_No__c,Distribution_List__c from Fab_Distribution_Table__c]){
                list<String> listFDTs = new list<String>();
                if(mapFabToDLs.containsKey(obj.Fab_No__c)){
                    listFDTs.addAll(mapFabToDLs.get(obj.Fab_No__c));        
                }
                if(obj.Distribution_List__c.contains(';')){
                    listFDTs.addAll(obj.Distribution_List__c.split(';'));   
                }else{
                    listFDTs.add(obj.Distribution_List__c); 
                }
                mapFabToDLs.put(obj.Fab_No__c, listFDTs);   
                                 
            }
            
       List<Email_Config_Settings__c> lstecs = new List<Email_Config_Settings__c>();
      
       lstecs =[SELECT Email_Template_Name__c,BCC__c,CC__c,Id,
                                                 Customer_Jobviewer_Type__c,
                                                 Foundry_Jobviewer_Type__c,Name,
                                                 MPW_PTRF__c,
                                                 
                                                 Send_Mail_To_Customer_AS_Submitter__c,
                                                 Tech_Geo_Value__c,TO__c,Send_Mail_To_Customer__c FROM Email_Config_Settings__c 
                                                 where Email_Template_Name__c=:et.DeveloperName and recordType.Name='Maskshop' and Available_For_Use__c=true];   

      
      // Email Configuration Manipulation AND Email formation Starts   
      
      List<Messaging.SingleEmailMessage> massEmail = new List<Messaging.SingleEmailMessage>();
                                             
     Integer counter = 0;  
     
     Map<String,Set<String>> mapConfigMasktoTo = new Map<String,Set<String>>();
     Map<String,Set<String>> mapConfigMasktoCc = new Map<String,Set<String>>();
     Map<String,Set<String>> mapConfigMasktoBcc = new Map<String,Set<String>>();
     Map<String,String> mapConfigMasktoSubject = new Map<String,String>();
     Map<String,String> mapConfigMasktoBody = new Map<String,String>();
     Map<String,List<MRS_Layer_Chip_Association__c>> mapConfigMasktoLayerChips = new Map<String,List<MRS_Layer_Chip_Association__c>>();
     Map<String,String> mapKeytoTo = new Map<String,String>();
     Map<String,String> mapKeytoCc = new Map<String,String>();
     Map<String,String> mapKeytoBcc = new Map<String,String>();
     Map<String,Set<String>> mapETToMasks = new Map<String,Set<String>>();      
     Set<Id> setNoMShopLayers = new Set<Id>();

      for(Email_Config_Settings__c ecs:lstecs){
        
        map<String,String> mapMaskshopToLayerIds = new map<String,String>();
        map<String,List<MRS_Layer_Chip_Association__c>> mapMaskshopToLayerChip = new map<String,List<MRS_Layer_Chip_Association__c>>();
        Map<String,String> mapMaskshopToFabs = new map<String,String>();
        map<String,String> mapMaskshopToTechGeos = new map<String,String>();
        map<String,List<String>> mapMasktoDL = new map<String,List<String>>();
        map<String,Set<String>> mapMasktoFabDL = new map<String,Set<String>>();
        Map<String,Set<String>> mapEmailConfigtoMaskshops = new Map<String,Set<String>>();
        Boolean mstNameStartswithMPW = ecs.MPW_PTRF__c; 

        List<String> lstTekGeo = new List<String>();
        Set<String> setConfigToMaskshops = new Set<String>();
        Boolean toProxy = false;
        Boolean ccProxy = false;
        Boolean bccProxy = false;
        Boolean toFab = false;
        Boolean ccFab = false;
        Boolean bccFab = false;
        Boolean toCustomer = false;
        Boolean ccCustomer = false;
        Boolean bccCustomer = false;
        List<String> lstTo = new List<String>();
        List<String> lstCc = new List<String>();
        List<String> lstBcc = new List<String>();
        Boolean toDiscardFirst = true;
        Boolean ccDiscardFirst = true;
        Boolean bccDiscardFirst = true;
            
            if(ecs.TO__c!=null && ecs.TO__c!='' && ecs.TO__c.contains('#')){
              lstTo=ecs.TO__c.split('#');   
            }
            
            if(ecs.CC__c!=null && ecs.CC__c!='' && ecs.CC__c.contains('#')){
              lstCc=ecs.CC__c.split('#');
            }
            
            if(ecs.BCC__c!=null && ecs.BCC__c!='' && ecs.BCC__c.contains('#')){
              lstBcc=ecs.BCC__c.split('#');
            } 

            if(lstTo!=null && lstTo.size()>0){
              for(String str:lstTo){
                if(toDiscardFirst){
                 toDiscardFirst=false;
                 continue;
                }
                if(str.trim().equalsIgnoreCase('ATP')){
                  toProxy = true; 
                }
                if(str.trim().equalsIgnoreCase('Fab')){
                  toFab = true;
                }
                if(str.trim().equalsIgnoreCase('Customer')){
                  toCustomer = true;
                }  
              }
            }
            
            if(lstCc!=null && lstCc.size()>0){
              for(String str:lstCc){
                if(ccDiscardFirst){
                 ccDiscardFirst=false;
                 continue;
                }
                if(str.trim().equalsIgnoreCase('ATP')){
                  ccProxy = true; 
                }
                if(str.trim().equalsIgnoreCase('Fab')){
                  ccFab = true;
                }
                if(str.trim().equalsIgnoreCase('Customer')){
                  ccCustomer = true;
                }  
              }
            }
            
            if(lstBcc!=null && lstBcc.size()>0){
              for(String str:lstBcc){
                if(bccDiscardFirst){
                 bccDiscardFirst=false;
                 continue;
                }
                if(str.trim().equalsIgnoreCase('ATP')){
                  bccProxy = true; 
                }
                if(str.trim().equalsIgnoreCase('Fab')){
                  bccFab = true;
                }
                if(str.trim().equalsIgnoreCase('Customer')){
                  bccCustomer = true;
                }  
              }
            }

          if(ecs.Tech_Geo_Value__c!=null && ecs.Tech_Geo_Value__c!=''){
           if(ecs.Tech_Geo_Value__c.contains(';')) 
             lstTekGeo = ecs.Tech_Geo_Value__c.split(';');
           else 
             lstTekGeo.add(ecs.Tech_Geo_Value__c); 
          }  
           
             Set<String> setTekGeo = new Set<String>();
           if(lstTekGeo!=null && lstTekGeo.size()>0){
             for(String str:lstTekGeo){
              if(setTekGeo.contains('NM'))
               setTekGeo.add(str.subStringBefore('NM').trim());
              else
               setTekGeo.add(str);  
              }
            }
            
            //SWGP-1168: stop release email for fab 9,10
            
             for(MRS_Layer_Chip_Association__c obj:lstMRSLChpAsso){
               if(obj.PTRF__r.Maskshop__c!=null && obj.PTRF__r.Maskshop__c!=''){ 
                Set<String> lstFabrec = new Set<String>();
                String maskshopName = obj.PTRF__r.Maskshop__c;
                
                setCustomerIds.add(obj.Customer_Name__c);
                maskSetTitleName = obj.PTRF__r.MaskSetTitle__r.Name;
                
                  Boolean mstnameMPW;
                  if(obj.Layer__r.Mask_Set_Title_Name__c.startsWith('MPW'))
                    mstnameMPW = true;
                  else
                    mstnameMPW = false;
                  String techGeo;   
                  if(obj.Layer__r.Tech_Geo__c != null){
                    techGeo = obj.Layer__r.Tech_Geo__c.toUpperCase().substringBefore('UM').trim();
                  }
                  
                  
                  
                  if (!statusCheck || (statusCheck && ((mapUpdatedLayers.get(obj.Layer__c).Layer_Status__c=='Hold' && mapLayerAssoToStatus.get(obj.Layer__c)=='Released') || (mapUpdatedLayers.get(obj.Layer__c).Layer_Status__c=='Released' && mapLayerAssoToStatus.get(obj.Layer__c)=='Hold')))){
                      
                      Double tech_geo_config = Double.valueOf(Environment_Variable__c.getInstance('SWIFT_MDP_EMAIL_TECH_GEO_CUT_OFF').Value__c);
                      if(setTekGeo!=null && setTekGeo.size()>0){
                        
                        if(setTekGeo.contains(string.valueOf(techGeo)) && (mstnameMPW==mstNameStartswithMPW)){

                             if(!setConfigToMaskshops.contains(obj.PTRF__r.Maskshop__c.toUppercase())){
                              setConfigToMaskshops.add(obj.PTRF__r.Maskshop__c.toUppercase());
                              mapETToMasks.put(ecs.Email_Template_Name__c+string.valueOf(counter),setConfigToMaskshops);
                             if(mapMaskshopToDLs!=null && mapMaskshopToDLs.size()>0 && mapMaskshopToDLs.get(obj.PTRF__r.Maskshop__c.toUppercase())!=null && mapMaskshopToDLs.get(obj.PTRF__r.Maskshop__c.toUppercase()).size()>0 && mapMasktoDL!=null && !mapMasktoDL.containsKey(obj.PTRF__r.Maskshop__c.toUppercase())) 
                               
                               //SWGP-601===================================                               
                               //if(! (Double.valueOf(techGeo) <= tech_geo_config) ) mapMasktoDL=createMaskDl(obj.PTRF__r.Maskshop__c.toUppercase(),mapMasktoDL,mapMaskshopToDLs);
                               if(Double.valueOf(techGeo) > tech_geo_config
                                    || 
                                  //SWGP-1176: re-enable hold/resume email for <= 22nm devices
                                  (Double.valueOf(techGeo) <= tech_geo_config && !'SWIFT_Layer_is_Released_To_Maskshop;SWIFT_Layer_is_Released_For_Mask_Write'.containsIgnoreCase(et.DeveloperName))  
                               ) {
                                    mapMasktoDL=createMaskDl(obj.PTRF__r.Maskshop__c.toUppercase(),mapMasktoDL,mapMaskshopToDLs);
                               }
                               //SWGP-601===================================
                             } 
                            // Creating FAB Map
                             if(obj.PTRF__r.Fab__c!=null && obj.PTRF__r.Fab__c!=''){
        
                                  mapMaskshopToFabs=createMApMaskFab(obj.PTRF__r.Fab__c,mapMaskshopToFabs,maskshopName.toUppercase());
                                   
                              if(mapFabToDLs!=null && mapFabToDLs.size()>0 && mapFabToDLs.get(obj.PTRF__r.Fab__c)!=null && mapFabToDLs.get(obj.PTRF__r.Fab__c).size()>0){    
                               if((toFab || ccFab || bccFab)){ 
                                  mapMasktoFabDL=createFabDL(obj.PTRF__r.Maskshop__c.toUppercase(),obj.PTRF__r.Fab__c,mapMasktoFabDL,mapFabToDLs);
                                }
                               }    
                             }
                             // Creating Tech GEO Map
                             if(obj.Layer__r.Tech_Geo__c!=null && obj.Layer__r.Tech_Geo__c!=''){
        
                              mapMaskshopToTechGeos=createMApMaskTech(obj.Layer__r.Tech_Geo__c,mapMaskshopToTechGeos,maskshopName.toUppercase());
        
                             }
                             // Creating Layer Map
        
                               String layerName=createLayerName(obj);
                               mapMaskshopToLayerIds=createMApMaskLayers(layerName,mapMaskshopToLayerIds,maskshopname.toUppercase());

                                if(mapMaskshopToLayerChip.get(maskshopname.toUppercase())!=null && mapMaskshopToLayerChip.get(maskshopname.toUppercase()).size()>0){
                                   mapMaskshopToLayerChip.get(maskshopname.toUppercase()).add(obj);                    
                                }  
                                else{ 
                                 List<MRS_Layer_Chip_Association__c> lstChips = new List<MRS_Layer_Chip_Association__c>(); 
                                 lstChips.add(obj); 
                                 mapMaskshopToLayerChip.put(maskshopname.toUppercase(),lstChips);
                               }  
                         }
                      }
                      else{
                        if(mstnameMPW==mstNameStartswithMPW){
                            if(!setConfigToMaskshops.contains(obj.PTRF__r.Maskshop__c.toUppercase())){
                              setConfigToMaskshops.add(obj.PTRF__r.Maskshop__c.toUppercase());
                              mapETToMasks.put(ecs.Email_Template_Name__c+string.valueOf(counter),setConfigToMaskshops);
                             if(mapMaskshopToDLs!=null && mapMaskshopToDLs.size()>0 && mapMaskshopToDLs.get(obj.PTRF__r.Maskshop__c.toUppercase())!=null && mapMaskshopToDLs.get(obj.PTRF__r.Maskshop__c.toUppercase()).size()>0 && mapMasktoDL!=null && !mapMasktoDL.containsKey(obj.PTRF__r.Maskshop__c.toUppercase())) 
                               
                               //SWGP-601===================================
                               if(! (Double.valueOf(techGeo) <= tech_geo_config) ) mapMasktoDL=createMaskDl(obj.PTRF__r.Maskshop__c.toUppercase(),mapMasktoDL,mapMaskshopToDLs);
                                //SWGP-601===================================
                             } 
                            // Creating FAB Map
                             if(obj.PTRF__r.Fab__c!=null && obj.PTRF__r.Fab__c!=''){
        
                                  mapMaskshopToFabs=createMApMaskFab(obj.PTRF__r.Fab__c,mapMaskshopToFabs,maskshopName.toUppercase());
                                   
                              if(mapFabToDLs!=null && mapFabToDLs.size()>0 && mapFabToDLs.get(obj.PTRF__r.Fab__c)!=null && mapFabToDLs.get(obj.PTRF__r.Fab__c).size()>0){    
                               if((toFab || ccFab || bccFab)){ 
                                  mapMasktoFabDL=createFabDL(obj.PTRF__r.Maskshop__c.toUppercase(),obj.PTRF__r.Fab__c,mapMasktoFabDL,mapFabToDLs);
                                }
                               }    
                             }
                             // Creating Tech GEO Map
                             if(obj.Layer__r.Tech_Geo__c!=null && obj.Layer__r.Tech_Geo__c!=''){
        
                              mapMaskshopToTechGeos=createMApMaskTech(obj.Layer__r.Tech_Geo__c,mapMaskshopToTechGeos,maskshopName.toUppercase());
                                   
                             }
                             // Creating Layer Map
        
                               String layerName=createLayerName(obj);
                               mapMaskshopToLayerIds=createMApMaskLayers(layerName,mapMaskshopToLayerIds,maskshopname.toUppercase());

                                if(mapMaskshopToLayerChip.get(maskshopname.toUppercase())!=null && mapMaskshopToLayerChip.get(maskshopname.toUppercase()).size()>0){
                                   mapMaskshopToLayerChip.get(maskshopname.toUppercase()).add(obj);                    
                                }  
                                else{ 
                                 List<MRS_Layer_Chip_Association__c> lstChips = new List<MRS_Layer_Chip_Association__c>(); 
                                 lstChips.add(obj); 
                                 mapMaskshopToLayerChip.put(maskshopname.toUppercase(),lstChips);
                               }
                         }
                      }
                   }
                   else{
                     setNoMShopLayers.add(obj.Layer__c);
                   }
                }    
                else{
                  setNoMShopLayers.add(obj.Layer__c);
                }
              }

              for(String str:setConfigToMaskshops){
                   String subject = et.subject;
                   String plainBody = et.Body;
                   String techGeoSeries = '';
                   String fabSeries = '';
                   String layerName = '';
                   Set<String> setCc = new Set<String>();
                   Set<String> setBcc = new Set<String>();
                   Set<String> setTo = new Set<String>();
                   
                  if(mapMasktoDL!=null && mapMasktoDL.size()>0 && mapMasktoDL.get(str)!=null && mapMasktoDL.get(str).size()>0) 
                   setTo.addAll(mapMasktoDL.get(str));
           
                   if(toProxy || ccProxy || bccProxy){
                     if(toProxy){
                      if(proxyEmailId!=null && proxyEmailId.size()>0)
                       setTo.addAll(proxyEmailId);
                      } 
                     if(ccProxy){
                      if(proxyEmailId!=null && proxyEmailId.size()>0)
                       setCc.addAll(proxyEmailId);
                      } 
                     if(bccProxy){
                      if(proxyEmailId!=null && proxyEmailId.size()>0)
                       setBcc.addAll(proxyEmailId);
                      } 
                   }
                   
                   if(toFab || ccFab || bccFab){
                     if(toFab){
                      if(mapMasktoFabDL.get(str)!=null && mapMasktoFabDL.get(str).size()>0)
                       setTo.addAll(mapMasktoFabDL.get(str));
                       }
                     if(ccFab){
                      if(mapMasktoFabDL.get(str)!=null && mapMasktoFabDL.get(str).size()>0)
                       setCc.addAll(mapMasktoFabDL.get(str));
                     }  
                     if(bccFab){
                      if(mapMasktoFabDL.get(str)!=null && mapMasktoFabDL.get(str).size()>0)
                       setBcc.addAll(mapMasktoFabDL.get(str));
                       }
                   }
                   
                   if((toCustomer || ccCustomer || bccCustomer) && ecs.Send_Mail_To_Customer__c==true){

                     if(toCustomer){
                      if(customerEmailId!=null && customerEmailId.size()>0)
                       setTo.addAll(customerEmailId);
                      } 
                     if(ccCustomer){
                      if(customerEmailId!=null && customerEmailId.size()>0)
                       setCc.addAll(customerEmailId);
                      } 
                     if(bccCustomer){
                      if(customerEmailId!=null && customerEmailId.size()>0) 
                       setBcc.addAll(customerEmailId);
                      } 
                   }
                   
                   
                   if(et.DeveloperName=='Swift_Hold_Mask_Write_for_Layer' || et.DeveloperName=='Swift_Resume_Mask_Write_for_Layer'){
                    setCc.add(u.Portal_Email__c);
                      
                     if(flagForRMG){
                       if(Environment_Variable__c.getInstance('SWIFT_RMG_EMAIL')!=null){
                           if(Environment_Variable__c.getInstance('SWIFT_RMG_EMAIL').Value__c.contains(';')){
                              setCc.addAll(Environment_Variable__c.getInstance('SWIFT_RMG_EMAIL').Value__c.split(';')); 
                           } 
                           else {
                              setCc.add(Environment_Variable__c.getInstance('SWIFT_RMG_EMAIL').Value__c); 
                            }
                          }
                        }
                     }
                   
                    if(mapMaskshopToLayerIds!=null && mapMaskshopToLayerIds.get(str)!=null && mapMaskshopToLayerIds.get(str)!='')
                      layerName=mapMaskshopToLayerIds.get(str);

                    if(mapMaskshopToLayerChip!=null && mapMaskshopToLayerChip.get(str)!=null && mapMaskshopToLayerChip.get(str).size()>0){
                      mapConfigMasktoLayerChips.put(ecs.Email_Template_Name__c+'::'+string.valueof(counter)+'::'+str,mapMaskshopToLayerChip.get(str));
                    }
                    if(mapMaskshopToFabs!=null && mapMaskshopToFabs.get(str)!=null && mapMaskshopToFabs.get(str)!='')
                      fabSeries=mapMaskshopToFabs.get(str);
                   
                    if(mapMaskshopToTechGeos!=null && mapMaskshopToTechGeos.get(str)!=null && mapMaskshopToTechGeos.get(str)!='')
                      techGeoSeries=mapMaskshopToTechGeos.get(str);

                        if(setTo!=null && setTo.size()>0)
                         mapConfigMasktoTo.put(ecs.Email_Template_Name__c+string.valueof(counter)+str,setTo);
                        if(setCc!=null && setCc.size()>0)
                         mapConfigMasktoCc.put(ecs.Email_Template_Name__c+string.valueof(counter)+str,setCc);
                        if(setBcc!=null && setBcc.size()>0) 
                         mapConfigMasktoBcc.put(ecs.Email_Template_Name__c+string.valueof(counter)+str,setBcc);
                         
                        if(subject!=null && subject!=''){
                         mapConfigMasktoSubject.put(ecs.Email_Template_Name__c+string.valueof(counter)+str,subject);
                        } 
                        if(plainBody!=null && plainBody!=''){
                         mapConfigMaskToBody.put(ecs.Email_Template_Name__c+string.valueof(counter)+str,plainBody);
                        } 
                        mapKeytoTo.put(ecs.Email_Template_Name__c+string.valueof(counter)+str,ecs.TO__c);
                        mapKeytoCc.put(ecs.Email_Template_Name__c+string.valueof(counter)+str,ecs.CC__c);
                        mapKeytoBcc.put(ecs.Email_Template_Name__c+string.valueof(counter)+str,ecs.Bcc__c); 
                              
              }
              counter++;
            } 

            Map<String,List<String>> MapKeyToRecvdTo = new Map<String,List<String>>();
            Map<String,List<String>> MapKeyToRecvdCc = new Map<String,List<String>>();
            Map<String,List<String>> MapKeyToRecvdBcc = new Map<String,List<String>>(); 
            Map<String,List<String>> mapKeytoRecvdSubjectBody = new Map<String,List<String>>();

            MapKeyToRecvdTo=EmailHandlerUtility.buildRecipientList(mapKeytoTo,null,null,false,null);
            MapKeyToRecvdCc=EmailHandlerUtility.buildRecipientList(mapKeytoCc,null,null,false,null);
            MapKeyToRecvdBcc=EmailHandlerUtility.buildRecipientList(mapKeytoBcc,null,null,false,null);
            
            mapKeytoRecvdSubjectBody=EmailSubjectBodyPerMaskshop.generateSubBodyPerMaskshop(mapConfigMasktoLayerChips,mapNameValuePair);
            
           Integer counter2=0;
           for(Email_Config_Settings__c ecs:lstecs){

            if(mapETToMasks!=null && mapETToMasks.size()>0 && mapETToMasks.get(ecs.Email_Template_Name__c+string.valueof(counter2))!=null && mapETToMasks.get(ecs.Email_Template_Name__c+string.valueof(counter2)).size()>0){
             for(String str:mapETToMasks.get(ecs.Email_Template_Name__c+string.valueof(counter2))){
              List<String> toAddress = new List<String>();
              List<String> ccAddress = new List<String>();
              List<String> bccAddress = new List<String>();
              List<String> lstSubBod = new List<String>();
               String subject = '';
               String plainBody = '';
             if(mapKeytoRecvdSubjectBody.get(ecs.Email_Template_Name__c+'::'+string.valueof(counter2)+'::'+str)!=null && mapKeytoRecvdSubjectBody.get(ecs.Email_Template_Name__c+'::'+string.valueof(counter2)+'::'+str).size()>0){
              lstSubBod = mapKeytoRecvdSubjectBody.get(ecs.Email_Template_Name__c+'::'+string.valueof(counter2)+'::'+str);
              subject = lstSubBod[0];
              plainBody = lstSubBod[1];
              plainBody = plainBody.replace('#ECS','ECS : '+ecs.Name);
             } 

             if(mapConfigMasktoTo.get(ecs.Email_Template_Name__c+string.valueof(counter2)+str)!=null && mapConfigMasktoTo.get(ecs.Email_Template_Name__c+string.valueof(counter2)+str).size()>0) 
              toAddress.addAll(mapConfigMasktoTo.get(ecs.Email_Template_Name__c+string.valueof(counter2)+str));
             if(mapConfigMasktoCc.get(ecs.Email_Template_Name__c+string.valueof(counter2)+str)!=null && mapConfigMasktoCc.get(ecs.Email_Template_Name__c+string.valueof(counter2)+str).size()>0) 
              ccAddress.addAll(mapConfigMasktoCc.get(ecs.Email_Template_Name__c+string.valueof(counter2)+str));
             if(mapConfigMasktoBcc.get(ecs.Email_Template_Name__c+string.valueof(counter2)+str)!=null && mapConfigMasktoBcc.get(ecs.Email_Template_Name__c+string.valueof(counter2)+str).size()>0) 
              bccAddress.addAll(mapConfigMasktoBcc.get(ecs.Email_Template_Name__c+string.valueof(counter2)+str));
             if(MapKeyToRecvdTo.get(ecs.Email_Template_Name__c+string.valueof(counter2)+str)!=null && MapKeyToRecvdTo.get(ecs.Email_Template_Name__c+string.valueof(counter2)+str).size()>0) 
              toAddress.addAll(MapKeyToRecvdTo.get(ecs.Email_Template_Name__c+string.valueof(counter2)+str));
             if(MapKeyToRecvdCc.get(ecs.Email_Template_Name__c+string.valueof(counter2)+str)!=null && MapKeyToRecvdCc.get(ecs.Email_Template_Name__c+string.valueof(counter2)+str).size()>0) 
              ccAddress.addAll(MapKeyToRecvdCc.get(ecs.Email_Template_Name__c+string.valueof(counter2)+str));
             if(MapKeyToRecvdBcc.get(ecs.Email_Template_Name__c+string.valueof(counter2)+str)!=null && MapKeyToRecvdBcc.get(ecs.Email_Template_Name__c+string.valueof(counter2)+str).size()>0)
              bccAddress.addAll(MapKeyToRecvdBcc.get(ecs.Email_Template_Name__c+string.valueof(counter2)+str));

            if((toAddress!=null && toAddress.size()>0) && (subject!=null && subject!='') && (plainBody!=null && plainBody!='')) 
              massEmail.addAll(MRSHandlerUtility.partingToCCBccAddress(toAddress,ccAddress,bccAddress,Orgid,true,subject,plainBody));
            }
           } 
            counter2++;
           }
                
              Messaging.sendEmail(massEmail); 

          // Call Per MST Method for Layers related to PTRFs witgh no Maskshop
          List<MRS_Layer_Association__c> lstMRSLayersForMST = new List<MRS_Layer_Association__c>();
          if(setNoMShopLayers!=null && setNoMShopLayers.size()>0){
           for(Id i:setNoMShopLayers){
             if(mapUpdatedLayers.get(i)!=null)
              lstMRSLayersForMST.add(mapUpdatedLayers.get(i)); 
           }
          }
          
         if(lstMRSLayersForMST!=null && lstMRSLayersForMST.size()>0)
          EmailHandlerUtilityPerMST.sendEmailPerMST(et.DeveloperName,lstMRSLayersForMST,null,comments);
           }
         catch(Exception e)
          {
            EmailHandlerUtility.saveEmailExceptionErrorLog(e, '','' ,'EmailHandlerUtilityPerMaskShop','sendEmailPerMaskshop');
                  
          }
      }
    
    public static void sendChipEmailPerMaskshop(EmailTemplate et,List<MRS_Layer_Chip_Association__c> lstMRSLChpAsso,String comments){
    try{
 
        map<String,list<String>> mapMaskshopToDLs = new map<String,list<String>>();
        map<String,list<String>> mapFabToDLs = new map<String,list<String>>();
        

        set<String> setCustomerIds = new set<String>();

        Boolean isCustomer;
        List<String> customerEmailId = new List<String>();
        List<String> proxyEmailId = new List<String>();
        List<Account_Team_Proxy__c> accProxyList = new List<Account_Team_Proxy__c>();
        List<User> customerId = new List<User>();
        Set<Id> contactIdSet = new Set<Id>();
        Set<Id> validContactIdSet = new Set<Id>();
        map<String,String> mapNameValuePair = new Map<String,String>();
        //Variable Declaration - Ends
        List<String> lstTeamRoles = Environment_Variable__c.getInstance('SwiftFETeamRoles').Value__c.split(',');
        if(lstMRSLChpAsso!=null && lstMRSLChpAsso.size()>0){
         accProxyList = [SELECT Account__c,Name,User_Email__c,User__r.IsActive FROM Account_Team_Proxy__c WHERE Account__c =:lstMRSLChpAsso[0].Customer_Name__c AND Team_Role__c IN :lstTeamRoles AND User__r.IsActive=true];
        } 
         for(Account_Team_Proxy__c accProxy:accProxyList){
           proxyEmailId.add(accProxy.User_Email__c);
         }

        // User & OrgwideEmailAddress query
        User u = [SELECT Id,Name,AccountId,Portal_Email__c,Username from User WHERE Id =:UserInfo.getuserId()];
        mapNameValuePair.put('USER_NAME',u.name);
        mapNameValuePair.put('USER_ID',u.Username);
        mapNameValuePair.put('REASON',Comments);
         if(String.valueOf(u.AccountId) != null && String.valueOf(u.AccountId) != ''){
              isCustomer = true;
          }
          else{
               isCustomer = false;
          }
          
          if(!isCustomer)
           customerEmailId.add(u.Portal_Email__c);
           
           if(lstMRSLChpAsso!=null && lstMRSLChpAsso.size()>0){ 
               customerId = [Select Id,Portal_Email__c,IsActive,ContactId from User WHERE AccountId = :lstMRSLChpAsso[0].Customer_Name__c and IsActive=true];
             }

           if(/*Label.MRS_Send_Email_To_Customer.equalsIgnoreCase('yes') &&*/ isCustomer && customerId.size()>0){ 
            for(user custId :customerId){
                if(custId.ContactId!=null){
                  contactIdSet.add(custId.ContactId);
               }                     
             }
           }
           
         // Portal Tab Access
         List<Portal_Tab_Access__c> portalTabAccessList = new List<Portal_Tab_Access__c>();  
         if(contactIdSet.size()>0)  
          portalTabAccessList = [SELECT Contact__c,My_Devices__c,PTRF__c FROM Portal_Tab_Access__c WHERE Contact__c IN :contactIdSet];  
        
         if(portalTabAccessList!=null && portalTabAccessList.size()>0){  
            for(Portal_Tab_Access__c pTAObj : portalTabAccessList){
                if(pTAObj.My_Devices__c && pTAObj.PTRF__c){
                   validContactIdSet.add(pTAObj.Contact__c);
                }
             }
          }  
          
         if(validContactIdSet.size()>0){
           for(user custId :customerId){
            if(validContactIdSet.contains(custId.ContactId))
             customerEmailId.add(custId.Portal_Email__c);
           }
         } 
           
        OrgWideEmailAddress Orgid=[Select id, DisplayName From OrgWideEmailAddress where DisplayName=:'GLOBALFOUNDRIES' LIMIT 1];
        
        //Retrieving Maskshop Email Distribution List and Populating Map of Maskshops to Maskshop Email Distribution List
      
            for(Released_Mask_Write_Distribution_List__c obj:[Select Distribution_List__c,Maskshop__r.Name from Released_Mask_Write_Distribution_List__c
                                                              ]){
                list<String> listDLs = new list<String>();
                if(mapMaskshopToDLs.containsKey(obj.Maskshop__r.Name.toUppercase())){
                    listDLs.addAll(mapMaskshopToDLs.get(obj.Maskshop__r.Name.toUppercase()));     
                }
                if(obj.Distribution_List__c.contains(';')){                 
                    listDLs.addAll(obj.Distribution_List__c.split(';'));                      
                }else{
                    listDLs.add(obj.Distribution_List__c); 
                }
                mapMaskshopToDLs.put(obj.Maskshop__r.Name.toUppercase(), listDLs);   
            }   
      
        
                //Retrieving Fab Email Distribution List and Populating Map of Fabs to Fab Email Distribution List
        
            for(Fab_Distribution_Table__c obj:[Select Fab_No__c,Distribution_List__c from Fab_Distribution_Table__c]){
                list<String> listFDTs = new list<String>();
                if(mapFabToDLs.containsKey(obj.Fab_No__c)){
                    listFDTs.addAll(mapFabToDLs.get(obj.Fab_No__c));        
                }
                if(obj.Distribution_List__c.contains(';')){
                    listFDTs.addAll(obj.Distribution_List__c.split(';'));   
                }else{
                    listFDTs.add(obj.Distribution_List__c); 
                }
                mapFabToDLs.put(obj.Fab_No__c, listFDTs);                     
            }   
          List<Messaging.SingleEmailMessage> massEmail = new List<Messaging.SingleEmailMessage>();
          List<Email_Config_Settings__c> lstecs =[SELECT Email_Template_Name__c,BCC__c,CC__c,Id,
                                                 Customer_Jobviewer_Type__c,
                                                 Foundry_Jobviewer_Type__c,Name,
                                                 MPW_PTRF__c,
                                                 
                                                 Send_Mail_To_Customer_AS_Submitter__c,
                                                 Tech_Geo_Value__c,TO__c,Send_Mail_To_Customer__c FROM Email_Config_Settings__c 
                                                 where Email_Template_Name__c=:et.DeveloperName and recordType.Name='Maskshop' and Available_For_Use__c=true];
           Integer counter = 0;  
             Map<String,Set<String>> mapETToMasks = new Map<String,Set<String>>(); 
             Map<String,Set<String>> mapConfigMasktoTo = new Map<String,Set<String>>();
             Map<String,Set<String>> mapConfigMasktoCc = new Map<String,Set<String>>();
             Map<String,Set<String>> mapConfigMasktoBcc = new Map<String,Set<String>>();
             Map<String,String> mapConfigMasktoSubject = new Map<String,String>();
             Map<String,String> mapConfigMasktoBody = new Map<String,String>();
             Map<String,String> mapKeytoTo = new Map<String,String>();
             Map<String,String> mapKeytoCc = new Map<String,String>();
             Map<String,String> mapKeytoBcc = new Map<String,String>();
             Map<String,List<MRS_Layer_Chip_Association__c>> mapConfigMasktoLayerChips = new Map<String,List<MRS_Layer_Chip_Association__c>>();            
           String layerName='';
           String maskSetTitleName; 
                                            
           for(Email_Config_Settings__c ecs:lstecs){
           
            Boolean mstNameStartswithMPW = ecs.MPW_PTRF__c;
            map<String,List<String>> mapMasktoDL = new map<String,List<String>>();
            map<String,Set<String>> mapMasktoFabDL = new map<String,Set<String>>();
            map<String,List<MRS_Layer_Chip_Association__c>> mapMaskshopToLayerChip = new map<String,List<MRS_Layer_Chip_Association__c>>();
            List<String> lstTekGeo = new List<String>();
            Set<String> setConfigToMaskshops = new Set<String>();
            Boolean toProxy = false;
            Boolean ccProxy = false;
            Boolean bccProxy = false;
            Boolean toFab = false;
            Boolean ccFab = false;
            Boolean bccFab = false;
            Boolean toCustomer = false;
            Boolean ccCustomer = false;
            Boolean bccCustomer = false;
            List<String> lstTo = new List<String>();
            List<String> lstCc = new List<String>();
            List<String> lstBcc = new List<String>();
            Boolean toDiscardFirst = true;
            Boolean ccDiscardFirst = true;
            Boolean bccDiscardFirst = true;
            
            if(ecs.TO__c!=null && ecs.TO__c!='' && ecs.TO__c.contains('#')){
              lstTo=ecs.TO__c.split('#');   
            }
            
            if(ecs.CC__c!=null && ecs.CC__c!='' && ecs.CC__c.contains('#')){
              lstCc=ecs.CC__c.split('#');
            }
            
            if(ecs.BCC__c!=null && ecs.BCC__c!='' && ecs.BCC__c.contains('#')){
              lstBcc=ecs.BCC__c.split('#');
            } 
            
            if(lstTo!=null && lstTo.size()>0){
              for(String str:lstTo){
                if(toDiscardFirst){
                 toDiscardFirst=false;
                 continue;
                }
                if(str.trim().equalsIgnoreCase('ATP')){
                  toProxy = true; 
                }
                if(str.trim().equalsIgnoreCase('Fab')){
                  toFab = true;
                }
                if(str.trim().equalsIgnoreCase('Customer')){
                  toCustomer = true;
                }  
              }
            }
            
            if(lstCc!=null && lstCc.size()>0){
              for(String str:lstCc){
                if(ccDiscardFirst){
                 ccDiscardFirst=false;
                 continue;
                }
                if(str.trim().equalsIgnoreCase('ATP')){
                  ccProxy = true; 
                }
                if(str.trim().equalsIgnoreCase('Fab')){
                  ccFab = true;
                }
                if(str.trim().equalsIgnoreCase('Customer')){
                  ccCustomer = true;
                }  
              }
            }
            
            if(lstBcc!=null && lstBcc.size()>0){
              for(String str:lstBcc){
                if(bccDiscardFirst){
                 bccDiscardFirst=false;
                 continue;
                }
                if(str.trim().equalsIgnoreCase('ATP')){
                  bccProxy = true; 
                }
                if(str.trim().equalsIgnoreCase('Fab')){
                  bccFab = true;
                }
                if(str.trim().equalsIgnoreCase('Customer')){
                  bccCustomer = true;
                }  
              }
            }

              if(ecs.Tech_Geo_Value__c!=null && ecs.Tech_Geo_Value__c!=''){
               if(ecs.Tech_Geo_Value__c.contains(';')) 
                 lstTekGeo = ecs.Tech_Geo_Value__c.split(';');
               else 
                 lstTekGeo.add(ecs.Tech_Geo_Value__c); 
              }   
                 Set<String> setTekGeo = new Set<String>();
               if(lstTekGeo!=null && lstTekGeo.size()>0){
                 for(String str:lstTekGeo){
                  if(setTekGeo.contains('NM'))
                   setTekGeo.add(str.subStringBefore('NM').trim());
                  else
                   setTekGeo.add(str);  
                  }
                } 
                
                  for(MRS_Layer_Chip_Association__c obj:lstMRSLChpAsso){
                   if(obj.PTRF__r.Maskshop__c!=null && obj.PTRF__r.Maskshop__c!=''){
                      maskSetTitleName=obj.PTRF__r.MaskSetTitle__r.Name;
                      Boolean mstnameMPW;
                      if(obj.Layer__r.Mask_Set_Title_Name__c.startsWith('MPW'))
                        mstnameMPW = true;
                      else
                        mstnameMPW = false;
                      String techGeo;   
                      if(obj.Layer__r.Tech_Geo__c != null){
                        techGeo = obj.Layer__r.Tech_Geo__c.toUpperCase().substringBefore('UM').trim();
                      }
                      
                      if(setTekGeo!=null && setTekGeo.size()>0){
                        if(setTekGeo.contains(string.valueOf(techGeo)) && (mstnameMPW==mstNameStartswithMPW)){
                           if(!setConfigToMaskshops.contains(obj.PTRF__r.Maskshop__c.toUppercase())){
                              setConfigToMaskshops.add(obj.PTRF__r.Maskshop__c.toUppercase());
                              mapETToMasks.put(ecs.Email_Template_Name__c+string.valueOf(counter),setConfigToMaskshops);
                             if(mapMaskshopToDLs!=null && mapMaskshopToDLs.size()>0 && mapMaskshopToDLs.get(obj.PTRF__r.Maskshop__c.toUppercase())!=null && mapMaskshopToDLs.get(obj.PTRF__r.Maskshop__c.toUppercase()).size()>0 && mapMasktoDL!=null && !mapMasktoDL.containsKey(obj.PTRF__r.Maskshop__c.toUppercase())) 
                               mapMasktoDL=createMaskDl(obj.PTRF__r.Maskshop__c.toUppercase(),mapMasktoDL,mapMaskshopToDLs);
                             } 
                             if(obj.PTRF__r.Fab__c!=null && obj.PTRF__r.Fab__c!=''){
                               if(mapFabToDLs!=null && mapFabToDLs.size()>0 && mapFabToDLs.get(obj.PTRF__r.Fab__c)!=null && mapFabToDLs.get(obj.PTRF__r.Fab__c).size()>0){    
                               if((toFab || ccFab || bccFab)){ 
                                  mapMasktoFabDL=createFabDL(obj.PTRF__r.Maskshop__c.toUppercase(),obj.PTRF__r.Fab__c,mapMasktoFabDL,mapFabToDLs);
                                }
                               }    
                             }
                            if(layerName==null || layerName==''){  
                             layerName=createLayerName(obj);
                            }
                           if(mapMaskshopToLayerChip.get(obj.PTRF__r.Maskshop__c.toUppercase())!=null && mapMaskshopToLayerChip.get(obj.PTRF__r.Maskshop__c.toUppercase()).size()>0){
                              mapMaskshopToLayerChip.get(obj.PTRF__r.Maskshop__c.toUppercase()).add(obj);                    
                           }  
                           else{ 
                              List<MRS_Layer_Chip_Association__c> lstChips = new List<MRS_Layer_Chip_Association__c>(); 
                               lstChips.add(obj); 
                               mapMaskshopToLayerChip.put(obj.PTRF__r.Maskshop__c.toUppercase(),lstChips);
                            }
                          }
                      }
                      else{
                        if(mstnameMPW==mstNameStartswithMPW){
                            if(!setConfigToMaskshops.contains(obj.PTRF__r.Maskshop__c.toUppercase())){
                              setConfigToMaskshops.add(obj.PTRF__r.Maskshop__c.toUppercase());
                              mapETToMasks.put(ecs.Email_Template_Name__c+string.valueOf(counter),setConfigToMaskshops);
                             if(mapMaskshopToDLs!=null && mapMaskshopToDLs.size()>0 && mapMaskshopToDLs.get(obj.PTRF__r.Maskshop__c.toUppercase())!=null && mapMaskshopToDLs.get(obj.PTRF__r.Maskshop__c.toUppercase()).size()>0 && mapMasktoDL!=null && !mapMasktoDL.containsKey(obj.PTRF__r.Maskshop__c.toUppercase())) 
                               mapMasktoDL=createMaskDl(obj.PTRF__r.Maskshop__c.toUppercase(),mapMasktoDL,mapMaskshopToDLs);
                             } 
                             if(obj.PTRF__r.Fab__c!=null && obj.PTRF__r.Fab__c!=''){
                               if(mapFabToDLs!=null && mapFabToDLs.size()>0 && mapFabToDLs.get(obj.PTRF__r.Fab__c)!=null && mapFabToDLs.get(obj.PTRF__r.Fab__c).size()>0){    
                               if((toFab || ccFab || bccFab)){ 
                                  mapMasktoFabDL=createFabDL(obj.PTRF__r.Maskshop__c.toUppercase(),obj.PTRF__r.Fab__c,mapMasktoFabDL,mapFabToDLs);
                                }
                               }    
                             }
                             
                             if(layerName==null || layerName==''){  
                              layerName=createLayerName(obj);
                             }  
                           if(mapMaskshopToLayerChip.get(obj.PTRF__r.Maskshop__c.toUppercase())!=null && mapMaskshopToLayerChip.get(obj.PTRF__r.Maskshop__c.toUppercase()).size()>0){
                              mapMaskshopToLayerChip.get(obj.PTRF__r.Maskshop__c.toUppercase()).add(obj);                    
                           }  
                           else{ 
                              List<MRS_Layer_Chip_Association__c> lstChips = new List<MRS_Layer_Chip_Association__c>(); 
                               lstChips.add(obj); 
                               mapMaskshopToLayerChip.put(obj.PTRF__r.Maskshop__c.toUppercase(),lstChips);
                            } 
                         } 
                       }  
                    }
                  }     
              
               for(String str:setConfigToMaskshops){
                   String subject = et.subject;
                   String plainBody = et.Body;
                   Set<String> setCc = new Set<String>();
                   Set<String> setBcc = new Set<String>();
                   Set<String> setTo = new Set<String>();
                   
                   if(mapMasktoDL!=null && mapMasktoDL.size()>0 && mapMasktoDL.get(str)!=null && mapMasktoDL.get(str).size()>0) 
                    setTo.addAll(mapMasktoDL.get(str));
                   if(toProxy || ccProxy || bccProxy){
                     if(toProxy){
                      if(proxyEmailId!=null && proxyEmailId.size()>0)
                       setTo.addAll(proxyEmailId);
                      } 
                     if(ccProxy){
                      if(proxyEmailId!=null && proxyEmailId.size()>0)
                       setCc.addAll(proxyEmailId);
                      } 
                     if(bccProxy){
                      if(proxyEmailId!=null && proxyEmailId.size()>0)
                       setBcc.addAll(proxyEmailId);
                      } 
                   }
                   
                   if(toFab || ccFab || bccFab){
                     if(toFab){
                      if(mapMasktoFabDL.get(str)!=null && mapMasktoFabDL.get(str).size()>0)
                       setTo.addAll(mapMasktoFabDL.get(str));
                       }
                     if(ccFab){
                      if(mapMasktoFabDL.get(str)!=null && mapMasktoFabDL.get(str).size()>0)
                       setCc.addAll(mapMasktoFabDL.get(str));
                     }  
                     if(bccFab){
                      if(mapMasktoFabDL.get(str)!=null && mapMasktoFabDL.get(str).size()>0)
                       setBcc.addAll(mapMasktoFabDL.get(str));
                       }
                   }
                   
                   if((toCustomer || ccCustomer || bccCustomer) && ecs.Send_Mail_To_Customer__c==true){
                     if(toCustomer){
                      if(customerEmailId!=null && customerEmailId.size()>0)
                       setTo.addAll(customerEmailId);
                      } 
                     if(ccCustomer){
                      if(customerEmailId!=null && customerEmailId.size()>0)
                       setCc.addAll(customerEmailId);
                      } 
                     if(bccCustomer){
                      if(customerEmailId!=null && customerEmailId.size()>0) 
                       setBcc.addAll(customerEmailId);
                      } 
                   }
                   
                   if(u.Portal_Email__c!=null && u.Portal_Email__c!='')
                    setCc.add(u.Portal_Email__c);

                        if(setTo!=null && setTo.size()>0)
                         mapConfigMasktoTo.put(ecs.Email_Template_Name__c+string.valueof(counter)+str,setTo);
                        if(setCc!=null && setCc.size()>0)
                         mapConfigMasktoCc.put(ecs.Email_Template_Name__c+string.valueof(counter)+str,setCc);
                        if(setBcc!=null && setBcc.size()>0) 
                         mapConfigMasktoBcc.put(ecs.Email_Template_Name__c+string.valueof(counter)+str,setBcc);
                         
                         if(mapMaskshopToLayerChip!=null && mapMaskshopToLayerChip.get(str)!=null && mapMaskshopToLayerChip.get(str).size()>0){
                            mapConfigMasktoLayerChips.put(ecs.Email_Template_Name__c+'::'+string.valueof(counter)+'::'+str,mapMaskshopToLayerChip.get(str));
                         } 
                         
                        if(subject!=null && subject!=''){
                         mapConfigMasktoSubject.put(ecs.Email_Template_Name__c+string.valueof(counter)+str,subject);
                        } 
                        if(plainBody!=null && plainBody!=''){
                         mapConfigMaskToBody.put(ecs.Email_Template_Name__c+string.valueof(counter)+str,plainBody);
                        } 
                        mapKeytoTo.put(ecs.Email_Template_Name__c+string.valueof(counter)+str,ecs.TO__c);
                        mapKeytoCc.put(ecs.Email_Template_Name__c+string.valueof(counter)+str,ecs.CC__c);
                        mapKeytoBcc.put(ecs.Email_Template_Name__c+string.valueof(counter)+str,ecs.Bcc__c);
               }  
             counter++;                                  
          }
           
            Map<String,List<String>> MapKeyToRecvdTo = new Map<String,List<String>>();
            Map<String,List<String>> MapKeyToRecvdCc = new Map<String,List<String>>();
            Map<String,List<String>> MapKeyToRecvdBcc = new Map<String,List<String>>();
            Map<String,List<String>> mapKeytoRecvdSubjectBody = new Map<String,List<String>>(); 
            
            MapKeyToRecvdTo=EmailHandlerUtility.buildRecipientList(mapKeytoTo,null,null,false,null);
            MapKeyToRecvdCc=EmailHandlerUtility.buildRecipientList(mapKeytoCc,null,null,false,null);
            MapKeyToRecvdBcc=EmailHandlerUtility.buildRecipientList(mapKeytoBcc,null,null,false,null);
            
            mapKeytoRecvdSubjectBody=EmailSubjectBodyPerMaskshop.generateSubBodyPerMaskshop(mapConfigMasktoLayerChips,mapNameValuePair);
            
          Integer counter2=0;
          
           for(Email_Config_Settings__c ecs:lstecs){

            if(mapETToMasks!=null && mapETToMasks.size()>0 && mapETToMasks.get(ecs.Email_Template_Name__c+string.valueof(counter2))!=null && mapETToMasks.get(ecs.Email_Template_Name__c+string.valueof(counter2)).size()>0){
            
             for(String str:mapETToMasks.get(ecs.Email_Template_Name__c+string.valueof(counter2))){
              List<String> toAddress = new List<String>();
              List<String> ccAddress = new List<String>();
              List<String> bccAddress = new List<String>();
              List<String> lstSubBod = new List<String>();
               String subject = '';
               String plainBody = '';
                 if(mapKeytoRecvdSubjectBody.get(ecs.Email_Template_Name__c+'::'+string.valueof(counter2)+'::'+str)!=null && mapKeytoRecvdSubjectBody.get(ecs.Email_Template_Name__c+'::'+string.valueof(counter2)+'::'+str).size()>0){
                  lstSubBod = mapKeytoRecvdSubjectBody.get(ecs.Email_Template_Name__c+'::'+string.valueof(counter2)+'::'+str);
                  subject = lstSubBod[0];
                  plainBody = lstSubBod[1];
                  plainBody = plainBody.replace('#ECS','ECS : '+ecs.Name);
                 }  
              
             if(mapConfigMasktoTo.get(ecs.Email_Template_Name__c+string.valueof(counter2)+str)!=null && mapConfigMasktoTo.get(ecs.Email_Template_Name__c+string.valueof(counter2)+str).size()>0) 
              toAddress.addAll(mapConfigMasktoTo.get(ecs.Email_Template_Name__c+string.valueof(counter2)+str));
             if(mapConfigMasktoCc.get(ecs.Email_Template_Name__c+string.valueof(counter2)+str)!=null && mapConfigMasktoCc.get(ecs.Email_Template_Name__c+string.valueof(counter2)+str).size()>0) 
              ccAddress.addAll(mapConfigMasktoCc.get(ecs.Email_Template_Name__c+string.valueof(counter2)+str));
             if(mapConfigMasktoBcc.get(ecs.Email_Template_Name__c+string.valueof(counter2)+str)!=null && mapConfigMasktoBcc.get(ecs.Email_Template_Name__c+string.valueof(counter2)+str).size()>0) 
              bccAddress.addAll(mapConfigMasktoBcc.get(ecs.Email_Template_Name__c+string.valueof(counter2)+str));
             if(MapKeyToRecvdTo.get(ecs.Email_Template_Name__c+string.valueof(counter2)+str)!=null && MapKeyToRecvdTo.get(ecs.Email_Template_Name__c+string.valueof(counter2)+str).size()>0) 
              toAddress.addAll(MapKeyToRecvdTo.get(ecs.Email_Template_Name__c+string.valueof(counter2)+str));
             if(MapKeyToRecvdCc.get(ecs.Email_Template_Name__c+string.valueof(counter2)+str)!=null && MapKeyToRecvdCc.get(ecs.Email_Template_Name__c+string.valueof(counter2)+str).size()>0) 
              ccAddress.addAll(MapKeyToRecvdCc.get(ecs.Email_Template_Name__c+string.valueof(counter2)+str));
             if(MapKeyToRecvdBcc.get(ecs.Email_Template_Name__c+string.valueof(counter2)+str)!=null && MapKeyToRecvdBcc.get(ecs.Email_Template_Name__c+string.valueof(counter2)+str).size()>0)
              bccAddress.addAll(MapKeyToRecvdBcc.get(ecs.Email_Template_Name__c+string.valueof(counter2)+str));

            if((toAddress!=null && toAddress.size()>0) && (subject!=null && subject!='') && (plainBody!=null && plainBody!='')) 
              massEmail.addAll(MRSHandlerUtility.partingToCCBccAddress(toAddress,ccAddress,bccAddress,Orgid,true,subject,plainBody));
            }
           } 
            counter2++;
           }

           Messaging.sendEmail(massEmail);
           }
              catch(Exception e)
           {
               EmailHandlerUtility.saveEmailExceptionErrorLog(e, '','' ,'EmailHandlerUtilityPerMaskShop','sendChipEmailPerMaskshop');
              
           } 
     }  

    public static Map<String,String> createMApMaskFab(String mlcaFab,Map<String,String> mapMaskshopToFabs,String maskShopName){
      String setFabs = '';
       if(mapMaskshopToFabs.containsKey(maskshopName)){
 
          List<String> lstStr = new List<String>();
          Set<String>  setStr = new Set<String>();
          List<String> lstRetStr = new List<String>();
          
          setFabs=mapMaskshopToFabs.get(maskshopName);
           if(setFabs.contains(',')){
            lstStr = setFabs.split(',');    
           }
           else{
            lstStr.add(setFabs);
           }
           if(lstStr.size()>0)
            setStr.addAll(lstStr);
           if(!string.isBlank(mlcaFab)) 
            setStr.add(mlcaFab);
           if(setStr.size()>0) 
            lstRetStr.addAll(setStr); 
           
           if(lstRetStr.size()>0) 
            setFabs=String.join(lstRetStr,','); 
        }
       else{
         setFabs = mlcaFab;
       }
      
      if(!string.isBlank(setFabs)) 
       mapMaskshopToFabs.put(maskshopName,setFabs);
        return mapMaskshopToFabs;
    }


    public static Map<String,String> createMApMaskTech(String mlcaTech,Map<String,String> mapMaskshopToTechGeos,String maskShopName){
     String setTGs = '';
     if(mapMaskshopToTechGeos.containsKey(maskshopName)){
      
          List<String> lstStr = new List<String>();
          Set<String>  setStr = new Set<String>();
          List<String> lstRetStr = new List<String>();
          
          setTGs=mapMaskshopToTechGeos.get(maskshopName);
           if(setTGs.contains(',')){
            lstStr = setTGs.split(',');    
           }
           else{
            lstStr.add(setTGs);
           }
           if(lstStr.size()>0)
            setStr.addAll(lstStr);
           if(!string.isBlank(mlcaTech)) 
            setStr.add(mlcaTech);
           if(setStr.size()>0) 
            lstRetStr.addAll(setStr); 
           
           if(lstRetStr.size()>0) 
            setTGs=String.join(lstRetStr,',');
         }
        else{
          setTGs=mlcaTech;
         }
         
        if(!string.isBlank(setTGs)) 
         mapMaskshopToTechGeos.put(maskshopName, setTGs);
        return mapMaskshopToTechGeos;
        }

  public static Map<String,String> createMApMaskLayers(String layerName,Map<String,String> mapMaskshopToLayerIds,String maskshopname){
                      
     String setLayers = '';
                       
     if(mapMaskshopToLayerIds.containsKey(maskshopName)){

          List<String> lstStr = new List<String>();
          Set<String>  setStr = new Set<String>();
          List<String> lstRetStr = new List<String>();
          
          setLayers=mapMaskshopToLayerIds.get(maskshopName);
           if(setLayers.contains(',')){
            lstStr = setLayers.split(',');    
           }
           else{
            lstStr.add(setLayers);
           }
           if(lstStr.size()>0)
            setStr.addAll(lstStr);
           if(!string.isBlank(layerName)) 
            setStr.add(layerName);
           if(setStr.size()>0) 
            lstRetStr.addAll(setStr); 
           
           if(lstRetStr.size()>0) 
            setLayers=String.join(lstRetStr,',');   
         }
         else{
            setLayers = layerName; 
         }
         
     if(!String.isBlank(setLayers)) 
        mapMaskshopToLayerIds.put(maskshopName,setLayers);
     return mapMaskshopToLayerIds;
   }
   
   public static String createLayerName(MRS_Layer_Chip_Association__c obj){
    String layerName = '';
    if(obj.Layer__r.ROM_Code__c!=null && obj.Layer__r.ROM_Code__c!='####'){
        layerName = obj.Layer__r.Name+obj.Layer__r.Mask_Layer_Rev__c+'('+obj.Layer__r.ROM_Code__c+')';
      }
     else{
        layerName = obj.Layer__r.Name+obj.Layer__r.Mask_Layer_Rev__c;
      }
      return layerName;
   }
   
   public static Map<String,List<String>> createMaskDl(String maskshopname,Map<String,List<String>> mapMasktoDL,Map<String,list<String>> mapMaskshopToDLs){
   
     if(!mapMasktoDL.containsKey(maskshopname)){
      List<String> lstStr = new List<String>();
      if(mapMaskshopToDLs!=null && mapMaskshopToDLs.get(maskshopname).size()>0 && mapMaskshopToDLs.get(maskshopname)!=null)
       lstStr=mapMaskshopToDLs.get(maskshopname);
        if(mapMasktoDL!=null)
         mapMasktoDL.put(maskshopname,lstStr);
        else{
         mapMasktoDL=new Map<String,List<String>>(); 
         mapMasktoDL.put(maskshopname,lstStr);
        }
     }

    return mapMasktoDL;
   }
   
   public static Map<String,Set<String>> createFabDL(String maskshopName,String fabName,Map<String,Set<String>> mapMasktoFabDL,Map<String,List<String>> mapFabToDLs){
    if(mapMasktoFabDL.containsKey(maskshopName)) { 
       Set<String> setStr = new Set<String>();
       setStr=mapMasktoFabDL.get(maskshopName);
       setStr.addAll(mapFabToDLs.get(fabName));
       mapMasktoFabDL.put(maskshopName,setStr);
    }
    else{
       Set<String> setStr = new Set<String>();
       setStr.addAll(mapFabToDLs.get(fabName));
       mapMasktoFabDL.put(maskshopName,setStr);
    }
    return mapMasktoFabDL;
   }
}