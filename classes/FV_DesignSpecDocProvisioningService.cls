/**
* @ Author :- Kunal Patil
* @ Company :- CTS 
* @ Description :- Class handles DesignSpec updates coming from OT
                 After DesignSpec document get provisioned request will be send to OT and after succesfully provisioned 
                 in to OT, Ot will return response to SFDC. This service is response service for DesignSpec.  
* @ Date :- 06/04/2015
* @ Change History :- 
**/
global class FV_DesignSpecDocProvisioningService { 
	
	// Handles new provision Designspec response and update  
    // bundle fields accordingly  
    webservice static responseInfo DesignSpecResponseService(List<DesignSpecProInfo> DesignSpecInfo){
 
        try {
            if (DesignSpecInfo<>NULL && !DesignSpecInfo.isEmpty()){
            	Set<String> dpIds = new Set<String>();
            	Map<Id,Document_Provisioning__c> mapOfDpRecords;
            	List<Document_Provisioning__c> listOfDp = new List<Document_Provisioning__c>();
            	dpIds = FV_DesignSpecDocProvisioningService.getDoProIds(DesignSpecInfo);
            	if(dpIds!=null && !dpIds.isEmpty())
            		mapOfDpRecords = new Map<Id,Document_Provisioning__c>([SELECT Id,Status__c,AccountID__c,AccountID__r.Short_Name__c,PdkSpecs__c,
                                                                              Sync_With_OpenText__c,PDK_Provisoin_To_Updated_Specs__c,PDK_Spec_Names__c,
                                                                              PDK_Failure_Specs__c,PDK_Failure_DeProSpecs__c,OpenText_Error_Message__c 
                                                                        FROM  Document_Provisioning__c 
                                                                        WHERE Id IN : dpIds]);
                                                                        
                if (mapOfDpRecords<>NULL && !mapOfDpRecords.isEmpty()){
                    for (DesignSpecProInfo info : DesignSpecInfo){
                        if (mapOfDpRecords.containskey(info.dpId)){
                            Document_Provisioning__c dp = new Document_Provisioning__c();
                            dp.Id = info.dpId;
                            dp.DateTime_Last_Synced_With_OpenText__c = DateTime.now();
                            dp.Sync_With_OpenText__c = info.isSyncWithOt;
                            if(info.otErrorMsg<>NULL && info.otErrorMsg!=''){
                              dp.OpenText_Error_Message__c = info.otErrorMsg;
                            } else {
                            	// Set Status to provisioned
                            	//dp.Status__c = info.status;
                            	if(info.isSyncWithOt){
                            		if(mapOfDpRecords.get(info.dpId).Status__c=='Provisioning In Progress')
                            			dp.Status__c ='Provisioned';
                            		else
                            			if(mapOfDpRecords.get(info.dpId).Status__c=='De-Provisioning In Progress')
                            				dp.Status__c = 'De-Provisioned';		
                            	}
                            }
                            listOfDp.add(dp);
                        }
                    }          
                }
               if (listOfDp<>NULL && !listOfDp.isEmpty()){
                    update listOfDp;
                }   
            }    
                
            return new responseInfo(true,'');
        }catch (Exception e){
            FV_ErrorLogHandler.setErrorLogs('DesignSpec','FV_DesignSpecDocProvisioningService','DesignSpecResponseService', e.getMessage());
            return new responseInfo(false,e.getMessage());
        }
	}
	// Prepare and return document provisioning SFDC id set
    private static Set<String> getDoProIds(List<DesignSpecProInfo> designSpecInfo){
        Set<String> dpIds = new Set<String>();
        for (DesignSpecProInfo info : designSpecInfo){
            if (info.dpId<>NULL && !String.isBlank(info.dpId)){
                    if (!dpIds.contains(info.dpId)){
                        dpIds.add(info.dpId);
                    }
            }
        }
        return dpIds;
    }
    
	 /*
    * @ Description :- Class holds designSpec provisioning related information
    * @ Date :- 
    * @ Change History :- 
    */
    global class DesignSpecProInfo {
        webservice Boolean isSyncWithOt = false;
        webservice String otErrorMsg;
        webservice String status;
        Webservice String dpId;      
    }
    
    /*
    * @ Description :- Class holds designSpec provisioning/de-provisioning related response info like success, error logs
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