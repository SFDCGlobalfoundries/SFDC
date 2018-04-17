/*
	@Author :- Suhas Bargi
*/
@isTest
global class DRC_DesignWaiverCollaboratorMockImpl implements WebServiceMock {

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
               
               
               Map<String, DRC_QueryRuleInfoFromMantisStub.GetMantisPTSRMetaDataResponse_element> response_map_x = new Map<String, DRC_QueryRuleInfoFromMantisStub.GetMantisPTSRMetaDataResponse_element>();
               
               DRC_QueryRuleInfoFromMantisStub.GetMantisPTSRMetaDataResponse_element response_x = new  DRC_QueryRuleInfoFromMantisStub.GetMantisPTSRMetaDataResponse_element();
               DRC_QueryRuleInfoFromMantisStub.DRCMetaData_element metaDataElement = new DRC_QueryRuleInfoFromMantisStub.DRCMetaData_element();
               DRC_QueryRuleInfoFromMantisStub.ViolationReportType vrt = new  DRC_QueryRuleInfoFromMantisStub.ViolationReportType();
               DRC_QueryRuleInfoFromMantisStub.RuleCheckInfoType   rcit = new DRC_QueryRuleInfoFromMantisStub.RuleCheckInfoType();
               
               vrt.DesignRuleID = '121221';
               vrt.DesignRuleName='Test1234';
               vrt.Description='TESTING the service response';
               vrt.HierErrorCount='4';
               
               rcit.CustomerName = 'GLOBALFOUNDRIES';
               rcit.DevideId='DEVICEID1234';
               rcit.MantisId='121221';
               
               
               List<DRC_QueryRuleInfoFromMantisStub.RuleCheckInfoType> rcitList = new  List<DRC_QueryRuleInfoFromMantisStub.RuleCheckInfoType>();
               List<DRC_QueryRuleInfoFromMantisStub.ViolationReportType> vrtList = new List<DRC_QueryRuleInfoFromMantisStub.ViolationReportType>();
               
               rcitList.add(rcit);
               vrtList.add(vrt);
               
               metaDataElement.ViolationReport = vrtList;
               metaDataElement.RuleCheckInfo = rcit;
               
               //metaDataElement = DRC_QueryRuleInfoFromMantisStub.GetMantisPTSRMetaData(121221); 
               response_x.DRCMetaData = metaDataElement;
               
               response_map_x.put('response_x', response_x);
               
               
           }



}