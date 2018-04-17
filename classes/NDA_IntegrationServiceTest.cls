@isTest
public class NDA_IntegrationServiceTest {

    static @isTest void TestActivateNDA()
    {
        // This causes a fake response to be generated
        system.Test.setMock(WebServiceMock.class, new NDA_IntegrationServiceWebServiceMock() );
        
        
        String CompanyShortName = 'ACME';
        String AmsCompanyName = 'ACME';
        String NdaCompanyName = 'ACME';
        String CompanyAddress = '123 Main St, Beverly Hills, CA 90210 ';
        String Purpose = 'I have a purpose';
        String NdaNumber = 'nda123';
        String NdaType = 'GF';
        String Originator = 'Test';
        String Approver = 'TestApprover';
        String TechGeometries = '0.10UM';
        Date AgreementDate = Date.newinstance(2013, 4,1);
        Date ExpiryDate = Date.newinstance(2015, 4,1);
        Date ConfidentialityDate = Date.newinstance(2013, 4,1);
        NDA_IntegrationService.NDAPort stub = new NDA_IntegrationService.NDAPort();
        stub.ActivateNDA(CompanyShortName,AmsCompanyName,TechGeometries, NdaCompanyName,CompanyAddress,Purpose,NdaNumber,NdaType,Originator,Approver,AgreementDate,ExpiryDate,ConfidentialityDate);
    }
    static @isTest void TestExpireNDA()
    {
        // This causes a fake response to be generated
        system.Test.setMock(WebServiceMock.class, new NDA_IntegrationServiceWebServiceMock() );
        String NdaNumber = 'nda123';
    
        NDA_IntegrationService.NDAPort stub = new NDA_IntegrationService.NDAPort();
        stub.ExpireNDA(NdaNumber);
    }
    
     static @isTest void TestVoidNDA()
    {
        // This causes a fake response to be generated
        system.Test.setMock(WebServiceMock.class, new NDA_IntegrationServiceWebServiceMock() );
        String NdaNumber = 'nda123';
    
        NDA_IntegrationService.NDAPort stub = new NDA_IntegrationService.NDAPort();
        stub.VoidNDA(NdaNumber);
    }
    
    

}