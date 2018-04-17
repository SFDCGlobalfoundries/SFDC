/*
    Author: Vijay Vemuru
    Description: This serves as the test class for the class DealGrading_UpdateDGOnOPP
    History: 06222016    - Code creation.
*/
@isTest(seeAlldata=false)
public class DealGrading_UpdateDGOnOPPTest{

@testSetup static void testdata(){

    DataUtilTest.loadEnvironmentVariables();
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();       
        fieldValueMap.put('Stage__c', 'Unqualified');
        fieldValueMap.put('Short_Name__c', 'test725');
        fieldValueMap.put('Site_Department__c', 'tcs.com');
        fieldValueMap.put('Account_Type__c', 'Customer');
        fieldValueMap.put('Organization_Unit__c', 'sg;us');
        fieldValueMap.put('Copy_Address__c', true);
        fieldValueMap.put('Corporate_Address_1__c', 'test');
        fieldValueMap.put('Corporate_City__c', 'sg');
        fieldValueMap.put('Corporate_Country__c', 'sg');        
        fieldValueMap.put('Financial_Territory__c', 'Germany');
        fieldValueMap.put('Region__c', 'APAC');
        fieldValueMap.put('Sub_Type__c', 'Direct');
        fieldValueMap.put('Transaction_Type__c', 'Transactional');
        fieldValueMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_EN_PARTNER'));
        fieldValueMap.put('Account_Profile__c', 'Fabless - Emerging');
        fieldValueMap.put('Corporate_Postal_Zip_Code__c', '500013');
        fieldValueMap.put('Fab_9_10__c', 'No');
                
       Account testAcct =  AccountDataFactory.createAccount(fieldValueMap);
              
       Opportunity testOppty = new Opportunity();
        testOppty.Name       = 'Test Opportunity 1';
        testOppty.AccountId  = testAcct.Id;
        
        testOppty.StageName              = '2. Assessment';
        testOppty.CloseDate              = Date.Today().addDays(10);
        testOppty.Target_Process_Node__c = '14XM';
        testOppty.Market_Segment__c      = 'Mobility';
        testOppty.Process_Platform__c    = 'GF Baseline';
        testOppty.Fab_Split__c           = 100;
        testOppty.Fab_Assignment_1__c    = 'FAB 6';
        testOppty.Process_Geometry__c    = '0.028UM';
        testOppty.Process_Family__c      = 'Generic / Nominal';
        testOppty.Years_of_Production__c = 2;
       
        Insert testOppty;    
        }       
    
 public static testmethod void TestUpdateOnOPP(){
     
     test.startTest();
        Opportunity opp= [select id,name from opportunity limit 1];
        system.AssertEquals('Test Opportunity 1', opp.Name);
     
        User thisUser= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');  
       List<PermissionSet> PersmissionsTemp = [SELECT Id,
                                                 Name, 
                                                 Label, 
                                                 ProfileId, 
                                                 Profile.Name 
                                                 FROM PermissionSet
                                                 WHERE Name = 'Deal_Grading_Admin_Access'];
         PermissionSetAssignment psa = new PermissionSetAssignment(AssigneeId = thisUser.id, PermissionSetId = PersmissionsTemp[0].Id);
                insert psa;        
        System.runAs(thisUser){
        
        Deal_Grading__c testdg = new Deal_Grading__c();
        testdg.Opportunity1__c = opp.Id;
        testdg.CreatedDate = Date.valueOf('2017-08-08 07:20:37');
        testdg.Graded_Date__c = Date.valueOf('2017-11-01 00:00:00');
        testdg.Start_time__c              = DateTime.parse('5/24/2016 12:08 AM') ;
        testdg.Meeting_Link__c          = 'https://plus.google.com/hangouts/_/globalfoundries.com/diw-standup-sc?authuser=0&hceid=a2lhbmNoaW5nLm5nQGdsb2JhbGZvdW5kcmllcy5jb20.pukq71hmpchn1l46pacdh4fcno';
        testdg.Result__c               = 'Decision Pending'; 
        testdg.Deal_Grading_Status__c  = 'Draft';
        insert testdg;
    test.stopTest();
        } 
        

 }

}