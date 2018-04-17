@isTest(seeAllData=TRUE)
global class PTRF_DotNetServiceClassTest{
    
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
               MRSdotNETResponseCalloutService.SendSFDCStatusResponse_element  respElement = 
               new MRSdotNETResponseCalloutService.SendSFDCStatusResponse_element();
               respElement.SendSFDCStatusResponseState = 'Mock Response';
               response.put('response_x',respElement); 
               }
            }
      // Testing web service callout
        public static String callEchoString(String input){          
        MRSdotNETResponseCalloutService.SwiftMRSPTRFSyncResponseService_pt sample = new MRSdotNETResponseCalloutService.SwiftMRSPTRFSyncResponseService_pt();
        sample.endpoint_x = Environment_Variable__c.getInstance('SWIFTdotNET_EndPoint').value__c;
        String echo = 'Mock Response';
        return echo;
        }      
    Public static TestMethod void testPTRF_DotNetService(){
    Test.setMock(WebServiceMock.class, new WebServiceMockImplNew());
    String output = callEchoString('Mock Response');
    System.assertEquals('Mock Response', output);
    list<HCM_Employee__c> hcmEmp = new list<HCM_Employee__c>();
    list<User> userHcm = new list<User>();
    User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
    System.runAs ( thisUser ) 
    {
         //test.startTest();
         hcmEmp = SwiftDataUtilityTest.createHCMEmployee(2);
    }
   // SwiftDataUtilityTest.customSystemData();
    // Insert PTRF record
    
    PTRF__c ptrf1 = new PTRF__c(Name='APTUS1',Order_Type__c = 'testOrder1',Recticle_Type__c='Small Field Reticle (SFR)',Customer_jobview__c='Gating Mask Release',Tech_Geo_Value__c='0.07', Process_id__c='test122');
    insert ptrf1;
    
    //PTRF__c ptrf1 = new PTRF__c(Name='APTUS1',Customer_jobview__c='Gating Mask Release',Tech_Geo_Value__c='0.07');
   // insert ptrf1;
    
    Process__c process1=new Process__c(name='test122',Process_Technology__c='test01');
    insert process1;
    Process_Technology__c pt = new Process_Technology__c (Name ='test01',Lifecycle__c='Sandbox' );
    insert pt;
    pt.Lifecycle__c = 'Production';
    update pt;
    
     PTRF_JobViewer_Info__c ptrfJV = new PTRF_JobViewer_Info__c(PTRF__c = ptrf1.id,Jobview_Type__c = 'Frame Mockup',Jobview__c = 'Customer',User__c = UserInfo.getUserId());
    insert ptrfJV;
    PTRF_JobViewer_Info__c ptrfJV1 = new PTRF_JobViewer_Info__c(PTRF__c = ptrf1.id,Jobview_Type__c = 'Frame Mockup',Jobview__c = 'Foundry',User__c = UserInfo.getUserId());
    insert ptrfJV1;
    
    PTRF_JobViewer_Info__c ptrfJV2 = new PTRF_JobViewer_Info__c(PTRF__c = ptrf1.id,Jobview_Type__c = 'ProcessOwner',Jobview__c = 'Foundry',User__c = UserInfo.getUserId());
    insert ptrfJV2;
    
    //PTRF_JobViewer_Info__c ptrfJV3 = new PTRF_JobViewer_Info__c(PTRF__c = ptrf1.id,Jobview_Type__c = 'Foundry',Jobview__c = 'Foundry',User__c = UserInfo.getUserId());
    //insert ptrfJV3;
    

                                                                      
    Test.StartTest();
    PTRF_DotNetService.ResponseData responseData= new PTRF_DotNetService.ResponseData();
    responseData.messageId = 'testMsgId';
    responseData.ptrfNumber = 'aptus';
    responseData.status = 'ERROR';
    responseData.errorMessage = 'tstError';
    PTRF_DotNetService.PTRFData ptrf = new PTRF_DotNetService.PTRFData();
    ptrf.ptrfNumber = 'aptus';
    ptrf.maskSetTitle ='TESTU';
    ptrf.reticleType='Single Layer Reticle (SLR)';
    ptrf.primeDRT='testPrime';
    ptrf.frameDRT='testFrame';
    ptrf.techGeo='0.02';
    ptrf.orderType='testOrder';
    ptrf.primeTapeout=true;
    ptrf.primeGDSOUT_Review=true;
    ptrf.frameTapeout=true;
    ptrf.frameMockup=true;
    ptrf.frameGDSOUT_Review=true;
    ptrf.DRC_Only=true;
    ptrf.bumpRequest=true;
    ptrf.accountShortName='bcmsgp';
    //ptrf.orderStatus='Open';
    ptrf.orderStatus='Perform Tapeout Options';
    ptrf.customerJobView='testJobView';
    ptrf.processOwnerJobview='testOwnerJobView';
    ptrf.CRMDID='testCrmId';
    ptrf.deviceId='testDeviceId';
    List<PTRF_DotNetService.MaskLayerData> lstMaskLayerData = new List<PTRF_DotNetService.MaskLayerData>();
    PTRF_DotNetService.MaskLayerData maskLayer = new PTRF_DotNetService.MaskLayerData();
    maskLayer.maskLayerName = 'testMaskLayerName';
    maskLayer.maskLayerNumber = '1001';
    maskLayer.maskRev = '10';
    maskLayer.romCode = '20';
    maskLayer.sortOrder = 1;
    maskLayer.tapeoutFlag = true;
    maskLayer.logicalOperation = 'testoperation';
    maskLayer.logicalOperationType = 'testType';
    lstMaskLayerData.add(maskLayer);
    List<PTRF_DotNetService.PrimeDieData> lstPrimeDie = new List<PTRF_DotNetService.PrimeDieData>();
    PTRF_DotNetService.PrimeDieData prmDie = new PTRF_DotNetService.PrimeDieData();
    prmDie.primeDieName = 'testPrimeDieName';
    prmDie.tapeoutFlag = true;
    lstPrimeDie.add(prmdie);
    List<PTRF_DotNetService.ScribelineDropinsData> lstscribelineDropins = new List<PTRF_DotNetService.ScribelineDropinsData>();
    PTRF_DotNetService.ScribelineDropinsData scribelineDropins = new PTRF_DotNetService.ScribelineDropinsData();
    scribelineDropins.scribelineName = 'testscribeLine';
    scribelineDropins.tapeoutFlag = true;
    lstscribelineDropins.add(scribelineDropins);
    List<PTRF_DotNetService.PTRFDataRecievedOnPerformTapeout> lstPtrfDataReceived = new List<PTRF_DotNetService.PTRFDataRecievedOnPerformTapeout>();
    PTRF_DotNetService.PTRFDataRecievedOnPerformTapeout ptrfDataReceived = new PTRF_DotNetService.PTRFDataRecievedOnPerformTapeout();
    ptrfDataReceived.messageID = 'testMsg';
    ptrfDataReceived.action = 'testAction';
    ptrfDataReceived.ptrf = ptrf;
    ptrfDataReceived.ptrf.processid ='test122';
    ptrfDataReceived.maskLayers = lstMaskLayerData;
    ptrfDataReceived.primeDies = lstPrimeDie;
    ptrfDataReceived.scribelineDropins = lstscribelineDropins;
    lstPtrfDataReceived.add(ptrfDataReceived);
    PTRF_DotNetService.sync_PTRF_Status_PerformTapeoutOptions(lstPtrfDataReceived);
    
    // Test sync_PTRF_Chip_MaskLayer_Deselected  
    List<PTRF_DotNetService.PTRFDataRecievedDiesLayersDeselected> lstPtrfDiesLayer = new List<PTRF_DotNetService.PTRFDataRecievedDiesLayersDeselected>();
    PTRF_DotNetService.PTRFDataRecievedDiesLayersDeselected PtrfDiesLayer = new PTRF_DotNetService.PTRFDataRecievedDiesLayersDeselected();
    PtrfDiesLayer.messageID = 'testMsg';
    PtrfDiesLayer.ptrfnumber='aptus';
    PtrfDiesLayer.maskLayers = lstMaskLayerData;
    PtrfDiesLayer.primeDies = lstPrimeDie;
    PtrfDiesLayer.scribelineDropins = lstscribelineDropins;
    lstPtrfDiesLayer.add(PtrfDiesLayer);
    PTRF_DotNetService.sync_PTRF_Chip_MaskLayer_Deselected(lstPtrfDiesLayer);
    
    // Test sync_PTRF_NewJobView_ChangesInJobView
    List<PTRF_DotNetService.Jobviewer> lstJobViewer = new List<PTRF_DotNetService.Jobviewer>();
    PTRF_DotNetService.Jobviewer jobViewer = new PTRF_DotNetService.JobViewer();
    jobViewer.jobviewType = 'ProcessOwner';
    jobViewer.MEBES = true;
    jobViewer.userId = UserInfo.getUserId();
    jobViewer.emailAddress = 'satyajit.kumarsingh@cognizant.com';
    jobViewer.GDSOUT =true;
    jobViewer.frameMockup = true;
    lstJobViewer.add(jobViewer);
    List<PTRF_DotNetService.PTRFDataRecievedOnJobviewDataChange> lstJobViewData = new List<PTRF_DotNetService.PTRFDataRecievedOnJobviewDataChange>();
    PTRF_DotNetService.PTRFDataRecievedOnJobviewDataChange JobViewData = new PTRF_DotNetService.PTRFDataRecievedOnJobviewDataChange();
    JobViewData.messageID = 'testMsg';
    JobViewData.ptrfnumber='aptus';
    JobViewData.customerJobview = 'testCustomerJobview';
    JobViewData.processOwnerJobview = 'testProcessOwnerJobView';
    JobViewData.jobviewers = lstJobViewer;
    lstJobViewData.add(JobViewData);
    
    PTRF_DotNetService.PTRFDataRecievedOnJobviewDataChange JobViewData1 = new PTRF_DotNetService.PTRFDataRecievedOnJobviewDataChange();
    JobViewData1.messageID = 'testMsg1';
    //JobViewData.ptrfnumber='aptus';
    //JobViewData.customerJobview = 'testCustomerJobview';
    //JobViewData.processOwnerJobview = 'testProcessOwnerJobView';
    //JobViewData.jobviewers = lstJobViewer;
    lstJobViewData.add(JobViewData1);
    PTRF_DotNetService.sync_PTRF_NewJobView_ChangesInJobView(lstJobViewData);
    Test.StopTest();
    }
    
    //Testing lstPTRF size == 0
    Public static TestMethod void testIsListPTRFempty(){
        
        list<HCM_Employee__c> hcmEmp = new list<HCM_Employee__c>();
    list<User> userHcm = new list<User>();
    User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
    System.runAs ( thisUser ) 
    {
         //test.startTest();
         hcmEmp = SwiftDataUtilityTest.createHCMEmployee(2);
    }
   // SwiftDataUtilityTest.customSystemData();
    Mask_Set_Title__c mst = SwiftDataUtilityTest.createMST('TESTU');
    insert mst;
    DRT__c drt1 = new DRT__c(Name='testFrame',Synced_with_Oracle_DB__c=false,
                             DRT_Package_Sync__c=false,Status__c='Active',Mask_Set_Title__c = mst.Id);          
    insert drt1; 
    DRT__c drt2 = new DRT__c(Name='testPrime',Synced_with_Oracle_DB__c=false,
                             DRT_Package_Sync__c=false,Status__c='Active',Mask_Set_Title__c = mst.Id);          
    insert drt2; 
    Test.StartTest();
    
    List<PTRF_DotNetService.Jobviewer> lstJobViewer = new List<PTRF_DotNetService.Jobviewer>();
    PTRF_DotNetService.Jobviewer jobviewer = new PTRF_DotNetService.Jobviewer();
    jobviewer.jobviewType ='Customer';
    jobviewer.MEBES =False;
    jobviewer.userId = hcmEmp[0].Employee_ID__c;
    jobviewer.emailAddress = hcmEmp[0].Email_Address__c ;
    jobviewer.GDSOUT = True;
    jobviewer.frameMockup = True;
    lstJobViewer.add(jobviewer);

    PTRF_DotNetService.Jobviewer jobviewer2 = new PTRF_DotNetService.Jobviewer();
    jobviewer2.jobviewType ='Foundry';
    jobviewer2.MEBES =False;
    jobviewer2.userId = hcmEmp[0].Employee_ID__c;
    jobviewer2.emailAddress = hcmEmp[0].Email_Address__c ;
    jobviewer2.GDSOUT = True;
    jobviewer2.frameMockup = True;
    lstJobViewer.add(jobviewer2);
    
    PTRF_DotNetService.PTRFData ptrf = new PTRF_DotNetService.PTRFData();
    ptrf.ptrfNumber = 'cdsa';
    ptrf.maskSetTitle ='TESTU';
    ptrf.reticleType='Single Layer Reticle (SLR)';
    ptrf.primeDRT='testPrime';
    ptrf.frameDRT='testFrame';
    ptrf.techGeo='0.05';
    ptrf.orderType='testOrder';
    ptrf.primeTapeout=true;
    ptrf.primeGDSOUT_Review=true;
    ptrf.frameTapeout=true;
    ptrf.frameMockup=true;
    ptrf.frameGDSOUT_Review=true;
    ptrf.DRC_Only=true;
    ptrf.bumpRequest=true;
    ptrf.accountShortName='bcmsgp';
    //ptrf.orderStatus='Open';
    ptrf.OrderStatus='Perform Tapeout Options';
    ptrf.customerJobView='testJobView';
    ptrf.processOwnerJobview='testOwnerJobView';
    ptrf.CRMDID='testCrmId';
    ptrf.deviceId='testDeviceId';
    List<PTRF_DotNetService.MaskLayerData> lstMaskLayerData = new List<PTRF_DotNetService.MaskLayerData>();
    PTRF_DotNetService.MaskLayerData maskLayer = new PTRF_DotNetService.MaskLayerData();
    maskLayer.maskLayerName = 'testMaskLayerName';
    maskLayer.maskLayerNumber = '1001';
    maskLayer.maskRev = '10';
    maskLayer.romCode = '20';
    maskLayer.sortOrder = 1;
    maskLayer.tapeoutFlag = true;
    maskLayer.logicalOperation = 'testoperation';
    maskLayer.logicalOperationType = 'testType';
    lstMaskLayerData.add(maskLayer);
    List<PTRF_DotNetService.PrimeDieData> lstPrimeDie = new List<PTRF_DotNetService.PrimeDieData>();
    PTRF_DotNetService.PrimeDieData prmDie = new PTRF_DotNetService.PrimeDieData();
    prmDie.primeDieName = 'testPrimeDieName';
    prmDie.tapeoutFlag = true;
    lstPrimeDie.add(prmdie);
    List<PTRF_DotNetService.ScribelineDropinsData> lstscribelineDropins = new List<PTRF_DotNetService.ScribelineDropinsData>();
    PTRF_DotNetService.ScribelineDropinsData scribelineDropins = new PTRF_DotNetService.ScribelineDropinsData();
    scribelineDropins.scribelineName = 'testscribeLine';
    scribelineDropins.tapeoutFlag = true;
    lstscribelineDropins.add(scribelineDropins);
    List<PTRF_DotNetService.PTRFDataRecievedOnPerformTapeout> lstPtrfDataReceived = new List<PTRF_DotNetService.PTRFDataRecievedOnPerformTapeout>();
    PTRF_DotNetService.PTRFDataRecievedOnPerformTapeout ptrfDataReceived = new PTRF_DotNetService.PTRFDataRecievedOnPerformTapeout();
    ptrfDataReceived.messageID = 'testMsg';
    ptrfDataReceived.action = 'testAction';
    ptrfDataReceived.ptrf = ptrf;
    ptrfDataReceived.ptrf.processid ='test122';
    ptrfDataReceived.jobviewers = lstJobViewer;
    ptrfDataReceived.maskLayers = lstMaskLayerData;
    ptrfDataReceived.primeDies = lstPrimeDie;
    ptrfDataReceived.scribelineDropins = lstscribelineDropins;
    lstPtrfDataReceived.add(ptrfDataReceived);
    PTRF_DotNetService.sync_PTRF_Status_PerformTapeoutOptions(lstPtrfDataReceived);
    
    PTRF_DotNetService.PTRFData ptrf1 = new PTRF_DotNetService.PTRFData();
    ptrf1.ptrfNumber = 'cdsa';
    ptrf1.maskSetTitle ='TESTU';
    ptrf1.reticleType='Single Layer Reticle (SLR)';
    ptrf1.primeDRT='testPrime';
    ptrf1.frameDRT='testFrame';
    ptrf1.techGeo='0.06';
    ptrf1.orderType='testOrder';
    ptrf1.primeTapeout=false;
    ptrf1.primeGDSOUT_Review=true;
    ptrf1.frameTapeout=true;
    ptrf1.frameMockup=true;
    ptrf1.frameGDSOUT_Review=true;
    ptrf1.DRC_Only=true;
    ptrf1.bumpRequest=true;
    ptrf1.accountShortName='bcmsgp';
    ptrf1.orderStatus='Perform Tapeout Options';
    ptrf1.customerJobView='testJobView';
    ptrf1.processOwnerJobview='testOwnerJobView';
    ptrf1.CRMDID='testCrmId';
    ptrf1.deviceId='testDeviceId';
    List<PTRF_DotNetService.MaskLayerData> lstMaskLayerData1 = new List<PTRF_DotNetService.MaskLayerData>();
    PTRF_DotNetService.MaskLayerData maskLayer1 = new PTRF_DotNetService.MaskLayerData();
    maskLayer1.maskLayerName = 'testMaskLayerName';
    maskLayer1.maskLayerNumber = '1001';
    maskLayer1.maskRev = '10';
    maskLayer1.romCode = '20';
    maskLayer1.sortOrder = 1;
    maskLayer1.tapeoutFlag = true;
    maskLayer1.logicalOperation = 'testoperation';
    maskLayer1.logicalOperationType = 'testType';
    lstMaskLayerData1.add(maskLayer1);
    List<PTRF_DotNetService.PrimeDieData> lstPrimeDie1 = new List<PTRF_DotNetService.PrimeDieData>();
    PTRF_DotNetService.PrimeDieData prmDie1 = new PTRF_DotNetService.PrimeDieData();
    prmDie1.primeDieName = 'testPrimeDieName';
    prmDie1.tapeoutFlag = true;
    lstPrimeDie1.add(prmdie1);
    List<PTRF_DotNetService.ScribelineDropinsData> lstscribelineDropins1 = new List<PTRF_DotNetService.ScribelineDropinsData>();
    PTRF_DotNetService.ScribelineDropinsData scribelineDropins1 = new PTRF_DotNetService.ScribelineDropinsData();
    scribelineDropins1.scribelineName = 'testscribeLine';
    scribelineDropins1.tapeoutFlag = true;
    lstscribelineDropins1.add(scribelineDropins1);
    List<PTRF_DotNetService.PTRFDataRecievedOnPerformTapeout> lstPtrfDataReceived1 = new List<PTRF_DotNetService.PTRFDataRecievedOnPerformTapeout>();
    PTRF_DotNetService.PTRFDataRecievedOnPerformTapeout ptrfDataReceived1 = new PTRF_DotNetService.PTRFDataRecievedOnPerformTapeout();
    ptrfDataReceived1.messageID = 'testMsg';
    ptrfDataReceived1.action = 'testAction';
    ptrfDataReceived1.ptrf = ptrf;
    ptrfDataReceived1.ptrf.processid ='test122';
    ptrfDataReceived1.jobviewers = lstJobViewer;
    ptrfDataReceived1.maskLayers = lstMaskLayerData;
    ptrfDataReceived1.primeDies = lstPrimeDie;
    ptrfDataReceived1.scribelineDropins = lstscribelineDropins;
    lstPtrfDataReceived1.add(ptrfDataReceived1);
    PTRF_DotNetService.sync_PTRF_Status_PerformTapeoutOptions(lstPtrfDataReceived1);
    
    
    List<PTRF_DotNetService.PTRFDataRecievedOnJobviewDataChange> lstJobViewData = new List<PTRF_DotNetService.PTRFDataRecievedOnJobviewDataChange>();
    PTRF_DotNetService.PTRFDataRecievedOnJobviewDataChange JobViewData = new PTRF_DotNetService.PTRFDataRecievedOnJobviewDataChange();
    JobViewData.messageID = 'testMsg';
    JobViewData.ptrfnumber='aptus';
    JobViewData.customerJobview = 'testCustomerJobview';
    JobViewData.processOwnerJobview = 'testProcessOwnerJobView';
    JobViewData.jobviewers = lstJobViewer;
    lstJobViewData.add(JobViewData);
    PTRF_DotNetService.sync_PTRF_NewJobView_ChangesInJobView(lstJobViewData);
    System.assertEquals('testMsg', JobViewData.messageID);    
    Test.StopTest();  
    PTRF_DotNetService.serviceResponse('testMessageID','PTRF-007','ERROR','Error Not Found!');    
    }
    
    //Testing lstPTRF size == 0
    Public static TestMethod void TestPerformTapeoutOptions(){
    list<HCM_Employee__c> hcmEmp = new list<HCM_Employee__c>();
    list<User> userHcm = new list<User>();
    User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
    System.runAs ( thisUser ) 
    {
         //test.startTest();
         hcmEmp = SwiftDataUtilityTest.createHCMEmployee(2);
    }
    //SwiftDataUtilityTest.customSystemData();
        
    Mask_Set_Title__c mst = SwiftDataUtilityTest.createMST('TESTU');
    insert mst;
    DRT__c drt1 = new DRT__c(Name='testFrame',Synced_with_Oracle_DB__c=false,
                             DRT_Package_Sync__c=false,Status__c='Active',Mask_Set_Title__c = mst.Id);          
    insert drt1; 
    DRT__c drt2 = new DRT__c(Name='testPrime',Synced_with_Oracle_DB__c=false,
                             DRT_Package_Sync__c=false,Status__c='Active',Mask_Set_Title__c = mst.Id);          
    insert drt2; 
    Test.StartTest();
    
    List<PTRF_DotNetService.Jobviewer> lstJobViewer = new List<PTRF_DotNetService.Jobviewer>();
    PTRF_DotNetService.Jobviewer jobviewer = new PTRF_DotNetService.Jobviewer();
    jobviewer.jobviewType ='Customer';
    jobviewer.MEBES =False;
    jobviewer.userId = hcmEmp[0].Employee_ID__c;
    jobviewer.emailAddress = hcmEmp[0].Email_Address__c ;
    jobviewer.GDSOUT = True;
    jobviewer.frameMockup = True;
    lstJobViewer.add(jobviewer);

    PTRF_DotNetService.Jobviewer jobviewer2 = new PTRF_DotNetService.Jobviewer();
    jobviewer2.jobviewType ='Foundry';
    jobviewer2.MEBES =False;
    jobviewer2.userId = hcmEmp[0].Employee_ID__c;
    jobviewer2.emailAddress = hcmEmp[0].Email_Address__c ;
    jobviewer2.GDSOUT = True;
    jobviewer2.frameMockup = True;
    lstJobViewer.add(jobviewer2);
    
    PTRF_DotNetService.PTRFData ptrf = new PTRF_DotNetService.PTRFData();
    ptrf.ptrfNumber = 'cdsa';
    ptrf.maskSetTitle ='MYMST';
    ptrf.reticleType='Single Layer Reticle (SLR)';
    ptrf.primeDRT='testPrime';
    ptrf.frameDRT='testFrame';
    ptrf.techGeo='0.02';
    ptrf.orderType='testOrder';
    ptrf.primeTapeout=true;
    ptrf.primeGDSOUT_Review=true;
    ptrf.frameTapeout=false;
    ptrf.frameMockup=true;
    ptrf.frameGDSOUT_Review=true;
    ptrf.DRC_Only=true;
    ptrf.bumpRequest=true;
    ptrf.accountShortName='bcmsgp';
    ptrf.orderStatus='Open';
    ptrf.customerJobView='testJobView';
    ptrf.processOwnerJobview='testOwnerJobView';
    ptrf.CRMDID='testCrmId';
    ptrf.deviceId='testDeviceId';
    List<PTRF_DotNetService.MaskLayerData> lstMaskLayerData = new List<PTRF_DotNetService.MaskLayerData>();
    PTRF_DotNetService.MaskLayerData maskLayer = new PTRF_DotNetService.MaskLayerData();
    maskLayer.maskLayerName = 'testMaskLayerName';
    maskLayer.maskLayerNumber = '1001';
    maskLayer.maskRev = '10';
    maskLayer.romCode = '20';
    maskLayer.sortOrder = 1;
    maskLayer.tapeoutFlag = true;
    maskLayer.logicalOperation = 'testoperation';
    maskLayer.logicalOperationType = 'testType';
    lstMaskLayerData.add(maskLayer);
    List<PTRF_DotNetService.PrimeDieData> lstPrimeDie = new List<PTRF_DotNetService.PrimeDieData>();
    PTRF_DotNetService.PrimeDieData prmDie = new PTRF_DotNetService.PrimeDieData();
    prmDie.primeDieName = 'testPrimeDieName';
    prmDie.tapeoutFlag = true;
    lstPrimeDie.add(prmdie);
    List<PTRF_DotNetService.ScribelineDropinsData> lstscribelineDropins = new List<PTRF_DotNetService.ScribelineDropinsData>();
    PTRF_DotNetService.ScribelineDropinsData scribelineDropins = new PTRF_DotNetService.ScribelineDropinsData();
    scribelineDropins.scribelineName = 'testscribeLine';
    scribelineDropins.tapeoutFlag = true;
    lstscribelineDropins.add(scribelineDropins);
    List<PTRF_DotNetService.PTRFDataRecievedOnPerformTapeout> lstPtrfDataReceived = new List<PTRF_DotNetService.PTRFDataRecievedOnPerformTapeout>();
    PTRF_DotNetService.PTRFDataRecievedOnPerformTapeout ptrfDataReceived1 = new PTRF_DotNetService.PTRFDataRecievedOnPerformTapeout();
    ptrfDataReceived1.messageID = 'testMsg01';
    ptrfDataReceived1.action = 'testAction1';
    ptrfDataReceived1.ptrf = ptrf;
    ptrfDataReceived1.ptrf.processid ='test121';
    ptrfDataReceived1.ptrf.orderStatus='Perform Tapeout Options';  
    ptrfDataReceived1.jobviewers = lstJobViewer;
    ptrfDataReceived1.maskLayers = lstMaskLayerData;
    ptrfDataReceived1.primeDies = lstPrimeDie;
    ptrfDataReceived1.scribelineDropins = lstscribelineDropins;
    lstPtrfDataReceived.add(ptrfDataReceived1);
    
    PTRF_DotNetService.PTRFDataRecievedOnPerformTapeout ptrfDataReceived2 = new PTRF_DotNetService.PTRFDataRecievedOnPerformTapeout();
    ptrfDataReceived2.messageID = 'testMsg02';
    ptrfDataReceived2.action = 'testAction2';
    ptrfDataReceived2.ptrf = ptrf;
    ptrfDataReceived2.ptrf.processid ='test122';
    ptrfDataReceived2.ptrf.orderStatus='Open'; 
    ptrfDataReceived2.jobviewers = lstJobViewer;
    ptrfDataReceived2.maskLayers = lstMaskLayerData;
    ptrfDataReceived2.primeDies = lstPrimeDie;
    ptrfDataReceived2.scribelineDropins = lstscribelineDropins;
    lstPtrfDataReceived.add(ptrfDataReceived2);
    PTRF_DotNetService.Sync_PTRF_Status_PerformTapeoutOptions(lstPtrfDataReceived);
    }
     public static testMethod void testMaskLayerDeselection() 
     {
      Mask_Set_Title__c mst = SwiftDataUtilityTest.createMST('TESTU');
         insert mst;
         
         list<ptrf__c> ptrfs = new list<ptrf__c>();
     PTRF__c ptrf1 = new PTRF__c(Name='APTUS1',Mask_Set_Title__c = mst.id,Order_Type__c = 'testOrder1',Recticle_Type__c='Small Field Reticle (SFR)',Customer_jobview__c='Gating Mask Release',Tech_Geo_Value__c='0.04');
    //insert ptrf1;
    
    PTRF__c ptrf2 = new PTRF__c(Name='ABC2D',Order_Type__c = 'testOrder2',Recticle_Type__c='Multi Layer Reticle (MLR)',Customer_jobview__c='Gating Mask Release');
          //insert ptrf2;
          
          
          ptrfs.add(ptrf1);
          ptrfs.add(ptrf2);
          
          insert ptrfs;
          
    
     DRT__c drt1 = new DRT__c(Name='testFrame',Synced_with_Oracle_DB__c=false,
                                     DRT_Package_Sync__c=false,Status__c='Active',Mask_Set_Title__c = mst.Id);          
            insert drt1; 
            DRT__c drt2 = new DRT__c(Name='Frame',Synced_with_Oracle_DB__c=false,
                                     DRT_Package_Sync__c=false,Status__c='Active',Mask_Set_Title__c = mst.Id);          
            insert drt2; 
          
          ////
          //PTRF__c ptrf2 = new PTRF__c(Name='ABC2D',Order_Type__c = 'testOrder2',Recticle_Type__c='Multi Layer Reticle (MLR)',Customer_jobview__c='Gating Mask Release');
          //insert ptrf2;
          ////
          DRT_PTRF_Association__c drtPtrfIns = new DRT_PTRF_Association__c();
          drtPtrfIns.DRT__c = drt1.id;
          drtPtrfIns.PTRF__c = ptrf1.id;
          insert drtPtrfIns ;
          
          DRT_PTRF_Association__c drtPtrfIns2 = new DRT_PTRF_Association__c();
          drtPtrfIns2.DRT__c = drt2.id;
          drtPtrfIns2.PTRF__c = ptrf1.id;
          insert drtPtrfIns2 ;
    
    Process__c process1=new Process__c(name='test122',Process_Technology__c='test11');
    insert process1;
    
    MRS__c mrs1 = new MRS__c(Full_Sync__c =true,
                                   Synced_with_Oracle_DB__c=false,
                                   MRS_Package_Sync__c=false,
                                   Mask_Set_Title__c=mst.Id);
          insert mrs1;                             
          MRS_Layer_Association__c mrsLayer1 = new MRS_Layer_Association__c(Name ='layer001',
                                                                           Synced_with_Oracle_DB__c=false,
                                                                           Mask_Layer_Rev__c = '899',ROM_Code__c='123',
                                                                           Layer_Name__c = 'layer001',
                                                                           Layer_Status__c = 'Not Ready',
                                                                           mrs__c = mrs1.id);
          insert mrslayer1;  
          MRS_Layer_Association__c mrsLayer2 = new MRS_Layer_Association__c(Name ='layer002',
                                                                           Synced_with_Oracle_DB__c=false,
                                                                           Mask_Layer_Rev__c = '900',
                                                                           Layer_Name__c = 'layer002',
                                                                           Layer_Status__c = 'Not Ready',
                                                                           mrs__c = mrs1.id);
          insert mrslayer2; 
          MRS_Layer_Association__c mrsLayer21 = new MRS_Layer_Association__c(Name ='layer003',
                                                                           Synced_with_Oracle_DB__c=false,
                                                                           Mask_Layer_Rev__c = '900',
                                                                           Layer_Name__c = 'Frame',
                                                                           Layer_Status__c = 'Not Ready',
                                                                           mrs__c = mrs1.id);
          insert mrslayer21;
          MRS_Layer_Association__c mrsLayer22 = new MRS_Layer_Association__c(Name ='layer004',
                                                                           Synced_with_Oracle_DB__c=false,
                                                                           Mask_Layer_Rev__c = '900',
                                                                           Layer_Name__c = 'Frame',ROM_Code__c='123',
                                                                           Layer_Status__c = 'Not Ready',
                                                                           mrs__c = mrs1.id);
          insert mrslayer22; 
                                                                                                                                          
          MRS_Chip_Details__c mrsChip1 = new MRS_Chip_Details__c(Name='chip001',
                                                                Synced_with_Oracle_DB__c=false,
                                                                mrs__c = mrs1.id);
          insert mrsChip1; 
           MRS_Chip_Details__c mrsChip2 = new MRS_Chip_Details__c(Name='chip002',
                                                                Synced_with_Oracle_DB__c=false,
                                                                mrs__c = mrs1.id);
          insert mrsChip2; 
          MRS_Chip_Details__c mrsChip3 = new MRS_Chip_Details__c(Name='chip003',
                                                                Synced_with_Oracle_DB__c=false,
                                                                mrs__c = mrs1.id);
          insert mrsChip3;                                                     
          MRS_Layer_Chip_Association__c layerChip1 = new MRS_Layer_Chip_Association__c(Name='layerChip001',
                                                                                      Synced_with_Oracle_DB__c=false,
                                                                                      Send_Prime_Data__c = 'Not Done',DRT__c=drt2.id,
                                                                                      Last_Sync_Req_Timestamp_Send_Prime__c = System.now().addHours(1),
                                                                                      Last_Sync_Req_Timestamp_Layer_Gen__c = System.now().addHours(3),
                                                                                      Last_Sync_Req_Timestamp_Send_Frame__c = System.now().addHours(2),
                                                                                      Foundry_GDSOUT_Review__c = 'Not Ready',
                                                                                      //Mask_Layer__c = 'layer002',
                                                                                      Layer__c=mrsLayer1.Id,
                                                                                      Chip__c=mrsChip1.Id,
                                                                                      PTRF__c=ptrf1.Id);

          insert layerChip1;
          
          MRS_Layer_Chip_Association__c layerChip2 = new MRS_Layer_Chip_Association__c(Name='layerChip001',
                                                                                      Synced_with_Oracle_DB__c=false,
                                                                                      Send_Prime_Data__c = 'Not Done',DRT__c=drt1.id,
                                                                                      Last_Sync_Req_Timestamp_Send_Prime__c = System.now().addHours(1),
                                                                                      Last_Sync_Req_Timestamp_Layer_Gen__c = System.now().addHours(3),
                                                                                      Last_Sync_Req_Timestamp_Send_Frame__c = System.now().addHours(2),
                                                                                      Foundry_GDSOUT_Review__c = 'Not Ready',
                                                                                      Layer__c=mrsLayer1.Id,
                                                                                      //Mask_Layer__c = 'layer001',
                                                                                      Chip__c=mrsChip3.Id,
                                                                                      PTRF__c=ptrf1.Id);

          insert layerChip2;
          MRS_Layer_Chip_Association__c layerChip3 = new MRS_Layer_Chip_Association__c(Name='layerChip001',
                                                                                      Synced_with_Oracle_DB__c=false,
                                                                                      Send_Prime_Data__c = 'Not Done',
                                                                                      Last_Sync_Req_Timestamp_Send_Prime__c = System.now().addHours(1),
                                                                                      Last_Sync_Req_Timestamp_Layer_Gen__c = System.now().addHours(3),
                                                                                      Last_Sync_Req_Timestamp_Send_Frame__c = System.now().addHours(2),
                                                                                      Foundry_GDSOUT_Review__c = 'Not Ready',
                                                                                      Layer__c=mrsLayer1.Id,
                                                                                      //Mask_Layer__c = 'layer001',
                                                                                      Chip__c=mrsChip2.Id,
                                                                                      PTRF__c=ptrf1.Id);

          insert layerChip3;
          
           MRS_Layer_Chip_Association__c layerChip4 = new MRS_Layer_Chip_Association__c(Name='layerChip001',
                                                                                      Synced_with_Oracle_DB__c=false,
                                                                                      Send_Prime_Data__c = 'Not Done',
                                                                                      Last_Sync_Req_Timestamp_Send_Prime__c = System.now().addHours(1),
                                                                                      Last_Sync_Req_Timestamp_Layer_Gen__c = System.now().addHours(3),
                                                                                      Last_Sync_Req_Timestamp_Send_Frame__c = System.now().addHours(2),
                                                                                      Foundry_GDSOUT_Review__c = 'Not Ready',
                                                                                      Layer__c=mrsLayer2.Id,
                                                                                      Chip__c=mrsChip2.Id,
                                                                                      //Mask_Layer__c = 'layer002',
                                                                                      PTRF__c=ptrf1.Id);

          insert layerChip4;
           MRS_Layer_Chip_Association__c layerChip21 = new MRS_Layer_Chip_Association__c(Name='frame',
                                                                                      Synced_with_Oracle_DB__c=false,
                                                                                      Send_Prime_Data__c = 'Not Done',DRT__c=drt1.id,
                                                                                      Last_Sync_Req_Timestamp_Send_Prime__c = System.now().addHours(1),
                                                                                      Last_Sync_Req_Timestamp_Layer_Gen__c = System.now().addHours(3),
                                                                                      Last_Sync_Req_Timestamp_Send_Frame__c = System.now().addHours(2),
                                                                                      Foundry_GDSOUT_Review__c = 'Not Ready',
                                                                                      Layer__c=mrsLayer21.Id,
                                                                                      //Mask_Layer__c = 'layer001',
                                                                                      Chip__c=mrsChip3.Id,
                                                                                      PTRF__c=ptrf1.Id);

          insert layerChip21;
          MRS_Layer_Chip_Association__c layerChip221 = new MRS_Layer_Chip_Association__c(Name='frame',
                                                                                      Synced_with_Oracle_DB__c=false,
                                                                                      Send_Prime_Data__c = 'Not Done',DRT__c=drt2.id,
                                                                                      Last_Sync_Req_Timestamp_Send_Prime__c = System.now().addHours(1),
                                                                                      Last_Sync_Req_Timestamp_Layer_Gen__c = System.now().addHours(3),
                                                                                      Last_Sync_Req_Timestamp_Send_Frame__c = System.now().addHours(2),
                                                                                      Foundry_GDSOUT_Review__c = 'Not Ready',
                                                                                      Layer__c=mrsLayer21.Id,
                                                                                      //Mask_Layer__c = 'layer001',
                                                                                      Chip__c=mrsChip3.Id,
                                                                                      PTRF__c=ptrf1.Id);

          insert layerChip221;
          MRS_Layer_Chip_Association__c layerChip212 = new MRS_Layer_Chip_Association__c(Name='frame',
                                                                                      Synced_with_Oracle_DB__c=false,
                                                                                      Send_Prime_Data__c = 'Not Done',DRT__c=drt1.id,
                                                                                      Last_Sync_Req_Timestamp_Send_Prime__c = System.now().addHours(1),
                                                                                      Last_Sync_Req_Timestamp_Layer_Gen__c = System.now().addHours(3),
                                                                                      Last_Sync_Req_Timestamp_Send_Frame__c = System.now().addHours(2),
                                                                                      Foundry_GDSOUT_Review__c = 'Not Ready',
                                                                                      Layer__c=mrsLayer22.Id,
                                                                                      //Mask_Layer__c = 'layer001',
                                                                                      Chip__c=mrsChip3.Id,
                                                                                      PTRF__c=ptrf1.Id);

          insert layerChip212;
     List<PTRF_DotNetService.MaskLayerData> lstMaskLayerData = new List<PTRF_DotNetService.MaskLayerData>();
    PTRF_DotNetService.MaskLayerData maskLayer = new PTRF_DotNetService.MaskLayerData();
    maskLayer.maskLayerName = 'layer001';
    maskLayer.maskLayerNumber = 'layer001';
    maskLayer.maskRev = '899';
    maskLayer.romCode = '123';
    maskLayer.sortOrder = 1;
    maskLayer.tapeoutFlag = true;
    maskLayer.logicalOperation = 'testoperation';
    maskLayer.logicalOperationType = 'testType';
    lstMaskLayerData.add(maskLayer);
      PTRF_DotNetService.MaskLayerData maskLayer1 = new PTRF_DotNetService.MaskLayerData();
    maskLayer1.maskLayerName = 'layer002';
    maskLayer1.maskLayerNumber = 'layer002';
    maskLayer1.maskRev = '900';
    //maskLayer.romCode = '20';
    maskLayer1.sortOrder = 1;
    maskLayer1.tapeoutFlag = true;
    maskLayer1.logicalOperation = 'testoperation';
    maskLayer1.logicalOperationType = 'testType';
    lstMaskLayerData.add(maskLayer1);
    PTRF_DotNetService.MaskLayerData maskLayer3 = new PTRF_DotNetService.MaskLayerData();
    maskLayer3.maskLayerName = 'layer003';
    maskLayer3.maskLayerNumber = 'layer003';
    maskLayer3.maskRev = '900';
    //maskLayr.romCode = '20';
    maskLayer3.sortOrder = 1;
    maskLayer3.tapeoutFlag = true;
    maskLayer3.logicalOperation = 'testoperation';
    maskLayer3.logicalOperationType = 'testType';
    lstMaskLayerData.add(maskLayer3);
    PTRF_DotNetService.MaskLayerData maskLayer4 = new PTRF_DotNetService.MaskLayerData();
    maskLayer4.maskLayerName = 'layer004';
    maskLayer4.maskLayerNumber = 'layer004';
    maskLayer4.maskRev = '900';
    maskLayer4.romCode = '123';
    maskLayer4.sortOrder = 1;
    maskLayer4.tapeoutFlag = true;
    maskLayer4.logicalOperation = 'testoperation';
    maskLayer4.logicalOperationType = 'testType';
    lstMaskLayerData.add(maskLayer4);
    
    List<PTRF_DotNetService.PrimeDieData> lstPrimeDie = new List<PTRF_DotNetService.PrimeDieData>();
    PTRF_DotNetService.PrimeDieData prmDie = new PTRF_DotNetService.PrimeDieData();
    prmDie.primeDieName = 'chip001';
    prmDie.tapeoutFlag = true;
    lstPrimeDie.add(prmdie);
    PTRF_DotNetService.PrimeDieData prmDie2 = new PTRF_DotNetService.PrimeDieData();
    prmDie2.primeDieName = 'chip002';
    prmDie2.tapeoutFlag = true;
    lstPrimeDie.add(prmdie2);
    PTRF_DotNetService.PrimeDieData prmDie3 = new PTRF_DotNetService.PrimeDieData();
    prmDie3.primeDieName = 'chip003';
    prmDie3.tapeoutFlag = true;
    lstPrimeDie.add(prmdie3);
    List<PTRF_DotNetService.ScribelineDropinsData> lstscribelineDropins = new List<PTRF_DotNetService.ScribelineDropinsData>();
    PTRF_DotNetService.ScribelineDropinsData scribelineDropins = new PTRF_DotNetService.ScribelineDropinsData();
    scribelineDropins.scribelineName = 'chip002';
    scribelineDropins.tapeoutFlag = true;
    lstscribelineDropins.add(scribelineDropins);
          
     List<PTRF_DotNetService.PTRFDataRecievedDiesLayersDeselected> lstPtrfDiesLayer = new List<PTRF_DotNetService.PTRFDataRecievedDiesLayersDeselected>();
    PTRF_DotNetService.PTRFDataRecievedDiesLayersDeselected PtrfDiesLayer = new PTRF_DotNetService.PTRFDataRecievedDiesLayersDeselected();
    PtrfDiesLayer.messageID = 'testMsg';
    PtrfDiesLayer.ptrfnumber='APTUS1';
    PtrfDiesLayer.maskLayers = lstMaskLayerData;
    PtrfDiesLayer.primeDies = lstPrimeDie;
    PtrfDiesLayer.scribelineDropins = lstscribelineDropins;
    lstPtrfDiesLayer.add(PtrfDiesLayer);
    
    test.startTest();
    PTRF_DotNetService.sync_PTRF_Chip_MaskLayer_Deselected(lstPtrfDiesLayer);
    test.stopTest();
    
     }   
  
   public static testMethod void testJobviewer() 
   {
    list<HCM_Employee__c> hcmEmp = new list<HCM_Employee__c>();
    list<User> userHcm = new list<User>();
    User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
    System.runAs ( thisUser ) 
    {
         //test.startTest();
         hcmEmp = SwiftDataUtilityTest.createHCMEmployee(2);
    }
    
     User u1=SwiftDataUtilityTest.createSysAdminUser();
    //u1.HCM_Login_ID__c=u1.Id;
    //update u1;
    //User u1 = [Select Id,Email from User Where HCM_Login_ID__c = 'E9214'];
    
    Mask_Set_Title__c mst = SwiftDataUtilityTest.createMST('TESTU');
    insert mst;
    DRT__c drtTest = new DRT__c(Name='TesingDrt',Synced_with_Oracle_DB__c=false,
                             DRT_Package_Sync__c=false,Status__c='Draft',Mask_Set_Title__c = mst.Id);          
    insert drtTest;
     list<DRT__c> lstUpdate = new list<DRT__c>();          
     lstUpdate.add(new DRT__c (id=drtTest.id,Synced_with_Oracle_DB__c=True,Status__c='Active',Mask_Set_Title__c = mst.Id ));
     update drtTest;    
    
    
    PTRF__c ptrf1 = new PTRF__c(Name='APTUS1',Mask_Set_Title__c = mst.id,Order_Type__c = 'testOrder1',Recticle_Type__c='Small Field Reticle (SFR)',Customer_jobview__c='Gating Mask Release',Tech_Geo_Value__c='0.03');
    insert ptrf1;
    
    //PTRF_JobViewer_Info__c ptrfJV = new PTRF_JobViewer_Info__c(PTRF__c = ptrf1.id,Jobview_Type__c = 'Frame Mockup,Prime GDSOUT Review,MEBES Jobview',Jobview__c = 'Customer',Email_Address__c='bhavana3@gmail.com',User__c = UserInfo.getUserId());
    //insert ptrfJV;
    
    PTRF_JobViewer_Info__c ptrfJV = new PTRF_JobViewer_Info__c(PTRF__c = ptrf1.id,Jobview_Type__c = 'Frame Mockup,Prime GDSOUT Review,MEBES Jobview',Jobview__c = 'Customer',Email_Address__c=u1.Email,User__c = u1.Id);
    insert ptrfJV;

    //PTRF_JobViewer_Info__c ptrfJV1 = new PTRF_JobViewer_Info__c(PTRF__c = ptrf1.id,Jobview_Type__c = 'Frame Mockup,Prime GDSOUT Review,MEBES Jobview',Jobview__c = 'Foundry',Email_Address__c='bhavana2@gmail.com',User__c = UserInfo.getUserId());
    //insert ptrfJV1;
    
    PTRF_JobViewer_Info__c ptrfJV1 = new PTRF_JobViewer_Info__c(PTRF__c = ptrf1.id,Jobview_Type__c = 'Frame Mockup,Prime GDSOUT Review,MEBES Jobview',Jobview__c = 'ProcessOwner',Email_Address__c=u1.Email,User__c = u1.Id);
    insert ptrfJV1;
    
    PTRF_JobViewer_Info__c ptrfJV2 = new PTRF_JobViewer_Info__c(PTRF__c = ptrf1.id,Jobview_Type__c = 'Frame Mockup,Prime GDSOUT Review,MEBES Jobview',Jobview__c = 'Foundry',Email_Address__c=u1.Email,User__c = u1.Id);
    insert ptrfJV2;
    
    PTRF_JobViewer_Info__c ptrfJV3 = new PTRF_JobViewer_Info__c(PTRF__c = ptrf1.id,Jobview_Type__c = NULL,Jobview__c = NULL,Email_Address__c=u1.Email,User__c = u1.Id);
    insert ptrfJV3;
                                
    list<PTRF_DotNetService.Jobviewer> jobviewerlist = new list<PTRF_DotNetService.Jobviewer>();    
    PTRF_DotNetService.Jobviewer jobviewer = new PTRF_DotNetService.Jobviewer();
    jobviewer.jobviewType ='Customer';
    jobviewer.MEBES =False;
    //jobviewer.userId = UserInfo.getUserId();
    //jobviewer.emailAddress = 'bhavana3@gmail.com';
    jobviewer.userId = u1.Id;
    jobviewer.emailAddress = u1.Email;
    jobviewer.GDSOUT = True;
    jobviewer.frameMockup = True;
    jobviewerlist.add(jobviewer);

    PTRF_DotNetService.Jobviewer jobviewer2 = new PTRF_DotNetService.Jobviewer();
    jobviewer2.jobviewType ='Foundry';
    jobviewer2.MEBES =False;
    //jobviewer2.userId = UserInfo.getUserId();
    //jobviewer2.emailAddress = 'bhavana2@gmail.com';
    jobviewer2.userId = u1.Id;
    jobviewer2.emailAddress = u1.Email;
    jobviewer2.GDSOUT = True;
    jobviewer2.frameMockup = True;
    jobviewerlist.add(jobviewer2);
          
    PTRF_DotNetService.Jobviewer jobviewer3 = new PTRF_DotNetService.Jobviewer();
    jobviewer3.jobviewType ='Foundry';
    jobviewer3.MEBES =True;
    //jobviewer3.userId = UserInfo.getUserId();
    //jobviewer3.emailAddress = 'bhavana1@gmail.com';
    jobviewer3.userId = u1.Id;
    jobviewer3.emailAddress = u1.Email;
    jobviewer3.GDSOUT = True;
    jobviewer3.frameMockup = True;
    jobviewerlist.add(jobviewer3);
          
    PTRF_DotNetService.Jobviewer jobviewer4 = new PTRF_DotNetService.Jobviewer();
    jobviewer4.jobviewType ='ProcessOwner';
    jobviewer4.MEBES =True;
    //jobviewer4.userId = UserInfo.getUserId();
    jobviewer4.userId = u1.Id;
    jobviewer4.emailAddress = u1.Email;
    //jobviewer4.emailAddress = 'bhavana1@gmail.com';
    jobviewer4.GDSOUT = True;
    jobviewer4.frameMockup = True;
    jobviewerlist.add(jobviewer4);

    PTRF_DotNetService.PTRFDataRecievedOnJobviewDataChange deselectJV = new PTRF_DotNetService.PTRFDataRecievedOnJobviewDataChange();
    list<PTRF_DotNetService.PTRFDataRecievedOnJobviewDataChange> deselectJVlist = new list<PTRF_DotNetService.PTRFDataRecievedOnJobviewDataChange>();
    deselectJV.messageID = '12345';
    deselectJV.ptrfNumber = ptrf1.Name;
    //deselectJV.jobviewers = new list<PTRF_DotNetService.Jobviewer>();
    deselectJV.jobviewers=jobviewerlist;
    deselectJV.jobviewers.addAll(jobviewerlist);
    deselectJVlist.add(deselectJV);
    
    PTRF_DotNetService.PTRFDataRecievedOnJobviewDataChange deselectJV1 = new PTRF_DotNetService.PTRFDataRecievedOnJobviewDataChange();
    deselectJV1.messageID = '12346';
    deselectJV1.ptrfNumber = ptrf1.Name;
    //deselectJV1.jobviewers = new list<PTRF_DotNetService.Jobviewer>();
    deselectJV1.jobviewers =jobviewerlist;
    deselectJV1.jobviewers.addAll(jobviewerlist);
    deselectJVlist.add(deselectJV1);
    
    PTRF_DotNetService.sync_PTRF_NewJobView_ChangesInJobView(deselectJVlist);
    Test.StartTest();
    PTRF_DotNetService.CalloutResponse('Test121',ptrf1.Id,'Open','Error');
    Test.StopTest();
     }
     
    Public static TestMethod void testPTRF_DotNetServiceNegative(){
    Test.setMock(WebServiceMock.class, new WebServiceMockImplNew());
    String output = callEchoString('Mock Response');
    System.assertEquals('Mock Response', output);
    list<HCM_Employee__c> hcmEmp = new list<HCM_Employee__c>();
    list<User> userHcm = new list<User>();
    User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
    System.runAs ( thisUser ) 
    {
         //test.startTest();
         hcmEmp = SwiftDataUtilityTest.createHCMEmployee(2);
    }
   // SwiftDataUtilityTest.customSystemData();
    // Insert PTRF record
    PTRF__c ptrf1 = new PTRF__c(Name='UATTEST',Order_Type__c = 'testOrder1',Recticle_Type__c='Small Field Reticle (SFR)',Customer_jobview__c='Gating Mask Release',Tech_Geo_Value__c='0.01');
    insert ptrf1;
    
    
     PTRF_JobViewer_Info__c ptrfJV = new PTRF_JobViewer_Info__c(PTRF__c = ptrf1.id,Jobview_Type__c = 'Frame Mockup',Jobview__c = 'Customer',User__c = UserInfo.getUserId());
    insert ptrfJV;
    PTRF_JobViewer_Info__c ptrfJV1 = new PTRF_JobViewer_Info__c(PTRF__c = ptrf1.id,Jobview_Type__c = 'Frame Mockup',Jobview__c = 'Foundry',User__c = UserInfo.getUserId());
    insert ptrfJV1;
    
    PTRF_JobViewer_Info__c ptrfJV2 = new PTRF_JobViewer_Info__c(PTRF__c = ptrf1.id,Jobview_Type__c = 'ProcessOwner',Jobview__c = 'Foundry',User__c = UserInfo.getUserId());
    insert ptrfJV2;
    
    PTRF_JobViewer_Info__c ptrfJV3 = new PTRF_JobViewer_Info__c(PTRF__c = ptrf1.id,Jobview_Type__c = NULL,Jobview__c = NULL,User__c = UserInfo.getUserId());
    insert ptrfJV3;
    
    
                                                                      
    Test.StartTest();
    PTRF_DotNetService.ResponseData responseData= new PTRF_DotNetService.ResponseData();
    responseData.messageId = 'testMsgId';
    responseData.ptrfNumber = 'UATTEST';
    responseData.status = 'ERROR';
    responseData.errorMessage = 'tstError';
    PTRF_DotNetService.PTRFData ptrf = new PTRF_DotNetService.PTRFData();
    ptrf.ptrfNumber = 'aptus';
    ptrf.maskSetTitle ='TESTU';
    ptrf.reticleType='Single Layer Reticle (SLR)';
    ptrf.primeDRT='testPrime';
    ptrf.frameDRT='testFrame';
    ptrf.techGeo='0.08';
    //ptrf.orderType='testOrder';
    ptrf.primeTapeout=true;
    ptrf.primeGDSOUT_Review=true;
    ptrf.frameTapeout=true;
    ptrf.frameMockup=true;
    ptrf.frameGDSOUT_Review=true;
    ptrf.DRC_Only=true;
    ptrf.bumpRequest=true;
    ptrf.accountShortName='bcmsgp';
    ptrf.orderStatus='Open';
    ptrf.customerJobView='testJobView';
    ptrf.processOwnerJobview='testOwnerJobView';
    ptrf.CRMDID='testCrmId';
    ptrf.deviceId='testDeviceId';
    List<PTRF_DotNetService.MaskLayerData> lstMaskLayerData = new List<PTRF_DotNetService.MaskLayerData>();
    PTRF_DotNetService.MaskLayerData maskLayer = new PTRF_DotNetService.MaskLayerData();
    maskLayer.maskLayerName = 'testMaskLayerName';
    maskLayer.maskLayerNumber = '1001';
    maskLayer.maskRev = '10';
    maskLayer.romCode = '20';
    maskLayer.sortOrder = 1;
    maskLayer.tapeoutFlag = true;
    maskLayer.logicalOperation = 'testoperation';
    maskLayer.logicalOperationType = 'testType';
    lstMaskLayerData.add(maskLayer);
    List<PTRF_DotNetService.PrimeDieData> lstPrimeDie = new List<PTRF_DotNetService.PrimeDieData>();
    PTRF_DotNetService.PrimeDieData prmDie = new PTRF_DotNetService.PrimeDieData();
    prmDie.primeDieName = 'testPrimeDieName';
    prmDie.tapeoutFlag = true;
    lstPrimeDie.add(prmdie);
    List<PTRF_DotNetService.ScribelineDropinsData> lstscribelineDropins = new List<PTRF_DotNetService.ScribelineDropinsData>();
    PTRF_DotNetService.ScribelineDropinsData scribelineDropins = new PTRF_DotNetService.ScribelineDropinsData();
    scribelineDropins.scribelineName = 'testscribeLine';
    scribelineDropins.tapeoutFlag = true;
    lstscribelineDropins.add(scribelineDropins);
    List<PTRF_DotNetService.PTRFDataRecievedOnPerformTapeout> lstPtrfDataReceived = new List<PTRF_DotNetService.PTRFDataRecievedOnPerformTapeout>();
    PTRF_DotNetService.PTRFDataRecievedOnPerformTapeout ptrfDataReceived = new PTRF_DotNetService.PTRFDataRecievedOnPerformTapeout();
    ptrfDataReceived.messageID = 'testMsg';
    ptrfDataReceived.action = 'testAction';
    ptrfDataReceived.ptrf = ptrf;
    ptrfDataReceived.ptrf.processid ='test122';
    ptrfDataReceived.maskLayers = lstMaskLayerData;
    ptrfDataReceived.primeDies = lstPrimeDie;
    ptrfDataReceived.scribelineDropins = lstscribelineDropins;
    lstPtrfDataReceived.add(ptrfDataReceived);
    PTRF_DotNetService.sync_PTRF_Status_PerformTapeoutOptions(lstPtrfDataReceived);
    map<string,string> mape = new map<string,string>();
    mape.put('ptrf','email');
    mape.put('ptrf1','email1');
     mape.put('ptrf2','email2');
     mape.put('emailtest','emailtest');
    PTRF_DotNetService.sendMail('ptrf',mape);
    
    }   
    //test PTRF_DotNetService.logValidationError(String wsMsg, String errorMsg, String msgId, String className, String methodName, String debugLevel, String ptrfNumber){
    static testMethod void test_logValidationError() {
        Test.startTest();
        //------------------
        String wsMsg = 'Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. ';
        String errorMsg = 'Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. Test 32k length string over-limit. ';
        PTRF_DotNetService.logValidationError(wsMsg, errorMsg, 'msgId', 'className', 'methodName', 'DEBUG', 'PTRF-12345-789');
        //------------------
        PTRF_DotNetService.sync_PTRF_Status_PerformTapeoutOptions( createDataForLogValidationError() );
        //------------------
        //PTRF_DotNetService pdns = new PTRF_DotNetService();
        //pdns.mthdDummy();
        //------------------
        Test.stopTest();
    }
    
    public static list<PTRF_DotNetService.PTRFDataRecievedOnPerformTapeout> createDataForLogValidationError() {
        PTRF_DotNetService.PTRFDataRecievedOnPerformTapeout msgData = new PTRF_DotNetService.PTRFDataRecievedOnPerformTapeout();
        msgData.messageID = 'TEST-SIT-001';
        msgData.ptrf = new PTRF_DotNetService.PTRFData(); //1
        msgData.jobviewers = new list<PTRF_DotNetService.Jobviewer>();//2
        msgData.maskLayers = new List<PTRF_DotNetService.MaskLayerData>();//3
        msgData.primeDies = new list<PTRF_DotNetService.PrimeDieData>();//4
        msgData.scribelineDropins = new list<PTRF_DotNetService.ScribelineDropinsData>();//5
        msgData.actionDateTime = DateTime.valueOf('2015-07-28 11:06:22.000'); 
        
        //1
        msgData.ptrf.ptrfNumber = 'PTRF-13987-538';
        msgData.ptrf.maskSetTitle = 'ZIN708';
        msgData.ptrf.reticleType = 'Single Layer Reticle (SLR)';
        msgData.ptrf.primeDRT = 'ZIN789_PRIME_DRT_001.010';
        msgData.ptrf.frameDRT = '';
        msgData.ptrf.techGeo = '0.020';
        msgData.ptrf.orderType = 'New Prototype';
        msgData.ptrf.primeTapeout = true;
        msgData.ptrf.primeGDSOUT_Review = true;
        msgData.ptrf.frameTapeout = true;
        msgData.ptrf.frameMockup = true;
        msgData.ptrf.frameGDSOUT_Review = true;
        msgData.ptrf.DRC_Only = true;
        msgData.ptrf.bumpRequest = false;
        msgData.ptrf.accountShortName = 'smrt';
        msgData.ptrf.orderStatus = 'Pending Submit'; //this line to cover the actual code
        msgData.ptrf.customerJobView = 'Not Required';
        msgData.ptrf.processOwnerJobview = 'Gating mask release';
        msgData.ptrf.CRMDID = 'CDID0018598.00';
        msgData.ptrf.deviceId = 'UAT_SWIFT_SUBWAY_20NM.01';
        msgData.ptrf.transactionDate = Date.valueOf('2015-07-27');
        msgData.ptrf.DRCoption = 'Foundry run and gating mask release';
        msgData.ptrf.processid = '08-020-LP-BHL-01-09-0001';
        msgData.ptrf.Fab = 'Fab8';
        msgData.ptrf.Maskshop = 'TOPPAN';
        msgData.ptrf.MaskshopId = '6210';
        msgData.ptrf.MaskTitleforROMcode = '';
        //added to msgData
        
        //2
        PTRF_DotNetService.Jobviewer joviewer1 = new PTRF_DotNetService.Jobviewer();
        joviewer1.jobviewType = 'Customer';
        joviewer1.MEBES = true;
        joviewer1.userId = '13979';
        joviewer1.emailAddress = 'angeline.ho@globalfoundries.com.swiftsit1';
        joviewer1.GDSOUT = true;
        joviewer1.frameMockup = true;
        
        PTRF_DotNetService.Jobviewer joviewer2 = new PTRF_DotNetService.Jobviewer();
        joviewer2.jobviewType = 'Customer';
        joviewer2.MEBES = true;
        joviewer2.userId = '456183';
        joviewer2.emailAddress = 'larry.pulvirent@globalfoundries.com.swiftsit1';
        joviewer2.GDSOUT = true;
        joviewer2.frameMockup = true;
        
        msgData.jobviewers.add(joviewer1);
        msgData.jobviewers.add(joviewer2);
        
        
        //3
        PTRF_DotNetService.MaskLayerData layer1 = new PTRF_DotNetService.MaskLayerData();
        layer1.maskLayerName = 'ZZ';
        layer1.maskLayerNumber = 'ZZ';
        layer1.maskRev = 'AZ';
        layer1.romCode = '';
        layer1.sortOrder = 1;
        layer1.tapeoutFlag = true;
        layer1.logicalOperation = 'Foundry Std.';
        layer1.logicalOperationType = 'Foundry Std';
        
        msgData.maskLayers.add(layer1);
        
        //4
        PTRF_DotNetService.PrimeDieData pd1 = new PTRF_DotNetService.PrimeDieData();
        pd1.primeDieName = 'PD321';
        pd1.tapeoutFlag = true;
        
        msgData.primeDies.add(pd1);
        
        list<PTRF_DotNetService.PTRFDataRecievedOnPerformTapeout> ptrfData = new list<PTRF_DotNetService.PTRFDataRecievedOnPerformTapeout>();
        ptrfData.add(msgData);
        return ptrfData;
    }
    
    //====================================================================================
    //====================================================================================
    //====================================================================================
    //====================================================================================
    //====================================================================================
    
    static testMethod void testThis1() {
        init();
        String jsonPayload = '[{"scribelineDropins":[],"ptrf":{"transactionDate":"2016-02-29","techGeo":"0.020","reticleType":"Single Layer Reticle (SLR)","ptrfNumber":"PTRF-Exxon-yyy","processOwnerJobview":"Gating mask release","processid":"08-014-XM-BHL-07-11-0001","primeTapeout":true,"primeGDSOUT_Review":false,"primeDRT":"","orderType":"Retrofit","orderStatus":"Perform Tapeout Options","MaskTitleforROMcode":"","MaskshopId":"5498","Maskshop":"AMTC-TPI","maskSetTitle":"ZIN789","frameTapeout":false,"frameMockup":false,"frameGDSOUT_Review":false,"frameDRT":"","Fab":"Fab7","DRCoption":"Foundry run and gating mask release","DRC_Only":false,"deviceId":"LMST.LONG","customerJobView":"Gating mask release","CRMDID":"CDID0019986.00","bumpRequest":false,"accountShortName":"smrt"},"primeDies":[{"tapeoutFlag":true,"primeDieName":"CHIP_3B"}],"messageID":"LONG-TEST-HA","maskLayers":[{"tapeoutFlag":true,"sortOrder":1,"romCode":"","maskRev":"BZ","maskLayerNumber":"V4","maskLayerName":"V4","logicalOperationType":"Foundry Std","logicalOperation":"Foundry Std."},{"tapeoutFlag":true,"sortOrder":2,"romCode":"","maskRev":"BZ","maskLayerNumber":"V1","maskLayerName":"V1","logicalOperationType":"Foundry Std","logicalOperation":"Foundry Std."},{"tapeoutFlag":true,"sortOrder":3,"romCode":"","maskRev":"BZ","maskLayerNumber":"V2","maskLayerName":"V2","logicalOperationType":"Foundry Std","logicalOperation":"Foundry Std."},{"tapeoutFlag":true,"sortOrder":4,"romCode":"","maskRev":"BZ","maskLayerNumber":"V3","maskLayerName":"V3","logicalOperationType":"Foundry Std","logicalOperation":"Foundry Std."},{"tapeoutFlag":false,"sortOrder":5,"romCode":"","maskRev":"BZ","maskLayerNumber":"A6","maskLayerName":"A6","logicalOperationType":"Foundry Std","logicalOperation":"Foundry Std."}],"jobviewers":[{"userId":"rc101712","MEBES":true,"jobviewType":"ProcessOwner","GDSOUT":false,"frameMockup":false,"emailAddress":"hoanglongluuvt@gmail.com"},{"userId":"E1001301","MEBES":true,"jobviewType":"Customer","GDSOUT":false,"frameMockup":false,"emailAddress":"andrew.sia@globalfoundries.com.swiftsit1"},{"userId":"BRATHOU1","MEBES":true,"jobviewType":"MEBES Jobview","GDSOUT":true,"frameMockup":false,"emailAddress":"baijnath.rathour=globalfoundries.com@example.com"},{"userId":"JNEPOMUC","MEBES":true,"jobviewType":"MEBES Jobview","GDSOUT":false,"frameMockup":true,"emailAddress":"julieann.nepomuceno=globalfoundries.com@example.com"}],"actionDateTime":"2016-02-29T18:37:44.000Z","action":"PTO"}]';
    
        test.startTest();
        PTRF_DotNetService.ptrfNumberList = new list<string>();
        list<PTRF_DotNetService.PTRFDataRecievedOnPerformTapeout> listToHandle = (list<PTRF_DotNetService.PTRFDataRecievedOnPerformTapeout>) json.deserialize(jsonPayload, list<PTRF_DotNetService.PTRFDataRecievedOnPerformTapeout>.class);
        PTRF_DotNetService.sync_PTRF_Status_PerformTapeoutOptions(listToHandle);
        test.stopTest();
    }
    
    static testMethod void testThis2() {
        init();
        String jsonPayload = '[{"scribelineDropins":[],"ptrf":{"transactionDate":"2016-02-29","techGeo":"0.020","reticleType":"Single Layer Reticle (SLR)","ptrfNumber":"PTRF-Exxon-yyy","processOwnerJobview":"Gating mask release","processid":"08-014-XM-BHL-07-11-0001","primeTapeout":true,"primeGDSOUT_Review":false,"primeDRT":"","orderType":"Retrofit","orderStatus":"Perform Tapeout Options","MaskTitleforROMcode":"","MaskshopId":"5498","Maskshop":"AMTC-TPI","maskSetTitle":"ZIN789","frameTapeout":false,"frameMockup":false,"frameGDSOUT_Review":false,"frameDRT":"","Fab":"Fab7","DRCoption":"Foundry run and gating mask release","DRC_Only":false,"deviceId":"LMST.LONG","customerJobView":"Gating mask release","CRMDID":"CDID0019986.00","bumpRequest":false,"accountShortName":"smrt"},"primeDies":[{"tapeoutFlag":true,"primeDieName":"CHIP_3B"}],"messageID":"LONG-TEST-HA","maskLayers":[{"tapeoutFlag":true,"sortOrder":1,"romCode":"","maskRev":"BZ","maskLayerNumber":"V4","maskLayerName":"V4","logicalOperationType":"Foundry Std","logicalOperation":"Foundry Std."},{"tapeoutFlag":true,"sortOrder":2,"romCode":"","maskRev":"BZ","maskLayerNumber":"V1","maskLayerName":"V1","logicalOperationType":"Foundry Std","logicalOperation":"Foundry Std."},{"tapeoutFlag":true,"sortOrder":3,"romCode":"","maskRev":"BZ","maskLayerNumber":"V2","maskLayerName":"V2","logicalOperationType":"Foundry Std","logicalOperation":"Foundry Std."},{"tapeoutFlag":true,"sortOrder":4,"romCode":"","maskRev":"BZ","maskLayerNumber":"V3","maskLayerName":"V3","logicalOperationType":"Foundry Std","logicalOperation":"Foundry Std."},{"tapeoutFlag":false,"sortOrder":5,"romCode":"","maskRev":"BZ","maskLayerNumber":"A6","maskLayerName":"A6","logicalOperationType":"Foundry Std","logicalOperation":"Foundry Std."}],"jobviewers":[{"userId":"rc101712","MEBES":true,"jobviewType":"ProcessOwner","GDSOUT":false,"frameMockup":false,"emailAddress":"hoanglongluuvt@gmail.com"},{"userId":"E1001301","MEBES":true,"jobviewType":"Customer","GDSOUT":false,"frameMockup":false,"emailAddress":"andrew.sia@globalfoundries.com.swiftsit1"},{"userId":"BRATHOU1","MEBES":true,"jobviewType":"MEBES Jobview","GDSOUT":true,"frameMockup":false,"emailAddress":"baijnath.rathour=globalfoundries.com@example.com"},{"userId":"JNEPOMUC","MEBES":true,"jobviewType":"MEBES Jobview","GDSOUT":false,"frameMockup":true,"emailAddress":"julieann.nepomuceno=globalfoundries.com@example.com"}],"actionDateTime":"2016-02-29T18:37:44.000Z","action":"PTO"}]';        
        Error_codes__c e = [select id from Error_codes__c where name = 'PTRF_MNR_Multiple_TechGeo'];
        delete e;
        
        test.startTest();
        list<PTRF_DotNetService.PTRFDataRecievedOnPerformTapeout> listToHandle = (list<PTRF_DotNetService.PTRFDataRecievedOnPerformTapeout>) json.deserialize(jsonPayload, list<PTRF_DotNetService.PTRFDataRecievedOnPerformTapeout>.class);
        PTRF_DotNetService.sync_PTRF_Status_PerformTapeoutOptions(listToHandle);
        test.stopTest();
    }
    
    static testMethod void testThis3() {
        init();
        String jsonPayload = '[{"scribelineDropins":[],"ptrf":{"transactionDate":"2016-02-29","techGeo":"0.028","reticleType":"Single Layer Reticle (SLR)","ptrfNumber":"PTRF-20189-522","processOwnerJobview":"Gating mask release","processid":"08-014-XM-BHL-07-11-0001","primeTapeout":true,"primeGDSOUT_Review":false,"primeDRT":"","orderType":"Retrofit","orderStatus":"Perform Tapeout Options","MaskTitleforROMcode":"","MaskshopId":"5498","Maskshop":"AMTC-TPI","maskSetTitle":"ZIN789","frameTapeout":false,"frameMockup":false,"frameGDSOUT_Review":false,"frameDRT":"","Fab":"Fab7","DRCoption":"Foundry run and gating mask release","DRC_Only":false,"deviceId":"LMST.LONG","customerJobView":"Gating mask release","CRMDID":"CDID0019986.00","bumpRequest":false,"accountShortName":"smrt"},"primeDies":[{"tapeoutFlag":true,"primeDieName":"CHIP_3B"}],"messageID":"LONG-TEST-HA","maskLayers":[{"tapeoutFlag":true,"sortOrder":1,"romCode":"","maskRev":"BZ","maskLayerNumber":"V4","maskLayerName":"V4","logicalOperationType":"Foundry Std","logicalOperation":"Foundry Std."},{"tapeoutFlag":true,"sortOrder":2,"romCode":"","maskRev":"BZ","maskLayerNumber":"V1","maskLayerName":"V1","logicalOperationType":"Foundry Std","logicalOperation":"Foundry Std."},{"tapeoutFlag":true,"sortOrder":3,"romCode":"","maskRev":"BZ","maskLayerNumber":"V2","maskLayerName":"V2","logicalOperationType":"Foundry Std","logicalOperation":"Foundry Std."},{"tapeoutFlag":true,"sortOrder":4,"romCode":"","maskRev":"BZ","maskLayerNumber":"V3","maskLayerName":"V3","logicalOperationType":"Foundry Std","logicalOperation":"Foundry Std."},{"tapeoutFlag":false,"sortOrder":5,"romCode":"","maskRev":"BZ","maskLayerNumber":"A6","maskLayerName":"A6","logicalOperationType":"Foundry Std","logicalOperation":"Foundry Std."}],"jobviewers":[{"userId":"rc101712","MEBES":true,"jobviewType":"ProcessOwner","GDSOUT":false,"frameMockup":false,"emailAddress":"hoanglongluuvt@gmail.com"},{"userId":"E1001301","MEBES":true,"jobviewType":"Customer","GDSOUT":false,"frameMockup":false,"emailAddress":"andrew.sia@globalfoundries.com.swiftsit1"},{"userId":"BRATHOU1","MEBES":true,"jobviewType":"MEBES Jobview","GDSOUT":true,"frameMockup":false,"emailAddress":"baijnath.rathour=globalfoundries.com@example.com"},{"userId":"JNEPOMUC","MEBES":true,"jobviewType":"MEBES Jobview","GDSOUT":false,"frameMockup":true,"emailAddress":"julieann.nepomuceno=globalfoundries.com@example.com"}],"actionDateTime":"2016-02-29T18:37:44.000Z","action":"PTO"}]';        
    
        ptrf__c ptrf = [select id from ptrf__c where name = 'PTRF-20189-522'];
        ptrf.status__c = 'Cancel';
        update ptrf;
        
        test.startTest();
        list<PTRF_DotNetService.PTRFDataRecievedOnPerformTapeout> listToHandle = (list<PTRF_DotNetService.PTRFDataRecievedOnPerformTapeout>) json.deserialize(jsonPayload, list<PTRF_DotNetService.PTRFDataRecievedOnPerformTapeout>.class);
        PTRF_DotNetService.sync_PTRF_Status_PerformTapeoutOptions(listToHandle);
        test.stopTest();
    }
    
    static testMethod void testThis4() {
        
        try {mrs_layer_association__c layer = new mrs_layer_association__c(); if(null == layer.Count_Released_Chip__c) {Integer a = 1;}} catch(exception e) {}
        
        init();
        String jsonPayload = '[{"scribelineDropins":[],"ptrf":{"transactionDate":"2016-02-29","techGeo":"0.028","reticleType":"Single Layer Reticle (SLR)","ptrfNumber":"PTRF-20189-522-b","processOwnerJobview":"Gating mask release","processid":"08-014-XM-BHL-07-11-0001","primeTapeout":true,"primeGDSOUT_Review":false,"primeDRT":"","orderType":"Retrofit","orderStatus":"Perform Tapeout Options","MaskTitleforROMcode":"","MaskshopId":"5498","Maskshop":"AMTC-TPI","maskSetTitle":"ZIN789","frameTapeout":false,"frameMockup":false,"frameGDSOUT_Review":false,"frameDRT":"","Fab":"Fab7","DRCoption":"Foundry run and gating mask release","DRC_Only":false,"deviceId":"LMST.LONG","customerJobView":"Gating mask release","CRMDID":"CDID0019986.00","bumpRequest":false,"accountShortName":"smrt"},"primeDies":[{"tapeoutFlag":true,"primeDieName":"CHIP_3B"}],"messageID":"LONG-TEST-HA","maskLayers":[{"tapeoutFlag":true,"sortOrder":1,"romCode":"","maskRev":"BZ","maskLayerNumber":"V4","maskLayerName":"V4","logicalOperationType":"Foundry Std","logicalOperation":"Foundry Std."},{"tapeoutFlag":true,"sortOrder":2,"romCode":"","maskRev":"BZ","maskLayerNumber":"V1","maskLayerName":"V1","logicalOperationType":"Foundry Std","logicalOperation":"Foundry Std."},{"tapeoutFlag":true,"sortOrder":3,"romCode":"","maskRev":"BZ","maskLayerNumber":"V2","maskLayerName":"V2","logicalOperationType":"Foundry Std","logicalOperation":"Foundry Std."},{"tapeoutFlag":true,"sortOrder":4,"romCode":"","maskRev":"BZ","maskLayerNumber":"V3","maskLayerName":"V3","logicalOperationType":"Foundry Std","logicalOperation":"Foundry Std."},{"tapeoutFlag":false,"sortOrder":5,"romCode":"","maskRev":"BZ","maskLayerNumber":"A6","maskLayerName":"A6","logicalOperationType":"Foundry Std","logicalOperation":"Foundry Std."}],"jobviewers":[{"userId":"rc101712","MEBES":true,"jobviewType":"ProcessOwner","GDSOUT":false,"frameMockup":false,"emailAddress":"hoanglongluuvt@gmail.com"},{"userId":"E1001301","MEBES":true,"jobviewType":"Customer","GDSOUT":false,"frameMockup":false,"emailAddress":"andrew.sia@globalfoundries.com.swiftsit1"},{"userId":"BRATHOU1","MEBES":true,"jobviewType":"MEBES Jobview","GDSOUT":true,"frameMockup":false,"emailAddress":"baijnath.rathour=globalfoundries.com@example.com"},{"userId":"JNEPOMUC","MEBES":true,"jobviewType":"MEBES Jobview","GDSOUT":false,"frameMockup":true,"emailAddress":"julieann.nepomuceno=globalfoundries.com@example.com"}],"actionDateTime":"2016-02-29T18:37:44.000Z","action":"PTO"}]';        
    
        Mask_Set_Title__c mst = [select id from Mask_Set_Title__c where name = 'ZIN789'];
        delete mst;
        
        test.startTest();
        list<PTRF_DotNetService.PTRFDataRecievedOnPerformTapeout> listToHandle = (list<PTRF_DotNetService.PTRFDataRecievedOnPerformTapeout>) json.deserialize(jsonPayload, list<PTRF_DotNetService.PTRFDataRecievedOnPerformTapeout>.class);
        PTRF_DotNetService.sync_PTRF_Status_PerformTapeoutOptions(listToHandle);
        test.stopTest();
    }
    
    
    public static void init() {
        
        //create mst
        Mask_Set_Title__c mst = SwiftDataUtilityTest.createMST('ZIN789');
        insert mst;
        
        //create ptrf
        PTRF__c ptrf1 = new PTRF__c( 
            Mask_Set_Title__c = 'ZIN789',  
            Name='PTRF-20189-522', 
            Order_Type__c = 'testOrder1', 
            Recticle_Type__c='Single Layer Reticle (SLR)', 
            Customer_jobview__c='Gating Mask Release', 
            MaskSetTitle__c = mst.id, 
            Status__c = 'Perform Tapeout Options',
            Tech_Geo_Value__c = '0.028'
        );
        insert ptrf1;
        
        PTRF__c ptrf2 = new PTRF__c( 
            Mask_Set_Title__c = 'ZIN789',  
            Name='PTRF-20189-522-b', 
            Order_Type__c = 'testOrder1', 
            Recticle_Type__c='Single Layer Reticle (SLR)', 
            Customer_jobview__c='Gating Mask Release', 
            //MaskSetTitle__c = mst.id, 
            Status__c = 'Open',
            Tech_Geo_Value__c = '0.028'
        );
        insert ptrf2;
    }
}