/**
* @ Author :- Kunal Patil
* @ Company :- CTS 
* @ Description :- Class handles PDK Spec Associations updates coming from OT
                   Class is used to acknowledge SFDC that all PDK Spec asscoations got created in OT or not
                   This is a response service for PDK spec associations creations.
* @ Date :- 17/6/2015
* @ Change History :- 
**/
global class FV_PDKSpecAssociationService {
    
    private static final String DELIMETER = ';';
    /*
    * @ Description :- Class holds PDK Spec Associations related information
    * @ Date :- 17/6/2015
    * @ Change History :- 
    */
    global class PDKSpecAssociationInfo {
        Webservice String subPdkId;
        Webservice String subPdkOtId;     
        webservice Boolean isReadyForProvision = false;
        Webservice String failureSpecInfo;
        webservice String specAssSalesforceIds;
    }
    
    /*
    * @ Description :- Class holds PDK Spec Associations related response info like success, error logs
    * @ Date :- 17/6/2015
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
    /*@ Method Name :- PdkSpecResponseService
    * @ Description :- Method used to handle response of Spec association creation and update bundle accordingly...
    * @ Date :- 1/7/2015
    * @ Change History :- 
    */
    webservice static responseInfo PdkSpecResponseService(PDKSpecAssociationInfo pdkSpecInfo){
        Sub_PDK__c subPDK;
        try {
            if (pdkSpecInfo<>NULL){
                if(pdkSpecInfo.subPdkId<>NULL){
                    subPDK = retrieveSubPDKInfo(pdkSpecInfo.subPdkId);
                    subPDK.Ready_For_Provisioning__c = pdkSpecInfo.isReadyForProvision;
                    subPDK.isRetrigger__c = false;
                    subPDK.Time_Req_To_Create_Association_In_OT__c = '0';
                    subPDK.PDK_Failure_Specs__c = pdkSpecInfo.failureSpecInfo;
                    if(pdkSpecInfo.failureSpecInfo!=null && pdkSpecInfo.failureSpecInfo!=''){ 
                        sendEmail(pdkSpecInfo.subPdkId);
                    }                                   
                    update subPDK;
                }
                    if(pdkSpecInfo.specAssSalesforceIds!=null && pdkSpecInfo.specAssSalesforceIds!=''){
                        List<String> listOfSubPdkSpecIds = pdkSpecInfo.specAssSalesforceIds.split(DELIMETER);
                        updatePdkProvisioning(pdkSpecInfo.subPdkId,listOfSubPdkSpecIds);
                    }   
                    if(subPDK!=null && subPDK.Release_Status__c != null && subPDK.Release_Status__c=='General Release'){
                         deleteAllDPrecordsRelatedtoPDK(subPDK.id);
                    }
                }   
            return new responseInfo(true,'');
        }catch (Exception e){
            FV_ErrorLogHandler.setErrorLogs('PDK','FV_PDKSpecAssociationService','PdkSpecResponseService', e.getMessage());
            return new responseInfo(false,e.getMessage());
        }
    }
    /*
    * @ Author :- Kunal Patil
    * @ Company :- CTS
    * @ Date  :- 30/06/2015
    * @ Description :- Method help to provision pdk at account level ,when bundle is updated and added new records for provisioning.
                      if bundle is already provisioned and user has updated bundle and selected new spec and save the record then 
                      Existing as well as newly added specs will be send to OT for provisioning.     
    * @ Change History :- 
    **/
    
    public static void updatePdkProvisioning(String subPdkId ,List<String> listOfSubPdkSpecIds){
        Map<Id,Sub_PDK_Spec__c> whiteListSpecs = new Map<Id,Sub_PDK_Spec__c>();
        Map<Id,Sub_PDK_Spec__c> nonWhiteListSpecs = new Map<Id,Sub_PDK_Spec__c>();
        Map<Id,Set<Id>> wlSpecAccMap = new Map<Id,Set<Id>>();
        List<Document_Provisioning__c> lstOfDP = new List<Document_Provisioning__c>();
        for (Sub_PDK_Spec__c pdkSpec : [SELECT Id,name,Sub_PDK__c,Design_Spec__c,OTID__c,Design_Spec__r.Release_Status__c,
                                                Design_Spec__r.OpenText_ID__c,Design_Spec__r.Specification_Type__c,Design_Spec__r.Document_Title__c
                                        FROM    Sub_PDK_Spec__c
                                        WHERE   Sub_PDK__c = : subPdkId
                                        AND     Id IN : listOfSubPdkSpecIds
                                        AND     Design_Spec__r.Release_Status__c!='General Release'
                                        AND     Design_Spec__r.Release_Status__c!='Internal Use Only'
                                        AND     Design_Spec__r.Specification_Type__c!='Stepper Tooling Forms'
                                        AND     Design_Spec__r.Specification_Type__c!='Reticle Grade Table']){
                                            
            if(pdkSpec<>NULL){
                if (pdkSpec.Design_Spec__r.Release_Status__c!='Internal Use Only' && pdkSpec.Design_Spec__r.Release_Status__c!='Stepper Tooling Forms'
                    && pdkSpec.Design_Spec__r.Release_Status__c!='Reticle Grade Table' && pdkSpec.Design_Spec__r.Release_Status__c!='Stepper Tooling Forms'){
                    
                    if (pdkSpec.Design_Spec__r.Release_Status__c.toLowerCase().contains('white list')){
                        if(pdkSpec.Design_Spec__r.OpenText_ID__c!=Null){
                            if(!whiteListSpecs.containsKey(pdkSpec.Design_Spec__c)){
                                whiteListSpecs.put(pdkSpec.Design_Spec__c,pdkSpec);
                            }
                        }
                        
                    } else {
                        if(pdkSpec.Design_Spec__r.OpenText_ID__c!=Null){
                            if(!nonWhiteListSpecs.containsKey(pdkSpec.Design_Spec__c)){
                                nonWhiteListSpecs.put(pdkSpec.Design_Spec__c,pdkSpec);
                            }
                        }
                    }   
                }
            } 
        } // END OF for loop
        //prepare Map of spec as key and list of white list accounts associated with that spec  
        if(whiteListSpecs<>NULL && !whiteListSpecs.isEmpty()){
            for(White_List__c wl : [Select Id,Design_Spec__c,Account__c 
                                    From White_List__c 
                                    where Design_Spec__c IN : whiteListSpecs.keySet()]){
                                        
                if(wl<>Null){                       
                    if (!wlSpecAccMap.containsKey(wl.Design_Spec__c)){
                        wlSpecAccMap.put(wl.Design_Spec__c, new Set<Id>());
                    } 
                        wlSpecAccMap.get(wl.Design_Spec__c).add(wl.Account__c);
                    
                }
            } 
        }
        // Get accounts from subpdk 
        for(Document_Provisioning__c dp : [SELECT Id,Status__c,AccountID__c,AccountID__r.Short_Name__c,PdkSpecs__c,Pdk_Specs_DeProvisioned__c,
                                                    Sync_With_OpenText__c,PDK_Provisoin_To_Updated_Specs__c,isProvUpdate__c,isDeProUpdate__c 
                                            FROM    Document_Provisioning__c WHERE Sub_PDK__c =: subPdkId
                                            AND     Status__c = 'Provisioned']){//Status__c != 'De-Provisioned' AND Status__c != 'De-Provisioning In Progress'
            
            String specs = '';
            String subPdkSpecs = '';
            String pdkAssociations = '';
            String specName = '';
            if (dp<>NULL){
                if(whiteListSpecs<>Null && !whiteListSpecs.isEmpty()){
                    for (Id specId : whiteListSpecs.keySet()){
                        if(wlSpecAccMap<>Null && wlSpecAccMap.containskey(specId) && 
                            wlSpecAccMap.get(specId).contains(dp.AccountID__c)){
                            // Add spec id to dp design spec
                            if(whiteListSpecs.containsKey(specId)){
                                if(specs==''){
                                    if(!String.isBlank(String.valueOf(whiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c))){
                                        if(whiteListSpecs.get(specId).OTID__c<>NULL)
                                            specs = String.valueOf(whiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c)+':'+whiteListSpecs.get(specId).OTID__c;
                                        else
                                            specs = String.valueOf(whiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c)+':'+'NONE';
                                    }
                                } else {
                                    if(!String.isBlank(String.valueOf(whiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c))){
                                        if(whiteListSpecs.get(specId).OTID__c<>NULL)
                                            specs = specs +';'+String.valueOf(whiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c)+':'+whiteListSpecs.get(specId).OTID__c;
                                        else
                                            specs = specs +';'+String.valueOf(whiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c)+':'+'NONE';
                                    }   
                                }
                            } //END OF WHITELIST SPEC IF BLOCK
                        }
                    } // End of whitelist for loop
                }// end of whitelist if
                if(nonWhiteListSpecs<>Null && !nonWhiteListSpecs.isEmpty()){
                    for (Id specId : nonWhiteListSpecs.keySet()){
                        if (specs ==''){
                            if(!String.isBlank(String.valueOf(nonWhiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c))){
                                if(nonWhiteListSpecs.get(specId).OTID__c<>NULL)
                                    specs = String.valueOf(nonWhiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c)+':'+nonWhiteListSpecs.get(specId).OTID__c;
                                else
                                    specs = String.valueOf(nonWhiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c)+':'+'NONE'; 
                            }
                        } else {
                            if(!String.isBlank(String.valueOf(nonWhiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c))){
                                if(nonWhiteListSpecs.get(specId).OTID__c<>NULL)
                                    specs = specs+';'+ String.valueOf(nonWhiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c)+':'+nonWhiteListSpecs.get(specId).OTID__c;
                                else    
                                    specs = specs+';'+ String.valueOf(nonWhiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c)+':'+'NONE';
                            }
                        }
                    } // End of nonWhiteListSpec for loop
                }// End of non white list if
                if (!String.isBlank(specs)){
                   dp.isProvUpdate__c = true;
                    if(DP.PDK_Provisoin_To_Updated_Specs__c<>NULL){
                        DP.PDK_Provisoin_To_Updated_Specs__c = DP.PDK_Provisoin_To_Updated_Specs__c +';'+specs;
                    } else {
                        DP.PDK_Provisoin_To_Updated_Specs__c = specs;
                    }   
                }
                lstOfDP.add(DP);
            }          
        }//End of Document provisioning list iterator for loop
        if (lstOfDP<>NULL && !lstOfDP.isEmpty()){
            update lstOfDP; 
        } 
    }//END OF updatePdkProvisioning
    
    
    // Retrive SubPDK Information for selected sub PDK
    public  static Sub_PDK__c retrieveSubPDKInfo(Id subPDKId){
        
        Sub_PDK__c objSubPDK = new Sub_PDK__c();
        
        objSubPDK = [Select Id, Name, Sub_PDK_Version__c, Sub_PDK_Location_Fab__c, Sub_PDK_Revision_Release_Date__c, Sub_PDK_Lifecycle_Phase__c, 
                            Sub_PDK_Sub_class__c, Technology__c,Tech_Geometry__c, Release_Status__c, PDK__c,Sync_With_OpenText__c,Full_PDK_Name__c,
                            Ready_For_Provisioning__c,Time_Req_To_Create_Association_In_OT__c,PDK_Failure_Specs__c,OpenText_Error_Message__c 
                     from   Sub_PDK__c
                     where  Id =: subPDKId];
                 
        return objSubPDK;
            
    }
    
    // Send Email in case any failure
    public static Messaging.SingleEmailMessage sendEmail(String pdkId){
        List<String> toAddresses = new List<String>();
        Set<Id> setOfUserId = new Set<Id>();
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
        List<EmailTemplate> templateId = [Select id from EmailTemplate where name = 'PDK Failure Spec Template'];
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(toAddresses);
        if(templateId!=null && templateId.size()>0)
            mail.setTemplateId(templateId[0].id);
        mail.setTargetObjectId(label.PDK_IT_Admin_Contact_Id); 
        mail.setWhatId(pdkId);
        if(!Test.isrunningtest())
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        return mail;
    }  
    /*@ Method Name :- deleteAllDPrecordsRelatedtoPDK
    * @ Description :- Method used to delete DP record when release status change from "XX" to "General Release".
    * @ Date :- 17/712/2015
    */
    
    public static void deleteAllDPrecordsRelatedtoPDK(String subPDKId){
        if(subPDKId != null)
            try{
                delete [select id from Document_Provisioning__c where Sub_PDK__c=:subPDKId];
            }
            Catch(System.DmlException e){
                FV_ErrorLogHandler.setErrorLogs('PDK','FV_PDKSpecAssociationService','deleteAllDPrecordsRelatedtoPDK', e.getMessage());
            }        
    }  
}