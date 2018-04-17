/*
Type Name: DocumentProvisioningTrigger Trigger
Author: Cognizant 
Created Date: 20-June-2013
Reason: 
Change History:
Author: 
Modified Date: 
Reason: 
Ã¢â‚¬Â¦Ã¢â‚¬Â¦..
Ã¢â‚¬Â¦Ã¢â‚¬Â¦..
Asolito 08012014 - Added condition to bypass White Paper design specs
Author: Cognizant
Modified Date: 2/10/2015
Reason: Case 38581 - Checkthe checkboxes for provisioning spec with Tech geo =NA
    
*/

trigger DocumentProvisioningTrigger on Document_Provisioning__c (after insert,after update,Before insert,Before update) {
    
    if(!IntegrationUserUtil.isSkipTrigger()){       
       
       /*-------------------added for Case 34665 start------------------------------------------------------------*/
          if(trigger.isinsert && trigger.isbefore){
             Map<Id,Id> mapofDpSpecIds=new Map<Id,Id>();
             List<IPDK_License_Information__c> lstIPDKInformation;
              
             for(Document_Provisioning__c objDP: trigger.new){
                if(objDP.Design_spec__c!=NULL){
                    mapofDpSpecIds.put(objDP.Id,objDP.Design_spec__c);
                }
             }
             if(mapofDpSpecIds!=NULL){
                lstIPDKInformation=[Select id,
                                  name,
                                  Specification__c,
                                  Account__c 
                                  from IPDK_License_Information__c 
                                  where Specification__c in:mapofDpSpecIds.values()];
             }
             for(Document_Provisioning__c objDP: trigger.new){
                  if(lstIPDKInformation<>Null &&!lstIPDKInformation.isEmpty()){
                     for(IPDK_License_Information__c objipdk :lstIPDKInformation){
                        if(objipdk.Specification__c==objDP.Design_spec__c && objipdk.Account__c==objDP.Account__c){
                            objDP.IPLA__c=true;
                        }
                     } 
                  }   
             }  
         }
    /*-------------------added for Case 34665 end------------------------------------------------------------*/              

        if(trigger.isafter && (trigger.isinsert || trigger.isupdate)){
            DesignSpecTriggerHandler.isAfterExecuted();
            
            List<Document_Provisioning__c>  lstDPSentForApproval = new List<Document_Provisioning__c>();
            List<Document_Provisioning__c>  lstDPProvisioned = new List<Document_Provisioning__c>();
            List<Document_Provisioning__c>  lstDPDeProvisioned = new List<Document_Provisioning__c>();
            set<String> setAllAccountIds = new set<String>();
            
            for(Document_Provisioning__c objDP: trigger.new){
                // Temparay Added for New PDK provisioning. Below check will not run PDK related code
                if(objDP.Sub_PDK__c == NULL){ 
                    if(objDP.Status__c=='Sent For Approval'){
                       /* if(trigger.isInsert || (trigger.isUpdate && Trigger.oldMap.get(objDP.ID).Status__c!='Sent For Approval')){
                            lstDPSentForApproval.add(objDP);
                        }*/
                        if(trigger.isInsert || (trigger.isUpdate && (Trigger.oldMap.get(objDP.ID).Status__c!='Sent For Approval' 
                                                                 && Trigger.oldMap.get(objDP.ID).Status__c!='Provisioned'))){
    
                            lstDPSentForApproval.add(objDP);
                        }
                    }
                    if(objDP.Status__c=='Provisioned'){
                        if(trigger.isInsert || (trigger.isUpdate && Trigger.oldMap.get(objDP.ID).Status__c!='Provisioned')){
                            lstDPProvisioned.add(objDP);                        
                        }
                    }
                    
                    if(objDP.Status__c=='De-Provisioned'){
                        if((trigger.isUpdate && Trigger.oldMap.get(objDP.ID).Status__c!='De-Provisioned')){
                            lstDPDeProvisioned.add(objDP);                      
                            setAllAccountIds.add(objDP.Account_Short_Name__c);       
                        }
                    }
                }
            }    
            if(lstDPSentForApproval!=null && lstDPSentForApproval.size()>0){
                // DesignSpecTriggerHandler.submitApprovalProcess(lstDPSentForApproval); // Commented by Cognizant on 2406201 for CR#27641 
                //DesignSpecTriggerHandler.submitApprovalProcessHighVolume(lstDPSentForApproval); // Added by Cognizant on 2406201 for CR#27641
            }
                       
           /* if(lstDPProvisioned!=null && lstDPProvisioned.size()>0){
                DesignSpecTriggerHandler.addAccountProvisionedTo(lstDPProvisioned);
            }
            if(lstDPDeProvisioned!=null && lstDPDeProvisioned.size()>0){
                DesignSpecTriggerHandler.removeAccountProvisionedTo(lstDPDeProvisioned,setAllAccountIds);
            }*/
            //}// END PDK code block     
        }
        // For all document provisioning insert/update operations with updated status as 'provisioned'-populate NDA related information 
       // if((Trigger.isInsert || Trigger.isUpdate) && Trigger.isBefore && !DesignSpecTriggerHandler.isBeforeExecuted){
           if((Trigger.isInsert || Trigger.isUpdate) && Trigger.isBefore ){
           
            // added for 31780 && 31833
           // DesignSpecTriggerHandler.isBeforeExecuted();
            
            if(Trigger.isUpdate){
                Set<Id> dProvisionIds = new Set<Id>();
                Map<Id,String> MapOfDpIdAndApprovalProcessComment = new Map<Id,String>();  
                          
                for(Document_Provisioning__c objDP: trigger.new){
                    if (objDP.Sub_PDK__c == NULL){
                        if(objDP.Status__c=='Provisioned' || objDP.Status__c=='Rejected'){                                      
                            if(Trigger.oldMap.get(objDP.ID).Status__c=='Sent For Approval'){
                                System.debug('Value of Approval_Process_Comments__c before is ' + objDP.Approval_Process_Comments__c);
                                dProvisionIds.add(objDP.Id);
                            }
                        }
                    }
                }           
                if(dProvisionIds<>Null && !dProvisionIds.isEmpty()){
                    MapOfDpIdAndApprovalProcessComment = DesignSpecTriggerHandler.getApprovalProcessComments(dProvisionIds);
                }
                if (MapOfDpIdAndApprovalProcessComment<>Null){
                    for(Id dpID: Trigger.newMap.keySet()){
                        if(MapOfDpIdAndApprovalProcessComment.containsKey(dpID)){
                            Trigger.newMap.get(dpID).Approval_Process_Comments__c = MapOfDpIdAndApprovalProcessComment.get(dpID);
                        }
                    }
                }
            }
            
            set<id> accids=new set<id>();
            set<id> specIds=new set<id>();
            set<id> pdkIds=new set<id>();


            map<id,account> mapacc=new map<id,account>();
            map<id,design_spec__c> mapSpec=new map<id,design_spec__c>();
            map<id,sub_pdk__c> mapPDK=new map<id,sub_pdk__c>();

            for(document_provisioning__c dp:Trigger.new){
                if (dp.Sub_PDK__c == NULL){
                    if((Trigger.isInsert && dp.status__c=='Provisioned') || (Trigger.isUpdate && dp.status__c=='Provisioned' && Trigger.oldMap.get(dp.id).status__c!='Provisioned')){
                        accids.add(dp.account__c);
                        if(dp.Design_Spec__c!=null)
                            specIds.add(dp.Design_Spec__c);    
                        if(dp.Sub_PDK__c!=null)
                            pdkIds.add(dp.Sub_PDK__c);                        



                    }
                }    
            }
            if(accids!=null && !accids.isEmpty()){
                for(account acc:[select id,Tech_Geo_Granted__c,Valid_Tech_Geos__c,Has_Valid_NDA__c,ASIC_Business_Flag__c from account where id in :accids]){
                    mapacc.put(acc.id,acc);        
                }
            }
            if(!specIds.isEmpty()){
                for(design_spec__c ds:[select id,technology_geometry__c,specification_type__c,Specification_ASIC_Flag__c from design_spec__c where id in :specIds]){
                    mapSpec.put(ds.id,ds);            
                }
            }
            if(!pdkIds.isEmpty()){
                for(sub_pdk__c pdk:[select id,tech_geometry__c from sub_pdk__c where id in :pdkIds]){
                    mappdk.put(pdk.id,pdk);            
                }
            }            






         
            for(document_provisioning__c dp :Trigger.new){
                if (dp.Sub_PDK__c == NULL){
                    // Check for NDA coverage of Technology geometries                
                    if(dp.Design_Spec__c!=null){ 
                        //Asolito - bypass NDA check if spec type is white papers
                        if(mapSpec!=null && mapSpec.containskey(dp.Design_Spec__c) && mapSpec.get(dp.Design_Spec__c).specification_type__c == 'White Papers'){
                            dp.NDA_Coverage__c=true;    
                        } else { 
                           // if(mapSpec!=null && mapSpec.containskey(dp.Design_Spec__c) && mapSpec.get(dp.Design_Spec__c).technology_geometry__c!=null){
                                               
                            if(mapSpec!=null && mapSpec.containskey(dp.Design_Spec__c) && mapSpec.get(dp.Design_Spec__c).technology_geometry__c!=null && mapSpec.get

(dp.Design_Spec__c).technology_geometry__c!='Not Applicable'){//added for Case38581
                                for(string s:mapSpec.get(dp.Design_Spec__c).technology_geometry__c.split(';')){
                                    if(mapacc!=null && mapacc.containskey(dp.account__c) && mapacc.get(dp.account__c).Valid_Tech_Geos__c!=null && (mapacc.get

(dp.account__c).Valid_Tech_Geos__c.contains(s)|| mapacc.get(dp.account__c).Valid_Tech_Geos__c.contains(s.substring(0,6)))){
                                        dp.NDA_Coverage__c=true;    
                                    }
                                    
                                }
                            }
                            
                           // else if(mapSpec!=null && mapSpec.containskey(dp.Design_Spec__c) && mapSpec.get(dp.Design_Spec__c).technology_geometry__c==null){
                              
                            else if(mapSpec!=null && mapSpec.containskey(dp.Design_Spec__c) && (mapSpec.get(dp.Design_Spec__c).technology_geometry__c==null || 

mapSpec.get(dp.Design_Spec__c).technology_geometry__c=='Not Applicable')){//added for Case38581
                                if(mapacc!=null && mapacc.containskey(dp.account__c) && mapacc.get(dp.account__c).Has_Valid_NDA__c==true){
                                    dp.NDA_Coverage__c=true;    
                                }  
                           } 
                       }                     
                    }
                   /* else if(dp.sub_pdk__c!=null){
                        if(mappdk!=null && mappdk.containskey(dp.sub_pdk__c) && mappdk.get(dp.sub_pdk__c).tech_geometry__c!=null ){
                            for(string s:mappdk.get(dp.sub_pdk__c).tech_geometry__c.split(';')){
                                if(mapacc!=null && mapacc.containskey(dp.account__c) && mapacc.get(dp.account__c).Valid_Tech_Geos__c!=null && (mapacc.get

(dp.account__c).Valid_Tech_Geos__c.contains(s) || mapacc.get(dp.account__c).Valid_Tech_Geos__c.contains(s.substring(0,6)))){
                                    dp.NDA_Coverage__c=true;    
                                }                           
                            }
                        }
                        else if(mappdk!=null && mappdk.containskey(dp.sub_pdk__c) && mappdk.get(dp.sub_pdk__c).tech_geometry__c==null){
                            if(mapacc!=null && mapacc.containskey(dp.account__c)  && mapacc.get(dp.account__c).Has_Valid_NDA__c==true){
                                dp.NDA_Coverage__c=true;    
                            }  
                       }  
                        
                    }
                   

                    else if(dp.design_package__c!=null){
                        if(mappackage!=null && mappackage.containskey(dp.design_package__c) && mappackage.get(dp.design_package__c).tech_geometry__c!=null ){
                            for(string s:mappackage.get(dp.design_package__c).tech_geometry__c.split(';')){
                                if(mapacc!=null && mapacc.containskey(dp.account__c) && mapacc.get(dp.account__c).Valid_Tech_Geos__c!=null && (mapacc.get

(dp.account__c).Valid_Tech_Geos__c.contains(s) || mapacc.get(dp.account__c).Valid_Tech_Geos__c.contains(s.substring(0,6)))){
                                    dp.NDA_Coverage__c=true;    
                                }                           
                            }
                        }
                        else if(mappackage!=null && mappackage.containskey(dp.design_package__c) && mappackage.get(dp.design_package__c)!=null && mappackage.get

(dp.design_package__c).tech_geometry__c==null){
                            if(mapacc!=null && mapacc.containskey(dp.account__c) && mapacc.get(dp.account__c).Has_Valid_NDA__c==true){
                                dp.NDA_Coverage__c=true;    
                            }  
                       }                     
                    }
                    */ 
                    

                    // Check if Technology geometries is manually granted at account level.
                    if(dp.Design_Spec__c!=null){
                        //Asolito - bypass NDA check if spec type is white papers
                        if(mapSpec!=null && mapSpec.containskey(dp.Design_Spec__c) && mapSpec.get(dp.Design_Spec__c).specification_type__c == 'White Papers'){
                            dp.Tech_Geo_Granted_to_Account__c=true;    
                        } else {
                           // if(mapSpec!=null && mapSpec.containskey(dp.Design_Spec__c) && mapSpec.get(dp.Design_Spec__c).technology_geometry__c!=null ){
                              if(mapSpec!=null && mapSpec.containskey(dp.Design_Spec__c) && mapSpec.get(dp.Design_Spec__c).technology_geometry__c!=null && mapSpec.get

(dp.Design_Spec__c).technology_geometry__c!='Not Applicable' ){//added for case 38581 
                              
                                for(string s:mapSpec.get(dp.Design_Spec__c).technology_geometry__c.split(';')){
                                    if(mapacc!=null && mapacc.containskey(dp.account__c) && mapacc.get(dp.account__c).Tech_Geo_Granted__c!=null && (mapacc.get

(dp.account__c).Tech_Geo_Granted__c.contains(s) || mapacc.get(dp.account__c).Tech_Geo_Granted__c.contains(s.substring(0,6)))){
                                        dp.Tech_Geo_Granted_to_Account__c=true;    
                                    }
                                    
                                }
                            }
                            //else if(mapSpec!=null && mapSpec.containskey(dp.Design_Spec__c) && mapSpec.get(dp.Design_Spec__c).technology_geometry__c==null){
                              else if(mapSpec!=null && mapSpec.containskey(dp.Design_Spec__c) && (mapSpec.get(dp.Design_Spec__c).technology_geometry__c==null || 

mapSpec.get(dp.Design_Spec__c).technology_geometry__c=='Not Applicable')){//added for Case 38581 
                              
                                if(mapacc!=null && mapacc.containskey(dp.account__c) && mapacc.get(dp.account__c).Has_Valid_NDA__c==true){
                                    dp.Tech_Geo_Granted_to_Account__c=true;    
                                }  
                           } 
                       }                     
                    }
                    /*else if(dp.sub_pdk__c!=null){
                        if(mappdk!=null && mappdk.containskey(dp.sub_pdk__c) && mappdk.get(dp.sub_pdk__c).tech_geometry__c!=null ){
                            for(string s:mappdk.get(dp.sub_pdk__c).tech_geometry__c.split(';')){
                                if(mapacc!=null && mapacc.containskey(dp.account__c) && mapacc.get(dp.account__c).Tech_Geo_Granted__c!=null && (mapacc.get

(dp.account__c).Tech_Geo_Granted__c.contains(s) || mapacc.get(dp.account__c).Tech_Geo_Granted__c.contains(s.substring(0,6)))){
                                    dp.Tech_Geo_Granted_to_Account__c=true;    
                                }                           
                            }
                        }
                        else if(mappdk!=null && mappdk.containskey(dp.sub_pdk__c) && mappdk.get(dp.sub_pdk__c).tech_geometry__c==null){
                            if(mapacc!=null && mapacc.containskey(dp.account__c)  && mapacc.get(dp.account__c).Has_Valid_NDA__c==true){
                                dp.Tech_Geo_Granted_to_Account__c=true;    
                            }  
                       }  
                        
                    }

                    
                    else if(dp.design_package__c!=null){
                        if(mappackage!=null && mappackage.containskey(dp.design_package__c) && mappackage.get(dp.design_package__c).tech_geometry__c!=null ){
                            for(string s:mappackage.get(dp.design_package__c).tech_geometry__c.split(';')){
                                if(mapacc!=null && mapacc.containskey(dp.account__c) && mapacc.get(dp.account__c).Tech_Geo_Granted__c!=null && (mapacc.get

(dp.account__c).Tech_Geo_Granted__c.contains(s) || mapacc.get(dp.account__c).Tech_Geo_Granted__c.contains(s.substring(0,6)))){
                                    dp.Tech_Geo_Granted_to_Account__c=true;    
                                }                           
                            }
                        }
                        else if(mappackage!=null && mappackage.containskey(dp.design_package__c) && mappackage.get(dp.design_package__c).tech_geometry__c==null){
                            if(mapacc!=null && mapacc.containskey(dp.account__c) && mapacc.get(dp.account__c).Has_Valid_NDA__c==true){
                                dp.Tech_Geo_Granted_to_Account__c=true;    
                            }  
                       }                     
                    }
                    */

                    if(dp.status__c=='Provisioned' && dp.NDA_Coverage__c && dp.Tech_Geo_Granted_to_Account__c){                       
                            dp.final_user_access__c=true;
                    }
                     // if ASIC Business for normal specs
                     if(mapSpec!=null && mapSpec.containskey(dp.Design_Spec__c) && mapSpec.get(dp.Design_Spec__c).Specification_ASIC_Flag__c){  
                        if(mapacc!=null && mapacc.containskey(dp.account__c) && mapacc.get(dp.account__c).ASIC_Business_Flag__c){
                                  dp.final_user_access__c=true;
                        }
                        else{
                          dp.final_user_access__c=false;                                                   
                        }
                     }                              
                                            
                   // if((dp.status__c!='Provisioned' || !dp.NDA_Coverage__c || !dp.Tech_Geo_Granted_to_Account__c) && dp.final_user_access__c){
                   //     dp.final_user_access__c=false;
                   // }
                    
                     if((dp.status__c=='De-Provisioned' || !dp.NDA_Coverage__c || !dp.Tech_Geo_Granted_to_Account__c) && dp.final_user_access__c){                    
                     dp.final_user_access__c=false;                                          
                     } 
                     
                     if(mapacc.containskey(dp.account__c) && dp.status__c=='De-Provisioned' && dp.final_user_access__c){                    
                         dp.final_user_access__c=false;                                               
                     }   
                     system.debug('**PK****'+dp.final_user_access__c); 
                                                              
                }// END OF PDK Related code blocking to execute this trigger 
          } // END OF Inner FOR LOOP
    } // END of before trigger condition
    
} // End of trigger runnig check   
    
} // End of Trigger