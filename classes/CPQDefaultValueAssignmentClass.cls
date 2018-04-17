/*
    Class Name:    CPQDefaultValueAssignmentClass 
    Author:        Prosenjit Saha(PS)
    Description:   This class will update product attribute value record, to set default values for core and IO voltage.
                   Called from DefaultValueAssignmentTrigger.
    History: 
      PS           02282014    - Code creation.
      PS           03172015    - Code modification 
                                 Reason: Workflow functionalities will be handled thorough class. 
                                 Assignment of Process Technology ID during creation on Product Attribute Value record
      ARoy         05302016    - Code modified for Copy Configurator functionality to create Product Attribute Value record.
     
*/ 

public class CPQDefaultValueAssignmentClass {

/*
    Method Name:    DefaultValueAssignmentMethod
    Parameter  :    Map<Apttus_Config2__ProductAttributeValue__c,String>
    Return Type:    N/A
*/
    public void DefaultValueAssignmentMethod(Map<Apttus_Config2__ProductAttributeValue__c,String>  ProdAttributeMap ){
        //Map to get Core default value. Key: Line Item ID , Value: Core default value.
        Map<String,String> MapLineItemCoreProductCode = new Map<String,string>();
        //Map to get IO default value. Key: Line Item ID , Value: IO default value.
        Map<String,String> MapLineItemIOProductCode = new Map<String,String>();
        // PS : 03172015
        Map<String,String> MapLineItemIDProdCode = new Map<String,String>();

        List<Id> clonedConfigIds = new List<Id>();
        List<Id> configIds = new List<Id>();
        //Preparing LineItemID vs Default value map for Core and IO Voltage. 
        
        List<Apttus_Config2__LineItem__c> LineItemList;
        
        if(!Test.isRunningTest()){            
        
            LineItemList = [SELECT   id
                                     , Apttus_Config2__ProductId__c
                                     , Apttus_Config2__ProductId__r.Default_Core_Voltage__c
                                     , Apttus_Config2__ProductId__r.Default_IO_Voltage__c
                                     , Apttus_Config2__ProductId__r.ProductCode
                                     , Apttus_Config2__ProductId__r.Apttus_Config2__ConfigurationType__c
                                     , Apttus_Config2__ConfigurationId__r.Cloned_Configurator__c
                                     , Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c
                                     , Apttus_Config2__ProductId__r.PT_Number__c
                                     , Apttus_Config2__DerivedFromId__c
                                     , Apttus_Config2__DerivedFromId__r.Apttus_Config2__AttributeValueId__r.core_voltagae__c
                                     , Apttus_Config2__DerivedFromId__r.Apttus_Config2__AttributeValueId__r.IO_Voltage__c
                          FROM       Apttus_Config2__LineItem__c 
                          WHERE      ID 
                          IN         :ProdAttributeMap.Values()];
        }else{
            LineItemList = new List<Apttus_Config2__LineItem__c>();
            LineItemList.add(new Apttus_Config2__LineItem__c());  
        }
        
        for(Apttus_Config2__LineItem__c LineItem : LineItemList){

            MapLineItemCoreProductCode.put(LineItem.id,(LineItem.Apttus_Config2__DerivedFromId__c!=null)?LineItem.Apttus_Config2__DerivedFromId__r.Apttus_Config2__AttributeValueId__r.core_voltagae__c:LineItem.Apttus_Config2__ProductId__r.Default_Core_Voltage__c);
            MapLineItemIOProductCode.put(LineItem.id,(LineItem.Apttus_Config2__DerivedFromId__c!=null)?LineItem.Apttus_Config2__DerivedFromId__r.Apttus_Config2__AttributeValueId__r.IO_Voltage__c:LineItem.Apttus_Config2__ProductId__r.Default_IO_Voltage__c);
            // PS : 03172015

            MapLineItemIDProdCode.put(LineItem.id, LineItem.Apttus_Config2__ProductId__r.PT_Number__c);
            clonedConfigIds.add(LineItem.Apttus_Config2__ConfigurationId__r.Cloned_Configurator__c);
            if(!(Test.isRunningTest())){
                configIds.add(LineItem.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c);
            }else{
                List<Apttus_Config2__ProductConfiguration__c> pcTest = [select Apttus_QPConfig__Proposald__c from Apttus_Config2__ProductConfiguration__c where Apttus_Config2__Status__c = 'Finalized'];
                if(pcTest.size()>0){
                    configIds.add(pcTest[0].Apttus_QPConfig__Proposald__c);
                }
            }
        }               
        
        // 05302016 ARoy : Code modified for Copy Configurator functionality to create Product Attribute Value record
        //*******************************************************************************************//
        String ConfigCart ;
        List<Apttus_Config2__ProductConfiguration__c> prodConfigList;
        
        List<Apttus_Config2__ProductConfiguration__c> currentProdConfigList = [select    id 
                                                                               from      Apttus_Config2__ProductConfiguration__c
                                                                               where     Apttus_QPConfig__Proposald__c in :configIds
                                                                              ];
        
        if(currentProdConfigList.size()==1){
            prodConfigList = [select id,Apttus_QPConfig__Proposald__c from Apttus_Config2__ProductConfiguration__c where Apttus_QPConfig__Proposald__c in :clonedConfigIds and  Apttus_Config2__Status__c = 'Finalized' Order by createdDate desc ];
            
            if(prodConfigList.size()>0){
                ConfigCart = prodConfigList[0].id;
            }else{
                prodConfigList = [select id,Apttus_QPConfig__Proposald__c from Apttus_Config2__ProductConfiguration__c where Apttus_QPConfig__Proposald__c in :clonedConfigIds Order by createdDate desc ];
                ConfigCart = (prodConfigList.size()>0)?prodConfigList[0].id:null;
            }
        }
        
        List<String> attrIds = new List<String>();
        for(Apttus_Config2__LineItem__c li : [select     id, 
                                                         Apttus_Config2__AttributeValueId__c, 
                                                         Apttus_Config2__ConfigurationId__c, 
                                                         Apttus_Config2__LineType__c
                                              from       Apttus_Config2__LineItem__c
                                              where      Apttus_Config2__ConfigurationId__c = :ConfigCart
                                             ]){
            if(li.Apttus_Config2__LineType__c == 'Product/Service'){
                attrIds.add(li.Apttus_Config2__AttributeValueId__c);
            }
        }
        
        List<Schema.FieldSetMember> fields = SObjectType.Apttus_Config2__ProductAttributeValue__c.FieldSets.ProductAttributeValue.getFields();
        String query = 'SELECT ';
        for(Schema.FieldSetMember f : fields) {
            query += f.getFieldPath() + ', ';
        }
        query += 'Id FROM Apttus_Config2__ProductAttributeValue__c where id in :attrIds';
        List<Apttus_Config2__ProductAttributeValue__c> prodAttrList = Database.query(query);                
        
        
        //populate value in the core voltage and IO voltage fields.
        for(Apttus_Config2__ProductAttributeValue__c PAttributeValue: ProdAttributeMap.keyset() ){
            //get Item ID
            ID LineItemID = ProdAttributeMap.get(PAttributeValue);
            //Populating value in the core voltage and IO voltage value
            PAttributeValue.core_voltagae__c            =    String.valueof(MapLineItemCoreProductCode.get(LineItemID ));    
            PAttributeValue.IO_Voltage__c               =    String.valueof(MapLineItemIOProductCode.get(LineItemID ));  
            // PS : 03172015
            PAttributeValue.APTPS_ProcessTechnology__c  =    MapLineItemIDProdCode.get(LineItemID);                                   
            
            for(Schema.FieldSetMember f : fields){
                if(prodAttrList.size()>0 && prodAttrList[0].get(f.getFieldPath())!=null){
                    PAttributeValue.put(f.getFieldPath(),prodAttrList[0].get(f.getFieldPath()));
                }
            }
        } 
        
        //*******************************************************************************************//
    }

}