/**
*   Author: Prosenjit Saha
*   Description: This is the test class for CPQMetadataStatusController

*   History:
*       PSaha          05142015     - code creation.
*     
**/
@istest(SeeAllData=false)
public class CPQMetadataStatusControllerTest {
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
    } 
    /*
    * Method Name:     CPQMetadataTest
    * Return Type:     NA
    * Parameter  :     NA
    * Reason     :     This method handle all the Metadata related test for CPQMetadataStatusController class
    */
    static testmethod void CPQMetadataTest(){  
        Product2 ParentProduct = createProduct('PT00XXXX');
        CPQ_MLGPLUS__c mlgplus = getCPQMLG(ParentProduct.id);
        Apttus_Config2__ProductAttributeGroup__c ProdAttGroup = createProdAttributeGroup();
        createMlg(mlgplus.id,ProdAttGroup);
        ApexPages.StandardController sc = new ApexPages.StandardController(mlgplus);
        pageReference pageRef = page.CPQMetadataStatus ; 
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('Id',mlgplus.id);
        CPQMetadataStatusController controller = new CPQMetadataStatusController(sc);       
        controller.metadataLoad();
        
    }
    
    /*
    * Method Name:     createMlg
    * Return Type:     NA
    * Parameter  :     String mlgID
    * Reason     :     This method creates MLG Test Data. 
    */
    static void createMlg(String mlgplusID, Apttus_Config2__ProductAttributeGroup__c prodAttGroup){
        integer count = 1; 
         
         MLG_Record__c TempMlg0    = new MLG_Record__c(
            Additional_Mask_s__c    = '6K,7K,99',
            Core_Voltage_V__c       =  null,
            Feature_Description__c  = 'Base features',
            Feature_Group__c        = 'Always included',
            Model_Name__c           =  null,
            FEOL_BEOL__c            = 'FEOL',
            IO_Voltage_V__c         =  null,
            Serial_Number__c        = count ++ , 
            CPQ_MLGPLUS__c			= mlgplusID , 
            version__c				= '#1#'
        );
        
        MLG_Record__c TempMlg1    = new MLG_Record__c(
            Additional_Mask_s__c    = '05,06',
            Core_Voltage_V__c       = '1.08',
            Feature_Description__c  = '3LM',
            Feature_Group__c        = 'Metal Options',
            Model_Name__c           = '',
            FEOL_BEOL__c            = 'BEOL',
            IO_Voltage_V__c         = '1.5',
            Serial_Number__c        = count ++ , 
            CPQ_MLGPLUS__c			= mlgplusID,
            version__c				= '#1#'
        );
        
        MLG_Record__c TempMlg2    = new MLG_Record__c(
            Additional_Mask_s__c    = 'PV,SV',
            Core_Voltage_V__c       = '1.08',
            Feature_Description__c  = 'Test Dev1',
            Feature_Group__c        = 'BJT',
            Model_Name__c           = 'dev1',
            FEOL_BEOL__c            = 'FEOL',
            IO_Voltage_V__c         = '1.5',
            Serial_Number__c        = count ++ , 
            CPQ_MLGPLUS__c			= mlgplusID,
            version__c				= '#1#'
        );
        
        MLG_Record__c TempMlg3    = new MLG_Record__c(
            Additional_Mask_s__c    = 'PQ,SQ',
            Core_Voltage_V__c       = '1.08',
            Feature_Description__c  = 'Test Dev2',
            Feature_Group__c        = 'Varactor',
            Model_Name__c           = 'dev2',
            FEOL_BEOL__c            = 'FEOL',
            IO_Voltage_V__c         = '1.5',
            Serial_Number__c        = count ++ , 
            CPQ_MLGPLUS__c			= mlgplusID,
            version__c				= '#1#'
        );
        
        Attribute_Rule__c attributeRule 	= new Attribute_Rule__c(
        	Name							= 'Rule-01'
        	, Attribute_Field_API_Name__c	= 'Bump_for_FC__c'
        	, Attribute_Field_Value__c		= 'Cu Pillar'
        	, Attribute_Group_Name__c		= prodAttGroup.id
        	, Mask_Layers__c				= 'XY,MN'
        	, CPQ_MLGPLUS__c				= mlgplusID
        );                               
        List<MLG_Record__c> mlgList =  new List<MLG_Record__c>{TempMlg0, TempMlg1, TempMlg2, TempMlg3};
        insert mlgList;
    }
    
    /*
    * Method Name:     createProdAttributeGroup
    * Return Type:     Apttus_Config2__ProductAttributeGroup__c
    * Parameter  :     NA
    * Reason     :     This method returns new Product Attribute Groups
    */
    Static Apttus_Config2__ProductAttributeGroup__c createProdAttributeGroup (){
    	Apttus_Config2__ProductAttributeGroup__c prodAtt = new Apttus_Config2__ProductAttributeGroup__c(
    		Name 									= 'Packaging'
    		, Apttus_Config2__BusinessObject__c 	= 'Apttus_Config2__ProductAttributeValue__c'
    		, Product_Attribute_Group_External_Id__c= 'Test Packaging'
    	);
    	insert prodAtt;
    	return prodAtt;
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