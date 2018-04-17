/*
 Type Name: ClsProductServicesTest
 Author: Cognizant Technology Solutions
 Created Date: 30-May-2013
 Reason: This is the test class for 'ClsProductServices' class.
 Change History:
 Author: 
 Modified Date: 
 Reason: 
 …….. 
 ……..
    Nbustillos       10122013    - Added call to loadEnvironmentVariables() method.
    ARoy             06192014    - Modified to add Proposal changes.
    Ashwini          04132015    - Updated code for making SeeAllData=false and refactoring of test class.
  Amrita Agarwala  Sprint 4    - Added test method.
*/


@isTest(SeeAllData=false)
private class ClsProductServicesTest 
{
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
    
    /**
        This method helps to test the PortalTabAccess record List for Product Services to check its all elements are set as 'True'
        and test the Page Redirection phase.
        
        @method name: testClsProductServices
       
     */
     
    static testmethod void testClsProductServices()
    {
        // Load Environment Variables   
        //DataUtilTest.loadEnvironmentVariables();
        
            Profile profileObj = [Select Name,Id from Profile where Name = 'Customer Portal Admin'];
            User userObj = new User();
            Account acctObj = getAccount('MYTEST ACCOUNT1');
            Contact conobj=new Contact();
            Portal_Tab_Access__c portaltabObj = new Portal_Tab_Access__c();
            
            User accoutOwner = [select Id from User where Profile.Name ='GF Sales User' and isActive = true and UserRoleId != null limit 1];
            
            
            
            
            conobj.FirstName='Mr';
            conobj.LastName='Testcon1';
            conobj.AccountId=acctObj.Id;
            conobj.Email='con1@gf.com';
            conobj.Department__c='Design';
                                      
            insert conobj;
            
            
            userObj.Alias = 'Shyam';
            userObj.Email='shyam@test.com'; 
            userObj.EmailEncodingKey='UTF-8'; 
            userObj.LastName='Paul';
            userObj.LanguageLocaleKey='en_US'; 
            userObj.LocaleSidKey='en_US';
            userObj.ProfileId = profileObj.Id;
            userObj.TimeZoneSidKey='America/Los_Angeles'; 
            userObj.UserName='shyam@test.com';
            userObj.Portal_Login__c = 'xyz';
            userObj.contactId = conobj.Id;
            userObj.IsActive = true;
            TriggerHandler.bypass('User_TriggerHandler');            
            insert userObj;
            
            Test.startTest();
            portaltabObj.User__c = userObj.Id;
            portaltabObj.Account__c = acctObj.Id;
             
            
            portaltabObj.X3rd_Party_IP__c = true;
            portaltabObj.Turnkey__c = true;
            portaltabObj.Services__c = true; 
            portaltabObj.Process_Technology__c = true; 
            portaltabObj.Process_ID__c = true; 
            portaltabObj.Price_List__c = true; 
            portaltabObj.MPW__c = true;
            portaltabObj.IP__c = true; 
            portaltabObj.Design_Enablement__c = true; 
            portaltabObj.Configurator__c = true; 
                        
         
             try{
             insert portaltabObj;
            }catch(Exception e) {
              System.debug('The following exception has occurred: ' + e.getMessage());
           }
                
        
            
            System.runAs(userObj)
            {
            
                
                ClsProductServices  clsProductServicesObj = new ClsProductServices ();
                clsProductServicesObj.Page = 'configurator';  
                clsProductServicesObj.redirect();  
                clsProductServicesObj.Page = 'SecondSourceTapeout';  
                clsProductServicesObj.redirect();               
                //Added by AR on 6/18/2014 : Proposal 
                //****************************************************************************// 
                clsProductServicesObj.Page = 'Proposals';   
                clsProductServicesObj.redirect();  
                //****************************************************************************//
                clsProductServicesObj.Page = 'design';  
                clsProductServicesObj.redirect();
                clsProductServicesObj.Page = 'processtech';  
                clsProductServicesObj.redirect();
                clsProductServicesObj.Page = 'processid';  
                clsProductServicesObj.redirect();
                clsProductServicesObj.Page = 'ip';  
                clsProductServicesObj.redirect();
                clsProductServicesObj.Page = 'partyip';  
                clsProductServicesObj.redirect();
                clsProductServicesObj.Page = 'pricelist';  
                clsProductServicesObj.redirect();
                clsProductServicesObj.Page = 'mpw';  
                clsProductServicesObj.redirect();
                clsProductServicesObj.Page = 'turnkey';  
                clsProductServicesObj.redirect();
                clsProductServicesObj.Page = 'services';  
                clsProductServicesObj.redirect();
                clsProductServicesObj.Page = 'procedure';  
                clsProductServicesObj.redirect();
                clsProductServicesObj.Page = 'ETS';  
                clsProductServicesObj.redirect();
                clsProductServicesObj.Page = 'processFMEA';  
                clsProductServicesObj.redirect();
                clsProductServicesObj.Page = 'technicalspec';  
                clsProductServicesObj.redirect();
                clsProductServicesObj.Page = 'otherspec';  
                clsProductServicesObj.redirect();
                clsProductServicesObj.Page = 'reticlegrad';  
                clsProductServicesObj.redirect();
                clsProductServicesObj.Page = 'materialspec';  
                clsProductServicesObj.redirect();
                clsProductServicesObj.Page = 'processspec';  
                clsProductServicesObj.redirect();
                clsProductServicesObj.Page = 'car';  
                clsProductServicesObj.redirect();
                clsProductServicesObj.Page = 'rma';  
                clsProductServicesObj.redirect();
                clsProductServicesObj.Page = 'wafercompliance';  
                clsProductServicesObj.redirect();
                clsProductServicesObj.Page = 'myMPW';  
                clsProductServicesObj.redirect();
                clsProductServicesObj.Page = 'tools';  
                clsProductServicesObj.redirect();
                clsProductServicesObj.Page = 'validator';  
                clsProductServicesObj.redirect();
                clsProductServicesObj.Page = 'yieldcalc';  
                clsProductServicesObj.redirect();
        
         clsProductServicesObj.Page = 'FeatureDescriptionSearch';  
                clsProductServicesObj.redirect();
                 clsProductServicesObj.Page = 'prductservicesLink';  
                clsProductServicesObj.redirect();
        clsProductServicesObj.Page = 'PCNEndOfLife';  
                clsProductServicesObj.redirect();
        clsProductServicesObj.Page = 'pcneol';  
                clsProductServicesObj.redirect();
        clsProductServicesObj.Page = 'viewallpcneol';  
                clsProductServicesObj.redirect();
                  
              //  System.assertEquals(true, clsProductServicesObj.showTurnkey);    
            }   
            Test.stopTest();                          
    }
    
     /**
        This method helps to test the PortalTabAccess record List for Product Services to check its all elements are set as 'False'.
        
        
        @method name: testClsProductServicesPTA
       
     */
     
    static testmethod void testClsProductServicesPTA()
    {
        // Load Environment Variables   
        //DataUtilTest.loadEnvironmentVariables();
        
            Profile profileObj = [Select Name,Id from Profile where Name = 'Customer Portal Admin'];
            User userObj = new User();
            Account acctObj = getAccount('MYTEST ACCOUNT1');
            Contact conobj=new Contact();
            Portal_Tab_Access__c portaltabObj = new Portal_Tab_Access__c();
            
            User accoutOwner = [select Id from User where Profile.Name ='GF Sales User' and isActive = true and UserRoleId != null limit 1];
            
            
            
            conobj.FirstName='Mr';
            conobj.LastName='Testcon12';
            conobj.AccountId=acctObj.Id;
            conobj.Email='con1@gf.com';
            conobj.Department__c='Design';
                                      
            insert conobj;
            
            
            userObj.Alias = 'John1206';
            userObj.Email='John1206@test.com'; 
            userObj.EmailEncodingKey='UTF-8'; 
            userObj.LastName='Paul';
            userObj.LanguageLocaleKey='en_US'; 
            userObj.LocaleSidKey='en_US';
            userObj.ProfileId = profileObj.Id;
            userObj.TimeZoneSidKey='America/Los_Angeles'; 
            userObj.UserName='John1206@test.com';
            userObj.Portal_Login__c = 'xyz1206';
            userObj.contactId = conobj.Id;
            userObj.IsActive = true;
            TriggerHandler.bypass('User_TriggerHandler');            
            insert userObj;
            
            Test.startTest();
            portaltabObj.User__c = userObj.Id;
            portaltabObj.Account__c = acctObj.Id;
             
            
            portaltabObj.X3rd_Party_IP__c = false;
            portaltabObj.Turnkey__c = false;
            portaltabObj.Services__c = false; 
            portaltabObj.Process_Technology__c = false; 
            portaltabObj.Process_ID__c = false; 
            portaltabObj.Price_List__c = false; 
            portaltabObj.MPW__c = false;
            portaltabObj.IP__c = false; 
            portaltabObj.Design_Enablement__c = false; 
            portaltabObj.Configurator__c = false; 
            
      portaltabObj.tools__c = true;
      portaltabObj.yield_calculator__c = true;
      portaltabObj.second_source_tapeout__c = true;
      //portaltabObj.PCN_End_of_Life__c = true;
      portaltabObj.Procedure__c = true;            
         
            try{
             insert portaltabObj;
           }catch(Exception e) {
              System.debug('The following exception has occurred: ' + e.getMessage());
           }
                        
            
            System.runAs(userObj)
            {
            
                
                ClsProductServices  clsProductServicesObj = new ClsProductServices ();
                   
                //System.assertEquals(false, clsProductServicesObj.showdesignEnablement); 
                ClsProductServices.checkLicense();
                ClsProductServices.sendEmail('GlobalfoundryView');                
            }  
            Test.stopTest();                          
    }
    
    static testmethod void testSendEmail(){
      
      Test.startTest();
      Integer emailbefore = Limits.getEmailInvocations();
        
      Apexpages.currentPage().getHeaders().put('Referer', 'GlobalfoundryView');
      ClsProductServices.sendEmail(URL.getCurrentRequestUrl().toExternalForm());
      system.assertEquals(emailbefore,Limits.getEmailInvocations(),'should have decreased');
      Test.stopTest();
    }
    
     private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }

}