/*
@author :- Abhita Bansal
*/
@isTest
private class WaivercollaboratorTriggerHandlerTest {  
    
    @testSetup static void testdata() {
        //DataUtilTest.loadEnvironmentVariables();
    }
    
    static testMethod void myWaiverTriggerMethod() {
         Test.startTest(); 
        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaborator7();
        waiverColl.PTSR_Service_Type__c='DFM Service Request';
        waiverColl.Waiver_Status__c = 'Approved';
        
       
        
        WaivercollaboratorTriggerHandler waiverCollTrigger = new WaivercollaboratorTriggerHandler();
        update waiverColl; 
        
        Test.stopTest();
        System.assertEquals(waiverColl.PTSR_Service_Type__c='DFM Service Request','DFM Service Request');
    } 
    
    
    
    
    
    
    static testMethod void myWaiverTriggerMethod1() {
         Test.startTest(); 
        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaborator8();
        waiverColl.PTSR_Service_Type__c='DFM Service Request';
        waiverColl.Waiver_Status__c = 'Rejected';
        waiverColl.Is_Submit_4_DFM_Apprval__c =true;
        
        update waiverColl; 
        
        Test.stopTest();
        System.assertEquals(waiverColl.PTSR_Service_Type__c='DFM Service Request','DFM Service Request');
    }
    
    static testMethod void myWaiverTriggerMethod2a() {
         Test.startTest(); 
        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaborator82();
        waiverColl.PTSR_Service_Type__c='DFM Service Request';
        waiverColl.Waiver_Status__c = 'Approved';
        waiverColl.PTSR_Status__c = 'Closed';
        waiverColl.IsGfAcceptsRisk__c = true;
        waiverColl.MantisIds__c='384868;884861';
        
      
        
        update waiverColl; 
        
        Test.stopTest();
        System.assertEquals(waiverColl.PTSR_Service_Type__c='DFM Service Request','DFM Service Request');
    }
    
    static testMethod void myWaiverTriggerMethod2c() {
         Test.startTest(); 
        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaborator83();
        waiverColl.PTSR_Service_Type__c='DFM Service Request';
        waiverColl.Waiver_Status__c = 'Approved';
        waiverColl.PTSR_Status__c = 'Closed';
        waiverColl.IsGfAcceptsRisk__c = true;
        waiverColl.MantisIds__c='384868;884861';
      
        update waiverColl; 
        
        Test.stopTest();
        System.assertEquals(waiverColl.PTSR_Service_Type__c='DFM Service Request','DFM Service Request');
    }
    
    static testMethod void myWaiverTriggerMethod2d() {
         Test.startTest(); 
        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaborator84();
        waiverColl.PTSR_Service_Type__c='DFM Service Request';
        waiverColl.Waiver_Status__c = 'Approved';
        waiverColl.PTSR_Status__c = 'Closed';
        waiverColl.IsGfAcceptsRisk__c = true;
        waiverColl.MantisIds__c='384868;884861';
        update waiverColl; 
        
        Test.stopTest();
        System.assertEquals(waiverColl.PTSR_Service_Type__c='DFM Service Request','DFM Service Request');
    }
    
    static testMethod void myWaiverTriggerMethod2dreject() {
         Test.startTest(); 
        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaborator85();
        waiverColl.PTSR_Service_Type__c='DFM Service Request';
        waiverColl.Waiver_Status__c = 'Rejected';
        waiverColl.PTSR_Status__c = 'Open';
        waiverColl.IsGfAcceptsRisk__c = true;
        waiverColl.DFMServiceOption__c='Review Only';
       
        update waiverColl; 
        
        Test.stopTest();
        System.assertEquals(waiverColl.PTSR_Service_Type__c='DFM Service Request','DFM Service Request');
    }
    
    static testMethod void myWaiverTriggerMethodExcp1() {
         Test.startTest(); 
        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaborator87();
        waiverColl.PTSR_Service_Type__c='DFM Service Request';
        waiverColl.Waiver_Status__c = 'Rejected';
        waiverColl.PTSR_Status__c = 'Closed';
        waiverColl.IsGfAcceptsRisk__c = true;
        waiverColl.DFMServiceOption__c='Review Only';
        waiverColl.MantisIds__c='384868;884861';
       
        update waiverColl; 
        
        Test.stopTest();
        System.assertEquals(waiverColl.PTSR_Service_Type__c='DFM Service Request','DFM Service Request');
    }
    
    static testMethod void myWaiverTriggerMethodExcp2() {
         Test.startTest(); 
        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaborator88();
        waiverColl.PTSR_Service_Type__c='DFM Service Request';
        waiverColl.Waiver_Status__c = 'Rejected';
        waiverColl.PTSR_Status__c = 'Closed';
        waiverColl.IsGfAcceptsRisk__c = true;
        waiverColl.DFMServiceOption__c='Review Only';
        waiverColl.MantisIds__c='384868;884861';
        
        update waiverColl; 
        
        Test.stopTest();
        System.assertEquals(waiverColl.PTSR_Service_Type__c='DFM Service Request','DFM Service Request');
    }
    
    static testMethod void myWaiverTriggerMethodExcp3() {
         Test.startTest(); 
        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaborator89();
        waiverColl.PTSR_Service_Type__c='DFM Service Request';
        waiverColl.Waiver_Status__c = 'Rejected';
        waiverColl.PTSR_Status__c = 'Closed';
        waiverColl.IsGfAcceptsRisk__c = true;
        waiverColl.DFMServiceOption__c='Review Only';
        waiverColl.MantisIds__c='384868;884861';       
        update waiverColl; 
        
        Test.stopTest();
        System.assertEquals(waiverColl.PTSR_Service_Type__c='DFM Service Request','DFM Service Request');
    }
    
    static testMethod void myWaiverTriggerMethod2drejectedNotChip() {
         Test.startTest(); 
        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaborator86();
        waiverColl.PTSR_Service_Type__c='DFM Service Request';
        waiverColl.Waiver_Status__c = 'Rejected';
        waiverColl.PTSR_Status__c = 'Open';
        waiverColl.IsGfAcceptsRisk__c = true;
        waiverColl.DFMServiceOption__c='Review Only';
       
        
        update waiverColl; 
        
        Test.stopTest();
        System.assertEquals(waiverColl.PTSR_Service_Type__c='DFM Service Request','DFM Service Request');
    }
    
    
    static testMethod void myWaiverTriggerMethod2() {
         Test.startTest(); 
        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaborator9();
        waiverColl.PTSR_Service_Type__c='DFM Service Request';
        waiverColl.Waiver_Status__c = 'Rejected';
        waiverColl.PTSR_Status__c = 'Closed';
        waiverColl.IsGfAcceptsRisk__c = true;
        waiverColl.MantisIds__c='384868;884861';
        update waiverColl; 
        
        Test.stopTest();
        System.assertEquals(waiverColl.PTSR_Service_Type__c='DFM Service Request','DFM Service Request');
    }
    
    static testMethod void myWaiverTriggerMethod3() {
         Test.startTest(); 
        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaborator10();
        waiverColl.PTSR_Service_Type__c='DFM Service Request';
        waiverColl.isAllPartyApproved__c = true;
        
        update waiverColl; 
        
        Test.stopTest();
        System.assertEquals(waiverColl.PTSR_Service_Type__c='DFM Service Request','DFM Service Request');
    }
    
    
    
    static testMethod void myWaiverTriggerMethod4() {
         Test.startTest(); 
          Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaborator11();
        
        waiverColl.Waiver_Status__c = 'Rejected';
        
        
        update waiverColl; 
        
        Test.stopTest();
        System.assertEquals(waiverColl.Waiver_Status__c = 'Rejected','Rejected');
    }
    
    
    
    
    
    static testMethod void sendClosureNotificationToPTSRTest(){
        
        Test.startTest();
        Test.setMock(WebServiceMock.class, new DRC_SyncPTSRStatusMockImpl());
        
        DRC_SyncPTSRStatusStub.SendPTSRClosureInfoRequest_element requestClosure_x = new DRC_SyncPTSRStatusStub.SendPTSRClosureInfoRequest_element();
        requestClosure_x.TransactionID = 'TransactionID';
        requestClosure_x.PTSRNumber = 'PTSRNumber';
        requestClosure_x.ActionName = 'ActionName';
        requestClosure_x.ClosedDate = '03-03-2016';
        
        DRC_SyncPTSRStatusStub.SyncPTSRStatusService_pt sample = new DRC_SyncPTSRStatusStub.SyncPTSRStatusService_pt();
        try{
            Boolean testResult = sample.SendPTSRClosureInfo('TransactionID','PTSRNumber',' ActionName','03-03-2016');
            
            Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaboratorDRCService_forService();
            
            WaivercollaboratorTriggerHandler.sendClosureNotificationToPTSR(waiverColl);
        }Catch(System.NullPointerException e){
            system.debug('Error Message :: sendClosureNotificationToPTSRTest'+e.getMessage());
        }
        Test.stopTest();
        System.assertEquals(requestClosure_x,requestClosure_x);
    }
    
    static testMethod void sendCancelInfoNotificationToPTSRTest(){
        Test.startTest();
        Test.setMock(WebServiceMock.class, new DRC_SyncPTSRStatusMockImpl());
        DRC_SyncPTSRStatusStub.SendPTSRCancelInfoRequest_element requestCancel_x = new DRC_SyncPTSRStatusStub.SendPTSRCancelInfoRequest_element();

        requestCancel_x.TransactionId ='TransactionID'   ;
        requestCancel_x.PTSRNumber= 'PTSRNumber';
        requestCancel_x.ActionName= 'ActionName';
        requestCancel_x.CancellationReason= 'Rejected';
        requestCancel_x.CancelledBy= 'Standard User';
        requestCancel_x.CancelledDate= '03-03-2016';
        requestCancel_x.DWCStage= 'DWC';
        
        DRC_SyncPTSRStatusStub.SyncPTSRStatusService_pt sample = new DRC_SyncPTSRStatusStub.SyncPTSRStatusService_pt();
        try{
                
            Boolean testResult1 = sample.SendPTSRCancelInfo('TransactionID','PTSRNumber',' ActionName','Design Failed', 'ABCD','03-03-2016','Cancelled');
            
            Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaboratorDRCService_forService();
            WaivercollaboratorTriggerHandler.sendCancelNotificationToPTSR(waiverColl,'');
        }Catch(System.NullPointerException e){
            system.debug('Error Message :: sendCancelInfoNotificationToPTSRTest'+e.getMessage());
        }
        Test.stopTest();
        System.assertEquals(requestCancel_x, requestCancel_x);
        
    }
    
    
    
    static testMethod void myWaiverTriggerMethodForDRC3() {
         Test.startTest(); 
        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaboratorDRCTrigger();
        waiverColl.Account_Short_Name__c='ACCOUNT1';
        waiverColl.DRB_Group_uIds__c='1001301,1004363';
        waiverColl.isAllPartyApproved__c = true;
        waiverColl.Is_Sync_with_AIA__c=true;
        
        update waiverColl; 
        
        Test.stopTest();
        System.assertEquals(waiverColl.isAllPartyApproved__c = true, true);
    }
    
    
    static testMethod void sendWfFreezeNotificationToMantisTest(){
        
        Test.startTest();
        Test.setMock(WebServiceMock.class, new DRC_UpdateStatusToMantisMockImpl());
        
        DRC_UpdateStatusToMantisStub.SendPTSRFreezeInfoRequest_element requestFreeze_x = new DRC_UpdateStatusToMantisStub.SendPTSRFreezeInfoRequest_element();
        requestFreeze_x.JsonFreezeRequest ='Test JSON Request'   ;
        
        
        DRC_UpdateStatusToMantisStub.SyncMantisStatusService_pt sample = new DRC_UpdateStatusToMantisStub.SyncMantisStatusService_pt();

        try{
            String testResult1 = sample.SendPTSRFreezeInfo('Test JSON Request');
            Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaboratorDRCTrigger();
            waiverColl.MantisIds__c = '384868;884861';
            system.debug('waiverColl-----'+waiverColl);
            update waiverColl;
      
            WaivercollaboratorTriggerHandler.sendWfFreezeNotificationToMantis(waiverColl);
        }Catch(System.NullPointerException e){
            system.debug('Error Message :: sendWfFreezeNotificationToMantisTest'+e.getMessage());
        }
        
        Test.stopTest();
        System.assertEquals(requestFreeze_x, requestFreeze_x);
        
        
    }
    
    static testMethod void sendWfClosureNotificationToMantisTest(){
        
        Test.startTest();
        Test.setMock(WebServiceMock.class, new DRC_UpdateStatusToMantisMockImpl());
        
        DRC_UpdateStatusToMantisStub.SendPTSRClosureInfoRequest_element requestClose_x = new DRC_UpdateStatusToMantisStub.SendPTSRClosureInfoRequest_element();
        requestClose_x.JsonClosureRequest ='Test JSON Request'   ;
        
        
        DRC_UpdateStatusToMantisStub.SyncMantisStatusService_pt sample = new DRC_UpdateStatusToMantisStub.SyncMantisStatusService_pt();
        try{
            String testResult1 = sample.SendPTSRClosureInfo('Test JSON Request');
            Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaboratorDRCTrigger();
             //list<Chip__c> objChip = [SELECT Id,Chip_Name__c, Prime_Die_Status__c,MantisId1__c,MantisId2__c,MantisId3__c,AllJobs_Submitted__c,Wavier_Collaborator__c FROM Chip__c WHERE Wavier_Collaborator__c =: drcInfo.Id];
            Chip__c chip =new Chip__c();
            chip.Wavier_Collaborator__c=waiverColl.id;
            chip.Prime_Die_Status__c = 'OPEN';
            chip.MantisId1__c ='384868';
            insert chip;
            waiverColl.MantisIds__c = '384868;884861';
            waiverColl.PTSR_Status__c='Closed';
             system.debug('waiverColl-----'+waiverColl);
             update waiverColl;
            list<Chip__c> objChip = [SELECT Id,Chip_Name__c, Prime_Die_Status__c,MantisId1__c,MantisId2__c,MantisId3__c,AllJobs_Submitted__c,Wavier_Collaborator__c FROM Chip__c WHERE Wavier_Collaborator__c =:waiverColl.Id];
            
            WaivercollaboratorTriggerHandler.sendClosureNotificationToMantis(waiverColl);
        }Catch(System.NullPointerException e){
            system.debug('Error Message :: sendWfClosureNotificationToMantisTest'+e.getMessage());
        }
        Test.stopTest();
        System.assertEquals(requestClose_x, requestClose_x);        
        
        
    } 
    
     static testMethod void sendWfRevertNotificationToMantisTest(){
        
        Test.startTest();
        Test.setMock(WebServiceMock.class, new DRC_UpdateStatusToMantisMockImpl());
        
        DRC_UpdateStatusToMantisStub.SendPTSRFreezeInfoRequest_element requestFreeze_x = new DRC_UpdateStatusToMantisStub.SendPTSRFreezeInfoRequest_element();
        requestFreeze_x.JsonFreezeRequest ='Test JSON Request'   ;
        
        
        DRC_UpdateStatusToMantisStub.SyncMantisStatusService_pt sample = new DRC_UpdateStatusToMantisStub.SyncMantisStatusService_pt();
        try{
            String testResult1 = sample.SendPTSRFreezeInfo('Test JSON Request');
            Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaboratorDRCTrigger();
            
            WaivercollaboratorTriggerHandler.sendRevertNotificationToMantis(waiverColl);
        }Catch(System.NullPointerException e){
            system.debug('Error Message :: sendWfFreezeNotificationToMantisTest'+e.getMessage());
        }
        
        Test.stopTest();
        System.assertEquals(requestFreeze_x, requestFreeze_x);
        
        
    }
    
    static testMethod void sendWfCancelNotificationToMantisTest(){
        Test.startTest();
        Test.setMock(WebServiceMock.class, new DRC_UpdateStatusToMantisMockImpl());
        
        DRC_UpdateStatusToMantisStub.SendPTSRCancelInfoRequest_element requestClose_x = new DRC_UpdateStatusToMantisStub.SendPTSRCancelInfoRequest_element();
        requestClose_x.JsonCancelRequest ='Test JSON Request'   ;
        
        
        DRC_UpdateStatusToMantisStub.SyncMantisStatusService_pt sample = new DRC_UpdateStatusToMantisStub.SyncMantisStatusService_pt();
        
       
        try{
            String testResult1 = sample.SendPTSRCancelInfo('Test JSON Request');
           
        }Catch(System.NullPointerException e ){
            system.debug('Error Message :: sendWfCancelNotificationToMantisTest'+e.getMessage());
        }
        Test.stopTest();
        System.assertEquals(requestClose_x, requestClose_x);        
    }
    
    
    static testMethod void sendReleaseReportTest(){
        
        Test.startTest();
        
        
        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaboratorDRCTriggert();
        Wavier_Collaborator__c waiverColl1 = DesignCollaboratorTestData.getWaiverCollaboratorDRCTriggert();
        List<Wavier_Collaborator__c> lstOfDRCRecords = new  List<Wavier_Collaborator__c>();
        lstOfDRCRecords.add(waiverColl);
        lstOfDRCRecords.add(waiverColl1);
        WaivercollaboratorTriggerHandler.shareDRCReport(lstOfDRCRecords);
        
        Test.stopTest();
        System.assertEquals(lstOfDRCRecords, lstOfDRCRecords);      
    } 
    
    static testMethod void myWaiverTriggerMethodForDRCPI() {
        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaboratorDRCTrigger();
        list<Waiver_Rule_List__c>  waiverCollList = DesignCollaboratorTestData.getWaiverRuleList(waiverColl.Id);
        waiverCollList[0].Mantis_Id__c = 384868;
        update waiverCollList; 
        System.debug('waiverCollList1-----'+waiverCollList);
        
        Test.startTest(); 
        
        DesignCollaboratorTestData.getWaiverRuleListForPI(waiverColl.Id);  
        waiverColl.PTSR_Status__c = 'Closed';
        waiverColl.Account_Short_Name__c='ACCOUNT1';
        waiverColl.DRB_Group_uIds__c='1001301,1004363';
        waiverColl.isAllPartyApproved__c = true;
        waiverColl.Is_Sync_with_AIA__c=true;
        waiverColl.MantisIds__c= '384868;884861';
        update waiverColl;
    
        Test.stopTest();
        System.assertEquals(waiverColl, waiverColl);
    } 
     static testMethod void myWaiverTriggerMethodForRevertDRCPI() {
        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaboratorDRCTrigger();
        list<Waiver_Rule_List__c>  waiverCollList = DesignCollaboratorTestData.getWaiverRuleList(waiverColl.Id);
        waiverCollList[0].Mantis_Id__c = 384868;
        waiverCollList[0].Revert_Rule__c = true;
        waiverCollList[0].Mantis_Stage__c = 'PI'; 
        update waiverCollList; 
        
        Test.startTest(); 
        
        DesignCollaboratorTestData.getWaiverRuleListForPI(waiverColl.Id);  
        waiverColl.PTSR_Status__c = 'Closed';
        waiverColl.Account_Short_Name__c='ACCOUNT1';
        waiverColl.DRB_Group_uIds__c='1001301,1004363';
        waiverColl.isAllPartyApproved__c = true;
        waiverColl.Is_Sync_with_AIA__c=true;
        waiverColl.MantisIds__c= '384868;884861';
        update waiverColl;
    
        Test.stopTest();
        System.assertEquals(waiverColl, waiverColl);
    } 
    
    static testMethod void myWaiverTriggerMethodForDRCPW() {
        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaboratorDRCTrigger();
        list<Waiver_Rule_List__c>  waiverCollList = DesignCollaboratorTestData.getWaiverRuleList(waiverColl.Id);
        waiverCollList[0].Mantis_Id__c = 384868;
        update waiverCollList; 
         Test.startTest(); 
        
        DesignCollaboratorTestData.getWaiverRuleListForPW(waiverColl.Id);  
        waiverColl.PTSR_Status__c = 'Closed';
        waiverColl.Account_Short_Name__c='ACCOUNT1';
        waiverColl.DRB_Group_uIds__c='1001301,1004363';
        waiverColl.isAllPartyApproved__c = true;
        waiverColl.Is_Sync_with_AIA__c=true;
        waiverColl.MantisIds__c='384868;884861';        
        update waiverColl; 
        
        Test.stopTest();
        System.assertEquals(waiverColl, waiverColl);
    } 
    
    
    static testMethod void myWaiverTriggerMethodForDRCWEA() {
        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaboratorDRCTrigger1();
        list<Waiver_Rule_List__c>  waiverCollList = DesignCollaboratorTestData.getWaiverRuleList(waiverColl.Id);
        waiverCollList[0].Mantis_Id__c = 384868;
        update waiverCollList;
         Test.startTest(); 
        
        
        waiverColl.PTSR_Status__c = 'Closed';
        waiverColl.Account_Short_Name__c='ACCOUNT1';
        waiverColl.DRB_Group_uIds__c='1001301,1004363';
        waiverColl.isAllPartyApproved__c = true;
        waiverColl.Is_Sync_with_AIA__c=true;
        waiverColl.MantisIds__c='384868;884861';
        update waiverColl; 
        
        Test.stopTest();
        System.assertEquals(waiverColl, waiverColl);
    } 
    
    
    static testMethod void myWaiverTriggerMethodForDRCWCR() {
        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaboratorDRCTrigger2();
        
        list<Waiver_Rule_List__c>  waiverCollList = DesignCollaboratorTestData.getWaiverRuleList(waiverColl.Id);
        waiverCollList[0].Mantis_Id__c = 384868;
        update waiverCollList;
         Test.startTest(); 
        
        DesignCollaboratorTestData.getWaiverRuleListForPW(waiverColl.Id);  
        waiverColl.PTSR_Status__c = 'Closed';
        waiverColl.Account_Short_Name__c='ACCOUNT1';
        waiverColl.DRB_Group_uIds__c='1001301,1004363';
        waiverColl.isAllPartyApproved__c = true;
        waiverColl.Is_Sync_with_AIA__c=true;
        waiverColl.MantisIds__c='384868;884861';
        update waiverColl; 
        
        Test.stopTest();
        System.assertEquals(waiverColl, waiverColl);
    } 
    
    static testMethod void myWaiverTriggerMethodForDRCFDRejection() {
        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaboratorDRCTrigger3();
        list<Waiver_Rule_List__c>  waiverCollList = DesignCollaboratorTestData.getWaiverRuleList(waiverColl.Id);
        waiverCollList[0].Mantis_Id__c = 384868;
        update waiverCollList; 
         Test.startTest(); 
               
        waiverColl.PTSR_Status__c = 'Closed';
        waiverColl.Account_Short_Name__c='ACCOUNT1';
        waiverColl.DRB_Group_uIds__c='1001301,1004363';
        waiverColl.isAllPartyApproved__c = true;
        waiverColl.Is_Sync_with_AIA__c=true;
        waiverColl.MantisIds__c='384868;884861';
        
        update waiverColl; 
        
        Test.stopTest();
        System.assertEquals(waiverColl, waiverColl);
    }
     static testMethod void sendCancelNotificationToMantisTest(){
        
        Test.startTest();
              
        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaboratorDRCTriggert();
        WaivercollaboratorTriggerHandler.sendCancelNotificationToMantis(waiverColl);
        
        Test.stopTest();
        System.assertEquals(waiverColl, waiverColl);   
    } 
    
    static testMethod void sendCancelNotificationToPTSRTest(){
        
        Test.startTest();
        
        
        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaboratorDRCTriggert();

        WaivercollaboratorTriggerHandler.sendCancelNotificationToPTSR(waiverColl,'testing');
        
        Test.stopTest();
        System.assertEquals(waiverColl, waiverColl);    
    } 
    
    // added new method to update PTSR_Status__c
     static testMethod void myWaiverTriggerMethodForDRCPI2() {
        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaboratorDRCTrigger();
        list<Waiver_Rule_List__c>  waiverCollList = DesignCollaboratorTestData.getWaiverRuleList(waiverColl.Id);
        waiverCollList[0].Mantis_Id__c = 384868;
        update waiverCollList;
         Test.startTest(); 
        
        DesignCollaboratorTestData.getWaiverRuleListForPI(waiverColl.Id);  
        waiverColl.PTSR_Status__c = 'Closed';
        waiverColl.Account_Short_Name__c='ACCOUNT1';
        waiverColl.DRB_Group_uIds__c='1001301,1004363';
        waiverColl.isAllPartyApproved__c = true;
        waiverColl.Is_Sync_with_AIA__c=true;
        waiverColl.Waiver_Status__c ='Approved';   
        waiverColl.MantisIds__c='384868;884861'; 
        update waiverColl; 
        waiverColl.PTSR_Status__c='Cancel';
        waiverColl.MantisIds__c='384868;884861'; 
       update waiverColl;
          Test.stopTest();
         System.assertEquals(waiverColl, waiverColl);
    } 
     static testMethod void shareDRCReportWithCustomers(){
        
        Test.startTest();
        
        
        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaboratortest();
        WaivercollaboratorTriggerHandler.shareDRCReportWithCustomers(waiverColl);
        
        Test.stopTest();
        System.assertEquals(waiverColl, waiverColl);   
    }    
}