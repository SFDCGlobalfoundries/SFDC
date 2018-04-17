/**
* Author: Dilip Jha
* Project: Test Class Automation  
* Description: This utility class will be used to create AccountTeam Proxy data in different Test classes
**/

@isTest
public class AccountTeamProxyDataFactory
{
    /* Method to create Account Team proxy Test Data record Dynamically*/
   public static List<Account_Team_Proxy__c> CreateAccountTeamProxies(List<Map<String,Object>> AccountTeamProxyfieldValueMaps,Integer numATP)    
    {
        // Validate parameters
        if (AccountTeamProxyfieldValueMaps != null && AccountTeamProxyfieldValueMaps.size() != numATP)
        {
            throw new DataFactoryException ('FieldValueMap Size must be equal to number of accounts TEAM PROXY you want to create.');
        }
        
        List<Account_Team_Proxy__c> atpList=new List<Account_Team_Proxy__c>();
        
        for(Integer i=0;i<numATP;i++)                    
        {
                Account_Team_Proxy__c  atp = new Account_Team_Proxy__c ();
                atp.Account_Access__c='Read/Write';
                atp.Opportunity_Access__c='Read/Write';
                atp.Sequence_No__c='2';
                atp.Account_Role_ID__c='test2';
                    
            if (AccountTeamProxyfieldValueMaps != null)
            {      
                Map<String,Object> AccountTeamProxyfieldValueMap = AccountTeamProxyfieldValueMaps.get(i);
                if (AccountTeamProxyfieldValueMap.get('Account__c') != null && AccountTeamProxyfieldValueMap.get('User__c') != null && AccountTeamProxyfieldValueMap.get('Team_Role__c') != null)
                {
                    for(String AccountTeamProxyfieldName: AccountTeamProxyfieldValueMap.keySet())
                    {
                        atp.put(AccountTeamProxyfieldName, AccountTeamProxyfieldValueMap.get(AccountTeamProxyfieldName));        
                    }
                }
                else
                {
                    doValidation(AccountTeamProxyfieldValueMap);   
                }
            }
            atpList.add(atp);    
        }
        
        insert atpList;
        
        return atpList;
    }
          
    /* Method to create one Contact Test Data record Dynamically*/
    public static Account_Team_Proxy__c CreateAccountTeamProxy(Map<String,Object> AccountTeamProxyfieldValueMap)
    {
        // Create Account Team Proxy with default data that is required, this will handle cases where required fields are not set
        // Check whether AccountID was passed in as a parameter
        
        Account_Team_Proxy__c atp = new Account_Team_Proxy__c();
        
        if (AccountTeamProxyfieldValueMap != null && AccountTeamProxyfieldValueMap.get('Account__c') != null && AccountTeamProxyfieldValueMap.get('User__c') != null)
        { 
                atp.Account_Access__c='Read/Write';
                atp.Opportunity_Access__c='Read/Write';
                atp.Team_Role__c='Backup Customer Service Rep';
                atp.Sequence_No__c='2';
                atp.Account_Role_ID__c='test2';
                      
            for(String AccountTeamProxyfieldName: AccountTeamProxyfieldValueMap.keySet())
            {
                atp.put(AccountTeamProxyfieldName, AccountTeamProxyfieldValueMap.get(AccountTeamProxyfieldName));        
            }

            insert atp;
        }
        else
        {
            doValidation(AccountTeamProxyfieldValueMap);  
        }
        
        return atp;            
   }              


   public static void doValidation(Map<String,Object> AccountTeamProxyfieldValueMap)
   {
       if (AccountTeamProxyfieldValueMap.get('Account__c') == null)
           throw new DataFactoryException ('Account__c must be passed in as a field to be updated in the parameter passed to the method');    
       else if (AccountTeamProxyfieldValueMap.get('User__c ') == null)    
           throw new DataFactoryException ('User__c must be passed in as a field to be updated in the parameter passed to the method'); 
       else if (AccountTeamProxyfieldValueMap.get('Team_Role__c') == null)
           throw new DataFactoryException ('Team_Role__c must be passed in as a field to be updated in the parameter passed to the method');    
   }
    
}