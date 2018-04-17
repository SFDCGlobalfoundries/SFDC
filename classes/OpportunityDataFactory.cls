/**
* Author: Dilip Jha
* Project: Test Class Automation  
* Description: This utility class will be used to create oppourtunity data in different Test classes
**/

@isTest
public class OpportunityDataFactory
    {
        public static List<Opportunity>createOpportunities(List<Map<String,Object>> OpportunityValueMaps,Integer numOpportunity)    
        {
        // Validate parameters
        if (OpportunityValueMaps != null && OpportunityValueMaps.size() != numOpportunity)
            {
                throw new DataFactoryException ('FieldValueMap Size must be equal to number of accounts you want to create.');      
            }
        
        List<Opportunity> OpportunityList = new List<Opportunity>();
        
        for(Integer i=0;i<numOpportunity;i++)                    
        {
            
            Opportunity opp = new Opportunity( Name = 'Test Opportunity'+ i+1,
                        
                        StageName = '4. Decision',
                        CloseDate = Date.Today().addDays(10),
                        Target_Process_Node__c = '28HPP',
                        Market_Segment__c = 'Mobility',
                        Process_Platform__c = 'GF Baseline',
                        Fab_Split__c = 100,
                        Process_Geometry__c = '0.028UM',
                        Process_Family__c = 'Generic / Nominal',
                        Opportunity_Sourcing_Type__c = 'Second Source',
                        Fab_Assignment_1__c = 'FAB 3'

            );
                           
            if (OpportunityValueMaps != null)
            {      
                Map<String,Object> OpportunityValueMap = OpportunityValueMaps.get(i);
                if (OpportunityValueMap.get('AccountId') != null)
                    {
                       for(String OpportunityfieldName: OpportunityValueMap.keySet())
                            {
                                opp.put(OpportunityfieldName, OpportunityValueMap.get(OpportunityfieldName));        
                            }
                            
                    }
                    else
                {
                    doValidation(OpportunityValueMap);      
                }
             }
            OpportunityList.add(opp);    
        }
        
        insert OpportunityList;
        
        return OpportunityList;
    }
    
    public static Opportunity createOpportunity(Map<String,Object> OpportunityValueMap)
    {
        // Create Oppourtunity with default data that is required, this will handle cases where required fields are not set
        Opportunity opp = new Opportunity();
        if (OpportunityValueMap != null && OpportunityValueMap.get('AccountId') != null)
        { 
                        opp.Name = 'Test Opportunity';                        
                        opp.StageName = '4. Decision';
                        opp.CloseDate = Date.Today().addDays(10);
                        opp.Target_Process_Node__c = '28HPP';
                        opp.Market_Segment__c = 'Mobility';
                        opp.Process_Platform__c = 'GF Baseline';
                        opp.Fab_Split__c = 100;
                        opp.Process_Geometry__c = '0.028UM';
                        opp.Process_Family__c = 'Generic / Nominal';
                        opp.Opportunity_Sourcing_Type__c = 'Second Source';
                        opp.Fab_Assignment_1__c = 'FAB 3';
                      
            for(String OppourtunityfieldName: OpportunityValueMap.keySet())
                {
                    opp.put(OppourtunityfieldName, OpportunityValueMap.get(OppourtunityfieldName));        
                }

            insert opp;
        }
        else
            {
            doValidation(OpportunityValueMap);     
            }
        
        return opp;            
   }  
   
   public static void doValidation(Map<String,Object> OpportunityValueMap)
   {
       if (OpportunityValueMap.get('AccountId') == null)
           throw new DataFactoryException ('AccountId must be passed in as a field to be updated in the parameter passed to the method');       
   }            
        
     
}