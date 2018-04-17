/**
*   Author: Prosenjit Saha
*   Description: This is the test class for CPQRedirectFieldCreateCls class

*   History:
*       PSaha          05182015     - code creation.
*     
**/
@istest(SeeAllData=false)
public class CPQRedirectFieldCreateClsTest{
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
    }
    /*
    * Method Name:     CPQRedirectTest
    * Return Type:     NA
    * Parameter  :     NA
    * Reason     :     This method handle all the testing of CPQRedirectFieldCreateCls class
    */
      static testmethod void CPQRedirectTest(){
        test.starttest();
            Product2 ParentProduct = createProduct('PT00XXXX');
            CPQ_MLGPLUS__c mlgplus = getCPQMLG(ParentProduct.id);
            ApexPages.StandardController sc = new ApexPages.StandardController(mlgplus);     
            CPQRedirectFieldCreateCls testController = new CPQRedirectFieldCreateCls(sc); 
            testController.createAttributeField(); 
            testController.createFieldDependency(); 
            
            List<CPQ_MLGPLUS__c> templist = new List<CPQ_MLGPLUS__c>();
            templist.add(mlgplus);
            ApexPages.StandardSetController StdSetCntrl = new ApexPages.StandardSetController(templist); 
            CPQMaintenanceJobsController testController2 = new CPQMaintenanceJobsController(StdSetCntrl);
        test.stoptest();
    } 
    
    /*
    * Method Name:     getCPQMLG
    * Return Type:     CPQ_MLGPLUS__c
    * Parameter  :     Product2
    * Reason     :     This method returns new CPQ MLG record
    */
    static CPQ_MLGPLUS__c getCPQMLG(String ParentProdID) {
        CPQ_MLGPLUS__c cpqmlgplus = new CPQ_MLGPLUS__c( Catalog_Type__c = 'First Source'
                                                        , Geometry__c = '0.065UM'
                                                        , Status__c = 'Ready to Load'
                                                        , Process_Technology__c = 'PT00XXXX'
                                                        , Bundle_Product__c = ParentProdID
                                                        , Parent_Product_External_ID__c = 'PT00XXXX'
                                                        , Parent_Product_Name__c = 'PT00XXXX'
                                                        , Processed_Version__c = '1');
        insert cpqmlgplus;
        return cpqmlgplus; 
    }
    
    /*
    * Method Name:     createParentProduct
    * Return Type:     NA
    * Parameter  :     NA
    * Reason     :     This method creates Parent Product. 
    */
    static Product2 createProduct(String PTnumber){
        Product2 TestProd = new Product2();
            TestProd.ProductCode                         = 'Test_'+PTnumber;
            TestProd.Product_External_ID__c              = 'Test_'+PTnumber;
            TestProd.APTPS_IP_Lifecycle__c               = 'Approved';
            //TestProd.APTPS_IP_Type__c                    = 'AMS';
            //TestProd.APTPS_IP_Vendors__c                 = 'GF';
            TestProd.Family                              = 'PTs';
            TestProd.Name                                = 'Test ' + PTnumber;
            TestProd.IsActive                            = TRUE;
            TestProd.Geometry__c                         = '0.028UM';
            TestProd.Apttus_Config2__ConfigurationType__c= 'Bundle'; 
            TestProd.PT_Number__c                        = PTnumber; 
             
        insert TestProd;
        Return TestProd;
    }
}