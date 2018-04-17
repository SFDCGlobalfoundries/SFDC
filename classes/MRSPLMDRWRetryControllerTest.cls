/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 */
@isTest
public class MRSPLMDRWRetryControllerTest {
    
    @testSetup
    static void setupTestData() {
        initialData();
    }

    static testMethod void retryPlmDrw_test() {
        SWIFT_Application_Log__c tempLog = [select id,Message_ID__c,Integration_Payload__c,Debug_Level__c from SWIFT_Application_Log__c where message_id__c = 'testPlmDRWR'];
        try { MRSPLMDRWRetryController.retryPlmDrw(tempLog.Id); } catch(Exception e) {}
    }
    
    //FrameGen_DRWNoOrderStatus
    static testMethod void retryDrwStartComplete_test1() {
        SWIFT_Application_Log__c tempLog = [select id,Message_ID__c,Integration_Payload__c,Debug_Level__c from SWIFT_Application_Log__c where message_id__c = 'FrameGen_DRWNoOrderStatus'];
        try { MRSPLMDRWRetryController.retryDrwStartComplete(tempLog.Id); } catch(Exception e) {}
    }
    
    //FrameGen_DRWStartStatus
    static testMethod void retryDrwStartComplete_test2() {
        SWIFT_Application_Log__c tempLog = [select id,Message_ID__c,Integration_Payload__c,Debug_Level__c from SWIFT_Application_Log__c where message_id__c = 'FrameGen_DRWStartStatus'];
        try { MRSPLMDRWRetryController.retryDrwStartComplete(tempLog.Id); } catch(Exception e) {}
    }
    
    //FrameGen_DRWCompletedStatus
    static testMethod void retryDrwStartComplete_test3() {
        SWIFT_Application_Log__c tempLog = [select id,Message_ID__c,Integration_Payload__c,Debug_Level__c from SWIFT_Application_Log__c where message_id__c = 'FrameGen_DRWCompletedStatus'];
        try { MRSPLMDRWRetryController.retryDrwStartComplete(tempLog.Id); } catch(Exception e) {}
    }
    
    //FrameGen_FGStatus
    static testMethod void retryDrwStartComplete_test4() {
        SWIFT_Application_Log__c tempLog = [select id,Message_ID__c,Integration_Payload__c,Debug_Level__c from SWIFT_Application_Log__c where message_id__c = 'FrameGen_FGStatus'];
        try { MRSPLMDRWRetryController.retryDrwStartComplete(tempLog.Id); } catch(Exception e) {}
    }
    
    //FrameGen_FGRerunStatus
    static testMethod void retryDrwStartComplete_test5() {
        SWIFT_Application_Log__c tempLog = [select id,Message_ID__c,Integration_Payload__c,Debug_Level__c from SWIFT_Application_Log__c where message_id__c = 'FrameGen_FGRerunStatus'];
        try { MRSPLMDRWRetryController.retryDrwStartComplete(tempLog.Id); } catch(Exception e) {}
        
        MRSPLMDRWRetryController.DrwStartCompleteParam testP = new MRSPLMDRWRetryController.DrwStartCompleteParam(
            new set < Id >{tempLog.id}, 
            new set < string > {''}
        );
    }
    
     static testMethod void retryPtrfPTONoChip_test1() {
         SWIFT_Application_Log__c tempLog = [select id,Message_ID__c,Integration_Payload__c,Debug_Level__c from SWIFT_Application_Log__c where message_id__c = 'tempLog7'];
         try { MRSPLMDRWRetryController.retryPtrfPTONoChip(tempLog.Id); } catch(Exception e) {}
     }
     
     static testMethod void retryPtrfPTONoChip_test2() {
         SWIFT_Application_Log__c tempLog = [select id,Message_ID__c,Integration_Payload__c,Debug_Level__c from SWIFT_Application_Log__c where message_id__c = 'tempLog8'];
         try { MRSPLMDRWRetryController.retryPtrfPTONoChip(tempLog.Id); } catch(Exception e) {}
     }
     
     static testMethod void retryPtrfCancelButChipNotCancel_test2() {
         SWIFT_Application_Log__c tempLog = [select id,Message_ID__c,Integration_Payload__c,Debug_Level__c from SWIFT_Application_Log__c where message_id__c = 'tempLog8'];
         try { MRSPLMDRWRetryController.retryPtrfCancelButChipNotCancel(tempLog.Id); } catch(Exception e) {}
     }
     
     static testMethod void retryTecnLiftOff_test2() {
         SWIFT_Application_Log__c tempLog = [select id,Message_ID__c,Integration_Payload__c,Debug_Level__c from SWIFT_Application_Log__c where message_id__c = 'tempLog9'];
         try { MRSPLMDRWRetryController.retryTecnLiftOff(tempLog.Id); } catch(Exception e) {}
     }
     
     static testMethod void retry_MRSDeselectionService_notification_test() {
         SWIFT_Application_Log__c tempLog = [select id,Message_ID__c,Integration_Payload__c,Debug_Level__c from SWIFT_Application_Log__c where message_id__c = 'tempLog10'];
         try { MRSPLMDRWRetryController.retry_MRSDeselectionService_notification(tempLog.Id); } catch(Exception e) {}
     }
     
     static testMethod void retry_retry_sendLayerStatusUpdate_test() {
         SWIFT_Application_Log__c tempLog = [select id,Message_ID__c,Integration_Payload__c,Debug_Level__c from SWIFT_Application_Log__c where message_id__c = 'tempLog10'];
         try { MRSPLMDRWRetryController.retry_sendLayerStatusUpdate(tempLog.Id); } catch(Exception e) {}
     }
    
    public static void initialData() {
        
        Mask_Set_Title__c mst = SwiftDataUtilityTest.createMST( 'ZIN789');
        insert mst;
        
        DRT__c drt1 = new DRT__c( Name='testFrame', Synced_with_Oracle_DB__c=false, DRT_Package_Sync__c=false, Status__c='Active', Mask_Set_Title__c = mst.Id );          
        insert drt1;
        
        PTRF__c ptrf1 = new PTRF__c( Name='PTRF-20189-522', Order_Type__c = 'testOrder1', Recticle_Type__c='Multi Layer Reticle (MLR)', 
            Customer_jobview__c='Gating Mask Release', MaskSetTitle__c = mst.id, Status__c = 'Perform Tapeout Options'
        );
        insert ptrf1;//this ptrf got chips
        
        PTRF__c ptrf2 = new PTRF__c( Name='PTRF-20189-5225', Order_Type__c = 'testOrder1', Recticle_Type__c='Multi Layer Reticle (MLR)', 
            Customer_jobview__c='Gating Mask Release', MaskSetTitle__c = mst.id, Status__c = 'Perform Tapeout Options'
        );
        insert ptrf2;//this ptrf not got chips
        
        DRT_PTRF_Association__c drtPtrfIns = new DRT_PTRF_Association__c( DRT__c = drt1.id, PTRF__c = ptrf1.id);
        //insert drtPtrfIns ;
        
        MRS__c mrs1 = new MRS__c( Full_Sync__c =true, Synced_with_Oracle_DB__c=false, MRS_Package_Sync__c=false, Mask_Set_Title__c=mst.Id);
        insert mrs1;
        
        MRS_Layer_Association__c mrsLayer1 = new MRS_Layer_Association__c( Name ='BV', Synced_with_Oracle_DB__c=false, Mask_Layer_Rev__c = 'AZ',
            Layer_Name__c = 'AZ', Layer_Status__c = 'Not Ready', mrs__c = mrs1.id
        );
        insert mrslayer1;
        
        MRS_Layer_Association__c mrsLayer2 = new MRS_Layer_Association__c( Name ='C7', Synced_with_Oracle_DB__c=false, Mask_Layer_Rev__c = 'AZ',
            Layer_Name__c = 'C7', Layer_Status__c = 'Not Ready', mrs__c = mrs1.id
        );
        insert mrslayer2;   
        
        MRS_Chip_Details__c mrsChip1 = new MRS_Chip_Details__c( Name='PD123', Synced_with_Oracle_DB__c=false, mrs__c = mrs1.id);        
        insert mrsChip1; 
        
        MRS_Layer_Chip_Association__c layerChip1 = new MRS_Layer_Chip_Association__c(
            Synced_with_Oracle_DB__c=false, Send_Frame_Data__c = 'Not Done', Send_Prime_Data__c = 'Not Done', /*DRT__c=drt1.id,*/
            Layer__c=mrsLayer1.Id, Foundry_GDSOUT_Review__c = 'Not Ready', Chip__c=mrsChip1.Id, PTRF__c=ptrf1.Id, GlobalShuttle_MEBES_Jobview__c= 'Not Ready',
            TDTI_MPW_MEBES_Jobview__c = 'Not Ready', MDP_MEBES_Jobview__c = 'Not Ready', Tapeout_Centre_MEBES_Jobview__c = 'Not Ready',         
            Tapeout_Applications_MEBES_Jobview__c = 'Not Ready', Foundry_MEBES_Jobview__c = 'Not Ready', Customer_MEBES_Jobview__c = 'Not Ready',
            Frame_MEBES_Received__c = 'Not Done', Prime_MEBES_Received__c = 'Not Done', Mask_Set_Title_Id__c = mst.id, PTRF_Or_DRT__c = 'PTRF'
        );
        insert layerChip1;
        
        MRS_Layer_Chip_Association__c layerChip2 = new MRS_Layer_Chip_Association__c(
            Synced_with_Oracle_DB__c=false, Send_Frame_Data__c = 'Not Done', Send_Prime_Data__c = 'Not Done',  DRT__c=drt1.id,
            Layer__c=mrsLayer2.Id, Foundry_GDSOUT_Review__c = 'Not Ready', Chip__c=mrsChip1.Id, PTRF__c=ptrf1.Id, GlobalShuttle_MEBES_Jobview__c= 'Not Ready',
            TDTI_MPW_MEBES_Jobview__c = 'Not Ready', MDP_MEBES_Jobview__c = 'Not Ready', Tapeout_Centre_MEBES_Jobview__c = 'Not Ready',
            Tapeout_Applications_MEBES_Jobview__c = 'Not Ready', Foundry_MEBES_Jobview__c = 'Not Ready', Customer_MEBES_Jobview__c = 'Not Ready',
            Frame_MEBES_Received__c = 'Not Done', Prime_MEBES_Received__c = 'Not Done', Mask_Set_Title_Id__c = mst.id, PTRF_Or_DRT__c = 'DRT'
        );
        insert layerChip2;
        
        //====================================================
        
        list<SWIFT_Application_Log__c> listLogTobeInserted = new list<SWIFT_Application_Log__c>();
        
        //select id,Message_ID__c,Integration_Payload__c from SWIFT_Application_Log__c where id = :logId
        //Debug_Level__c
        SWIFT_Application_Log__c tempLog = new SWIFT_Application_Log__c(
            Message_ID__c = 'testPlmDRWR',
            Integration_Payload__c = '{"ptrfNumber":"PTRF-20123-123","messageID":"DRWR-00005754_20150918172036","layers":[{"maskRev":"AZ","maskLayerNumber":"A1"},{"maskRev":"AZ","maskLayerNumber":"A2"},{"maskRev":"AZ","maskLayerNumber":"A3"},{"maskRev":"BZ","maskLayerNumber":"B1"},{"maskRev":"BZ","maskLayerNumber":"B2"}]}',
            Debug_Level__c = 'ERROR'
        );
        listLogTobeInserted.add(tempLog);
        
        SWIFT_Application_Log__c tempLog2 = new SWIFT_Application_Log__c(
            Message_ID__c = 'FrameGen_DRWNoOrderStatus',
            Integration_Payload__c = '{"ptrfnumberSet":["PTRF-20123-123"],"ptrfIdSet":["a5oN0000000EYewIAG"]}',
            Debug_Level__c = 'ERROR',
            Method__c = 'FrameGen_DRWNoOrderStatus'
        );
        listLogTobeInserted.add(tempLog2);
        
        SWIFT_Application_Log__c tempLog3 = new SWIFT_Application_Log__c(
            Message_ID__c = 'FrameGen_DRWStartStatus',
            Integration_Payload__c = '{"ptrfnumberSet":["PTRF-20123-123"],"ptrfIdSet":["a5oN0000000EYewIAG"]}',
            Debug_Level__c = 'ERROR',
            Method__c = 'FrameGen_DRWStartStatus'
        );
        listLogTobeInserted.add(tempLog3);

        SWIFT_Application_Log__c tempLog4 = new SWIFT_Application_Log__c(
            Message_ID__c = 'FrameGen_DRWCompletedStatus',
            Integration_Payload__c = '{"ptrfnumberSet":["PTRF-20123-123"],"ptrfIdSet":["a5oN0000000EYewIAG"]}',
            Debug_Level__c = 'ERROR',
            Method__c = 'FrameGen_DRWCompletedStatus'
        );
        listLogTobeInserted.add(tempLog4);

        SWIFT_Application_Log__c tempLog5 = new SWIFT_Application_Log__c(
            Message_ID__c = 'FrameGen_FGStatus',
            Integration_Payload__c = '{"ptrfnumberSet":["PTRF-20123-123"],"ptrfIdSet":["a5oN0000000EYewIAG"]}',
            Debug_Level__c = 'ERROR',
            Method__c = 'FrameGen_FGStatus'
        );
        listLogTobeInserted.add(tempLog5);
        
        SWIFT_Application_Log__c tempLog6 = new SWIFT_Application_Log__c(
            Message_ID__c = 'FrameGen_FGRerunStatus',
            Integration_Payload__c = '{"ptrfnumberSet":["PTRF-20123-123"],"ptrfIdSet":["a5oN0000000EYewIAG"]}',
            Debug_Level__c = 'ERROR',
            Method__c = 'FrameGen_FGRerunStatus'
        );
        listLogTobeInserted.add(tempLog6);
        
        //ptrf pto no chips
        SWIFT_Application_Log__c tempLog7 = new SWIFT_Application_Log__c(
            Message_ID__c = 'tempLog7',
            Integration_Payload__c = '["' + ptrf2.Id + '"]',
            Debug_Level__c = 'ERROR',
            Method__c = 'addingPTRFToMRSFuture',
            Apex_Component_name__c = 'MRSHandlerUtility'
        );
        listLogTobeInserted.add(tempLog7);
        
        //ptrf pto got chips / for ptrf cancel also
        SWIFT_Application_Log__c tempLog8 = new SWIFT_Application_Log__c(
            Message_ID__c = 'tempLog8',
            Integration_Payload__c = '["' + ptrf1.Id + '"]',
            Debug_Level__c = 'ERROR',
            Method__c = 'addingPTRFToMRSFuture',
            Apex_Component_name__c = 'MRSHandlerUtility'
        );
        listLogTobeInserted.add(tempLog8);
        
        SWIFT_Application_Log__c tempLog9 = new SWIFT_Application_Log__c(
            Message_ID__c = 'tempLog9',
            Integration_Payload__c = '["' + ptrf1.Id + '"]',
            Debug_Level__c = 'ERROR',
            Method__c = 'liftOffUnUsedTECN',
            Apex_Component_name__c = 'TECNHandlerUtility'
        );
        listLogTobeInserted.add(tempLog9);
        
        
        SWIFT_Application_Log__c tempLog10 = new SWIFT_Application_Log__c(
             Message_ID__c = 'tempLog10',
            Integration_Payload__c = '["' + ptrf1.Id + '"]',
            Debug_Level__c = 'ERROR',
            Apex_Component_Name__c = 'tempLog10',
            Method__c = 'notification'
        );
        listLogTobeInserted.add(tempLog10);        
        insert listLogTobeInserted;
    }
}