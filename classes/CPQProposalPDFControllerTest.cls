/**
*  Class:       CPQProposalPDFControllerTest
 *----------------------------------------------------------------------------------------------------------------------------------- 
 * Author:      Shivam Sharma 
 * Description: This class contains unit tests for CPQProposalPDFController Apex classes
 *              Class: CPQProposalPDFController 
 *
 *
 * History:
 *              SS 11262015     - code creation.
**/
@isTest(SeeAllData = False)
public class CPQProposalPDFControllerTest{
    @testSetup
     static void testDataSetup(){
        DataUtilTest.loadEnvironmentVariables();
        
     }
     
    static Product2 createProduct(String PTnumber){
        Product2 TestProd = new Product2();
            TestProd.ProductCode                         = 'Test_'+PTnumber;
            TestProd.Product_External_ID__c              = 'Test_'+PTnumber;
            TestProd.APTPS_IP_Lifecycle__c               = 'Approved';
            TestProd.Family                              = 'IPs';
            TestProd.Name                                = 'Test ' + PTnumber;
            TestProd.IsActive                            = TRUE;
            TestProd.Geometry__c                         = '0.028UM';
            TestProd.Apttus_Config2__ConfigurationType__c= 'Bundle'; 
            TestProd.PT_Number__c                        = PTnumber; 
            TestProd.IP_Device_List__c = 'IP1,IP2,IP3';
            TestProd.Sram_Type__c = 'TestSram_Type__c'; 
        insert TestProd;
        Return TestProd;
    } 
    public testMethod static void testcpqproposalpdf(){
        
        
        Product2 tp = createProduct('PT00XXXX');
        Base_IP__c bip = new Base_IP__c(IP_Number__c= tp.productcode, name=tp.productcode);
        insert bip;
        
        Ip__c ip = new IP__c(name=tp.productcode, Latest_Version__c= tp.productcode,IPNumber__c=bip.id);
        insert ip;
        
        Apttus_Proposal__Proposal__c proposal = new Apttus_Proposal__Proposal__c(SRAM_Sizes__c = 'SRAM_Sizes__c<:>SRAM_Sizes__c1', Free_Devices__c='Test_PT00XXXX<:>');
        insert proposal;
        
        Apttus_Proposal__Proposal_Line_Item__c proposalLineItem;

        proposalLineItem = new Apttus_Proposal__Proposal_Line_Item__c();
        proposalLineItem.Apttus_QPConfig__LineType__c = 'Product/Service';
        proposalLineItem.Apttus_QPConfig__OptionId__c = tp.id;
        proposalLineItem.Apttus_Proposal__Proposal__c = proposal.Id;
        
        insert proposalLineItem;
        
        CPQ_PostFabServicesReadonlyViewCtrl postfab = new CPQ_PostFabServicesReadonlyViewCtrl();
        Map<String, Schema.FieldSet> fsMap = postfab.fieldSetMap;
        postfab.proposalId = proposal.id;
        postfab.isPrint = false;
        postfab.getPostFabServices();
        
        System.assertNotEquals(proposalLineItem.Id, null);
        
        PageReference pRef = Page.CPQ_Proposal_pdf;
        pRef.getParameters().put('id',proposal.id);
        pRef.getParameters().put('doSave','Yes');
        Test.setCurrentPage(pRef);
        
        CPQProposalPDFController controllerInstance = new CPQProposalPDFController();
        controllerInstance.savePDF();
        
        controllerInstance.doSave = 'No';
        controllerInstance.savePDF();
    }
}