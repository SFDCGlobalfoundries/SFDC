@isTest
Public Class IPRDataFactory{
  
    
    /* Method to create one RFQ Test Data record Dynamically*/
    public static RFQ__c createRFQ(Map<String,Object> fieldValueMap)
    {
        // Create RFQ with default data that is required, this will handle cases where required fields are not set
         RFQ__c rfq = new RFQ__c(Description__c='TestRFQ1',Status__c='Draft');    
              
          for(String RFQfieldName: fieldValueMap.keySet())
        {
            rfq.put(RFQfieldName, fieldValueMap.get(RFQfieldName));        
        }
        system.debug('RFQ records' +rfq);

        insert rfq;
            
        return rfq;
    }   
    
    /* Method to create one IPR Test Data record Dynamically*/
    public static IP_Request__c createIPR(Map<String,Object> fieldValueMap)
    {
        // Create IPR with default data that is required, this will handle cases where required fields are not set
         IP_Request__c ipr = new IP_Request__c(IP_Name__c='TestIPR',IP_Request_Description__c='Test des',Request_Type__c ='IPRequest');    
              
          for(String IPRfieldName: fieldValueMap.keySet())
        {
            ipr.put(IPRfieldName, fieldValueMap.get(IPRfieldName));        
        }
        system.debug('IPR records' +ipr);

        insert ipr;
            
        return ipr;
    }   
    
    /* Method to create one RFQIPR Test Data record Dynamically*/
    public static RFQ_IPR__c createRFQIPR(Map<String,Object> fieldValueMap)
    {
        // Create RFQIPR with default data that is required, this will handle cases where required fields are not set
         RFQ_IPR__c rfqipr = new RFQ_IPR__c(AcceptedbyCustomer__c=False);    
              
          for(String RFQIPRIPRfieldName: fieldValueMap.keySet())
        {
            rfqipr.put(RFQIPRIPRfieldName, fieldValueMap.get(RFQIPRIPRfieldName));        
        }
        system.debug('RFQIPR records' +rfqipr );
        try{
        insert rfqipr;
        }catch (Exception excp) {
                  
                  ApexPages.addMessages(excp);
                  GlobalUtility.logMessage('Error','CloneIPRwithSizing','cloning','','Exception while cloning IpSizingOptions records',String.valueof(excp.getMessage()),'','IP Request',excp,0);
                  return null;
               } 
            
        return rfqipr;
    }   
    
    /* Method to create one IPSizing Test Data record Dynamically*/
    public static IP_Sizing__c createIPSizing(Map<String,Object> fieldValueMap)
    {
        // Create IP Sizing with default data that is required, this will handle cases where required fields are not set
         IP_Sizing__c ipsiz = new IP_Sizing__c(Competitive_Offerings__c='Testing');    
              
         for(String ipsizfieldName: fieldValueMap.keySet())
         {
            ipsiz.put(ipsizfieldName, fieldValueMap.get(ipsizfieldName));        
         }
        system.debug('IPRSIZing records' +ipsiz );

        insert ipsiz;
            
        return ipsiz;
    }   
     
    public static IP_Sizing_Option__c createIPSizingOption(Map<String,Object> fieldValueMap)
    {
        // Create RFQ with default data that is required, this will handle cases where required fields are not set
         IP_Sizing_Option__c ipsizOP = new IP_Sizing_Option__c(X2nd_Line_Org__c='Testing');    
              
         for(String ipsizOPTfieldName: fieldValueMap.keySet())
         {
            ipsizOP.put(ipsizOPTfieldName, fieldValueMap.get(ipsizOPTfieldName));        
         }
        system.debug('IPRSIZingOPT records' +ipsizOP);

        insert ipsizOP;
            
        return ipsizOP;
    }  




}