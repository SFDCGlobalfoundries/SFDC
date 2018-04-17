/*
    Author: Pradosh Samal
    Description: This is the test class for IQ_RequoteController class.   
    History:
        Psamal       11112016    - code creation.
*/
@isTest(SeeAllData=false)
private class IQ_RequoteControllerTest {
    
    @testSetup static void testData() {
        DataUtilTest.loadEnvironmentVariables();
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MYTEST ACCOUNT1-Test1');            
        fieldValueMap.put('stage__c', 'Unqualified');        
        fieldValueMap.put('sub_type__c', 'Direct');
        fieldValueMap.put('site_department__c', 'test dept1');          
        fieldValueMap.put('transaction_type__c', 'transactional');                          
        fieldValueMap.put('region__c', 'APJ');        
        fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Corporate_City__c', 'Test City');                
        fieldValueMap.put('Corporate_Country__c', 'Singapore');
        fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Bill_To_City__c', 'Test City');            
        fieldValueMap.put('Bill_To_Country__c', 'Singapore');        
        fieldValueMap.put('Fab_9_10__c','No');
        //fieldValueMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER'));

        AccountDataFactory.createAccount(fieldValueMap);
    }
    
    private static Account getAccount(String accountName) {
        Account acct = [SELECT Id FROM Account Where Name =: accountName];
        return acct;
    }
    
    static testMethod void testRun1() {
        
        Account acc = getAccount('MYTEST ACCOUNT1-Test1');
             
        Opportunity testOppty = new Opportunity();
        testOppty.Name = 'Test Opportunity';
        testOppty.AccountId = acc.Id;
        testOppty.StageName = '1. Discovery';
        testOppty.CloseDate = Date.Today().addDays(10);
        testOppty.Target_Process_Node__c = '14XM';
        testOppty.Market_Segment__c = 'Mobility';
        testOppty.Process_Platform__c = 'GF Baseline';
        testOppty.Fab_Split__c = 100;
        testOppty.Process_Geometry__c = '0.028UM';
        testOppty.Process_Family__c = 'Super Low Power';
        
        insert testOppty;
        
        ConstantProcessGeometry__c constantProcessGeometryObj = new ConstantProcessGeometry__c(Name = '0.028UM', Value__c = '28NM');
        insert constantProcessGeometryObj;
        
        Informal_Quote__c obj = new Informal_Quote__c();
        obj.Process_ID__c = 'Test1';
        obj.Account__c = acc.Id;
        obj.Business_Deal_Proposal__c = 'Requote Existing Business';
        obj.Product_Category__c = 'Wafer';
        obj.Opportunity__c = testOppty.Id;
        obj.Years_of_Product__c = 1;
        obj.Process_Geometry__c = '0.028UM';
        obj.Budgetary_Quote_Status__c = 'Draft';
        obj.X1st_Product_Date__c = Date.Today();
        insert obj;
        
        Test.setCurrentPage(Page.IQ_Requote);
        ApexPages.currentPage().getParameters().put('EIQ', obj.Id);
        IQ_RequoteController iQ_RequoteController = new IQ_RequoteController(new ApexPages.StandardController(obj));
        PageReference pageRef = iQ_RequoteController.reQuote();
        
        List<Informal_Quote__c> informalQuoteList = [SELECT Id FROM Informal_Quote__c WHERE Existing_Informal_Quote__c = : obj.Id];
        
        if(informalQuoteList.size() > 0){
            Test.setCurrentPage(Page.IQ_Requote);
            ApexPages.currentPage().getParameters().put('EIQ', informalQuoteList[0].Id);
            iQ_RequoteController = new IQ_RequoteController(new ApexPages.StandardController(informalQuoteList[0]));
            pageRef = iQ_RequoteController.reQuote();
        }
    }
}