/*
    Author: Pradosh Samal
    Description: This is the test class for IQ_HoldController class.   
    History:
        Psamal       01062017    - code creation.
*/
@isTest(SeeAllData=false)
private class IQ_HoldControllerTest {
    
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

        Account acctObj = AccountDataFactory.createAccount(fieldValueMap);
        
        Map<String,Object> opportunityValueMap = new Map<String,Object>();
        opportunityValueMap.put('Name', 'Test Opportunity'); 
        opportunityValueMap.put('AccountId', acctObj.Id); 
        opportunityValueMap.put('StageName', '1. Discovery'); 
        opportunityValueMap.put('CloseDate', Date.Today().addDays(10)); 
        opportunityValueMap.put('Target_Process_Node__c', '14XM'); 
        opportunityValueMap.put('Market_Segment__c', 'Mobility'); 
        opportunityValueMap.put('Process_Platform__c', 'GF Baseline'); 
        opportunityValueMap.put('Fab_Split__c', 100); 
        opportunityValueMap.put('Process_Geometry__c', '0.028UM'); 
        opportunityValueMap.put('Process_Family__c', 'Super Low Power'); 
        
        OpportunityDataFactory.createOpportunity(opportunityValueMap);
    }
    
    private static Account getAccount(String accountName) {
        Account acct = [SELECT Id FROM Account Where Name =: accountName];
        return acct;
    }
    
    private static Opportunity getOpportunity(String oppName) {
        Opportunity opp = [SELECT Id FROM Opportunity Where Name =: oppName];
        return opp;
    }
    
    static testMethod void testRun1() {
        Test.startTest();
        try{
            Account acc = getAccount('MYTEST ACCOUNT1-Test1');
             
            Opportunity testOppty = getOpportunity('Test Opportunity');
            
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
            
            Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
            req1.setObjectId(obj.Id);
            Approval.ProcessResult result = Approval.process(req1);
            
            List<Budgetary_Quote_Item__c> budgetaryQuoteItemList = [SELECT id,Competitors_1__c,Competitors_2__c,Competitors_1_Volume__c ,Competitors_2_Volume__c , CreatedDate,           Competitor_1_Complexity__c,Competitor_2_Complexity__c,Competitor_1_Price_US__c,Competitor_2_Price_US__c, name, Sales_Requested_Price__c,Pricing_Approved_Price__c,Box_Score__c,Cost__c, List_Price__c, Start_Date__c, Quarter__c, Quantity__c,Margin__c, Budgetary_Quote__r.Name,Budgetary_Quote__r.id,Budgetary_Quote__r.Competitor1__c,            Budgetary_Quote__r.Competitor_2__c,Budgetary_Quote__r.Competitor_1_Complexity__c,Yield_Commit_information_for_customer__c,Yield_Commit_information_for_TE__c,Yield_Commit_information_for_Pricing__c, Budgetary_Quote__r.Competitor_2_Complexity__c,Budgetary_Quote__r.Competitor_1_Price_US__c,Budgetary_Quote__r.Budgetary_Quote_Status__c,                Budgetary_Quote__r.Competitor_2_Price_US__c,Budgetary_Quote__r.Competitor_1_Quarter__c,Budgetary_Quote__r.Yield_Commit__c,             Budgetary_Quote__r.Competitor_2_Quarter__c,Budgetary_Quote__c from Budgetary_Quote_Item__c where Budgetary_Quote__c =: obj.Id];
            
            for(Budgetary_Quote_Item__c obj1 : budgetaryQuoteItemList){
                obj1.Pricing_Approved_Price__c = 100;
                obj1.List_Price__c = 100;
            }
            
            update budgetaryQuoteItemList;
            
            obj.Hold_Reason__c = 'Test';
            update obj;
            
            Test.setCurrentPage(Page.IQ_Hold);
            ApexPages.currentPage().getParameters().put('Id', obj.Id);
            IQ_HoldController iQ_HoldController = new IQ_HoldController(new ApexPages.StandardController(obj));
            PageReference pageRef = iQ_HoldController.save();
            
            pageRef = iQ_HoldController.hold();
            
            obj.Hold_Reason__c = 'Test1';
            update obj;
            
            pageRef = iQ_HoldController.save();
            pageRef = iQ_HoldController.hold();
        }
        catch(Exception e){}
        Test.stopTest();
    }
    
    static testMethod void testRun2() {
        Test.startTest();
        try{
            Account acc = getAccount('MYTEST ACCOUNT1-Test1');
             
            Opportunity testOppty = getOpportunity('Test Opportunity');
            
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
            
            Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
            req1.setObjectId(obj.Id);
            Approval.ProcessResult result = Approval.process(req1);
            
            List<Budgetary_Quote_Item__c> budgetaryQuoteItemList = [SELECT id,Competitors_1__c,Competitors_2__c,Competitors_1_Volume__c ,Competitors_2_Volume__c , CreatedDate,           Competitor_1_Complexity__c,Competitor_2_Complexity__c,Competitor_1_Price_US__c,Competitor_2_Price_US__c, name, Sales_Requested_Price__c,Pricing_Approved_Price__c,Box_Score__c,Cost__c, List_Price__c, Start_Date__c, Quarter__c, Quantity__c,Margin__c, Budgetary_Quote__r.Name,Budgetary_Quote__r.id,Budgetary_Quote__r.Competitor1__c,            Budgetary_Quote__r.Competitor_2__c,Budgetary_Quote__r.Competitor_1_Complexity__c,Yield_Commit_information_for_customer__c,Yield_Commit_information_for_TE__c,Yield_Commit_information_for_Pricing__c, Budgetary_Quote__r.Competitor_2_Complexity__c,Budgetary_Quote__r.Competitor_1_Price_US__c,Budgetary_Quote__r.Budgetary_Quote_Status__c,                Budgetary_Quote__r.Competitor_2_Price_US__c,Budgetary_Quote__r.Competitor_1_Quarter__c,Budgetary_Quote__r.Yield_Commit__c,             Budgetary_Quote__r.Competitor_2_Quarter__c,Budgetary_Quote__c from Budgetary_Quote_Item__c where Budgetary_Quote__c =: obj.Id];
            
            for(Budgetary_Quote_Item__c obj1 : budgetaryQuoteItemList){
                obj1.Pricing_Approved_Price__c = 100;
                obj1.List_Price__c = 100;
            }
            
            update budgetaryQuoteItemList;
            
            obj.Hold_Reason__c = 'Test';
            update obj;
            
            Test.setCurrentPage(Page.IQ_Hold);
            ApexPages.currentPage().getParameters().put('Id', obj.Id);
            ApexPages.currentPage().getParameters().put('test', 'test');
            IQ_HoldController iQ_HoldController = new IQ_HoldController(new ApexPages.StandardController(obj));
            
            PageReference pageRef = iQ_HoldController.save();
            pageRef = iQ_HoldController.hold();
        }
        catch(Exception e){}
        Test.stopTest();
    }
}