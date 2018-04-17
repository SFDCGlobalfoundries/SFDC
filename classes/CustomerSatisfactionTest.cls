/*
    ********************************************************************
    * @Author      : Mallika Seth
    * @Date        : 28/02/2017
    * @Description : This class contains unit tests for validating the Functionality of Customer Satisfaction
    ********************************************************************
*/
@isTest
private class CustomerSatisfactionTest{
   
    static testMethod void TestCSInsert(){
        Quarter__c Quarter = new Quarter__c();
        Quarter.Name = 'Q1';
        Insert Quarter;
        
        Merit__c merit = new Merit__c();
        merit.name = 'cirrus';
        merit.RED__c = 65;
        merit.GREEN__c = 75;
        Insert merit;
        
        Customer_Satsfaction__c CS = new Customer_Satsfaction__c();
        CS.Name = 'cirrus Q1';
        CS.Percentage__c = False;
        CS.Q1_Score__c = 70;
        CS.Quarter__c = Quarter.ID;
        CS.Merit_Index_for_customers__c = merit.ID;
        
        Insert CS;
        
    }
    static testMethod void TestCSInsert2(){
        Quarter__c Quarter = new Quarter__c();
        Quarter.Name = 'Q1';
        Insert Quarter;
        
        
        Merit__c merit = new Merit__c();
        merit.name = 'cirrus';
        merit.RED__c = 65;
        merit.GREEN__c = 75;
        Insert merit;
        
        Customer_Satsfaction__c CS = new Customer_Satsfaction__c();
        CS.Name = 'cirrus Q1';
        CS.Percentage__c = true;
        CS.Q1_Score__c = 70;
        CS.Quarter__c = Quarter.ID;
        CS.Merit_Index_for_customers__c = merit.ID;
        
        Insert CS;
        
    }
    static testMethod void TestCSUpdate(){
        Quarter__c Quarter = new Quarter__c();
        Quarter.Name = 'Q1';
        Insert Quarter;
        Quarter__c Quarter1 = new Quarter__c();
        Quarter1.Name = 'Q2';
        Insert Quarter1;
        Quarter__c Quarter2 = new Quarter__c();
        Quarter2.Name = 'Q3';
        Insert Quarter2;
        Quarter__c Quarter3 = new Quarter__c();
        Quarter3.Name = 'Q4';
        Insert Quarter3;
        
        Merit__c merit = new Merit__c();
        merit.name = 'cirrus';
        merit.RED__c = 65;
        merit.GREEN__c = 75;
        Insert merit;
        
        Customer_Satsfaction__c CS = new Customer_Satsfaction__c();
        CS.Name = 'cirrus Q1';
        CS.Percentage__c = False;
        CS.Q1_Score__c = 70;
        CS.Quarter__c = Quarter.ID;
        CS.Merit_Index_for_customers__c = merit.ID;
        CS.New_Technology__c = 60;
        CS.New_Product__c = 70;
        CS.Yield_Engineering__c = 50;
        CS.Quality__c = 50;
        CS.Capacity__c = 70;
        CS.Customer_Service__c = 40;
        
        Insert CS;
        Customer_Satsfaction__c CS1 = new Customer_Satsfaction__c();
        CS1.Name = 'cirrus Q2';
        CS1.Percentage__c = False;
        CS1.Q1_Score__c = 70;
        CS1.Quarter__c = Quarter1.ID;
        CS1.Merit_Index_for_customers__c = merit.ID;
        CS1.Score_Year__c ='2016';
        Insert CS1;
        Customer_Satsfaction__c CS2 = new Customer_Satsfaction__c();
        CS2.Name = 'cirrus Q3';
        CS2.Percentage__c = False;
        CS2.Q1_Score__c = 70;
        CS2.Quarter__c = Quarter2.ID;
        CS2.Merit_Index_for_customers__c = merit.ID;
        CS2.Score_Year__c ='2016';
        CS2.New_Technology__c = 60;
        CS2.New_Product__c = 70;
        CS2.Yield_Engineering__c = 50;
        CS2.Quality__c = 50;
        CS2.Capacity__c = 70;
        CS2.Customer_Service__c = 40;
        Insert CS2;
        
        Customer_Satsfaction__c CS3 = new Customer_Satsfaction__c();
        CS3.Name = 'cirrus Q4';
        CS3.Percentage__c = False;
        CS3.Q1_Score__c = 70;
        CS3.Quarter__c = Quarter3.ID;
        CS3.Merit_Index_for_customers__c = merit.ID;
        CS3.Score_Year__c ='2016';
        CS3.New_Technology__c = 60;
        CS3.New_Product__c = 70;
        CS3.Yield_Engineering__c = 50;
        CS3.Quality__c = 50;
        CS3.Capacity__c = 70;
        CS3.Customer_Service__c = 40;
        
        Insert CS3;
        
        CS.Q1_Score__c = 90;
        Update CS;
        CustomerSatisfactionBarChartExtention CSBCE=new CustomerSatisfactionBarChartExtention();
        CSBCE.CustomerName ='cirrus';
        CSBCE.getData();
        CustomerSatisfaction CSC = new CustomerSatisfaction();
        CSC.StartQuarter = 'Q1';
        CSC.EndQuarter = 'Q4';
        CSC.StartYear = '2016';
        CSC.EndYear = '2016';
        CSC.Go();
    }
     static testMethod void TestCSUpdateStartQ2(){
        Quarter__c Quarter = new Quarter__c();
        Quarter.Name = 'Q1';
        Insert Quarter;
        Quarter__c Quarter1 = new Quarter__c();
        Quarter1.Name = 'Q2';
        Insert Quarter1;
        Quarter__c Quarter2 = new Quarter__c();
        Quarter2.Name = 'Q3';
        Insert Quarter2;
        Quarter__c Quarter3 = new Quarter__c();
        Quarter3.Name = 'Q4';
        Insert Quarter3;
        
        Merit__c merit = new Merit__c();
        merit.name = 'cirrus';
        merit.RED__c = 65;
        merit.GREEN__c = 75;
        Insert merit;
        
        Customer_Satsfaction__c CS = new Customer_Satsfaction__c();
        CS.Name = 'cirrus Q1';
        CS.Percentage__c = False;
        CS.Q1_Score__c = 70;
        CS.Quarter__c = Quarter.ID;
        CS.Merit_Index_for_customers__c = merit.ID;
        CS.Score_Year__c ='2017';
        Insert CS;
        Customer_Satsfaction__c CS1 = new Customer_Satsfaction__c();
        CS1.Name = 'cirrus Q2';
        CS1.Percentage__c = False;
        CS1.Q1_Score__c = 70;
        CS1.Quarter__c = Quarter1.ID;
        CS1.Merit_Index_for_customers__c = merit.ID;
        CS1.Score_Year__c ='2016';
        Insert CS1;
        Customer_Satsfaction__c CS2 = new Customer_Satsfaction__c();
        CS2.Name = 'cirrus Q3';
        CS2.Percentage__c = False;
        CS2.Q1_Score__c = 70;
        CS2.Quarter__c = Quarter2.ID;
        CS2.Merit_Index_for_customers__c = merit.ID;
        CS2.Score_Year__c ='2016';
        Insert CS2;
        
        Customer_Satsfaction__c CS3 = new Customer_Satsfaction__c();
        CS3.Name = 'cirrus Q4';
        CS3.Percentage__c = False;
        CS3.Q1_Score__c = 70;
        CS3.Quarter__c = Quarter3.ID;
        CS3.Merit_Index_for_customers__c = merit.ID;
        CS3.Score_Year__c ='2016';
        
        Insert CS3;
        
        CS.Q1_Score__c = 90;
        Update CS;
        
        CustomerSatisfaction CSC = new CustomerSatisfaction();
        CSC.StartQuarter = 'Q2';
        CSC.EndQuarter = 'Q1';
        CSC.StartYear = '2016';
        CSC.EndYear = '2017';
        CSC.Go();
    }
    static testMethod void TestCSUpdateStartQ3(){
        Quarter__c Quarter = new Quarter__c();
        Quarter.Name = 'Q1';
        Insert Quarter;
        Quarter__c Quarter1 = new Quarter__c();
        Quarter1.Name = 'Q2';
        Insert Quarter1;
        Quarter__c Quarter2 = new Quarter__c();
        Quarter2.Name = 'Q3';
        Insert Quarter2;
        Quarter__c Quarter3 = new Quarter__c();
        Quarter3.Name = 'Q4';
        Insert Quarter3;
        
        Merit__c merit = new Merit__c();
        merit.name = 'cirrus';
        merit.RED__c = 65;
        merit.GREEN__c = 75;
        Insert merit;
        
        Customer_Satsfaction__c CS = new Customer_Satsfaction__c();
        CS.Name = 'cirrus Q1';
        CS.Percentage__c = False;
        CS.Q1_Score__c = 70;
        CS.Quarter__c = Quarter.ID;
        CS.Merit_Index_for_customers__c = merit.ID;
        CS.Score_Year__c ='2017';
        Insert CS;
        Customer_Satsfaction__c CS1 = new Customer_Satsfaction__c();
        CS1.Name = 'cirrus Q2';
        CS1.Percentage__c = False;
        CS1.Q1_Score__c = 70;
        CS1.Quarter__c = Quarter1.ID;
        CS1.Merit_Index_for_customers__c = merit.ID;
        CS1.Score_Year__c ='2017';
        Insert CS1;
        Customer_Satsfaction__c CS2 = new Customer_Satsfaction__c();
        CS2.Name = 'cirrus Q3';
        CS2.Percentage__c = False;
        CS2.Q1_Score__c = 70;
        CS2.Quarter__c = Quarter2.ID;
        CS2.Merit_Index_for_customers__c = merit.ID;
        CS2.Score_Year__c ='2016';
        Insert CS2;
        
        Customer_Satsfaction__c CS3 = new Customer_Satsfaction__c();
        CS3.Name = 'cirrus Q4';
        CS3.Percentage__c = False;
        CS3.Q1_Score__c = 70;
        CS3.Quarter__c = Quarter3.ID;
        CS3.Merit_Index_for_customers__c = merit.ID;
        CS3.Score_Year__c ='2016';
        
        Insert CS3;
        
        CS.Q1_Score__c = 90;
        Update CS;
       
        CustomerSatisfaction CSC = new CustomerSatisfaction();
        CSC.StartQuarter = 'Q3';
        CSC.EndQuarter = 'Q2';
        CSC.StartYear = '2016';
        CSC.EndYear = '2017';
        CSC.Go();
    }
    
       static testMethod void TestCSUpdateStartQ4(){
        Quarter__c Quarter = new Quarter__c();
        Quarter.Name = 'Q1';
        Insert Quarter;
        Quarter__c Quarter1 = new Quarter__c();
        Quarter1.Name = 'Q2';
        Insert Quarter1;
        Quarter__c Quarter2 = new Quarter__c();
        Quarter2.Name = 'Q3';
        Insert Quarter2;
        Quarter__c Quarter3 = new Quarter__c();
        Quarter3.Name = 'Q4';
        Insert Quarter3;
        
        Merit__c merit = new Merit__c();
        merit.name = 'cirrus';
        merit.RED__c = 65;
        merit.GREEN__c = 75;
        Insert merit;
        list<Customer_Satsfaction__c> ListCS = new list<Customer_Satsfaction__c>();
        Customer_Satsfaction__c CS = new Customer_Satsfaction__c();
        CS.Name = 'cirrus Q1';
        CS.Percentage__c = False;
        CS.Q1_Score__c = 70;
        CS.Quarter__c = Quarter.ID;
        CS.Merit_Index_for_customers__c = merit.ID;
        CS.Score_Year__c ='2017';
        ListCS.add(CS);
        Customer_Satsfaction__c CS1 = new Customer_Satsfaction__c();
        CS1.Name = 'cirrus Q2';
        CS1.Percentage__c = False;
        CS1.Q1_Score__c = 70;
        CS1.Quarter__c = Quarter1.ID;
        CS1.Merit_Index_for_customers__c = merit.ID;
        CS1.Score_Year__c ='2017';
        ListCS.add(CS1);
        Customer_Satsfaction__c CS2 = new Customer_Satsfaction__c();
        CS2.Name = 'cirrus Q3';
        CS2.Percentage__c = False;
        CS2.Q1_Score__c = 70;
        CS2.Quarter__c = Quarter2.ID;
        CS2.Merit_Index_for_customers__c = merit.ID;
        CS2.Score_Year__c ='2017';
        ListCS.add(CS2);
        
        Customer_Satsfaction__c CS3 = new Customer_Satsfaction__c();
        CS3.Name = 'cirrus Q4';
        CS3.Percentage__c = False;
        CS3.Q1_Score__c = 70;
        CS3.Quarter__c = Quarter3.ID;
        CS3.Merit_Index_for_customers__c = merit.ID;
        CS3.Score_Year__c ='2016';
        
        ListCS.add(CS3);
        //CST.sCustomerSatisfaction = ListCS;
        Insert ListCS;
        CS.Q1_Score__c = 90;
        Update CS;
       
        CustomerSatisfaction CSC = new CustomerSatisfaction();
        CSC.StartQuarter = 'Q4';
        CSC.EndQuarter = 'Q1';
        CSC.StartYear = '2016';
        CSC.EndYear = '2017';
        CSC.Go();
    }
     public static testMethod void testSoslFixedResults() {
      Quarter__c Quarter = new Quarter__c();
        Quarter.Name = 'Q1';
        Insert Quarter;
        Quarter__c Quarter1 = new Quarter__c();
        Quarter1.Name = 'Q2';
        Insert Quarter1;
        Quarter__c Quarter2 = new Quarter__c();
        Quarter2.Name = 'Q3';
        Insert Quarter2;
        Quarter__c Quarter3 = new Quarter__c();
        Quarter3.Name = 'Q4';
        Insert Quarter3;
        
        Merit__c merit = new Merit__c();
        merit.name = 'cirrus';
        merit.RED__c = 65;
        merit.GREEN__c = 75;
        Insert merit;
        list<Customer_Satsfaction__c> ListCS = new list<Customer_Satsfaction__c>();
        Customer_Satsfaction__c CS = new Customer_Satsfaction__c();
        CS.Name = 'cirrus Q1';
        CS.Percentage__c = False;
        CS.Q1_Score__c = 70;
        CS.Quarter__c = Quarter.ID;
        CS.Merit_Index_for_customers__c = merit.ID;
        CS.Score_Year__c ='2017';
        ListCS.add(CS);
        Customer_Satsfaction__c CS1 = new Customer_Satsfaction__c();
        CS1.Name = 'cirrus Q2';
        CS1.Percentage__c = False;
        CS1.Q1_Score__c = 70;
        CS1.Quarter__c = Quarter1.ID;
        CS1.Merit_Index_for_customers__c = merit.ID;
        CS1.Score_Year__c ='2017';
        ListCS.add(CS1);
        Customer_Satsfaction__c CS2 = new Customer_Satsfaction__c();
        CS2.Name = 'cirrus Q3';
        CS2.Percentage__c = False;
        CS2.Q1_Score__c = 70;
        CS2.Quarter__c = Quarter2.ID;
        CS2.Merit_Index_for_customers__c = merit.ID;
        CS2.Score_Year__c ='2017';
       // ListCS.add(CS2);
        Insert CS2;
        Customer_Satsfaction__c CS3 = new Customer_Satsfaction__c();
        CS3.Name = 'cirrus';
        CS3.Percentage__c = False;
        CS3.Q1_Score__c = 70;
        CS3.Quarter__c = Quarter3.ID;
        CS3.Merit_Index_for_customers__c = merit.ID;
        CS3.Score_Year__c ='2016'; 
        
        
       Id [] fixedSearchResults = new Id[]{CS2.Id};
       fixedSearchResults[0] = CS2.Id;
       Test.setFixedSearchResults(fixedSearchResults);
       CustomerSatisfaction_TriggerHandler CST = new CustomerSatisfaction_TriggerHandler();
       test.startTest();
       CST.Names.add('cirrus');
       Insert CS3;
       test.stopTest();
     
    }
}