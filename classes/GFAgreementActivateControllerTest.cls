/*
*   Author: Suvajit Majumder
*   Description:  This is the test class for GFAgreementActivateController Class.
*   History: 
*   suvajit:   29/02/2016    - Apex code created
    DBiswal    02152018        Changes for SOQL issue and code coverage.
*/
@isTest
public class GFAgreementActivateControllerTest
{
   @testsetup  
   public static void TestSetupMethod()
   {
       TriggerHandler.bypass('Account_TriggerHandler');
       TriggerHandler.bypass('FeedItemHandler');
       List<SObject> SobjList=new List<SObject>();
       AgreementTestDataFactory.loaddefaults();
       Account acct=AgreementTestDataFactory.GenerateAccount(NULL,'MYTEST ACCOUNT');
       insert acct;    
       
       Environment_Variable__c env = [select id,name,value__c from Environment_Variable__c where name='HCM Emp AccountId'];
       env.value__c=acct.Id;
       update env;
          
       Contact con=AgreementTestDataFactory.GenerateContact(NULL,'test','test',acct);
       SobjList.add(con);
       
       
       Apttus__APTS_Agreement__c Agr=AgreementTestDataFactory.GenerateAgreement('GENERAL_2_Party_NDA','Test Agreement for Activation',acct);
       SobjList.add(Agr);
       
       SobjList.add(AgreementTestDataFactory.GenerateHCMID('Test','Test',6));
       
       insert SobjList;
       SobjList.clear();
       
       SobjList.add(AgreementTestDataFactory.GenerateAttachment(5347737,'Test Attachment of more than 5 MB',Agr.id));
       SobjList.add(AgreementTestDataFactory.GenerateAttachment(514288, 'Test Attachment of less than 5 MB',Agr.id));
       
       FeedItem post=AgreementTestDataFactory.GenerateFeedWithAttachment(100,Agr.id);
       SobjList.add(post);
       
       SobjList.add(AgreementTestDataFactory.GenerateNote(25,'Test Note',Agr.id,False));
       
       Document d=AgreementTestDataFactory.GenerateDocument('Test Document');
       SobjList.add(d);
       
       GoogleDoc gd = new GoogleDoc(Name='test googledoc', ParentId=Agr.id, Url='https://docs.google.com/document/d/1zi2fai0n2lgEL3OVh5VT0jOA_9Wjv_sc-wMmOM2CIIg');
       SobjList.add(gd);
       
       test.startTest();
       
       insert SobjList;
       SobjList.clear();
       
       Apttus__Agreement_Document__c agrDoc=AgreementTestDataFactory.GenerateAgrDocRecord(d,Agr);
     
       SobjList.add(agrDoc);
       insert SobjList;
       SobjList.clear();
       
       AgreementTestDataFactory.GenerateDocinLibrary('Apttus Library',250,'Test',Agr.id);
       test.stopTest();
   }
   
   
   
   
   public static testMethod void TestInitialisation() 
   {
       PageReference pageRef = Page.GF_AgreementActivate;
       Test.setCurrentPage(pageRef);
       test.startTest();
       Apttus__APTS_Agreement__c agr=[select id from Apttus__APTS_Agreement__c where name='Test Agreement for Activation' limit 1]; 
       ApexPages.currentPage().getParameters().put('Id', agr.id);
       GFAgreementActivateController controller = new GFAgreementActivateController();
       
       System.assertEquals(controller.objAgr.id,agr.id);
       
       ApexPages.currentPage().getParameters().put('Id', NULL);
       try
       {
           controller.init();
       }catch(Exception e)
       {
        {System.Assert(e.getMessage().contains('Please run the page with an associated valid Agreement Id.'));}
       }
     test.stopTest();
   }   
    public static testMethod void TestOptions()
    {
       PageReference pageRef = Page.GF_AgreementActivate;
       Test.setCurrentPage(pageRef);
       test.startTest();
       Apttus__APTS_Agreement__c agr=[select id from Apttus__APTS_Agreement__c where name='Test Agreement for Activation' limit 1]; 
       ApexPages.currentPage().getParameters().put('Id', agr.id);
       GFAgreementActivateController controller = new GFAgreementActivateController();
              
       List<SelectOption> options=controller.getItems1();
       System.assertEquals(7,options.size());
       
       Boolean f=controller.gethasAvailableDocItems();
       System.assertEquals(True,f);
       test.stopTest();
    }
    
    public static testMethod void TestCancel()
    {
       PageReference pageRef = Page.GF_AgreementActivate;
       Test.setCurrentPage(pageRef);
       test.startTest();
       Apttus__APTS_Agreement__c agr=[select id from Apttus__APTS_Agreement__c where name='Test Agreement for Activation' limit 1]; 
       ApexPages.currentPage().getParameters().put('Id', agr.id);
       GFAgreementActivateController controller = new GFAgreementActivateController();
       
       System.assertEquals(new PageReference('/'+agr.id).getURL(),controller.returnToAgr().getURL());
       test.stopTest();
    }
    
    
    
    public static testMethod void TestUserAccess()
    {
       PageReference pageRef = Page.GF_AgreementActivate;
       Test.setCurrentPage(pageRef);
       test.startTest();
       Apttus__APTS_Agreement__c agr=[select id from Apttus__APTS_Agreement__c where name='Test Agreement for Activation' limit 1]; 
       ApexPages.currentPage().getParameters().put('Id', agr.id);
       GFAgreementActivateController controller = new GFAgreementActivateController();
       
       PageReference pg=controller.AddUsertoGroupForLibraryAccess();
       System.assertEquals(True,controller.AccessGranted);
       
       HCM_Employee__c hcmid=[select id,Employee_ID__c from HCM_Employee__c limit 1];
       
       Profile p = [SELECT Id FROM Profile WHERE Name='Chatter Free User']; 
        User u = new User(Alias = 'standt', Email='chatterusr@gf.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='chatterusr@gf.com',isActive=True,FederationIdentifier=hcmid.Employee_ID__c);

              
              System.runAs(u)
              {
                try
                {
                
                pg=controller.AddUsertoGroupForLibraryAccess();
                
                }catch(Exception e)
                {
                    System.assertEquals(False,controller.AccessGranted);
                    System.Assert(e.getMessage().contains('Error in getting access to library:-'));
                }
              }
                              
      test.stopTest(); 
    }
    
    public static testmethod void TestUpdateStatus()
    {
       PageReference pageRef = Page.GF_AgreementActivate;
       Test.setCurrentPage(pageRef);
       Test.startTest();
       Apttus__APTS_Agreement__c agr=[select id from Apttus__APTS_Agreement__c where name='Test Agreement for Activation' limit 1]; 
       ApexPages.currentPage().getParameters().put('Id', agr.id);
       GFAgreementActivateController controller = new GFAgreementActivateController();
       
       controller.UpdateStatus();
       Test.stopTest();
       agr=[select id,Apttus__Status_Category__c,Apttus__Status__c from Apttus__APTS_Agreement__c where name='Test Agreement for Activation' limit 1]; 
       
       System.assertEquals('In Effect',agr.Apttus__Status_Category__c);
       System.assertEquals('Activated',agr.Apttus__Status__c);
       
    }
    
    public static testmethod void TestcreateAuditTask()
    {
       PageReference pageRef = Page.GF_AgreementActivate;
       Test.setCurrentPage(pageRef);
       
     Test.startTest();
       Apttus__APTS_Agreement__c agr=[select id from Apttus__APTS_Agreement__c where name='Test Agreement for Activation' limit 1]; 
       ApexPages.currentPage().getParameters().put('Id', agr.id);
       GFAgreementActivateController controller = new GFAgreementActivateController();
       
       controller.createAuditTask();
       Integer c=[select count() from Task where OwnerId= :UserInfo.getUserId() and Subject='Activated Agreement' and ActivityDate= :Date.today() and WhatId= :agr.id and Status='Completed' and Priority='Normal'];
       Test.stopTest();
       System.assertEquals(1,c);
    }
    
    
    public static testmethod void TestContentSearchMethod()
    {
       PageReference pageRef = Page.GF_AgreementActivate;
       Test.setCurrentPage(pageRef);
              
       test.startTest();
       Apttus__APTS_Agreement__c agr=[select id from Apttus__APTS_Agreement__c where name='Test Agreement for Activation' limit 1]; 
       ApexPages.currentPage().getParameters().put('Id', agr.id);
       GFAgreementActivateController controller = new GFAgreementActivateController();
       List<SelectOption> options=controller.getItems1();
       for(SelectOption so : options)
        controller.attchLst.add(so.getValue());
       
       controller.EnableContentSearch();
       test.stopTest();
       Integer c=[select count() from Apttus__Agreement_Document__c where Apttus__Agreement__c= :agr.id];
       System.assertEquals(7,c);
    }
    
    
    
    
    public static testmethod void TestActivateController()
    {
       PageReference pageRef = Page.GF_AgreementActivate;
       Test.setCurrentPage(pageRef);
       
       Apttus__APTS_Agreement__c agr=[select id from Apttus__APTS_Agreement__c where name='Test Agreement for Activation' limit 1]; 
       ApexPages.currentPage().getParameters().put('Id', agr.id);
       
       test.startTest();
       GFAgreementActivateController controller = new GFAgreementActivateController();
       List<SelectOption> options=controller.getItems1();
       List<String> emailids=new List<String>{'george.iwamura@globalfoundries.com'};
       for(SelectOption so : options)
        controller.attchLst.add(so.getValue());      
       
       controller.doActivate(); 
       test.stopTest();
       System.assertEquals(True,controller.isSuccessOp);
   } 
       
       
       public static testmethod void TestgetUserAccess()
       {
       PageReference pageRef = Page.GF_AgreementActivate;
       Test.setCurrentPage(pageRef);
     
       test.startTest();
       Apttus__APTS_Agreement__c agr=[select id from Apttus__APTS_Agreement__c where name='Test Agreement for Activation' limit 1]; 
       ApexPages.currentPage().getParameters().put('Id', agr.id);
       GFAgreementActivateController controller = new GFAgreementActivateController();
       
       controller.getUserAccess();
       GFAgreementActivateController controller2 = new GFAgreementActivateController(agr);
       test.stopTest();
       
       }
       
    
     public static testmethod void TestFutureMailSender()
     {
         PageReference pageRef = Page.GF_AgreementActivate;
         Test.setCurrentPage(pageRef);
         
         test.startTest();    
          Apttus__APTS_Agreement__c agr=[select id from Apttus__APTS_Agreement__c where name='Test Agreement for Activation' limit 1]; 
         
          ContentVersion testContent = [SELECT ContentDocumentId FROM ContentVersion limit 1];
          FeedItem p=[select id from FeedItem limit 1];
          Apttus__Agreement_Document__c agrDoc=new Apttus__Agreement_Document__c();  
          agrDoc=AgreementTestDataFactory.GenerateAgrDocRecord(testContent,agr);
          agrDoc.Apttus__Comments__c=p.id;
          insert agrDoc;
          
         List<String> emailids=new List<String>{'george.iwamura@globalfoundries.com'};
         GFAgreementActivateController.sendMailOnActivation(emailids,agr.id);
         test.stopTest();
         
     }
     
     public static testmethod void TestExceptions()
     {
         test.startTest();
         Apttus__APTS_Agreement__c agr=[select id from Apttus__APTS_Agreement__c where name='Test Agreement for Activation' limit 1];         
         ContentVersion testContent = [SELECT ContentDocumentId FROM ContentVersion limit 1];
         Apttus__Agreement_Document__c agrDoc=new Apttus__Agreement_Document__c();  
         agrDoc=AgreementTestDataFactory.GenerateAgrDocRecord(testContent,agr);
         insert agrDoc;
         
         PageReference pageRef = Page.GF_AgreementActivate;
         Test.setCurrentPage(pageRef);
         try{
             GFAgreementActivateController controller = new GFAgreementActivateController();
             controller.doActivate();
         }catch(Exception e){
         }
         test.stopTest();
     }
    
    public static testmethod void TestMethodOthers()
    {
            PageReference pageRef = Page.GF_AgreementActivate;
            Test.setCurrentPage(pageRef);
            test.startTest();
            Apttus__APTS_Agreement__c agr=[select id from Apttus__APTS_Agreement__c where name='Test Agreement for Activation' limit 1]; 
            ApexPages.currentPage().getParameters().put('Id', agr.id);
            GFAgreementActivateController controller = new GFAgreementActivateController();
            
            controller.getattchLst();
            controller.setattchLst(new List<String>{'abc'});
            controller.getErrorsPresent();
            test.stopTest();
            
    }
}