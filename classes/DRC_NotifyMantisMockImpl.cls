/*
	@Author :- Suhas Bargi  
	@  DRC_UpdateStatusToMantisStub
*/
@isTest
global class DRC_NotifyMantisMockImpl implements WebServiceMock {

       global void doInvoke(  
           Object stub,  
           Object request,  
           Map<string, Object> response,  
           String endpoint,  
           String soapAction,  
           String requestName,  
           String responseNS,  
           String responseName,  
           String responseType) {
               
               Map<String, DRC_UpdateStatusToMantisStub.SendPTSRClosureInfoResponse_element> closure_response_map_x = new Map<String, DRC_UpdateStatusToMantisStub.SendPTSRClosureInfoResponse_element>();
               DRC_UpdateStatusToMantisStub.SendPTSRClosureInfoResponse_element     closureRespElement  = new DRC_UpdateStatusToMantisStub.SendPTSRClosureInfoResponse_element();
               closureRespElement.Result = 'closureRespElement'; 
               closure_response_map_x.put('response_x',closureRespElement);
               
               
               Map<String, DRC_UpdateStatusToMantisStub.SendPTSRFreezeInfoResponse_element> freeze_response_map_x = new Map<String, DRC_UpdateStatusToMantisStub.SendPTSRFreezeInfoResponse_element>();
               DRC_UpdateStatusToMantisStub.SendPTSRFreezeInfoResponse_element    freezeRespElement     =  new DRC_UpdateStatusToMantisStub.SendPTSRFreezeInfoResponse_element();
               freezeRespElement.Result = 'freezeRespElement'; 
               freeze_response_map_x.put('response_x',freezeRespElement);
               
        
               Map<String, DRC_UpdateStatusToMantisStub.SendPTSRCancelInfoResponse_element> cancel_response_map_x = new Map<String, DRC_UpdateStatusToMantisStub.SendPTSRCancelInfoResponse_element>();
               DRC_UpdateStatusToMantisStub.SendPTSRCancelInfoResponse_element cancelRespElement = new DRC_UpdateStatusToMantisStub.SendPTSRCancelInfoResponse_element();
               cancelRespElement.Result = 'cancelRespElement'; 
               cancel_response_map_x.put('response_x',cancelRespElement);
               
               // DRC_UpdateStatusToMantisStub.SyncMantisStatusService_pt srvcPt = new   DRC_UpdateStatusToMantisStub.SyncMantisStatusService_pt();            
               //	srvcPt.SendPTSRClosureInfo('String JsonClosureRequest') ;
         		//srvcPt.SendPTSRFreezeInfo('String JsonPTSRFreezeInfoRequest') ;
         		//srvcPt.SendPTSRCancelInfo('String JsonPTSRCancelRequest') ;
           }



}