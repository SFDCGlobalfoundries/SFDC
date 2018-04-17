/**
* @ Author :- Navneet Rajput
* @ Company :- CTS 
* @ Description :- Class handles PDK updates coming from OT
                 After PDK document get provisioned request will be send to OT and after succesfully provisioned 
                 in to OT, Ot will return response to SFDC. This service is response service for PDK.  
* @ Date :- 12/1/2014
* @ Change History :- 
**/
global class FV_DocumentProvisioningService { 
    
    private static final String DELIMETER = ';';
    public static Map<String, Spec_Owner__c> mapSpecOwner = Spec_Owner__c.getAll();   
    // Handles new provision PDK response and update  
    // bundle fields accordingly  
    webservice static responseInfo PdkProResponseService(List<PDKProInfo> pdkInfo){
      system.debug('Inside PdkProResponseService---pdkInfo>>>>>>>>>>>>>>>>'+pdkInfo);
        try {
            if (pdkInfo<>NULL && !pdkInfo.isEmpty()){
                Set<String> subPdkIds;
                Set<String> dpIds;
                Set<String> accNames;
                Map<Id,Document_Provisioning__c> mapOfDpRecords;
                List<Document_Provisioning__c> listOfDp = new List<Document_Provisioning__c>(); 
                
                subPdkIds = FV_DocumentProvisioningService.getSubPdkIds(pdkInfo);
                dpIds = FV_DocumentProvisioningService.getDoProIds(pdkInfo);
                accNames = FV_DocumentProvisioningService.getAccShrtNames(pdkInfo);
                system.debug('subPdkIds >>>>>>>>>>>>'+subPdkIds);
                system.debug('dpIds>>>>>>>>>>>>>'+dpIds);
                system.debug('accNames>>>>>>>>>>>>>>'+accNames);
                
                
                mapOfDpRecords = new Map<Id,Document_Provisioning__c>([SELECT Id,Name,Status__c,isDeletionNeeded__c,AccountID__c,AccountID__r.Short_Name__c,PdkSpecs__c,
                                                                              Sync_With_OpenText__c,PDK_Provisoin_To_Updated_Specs__c,PDK_Spec_Names__c,
                                                                              PDK_Failure_Specs__c,PDK_Failure_DeProSpecs__c,OpenText_Error_Message__c 
                                                                        FROM  Document_Provisioning__c 
                                                                        WHERE Id IN : dpIds AND Status__c!='De-Provisioned']);
                                                                        //WHERE   Sub_PDK__r.OTID__c IN : subPdkIds
                                                                        //AND     AccountID__r.Short_Name__c IN : accNames
                                                                        //AND     Id IN : dpIds]); 
                                                                        
                system.debug('mapOfDpRecords>>>>>>>>>>>>>>>>'+mapOfDpRecords);                                                      
                if (mapOfDpRecords<>NULL && !mapOfDpRecords.isEmpty()){
                    for (PDKProInfo info : pdkInfo){
                      boolean isError = false;
                        if (mapOfDpRecords.containskey(info.dpId)){
                            Document_Provisioning__c dp = new Document_Provisioning__c();
                            dp.Id = info.dpId;
                            dp.DateTime_Last_Synced_With_OpenText__c = DateTime.now();
                            dp.Sync_With_OpenText__c = info.isSyncWithOt;
                            if(info.otErrorMsg<>NULL && info.otErrorMsg!=''){
                              dp.OpenText_Error_Message__c = info.otErrorMsg;
                              isError = true;
                              // send error email to OT and SFDC DL
                              //Messaging.SingleEmailMessage mail = FV_DocumentProvisioningService.sendEmail(Email,Subject,finalBodyText);
                            }
                            if(info.failureSpecInfo!=null && info.failureSpecInfo!=''){ 
                               sendEmail(info.dpId);
                            }                                   
                            if(info.status=='DeProvisioned' && mapOfDpRecords.get(info.dpId).Status__c!='Provisioned'&& !isError){
                              info.status ='De-Provisioned';
                               if (mapOfDpRecords.get(info.dpId).PDK_Spec_Names__c<>NULL && !String.isBlank(mapOfDpRecords.get(info.dpId).PDK_Spec_Names__c)){
                                    dp.PDK_Spec_Names__c ='';
                                    mapOfDpRecords.get(info.dpId).PDK_Spec_Names__c=null;
                                }
                            } else {
                              if(!isError){
                                info.status='Provisioned';
                              }
                            }
                            if(info.status<>NULL && info.status!=''&&!isError){
                              dp.Status__c = info.status;
                            }
                            if (!String.isBlank(info.failureSpecInfo)){
                              if(!String.isBlank(dp.PDK_Failure_Specs__c)){
                                dp.PDK_Failure_Specs__c = dp.PDK_Failure_Specs__c+';'+info.failureSpecInfo;
                              } else {
                                dp.PDK_Failure_Specs__c = info.failureSpecInfo;
                              } 
                            } else {
                              dp.PDK_Failure_Specs__c='';
                            }
                            if (!String.isBlank(info.PARAM1)){
                              if (!String.isBlank(dp.PDK_Failure_DeProSpecs__c)){
                                if(!String.isBlank(dp.PDK_Failure_DeProSpecs__c)){
                                  dp.PDK_Failure_DeProSpecs__c = dp.PDK_Failure_DeProSpecs__c+';'+info.PARAM1;
                                } else {
                                  dp.PDK_Failure_DeProSpecs__c = info.PARAM1;
                                }
                              }
                            } else {
                              dp.PDK_Failure_DeProSpecs__c = '';
                            }
                            //dp.PdkSpecs__c = info.specAssOtIds;
                            system.debug('info.specNamesProv>>>>>>>>>>>>>>>>'+info.specNamesProv);
                            if (info.specNamesProv<>NULL && !String.isBlank(info.specNamesProv)){
                               /* if (mapOfDpRecords.get(info.dpId).PDK_Spec_Names__c<>NULL && !String.isBlank(mapOfDpRecords.get(info.dpId).PDK_Spec_Names__c)){
                                    dp.PDK_Spec_Names__c = mapOfDpRecords.get(info.dpId).PDK_Spec_Names__c+';'+'\n'+info.specNamesProv;
                                } else {*/
                                  system.debug('Inside else of spec name #######');
                                    //mapOfDpRecords.get(info.dpId).PDK_Spec_Names__c = info.specNamesProv;
                                    String specNames='';
                                    for(String sInfo : info.specNamesProv.split(DELIMETER)){
                                      if(specNames==''){
                                        system.debug('specNames>>>>>>>>>>>>>'+sInfo); 
                                        specNames=sInfo;
                                      } else {
                                        specNames = specNames+';'+'\n'+ sInfo;
                                      }
                                    }
                                    if (!String.isBlank(specNames)){
                                      //dp.PDK_Spec_Names__c=specNames;
                                      if(mapOfDpRecords.get(info.dpId).PDK_Spec_Names__c<>NULL && !String.isBlank(mapOfDpRecords.get(info.dpId).PDK_Spec_Names__c)){
                                            dp.PDK_Spec_Names__c = mapOfDpRecords.get(info.dpId).PDK_Spec_Names__c+';'+'\n'+specNames;  
                                      } else {
                                            dp.PDK_Spec_Names__c=specNames;
                                       }    
                                    }
                                //}
                            }
                            system.debug('dp.PDK_Spec_Names__c >>>>>>>>>>>>>>>'+dp.PDK_Spec_Names__c);
                            system.debug('info.specAssOtIds>>>>>>>>>>>'+info.specAssOtIds);
                            
                            if (info.specAssOtIds<>NULL && !String.isBlank(info.specAssOtIds)){
                               
                                if (mapOfDpRecords.get(info.dpId).PdkSpecs__c<>NULL && !String.isBlank(mapOfDpRecords.get(info.dpId).PdkSpecs__c)){
                                  system.debug('Inside PDK SPEC NOT NULL >>>>>>>>>>>'+mapOfDpRecords.get(info.dpId).PdkSpecs__c);
                                  system.debug('info.specAssOtIds>>>>>>>>>>>'+info.specAssOtIds);
                                  Pattern ptrn =  Pattern.compile('[^a-zA-Z0-9]');
                                  String oldSpec = ptrn.matcher(mapOfDpRecords.get(info.dpId).PdkSpecs__c).replaceAll('');
                                  String newSpec = ptrn.matcher(info.specAssOtIds).replaceAll('');
                                  
                                  system.debug('oldSpec>>>>>>>>>>>>>>'+oldSpec);
                                  system.debug('newSpec>>>>>>>>>>>>>>'+newSpec);
                                  
                                  if(!oldSpec.equals(newSpec)){
                                  
                                      dp.PdkSpecs__c = mapOfDpRecords.get(info.dpId).PdkSpecs__c +';'+ info.specAssOtIds;
                                  }
                                 
                                    dp.PDK_Provisoin_To_Updated_Specs__c = null;
                                    dp.isProvUpdate__c=false;
                                } else {
                                  system.debug('Inside else PDK SPECS >>>>>>>>>>>>');
                                    dp.PdkSpecs__c = info.specAssOtIds; 
                                    dp.PDK_Provisoin_To_Updated_Specs__c = null;
                                    dp.isProvUpdate__c=false;
                                }
                            }
/*-----------------------------added for Sending 'NONE' to OT when PDK specs Provsioned is blank start---------------------*/                            
                             else
                            {
                            
                            system.debug('Inside else PDK SPECS mycode>>>>>>>>>>>>');
                            dp.PdkSpecs__c ='';
                            }
/*-----------------------------added for Sending 'NONE' to OT when PDK specs Provsioned is blank end---------------------*/                              
                                system.debug('info.specNamesDeProv>>>>>>>>>>>>>>>>>'+info.specNamesDeProv);
                            if (info.specNamesDeProv<>NULL && !String.isBlank(info.specNamesDeProv)){
                              system.debug('Inside deprov of specs New >>>>>>>>>>>>>'+info.specNamesDeProv);
                              system.debug('Old Spec for depro >>>>>>>>'+mapOfDpRecords.get(info.dpId).PDK_Spec_Names__c);
                              
                              String tempStr='';
                                if(mapOfDpRecords.get(info.dpId).PDK_Spec_Names__c<>NULL 
                                    && !String.isBlank(mapOfDpRecords.get(info.dpId).PDK_Spec_Names__c)){
                                    for(String s : mapOfDpRecords.get(info.dpId).PDK_Spec_Names__c.split(DELIMETER)){
                                        if(String.isBlank(tempStr)){
                                            tempStr = s.replaceAll('\n','').trim();
                                        } else {
                                            tempStr = tempStr+';'+s.replaceAll('\n','').trim();
                                        }
                                    }
                                }
                                system.debug('tempStr>>>>>>'+tempStr);
                                String specNames = FV_DocumentProvisioningService.getUpdatedSpecNames(tempStr,info.specNamesDeProv);
                                                   
                              
                           
                                dp.PDK_Spec_Names__c = specNames;
                             
                            }
                            if (info.specAssDeProOtIds<>NULL && !String.isBlank(info.specAssDeProOtIds)){
                              system.debug('Inside deprovisioning of specs and associations >>>>>');
                              String specAssIds = FV_DocumentProvisioningService.getUpdatedSpecAssoIds(mapOfDpRecords.get(info.dpId).PdkSpecs__c,info.specAssDeProOtIds);
                             
                               if(info.status!='De-Provisioned'&& info.status!='DeProvisioned'){
                                   dp.PdkSpecs__c = specAssIds;
                                   dp.Pdk_Specs_DeProvisioned__c=null;
                                   dp.isDeProUpdate__c=false;
                                   dp.isDeletionNeeded__c=false;
                                   
                               } 
                                
                             
                            } 
                            system.debug('dp.PdkSpecs__c>>>>>>>>>>>>>>.'+dp.PdkSpecs__c);
                            system.debug('dp.PDK_Spec_Names__c >>>>>>>>>>>>>>>>>>'+dp.PDK_Spec_Names__c);
                            listOfDp.add(dp);
                        }
                       
                    }       
                }
                system.debug('listOfDp>>>>>>>>>'+listOfDp);
                if (listOfDp<>NULL && !listOfDp.isEmpty()){
                    update listOfDp;
                }                                                        
            }
            return new responseInfo(true,'');   
        } catch (Exception e){
            FV_ErrorLogHandler.setErrorLogs('PDK','FV_DocumentProvisioningService','PdkProResponseService', e.getMessage());
            return new responseInfo(false,e.getMessage());
        }
    }
    
    // Prepare string of Spec and PDk Association and remove deprovisionied spec:asso combibation from String
    private static String getUpdatedSpecAssoIds(String oldSpecNames,String newSpecNames){
      system.debug('getUpdatedSpecAssoIds>>>>>>>>>>>>');
      Map<String,String> newSpecMap = new Map<String,String>();
      String updatedSpecIds = '';
      for (String specId : newSpecNames.split(DELIMETER)){
        if (!newSpecMap.containsKey(specId)){
          newSpecMap.put(specId,specId);
        }
      }
      if (oldSpecNames<>NULL && !String.isBlank(oldSpecNames)){
        for(String oldSpecId : oldSpecNames.split(DELIMETER)){
          if (newSpecMap<>NULL && !newSpecMap.containsKey(oldSpecId)){
            if (updatedSpecIds==''){
              updatedSpecIds = oldSpecId;
            } else {
              updatedSpecIds = updatedSpecIds+';'+oldSpecId;
            }
          }
        }
        system.debug('updatedSpecIds>>>>>>>>>>>>>>>'+updatedSpecIds);
      }
      return updatedSpecIds;
    }
    // Prepare list of specs names after specs got deprovisioned
    private static String getUpdatedSpecNames(String oldSpecNames,String newSpecNames){
      Map<String,String> newSpecMap = new Map<String,String>();
      String updatedSpecNames = '';
      for(String newSpec : newSpecNames.split(DELIMETER)){
        if (!newSpecMap.containsKey(newSpec)){
          newSpecMap.put(newSpec,newSpec);
        }
      }
      if (oldSpecNames<>NULL && !String.isBlank(oldSpecNames)){
        for (String spec : oldSpecNames.split(DELIMETER)){
          //if (!newSpecMap.containsKey(spec.replaceAll('\n','').trim())){
          if (!newSpecMap.containsKey(spec)){
            system.debug('Key Not Matched !!!!');
            if (updatedSpecNames == ''){
              //updatedSpecNames =spec.replaceAll('\n','').trim();
              updatedSpecNames =spec; 
            } else {
              updatedSpecNames = updatedSpecNames+';'+'\n'+spec.replaceAll('\n','').trim();
            } 
          }
        }
        system.debug('updatedSpecNames>>>>>>>>>>>>>>>>>'+updatedSpecNames);
      }
      return updatedSpecNames;
    }
    // Prepare and returns sub pkd Ot ids
    private static Set<String> getSubPdkIds(List<PDKProInfo> pdkInfo){
        Set<string> subPdkIds = new Set<String>();
        for (PDKProInfo info : pdkInfo){
            if (info.subPdkId<>NULL && !String.isBlank(info.subPdkId)){
                for (String sPdkId : info.subPdkId.split(DELIMETER)){
                    if (!subPdkIds.contains(sPdkId)){
                        subPdkIds.add(sPdkId);
                    }       
                }
            }
        }
        return subPdkIds;   
    }
    
    // Prepare and return document provisioning SFDC id set
    private static Set<String> getDoProIds(List<PDKProInfo> pdkInfo){
        system.debug('Inside getDoProIds >>>>>>>>>>>>'+pdkInfo);
        Set<String> dpIds = new Set<String>();
        for (PDKProInfo info : pdkInfo){
            if (info.dpId<>NULL && !String.isBlank(info.dpId)){
                //for (String dpID : info.dpId.split(DELIMETER)){
                    if (!dpIds.contains(info.dpId)){
                        dpIds.add(info.dpId);
                    }
                //}
            }
        }
        return dpIds;
    }
    // Prepare and returns account sort names
    private static Set<String> getAccShrtNames(List<PDKProInfo> pdkInfo){
        system.debug('Inside getAccShrtNames >>>>>>>>'+pdkInfo);
        Set<String> accNames = new Set<String>();
        for (PDKProInfo info : pdkInfo){
            if (info.accShortName<>NULL && !String.isBlank(info.accShortName)){
                for (String accSrtName : info.accShortName.split(DELIMETER)){
                    if (!accNames.contains(accSrtName)){
                        accNames.add(accSrtName);
                    }
                }
            }
        }
        return accNames;
    }
    
    // Send Email in case any failure
   public static Messaging.SingleEmailMessage sendEmail(String docProvisioningId){
        List<String> toAddresses = new List<String>();
        Set<Id> setOfUserId = new Set<Id>();
        List<EmailTemplate> templateId = [Select id from EmailTemplate where name = 'Document Provisioning Failure Spec Template'];
        List<Group> lstGroup = [Select id from Group where Name='PDK IT Team'];
        if(lstGroup.size()>0){
            List<GroupMember> lstGrpMember = [Select UserOrGroupId from GroupMember where groupid=:lstGroup[0].id];
            if(lstGrpMember.size()>0){
                for(GroupMember gm : lstGrpMember){
                    setOfUserId.add(gm.UserOrGroupId);
                }
            }
            if(setOfUserId.size()>0){
                List<User> lstUser = [Select email from User where id IN:setOfUserId];
                for(User u :lstUser){
                    toAddresses.add(u.email);
                }
            }
        }
        //if(label.PDK_IT_Admin!=null || label.PDK_IT_Admin!='')
          //  toAddresses = label.PDK_IT_Admin.split(';');
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(toAddresses);
        //mail.setSubject(subject);
        //mail.setWhatId(docProvisioningId);
        if(templateId!=null && templateId.size()>0)
            mail.setTemplateId(templateId[0].id);
        mail.setTargetObjectId(label.PDK_IT_Admin_Contact_Id); 
        mail.setWhatId(docProvisioningId);
        //mail.setWhatId(docProvisioningId);
        // Send the email you have created.
        if(!Test.isrunningtest())
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        
        return mail;
    }
    
    /*
    * @ Description :- Class holds pdk provisioning related information
    * @ Date :- 
    * @ Change History :- 
    */
    global class PDKProInfo {
        webservice Boolean isSyncWithOt = false;
        webservice String otErrorMsg;
        Webservice String failureSpecInfo;
        webservice String specNamesProv;
        webservice String specAssOtIds;
        Webservice String subPdkId;
        Webservice String accShortname;
        webservice String status;
        Webservice String dpId; 
        // Below string will be used in case of deProvisioning
        webservice String specNamesDeProv; // Need to remove these specs from DP records spec name field
        webservice String specAssDeProOtIds;// Need to remove these records from DP records PDK Specs field
        webservice String PARAM1;
        webservice String PARAM2;
        webservice String PARAM3;
        webservice String PARAM4;
        webservice String PARAM5;     
    }
    
    /*
    * @ Description :- Class holds pkd provisioning/de-provisioning related response info like success, error logs
    * @ Date :- 
    * @ Change History :- 
    */
    global class responseInfo {
        webservice Boolean isSuccess = false;
        webservice String errorMsg = '';
        
        public responseInfo(Boolean isSuccess, String errorMsg){
            this.isSuccess = isSuccess;
            this.errorMsg = errorMsg;
        }
    }
}