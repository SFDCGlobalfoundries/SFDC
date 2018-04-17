@isTest(SeeAllData=false)
public class ClsSupplierServiceTest{
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        
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

        AccountDataFactory.createAccount(fieldValueMap);
    }
    
    public static testMethod void testMyController() {
        PageReference pageRef = Page.VfSupplierService;
        Test.setCurrentPage(pageRef);
        ClsSupplierService clsSuppSerIns = new ClsSupplierService();
        clsSuppSerIns.Page = 'msqs';
        clsSuppSerIns.redirect();
        clsSuppSerIns.Page = 'ses';
        clsSuppSerIns.redirect();
        clsSuppSerIns.Page = 'pra';
        clsSuppSerIns.redirect();
        clsSuppSerIns.Page = 'shr';
        clsSuppSerIns.redirect();
        clsSuppSerIns.Page = 'tir';
        clsSuppSerIns.redirect();
        clsSuppSerIns.Page = 'wds';
        clsSuppSerIns.redirect();
        clsSuppSerIns.Page = 'proc';
        clsSuppSerIns.redirect();
        clsSuppSerIns.Page = 'sao';
        clsSuppSerIns.redirect();
        clsSuppSerIns.Page = 'ehs';
        clsSuppSerIns.redirect();

    // Running Supplier Service for Portal Users' context
    Account accntObj = getAccount('MYTEST ACCOUNT1');
    List<contact> lstCon=new list<contact>(); 
    lstCon.add(new Contact(FirstName='Mr',LastName='Testcon1',AccountId=accntObj.Id,Email='con1@gf.com',Department__c='Procurement')); 
    lstCon.add(new Contact(FirstName='Mr',LastName='Testcon1',AccountId=accntObj.Id,Email='con1@gf.com',Department__c='Procurement')); 
    insert lstCon;
          
    Profile profile1 = [Select Id from Profile where name = 'Supplier Portal Profile'];
    list<user> lstPortalUser = new list<user>();
    lstPortalUser.add( new User( ProfileId = profile1.Id,
                                                Username = 'portaluser@testorg.com.trwrfcv',
                                                Alias = 'rhdowqfh',
                                                Email='portaluser@testorg.com',
                                                EmailEncodingKey='UTF-8',
                                                Firstname='Bruce',
                                                Lastname='Wayne',
                                                LanguageLocaleKey='en_US',
                                                LocaleSidKey='en_US',
                                                TimeZoneSidKey='America/Chicago',
                                                ContactId=lstcon[0].id,
                                                Portal_Login__c='abc12345678'
                                               ));
                                               
     
     lstPortalUser.add( new User( ProfileId = profile1.Id,
                                                Username = 'portaluser@testorg.com.yroewr',
                                                Alias = 'dowheofh',
                                                Email='portaluser@testorg.com',
                                                EmailEncodingKey='UTF-8',
                                                Firstname='Bruce',
                                                Lastname='Wayne',
                                                LanguageLocaleKey='en_US',
                                                LocaleSidKey='en_US',
                                                TimeZoneSidKey='America/Chicago',
                                                ContactId=lstcon[1].id,
                                                Portal_Login__c='abc9405757553'
                                               ));
     test.startTest();
     insert   lstportalUser   ; 
     test.stopTest();
     list<portal_tab_access__c> lstPTA=new list<portal_tab_access__c>();
     lstPTA = [select id from portal_tab_access__c where user__c=:lstPortalUser[0].id limit 1];     
     if(lstpta!=null && lstPTA.size()>0){
         lstPTA[0].Material_Selection_Qualififcation__c=false;
         lstPTA[0].Procedure_Review_Acceptance__c=false;
         lstPTA[0].SQE_Applications_Overview__c=false;
         lstPTA[0].Supplier_eCOA_Submission__c=false;
         lstPTA[0].Supplier_Procedure__c=false;
         lstPTA[0].Turnkey_Incident_Report__c=false;
         lstPTA[0].Wafer_Disposition_System__c=false;
     }
     update lstPTA[0];
     system.runAs(lstportalUser[0]){
        ClsSupplierService clsSuppSerInsPU0 = new ClsSupplierService();
     }
     
     system.runAs(lstportalUser[1]){
        ClsSupplierService clsSuppSerInsPU0 = new ClsSupplierService();
     }
  }
  
  private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
    
  }