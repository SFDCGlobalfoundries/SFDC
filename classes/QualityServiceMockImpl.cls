@istest
global class QualityServiceMockImpl implements WebServiceMock {
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

        QualityService.CreateFolderResponse_element respElement=new QualityService.CreateFolderResponse_element();
        QualityService.QACreateFolderService_pt QC=new QualityService.QACreateFolderService_pt();
        QC.endpoint_x= 'https://www.test.com';        
        //ROS_RetreiveGEForm_1.result_element res = new ROS_RetreiveGEForm_1.result_element();
        //QualityService.Response res=new QualityService.Response();
        //res.OpenTextId='1234567';
        //res.Status='SUCCESS';
        //res.ErrorMessage='';
        response.put('response_x', respElement);
   }
}