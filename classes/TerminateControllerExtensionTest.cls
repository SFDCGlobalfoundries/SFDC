@isTest
public class TerminateControllerExtensionTest
{
    @testsetup  
   public static void TestSetupMethod()
   {
       List<SObject> SobjList=new List<SObject>();
              //DataUtilTest.LoadEnvironmentVariables();
               AgreementTestDataFactory.loaddefaults();
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

        Account acct= AccountDataFactory.createAccount(fieldValueMap);
           
       Contact con=AgreementTestDataFactory.GenerateContact(NULL,'test','test',acct);
       SobjList.add(con);
       Apttus__APTS_Agreement__c agr=AgreementTestDataFactory.GenerateAgreement('Procurement_Agreements','Test Agreement',acct);
       SobjList.add(agr);
             
       insert SobjList;
   }
     
     public static testMethod void testControllerExtension() 
      {   
      
      PageReference pageRef = Page.Terminate_Agreement;
      Test.setCurrentPage(pageRef);
      
      Apttus__APTS_Agreement__c Agr=[select id,CLM_Termination_Reason__c from Apttus__APTS_Agreement__c where name='Test Agreement' limit 1]; 
      ApexPages.currentPage().getParameters().put('Id', Agr.id);
      TerminateControllerExtension controller = new TerminateControllerExtension(new ApexPages.StandardController(Agr));
      
      controller.Terminate();
      
      boolean msgFound = false;
      for(Apexpages.Message msg : ApexPages.getMessages())
      {
            if (msg.getDetail() == controller.MSG_ERROR) msgFound = true;

      }

      System.Assert(msgFound);
      
      test.startTest();
      Agr.CLM_Termination_Reason__c='Test';
      PageReference pg=controller.Terminate();
      msgFound = false;
      for(Apexpages.Message msg : ApexPages.getMessages())
      {
            if (msg.getDetail() == controller.MSG_ERROR) msgFound = true;

      }
      
      test.stopTest();
      Apttus__APTS_Agreement__c ResAgr=[select id,Apttus__Status__c,Apttus__Status_Category__c,CLM_Termination_Reason__c from Apttus__APTS_Agreement__c where name='Test Agreement' limit 1]; 
      System.AssertEquals(ResAgr.Apttus__Status__c,'Terminated');
      System.AssertEquals(ResAgr.Apttus__Status_Category__c,'Terminated');
      System.AssertEquals(ResAgr.CLM_Termination_Reason__c,'Test');
      
      List<Task> At=new List<Task>([select id from Task where WhatId= :ResAgr.id]);
      System.AssertEquals(At.size(),1);
      
      PageReference pr=new PageReference('/'+ResAgr.id); 
      System.assertEquals(pr.getURL(),pg.getURL());
      }
      
      
      public static testMethod void testControllerExtensionExpireMethod() 
      {   
      
      PageReference pageRef = Page.Terminate_Agreement;
      Test.setCurrentPage(pageRef);
      
      Apttus__APTS_Agreement__c Agr=[select id,Expiration_Reason__c from Apttus__APTS_Agreement__c where name='Test Agreement' limit 1]; 
      ApexPages.currentPage().getParameters().put('Id', Agr.id);
      TerminateControllerExtension controller = new TerminateControllerExtension(new ApexPages.StandardController(Agr));
      
      controller.Expire();
      
      boolean msgFound = false;
      for(Apexpages.Message msg : ApexPages.getMessages())
      {
            if (msg.getDetail() == controller.MSG_ERROR) msgFound = true;

      }

      //System.Assert(msgFound);
      
      test.startTest();
      Agr.Expiration_Reason__c='Test';
      PageReference pg=controller.Expire();
      msgFound = false;
      for(Apexpages.Message msg : ApexPages.getMessages())
      {
            if (msg.getDetail() == controller.MSG_ERROR) msgFound = true;

      }
      
      test.stopTest();
      Apttus__APTS_Agreement__c ResAgr=[select id,Apttus__Status__c,Apttus__Status_Category__c,Expiration_Reason__c from Apttus__APTS_Agreement__c where name='Test Agreement' limit 1]; 
      System.AssertEquals(ResAgr.Apttus__Status__c,'Expired');
      System.AssertEquals(ResAgr.Apttus__Status_Category__c,'Expired');
      System.AssertEquals(ResAgr.Expiration_Reason__c,'Test');
      
      List<Task> At=new List<Task>([select id from Task where WhatId= :ResAgr.id]);
      System.AssertEquals(At.size(),1);
      
      PageReference pr=new PageReference('/'+ResAgr.id); 
      System.assertEquals(pr.getURL(),pg.getURL());
      }
    
      }