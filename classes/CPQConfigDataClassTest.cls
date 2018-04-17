/**
* Author: Prosenjit Saha
* Description: This is the test class for CPQConfigDataClass

* History:
*     PSaha          06232014     - code creation.
*     
**/

@isTest(SeeAllData=true)
private class CPQConfigDataClassTest{
    
    /*
    * Method Name:     createMlg
    * Return Type:     List<CPQ_MLG__c>
    * Parameter  :     Product2
    * Reason     :     This method creates MLG Test Data. 
    */
    static void createMlg(Product2 ParentProd){
        integer count = 1; 
         
         CPQ_MLG__c TempMlg0    = new CPQ_MLG__c(
            Additional_Mask_s__c    = '6K,7K,99',
            Core_Voltage_V__c       =  null,
            Feature_Description__c  = 'Base features',
            Feature_Group__c        = 'Always included',
            Model_Name__c           =  null,
            FEOL_BEOL__c            = 'FEOL',
            IO_Voltage_V__c         =  null,
            Product_Name__c         = ParentProd.ID,
            Serial_Number__c        = count ++ 
        );
        
        CPQ_MLG__c TempMlg1    = new CPQ_MLG__c(
            Additional_Mask_s__c    = '05,06',
            Core_Voltage_V__c       = 1.08,
            Feature_Description__c  = '3LM',
            Feature_Group__c        = 'Metal Options',
            Model_Name__c           = '',
            FEOL_BEOL__c            = 'FEOL',
            IO_Voltage_V__c         = 1.5,
            Product_Name__c         = ParentProd.ID,
            Serial_Number__c        = count ++ 
        );
        
        CPQ_MLG__c TempMlg2    = new CPQ_MLG__c(
            Additional_Mask_s__c    = 'PV,SV',
            Core_Voltage_V__c       = 1.08,
            Feature_Description__c  = 'Test Dev1',
            Feature_Group__c        = 'BJT',
            Model_Name__c           = 'dev1',
            FEOL_BEOL__c            = 'FEOL',
            IO_Voltage_V__c         = 1.5,
            Product_Name__c         = ParentProd.ID,
            Serial_Number__c        = count ++ 
        );
        
        CPQ_MLG__c TempMlg3    = new CPQ_MLG__c(
            Additional_Mask_s__c    = 'PQ,SQ',
            Core_Voltage_V__c       = 1.08,
            Feature_Description__c  = 'Test Dev2',
            Feature_Group__c        = 'Varactor',
            Model_Name__c           = 'dev2',
            FEOL_BEOL__c            = 'FEOL',
            IO_Voltage_V__c         = 1.5,
            Product_Name__c         = ParentProd.ID,
            Serial_Number__c        = count ++ 
        );
                                 
        List<CPQ_MLG__c> mlgList =  new List<CPQ_MLG__c>{TempMlg0, TempMlg1, TempMlg2, TempMlg3};
        insert mlgList;
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
    * Method Name:     createIPPTMap
    * Return Type:     NA
    * Parameter  :     NA
    * Reason     :     This method creates Parent Product. 
    */
     static void createIPPTMap(String PTnumber){
        Process_Technology__c pt = new Process_Technology__c(
                                    name        =  PTnumber,
                                    Lifecycle__c    =  'Product',
                                    Tech_Geometry__c=  '0.028UM',
                                    PT_Number__c    = PTnumber);
        
        insert pt;
        
        Base_Ip__c ip = new Base_Ip__c (
                            name            = 'IP00XXXX',
                            ip_number__c    = 'IP00XXXX',
                            IP_Type__c      = 'AMS',
                            Ip_Vendor__c    = 'GF',
                            description__c  = 'test',
                            LifeCycle__c    = 'Approved');
        insert ip;
        
        IP__c ipDk = new IP__c( IP_Device_List__c = 'dev1,dev2',
                                Metal_Stack_List__c = 'M1;M2;M3',
                                LifeCycle__c = 'Approved',
                                IPNumber__c  = ip.id);
        insert ipDk;
        
        IP_PT_Map__c ipMap = new IP_PT_Map__c(IPNumber__c = ip.id,
                                              IP_PT_Number__c = 'IP00XXXX' + PTnumber,
                                              IP_Type__c = 'AMS',
                                              PT_Number__c  = pt.id);  
        insert ipMap;      
    }
    
    /*
    * Method Name:     CPQConfigDataClassMethod
    * Return Type:     NA
    * Parameter  :     NA
    * Reason     :     This method Tests CPQConfigDataClass.
    */
    static testMethod void CPQConfigDataClassMethod(){
        Product2 ParentProduct = createProduct('PT00XXXX');
        createIPPTMap('PT00XXXX');
        createMlg(ParentProduct);
        CPQConfigDataClass.insertIpMLGplus(ParentProduct);
        //to insert products
        
        test.startTest();
         List<string> PriceListNames=new List<string> {'PriceList1','PriceList2'}; 
            CPQConfigDataClass cpqcon = new CPQConfigDataClass();
            cpqcon.CategoryInsert(ParentProduct,PriceListNames);
            cpqcon.ConstraintRuleActionConditionInsert(ParentProduct);
        test.stopTest();
        CPQConfigDataClass.removeAll('PT00XXXX',true);
    }  
    
    
}