/**
* Author: Dilip Jha
* Project: Test Class Automation  
* Description: This utility class will be used to create Oppourtunity Program data in different Test classes
**/

@isTest
public class OpportunityProgramDataFactory
{
    public static List< Opportunity_Program__c> createOpportunityPrograms(List<Map<String,Object>> OpportunityProgramfieldValueMaps,Integer numOpportunityPrograms)    
    {
        // Validate parameters
        if (OpportunityProgramfieldValueMaps != null && OpportunityProgramfieldValueMaps.size() != numOpportunityPrograms)
        {
            throw new DataFactoryException ('OpportunityProgramfieldValueMaps Size must be equal to number of OpportunityProgram you want to create.');
        }
        
        List<Opportunity_Program__c> OpportunityProgramList=new List<Opportunity_Program__c>();
        
        for(Integer i=0;i<numOpportunityPrograms;i++)                    
        {
            
                Opportunity_Program__c OppPrg = new Opportunity_Program__c();
                OppPrg.Name='TestOppProg' + i+1;
                
             
            if (OpportunityProgramfieldValueMaps != null)
            {      
                Map<String,Object> OpportunityProgramfieldValueMap = OpportunityProgramfieldValueMaps.get(i);
                if (OpportunityProgramfieldValueMap.get('Account__c') != null && OpportunityProgramfieldValueMap.get('Opportunity__c') != null)
                {
                    for(String OpportunityProgramfield: OpportunityProgramfieldValueMap.keySet())
                    {
                        OppPrg.put(OpportunityProgramfield, OpportunityProgramfieldValueMap.get(OpportunityProgramfield));        
                    }
                }
                else
                {
                    doValidation(OpportunityProgramfieldValueMap);   
                }
            }
            OpportunityProgramList.add(OppPrg);    
        }
        
        insert OpportunityProgramList;
        
        return OpportunityProgramList;
    }
    
    public static Opportunity_Program__c createOpportunityProgram(Map<String,Object> OpportunityProgramfieldValueMap)
    {
        // Create Oppourtunity Program with default data that is required, this will handle cases where required fields are not set
        Opportunity_Program__c oppPrg = new Opportunity_Program__c();
        if (OpportunityProgramfieldValueMap != null && OpportunityProgramfieldValueMap.get('Account__c') != null && OpportunityProgramfieldValueMap.get('Opportunity__c') != null)
        
            { 
                        oppPrg.Name='TestOppProg';
                      
            for(String OppourtunityfieldName: OpportunityProgramfieldValueMap.keySet())
                {
                    oppPrg.put(OppourtunityfieldName, OpportunityProgramfieldValueMap.get(OppourtunityfieldName));        
                }

            insert oppPrg;
        }
        else
            {
            doValidation(OpportunityProgramfieldValueMap);     
            }
        
        return oppPrg;            
   }  
    
    public static void doValidation(Map<String,Object> OpportunityProgramfieldValueMap)
   {
       if (OpportunityProgramfieldValueMap.get('Account__c') == null)
           throw new DataFactoryException ('Account__c must be passed in as a field to be updated in the parameter passed to the method');    
       else if (OpportunityProgramfieldValueMap.get('Opportunity__c') == null)    
           throw new DataFactoryException ('Opportunity__c must be passed in as a field to be updated in the parameter passed to the method'); 
          
   }          
    
}