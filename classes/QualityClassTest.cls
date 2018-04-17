/*------------------------------------------------------------  
Author:        Amar Smruti Pattanaik
Company:       CTS
Description:   This test class is for code coverage for QualityService
  History:
  ASPattanaik 26092016 - Class Modification to increase code coverage.
--------------------------------------------------------------*/
@isTest(seealldata=false)

private class QualityClassTest {


     @isTest static void testCallout() {

        //Insert Custom setting Data for Test class
        Environment_Variable__c ev = new Environment_Variable__c();
        ev.Name ='Quality Endpoint URl';
        ev.Value__c='www.test.com';
        insert ev; 

        Test.startTest();

        //Calling webservice for testing
        Test.setMock(WebServiceMock.class, new QualityServiceMockImpl());
        QualityService.QACreateFolderService_pt QC=new QualityService.QACreateFolderService_pt();
        QualityService.CreateFolderRequest_element re=new QualityService.CreateFolderRequest_element();
        QualityService.CreateFolder cf=new QualityService.CreateFolder();
        QualityService.Response resp = new QualityService.Response();
        QualityService.CreateFolderResponse_element resel=new QualityService.CreateFolderResponse_element();
        List<QualityService.CreateFolder> qcflist = new List<QualityService.CreateFolder>();
        qcflist.add(cf);
        QC.CreateFolder(qcflist); 
        }
    }