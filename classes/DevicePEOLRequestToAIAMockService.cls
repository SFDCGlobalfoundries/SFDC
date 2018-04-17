@isTest
public class DevicePEOLRequestToAIAMockService implements WebServiceMock {
    private boolean simulatingError{get; set;}
    private boolean simulatingException{get; set;}
    public DevicePEOLRequestToAIAMockService() {  
    }
    public DevicePEOLRequestToAIAMockService(boolean simulatingError, boolean simulatingException) {
        this.simulatingError = simulatingError;
        this.simulatingException = simulatingException;
    }

    public void doInvoke(Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType) {
        DevicePEOLSyncService.DevicePEOLSyncServiceResponse_element respone_x = new DevicePEOLSyncService.DevicePEOLSyncServiceResponse_element();
        if(simulatingError){
            respone_x.Response = 'Failed';
        }else if(this.simulatingException){
            throw new DevicePEOLUtility.PEOLException('UNIT TESTING EXCEPTION');
        }else{
            respone_x.Response = 'OK';
        }
        response.put('response_x', respone_x);
        //return response;
    }

}