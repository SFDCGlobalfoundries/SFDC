/*
* @ Author :- Navneet Rajput
* @ Company :- CTS
* @ Description :- Below trigger handler Handle onAfter and onBefore operations of document provisioning trigger
                 It will help to provision PDK,Package and indivisual spec
* @ Date :- 11/11/2014
* @ Change History :- 
    Changes done by Kunal
    Cases Nos-:50587,50673
    Enhancement for DP delete
    Date-: 17/12/2015
* @ Author - Prajnith Karra
    Date-: 15/5/2015
    line 45 - throw error meeage on DP, if Blacklisted        
*/

public with sharing class FV_DocumentProvisioningTriggerHandler {

    public FV_DocumentProvisioningTriggerHandler(){
        
    }
    // Handles before insert operations of PDK bundle provisioning functionality
    public void onBeforeInsert(List<Document_Provisioning__c> newRecords){
        setFinalUserAccessOfPDK(newRecords,null,null,null);
    }
    // Handles before update operations of PDK bundle provisioning functionality
    public void onBeforeUpdate(List<Document_Provisioning__c> newRecords,List<Document_Provisioning__c> oldRecords,
                               Map<Id,Document_Provisioning__c> newMapRecords, Map<Id,Document_Provisioning__c> oldMapRecords){
                                
        getApprovalProcessComments(newRecords,oldRecords,newMapRecords,oldMapRecords);
        setFinalUserAccessOfPDK(newRecords,oldRecords,newMapRecords,oldMapRecords); 
    }
    //Handles before delete operations of PDK bundle provisioning functionality
    public void onBeforeDelete(List<Document_Provisioning__c> oldRecords){
     insertDocumentProvisioningLog(oldRecords);    
    }
    // Hadles after insert operations of pdk bundle provisioning functionality
    public void onAfterInsert(List<Document_Provisioning__c> newRecords,Map<Id,Document_Provisioning__c> newMap){
        sendApprovalRequest(newRecords,null);
    }
    //Handles after update operations of PDK bundle provisioning functionality
    public void onAfterUpdate(List<Document_Provisioning__c> newRecords,List<Document_Provisioning__c> oldRecords,
                               Map<Id,Document_Provisioning__c> newMap, Map<Id,Document_Provisioning__c> oldMapRecords){
                                
        sendApprovalRequest(newRecords,oldMapRecords);
        FV_ASICNewsAlertShare.onAfterUpdate(newMap,oldMapRecords);
        //throw error meeage on DP, if Blacklisted        
        if(!system.isFuture() || !system.isBatch()){
            PDKBlackListTriggerHandler.onDPUpdate(newMap,oldMapRecords);
        }
    }
    
    /*
    * @ Description :- Method used to send approval request to PDK bundle owner and group
    *                  of users who are set as approver for bundle in SFDC  
    * @ Params :- List<Document_Provisioinng> object
    * @ Date   :-   
    **/
    
    private void sendApprovalRequest(List<Document_Provisioning__c> newRecords,Map<Id,Document_Provisioning__c> oldMapRecords){
        
        List<Document_Provisioning__c>  dpSendForApprovalRecords = new List<Document_Provisioning__c>();
        
        if (oldMapRecords<>NULL && !oldMapRecords.isEmpty()){
            for (Document_Provisioning__c DP : newRecords){
                if (dp<>NULL && DP.Status__c<>NULL && DP.Status__c.equalsIgnoreCase('Sent For Approval')){
                    if (oldMapRecords<> Null && oldMapRecords.get(DP.ID).Status__c!='Sent For Approval' 
                                        && oldMapRecords.get(DP.ID).Status__c!='Provisioned' && oldMapRecords.get(DP.ID).Status__c!='Provisioning In Progress'){
                                        
                        dpSendForApprovalRecords.add(DP);
                    }
                }
            }
                        
        } else {
                for (Document_Provisioning__c DP : newRecords){
                    if (dp<>NULL && DP.Status__c<>NULL && DP.Status__c.equalsIgnoreCase('Sent For Approval')){
                        dpSendForApprovalRecords.add(DP);
                    }
                }   
        }
        // Send DP list for approval
        if (dpSendForApprovalRecords<>Null && !dpSendForApprovalRecords.isEmpty()){
            submitApprovalProcess(dpSendForApprovalRecords);
        }
    }
    
    /**
        This method triggers the Approval Process for all the provisioning records having Status as Sent for Approval.

        @method name: submitApprovalProcess
        @parameter:   List of provisioning records having status as Sent for Approval.
        @return :     None.
     **/
     
    private void submitApprovalProcess(List<Document_Provisioning__c> lstDPSentForApproval){
       List<Approval.ProcessSubmitRequest> requests = new List<Approval.ProcessSubmitRequest> (); 

        if(lstDPSentForApproval!=null && lstDPSentForApproval.size()>0){
            for(Document_Provisioning__c objDP: lstDPSentForApproval){
                
                /** Create the new approval request to submit **/
                Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
                req.setComments('Submitted for approval. Please approve.');
                req.setObjectId(objDP.Id);
                requests.add(req); 
            }
            /** Submit the approval request for processing **/ 
            Approval.ProcessResult[] processResults = null;
            try{
                processResults = Approval.process(requests,false);
            }
            catch (System.DmlException e) {
            } 
        }   
    }
    
    /**
        This method populates the Approval Comment from Approval Process into the Approval Process Comments field.

        @method name: getApprovalProcessComments
        @parameter:   Document Provisioning Id.
        @return :     Approval Comment from Approval Process.
     **/
     
     private static void getApprovalProcessComments(List<Document_Provisioning__c> newRecords,List<Document_Provisioning__c> oldRecords,
                                                             Map<Id,Document_Provisioning__c> newMapRecords, Map<Id,Document_Provisioning__c> oldMapRecords){
        String approvalComments = '';
        Map<Id,String> mapOfDpIdAndApprovalComment = new Map<Id,String>();
        Set<Id> dProvisionIds = new Set<Id>();
        Map<Id,String> MapOfDpIdAndApprovalProcessComment = new Map<Id,String>();  
                  
        for(Document_Provisioning__c objDP: newRecords){
            
            if(objDP<>NULL && objDP.Status__c<>NULL && (objDP.Status__c=='Provisioning In Progress' || objDP.Status__c=='Provisioned' || objDP.Status__c=='Rejected')){                                      
                if(oldMapRecords.get(objDP.ID).Status__c=='Sent For Approval'){
                    dProvisionIds.add(objDP.Id);
                }
            }
            
        } 
        for(ProcessInstanceStep objPIS : [Select Comments, ProcessInstance.TargetObjectId, StepStatus From ProcessInstanceStep 
                                            where ProcessInstance.TargetObjectId IN : dProvisionIds order by CreatedDate asc]){
                                                
            if(objPIS.Comments!=null && objPIS.Comments!='Submitted for approval. Please approve.'){
                approvalComments =  'Comments given are: \r\n' + objPIS.Comments;
                mapOfDpIdAndApprovalComment.put(objPIS.ProcessInstance.TargetObjectId,approvalComments);
            }
        }   
        if (mapOfDpIdAndApprovalComment<>Null && !mapOfDpIdAndApprovalComment.isEmpty()){
            for(Id dpID: Trigger.newMap.keySet()){
                if(mapOfDpIdAndApprovalComment.containsKey(dpID)){
                    newMapRecords.get(dpID).Approval_Process_Comments__c = mapOfDpIdAndApprovalComment.get(dpID);
                }
            }
        }
     } // END OF getApprovalProcessComments
     
     /*
     * @ Description :- Method help to validate and set valid tech Geo,Valid NDA and Final user access flag to true/false
     * @ Param :- list<document_Provisioning> new, list<document_Provisioning> old,Map<document_Provisioning> new,Map<document_Provisioning>old,        
     * @ Date :- 11/12/2014
     **/
     
     private void setFinalUserAccessOfPDK(List<Document_Provisioning__c> newRecords,List<Document_Provisioning__c> oldRecords,
                                            Map<Id,Document_Provisioning__c> newMapRecords, Map<Id,Document_Provisioning__c> oldMapRecords){
        
        set<id> accids=new set<id>();
        set<id> pdkIds=new set<id>();
        map<id,account> mapOfAcc=new map<id,account>();
        map<id,sub_pdk__c> mapOfPDK=new map<id,sub_pdk__c>();
        //Code for Specification account level Provisioning
        set<id> designSpecIds=new set<id>();
        map<id,Design_Spec__c> mapOfDesignSpec=new map<id,Design_Spec__c>();
        // code for Before Update
        if (oldRecords<>NULL){
            for (Document_Provisioning__c DP : newRecords){
                if (dp<>NULL && DP.Status__c<>NULL && DP.Status__c.equalsIgnoreCase('Provisioning In Progress') && !oldMapRecords.get(DP.id).status__c.equalsIgnoreCase('Provisioning In Progress')){
                    if (dp.AccountID__c<>NULL){
                        accids.add(dp.AccountID__c);
                    }
                    if (DP.Sub_PDK__c<>NULL){
                        pdkIds.add(DP.Sub_PDK__c);
                    }
                    if (DP.Design_Spec__c<>NULL){
                        designSpecIds.add(DP.Design_Spec__c);
                    }            
                }               
            }// END OF FOR
            
        } else {
            for (Document_Provisioning__c DP : newRecords){
                if (DP<>NULL && DP.Status__c<>NULL && DP.Status__c.equalsIgnoreCase('Provisioning In Progress')){
                    if (dp.AccountID__c<>NULL){
                        accids.add(dp.AccountID__c);
                    }
                    if (DP.Sub_PDK__c<>NULL){
                        pdkIds.add(DP.Sub_PDK__c);
                    } 
                    if (DP.Design_Spec__c<>NULL){
                        designSpecIds.add(DP.Design_Spec__c);
                    }           
                }               
            }// END OF FOR
        }   
        // Prepare Map of Account
        if(accids!=null && !accids.isEmpty()){           
            for(account acc:[select id,Tech_Geo_Granted__c,Valid_Tech_Geos__c,Has_Valid_NDA__c,ASIC_Business_Flag__c from account where id IN : accids]){
                mapOfAcc.put(acc.id,acc);        
            }
        }
        // Prepare Map of Sub PDK
        if(!pdkIds.isEmpty()){
            for(sub_pdk__c pdk:[select id,tech_geometry__c from sub_pdk__c where id in :pdkIds]){
                mapOfPDK.put(pdk.id,pdk);            
            }
        }
        
        // Prepare Map of Design Spec
        if(!designSpecIds.isEmpty()){
            for(Design_Spec__c designSpec:[select id,Technology_Geometry__c from Design_Spec__c where id in :designSpecIds]){
                mapOfDesignSpec.put(designSpec.id,designSpec);            
            }
        } 
        // Verify Valid Tech Geo and Valid NDA and provide final user access
        for(Document_Provisioning__c dp : newRecords){
            // Check for NDA coverage
            if(mapOfPDK!=null && mapOfPDK.containskey(dp.sub_pdk__c) && mapOfPDK.get(dp.sub_pdk__c).tech_geometry__c!=null ){
                for(string s:mapOfPDK.get(dp.sub_pdk__c).tech_geometry__c.split(';')){
                    if(mapOfAcc!=null && mapOfAcc.containskey(dp.AccountID__c) && mapOfAcc.get(dp.AccountID__c).Valid_Tech_Geos__c!=null 
                        && (mapOfAcc.get(dp.AccountID__c).Valid_Tech_Geos__c.contains(s) || mapOfAcc.get(dp.AccountID__c).Valid_Tech_Geos__c.contains(s.substring(0,6)))){
                        dp.NDA_Coverage__c=true;
                    }                           
                }
            }
            else if(mapOfPDK!=null && mapOfPDK.containskey(dp.sub_pdk__c) && mapOfPDK.get(dp.sub_pdk__c).tech_geometry__c==null){
                if(mapOfAcc!=null && mapOfAcc.containskey(dp.AccountID__c)  && mapOfAcc.get(dp.AccountID__c).Has_Valid_NDA__c==true){
                    dp.NDA_Coverage__c=true;
                }  
           }
           // Check for NDA coverage for Design Spec
                if(mapOfDesignSpec!=null && mapOfDesignSpec.containskey(dp.Design_Spec__c) && mapOfDesignSpec.get(dp.Design_Spec__c).Technology_Geometry__c!=null && 
mapOfDesignSpec.get(dp.Design_Spec__c).technology_geometry__c!='Not Applicable'){
                    for(string s:mapOfDesignSpec.get(dp.Design_Spec__c).Technology_Geometry__c.split(';')){
                        if(mapOfAcc!=null && mapOfAcc.containskey(dp.AccountID__c) && mapOfAcc.get(dp.AccountID__c).Valid_Tech_Geos__c!=null 
                            && (mapOfAcc.get(dp.AccountID__c).Valid_Tech_Geos__c.contains(s) || mapOfAcc.get(dp.AccountID__c).Valid_Tech_Geos__c.contains(s.substring(0,6)))){
                            dp.NDA_Coverage__c=true;
                        }                           
                    }
                }
                else if(mapOfDesignSpec!=null && mapOfDesignSpec.containskey(dp.Design_Spec__c) && (mapOfDesignSpec.get(dp.Design_Spec__c).Technology_Geometry__c==null || 
mapOfDesignSpec.get(dp.Design_Spec__c).technology_geometry__c=='Not Applicable')){
                    if(mapOfAcc!=null && mapOfAcc.containskey(dp.AccountID__c)  && mapOfAcc.get(dp.AccountID__c).Has_Valid_NDA__c==true){
                        dp.NDA_Coverage__c=true;
                    }  
               }
               
           //Check for Valid Tech Geo
           if(mapOfPDK!=null && mapOfPDK.containskey(dp.sub_pdk__c) && mapOfPDK.get(dp.sub_pdk__c).tech_geometry__c!=null ){
                for(string s:mapOfPDK.get(dp.sub_pdk__c).tech_geometry__c.split(';')){
                    if(mapOfAcc!=null && mapOfAcc.containskey(dp.AccountID__c) && mapOfAcc.get(dp.AccountID__c).Tech_Geo_Granted__c!=null 
                        && (mapOfAcc.get(dp.AccountID__c).Tech_Geo_Granted__c.contains(s) || mapOfAcc.get(dp.AccountID__c).Tech_Geo_Granted__c.contains(s.substring(0,6)))){
                        dp.Tech_Geo_Granted_to_Account__c=true;    
                    }                           
                }
            }
            
            else if(mapOfPDK!=null && mapOfPDK.containskey(dp.sub_pdk__c) && mapOfPDK.get(dp.sub_pdk__c).tech_geometry__c==null){
                if(mapOfAcc!=null && mapOfAcc.containskey(dp.AccountID__c) && mapOfAcc.get(dp.AccountID__c).Has_Valid_NDA__c==true){
                    dp.Tech_Geo_Granted_to_Account__c=true;    
                }  
           } 
           //Check for Valid Tech Geo Design Spec
               if(mapOfDesignSpec!=null && mapOfDesignSpec.containskey(dp.Design_Spec__c) && mapOfDesignSpec.get(dp.Design_Spec__c).Technology_Geometry__c!=null && 
mapOfDesignSpec.get(dp.Design_Spec__c).technology_geometry__c!='Not Applicable'){
                    for(string s:mapOfDesignSpec.get(dp.Design_Spec__c).Technology_Geometry__c.split(';')){
                        if(mapOfAcc!=null && mapOfAcc.containskey(dp.AccountID__c) && mapOfAcc.get(dp.AccountID__c).Tech_Geo_Granted__c!=null 
                            && (mapOfAcc.get(dp.AccountID__c).Tech_Geo_Granted__c.contains(s) || mapOfAcc.get(dp.AccountID__c).Tech_Geo_Granted__c.contains(s.substring(0,6)))){   
                            dp.Tech_Geo_Granted_to_Account__c=true;    
                        }                           
                    }
                }
                
                else if(mapOfDesignSpec!=null && mapOfDesignSpec.containskey(dp.Design_Spec__c) && (mapOfDesignSpec.get(dp.Design_Spec__c).Technology_Geometry__c==null || 
mapOfDesignSpec.get(dp.Design_Spec__c).technology_geometry__c=='Not Applicable')){
                    if(mapOfAcc!=null && mapOfAcc.containskey(dp.AccountID__c) && mapOfAcc.get(dp.AccountID__c).Has_Valid_NDA__c==true){
                        dp.Tech_Geo_Granted_to_Account__c=true;    
                    }  
               } 
          //Give final user access
          if(dp<>NULL && dp.Status__c<>NULL && dp.status__c.equalsIgnoreCase('Provisioning In Progress') && dp.NDA_Coverage__c && dp.Tech_Geo_Granted_to_Account__c){
               dp.final_user_access__c=true;
          }
          //Remove final user access
          if(dp<>NULL && DP.Status__c<>NULL && oldMapRecords <> NULL && ((oldMapRecords.get(dp.Id).status__c.equalsIgnoreCase('Provisioned') || oldMapRecords.get(dp.Id).status__c.equalsIgnoreCase('IPLAProvision') || oldMapRecords.get(dp.Id).status__c.equalsIgnoreCase('IPLADeprovision')) && dp.status__c.equalsIgnoreCase('De-Provisioning In Progress')) 
                 && dp.NDA_Coverage__c && dp.Tech_Geo_Granted_to_Account__c){ 
                
               dp.final_user_access__c = false;
          }       
          // ASIC Logic
          // if PDK Spec or Normal Spec
          if(dp != null && !string.isEmpty(dp.status__c))
          {
            if(dp.DP_Is_Parent_ASIC__c && dp.status__c.equalsIgnoreCase('Provisioning In Progress') || dp.status__c.equalsIgnoreCase('Provisioned'))
            {
                if(dp.NDA_Coverage__c && dp.Tech_Geo_Granted_to_Account__c)
                      dp.final_user_access__c=true;
                else
                      dp.final_user_access__c=false;
            }            
            /*if(oldMapRecords <> NULL && dp.NDA_Coverage__c && dp.Tech_Geo_Granted_to_Account__c && ((oldMapRecords.get(dp.Id).status__c.equalsIgnoreCase('Provisioned') || oldMapRecords.get(dp.Id).status__c.equalsIgnoreCase('IPLAProvision') || oldMapRecords.get(dp.Id).status__c.equalsIgnoreCase('IPLADeprovision')) && (dp.status__c.equalsIgnoreCase('De-Provisioning In Progress') || dp.status__c.equalsIgnoreCase('De-Provisioned') )))            
            {
                dp.final_user_access__c=false;
            } 
            */          
            
          }                 
       }// End of FOR loop   
    } // END of setFinalUserAccessOfPDK
    
    /*
     * @ Description :- Method help to create document provisioning log record and send it to OT.
     * @ Param :- list<document_Provisioning> new
     * @ Date :- 17/12/2015
     **/
    private void insertDocumentProvisioningLog(List<Document_Provisioning__c> oldRecords){
        list<Document_Provisioning_Log__c> lstLogs = new list<Document_Provisioning_Log__c>();
        Map<String,String> mapOfPdkIdAndReleaseStatus = new Map<String,String>();
        Map<String,String> mapOfSpecIdAndReleaseStatus = new Map<String,String>();
        Map <Id,Set<String>> accPdkOtIdMap = new Map<Id,Set<String>>();
        Map<String,String> mapOfSpecIdAndSpecType = new Map<String,String>();
        if(oldRecords!=null && oldRecords.Size()>0){
            List<Document_Provisioning__c> lstDP = [select Sub_Pdk__c,Sub_Pdk__r.Release_Status__c,Design_Spec__c,Design_Spec__r.Specification_Type__c,Design_Spec__r.Release_Status__c 
                                                    from Document_Provisioning__c where id IN:oldRecords];
            if(lstDP.size()>0){
                for(Document_Provisioning__c docPro: lstDP){
                    mapOfPdkIdAndReleaseStatus.put(docPro.Sub_Pdk__c,docPro.Sub_Pdk__r.Release_Status__c);
                    mapOfSpecIdAndSpecType.put(docPro.Design_Spec__c,docPro.Design_Spec__r.Specification_Type__c); 
                    mapOfSpecIdAndReleaseStatus.put(docPro.Design_Spec__c,docPro.Design_Spec__r.Release_Status__c); 
                }
            }
         
        if(mapOfPdkIdAndReleaseStatus!=null && mapOfPdkIdAndReleaseStatus.size()>0){
            List<Document_Provisioning__c> listOfDpRecords =[SELECT Sub_PDK__r.Sub_PDK_OpenText_Id__c,AccountID__c,isDeletionNeeded__c
                                                            FROM Document_Provisioning__c
                                                            WHERE (Status__c = 'Provisioned' OR Status__c ='Provisioning In Progress')
                                                            AND Sub_PDK__c != NULL
                                                            AND Sub_PDK__c NOT IN :mapOfPdkIdAndReleaseStatus.keyset()];
        
            if(listOfDpRecords<>NULL && !listOfDpRecords.isEmpty()){
                for(Document_Provisioning__c DP : listOfDpRecords){
                    if (!accPdkOtIdMap.containsKey(DP.AccountID__c)){
                      accPdkOtIdMap.put(DP.AccountID__c, new Set<String>());
                    }
                    if(DP.Sub_PDK__r.Sub_PDK_OpenText_Id__c<>NULL){
                        accPdkOtIdMap.get(DP.AccountID__c).add(String.valueOf(DP.Sub_PDK__r.Sub_PDK_OpenText_Id__c));
                    }   
                }
            }
        }                                           
            for (Document_Provisioning__c DP : oldRecords){
                if(DP.status__c!='De-Provisioned'&& DP.Sub_PDK__c!=null){
                    Document_Provisioning_Log__c docProLog = new Document_Provisioning_Log__c();
                    String bundleOtIds = '';
                    docProLog .Account_Short_Name__c = DP.Acc_Short_Name__c;
                    docProLog .status__c = 'De-Provisioning In Progress';
                    docProLog .isDeletionNeeded__c = true;
                    docProLog .isDeProUpdate__c = false;
                    docProLog.Sub_PDK_SF_Id__c = DP.Sub_PDK__c ; 
                    docProLog.Spec_SF_Id__c = DP.Design_Spec__c;
                    docProLog.Spec_OpenText_Id__c = DP.Design_Spec_OpenText_Id__c;
                    docProLog.Sub_PDK_OpenText_Id__c = DP.Sub_PDK_OpenText_Id__c;
                    docProLog.Document_Provisioning_SF_Id__c = DP.id;
                    docProLog.PdkSpecs__c = DP.PdkSpecs__c;
                    if (accPdkOtIdMap<>NULL && accPdkOtIdMap.containsKey(DP.AccountID__c)){
                            for(String str : accPdkOtIdMap.get(DP.AccountID__c)){
                                if(str<>NULL && str!=''){
                                    if (bundleOtIds==''){
                                        bundleOtIds = str;
                                    } else {
                                        bundleOtIds = bundleOtIds+';'+str;
                                    }
                                }   
                            }
                        }
                        if(!String.isBlank(bundleOtIds)){
                            docProLog.Bundle_OT_ID__c = bundleOtIds;   
                        }
                    docProLog.entity__c='DP_Pdk';
                    docProLog.PDK_Release_Status__c = mapOfPdkIdAndReleaseStatus.get( DP.Sub_PDK__c);
                    lstLogs.add(docProLog);
                }                   
            else if(DP.status__c!='De-Provisioned'&& DP.Design_Spec__c!=null){
                Document_Provisioning_Log__c docProLog = new Document_Provisioning_Log__c();
                if(mapOfSpecIdAndSpecType!=null && mapOfSpecIdAndSpecType.size()>0){
                    if(mapOfSpecIdAndSpecType.get(DP.Design_Spec__c)=='IP Design Kit'){    
                        docProLog.entity__c='DP_Ipdk';
                        docProLog.IPLA__c = DP.IPLA__c;
                    }
                    else
                        docProLog.entity__c='DP_Spec';
                }       
                docProLog .Account_Short_Name__c = DP.Acc_Short_Name__c;
                docProLog .status__c = 'De-Provisioning In Progress';
                docProLog.Spec_SF_Id__c = DP.Design_Spec__c;
                docProLog.Spec_OpenText_Id__c = DP.Design_Spec_OpenText_Id__c;
                docProLog.PDK_Release_Status__c = mapOfSpecIdAndReleaseStatus.get(DP.Design_Spec__c); 
                lstLogs.add(docProLog);        
            }
         }
         }    
        if(lstLogs.size()>0){
            try{
                insert lstLogs;
            }
            Catch(System.DmlException e){
                FV_ErrorLogHandler.setErrorLogs('PDK','FV_DocumentProvisioningTriggerHandler','insertDocumentProvisioningLog', e.getMessage());
            }
        }         
    }
} // FV_DocumentProvisioningTriggerHandler