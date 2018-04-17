/*
    Author: Sandesh Singh
    Description: This is the test class for CustomerSatisfactionCloneExtention class 
    History:
        Sandesh 24/10/2017    - code creation.
*/
@isTest(SeeAllData=false)
private class CustomerSatisfactionBarChartTest{
    
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
    }
    
    private static Customer_Satsfaction__c getCustomerSat(String CustomerSatName){
        Map<String,Object> cusSatMap = new Map<String,Object>();
        Customer_Satsfaction__c cs = new Customer_Satsfaction__c();
        cusSatMap.put('New_Technology_Color__c', 'YELLOW');
        cusSatMap.put('New_Product_Color__c', 'RED');
        cusSatMap.put('New_Technology_Color__c', 'GREEN');
        CustomerSatisfactionDataFactory.createCustomerSatisfaction(new Map<String,Customer_Satsfaction__c>());
        
        return [Select Id,Name,Merit_Index_for_customers__c,Quarter_New__c,Score_Year__c
                From Customer_Satsfaction__c
                Where Name =:CustomerSatName];
    }

    static testMethod void testLoadData(){
        
        Map<String,Object> cusSatMap = new Map<String,Object>();
        cusSatMap.put('New_Product_Color__c', 'RED');
        cusSatMap.put('New_Technology_Color__c', 'GREEN');
        List<Map<String,Object>> fieldValueMaps = new List<Map<String,Object>>();
        fieldValueMaps.add(cusSatMap);
        List<Customer_Satsfaction__c> satisfacs = new List<Customer_Satsfaction__c>();
        satisfacs = CustomerSatisfactionDataFactory.createCustomerSatisfactions(fieldValueMaps,1);
        
        // Setup test data
        // This code runs as the system user
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standarduser85630@testorg.com');
        insert u;
        
        Map<String,Object> postQBR = new Map<String,Object>();
        postQBR.put('Assginee__c', u.id);
        postQBR.put('Category__c', 'Planning');    
        List<Map<String,Object>> fieldValueMaps1 = new List<Map<String,Object>>();
        fieldValueMaps1.add(postQBR);
        List<Post_QBR_Action_Plan__c> lstPostQBR = new List<Post_QBR_Action_Plan__c>();
        lstPostQBR = PostQBRDataFactory.getPostQBRs(fieldValueMaps1,1);
        
        ApexPages.StandardController stcontroller = new ApexPages.StandardController(satisfacs[0]);
        CustomerSatisfactionBarChartExtention csController = new CustomerSatisfactionBarChartExtention(stcontroller);
        //csController.ScoreYear ='2016';
        
        PageReference myVfPage = Page.CustomerSatisfactionBarChart;
		Test.setCurrentPage(myVfPage);
        // Put Id into the current page Parameters
        ApexPages.currentPage().getParameters().put('CustomerName','TestMerit');
        ApexPages.currentPage().getParameters().put('ScoreYear','2016');
        ApexPages.currentPage().getParameters().put('Quarter','Q1');
        
        //Customer_Satsfaction__c cus = getCustomerSat('Fudan Q1 2016');
        csController.getData();
        //to get fielter data
        csController.getChartFilter();
        //to get postQBR records
        List<Post_QBR_Action_Plan__c> postQBRS = csController.getPostQBR();
        
		//validate page parameter
		system.assertEquals('Q1', csController.quarter);
        system.assertEquals('2016', csController.ScoreYear);
        system.assertEquals('TestMerit', csController.customerName);
        system.assert(!postQBRS.isEmpty());
        
    }    
}