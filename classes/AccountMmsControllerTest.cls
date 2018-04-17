//Ashwini     04162015    - Updated code for making SeeAllData=false and refactoring of test class.

@isTest(seealldata=false)
public class AccountMmsControllerTest{
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        List<Account_MMS_Setting__c> accMMSsettingList = new List<Account_MMS_Setting__c>(); 
        Account_MMS_Setting__c accMMSsetting1 = new Account_MMS_Setting__c (name='Actual',Seq__c=1,Active__c=true,Readonly__c=true,Field_Set_API__c='Actual');
        Account_MMS_Setting__c accMMSsetting2 = new Account_MMS_Setting__c (name='Cust SAM',Seq__c=2,Active__c=true,Readonly__c=false,Field_Set_API__c='Cust_SAM');
        accMMSsettingList.add(accMMSsetting1);
        accMMSsettingList.add(accMMSsetting2);
        insert accMMSsettingList;    
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();            
        fieldValueMap.put('Name', 'TestAccount20150116');            
        fieldValueMap.put('stage__c', 'Unqualified');
        fieldValueMap.put('short_name__c', 'TA20150116');
        fieldValueMap.put('sub_type__c', 'Indirect');
        fieldValueMap.put('site_department__c', 'IT');          
        fieldValueMap.put('transaction_type__c', 'Non-Transactional');
        fieldValueMap.put('account_profile__c', 'Fabless - Emerging');            
        fieldValueMap.put('Process_Tech_Interested__c', 'Mature (> 0.11um)');
        fieldValueMap.put('region__c', 'US');
        fieldValueMap.put('Sales_Territory__c', 'Japan Korea');
        fieldValueMap.put('financial_territory__c', 'Japan Korea');          
        fieldValueMap.put('Copy_Address__c', true);
        fieldValueMap.put('Corporate_Address_1__c', 'Lee');            
        fieldValueMap.put('Corporate_Country__c', 'Japan');
        fieldValueMap.put('Organization_Unit__c', 'GF Investment LLC OU');
        fieldValueMap.put('bill_to_location__c', 'YES');
        fieldValueMap.put('total_employee__c', 100);          
        fieldValueMap.put('end_customer__c', 'people');
        fieldValueMap.put('Revenue_Potential__c', 'High Potential');            
        fieldValueMap.put('Target_Account__c', 'Yes');
        fieldValueMap.put('Fab_9_10__c','No');
        fieldValueMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER'));
        AccountDataFactory.createAccount(fieldValueMap);                    
    }
    public static testMethod void testController() {
        Account acct = getAccount('TestAccount20150116');
        Account_MMS__c acctMMS = createAccountMMS(acct.Id );
        Test.startTest();
        PageReference pageRef = new PageReference('/'+acct.Id);
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController acctStdCtrl = new ApexPages.StandardController(acctMMS);
        AccountMmsController ctrlex = new AccountMmsController(acctStdCtrl );
        
        Account acc = ctrlex.getAccountInfo();
        ctrlex.acctId = acc.Id;
        ctrlex.newMMS();
        ctrlex .save();         
        ctrlex.cancel();
        Test.stopTest();
        
    }
    
    public static Account_MMS__c createAccountMMS(id accountId){
    
        Account_MMS__c acctMMS = new Account_MMS__c (name = 'testAcctMMS',account__c = accountId);
        insert acctMMS ;
        return acctMMS ;
    }
    
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id FROM Account Where Name =: AccountName];
        
        return acct;
    }
}