@isTest
public class ICC_Test_ClsSplitSalesOrderSchedule
{
    
    
    private static testmethod void test()
    {
        try{
            DataUtilTest.loadEnvironmentVariables();
            
           Map<String,Object> fieldValueMap = new Map<String,Object>();
            fieldValueMap.put('Name', 'MYTEST ACCOUNT1');  
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
            
            
             Account accntObj = getAccount('MYTEST ACCOUNT1'); 
             
            Sales_Order_Line__c testSOL = new Sales_Order_Line__c(Account__c = accntObj.id);
            insert testSOL;
            
            Sales_Order_Schedule__c testSOS = new Sales_Order_Schedule__c(Sales_Order_Line__c = testSOL.id, Cum_Cf_Qty__c = 8);
            insert testSOS;
            
            
            
            ApexPages.currentPage().getParameters().put('id', testSOS.id);
            
            Early_Warning_REASON_CODES__c testRec = new Early_Warning_REASON_CODES__c(Name = 'test', EXT_REASON__c = 'test', INT_REASON__c = 'test');
            insert testRec;
            
            Early_Warning_Status__c ewsRec = new Early_Warning_Status__c(Sales_Order1__c = testSOS.id, Version_Id__c = 1, AVAIL_DATE__c = date.today(), Available_Quantity__c = 4, EWS_FLAG__c='O'); 
            insert ewsRec;
            
            ApexPages.StandardController sc = new ApexPages.StandardController(testSOS);
            ICC_EarlyWarning_CustomRelatedList test_RelList = new ICC_EarlyWarning_CustomRelatedList(sc);
            
            
            ClsSplitSalesOrderSchedule test = new ClsSplitSalesOrderSchedule();
            test.getInternalComments();
            system.currentpagereference().getparameters().put('index', '0');
            test.findExternalReasonCode();
            
            test.cancel();
            test.AddRow();
            for(Early_Warning_Status__c ews : test.Earlywarninglist)
            {
                ews.AVAIL_DATE__c = date.today();
                ews.Available_Quantity__c = 4;
                ews.EWS_FLAG__c='O';
            }
            test.save();
            for(Early_Warning_Status__c ews : test.Earlywarninglist)
            {
                ews.AVAIL_DATE__c = date.today();
                ews.Available_Quantity__c = 4;
                ews.EWS_FLAG__c='L';
            }
            test.save();
            system.currentpagereference().getparameters().put('index', '0');
            test.delRow();
            test.Save();
        }
        catch(Exception e)
        {
            ApplicationLogWrapper alw = new ApplicationLogWrapper();
            alw.source = ICC_Test_ClsSplitSalesOrderSchedule.class.getName();
            alw.sourceFunction ='test()';
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