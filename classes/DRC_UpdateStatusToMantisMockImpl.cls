/*
	@Author :- Suhas Bargi  
	@  DRC_SyncPTSRStatusStub
*/
@isTest
global class DRC_UpdateStatusToMantisMockImpl implements WebServiceMock {

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
               
               Map<String, DRC_UpdateStatusToMantisStub.SendPTSRFreezeInfoResponse_element> freeze_response_map_x = new Map<String, DRC_UpdateStatusToMantisStub.SendPTSRFreezeInfoResponse_element>();
               DRC_UpdateStatusToMantisStub.SendPTSRFreezeInfoResponse_element     freezeRespElement  = new DRC_UpdateStatusToMantisStub.SendPTSRFreezeInfoResponse_element();
               freezeRespElement.Result = 'true'; 
               freeze_response_map_x.put('response_x',freezeRespElement);
        
               Map<String, DRC_UpdateStatusToMantisStub.SendPTSRClosureInfoResponse_element> closure_response_map_x = new Map<String, DRC_UpdateStatusToMantisStub.SendPTSRClosureInfoResponse_element>();
               DRC_UpdateStatusToMantisStub.SendPTSRClosureInfoResponse_element closeRespElement = new DRC_UpdateStatusToMantisStub.SendPTSRClosureInfoResponse_element();
               closeRespElement.Result = 'true'; 
               closure_response_map_x.put('response_x',closeRespElement);
               
                Map<String, DRC_UpdateStatusToMantisStub.SendPTSRCancelInfoResponse_element> cancel_response_map_x = new Map<String, DRC_UpdateStatusToMantisStub.SendPTSRCancelInfoResponse_element>();
               DRC_UpdateStatusToMantisStub.SendPTSRCancelInfoResponse_element cancelRespElement = new DRC_UpdateStatusToMantisStub.SendPTSRCancelInfoResponse_element();
               cancelRespElement.Result = 'true'; 
               cancel_response_map_x.put('response_x',cancelRespElement);
               
           }


    
    
    
}