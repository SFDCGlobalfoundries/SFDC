/*
    Author: Yash Kumar
    Description: Test class for OppInformalQuoteItemMassEditController
    History:
        Yash 25032014    - Code Creation.
        Ashwini     05152015    - Updated code for refactoring of test class.
        Pradosh     12192016    - Updated for increasing code coverage.    
*/


@isTest
public class InformalQuoteItemTrigger_Test{
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MYTEST ACCOUNT1');                         
        fieldValueMap.put('sub_type__c', 'Direct');
        fieldValueMap.put('site_department__c', 'test dept');          
        fieldValueMap.put('transaction_type__c', 'transactional');                          
        fieldValueMap.put('region__c', 'APJ');        
        fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Corporate_City__c', 'Test City');                
        fieldValueMap.put('Corporate_Country__c', 'India');
        fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Bill_To_City__c', 'Test City');            
        fieldValueMap.put('Bill_To_Country__c', 'India');        
        fieldValueMap.put('Fab_9_10__c','No');

        Account acc1 = AccountDataFactory.createAccount(fieldValueMap);
        
        fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MYTEST ACCOUNT2');            
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

        Account acc2 = AccountDataFactory.createAccount(fieldValueMap);
        
        Map<String,Object> opportunityValueMap = new Map<String,Object>();
        opportunityValueMap.put('Name', 'Test Opportunity1'); 
        opportunityValueMap.put('AccountId', acc1.Id); 
        opportunityValueMap.put('StageName', '1. Discovery'); 
        opportunityValueMap.put('CloseDate', Date.Today().addDays(10)); 
        opportunityValueMap.put('Target_Process_Node__c', '14XM'); 
        opportunityValueMap.put('Market_Segment__c', 'Mobility'); 
        opportunityValueMap.put('Process_Platform__c', 'GF Baseline'); 
        opportunityValueMap.put('Fab_Split__c', 100); 
        opportunityValueMap.put('Process_Geometry__c', '0.028UM'); 
        opportunityValueMap.put('Process_Family__c', 'Super Low Power'); 
        
        OpportunityDataFactory.createOpportunity(opportunityValueMap);
        
        opportunityValueMap = new Map<String,Object>();
        opportunityValueMap.put('Name', 'Test Opportunity2'); 
        opportunityValueMap.put('AccountId', acc2.Id); 
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
    
    private static Account getAccount(string AccountName){
    
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
    
    private static Opportunity getOpportunity(String oppName) {
        Opportunity opp = [SELECT Id FROM Opportunity Where Name =: oppName];
        return opp;
    }
    
    static testMethod void doTestInformalQuoteItemTrigger()
    {    
        Test.startTest();
        //DataUtilTest.loadEnvironmentVariables();
       
        Profile profile1 = [select id from profile where name='System Administrator'];
        Profile profile = [select id from profile where name='GF Biz Ops Pricing'];
     
         
         
        ProfileName__c settings = new ProfileName__c();
        ProfileName__c settings1 = new ProfileName__c();
        ProfileName__c settings2 = new ProfileName__c();
        ProfileName__c settings3 = new ProfileName__c();
        ProfileName__c settings4 = new ProfileName__c();
        ProfileName__c settings5 = new ProfileName__c();
          
        settings = new ProfileName__c();
        settings.name ='System Administrator';
        settings.ProfileAccess__c = 'E';
        
        settings1 = new ProfileName__c();
        settings1.name ='GF Biz Ops Pricing';
        settings1.ProfileAccess__c = 'P';
        
        settings2 = new ProfileName__c();
        settings2.name ='GF Sales User';
        settings2.ProfileAccess__c = 'S';
        
        settings3 = new ProfileName__c();
        settings3.name ='GF Finance';
        settings3.ProfileAccess__c = 'F';
        
        
              
        Account_Team_Roles__c roless = new Account_Team_Roles__c();
        roless.name='ROLE_PRIMARY_FIELD_ENGINEER';
        roless.Role__c='Field Application Engineer';
        insert roless ;
      
        Insert settings;
        Insert settings1;
        Insert settings2;
        Insert settings3;
     //   try
      //  {
            Account acc = getAccount('MYTEST ACCOUNT1');
          /*
          Map<String,Object> fieldValueMap = new Map<String,Object>();
          fieldValueMap.put('AccountId',acc.id);
          fieldValueMap.put('Name','ABC');  
          fieldValueMap.put('StageName','1. Discovery');
          fieldValueMap.put('CloseDate',date.newinstance(2012, 12, 21));  
          fieldValueMap.put('Target_Process_Node__c','14XM');
          fieldValueMap.put('Market_Segment__c','Automotive');  
          fieldValueMap.put('Process_Platform__c','GF Baseline');
          fieldValueMap.put('Fab_Split__c',100);          
          fieldValueMap.put('Process_Geometry__c','0.09UM');  
          fieldValueMap.put('Process_Family__c','Generic / Nominal');
          fieldValueMap.put('Opportunity_Sourcing_Type__c','First Source');  
         */
          Opportunity opp = getOpportunity('Test Opportunity1');
        
            Competitors__c comp= new Competitors__c(Name='test156413',Order_Type__c='Wafer');
            insert comp;
            Competitors__c comp1= new Competitors__c(Name='test256413',Order_Type__c='Wafer');
            insert comp1;
            Competitors__c comp2= new Competitors__c(Name='test356413',Order_Type__c='Wafer');
            insert comp2;
            
            ConstantProcessGeometry__c constantProcessGeometryObj = new ConstantProcessGeometry__c(Name = '0.028UM', Value__c = '28NM');
            insert constantProcessGeometryObj;
            
            Informal_Quote__c info = new Informal_Quote__c(Competitor1__c=comp.id,Yield_Commit__c='NO',Existing_Device__c='NO',account__c=acc.id,Business_Deal_Proposal__c='Requote Existing Business',Opportunity__c=opp.id,Product_Category__c='Wafer',Process_Geometry__c='0.028UM',Process_ID__c='100',Budgetary_Quote_Status__c='Draft'); //,Years_of_Product__c=1,X1st_Product_Date__c= date.newinstance(2012, 4, 1)
            insert info;
           
            info.Years_of_Product__c=2;
            info.X1st_Product_Date__c= date.newinstance(2012, 4, 1);
            update info;
      //  }
     //   catch(exception ex)
     //   {

     //   }
        Test.stopTest();
    }
    
    static testMethod void testRun1(){
        Test.startTest();
      //  try{
            Account acc = getAccount('MYTEST ACCOUNT1');
            Opportunity opp = getOpportunity('Test Opportunity1');
            
            ConstantProcessGeometry__c constantProcessGeometryObj = new ConstantProcessGeometry__c(Name = '0.014UM', Value__c = '14NM');
            insert constantProcessGeometryObj;
            
            Informal_Quote__c info = new Informal_Quote__c(Yield_Commit__c='NO',Existing_Device__c='NO',account__c=acc.id,Business_Deal_Proposal__c='Requote Existing Business',Opportunity__c=opp.id,Product_Category__c='Wafer',Process_Geometry__c='0.014UM',Process_ID__c='100',Budgetary_Quote_Status__c='Draft');
            
            insert info;
     //   }
     //   catch(Exception e){}
        Test.stopTest(); 
    }
    
    static testMethod void testRun2()
    {    
        Test.startTest();
       // try{
            //DataUtilTest.loadEnvironmentVariables();
            ConstantProcessGeometry__c constantProcessGeometryObj = new ConstantProcessGeometry__c(Name = '0.014UM', Value__c = '14NM');
            insert constantProcessGeometryObj;
            
            Profile profile1 = [select id from profile where name='System Administrator'];
            Profile profile = [select id from profile where name='GF Biz Ops Pricing'];
         
             
             
            ProfileName__c settings = new ProfileName__c();
            ProfileName__c settings1 = new ProfileName__c();
            ProfileName__c settings2 = new ProfileName__c();
            ProfileName__c settings3 = new ProfileName__c();
            ProfileName__c settings4 = new ProfileName__c();
            ProfileName__c settings5 = new ProfileName__c();
              
            settings = new ProfileName__c();
            settings.name ='System Administrator';
            settings.ProfileAccess__c = 'E';
            
            settings1 = new ProfileName__c();
            settings1.name ='GF Biz Ops Pricing';
            settings1.ProfileAccess__c = 'P';
            
            settings2 = new ProfileName__c();
            settings2.name ='GF Sales User';
            settings2.ProfileAccess__c = 'S';
            
            settings3 = new ProfileName__c();
            settings3.name ='GF Finance';
            settings3.ProfileAccess__c = 'F';
            
            
                  
            Account_Team_Roles__c roless = new Account_Team_Roles__c();
            roless.name='ROLE_PRIMARY_FIELD_ENGINEER';
            roless.Role__c='Field Application Engineer';
            insert roless ;
          
            Insert settings;
            Insert settings1;
            Insert settings2;
            Insert settings3;
            
            Account acc = getAccount('MYTEST ACCOUNT1');
              
            Opportunity opp = getOpportunity('Test Opportunity1');
            upsert opp;  
            Competitors__c comp= new Competitors__c(Name='test156413',Order_Type__c='Wafer');
            insert comp;
            Competitors__c comp1= new Competitors__c(Name='test256413',Order_Type__c='Wafer');
            insert comp1;
            Competitors__c comp2= new Competitors__c(Name='test356413',Order_Type__c='Wafer');
            insert comp2;
              
            Informal_Quote__c info = new Informal_Quote__c(Competitor1__c=comp.id,Yield_Commit__c='NO',Existing_Device__c='NO',account__c=acc.id,Business_Deal_Proposal__c='Requote Existing Business',Opportunity__c=opp.id,Product_Category__c='Wafer',Process_Geometry__c='0.014UM',Process_ID__c='100',Budgetary_Quote_Status__c='Draft'); //,Years_of_Product__c=1,X1st_Product_Date__c= date.newinstance(2012, 4, 1)
            insert info;
           
            info.Years_of_Product__c=2;
            info.X1st_Product_Date__c= date.newinstance(2012, 4, 1);
            update info;
     //   }
      //  catch(Exception e){}
       // Test.stopTest();
    }

    static testMethod void testRun5() {
        Test.startTest();
      //  try{
            Account acc = getAccount('MYTEST ACCOUNT2');
             
            Opportunity testOppty = getOpportunity('Test Opportunity2');
            
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
            obj.Yield_Commit__c = 'NO';
            insert obj;
            
            List<Budgetary_Quote_Item__c> budgetaryQuoteItemList = [SELECT id,Competitors_1__c,Competitors_2__c,Competitors_1_Volume__c ,Competitors_2_Volume__c , CreatedDate,           Competitor_1_Complexity__c,Competitor_2_Complexity__c,Competitor_1_Price_US__c,Competitor_2_Price_US__c, name, Sales_Requested_Price__c,Pricing_Approved_Price__c,Box_Score__c,Cost__c, List_Price__c, Start_Date__c, Quarter__c, Quantity__c,Margin__c, Budgetary_Quote__r.Name,Budgetary_Quote__r.id,Budgetary_Quote__r.Competitor1__c,            Budgetary_Quote__r.Competitor_2__c,Budgetary_Quote__r.Competitor_1_Complexity__c,Yield_Commit_information_for_customer__c,Yield_Commit_information_for_TE__c,Yield_Commit_information_for_Pricing__c, Budgetary_Quote__r.Competitor_2_Complexity__c,Budgetary_Quote__r.Competitor_1_Price_US__c,Budgetary_Quote__r.Budgetary_Quote_Status__c,                Budgetary_Quote__r.Competitor_2_Price_US__c,Budgetary_Quote__r.Competitor_1_Quarter__c,Budgetary_Quote__r.Yield_Commit__c,             Budgetary_Quote__r.Competitor_2_Quarter__c,Budgetary_Quote__c from Budgetary_Quote_Item__c where Budgetary_Quote__c =: obj.Id];
            
            for(Budgetary_Quote_Item__c obj1 : budgetaryQuoteItemList){
                obj1.Pricing_Approved_Price__c = 100;
                obj1.List_Price__c = 100;
            }
            
            update budgetaryQuoteItemList;
            
            obj.Budgetary_Quote_Status__c = 'Pending Approval Pricing';
            update obj;
            
            obj.Hold_Reason__c = 'Hold Reason';
            obj.Budgetary_Quote_Status__c = 'Hold';
            obj.Hold_Stage__c = 'Pending Approval Pricing';
            obj.Hold_Time__c = System.now();
            update obj;
            
            obj.Hold_Reason__c = NULL;
            obj.Budgetary_Quote_Status__c = 'Pending Approval Pricing';
            update obj;
            
            obj.Hold_Reason__c = 'Hold Reason';
            obj.Budgetary_Quote_Status__c = 'Hold';
            obj.Hold_Stage__c = 'Pending Approval Pricing';
            obj.Hold_Time__c = System.now().addDays(-10);
            update obj;
            
            obj.Hold_Reason__c = NULL;
            obj.Budgetary_Quote_Status__c = 'Pending Approval Pricing';
            update obj;
     //   }
      //  catch(Exception e){}
        Test.stopTest();
    }
}