/**
* Author: Cognizant Technology Solutions
* Project: DIW 
* Description: This data factory class will be used to create Options,Service,Chip,Wafer,Module,Package,Design,RI,RFQ Routing,RFQ Task data in different Test classes
**/

@isTest
public class BNP_DataFactory
{
    /*Options Modules*/  
    /* Method to create one Options Test Data record Dynamically*/
    public static Customer_Requirement__c createOption(Map<String,Object> fieldValueMap)
    {
        // Create option with default data that is required, this will handle cases where required fields are not set
            Customer_Requirement__c cr= new Customer_Requirement__c();
            cr.Deliverable_Part_Number_DPN__c = '1234';
            cr.Design_Assay_PN__c = '123456';
            cr.isTCA__c = 'No';
            cr.Total_Chip_Count__c = '1';
            cr.Reliability_grade_required__c = 'Yes';
            cr.Reliability_Grade__c = 'Grade 1 (Premium)';
            cr.Area_of_Concern_Description__c = 'test';
            cr.Deliverable_Type__c  ='service';
            cr.Node__c = '0.007UM';
            cr.Technology__c = '7LP';
            cr.Fab__c = 'FAB 1';
            cr.Product_Type__c = 'ASIC';
            cr.Customer_part_name__c = 'abcd1234';
            cr.MD_Part_Number__c = '1234';
            cr.Does_the_contract_or_accepted_quote__c ='No';
            for(String CudtomerRequirementfieldName:fieldValueMap.keySet())
            {
                cr.put(CudtomerRequirementfieldName, fieldValueMap.get(CudtomerRequirementfieldName));
                
            }
           system.debug('Options recards' +cr);
           insert cr;
           return cr;
    } 
 
      
   /* Method to create one Service Test Data record Dynamically*/
    public static Service__c createService(Map<String,Object> fieldValueMap)
    {
        // Create Service with default data that is required, this will handle cases where required fields are not set  
           Service__c  service = new Service__c ();
           service.Is_Deliverable_Type__c ='Yes'; 
           
           for(String servicefieldName:fieldValueMap.keySet())
           { 
               service.put(servicefieldName,fieldValueMap.get(servicefieldName));   
           }
           insert service;    
           return service;
    } 
           
    /* Method to create one wafer Test Data record Dynamically*/
    public static Wafer_Data__c createWaferData(Map<String,Object> fieldValueMap)
    {
        // Create waferdata with default data that is required, this will handle cases where required fields are not set
            
            Wafer_Data__c  WaferData = new Wafer_Data__c();
            WaferData.Is_Deliverable_Type__c = 'Yes';
            for(String waferfieldName:fieldValueMap.keySet())
            {
              WaferData.put(waferfieldName,fieldValueMap.get(waferfieldName));     
            } 
            insert WaferData;
            return WaferData;
     }          
                       
     /* Method to create one Chipdata Test Data record Dynamically*/
    public static Chip_Data__c createChipData(Map<String,Object> fieldValueMap)
    {
        // Create chipdata with default data that is required, this will handle cases where required fields are not set
            
            Chip_Data__c Chipdata = new Chip_Data__c();
            Chipdata.Is_Deliverable_Type__c = 'Yes';
            for(String chipfieldName:fieldValueMap.keySet())
            { 
               Chipdata.put(chipfieldName,fieldValueMap.get(chipfieldName));  
            }  
            insert Chipdata;
            return Chipdata;
    }      
          
     /* Method to create one ModuleData Test Data record Dynamically*/
    public static Module_Data__c createModuleData(Map<String,Object> fieldValueMap)
    {
        // Create ModuleData with default data that is required, this will handle cases where required fields are not set
        
          Module_Data__c ModuleData = new Module_Data__c();
          ModuleData.Is_Deliverable_Type__c = 'Yes'; 
          
          for(String ModulefieldName:fieldValueMap.keySet())
          {
             ModuleData.put(ModulefieldName,fieldValueMap.get(ModulefieldName));  
              
          }   
          insert ModuleData;    
          return ModuleData;
    } 
     /* Method to create one PackageData Test Data record Dynamically*/
    public static Package_Data__c createPackageData(Map<String,Object> fieldValueMap)
    {
        // Create PackageData with default data that is required, this will handle cases where required fields are not set
        
        Package_Data__c PackageData = new Package_Data__c();
        PackageData.Is_Deliverable_Type__c = 'Yes'; 
        
        for(String PackagefieldName:fieldValueMap.keySet())
        {
            PackageData.put(PackagefieldName,fieldValueMap.get(PackagefieldName));      
        }
        insert PackageData;     
        return PackageData;
    } 
    /* Method to create one Design Test Data record Dynamically*/
    public static Design__c  createDesign(Map<String,Object> fieldValueMap)
    {
        // Create Design with default data that is required, this will handle cases where required fields are not set
        
        Design__c Designdata = new Design__c();
        Designdata.Is_Deliverable_Type__c = 'Yes';
        
        for(String DesignfieldName:fieldValueMap.keySet())
        {
           Designdata.put(DesignfieldName,fieldValueMap.get(DesignfieldName));     
        }
        insert Designdata;    
        return Designdata;
    } 
    public static Delivery_Part_Number__c  createDPNumber(Map<String,Object> fieldValueMap)
    {
      // Create Delivery Part Number with default data that is required, this will handle cases where required fields are not set
        
        Delivery_Part_Number__c objDPN = new Delivery_Part_Number__c();
        objDPN.Name = '0000001LN0001';
        objDPN.Count__c= 1;
        for(String DPfieldName:fieldValueMap.keySet())
        {
           objDPN.put(DPfieldName,fieldValueMap.get(DPfieldName));     
        }
        insert objDPN;    
        return objDPN;
    }
     /*Options Modules End*/  
     /*BNP Modules*/ 
     /* Method to create one RequestInformation Test Data record Dynamically*/
    public static Request_Information__c createRequestInformation(Map<String,Object> fieldValueMap)
    {
        // Create RequestInformation with default data that is required, this will handle cases where required fields are not set
        
        Request_Information__c reqInfo = new Request_Information__c();
        reqInfo.Name = 'Test Bnp RFQ35';
        //reqInfo.Date_customer_wants_response__c = datetime.newInstance(2016, 10, 13, 12, 30, 0);
        //reqInfo.Date_customer_made_Request__c = datetime.newInstance(2016, 10, 13, 12, 30, 0);
                      
        for(String fieldName: fieldValueMap.keySet())
        {
            reqInfo.put(fieldName, fieldValueMap.get(fieldName));  
        }

        insert reqInfo;
        system.debug('RI Recard'+reqInfo);   
        return reqInfo;
    } 
    /* Method to create one  RFQRouting Test Data record Dynamically*/
    public static RFQ_Routing__c createRFQRouting(Map<String,Object> fieldValueMap)
    {
        // Create RFQRouting with default data that is required, this will handle cases where required fields are not set
        
        RFQ_Routing__c rfqRoute = new RFQ_Routing__c();
        rfqRoute.Name = 'Test Bnp route35';
        rfqRoute.Template__c = true;
        //rfqRoute.Status__c = 'Complete';
        for(String fieldName: fieldValueMap.keySet())
        {
            rfqRoute.put(fieldName, fieldValueMap.get(fieldName)); 
            
        }

        insert rfqRoute;
            
        return rfqRoute;
    } 
    /* Method to create one  RFQ_Tasks_Routing Test Data record Dynamically*/
    public static RFQ_Tasks_Routing__c createRFQTaskRouting(Map<String,Object> fieldValueMap)
    {
        // Create RFQ_Tasks_Routing with default data that is required, this will handle cases where required fields are not set
        
        RFQ_Tasks_Routing__c rfqRouteTask = new RFQ_Tasks_Routing__c();
        rfqRouteTask.Task_Name__c = 'Test Route Task';
        rfqRouteTask.Action__c = 'Notify Only';
        rfqRouteTask.Sequence__c = 'Any';
        rfqRouteTask.Order__c = 1;
        rfqRouteTask.Start_date__c  = System.now();
        rfqRouteTask.Task_Due_Date_and_Time__c = System.now();
        rfqRouteTask.Add_Offset_Days__c = '1';
       // rfqRouteTask.Task_Status__c = 'Pause';
       // rfqRouteTask.Pause_Reason__c = 'CEST Optimization Assessment';
        
        
        for(String fieldName: fieldValueMap.keySet())
        {
            rfqRouteTask.put(fieldName, fieldValueMap.get(fieldName));   
        }

        insert rfqRouteTask;
            
        return rfqRouteTask;
    } 
    /* Method to create one   RFQ_Task_Assignee Test Data record Dynamically*/
    public static RFQ_Task_Assignee__c createRFQTaskAssignee(Map<String,Object> fieldValueMap)
    {
        // Create  RFQ_Task_Assignee with default data that is required, this will handle cases where required fields are not set
        
        RFQ_Task_Assignee__c rfqRouteTaskAssignee = new RFQ_Task_Assignee__c();
        rfqRouteTaskAssignee.User_Type__c = 'Primary';
        rfqRouteTaskAssignee.Notify__c = true; 
        //rfqRouteTaskAssignee.Task_Assignee_Id__c  = 'task';             
        for(String fieldName: fieldValueMap.keySet())
        {
            rfqRouteTaskAssignee.put(fieldName, fieldValueMap.get(fieldName));   
        }

        insert rfqRouteTaskAssignee;
            
        return rfqRouteTaskAssignee;
    } 
    /* Method to create one   BnP Finance Quote Document Test Data record Dynamically*/
    public static BnP_Finance_Quote_Document__c createBnPFinanceQuoteDocument(Map<String,Object> fieldValueMap)
    {
        // Create  BnP Finance Quote Document with default data that is required, this will handle cases where required fields are not set
        
        BnP_Finance_Quote_Document__c BnpFQD= new BnP_Finance_Quote_Document__c ();
        BnpFQD.Name= 'test'; 
        //BnpFQD.Is_Financial_Document__c = true;  
        for(String fieldName: fieldValueMap.keySet())
        {
            BnpFQD.put(fieldName, fieldValueMap.get(fieldName));
        }

        insert BnpFQD;
            
        return BnpFQD;
    } 
    /* Method to create one   Attachment Test Data record Dynamically*/
    public static Attachment createAttachment(Map<String,Object> fieldValueMap)
    {
        // Create  Attachment with default data that is required, this will handle cases where required fields are not set
        
        Attachment  attch = new Attachment ();
        attch.Name = 'Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attch.body=bodyBlob; 
          
        for(String fieldName: fieldValueMap.keySet())
        {
            attch.put(fieldName, fieldValueMap.get(fieldName));
        }

        insert attch;
            
        return attch;
    } 
    /*BNP Modules End*/ 
}