/*------------------------------------------------------------  
Author:        Amar Smruti Pattanaik
Company:       CTS
Description:   This test class is for code coverage for DocumentDeprovisioningService
  History:
  ASPattanaik 26092016 - Class Creation.
--------------------------------------------------------------*/
@isTest(seealldata=false)

public class DocumentDeprovisioningServiceTest {
     @isTest static void testCallout() {

        //Insert Custom setting Data for Test class
        Environment_Variable__c ev = new Environment_Variable__c();
        ev.Name = 'CPK Deprovision URL';
        ev.Value__c ='www.test.com';
        insert ev;

        Test.startTest();

        // Calling mock webservice for testing
        Test.setMock(WebServiceMock.class, new DocumentDeprovisioningServiceMockImpl());
        DocumentDeprovisioningService.DocumentDeProvisioningService_pt QC=new DocumentDeprovisioningService.DocumentDeProvisioningService_pt();
        DocumentDeprovisioningService.DeProvisionRequest_element re=new DocumentDeprovisioningService.DeProvisionRequest_element();
        DocumentDeprovisioningService.DeProvision cf=new DocumentDeprovisioningService.DeProvision();
        DocumentDeprovisioningService.Response resp = new DocumentDeprovisioningService.Response();
        DocumentDeprovisioningService.DeProvisionResponse_element resel=new DocumentDeprovisioningService.DeProvisionResponse_element();
        List<DocumentDeprovisioningService.DeProvision> cflist = new List<DocumentDeprovisioningService.DeProvision>();
        cflist.add(cf);
        qc.process(cflist);
        }
    }