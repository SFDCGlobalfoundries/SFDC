/*
    Author: Yash Kumar
    Description: Test class for TabAccessCreatePageController
    History:
        Yash 11022013    - Code Creation.
       
            
*/


@isTest(SeeAllData=false)
public class TabAccessCreatePageControllerTest{

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
        fieldValueMap.put('RecordTypeId',Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId());
        AccountDataFactory.createAccount(fieldValueMap);
       
        Account acc= getAccount('Test Account 007'); 
        
/*--------------------added by cognizant on 6th march----------------------------------------------------------------------------*/        
        Contact conobj=new Contact(FirstName='Mr',LastName='Testcon1',AccountId=acc.Id,Email='con1@gf.com',Department__c='Design');
        insert conobj;
        Profile profile1 = [Select Id from Profile where name = 'Overage Customer Portal Admin'];
        User portalUser = new User( ProfileId = profile1.Id,
                                                Username = 'portaluser@testorg.com',
                                                Alias = 'auser',
                                                Email='portaluser@testorg.com',
                                                EmailEncodingKey='UTF-8',
                                                Firstname='Bruce',
                                                Lastname='Wayne',
                                                LanguageLocaleKey='en_US',
                                                LocaleSidKey='en_US',
                                                TimeZoneSidKey='America/Chicago',
                                                ContactId=conobj.Id
                                               );
                                               
        insert  portalUser ;  
        
        }
        
        public static testmethod void TestController()
        {

        List<Portal_Tab_Access__c > lstAccessTab=[select id ,account__r.recordtype.name from Portal_Tab_Access__c limit 1];
        
        Id AccessTabId = (Id)System.currentPageReference().getParameters().put('id',lstAccessTab[0].id);
       
       Test.startTest(); 
       ApexPages.StandardController controller = new ApexPages.StandardController(lstAccessTab[0]);
       Test.setCurrentPageReference(Page.TabAccessCreatePage);
       TabAccessCreatePageController dp = new TabAccessCreatePageController(controller);
       Boolean var=TabAccessCreatePageController.SupplierSection;
       var=TabAccessCreatePageController.NotSupplierSection;
       var=TabAccessCreatePageController.isVendorPortalUser;
       Id v=TabAccessCreatePageController.AccessId;
       Portal_Tab_Access__c ptarecord=TabAccessCreatePageController.PTARec;
       Test.stopTest();
   
   }
   
   public static testmethod void testGetters()
   {
       Boolean SupplierSection=TabAccessCreatePageController.SupplierSection;
       Boolean NotSupplierSection=TabAccessCreatePageController.NotSupplierSection;
       Boolean isVendorPortalUser=TabAccessCreatePageController.isVendorPortalUser;
       Id AccessID=TabAccessCreatePageController.AccessId;
       Portal_Tab_Access__c  PTAReec=TabAccessCreatePageController.PTARec;
   }
   
    private static Account getAccount(string AccountName)
            {
                Account acc= [SELECT Id, Name FROM Account Where Name =: AccountName];
        
                return acc;
            }  

}