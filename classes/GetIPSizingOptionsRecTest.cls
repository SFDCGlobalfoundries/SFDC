@isTest
Public Class GetIPSizingOptionsRecTest {
 

    @TestSetup static void testdata() 
    {
       DataUtilTest.loadEnvironmentVariables();
    }

    @isTest
    private static void testGetIPSizingOptionsRec() {
    
    
       Map<String,Object> fieldValueRFQMap = new Map<String,Object>();
       RFQ__c rfq = IPRDataFactory.createRFQ(fieldValueRFQMap);
        
            
       Map<String,Object> fieldValueIPRMap = new Map<String,Object>();
       IP_Request__c ipr = IPRDataFactory.createIPR(fieldValueIPRMap);
       
       Map<String,Object> fieldValueRFQIPRMap = new Map<String,Object>();
       fieldValueRFQIPRMap.put('RFQ__c',rfq.id); 
       fieldValueRFQIPRMap.put('IP_Request__c',ipr.id); 
       RFQ_IPR__c  rfqipr = IPRDataFactory.createRFQIPR(fieldValueRFQIPRMap);
       
       Map<String,Object> fieldValueipSIZMap = new Map<String,Object>();
       fieldValueipSIZMap.put('RFQ__c',rfq.id); 
       fieldValueipSIZMap.put('IP_Request__c',ipr.id); 
       IP_Sizing__c ipsiz = IPRDataFactory.createIPSizing(fieldValueipSIZMap);
       
       Map<String,Object> fieldValueipSIZOPTMap = new Map<String,Object>();
       fieldValueipSIZOPTMap.put('IP_Sizing__c',ipsiz.id); 
       fieldValueipSIZOPTMap.put('Status__c','Move to Development'); 
       IP_Sizing_Option__c ipsizopt = IPRDataFactory.createIPSizingOption(fieldValueipSIZOPTMap);
              
             
       Set<String> iprset = new Set<String>();
       ApexPages.StandardController con = new ApexPages.StandardController(rfq);
  
       GetIPSizingOptionsRec ext = new GetIPSizingOptionsRec(con);

       Test.startTest();
       ext.showIPSizOP(rfq.id);
       
       Test.stopTest();
                           
    }
 
}