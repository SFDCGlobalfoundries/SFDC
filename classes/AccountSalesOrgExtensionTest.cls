@isTest
private class AccountSalesOrgExtensionTest {
    @testSetup static void testdata() {
            DataUtilTest.loadEnvironmentVariables();
    }
    static testMethod void DisplayAccountsTest() {
        
        Account acc = new Account();
        acc.Name = 'testing725';
        acc.Short_Name__c = 'test725';
        acc.Site_Department__c = 'cts.com';
        acc.Account_Type__c = 'Customer';
        acc.Organization_Unit__c = 'sg;us';
        acc.New_Organization_Unit_Request__c = 'gf';
        acc.Copy_Address__c = true;
        acc.Corporate_Address_1__c = 'test';
        acc.Corporate_City__c = 'sg';
        acc.Corporate_Country__c = 'sg';
        acc.Financial_Territory__c =  'Greater China';
        acc.Region__c = 'APJ';
        acc.stage__c = 'Unqualified';
        acc.Sub_Type__c = 'Direct';
        acc.Transaction_Type__c = 'Transactional';
        acc.Bill_To_Address_1__c = 'Test';
        acc.Bill_To_Address_2__c = 'Test2';
        acc.Bill_To_City__c = 'Test3';
        acc.Bill_To_Country__c = 'Test4';
        acc.Bill_To_Postal_Zip_Code__c = '12345';
        acc.Bill_To_State__c = 'Test1';
        acc.SAP_Account_Number__c = '123456';
        insert acc;
       
        Sales_Org__c SalesOrg = new Sales_Org__c();
        SalesOrg.Sales_Org_Id__c = '12345';
        insert SalesOrg;
       
        Account_Address__c accAdd = new Account_Address__c();
        accAdd.Account__c = acc.ID;
        accAdd.name = acc.name;
        accAdd.Bill_To_Address_Number__c = '12345';
        accAdd.Is_Primary_Address__c = TRUE;
        accAdd.Type__c ='Bill To Address'; 
        insert accAdd;
        
        Account_Sales_Org__c AccSalesOrg = new Account_Sales_Org__c();
        AccSalesOrg.Account_Name__c = acc.ID;
        AccSalesOrg.Sales_Org__c = SalesOrg.ID;
        Insert AccSalesOrg;
         
        ApexPages.StandardController sc = new ApexPages.StandardController(AccSalesOrg);
        AccountSalesOrgExtension AccSO = new AccountSalesOrgExtension(sc);
        
        PageReference pageRef = Page.AccountSalesOrgPage;
        pageRef.getParameters().put('id', String.valueOf(AccSalesOrg.Id));
        Test.setCurrentPage(pageRef);
        AccSO.DisplayAccounts();
    }
}