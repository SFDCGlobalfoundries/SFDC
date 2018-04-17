/**
Author: Thomas Lai
Description: Test class for AccountRegionHeadMappingTrigger.
History:
    TL    27012014    - Created
**/
@isTest(seeAllData=false)
private class AccountRegionHeadMappingTriggerTest{
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        Map<String,Object> fieldValueMap = new Map<String,Object>();            
        fieldValueMap.put('Name', 'Strategic Account24233');            
        fieldValueMap.put('stage__c', 'Unqualified');
        fieldValueMap.put('short_name__c', 'test13141111');
        fieldValueMap.put('sub_type__c', 'Direct');
        fieldValueMap.put('site_department__c', 'hq');          
        fieldValueMap.put('transaction_type__c', 'transactional');
        fieldValueMap.put('account_profile__c', 'Fabless - Emerging');            
        fieldValueMap.put('Process_Tech_Interested__c', 'Mature (> 0.11um)');
        fieldValueMap.put('region__c', 'US-East');
        fieldValueMap.put('Sales_Territory__c', 'US-East');
        fieldValueMap.put('financial_territory__c', 'US-East');          
        fieldValueMap.put('Copy_Address__c', true);
        fieldValueMap.put('Corporate_Address_1__c', 'Lee');            
        fieldValueMap.put('Corporate_Country__c', 'Japan');
        fieldValueMap.put('Organization_Unit__c', 'GF Investment LLC OU');
        fieldValueMap.put('bill_to_location__c', 'YES');
        fieldValueMap.put('total_employee__c', 100);          
        fieldValueMap.put('end_customer__c', 'people');
        fieldValueMap.put('Revenue_Potential__c', 'High Potential');            
        fieldValueMap.put('Target_Account__c', 'Yes');
        fieldValueMap.put('Fab_9_10__c','No');
        
        AccountDataFactory.createAccount(fieldValueMap);
    }
    
    static Opportunity createOpportunity(Id testAcctId) {
        // Create Opportunity
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('AccountId',testAcctId);
        fieldValueMap.put('Name','Test Opportunity');  
        fieldValueMap.put('StageName','1. Discovery');
        fieldValueMap.put('CloseDate',Date.Today().addDays(10));  
        fieldValueMap.put('Target_Process_Node__c','14XM');
        fieldValueMap.put('Market_Segment__c','Mobility');  
        fieldValueMap.put('Process_Platform__c','GF Baseline');
        fieldValueMap.put('Fab_Split__c',100);          
        fieldValueMap.put('Process_Geometry__c','0.055UM');  
        fieldValueMap.put('Process_Family__c','Generic / Nominal');
        fieldValueMap.put('Marketing_Recommendation__c','Recommend for Approval');          
         
        return OpportunityDataFactory.createOpportunity(fieldValueMap);       
    }
    
    static testmethod void runTestInactiveMapping(){ 
        
        Account acc = getAccount('Strategic Account24233');
        createOpportunity(acc.id);
        Account_Region_Head_Mapping__c  mapping = new Account_Region_Head_Mapping__c(Region_Head_LK__c = userinfo.getUserId(),
                                                                                        Sales_SVP__c = userinfo.getuserId(),
                                                                                        Strategic_Account__c = acc.id,
                                                                                        isActive__c = true);
        insert mapping;
        
        Test.startTest();
        mapping.isactive__c = false;
        update mapping;
        
        
        Test.stopTest();
    }
    
    static testmethod void runTestAccountSalesTerritoryChange(){ 
        
        Account acc = getAccount('Strategic Account24233');
        createOpportunity(acc.id);
        Account_Region_Head_Mapping__c  mapping = [select id,region_head_lk__c from Account_Region_Head_Mapping__c where isActive__c = true and sales_territory__c = :acc.Financial_Territory__c];
        
        acc.Financial_Territory__c = 'US-East';
        acc.Account_Profile__c = 'Fabless - Emerging';
        acc.Process_Tech_Interested__c = 'Advanced (90nm to 40nm)';
        acc.Market_Segment__c = 'Automotive; Mobility';
        acc.Approval_Request__c = 'Promote to Qualified';
        acc.Total_Employee__c = 30;
        update acc;
        
        Test.startTest();
        user u = [select id from user where id != :userinfo.getuserId() and isactive = true limit 1];
       
        mapping.Region_Head_LK__c = u.id;
        mapping.sales_svp__c = userinfo.getuserId();
        update mapping;
        
        Test.stopTest();
    }
    
    static testmethod void runTestStrategicAccountChange(){ 
        
        Account acc = getAccount('Strategic Account24233');
        createOpportunity(acc.id);
        Account_Region_Head_Mapping__c  mapping = new Account_Region_Head_Mapping__c(Region_Head_LK__c = userinfo.getUserId(),
                                                                                        Sales_SVP__c = userinfo.getuserId(),
                                                                                        Strategic_Account__c = acc.id);
        insert mapping;
        
        Test.startTest();
        acc.Approval_Request__c = 'Promote to Qualified';
        acc.Approval_Request__c = 'Invoice Term Change';
        acc.Invoice_Term_Change_Request__c = 'Shipping Date';
        update acc;
        
        user u = [select id from user where id != :userinfo.getuserId() and isactive = true limit 1];
        mapping.Sales_SVP__c = u.id;
        mapping.Region_Head_LK__c = u.id;
        update mapping;
        
        Test.stopTest();
    }
    
    
    
    static testmethod void runTestStrategicAccountChange2(){ 
        //Custom Setting record
        ConstantOpportunityValueStoreList__c COVS = New ConstantOpportunityValueStoreList__c();
        COVS.Name = '14XM';
        COVS.Value__c = '14NM';
        
        insert COVS;
        
        Account acc = getAccount('Strategic Account24233');
        Opportunity oppty = createOpportunity(acc.id);
        Account_Region_Head_Mapping__c  mapping = new Account_Region_Head_Mapping__c(Region_Head_LK__c = userinfo.getUserId(),
                                                                                        Sales_SVP__c = userinfo.getuserId(),
                                                                                        Strategic_Account__c = acc.id);
        insert mapping;
        
        Test.startTest();
        oppty.Design_Win_Review_Status__c = 'Submitted for Review';
        update oppty;
        
        user u = [select id from user where id != :userinfo.getuserId() and isactive = true limit 1];
        mapping.Sales_SVP__c = u.id;
        mapping.Region_Head_LK__c = u.id;
        update mapping;
        Test.stopTest();
    }
    
     static testmethod void runTestStrategicAccountChange3(){ 
        
        Account acc = getAccount('Strategic Account24233');
        Opportunity oppty = createOpportunity(acc.id);
        Account_Region_Head_Mapping__c  mapping = new Account_Region_Head_Mapping__c(Region_Head_LK__c = userinfo.getUserId(),
                                                                                        Sales_SVP__c = userinfo.getuserId(),
                                                                                        Strategic_Account__c = acc.id);
        insert mapping;
        
        Test.startTest();
        oppty.Design_Win_Review_Status__c = 'Recommend for Approval';
        update oppty;
        
        user u = [select id from user where id != :userinfo.getuserId() and isactive = true limit 1];
        mapping.Sales_SVP__c = u.id;
        mapping.Region_Head_LK__c = u.id;
        update mapping;
        
        Test.stopTest();
    }  
    
     private static Account getAccount(string AccountName)
    {
        // Select columns you would like to use in your test class for the object. If only ID is used, just select ID
        Account acct = [SELECT Id,Financial_Territory__c FROM Account Where Name =: AccountName];
        
        return acct;
    }
    
}