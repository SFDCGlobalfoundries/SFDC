/******************************************************************************************************************************
Class:         CPQViewPTIPDetailWithNDATest
-------------------------------------------------------------------------------------------------------------------------------
Author:        Joydev Mondol (Cognizant - 153480)
Created Date:  5/11/2013
Reason:        Test class for controller classes View_PT_IP_DetailsController
History:       06262014 AR: Modified Test Class for NDA Changes
               Updated by Sunil for case # 29898 on 18th sep, 2014. 
....
Ashwini     04132015    - Updated code for making SeeAllData=false and refactoring of test class.
*******************************************************************************************************************************/
               
@isTest(SeeAllData=false)
private class CPQViewPTIPDetailWithNDATest{
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        
        GFV_NDA_Account_Sync_Settings__c ab = new GFV_NDA_Account_Sync_Settings__c();
        ab.Name = 'ndaSyncApplicableTo';
        ab.Comment__c ='Delimiter is new Line. Format : Status Category->Status. Don\'t leave spaces in the end';
        ab.Value__c = 'In Effect->Activated In Effect->Being Amended';
        Insert ab;
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MYTEST ACCOUNT223322');            
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
        fieldValueMap.put('Has_Valid_NDA__c',true);
        fieldValueMap.put('Tech_Geo_Granted__c','0.11UM;0.13UM;0.14UM;0.152UM;0.153UM');
        fieldValueMap.put('Valid_Tech_Geos__c','0.15UM;0.16UM;0.18UM;0.060UM;0.20UM;0.032UM;0.040UM;0.045UM;0.055UM;0.70UM;0.010UM;0.014UM;0.40 UM;0.17UM');
        
        
        Profile pp = [Select Id from Profile where Name='System Administrator']; 
        User ur = [Select Id, Name,IsActive from User where IsActive=true AND userRoleId != null and ContactId = null and ProfileID=:pp.Id Limit 1];
        
        system.runAs(ur){
            AccountDataFactory.createAccount(fieldValueMap);
        }
        
    }  
    
    static void updaterole(){
       UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
       User objUser=new User(Id=UserInfo.getUserId(),UserRoleId=portalRole.id);
       update objUser;
    }  
    static testMethod void testNewIPRequestRedirect(){
        //DataUtilTest.loadEnvironmentVariables();
        //if(Userinfo.getUserRoleId()==null){
        //  updaterole();
        //}
        Test.startTest();
        PageReference pageRef = Page.NewIPRequestRedirect;
        
        Test.setCurrentPage(pageRef);
        
        NewIPRequestRedirectController NewIPRequestRedirectCon = new NewIPRequestRedirectController();   
        NewIPRequestRedirectCon.redirect();    
        Test.stopTest();
    }
    
    static testMethod void testViewPTDetail(){
        //DataUtilTest.loadEnvironmentVariables();
        //Setup the PT test record for the the page to render
        Base_Ip__c ip = createIP();
        Process_Technology__c pt = createProcessTechnology();
        IP_PT_Map__c ipptmap = createIPPTMap(ip.Id, pt.Id);
        
        Account acc = getAccount('MYTEST ACCOUNT223322');        
        
        Apttus__APTS_Agreement__c nda = createAgreement(acc.Id);
                                             
        Test.startTest();
        PageReference pageRef = Page.View_PT_IP_Details;
        
        Test.setCurrentPage(pageRef);
        
        ApexPages.CurrentPage().getParameters().put('Entity', 'PT');
        ApexPages.CurrentPage().getParameters().put('Id', pt.Id);
        
        View_PT_IP_DetailsController ViewPTDetailController = new View_PT_IP_DetailsController();       
        Test.stopTest();
    }
    
    static testMethod void testViewPTDetailByXUser(){
        //DataUtilTest.loadEnvironmentVariables();
        //Setup the PT test record for the the page to render
        Base_Ip__c ip = createIP();
        Process_Technology__c pt = createProcessTechnology();
        IP_PT_Map__c ipptmap = createIPPTMap(ip.Id, pt.Id);
        Account acc = getAccount('MYTEST ACCOUNT223322');
       
        Apttus__APTS_Agreement__c nda = createAgreement(acc.Id);
        
            
        Test.startTest();
        User xUser = createXUser(acc.Id);
        
        system.runas(xUser){
            
            PageReference pageRef = Page.View_PT_IP_Details;
            
            Test.setCurrentPage(pageRef);
            
            ApexPages.CurrentPage().getParameters().put('Entity', 'PT');
            ApexPages.CurrentPage().getParameters().put('Id', pt.Id);
            
            View_PT_IP_DetailsController ViewPTDetailController = new View_PT_IP_DetailsController();
        }
        Test.stopTest();
    }
    
    static testMethod void testViewIPDetail(){
        //DataUtilTest.loadEnvironmentVariables();
        //Setup the IP test record for the the page to render
        Base_Ip__c ip = createIP();
        Process_Technology__c pt = createProcessTechnology();
        Ip__c ipdk = createIPDesignKit(ip.Id);
        IP_Merge__c ipmdk = createIPMergedDesignKit(ip.Id);
        IP_PT_Map__c ipptmap = createIPPTMap(ip.Id, pt.Id);
        
        Test.startTest();
        PageReference pageRef = Page.View_PT_IP_Details;
        
        Test.setCurrentPage(pageRef);
        
        ApexPages.CurrentPage().getParameters().put('Entity', 'IP');
        ApexPages.CurrentPage().getParameters().put('Id', ip.Id);
        
        View_PT_IP_DetailsController ViewPTDetailController = new View_PT_IP_DetailsController();       
        Test.stopTest();
    }
    
    static testMethod void testViewIPDetailByXUser(){
        //DataUtilTest.loadEnvironmentVariables();
        //Setup the IP test record for the the page to render
        Base_Ip__c ip = createIP();
        Process_Technology__c pt = createProcessTechnology();
        Ip__c ipdk = createIPDesignKit(ip.Id);
        IP_Merge__c ipmdk = createIPMergedDesignKit(ip.Id);
        IP_PT_Map__c ipptmap = createIPPTMap(ip.Id, pt.Id);
        
        
        Account acc = getAccount('MYTEST ACCOUNT223322');
        Apttus__APTS_Agreement__c agrmnt = createAgreement(acc.Id);
        Test.startTest();
        User xUser = createXUser(acc.Id);
        
        system.runas(xUser){
            
            PageReference pageRef = Page.View_PT_IP_Details;
            
            Test.setCurrentPage(pageRef);
            
            ApexPages.CurrentPage().getParameters().put('Entity', 'IP');
            ApexPages.CurrentPage().getParameters().put('Id', ip.Id);
            
            View_PT_IP_DetailsController ViewPTDetailController = new View_PT_IP_DetailsController();
        }
        Test.stopTest();
    }
    
    //Static method to create External User test record
    static User createXUser(Id accId){
        Profile prf = [Select Id, 
                              Name 
                         From Profile 
                        Where Name = 'Customer Portal Admin'];
                        
        Contact cnct = createContact(accId);
        
        User xUser = new User(alias = 'standt',
                                email='standarduser@testorg.com',
                                emailencodingkey='UTF-8',
                                lastname='Testing', 
                                languagelocalekey='en_US',
                                localesidkey='en_US',
                                profileid = prf.Id,
                                ContactId = cnct.Id,
                                Portal_Login__c = 'TestLogin0001',
                                timezonesidkey='America/Los_Angeles',
                                username='standarduser@testorg.com');
        
        insert xUser;
        return xUser;
    }
    
    //Static method to create External User Contact test record
    //Department populated by Sunil Arora for case # 29898
    static Contact createContact(Id accId){
        Contact cnct = new Contact(email='standarduser@testorg.com',
                                    lastname='Testing',Role__c='Customers My Device Admin',
                                    FirstName = 'Testing',
                                    Department__c='Design',
                                    AccountId = accId);
        
        insert cnct;
        return cnct;
    }        
    
    //Static method to create Account test record
    static Process_Technology__c createProcessTechnology(){
        Process_Technology__c pt = new Process_Technology__c(Name = 'Test PT',
                                                             Tech_Geometry__c = '0.20UM,0.153UM');
        
        insert pt;
        return pt;
    }
    
    //Static method to create Account test record
    static Base_Ip__c createIP(){
        Base_Ip__c ip = new Base_Ip__c(Name = 'Test IP',
                                       IP_Number__c = 'TESTIP00001',
                                       Geometry__c = '200nm');
        
        insert ip;
        return ip;
    }
    
    //Static method to create Account test record
    static Ip__c createIPDesignKit(Id ipId){
        Ip__c ipdk = new Ip__c(Name = 'Test IP DK',
                               IPNumber__c = ipId);
        
        insert ipdk;
        return ipdk;
    }
    
    //Static method to create Account test record
    static IP_Merge__c createIPMergedDesignKit(Id ipId){
        IP_Merge__c ipmdk = new IP_Merge__c(Name = 'Test IP MDK',
                                            IPNumber__c = ipId);
        
        insert ipmdk;
        return ipmdk;
    }
    
    //Static method to create Account test record
    static IP_PT_Map__c createIPPTMap(Id ipId, Id ptId){
        IP_PT_Map__c ipmdk = new IP_PT_Map__c(IPNumber__c = ipId,
                                              PT_Number__c = ptId);
        
        insert ipmdk;
        return ipmdk;
    }
    
    //Static method to create Attribute test record
    static Apttus__APTS_Agreement__c createAgreement(Id accId){
        //Create a proposal line item
        Apttus__APTS_Agreement__c agrmnt = new Apttus__APTS_Agreement__c(Apttus__Account__c = accId,
                                                                         Name = 'Test Agreement',
                                                                         Geometries__c = '0.20UM,0.153UM',
                                                                         Apttus__Status_Category__c = 'In Effect',
                                                                         Apttus__Contract_End_Date__c = Date.Today(),
                                                                         Apttus__Requestor__c = UserInfo.getUserId(),
                                                                         GF_Contract_End_Date__c = Date.today().addDays(10));
        
        insert agrmnt;
        return agrmnt;
    }
    
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
}