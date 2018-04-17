/*
    Author: Sandesh Singh
    Description: This is the test class for CustomerSatisfactionCloneExtention class 
    History:
        Sandesh 24/10/2017    - code creation.
*/
@isTest(SeeAllData=false)
private class CustomerSatisfactionCloneExtentionTest {

    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
    }
    
    private static Customer_Satsfaction__c getCustomerSat(){
        Map<String,Object> cusSatMap = new Map<String,Object>();
        cusSatMap.put('Quarter_New__c', 'Q2');
        cusSatMap.put('New_Product_Color__c', 'RED');
        cusSatMap.put('New_Technology_Color__c', 'YELLOW');
        /*List<Map<String,Object>> fieldValueMaps = new List<Map<String,Object>>();
        fieldValueMaps.add(cusSatMap);*/
        CustomerSatisfactionDataFactory.createCustomerSatisfaction(cusSatMap);
        
        return [Select Id,Name,Merit_Index_for_customers__c,Quarter_New__c,Score_Year__c
                From Customer_Satsfaction__c LIMIT 1];
    }
    
    private static List<Next_QBR__c> getNextQBR(){
        Map<String,Object> nextQBRs = new Map<String,Object>();
        nextQBRs.put('Customer_Satisfaction__c', getCustomerSat().Id);
        nextQBRs.put('Weight__c', 20);
        List<Map<String,Object>> fieldValueMaps = new List<Map<String,Object>>();
        fieldValueMaps.add(nextQBRs);
        NextQBRDataFactory.getNextQBRs(fieldValueMaps,1);
        
        return [Select Id, Name, Actual__c,Area_of_Excellence__c, Forecast__c, Order__c, Target__c From Next_QBR__c];
    }
    
    static testMethod void testCloneRecord(){
        Customer_Satsfaction__c cus = getCustomerSat();
        List<Next_QBR__c> nextQBRs = getNextQBR();
        ApexPages.StandardController stcontroller = new ApexPages.StandardController(cus);
        CustomerSatisfactionCloneExtention csClone = new CustomerSatisfactionCloneExtention(stcontroller);
        
        csClone.customerSat.Score_Year__c = '2016';
        csClone.customerSat.Quarter_New__c = 'Q3';
        csClone.cloneRecord();
        List<Customer_Satsfaction__c> lstcustSat =[Select Id,Name,Merit_Index_for_customers__c,Quarter_New__c,Score_Year__c
                									From Customer_Satsfaction__c ];
        system.assert(!lstcustSat.isEmpty());
        system.assert(lstcustSat.size()==2);
    }
    static testMethod void testDuplicateCloneRecord(){
       CustomerSatisfaction__c cuSett = new CustomerSatisfaction__c(Name ='Customer_Satisfaction_Clone_Error', 
                                                                     Value__c ='An error occurred while cloning the Parent object. The selected Year and Quarter are existed');
        
		insert cuSett;
        Map<String,Object> cusSatMap = new Map<String,Object>();
        cusSatMap.put('New_Product_Color__c', 'GREEN');
        cusSatMap.put('New_Technology_Color__c', 'RED');
        List<Map<String,Object>> fieldValueMaps = new List<Map<String,Object>>();
        fieldValueMaps.add(cusSatMap);
        List<Customer_Satsfaction__c> satisfacs = new List<Customer_Satsfaction__c>();
        satisfacs = CustomerSatisfactionDataFactory.createCustomerSatisfactions(fieldValueMaps,1);
        
        List<Next_QBR__c> nextQBRs = getNextQBR();
        ApexPages.StandardController stcontroller = new ApexPages.StandardController(satisfacs[0]);
        CustomerSatisfactionCloneExtention csClone = new CustomerSatisfactionCloneExtention(stcontroller);
        
        csClone.customerSat.Score_Year__c = '2016';
        csClone.customerSat.Quarter_New__c = 'Q1';
        csClone.cloneRecord();
        List<Customer_Satsfaction__c> lstcustSat =[Select Id,Name,Merit_Index_for_customers__c,Quarter_New__c,Score_Year__c
                									From Customer_Satsfaction__c ];
        system.assert(!lstcustSat.isEmpty());
        system.assertEquals(2, lstcustSat.size());
        
    }
}