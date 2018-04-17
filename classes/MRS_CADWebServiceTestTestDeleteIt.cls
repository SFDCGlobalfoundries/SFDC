@isTest(seeAllData = True)
global class MRS_CADWebServiceTestTestDeleteIt{
    
    static void updateFlagNewWsNotRun() {
        
        List<Environment_Variable__c> listCustomSetting = new List<Environment_Variable__c>();
        Environment_Variable__c rjvSwitch1 = Environment_Variable__c.getInstance('SWIFT_CAD_WS_RJV_SWITCH'); // flag to check using new ws
        rjvSwitch1.value__c = 'OFF';
        listCustomSetting.add(rjvSwitch1);
        Environment_Variable__c rjvSwitch2 = Environment_Variable__c.getInstance('SWIFT_CAD_WS_MEBES_RECEIVED_SWITCH'); // flag to check using new ws
        rjvSwitch2.value__c = 'OFF';
        listCustomSetting.add(rjvSwitch2);
        Environment_Variable__c rjvSwitch3 = Environment_Variable__c.getInstance('SWIFT_CAD_WS_SEND_DATA_SWITCH'); // flag to check using new ws
        rjvSwitch3.value__c = 'OFF';
        listCustomSetting.add(rjvSwitch3);
        update listCustomSetting;

    }
    
    global class WebServiceMockImplNew implements WebServiceMock {
           global void doInvoke(
                   Object stub,
                   Object request,
                   Map<String, Object> response,
                   String endpoint,
                   String soapAction,
                   String requestName,
                   String responseNS,
                   String responseName,
                   String responseType){
                          /* docSample.EchoStringResponse_element respElement = 
                           new docSample.EchoStringResponse_element();
                           respElement.EchoStringResult = 'Mock response';
                           response.put('response_x',respElement); */
                           MRSCADResponseCalloutService.serviceMRSfeedbackResponse_element respElement =
                           new MRSCADResponseCalloutService.serviceMRSfeedbackResponse_element();
                           respElement.MRSfeedbackResponse = 'Hello World!';
                           response.put('response_x',respElement);
                           }
                       }
        
        // Testing web service callout
        public static String callEchoString(String input) {
        
            MRSCADResponseCalloutService.layer mrsLayer = new MRSCADResponseCalloutService.layer();
            mrsLayer.layerName = 'Layer001';        
            mrsLayer.layerRevision = 'Rev001';        
            mrsLayer.status = 'pass';        
            mrsLayer.errorMessage = 'error01';        
            
            MRSCADResponseCalloutService.chipLayerStatus chipLyrSts = new MRSCADResponseCalloutService.chipLayerStatus();
            chipLyrSts.ChipName = 'Chip001';
            chipLyrSts.layer = new MRSCADResponseCalloutService.layer[]{mrsLayer};            
            //chipLyrSts.layer.add(mrsLayer);
             
            MRSCADResponseCalloutService.transactionStatus transtu = new MRSCADResponseCalloutService.transactionStatus();
            transtu.ptrf = 'ptrf1';
            transtu.status = 'pass';
            transtu.transactionErrorMessage = 'errormsg';
            transtu.ChipStatus = new MRSCADResponseCalloutService.chipLayerStatus[]{chipLyrSts};        
             
            MRSCADResponseCalloutService.transactionStatus[] singleTransactionStus = new MRSCADResponseCalloutService.transactionStatus[]{transtu};
            //singleTransactionStus.add(transtu);               
            
        MRSCADResponseCalloutService.CADMRSLayerSyncResponseService_pt sample = new MRSCADResponseCalloutService.CADMRSLayerSyncResponseService_pt();
        sample.ProcessCADMRSLayerSyncResponse('Masg001',singleTransactionStus);
        sample.endpoint_x = 'http://api.salesforce.com/foo/bar';
        String echo = 'Hello World!';
        return echo;
        }
               //***************Sync_Layer_Generation_Job_CompletionFirst4 -Start ***********//
            
        Public static TestMethod void testSync_Layer_Generation_Job_CompletionFirst4(){
            
            updateFlagNewWsNotRun();
            
           User sysAdminUser = [SELECT Id,Name FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true].get(0); 
            List<HCM_Employee__c> hcmList = SwiftDataUtilityTest.createHCMEmployee(5);
         
          
          system.runAs(sysAdminUser)
          {
             list<User> u1List = SwiftDataUtilityTest.createTestUser(hcmList);
          User u1 = u1List[1]; 
        Mask_Set_Title__c mst = SwiftDataUtilityTest.createMST('QWERTY');
        insert mst;

    PTRF__c ptrf = new PTRF__c(Name='PTRFPS',Order_Type__c = 'testOrder',Recticle_Type__c='Multi Layer Reticle (MLR)',Customer_jobview__c='Gating Mask Release');
        insert ptrf;

    MRS__c mrs = new MRS__c(Full_Sync__c =true,
                                   Synced_with_Oracle_DB__c=false,
                                   MRS_Package_Sync__c=false,
                                   Mask_Set_Title__c=mst.Id);
    insert mrs;

    MRS_Layer_Association__c mrsLayer = new MRS_Layer_Association__c(Name ='layerPS',
                                                                           Synced_with_Oracle_DB__c=false,
                                                                           Mask_Layer_Rev__c = '005',
                                                                           Layer_Name__c = 'testLayer001',
                                                                           Layer_Status__c = 'Not Ready',
                                                                           mrs__c = mrs.id);
        insert mrslayer;
        
      MRS_Layer_Association__c mrsLayer1 = new MRS_Layer_Association__c(Name ='layerPS1',
                                                                           Synced_with_Oracle_DB__c=false,
                                                                           Mask_Layer_Rev__c = '006',
                                                                           Layer_Name__c = 'testLayer001',
                                                                           Layer_Status__c = 'Not Ready',
                                                                           mrs__c = mrs.id);
        insert mrslayer1;

    MRS_Chip_Details__c mrsChip = new MRS_Chip_Details__c(Name='chipPS',
                                                                Synced_with_Oracle_DB__c=false,
                                                                mrs__c = mrs.id);
        insert mrsChip;

    MRS_Layer_Chip_Association__c layerChip = new MRS_Layer_Chip_Association__c(Name='layerChipPS',
                                                                                      Synced_with_Oracle_DB__c=false,
                                                                                      
                                                                                      Last_Sync_Req_Timestamp_Send_Prime__c = system.now()+1,
                                                                                      Last_Sync_Req_Timestamp_Layer_Gen__c = system.now()+1,
                                                                                      Last_Sync_Req_Timestamp_Send_Frame__c = system.now()+1,
                                                                                      Last_Sync_Req_Timestamp_ORCN_Job__c = system.now()+1,
                                                                                      Last_Sync_Req_Timestamp_Receive_MEBES__c = system.now()+1,
                                                                                      Last_Sync_Req_Timestamp_Remote_Jobview__c = system.now()+1,
                                                                                      Customer_GDSOUT_Review__c = 'N.A.',
                                                                                      Foundry_GDSOUT_Review__c = 'N.A.',
                                                                                      Send_Frame_Data__c = 'N.A.',
                                                                                      Send_Prime_Data__c = 'N.A.',
                                              //Last_Sync_Req_Timestamp_Layer_Gen__c = system.now(),
                                                                                      Layer__c=mrsLayer.Id,
                                                                                      Chip__c=mrsChip.Id,
                                                                                      PTRF__c=ptrf.Id);
        insert layerChip;

          
          PTRF_JobViewer_Info__c tempJobViewer = new PTRF_JobViewer_Info__c(Name='testJobViewer',User__c=u1.Id,
                                                                      PTRF__c=ptrf.Id,Jobview__c='Foundry',Jobview_Type__c='MEBES Jobview',
                                                                      Email_Address__c='prasun.sarkar2@cognizant.com');
        insert tempJobViewer;

    list<string> lstchipNotFound = new list<string>();
            list<string> lstLayerNotFound = new list<string>();
            String chipNotFound = 'chip004';  
            String layerNotFound = 'layer003';
            lstchipNotFound.add(chipNotFound);
            lstLayerNotFound.add(layerNotFound);
            //Test.startTest();
            //Test.setMock(WebServiceMock.class, new WebServiceMockImplNew());
            //String output = callEchoString('Hello World!');
            //System.assertEquals('Hello World!', output);
    
    MRS_CADService.MSTPtrfChipLayer PtrfChipLayer = new MRS_CADService.MSTPtrfChipLayer();
        MRS_CADService.mstPtrfChipLayerList = new List<MRS_CADService.MSTPtrfChipLayer>();

    //Test method for class LayerData
            List<MRS_CADService.LayerData> tempLayerData= new List<MRS_CADService.LayerData>();
            MRS_CADService.LayerData templyr= new MRS_CADService.LayerData();
            templyr.maskLayer = 'testLayer001';
            templyr.maskRev = '005';
            templyr.resetFlag = true;
            templyr.jobStatus = 'SUCCESS';
            tempLayerData.add(templyr);
            
            MRS_CADService.LayerData templyr1= new MRS_CADService.LayerData();
            templyr1.maskLayer = 'testLayer001';
            templyr1.maskRev = '006';
            templyr1.resetFlag = false;
            templyr1.jobStatus = 'SUCCESS';
            tempLayerData.add(templyr1);

        //Test method for class ChipData
            List<MRS_CADService.ChipData> tempChipData = new List<MRS_CADService.ChipData>();
            MRS_CADService.ChipData tempChip = new MRS_CADService.ChipData();
            tempChip.chipName = 'chipPS';
            tempChip.chipType = 'testChipType';
            tempChip.layer = new list<MRS_CADService.LayerData>();
            tempChip.layer.addAll(tempLayerData);
            tempChipData.add(tempChip);
            
        //Test method for class PTRFData
            List<MRS_CADService.PTRFData> tempPtrf = new List<MRS_CADService.PTRFData>();
            MRS_CADService.PTRFData tempPtrfData = new MRS_CADService.PTRFData();
            tempPtrfData.ptrfNumber ='PTRFPS';
            tempPtrfData.technology = 'testTech';
            tempPtrfData.chip = new list<MRS_CADService.ChipData>();
            tempPtrfData.chip.addAll(tempChipData);
            //tempPtrfData.chip = tempChipData; 
            tempPtrf.add(tempPtrfData);
            
        //Test method for MRSDataRecievedOnLayerGeneration
            List<MRS_CADService.MRSDataRecievedOnLayerGeneration> layerGen = new List<MRS_CADService.MRSDataRecievedOnLayerGeneration>();
            MRS_CADService.MRSDataRecievedOnLayerGeneration tempLayerGen= new MRS_CADService.MRSDataRecievedOnLayerGeneration();
            tempLayerGen.messageID = 'testmsg01';
            tempLayerGen.maskSetTitle = mst.Name;
            tempLayerGen.jobStatus = 'SUCCESS';
            tempLayerGen.sourceInboundRequestTimestamp = system.now();
            tempLayerGen.additionalEmailContent = 'prasun.sarkar2@cognizant.com';
            tempLayerGen.ptrf = new list<MRS_CADService.PTRFData>();
            tempLayerGen.ptrf.addAll(tempPtrf);

            //tempLayerGen.ptrf = tempPtrf;
            layerGen.add(tempLayerGen);
            
        //MRS_CADService.sync_Layer_Generation_Job_Completion(layerGen); 
        
            // Test ()
            List<MRS_CADService.MRSDataRecievedOnSendPrimeData> lstSendPrimeData = new List<MRS_CADService.MRSDataRecievedOnSendPrimeData>();  
            MRS_CADService.MRSDataRecievedOnSendPrimeData tempSendPrimeData = new MRS_CADService.MRSDataRecievedOnSendPrimeData();
            tempSendPrimeData.messageID = 'testmsg01';
            tempSendPrimeData.maskSetTitle = mst.Name;
            tempSendPrimeData.jobStatus = 'SUCCESS';
            tempSendPrimeData.ptrf = new list<MRS_CADService.PTRFData>();
            tempSendPrimeData.ptrf.addAll(tempPtrf);
            //tempSendPrimeData.ptrf = tempPtrf;
            tempSendPrimeData.sourceInboundRequestTimestamp = system.now();
            tempSendPrimeData.reTapeoutFlag =true;
            lstSendPrimeData.add(tempSendPrimeData);

        MRS_CADService.sync_Send_Prime_Data_Job_Completion(lstSendPrimeData);
        // Check Prime_Data_Job_Completion for reTapeoutFlag false
         List<MRS_CADService.MRSDataRecievedOnSendPrimeData> lstSendPrimeData1 = new List<MRS_CADService.MRSDataRecievedOnSendPrimeData>();  
            MRS_CADService.MRSDataRecievedOnSendPrimeData tempSendPrimeData1 = new MRS_CADService.MRSDataRecievedOnSendPrimeData();
            tempSendPrimeData1.messageID = 'testmsg02';
            tempSendPrimeData1.maskSetTitle = mst.Name;
            tempSendPrimeData1.jobStatus = 'SUCCESS';
            tempSendPrimeData1.ptrf = new list<MRS_CADService.PTRFData>();
            tempSendPrimeData1.ptrf.addAll(tempPtrf);
            tempSendPrimeData1.sourceInboundRequestTimestamp = system.now();
            tempSendPrimeData1.reTapeoutFlag =False;
            lstSendPrimeData1.add(tempSendPrimeData1);

        MRS_CADService.sync_Send_Prime_Data_Job_Completion(lstSendPrimeData1);
 
     // Test sync_Send_Frame_Data_Job_Completion()
            List<MRS_CADService.MRSDataRecievedOnSendFrameData> lstSendFrameData = new List<MRS_CADService.MRSDataRecievedOnSendFrameData>();  
            MRS_CADService.MRSDataRecievedOnSendFrameData tempFrameData = new MRS_CADService.MRSDataRecievedOnSendFrameData();
            tempFrameData.messageID = 'testmsg01';
            tempFrameData.maskSetTitle = mst.Name;
            tempFrameData.jobStatus = 'SUCCESSgg';
            tempFrameData.ptrf = new list<MRS_CADService.PTRFData>();
            tempFrameData.ptrf.addAll(tempPtrf);
            tempFrameData.reTapeoutFlag =true;
            tempFrameData.sourceInboundRequestTimestamp = system.now();
            lstSendFrameData.add(tempFrameData);
            
        MRS_CADService.sync_Send_Frame_Data_Job_Completion(lstSendFrameData);

       /* List<MRS_CADService.MRSDataRecievedOnSendFrameData> lstSendFrameData1 = new List<MRS_CADService.MRSDataRecievedOnSendFrameData>();  
            MRS_CADService.MRSDataRecievedOnSendFrameData tempFrameData1 = new MRS_CADService.MRSDataRecievedOnSendFrameData();
            tempFrameData1.messageID = 'testmsg01';
            tempFrameData1.maskSetTitle = mst.Name;
            tempFrameData1.jobStatus = 'SUCCESSgg';
            tempFrameData1.ptrf = new list<MRS_CADService.PTRFData>();
            tempFrameData1.ptrf.addAll(tempPtrf);
            tempFrameData1.reTapeoutFlag =False;
            tempFrameData1.sourceInboundRequestTimestamp = system.now();
            lstSendFrameData1.add(tempFrameData1);
            
        MRS_CADService.sync_Send_Frame_Data_Job_Completion(lstSendFrameData1); */
        
     // Test sync_Remote_Jobview_Setup_Ready()
     List<MRS_CADService.JobDeckData> lstJobDeck = new List<MRS_CADService.JobDeckData>();
            MRS_CADService.JobDeckData tempDeckDataNew = new MRS_CADService.JobDeckData();
            tempDeckDataNew.jobDeck = 'testJobDeck';
            lstJobDeck.add(tempDeckDataNew);
     
        List<MRS_CADService.JobViewData> lstJobView = new List<MRS_CADService.JobViewData>();
            MRS_CADService.JobViewData tempjobView = new MRS_CADService.JobViewData();
            tempjobView.jobViewGroup = 'Customer';
            tempjobView.jobViewType = 'Mask_Layout';
            tempjobView.jobViewRemarks = 'testViewRemarks';
            tempjobView.jobDecks = lstJobDeck;
            tempjobView.emailToList = 'testEmailLists';
            tempjobView.ptrf = tempPtrf;
            lstJobView.add(tempjobView);
                        
            List<MRS_CADService.MRSDataRecievedOnSyncRemoteJobView> lstSendResmoteJob = new List<MRS_CADService.MRSDataRecievedOnSyncRemoteJobView>();  
            MRS_CADService.MRSDataRecievedOnSyncRemoteJobView tempRemoteJobView = new MRS_CADService.MRSDataRecievedOnSyncRemoteJobView();
            tempRemoteJobView.messageID = 'testmsg01';
            tempRemoteJobView.maskSetTitle = mst.Name;
            tempRemoteJobView.sourceInboundRequestTimestamp = system.now();
            tempRemoteJobView.jobView = lstJobView;
            lstSendResmoteJob.add(tempRemoteJobView);
            
        //MRS_CADService.sync_Remote_Jobview_Setup_Ready(lstSendResmoteJob);

     // test sync_Receive_MEBES_Data_from_Maskshop()
        
            
            List<MRS_CADService.MRSDataRecievedOnSyncMEBESReceive> lstSyncMEBES = new List<MRS_CADService.MRSDataRecievedOnSyncMEBESReceive>();
            MRS_CADService.MRSDataRecievedOnSyncMEBESReceive tmepSyncMEBES = new MRS_CADService.MRSDataRecievedOnSyncMEBESReceive();
            tmepSyncMEBES.messageID = 'testmsg01';
            tmepSyncMEBES.maskSetTitle = mst.Name;
            tmepSyncMEBES.sourceInboundRequestTimestamp = system.now();
            tmepSyncMEBES.jobdecks = lstJobDeck;
            tmepSyncMEBES.jobViewRemarks = 'testjobViewRemarks';
            tmepSyncMEBES.ptrf = tempPtrf;
            tmepSyncMEBES.customerJobViewAtFoundry = true;
            lstSyncMEBES.add(tmepSyncMEBES);
        //Test.startTest();
       // MRS_CADService.sync_Receive_MEBES_Data_from_Maskshop(lstSyncMEBES);
        //Test.stopTest();
      // Test sync_ORCN_Job_Status_Change()
            List<MRS_CADService.MRSDataRecievedOnORCNStatusChange> lstORCNStatusChange = new List<MRS_CADService.MRSDataRecievedOnORCNStatusChange>();
            MRS_CADService.MRSDataRecievedOnORCNStatusChange tempORCNStatus= new MRS_CADService.MRSDataRecievedOnORCNStatusChange();
            tempORCNStatus.messageID = 'testmsg01';
            tempORCNStatus.maskSetTitle = mst.Name;
            tempORCNStatus.ptrf = tempPtrf;
        tempORCNStatus.sourceInboundRequestTimestamp = system.now();    
            lstORCNStatusChange.add(tempORCNStatus);
     
        //MRS_CADService.sync_ORCN_Job_Status_Change(lstORCNStatusChange);     
        }
}
      
}