public class NDA_NDAService
{
   
    //private static String CERT_NAME = 'gf_int_services';
    
  private static void setHeaders(NDA_IntegrationService.NDAPort intService)
  {
      intService.clientCertName_x = NDAVariable.get('CERT_NAME');
      
  }
  

  @Future(callout=true)
  public static void activateNDA(
  String CompanyShortName,String AmsCompanyName,String TechGeometries,String NdaCompanyName,String CompanyAddress,String Purpose,String NdaNumber,String NdaType,String Originator,String Approver,Date AgreementDate,Date ExpiryDate,Date ConfidentialityDate) 
  {
     
     NDA_IntegrationService.NDAPort intService = new NDA_IntegrationService.NDAPort();
     setHeaders(intService);
     if(!System.Test.isRunningTest())   
     NDA_IntegrationSchema.Response_element response = intService.activateNDA(CompanyShortName,AmsCompanyName,TechGeometries,NdaCompanyName,CompanyAddress,Purpose,NdaNumber,NdaType,Originator,Approver,AgreementDate,ExpiryDate,ConfidentialityDate);
     
  }   
        
  
  @Future(callout=true)
   public static void expireNDA(String ndaNumber)
  {
    
    NDA_IntegrationService.NDAPort intService = new NDA_IntegrationService.NDAPort();
    setHeaders(intService); 
    if(!System.Test.isRunningTest()) 
    NDA_IntegrationSchema.Response_element response = intService.ExpireNDA(ndaNumber);
    
  }
  
  
  @Future(callout=true)
   public static void voidNDA(String ndaNumber)
  {
    
    NDA_IntegrationService.NDAPort intService = new NDA_IntegrationService.NDAPort();
    setHeaders(intService);
    if(!System.Test.isRunningTest()) 
    NDA_IntegrationSchema.Response_element response = intService.VoidNDA(ndaNumber);
    
  }
}