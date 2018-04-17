@isTest
global class WebServiceMockImpl implements WebServiceMock {
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
           ROS_RetreiveGEForm_1.processResponse_element respElement  = new ROS_RetreiveGEForm_1.processResponse_element();
           ROS_RetreiveGEForm_1.GEReticleSyncService_pt Tobj = new ROS_RetreiveGEForm_1.GEReticleSyncService_pt();
           Tobj.endpoint_x = 'https://www.test.com';
       
           //endpoint_x = 'https://www.test.com'
           ROS_RetreiveGEForm_1.result_element res = new ROS_RetreiveGEForm_1.result_element();
           res.RequestNo  = 'Test';
         //  respElement.result.add(res); 
           response.put('response_x',respElement);
   }
}