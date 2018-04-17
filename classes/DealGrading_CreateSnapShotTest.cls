/*Author: Vijay Vemuru
Description:This is the Test class for Dealgrading snapshots where the Quarterly Revenue Snapshots are taken from Opportunity Revenue.
*/
@isTest
public class DealGrading_CreateSnapShotTest{

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
        fieldValueMap.put('Financial_Territory__c', 'Australia');
        fieldValueMap.put('Region__c', 'APJ');
        fieldValueMap.put('Sub_Type__c', 'Direct');
        fieldValueMap.put('Transaction_Type__c', 'Transactional');
        fieldValueMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_RESELLER'));
        fieldValueMap.put('Account_Profile__c', 'Fabless - Emerging');
        fieldValueMap.put('Corporate_Postal_Zip_Code__c', '700007');
        fieldValueMap.put('Fab_9_10__c', 'No');
                
        AccountDataFactory.createAccount(fieldValueMap);
        }
        
//Creating Opportunity
public static Opportunity createOpp(){
       
       Account testAcct=[SELECT id from Account LIMIT 1];
             
       Opportunity testOppty = new Opportunity();
        testOppty.Name       = 'Test Opportunity 1';
        testOppty.AccountId  = testAcct.Id;
        
        testOppty.StageName = '1. Discovery';
        testOppty.CloseDate = Date.Today().addDays(10);
        testOppty.Target_Process_Node__c = '14XM';
        testOppty.Market_Segment__c = 'A&D';
        testOppty.Process_Platform__c = 'GF Baseline';
        testOppty.Fab_Split__c = 100;
        testOppty.Fab_Assignment_1__c = 'FAB 9';
        testOppty.Process_Geometry__c = '0.028UM';
        testOppty.Process_Family__c = 'Generic / Nominal';
        testOppty.Years_of_Production__c = 1;
       
        Insert testOppty; 
        return testOppty;

                    }
    static public testmethod void CheckSnapShot()
        {
          Opportunity newopp=DealGrading_CreateSnapShotTest.createOpp();
                 
          List<Quarterly_Revenue_Object__c> qrevList = new list<Quarterly_Revenue_Object__c>();
          
         //Creating a new DG record and assigning the newoppid
         Quarterly_Revenue_Object__c   qrev =  new Quarterly_Revenue_Object__c();
            qrev.Fiscal_Quarter__c  = '2011-2012';
            qrev.NRE__c         =   10000;
            qrev.ASP__c         =   15000;
            qrev.Volume__c      =   10000;
            qrev.date__c        =   system.today();
            qrev.Opportunity__c =   newopp.id;
        qrevList.add(qrev);
        
        Quarterly_Revenue_Object__c   qrev1 =  new Quarterly_Revenue_Object__c();
            qrev1.Fiscal_Quarter__c  = '2012-2013';
            qrev1.date__c        =   system.today();
            qrev1.NRE__c         =   10000;
            qrev1.ASP__c         =   10000;
            qrev1.Volume__c      =   15000;
            qrev1.Opportunity__c =  newopp.id;
        qrevList.add(qrev1);
        
        Quarterly_Revenue_Object__c   qrev2 =  new Quarterly_Revenue_Object__c();
            qrev2.Fiscal_Quarter__c = '2013-2014';
            qrev2.NRE__c            =   10000;
            qrev2.ASP__c            =   10000;
            qrev2.Volume__c         =   10000;
            qrev2.date__c           =   system.today();
            qrev2.Opportunity__c    =   newopp.id;
        qrevList.add(qrev2);
        insert qrevList;
        
        Deal_Grading__c testdg      =   new Deal_Grading__c();
            testdg.Opportunity1__c  =   newopp.Id;
            testdg.Result__c        =  'Decision Pending'; 
            test.startTest();
            insert testdg;
            
            testdg.Deal_Grading_status__c        = 'Complete - Proceed to Quote';
            testdg.Is_submitting_for_approval__c = true;
            update testdg;
           test.stopTest();

        }
 }