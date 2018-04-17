/*  Author: Vijay Vemuru
    Description: This serves as the test class for the class DealGrading_UpdateDGOnOPP
    DealGrading_testRecordCreation_Utility -  is the utility class where Account and Opportunity are already created.
    History: 06222016    - Code creation.
*/
@isTest
public class DealGrading_Only1DGPerOPPTest{

@testSetup static void testdata(){
        DataUtilTest.loadEnvironmentVariables();
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();       
        fieldValueMap.put('Stage__c', 'Unqualified');
        fieldValueMap.put('Short_Name__c', 'test725');
        fieldValueMap.put('Site_Department__c', 'cts.com');
        fieldValueMap.put('Account_Type__c', 'Customer');
        fieldValueMap.put('Organization_Unit__c', 'sg;us');
        fieldValueMap.put('Copy_Address__c', true);
        fieldValueMap.put('Corporate_Address_1__c', 'test');
        fieldValueMap.put('Corporate_City__c', 'sg');
        fieldValueMap.put('Corporate_Country__c', 'sg');        
        fieldValueMap.put('Financial_Territory__c', 'Singapore');
        fieldValueMap.put('Region__c', 'EMEA');
        fieldValueMap.put('Sub_Type__c', 'Direct');
        fieldValueMap.put('Transaction_Type__c', 'Transactional');
        fieldValueMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_RESELLER'));
        fieldValueMap.put('Account_Profile__c', 'Fabless - Emerging');
        fieldValueMap.put('Corporate_Postal_Zip_Code__c', '560003');
        fieldValueMap.put('Fab_9_10__c', 'No');
                
        AccountDataFactory.createAccount(fieldValueMap);
        Opportunity opp= DealGrading_Only1DGPerOPPTest.createOpp();
        }
        
//Creating Opportunity
public static Opportunity createOpp(){
       
       Account testAcct=[SELECT id from Account LIMIT 1];
       
       Opportunity testOppty = new Opportunity();
        testOppty.Name = 'Test Opportunity 1';
        testOppty.AccountId = testAcct.Id;
        
        testOppty.StageName = '1. Discovery';
        testOppty.CloseDate = Date.Today().addDays(10);
        testOppty.Target_Process_Node__c = '14XM';
        testOppty.Market_Segment__c = 'Mobility';
        testOppty.Process_Platform__c = 'GF Baseline';
        testOppty.Fab_Split__c = 100;
        testOppty.Fab_Assignment_1__c = 'FAB 3';
        testOppty.Process_Geometry__c = '0.028UM';
        testOppty.Process_Family__c = 'Generic / Nominal';
        testOppty.Years_of_Production__c = 1;
       
        Insert testOppty;
        return testOppty;

                    }

public static testmethod void TestUpdateOnOPP(){
        Opportunity opp=[Select Id, Name from Opportunity where Name = 'Test Opportunity 1'];
        system.AssertEquals('Test Opportunity 1', opp.Name);
        
        Deal_Grading__c testdg=new Deal_Grading__c();
        
            testdg.Opportunity1__c          =   opp.Id;
            testdg.Start_time__c            =   DateTime.parse('5/24/2016 12:08 AM');
            testdg.Meeting_Link__c          =   'https://plus.google.com/hangouts/_/globalfoundries.com/diw-standup-sc?authuser=0&hceid=a2lhbmNoaW5nLm5nQGdsb2JhbGZvdW5kcmllcy5jb20.pukq71hmpchn1l46pacdh4fcno';
            //testdg.Result__c                =   'Decision Pending'; 
            testdg.Deal_Grading_Status__c   =   'Draft';
           Test.startTest();
            insert testdg;
           
           Deal_Grading__c testdg1=new Deal_Grading__c();
        
            testdg1.Opportunity1__c         =   opp.Id;
            testdg1.Start_time__c           =   DateTime.parse('5/24/2016 12:08 AM');
            testdg1.Meeting_Link__c         =   'https://plus.google.com/hangouts/_/globalfoundries.com/diw-standup-sc?authuser=0&hceid=a2lhbmNoaW5nLm5nQGdsb2JhbGZvdW5kcmllcy5jb20.pukq71hmpchn1l46pacdh4fcno';
            //testdg1.Result__c               =   'Decision Pending'; 
            testdg1.Deal_Grading_Status__c  =   'Draft';
            
            try{
            
                insert testdg1;
            } catch(Exception excp) {}
           
              testdg.Deal_Grading_Status__c='Pending Resubmission' ;
             update testdg;
                   
             Test.StopTest();
   }

}