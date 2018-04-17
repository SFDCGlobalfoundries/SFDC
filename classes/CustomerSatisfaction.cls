/*
    Author: 
    Description: This is the class to fetch records and display in table format. 
    History:
        Mset     05042017    -  Created Class. 
*/
public class CustomerSatisfaction{

    Public List<Customer_Satsfaction__c> lstCustomerSatsfaction;
    Public Map<String,List<Customer_Satsfaction__c>> mapCustomerSatsfaction{get;set;}
    Public String PrevCustomerName;
    Public Set<String> CustomerNames{get;set;}
    Public Set<String> Customer{get;set;}
    Public String StartQuarter{get;set;}
    Public String EndQuarter{get;set;}
    Public String EndYear{get;set;}
    Public String StartYear{get;set;}
    Public set<String> setYear;
    Public list<String> setYearQuarter{get;set;}
    Public CustomerSatisfaction(){
       
        CustomerNames = new Set<String>();
        Customer = new Set<String>();
        setYear = new set<String>();
        setYearQuarter = new list<String>();
        setYearQuarter.add('Q1');
        setYearQuarter.add('Q2');
        setYearQuarter.add('Q3');
        setYearQuarter.add('Q4');
        mapCustomerSatsfaction = new Map<String,List<Customer_Satsfaction__c>>();
        
    }
    Public void Go(){
      mapCustomerSatsfaction = new Map<String,List<Customer_Satsfaction__c>>();  
        setYear.add(StartYear);
        setYear.add(EndYear);
        setYearQuarter.clear();
        For(integer i=1;i<=4;i++){
             if(StartQuarter == 'Q1'){
                setYearQuarter.add(StartYear+'Q'+i);
             }
             if(StartQuarter == 'Q2'){
                 if(i<4){
                    setYearQuarter.add(StartYear+'Q'+(i+1));
                 }   
                 if(i==4){
                      setYearQuarter.add(EndYear+EndQuarter); 
                 }
             }
             if(StartQuarter == 'Q3'){
              if(i<3){
                setYearQuarter.add(StartYear+'Q'+(i+2));
              }  
                if(i>=3){
                  setYearQuarter.add(EndYear+'Q'+(i-1)); 
                  setYearQuarter.add(EndYear + EndQuarter); 
                }
             }
             if(StartQuarter == 'Q4'){
                setYearQuarter.add(StartYear+StartQuarter);  
                setYearQuarter.add(EndYear+'Q'+(i-1));  
             }
        
        }
       
        datatable();
       
    }
    public void datatable() {
        for(Customer_Satsfaction__c CS :[SELECT Id,Q1_Score__c,Q1__c,X4Q_trend__c,Merit_Index_for_customers__r.RED__c,YearQuarter__c,Merit_Index_for_customers__r.GREEN__c,MeritIndex__c,Percentage__c,Score_Year__c,Quarter__r.Name,Merit_Index_for_customers__r.name,name FROM Customer_Satsfaction__c where YearQuarter__c IN:setYearQuarter order by Merit_Index_for_customers__r.SG_Approved_Operation_Plan_M__c Desc,name Asc] ){

            if(CS.Merit_Index_for_customers__r.name != PrevCustomerName || PrevCustomerName==Null){
               lstCustomerSatsfaction = new List<Customer_Satsfaction__c>();                
               PrevCustomerName = Null;
            }

            if(CS.Merit_Index_for_customers__r.name == PrevCustomerName || PrevCustomerName==Null){
                lstCustomerSatsfaction.add(CS);
            
            if(CS.Merit_Index_for_customers__r.name != Null && lstCustomerSatsfaction.size()==4){
                mapCustomerSatsfaction.put(CS.Merit_Index_for_customers__r.name,lstCustomerSatsfaction);
               
            }
            }
           
            PrevCustomerName = CS.Merit_Index_for_customers__r.name;
        }
         CustomerNames= mapCustomerSatsfaction.keySet();
    }
   


}