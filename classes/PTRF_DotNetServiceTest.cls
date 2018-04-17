@isTest(seeAllData=false)
global class PTRF_DotNetServiceTest{

@testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
                 List<Map<String,Object>>  fieldValueMapList = new List<Map<String,Object>>();
        for(integer i=1;i<=2;i++){
            Map<String,Object> fieldValueMap = new Map<String,Object>();
            fieldValueMap.put('Name', 'MYTEST ACCOUNT'+i);            
            fieldValueMap.put('stage__c', 'Unqualified');        
            fieldValueMap.put('sub_type__c', 'Direct');
            fieldValueMap.put('site_department__c', 'test dept'+'70217417535'+string.valueOf(math.random())+string.valueOf(system.now().gettime()));          
            fieldValueMap.put('transaction_type__c', 'transactional');                          
            fieldValueMap.put('region__c', 'APJ');        
            fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
            fieldValueMap.put('Corporate_City__c', 'Test City');                
            fieldValueMap.put('Corporate_Country__c', 'Singapore');
            fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
            fieldValueMap.put('Bill_To_City__c', 'Test City');            
            fieldValueMap.put('Bill_To_Country__c', 'Singapore');        
            fieldValueMap.put('Fab_9_10__c','no');
            fieldValueMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER'));
    
            fieldValueMapList.add(fieldValueMap);
        }
        AccountDataFactory.createAccounts(fieldValueMapList,2);
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
               MRSdotNETResponseCalloutService.SendSFDCStatusResponse_element  respElement = 
               new MRSdotNETResponseCalloutService.SendSFDCStatusResponse_element();
               respElement.SendSFDCStatusResponseState = 'Mock Response';
               response.put('response_x',respElement); 
               }
            }
      // Testing web service callout
         
    Public static TestMethod void testPTRF_DotNetService(){
        Account acc= getAccount('MYTEST ACCOUNT2');
        Environment_Variable__c env = [select id,name,value__c from Environment_Variable__c where name='HCM Emp AccountId'];
        env.value__c=acc.Id;
        update env;
        
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
    PTRF__c ptrf1 = new PTRF__c(Name='APTUS1',Order_Type__c = 'testOrder1',Recticle_Type__c='Multi Layer Reticle (MLR)',Customer_jobview__c='Gating Mask Release');
    insert ptrf1;
    
    
     PTRF_JobViewer_Info__c ptrfJV = new PTRF_JobViewer_Info__c(PTRF__c = ptrf1.id,Jobview_Type__c = 'Frame Mockup',Jobview__c = 'Customer',User__c = UserInfo.getUserId());
    insert ptrfJV;
    PTRF_JobViewer_Info__c ptrfJV1 = new PTRF_JobViewer_Info__c(PTRF__c = ptrf1.id,Jobview_Type__c = 'Frame Mockup',Jobview__c = 'Foundry',User__c = UserInfo.getUserId());
    insert ptrfJV1;
    
    PTRF_JobViewer_Info__c ptrfJV2 = new PTRF_JobViewer_Info__c(PTRF__c = ptrf1.id,Jobview_Type__c = 'ProcessOwner',Jobview__c = 'Foundry',User__c = UserInfo.getUserId());
    insert ptrfJV2;
    
    PTRF_JobViewer_Info__c ptrfJV3 = new PTRF_JobViewer_Info__c(PTRF__c = ptrf1.id,Jobview_Type__c = NULL,Jobview__c = NULL,User__c = UserInfo.getUserId());
    insert ptrfJV3;
    
Mask_Set_Title__c mst = SwiftDataUtilityTest.createMST('TESTU01');
          insert mst;
        DRT__c drt1 = new DRT__c(Name='testFrame',Synced_with_Oracle_DB__c=false,
                                     DRT_Package_Sync__c=false,Status__c='Active',Mask_Set_Title__c = mst.Id);          
            insert drt1; 
            DRT__c drt2 = new DRT__c(Name='Frame',Synced_with_Oracle_DB__c=false,
                                     DRT_Package_Sync__c=false,Status__c='Active',Mask_Set_Title__c = mst.Id);          
            insert drt2; 

                                                                  
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
    ptrf.primeDRT='testFrame';
    ptrf.frameDRT='Frame';
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
    PTRF_DotNetService.sync_PTRF_NewJobView_ChangesInJobView(lstJobViewData);
    Test.StopTest();
    }
    
    //Testing lstPTRF size == 0
    Public static TestMethod void testIsListPTRFempty(){
        Account acc= getAccount('MYTEST ACCOUNT2');
        Environment_Variable__c env = [select id,name,value__c from Environment_Variable__c where name='HCM Emp AccountId'];
        env.value__c=acc.Id;
        update env;
        
        list<HCM_Employee__c> hcmEmp = new list<HCM_Employee__c>();
    list<User> userHcm = new list<User>();
    User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
    System.runAs ( thisUser ) 
    {
         //test.startTest();
         hcmEmp = SwiftDataUtilityTest.createHCMEmployee(2);
    }
   // SwiftDataUtilityTest.customSystemData();
    Mask_Set_Title__c mst = SwiftDataUtilityTest.createMST('TESTU01');
    insert mst;
    DRT__c drt1 = new DRT__c(Name='testFrame',Synced_with_Oracle_DB__c=false,
                             DRT_Package_Sync__c=false,Status__c='Draft',Mask_Set_Title__c = mst.Id);          
    insert drt1; 
    DRT__c drt2 = new DRT__c(Name='testPrime',Synced_with_Oracle_DB__c=false,
                             DRT_Package_Sync__c=false,Status__c='Active',Mask_Set_Title__c = mst.Id);          
    insert drt2; 
    Test.StartTest();
    list<DRT__c> lstUpdate = new list<DRT__c>();          
     lstUpdate.add(new DRT__c (id=drt1.id,Synced_with_Oracle_DB__c=True,Status__c='Active',Mask_Set_Title__c = mst.Id ));
     update lstUpdate ; 
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
    ptrf1.techGeo='0.02';
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
        Account acc= getAccount('MYTEST ACCOUNT2');
        Environment_Variable__c env = [select id,name,value__c from Environment_Variable__c where name='HCM Emp AccountId'];
        env.value__c=acc.Id;
        update env;
    
        list<HCM_Employee__c> hcmEmp = new list<HCM_Employee__c>();
        list<User> userHcm = new list<User>();
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        System.runAs ( thisUser ) 
        {
             //test.startTest();
             hcmEmp = SwiftDataUtilityTest.createHCMEmployee(2);
        }
        //SwiftDataUtilityTest.customSystemData();
        
        Mask_Set_Title__c mst = SwiftDataUtilityTest.createMST('TESTU01');
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
      Mask_Set_Title__c mst = SwiftDataUtilityTest.createMST('TESTU01');
         insert mst;
     PTRF__c ptrf1 = new PTRF__c(Name='APTUS1',Mask_Set_Title__c = mst.id,Order_Type__c = 'testOrder1',Recticle_Type__c='Multi Layer Reticle (MLR)',Customer_jobview__c='Gating Mask Release');
    insert ptrf1;
    
    MRS__c mrs1 = new MRS__c(Full_Sync__c =true,
                                   Synced_with_Oracle_DB__c=false,
                                   MRS_Package_Sync__c=false,
                                   Mask_Set_Title__c=mst.Id);
          insert mrs1;                             
          MRS_Layer_Association__c mrsLayer1 = new MRS_Layer_Association__c(Name ='layer001',
                                                                           Synced_with_Oracle_DB__c=false,
                                                                           Mask_Layer_Rev__c = '899',
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
                                                                                      Send_Prime_Data__c = 'Not Done',
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
                                                                                      Send_Prime_Data__c = 'Not Done',
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
     List<PTRF_DotNetService.MaskLayerData> lstMaskLayerData = new List<PTRF_DotNetService.MaskLayerData>();
    PTRF_DotNetService.MaskLayerData maskLayer = new PTRF_DotNetService.MaskLayerData();
    maskLayer.maskLayerName = 'layer001';
    maskLayer.maskLayerNumber = 'layer001';
    maskLayer.maskRev = '899';
    //maskLayer.romCode = '20';
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
    List<PTRF_DotNetService.PrimeDieData> lstPrimeDie = new List<PTRF_DotNetService.PrimeDieData>();
    PTRF_DotNetService.PrimeDieData prmDie = new PTRF_DotNetService.PrimeDieData();
    prmDie.primeDieName = 'chip001';
    prmDie.tapeoutFlag = true;
    lstPrimeDie.add(prmdie);
    List<PTRF_DotNetService.ScribelineDropinsData> lstscribelineDropins = new List<PTRF_DotNetService.ScribelineDropinsData>();
    PTRF_DotNetService.ScribelineDropinsData scribelineDropins = new PTRF_DotNetService.ScribelineDropinsData();
    scribelineDropins.scribelineName = 'chip002';
    scribelineDropins.tapeoutFlag = true;
    lstscribelineDropins.add(scribelineDropins);
    Test.startTest();      
     List<PTRF_DotNetService.PTRFDataRecievedDiesLayersDeselected> lstPtrfDiesLayer = new List<PTRF_DotNetService.PTRFDataRecievedDiesLayersDeselected>();
    PTRF_DotNetService.PTRFDataRecievedDiesLayersDeselected PtrfDiesLayer = new PTRF_DotNetService.PTRFDataRecievedDiesLayersDeselected();
    PtrfDiesLayer.messageID = 'testMsg';
    PtrfDiesLayer.ptrfnumber='APTUS1';
    PtrfDiesLayer.maskLayers = lstMaskLayerData;
    PtrfDiesLayer.primeDies = lstPrimeDie;
    PtrfDiesLayer.scribelineDropins = lstscribelineDropins;
    lstPtrfDiesLayer.add(PtrfDiesLayer);
    PTRF_DotNetService.sync_PTRF_Chip_MaskLayer_Deselected(lstPtrfDiesLayer);
    Test.stopTest();
    
    
     }   
  
  
   public static testMethod void testJobviewer() 
     {
     Account acc= getAccount('MYTEST ACCOUNT2');
        Environment_Variable__c env = [select id,name,value__c from Environment_Variable__c where name='HCM Emp AccountId'];
        env.value__c=acc.Id;
        update env;
     list<HCM_Employee__c> hcmEmp = new list<HCM_Employee__c>();
    list<User> userHcm = new list<User>();
    User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
    System.runAs ( thisUser ) 
    {
         //test.startTest();
         hcmEmp = SwiftDataUtilityTest.createHCMEmployee(2);
    }
      Mask_Set_Title__c mst = SwiftDataUtilityTest.createMST('TESTU01');
         insert mst;
     PTRF__c ptrf1 = new PTRF__c(Name='APTUS1',Mask_Set_Title__c = mst.id,Order_Type__c = 'testOrder1',Recticle_Type__c='Multi Layer Reticle (MLR)',Customer_jobview__c='Gating Mask Release');
    insert ptrf1;
    
   PTRF_JobViewer_Info__c ptrfJV = new PTRF_JobViewer_Info__c(PTRF__c = ptrf1.id,Jobview_Type__c = 'Frame Mockup,Prime GDSOUT Review,MEBES Jobview',Jobview__c = 'Customer',Email_Address__c='bhavana3@gmail.com',User__c = UserInfo.getUserId());
    insert ptrfJV;
    PTRF_JobViewer_Info__c ptrfJV1 = new PTRF_JobViewer_Info__c(PTRF__c = ptrf1.id,Jobview_Type__c = 'Frame Mockup,Prime GDSOUT Review,MEBES Jobview',Jobview__c = 'Foundry',Email_Address__c='bhavana2@gmail.com',User__c = UserInfo.getUserId());
    insert ptrfJV1;
    
    PTRF_JobViewer_Info__c ptrfJV2 = new PTRF_JobViewer_Info__c(PTRF__c = ptrf1.id,Jobview_Type__c = 'Frame Mockup,Prime GDSOUT Review,MEBES Jobview',Jobview__c = 'Foundry',Email_Address__c='bhavana1@gmail.com',User__c = UserInfo.getUserId());
    insert ptrfJV2;
    
    PTRF_JobViewer_Info__c ptrfJV3 = new PTRF_JobViewer_Info__c(PTRF__c = ptrf1.id,Jobview_Type__c = NULL,Jobview__c = NULL,Email_Address__c='bhavana@gmail.com',User__c = UserInfo.getUserId());
    insert ptrfJV3;
                                
    list<PTRF_DotNetService.Jobviewer> jobviewerlist = new list<PTRF_DotNetService.Jobviewer>();    
    PTRF_DotNetService.Jobviewer jobviewer = new PTRF_DotNetService.Jobviewer();
    jobviewer.jobviewType ='Customer';
    jobviewer.MEBES =False;
    jobviewer.userId = UserInfo.getUserId();
    jobviewer.emailAddress = 'bhavana3@gmail.com';
    jobviewer.GDSOUT = True;
    jobviewer.frameMockup = True;
    jobviewerlist.add(jobviewer);

    PTRF_DotNetService.Jobviewer jobviewer2 = new PTRF_DotNetService.Jobviewer();
    jobviewer2.jobviewType ='Foundry';
    jobviewer2.MEBES =False;
    jobviewer2.userId = UserInfo.getUserId();
    jobviewer2.emailAddress = 'bhavana2@gmail.com';
    jobviewer2.GDSOUT = True;
    jobviewer2.frameMockup = True;
    jobviewerlist.add(jobviewer2);
          
    PTRF_DotNetService.Jobviewer jobviewer3 = new PTRF_DotNetService.Jobviewer();
    jobviewer3.jobviewType ='Foundry';
    jobviewer3.MEBES =True;
    jobviewer3.userId = UserInfo.getUserId();
    jobviewer3.emailAddress = 'bhavana1@gmail.com';
    jobviewer3.GDSOUT = True;
    jobviewer3.frameMockup = True;
    jobviewerlist.add(jobviewer3);
          
     
    PTRF_DotNetService.PTRFDataRecievedOnJobviewDataChange deselectJV = new PTRF_DotNetService.PTRFDataRecievedOnJobviewDataChange();
    list<PTRF_DotNetService.PTRFDataRecievedOnJobviewDataChange> deselectJVlist = new list<PTRF_DotNetService.PTRFDataRecievedOnJobviewDataChange>();
    deselectJV.messageID = '12345';
    deselectJV.ptrfNumber = ptrf1.Name;
    deselectJV.jobviewers = new list<PTRF_DotNetService.Jobviewer>();
    deselectJV.jobviewers.addAll(jobviewerlist);
    deselectJVlist.add(deselectJV);
    
    PTRF_DotNetService.PTRFDataRecievedOnJobviewDataChange deselectJV1 = new PTRF_DotNetService.PTRFDataRecievedOnJobviewDataChange();
    deselectJV1.messageID = '12346';
    deselectJV1.ptrfNumber = ptrf1.Name;
    deselectJV1.jobviewers = new list<PTRF_DotNetService.Jobviewer>();
    deselectJV1.jobviewers.addAll(jobviewerlist);
    deselectJVlist.add(deselectJV1);
    
    PTRF_DotNetService.sync_PTRF_NewJobView_ChangesInJobView(deselectJVlist);
   
    
     }
     
     Public static TestMethod void testPTRF_DotNetServiceNegative(){
        Account acc= getAccount('MYTEST ACCOUNT2');
        Environment_Variable__c env = [select id,name,value__c from Environment_Variable__c where name='HCM Emp AccountId'];
        env.value__c=acc.Id;
        update env;
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
    PTRF__c ptrf1 = new PTRF__c(Name='UATTEST',Order_Type__c = 'testOrder1',Recticle_Type__c='Multi Layer Reticle (MLR)',Customer_jobview__c='Gating Mask Release');
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
    Test.StopTest();
    }   
     public static TestMethod void syncLayerResponseTest()
   {
      List<MRS_dotNET_ResponseService.LayerResponseProxy> lstLayerChip = new list<MRS_dotNET_ResponseService.LayerResponseProxy>();
      Mask_Set_Title__c mst = SwiftDataUtilityTest.createMST('TESTU01');
      insert mst;
      
      PTRF__c ptrf = new PTRF__c(Name='ACOU1',
                                  DRW_Disposition__c = 'Risk tapeout with violations', 
                                  DRC_DRW_Status__c = 'DRC',
                                  Frame_Tapeout__c = True,
                                  Prime_Tapeout__c = True,
                                  MaskSetTitle__c =mst.Id,
                                  DRC_Only__c= True,
                                  PTRF_DRC_Option__c= 'Foundry run and gating mask release', 
                                  Recticle_Type__c = 'Single Layer Reticle (SLR)', 
                                  Order_Type__c = 'testOrder', 
                                  Customer_jobview__c='Gating Mask Release', 
                                  Frame_Status__c = 'Cancelled Frame');
      insert ptrf;
      
      
      
      MRS__c mrs = new MRS__c(Full_Sync__c =true,
                                   Synced_with_Oracle_DB__c = false,
                                   MRS_Package_Sync__c = false,
                                   Mask_Set_Title__c = mst.Id);
      insert mrs; 
      
      MRS_Layer_Association__c mrsLayer = new MRS_Layer_Association__c(Name ='layer001',
                                                                           Synced_with_Oracle_DB__c= true, 
                                                                           Mask_Layer_Rev__c = '899',
                                                                           Layer_Name__c = 'testLayer001',
                                                                           Layer_Status__c = 'Not Ready',
                                                                           mrs__c = mrs.id);
      insert mrslayer; 
      
      MRS_Chip_Details__c mrsChip = new MRS_Chip_Details__c(Name='chip001',
                                                                Synced_with_Oracle_DB__c=true, //false,
                                                                mrs__c = mrs.id);
      insert mrsChip; 
      
      MRS_Layer_Chip_Association__c layerChip = new MRS_Layer_Chip_Association__c(Name='layerChip001',
                                                                                      Synced_with_Oracle_DB__c=true,
                                                                                      Layer__c=mrsLayer.Id,
                                                                                      Chip__c=mrsChip.Id,
                                                                                      PTRF__c=ptrf.Id,
                                                                                      DRW__c = 'Not Ready');
      insert layerChip;
      
      PTRF__c pSelected = [SELECT Id,DRC_DRW_Status__c FROM PTRF__c where Id =:ptrf.Id];
      pSelected.DRC_DRW_Status__c= 'DRW';
       pSelected.DRW_Disposition__c = 'No violations';
      update pSelected; 
      
       
  }  
  
   public static TestMethod void syncLayerResponseTest2()
   {
      List<MRS_dotNET_ResponseService.LayerResponseProxy> lstLayerChip = new list<MRS_dotNET_ResponseService.LayerResponseProxy>();
      Mask_Set_Title__c mst = SwiftDataUtilityTest.createMST('TESTU01');
      insert mst;
      
      PTRF__c ptrf = new PTRF__c(Name='ACOU1',
                                  DRW_Disposition__c = 'Risk tapeout with violations', 
                                  DRC_DRW_Status__c = 'DRW',
                                  Frame_Tapeout__c = True,
                                  Prime_Tapeout__c = True,
                                  MaskSetTitle__c =mst.Id,
                                  DRC_Only__c= True,
                                  PTRF_DRC_Option__c= 'Foundry run and gating mask release', 
                                  Recticle_Type__c = 'Single Layer Reticle (SLR)', 
                                  Order_Type__c = 'testOrder', 
                                  Customer_jobview__c='Gating Mask Release', 
                                  Frame_Status__c = 'Cancelled Frame');
      insert ptrf;
      
      
      
      MRS__c mrs = new MRS__c(Full_Sync__c =true,
                                   Synced_with_Oracle_DB__c = false,
                                   MRS_Package_Sync__c = false,
                                   Mask_Set_Title__c = mst.Id);
      insert mrs; 
      
      MRS_Layer_Association__c mrsLayer = new MRS_Layer_Association__c(Name ='layer001',
                                                                           Synced_with_Oracle_DB__c= true, 
                                                                           Mask_Layer_Rev__c = '899',
                                                                           Layer_Name__c = 'testLayer001',
                                                                           Layer_Status__c = 'Not Ready',
                                                                           mrs__c = mrs.id);
      insert mrslayer; 
      
      MRS_Chip_Details__c mrsChip = new MRS_Chip_Details__c(Name='chip001',
                                                                Synced_with_Oracle_DB__c=true, //false,
                                                                mrs__c = mrs.id);
      insert mrsChip; 
      
      MRS_Layer_Chip_Association__c layerChip = new MRS_Layer_Chip_Association__c(Name='layerChip001',
                                                                                      Synced_with_Oracle_DB__c=true,
                                                                                      Layer__c=mrsLayer.Id,
                                                                                      Chip__c=mrsChip.Id,
                                                                                      PTRF__c=ptrf.Id,
                                                                                      DRW__c = 'In Progress');
      insert layerChip;
      
     
      
       PTRF__c pSelected1 = [SELECT Id,DRC_DRW_Status__c FROM PTRF__c where Id =:ptrf.Id];
      pSelected1.DRC_DRW_Status__c= 'Completed';
       pSelected1.DRW_Disposition__c = 'No violations';
      update pSelected1; 
  }  
  
  
   public static TestMethod void syncLayerResponseTest3()
   {
      List<MRS_dotNET_ResponseService.LayerResponseProxy> lstLayerChip = new list<MRS_dotNET_ResponseService.LayerResponseProxy>();
      Mask_Set_Title__c mst = SwiftDataUtilityTest.createMST('TESTU01');
      insert mst;
      
      PTRF__c ptrf = new PTRF__c(Name='ACOU1',
                                  DRW_Disposition__c = 'Risk tapeout with violations', 
                                  DRC_DRW_Status__c = 'DRC',
                                  Frame_Tapeout__c = True,
                                  Prime_Tapeout__c = True,
                                  MaskSetTitle__c =mst.Id,
                                  DRC_Only__c= True,
                                  PTRF_DRC_Option__c= 'Foundry run and gating mask release', 
                                  Recticle_Type__c = 'Single Layer Reticle (SLR)', 
                                  Order_Type__c = 'testOrder', 
                                  Customer_jobview__c='Gating Mask Release', 
                                  Frame_Status__c = 'Cancelled Frame');
      insert ptrf;
      
      
      
      MRS__c mrs = new MRS__c(Full_Sync__c =true,
                                   Synced_with_Oracle_DB__c = false,
                                   MRS_Package_Sync__c = false,
                                   Mask_Set_Title__c = mst.Id);
      insert mrs; 
      
      MRS_Layer_Association__c mrsLayer = new MRS_Layer_Association__c(Name ='layer001',
                                                                           Synced_with_Oracle_DB__c= true, 
                                                                           Mask_Layer_Rev__c = '899',
                                                                           Layer_Name__c = 'testLayer001',
                                                                           Layer_Status__c = 'Not Ready',
                                                                           mrs__c = mrs.id);
      insert mrslayer; 
      
      MRS_Chip_Details__c mrsChip = new MRS_Chip_Details__c(Name='Frame',
                                                                Synced_with_Oracle_DB__c=true, //false,
                                                                mrs__c = mrs.id);
      insert mrsChip; 
      
      MRS_Layer_Chip_Association__c layerChip = new MRS_Layer_Chip_Association__c(Name='layerChip001',
                                                                                      Synced_with_Oracle_DB__c=true,
                                                                                      Layer__c=mrsLayer.Id,
                                                                                      Chip__c=mrsChip.Id,
                                                                                      PTRF__c=ptrf.Id,
                                                                                      Tech_Geo__c = '0.065UM',
                                                                                      Customer_Frame_Mockup__c= 'Ready',
                                                                                      Foundry_Frame_Mockup__c= 'Ready');
      insert layerChip;
      MRS_Layer_Chip_Association__c layerChip1 = new MRS_Layer_Chip_Association__c(Name='layerChip001',
                                                                                      Synced_with_Oracle_DB__c=true,
                                                                                      Layer__c=mrsLayer.Id,
                                                                                      Chip__c=mrsChip.Id,
                                                                                      PTRF__c=ptrf.Id,
                                                                                      Tech_Geo__c = '0.1UM',
                                                                                      Customer_Frame_Mockup__c= 'Ready',
                                                                                      Foundry_Frame_Mockup__c= 'Ready');
      insert layerChip1;
       MRS_Layer_Chip_Association__c layerChip3 = new MRS_Layer_Chip_Association__c(Name='layerChip001',
                                                                                      Synced_with_Oracle_DB__c=true,
                                                                                      Layer__c=mrsLayer.Id,
                                                                                      Chip__c=mrsChip.Id,
                                                                                      PTRF__c=ptrf.Id,
                                                                                      Customer_Frame_Mockup__c= 'Ready',
                                                                                      Foundry_Frame_Mockup__c= 'Ready');
      insert layerChip3;
      
      PTRF__c pSelected = [SELECT Id,DRC_DRW_Status__c FROM PTRF__c where Id =:ptrf.Id];
      pSelected.Frame_Status__c= 'Frame Generation';
       pSelected.DRW_Disposition__c = 'No violations';
      update pSelected; 
      
       
  }  
  
   public static TestMethod void syncLayerResponseTest4()
   {
      List<MRS_dotNET_ResponseService.LayerResponseProxy> lstLayerChip = new list<MRS_dotNET_ResponseService.LayerResponseProxy>();
      Mask_Set_Title__c mst = SwiftDataUtilityTest.createMST('TESTU01');
      insert mst;
      
      PTRF__c ptrf = new PTRF__c(Name='ACOU1',
                                  DRW_Disposition__c = 'Risk tapeout with violations', 
                                  DRC_DRW_Status__c = 'DRW',
                                  Frame_Tapeout__c = True,
                                  Prime_Tapeout__c = True,
                                  MaskSetTitle__c =mst.Id,
                                  DRC_Only__c= True,
                                  PTRF_DRC_Option__c= 'Foundry run and gating mask release', 
                                  Recticle_Type__c = 'Single Layer Reticle (SLR)', 
                                  Order_Type__c = 'testOrder', 
                                  Customer_jobview__c='Gating Mask Release', 
                                  Frame_Status__c = 'Cancelled Frame');
      insert ptrf;
      
      
      
      MRS__c mrs = new MRS__c(Full_Sync__c =true,
                                   Synced_with_Oracle_DB__c = false,
                                   MRS_Package_Sync__c = false,
                                   Mask_Set_Title__c = mst.Id);
      insert mrs; 
      
      MRS_Layer_Association__c mrsLayer = new MRS_Layer_Association__c(Name ='layer001',
                                                                           Synced_with_Oracle_DB__c= true, 
                                                                           Mask_Layer_Rev__c = '899',
                                                                           Layer_Name__c = 'testLayer001',
                                                                           Layer_Status__c = 'Not Ready',
                                                                           mrs__c = mrs.id);
      insert mrslayer; 
      
      MRS_Chip_Details__c mrsChip = new MRS_Chip_Details__c(Name='Frame',
                                                                Synced_with_Oracle_DB__c=true, //false,
                                                                mrs__c = mrs.id);
      insert mrsChip; 
      
      MRS_Layer_Chip_Association__c layerChip = new MRS_Layer_Chip_Association__c(Name='layerChip001',
                                                                                      Synced_with_Oracle_DB__c=true,
                                                                                      Layer__c=mrsLayer.Id,
                                                                                      Chip__c=mrsChip.Id,
                                                                                      PTRF__c=ptrf.Id,
                                                                                      Tech_Geo__c = '0.065UM',
                                                                                      Send_Frame_Data__c = 'Not Done',
                                                                                      Customer_Frame_Mockup__c= 'N.A.',
                                                                                      Foundry_Frame_Mockup__c= 'N.A.');
      insert layerChip;
      
      MRS_Layer_Chip_Association__c layerChip1 = new MRS_Layer_Chip_Association__c(Name='layerChip001',
                                                                                      Synced_with_Oracle_DB__c=true,
                                                                                      Layer__c=mrsLayer.Id,
                                                                                      Chip__c=mrsChip.Id,
                                                                                      PTRF__c=ptrf.Id,
                                                                                      Tech_Geo__c = '0.1UM',
                                                                                      Customer_Frame_Mockup__c= 'Ready',
                                                                                      Foundry_Frame_Mockup__c= 'Not Ready');
      insert layerChip1;
      
     MRS_Layer_Chip_Association__c layerChip3 = new MRS_Layer_Chip_Association__c(Name='layerChip001',
                                                                                      Synced_with_Oracle_DB__c=true,
                                                                                      Layer__c=mrsLayer.Id,
                                                                                      Chip__c=mrsChip.Id,
                                                                                      PTRF__c=ptrf.Id,
                                                                                      Customer_Frame_Mockup__c= 'Ready',
                                                                                      Foundry_Frame_Mockup__c= 'Ready');
      insert layerChip3;
      
       PTRF__c pSelected1 = [SELECT Id,DRC_DRW_Status__c FROM PTRF__c where Id =:ptrf.Id];
      pSelected1.Frame_Status__c = 'Completed';
       pSelected1.DRW_Disposition__c = 'No violations';
      update pSelected1; 
  }  
   public static TestMethod void syncLayerResponseTest5()
   {
      List<MRS_dotNET_ResponseService.LayerResponseProxy> lstLayerChip = new list<MRS_dotNET_ResponseService.LayerResponseProxy>();
      Mask_Set_Title__c mst = SwiftDataUtilityTest.createMST('TESTU01');
      insert mst;
      list<account> lstAcc = new list<account>();
      lstAcc = [select id from account where name like '%Test rec%'];
      delete lstAcc;
      AccountTriggerRun.hasAccountTriggerRun =false;
       Account acc= getAccount('MYTEST ACCOUNT2');
        
      DRT__c[] drtp = SwiftDataUtilityTest.createDRTList1(2,mst,acc.id);
       DRT__c[]drtf = SwiftDataUtilityTest.createDRTListForFrame(2,mst,acc.id);
       
      string DRTPName = drtp[0].Name;
      string DRTFName = drtf[0].Name;
      string DRTP1Name = drtp[1].Name;
      string DRTF1Name = drtf[1].Name;
      string DRTPId1Name = drtp[1].id;
      string DRTFId1Name = drtf[1].id;
      
      PTRF__c ptrf = new PTRF__c(Name='ACOU1',
                                  DRW_Disposition__c = 'Risk tapeout with violations', 
                                  DRC_DRW_Status__c = 'DRW',
                                  Frame_Tapeout__c = True,
                                  Prime_Tapeout__c = True,
                                  MaskSetTitle__c =mst.Id,
                                  DRC_Only__c= True,
                                  Prime_DRT__c= 'DRTP1Name',
                                  Frame_DRT__c= 'DRTF1Name',
                                  PTRF_DRC_Option__c= 'Foundry run and gating mask release', 
                                  Recticle_Type__c = 'Single Layer Reticle (SLR)', 
                                  Order_Type__c = 'testOrder', 
                                  Customer_jobview__c='Gating Mask Release', 
                                  Frame_Status__c = 'Cancelled Frame');
      insert ptrf;
      
      
      MRS__c mrs = new MRS__c(Full_Sync__c =true,
                                   Synced_with_Oracle_DB__c = false,
                                   MRS_Package_Sync__c = false,
                                   Mask_Set_Title__c = mst.Id);
      insert mrs; 
      
      MRS_Layer_Association__c mrsLayer = new MRS_Layer_Association__c(Name ='layer001',
                                                                           Synced_with_Oracle_DB__c= true, 
                                                                           Mask_Layer_Rev__c = '899',
                                                                           Layer_Name__c = 'testLayer001',
                                                                           Layer_Status__c = 'Not Ready',
                                                                           mrs__c = mrs.id);
      insert mrslayer; 
      
      MRS_Chip_Details__c mrsChip = new MRS_Chip_Details__c(Name='Frame',
                                                                Synced_with_Oracle_DB__c=true, //false,
                                                                mrs__c = mrs.id);
      insert mrsChip; 
      
      MRS_Layer_Chip_Association__c layerChip = new MRS_Layer_Chip_Association__c(Name='layerChip001',
                                                                                      Synced_with_Oracle_DB__c=true,
                                                                                      Layer__c=mrsLayer.Id,
                                                                                      Chip__c=mrsChip.Id,
                                                                                      PTRF__c=ptrf.Id,
                                                                                      Tech_Geo__c = '0.065UM',
                                                                                      Customer_Frame_Mockup__c= 'Not Ready',
                                                                                      Foundry_Frame_Mockup__c= 'Not Ready');
      insert layerChip;
      
      MRS_Layer_Chip_Association__c layerChip1 = new MRS_Layer_Chip_Association__c(Name='layerChip001',
                                                                                      Synced_with_Oracle_DB__c=true,
                                                                                      Layer__c=mrsLayer.Id,
                                                                                      Chip__c=mrsChip.Id,
                                                                                      PTRF__c=ptrf.Id,
                                                                                      Tech_Geo__c = '0.1UM',
                                                                                      Customer_Frame_Mockup__c= 'Not Ready',
                                                                                      Foundry_Frame_Mockup__c= 'Not Ready');
      insert layerChip1;
      
     MRS_Layer_Chip_Association__c layerChip3 = new MRS_Layer_Chip_Association__c(Name='layerChip001',
                                                                                      Synced_with_Oracle_DB__c=true,
                                                                                      Layer__c=mrsLayer.Id,
                                                                                      Chip__c=mrsChip.Id,
                                                                                      PTRF__c=ptrf.Id,
                                                                                      Customer_Frame_Mockup__c= 'Ready',
                                                                                      Foundry_Frame_Mockup__c= 'Ready');
      insert layerChip3;
      
       PTRF__c pSelected1 = [SELECT Id,DRC_DRW_Status__c FROM PTRF__c where Id =:ptrf.Id];
      pSelected1.Prime_DRT__c= 'DRTPName';
      pSelected1.Frame_DRT__c= 'DRTFName';
      update pSelected1; 
      
      DRT_PTRF_Association__c ptrfDrtIns = new DRT_PTRF_Association__c();
      ptrfDrtIns.DRT__c= DRTPId1Name;
      ptrfDrtIns.PTRF__c= ptrf.id;
      insert ptrfDrtIns;
      DRT_PTRF_Association__c ptrfDrtIns1 = new DRT_PTRF_Association__c();
      ptrfDrtIns1.DRT__c= DRTFId1Name;
      ptrfDrtIns1.PTRF__c= ptrf.id;
      insert ptrfDrtIns1;
      set<string> DrtNewName = new set<string>();
      DrtNewName.add('DRTPName');
      DrtNewName.add('DRTFName');
      set<string> ptrf2Name = new set<string>();
      ptrf2Name.add('PTRFs');
      list<string> ptrf1Name = new list<string>();
      ptrf1Name.add('PTRFd');
      list<id> ptrfId = new list<id>();
      ptrfId.add(ptrf.id);
      set<id> drtNameDel = new set<id>();
      drtNameDel.add(DRTPId1Name);
      set<id> drtfNameDel = new set<id>();
      drtfNameDel.add(DRTFId1Name);
      
      PTRF_FrameGen_DRW_StatusUpdate.DRT_PtrfAssociationupdate(ptrfId,drtfNameDel,drtNameDel,DrtNewName,ptrf1Name ,ptrf2Name );
      
  }
  
  public static TestMethod void syncLayerResponseTest6()
   {
      List<MRS_dotNET_ResponseService.LayerResponseProxy> lstLayerChip = new list<MRS_dotNET_ResponseService.LayerResponseProxy>();
      Mask_Set_Title__c mst = SwiftDataUtilityTest.createMST('TESTU01');
      insert mst;
      list<account> lstAcc = new list<account>();
      lstAcc = [select id from account where name like '%Test rec%'];
      delete lstAcc;
      AccountTriggerRun.hasAccountTriggerRun =false;
      Account acc= getAccount('MYTEST ACCOUNT1');
      DRT__c[] drtp = SwiftDataUtilityTest.createDRTList1(2,mst,acc.id);
       DRT__c[]drtf = SwiftDataUtilityTest.createDRTListForFrame(2,mst,acc.id);
      string DRTPName = drtp[0].Name;
      string DRTFName = drtf[0].Name;
      string DRTP1Name = drtp[1].Name;
      string DRTF1Name = drtf[1].Name;
      
      PTRF__c ptrf = new PTRF__c(Name='ACOU1',
                                  DRW_Disposition__c = 'Risk tapeout with violations', 
                                  DRC_DRW_Status__c = 'Completed',
                                  Frame_Tapeout__c = True,
                                  Prime_Tapeout__c = True,
                                  MaskSetTitle__c =mst.Id,
                                  DRC_Only__c= True,
                                  Prime_DRT__c= 'DRTP1Name',
                                  Frame_DRT__c= 'DRTF1Name',
                                  PTRF_DRC_Option__c= 'Foundry run and gating mask release', 
                                  Recticle_Type__c = 'Single Layer Reticle (SLR)', 
                                  Order_Type__c = 'testOrder', 
                                  Customer_jobview__c='Gating Mask Release', 
                                  Frame_Status__c = 'Completed');
      insert ptrf;
      
      
      
      MRS__c mrs = new MRS__c(Full_Sync__c =true,
                                   Synced_with_Oracle_DB__c = false,
                                   MRS_Package_Sync__c = false,
                                   Mask_Set_Title__c = mst.Id);
      insert mrs; 
      
      MRS_Layer_Association__c mrsLayer = new MRS_Layer_Association__c(Name ='layer001',
                                                                           Synced_with_Oracle_DB__c= true, 
                                                                           Mask_Layer_Rev__c = '899',
                                                                           Layer_Name__c = 'testLayer001',
                                                                           Layer_Status__c = 'Not Ready',
                                                                           mrs__c = mrs.id);
      insert mrslayer; 
      
      MRS_Chip_Details__c mrsChip = new MRS_Chip_Details__c(Name='Frame',
                                                                Synced_with_Oracle_DB__c=true, //false,
                                                                mrs__c = mrs.id);
      insert mrsChip; 
      
      MRS_Layer_Chip_Association__c layerChip = new MRS_Layer_Chip_Association__c(Name='layerChip001',
                                                                                      Synced_with_Oracle_DB__c=true,
                                                                                      Layer__c=mrsLayer.Id,
                                                                                      Chip__c=mrsChip.Id,
                                                                                      PTRF__c=ptrf.Id,
                                                                                      Tech_Geo__c = '0.065UM',DRW__c= 'Not Ready',
                                                                                      Customer_Frame_Mockup__c= 'Not Ready',
                                                                                      Foundry_Frame_Mockup__c= 'Not Ready');
      insert layerChip;
      
      MRS_Layer_Chip_Association__c layerChip1 = new MRS_Layer_Chip_Association__c(Name='layerChip001',
                                                                                      Synced_with_Oracle_DB__c=true,
                                                                                      Layer__c=mrsLayer.Id,
                                                                                      Chip__c=mrsChip.Id,
                                                                                      PTRF__c=ptrf.Id,
                                                                                      Tech_Geo__c = '0.1UM',DRW__c= 'In Progress',
                                                                                      Customer_Frame_Mockup__c= 'Not Ready',
                                                                                      Foundry_Frame_Mockup__c= 'Not Ready');
      insert layerChip1;
      
     MRS_Layer_Chip_Association__c layerChip3 = new MRS_Layer_Chip_Association__c(Name='layerChip001',
                                                                                      Synced_with_Oracle_DB__c=true,
                                                                                      Layer__c=mrsLayer.Id,
                                                                                      Chip__c=mrsChip.Id,
                                                                                      PTRF__c=ptrf.Id,
                                                                                      DRW__c= 'Not Ready',
                                                                                      Foundry_Frame_Mockup__c= 'Ready');
      insert layerChip3;
      
       PTRF__c pSelected1 = [SELECT Id,DRC_DRW_Status__c FROM PTRF__c where Id =:ptrf.Id];
      pSelected1.DRC_DRW_Status__c= 'Completed';
      pSelected1.DRW_Disposition__c = 'No violations';
      update pSelected1; 
  }
  
    public static TestMethod void syncLayerResponseTest7()
   {
      List<MRS_dotNET_ResponseService.LayerResponseProxy> lstLayerChip = new list<MRS_dotNET_ResponseService.LayerResponseProxy>();
      Mask_Set_Title__c mst = SwiftDataUtilityTest.createMST('TESTU01');
      insert mst;
      list<account> lstAcc = new list<account>();
      lstAcc = [select id from account where name like '%Test rec%'];
      delete lstAcc;
      AccountTriggerRun.hasAccountTriggerRun =false;
      Account acc = new Account(
            name = 'TEST recs'+string.valueOf(system.now().gettime()),
            Account_Type__c='Customer',
            stage__c = 'Unqualified',
            short_name__c = 'TESTrec',
            sub_type__c= 'Direct',
            site_department__c = 'test dept'+'7503252573267'+string.valueOf(math.random())+string.valueOf(system.now().gettime()),
            transaction_type__c = 'transactional',
            account_profile__c = 'Fabless - Emerging',
            Process_Tech_Interested__c = 'Mature (> 0.11um)',
            region__c = 'APJ',
            Market_Segment__c = 'Mobility',
            Sales_Territory__c = 'APJ-Japan',
            FE_Territory__c = 'APJ-FE-JAPAN',
            financial_territory__c = 'APJ-Japan',
            Corporate_Address_1__c = '50 water st',
            Bill_To_Address_1__c= '50 water st',
            Corporate_City__c = 'Lee',
            Bill_To_City__c='Lee',
            Corporate_Country__c = 'Japan',
             Bill_To_Country__c='Japan',
            Organization_Unit__c = 'GF Investment LLC OU',
            bill_to_location__c = 'YES',
            total_employee__c = 100,
            end_customer__c = 'people',
            Revenue_Potential__c = 'High Potential',
            Customer_Number__c='',
            Target_Account__c = 'Yes',
            siebel_account_id__c='1111'
        );
        insert acc;
      
      DRT__c[] drtp = SwiftDataUtilityTest.createDRTList1(2,mst,acc.id);
       DRT__c[]drtf = SwiftDataUtilityTest.createDRTListForFrame(2,mst,acc.id);
      string DRTPName = drtp[0].Name;
      string DRTFName = drtf[0].Name;
     
      
      PTRF__c ptrf = new PTRF__c(Name='ACOU1',
                                  DRW_Disposition__c = 'Risk tapeout with violations', 
                                  DRC_DRW_Status__c = 'DRW',
                                  Frame_Tapeout__c = True,
                                  Prime_Tapeout__c = True,
                                  MaskSetTitle__c =mst.Id,
                                  DRC_Only__c= True,
                                  Prime_DRT__c= '',
                                  Frame_DRT__c= '',
                                  PTRF_DRC_Option__c= 'Foundry run and gating mask release', 
                                  Recticle_Type__c = 'Single Layer Reticle (SLR)', 
                                  Order_Type__c = 'testOrder', 
                                  Customer_jobview__c='Gating Mask Release', 
                                  Frame_Status__c = 'Cancelled Frame');
      insert ptrf;
      
      
      
      MRS__c mrs = new MRS__c(Full_Sync__c =true,
                                   Synced_with_Oracle_DB__c = false,
                                   MRS_Package_Sync__c = false,
                                   Mask_Set_Title__c = mst.Id);
      insert mrs; 
      Test.startTest();
      MRS_Layer_Association__c mrsLayer = new MRS_Layer_Association__c(Name ='layer001',
                                                                           Synced_with_Oracle_DB__c= true, 
                                                                           Mask_Layer_Rev__c = '899',
                                                                           Layer_Name__c = 'testLayer001',
                                                                           Layer_Status__c = 'Not Ready',
                                                                           mrs__c = mrs.id);
      insert mrslayer; 
      
      MRS_Chip_Details__c mrsChip = new MRS_Chip_Details__c(Name='Frame',
                                                                Synced_with_Oracle_DB__c=true, //false,
                                                                mrs__c = mrs.id);
      insert mrsChip; 
      
      MRS_Layer_Chip_Association__c layerChip = new MRS_Layer_Chip_Association__c(Name='layerChip001',
                                                                                      Synced_with_Oracle_DB__c=true,
                                                                                      Layer__c=mrsLayer.Id,
                                                                                      Chip__c=mrsChip.Id,
                                                                                      PTRF__c=ptrf.Id,
                                                                                      Tech_Geo__c = '0.065UM',
                                                                                      Customer_Frame_Mockup__c= 'Not Ready',
                                                                                      Foundry_Frame_Mockup__c= 'Not Ready');
      insert layerChip;
      
      MRS_Layer_Chip_Association__c layerChip1 = new MRS_Layer_Chip_Association__c(Name='layerChip001',
                                                                                      Synced_with_Oracle_DB__c=true,
                                                                                      Layer__c=mrsLayer.Id,
                                                                                      Chip__c=mrsChip.Id,
                                                                                      PTRF__c=ptrf.Id,
                                                                                      Tech_Geo__c = '0.1UM',
                                                                                      Customer_Frame_Mockup__c= 'Not Ready',
                                                                                      Foundry_Frame_Mockup__c= 'Not Ready');
      insert layerChip1;
      
     MRS_Layer_Chip_Association__c layerChip3 = new MRS_Layer_Chip_Association__c(Name='layerChip001',
                                                                                      Synced_with_Oracle_DB__c=true,
                                                                                      Layer__c=mrsLayer.Id,
                                                                                      Chip__c=mrsChip.Id,
                                                                                      PTRF__c=ptrf.Id,
                                                                                      Customer_Frame_Mockup__c= 'Ready',
                                                                                      Foundry_Frame_Mockup__c= 'Ready');
      insert layerChip3;
      
       PTRF__c pSelected1 = [SELECT Id,DRC_DRW_Status__c FROM PTRF__c where Id =:ptrf.Id];
      pSelected1.Prime_DRT__c= 'DRTPName';
      pSelected1.Frame_DRT__c= 'DRTFName';
      update pSelected1; 
      Test.stopTest();
  }
  //Test method for apex class: SWIFTDRTPTRFDeleteService 
 
    global class WebServiceMockImplPTRFdel implements WebServiceMock {
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
               SWIFTDRTPTRFDeleteService.ProcessResponse_element  respElement = 
               new SWIFTDRTPTRFDeleteService.ProcessResponse_element();
               respElement.response = new list<string>{ 'Mock Response'};
               response.put('response_x',respElement); 
               }
            }
            
             private static Account getAccount(string AccountName)
            {
                Account testAcct= [SELECT Id, Name FROM Account Where Name =: AccountName];
        
                return testAcct;
            }  
     
}