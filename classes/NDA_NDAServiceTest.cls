@isTest
public class NDA_NDAServiceTest {

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
        String TechGeometries = '0.10UM';
        String NdaType = 'GF';
        String Originator = 'Test';
        String Approver = 'TestApprover';
        Date AgreementDate = Date.newinstance(2013, 4,1);
        Date ExpiryDate = Date.newinstance(2015, 4,1);
        Date ConfidentialityDate = Date.newinstance(2013, 4,1);
       
        NDA_NDAService.ActivateNDA(CompanyShortName,AmsCompanyName,TechGeometries,NdaCompanyName,CompanyAddress,Purpose,NdaNumber,NdaType,Originator,Approver,AgreementDate,ExpiryDate,ConfidentialityDate);
    }
    static @isTest void TestExpireNDA()
    {
        // This causes a fake response to be generated
        system.Test.setMock(WebServiceMock.class, new NDA_IntegrationServiceWebServiceMock() );
        String NdaNumber = 'nda123';
    
        
        NDA_NDAService.ExpireNDA(NdaNumber);
    }
    
     static @isTest void TestVoidNDA()
    {
        // This causes a fake response to be generated
        system.Test.setMock(WebServiceMock.class, new NDA_IntegrationServiceWebServiceMock() );
        String NdaNumber = 'nda123';
    
        
        NDA_NDAService.VoidNDA(NdaNumber);
    }
    
    

}