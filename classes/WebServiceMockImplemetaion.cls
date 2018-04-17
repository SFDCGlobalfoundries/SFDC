/*
Author: Bhavana Mohan
Company: Cognizant
Description: sfdc - .net Integration Webservice Test class for Mock Response 
History:
created     10-Jun-2014     
*/

@isTest  
global class WebServiceMockImplemetaion implements WebServiceMock {  
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
       MRSdotNETResponseCalloutService.SendSFDCStatusResponse_element respElement = new MRSdotNETResponseCalloutService.SendSFDCStatusResponse_element();  
       respElement.SendSFDCStatusResponseState = 'Mock response';  
       response.put('response_x', respElement);   
   }  
}