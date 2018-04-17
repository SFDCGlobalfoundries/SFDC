/*
	@Author :- Suhas Bargi  
	@  DRC_SyncPTSRStatusStub
*/
@isTest
global class DRC_SyncPTSRStatusMockImpl implements WebServiceMock {

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
               
               Map<String, DRC_SyncPTSRStatusStub.SendPTSRClosureInfoResponse_element> closure_response_map_x = new Map<String, DRC_SyncPTSRStatusStub.SendPTSRClosureInfoResponse_element>();
               DRC_SyncPTSRStatusStub.SendPTSRClosureInfoResponse_element     closureRespElement  = new DRC_SyncPTSRStatusStub.SendPTSRClosureInfoResponse_element();
               closureRespElement.Result = true; 
               closure_response_map_x.put('response_x',closureRespElement);
               
               
              
               
        
               Map<String, DRC_SyncPTSRStatusStub.SendPTSRCancelInfoResponse_element> cancel_response_map_x = new Map<String, DRC_SyncPTSRStatusStub.SendPTSRCancelInfoResponse_element>();
               DRC_SyncPTSRStatusStub.SendPTSRCancelInfoResponse_element cancelRespElement = new DRC_SyncPTSRStatusStub.SendPTSRCancelInfoResponse_element();
               cancelRespElement.Result = true; 
               cancel_response_map_x.put('response_x',cancelRespElement);
               
               
           }



}