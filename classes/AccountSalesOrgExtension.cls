/*
  ********************************************************************************************
  * @Author        :     Mallika Seth
  * @Date          :     02/01/2017
  * @Description   :     This extension class is used in Visualforce Page to fecth details for account sales org object automatically
  ********************************************************************************************
*/

public class AccountSalesOrgExtension
{
    public boolean showAccount {get; set;}
    Public ID AccSalesOrgID{get;set;}
    public Account_Sales_Org__c AccSalesOrg;
    public AccountSalesOrgExtension()
    {
        showAccount = false ;
    }
    public AccountSalesOrgExtension(ApexPages.StandardController controller) {
        AccSalesOrgID = controller.getRecord().Id; 
        this.AccSalesOrg = (Account_Sales_Org__c)Controller.getRecord();
    }
    public PageReference DisplayAccounts()
    {
       
        showAccount = true ;
        List < Id > newOrUpdatedAccSalesOrg = new List < Id > ();
         List < Id > newOrUpdatedSalesOrg = new List < Id > ();
        List <account> acclist = new List <account> ();
        List <Sales_Org__c> SalesOrglist = new List <Sales_Org__c> ();
        List <Account_Address__c> accAddlist = new List <Account_Address__c> ();
        List <Account_Sales_Org__c> AccountSalesOrgToBeUpdated = new List <Account_Sales_Org__c>();
        
        //for (Account_Sales_Org__c c: [Select ID,Account_Name__c,Bill_To_Address_1__c,Bill_To_Address_2__c  from Account_Sales_Org__c where ID =: AccSalesOrgID]) {
           If(AccSalesOrg.Account_Name__c != Null){
               newOrUpdatedAccSalesOrg.add(AccSalesOrg.Account_Name__c);
           }
           If(AccSalesOrg.Sales_Org__c!= Null){
               newOrUpdatedSalesOrg.add(AccSalesOrg.Sales_Org__c);
           }
           AccountSalesOrgToBeUpdated.add(AccSalesOrg);
        

        acclist = [Select Bill_To_Address_1__c,Bill_To_Address_2__c,Bill_To_City__c,Bill_To_Country__c,Bill_To_State__c,Bill_To_Postal_Zip_Code__c,SAP_Account_Number__c from Account where Id in : newOrUpdatedAccSalesOrg];
        accAddlist = [Select Account__c,Bill_To_Address_Number__c From Account_Address__c where Account__c in :newOrUpdatedAccSalesOrg AND Is_Primary_Address__c = TRUE AND Type__c ='Bill To Address' ];
        SalesOrglist = [Select ID,Sales_Org_Id__c from Sales_Org__c where Id in : newOrUpdatedSalesOrg];
        

        for (Account_Sales_Org__c ASOTU : AccountSalesOrgToBeUpdated) {
            ASOTU.Bill_To_Address_1__c = acclist[0].Bill_To_Address_1__c;
            ASOTU.Bill_To_Address_2__c = acclist[0].Bill_To_Address_2__c;
            ASOTU.Bill_To_City__c= acclist[0].Bill_To_City__c;
            ASOTU.Bill_To_Country__c= acclist[0].Bill_To_Country__c;
            ASOTU.Bill_To_Postal_Zip_Code__c= acclist[0].Bill_To_Postal_Zip_Code__c;
            ASOTU.Bill_To_State__c= acclist[0].Bill_To_State__c;
            ASOTU.SAP_Customer_Number__c = acclist[0].SAP_Account_Number__c;
            ASOTU.SAP_Billto_Number__c = accAddlist[0].Bill_To_Address_Number__c;
            ASOTU.External_Id__c =  ASOTU.SAP_Customer_Number__c + '-' +  ASOTU.SAP_Billto_Number__c  + '-' +    SalesOrglist[0].Sales_Org_Id__c;
            ASOTU.Sold_To_Sales_Org_ID__c  = ASOTU.SAP_Customer_Number__c + '-' + SalesOrglist[0].Sales_Org_Id__c;
        } 
        return null ;
    }
   
}