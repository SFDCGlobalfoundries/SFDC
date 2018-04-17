trigger AccountSalesOrgTrigger on Account_Sales_Org__c (Before Insert, Before update) {  
  if(!AccountSalesOrgUserUtil.isSkipTrigger()){
    List < Id > newOrUpdatedAccSalesOrg = new List < Id > ();
    List < Id > newOrUpdatedSalesOrg = new List < Id > ();
    List <account> acclist = new List <account> ();
    List <Account_Address__c> accAddlist = new List <Account_Address__c> ();
    List <Sales_Org__c> SalesOrglist = new List <Sales_Org__c> ();
    list <Account_Sales_Org__c> AccountSalesOrgToBeUpdated = new List <Account_Sales_Org__c>();

    for (Account_Sales_Org__c c: trigger.new) {
        newOrUpdatedAccSalesOrg.add(c.Account_Name__c);
        newOrUpdatedSalesOrg.add(c.Sales_Org__c);
        AccountSalesOrgToBeUpdated.add(c);
    }

    acclist = [Select Bill_To_Address_1__c,Bill_To_Address_2__c,Bill_To_City__c,Bill_To_Country__c,Bill_To_State__c,Bill_To_Postal_Zip_Code__c,SAP_Account_Number__c from Account where Id in : newOrUpdatedAccSalesOrg];
    accAddlist = [Select Account__c,Bill_To_Address_Number__c From Account_Address__c where Account__c in :newOrUpdatedAccSalesOrg AND Is_Primary_Address__c = TRUE AND Type__c ='Bill To Address' ];
    SalesOrglist = [Select ID,Sales_Org_Id__c from Sales_Org__c where Id in : newOrUpdatedSalesOrg];
    

    for (Account_Sales_Org__c ASOTU : AccountSalesOrgToBeUpdated) {
        if(acclist!= Null){
            ASOTU.Bill_To_Address_1__c = acclist[0].Bill_To_Address_1__c;
            ASOTU.Bill_To_Address_2__c= acclist[0].Bill_To_Address_2__c;
            ASOTU.Bill_To_City__c= acclist[0].Bill_To_City__c;
            ASOTU.Bill_To_Country__c= acclist[0].Bill_To_Country__c;
            ASOTU.Bill_To_Postal_Zip_Code__c= acclist[0].Bill_To_Postal_Zip_Code__c;
            ASOTU.Bill_To_State__c= acclist[0].Bill_To_State__c;
            ASOTU.SAP_Customer_Number__c = acclist[0].SAP_Account_Number__c;
        }
         if(accAddlist!= Null){
                ASOTU.SAP_Billto_Number__c = accAddlist[0].Bill_To_Address_Number__c;
         }
            
         if(SalesOrglist[0].Sales_Org_Id__c!= Null && ASOTU.SAP_Customer_Number__c!=Null && ASOTU.SAP_Billto_Number__c!= Null){
                ASOTU.External_Id__c =  ASOTU.SAP_Customer_Number__c + '-' +  ASOTU.SAP_Billto_Number__c  + '-' +    SalesOrglist[0].Sales_Org_Id__c;
                ASOTU.Sold_To_Sales_Org_ID__c  = ASOTU.SAP_Customer_Number__c + '-' + SalesOrglist[0].Sales_Org_Id__c;
         }
    }
  }
}