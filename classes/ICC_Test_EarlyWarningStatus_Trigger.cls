@isTest
public class ICC_Test_EarlyWarningStatus_Trigger
{
    
    
    public static testmethod void test_trigger()
    {
        try{
           DataUtilTest.loadEnvironmentVariables();             
           Map<String,Object> fieldValueMap = new Map<String,Object>();
            fieldValueMap.put('Name', 'MYTEST ACCOUNT100');  
            fieldValueMap.put('Account_Type__c', 'Customer');                           
            fieldValueMap.put('sub_type__c', 'Indirect');        
            fieldValueMap.put('site_department__c', 'IT');  
            fieldValueMap.put('Account_Manager__c', userinfo.getuserid());        
            fieldValueMap.put('transaction_type__c', 'Non-Transactional');                          
            fieldValueMap.put('region__c', 'US');        
            fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
            fieldValueMap.put('Corporate_City__c', 'Test City');                
            fieldValueMap.put('Corporate_Country__c', 'Singapore');
            fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
            fieldValueMap.put('Bill_To_City__c', 'Test City');            
            fieldValueMap.put('Bill_To_Country__c', 'Singapore');        
            fieldValueMap.put('Fab_9_10__c','No');
            
            AccountDataFactory.createAccount(fieldValueMap);
            
            
             Account accntObj = getAccount('MYTEST ACCOUNT100'); 
             
            Sales_Order_Line__c testSOL = new Sales_Order_Line__c(Account__c = accntObj.id);
            insert testSOL;
            
            Sales_Order_Schedule__c testSOS = new Sales_Order_Schedule__c(Sales_Order_Line__c = testSOL.id);
            insert testSOS;
            
            Early_Warning_Status__c ew = new Early_Warning_Status__c(AVAIL_DATE__c = date.today(), Version_Id__c = 1, Available_Quantity__c = 23);
            insert ew;
            ApexPages.StandardController sc = new ApexPages.StandardController(testSOS);
                        
            ICC_EarlyWarning_CustomRelatedList test_ICC_EarlyWarning_CustomRelatedList = new ICC_EarlyWarning_CustomRelatedList(sc);
            
          }
          catch(Exception e)
          {
              ApplicationLogWrapper alw = new ApplicationLogWrapper();
            alw.source = ICC_Test_EarlyWarningStatus_Trigger.class.getName();
            alw.sourceFunction ='test_Trigger()';
            alw.ApplicationName='ICC';
            alw.referenceInfo = 'Bug';
            alw.logMessage = 'Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
            alw.debugLevel = 'Error';
            alw.logCode = e.getTypeName();
            alw.ex = e.getCause();
            GlobalUtility.logMessage(alw);
          }
    }
    
     private static Account getAccount(string AccountName){
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
}