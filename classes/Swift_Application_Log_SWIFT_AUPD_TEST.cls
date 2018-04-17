/*cover trigger Swift_Application_Log_SWIFT_AUPD*/
@isTest(seeAllData=false)
private class Swift_Application_Log_SWIFT_AUPD_TEST {

    @testSetup
    static void setupTestData() {
        initialData();
    }

    static testMethod void PTRF_FrameGen_DRW_StatusUpdate_retry() {
        SWIFT_Application_Log__c tempLog = [select id,Message_ID__c,Integration_Payload__c,Debug_Level__c from SWIFT_Application_Log__c where message_id__c = 'tempLog'];
        tempLog.Retry_Status__c = 'In Queue';
        try { update tempLog; } catch(Exception e) {}
    }
    
    static testMethod void MRSPLMDRWServiceHandler_retry() {
        SWIFT_Application_Log__c tempLog = [select id,Message_ID__c,Integration_Payload__c,Debug_Level__c from SWIFT_Application_Log__c where message_id__c = 'tempLog2'];
        tempLog.Retry_Status__c = 'In Queue';
        try { update tempLog; } catch(Exception e) {}
    }
    
    static testMethod void MRSHandlerUtility_addingPTRFToMRSFuture_retry() {
        SWIFT_Application_Log__c tempLog = [select id,Message_ID__c,Integration_Payload__c,Debug_Level__c from SWIFT_Application_Log__c where message_id__c = 'tempLog3'];
        tempLog.Retry_Status__c = 'In Queue';
        try { update tempLog; } catch(Exception e) {}
    }
    
    static testMethod void MRSHandlerUtility_executeUpdateMCLAFuture_retry() {
        SWIFT_Application_Log__c tempLog = [select id,Message_ID__c,Integration_Payload__c,Debug_Level__c from SWIFT_Application_Log__c where message_id__c = 'tempLog4'];
        tempLog.Retry_Status__c = 'In Queue';
        try { update tempLog; } catch(Exception e) {}
    }
    
    static testMethod void MRSHandlerUtility_liftOffUnUsedTECN_retry() {
        SWIFT_Application_Log__c tempLog = [select id,Message_ID__c,Integration_Payload__c,Debug_Level__c from SWIFT_Application_Log__c where message_id__c = 'tempLog5'];
        tempLog.Retry_Status__c = 'In Queue';
        try { update tempLog; } catch(Exception e) {}
    }
    
    static testMethod void MRSHandlerUtility_elseContinue_retry() {
        SWIFT_Application_Log__c tempLog = [select id,Message_ID__c,Integration_Payload__c,Debug_Level__c from SWIFT_Application_Log__c where message_id__c = 'tempLog5'];
        tempLog.Apex_Component_Name__c = 'CONTINUE';
        tempLog.Retry_Status__c = 'In Queue';
        try { update tempLog; } catch(Exception e) {}
    }
    
    static testMethod void MRSSwiftUtility_sendLayerStatusUpdate_retry() {
        SWIFT_Application_Log__c tempLog = [select id,Message_ID__c,Integration_Payload__c,Debug_Level__c from SWIFT_Application_Log__c where message_id__c = 'tempLog6'];
        tempLog.Apex_Component_Name__c = 'CONTINUE';
        tempLog.Retry_Status__c = 'In Queue';
        try { update tempLog; } catch(Exception e) {}
    }
    
    static testMethod void retry_MRSDeselectionService_notification() {
        SWIFT_Application_Log__c tempLog = [select id,Message_ID__c,Integration_Payload__c,Debug_Level__c from SWIFT_Application_Log__c where message_id__c = 'tempLog7'];
        tempLog.Apex_Component_Name__c = 'CONTINUE';
        tempLog.Retry_Status__c = 'In Queue';
        try { update tempLog; } catch(Exception e) {}
    }
    
    public static void initialData() {
        list<SWIFT_Application_Log__c> listLogTobeInserted = new list<SWIFT_Application_Log__c>();
        
        SWIFT_Application_Log__c tempLog = new SWIFT_Application_Log__c(
            Message_ID__c = 'tempLog',
            Integration_Payload__c = 'test_dummy',
            Debug_Level__c = 'ERROR',
            Retry_Status__c = 'New',
            Is_Auto_Retry__c = true,
            Apex_Component_Name__c = 'PTRF_FrameGen_DRW_StatusUpdate'
        );
        listLogTobeInserted.add(tempLog);
        
        SWIFT_Application_Log__c tempLog2 = new SWIFT_Application_Log__c(
            Message_ID__c = 'tempLog2',
            Integration_Payload__c = 'test_dummy',
            Debug_Level__c = 'ERROR',
            Retry_Status__c = 'New',
            Is_Auto_Retry__c = true,
            Apex_Component_Name__c = 'MRSPLMDRWServiceHandler'
        );
        listLogTobeInserted.add(tempLog2);
        
        SWIFT_Application_Log__c tempLog3 = new SWIFT_Application_Log__c(
            Message_ID__c = 'tempLog3',
            Integration_Payload__c = 'test_dummy',
            Debug_Level__c = 'ERROR',
            Retry_Status__c = 'New',
            Is_Auto_Retry__c = true,
            Apex_Component_Name__c = 'MRSHandlerUtility',
            Method__c = 'addingPTRFToMRSFuture'
        );
        listLogTobeInserted.add(tempLog3);
        
        SWIFT_Application_Log__c tempLog4 = new SWIFT_Application_Log__c(
            Message_ID__c = 'tempLog4',
            Integration_Payload__c = 'test_dummy',
            Debug_Level__c = 'ERROR',
            Retry_Status__c = 'New',
            Is_Auto_Retry__c = true,
            Apex_Component_Name__c = 'MRSHandlerUtility',
            Method__c = 'executeUpdateMCLAFuture'
        );
        listLogTobeInserted.add(tempLog4);
        
        SWIFT_Application_Log__c tempLog5 = new SWIFT_Application_Log__c(
            Message_ID__c = 'tempLog5',
            Integration_Payload__c = 'test_dummy',
            Debug_Level__c = 'ERROR',
            Retry_Status__c = 'New',
            Is_Auto_Retry__c = true,
            Apex_Component_Name__c = 'TECNHandlerUtility',
            Method__c = 'liftOffUnUsedTECN'
        );
        listLogTobeInserted.add(tempLog5);
        
        SWIFT_Application_Log__c tempLog6 = new SWIFT_Application_Log__c(
            Message_ID__c = 'tempLog6',
            Integration_Payload__c = 'test_dummy',
            Debug_Level__c = 'ERROR',
            Retry_Status__c = 'New',
            Is_Auto_Retry__c = true,
            Apex_Component_Name__c = 'MRSSwiftUtility',
            Method__c = 'sendLayerStatusUpdate'
        );
        listLogTobeInserted.add(tempLog6);
        
        
        SWIFT_Application_Log__c tempLog7 = new SWIFT_Application_Log__c(
            Message_ID__c = 'tempLog7',
            Integration_Payload__c = 'test_dummy',
            Debug_Level__c = 'ERROR',
            Retry_Status__c = 'New',
            Is_Auto_Retry__c = true,
            Apex_Component_Name__c = 'MRSDeselectionService',
            Method__c = 'notification'
        );
        listLogTobeInserted.add(tempLog7);
        
        insert listLogTobeInserted;
    }
}