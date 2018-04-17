@isTest
public class NDA_IntegrationServiceWebServiceMock implements WebServiceMock {
   public void doInvoke(
           Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType) {
           NDA_IntegrationSchema.Response_element respElement = 
           new NDA_IntegrationSchema.Response_element();
      
       response.put('response_x', respElement); 
   }
}