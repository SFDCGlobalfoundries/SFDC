@isTest
public class ROS_ScrapCertificateViewTest{
   @testSetup static void testdata(){
        DataUtilTest.loadEnvironmentVariables();
 
         Map<String,Object> fieldValueMap = new Map<String,Object>();       
        fieldValueMap.put('Name', 'testing901');
        fieldValueMap.put('Stage__c', 'Unqualified');
        fieldValueMap.put('Short_Name__c', 'test725');
        fieldValueMap.put('Site_Department__c', 'cts.com');
        fieldValueMap.put('Account_Type__c', 'Customer');
        fieldValueMap.put('Organization_Unit__c', 'sg;us');
        fieldValueMap.put('Copy_Address__c', true);
        fieldValueMap.put('Corporate_Address_1__c', 'test');
        fieldValueMap.put('Corporate_City__c', 'sg');
        fieldValueMap.put('Corporate_Country__c', 'sg');        
        fieldValueMap.put('Financial_Territory__c', 'Greater China');
        fieldValueMap.put('Region__c', 'APJ');
        fieldValueMap.put('Sub_Type__c', 'Direct');
        fieldValueMap.put('Transaction_Type__c', 'Transactional');
        fieldValueMap.put('Account_Profile__c', 'Fabless - Emerging');
        fieldValueMap.put('Corporate_Postal_Zip_Code__c', '700007');
        fieldValueMap.put('Fab_9_10__c', 'No');
        fieldValueMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER'));       
        AccountDataFactory.createAccount(fieldValueMap);
    }   
    static id createRosCycle(){
        ROS_Cycle__c rosCycle1 = new ROS_Cycle__c();
        rosCycle1.Name = '1H14';
        rosCycle1.Cycle_Start_Date__c = Date.today()-1;
        rosCycle1.Cycle_End_Date__c = Date.today()+5;
        rosCycle1.Next_Cycle_Name__c = '2H14';
        insert rosCycle1;
        return rosCycle1.id;
    }
    
    static Account createAccount(){
        Account testAcct = getAccount('testing901');
        return testAcct;
    }
    
    static testMethod void testPositive(){
        
        List<SObject> lstAccounts = new List<sObject>();
        Account testAcct = createAccount();
        
        contact testCon = new contact();
        testCon.FirstName = 'Test abc';
        testCon.LastName = 'abc';
        testCon.Email = 'abc@gmail.com';
        testCon.AccountId = testAcct.Id;
        insert testCon;
        
        ROS_Disposal_Certificate__c scrapCertificate = new ROS_Disposal_Certificate__c();
        RecordType rt1 = [SELECT Id FROM  RecordType WHERE  SObjectType = 'ROS_Disposal_Certificate__c'  AND Name = 'Active Certificate'];
        scrapCertificate.PDF_Generated__c = true;
        scrapCertificate.Scrap_Date__c =  Datetime.now();
        scrapCertificate.Authorizing_User__c = UserInfo.getUserId();
        scrapCertificate.Account__c = testAcct.Id;       
        scrapCertificate.RecordTypeId = rt1.Id;
        insert scrapCertificate;
        createRosCycle();
        test.startTest();
        ROS_ScrapCertificateView obj = new ROS_ScrapCertificateView();
        obj.rosCycle = 'none';                
        obj.Search();
        test.stopTest();

    }  
    static testMethod void testPositiveRosValue(){
        //loadCustomSettings();
        List<SObject> lstAccounts = new List<sObject>();
        Account testAcct = createAccount();        
        contact testCon = new contact();
        testCon.FirstName = 'Test abc';
        testCon.LastName = 'abc';
        testCon.Email = 'abc@gmail.com';
        testCon.AccountId = testAcct.Id;
        insert testCon;
                
        ROS_Disposal_Certificate__c scrapCertificate = new ROS_Disposal_Certificate__c();
        RecordType rt1 = [SELECT Id FROM  RecordType WHERE  SObjectType = 'ROS_Disposal_Certificate__c'  AND Name = 'Active Certificate'];
        scrapCertificate.PDF_Generated__c = true;
        scrapCertificate.Scrap_Date__c =  Datetime.now();
        scrapCertificate.Authorizing_User__c = UserInfo.getUserId();
        scrapCertificate.Account__c = testAcct.Id;       
        scrapCertificate.RecordTypeId = rt1.Id;
        insert scrapCertificate;
        createRosCycle();
               
        test.startTest();
        ROS_ScrapCertificateView obj = new ROS_ScrapCertificateView();
        obj.rosCycle = '1H14';          
        obj.accountName='testing901';
        //obj.AccountId=testAcct.Id;
        obj.Search();
        test.stopTest();

    }    
    static testMethod void testNagetiveRosValue(){
        //loadCustomSettings();
        List<SObject> lstAccounts = new List<sObject>();
        Account testAcct = createAccount();
        
        contact testCon = new contact();
        testCon.FirstName = 'Test abc';
        testCon.LastName = 'abc';
        testCon.Email = 'abc@gmail.com';
        testCon.AccountId = testAcct.Id;
        insert testCon;
        createRosCycle();        
        
        test.startTest();
        ROS_ScrapCertificateView obj = new ROS_ScrapCertificateView();
        obj.getrosCycles();
//        obj.getQcAccessData();
        obj.ViewRosVF();
        obj.rosCycle = '1H14';      
        obj.Search();
        test.stopTest();
    } 
    static testMethod void testNagetive(){
        //loadCustomSettings();
        List<SObject> lstAccounts = new List<sObject>();
        Account testAcct = createAccount();        
        contact testCon = new contact();
        testCon.FirstName = 'Test abc';
        testCon.LastName = 'abc';
        testCon.Email = 'abc@gmail.com';
        testCon.AccountId = testAcct.Id;
        insert testCon;
        
        test.startTest();
        ROS_ScrapCertificateView obj = new ROS_ScrapCertificateView();
       
        test.stopTest();

    }  
    
    private static Account getAccount(string AccountName)
            {
                Account testAcct= [SELECT Id, Name FROM Account Where Name =: AccountName];
        
                return testAcct;
            } 
}