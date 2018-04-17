/*------------------------------------------------------------  
Author:        Amar Smruti Pattanaik
Company:       CTS
Description:   This test class is to give mock webservice call for DocumentDeprovisioningService
  History:
  ASPattanaik 26092016 - Class Creation.
--------------------------------------------------------------*/

@istest
global class DocumentDeprovisioningServiceMockImpl implements WebServiceMock {
   global void doInvoke(
           Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType) {
    
        //Calling webservices Instances
        DocumentDeprovisioningService.DeProvisionResponse_element respElement=new DocumentDeprovisioningService.DeProvisionResponse_element();
        DocumentDeprovisioningService.DocumentDeProvisioningService_pt QC=new DocumentDeprovisioningService.DocumentDeProvisioningService_pt();
        QC.endpoint_x= 'https://www.test.com';        
        response.put('response_x', respElement);
   }
}