/*
THIS CLASS is used to handling concurrency exclusive lock issue by retrying
Although it's named PLM but it's used for various operation.
*/
global class MRSPLMDRWRetryController {
    
    public static String RESPONSE_STRING = 'Retry completed. Please check email for any error';

    /**
    * Retry PLM DRWR ws
    * This method is called from:
    *       - Auto retry mechanism: Swift_Application_Log_SWIFT_AUPD trigger
    *       - Manual retry: Retry button on Swift_Application_Log object
    */
    webservice static String retryPlmDrw(Id logId) {
        
        String response = '';
        try {
            //query the log based on log id
            SWIFT_Application_Log__c inputLog = getLog(logId);
            
            //get msg id of log, query log based on msg id, order by createdDate DESC > get the latest record
            list<SWIFT_Application_Log__c> logList = [select id,name,Debug_Level__c from SWIFT_Application_Log__c where Message_ID__c = :inputLog.Message_ID__c order by CreatedDate DESC limit 1];
            
            //if latest record debug level is DEBUG > return msg this request has been retried
            if(logList.get(0).Debug_Level__c == 'DEBUG') return 'Already retry success at: ' + logList.get(0).name;
            //else: retry request and response retry has been submitted
            
            //log saved payload in json format
            String payload = inputLog.Integration_Payload__c;
            //parse the json back to request data and call ws function for processing again
            MRSPLMDRWService.PlmDrwPTRF msgData = (MRSPLMDRWService.PlmDrwPTRF) JSON.deserialize(payload, MRSPLMDRWService.PlmDrwPTRF.class);
            //call PLM DRWR ws with original payload
            MRSPLMDRWServiceHandler.fetch().handleRequest(json.serialize(msgData));
            response = RESPONSE_STRING;
        } catch(Exception e) { response = e.getMessage() + ' - ' + e.getStackTraceString(); }
        return response;//response message show in manual retry page layout only
    }
    
    /**
    * Retry PTRF DRW Start/Complete ws
    * This method is called from:
    *       - Auto retry mechanism: Swift_Application_Log_SWIFT_AUPD trigger
    *       - Manual retry: Retry button on Swift_Application_Log object
    * Retry based on type of DRW WS
    */
    webservice static String retryDrwStartComplete(Id logId) {

        String response = '';

        try {
            SWIFT_Application_Log__c inputLog = [select id,Message_ID__c,Integration_Payload__c,Method__c,Is_Auto_Retry__c from SWIFT_Application_Log__c where id = :logId];
            String payload = inputLog.Integration_Payload__c;
            String method = inputLog.Method__c.trim();
            DrwStartCompleteParam msgData = (MRSPLMDRWRetryController.DrwStartCompleteParam) JSON.deserialize(payload, MRSPLMDRWRetryController.DrwStartCompleteParam.class);
            
            if(method == 'FrameGen_DRWNoOrderStatus') PTRF_FrameGen_DRW_StatusUpdate.FrameGen_DRWNoOrderStatus(msgData.ptrfIdSet, msgData.ptrfnumberSet); 
            //drw start
            else if(method == 'FrameGen_DRWStartStatus') PTRF_FrameGen_DRW_StatusUpdate.FrameGen_DRWStartStatus(msgData.ptrfIdSet, msgData.ptrfnumberSet);
            //drw complete
            else if(method == 'FrameGen_DRWCompletedStatus') PTRF_FrameGen_DRW_StatusUpdate.FrameGen_DRWCompletedStatus(msgData.ptrfIdSet, msgData.ptrfnumberSet); 
            else if(method == 'FrameGen_FGStatus') PTRF_FrameGen_DRW_StatusUpdate.FrameGen_FGStatus(msgData.ptrfIdSet, msgData.ptrfnumberSet); 
            else if(method == 'FrameGen_FGRerunStatus') PTRF_FrameGen_DRW_StatusUpdate.FrameGen_FGRerunStatus(msgData.ptrfIdSet, msgData.ptrfnumberSet);
            response = RESPONSE_STRING;
        } catch(Exception e) { response = e.getMessage() + ' - ' + e.getStackTraceString(); }
        return response;
    }
    
    /**
    * Retry PTRF reached PTO but failed to generate layer chip due to concurrency lead to duplicate layer
    */
    webservice static String retryPtrfPTONoChip(Id logId) {
        
        SWIFT_Application_Log__c inputLog = getLog(logId);
        set < String > setPTRFIds = (set<String>) JSON.deserialize(inputLog.Integration_Payload__c, set<string>.class);
        list<mrs_layer_chip_association__c> listLayerChip = [select id from mrs_layer_chip_association__c where ptrf__c in :setPTRFIds];
        if(!listLayerChip.isEmpty()) return 'Already retried.';
        MRSHandlerUtility.addingPTRFToMRS(setPTRFIds); return 'SUCCESS';
    }
    
    /**
    * Retry PTRF cancel failed to cancel related layer chip due to concurrency lock
    */
    webservice static String retryPtrfCancelButChipNotCancel(Id logId) {
        
        SWIFT_Application_Log__c inputLog = getLog(logId);
        set < String > setPTRFIds = (set<String>) JSON.deserialize(inputLog.Integration_Payload__c, set<string>.class);        
        
        map<Id, MRS_Layer_Chip_Association__c> mapLayerChipToCancel = new map<Id, MRS_Layer_Chip_Association__c>([
            select id 
            from MRS_Layer_Chip_Association__c 
            where ptrf__r.Name in :setPTRFIds and layer_chip_status__c != 'Cancel'
        ]);
        
        if(mapLayerChipToCancel.isEmpty()) return 'Already retried.';
        List < ID > recordIds = new List < ID >();
        recordIds.addAll(mapLayerChipToCancel.keySet());
        
        MRSHandlerUtility.executeUpdateMCLAFuture(recordIds); return 'SUCCESS';
    }
    
    /*
    //SWGP-134
    retry TECNHAndlerUtility.liftOffUnUsedTECN
    */
    webservice static String retryTecnLiftOff(Id logId) {
        SWIFT_Application_Log__c inputLog = getLog(logId);
        list<Mask_Layer__c> listMaskLayer = (list<Mask_Layer__c>) json.deserialize(inputLog.Integration_Payload__c, list<Mask_Layer__c>.class);
        TECNHandlerUtility.liftOffUnUsedTECN(listMaskLayer); return 'SUCCESS';
    }
    
    /*
    SWGP-983
    retry this method MRSSwiftUtility.sendLayerStatusUpdate(set<id>); to send layer status to .net PTRF
    */
    webservice static String retry_sendLayerStatusUpdate(Id logId) {
        SWIFT_Application_Log__c inputLog = getLog(logId);
        set<Id> setLayerIds = (set<Id>) json.deserialize(inputLog.Integration_Payload__c, set<Id>.class);
        MRSSwiftUtility.sendLayerStatusUpdate(setLayerIds); return 'SUCCESS';        
    }
    
    
    /*
    SWGP-882
    */
    webservice static String retry_MRSDeselectionService_notification(Id logId) {
        SWIFT_Application_Log__c inputLog = getLog(logId);
        MRSDeselectionService.Notification payload = (MRSDeselectionService.Notification) json.deserialize(inputLog.Integration_Payload__c, MRSDeselectionService.Notification.class);
        MRSDeselectionService.notification(payload); return 'SUCCESS';        
    }
    
    /*this method retrive swift log for failed payload*/
    static SWIFT_Application_Log__c getLog(Id logId) {
        list<SWIFT_Application_Log__c> inputLog = [select id,Message_ID__c,Integration_Payload__c,Is_Auto_Retry__c from SWIFT_Application_Log__c where id = :logId];
        if(!inputLog.isEmpty()) return inputLog.get(0);
        return null;
    }
    
    public static void invokeRetry(SWIFT_Application_Log__c s) {
   
        if(s.Apex_Component_Name__c == 'PTRF_FrameGen_DRW_StatusUpdate') 
        { 
            MRSPLMDRWRetryController.retryDrwStartComplete(s.id);
        } 
        else if(s.Apex_Component_Name__c == 'MRSPLMDRWServiceHandler') 
        {
            MRSPLMDRWRetryController.retryPlmDrw(s.id);
        } 
        else if(s.Apex_Component_Name__c == 'MRSHandlerUtility') 
        {
            if(null != s.Method__c && (s.Method__c == 'addingPTRFToMRSFuture' || s.Method__c == 'addingPTRFToMRS')) 
            {
                MRSPLMDRWRetryController.retryPtrfPTONoChip(s.id);
            } 
            else if(null != s.Method__c && s.Method__c == 'executeUpdateMCLAFuture') 
            {
                MRSPLMDRWRetryController.retryPtrfCancelButChipNotCancel(s.id);
            }
        }
        else if(s.Apex_Component_Name__c == 'TECNHandlerUtility')
        {
            if(!String.isBlank(s.Method__c) && s.Method__c == 'liftOffUnUsedTECN')
            {
                MRSPLMDRWRetryController.retryTecnLiftOff(s.id);//SWGP-134
            }
        }
        else if(s.Apex_Component_Name__c == 'MRSSwiftUtility')
        {
            if(!String.isBlank(s.Method__c) && s.Method__c == 'sendLayerStatusUpdate')
            {
                MRSPLMDRWRetryController.retry_sendLayerStatusUpdate(s.id);//SWGP-983
            }
        }
        else if(s.Apex_Component_Name__c == 'MRSDeselectionService')
        {
            if(!String.isBlank(s.Method__c) && s.Method__c == 'notification')
            {
                MRSPLMDRWRetryController.retry_MRSDeselectionService_notification(s.id);//SWGP-882
            }
        }
    }
    
    public class DrwStartCompleteParam {
        public set < Id > ptrfIdSet;
        public set < string > ptrfnumberSet;
        public DrwStartCompleteParam(set < Id > ptrfIdSet, set < string > ptrfnumberSet) {
            this.ptrfIdSet      = ptrfIdSet;
            this.ptrfnumberSet  = ptrfnumberSet;
        }
    }    
}