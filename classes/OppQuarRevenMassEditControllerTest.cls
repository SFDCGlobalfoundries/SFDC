/*
    Author: Yash Kumar
    Description: Test class for OppQuarterlyRevenueMassEditController
    History:
        Yash 24082013    - Code Creation.
            
*/


@isTest(SeeAllData=false)
public class OppQuarRevenMassEditControllerTest{

    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        Map<String,Object> fieldValueMap = new Map<String,Object>();            
        fieldValueMap.put('Name', 'Test Account 007');            
        fieldValueMap.put('stage__c', 'Unqualified');
        fieldValueMap.put('short_name__c', 'Test007');
        fieldValueMap.put('sub_type__c', 'Direct');
        fieldValueMap.put('site_department__c', 'IT');          
        fieldValueMap.put('transaction_type__c', 'Non-Transactional');
        fieldValueMap.put('account_profile__c', 'Fabless - Emerging');            
        fieldValueMap.put('Process_Tech_Interested__c', 'Mature (> 0.11um)');
        fieldValueMap.put('region__c', 'US');
        fieldValueMap.put('Sales_Territory__c', 'Greater China');
        fieldValueMap.put('financial_territory__c', 'Greater China');          
        fieldValueMap.put('Copy_Address__c', true);
        fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');
        fieldValueMap.put('Corporate_Address_2__c', 'Test Address 2');
        fieldValueMap.put('Corporate_Address_3__c', 'Test Address 3');
        fieldValueMap.put('Corporate_Address_4__c', 'Test Address 4');            
        fieldValueMap.put('Corporate_Country__c', 'Test Country');
        fieldValueMap.put('Corporate_City__c', 'Test City');
        fieldValueMap.put('Corporate_State__c', 'Test State');
        fieldValueMap.put('Corporate_Postal_Zip_Code__c', '700007');
        fieldValueMap.put('Organization_Unit__c', 'GF Investment LLC OU');
        fieldValueMap.put('bill_to_location__c', 'test');
        fieldValueMap.put('total_employee__c', 7);          
        fieldValueMap.put('end_customer__c', 'people');
        fieldValueMap.put('Revenue_Potential__c', 'Low Potential');            
        fieldValueMap.put('Target_Account__c', 'Yes');
        fieldValueMap.put('Fab_9_10__c','No');
        fieldValueMap.put('Bill_To_Address_1__c','Test Address');
        fieldValueMap.put('Account_Profile__c','Fabless - Emerging');
        fieldValueMap.put('Bill_To_City__c','Test City');
        fieldValueMap.put('Bill_To_Country__c','India');
        AccountDataFactory.createAccount(fieldValueMap);
        }
    static testMethod void doTestOppQuarRevMassEditController(){ 
    //UserRole role1 = [Select r.Name From UserRole r where name='Senior VP - WW Sales'];
   // UserRole role = [Select r.Name From UserRole r where name='CSR - Global Customer Support'];
      
       
       
        /*Environment_Variable__c settings = new Environment_Variable__c();
         Environment_Variable__c settings1 = new Environment_Variable__c();
        
            settings = new Environment_Variable__c();
            settings.name ='Senior VP - WW Sales';
            settings.Value__c = 'E';
            
            settings1 = new Environment_Variable__c();
            settings1.name ='CSR - Global Customer Support';
            settings1.Value__c= 'E';
            
            
            Insert new list<Environment_Variable__c>{settings1};*/
            
            Account acct= getAccount('Test Account 007');
            Test.startTest(); 
	     Map<String,Object> fieldValueMap = new Map<String,Object>();
          fieldValueMap.put('AccountId',acct.Id);
          fieldValueMap.put('Name','ABC');  
          fieldValueMap.put('StageName','1. Discovery');
          fieldValueMap.put('CloseDate',date.newinstance(2012, 12, 21));  
          fieldValueMap.put('Target_Process_Node__c','14XM');
          fieldValueMap.put('Market_Segment__c','Automotive');  
          fieldValueMap.put('Process_Platform__c','GF Baseline');
          fieldValueMap.put('Fab_Split__c',100);          
          fieldValueMap.put('Process_Geometry__c','0.014UM');  
          fieldValueMap.put('Process_Family__c','Super Low Power');
          fieldValueMap.put('Opportunity_Sourcing_Type__c','First Source');  
          fieldValueMap.put('Fab_Assignment_1__c','FAB 1');
         
            Opportunity opp = OpportunityDataFactory.createOpportunity(fieldValueMap);
        Quarterly_Revenue_Object__c qr1 = new Quarterly_Revenue_Object__c(Opportunity__c = opp.Id, ASP__c=10.0, Volume__c=100, Date__c= date.newinstance(2012, 4, 1), Count__c = true);
        //insert qr1;       
        Quarterly_Revenue_Object__c qr2 = new Quarterly_Revenue_Object__c(Opportunity__c = opp.Id, ASP__c=10.0, Volume__c=100, Date__c= date.newinstance(2012, 4, 2), Count__c = true);
        //insert qr2;      
        Quarterly_Revenue_Object__c qr3 = new Quarterly_Revenue_Object__c(Opportunity__c = opp.Id, ASP__c=10.0, Volume__c=100, Date__c= date.newinstance(2012, 4, 3), Count__c = true);
        //insert qr3;
        List<Quarterly_Revenue_Object__c> qrList = new List<Quarterly_Revenue_Object__c>(); 
        List<Quarterly_Revenue_Object__c> sList = new List<Quarterly_Revenue_Object__c>(); 
        
        slist.add(qr2);
        slist.add(qr3);
        slist.add(qr1);
        
        insert slist;
        
        /*qr1.ASP_Module_Chip__c = 10;
        qr1.Volume_Module_Chip__c=11; 
        qr1.Volume__c = 150; 
        slist.add(qr1);
        
        update qr1; */   
        
              
        ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(sList);        
        OppQuarterlyRevenueMassEditController ctrl = new OppQuarterlyRevenueMassEditController(stdSetController);
        stdSetController.setSelected(sList);        
       
      //  ctrl.checkVisibility('Senior VP - WW Sales');
      //  ctrl.checkVisibility('CSR - Global Customer Support');
            
        List<Quarterly_Revenue_Object__c> tlist = ctrl.getSelectedSorted();
        
        System.assert(tlist.size()==3);
        Quarterly_Revenue_Object__c first = tlist.get(0);    
        
        System.assert(first.Id == qr1.Id);
       Test.stopTest();
        
    
    
    }
    
    private static Account getAccount(string AccountName)
            {
                Account acct= [SELECT Id, Name FROM Account Where Name =: AccountName];
        
                return acct;
            }  
            
       
        static testmethod void myunittest() {
            Account acct= getAccount('Test Account 007');
            Test.startTest(); 
            Opportunity opp = new Opportunity(Name='ABC', StageName='Discovery', CloseDate = date.newinstance(2012, 12, 21), AccountId=acct.Id );
            insert opp;   
            
            Quarterly_Revenue_Object__c qr1 = new Quarterly_Revenue_Object__c(Opportunity__c = opp.Id, ASP__c=10.0, Volume__c=100, Date__c= date.newinstance(2012, 4, 1), Count__c = true);
            
            insert qr1;       
            
            qr1.ASP_Module_Chip__c = 10;
            qr1.Volume_Module_Chip__c=11; 
            qr1.Volume__c = 150; 
            
            update qr1; 
            Test.stopTest();    
        }
            
}