/**
* Author: Dilip Jha
* Project: Test Class Automation  
* Description: This utility class will be used to create Oppourtunity Program data in different Test classes
**/

@isTest
public class OpportunityProgramTeamDataFactory
    {
    
        public static List< Opportunity_Program_Team_Member__c> createOpportunityProgramTeams(List<Map<String,Object>> OpportunityProgramTeamfieldValueMaps,Integer numOpportunityProgramTeams)    
    {
        // Validate parameters
        if (OpportunityProgramTeamfieldValueMaps != null && OpportunityProgramTeamfieldValueMaps.size() != numOpportunityProgramTeams)
        {
            throw new DataFactoryException ('OpportunityProgramTeamfieldValueMaps Size must be equal to number of numOpportunityProgramTeams you want to create.');
        }
        
        List<Opportunity_Program_Team_Member__c> OpportunityProgramTeamList=new List<Opportunity_Program_Team_Member__c>();
        
        for(Integer i=0;i<numOpportunityProgramTeams;i++)                    
        {
            
                Opportunity_Program_Team_Member__c OppPrgTeam = new Opportunity_Program_Team_Member__c();
                   OppPrgTeam.Core_Team_Member__c=false;
                   OppPrgTeam.Device_Access__c='Read/Write';
                   OppPrgTeam.Opportunity_Program_Access__c='Read/Write';
                   OppPrgTeam.Flag_for_Delete__c=False;
             
            if (OpportunityProgramTeamfieldValueMaps != null)
            {      
                Map<String,Object> OpportunityProgramTeamfieldValueMap = OpportunityProgramTeamfieldValueMaps.get(i);
                if (OpportunityProgramTeamfieldValueMap.get('User__c') != null && OpportunityProgramTeamfieldValueMap.get('Team_Role__c') != null && OpportunityProgramTeamfieldValueMap.get('Opportunity_Program__c') != null)
                {
                    for(String OpportunityProgramTeamfield: OpportunityProgramTeamfieldValueMap.keySet())
                    {
                        OppPrgTeam.put(OpportunityProgramTeamfield, OpportunityProgramTeamfieldValueMap.get(OpportunityProgramTeamfield));        
                    }
                }
                else
                {
                    doValidation(OpportunityProgramTeamfieldValueMap);   
                }
            }
            OpportunityProgramTeamList.add(OppPrgTeam);    
        }
        
        insert OpportunityProgramTeamList;
        
        return OpportunityProgramTeamList;
    }
    
    public static Opportunity_Program_Team_Member__c createOpportunityProgramTeam(Map<String,Object> OpportunityProgramTeamfieldValueMap)
    {
        // Create Oppourtunity with default data that is required, this will handle cases where required fields are not set
        Opportunity_Program_Team_Member__c OppPrgTeam = new Opportunity_Program_Team_Member__c();
        if (OpportunityProgramTeamfieldValueMap!= null && OpportunityProgramTeamfieldValueMap.get('User__c') != null && OpportunityProgramTeamfieldValueMap.get('Team_Role__c') != null && OpportunityProgramTeamfieldValueMap.get('Opportunity_Program__c') != null)

        
            { 
                        OppPrgTeam.Core_Team_Member__c=false;
                         OppPrgTeam.Device_Access__c='Read/Write';
                        OppPrgTeam.Opportunity_Program_Access__c='Read/Write';
                        OppPrgTeam.Flag_for_Delete__c=False;
                      
            for(String OpportunityProgramTeamfieldName: OpportunityProgramTeamfieldValueMap.keySet())
                {
                    OppPrgTeam.put(OpportunityProgramTeamfieldName, OpportunityProgramTeamfieldValueMap.get(OpportunityProgramTeamfieldName));        
                }

            insert OppPrgTeam;
        }
        else
            {
            doValidation(OpportunityProgramTeamfieldValueMap);     
            }
        
        return OppPrgTeam;            
   }  
    
    
    public static void doValidation(Map<String,Object> OpportunityProgramTeamfieldValueMap)
   {
       if (OpportunityProgramTeamfieldValueMap.get('User__c') == null)    
           throw new DataFactoryException ('User__c must be passed in as a field to be updated in the parameter passed to the method'); 
       else if (OpportunityProgramTeamfieldValueMap.get('Team_Role__c') == null)    
           throw new DataFactoryException ('Team_Role__c must be passed in as a field to be updated in the parameter passed to the method'); 
       else if (OpportunityProgramTeamfieldValueMap.get('Opportunity_Program__c') == null)    
           throw new DataFactoryException ('Opportunity_Program__c must be passed in as a field to be updated in the parameter passed to the method'); 
          
   }      
    
    
    }