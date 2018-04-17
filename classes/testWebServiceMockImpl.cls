@isTest
global class testWebServiceMockImpl implements WebServiceMock {
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
               
       Queryptsrattachments.GetPTSRAttachmentResponse_element  respElement = new Queryptsrattachments.GetPTSRAttachmentResponse_element();
      List<Queryptsrattachments.GetPTSRAttachmentResponseDetailsType> listObj=new  List<Queryptsrattachments.GetPTSRAttachmentResponseDetailsType>();
      Queryptsrattachments.GetPTSRAttachmentResponseDetailsType obj=new Queryptsrattachments.GetPTSRAttachmentResponseDetailsType();                       
         obj.FileID = '10000001';
         obj.PTSRID = '1000008001';
         obj.PTSRNumber='PTSR-XXXX-001';
         obj.Reference = 'Reference';
         obj.FileName = 'Test FileName';
         obj.ContentType = 'Attachment';
         obj.AttachTo = 'Test Collaborator';
         obj.FileSize = '2';
         obj.CreatedDate = '2015-09-09T16:56:33.75-07:00';
         obj.CreatedBy = 'test User';
         obj.ModifedDate = '2015-09-09T16:56:33.75-07:00';
         obj.ModifiedBy = 'test User';
               listObj.add(obj);
               system.debug('listObj'+listObj); 
       respElement.GetPTSRAttachmentResponseDetails = listObj;
               system.debug('listObj1'+respElement.GetPTSRAttachmentResponseDetails);
        response.put('response_x', respElement); 
   }
}