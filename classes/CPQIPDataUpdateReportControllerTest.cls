/**
* Author: Shuchismita Mallik
* Description: This is the test class for CPQIPDataUpdateReportController and BatchProcessIpData    
**/
@isTest(SeeAllData=false)
private class CPQIPDataUpdateReportControllerTest{    
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
            TestProd.Geometry__c                         = '>0.18UM';
            TestProd.Apttus_Config2__ConfigurationType__c= 'Bundle'; 
            TestProd.PT_Number__c                        = PTnumber; 
            TestProd.Catalog_type__c                     = 'First Source';              
        insert TestProd;
        Return TestProd;
    }
    
    /*
    * Method Name:     CPQIPDataUpdateReportController
    * Return Type:     NA
    * Parameter  :     NA
    * Reason     :     This method Tests CPQIPDataUpdateReportController.
    */    
    static testMethod void CPQIPDataUpdateReportController(){
        Product2 ParentProduct = createProduct('PT00XXXX');
        Process_Technology__c pt = new Process_Technology__c(
                                    name        =  'PT00XXXX',
                                    Lifecycle__c    =  'Product',
                                    Tech_Geometry__c=  '>0.18UM',
                                    PT_Number__c    = 'PT00XXXX');
        
        insert pt;
        
        Base_Ip__c ip = new Base_Ip__c (
                            name            = 'IP00XXXX',
                            ip_number__c    = 'IP00XXXX',
                            IP_Type__c      = 'AMS',
                            Ip_Vendor__c    = 'GF',
                            description__c  = 'test',
                            LifeCycle__c    = 'Approved');
                           
        insert ip;
        
        IP__c ipDk = new IP__c( IP_Device_List__c = 'pn_2p5',
                                Metal_Stack_List__c = 'M1;M2;M3',
                                LifeCycle__c = 'FB Design Kit Approved',
                                IPNumber__c  = ip.id,
                                IP_ID__c = ip.name,
                                Name = ip.Name+'-00',
                                Latest_Version__c = ip.Name+'-00',
                                PT_Number__c = 'PT00XXXX',
                                IP_Vendor__c = 'GF',
                                IP_Type__c = 'AMS');
        insert ipDk;
        
        IP_PT_Map__c ipMap = new IP_PT_Map__c(IPNumber__c = ip.id,
                                              IP_PT_Number__c = 'IP00XXXX' + 'PT00XXXX',
                                              IP_Type__c = 'AMS',
                                              PT_Number__c  = pt.id);  
        insert ipMap;        
             Apttus_Config2__ClassificationName__c category = new Apttus_Config2__ClassificationName__c(Apttus_Config2__Active__c = true,Category_External_ID__c = 'GLOBALFOUNDRIES Offering',Apttus_Config2__HierarchyLabel__c = 'GLOBALFOUNDRIES Offering',Apttus_Config2__Type__c = 'Offering');
             insert category;
             Apttus_Config2__ClassificationHierarchy__c catHierarchy = new Apttus_Config2__ClassificationHierarchy__c(Apttus_Config2__Label__c = 'Other',Name = 'Other',Category_Hierarchy_External_ID__c = 'Other',Apttus_Config2__HierarchyId__c = category.id);
             insert catHierarchy;
             
             product2 compProd = new product2(Product_External_ID__c = 'IP00XXXX'
                                             ,ProductCode           = 'IP00XXXY'              
                                             ,Description__c        = 'IP00XXXY'
                                             ,IsActive              =TRUE 
                                             ,Geometry__c           = '>0.18UM'
                                             ,Apttus_Config2__ConfigurationType__c   = 'Option'
                                             ,Apttus_Config2__HasAttributes__c       = FALSE
                                             ,Apttus_Config2__HasDefaults__c         = FALSE
                                             ,Apttus_Config2__HasOptions__c          = FALSE
                                             ,Apttus_Config2__HasSearchAttributes__c = FALSE
                                             ,APTPS_IP_Lifecycle__c = 'Approved'
                                             ,APTPS_IP_Type__c = 'AMS'
                                             ,APTPS_IP_Vendors__c = 'GF'
                                             ,Apttus_Config2__Customizable__c        = FALSE
                                             ,Family                                 = 'IPs'
                                             ,Name                                   = 'test'
                                             ,Apttus_Config2__Uom__c                 = 'Each'
                                             ,IP_Device_List__c                      = 'pn_2p5'
                                             ,APTPS_Metal_Stack__c = 'M1;M2;M3'
                                             ,Description   = 'M1;M2;M3'                        
                                             ,IP_PT_ID__c = ip.id
                                             ,Apttus_Config2__IconId__c              = null
                                             );
             insert compProd;
             product2 devProd = new product2(Product_External_ID__c = 'Test_PT00XXXX_pn_2p5'
                                             ,ProductCode           = 'Test_PT00XXXX_pn_2p5'              
                                             ,Description__c        = 'pn_2p5'
                                             ,IsActive              =TRUE 
                                             ,Geometry__c           = '>0.18UM'
                                             ,Apttus_Config2__ConfigurationType__c   = 'Option'
                                             ,Family                                 = 'Devices'
                                             ,Name                                   = 'P+/Nwell diode (without DV mask)'
                                             ,Mask_Sets__c = 'M1;M2;M3'
                                             );
             insert devProd; 
             Apttus_Config2__ProductOptionComponent__c prodOptnComp = new Apttus_Config2__ProductOptionComponent__c(Apttus_Config2__AllowCloning__c = false                                                                                                                   
                                                                                                                   ,Apttus_Config2__ComponentProductId__c = compProd.id
                                                                                                                   ,Apttus_Config2__Default__c = false
                                                                                                                   ,Apttus_Config2__Modifiable__c = false
                                                                                                                   ,Apttus_Config2__ParentProductId__c = ParentProduct.id
                                                                                                                   ,Option_Component_External_ID__c = 'test'
                                                                                                                   ,Apttus_Config2__RelationshipType__c = 'Option'
                                                                                                                   ,Apttus_Config2__Required__c = false
                                                                                                                   ,Apttus_Config2__Sequence__c = 1);
             insert prodOptnComp;
             Apttus_Config2__ProductClassification__c prodClassification = new Apttus_Config2__ProductClassification__c (Product_Classification_External_ID__c  = 'IP00XXXX_OTHER',Apttus_Config2__ClassificationId__c = catHierarchy.id,Apttus_Config2__ProductId__c = compProd.id);
             insert prodClassification;
             Apttus_Config2__PriceList__c pricelist = new Apttus_Config2__PriceList__c(name = 'GLOBALFOUNDRIES Internal Price List');
             insert pricelist;
             CPQIPDataUpdateReportController  cpqIpUpdate = new CPQIPDataUpdateReportController ();
             cpqIpUpdate.isDisableFlag = false;
             try{
                Test.startTest();
                cpqIpUpdate.processIPData();
               Test.stopTest();
             }catch(Exception e){
                system.debug('Exception in Managed Package');
             }
    } 
    static testMethod void CPQIPDataUpdateReportControllerBlankChk(){
        Product2 ParentProduct = createProduct('PT00XXXX');
        CPQIPDataUpdateReportController  cpqIpUpdate = new CPQIPDataUpdateReportController ();
        cpqIpUpdate.isDisableFlag = false;
    }
    
}