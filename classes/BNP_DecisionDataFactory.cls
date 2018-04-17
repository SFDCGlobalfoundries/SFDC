/**
* Author: Cognizant Technology Solutions
* Project: DIW 
* Description: This data factory class will be used to create Decision module data in different Test classes
**/

@isTest
public class BNP_DecisionDataFactory
{
    /*Decison Modules*/  
    /* Method to create one Decision Test Data record Dynamically*/
    public static Decision__c createDecision(Map<String,Object> fieldValueMap)
    {
        // Create decision with default data that is required, this will handle cases where required fields are not set
            Decision__c dsc = new Decision__c();
            dsc.Status__c = 'Completed';
       
            for(String DecisionfieldName:fieldValueMap.keySet())
            {
                dsc.put(DecisionfieldName, fieldValueMap.get(DecisionfieldName));
                
            }
           system.debug('Decision records' +dsc);
           insert dsc;
           return dsc;
    } 
 
      
   /* Method to create one Charge Info Test Data record Dynamically*/
    public static Charge_Info__c createChargeInfo(Map<String,Object> fieldValueMap)
    {
        // Create Charge Info with default data that is required, this will handle cases where required fields are not set  
           Charge_Info__c crg  = new Charge_Info__c();
           crg.Charge_Number__c = '123';
           crg.Charge_Type__c = 'Marketing Area Number';
           
           for(String chargeInfofieldName:fieldValueMap.keySet())
           { 
               crg.put(chargeInfofieldName,fieldValueMap.get(chargeInfofieldName));   
           }
           insert crg;    
           return crg;
    } 
           
    /* Method to create one Sap Order Detail Test Data record Dynamically*/
    public static SAP_Order_Detail__c createSapOrder(Map<String,Object> fieldValueMap)
    {
        // Create Sap Order Detail with default data that is required, this will handle cases where required fields are not set
            
            SAP_Order_Detail__c sr = new SAP_Order_Detail__c ();
            sr.Order_Type__c = 'Services';
            for(String sapOrderfieldName:fieldValueMap.keySet())
            {
              sr.put(sapOrderfieldName,fieldValueMap.get(sapOrderfieldName));     
            } 
            insert sr;
            return sr;
     }          
                       
            
    /* Method to create one Tech Review Test Data record Dynamically*/
    public static Tech_Review_Summary__c createTechReview(Map<String,Object> fieldValueMap)
    {
        // Create Tech Review with default data that is required, this will handle cases where required fields are not set
            
            Tech_Review_Summary__c tr = new Tech_Review_Summary__c();
            tr.Comments__c = 'Test tech review';
            for(String techreviewfieldName:fieldValueMap.keySet())
            {
              tr.put(techreviewfieldName,fieldValueMap.get(techreviewfieldName));     
            } 
            insert tr;
            return tr;
     }          
          
     /*Decision Modules End*/  
  }