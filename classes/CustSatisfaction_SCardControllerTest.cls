/** Author : Ravikiran Nadella 

*  Created Date : 26/10/2017
*  Description : test class for Custom controller class CustSatisfaction_SCardController 
**/

@isTest(SeeAllData=false)
private class CustSatisfaction_SCardControllerTest{
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        CustomerSatisfaction__c cuSett = new CustomerSatisfaction__c(Name ='Title',  Value__c ='ScoreCard');
        insert cuSett;
        CustomerSatisfaction__c cuSett1 = new CustomerSatisfaction__c(Name ='Displayed Years',  Value__c ='2010,2015');
        insert cuSett1;
        
    }
    
    private static Customer_Satsfaction__c getCustomerSat(String CustomerSatName){
        Map<String,Object> cusSatMap = new Map<String,Object>();
        Customer_Satsfaction__c cs = new Customer_Satsfaction__c();
        cusSatMap.put('New_Technology__c', 10);
        cusSatMap.put('New_Product__c', 12);
        cusSatMap.put('New_Technology__c', 10);
        CustomerSatisfactionDataFactory.createCustomerSatisfaction(new Map<String,Customer_Satsfaction__c>());
        
        return [Select Id,Name,Merit_Index_for_customers__c,Quarter_New__c,Score_Year__c
                From Customer_Satsfaction__c limit 1];
    }
    
    static testMethod void  testLoadData(){
        List<Map<String,Object>> fieldValueMaps = new List<Map<String,Object>>();
       
        Map<String,Object> cusSatMap = new Map<String,Object>();
        cusSatMap.put('New_Product__c', 12);
        cusSatMap.put('New_Technology__c', 10);
        fieldValueMaps.add(cusSatMap);
        
        Map<String,Object> cusSatMap1 = new Map<String,Object>();
        cusSatMap1.put('Quarter_New__c','Q4');
        cusSatMap1.put('Score_Year__c', '2015');
        fieldValueMaps.add(cusSatMap1);
        
        Map<String,Object> cusSatMap2 = new Map<String,Object>();
        cusSatMap2.put('Quarter_New__c', 'Q3');
        cusSatMap2.put('Score_Year__c','2015');
        fieldValueMaps.add(cusSatMap2);
        
        Map<String,Object> cusSatMap3 = new Map<String,Object>();
        cusSatMap3.put('Quarter_New__c', 'Q2');
        cusSatMap3.put('Score_Year__c','2015');
        fieldValueMaps.add(cusSatMap3);
        
        Map<String,Object> cusSatMap4 = new Map<String,Object>();
        cusSatMap4.put('Quarter_New__c', 'Q1');
        cusSatMap4.put('Score_Year__c','2015');
        fieldValueMaps.add(cusSatMap4);
        
        List<Customer_Satsfaction__c> satisfacs = new List<Customer_Satsfaction__c>();
        satisfacs = CustomerSatisfactionDataFactory.createCustomerSatisfactions(fieldValueMaps,5);
        
        Merit__c mrt = new Merit__c (id=satisfacs[0].Merit_Index_for_customers__c);
        mrt.GREEN__c=90;
        mrt.RED__c=80;
        update mrt;
        
        satisfacs[0].Q1_Score__c=85;
        satisfacs[0].Q1__c=85;
        satisfacs[0].Q1_Rank__c='2 out of 5';
        
        satisfacs[1].Q1_Score__c=20;
        satisfacs[1].Quarter_New__c='Q4';
        satisfacs[1].Score_Year__c='2015';
        
        satisfacs[2].Q1__c=60;
        satisfacs[2].Quarter_New__c='Q3';
        satisfacs[2].Score_Year__c='2015';
        
        satisfacs[3].Q1_Rank__c='3 out of 5';
        satisfacs[3].Quarter_New__c='Q2';
        satisfacs[3].Score_Year__c='2015';
        
        satisfacs[4].Q1_Score__c=85;
        satisfacs[4].Quarter_New__c='Q1';
        satisfacs[4].Score_Year__c='2015';
        
        update satisfacs;
        
        // Put Id into the current page Parameters
        PageReference myVfPage = Page.CustSatisfaction_SCardN;
        Test.setCurrentPage(myVfPage);
        ApexPages.currentPage().getParameters().put('year','2016');
        ApexPages.currentPage().getParameters().put('quater','3');
        
        CustSatisfaction_SCardController csController = new CustSatisfaction_SCardController();
        csController.getyrs();
        csController.getQtrs();
        csController.getData();
        
        //validate page parameter
        system.assertEquals('ScoreCard', csController.Title);
        system.assertEquals('2016', csController.year);
        
        
    }    
    
    static testMethod void  testLoadData1(){
        List<Map<String,Object>> fieldValueMaps = new List<Map<String,Object>>();
       
        Map<String,Object> cusSatMap = new Map<String,Object>();
        cusSatMap.put('New_Product__c', 12);
        cusSatMap.put('New_Technology__c', 10);
        fieldValueMaps.add(cusSatMap);
        
        Map<String,Object> cusSatMap1 = new Map<String,Object>();
        cusSatMap1.put('Quarter_New__c','Q4');
        cusSatMap1.put('Score_Year__c', '2015');
        fieldValueMaps.add(cusSatMap1);
        
        Map<String,Object> cusSatMap2 = new Map<String,Object>();
        cusSatMap2.put('Quarter_New__c', 'Q3');
        cusSatMap2.put('Score_Year__c','2015');
        fieldValueMaps.add(cusSatMap2);
        
        Map<String,Object> cusSatMap3 = new Map<String,Object>();
        cusSatMap3.put('Quarter_New__c', 'Q2');
        cusSatMap3.put('Score_Year__c','2015');
        fieldValueMaps.add(cusSatMap3);
        
        Map<String,Object> cusSatMap4 = new Map<String,Object>();
        cusSatMap4.put('Quarter_New__c', 'Q1');
        cusSatMap4.put('Score_Year__c','2015');
        fieldValueMaps.add(cusSatMap4);
        
        List<Customer_Satsfaction__c> satisfacs = new List<Customer_Satsfaction__c>();
        satisfacs = CustomerSatisfactionDataFactory.createCustomerSatisfactions(fieldValueMaps,5);
        
        Merit__c mrt = new Merit__c (id=satisfacs[0].Merit_Index_for_customers__c);
        mrt.GREEN__c=90;
        mrt.RED__c=80;
        update mrt;
        
        satisfacs[0].Q1_Score__c=85;
        satisfacs[0].Q1__c=85;
        satisfacs[0].Q1_Rank__c='2 out of 5';
        
        satisfacs[1].Q1_Score__c=20;
        satisfacs[1].Quarter_New__c='Q4';
        satisfacs[1].Score_Year__c='2015';
        
        satisfacs[2].Q1__c=60;
        satisfacs[2].Quarter_New__c='Q3';
        satisfacs[2].Score_Year__c='2015';
        
        satisfacs[3].Q1_Rank__c='3 out of 5';
        satisfacs[3].Quarter_New__c='Q2';
        satisfacs[3].Score_Year__c='2015';
        
        satisfacs[4].Q1_Score__c=85;
        satisfacs[4].Quarter_New__c='Q1';
        satisfacs[4].Score_Year__c='2015';
        
        update satisfacs;
        
        // Put Id into the current page Parameters
        PageReference myVfPage = Page.CustSatisfaction_SCardN;
        Test.setCurrentPage(myVfPage);
        ApexPages.currentPage().getParameters().put('sfdc.tabName','00112121212');
        CustSatisfaction_SCardController csController = new CustSatisfaction_SCardController();
        csController.getyrs();
        csController.getQtrs();
        csController.getData();
        csController.getCsites();
        
        //validate page parameter
        system.assertEquals('ScoreCard', csController.Title);
        system.assertEquals(string.valueOf(system.today().year()), csController.year);
        
        
    }
    
}