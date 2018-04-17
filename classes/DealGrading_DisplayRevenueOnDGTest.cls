/*  Author: Vijay Vemuru
    Description: This serves as the test class for the class DealGrading_DisplayRevenueOnDG where the Revenue is displayed from Quarterly Revenue of Opportunity
    DealGrading_DisplayRevenueOnDGTest -  is the test class for DealGradingDisplayRevenueonDG Class. That class is the controller for Deal Grading Populate VF Page
    History: 
                06222016    - Code creation.
*/
@isTest
private class DealGrading_DisplayRevenueOnDGTest {

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
        fieldValueMap.put('Financial_Territory__c', 'Greater China');
        fieldValueMap.put('Region__c', 'APJ');
        fieldValueMap.put('Sub_Type__c', 'Direct');
        fieldValueMap.put('Transaction_Type__c', 'Transactional');
        fieldValueMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_RESELLER'));
        fieldValueMap.put('Account_Profile__c', 'Fabless - Emerging');
        fieldValueMap.put('Corporate_Postal_Zip_Code__c', '700007');
        fieldValueMap.put('Fab_9_10__c', 'No');
                
        AccountDataFactory.createAccount(fieldValueMap);
        Test.startTest();
        Opportunity newopp=DealGrading_CreateSnapShotTest.createOpp();
        Test.stopTest();
        }
        
//Creating Opportunity
public static Opportunity createOpp(){
       
       Account testAcct=[SELECT id from Account LIMIT 1];
       
       Opportunity testOppty = new Opportunity();
        testOppty.Name       = 'Test Opportunity 1';
        testOppty.AccountId  = testAcct.Id;
        
        testOppty.StageName              = '5. Commitment';
        testOppty.CloseDate              = Date.Today().addDays(10);
        testOppty.Target_Process_Node__c = '14XM';
        testOppty.Market_Segment__c      = 'Mobility';
        testOppty.Process_Platform__c    = 'GF Baseline';
        testOppty.Fab_Split__c           = 100;
        testOppty.Fab_Assignment_1__c    = 'FAB 5';
        testOppty.Process_Geometry__c    = '0.65UM';
        testOppty.Process_Family__c      = 'Generic / Nominal';
        testOppty.Years_of_Production__c = 1;
       
        Insert testOppty;       
        return testOppty;

    }
    
    public static testmethod void displayrevenueTest() {
          Opportunity newopp=[Select Id, Name from Opportunity where Name = 'Test Opportunity 1'];
          List<Quarterly_Revenue_Object__c> qrevList = new list<Quarterly_Revenue_Object__c>();
          
         //Creating a new DG record and assigning the newoppid
         
         Quarterly_Revenue_Object__c   qrev =  new Quarterly_Revenue_Object__c();
            qrev.Fiscal_Quarter__c  = '2011-Q1';
            qrev.NRE__c         =   10000;
            qrev.ASP__c         =   10000;
            qrev.Volume__c      =   10000;
            qrev.date__c        =   system.today();
            qrev.Opportunity__c =   newopp.id;
        qrevList.add(qrev);
        
        Quarterly_Revenue_Object__c   qrev11 =  new Quarterly_Revenue_Object__c();
            qrev11.Fiscal_Quarter__c  = '2011-Q2';
            qrev11.NRE__c         =   10000;
            qrev11.ASP__c         =   10000;
            qrev11.Volume__c      =   10000;
            qrev11.date__c        =   system.today();
            qrev11.Opportunity__c =   newopp.id;
        qrevList.add(qrev11);
              
        Quarterly_Revenue_Object__c   qrev1 =  new Quarterly_Revenue_Object__c();
            qrev1.Fiscal_Quarter__c         = '2012-2013';
            qrev1.date__c                   =   system.today();
            qrev1.NRE__c                    =   10000;
            qrev1.ASP__c                    =   10000;
            qrev1.Volume__c                 =   10000;
            qrev1.Opportunity__c            =   newopp.id;
        qrevList.add(qrev1);
             
        Quarterly_Revenue_Object__c   qrev2 =  new Quarterly_Revenue_Object__c();
            qrev2.Fiscal_Quarter__c = '2013-2014';
            qrev2.NRE__c            =   10000;
            qrev2.ASP__c            =   10000;
            qrev2.Volume__c         =   10000;
            qrev2.date__c           =   system.today();
            qrev2.Opportunity__c    =   newopp.id;
        qrevList.add(qrev2);
        test.startTest();
        insert qrevList;       
        
        Deal_Grading__c testdg      =   new Deal_Grading__c();
            testdg.Opportunity1__c   =   newopp.Id;
            //testdg.Result__c='Decision Pending'; 
        insert testdg;
            
        ApexPages.CurrentPage().getparameters().put('id',testdg.id);
        ApexPages.StandardController  con       =   new ApexPages.StandardController(testdg);
        DealGrading_DisplayRevenueOnDG revDeg   =   new DealGrading_DisplayRevenueOnDG(con);
        revDeg.getcalSum();
        test.stoptest();
               
    }
    
}