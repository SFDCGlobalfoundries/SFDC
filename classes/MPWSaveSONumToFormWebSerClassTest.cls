/*
    Author: Abhita Bansal
    Created Date: 24/08/2015 
    Description: Test class for MPWSaveSONumberToFormWebServiceClass
*/
@isTest
public class MPWSaveSONumToFormWebSerClassTest {

    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
    }
    
    private static MPW_Train_Maintenance__c utilDataTMMethod() {
        
        MPW_Train_Maintenance__c mpwTrain = new MPW_Train_Maintenance__c();
        mpwTrain.Active__c = true;
        mpwTrain.Publish__c = true;
        mpwTrain.Train_Type__c = 'GlobalShuttle';
        mpwTrain.Geometry__c = '28nm';
        mpwTrain.Train_Number__c = 'MPW03312';
        mpwTrain.Reservation_Close_Date__c = System.today();
        mpwTrain.Projected_1st_Batch_Bare_Die_Ship_Start__c = System.today()+10;
        mpwTrain.Projected_1st_Batch_Bare_Die_Ship_End__c = System.today()+10;
        mpwTrain.Lot_Start_Date__c = System.today() +10;
        mpwTrain.Tapeout_Date_Customer__c = System.today() + 6;
        mpwTrain.Fab__c = 'Fab1';
        mpwTrain.Status__c = '28LPSe, 28LPS, 28LPS-RF';
        insert mpwTrain;
        
        return mpwTrain;
    }
    
    public static testMethod void myWebServiceClassMethod() {
      
      List<MPWSaveSONumberToFormWebServiceClass.SalesOrder> actList = new List<MPWSaveSONumberToFormWebServiceClass.SalesOrder>();
      MPW_Train_Maintenance__c mpwTrain = utilDataTMMethod();
      
      MPW_Reservation__c mpwReservation1 = new MPW_Reservation__c();        
      mpwReservation1.MPW_Train_Name__c = mpwTrain.Id;
      mpwReservation1.Name = '2015-03-05600';
      mpwReservation1.Form_Status__c = 'Draft';
      mpwReservation1.Category__c = 'FAB';
      mpwReservation1.Usage__c = 'Required';
      mpwReservation1.Prime_Die_Name__c = 'TestComapre1';
      mpwReservation1.sales_order__c = '2189023901';
      insert mpwReservation1;
      
      MPWSaveSONumberToFormWebServiceClass.SalesOrder act = new MPWSaveSONumberToFormWebServiceClass.SalesOrder();
      act.MPWNo = '2015-03-05600';
      act.SONumber = '2189023901';
      actList.add(act);
      MPWSaveSONumberToFormWebServiceClass.saveSONumber(actList);
    }
    
    public static testMethod void myWebServiceClassMethod1() {
      
      List<MPWSaveSONumberToFormWebServiceClass.SalesOrder> actList = new List<MPWSaveSONumberToFormWebServiceClass.SalesOrder>();
      MPW_Train_Maintenance__c mpwTrain = utilDataTMMethod();
      
      MPW_Reservation__c mpwReservation1 = new MPW_Reservation__c();        
      mpwReservation1.MPW_Train_Name__c = mpwTrain.Id;
      mpwReservation1.Name = '2015-03-05601';
      mpwReservation1.Form_Status__c = 'Draft';
      mpwReservation1.Category__c = 'FAB';
      mpwReservation1.Usage__c = 'Required';
      mpwReservation1.Prime_Die_Name__c = 'TestComapre1';
      mpwReservation1.sales_order__c = '2189023901';
      insert mpwReservation1;
      
      MPWSaveSONumberToFormWebServiceClass.SalesOrder act = new MPWSaveSONumberToFormWebServiceClass.SalesOrder();
      act.MPWNo = '2015-03-05600';
      act.SONumber = '2189023901';
      actList.add(act);
      MPWSaveSONumberToFormWebServiceClass.saveSONumber(actList);
    }
}