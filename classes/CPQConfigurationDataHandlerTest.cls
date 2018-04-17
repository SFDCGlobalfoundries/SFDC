/**
* 	Author: Prosenjit Saha
* 	Description: This is the test class for CPQConfigurationDataHandler

* 	History:
*     	PSaha          05122015     - code creation.
*     
**/
@istest(SeeAllData=false)
public class CPQConfigurationDataHandlerTest {
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
    } 
    
    /*
    * Method Name:     insertdatabatch
    * Return Type:     NA
    * Parameter  :     NA
    * Reason     :     This method handle all the testing 
    */
    static testmethod void insertdatabatch(){   	
    	Product2 ParentProduct = createProduct('PT00XXXX');
    	createIPPTMap('PT00XXXX');
    	//createPublicGroup();
    	Apttus_Config2__ProductAttributeGroup__c ProdAttGroup = createProdAttributeGroup();
    	createPricelists () ; 
    	createCatagories() ; 
    	CPQ_MLGPLUS__c mlgplus = getCPQMLG(ParentProduct.id);
    	createMlg(mlgplus.id,ProdAttGroup);
    	List<CPQ_MLGPLUS__c> templist = new List<CPQ_MLGPLUS__c>();
    	templist.add(mlgplus);
    	ApexPages.StandardSetController sc = new ApexPages.StandardSetController(templist);   	
    	CPQProcessDataButtonController controllerButton = new CPQProcessDataButtonController(sc);
    	Test.startTest();
    		controllerButton.callBatchProcessData(); 
    		batchJobs testController = new batchJobs(); 
            testController.Classname = 'CPQConfigDataHandlerBatch'; 
            testController.getBatchJobs();  
    	Test.stopTest();
    } 
    
    /*
    * Method Name:     createPublicGroup
    * Return Type:     NA
    * Parameter  :     NA
    * Reason     :     Send mail to admin group users
    
    Static void createPublicGroup(){
    	Group TestGroup = new Group();
    		TestGroup.name = 'CPQ MLGPLUS Admin Users'; 
    		TestGroup.DeveloperName = 'Test_Admin_Group';
		insert TestGroup ; 
		GroupMember grpmem = new GroupMember();
			grpmem.GroupId = TestGroup.id;
			grpmem.UserOrGroupId =userinfo.getuserID();
		insert grpmem;
		system.debug('[debug: group Member ]'+grpmem.id);
    }*/
    
    /*
    * Method Name:     createCatagories
    * Return Type:     NA
    * Parameter  :     NA
    * Reason     :     This method creates Category and related category hierarchy 
    */
    static void createCatagories(){
    	Apttus_Config2__ClassificationName__c catalogGFOffering = new Apttus_Config2__ClassificationName__c( Name = 'GLOBALFOUNDRIES Offering'
    																										, Apttus_Config2__Active__c = TRUE
    																										, Category_External_ID__c = 'Test GF offering'
    																										, Apttus_Config2__Type__c = 'Offering'
    																										, Apttus_Config2__HierarchyLabel__c = 'GLOBALFOUNDRIES Offering');
		insert catalogGFOffering; 
		Apttus_Config2__ClassificationHierarchy__c catalogHierarchyStep1 = new Apttus_Config2__ClassificationHierarchy__c
																			( Name = 'GLOBALFOUNDRIES Offering'
																			, Category_Hierarchy_External_ID__c = 'Test GF offering'
																			, Apttus_Config2__Label__c = 'GLOBALFOUNDRIES Offering'
																			, Apttus_Config2__ExpandedByDefault__c = true
																			, Apttus_Config2__HideAllSearchFilters__c =  true
																			, Apttus_Config2__HierarchyId__c = catalogGFOffering.id
																			, Apttus_Config2__Left__c = 1
																			, Apttus_Config2__Level__c = 0
																			, Apttus_Config2__MaxOptions__c = 1
																			, Apttus_Config2__MinOptions__c = 1
																			, Apttus_Config2__Modifiable__c = true
																			, Apttus_Config2__Right__c = 38);
		insert catalogHierarchyStep1; 	
		List<Apttus_Config2__ClassificationHierarchy__c> catalogHierarchyStep2 = new List<Apttus_Config2__ClassificationHierarchy__c>();
		Apttus_Config2__ClassificationHierarchy__c catalogHierarchyStepIP = new Apttus_Config2__ClassificationHierarchy__c
																			( Name = 'Test IP catalog'
																			, Apttus_Config2__AncestorId__c = catalogHierarchyStep1.id
																			, Category_Hierarchy_External_ID__c = 'Test IP catalog'
																			, Apttus_Config2__Label__c = 'Test IP catalog'
																			, Apttus_Config2__PrimordialId__c = catalogHierarchyStep1.id
																			, Apttus_Config2__ExpandedByDefault__c = true
																			, Apttus_Config2__HideAllSearchFilters__c =  true
																			, Apttus_Config2__HierarchyId__c = catalogGFOffering.id
																			, Apttus_Config2__Left__c = 24
																			, Apttus_Config2__Level__c = 1
																			, Apttus_Config2__MaxOptions__c = 1
																			, Apttus_Config2__MinOptions__c = 1
																			, Apttus_Config2__Modifiable__c = true
																			, Apttus_Config2__Right__c = 37);
		Apttus_Config2__ClassificationHierarchy__c catalogHierarchyStepPT = new Apttus_Config2__ClassificationHierarchy__c
																			( Name = 'Test PT catalog'
																			, Apttus_Config2__AncestorId__c = catalogHierarchyStep1.id
																			, Category_Hierarchy_External_ID__c = 'Test PT catalog'
																			, Apttus_Config2__Label__c = 'Test PT catalog'
																			, Apttus_Config2__PrimordialId__c = catalogHierarchyStep1.id
																			, Apttus_Config2__ExpandedByDefault__c = true
																			, Apttus_Config2__HideAllSearchFilters__c =  true
																			, Apttus_Config2__HierarchyId__c = catalogGFOffering.id
																			, Apttus_Config2__Left__c = 2
																			, Apttus_Config2__Level__c = 1
																			, Apttus_Config2__MaxOptions__c = 1
																			, Apttus_Config2__MinOptions__c = 1
																			, Apttus_Config2__Modifiable__c = true
																			, Apttus_Config2__Right__c = 23);
		catalogHierarchyStep2.add(catalogHierarchyStepIP);
		catalogHierarchyStep2.add(catalogHierarchyStepPT);
		insert catalogHierarchyStep2; 
		List<String> PTGeomValues = new List<String>{'10nm','14nm','20nm','28nm','40nm','55nm','65nm','130nm','160nm','180nm','>180nm'};
		List<String> IPTypeValues = new List<String>{'AMS','IO','Phys','Logic','Memory','Other'};
		List<Apttus_Config2__ClassificationHierarchy__c> catalogHierarchyStep3 = new List<Apttus_Config2__ClassificationHierarchy__c>();
		integer InitialLeftValue = 3; 
		for(String geom : PTGeomValues){
			catalogHierarchyStep3.add(new Apttus_Config2__ClassificationHierarchy__c( Name = geom
																					, Apttus_Config2__AncestorId__c = catalogHierarchyStepPT.id
																					, Category_Hierarchy_External_ID__c = geom
																					, Apttus_Config2__Label__c = geom
																					, Apttus_Config2__PrimordialId__c = catalogHierarchyStep1.id
																					, Apttus_Config2__ExpandedByDefault__c = true
																					, Apttus_Config2__HideAllSearchFilters__c =  true
																					, Apttus_Config2__HierarchyId__c = catalogGFOffering.id
																					, Apttus_Config2__Left__c = InitialLeftValue
																					, Apttus_Config2__Level__c = 2
																					, Apttus_Config2__MaxOptions__c = 1
																					, Apttus_Config2__MinOptions__c = 1
																					, Apttus_Config2__Modifiable__c = true
																					, Apttus_Config2__Right__c = ++InitialLeftValue));
			InitialLeftValue ++ ;
		}
		for(String IPType : IPTypeValues){
			catalogHierarchyStep3.add(new Apttus_Config2__ClassificationHierarchy__c( Name = IPType
																					, Apttus_Config2__AncestorId__c = catalogHierarchyStepIP.id
																					, Category_Hierarchy_External_ID__c = IPType
																					, Apttus_Config2__Label__c = IPType
																					, Apttus_Config2__PrimordialId__c = catalogHierarchyStep1.id
																					, Apttus_Config2__ExpandedByDefault__c = true
																					, Apttus_Config2__HideAllSearchFilters__c =  true
																					, Apttus_Config2__HierarchyId__c = catalogGFOffering.id
																					, Apttus_Config2__Left__c = InitialLeftValue
																					, Apttus_Config2__Level__c = 2
																					, Apttus_Config2__MaxOptions__c = 1
																					, Apttus_Config2__MinOptions__c = 1
																					, Apttus_Config2__Modifiable__c = true
																					, Apttus_Config2__Right__c = ++InitialLeftValue));
			InitialLeftValue ++ ;
		}
		insert catalogHierarchyStep3;
		
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
            TestProd.Catalog_Type__c					 = 'First Source';
             
        insert TestProd;
        Return TestProd;
    }
    
    /*
    * Method Name:     createPricelists
    * Return Type:     NA
    * Parameter  :     NA
    * Reason     :     This method creates Price lists
    */
    static void createPricelists (){
    	List<Apttus_Config2__PriceList__c> ListPricelist = new List<Apttus_Config2__PriceList__c>();
    	Apttus_Config2__PriceList__c tempPricelist1 = new Apttus_Config2__PriceList__c(Apttus_Config2__Active__c = TRUE
																					  , Apttus_Config2__Description__c = 'test Pricelist 1'
																					  , Name  = 'test Pricelist 1'); 
  		Apttus_Config2__PriceList__c tempPricelist2 = new Apttus_Config2__PriceList__c(Apttus_Config2__Active__c = TRUE
																					  , Apttus_Config2__Description__c = 'test Pricelist 2'
																					  , Name  = 'test Pricelist 2'); 
    	ListPricelist.add(tempPricelist1);
    	ListPricelist.add(tempPricelist2);
    	insert ListPricelist;
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
    * Method Name:     createIPPTMap
    * Return Type:     NA
    * Parameter  :     NA
    * Reason     :     This method creates Parent Product. 
    */
     static void createIPPTMap(String PTnumber){
        Process_Technology__c pt = new Process_Technology__c(
                                    name        =  PTnumber,
                                    Lifecycle__c    =  'Product',
                                    Tech_Geometry__c=  '0.065UM',
                                    PT_Number__c    = PTnumber);
        
        insert pt;
        
        Base_Ip__c ip = new Base_Ip__c (
                            name            = 'IP00XXXX',
                            ip_number__c    = 'IP00XXXX',
                            IP_Type__c      = 'AMS',
                            Ip_Vendor__c    = 'GF',
                            description__c  = 'test',
                            LifeCycle__c    = 'FB Design Kit Approved');
        insert ip;
        
        IP__c ipDk = new IP__c( IP_Device_List__c = 'dev1,dev2',
                                Metal_Stack_List__c = 'M1;M2;M3',
                                LifeCycle__c = 'FB Design Kit Approved',
                                IPNumber__c  = ip.id ,
                                Latest_Version__c = ip.name+'-01',
                                name = ip.name+'-01');
        insert ipDk;
        
        IP_PT_Map__c ipMap = new IP_PT_Map__c(IPNumber__c = ip.id,
                                              IP_PT_Number__c = 'IP00XXXX' + PTnumber,
                                              IP_Type__c = 'AMS',
                                              PT_Number__c  = pt.id);  
        insert ipMap;      
    }
    
    
    
}