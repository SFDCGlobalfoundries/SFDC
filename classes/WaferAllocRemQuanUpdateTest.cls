/*
    Author: Abhita Bansal
    Created Date: 12/09/2014 
    Description: Test class for WaferAllocRemQuanUpdate 
*/
@isTest(SeeAllData = true)
public class WaferAllocRemQuanUpdateTest {
  
     static testMethod void myFormCreationMethod() {
          
         Wafer_Allocation__c wafer = new Wafer_Allocation__c();
         wafer.Fab__c = 'FAB 5';
         wafer.Year__c = '2014';
         wafer.Month__c = 'Jan';
         wafer.Wafer_Quantity_Allocated__c = 100;
         wafer.Remaining_Quantity__c = 80;
         insert wafer;
         
         wafer.Wafer_Quantity_Allocated__c = 110;
         update wafer;
     }
}