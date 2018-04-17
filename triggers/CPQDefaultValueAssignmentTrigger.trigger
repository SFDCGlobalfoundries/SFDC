/*
    Trigger Name:  CPQDefaultValueAssignmentTrigger  
    Author:        Prosenjit Saha(PS)
    Description:   This Trigger will update product attribute value record, to set default values for core and IO voltage.
    History: 
      PS           02282014    - Code creation.
     
*/
trigger CPQDefaultValueAssignmentTrigger on Apttus_Config2__ProductAttributeValue__c (before insert) {
    //Map to save Product attribute values and corresponding Line Item ID. Key: Product attribute value, Value: Line Item ID
    Map<Apttus_Config2__ProductAttributeValue__c,String > ProdAttributeMap = new Map<Apttus_Config2__ProductAttributeValue__c,String >();
    
    //preparing ProdAttributeMap.
    for(Apttus_Config2__ProductAttributeValue__c  ProdAttribute: trigger.new){
        ProdAttributeMap.put(ProdAttribute , ProdAttribute.Apttus_Config2__LineItemId__c);
    }  
    
    //call DefaultValueAssignmentMethod to populate value in the core and IO voltage fields.
    CPQDefaultValueAssignmentClass AssignmentDefaultValue = new CPQDefaultValueAssignmentClass ();
    AssignmentDefaultValue.DefaultValueAssignmentMethod(ProdAttributeMap);
     
}