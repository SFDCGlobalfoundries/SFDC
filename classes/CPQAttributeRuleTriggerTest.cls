/**
*   Author: Prosenjit Saha
*   Description: This is the test class for following triggers and classes:
                    1. CPQAttributeRuleTrigger
                    2. CPQAttributeRuleTriggerHandler
                    3. CPQAttributeRuleEditController
                    4. CPQAttributeRuleEditMultiController //added on 06082015

*   History:
*       PSaha          05182015     - code creation.
*		PSaha		   06082015		- Code Modification: Added Test class for CPQAttributeRuleEditMultiController
*     
**/
@istest(SeeAllData=false)
public class CPQAttributeRuleTriggerTest{
	@testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
    } 
    
	/*
    * Method Name:     AttributeRuleTest1
    * Return Type:     NA
    * Parameter  :     NA
    * Reason     :     This method handle all the testing related to following triggers and classes:
    					  1. CPQAttributeRuleTrigger
                		  2. CPQAttributeRuleTriggerHandler
	                      3. CPQAttributeRuleEditController
    */
    static testmethod void AttributeRuleTest1(){
    	Product2 ParentProduct = createProduct('PT00XXXX');
    	CPQ_MLGPLUS__c mlgplus = getCPQMLG(ParentProduct.id);
    	Attribute_Rule__c TestAttributeRule = new Attribute_Rule__c();
			TestAttributeRule.name = 'Test Attribute';
			TestAttributeRule.CPQ_MLGPLUS__c  = mlgplus.id ; 
			TestAttributeRule.Attribute_Field_API_Name__c = 'Bumping_for_FC__c';
			TestAttributeRule.Attribute_Group_Name__c = 'Packaging';
			TestAttributeRule.Attribute_Field_Value__c = 'Test Value';
			TestAttributeRule.Mask_Layers__c = 'PK,ST';
		insert TestAttributeRule ; 
    	ApexPages.StandardController stdController = new ApexPages.StandardController (TestAttributeRule) ;	
    	pageReference pageRef = page.CPQMetadataStatus ; 
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('Id',mlgplus.id);
        Test.startTest();
        	CPQAttributeRuleEditController TestController = new CPQAttributeRuleEditController(stdController);
	        TestController.AttributeField = 'Bumping_for_FC__c';
	        TestController.AttributeFieldValue = 'Test Value';
        	TestController.onSelectAttributeValues (); 
        	TestController.getFieldValues () ; 
        	TestController.getFieldValuesCreate ();
        	TestController.onSelectAttributeValuesEdit();
        	TestController.saveAtt(); 
        Test.stopTest();
    } 
    
    /*
    * Method Name:     AttributeRuleTest2
    * Return Type:     NA
    * Parameter  :     NA
    * Reason     :     This method handle all the testing related to following triggers and classes:
    					  1. CPQAttributeRuleTrigger
                		  2. CPQAttributeRuleTriggerHandler
	                      3. CPQAttributeRuleEditController
    */
    static testmethod void AttributeRuleTest2(){
    	Product2 ParentProduct = createProduct('PT00XXXX');
    	CPQ_MLGPLUS__c mlgplus = getCPQMLG(ParentProduct.id);
    	Attribute_Rule__c TestAttributeRule = new Attribute_Rule__c();
			TestAttributeRule.name = 'Test Attribute';
			TestAttributeRule.CPQ_MLGPLUS__c  = mlgplus.id ; 
			TestAttributeRule.Attribute_Field_API_Name__c = 'Bumping_for_FC__c';
			TestAttributeRule.Attribute_Group_Name__c = 'Packaging';
			TestAttributeRule.Attribute_Field_Value__c = 'Test Value';
			TestAttributeRule.Mask_Layers__c = 'PK,ST';
		insert TestAttributeRule ; 
    	ApexPages.StandardController stdController = new ApexPages.StandardController (TestAttributeRule) ;	
    	pageReference pageRef = page.CPQMetadataStatus ; 
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('retURL',mlgplus.id);
        Test.startTest();
        	CPQAttributeRuleEditController TestController = new CPQAttributeRuleEditController(stdController);
	        TestController.AttributeField = 'Bumping_for_FC__c';
	        TestController.AttributeFieldValue = 'Test Value';
        	TestController.onSelectAttributeValues (); 
        	TestController.getFieldValues () ; 
        	TestController.getFieldValuesCreate ();
        	TestController.onSelectAttributeValuesEdit();
        	TestController.saveAtt(); 
        Test.stopTest();
    } 
    
    /*
    * Method Name:     AttributeRuleTest3
    * Return Type:     NA
    * Parameter  :     NA
    * Reason     :     This method handle all the testing related to following triggers and classes:
    					  1. CPQAttributeRuleTrigger
                		  2. CPQAttributeRuleTriggerHandler
	                      3. CPQAttributeRuleEditController
    */
    static testmethod void AttributeRuleTest3(){
    	Product2 ParentProduct = createProduct('PT00XXXX');
    	CPQ_MLGPLUS__c mlgplus = getCPQMLG(ParentProduct.id);
    	Attribute_Rule__c TestAttributeRule = new Attribute_Rule__c();
			TestAttributeRule.name = 'Test Attribute';
			TestAttributeRule.CPQ_MLGPLUS__c  = mlgplus.id ; 
			TestAttributeRule.Attribute_Field_API_Name__c = 'Bumping_for_FC__c';
			TestAttributeRule.Attribute_Group_Name__c = 'Packaging';
			TestAttributeRule.Attribute_Field_Value__c = 'Test Value';
			TestAttributeRule.Mask_Layers__c = 'PK,ST';
		insert TestAttributeRule ; 
		delete TestAttributeRule ; 
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
	/*
    * Method Name:     getCPQMLG
    * Return Type:     CPQ_MLGPLUS__c
    * Parameter  :     Product2
    * Reason     :     This method returns new CPQ MLG record
    */
    static CPQ_MLGPLUS__c getCPQMLG(String ParentProdID) {
    	CPQ_MLGPLUS__c cpqmlgplus = new CPQ_MLGPLUS__c(	Catalog_Type__c = 'First Source'
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
    * Method Name:     AttributeRuleTest4
    * Return Type:     NA
    * Parameter  :     NA
    * Reason     :     This method handle all the testing related to following triggers and classes:
    					  1. CPQAttributeRuleEditMultiController
    */
    static testmethod void AttributeRuleTest4(){
    	Product2 ParentProduct = createProduct('PT00XXXX');
    	CPQ_MLGPLUS__c mlgplus = getCPQMLG(ParentProduct.id);
    	Attribute_Rule__c TestAttributeRule = new Attribute_Rule__c();
			TestAttributeRule.name = 'Test Attribute';
			TestAttributeRule.CPQ_MLGPLUS__c  = mlgplus.id ; 
			TestAttributeRule.Attribute_Field_API_Name__c = 'Bumping_for_FC__c';
			TestAttributeRule.Attribute_Group_Name__c = 'Packaging';
			TestAttributeRule.Attribute_Field_Value__c = 'Test Value';
			TestAttributeRule.Mask_Layers__c = 'PK,ST';
		insert TestAttributeRule ; 
    	ApexPages.StandardController stdController = new ApexPages.StandardController (TestAttributeRule) ;	
    	pageReference pageRef = page.CPQAttributeRuleCreateMulti ; 
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('retURL',mlgplus.id);
        List<Apttus_Config2__ProductAttribute__c> ProdAttList = new List<Apttus_Config2__ProductAttribute__c> ();
        ProdAttList = prodAttributeCreate();
        Test.startTest();
        	CPQAttributeRuleEditMultiController TestController = new CPQAttributeRuleEditMultiController(stdController);
        	CPQAttributeRuleEditMultiController.AttributeWrapper testWrap = new CPQAttributeRuleEditMultiController.AttributeWrapper();
        	TestController.getNewAttibuteRow() ;
        	testWrap.AttributeGroupName = 'Test Group';
        	testWrap.AttributeField  = 'Bumping_for_FC__c';
        	testWrap.AttributeFieldValue  = 'Test Value';
        	testWrap.MaskLayers = 'AB, CD';
        	testWrap.FieldValue  = 'Test';
        	TestController.AttributeWrapList.add(testWrap);
        	TestController.saveAtt(); 
        Test.stopTest();
    } 
    
    static List<Apttus_Config2__ProductAttribute__c> prodAttributeCreate(){
		Apttus_Config2__ProductAttributeGroup__c ProdAttGroup = createProdAttributeGroup();
    	List<Apttus_Config2__ProductAttribute__c> newList = new List<Apttus_Config2__ProductAttribute__c>();
    		Apttus_Config2__ProductAttribute__c prodatt = new Apttus_Config2__ProductAttribute__c(	Apttus_Config2__AttributeGroupId__c = ProdAttGroup.id
    																								, Apttus_Config2__Field__c = 'Bumping_for_FC__c'
    																								,Apttus_Config2__Sequence__c = 1);
			newList.add(prodatt);
		insert newList; 
		return newList;
    }
	
	Static Apttus_Config2__ProductAttributeGroup__c createProdAttributeGroup (){
    	Apttus_Config2__ProductAttributeGroup__c prodAtt = new Apttus_Config2__ProductAttributeGroup__c(
    		Name 									= 'Packaging'
    		, Apttus_Config2__BusinessObject__c 	= 'Apttus_Config2__ProductAttributeValue__c'
    		, Product_Attribute_Group_External_Id__c= 'Test Packaging'
    	);
    	insert prodAtt;
    	return prodAtt;
    }
    
}