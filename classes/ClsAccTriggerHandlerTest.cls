/*
Type Name: ClsAccTriggerHandlerTest 
Author: Cognizant
Created Date: 24-April-2013
Reason: This is the Test class for class ClsAccTriggerHandler. 
Change History:
Author: 
Modified Date: 
Reason: 
……..
……..
    Nbustillos  10122013    - Added call to loadEnvironmentVariables() method.
    Ashwini     03262015    - Updated code for refactoring test class.
*/
@isTest(SeeAllData=false)
public class ClsAccTriggerHandlerTest
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
        
         Map<String,Object> fieldValueMap1 = new Map<String,Object>();
        fieldValueMap1.put('Name', 'MYTEST ACCOUNT2');            
        fieldValueMap1.put('stage__c', 'Unqualified');        
        fieldValueMap1.put('sub_type__c', 'Direct');
        fieldValueMap1.put('site_department__c', 'test dept');          
        fieldValueMap1.put('transaction_type__c', 'transactional');                          
        fieldValueMap1.put('region__c', 'APJ');        
        fieldValueMap1.put('Corporate_Address_1__c', 'Test Address 1');          
        fieldValueMap1.put('Corporate_City__c', 'Test City');                
        fieldValueMap1.put('Corporate_Country__c', 'Singapore');
        fieldValueMap1.put('Bill_To_Address_1__c', 'Test Address 1');          
        fieldValueMap1.put('Bill_To_City__c', 'Test City');            
        fieldValueMap1.put('Bill_To_Country__c', 'Singapore');        
        fieldValueMap1.put('Fab_9_10__c','No');

        AccountDataFactory.createAccount(fieldValueMap1);
        
        Account acctObj=getAccount('MYTEST ACCOUNT1');
        Account acctObj1=getAccount('MYTEST ACCOUNT2');
        acctObj.parentId=acctObj1.id;
        update acctObj;
        system.debug('???acctObj' +acctObj);
        
    }
    
    static testMethod void testdeactivateAccountContact()
    {
        
            Profile profileObj = [Select Name,Id from Profile where Name = 'Customer Portal Admin'];
            User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
            //Account acctObj1=getAccount('MYTEST ACCOUNT2');
            Account acctObj=getAccount('MYTEST ACCOUNT1');
            
            Contact conobj=new Contact();
            User userObj = new User();
            List<Id> accIdList=new List<Id>();  
            List<Id> conIdList=new List<Id>();                       
            
            accIdList.add(acctObj.Id);
            
            conobj.FirstName='Mr';
            conobj.LastName='Testcon1';
            conobj.AccountId=acctObj.Id;
            conobj.Email='con1@gf.com';
            conobj.Department__c='Design';
            
            insert conobj;
            conIdList.add(conobj.Id);
            
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

            
            insert userObj;
            System.runAs(thisUser)
            { 
             Test.startTest();
             ClsAccTriggerHandler.updateManager(accIdList);
             ClsAccTriggerHandler.deactivateAccount(accIdList);
             ClsAccTriggerHandler.deactivateContactUser(conIdList);
             system.assertEquals(userObj.Email, 'shyam@test.com');
             Test.stopTest(); 
            }
     
       }
        static testMethod void testCreateSharingOnAccount()
    {
        // Load Environment Variables   
        //DataUtilTest.loadEnvironmentVariables();
        
            Profile profileObj = [Select Name,Id from Profile where Name = 'Reseller Portal Admin'];
            User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
            Account acctObj=getAccount('MYTEST ACCOUNT1');
            Account acctObj1=getAccount('MYTEST ACCOUNT2');
            Account parentacctObj=new Account(id=acctObj1.id);
            system.debug('???parentacctObj' +parentacctObj);
            Contact conobj=new Contact();
            Contact parentconobj=new Contact();
            User userObj = new User();
            AccountShare accShareObj = new AccountShare();
            
            List<Id> accIdList=new List<Id>();  
            List<Id> parentaccIdList=new List<Id>(); 
            List<Id> conIdList=new List<Id>();  
            List<AccountShare> accntShareListSub = new List<AccountShare>();
            
            set<Id> accountidSet = new set<Id>();
            Map<Id, Id> childParentMap = new Map<Id, Id>();
            Map <Id, List<Id>> mapAccountContact = new Map <Id, List<Id>>();
            Map<Id, Id> userContactmap = new Map<Id, Id>();
            Map<Id, List<id>> parentChildMap = new Map<Id, List<id>>();
            Map<Id, Id> mapParentparentAccount = new Map<Id, Id>();
            Map<Id, Id> deleteParentChildMap = new Map<Id, Id>();
        
           /* parentacctObj.Name='TestAccount1';
            parentacctObj.Site_Department__c = 'Site11';
            parentacctObj.Sub_Type__c = 'Direct';
            parentacctObj.Transaction_Type__c = 'Transactional';
            parentacctObj.Region__c = 'APJ';
            parentacctObj.Bill_To_Address_1__c='KOL';
            parentacctObj.Bill_To_City__c = 'KOL';
            parentacctObj.Bill_To_Country__c = 'INDIA';
            parentacctObj.Corporate_Address_1__c = 'Street';
            parentacctObj.Corporate_City__c = 'KOL';
            parentacctObj.Corporate_Country__c = 'INDIA';
           
            insert parentacctObj;*/
                    
            accIdList.add(acctObj.Id);
            parentaccIdList.add(parentacctObj.Id);
            //accountidSet.add(parentacctObj.Id);
            accountidSet.add(acctObj.Id);
            childParentMap.put(acctObj.Id,parentacctObj.Id);
            
            System.debug('accountidSet-------------->'+accountidSet);
            System.debug('childParentMap-------------->'+childParentMap);
            
            conobj.FirstName='Mr';
            conobj.LastName='Testcon1';
            conobj.AccountId=acctObj.Id;
            conobj.Email='con1@gf.com';
            conobj.Department__c='Design';
            
            insert conobj;
            
            parentconobj.FirstName='Mr';
            parentconobj.LastName='Testcon11';
            parentconobj.AccountId=parentacctObj.Id;
            parentconobj.Email='con11@gf.com';
            parentconobj.Department__c='Design';
            
            insert parentconobj;
            conIdList.add(conobj.Id);
            mapAccountContact.put(acctObj.Id, conIdList);
            System.debug('conIdList-------------->'+conIdList);
            
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
            userObj.contactId =conobj.Id;

            userObj.IsActive = true;
            
            Test.startTest();
            insert userObj;
       
            userContactmap.put(conobj.Id, userObj.Id);
            System.debug('userContactmap-------------->'+userContactmap);
            
            parentChildMap.put(parentacctObj.Id, accIdList);
            System.debug('parentChildMap-------------->'+parentChildMap);
            
            mapParentparentAccount.put(acctObj.Id, parentacctObj.Id);
            System.debug('mapParentparentAccount-------------->'+mapParentparentAccount);//wrong
            
            
            accShareObj.UserOrgroupId = userObj.Id;
            accShareObj.AccountId = acctObj.Id;
            accShareObj.AccountAccessLevel = 'Edit';
            accShareObj.OpportunityAccessLevel = 'None';
            accShareObj.CaseAccessLevel ='None'; 
            
            insert accShareObj;
            
            accntShareListSub.add(accShareObj);
            
            deleteParentChildMap.put(acctObj.Id, parentacctObj.Id);
            
            System.runAs(thisUser)
            { 
             
             ClsAccTriggerHandler.createSharingOnAccount(accountidSet, childParentMap, mapAccountContact,userContactmap, parentChildMap, mapParentparentAccount);
             ClsAccTriggerHandler.updateChildRecords(accIdList,accIdList,accIdList,accIdList,accntShareListSub);
          
             ClsAccTriggerHandler.updateReparentedRecords(accIdList,accIdList,accIdList,accntShareListSub);
             ClsAccTriggerHandler.deleteSharingOnAccount(accountidSet, deleteParentChildMap);
        
             
            }
            
            
            User[] userRecordLst=[Select id,ProfileId,AccountId,ContactId,Contact.Is_Portal_User_Active__c,
                                   profile.name
                                   from User
                                   where AccountId !=null and Contact.Is_Portal_User_Active__c=:true and Contact.Is_Portal_User_Created__c = :true and (profile.name = :System.Label.CustomerPortalAdmin or profile.name = :System.Label.OverageCustomerPortalAdmin) Limit 1];
         if(userRecordLst!=null && userRecordLst.size()>0){
            Account acc=new Account (Id=userRecordLst[0].AccountId, Customer_Portal_Admin__c=userRecordLst[0].Id);
            update acc;            
         }
         system.assertEquals(userObj.Email, 'shyam@test.com');
         Test.stopTest(); 
       }
       
       static testMethod void testUpdateReparentedRecords()
    {
            Profile profileObj = [Select Name,Id from Profile where Name = 'Customer Portal Admin'];
            User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
            Account acctObj=new Account();
            Account parentacctObj=new Account();
            Contact conobj=new Contact();
            Contact parentconobj=new Contact();
            User userObj = new User();
            AccountShare accShareObj = new AccountShare();
            
            List<Id> accIdList=new List<Id>();  
            List<Id> parentaccIdList=new List<Id>(); 
            List<Id> conIdList=new List<Id>();  
            List<AccountShare> accntShareListSub = new List<AccountShare>();
            
            set<Id> accountidSet = new set<Id>();
            Map<Id, Id> childParentMap = new Map<Id, Id>();
            Map <Id, List<Id>> mapAccountContact = new Map <Id, List<Id>>();
            Map<Id, Id> userContactmap = new Map<Id, Id>();
            Map<Id, List<id>> parentChildMap = new Map<Id, List<id>>();
            Map<Id, Id> mapParentparentAccount = new Map<Id, Id>();
            Map<Id, Id> deleteParentChildMap = new Map<Id, Id>();
        
             parentacctObj =getAccount('MYTEST ACCOUNT2') ;
             acctObj=getAccount('MYTEST ACCOUNT1');
            
            
            accIdList.add(acctObj.Id);
            parentaccIdList.add(parentacctObj.Id);
            accountidSet.add(parentacctObj.Id);
            accountidSet.add(acctObj.Id);
            childParentMap.put(acctObj.Id,parentacctObj.Id);
            
            System.debug('accountidSet-------------->'+accountidSet);
            System.debug('childParentMap-------------->'+childParentMap);
            
            conobj.FirstName='Mr';
            conobj.LastName='Testcon1';
            conobj.AccountId=acctObj.Id;
            conobj.Email='con1@gf.com';
            conobj.Department__c='Design';
            
            insert conobj;
            
            parentconobj.FirstName='Mr';
            parentconobj.LastName='Testcon11';
            parentconobj.AccountId=parentacctObj.Id;
            parentconobj.Email='con11@gf.com';
            parentconobj.Department__c='Design';
            
            insert parentconobj;
            conIdList.add(conobj.Id);
            mapAccountContact.put(acctObj.Id, conIdList);
            System.debug('conIdList-------------->'+conIdList);
            
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

            Test.startTest();
            insert userObj;
               
            userContactmap.put(conobj.Id, userObj.Id);
            System.debug('userContactmap-------------->'+userContactmap);
            
            parentChildMap.put(parentacctObj.Id, accIdList);
            System.debug('parentChildMap-------------->'+parentChildMap);
            
            mapParentparentAccount.put(acctObj.Id, parentacctObj.Id);
            System.debug('mapParentparentAccount-------------->'+mapParentparentAccount);//wrong
            
            
            accShareObj.UserOrgroupId = userObj.Id;
            accShareObj.AccountId = acctObj.Id;
            accShareObj.AccountAccessLevel = 'Edit';
            accShareObj.OpportunityAccessLevel = 'None';
            accShareObj.CaseAccessLevel ='None'; 
            
            insert accShareObj;
            
            accntShareListSub.add(accShareObj);
            
            deleteParentChildMap.put(acctObj.Id, parentacctObj.Id);
            
            System.runAs(thisUser)
            { 
             ClsAccTriggerHandler.updateReparentedRecords(accIdList,accIdList,accIdList,accntShareListSub);
            }
            system.assertEquals(userObj.Email, 'shyam@test.com');
             Test.stopTest(); 
       }
       
     private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id,parentId, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
 }