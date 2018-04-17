/*Author: Vijay Vemuru
Description;  This class is used to test the Deal Grading IP's which are queried from IP Design Kit
History:
7/23/2016     code creation
*/
@isTest
private class DealGradingIP_Test {
   
@testSetup static void testdata(){
        DataUtilTest.loadEnvironmentVariables();
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();       
        fieldValueMap.put('Stage__c', 'Unqualified');
        fieldValueMap.put('Short_Name__c', 'test725');
        fieldValueMap.put('Site_Department__c', 'abc.com');
        fieldValueMap.put('Account_Type__c', 'Customer');
        fieldValueMap.put('Organization_Unit__c', 'sg;us');
        fieldValueMap.put('Copy_Address__c', true);
        fieldValueMap.put('Corporate_Address_1__c', 'test');
        fieldValueMap.put('Corporate_City__c', 'sg');
        fieldValueMap.put('Corporate_Country__c', 'sg');        
        fieldValueMap.put('Financial_Territory__c', 'Greater China');
        fieldValueMap.put('Region__c', 'APAC');
        fieldValueMap.put('Sub_Type__c', 'Direct');
        fieldValueMap.put('Transaction_Type__c', 'Transactional');
        fieldValueMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_RESELLER'));
        fieldValueMap.put('Account_Profile__c', 'Fabless - Emerging');
        fieldValueMap.put('Corporate_Postal_Zip_Code__c', '500013');
        fieldValueMap.put('Fab_9_10__c', 'No');
                
        AccountDataFactory.createAccount(fieldValueMap);
        }
        
//Creating Opportunity
public static Opportunity createOpp(){
       
       Account testAcct=[SELECT id from Account LIMIT 1];
           
           Opportunity testOppty = new Opportunity();
            testOppty.Name = 'Test Opportunity 1';
            testOppty.AccountId = testAcct.Id;
            
            testOppty.StageName = '2. Assessment';
            testOppty.CloseDate = Date.Today().addDays(10);
            testOppty.Target_Process_Node__c = '14XM';
            testOppty.Market_Segment__c = 'Mobility';
            testOppty.Process_Platform__c = 'GF Baseline';
            testOppty.Fab_Split__c = 100;
            testOppty.Fab_Assignment_1__c = 'FAB 5';
            testOppty.Process_Geometry__c = '0.028UM';
            testOppty.Process_Family__c = 'Generic / Nominal';
            testOppty.Years_of_Production__c = 4;
           
            Insert testOppty;   
            return testOppty;
    
    }  
    public static testmethod void  dealGradingIp() {
        
        test.startTest();
        Opportunity newopp=DealGrading_CreateSnapShotTest.createOpp();
        Deal_Grading__c testdg      =   new Deal_Grading__c();
        testdg.Opportunity1__c  =   newopp.Id;
        testdg.Result__c        =   'Decision Pending'; 
        insert testdg;
        
        DealGrading_IP dealIp       =   new DealGrading_IP(new ApexPages.StandardController(testdg));
        dealIp.dealGradingIps = new map<integer,Deal_Grading_IP__c>();
        dealIp.AddIp();
        DealIp.saveIp();
        dealIp.AddIp();
        dealIp.removeRow =0;
        dealIp.removeIp();
        dealIp.removeIp();
        
        testdg.Deal_Grading_Status__c   = 'Draft';
        update testdg;
        test.stoptest();     
    } 
}