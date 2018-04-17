@isTest
public class LinkedAgreementRelatedListControllerTest
{
   
   @testsetup  
   public static void TestSetupMethod()
   {
       List<SObject> SobjList=new List<SObject>();
         DataUtilTest.LoadEnvironmentVariables();
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MYTEST ACCOUNT1');            
        fieldValueMap.put('stage__c', 'Unqualified');        
        fieldValueMap.put('sub_type__c', 'Direct');
        fieldValueMap.put('site_department__c', 'test dept');          
        fieldValueMap.put('transaction_type__c', 'transactional');                          
        fieldValueMap.put('region__c', 'APJ');        
        fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Corporate_City__c', 'Test City');                
        fieldValueMap.put('Corporate_Country__c', 'Singapore');
        fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Bill_To_City__c', 'Test City');            
        fieldValueMap.put('Bill_To_Country__c', 'Singapore');        
        fieldValueMap.put('Fab_9_10__c','No');

        Account acct = AccountDataFactory.createAccount(fieldValueMap);
        
        GFV_NDA_Account_Sync_Settings__c gnda = new GFV_NDA_Account_Sync_Settings__c();
        gnda.name = 'ndaSyncApplicableTo';
        gnda.value__c = 'In Effect->Activated;In Effect->Being Amended';        
        gnda.comment__c = 'Delimiter is new Line. Format : Status Category Status. Do not leave spaces in the end';
        insert gnda;
        
            
       Contact con=AgreementTestDataFactory.GenerateContact(NULL,'test','test',acct);
       SobjList.add(con);
       Apttus__APTS_Agreement__c Paragr=AgreementTestDataFactory.GenerateAgreement('Procurement_Agreements','Primary Test Agreement',acct);
       SobjList.add(Paragr);
       Apttus__APTS_Agreement__c Childagr1=AgreementTestDataFactory.GenerateAgreement('Procurement_Agreements','Child Test Agreement1',acct);     
       SobjList.add(Childagr1);
       Apttus__APTS_Agreement__c Childagr2=AgreementTestDataFactory.GenerateAgreement('Procurement_Agreements','Child Test Agreement2',acct);     
       SobjList.add(Childagr2);
       Apttus__APTS_Agreement__c Childagr3=AgreementTestDataFactory.GenerateAgreement('Procurement_Agreements','Child Test Agreement3',acct);     
       SobjList.add(Childagr3);
       Apttus__APTS_Agreement__c Childagr4=AgreementTestDataFactory.GenerateAgreement('Procurement_Agreements','Child Test Agreement4',acct);     
       SobjList.add(Childagr4);
       
       insert SobjList;  
        
   }       
   public static testMethod void testController() 
   {
       PageReference pageRef = Page.Related_Agreements;
       Test.setCurrentPage(pageRef);
       
       
       
       
       Apttus__APTS_Agreement__c Paragr=[select id from Apttus__APTS_Agreement__c where name='Primary Test Agreement' limit 1]; 
       ApexPages.currentPage().getParameters().put('Id', Paragr.id);
       
       LinkedAgreementRelatedListController controller = new LinkedAgreementRelatedListController(new ApexPages.StandardController(Paragr));
       
       
       
       
       
       List<Apttus__APTS_Agreement__c> listchildagr=new List<Apttus__APTS_Agreement__c>();
       List<Linked_and_Associated_Contract__c> linkedRecList=new List<Linked_and_Associated_Contract__c>();
       
       for(Apttus__APTS_Agreement__c  agr :[select id from Apttus__APTS_Agreement__c where name like '%Child Test Agreement%']) 
       {
               Linked_and_Associated_Contract__c linkedObj=new Linked_and_Associated_Contract__c();
               linkedObj.Top_Level_Agreement__c=Paragr.id;
               linkedObj.Child_Level_Agreement__c=agr.id;
               linkedRecList.add(linkedObj);
               
               linkedObj=new Linked_and_Associated_Contract__c();
               linkedObj.Top_Level_Agreement__c=agr.id;
               linkedObj.Child_Level_Agreement__c=Paragr.id;
               linkedRecList.add(linkedObj);
               
       }
       
       
       upsert linkedRecList;   
           
       controller=new LinkedAgreementRelatedListController(new ApexPages.StandardController(Paragr));
            
       controller.loadData();
       System.assertEquals(controller.agreements.size(),4);
       
       controller.lstSetController.addAll(listchildagr);
       
       
       pageReference pg = new pageReference('/apex/related_agreements?Id='+Paragr.Id);
       controller.getCallLinkerSearchPage();
       System.assertEquals(ApexPages.currentPage().getURL(),pg.getURL());
       
       
       controller.getCallUnLinkerPage();
       
       controller.next();
          
       controller.previous();
       
       
       
       controller.SelectedAgrId=[select id from Apttus__APTS_Agreement__c where name ='Child Test Agreement3' limit 1].id;
       controller.deleteAgr();
       System.assertEquals([select id from Apttus__APTS_Agreement__c where name ='Child Test Agreement3' limit 1].size(),0);
       
       
       Boolean hasNext=controller.hasNext; 
       Boolean hasPrevious=controller.hasPrevious;
       
       
       

       }
       
       }