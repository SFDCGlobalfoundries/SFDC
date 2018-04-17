@isTest(seeAllData = true)
global class MRS_dotNET_ResponseServiceTest{
    global class WebServiceMockImplNew implements WebServiceMock 
    {
           global void doInvoke(
                   Object stub,
                   Object request,
                   Map<String, Object> response,
                   String endpoint,
                   String soapAction,
                   String requestName,
                   String responseNS,
                   String responseName,
                   String responseType)
                   {
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
                   
   public static TestMethod void syncLayerResponseTest()
   {
      List<MRS_dotNET_ResponseService.LayerResponseProxy> lstLayerChip = new list<MRS_dotNET_ResponseService.LayerResponseProxy>();
      Mask_Set_Title__c mst = SwiftDataUtilityTest.createMST('MYMST1');
      insert mst;
      
      PTRF__c ptrf = new PTRF__c(Name='ACOU1',MaskSetTitle__c =mst.Id,Order_Type__c = 'testOrder',Recticle_Type__c='Multi Layer Reticle (MLR)',Customer_jobview__c='Gating Mask Release', Frame_Status__c = 'Cancelled Frame');
      insert ptrf;
      
      PTRF__c pSelected = [SELECT Id,Frame_Status__c FROM PTRF__c where Id =:ptrf.Id];
      pSelected.Frame_Status__c = 'Completed';
      update pSelected; 
      
      
     // PTRF__c ptrfcheck01 = new PTRF__c(Name='ACOU1',DRW_Disposition__c = 'Violations waive', MaskSetTitle__c = mst.Id, Order_Type__c = 'testOrder', Recticle_Type__c ='Multi Layer Reticle (MLR)',Customer_jobview__c='Gating Mask Release', Frame_Status__c = 'Cancelled Frame', DRC_DRW_Status__c ='DRW');
     // insert ptrfcheck01 ;
      
     // PTRF__c  psl = [SELECT Id, DRC_DRW_Status__c, DRW_Disposition__c FROM PTRF__c where id = :ptrfcheck01.id];
    //  psl.DRC_DRW_Status__c = 'Completed';
      //ps1.DRW_Disposition__c = 'No violations';
     // update psl;
      
      MRS__c mrs = new MRS__c(Full_Sync__c =true,
                                   Synced_with_Oracle_DB__c=false,
                                   MRS_Package_Sync__c=false,
                                   Mask_Set_Title__c=mst.Id);
      insert mrs; 
      
      MRS_Layer_Association__c mrsLayer = new MRS_Layer_Association__c(Name ='layer001',
                                                                           Synced_with_Oracle_DB__c= true, //false,
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
                                                                                      PTRF__c=ptrf.Id
                                                                                      );
      insert layerChip;
      
      User u1 = [Select Id,Email from User Where HCM_Login_ID__c != ''LIMIT 1];
      
      PTRF_JobViewer_Info__c tempJobViewer = new PTRF_JobViewer_Info__c(Name='testJobViewer',User__c = u1.Id,
                                                                      PTRF__c=ptrf.Id,Jobview__c='Foundry',Jobview_Type__c='MEBES Jobview',
                                                                      Email_Address__c='satyajit.kumarsingh@cognizant.com');
                                                                      
      MRS_dotNET_ResponseService.LayerResponseProxy lstLayerChip1 = new MRS_dotNET_ResponseService.LayerResponseProxy();
      
      lstLayerChip1.PTRFnumber=ptrf.Id;
      lstLayerChip1.LayerStatus='SUCCESS';
      lstLayerChip1.status='SUCCESS';      
      lstLayerChip.add(lstLayerChip1);
      
      MRS_dotNET_ResponseService.LayerResponseProxy lstLayerChip2 = new MRS_dotNET_ResponseService.LayerResponseProxy();
      
      lstLayerChip2.PTRFnumber=ptrf.Name;
      lstLayerChip2.LayerStatus='ERROR';
      lstLayerChip2.status='SUCCESS';  
      lstLayerChip.add(lstLayerChip2);
      
      MRS_dotNET_ResponseService.syncLayerResponse(lstLayerChip);             
   }
   public static TestMethod void syncMRSPrimeFrameResponseTest()
   {
      List<MRS_dotNET_ResponseService.MRSPrimeFrameSendDataResponseProxy> lstLayerFrame = new list<MRS_dotNET_ResponseService.MRSPrimeFrameSendDataResponseProxy>();
       Mask_Set_Title__c mst = SwiftDataUtilityTest.createMST('MYMST01');
      insert mst;
      
      PTRF__c ptrf = new PTRF__c(Name='ACOU1',MaskSetTitle__c =mst.Id,Order_Type__c = 'testOrder',Recticle_Type__c='Multi Layer Reticle (MLR)',Customer_jobview__c='Gating Mask Release');
      insert ptrf;
      
      MRS__c mrs = new MRS__c(Full_Sync__c =true,
                                   Synced_with_Oracle_DB__c=false,
                                   MRS_Package_Sync__c=false,
                                   Mask_Set_Title__c=mst.Id);
      insert mrs; 
      
      MRS_Layer_Association__c mrsLayer = new MRS_Layer_Association__c(Name ='layer001',
                                                                           Synced_with_Oracle_DB__c= true, //false,
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
                                                                                      PTRF__c=ptrf.Id);
      insert layerChip;
      
      User u1 = [Select Id,Email from User Where HCM_Login_ID__c != ''LIMIT 1];
      
      PTRF_JobViewer_Info__c tempJobViewer = new PTRF_JobViewer_Info__c(Name='testJobViewer',User__c=u1.Id,
                                                                      PTRF__c=ptrf.Id,Jobview__c='Foundry',Jobview_Type__c='MEBES Jobview',
                                                                      Email_Address__c='satyajit.kumarsingh@cognizant.com');
      
      MRS_dotNET_ResponseService.MRSPrimeFrameSendDataResponseProxy lstLayerFrame1 = new MRS_dotNET_ResponseService.MRSPrimeFrameSendDataResponseProxy();
      
      lstLayerFrame1.PTRFnumber=ptrf.Id;
      lstLayerFrame1.status='SUCCESS';
      lstLayerFrame.add(lstLayerFrame1);
      
      MRS_dotNET_ResponseService.MRSPrimeFrameSendDataResponseProxy lstLayerFrame2 = new MRS_dotNET_ResponseService.MRSPrimeFrameSendDataResponseProxy();
      
      lstLayerFrame2.PTRFnumber=ptrf.Id;
      lstLayerFrame2.status='ERROR';
      lstLayerFrame.add(lstLayerFrame2);
      
      //MRS_dotNET_ResponseService.syncMRSPrimeFrameResponse(lstLayerFrame);  
      
      MRS_dotNET_ResponseService.MRSPrimeFrameSendDataResponseProxy lstLayerFrame11 = new MRS_dotNET_ResponseService.MRSPrimeFrameSendDataResponseProxy();
      
      //lstLayerFrame11.PTRFnumber=ptrf.Id;
      lstLayerFrame11.status='SUCCESS';
      lstLayerFrame.add(lstLayerFrame11);
      
      MRS_dotNET_ResponseService.MRSPrimeFrameSendDataResponseProxy lstLayerFrame21 = new MRS_dotNET_ResponseService.MRSPrimeFrameSendDataResponseProxy();
      
      //lstLayerFrame21.PTRFnumber=ptrf.Id;
      lstLayerFrame21.status='ERROR';
      lstLayerFrame.add(lstLayerFrame21);
      
      MRS_dotNET_ResponseService.syncMRSPrimeFrameResponse(lstLayerFrame);          
   }
    public static TestMethod void syncMRSrevisedDRTResponseTest()
   {
      List<MRS_dotNET_ResponseService.MRSrevisedDRTresponseProxy> lstLayerMrs = new list<MRS_dotNET_ResponseService.MRSrevisedDRTresponseProxy>();
      
       Mask_Set_Title__c mst = SwiftDataUtilityTest.createMST('MYMST02');
      insert mst;
      
      PTRF__c ptrf = new PTRF__c(Name='ACOU1',MaskSetTitle__c =mst.Id,Order_Type__c = 'testOrder',Recticle_Type__c='Multi Layer Reticle (MLR)',Customer_jobview__c='Gating Mask Release');
      insert ptrf;
      
      MRS__c mrs = new MRS__c(Full_Sync__c =true,
                                   Synced_with_Oracle_DB__c=false,
                                   MRS_Package_Sync__c=false,
                                   Mask_Set_Title__c=mst.Id);
      insert mrs; 
      
      DRT__c drt1 = new DRT__c(Mask_Set_Title__c=mst.Id,name='Drt001');
      insert drt1;
      
      DRT__c drt2 = new DRT__c(Mask_Set_Title__c=mst.Id,name='Drt002');
      insert drt2;
      
      MRS_Layer_Association__c mrsLayer = new MRS_Layer_Association__c(Name ='layer001',
                                                                           Synced_with_Oracle_DB__c= true, //false,
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
                                                                                      PTRF__c=ptrf.Id);
      insert layerChip;
      
      User u1 = [Select Id,Email from User Where HCM_Login_ID__c != '' LIMIT 1];
      
      PTRF_JobViewer_Info__c tempJobViewer = new PTRF_JobViewer_Info__c(Name='testJobViewer',User__c=u1.Id,
                                                                      PTRF__c=ptrf.Id,Jobview__c='Foundry',Jobview_Type__c='MEBES Jobview',
                                                                      Email_Address__c='satyajit.kumarsingh@cognizant.com');
      
      MRS_dotNET_ResponseService.MRSrevisedDRTresponseProxy lstLayerFrame1 = new MRS_dotNET_ResponseService.MRSrevisedDRTresponseProxy();
      
      lstLayerFrame1.DRTnumber=drt1.Name;
      lstLayerFrame1.status='SUCCESS';
      lstLayerMrs.add(lstLayerFrame1);
      
      MRS_dotNET_ResponseService.MRSrevisedDRTresponseProxy lstLayerFrame2 = new MRS_dotNET_ResponseService.MRSrevisedDRTresponseProxy();
      
      lstLayerFrame2.DRTnumber=drt1.Name;
      lstLayerFrame2.status='ERROR';
      lstLayerMrs.add(lstLayerFrame2);
      
      MRS_dotNET_ResponseService.MRSrevisedDRTresponseProxy lstLayerFrame3 = new MRS_dotNET_ResponseService.MRSrevisedDRTresponseProxy();
      
      lstLayerFrame3.DRTnumber=drt1.Id;
      lstLayerFrame3.status='SUCCESS';
      lstLayerMrs.add(lstLayerFrame3);
                                                  
      MRS_dotNET_ResponseService.syncMRSrevisedDRTResponse(lstLayerMrs);             
   }
    public static TestMethod void syncMRSdisapprovalFrameMosckupResponseTest()
   {
      List<MRS_dotNET_ResponseService.MRSDisapprovalFrameMockupresponseProxy> lstLayerMrsframe = new list<MRS_dotNET_ResponseService.MRSDisapprovalFrameMockupresponseProxy>();
       Mask_Set_Title__c mst = SwiftDataUtilityTest.createMST('MYMST1');
      insert mst;
      
      PTRF__c ptrf = new PTRF__c(Name='ACOU1',MaskSetTitle__c =mst.Id,Order_Type__c = 'testOrder',Recticle_Type__c='Multi Layer Reticle (MLR)',Customer_jobview__c='Gating Mask Release');
      insert ptrf;
      
      MRS__c mrs = new MRS__c(Full_Sync__c =true,
                                   Synced_with_Oracle_DB__c=false,
                                   MRS_Package_Sync__c=false,
                                   Mask_Set_Title__c=mst.Id);
      insert mrs; 
      
      MRS_Layer_Association__c mrsLayer = new MRS_Layer_Association__c(Name ='layer001',
                                                                           Synced_with_Oracle_DB__c= true, //false,
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
                                                                                      Customer_Frame_Mockup__c='Disapprove');
      insert layerChip;
      
      MRS_Layer_Chip_Association__c layerChip1 = new MRS_Layer_Chip_Association__c(Name='layerChip002',
                                                                                      Synced_with_Oracle_DB__c=true,
                                                                                      Layer__c=mrsLayer.Id,
                                                                                      Chip__c=mrsChip.Id,
                                                                                      PTRF__c=ptrf.Id,
                                                                                      Foundry_Frame_Mockup__c='Disapprove');
      insert layerChip1;

      Notes__c note1=new Notes__c(MRS_Layer_Association__c=mrslayer.id,ParentId__c=layerChip.id,Body__c='Test01',category__c ='Customer Frame Mockup Disapproval');
      insert note1;
      
      Notes__c note2=new Notes__c(MRS_Layer_Association__c=mrslayer.id,ParentId__c=layerChip1.id,Body__c='Test02',category__c ='Foundry Frame Mockup Disapproval');
      insert note2;
      
      User u1 = [Select Id,Email from User Where HCM_Login_ID__c != ''LIMIT 1];
      
      PTRF_JobViewer_Info__c tempJobViewer = new PTRF_JobViewer_Info__c(Name='testJobViewer',User__c=u1.Id,
                                                                      PTRF__c=ptrf.Id,Jobview__c='Foundry',Jobview_Type__c='MEBES Jobview',
                                                                      Email_Address__c='satyajit.kumarsingh@cognizant.com');
      
      MRS_dotNET_ResponseService.MRSDisapprovalFrameMockupresponseProxy lstLayerFrame1 = new MRS_dotNET_ResponseService.MRSDisapprovalFrameMockupresponseProxy();
      
      lstLayerFrame1.PTRFnumber=ptrf.Name;
      lstLayerFrame1.status='SUCCESS';
      lstLayerMrsframe.add(lstLayerFrame1);
      
      MRS_dotNET_ResponseService.syncMRSdisapprovalFrameMosckupResponse(lstLayerMrsframe);  
      
      List<MRS_dotNET_ResponseService.MRSDisapprovalFrameMockupresponseProxy> lstLayerMrsframe1 = new list<MRS_dotNET_ResponseService.MRSDisapprovalFrameMockupresponseProxy>();
      MRS_dotNET_ResponseService.MRSDisapprovalFrameMockupresponseProxy lstLayerFrame2 = new MRS_dotNET_ResponseService.MRSDisapprovalFrameMockupresponseProxy();
      
      lstLayerFrame2.PTRFnumber=ptrf.Name;
      lstLayerFrame2.status='ERROR';
      lstLayerMrsframe1.add(lstLayerFrame2);
      MRS_dotNET_ResponseService.syncMRSdisapprovalFrameMosckupResponse(lstLayerMrsframe1);  
                                                                                 
   }
   /*  Added on 4th Sep */
    public static TestMethod void MRS_Layer_Association_SWIFT_AUPDTest()
   {
    Mask_Set_Title__c mst001 = SwiftDataUtilityTest.createMST('MYMST1');
      insert mst001;
      
      PTRF__c ptrf001 = new PTRF__c(Name='ACOU1',MaskSetTitle__c =mst001.Id,Order_Type__c = 'testOrder',Recticle_Type__c='Multi Layer Reticle (MLR)',Customer_jobview__c='Gating Mask Release');
      insert ptrf001;
      
      MRS__c mrs001 = new MRS__c(Full_Sync__c =true,
                                   Synced_with_Oracle_DB__c=false,
                                   MRS_Package_Sync__c=false,
                                   Mask_Set_Title__c=mst001.Id);
      insert mrs001; 
      
      MRS_Layer_Association__c mrsLayer001 = new MRS_Layer_Association__c(Name ='layer001',
                                                                           Synced_with_Oracle_DB__c= true, //false,
                                                                           Mask_Layer_Rev__c = '899',
                                                                           Layer_Name__c = 'testLayer001',
                                                                           Layer_Status__c = 'Not Ready',
                                                                           mrs__c = mrs001.id);
      insert mrslayer001; 
      
      MRS_Chip_Details__c mrsChip001 = new MRS_Chip_Details__c(Name='chip001',
                                                                Synced_with_Oracle_DB__c=true, //false,
                                                                mrs__c = mrs001.id);
      insert mrsChip001; 
      
      MRS_Layer_Chip_Association__c layerChip001 = new MRS_Layer_Chip_Association__c(Name='layerChip001',
                                                                                      Synced_with_Oracle_DB__c=true,
                                                                                      Layer__c=mrsLayer001.Id,
                                                                                      Chip__c=mrsChip001.Id,
                                                                                      PTRF__c=ptrf001.Id,
                                                                                      Customer_Frame_Mockup__c='Disapprove');
      insert layerChip001;
      
      MRS_Layer_Chip_Association__c layerChip002 = new MRS_Layer_Chip_Association__c(Name='layerChip002',
                                                                                      Synced_with_Oracle_DB__c=true,
                                                                                      Layer__c=mrsLayer001.Id,
                                                                                      Chip__c=mrsChip001.Id,
                                                                                      PTRF__c=ptrf001.Id,
                                                                                      Foundry_Frame_Mockup__c ='Disapprove',
                                                                                      Customer_Frame_Mockup__c ='Not Ready'
                                                                                      );
      insert layerChip002;
      
      //MRS_Layer_Chip_Association__c mlca = [SELECT Id,Customer_Frame_Mockup__c FROM MRS_Layer_Chip_Association__c where Id = :layerChip002.Id];
     // mlca.Customer_Frame_Mockup__c = 'Not Ready';
      //update mlca; 
      }
   }